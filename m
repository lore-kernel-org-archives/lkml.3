Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaJBTWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:22:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaJBTWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:22:05 -0400
Date: Thu, 2 Oct 2014 21:18:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141002191846.GB30606@redhat.com>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <542D57D0.4030904@hurleysoftware.com> <20141002135250.GB10583@worktop.programming.kicks-ass.net> <20141002135805.GF6324@worktop.programming.kicks-ass.net> <542D5E3B.6000309@hurleysoftware.com> <20141002165739.GC10583@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002165739.GC10583@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, somehow I missed this email, I already replied to the previous one.

On 10/02, Peter Zijlstra wrote:
>
> In any case, if we change wait_woken() like the below, then we can
> simplify the loops by taking out their signal_pending checks and using
> the wait_woken() return value instead.

Yes, but let me repeat,

> +++ b/kernel/sched/wait.c
> @@ -326,8 +326,14 @@ long wait_woken(wait_queue_t *wait, unsi
>  	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
>  	 * also observe all state before the wakeup.
>  	 */
> -	if (!(wait->flags & WQ_FLAG_WOKEN))
> -		timeout = schedule_timeout(timeout);
> +	if (!(wait->flags & WQ_FLAG_WOKEN)) {
> +		if (___wait_is_interruptible(mode)) {

___wait_is_interruptible() is pointless, signal_pending_state() does
the same checks. Not to mention it will always return T in this case,
note that __builtin_constant_p(state) == F.


> +		       if (signal_pending_state(mode, current))
> +			       timeout = -ERESTARTSYS;

OK, but unless I missed something this looks overcomplicated. You can
simply do this at the start of wait_woken(). Not need to play with
current->state, no need to clear WQ_FLAG_WOKEN.

Oleg.

