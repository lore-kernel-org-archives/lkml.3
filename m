Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaCRR4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:56:16 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:56099 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756673AbaCRR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:56:14 -0400
X-Greylist: delayed 896 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 13:56:14 EDT
X-TM-IMSS-Message-ID: <2edd6a4e001bb0c6@nsa.gov>
Message-ID: <53288477.9060808@tycho.nsa.gov>
Date: Tue, 18 Mar 2014 13:37:59 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: get comm using lock to avoid race in string printing
References: <20140315232846.GE27244@madcap2.tricolour.ca> <14ba8faef484ac199ca33fe78fdf943a8d9755fb.1394925657.git.rgb@redhat.com>
In-Reply-To: <14ba8faef484ac199ca33fe78fdf943a8d9755fb.1394925657.git.rgb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 07:29 PM, Richard Guy Briggs wrote:
> ---
>  kernel/audit.c   |    5 ++---
>  kernel/auditsc.c |    9 +++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)

Doesn't this also need to be fixed (twice) in security/lsm_audit.c?

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 9239e5e..5b600c8 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1883,7 +1883,7 @@ EXPORT_SYMBOL(audit_log_task_context);
>  void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
>  {
>  	const struct cred *cred;
> -	char name[sizeof(tsk->comm)];
> +	char comm[sizeof(tsk->comm)];
>  	struct mm_struct *mm = tsk->mm;
>  	char *tty;
>  
> @@ -1917,9 +1917,8 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
>  			 from_kgid(&init_user_ns, cred->fsgid),
>  			 tty, audit_get_sessionid(tsk));
>  
> -	get_task_comm(name, tsk);
>  	audit_log_format(ab, " comm=");
> -	audit_log_untrustedstring(ab, name);
> +	audit_log_untrustedstring(ab, get_task_comm(name, tsk));
>  
>  	if (mm) {
>  		down_read(&mm->mmap_sem);
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 8fffca8..b789e0c 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2289,7 +2289,7 @@ void __audit_ptrace(struct task_struct *t)
>  	context->target_uid = task_uid(t);
>  	context->target_sessionid = audit_get_sessionid(t);
>  	security_task_getsecid(t, &context->target_sid);
> -	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
> +	get_task_comm(context->target_comm, t);
>  }
>  
>  /**
> @@ -2328,7 +2328,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
>  		ctx->target_uid = t_uid;
>  		ctx->target_sessionid = audit_get_sessionid(t);
>  		security_task_getsecid(t, &ctx->target_sid);
> -		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
> +		get_task_comm(ctx->target_comm, t);
>  		return 0;
>  	}
>  
> @@ -2349,7 +2349,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
>  	axp->target_uid[axp->pid_count] = t_uid;
>  	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
>  	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
> -	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
> +	get_task_comm(axp->target_comm[axp->pid_count], t);
>  	axp->pid_count++;
>  
>  	return 0;
> @@ -2435,6 +2435,7 @@ static void audit_log_task(struct audit_buffer *ab)
>  	kgid_t gid;
>  	unsigned int sessionid;
>  	struct mm_struct *mm = current->mm;
> +	char comm[sizeof(current->comm)];
>  
>  	auid = audit_get_loginuid(current);
>  	sessionid = audit_get_sessionid(current);
> @@ -2447,7 +2448,7 @@ static void audit_log_task(struct audit_buffer *ab)
>  			 sessionid);
>  	audit_log_task_context(ab);
>  	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
> -	audit_log_untrustedstring(ab, current->comm);
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current);
>  	if (mm) {
>  		down_read(&mm->mmap_sem);
>  		if (mm->exe_file)
> 

