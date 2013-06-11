Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3FKUij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:38:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3FKUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:02:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [ 21/21] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
Date: Tue, 11 Jun 2013 13:03:15 -0700
Message-Id: <20130611195522.489019732@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195520.003233586@linuxfoundation.org>
References: <20130611195520.003233586@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


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
 kernel/trace/ftrace.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -933,6 +933,19 @@ static __init void ftrace_profile_debugf
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
+static loff_t
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
@@ -2299,19 +2312,6 @@ ftrace_notrace_open(struct inode *inode,
 				 inode, file);
 }
 
-static loff_t
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


