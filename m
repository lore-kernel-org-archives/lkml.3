Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3EVIuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:50:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55179
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab3EVIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:50:21 -0400
Date: Wed, 22 May 2013 10:49:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
Message-ID: <20130522084947.GQ26912@twins.programming.kicks-ass.net>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
 <519AE7F2.706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AE7F2.706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:20:18AM +0800, Michael Wang wrote:
> 
> wake-affine stuff is always trying to pull wakee close to waker, by theory,
> this will benefit us if waker's cpu cached hot data for wakee, or the extreme
> ping-pong case, and testing show it could benefit hackbench 15% at most.
> 
> However, the whole feature is somewhat blindly, load balance is the only factor
> to be guaranteed, and since the stuff itself is time-consuming, some workload
> suffered, and testing show it could damage pgbench 41% at most.
> 
> The feature currently settled in mainline, which means the current scheduler
> force sacrificed some workloads to benefit others, that is definitely unfair.
> 
> Thus, this patch provide the way to throttle wake-affine stuff, in order to
> adjust the gain and loss according to demand.
> 
> The patch introduced a new knob 'sysctl_sched_wake_affine_interval' with the
> default value 1ms (default minimum balance interval), which means wake-affine
> will keep silent for 1ms after it's failure.
> 
> By turning the new knob, compared with mainline, which currently blindly using
> wake-affine, pgbench show 41% improvement at most.
> 
> Link:
> 	Analysis from Mike Galbraith about the improvement:
> 		https://lkml.org/lkml/2013/4/11/54
> 
> 	Analysis about the reason of throttle after failed:
> 		https://lkml.org/lkml/2013/5/3/31
> 
> Test:
> 	Test with 12 cpu X86 server and tip 3.10.0-rc1.
> 
> 				default
> 		    base	1ms interval	 10ms interval	   100ms interval
> | db_size | clients |  tps  |   |  tps  |        |  tps  |         |  tps  |
> +---------+---------+-------+   +-------+        +-------+         +-------+
> | 22 MB   |       1 | 10828 |   | 10850 |        | 10795 |         | 10845 |
> | 22 MB   |       2 | 21434 |   | 21469 |        | 21463 |         | 21455 |
> | 22 MB   |       4 | 41563 |   | 41826 |        | 41789 |         | 41779 |
> | 22 MB   |       8 | 53451 |   | 54917 |        | 59250 |         | 59097 |
> | 22 MB   |      12 | 48681 |   | 50454 |        | 53248 |         | 54881 |
> | 22 MB   |      16 | 46352 |   | 49627 | +7.07% | 54029 | +16.56% | 55935 | +20.67%
> | 22 MB   |      24 | 44200 |   | 46745 | +5.76% | 52106 | +17.89% | 57907 | +31.01%
> | 22 MB   |      32 | 43567 |   | 45264 | +3.90% | 51463 | +18.12% | 57122 | +31.11%
> | 7484 MB |       1 |  8926 |   |  8959 |        |  8765 |         |  8682 |
> | 7484 MB |       2 | 19308 |   | 19470 |        | 19397 |         | 19409 |
> | 7484 MB |       4 | 37269 |   | 37501 |        | 37552 |         | 37470 |
> | 7484 MB |       8 | 47277 |   | 48452 |        | 51535 |         | 52095 |
> | 7484 MB |      12 | 42815 |   | 45347 |        | 48478 |         | 49256 |
> | 7484 MB |      16 | 40951 |   | 44063 | +7.60% | 48536 | +18.52% | 51141 | +24.88%
> | 7484 MB |      24 | 37389 |   | 39620 | +5.97% | 47052 | +25.84% | 52720 | +41.00%
> | 7484 MB |      32 | 36705 |   | 38109 | +3.83% | 45932 | +25.14% | 51456 | +40.19%
> | 15 GB   |       1 |  8642 |   |  8850 |        |  9092 |         |  8560 |
> | 15 GB   |       2 | 19256 |   | 19285 |        | 19362 |         | 19322 |
> | 15 GB   |       4 | 37114 |   | 37131 |        | 37221 |         | 37257 |
> | 15 GB   |       8 | 47120 |   | 48053 |        | 50845 |         | 50923 |
> | 15 GB   |      12 | 42386 |   | 44748 |        | 47868 |         | 48875 |
> | 15 GB   |      16 | 40624 |   | 43414 | +6.87% | 48169 | +18.57% | 50814 | +25.08%
> | 15 GB   |      24 | 37110 |   | 39096 | +5.35% | 46594 | +25.56% | 52477 | +41.41%
> | 15 GB   |      32 | 36252 |   | 37316 | +2.94% | 45327 | +25.03% | 51217 | +41.28%
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Mike Galbraith <efault@gmx.de>
> CC: Alex Shi <alex.shi@intel.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

So I utterly hate this patch. I hate it worse than your initial buddy
patch :/

And I know its got a Suggested-by there; but that was when you led me to
believe that wake_affine() itself was expensive to run; its not, its the
result of those runs you don't like.

While we have a ton (too many to be sure) scheduler tunables, users
shouldn't ever need to actually touch those. Its just that every time we
have to make a random choice its as easy to make it a debug knob as to
hardcode it.

The problem with this patch is that users _have_ to frob knobs and while
doing so potentially wreck other workloads.

To make it worse, the knob isn't anything fundamental, its a random
hack.

So I would really either improve the smarts of wake_affine, with for
example your wake buddy relation thing (and simply exempt [Soft]IRQs) or
kill wake_affine and be done with it.

Either avenue has the risk of regressing some workload, but at least
when that happens (and people report it) we'll have a counter-example to
learn from and incorporate.
