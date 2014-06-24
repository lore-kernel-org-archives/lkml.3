Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaFXOl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:41:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35170 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaFXOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:23 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v6 6/6] ima: define '.ima' as a builtin 'trusted' keyring
Date: Tue, 24 Jun 2014 10:40:52 -0400
Message-Id: <1403620852-16476-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-1344-0000-0000-00000264ACCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require all keys added to the IMA keyring be signed by an
existing trusted key on the system trusted keyring.

Changelog v6:
- remove ifdef CONFIG_IMA_TRUSTED_KEYRING in C code - Dmitry
- update Kconfig dependency and help
- select KEYS_DEBUG_PROC_KEYS - Dmitry

Changelog v5:
- Move integrity_init_keyring() to init_ima() - Dmitry
- reset keyring[id] on failure - Dmitry

Changelog v1:
- don't link IMA trusted keyring to user keyring

Changelog:
- define stub integrity_init_keyring() function (reported-by Fengguang Wu)
- differentiate between regular and trusted keyring names.
- replace printk with pr_info (D. Kasatkin)
- only make the IMA keyring a trusted keyring (reported-by D. Kastatkin)
- define stub integrity_init_keyring() definition based on
  CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.
  (reported-by Jim Davis)

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/digsig.c       | 28 ++++++++++++++++++++++++++++
 security/integrity/ima/Kconfig    | 10 ++++++++++
 security/integrity/ima/ima.h      | 12 ++++++++++++
 security/integrity/ima/ima_main.c | 10 ++++++++--
 security/integrity/integrity.h    |  5 +++++
 5 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index b4af4eb..8d4fbff 100644
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
 
@@ -24,7 +26,11 @@ static struct key *keyring[INTEGRITY_KEYRING_MAX];
 static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
 	"_evm",
 	"_module",
+#ifndef CONFIG_IMA_TRUSTED_KEYRING
 	"_ima",
+#else
+	".ima",
+#endif
 };
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
@@ -56,3 +62,25 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 	return -EOPNOTSUPP;
 }
+
+int integrity_init_keyring(const unsigned int id)
+{
+	const struct cred *cred = current_cred();
+	int err = 0;
+
+	keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
+				    KGIDT_INIT(0), cred,
+				    ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				     KEY_USR_VIEW | KEY_USR_READ |
+				     KEY_USR_WRITE | KEY_USR_SEARCH),
+				    KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (!IS_ERR(keyring[id]))
+		set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
+	else {
+		err = PTR_ERR(keyring[id]);
+		pr_info("Can't allocate %s keyring (%d)\n",
+			keyring_name[id], err);
+		keyring[id] = NULL;
+	}
+	return err;
+}
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 81a2797..08758fb 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -123,3 +123,13 @@ config IMA_APPRAISE
 	  For more information on integrity appraisal refer to:
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
+
+config IMA_TRUSTED_KEYRING
+	bool "Require all keys on the .ima keyring be signed"
+	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	select KEYS_DEBUG_PROC_KEYS
+	default y
+	help
+	   This option requires that all keys added to the .ima
+	   keyring be signed by a key on the system trusted keyring.
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f79fa8b..c42056e 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -249,4 +249,16 @@ static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 	return -EINVAL;
 }
 #endif /* CONFIG_IMA_LSM_RULES */
+
+#ifdef CONFIG_IMA_TRUSTED_KEYRING
+static inline int ima_init_keyring(const unsigned int id)
+{
+	return integrity_init_keyring(id);
+}
+#else
+static inline int ima_init_keyring(const unsigned int id)
+{
+	return 0;
+}
+#endif /* CONFIG_IMA_TRUSTED_KEYRING */
 #endif
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f474c60..0d69643 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -325,8 +325,14 @@ static int __init init_ima(void)
 
 	hash_setup(CONFIG_IMA_DEFAULT_HASH);
 	error = ima_init();
-	if (!error)
-		ima_initialized = 1;
+	if (error)
+		goto out;
+
+	error = ima_init_keyring(INTEGRITY_KEYRING_IMA);
+	if (error)
+		goto out;
+	ima_initialized = 1;
+out:
 	return error;
 }
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 33c0a70..09c440d 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -124,6 +124,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
+int integrity_init_keyring(const unsigned int id);
 #else
 
 static inline int integrity_digsig_verify(const unsigned int id,
@@ -133,6 +134,10 @@ static inline int integrity_digsig_verify(const unsigned int id,
 	return -EOPNOTSUPP;
 }
 
+static inline int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
-- 
1.8.1.4

