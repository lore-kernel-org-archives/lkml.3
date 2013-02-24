Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab3BXXcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:32:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:43310 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab3BXXcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:32:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] freezer: do not send a fake signal to a PF_DUMPCORE thread
Date: Mon, 25 Feb 2013 00:39:03 +0100
Message-ID: <45402727.PXDVBuj6zy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130224183656.GA8903@redhat.com>
References: <20130224173144.GA32179@redhat.com> <20130224173206.GA32206@redhat.com> <20130224183656.GA8903@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 24, 2013 07:36:56 PM Oleg Nesterov wrote:
> A coredumping thread can't be frozen anyway but the fake signal sent
> by freeze_task() can confuse dump_write/wait_for_dump_helpers/etc
> and interrupt the coredump.
> 
> We are going to make the do_coredump() paths freezable but the fake
> TIF_SIGPENDING doesn't help, it only makes sense when we assume that
> the target can return to user-mode and call get_signal_to_deliver().
> 
> Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD. We
> need to recheck PF_DUMPCORE under ->siglock to avoid the race with
> zap_threads() which can set this flag right before we take the lock.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  kernel/freezer.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index c38893b..595afab 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -85,14 +85,21 @@ bool __refrigerator(bool check_kthr_stop)
>  }
>  EXPORT_SYMBOL(__refrigerator);
>  
> -static void fake_signal_wake_up(struct task_struct *p)
> +static bool fake_signal_wake_up(struct task_struct *p)
>  {
>  	unsigned long flags;
> +	bool ret = false;
> +
> +	if (p->flags & (PF_KTHREAD | PF_DUMPCORE))
> +		return ret;
>  
>  	if (lock_task_sighand(p, &flags)) {
> -		signal_wake_up(p, 0);
> +		ret = !(p->flags & PF_DUMPCORE);
> +		if (ret)
> +			signal_wake_up(p, 0);
>  		unlock_task_sighand(p, &flags);
>  	}
> +	return ret;
>  }
>  
>  /**
> @@ -100,8 +107,8 @@ static void fake_signal_wake_up(struct task_struct *p)
>   * @p: task to send the request to
>   *
>   * If @p is freezing, the freeze request is sent either by sending a fake
> - * signal (if it's not a kernel thread) or waking it up (if it's a kernel
> - * thread).
> + * signal (if it's not a kernel thread or a coredumping thread) or waking
> + * it up otherwise.
>   *
>   * RETURNS:
>   * %false, if @p is not freezing or already frozen; %true, otherwise
> @@ -116,9 +123,7 @@ bool freeze_task(struct task_struct *p)
>  		return false;
>  	}
>  
> -	if (!(p->flags & PF_KTHREAD))
> -		fake_signal_wake_up(p);
> -	else
> +	if (!fake_signal_wake_up(p))
>  		wake_up_state(p, TASK_INTERRUPTIBLE);
>  
>  	spin_unlock_irqrestore(&freezer_lock, flags);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
