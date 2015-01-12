Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbbALPOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbbALPOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:14:40 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rgb@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
Date: Mon, 12 Jan 2015 10:14:34 -0500
Message-ID: <14076510.2zuEr3QEsx@x2>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.17.7-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp>
References: <20141007213054.GJ26201@madcap2.tricolour.ca> <20150105180743.GI29998@madcap2.tricolour.ca> <201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2015 03:13:12 PM Tetsuo Handa wrote:
> Thank you for comments.
> 
> Richard Guy Briggs wrote:
> > Steve already mentioned any user-influenced fields need to be escaped,
> > so I'd recommend audit_log_untrustedstring() as being much simpler from
> > your perspective and much better tested and understood from audit
> > maintainer's perspective.  At least use the existing 'o' printf format
> > specifier instead of inventing your own.  I do acknowledge that the
> > resulting output from your function is easier to read in its raw format
> > passed from the kernel, however, it makes your code harder to maintain.
> 
> I'm not sure whether I should use audit_log_untrustedstring().

That is the accepted encoding. We do not want 2 different kinds of encoding 
functions.

> This record contains multiple user-influenced comm names. If I use
> audit_log_untrustedstring(), I would need to split this record into
> multiple records like history[0]='...' history[1]='...' history[2]='...'
> in order to avoid matching delimiters (i.e. ';', '=' and '>') used in
> this record. 

That sounds like a good change to me. Audit records are always name=value with 
a space between fields. We need this to always stay like this because the 
tooling expects that format. There is nowhere in the audit logs we use =>.


> This would also change from "char *" in "struct task_struct"
> to array of struct { "comm name", "pid", "stamp" } in "struct task_struct".
> I don't know whether such change makes easier to maintain than now.

You can still use char *, just use history[x]= to append with. We faced the 
same issue regarding argv[] logging. You might look at the execve record 
generation to get some ideas how that was handled.


> > As for the date-stamping bits, they seem to be the majority of the code
> > in audit_update_history().  I'd just emit a number and punt that to
> > userspace for decoding.  Alternatively, I'd use an existing service in
> > the kernel to do that date formatting, or at least call a new function
> > to format that date string should a suitable one not already exist, so
> > you can remove that complexity from audit_update_history().
> 
> Since I don't know existing functions for date formatting,

All time in the audit system is "%lu.%03lu", t.tv_sec, t.tv_nsec/1000000. User 
space tooling expects this.

-Steve


> I split it as a new function. If it is acceptable, I'd like to make that
> function public and replace tomoyo_convert_time() in security/tomoyo/util.c
> with that function.
> 
> Regards.
> ----------------------------------------
> 
> >From 50d59b5640a7501b8d5f843fb57283fcb62b1118 Mon Sep 17 00:00:00 2001
> 
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 12 Jan 2015 14:45:23 +0900
> Subject: [PATCH] audit: Emit history of thread's comm name.
> 
> When an unexpected system event (e.g. reboot) occurs, the administrator may
> want to identify which application triggered the event. System call auditing
> could be used for recording such event. However, the audit log may not be
> able to provide sufficient information for identifying the application
> because the audit log does not reflect how the program was executed.
> 
> This patch adds ability to trace how the program was executed and emit it
> as an auxiliary record in the form of comm name, pid and time stamp pairs
> as of execve().
> 
>   type=UNKNOWN[1329] msg=audit(1421039813.810:3693): history='
>   name=swapper\0570;pid=1;start=20150112140720=>name=init;pid=1;
>   start=20150112140721=>name=systemd;pid=1;start=20150112140722=>
>   name=sshd;pid=2473;start=20150112050733=>name=sshd;pid=9838;
>   start=20150112051105=>name=bash;pid=9840;start=20150112051108=>
>   name=tail;pid=9876;start=20150112051653'
> 
> Since converting all bytes using audit_log_untrustedstring() makes this
> record unparsable because this record includes multiple user-influenced
> comm names which may match delimiters used in this record (i.e. ';', '='
> and '>'), only bytes which are not alphabets, numbers, '.', '_' nor '-' are
> escaped.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/exec.c                  |   1 +
>  include/linux/audit.h      |   4 ++
>  include/linux/init_task.h  |   5 ++
>  include/linux/sched.h      |   3 +
>  include/uapi/linux/audit.h |   1 +
>  kernel/audit.c             |   1 +
>  kernel/auditsc.c           | 155
> +++++++++++++++++++++++++++++++++++++++++++++ 7 files changed, 170
> insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ad8798e..5e92651 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1200,6 +1200,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>  	commit_creds(bprm->cred);
>  	bprm->cred = NULL;
> 
> +	audit_update_history();
>  	/*
>  	 * Disable monitoring for regular users
>  	 * when executing setuid binaries. Must
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index af84234..74310a7 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -221,6 +221,8 @@ static inline void audit_ptrace(struct task_struct *t)
>  		__audit_ptrace(t);
>  }
> 
> +extern void audit_update_history(void);
> +
>  				/* Private API (for audit.c only) */
>  extern unsigned int audit_serial(void);
>  extern int auditsc_get_stamp(struct audit_context *ctx,
> @@ -437,6 +439,8 @@ static inline void audit_mmap_fd(int fd, int flags)
>  { }
>  static inline void audit_ptrace(struct task_struct *t)
>  { }
> +static inline void audit_update_history(void)
> +{ }
>  #define audit_n_rules 0
>  #define audit_signals 0
>  #endif /* CONFIG_AUDITSYSCALL */
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 3037fc0..078823a 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -98,8 +98,12 @@ extern struct group_info init_groups;
>  #define INIT_IDS \
>  	.loginuid = INVALID_UID, \
>  	.sessionid = (unsigned int)-1,
> +extern char init_task_history[];
> +#define INIT_THREAD_HISTORY		\
> +	.comm_history = init_task_history,
>  #else
>  #define INIT_IDS
> +#define INIT_THREAD_HISTORY
>  #endif
> 
>  #ifdef CONFIG_PREEMPT_RCU
> @@ -247,6 +251,7 @@ extern struct task_group root_task_group;
>  	INIT_RT_MUTEXES(tsk)						\
>  	INIT_VTIME(tsk)							\
>  	INIT_NUMA_BALANCING(tsk)					\
> +	INIT_THREAD_HISTORY						\
>  }
> 
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8db31ef..77539e4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1701,6 +1701,9 @@ struct task_struct {
>  #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
>  	unsigned long	task_state_change;
>  #endif
> +#ifdef CONFIG_AUDITSYSCALL
> +	char *comm_history;
> +#endif
>  };
> 
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index d3475e1..93ad58c 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -110,6 +110,7 @@
>  #define AUDIT_SECCOMP		1326	/* Secure Computing event */
>  #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
>  #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes 
*/
> +#define AUDIT_PROCHISTORY	1329	/* Commname history emit event */
> 
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 72ab759..d45397e 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1154,6 +1154,7 @@ static int __init audit_init(void)
>  {
>  	int i;
> 
> +	audit_update_history();
>  	if (audit_initialized == AUDIT_DISABLED)
>  		return 0;
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 072566d..2edeba2 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -88,6 +88,9 @@
>  /* max length to print of cmdline/proctitle value during audit */
>  #define MAX_PROCTITLE_AUDIT_LEN 128
> 
> +/* thread's comm name history length */
> +#define COMM_HISTORY_SIZE 1024
> +
>  /* number of audit rules */
>  int audit_n_rules;
> 
> @@ -945,6 +948,11 @@ int audit_alloc(struct task_struct *tsk)
>  	enum audit_state     state;
>  	char *key = NULL;
> 
> +	tsk->comm_history = kmemdup(current->comm_history, COMM_HISTORY_SIZE,
> +				    GFP_KERNEL);
> +	if (!tsk->comm_history)
> +		return -ENOMEM;
> +
>  	if (likely(!audit_ever_enabled))
>  		return 0; /* Return if not auditing. */
> 
> @@ -955,6 +963,8 @@ int audit_alloc(struct task_struct *tsk)
>  	}
> 
>  	if (!(context = audit_alloc_context(state))) {
> +		kfree(tsk->comm_history);
> +		tsk->comm_history = NULL;
>  		kfree(key);
>  		audit_log_lost("out of memory in audit_alloc");
>  		return -ENOMEM;
> @@ -1344,6 +1354,17 @@ out:
>  	audit_log_end(ab);
>  }
> 
> +static void audit_log_history(struct audit_context *context)
> +{
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PROCHISTORY);
> +	if (!ab)
> +		return;	/* audit_panic or being filtered */
> +	audit_log_format(ab, "history='%s'", current->comm_history);
> +	audit_log_end(ab);
> +}
> +
>  static void audit_log_exit(struct audit_context *context, struct
> task_struct *tsk) {
>  	int i, call_panic = 0;
> @@ -1462,6 +1483,7 @@ static void audit_log_exit(struct audit_context
> *context, struct task_struct *ts }
> 
>  	audit_log_proctitle(tsk, context);
> +	audit_log_history(context);
> 
>  	/* Send end of event record to help user space know we are finished */
>  	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
> @@ -1481,6 +1503,8 @@ void __audit_free(struct task_struct *tsk)
>  {
>  	struct audit_context *context;
> 
> +	kfree(tsk->comm_history);
> +	tsk->comm_history = NULL;
>  	context = audit_take_context(tsk, 0, 0);
>  	if (!context)
>  		return;
> @@ -2535,3 +2559,134 @@ struct list_head *audit_killed_trees(void)
>  		return NULL;
>  	return &ctx->killed_trees;
>  }
> +
> +char init_task_history[COMM_HISTORY_SIZE];
> +
> +/* Structure for representing YYYY/MM/DD hh/mm/ss. */
> +struct yyyymmdd_hhmmss {
> +	u16 year;
> +	u8 month;
> +	u8 day;
> +	u8 hour;
> +	u8 min;
> +	u8 sec;
> +};
> +
> +/**
> + * tt_get_time - Get current time in YYYY/MM/DD hh/mm/ss format.
> + *
> + * @stamp: Pointer to "struct yyyymmdd_hhmmss".
> + *
> + * Returns nothing.
> + *
> + * This function does not handle Y2038 problem.
> + */
> +static void tt_get_time(struct yyyymmdd_hhmmss *stamp)
> +{
> +	static const u16 days_until_end_of_month[2][12] = {
> +		{ 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
> +		{ 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
> +	};
> +	u16 y = 1970;
> +	u8 m;
> +	bool r;
> +	time_t time = get_seconds();
> +
> +	stamp->sec = time % 60;
> +	time /= 60;
> +	stamp->min = time % 60;
> +	time /= 60;
> +	stamp->hour = time % 24;
> +	time /= 24;
> +	if (time >= 16436) {
> +		/* Start from 2015/01/01 rather than 1970/01/01. */
> +		time -= 16436;
> +		y += 45;
> +	}
> +	while (1) {
> +		const unsigned short days = (y & 3) ? 365 : 366;
> +
> +		if (time < days)
> +			break;
> +		time -= days;
> +		y++;
> +	}
> +	r = (y & 3) == 0;
> +	for (m = 0; m < 11 && time >= days_until_end_of_month[r][m]; m++)
> +		;
> +	if (m)
> +		time -= days_until_end_of_month[r][m - 1];
> +	stamp->year = y;
> +	stamp->month = ++m;
> +	stamp->day = ++time;
> +}
> +
> +/**
> + * audit_update_history - Update current->comm_history field.
> + *
> + * Returns nothing.
> + *
> + * Update is done locklessly because current thread's history is updated by
> + * only current thread upon boot up and successful execve() operation, and
> + * we don't read other thread's history.
> + */
> +void audit_update_history(void)
> +{
> +	char *cp;
> +	int i;
> +	int required;
> +	char buf[256];
> +
> +	/*
> +	 * Lockless read because this is current thread and being unexpectedly
> +	 * modified by other thread is not a fatal problem.
> +	 */
> +	cp = buf;
> +	cp += snprintf(buf, sizeof(buf) - 1, "name=");
> +	for (i = 0; i < TASK_COMM_LEN; i++) {
> +		const unsigned char c = current->comm[i];
> +
> +		if (!c)
> +			break;
> +		if (isalnum(c) || c == '.' || c == '_' || c == '-') {
> +			*cp++ = c;
> +			continue;
> +		}
> +		*cp++ = '\\';
> +		*cp++ = (c >> 6) + '0';
> +		*cp++ = ((c >> 3) & 7) + '0';
> +		*cp++ = (c & 7) + '0';
> +	}
> +	/* Append PID. */
> +	cp += snprintf(cp, buf - cp + sizeof(buf) - 1, ";pid=%u",
> +		       current->pid);
> +	/* Append timestamp. */
> +	{
> +		struct yyyymmdd_hhmmss stamp;
> +
> +		tt_get_time(&stamp);
> +		cp += snprintf(cp, buf - cp + sizeof(buf) - 1,
> +			       ";start=%04u%02u%02u%02u%02u%02u", stamp.year,
> +			       stamp.month, stamp.day, stamp.hour, stamp.min,
> +			       stamp.sec);
> +	}
> +	/* Terminate the buffer. */
> +	if (cp >= buf + sizeof(buf))
> +		cp = buf + sizeof(buf) - 1;
> +	*cp = '\0';
> +	required = cp - buf;
> +	/* Make some room by truncating old history. */
> +	cp = current->comm_history;
> +	while (i = strlen(cp), i + required >= COMM_HISTORY_SIZE - 10) {
> +		char *cp2 = memchr(cp + 2, '>', i - 2);
> +
> +		BUG_ON(!cp2);
> +		cp2--;
> +		memmove(cp, cp2, strlen(cp2) + 1);
> +	}
> +	/* Emit the buffer. */
> +	if (!i)
> +		sprintf(cp, "%s", buf);
> +	else
> +		sprintf(cp + i, "=>%s", buf);
> +}

