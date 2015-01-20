Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbbATNVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:21:18 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50220 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbbATNVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:21:13 -0500
To: sgrubb@redhat.com, rgb@redhat.com, linux-audit@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20141007213054.GJ26201@madcap2.tricolour.ca>
	<20150105180743.GI29998@madcap2.tricolour.ca>
	<201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp>
	<14076510.2zuEr3QEsx@x2>
In-Reply-To: <14076510.2zuEr3QEsx@x2>
Message-Id: <201501202220.DJJ34834.OLJOHFMQOFtSVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 20 Jan 2015 22:20:58 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs wrote:
> It also occurs to me that the pid_t of that process in init PID
> namespace would be useful for each entry.

Me too. I added it.

Steve Grubb wrote:
> > > As for the date-stamping bits, they seem to be the majority of the code
> > > in audit_update_history().  I'd just emit a number and punt that to
> > > userspace for decoding.  Alternatively, I'd use an existing service in
> > > the kernel to do that date formatting, or at least call a new function
> > > to format that date string should a suitable one not already exist, so
> > > you can remove that complexity from audit_update_history().
> > 
> > Since I don't know existing functions for date formatting,
> 
> All time in the audit system is "%lu.%03lu", t.tv_sec, t.tv_nsec/1000000. User 
> space tooling expects this.

What about printing uptime than current system clock for this record? Since
system clock changes during boot upon applying timezone setting, time stamp
within this record goes backwards. On the other hand, uptime does not go
backwards and can serve for knowing when the past execve() had been called.

Steve Grubb wrote:
> > This record contains multiple user-influenced comm names. If I use
> > audit_log_untrustedstring(), I would need to split this record into
> > multiple records like history[0]='...' history[1]='...' history[2]='...'
> > in order to avoid matching delimiters (i.e. ';', '=' and '>') used in
> > this record. 
> 
> That sounds like a good change to me. Audit records are always name=value with 
> a space between fields. We need this to always stay like this because the 
> tooling expects that format. There is nowhere in the audit logs we use =>.

Steve Grubb wrote:
> > This would also change from "char *" in "struct task_struct"
> > to array of struct { "comm name", "pid", "stamp" } in "struct task_struct".
> > I don't know whether such change makes easier to maintain than now.
> 
> You can still use char *, just use history[x]= to append with. We faced the 
> same issue regarding argv[] logging. You might look at the execve record 
> generation to get some ideas how that was handled.

Excuse me, but

Richard Guy Briggs wrote:
> This will end up producing a varying number of fields.  The userspace
> tools are looking for a constant number of fields per record type.

what does Richard's comment mean? We are using

   argc=$argc a0=$argv[0] a1=$argv[1] a2=$argv[2] ...

format for type=EXECVE record. Are the userspace tools really looking for
a constant number of fields per record type?

If the userspace tools are not looking for a constant number of fields
per record type, does Steve's comment suggest something like

  history_name[0]="swapper/0" history_pid[0]=1 history_start[0]=1.10
  history_name[1]="init" history_pid[1]=1 history_start[1]=1.50
  history_name[2]="systemd" history_pid[2]=1 history_start[2]=2.68
  history_name[3]="sshd" history_pid[3]=1210 history_start[3]=29.28
  history_name[4]="sshd" history_pid[4]=9185 history_start[4]=1609.00
  history_name[5]="bash" history_pid[5]=9187 history_start[5]=1611.63
  history_name[6]="tail" history_pid[6]=9230 history_start[6]=1616.51

than

  history="name=swapper/0;pid=1;start=1.10=>name=init;pid=1;start=1.50=>
  name=systemd;pid=1;start=2.68=>name=sshd;pid=1210;start=29.28=>name=sshd;
  pid=9185;start=1609.00=>name=bash;pid=9187;start=1611.63=>name=tail;
  pid=9230;start=1616.51"

for this record? This would indeed avoid => in the $value field, but
does this space-consuming format better than using => ?

Steve Grubb wrote:
> On Monday, January 12, 2015 03:13:12 PM Tetsuo Handa wrote:
> > Thank you for comments.
> > 
> > Richard Guy Briggs wrote:
> > > Steve already mentioned any user-influenced fields need to be escaped,
> > > so I'd recommend audit_log_untrustedstring() as being much simpler from
> > > your perspective and much better tested and understood from audit
> > > maintainer's perspective.  At least use the existing 'o' printf format
> > > specifier instead of inventing your own.  I do acknowledge that the
> > > resulting output from your function is easier to read in its raw format
> > > passed from the kernel, however, it makes your code harder to maintain.
> > 
> > I'm not sure whether I should use audit_log_untrustedstring().
> 
> That is the accepted encoding. We do not want 2 different kinds of encoding 
> functions.

Richard Guy Briggs wrote:
> This is where I would seperate them to:
> 
> 	audit_log_format(ab, "history=");
> 	audit_log_untrustedstring(ab, current->comm_history);

OK. I changed to use audit_log_untrustedstring(), though
audit_string_contains_control() is always false for this record because
I already escaped user-influenced comm name in order to keep the $value
field parsable.

Patch follows.
------------------------------------------------------------
>From 637299dfae899270f7b4b2fbae35af680d19704d Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 20 Jan 2015 13:13:39 +0900
Subject: [PATCH v2] audit: Emit history of thread's comm name.

When an unexpected system event (e.g. reboot) occurs, the administrator may
want to identify which application triggered the event. System call auditing
could be used for recording such event. However, the audit log may not be
able to provide sufficient information for identifying the application
because the audit log does not reflect how the program was executed.

This patch adds ability to trace how the program was executed and emit it
as an auxiliary record in the form of comm name, pid and uptime pairs as of
execve().

  type=UNKNOWN[1329] msg=audit(1421727157.228:5757): history="name=swapper/0;
  pid=1;start=1.10=>name=init;pid=1;start=1.50=>name=systemd;pid=1;start=2.68=>
  name=sshd;pid=1210;start=29.28=>name=sshd;pid=9185;start=1609.00=>name=bash;
  pid=9187;start=1611.63=>name=tail;pid=9230;start=1616.51"

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c                  |  1 +
 include/linux/audit.h      |  4 +++
 include/linux/init_task.h  |  5 +++
 include/linux/sched.h      |  3 ++
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             |  1 +
 kernel/auditsc.c           | 89 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 104 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index ad8798e..5e92651 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1200,6 +1200,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
 
+	audit_update_history();
 	/*
 	 * Disable monitoring for regular users
 	 * when executing setuid binaries. Must
diff --git a/include/linux/audit.h b/include/linux/audit.h
index af84234..74310a7 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -221,6 +221,8 @@ static inline void audit_ptrace(struct task_struct *t)
 		__audit_ptrace(t);
 }
 
+extern void audit_update_history(void);
+
 				/* Private API (for audit.c only) */
 extern unsigned int audit_serial(void);
 extern int auditsc_get_stamp(struct audit_context *ctx,
@@ -437,6 +439,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 { }
 static inline void audit_ptrace(struct task_struct *t)
 { }
+static inline void audit_update_history(void)
+{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 3037fc0..078823a 100644
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
 
 #ifdef CONFIG_PREEMPT_RCU
@@ -247,6 +251,7 @@ extern struct task_group root_task_group;
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
 	INIT_NUMA_BALANCING(tsk)					\
+	INIT_THREAD_HISTORY						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..77539e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1701,6 +1701,9 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+#ifdef CONFIG_AUDITSYSCALL
+	char *comm_history;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index d3475e1..93ad58c 100644
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
index 72ab759..d45397e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1154,6 +1154,7 @@ static int __init audit_init(void)
 {
 	int i;
 
+	audit_update_history();
 	if (audit_initialized == AUDIT_DISABLED)
 		return 0;
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 072566d..7a3d8f4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -88,6 +88,9 @@
 /* max length to print of cmdline/proctitle value during audit */
 #define MAX_PROCTITLE_AUDIT_LEN 128
 
+/* thread's comm name history length */
+#define COMM_HISTORY_SIZE 1024
+
 /* number of audit rules */
 int audit_n_rules;
 
@@ -945,6 +948,11 @@ int audit_alloc(struct task_struct *tsk)
 	enum audit_state     state;
 	char *key = NULL;
 
+	tsk->comm_history = kmemdup(current->comm_history, COMM_HISTORY_SIZE,
+				    GFP_KERNEL);
+	if (!tsk->comm_history)
+		return -ENOMEM;
+
 	if (likely(!audit_ever_enabled))
 		return 0; /* Return if not auditing. */
 
@@ -955,6 +963,8 @@ int audit_alloc(struct task_struct *tsk)
 	}
 
 	if (!(context = audit_alloc_context(state))) {
+		kfree(tsk->comm_history);
+		tsk->comm_history = NULL;
 		kfree(key);
 		audit_log_lost("out of memory in audit_alloc");
 		return -ENOMEM;
@@ -1344,6 +1354,18 @@ out:
 	audit_log_end(ab);
 }
 
+static void audit_log_history(struct audit_context *context)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PROCHISTORY);
+	if (!ab)
+		return;	/* audit_panic or being filtered */
+	audit_log_format(ab, "history=");
+	audit_log_untrustedstring(ab, current->comm_history);
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -1462,6 +1484,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	}
 
 	audit_log_proctitle(tsk, context);
+	audit_log_history(context);
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -1481,6 +1504,8 @@ void __audit_free(struct task_struct *tsk)
 {
 	struct audit_context *context;
 
+	kfree(tsk->comm_history);
+	tsk->comm_history = NULL;
 	context = audit_take_context(tsk, 0, 0);
 	if (!context)
 		return;
@@ -2535,3 +2560,67 @@ struct list_head *audit_killed_trees(void)
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
+	char *cp;
+	int pos;
+	int required;
+	char buf[256];
+	const unsigned long long now = nsec_to_clock_t(ktime_get_boot_ns());
+
+	/*
+	 * Lockless read because this is current thread and being unexpectedly
+	 * modified by other thread is not a fatal problem.
+	 */
+	cp = buf;
+	cp += snprintf(buf, sizeof(buf) - 1, "name=");
+	for (pos = 0; pos < TASK_COMM_LEN; pos++) {
+		const unsigned char c = current->comm[pos];
+
+		if (!c)
+			break;
+		if (isalnum(c) || c == '.' || c == '_' || c == '-' || c == '/')
+			cp += snprintf(cp, buf - cp + sizeof(buf) - 1, "%c",
+				       c);
+		else
+			cp += snprintf(cp, buf - cp + sizeof(buf) - 1,
+				       "\\%03o", c);
+	}
+	/* Append PID of init namespace. */
+	cp += snprintf(cp, buf - cp + sizeof(buf) - 1, ";pid=%u",
+		       current->pid);
+	/* Append uptime. */
+	cp += snprintf(cp, buf - cp + sizeof(buf) - 1, ";start=%llu.%02llu",
+		       now / 100, now % 100);
+	/* Terminate the buffer. */
+	if (cp >= buf + sizeof(buf))
+		cp = buf + sizeof(buf) - 1;
+	*cp = '\0';
+	required = cp - buf;
+	/* Make some room by truncating old history. */
+	cp = current->comm_history;
+	pos = strlen(cp);
+	while (pos + required >= COMM_HISTORY_SIZE - 10) {
+		char *cp2 = memchr(cp, '>', pos) + 1;
+
+		pos -= cp2 - cp;
+		memmove(cp, cp2, pos + 1);
+	}
+	/* Emit the buffer. */
+	if (pos)
+		sprintf(cp + pos, "=>%s", buf);
+	else
+		sprintf(cp, "%s", buf);
+}
-- 
1.8.3.1
