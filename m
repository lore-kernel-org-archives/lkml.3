Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3BFBOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:14:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:1135 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab3BFBOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:14:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,610,1355126400"; 
   d="scan'208";a="199118544"
Subject: [PATCH] fuse: make fuse daemon frozen along with kernel threads
From: Li Fei <fei.li@intel.com>
To: miklos@szeredi.hu, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, peterz@infradead.org
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, chuansheng.liu@intel.com,
        biao.wang@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Feb 2013 09:11:52 +0800
Message-ID: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is well known issue that freezing will fail in case that fuse
daemon is frozen firstly with some requests not handled, as the fuse
usage task is waiting for the response from fuse daemon and can't be
frozen.

To solve the issue above, make fuse daemon frozen after all all user
space processes frozen and during the kernel threads frozen phase.
PF_FREEZE_DAEMON flag is added to indicate that the current thread is
the fuse daemon, set on connection, and clear on disconnection.
It works as all fuse requests are handled during user space processes
frozen, there will no further fuse request, and it's safe to continue
to freeze fuse daemon together with kernel freezable tasks.

Signed-off-by: Wang Biao <biao.wang@intel.com>
Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 fs/fuse/inode.c         |    9 +++++++++
 include/linux/freezer.h |    4 ++++
 include/linux/sched.h   |    2 ++
 kernel/freezer.c        |   33 ++++++++++++++++++++++++++++++++-
 kernel/power/process.c  |    2 +-
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 73ca6b7..fe476e8 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/freezer.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -367,6 +368,10 @@ void fuse_conn_kill(struct fuse_conn *fc)
 	wake_up_all(&fc->waitq);
 	wake_up_all(&fc->blocked_waitq);
 	wake_up_all(&fc->reserved_req_waitq);
+
+	/* Clear daemon flag after disconnection */
+	clear_freeze_daemon_flag();
+
 }
 EXPORT_SYMBOL_GPL(fuse_conn_kill);
 
@@ -1054,6 +1059,10 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 		goto err_unlock;
 
 	list_add_tail(&fc->entry, &fuse_conn_list);
+
+	/* Set daemon flag just before connection */
+	set_freeze_daemon_flag();
+
 	sb->s_root = root_dentry;
 	fc->connected = 1;
 	file->private_data = fuse_conn_get(fc);
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..9f0d0cf 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -51,6 +51,8 @@ static inline bool try_to_freeze(void)
 
 extern bool freeze_task(struct task_struct *p);
 extern bool set_freezable(void);
+extern bool set_freeze_daemon_flag(void);
+extern bool clear_freeze_daemon_flag(void);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern bool cgroup_freezing(struct task_struct *task);
@@ -217,6 +219,8 @@ static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
+static inline void set_freeze_daemon_flag(void) {}
+static inline void clear_freeze_daemon_flag(void) {}
 
 #define freezable_schedule()  schedule()
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..6cdc969 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,6 +1826,8 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
+/* Daemon threads to be frozen along with kernel threads */
+#define PF_FREEZER_DAEMON 0x80000000
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..eff9440 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -39,7 +39,8 @@ bool freezing_slow_path(struct task_struct *p)
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-	if (pm_freezing && !(p->flags & PF_KTHREAD))
+	if (pm_freezing && !(p->flags & PF_KTHREAD) &&
+				!(p->flags & PF_FREEZE_DAEMON))
 		return true;
 
 	return false;
@@ -162,3 +163,33 @@ bool set_freezable(void)
 	return try_to_freeze();
 }
 EXPORT_SYMBOL(set_freezable);
+
+/**
+ * set_freeze_daemon_flag - make %current as daemon
+ *
+ * Make %current being frozen by freezer along with kernel threads
+ */
+bool set_freeze_daemon_flag(void)
+{
+	spin_lock_irq(&freezer_lock);
+	current->flags |= PF_FREEZE_DAEMON;
+	spin_unlock_irq(&freezer_lock);
+
+	return try_to_freeze();
+}
+EXPORT_SYMBOL(set_freeze_daemon_flag);
+
+/**
+ * clear_freeze_daemon_flag - make %current as usual user space process
+ *
+ * Make %current being frozen by freezer along with user space processes
+ */
+bool clear_freeze_daemon_flag(void)
+{
+	spin_lock_irq(&freezer_lock);
+	current->flags &= ~PF_FREEZE_DAEMON;
+	spin_unlock_irq(&freezer_lock);
+
+	return try_to_freeze();
+}
+EXPORT_SYMBOL(clear_freeze_daemon_flag);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index d5a258b..a4489ae 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -199,7 +199,7 @@ void thaw_kernel_threads(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
+		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER | PF_FREEZE_DAEMON))
 			__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
-- 
1.7.4.1




