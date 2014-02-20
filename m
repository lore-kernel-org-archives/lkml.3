Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaBTIoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:44:37 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46459 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaBTIoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:44:34 -0500
X-AuditID: 85900ec0-cff26b9000001514-16-5305c06fd4f8
Subject: [PATCH V2 1/2] ftrace: Make saved_cmdlines use seq_read
To: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 20 Feb 2014 17:44:31 +0900
Message-ID: <20140220084431.3839.51793.stgit@yunodevel>
In-Reply-To: <20140220084428.3839.59555.stgit@yunodevel>
References: <20140220084428.3839.59555.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current tracing_saved_cmdlines_read() implementation is naive;
simply allocate a big buffer, construct output data on the
buffer for each read operation, and then copy a portion of
the buffer to the user space buffer.  This can cause a couple of
issues such as a slow memory allocation, high cpu usage, and a
corruption of the output data.

To address these issues, make saved_cmdlines use seq_read.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |   89 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 815c878..b97648aa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3638,55 +3638,74 @@ static const struct file_operations tracing_readme_fops = {
 	.llseek		= generic_file_llseek,
 };
 
-static ssize_t
-tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
-				size_t cnt, loff_t *ppos)
+static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	char *buf_comm;
-	char *file_buf;
-	char *buf;
-	int len = 0;
-	int pid;
-	int i;
+	unsigned int *ptr = v;
 
-	file_buf = kmalloc(SAVED_CMDLINES*(16+TASK_COMM_LEN), GFP_KERNEL);
-	if (!file_buf)
-		return -ENOMEM;
+	if (*pos || m->count)
+		ptr++;
 
-	buf_comm = kmalloc(TASK_COMM_LEN, GFP_KERNEL);
-	if (!buf_comm) {
-		kfree(file_buf);
-		return -ENOMEM;
-	}
+	(*pos)++;
+
+	for (; ptr < &map_cmdline_to_pid[SAVED_CMDLINES]; ptr++) {
+		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
+			continue;
 
-	buf = file_buf;
+		return ptr;
+	}
 
-	for (i = 0; i < SAVED_CMDLINES; i++) {
-		int r;
+	return NULL;
+}
 
-		pid = map_cmdline_to_pid[i];
-		if (pid == -1 || pid == NO_CMDLINE_MAP)
-			continue;
+static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
+{
+	void *v;
+	loff_t l = 0;
 
-		trace_find_cmdline(pid, buf_comm);
-		r = sprintf(buf, "%d %s\n", pid, buf_comm);
-		buf += r;
-		len += r;
+	v = &map_cmdline_to_pid[0];
+	while (l <= *pos) {
+		v = saved_cmdlines_next(m, v, &l);
+		if (!v)
+			return NULL;
 	}
 
-	len = simple_read_from_buffer(ubuf, cnt, ppos,
-				      file_buf, len);
+	return v;
+}
 
-	kfree(file_buf);
-	kfree(buf_comm);
+static void saved_cmdlines_stop(struct seq_file *m, void *v)
+{
+}
 
-	return len;
+static int saved_cmdlines_show(struct seq_file *m, void *v)
+{
+	char buf[TASK_COMM_LEN];
+	unsigned int *pid = v;
+
+	trace_find_cmdline(*pid, buf);
+	seq_printf(m, "%d %s\n", *pid, buf);
+	return 0;
+}
+
+static const struct seq_operations tracing_saved_cmdlines_seq_ops = {
+	.start		= saved_cmdlines_start,
+	.next		= saved_cmdlines_next,
+	.stop		= saved_cmdlines_stop,
+	.show		= saved_cmdlines_show,
+};
+
+static int tracing_saved_cmdlines_open(struct inode *inode, struct file *filp)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+
+	return seq_open(filp, &tracing_saved_cmdlines_seq_ops);
 }
 
 static const struct file_operations tracing_saved_cmdlines_fops = {
-    .open       = tracing_open_generic,
-    .read       = tracing_saved_cmdlines_read,
-    .llseek	= generic_file_llseek,
+	.open		= tracing_saved_cmdlines_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
 };
 
 static ssize_t

