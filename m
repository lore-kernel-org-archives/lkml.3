Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab3DOCoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:44:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934494Ab3DOCoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:44:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [ 23/27] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
Date: Sun, 14 Apr 2013 19:43:22 -0700
Message-Id: <20130415024233.069872762@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ftrace.h |    3 ++-
 kernel/trace/ftrace.c  |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -394,7 +394,6 @@ ssize_t ftrace_filter_write(struct file
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
@@ -567,6 +566,8 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
+
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1027,6 +1027,19 @@ static __init void ftrace_profile_debugf
 
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
@@ -2589,7 +2602,7 @@ static void ftrace_filter_reset(struct f
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2673,19 +2686,6 @@ ftrace_notrace_open(struct inode *inode,
 				 inode, file);
 }
 
-loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, whence);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;


