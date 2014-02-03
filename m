Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaBCTJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:09:49 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37215 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBCTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:09:33 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/10] kernfs: add CONFIG_KERNFS
Date: Mon,  3 Feb 2014 14:09:17 -0500
Message-Id: <1391454557-32376-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391454557-32376-1-git-send-email-tj@kernel.org>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As sysfs was kernfs's only user, kernfs has been piggybacking on
CONFIG_SYSFS; however, kernfs is scheduled to grow a new user very
soon.  Introduce a separate config option CONFIG_KERNFS which is to be
selected by kernfs users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/Kconfig             | 1 +
 fs/Makefile            | 3 ++-
 fs/kernfs/Kconfig      | 7 +++++++
 fs/sysfs/Kconfig       | 1 +
 include/linux/kernfs.h | 6 +++---
 5 files changed, 14 insertions(+), 4 deletions(-)
 create mode 100644 fs/kernfs/Kconfig

diff --git a/fs/Kconfig b/fs/Kconfig
index 7385e54..312393f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -96,6 +96,7 @@ endif # BLOCK
 menu "Pseudo filesystems"
 
 source "fs/proc/Kconfig"
+source "fs/kernfs/Kconfig"
 source "fs/sysfs/Kconfig"
 
 config TMPFS
diff --git a/fs/Makefile b/fs/Makefile
index 47ac07b..f9cb987 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,7 +52,8 @@ obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-y				+= quota/
 
 obj-$(CONFIG_PROC_FS)		+= proc/
-obj-$(CONFIG_SYSFS)		+= sysfs/ kernfs/
+obj-$(CONFIG_KERNFS)		+= kernfs/
+obj-$(CONFIG_SYSFS)		+= sysfs/
 obj-$(CONFIG_CONFIGFS_FS)	+= configfs/
 obj-y				+= devpts/
 
diff --git a/fs/kernfs/Kconfig b/fs/kernfs/Kconfig
new file mode 100644
index 0000000..397b5f7
--- /dev/null
+++ b/fs/kernfs/Kconfig
@@ -0,0 +1,7 @@
+#
+# KERNFS should be selected by its users
+#
+
+config KERNFS
+	bool
+	default n
diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
index 8c41fea..b275601 100644
--- a/fs/sysfs/Kconfig
+++ b/fs/sysfs/Kconfig
@@ -1,6 +1,7 @@
 config SYSFS
 	bool "sysfs file system support" if EXPERT
 	default y
+	select KERNFS
 	help
 	The sysfs filesystem is a virtual filesystem that the kernel uses to
 	export internal kernel objects, their attributes, and their
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index b7cb267..32b696f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -201,7 +201,7 @@ struct kernfs_ops {
 #endif
 };
 
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_KERNFS
 
 static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
 {
@@ -284,7 +284,7 @@ void kernfs_kill_sb(struct super_block *sb);
 
 void kernfs_init(void);
 
-#else	/* CONFIG_SYSFS */
+#else	/* CONFIG_KERNFS */
 
 static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
 { return 0; }	/* whatever */
@@ -379,7 +379,7 @@ static inline void kernfs_kill_sb(struct super_block *sb) { }
 
 static inline void kernfs_init(void) { }
 
-#endif	/* CONFIG_SYSFS */
+#endif	/* CONFIG_KERNFS */
 
 static inline struct kernfs_node *
 kernfs_find_and_get(struct kernfs_node *kn, const char *name)
-- 
1.8.5.3

