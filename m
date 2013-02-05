Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3BEHbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:31:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:33551 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3BEHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:31:41 -0500
Message-ID: <5110B552.9030903@huawei.com>
Date: Tue, 5 Feb 2013 15:31:30 +0800
From: Qiang Huang <h.huangqiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt26
References: <alpine.LFD.2.02.1302041537230.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302041537230.11905@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.210]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/4 22:58, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.11-rt26 release.
> 
> Changes since 3.6.11-rt25:
> 
>    1) Fix the RT highmem implementation on x86

Hi Thomas,

>From patches-3.6.11-rt28.patch.gz, your patch x86-highmem-make-it-work.patch
did this work. And you said
"It had been enabled quite some time, but never really worked."

But I think there is a previous patch mm-rt-kmap-atomic-scheduling.patch did
the job, so I think RT highmem on x86 should have worked.

Now with your patch, if we use kmap instead of kmap_atomic on RT, do we need
to revert Peter's patch as well?

I haven't tested it, but if Peter's patch did solved the problem, is his way
better than use kmap? Because we can use more highmem virtual address,
although with some switch latency in some small probability scenarios.

> 
>    2) Support highmem + RT on ARM
> 
>    3) Fix an one off error in the generic highmem code (upstream fix
>       did not make it into 3.6.stable)
> 
>    4) Upstream SLUB fixes (Christoph Lameter)
> 
>    5) Fix a few RT issues in mmc and amba drivers
> 
>    6) Initialize local locks in mm/swap.c early
> 
>    7) Use simple wait queues for completions. This is a performance
>       improvement.
> 
>       Completions do not have complex callbacks and the wakeup path is
>       disabling interrupts anyway. So using simple wait locks with the
>       raw spinlock is not a latency problem, but the "sleeping lock"
>       in the normal waitqueue is a source for lock bouncing:
> 
>       T1  	 	   T2
>       lock(WQ)
>       wakeup(T2)
>       ---> preemption
> 			   lock(WQ)
> 			   pi_boost(T1)
> 			   wait_for_lock(WQ)
>       unlock(WQ)
>       deboost(T1)
>       ---> preemption
> 			   ....
> 
>       The simple waitqueue reduces this to:
> 		   
>       T1  	 	   T2
>       raw_lock(WQ)
>       wakeup(T2)
>       raw_unlock(WQ)
>       ---> preemption
> 			   raw_lock(WQ)	
> 			   ....
> 
> @Steven: Sorry, I forgot the stable tags on:
> 	 drivers-tty-pl011-irq-disable-madness.patch
> 	 mmci-remove-bogus-irq-save.patch
> 	 idle-state.patch
> 	 might-sleep-check-for-idle.patch
> 	 mm-swap-fix-initialization.patch
> 
> I'm still digging through my mail backlog, so I have not yet decided
> whether this is the last RT release for 3.6.
> 
> 
> The delta patch against 3.6.11-rt25 is appended below and can be found
> here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt25-rt26.patch.xz
> 
> The RT patch against 3.6.11 can be found here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt26.patch.xz
> 
> The split quilt queue is available at:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt26.tar.xz
> 
> Enjoy,
> 
> 	tglx
> 


