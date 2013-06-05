Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3FEPpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:45:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab3FEPpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:45:09 -0400
Date: Wed, 5 Jun 2013 17:40:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [ 020/184] ptrace: ensure arch_ptrace/ptrace_request can never
Message-ID: <20130605154051.GA23025@redhat.com>
References: <20130604172131.136042108@1wt.eu> <87sj0wucft.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj0wucft.fsf@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Luis Henriques wrote:
>
> Willy Tarreau <w@1wt.eu> writes:
>
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >  race with SIGKILL
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
> >
>
> This patch actually introduce a regression in the Ubuntu kernel.  You
> may want to include the fix below.

Yes, 2.6.32 should also take care of TASK_STOPPED.

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -81,14 +81,18 @@ void __ptrace_unlink(struct task_struct *child)
>  }
>  
>  /* Ensure that nothing can wake it up, even SIGKILL */
> -static bool ptrace_freeze_traced(struct task_struct *task)
> +static bool ptrace_freeze_traced(struct task_struct *task, int kill)
>  {
> -	bool ret = false;
> +	bool ret = true;
>  
>  	spin_lock_irq(&task->sighand->siglock);
> -	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
> +	if (task_is_stopped(task) && !__fatal_signal_pending(task))
>  		task->state = __TASK_TRACED;
> -		ret = true;
> +	else if (!kill) {
> +		if (task_is_traced(task) && !__fatal_signal_pending(task))
> +			task->state = __TASK_TRACED;
> +		else
> +			ret = false;
>  	}
>  	spin_unlock_irq(&task->sighand->siglock);
>  
> @@ -131,7 +135,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
>  		 * child->sighand can't be NULL, release_task()
>  		 * does ptrace_unlink() before __exit_signal().
>  		 */
> -		if (kill || ptrace_freeze_traced(child))
> +		if (ptrace_freeze_traced(child, kill))
>  			ret = 0;

I can't apply this patch, probably I misread it...

But it looks very wrong. It seems that ptrace_freeze_traced(kill => true)
always succeeds? Even if task is TASK_RUNNING/UNINTERRUPTIBLE/etc ?

Note: I can make a _much_ simpler patch for 2.6.32, please let me know
if you need it.

We can rely on sys_ptrace()->lock_kernel() and simply do lock/unlock
if fatal_signal_pending() in ptrace_stop/do_signal_stop. This is not
the same, this doesn't prevent wakeup(), but this should be enough.

Oleg.

