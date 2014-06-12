Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaFLUR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:17:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42156 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaFLURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:17:42 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1a 2/2] KEYS: validate certificate trust only with builtin keys
Date: Thu, 12 Jun 2014 23:17:11 +0300
Message-Id: <4cf4c2546fd7c279338da9751286a034b1863cfd.1402604096.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1402604096.git.d.kasatkin@samsung.com>
References: <cover.1402604096.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1402604096.git.d.kasatkin@samsung.com>
References: <cover.1402604096.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted keyring,
this patch further restricts the certificates to those signed only by
builtin keys on the system keyring.

This patch defines a new option 'builtin' for the kernel parameter
'keys_ownerid' to allow trust validation using builtin keys.

Idea belongs to Mimi Zohar.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 Documentation/kernel-parameters.txt      | 2 +-
 crypto/asymmetric_keys/x509_public_key.c | 9 +++++++--
 include/linux/key.h                      | 1 +
 kernel/system_keyring.c                  | 1 +
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7a810d3..336dabe 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1437,7 +1437,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	keys_ownerid=[KEYS] This parameter identifies a specific key(s) on
 			the system trusted keyring to be used for certificate
 			trust validation.
-			format: id:<keyid>
+			format: { id:<keyid> | builtin }
 
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index d46b790..c3805a8 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,6 +24,7 @@
 #include "public_key.h"
 #include "x509_parser.h"
 
+static bool builtin_keys;
 static char *owner_keyid;
 static int __init default_owner_keyid_set(char *str)
 {
@@ -32,6 +33,8 @@ static int __init default_owner_keyid_set(char *str)
 
 	if (strncmp(str, "id:", 3) == 0)
 		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
+	else if (strcmp(str, "builtin") == 0)
+		builtin_keys = true;
 
 	return 1;
 }
@@ -197,8 +200,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 					  cert->authority,
 					  strlen(cert->authority));
 	if (!IS_ERR(key))  {
-		pk = key->payload.data;
-		ret = x509_check_signature(pk, cert);
+		if (!builtin_keys || test_bit(KEY_FLAG_BUILTIN, &key->flags)) {
+			pk = key->payload.data;
+			ret = x509_check_signature(pk, cert);
+		}
 		key_put(key);
 	}
 	return ret;
diff --git a/include/linux/key.h b/include/linux/key.h
index cd0abb8..67c8e7e 100644
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
1.9.1

