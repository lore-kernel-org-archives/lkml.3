Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbaDWN7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:59:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaDWN3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:47 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-41-5357c04865e9
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 01/20] KEYS: verify a certificate is signed by a 'trusted' key
Date: Wed, 23 Apr 2014 16:30:19 +0300
Message-id: <0f7915604c69374f15cbaf36c499a5d88264e89d.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7oeB8KDDbYfVbG49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mq4PeUjU8ERhYpXHfdYGxjXSXUxcnJICJhInJrfxgxhi0lc
	uLeerYuRi0NIYCmjxKt7a5ghnE4miW0bJ7CCVLEJ6ElsaP7BDmKLCLhI7J7TxwRSxCzQwyix
	+89ioA4ODmEBP4mzr/hBalgEVCV6lq0Dq+cViJPY3/+MEWKbgsSyL2vBNnMKWEn8aZ4OViMk
	YCnxfdJknOITGPkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJxi87GBcfszrEKMDB
	qMTDK7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZODilGhj77ZMP
	Wp2tu8Q57chD/+/LLil5W8sYi5/3e92wx1c+UVqqKS1o9Udn9RW7r078IRR8dte/aR6MIg+r
	Rf2F11RpbHD6q87opST87jQLM8ubOT0VF78tCf1X/HLmw637rLZM7ZQ4uMSprrYs4ynbaQZD
	tWXP1rUs3nRAY1/VTFkr75fhDIy/jksrsRRnJBpqMRcVJwIAIJm1VCQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Only public keys, with certificates signed by an existing
'trusted' key on the system trusted keyring, should be added
to a trusted keyring.  This patch adds support for verifying
a certificate's signature.

This is derived from David Howells pkcs7_request_asymmetric_key() patch.

Changes:
- Flaged out the code to prevent build break if system keyring
  is not enabled (Dmitry).

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 85 +++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 382ef0d..d279f43 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -18,6 +18,7 @@
 #include <linux/asn1_decoder.h>
 #include <keys/asymmetric-subtype.h>
 #include <keys/asymmetric-parser.h>
+#include <keys/system_keyring.h>
 #include <crypto/hash.h>
 #include "asymmetric_keys.h"
 #include "public_key.h"
@@ -102,6 +103,82 @@ int x509_check_signature(const struct public_key *pub,
 }
 EXPORT_SYMBOL_GPL(x509_check_signature);
 
+#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
+/*
+ * Find a key in the given keyring by issuer and authority.
+ */
+static struct key *x509_request_asymmetric_key(
+	struct key *keyring,
+	const char *signer, size_t signer_len,
+	const char *authority, size_t auth_len)
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
+	pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key_ref_to_ptr(key)));
+	return key_ref_to_ptr(key);
+}
+
+/*
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
+	key = x509_request_asymmetric_key(trust_keyring,
+					  cert->issuer, strlen(cert->issuer),
+					  cert->authority,
+					  strlen(cert->authority));
+	if (!IS_ERR(key))  {
+		pk = key->payload.data;
+		ret = x509_check_signature(pk, cert);
+	}
+	return ret;
+}
+#endif
+
 /*
  * Attempt to parse a data blob for a key as an X509 certificate.
  */
@@ -155,9 +232,15 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	/* Check the signature on the key if it appears to be self-signed */
 	if (!cert->authority ||
 	    strcmp(cert->fingerprint, cert->authority) == 0) {
-		ret = x509_check_signature(cert->pub, cert);
+		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
+	} else {
+#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
+		ret = x509_validate_trust(cert, system_trusted_keyring);
+		if (!ret)
+			prep->trusted = 1;
+#endif
 	}
 
 	/* Propose a description */
-- 
1.8.3.2

