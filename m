Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3DRJSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:18:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab3DRJS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 61/72] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
Date: Thu, 18 Apr 2013 10:16:46 +0100
Message-Id: <1366276617-3553-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ftrace.h |  3 ++-
 kernel/trace/ftrace.c  | 28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6ce7928..fee0238 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -305,7 +305,6 @@ ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int origin);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
@@ -429,6 +428,8 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
+
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f125532..38353bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -999,6 +999,19 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
+loff_t
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_lseek(file, offset, whence);
+	else
+		file->f_pos = ret = 1;
+
+	return ret;
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -2509,7 +2522,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2593,19 +2606,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
 				 inode, file);
 }
 
-loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, origin);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
-- 
1.8.1.2

