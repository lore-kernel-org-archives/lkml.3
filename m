Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab3BTCRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:17:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:46555 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235Ab3BTCRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:17:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,698,1355126400"; 
   d="scan'208";a="204245961"
Subject: [PATCH] freezer: configure user space process frozen along with
 kernel threads
From: Li Fei <fei.li@intel.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, ebiederm@xmission.com, gorcunov@openvz.org,
        rientjes@google.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        chuansheng.liu@intel.com, biao.wang@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Feb 2013 10:15:25 +0800
Message-ID: <1361326525.9753.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is well known issue that freezing will fail in case that fuse
daemon is frozen firstly with some requests not handled, as the fuse
usage task is waiting for the response from fuse daemon and can't be
frozen. To solve the issue as above, make fuse daemon frozen after
all user space processes frozen and during the kernel threads frozen
phase.

After discussion, at present it's generally agreed that:
1) It's only the fuse daemon itself know definitely that it needs
and can be frozen together with kernel threads;
2) It's helpful to expose interface that user space processes can
use to configure user space processes to be frozen together with
kernel threads.
More information can be found on https://lkml.org/lkml/2013/2/18/174.

To support the requirement above, attribute /proc/<PID>/freeze_late
is added, writing 1 to it will make the process to be frozen together
with kernel threads, and writing 0 to it will make the process to be
frozen together with user space processes.

Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Wang Biao <biao.wang@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 fs/proc/base.c          |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/freezer.h |    6 ++++
 include/linux/sched.h   |    2 +
 kernel/freezer.c        |   29 +++++++++++++++++++-
 kernel/power/process.c  |    2 +-
 5 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9b43ff77..8d54c79 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -89,6 +89,9 @@
 #include <asm/hardwall.h>
 #endif
 #include <trace/events/oom.h>
+#ifdef CONFIG_FREEZER
+#include <linux/freezer.h>
+#endif
 #include "internal.h"
 #include "fd.h"
 
@@ -2486,6 +2489,70 @@ static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 	return err;
 }
 
+#ifdef CONFIG_FREEZER
+
+static ssize_t freeze_late_read(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	int freeze_late;
+	size_t len;
+	if (!task)
+		return -ESRCH;
+	freeze_late = (task->flags & PF_FREEZER_LATE) ? 1 : 0;
+	len = snprintf(buffer, sizeof(buffer), "%d\n", freeze_late);
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t freeze_late_write(struct file *file, const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF];
+	int freeze_late;
+	int err;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = kstrtoint(strstrip(buffer), 0, &freeze_late);
+	if (err)
+		goto out;
+	if (freeze_late < FREEZE_LATE_MIN ||
+			freeze_late > FREEZE_LATE_MAX) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task) {
+		err = -ESRCH;
+		goto out;
+	}
+
+	if (freeze_late)
+		set_freeze_late_flag(task);
+	else
+		clear_freeze_late_flag(task);
+
+out:
+	return err < 0 ? err : count;
+}
+
+static const struct file_operations proc_freeze_late_operations = {
+	.read		= freeze_late_read,
+	.write		= freeze_late_write,
+	.llseek		= generic_file_llseek,
+};
+
+#endif
+
 /*
  * Thread groups
  */
@@ -2582,6 +2649,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_FREEZER
+	REG("freeze_late", S_IRUGO|S_IWUSR, proc_freeze_late_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..10b24f8 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -51,6 +51,10 @@ static inline bool try_to_freeze(void)
 
 extern bool freeze_task(struct task_struct *p);
 extern bool set_freezable(void);
+#define FREEZE_LATE_MIN 0
+#define FREEZE_LATE_MAX 1
+extern void set_freeze_late_flag(struct task_struct *p);
+extern void clear_freeze_late_flag(struct task_struct *p);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern bool cgroup_freezing(struct task_struct *task);
@@ -217,6 +221,8 @@ static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
+static inline void set_freeze_late_flag(void) {}
+static inline void clear_freeze_late_flag(void) {}
 
 #define freezable_schedule()  schedule()
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..4b2a7ef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,6 +1826,8 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
+/* Threads to be frozen along with kernel threads */
+#define PF_FREEZER_LATE 0x80000000
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..1469474 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -39,7 +39,8 @@ bool freezing_slow_path(struct task_struct *p)
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-	if (pm_freezing && !(p->flags & PF_KTHREAD))
+	if (pm_freezing && !(p->flags & PF_KTHREAD) &&
+				!(p->flags & PF_FREEZE_LATE))
 		return true;
 
 	return false;
@@ -162,3 +163,29 @@ bool set_freezable(void)
 	return try_to_freeze();
 }
 EXPORT_SYMBOL(set_freezable);
+
+/**
+ * set_freeze_late_flag - make %p to be frozen late
+ *
+ * Make %p to be frozen by freezer along with kernel threads
+ */
+void set_freeze_late_flag(struct task_struct *p)
+{
+	spin_lock_irq(&freezer_lock);
+	p->flags |= PF_FREEZE_LATE;
+	spin_unlock_irq(&freezer_lock);
+}
+EXPORT_SYMBOL(set_freeze_late_flag);
+
+/**
+ * clear_freeze_late_flag - make %p to be frozen early
+ *
+ * Make %p to be frozen by freezer along with user space processes
+ */
+void clear_freeze_late_flag(struct task_struct *p)
+{
+	spin_lock_irq(&freezer_lock);
+	p->flags &= ~PF_FREEZE_LATE;
+	spin_unlock_irq(&freezer_lock);
+}
+EXPORT_SYMBOL(clear_freeze_late_flag);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index d5a258b..1472308 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -199,7 +199,7 @@ void thaw_kernel_threads(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
+		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER | PF_FREEZE_LATE))
 			__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
-- 
1.7.4.1




