Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaFJIs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:48:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19416 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaFJIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:48:56 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4b-5396c67212df
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 4/4] KEYS: validate key trust only with builtin keys
Date: Tue, 10 Jun 2014 11:48:18 +0300
Message-id: <46a150454d7d8e1dd22863c4993566e482961dbf.1402387862.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1402387862.git.d.kasatkin@samsung.com>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1402387862.git.d.kasatkin@samsung.com>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7pFx6YFG7xZrmFx6+9eZot3Tb9Z
	LL4srbM48O4Ji8XsXQ9ZLC7vmsNm8aHnEZvFpxWTmB04PHbOusvuMe3EMhaPB4c2s3i833eV
	zaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyZj66wljQJVJxe/1ppgbGOQJdjJwcEgImEjuX
	HGCDsMUkLtxbD2RzcQgJLGWUeHx8JiOE08kkMWN2AxNIFZuAnsSG5h/sIAkRgTZGibatz8Da
	mQXSJT5N6mUHsYUFXCRenG4Hs1kEVCVerjkOVsMrECex8sxkVoh1chInj4HYHBycAlYSHxaF
	goSFBMokTn7+gClsKdH/eirbBEb+BYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCwvLL
	DsbFx6wOMQpwMCrx8HLoTAsWYk0sK67MPcQowcGsJMJ7dxtQiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA2Pi2Z6Q85w1MzO+dunsOD9Pf2n/rYXhqq/sb8+sSOA9s0CokvtJ3N8vpqvPXw0Pu6/4
	7NT/F1wOl17c+qa04v/qV60P/nel/Nsi8vdMnxOPwd4zVnHPlx8R9z18KZLl0YI1d/dcO/9o
	15LS/ha2o7wCkWLZzzawmF46+fxayZxGsbKk9aHuez4yKLEUZyQaajEXFScCAEkoxewpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to specify kernel parameter 'keys_ownerid=builtin'
to allow trust validation only using builtin keys.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 9 +++++++--
 include/linux/key.h                      | 1 +
 kernel/system_keyring.c                  | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

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

