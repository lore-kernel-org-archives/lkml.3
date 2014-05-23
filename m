Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaEWMpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:45:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:44531 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaEWMov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:44:51 -0400
X-Nat-Received: from [202.181.97.72]:55953 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400849083.23308
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] TaskTracker : Simplified thread information tracker.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201405232144.JFB30480.OVMOOSFtQJHLFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 23 May 2014 21:44:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 23052014 #7986981, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday I went to LinuxCon Japan 2014 and stopped at Red Hat's booth
and Oracle's booth. I explained about this module ( using page 92 of
http://I-love.SAKURA.ne.jp/tomoyo/LCJ2014-en.pdf ) and got positive
responses from persons who have experienced troubleshooting jobs.
I was convinced that I am not the only person who is bothered by lack of
process history information in the logs. Therefore, I repost this module
toward inclusion into mainline Linux kernel.

Changes from previous version ( http://lwn.net/Articles/575044/ ):

  (1) Assign a value to "u32 *seclen" in addition to "char *secdata"
      at security_task_getsecid() hook.

  (2) Make calculation of time stamp a bit faster.

Background:

  When an unexpected system event (e.g. reboot) occurs, the administrator may
  want to identify which application triggered the event. System call auditing
  could be used for recording such event. However, the audit log may not be
  able to provide sufficient information for identifying the application
  because the audit log does not reflect how the program was executed.

  I sometimes receive "which application triggered the event" questions on RHEL
  systems. TOMOYO security module can track how the program was executed, but
  TOMOYO is not yet available in Fedora/RHEL distributions.

  Although subj= field is added to the audit log if SELinux is not disabled,
  SELinux is too difficult to customize as fine grained as I expect in order to
  reflect how the program was executed. Therefore, I'm currently using AKARI
  and SystemTap for emulating TOMOYO-like tracing.

  But AKARI and SystemTap do not help unless the kernel module is loaded before
  the unexpected system event occurs. Generally, the administrator is failing
  to record the first event, and has to wait for the same event to occur again
  after loading the kernel module and/or configuring auditing. I came to think
  that we want a built-in kernel routine which is automatically started upon
  boot so that we don't fail to record the first event.

What I did:

  Assuming that multiple concurrent LSM support comes in the near future,
  I wrote a trivial LSM module which emits TOMOYO-like information into the
  audit logs.

Usage:

  Just register this LSM module. No configuration is needed. You will get
  history of current thread in the form of comm name and time stamp pairs
  in the subj= field of audit logs like examples shown in the patch
  description.
----------
>From ff68d3a4cd496bd263d2939848777fffc30cbc0b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 23 May 2014 21:31:56 +0900
Subject: [PATCH] TaskTracker : Simplified thread information tracker.

Existing audit logs generated via system call auditing functionality include
current thread's comm name. But it is not always sufficient for identifying
which application has requested specific operations because comm name does not
reflect history of current thread.

This security module adds functionality for adding current thread's history
information like TOMOYO security module does, expecting that this module can
help us getting more information from system call auditing functionality.

  type=USER_LOGIN msg=audit(1400879947.084:24): pid=4308 uid=0 auid=0 ses=2
  subj="swapper/0(2014/05/23-21:17:30)=>init(2014/05/23-21:17:33)=>
  switch_root(2014/05/23-21:17:34)=>init(2014/05/23-21:17:34)=>
  sh(2014/05/23-21:17:56)=>mingetty(2014/05/23-21:17:56)=>
  login(2014/05/23-21:19:05)" msg='op=login id=0 exe="/bin/login" hostname=?
  addr=? terminal=tty1 res=success'

  type=SYSCALL msg=audit(1400880014.444:26): arch=40000003 syscall=11
  success=yes exit=0 a0=8140f78 a1=812b7d8 a2=812b248 a3=812b7d8 items=2
  ppid=4323 pid=4355 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
  fsgid=0 tty=pts0 ses=1 comm="tail" exe="/usr/bin/tail"
  subj="swapper/0(2014/05/23-21:17:30)=>init(2014/05/23-21:17:33)=>
  switch_root(2014/05/23-21:17:34)=>init(2014/05/23-21:17:34)=>
  sh(2014/05/23-21:17:37)=>rc(2014/05/23-21:17:37)=>
  S55sshd(2014/05/23-21:17:53)=>sshd(2014/05/23-21:17:53)=>
  sshd(2014/05/23-21:18:17)=>bash(2014/05/23-21:18:21)=>
  tail(2014/05/23-21:20:14)" key=(null)

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig                   |    6 +
 security/Makefile                  |    2 +
 security/tasktracker/Kconfig       |   35 +++++
 security/tasktracker/Makefile      |    1 +
 security/tasktracker/tasktracker.c |  282 ++++++++++++++++++++++++++++++++++++
 5 files changed, 326 insertions(+), 0 deletions(-)
 create mode 100644 security/tasktracker/Kconfig
 create mode 100644 security/tasktracker/Makefile
 create mode 100644 security/tasktracker/tasktracker.c

diff --git a/security/Kconfig b/security/Kconfig
index beb86b5..14e7d27 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -122,6 +122,7 @@ source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/yama/Kconfig
+source security/tasktracker/Kconfig
 
 source security/integrity/Kconfig
 
@@ -132,6 +133,7 @@ choice
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
 	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
+	default DEFAULT_SECURITY_TT if SECURITY_TT
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -153,6 +155,9 @@ choice
 	config DEFAULT_SECURITY_YAMA
 		bool "Yama" if SECURITY_YAMA=y
 
+	config DEFAULT_SECURITY_TT
+		bool "TaskTracker" if SECURITY_TT=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -165,6 +170,7 @@ config DEFAULT_SECURITY
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
 	default "yama" if DEFAULT_SECURITY_YAMA
+	default "tt" if DEFAULT_SECURITY_TT
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index 05f1c93..28a90ed 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -8,6 +8,7 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
+subdir-$(CONFIG_SECURITY_TT)		+= tasktracker
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -22,6 +23,7 @@ obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
+obj-$(CONFIG_SECURITY_TT)		+= tasktracker/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/tasktracker/Kconfig b/security/tasktracker/Kconfig
new file mode 100644
index 0000000..6de5354
--- /dev/null
+++ b/security/tasktracker/Kconfig
@@ -0,0 +1,35 @@
+config SECURITY_TT
+	bool "TaskTracker support"
+	depends on SECURITY
+	default n
+	help
+	  Existing audit logs generated via system call auditing functionality
+	  include current thread's comm name. But it is not always sufficient
+	  for identifying which application has requested specific operations
+	  because comm name does not reflect history of current thread.
+	  
+	  This security module adds functionality for adding current thread's
+	  history information like TOMOYO security module does, expecting that
+	  this module can help us getting more information from system call
+	  auditing functionality.
+	  
+	  If you are unsure how to answer this question, answer N.
+	  
+	  Usage:
+	  
+	  Just register this module. No configuration is needed.
+	  
+	  You will get history of current thread in the form of
+	  comm name and time stamp pairs in the subj= field of audit logs
+	  like an example shown below.
+	  
+	    type=SYSCALL msg=audit(1400880014.444:26): arch=40000003 syscall=11
+	    success=yes exit=0 a0=8140f78 a1=812b7d8 a2=812b248 a3=812b7d8
+	    items=2 ppid=4323 pid=4355 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0
+	    egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="tail"
+	    exe="/usr/bin/tail" subj="swapper/0(2014/05/23-21:17:30)=>
+	    init(2014/05/23-21:17:33)=>switch_root(2014/05/23-21:17:34)=>
+	    init(2014/05/23-21:17:34)=>sh(2014/05/23-21:17:37)=>
+	    rc(2014/05/23-21:17:37)=>S55sshd(2014/05/23-21:17:53)=>
+	    sshd(2014/05/23-21:17:53)=>sshd(2014/05/23-21:18:17)=>
+	    bash(2014/05/23-21:18:21)=>tail(2014/05/23-21:20:14)" key=(null)
diff --git a/security/tasktracker/Makefile b/security/tasktracker/Makefile
new file mode 100644
index 0000000..15d03ce
--- /dev/null
+++ b/security/tasktracker/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SECURITY_TT) := tasktracker.o
diff --git a/security/tasktracker/tasktracker.c b/security/tasktracker/tasktracker.c
new file mode 100644
index 0000000..ec4eb0c
--- /dev/null
+++ b/security/tasktracker/tasktracker.c
@@ -0,0 +1,282 @@
+/*
+ * tasktracker.c - Simplified thread information tracker.
+ *
+ * Copyright (C) 2010-2014  Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
+ */
+#include <linux/security.h>
+#include <linux/binfmts.h>
+
+/* Wrapper structure for passing string buffer. */
+struct tt_record {
+	char history[1024];
+};
+
+/* Structure for representing YYYY/MM/DD hh/mm/ss. */
+struct tt_time {
+	u16 year;
+	u8 month;
+	u8 day;
+	u8 hour;
+	u8 min;
+	u8 sec;
+};
+
+/**
+ * tt_get_time - Get current time in YYYY/MM/DD hh/mm/ss format.
+ *
+ * @stamp: Pointer to "struct tt_time".
+ *
+ * Returns nothing.
+ *
+ * This function does not handle Y2038 problem.
+ */
+static void tt_get_time(struct tt_time *stamp)
+{
+	struct timeval tv;
+	static const u16 tt_eom[2][12] = {
+		{ 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
+		{ 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
+	};
+	u16 y = 1970;
+	u8 m;
+	bool r;
+	time_t time;
+	do_gettimeofday(&tv);
+	time = tv.tv_sec;
+	stamp->sec = time % 60;
+	time /= 60;
+	stamp->min = time % 60;
+	time /= 60;
+	stamp->hour = time % 24;
+	time /= 24;
+	if (time >= 16071) {
+		/* Start from 2014/01/01 rather than 1970/01/01. */
+		time -= 16071;
+		y += 44;
+	}
+	while (1) {
+		const unsigned short days = (y & 3) ? 365 : 366;
+		if (time < days)
+			break;
+		time -= days;
+		y++;
+	}
+	r = (y & 3) == 0;
+	for (m = 0; m < 11 && time >= tt_eom[r][m]; m++)
+		;
+	if (m)
+		time -= tt_eom[r][m - 1];
+	stamp->year = y;
+	stamp->month = ++m;
+	stamp->day = ++time;
+}
+
+/**
+ * tt_update_record - Update "struct tt_record" for given credential.
+ *
+ * @record: Pointer to "struct tt_record".
+ *
+ * Returns nothing.
+ */
+static void tt_update_record(struct tt_record *record)
+{
+	char *cp;
+	int i;
+	struct tt_time stamp;
+	tt_get_time(&stamp);
+	/*
+	 * Lockless update because current thread's record is not concurrently
+	 * accessible, for "struct cred"->security is not visible from other
+	 * threads because this function is called upon only boot up and
+	 * successful execve() operation.
+	 */
+	cp = record->history;
+	i = strlen(cp);
+	while (i >= sizeof(record->history) - (TASK_COMM_LEN * 4 + 30)) {
+		/*
+		 * Since this record is not for making security decision,
+		 * I don't care by-chance matching "=>" in task's commname.
+		 */
+		char *cp2 = strstr(cp + 2, "=>");
+		if (!cp2)
+			return;
+		memmove(cp + 1, cp2, strlen(cp2) + 1);
+		i = strlen(cp);
+	}
+	if (!i)
+		*cp++ = '"';
+	else {
+		cp += i - 1;
+		*cp++ = '=';
+		*cp++ = '>';
+	}
+	/*
+	 * Lockless read because this is current thread and being unexpectedly
+	 * modified by other thread is not a fatal problem.
+	 */
+	for (i = 0; i < TASK_COMM_LEN; i++) {
+		const unsigned char c = current->comm[i];
+		if (!c)
+			break;
+		else if (c == '"' || c == '\\' || c < 0x21 || c > 0x7e) {
+			*cp++ = '\\';
+			*cp++ = (c >> 6) + '0';
+			*cp++ = ((c >> 3) & 7) + '0';
+			*cp++ = (c & 7) + '0';
+		} else
+			*cp++ = c;
+	}
+	sprintf(cp, "(%04u/%02u/%02u-%02u:%02u:%02u)\"", stamp.year,
+		stamp.month, stamp.day, stamp.hour, stamp.min, stamp.sec);
+}
+
+/**
+ * tt_find_record - Find "struct tt_record" for given credential.
+ *
+ * @cred: Pointer to "struct cred".
+ *
+ * Returns pointer to "struct tt_record".
+ */
+static inline struct tt_record *tt_find_record(const struct cred *cred)
+{
+	return cred->security;
+}
+
+/**
+ * tt_cred_alloc_blank - Allocate memory for new credentials.
+ *
+ * @new: Pointer to "struct cred".
+ * @gfp: Memory allocation flags.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int tt_cred_alloc_blank(struct cred *new, gfp_t gfp)
+{
+	new->security = kzalloc(sizeof(struct tt_record), gfp);
+	return new->security ? 0 : -ENOMEM;
+}
+
+/**
+ * tt_cred_prepare - Allocate memory for new credentials.
+ *
+ * @new: Pointer to "struct cred".
+ * @old: Pointer to "struct cred".
+ * @gfp: Memory allocation flags.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int tt_cred_prepare(struct cred *new, const struct cred *old,
+			   gfp_t gfp)
+{
+	if (tt_cred_alloc_blank(new, gfp))
+		return -ENOMEM;
+	strcpy(tt_find_record(new)->history, tt_find_record(old)->history);
+	return 0;
+}
+
+/**
+ * tt_cred_free - Release memory used by credentials.
+ *
+ * @cred: Pointer to "struct cred".
+ *
+ * Returns nothing.
+ */
+static void tt_cred_free(struct cred *cred)
+{
+	kfree(cred->security);
+}
+
+/**
+ * tt_cred_transfer - Transfer "struct tt_record" between credentials.
+ *
+ * @new: Pointer to "struct cred".
+ * @old: Pointer to "struct cred".
+ *
+ * Returns nothing.
+ */
+static void tt_cred_transfer(struct cred *new, const struct cred *old)
+{
+	strcpy(tt_find_record(new)->history, tt_find_record(old)->history);
+}
+
+/**
+ * tt_bprm_committing_creds - A hook which is called when do_execve() succeeded.
+ *
+ * @bprm: Pointer to "struct linux_binprm".
+ *
+ * Returns nothing.
+ */
+static void tt_bprm_committing_creds(struct linux_binprm *bprm)
+{
+	tt_update_record(tt_find_record(bprm->cred));
+}
+
+/**
+ * tt_task_getsecid - Check whether to audit or not.
+ *
+ * @p:     Pointer to "struct task_struct".
+ * @secid: Pointer to flag.
+ */
+static void tt_task_getsecid(struct task_struct *p, u32 *secid)
+{
+	*secid = (p == current);
+}
+
+/**
+ * tt_secid_to_secctx - Allocate memory used for auditing.
+ *
+ * @secid:   Bool flag to allocate.
+ * @secdata: Pointer to allocate memory.
+ * @seclen:  Size of allocated memory.
+ *
+ * Returns 0 on success, -EINVAL otherwise.
+ */
+static int tt_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+{
+	struct tt_record *record;
+	/* Ignore unless current thread's record is requested. */
+	if (secid != 1)
+		return -EINVAL;
+	/*
+	 * We don't need to duplicate the string because current thread's
+	 * record is updated upon only boot up and successful execve()
+	 * operation, even if current thread's record is shared between
+	 * multiple threads.
+	 */
+	record = tt_find_record(current->real_cred);
+	*secdata = record->history;
+	*seclen = strlen(record->history);
+	return 0;
+}
+
+/* List of hooks. */
+static struct security_operations tasktracker_ops = {
+	.name                  = "tt",
+	.secid_to_secctx       = tt_secid_to_secctx,
+	.task_getsecid         = tt_task_getsecid,
+	.cred_prepare          = tt_cred_prepare,
+	.cred_free             = tt_cred_free,
+	.cred_alloc_blank      = tt_cred_alloc_blank,
+	.cred_transfer         = tt_cred_transfer,
+	.bprm_committing_creds = tt_bprm_committing_creds,
+};
+
+/**
+ * tt_init - Initialize this module.
+ *
+ * Returns 0 on success, panic otherwise.
+ */
+static int __init tt_init(void)
+{
+	struct cred *cred = (struct cred *) current_cred();
+	if (!security_module_enable(&tasktracker_ops))
+		return 0;
+	if (tt_cred_alloc_blank(cred, GFP_ATOMIC) ||
+	    register_security(&tasktracker_ops))
+		panic("Failure registering TaskTracker");
+	tt_update_record(tt_find_record(cred));
+	pr_info("TaskTracker initialized\n");
+	return 0;
+}
+
+security_initcall(tt_init);
-- 
1.7.1
