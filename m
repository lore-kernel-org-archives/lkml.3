Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LEVxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:53:39 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41899 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3LEVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:53:38 -0500
From: Paul Moore <paul@paul-moore.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
Date: Thu, 05 Dec 2013 16:53:34 -0500
Message-ID: <2222358.CI2sulrSvj@sifl>
User-Agent: KMail/4.11.3 (Linux/3.12.1-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131205165953.GA24844@redhat.com>
References: <20131205165953.GA24844@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 05, 2013 05:59:53 PM Oleg Nesterov wrote:
> selinux_setprocattr() does ptrace_parent(p) under task_lock(p),
> but task_struct->alloc_lock doesn't pin ->parent or ->ptrace,
> this looks confusing and triggers the "suspicious RCU usage"
> warning because ptrace_parent() does rcu_dereference_check().
> 
> And in theory this is wrong, spin_lock()->preempt_disable()
> doesn't necessarily imply rcu_read_lock() we need to access
> the ->parent.
> 
> The patch also checks pid_alive(p) before ptrace_parent(p) to
> ensure that this task can't be dead even before rcu_read_lock(),
> in this case its ->parent points to nowhere. This is not really
> needed "in practice", task->ptrace must be already cleared in
> this case but we should not rely on this.
> 
> Note: perhaps we should simply kill ptrace_parent(), it buys
> almost nothing and it is obviously racy. Or perhaps we should
> change it to ensure it can't wrongly return the natural parent
> if it races with ptrace_detach.

Can you elaborate on "kill ptrace_parent()"?  If the process is being traced 
we do need to fetch the tracer's task_struct for use in the SELinux access 
check at this bottom of the diff below.  If you have something better in mind 
than ptrace_parent() it would be helpful to share that ...
 
> Reported-by: Evan McNabb <emcnabb@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  security/selinux/hooks.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 794c3ca..2adfd7a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5503,11 +5503,14 @@ static int selinux_setprocattr(struct task_struct
> *p, /* Check for ptracing, and update the task SID if ok.
>  		   Otherwise, leave SID unchanged and fail. */
>  		ptsid = 0;
> -		task_lock(p);
> -		tracer = ptrace_parent(p);
> -		if (tracer)
> -			ptsid = task_sid(tracer);
> -		task_unlock(p);
> +		tracer = NULL;
> +		rcu_read_lock();
> +		if (pid_alive(p)) {
> +			tracer = ptrace_parent(p);
> +			if (tracer)
> +				ptsid = task_sid(tracer);
> +		}
> +		rcu_read_unlock();
> 
>  		if (tracer) {
>  			error = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,

-- 
paul moore
www.paul-moore.com

