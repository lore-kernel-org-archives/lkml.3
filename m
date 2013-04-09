Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936916Ab3DIPsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898Ab3DIPs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:48:29 -0400
Date: Tue, 9 Apr 2013 11:48:21 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130409154820.GE32476@hansolo.jdub.homelinux.org>
References: <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
 <1361998001.2110.22.camel@localhost>
 <20130227221954.GJ2071@hansolo.jdub.homelinux.org>
 <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
 <20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
 <20130322221444.GJ15821@hansolo.jdub.homelinux.org>
 <CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
 <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
 <CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
 <20130409005050.GE18176@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409005050.GE18176@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmesg_restrict sysctl currently covers the syslog method for access
dmesg, however /dev/kmsg isn't covered by the same protections.  Most
people haven't noticed because util-linux dmesg(1) defaults to using the
syslog method for access in older versions.  With util-linux dmesg(1)
defaults to reading directly from /dev/kmsg.

Fix this by reworking all of the access methods to use the
check_syslog_permissions function and adding checks to devkmsg_open and
devkmsg_read.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192

Reported-by: Christian Kujau <lists@nerdbynature.de>
CC: stable@vger.kernel.org
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

 v2: Rework patch based on code from Eric Paris, add check in devkmsg_read as
     suggested by Kees Cook.

 kernel/printk.c | 91 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 47 insertions(+), 44 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index abbdd9e..5541095 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -368,6 +368,46 @@ static void log_store(int facility, int level,
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
+	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
+	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		goto ok;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			goto ok;
+		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
+		if (capable(CAP_SYS_ADMIN)) {
+			printk_once(KERN_WARNING "%s (%d): "
+				 "Attempt to access syslog with CAP_SYS_ADMIN "
+				 "but no CAP_SYSLOG (deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			goto ok;
+		}
+		return -EPERM;
+	}
+ok:
+	return security_syslog(type);
+}
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -443,10 +483,16 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	char cont = '-';
 	size_t len;
 	ssize_t ret;
+	int err;
 
 	if (!user)
 		return -EBADF;
 
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+		SYSLOG_FROM_FILE);
+	if (err)
+		return err;
+
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
@@ -624,7 +670,7 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_OPEN, SYSLOG_FROM_FILE);
 	if (err)
 		return err;
 
@@ -817,45 +863,6 @@ static inline void boot_delay_msec(int level)
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
@@ -1131,10 +1138,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	if (error)
 		goto out;
 
-	error = security_syslog(type);
-	if (error)
-		return error;
-
 	switch (type) {
 	case SYSLOG_ACTION_CLOSE:	/* Close log */
 		break;
-- 
1.8.1.4

