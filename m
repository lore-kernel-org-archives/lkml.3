Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3IZSPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:15:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:44165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3IZSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="409929644"
Message-ID: <1380219317.32071.6.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
From: Darren Hart <dvhart@linux.intel.com>
To: zhang.yi20@zte.com.cn
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Thu, 26 Sep 2013 11:15:17 -0700
In-Reply-To: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
References: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 09:09 +0800, zhang.yi20@zte.com.cn wrote:
> Hi all,
> 
> Task processes all its owned robust futex when it is exiting,
> to ensure the futexes can be taken by other tasks.
> 
> Though this can not work good in sometimes.
> Think about this scene：
> 1. A robust mutex is shared for two processes, each process has
>    multi threads to lock the mutex.
> 2. One of the threads locks the mutex, and the others are waiting
>    and sorted in order of priority.
> 3. The process to which the mutex owner thread belongs is dying
>    without unlocking the mutex，and handle_futex_death is invoked
>    to wake the first waiter.
> 4. If the first waiter belongs to the same process，it has no chance
>    to return to the userspace to lock the mutex, and it won't wake
>    the next waiter because it is not the owner of the mutex.
> 5. The rest waiters of the other process may block forever.
> 
> This patch remove the owner check when waking task in handle_futex_death.
> If above occured, The dying task can wake the next waiter by processing its list_op_pending.
> The waked task could return to userspace and try to lock the mutex again.
> 

The problem is if you allow the non-owner to do the wake, you risk
multiple threads calling futex_wake(). Or is that your intention? Wake
one waiter for every thread that calls handle_futex_death()?

> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> Reviewed-by: Xie Baoyou <xie.baoyou@zte.com.cn>
> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> 
> 
> 
> --- linux/kernel/futex.c	2013-09-25 09:24:34.639634244 +0000
> +++ linux/kernel/futex.c	2013-09-25 10:12:17.619673546 +0000
> @@ -2541,14 +2541,15 @@ retry:
>  		}
>  		if (nval != uval)
>  			goto retry;
> -
> -		/*
> -		 * Wake robust non-PI futexes here. The wakeup of
> -		 * PI futexes happens in exit_pi_state():
> -		 */
> -		if (!pi && (uval & FUTEX_WAITERS))
> -			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
>  	}
> +
> +	/*
> +	 * Wake robust non-PI futexes here. The wakeup of
> +	 * PI futexes happens in exit_pi_state():
> +	 */
> +	if (!pi)


Why did you drop the FUTEX_WAITERS condition?

You sent a different patch earlier this year that didn't appear to get
any review:

https://lkml.org/lkml/2013/4/8/65

This one woke all the waiters and let them sort it out.

It seems we've hashed through this already, but I'm not finding the
email logs and I don't recall off the top of my head.

> +		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
> +
>  	return 0;
>  }

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


