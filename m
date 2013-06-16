Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3FPW0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:26:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab3FPWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        "Namhyung Kim" <namhyung@kernel.org>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.125177514@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [30/83] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE
 section
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2:
 - ftrace_filter_lseek() is static and not declared in ftrace.h
 - 'whence' parameter was called 'origin']
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -929,6 +929,19 @@ static __init void ftrace_profile_debugf
 
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
@@ -2315,19 +2328,6 @@ ftrace_notrace_open(struct inode *inode,
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

