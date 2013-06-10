Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3FKG2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:28:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3FKG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:50 -0400
Subject: Patch "ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section" has been added to the 3.4-stable tree
To: lizefan@huawei.com, fweisbec@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        rostedt@goodmis.org, stable@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 10 Jun 2013 14:28:03 -0700
In-Reply-To: <51B1A190.4060409@huawei.com>
Message-ID: <13708996831528@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ftrace-move-ftrace_filter_lseek-out-of-config_dynamic_ftrace-section.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From lizefan@huawei.com  Mon Jun 10 14:15:51 2013
From: Li Zefan <lizefan@huawei.com>
Date: Fri, 7 Jun 2013 17:02:08 +0800
Subject: ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Message-ID: <51B1A190.4060409@huawei.com>


From: Steven Rostedt <rostedt@goodmis.org>

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
[ lizf: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ftrace.h |    3 ++-
 kernel/trace/ftrace.c  |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -299,7 +299,6 @@ ssize_t ftrace_filter_write(struct file
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int origin);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
@@ -420,6 +419,8 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
+
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -999,6 +999,19 @@ static __init void ftrace_profile_debugf
 
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
@@ -2541,7 +2554,7 @@ static void ftrace_filter_reset(struct f
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2625,19 +2638,6 @@ ftrace_notrace_open(struct inode *inode,
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


Patches currently in stable-queue which might be from lizefan@huawei.com are

queue-3.4/tracing-fix-possible-null-pointer-dereferences.patch
queue-3.4/ftrace-move-ftrace_filter_lseek-out-of-config_dynamic_ftrace-section.patch
