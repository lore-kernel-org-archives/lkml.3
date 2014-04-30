Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaD3Oaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:30:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52345 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758930AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 15/16] kgr: add procfs interface for per-process 'kgr_in_progress'
Date: Wed, 30 Apr 2014 16:30:48 +0200
Message-Id: <1398868249-26169-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Instead of flooding dmesg with data about tasks which haven't yet been
migrated to the "new universe", create a 'kgr_in_progress' in /proc/<pid>/
so that it's possible to easily script the checks/actions in userspace.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz> [simplification]
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 fs/proc/base.c | 10 ++++++++++
 kernel/kgr.c   |  3 +--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0c93bf..70cba8b21c3f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2106,6 +2106,13 @@ static const struct file_operations proc_timers_operations = {
 };
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
+#ifdef CONFIG_KGR
+static int proc_pid_kgr_in_progress(struct task_struct *task, char *buffer)
+{
+	return sprintf(buffer, "%d\n", task_thread_info(task)->kgr_in_progress);
+}
+#endif /* CONFIG_KGR */
+
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -2638,6 +2645,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
+#ifdef CONFIG_KGR
+	INF("kgr_in_progress",	S_IRUSR, proc_pid_kgr_in_progress),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/kernel/kgr.c b/kernel/kgr.c
index ff5afaf6f0e7..1fadde396021 100644
--- a/kernel/kgr.c
+++ b/kernel/kgr.c
@@ -45,9 +45,8 @@ static bool kgr_still_patching(void)
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		if (task_thread_info(p)->kgr_in_progress) {
-			pr_info("pid %d (%s) still in kernel after timeout\n",
-					p->pid, p->comm);
 			failed = true;
+			break;
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
1.9.2

