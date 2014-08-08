Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaHHTAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaHHTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:00:11 -0400
Date: Fri, 8 Aug 2014 20:57:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] proc: unify proc_tgid_stat() and proc_tid_stat()
Message-ID: <20140808185752.GA781@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185732.GA760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have is_tgid_pid_entry() we do not need 2 different helpers
for ONE("stat"), we can kill proc_tgid_stat() and proc_tid_stat() and
turn do_task_stat() into proc_pid_stat().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c    |   17 +++--------------
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    4 +---
 3 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..d096bd6 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -377,9 +377,10 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
-static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
-			struct pid *pid, struct task_struct *task, int whole)
+int proc_pid_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
+	bool whole = is_tgid_pid_entry(PROC_I(m->private)->pid_entry);
 	unsigned long vsize, eip, esp, wchan = ~0UL;
 	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
@@ -550,18 +551,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
-int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
-			struct pid *pid, struct task_struct *task)
-{
-	return do_task_stat(m, ns, pid, task, 0);
-}
-
-int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
-			struct pid *pid, struct task_struct *task)
-{
-	return do_task_stat(m, ns, pid, task, 1);
-}
-
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ea11bf1..9d47fe0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2581,7 +2581,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
-	ONE("stat",       S_IRUGO, proc_tgid_stat),
+	ONE("stat",       S_IRUGO, proc_pid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
 #ifdef CONFIG_NUMA
@@ -2917,7 +2917,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
-	ONE("stat",      S_IRUGO, proc_tid_stat),
+	ONE("stat",      S_IRUGO, proc_pid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
 #ifdef CONFIG_CHECKPOINT_RESTORE
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2e310b6..c7bb0e3 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -151,10 +151,8 @@ extern const struct file_operations proc_tid_children_operations;
 
 extern bool is_tgid_pid_entry(const struct pid_entry *p);
 
-extern int proc_tid_stat(struct seq_file *, struct pid_namespace *,
+extern int proc_pid_stat(struct seq_file *, struct pid_namespace *,
 			 struct pid *, struct task_struct *);
-extern int proc_tgid_stat(struct seq_file *, struct pid_namespace *,
-			  struct pid *, struct task_struct *);
 extern int proc_pid_status(struct seq_file *, struct pid_namespace *,
 			   struct pid *, struct task_struct *);
 extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
-- 
1.5.5.1

