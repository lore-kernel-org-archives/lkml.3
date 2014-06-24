Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaFXOlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:41:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49072 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaFXOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:14 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH v6 2/6] KEYS: verify a certificate is signed by a 'trusted' key
Date: Tue, 24 Jun 2014 10:40:48 -0400
Message-Id: <1403620852-16476-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-0928-0000-0000-000002EC22FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only public keys, with certificates signed by an existing
'trusted' key on the system trusted keyring, should be added
to a trusted keyring.  This patch adds support for verifying
a certificate's signature.

This is derived from David Howells pkcs7_request_asymmetric_key() patch.

Changelog v6:
- on error free key - Dmitry
- validate trust only for not already trusted keys - Dmitry
- formatting cleanup

Changelog:
- define get_system_trusted_keyring() to fix kbuild issues

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 87 +++++++++++++++++++++++++++++++-
 include/keys/system_keyring.h            | 10 +++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 382ef0d..436fbd8 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -18,12 +18,62 @@
 #include <linux/asn1_decoder.h>
 #include <keys/asymmetric-subtype.h>
 #include <keys/asymmetric-parser.h>
+#include <keys/system_keyring.h>
 #include <crypto/hash.h>
 #include "asymmetric_keys.h"
 #include "public_key.h"
 #include "x509_parser.h"
 
 /*
+ * Find a key in the given keyring by issuer and authority.
+ */
+static struct key *x509_request_asymmetric_key(struct key *keyring,
+					       const char *signer,
+					       size_t signer_len,
+					       const char *authority,
+					       size_t auth_len)
+{
+	key_ref_t key;
+	char *id;
+
+	/* Construct an identifier. */
+	id = kmalloc(signer_len + 2 + auth_len + 1, GFP_KERNEL);
+	if (!id)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(id, signer, signer_len);
+	id[signer_len + 0] = ':';
+	id[signer_len + 1] = ' ';
+	memcpy(id + signer_len + 2, authority, auth_len);
+	id[signer_len + 2 + auth_len] = 0;
+
+	pr_debug("Look up: \"%s\"\n", id);
+
+	key = keyring_search(make_key_ref(keyring, 1),
+			     &key_type_asymmetric, id);
+	if (IS_ERR(key))
+		pr_debug("Request for module key '%s' err %ld\n",
+			 id, PTR_ERR(key));
+	kfree(id);
+
+	if (IS_ERR(key)) {
+		switch (PTR_ERR(key)) {
+			/* Hide some search errors */
+		case -EACCES:
+		case -ENOTDIR:
+		case -EAGAIN:
+			return ERR_PTR(-ENOKEY);
+		default:
+			return ERR_CAST(key);
+		}
+	}
+
+	pr_devel("<==%s() = 0 [%x]\n", __func__,
+		 key_serial(key_ref_to_ptr(key)));
+	return key_ref_to_ptr(key);
+}
+
+/*
  * Set up the signature parameters in an X.509 certificate.  This involves
  * digesting the signed data and extracting the signature.
  */
@@ -103,6 +153,37 @@ int x509_check_signature(const struct public_key *pub,
 EXPORT_SYMBOL_GPL(x509_check_signature);
 
 /*
+ * Check the new certificate against the ones in the trust keyring.  If one of
+ * those is the signing key and validates the new certificate, then mark the
+ * new certificate as being trusted.
+ *
+ * Return 0 if the new certificate was successfully validated, 1 if we couldn't
+ * find a matching parent certificate in the trusted list and an error if there
+ * is a matching certificate but the signature check fails.
+ */
+static int x509_validate_trust(struct x509_certificate *cert,
+			       struct key *trust_keyring)
+{
+	const struct public_key *pk;
+	struct key *key;
+	int ret = 1;
+
+	if (!trust_keyring)
+		return -EOPNOTSUPP;
+
+	key = x509_request_asymmetric_key(trust_keyring,
+					  cert->issuer, strlen(cert->issuer),
+					  cert->authority,
+					  strlen(cert->authority));
+	if (!IS_ERR(key))  {
+		pk = key->payload.data;
+		ret = x509_check_signature(pk, cert);
+		key_put(key);
+	}
+	return ret;
+}
+
+/*
  * Attempt to parse a data blob for a key as an X509 certificate.
  */
 static int x509_key_preparse(struct key_preparsed_payload *prep)
@@ -155,9 +236,13 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	/* Check the signature on the key if it appears to be self-signed */
 	if (!cert->authority ||
 	    strcmp(cert->fingerprint, cert->authority) == 0) {
-		ret = x509_check_signature(cert->pub, cert);
+		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
+	} else if (!prep->trusted) {
+		ret = x509_validate_trust(cert, get_system_trusted_keyring());
+		if (!ret)
+			prep->trusted = 1;
 	}
 
 	/* Propose a description */
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 8dabc39..72665eb 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -17,7 +17,15 @@
 #include <linux/key.h>
 
 extern struct key *system_trusted_keyring;
-
+static inline struct key *get_system_trusted_keyring(void)
+{
+	return system_trusted_keyring;
+}
+#else
+static inline struct key *get_system_trusted_keyring(void)
+{
+	return NULL;
+}
 #endif
 
 #endif /* _KEYS_SYSTEM_KEYRING_H */
-- 
1.8.1.4

