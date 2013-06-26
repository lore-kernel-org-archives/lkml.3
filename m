Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FZQSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:18:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:18:37 -0400
Date: Wed, 26 Jun 2013 11:18:20 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        containers@lists.linux-foundation.org,
        Colin Ian King <colin.king@canonical.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: [PATCH RFC] procfs: add pidnr file
Message-ID: <20130626161820.GA32142@tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a file called pidnr under /proc/task/.  Reading this file gives the
pid of /proc/task in the reading task's namespace (or 0 if there is no
valid pid).

This fills a need currently not solvable at all.  The particular need I
have for it is so that a task inside a container can pass requests to a
task outside the container (using an open fd for /proc/task) to have the
target task moved to a new cgroup.  Others have asked for this ability
for other reasons.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: containers@lists.linux-foundation.org
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
---
 fs/proc/base.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c3834da..b7499eb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -899,6 +899,28 @@ static const struct file_operations proc_environ_operations = {
 	.release	= mem_release,
 };
 
+#define TMPBUFLEN 21
+static ssize_t pidnr_read(struct file * file, char __user * buf,
+				  size_t count, loff_t *ppos)
+{
+	struct inode * inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+	ssize_t length;
+	char tmpbuf[TMPBUFLEN];
+
+	if (!task)
+		return -ESRCH;
+	length = scnprintf(tmpbuf, TMPBUFLEN, "%u\n",
+			task_pid_vnr(task));
+	put_task_struct(task);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
+static const struct file_operations pidnr_operations = {
+	.read		= pidnr_read,
+	.llseek		= generic_file_llseek,
+};
+
 static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
@@ -1096,7 +1118,6 @@ static const struct file_operations proc_oom_score_adj_operations = {
 };
 
 #ifdef CONFIG_AUDITSYSCALL
-#define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
@@ -2642,6 +2663,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
+	REG("pidnr",      S_IRUGO, pidnr_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUGO, proc_pid_personality),
@@ -2999,6 +3021,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
+	REG("pidnr",     S_IRUGO, pidnr_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUGO, proc_pid_personality),
-- 
1.7.9.5

