Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaDWN35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:29:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaDWN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:50 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-90-5357c04b9039
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 05/20] integrity: provide builtin 'trusted' keyrings
Date: Wed, 23 Apr 2014 16:30:23 +0300
Message-id: <2819d76b5ba38aee0028dc5910727a2da268fc60.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7reB8KDDf5O07C49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mp419LFVLBVquL3myXMDYzfRbsYOTkkBEwk1r9ZwQhhi0lc
	uLeerYuRi0NIYCmjxJH3FxghnE4mieNTZrOAVLEJ6ElsaP7BDmKLCLhI7J7TxwRSxCzQwyix
	+89iZpCEMFBi9s+3YA0sAqoSi+c3s4LYvAJxEm09v5kg1ilILPuyFqyeU8BK4k/zdLChQgKW
	Et8nTcYpPoGRfwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkHD8uoNx6TGrQ4wCHIxK
	PLwSy8OChVgTy4orcw8xSnAwK4nwLlkUHizEm5JYWZValB9fVJqTWnyIkYmDU6qB0exXzUQL
	tV3/+EsT5dmEgnX/By68PP+z4M177zf8rUpJdWjhd+FQmrH+vtjRnvvd/FsORRuUpCfdEDhU
	8OrdgoPhMRW9zAGn1qw5z6+78dytK4wNrRVfjKaeufjY/faL1F7xeacnSnbece44d6risjNv
	xFLB/UWrt+Y3/Ity2nrkPovvGdVZy5VYijMSDbWYi4oTATxpOzclAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide creation of trusted keyrings, which require all keys
added to the keyrings be signed by an existing trusted key
on the system trusted keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     |  4 ++++
 security/integrity/digsig.c    | 31 +++++++++++++++++++++++++++++++
 security/integrity/integrity.h | 10 ++++++++++
 3 files changed, 45 insertions(+)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index b16c9cd..89f226a 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -47,6 +47,10 @@ config INTEGRITY_AUDIT
 	  be enabled by specifying 'integrity_audit=1' on the kernel
 	  command line.
 
+config INTEGRITY_TRUSTED_KEYRING
+	def_bool n
+	depends on IMA_TRUSTED_KEYRING || EVM_TRUSTED_KEYRING
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
 
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index b4af4eb..45adc07 100644
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
 
@@ -56,3 +58,32 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 
 	return -EOPNOTSUPP;
 }
+
+#ifdef CONFIG_INTEGRITY_TRUSTED_KEYRING
+int integrity_init_keyring(const unsigned int id)
+{
+	const struct cred *cred = current_cred();
+	const struct user_struct *user = cred->user;
+
+	pr_notice("initialize trusted keyring: %s\n", keyring_name[id]);
+
+	/* this function relies that init_root_keyring() was executed
+	 * in 'keys' subsystem, which is initialized before integrity
+	 */
+
+	keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
+				    KGIDT_INIT(0), cred,
+				    ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				     KEY_USR_VIEW | KEY_USR_READ),
+				    KEY_ALLOC_NOT_IN_QUOTA, user->uid_keyring);
+	if (IS_ERR(keyring[id])) {
+		long rc = PTR_ERR(keyring[id]);
+		pr_err("Can't allocate %s keyring (%ld)\n",
+		       keyring_name[id], rc);
+		keyring[id] = NULL;
+		return rc;
+	}
+	set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
+	return 0;
+}
+#endif
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 2fb5e53..dd26ad0 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -137,6 +137,7 @@ static inline int integrity_digsig_verify(const unsigned int id,
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int asymmetric_verify(struct key *keyring, const char *sig,
 		      int siglen, const char *data, int datalen);
+
 #else
 static inline int asymmetric_verify(struct key *keyring, const char *sig,
 				    int siglen, const char *data, int datalen)
@@ -145,6 +146,15 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 }
 #endif
 
+#ifdef CONFIG_INTEGRITY_TRUSTED_KEYRING
+int integrity_init_keyring(const unsigned int id);
+#else
+static inline int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_INTEGRITY_AUDIT
 /* declarations */
 void integrity_audit_msg(int audit_msgno, struct inode *inode,
-- 
1.8.3.2

