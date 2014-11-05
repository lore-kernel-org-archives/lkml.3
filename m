Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaKEPCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:02:52 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25535 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaKEPCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:02:48 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-ce-545a3c16cc5e
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v4 4/6] integrity: provide a hook to load keys when rootfs is
 ready
Date: Wed, 05 Nov 2014 17:01:15 +0200
Message-id: <1618d51b09e8126689d791edb3ff97b01f0d9a3f.1415197743.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1415197743.git.d.kasatkin@samsung.com>
References: <cover.1415197743.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xK7piNlEhBke2SVnMWb+GzeLW373M
	Fl+W1lm8nDGP3eLyrjlsFh96HrFZnP97nNXi04pJzA4cHjtn3WX3ODHjN4vHg0ObWTx2L/jM
	5NG3ZRWjx+dNch6bnrxlCmCP4rJJSc3JLEst0rdL4Mq4/fIJY8ET0Yq/8w4wNzA+Fuxi5OCQ
	EDCR6Pkc3cXICWSKSVy4t56ti5GLQ0hgKaNEx6vLLCAJIYFOJonnd+1BbDYBPYkNzT/YQYpE
	BBYxSmz6ehGsiFkgXeLTpF52kKHCAqESmy4KgIRZBFQlFi88ygZi8wrESbRvmMYEsUxO4uSx
	yawgNqeAlcSEJxfZIHZZSix81MSIS3wCI/8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCHh+WUH4+JjVocYBTgYlXh4PZoiQ4RYE8uKK3MPMUpwMCuJ8F6zjAoR4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwGieLW+rz9F9N+iU1IKvN3xuR7zXviml8EVdgOFLma2bi9i627WlXT2zZ3me
	6p/sL5rt3aXkLVxv8ZInmlfY0ebRjx/Rax2/y2z7kvdXZtauy7k1tkfkowxDp033kWOYWOH8
	2MfpRcvkP7deqgUuVHe+ZDKnfu7M+9sv9fJ9Ovb3psCMr4kVn5RYijMSDbWYi4oTAZVNAFwt	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keys can only be loaded once the rootfs is mounted. Initcalls
are not suitable for that. This patch defines a special hook
to load the x509 public keys onto the IMA keyring, before
attempting to access any file. The keys are required for
verifying the file's signature. The hook is called after the
root filesystem is mounted and before the kernel calls 'init'.

Changes in v3:
* added more explanation to the patch description (Mimi)

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

