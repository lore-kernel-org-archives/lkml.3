Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3FGJCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:02:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27935 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FGJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:02:34 -0400
Message-ID: <51B1A190.4060409@huawei.com>
Date: Fri, 7 Jun 2013 17:02:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3.4-stable 2/2] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE
 section
References: <51B1A15C.5040108@huawei.com>
In-Reply-To: <51B1A15C.5040108@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ lizf: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/ftrace.h |  3 ++-
 kernel/trace/ftrace.c  | 28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8add291..f80ca4a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -299,7 +299,6 @@ ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
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
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8f74f42..e101cf9 100644
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
@@ -2541,7 +2554,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2625,19 +2638,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
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
1.8.0.2
