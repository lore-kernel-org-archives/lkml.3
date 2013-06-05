Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3FEQOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:14:07 -0400
Received: from 1wt.eu ([62.212.114.60]:36036 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab3FEQOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:14:05 -0400
Date: Wed, 5 Jun 2013 18:13:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [ 020/184] ptrace: ensure arch_ptrace/ptrace_request can never
Message-ID: <20130605161359.GF27897@1wt.eu>
References: <20130604172131.136042108@1wt.eu> <87sj0wucft.fsf@canonical.com> <20130605154051.GA23025@redhat.com> <20130605154950.GA23647@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605154950.GA23647@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, Jun 05, 2013 at 05:49:51PM +0200, Oleg Nesterov wrote:
> On 06/05, Oleg Nesterov wrote:
> >
> > Note: I can make a _much_ simpler patch for 2.6.32, please let me know
> > if you need it.
> >
> > We can rely on sys_ptrace()->lock_kernel() and simply do lock/unlock
> > if fatal_signal_pending() in ptrace_stop/do_signal_stop. This is not
> > the same, this doesn't prevent wakeup(), but this should be enough.
> 
> Something like below. Untested/uncompiled. I think it should close the
> security problems.
> 
> Oleg.
> 
> 
> --- x/kernel/signal.c
> +++ x/kernel/signal.c
> @@ -1545,6 +1545,14 @@ static int sigkill_pending(struct task_s
>  		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
>  }
>  
> +static void ptrace_sync(void)
> +{
> +	if (fatal_signal_pending(current)) {
> +		lock_kernel();
> +		unlock_kernel();
> +	}
> +}
> +
>  /*
>   * This must be called with current->sighand->siglock held.
>   *
> @@ -1603,6 +1611,7 @@ static void ptrace_stop(int exit_code, i
>  		read_unlock(&tasklist_lock);
>  		preempt_enable_no_resched();
>  		schedule();
> +		ptrace_sync();
>  	} else {
>  		/*
>  		 * By the time we got the lock, our tracer went away.
> @@ -1722,6 +1731,9 @@ static int do_signal_stop(int signr)
>  		schedule();
>  	} while (try_to_freeze());
>  
> +	if (current->ptrace)
> +		ptrace_sync();
> +
>  	tracehook_finish_jctl();
>  	current->exit_code = 0;
>  

While I'm unable to tell whether the patch fixes the issue, I totally
trust you on this. So if you have the time to propose a tested patch
(or suggest me how to reliably test it), I'd gladly apply it instead.

Thanks!
Willy

