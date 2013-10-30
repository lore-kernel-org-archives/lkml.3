Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3J3SzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:55:03 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45403 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3J3SzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:55:01 -0400
Message-ID: <1383159291.5434.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: [PATCH] ima: define '_ima' as a builtin 'trusted' keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 30 Oct 2013 14:54:51 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103018-0928-0000-0000-000003158ECC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require all keys added to the IMA keyring be signed by an
existing trusted key on the system trusted keyring.

Changelog:
- define stub integrity_init_keyring() function (reported-by Fengguang Wu)
- differentiate between regular and trusted keyring names.
- replace printk with pr_info (D. Kasatkin)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/digsig.c           | 30 +++++++++++++++++++++++++++++-
 security/integrity/ima/Kconfig        |  8 ++++++++
 security/integrity/ima/ima_appraise.c | 11 +++++++++++
 security/integrity/integrity.h        |  7 +++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index b4af4eb..77ca965 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -13,7 +13,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <linux/rbtree.h>
+#include <linux/cred.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
 
@@ -21,11 +23,19 @@
 
 static struct key *keyring[INTEGRITY_KEYRING_MAX];
 
+#ifdef CONFIG_IMA_TRUSTED_KEYRING
+static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
+	".evm",
+	".module",
+	".ima",
+};
+#else
 static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 	"_evm",
 	"_module",
 	"_ima",
 };
+#endif
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen)
@@ -35,7 +45,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 	if (!keyring[id]) {
 		keyring[id] =
-			request_key(&key_type_keyring, keyring_name[id], NULL);
+		    request_key(&key_type_keyring, keyring_name[id], NULL);
 		if (IS_ERR(keyring[id])) {
 			int err = PTR_ERR(keyring[id]);
 			pr_err("no %s keyring: %d\n", keyring_name[id], err);
@@ -56,3 +66,21 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 	return -EOPNOTSUPP;
 }
+
+int integrity_init_keyring(const unsigned int id)
+{
+	const struct cred *cred = current_cred();
+	const struct user_struct *user = cred->user;
+
+	keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
+				    KGIDT_INIT(0), cred,
+				    ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				     KEY_USR_VIEW | KEY_USR_READ),
+				    KEY_ALLOC_NOT_IN_QUOTA, user->uid_keyring);
+	if (!IS_ERR(keyring[id]))
+		set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
+	else
+		pr_info("Can't allocate %s keyring (%ld)\n",
+			keyring_name[id], PTR_ERR(keyring[id]));
+	return 0;
+}
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 81a2797..dad8d4c 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -123,3 +123,11 @@ config IMA_APPRAISE
 	  For more information on integrity appraisal refer to:
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
+
+config IMA_TRUSTED_KEYRING
+	bool "Require all keys on the _ima keyring be signed"
+	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
+	default y
+	help
+	   This option requires that all keys added to the _ima
+	   keyring be signed by a key on the system trusted keyring.
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 734e946..46353ee 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -381,3 +381,14 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 	}
 	return result;
 }
+
+#ifdef CONFIG_IMA_TRUSTED_KEYRING
+static int __init init_ima_keyring(void)
+{
+	int ret;
+
+	ret = integrity_init_keyring(INTEGRITY_KEYRING_IMA);
+	return 0;
+}
+late_initcall(init_ima_keyring);
+#endif
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 2fb5e53..b9e7c13 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -137,12 +137,19 @@ static inline int integrity_digsig_verify(const unsigned int id,
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int asymmetric_verify(struct key *keyring, const char *sig,
 		      int siglen, const char *data, int datalen);
+
+int integrity_init_keyring(const unsigned int id);
 #else
 static inline int asymmetric_verify(struct key *keyring, const char *sig,
 				    int siglen, const char *data, int datalen)
 {
 	return -EOPNOTSUPP;
 }
+
+static int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_INTEGRITY_AUDIT
-- 
1.8.1.4



