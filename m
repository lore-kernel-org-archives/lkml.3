Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3BYXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:53:18 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46405 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3BYXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:53:17 -0500
Date: Mon, 25 Feb 2013 15:53:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Lianwei Wang <lianwei.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
Message-ID: <20130225235313.GE2679@htj.dyndns.org>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rafael and Oleg and quoting whole body)

On Thu, Feb 21, 2013 at 02:19:21PM +0800, Lianwei Wang wrote:
> Hi Tejun Heo and all,
> 
> The commit of "34b087e freezer: kill unused
> set_freezable_with_signal()" remove recalc_sigpending*() calls in
> freezer, so the user tasks get TIF_SIGPENDING fake signal that is set
> when freezing userspace process. It left the fake signal to userspcae
> which cause the userspace task that wait_event_freezable and friends
> return a wrong ERESTARTSYS. This is not good because it waste cpu time
> to handle the fake signal.

Is this even measureable?  Freeze / thaw isn't exactly a hot path and
I'm having difficult time believing -ERESTARTSYS would have a
noticeable impact on anything.  Can you please explain why this is a
problem?

> Can we just call the recalc_sigpending to clear the fake signal for
> userspace tasks? as below patch do:
> 
> From 176fccee178bc0185d92853dd2f521c9166b0853 Mon Sep 17 00:00:00 2001
> From: Lianwei Wang <lianwei.wang@gmail.com>
> Date: Mon, 21 Jan 2013 18:21:26 +0800
> Subject: [PATCH] freezer: add fake signal clearing back when thaw task
> 
> The fake TIF_SIGPENDING is set during freeze userspace process, but it
> is not cleared when thaw tasks after below commit:
>   34b087e freezer: kill unused set_freezable_with_signal()
> 
> This will cause the userspace task that wait_event_freezable and friends
> return a wrong ERESTARTSYS. This is not good because it waste cpu time to
> handle the fake signal.
> 
> Try to clear the TIF_SIGPENDING flag for userspace apps when wakeup the
> frozen task to fix this issue.
> 
> Change-Id: I91c90ad2ee9a46c42e3b39a7384ec81e97bc0394
> Signed-off-by: Lianwei Wang <lianwei.wang@gmail.com>
> ---
>  kernel/freezer.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index c38893b..09557f6 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -46,6 +46,16 @@ bool freezing_slow_path(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(freezing_slow_path);
> 
> +static void fake_signal_clear(struct task_struct *p)
> +{
> + unsigned long flags;
> +
> + if (lock_task_sighand(p, &flags)) {
> +     recalc_sigpending();
> +     unlock_task_sighand(p, &flags);
> + }
> +}
> +
>  /* Refrigerator is place where frozen processes are stored :-). */
>  bool __refrigerator(bool check_kthr_stop)
>  {
> @@ -74,6 +84,10 @@ bool __refrigerator(bool check_kthr_stop)
> 
>   pr_debug("%s left refrigerator\n", current->comm);
> 
> + if (!(current->flags & PF_KTHREAD))
> +     if (test_tsk_thread_flag(current, TIF_SIGPENDING))
> +         fake_signal_clear(current);
> +
>   /*
>   * Restore saved task state before returning.  The mb'd version
>   * needs to be used; otherwise, it might silently break
> --
> 1.7.4.1



-- 
tejun
