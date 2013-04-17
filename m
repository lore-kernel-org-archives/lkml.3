Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab3DQTzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:55:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3DQTzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:55:04 -0400
Date: Wed, 17 Apr 2013 12:54:52 -0700
From: tip-bot for Pavel Emelyanov <tipbot@zytor.com>
Message-ID: <tip-48f6a7a511ef8823fdff39afee0320092d43a8a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <513DA00D.6070009@parallels.com>
References: <513DA00D.6070009@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Introduce /proc/PID/timers file
Git-Commit-ID: 48f6a7a511ef8823fdff39afee0320092d43a8a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 12:54:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48f6a7a511ef8823fdff39afee0320092d43a8a0
Gitweb:     http://git.kernel.org/tip/48f6a7a511ef8823fdff39afee0320092d43a8a0
Author:     Pavel Emelyanov <xemul@parallels.com>
AuthorDate: Mon, 11 Mar 2013 13:12:45 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 20:51:01 +0200

posix-timers: Introduce /proc/PID/timers file

Currently kernel doesn't provide any API for getting info about what
posix timers are configured by processes. It's implied, that a process
which configured some timers, knows what it did. However, for external
tools it's impossible to get this information. In particular, this is
critical for checkpoint-restore project to have this info.

Introduce a per-pid proc file with information about posix
timers. Since these timers are shared between threads, this file is
present on tgid level only, no such thing in tid subdirs.

The file format is expected to be the "/proc/<pid>/smaps"-like,
i.e. each timer will occupy seveal lines to allow for future
extending.

Each new timer entry starts with the

ID: <number>

line which is added by this patch.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Link: http://lkml.kernel.org/r/513DA00D.6070009@parallels.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/base.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..01def9f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -86,6 +86,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/flex_array.h>
+#include <linux/posix-timers.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2013,6 +2014,85 @@ static const struct file_operations proc_map_files_operations = {
 	.llseek		= default_llseek,
 };
 
+struct timers_private {
+	struct pid *pid;
+	struct task_struct *task;
+	struct sighand_struct *sighand;
+	unsigned long flags;
+};
+
+static void *timers_start(struct seq_file *m, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+
+	tp->task = get_pid_task(tp->pid, PIDTYPE_PID);
+	if (!tp->task)
+		return ERR_PTR(-ESRCH);
+
+	tp->sighand = lock_task_sighand(tp->task, &tp->flags);
+	if (!tp->sighand)
+		return ERR_PTR(-ESRCH);
+
+	return seq_list_start(&tp->task->signal->posix_timers, *pos);
+}
+
+static void *timers_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+	return seq_list_next(v, &tp->task->signal->posix_timers, pos);
+}
+
+static void timers_stop(struct seq_file *m, void *v)
+{
+	struct timers_private *tp = m->private;
+
+	if (tp->sighand) {
+		unlock_task_sighand(tp->task, &tp->flags);
+		tp->sighand = NULL;
+	}
+
+	if (tp->task) {
+		put_task_struct(tp->task);
+		tp->task = NULL;
+	}
+}
+
+static int show_timer(struct seq_file *m, void *v)
+{
+	struct k_itimer *timer;
+
+	timer = list_entry((struct list_head *)v, struct k_itimer, list);
+	seq_printf(m, "ID: %d\n", timer->it_id);
+
+	return 0;
+}
+
+static const struct seq_operations proc_timers_seq_ops = {
+	.start	= timers_start,
+	.next	= timers_next,
+	.stop	= timers_stop,
+	.show	= show_timer,
+};
+
+static int proc_timers_open(struct inode *inode, struct file *file)
+{
+	struct timers_private *tp;
+
+	tp = __seq_open_private(file, &proc_timers_seq_ops,
+			sizeof(struct timers_private));
+	if (!tp)
+		return -ENOMEM;
+
+	tp->pid = proc_pid(inode);
+	return 0;
+}
+
+static const struct file_operations proc_timers_operations = {
+	.open		= proc_timers_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
@@ -2583,6 +2663,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("timers",	  S_IRUGO, proc_timers_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
