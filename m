Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaJJOKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:10:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26329 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJJOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:10:02 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-46-5437e8b41725
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 4/6] integrity: provide hook to load keys when rootfs is
 ready
Date: Fri, 10 Oct 2014 17:09:31 +0300
Message-id: <d9c99743a6010aebdea29a9966030e56b84b7418.1412950047.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7pbXpiHGCzdbmUxZ/0aNotbf/cy
	W3xZWmfxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48SM3yweDw5tZvHYveAz
	k0ffllWMHp83yXlsevKWKYA9issmJTUnsyy1SN8ugSujf0kHc8F04YpJU+eyNjBe4+9i5OSQ
	EDCRONf3jg3CFpO4cG89kM3FISSwlFHi1fc1YAkhgU4mibktBSA2m4CexIbmH+wgRSICixgl
	Hi+7yAqSYBZIl/g0qZcdxBYWCJZ42reBGcRmEVCVeHdmJdAgDg5egTiJV3MyIJbJSZw8Nhms
	lVPASuLbq19MELssJb6/b2HBJT6BkX8BI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAA
	/bqDcekxq0OMAhyMSjy8F2TMQ4RYE8uKK3MPMUpwMCuJ8H57DhTiTUmsrEotyo8vKs1JLT7E
	yMTBKdXAGKVlvjNpQltD4tGf7R0Jjy5sPiERaNmkVLHj3ORjJVdacr0al6hv2bRkxSqt148m
	ndrj6852M/2m+gr1c30xov+bNolZVmz2SUoRrHu0ZNal8JL1GrO5n5w3b/BVfvr+L6td9oZr
	yjJWqhP9fvRmKV8qTE+fv/Ru4uJPL8N8f6gY1Vlc59rAr8RSnJFoqMVcVJwIAI+MBbUuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keys can only be loaded when rootfs is mounted. Initcalls
are not suitable for that. Provide a special hook.

Changes in v2:
* Hook renamed as 'integrity_load_keys()' to handle both IMA and EVM
  keys by integrity subsystem.
* Hook patch moved after defining loading functions

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 include/linux/integrity.h |  6 ++++++
 init/main.c               |  6 +++++-
 security/integrity/iint.c | 11 +++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 83222ce..c2d6082 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -24,6 +24,7 @@ enum integrity_status {
 #ifdef CONFIG_INTEGRITY
 extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
 extern void integrity_inode_free(struct inode *inode);
+extern void __init integrity_load_keys(void);
 
 #else
 static inline struct integrity_iint_cache *
@@ -36,5 +37,10 @@ static inline void integrity_inode_free(struct inode *inode)
 {
 	return;
 }
+
+static inline void integrity_load_keys(void)
+{
+}
 #endif /* CONFIG_INTEGRITY */
+
 #endif /* _LINUX_INTEGRITY_H */
diff --git a/init/main.c b/init/main.c
index e8ae1fe..2c1928d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -78,6 +78,7 @@
 #include <linux/context_tracking.h>
 #include <linux/random.h>
 #include <linux/list.h>
+#include <linux/integrity.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1026,8 +1027,11 @@ static noinline void __init kernel_init_freeable(void)
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
+	 *
+	 * rootfs is available now, try loading the public keys
+	 * and default modules
 	 */
 
-	/* rootfs is available now, try loading default modules */
+	integrity_load_keys();
 	load_default_modules();
 }
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index 0a76686..a1f5cd1 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -245,3 +245,14 @@ out:
 	fput(file);
 	return rc;
 }
+
+/*
+ * integrity_load_keys - load integrity keys hook
+ *
+ * Hooks is called from init/main.c:kernel_init_freeable()
+ * when rootfs is ready
+ */
+void __init integrity_load_keys(void)
+{
+	ima_load_x509();
+}
-- 
1.9.1

