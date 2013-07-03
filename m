Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab3GCTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:15:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3GCTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:16 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9orN5my68swA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CybV8xYNGJwA:10 a=cm27Pg_UAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=82irRftXAAAA:8 a=VwQbUJbxAAAA:8 a=kyFdvUZNXn0i95xzGiAA:9 a=zv9_9hqRWm8A:10 a=jbrJJM5MRmoA:10 a=dvHDv6DFvjYA:10 a=jEp0ucaQiEUA:10 a=WgwKcZQGGVUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184107.300621861@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Christian Kujau <lists@nerdbynature.de>,
        Josh Boyer <jwboyer@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [124/141] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0124-kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 637241a900cbd982f744d44646b48a273d609b34 ]

The dmesg_restrict sysctl currently covers the syslog method for access
dmesg, however /dev/kmsg isn't covered by the same protections.  Most
people haven't noticed because util-linux dmesg(1) defaults to using the
syslog method for access in older versions.  With util-linux dmesg(1)
defaults to reading directly from /dev/kmsg.

To fix /dev/kmsg, let's compare the existing interfaces and what they
allow:

 - /proc/kmsg allows:
  - open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructive
    single-reader interface (SYSLOG_ACTION_READ).
  - everything, after an open.

 - syslog syscall allows:
  - anything, if CAP_SYSLOG.
  - SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if
    dmesg_restrict==0.
  - nothing else (EPERM).

The use-cases were:
 - dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
 - sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
   destructive SYSLOG_ACTION_READs.

AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't
clear the ring buffer.

Based on the comments in devkmsg_llseek, it sounds like actions besides
reading aren't going to be supported by /dev/kmsg (i.e.
SYSLOG_ACTION_CLEAR), so we have a strict subset of the non-destructive
syslog syscall actions.

To this end, move the check as Josh had done, but also rename the
constants to reflect their new uses (SYSLOG_FROM_CALL becomes
SYSLOG_FROM_READER, and SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC).
SYSLOG_FROM_READER allows non-destructive actions, and SYSLOG_FROM_PROC
allows destructive actions after a capabilities-constrained
SYSLOG_ACTION_OPEN check.

 - /dev/kmsg allows:
  - open if CAP_SYSLOG or dmesg_restrict==0
  - reading/polling, after open

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=903192

[akpm@linux-foundation.org: use pr_warn_once()]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Josh Boyer <jwboyer@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/proc/kmsg.c         |   10 +++---
 include/linux/syslog.h |    4 +--
 kernel/printk.c        |   91 ++++++++++++++++++++++++++----------------------
 3 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index bd4b5a7..bdfabda 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
 }
 
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
 	return 0;
 }
 
@@ -34,15 +34,15 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	if ((file->f_flags & O_NONBLOCK) &&
-	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return -EAGAIN;
-	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_PROC);
 }
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 3891139..98a3153 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -44,8 +44,8 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
 
-#define SYSLOG_FROM_CALL 0
-#define SYSLOG_FROM_FILE 1
+#define SYSLOG_FROM_READER           0
+#define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..2d3fc0e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -362,6 +362,53 @@ static void log_store(int facility, int level,
 	log_next_seq++;
 }
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
+static int syslog_action_restricted(int type)
+{
+	if (dmesg_restrict)
+		return 1;
+	/*
+	 * Unless restricted, we allow "read all" and "get buffer size"
+	 * for everybody.
+	 */
+	return type != SYSLOG_ACTION_READ_ALL &&
+	       type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		return 0;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			return 0;
+		/*
+		 * For historical reasons, accept CAP_SYS_ADMIN too, with
+		 * a warning.
+		 */
+		if (capable(CAP_SYS_ADMIN)) {
+			pr_warn_once("%s (%d): Attempt to access syslog with "
+				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				     "(deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			return 0;
+		}
+		return -EPERM;
+	}
+	return security_syslog(type);
+}
+
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -618,7 +665,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
 	if (err)
 		return err;
 
@@ -794,45 +842,6 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
-
-static int syslog_action_restricted(int type)
-{
-	if (dmesg_restrict)
-		return 1;
-	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
-	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
-}
-
-static int check_syslog_permissions(int type, bool from_file)
-{
-	/*
-	 * If this is from /proc/kmsg and we've already opened it, then we've
-	 * already done the capabilities checks at open time.
-	 */
-	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
-
-	if (syslog_action_restricted(type)) {
-		if (capable(CAP_SYSLOG))
-			return 0;
-		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
-		if (capable(CAP_SYS_ADMIN)) {
-			printk_once(KERN_WARNING "%s (%d): "
-				 "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n",
-				 current->comm, task_pid_nr(current));
-			return 0;
-		}
-		return -EPERM;
-	}
-	return 0;
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -1229,7 +1238,7 @@ out:
 
 SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 {
-	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
+	return do_syslog(type, buf, len, SYSLOG_FROM_READER);
 }
 
 static bool __read_mostly ignore_loglevel;
-- 
1.7.10.4


