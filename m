Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaJBOQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:16:34 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47899 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbaJBOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:16:33 -0400
Message-ID: <542D5E3B.6000309@hurleysoftware.com>
Date: Thu, 02 Oct 2014 10:16:27 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, oleg@redhat.com
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <542D57D0.4030904@hurleysoftware.com> <20141002135250.GB10583@worktop.programming.kicks-ass.net> <20141002135805.GF6324@worktop.programming.kicks-ass.net>
In-Reply-To: <20141002135805.GF6324@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:58 AM, Peter Zijlstra wrote:
> On Thu, Oct 02, 2014 at 03:52:50PM +0200, Peter Zijlstra wrote:
>>> If yes, then wakeups from signals don't work either, right?
>>
>> Its a kthread, there should not be any signals.
> 
> That said, in the tty patch we do appear to have this problem.

That's what I meant. And the module load patch too.

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
>  
>  	/*
> 

