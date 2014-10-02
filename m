Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaJBMmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaJBMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:42:50 -0400
Date: Thu, 2 Oct 2014 14:42:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>, oleg@redhat.com
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141002124247.GD6324@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002123150.GC6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:31:50PM +0200, Peter Zijlstra wrote:
> @@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
>  
>  static int rfcomm_run(void *unused)
>  {
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  	BT_DBG("");
>  
>  	set_user_nice(current, -10);
>  
>  	rfcomm_add_listener(BDADDR_ANY);
>  
> -	while (1) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		if (kthread_should_stop())
> -			break;
> +	add_wait_queue(&rfcomm_wq, &wait);
> +	while (!kthread_should_stop()) {
>  
>  		/* Process stuff */
>  		rfcomm_process_sessions();
>  
> -		schedule();
> +		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>  	}
> -	__set_current_state(TASK_RUNNING);
> +	remove_wait_queue(&rfcomm_wq, &wait);
>  
>  	rfcomm_kill_listener();
>  

Hmm, I think there's a problem there. If someone were to do
kthread_stop() before wait_woken() we'd not actually stop, because
wait_woken() doesn't test KTHREAD_SHOULD_STOP before calling schedule().

We can't unconditionally put a kthread_should_stop() in because
to_kthread() would explode on a !kthread. The other obvious solution is
adding a second function, something like wait_woken_or_stop(), but that
appears somewhat ugly to me.

Oleg, do you see another solution?
