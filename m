Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaEZNdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:33:37 -0400
Received: from numidia.opendz.org ([98.142.220.152]:48848 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:33:36 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 09:33:35 EDT
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 4/9] procfs: improve /proc/<pid>/wchan protection
Date: Mon, 26 May 2014 14:27:25 +0100
Message-Id: <1401110850-3552-5-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wchan from an INF entry to a REG one. This way we can perform
and cache the permission checks during ->open().

The checks are only cached, since /proc/<pid>/wchan is world readable,
and it needs permissions only when returning an address, returning the
symbol name is not subject to permission checks, so do not change this.

With this logic userspace should continue to work without any problem,
only cases where users are trying to play tricks or something
sophisticated is trying to use privileged programs to disclose sensitive
data will notice.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index efe2a11..ef35544 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -273,21 +273,64 @@ static int proc_pid_auxv(struct task_struct *task, char *buffer)
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
  * Returns the resolved symbol.  If that fails, simply return the address.
  */
-static int proc_pid_wchan(struct task_struct *task, char *buffer)
+static int wchan_open(struct inode *inode, struct file *filp)
+{
+	/* we only cache the result for wchan entry */
+	if (pid_entry_access(filp, PTRACE_MODE_READ))
+		filp->private_data = (void *)(unsigned long)PID_ENTRY_DENY;
+	else
+		filp->private_data = (void *)(unsigned long)PID_ENTRY_ALLOW;
+
+	return 0;
+}
+
+static int proc_pid_wchan(char *buffer,
+			  struct task_struct *task, int permitted)
 {
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
 
 	wchan = get_wchan(task);
 
-	if (lookup_symbol_name(wchan, symname) < 0)
-		if (!ptrace_may_access(task, PTRACE_MODE_READ))
+	if (lookup_symbol_name(wchan, symname) < 0) {
+		if (!permitted)
+			return 0;
+
+		/* Update only if access was granted during ->open */
+		if (!mutex_lock_killable(&task->signal->cred_guard_mutex)) {
+			permitted = ptrace_may_access(task, PTRACE_MODE_READ);
+			mutex_unlock(&task->signal->cred_guard_mutex);
+		}
+
+		if (!permitted)
 			return 0;
 		else
 			return sprintf(buffer, "%lu", wchan);
-	else
+	} else
 		return sprintf(buffer, "%s", symname);
 }
+
+static ssize_t wchan_read(struct file *file, char __user *buf,
+			  size_t count, loff_t *ppos)
+{
+	ssize_t length;
+	unsigned long page = 0UL;
+
+	length = pid_entry_read(file, &page, proc_pid_wchan);
+	if (length >= 0) {
+		length = proc_read_from_buffer(buf, count, ppos,
+					       (char *)page, length);
+		free_page(page);
+	}
+
+	return length;
+}
+
+static const struct file_operations proc_pid_wchan_operations = {
+	.open   = wchan_open,
+	.read   = wchan_read,
+	.llseek = generic_file_llseek,
+};
 #endif /* CONFIG_KALLSYMS */
 
 static int lock_trace(struct task_struct *task)
@@ -2631,7 +2674,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",      S_IRUGO, proc_pid_wchan),
+	REG("wchan",      S_IRUGO, proc_pid_wchan_operations),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
@@ -2967,7 +3010,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",     S_IRUGO, proc_pid_wchan),
+	REG("wchan",     S_IRUGO, proc_pid_wchan_operations),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
-- 
1.7.11.7

