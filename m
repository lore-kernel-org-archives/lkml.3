Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaFXOlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:41:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55106 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaFXOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:22 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH v6 5/6] KEYS: validate certificate trust only with builtin keys
Date: Tue, 24 Jun 2014 10:40:51 -0400
Message-Id: <1403620852-16476-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-9332-0000-0000-0000012EE6AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted keyring,
this patch further restricts the certificates to those signed only by
builtin keys on the system keyring.

This patch defines a new option 'builtin' for the kernel parameter
'keys_ownerid' to allow trust validation using builtin keys.

Simplified Mimi's "KEYS: define an owner trusted keyring" patch

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt      | 2 +-
 crypto/asymmetric_keys/x509_public_key.c | 8 +++++---
 include/linux/key.h                      | 1 +
 kernel/system_keyring.c                  | 1 +
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b0cc47d..a0c155c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1495,7 +1495,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	keys_ownerid=[KEYS] This parameter identifies a specific key(s) on
 			the system trusted keyring to be used for certificate
 			trust validation.
-			format: id:<keyid>
+			format: { id:<keyid> | builtin }
 
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 44850f2..541329d 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,6 +24,7 @@
 #include "public_key.h"
 #include "x509_parser.h"
 
+static bool builtin_keys;
 static char *owner_keyid;
 
 #ifndef MODULE
@@ -34,6 +35,8 @@ static int __init default_owner_keyid_set(char *str)
 
 	if (strncmp(str, "id:", 3) == 0)
 		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
+	else if (strcmp(str, "builtin") == 0)
+		builtin_keys = true;
 
 	return 1;
 }
@@ -180,7 +183,6 @@ EXPORT_SYMBOL_GPL(x509_check_signature);
 static int x509_validate_trust(struct x509_certificate *cert,
 			       struct key *trust_keyring)
 {
-	const struct public_key *pk;
 	struct key *key;
 	int ret = 1;
 
@@ -196,8 +198,8 @@ static int x509_validate_trust(struct x509_certificate *cert,
 					  cert->authority,
 					  strlen(cert->authority));
 	if (!IS_ERR(key))  {
-		pk = key->payload.data;
-		ret = x509_check_signature(pk, cert);
+		if (!builtin_keys || test_bit(KEY_FLAG_BUILTIN, &key->flags))
+			ret = x509_check_signature(key->payload.data, cert);
 		key_put(key);
 	}
 	return ret;
diff --git a/include/linux/key.h b/include/linux/key.h
index 017b082..65316f7 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -170,6 +170,7 @@ struct key {
 #define KEY_FLAG_INVALIDATED	7	/* set if key has been invalidated */
 #define KEY_FLAG_TRUSTED	8	/* set if key is trusted */
 #define KEY_FLAG_TRUSTED_ONLY	9	/* set if keyring only accepts links to trusted keys */
+#define KEY_FLAG_BUILTIN	10	/* set if key is builtin */
 
 	/* the key type and key description string
 	 * - the desc is used to match a key against search criteria
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 52ebc70..875f64e 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -89,6 +89,7 @@ static __init int load_system_certificate_list(void)
 			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
 			       PTR_ERR(key));
 		} else {
+			set_bit(KEY_FLAG_BUILTIN, &key_ref_to_ptr(key)->flags);
 			pr_notice("Loaded X.509 cert '%s'\n",
 				  key_ref_to_ptr(key)->description);
 			key_ref_put(key);
-- 
1.8.1.4

