Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaJJMkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:40:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:30794 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaJJMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:40:22 -0400
To: rgb@redhat.com, sgrubb@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201406262040.BGC30243.FFMLHOVQOOFSJt@I-love.SAKURA.ne.jp>
	<201409271002.JAH52667.FtSOOHOQLFFMJV@I-love.SAKURA.ne.jp>
	<20140927091440.6fe54f43@ivy-bridge>
	<201409280012.FGE05239.VtFOSMOJFOFQLH@I-love.SAKURA.ne.jp>
	<20141007213054.GJ26201@madcap2.tricolour.ca>
In-Reply-To: <20141007213054.GJ26201@madcap2.tricolour.ca>
Message-Id: <201410102140.HHB30768.tFVJSFQOMLOOFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 10 Oct 2014 21:40:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Grubb wrote:
> Hello,
> 
> On Sun, 28 Sep 2014 00:13:14 +0900
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > Steve Grubb wrote:
> > > On Sat, 27 Sep 2014 10:02:44 +0900
> > > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > > 
> > > > May I continue proposing this functionality?
> > > 
> > > From the audit perspective, sure. I think we were expecting a
> > > revised patch after the comments. Other groups may have different
> > > thoughts, though.
> > > 
> > > -Steve
> > 
> > OK, thank you. Before posting a revised patch, can I hear answers
> > about specification questions listed below?
> 
> Sure.
> 
> > (Q1) Where can I find which bytes in $value need to be escaped when
> >      emitting a record like name='$value' ?
> 
> I have written a specification that describes how to write well formed
> audit events to help with questions like this. You can find it here:
> 
> http://people.redhat.com/sgrubb/audit/audit-events.txt
> 
> If you know that a field is under user control, it must be escaped so
> that they cannot try to trick the parser.
> 
> > Is 0x20 in $value permitted?
> 
> No. That is the separator between fields, so it cannot be allowed. What
> we suggest is to use a dash or hyphen between if you are logging a
> phrase that cannot be altered by the user. For example, you may have an
> op field saying it deleted a rule. You would do it as op=rule-deleted.
> However, we do not suggest that for user controlled fields. Just escape
> it by calling audit_log_untrustedstring() if in the kernel. There are
> examples in the page I mention above.
> 
> > (Q2) Does auxiliary record work with only type=SYSCALL case?
> 
> Auxiliary records compliment a syscall record by adding extra
> information. PATH, IPC, CWD, and EXECVE are some examples. They get
> emitted in audit_log_exit() if you wanted to look at them in more
> detail.
> 
> HTH...

Richard Guy Briggs wrote:
> On 14/09/28, Tetsuo Handa wrote:
> > (Q2) Does auxiliary record work with only type=SYSCALL case?
> 
> Auxiliary records don't work with AUDIT_LOGIN because that record has a
> NULL context.  Similarly for core dumps (AUDIT_ANOM_ABEND), AUDIT_SECCOMP,
> configuration changes (AUDIT_CONFIG_CHANGE, AUDIT_FEATURE_CHANGE), most
> (all?) AUDIT_USER_* messages.
> 
I see, thank you.

Although I feel that, from the point of view of troubleshooting, emitting
history of thread's comm name into NULL-context records would help sysadmin
to map login session and operations a user did from that login session,
I'm OK with starting history of thread's comm name as auxiliary records
(i.e. not emitted into NULL-context records).

Adding LKML for reviewers. What else can I do for merging this patch?
----------
>From 2beb93e870e9c1a6391d8706aa84a608b8353c2a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 28 Sep 2014 19:20:16 +0900
Subject: [PATCH] audit: Emit history of thread's comm name.

When an unexpected system event (e.g. reboot) occurs, the administrator may
want to identify which application triggered the event. System call auditing
could be used for recording such event. However, the audit log may not be
able to provide sufficient information for identifying the application
because the audit log does not reflect how the program was executed.

This patch adds ability to trace how the program was executed and emit it
as an auxiliary record in the form of comm name and time stamp pairs as of
execve().

  type=UNKNOWN[1329] msg=audit(1403741314.019:22): history='
  swapper/0(2014/06/26-09:06:04)=>init(2014/06/26-09:06:10)=>
  switch_root(2014/06/26-09:06:13)=>init(2014/06/26-09:06:13)=>
  sh(2014/06/26-00:06:27)=>rc(2014/06/26-00:06:27)=>
  S55sshd(2014/06/26-00:06:35)=>sshd(2014/06/26-00:06:35)=>
  sshd(2014/06/26-00:06:40)=>bash(2014/06/26-00:06:43)=>
  tail(2014/06/26-00:08:34)'

Note that only char < 0x21, char > 0x7e, '\'', '\\' and '=' are escaped
using \ooo style octal value rather than converting all characters to XX
style hexadecimal value.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c                  |    1 +
 include/linux/audit.h      |    4 ++
 include/linux/init_task.h  |    5 ++
 include/linux/sched.h      |    3 +
 include/uapi/linux/audit.h |    1 +
 kernel/audit.c             |    1 +
 kernel/auditsc.c           |  113 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a2b42a9..1e81709 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1191,6 +1191,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
 
+	audit_update_history();
 	/*
 	 * Disable monitoring for regular users
 	 * when executing setuid binaries. Must
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb..97d08e1 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -206,6 +206,8 @@ static inline void audit_ptrace(struct task_struct *t)
 		__audit_ptrace(t);
 }
 
+extern void audit_update_history(void);
+
 				/* Private API (for audit.c only) */
 extern unsigned int audit_serial(void);
 extern int auditsc_get_stamp(struct audit_context *ctx,
@@ -419,6 +421,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 { }
 static inline void audit_ptrace(struct task_struct *t)
 { }
+static inline void audit_update_history(void)
+{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 2bb4c4f..7a5695b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -98,8 +98,12 @@ extern struct group_info init_groups;
 #define INIT_IDS \
 	.loginuid = INVALID_UID, \
 	.sessionid = (unsigned int)-1,
+extern char init_task_history[];
+#define INIT_THREAD_HISTORY		\
+	.comm_history = init_task_history,
 #else
 #define INIT_IDS
+#define INIT_THREAD_HISTORY
 #endif
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -227,6 +231,7 @@ extern struct task_group root_task_group;
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
+	INIT_THREAD_HISTORY						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b867a4d..fd3cdaf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1644,6 +1644,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_AUDITSYSCALL
+	char *comm_history;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 3b9ff33..a6a8ee8 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -110,6 +110,7 @@
 #define AUDIT_SECCOMP		1326	/* Secure Computing event */
 #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
+#define AUDIT_PROCHISTORY	1329	/* Commname history emit event */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index ba2ff5a..252544a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1163,6 +1163,7 @@ static int __init audit_init(void)
 {
 	int i;
 
+	audit_update_history();
 	if (audit_initialized == AUDIT_DISABLED)
 		return 0;
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 21eae3c..2e5ee14 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -85,6 +85,9 @@
 /* max length to print of cmdline/proctitle value during audit */
 #define MAX_PROCTITLE_AUDIT_LEN 128
 
+/* thread's comm name history length */
+#define COMM_HISTORY_SIZE 1024
+
 /* number of audit rules */
 int audit_n_rules;
 
@@ -950,6 +953,11 @@ int audit_alloc(struct task_struct *tsk)
 	enum audit_state     state;
 	char *key = NULL;
 
+	tsk->comm_history = kmemdup(current->comm_history, COMM_HISTORY_SIZE,
+				    GFP_KERNEL);
+	if (!tsk->comm_history)
+		return -ENOMEM;
+
 	if (likely(!audit_ever_enabled))
 		return 0; /* Return if not auditing. */
 
@@ -960,6 +968,8 @@ int audit_alloc(struct task_struct *tsk)
 	}
 
 	if (!(context = audit_alloc_context(state))) {
+		kfree(tsk->comm_history);
+		tsk->comm_history = NULL;
 		kfree(key);
 		audit_log_lost("out of memory in audit_alloc");
 		return -ENOMEM;
@@ -1349,6 +1359,17 @@ out:
 	audit_log_end(ab);
 }
 
+static void audit_log_history(struct audit_context *context)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PROCHISTORY);
+	if (!ab)
+		return;	/* audit_panic or being filtered */
+	audit_log_format(ab, "history='%s'", current->comm_history);
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -1467,6 +1488,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	}
 
 	audit_log_proctitle(tsk, context);
+	audit_log_history(context);
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -1486,6 +1508,8 @@ void __audit_free(struct task_struct *tsk)
 {
 	struct audit_context *context;
 
+	kfree(tsk->comm_history);
+	tsk->comm_history = NULL;
 	context = audit_take_context(tsk, 0, 0);
 	if (!context)
 		return;
@@ -2503,3 +2527,92 @@ struct list_head *audit_killed_trees(void)
 		return NULL;
 	return &ctx->killed_trees;
 }
+
+char init_task_history[COMM_HISTORY_SIZE];
+
+/**
+ * audit_update_history - Update current->comm_history field.
+ *
+ * Returns nothing.
+ *
+ * Update is done locklessly because current thread's history is updated by
+ * only current thread upon boot up and successful execve() operation, and
+ * we don't read other thread's history.
+ */
+void audit_update_history(void)
+{
+	static const u16 eom[2][12] = {
+		{ 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
+		{ 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
+	};
+	u16 year = 1970;
+	u16 day;
+	u8 month;
+	u8 hour;
+	u8 minute;
+	u8 second;
+	bool r;
+	time_t now = get_seconds();
+	char *history = current->comm_history;
+	int pos = strlen(history);
+
+	/* Make some room by truncating old history. */
+	while (pos >= COMM_HISTORY_SIZE - (TASK_COMM_LEN * 4 + 30)) {
+		char *cp = strchr(history + 1, '=');
+
+		if (unlikely(!cp))
+			return;
+		pos -= cp - history;
+		memmove(history, cp, pos + 1);
+	}
+	if (pos) {
+		history += pos;
+		*history++ = '=';
+		*history++ = '>';
+	}
+	/*
+	 * Read locklessly because this is current thread and being
+	 * unexpectedly modified by other thread is not a fatal problem.
+	 */
+	for (pos = 0; pos < TASK_COMM_LEN; pos++) {
+		const unsigned char c = current->comm[pos];
+
+		if (!c)
+			break;
+		else if (c == '\'' || c == '\\' || c == '=' || c < 0x21 ||
+			 c > 0x7e) {
+			*history++ = '\\';
+			*history++ = (c >> 6) + '0';
+			*history++ = ((c >> 3) & 7) + '0';
+			*history++ = (c & 7) + '0';
+		} else
+			*history++ = c;
+	}
+	/* Append current time in "(YYYY/MM/DD-hh:mm:ss)" format. */
+	second = now % 60;
+	now /= 60;
+	minute = now % 60;
+	now /= 60;
+	hour = now % 24;
+	day = now / 24;
+	if (day >= 16071) {
+		/* Start from 2014/01/01 rather than 1970/01/01. */
+		day -= 16071;
+		year += 44;
+	}
+	while (1) {
+		const u16 days = (year & 3) ? 365 : 366;
+
+		if (day < days)
+			break;
+		day -= days;
+		year++;
+	}
+	r = (year & 3) == 0;
+	for (month = 0; month < 11 && day >= eom[r][month]; month++)
+		;
+	if (month)
+		day -= eom[r][month - 1];
+	snprintf(history, 22, "(%04u/%02u/%02u-%02u:%02u:%02u)", year,
+		 month + 1, day + 1, hour, minute, second);
+}
-- 
1.7.1
