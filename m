Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3FGJB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:01:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26117 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FGJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:01:53 -0400
Message-ID: <51B1A150.6030804@huawei.com>
Date: Fri, 7 Jun 2013 17:01:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 3.0-stable 2/2] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE
 section
References: <51B1A131.9090206@huawei.com>
In-Reply-To: <51B1A131.9090206@huawei.com>
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
 kernel/trace/ftrace.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b17a3f6..0d704b0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -933,6 +933,19 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
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
@@ -2299,19 +2312,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
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
-- 
1.8.0.2

