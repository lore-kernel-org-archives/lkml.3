Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaKZAn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaKZAnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:43:53 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, penguin-kernel@i-love.sakura.ne.jp,
        sgrubb@redhat.com, eparis@parisplace.org
Subject: Re: [PATCH] lsm: copy comm before calling audit_log to avoid race in string printing
Date: Tue, 25 Nov 2014 19:43:46 -0500
Message-ID: <1932693.LDiX4theDV@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <efbec5e7d1923c4cc2bf9bf942889ded446900f1.1416029235.git.rgb@redhat.com>
References: <efbec5e7d1923c4cc2bf9bf942889ded446900f1.1416029235.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 16, 2014 04:44:10 PM Richard Guy Briggs wrote:
> When task->comm is passed directly to audit_log_untrustedstring() without
> getting a copy or using the task_lock, there is a race that could happen
> that would output a NULL (\0) in the middle of the output string that would
> effectively truncate the rest of the report text after the comm= field in
> the audit log message, losing fields.
> 
> Using get_task_comm() to get a copy while acquiring the task_lock to prevent
> this and to prevent the result from being a mixture of old and new values
> of comm would incur potentially unacceptable overhead, considering that the
> value can be influenced by userspace and therefore untrusted anyways.
> 
> Copy the value before passing it to audit_log_untrustedstring() ensures that
> a local copy is used to calculate the length *and* subsequently printed. 
> Even if this value contains a mix of old and new values, it will only
> calculate and copy up to the first NULL, preventing the rest of the audit
> log message being truncated.

In general I think this looks good, some minor nits below.  We should get this 
into linux-next soonish.

> The LSM_AUDIT_DATA_TASK pid= and comm= labels are duplicates of those at the
> start of this function with different values.  Rename them to their object
> counterparts opid= and ocomm= to disambiguate.  Use a second local copy of
> comm to avoid a race between the first and second calls to
> audit_log_untrustedstring() with comm.

This probably should have been split into a separate patch, but not a deal 
breaker I suppose.  For the record, is Steve okay with these field names?

> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  security/lsm_audit.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 69fdf3b..3323144 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -211,7 +211,7 @@ static inline void print_ipv4_addr(struct audit_buffer
> *ab, __be32 addr, static void dump_common_audit_data(struct audit_buffer
> *ab,
>  				   struct common_audit_data *a)
>  {
> -	struct task_struct *tsk = current;
> +	char comm[sizeof(current->comm)];

As mentioned previously, I think I prefer TASK_COMM_LEN here, but ultimately 
it isn't too important.

>  	/*
>  	 * To keep stack sizes in check force programers to notice if they
> @@ -220,8 +220,8 @@ static void dump_common_audit_data(struct audit_buffer
> *ab, */
>  	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
> 
> -	audit_log_format(ab, " pid=%d comm=", task_pid_nr(tsk));
> -	audit_log_untrustedstring(ab, tsk->comm);
> +	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
> +	audit_log_untrustedstring(ab, memcpy(comm, current->comm, sizeof(comm)));

Again.

>  	switch (a->type) {
>  	case LSM_AUDIT_DATA_NONE:
> @@ -276,16 +276,19 @@ static void dump_common_audit_data(struct audit_buffer
> *ab, audit_log_format(ab, " ino=%lu", inode->i_ino);
>  		break;
>  	}
> -	case LSM_AUDIT_DATA_TASK:
> -		tsk = a->u.tsk;
> +	case LSM_AUDIT_DATA_TASK: {
> +		struct task_struct *tsk = a->u.tsk;
>  		if (tsk) {
>  			pid_t pid = task_pid_nr(tsk);
>  			if (pid) {
> -				audit_log_format(ab, " pid=%d comm=", pid);
> -				audit_log_untrustedstring(ab, tsk->comm);
> +				char comm[sizeof(tsk->comm)];
> +				audit_log_format(ab, " opid=%d ocomm=", pid);
> +				audit_log_untrustedstring(ab,
> +				    memcpy(comm, tsk->comm, sizeof(comm)));

... and again.

-- 
paul moore
security and virtualization @ redhat

