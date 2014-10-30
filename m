Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161566AbaJ3XSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161351AbaJ3XSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:18:31 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com, sgrubb@redhat.com
Subject: Re: [PATCH] lsm: get comm using lock to avoid race in string printing
Date: Thu, 30 Oct 2014 19:18:17 -0400
Message-ID: <1478341.K6oVWdhYQd@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.17.1-gentoo-r1; KDE/4.14.2; x86_64; ; )
In-Reply-To: <735f28048636878e638add7d6129a8c2fd79a09e.1411141022.git.rgb@redhat.com>
References: <735f28048636878e638add7d6129a8c2fd79a09e.1411141022.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 19, 2014 11:41:15 AM Richard Guy Briggs wrote:
> When task->comm is passed directly to audit_log_untrustedstring() without
> getting a copy or using the task_lock, there is a race that could happen
> that would output a NULL (\0) in the output string that would effectively
> truncate the rest of the report text after the comm= field in the audit,
> losing fields.
> 
> Use get_task_comm() to get a copy while acquiring the task_lock to prevent
> this and to prevent the result from being a mixture of old and new values of
> comm.
> 
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

The above is a bit odd ... is that a "Signed-off-by:" from Tetsuo Handa or a 
"From:"?

> ---
> I've manually checked for locking issues and found none.  I've also enabled
> all the kernel lock debugging options and it came up clean.
> 
>  security/lsm_audit.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 69fdf3b..4773b91 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -212,6 +212,7 @@ static void dump_common_audit_data(struct audit_buffer
> *ab, struct common_audit_data *a)
>  {
>  	struct task_struct *tsk = current;
> +	char comm[sizeof(tsk->comm)];

This makes me a bit nervous for a potential race condition between allocation 
and use below.  How about using TASK_COMM_LEN instead?

>  	/*
>  	 * To keep stack sizes in check force programers to notice if they
> @@ -221,7 +222,7 @@ static void dump_common_audit_data(struct audit_buffer
> *ab, BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
> 
>  	audit_log_format(ab, " pid=%d comm=", task_pid_nr(tsk));
> -	audit_log_untrustedstring(ab, tsk->comm);
> +	audit_log_untrustedstring(ab, get_task_comm(comm, tsk));
> 
>  	switch (a->type) {
>  	case LSM_AUDIT_DATA_NONE:
> @@ -282,7 +283,7 @@ static void dump_common_audit_data(struct audit_buffer
> *ab, pid_t pid = task_pid_nr(tsk);
>  			if (pid) {
>  				audit_log_format(ab, " pid=%d comm=", pid);
> -				audit_log_untrustedstring(ab, tsk->comm);
> +				audit_log_untrustedstring(ab, get_task_comm(comm, tsk));
>  			}
>  		}
>  		break;

-- 
paul moore
security and virtualization @ redhat

