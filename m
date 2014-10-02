Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaJBTOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:14:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaJBTOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:14:34 -0400
Date: Thu, 2 Oct 2014 21:11:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141002191114.GA30606@redhat.com>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <542D57D0.4030904@hurleysoftware.com> <20141002135250.GB10583@worktop.programming.kicks-ass.net> <20141002135805.GF6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002135805.GF6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02, Peter Zijlstra wrote:
>
> On Thu, Oct 02, 2014 at 03:52:50PM +0200, Peter Zijlstra wrote:
> > > If yes, then wakeups from signals don't work either, right?
> >
> > Its a kthread, there should not be any signals.
>
> That said, in the tty patch we do appear to have this problem.
>
> Oleg, do we want something like the below on top to make that work
> again?
>
> ---
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -326,8 +326,10 @@ long wait_woken(wait_queue_t *wait, unsi
>  	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
>  	 * also observe all state before the wakeup.
>  	 */
> -	if (!(wait->flags & WQ_FLAG_WOKEN))
> -		timeout = schedule_timeout(timeout);
> +	if (!(wait->flags & WQ_FLAG_WOKEN)) {
> +		if (___wait_is_interruptible(mode) && !signal_pending_state(mode, current))
> +			timeout = schedule_timeout(timeout);
> +	}
>  	__set_current_state(TASK_RUNNING);

I am a bit confused... but for what?

schedule() won't sleep if signal_pending_state(mode) anyway, so we
do not need this correctness-wise. And the caller needs to check
signal_pending() anyway.

We can probably add

	if (signal_pending_state(mode, current))
		return -EINTR;

at the start of wait_woken(), even before set_current_state(mode).
Then the caller can check "ret < 0" and avoid signal_pending().
Not sure this makes sense.

Oleg.

