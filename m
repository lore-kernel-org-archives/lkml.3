Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3GXEYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:24:15 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30446 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3GXEYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:24:13 -0400
Message-ID: <1374639848.2335.7.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 23 Jul 2013 21:24:08 -0700
In-Reply-To: <20130723110646.GA27005@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <20130722070144.GC5138@linux.vnet.ibm.com>
	 <1374519467.7608.87.camel@j-VirtualBox>
	 <20130723110646.GA27005@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 16:36 +0530, Srikar Dronamraju wrote:
> > 
> > A potential issue I have found with avg_idle is that it may sometimes be
> > not quite as accurate for the purposes of this patch, because it is
> > always given a max value (default is 1000000 ns). For example, a CPU
> > could have remained idle for 1 second and avg_idle would be set to 1
> > millisecond. Another question I have is whether we can update avg_idle
> > at all times without putting a maximum value on avg_idle, or increase
> > the maximum value of avg_idle by a lot.
> 
> May be the current max value is a limiting factor, but I think there
> should be a limit to the maximum value. Peter and Ingo may help us
> understand why they limited to the 1ms. But I dont think we should
> introduce a new variable just for this.

You're right. As Peter recently mentioned, avg_idle is only used for
idle_balance() anyway, so we should just use the existing avg_idle
estimator.

> > 
> > > Should we take the consideration of whether a idle_balance was
> > > successful or not?
> > 
> > I recently ran fserver on the 8 socket machine with HT-enabled and found
> > that load balance was succeeding at a higher than average rate, but idle
> > balance was still lowering performance of that workload by a lot.
> > However, it makes sense to allow idle balance to run longer/more often
> > when it has a higher success rate.
> > 
> 
> If idle balance did succeed, then it means that the system was indeed
> imbalanced. So idle balance was the right thing to do. May be we chose
> the wrong task to pull. May be after numa balancing enhancements go in,
> we pick a better task to pull atleast across nodes. And there could be
> other opportunities/strategies to select a right task to pull.
> 
> Again, schedstats during the application run should give us hints here.
> 
> > > I am not sure whats a reasonable value for n can be, but may be we could
> > > try with n=3.
> > 
> > Based on some of the data I collected, n = 10 to 20 provides much better
> > performance increases.
> > 
> 
> I was saying it the other way. 
> your suggestion is to run idle balance once in n runs .. where n is 10
> to 20. 
> My thinking was to not run idle balance once in n unsuccessful runs. 

When I suggested N is 20, that means that if the average idle time of a
CPU is 1,000,000 ns, then we stop idle balancing if the average cost to
idle balance within a domain would come up to be greater than (1,000,000
ns / 20) = 50,000 ns. In the v2 patch, N helps determine the maximum
duration in which we allow each idle_balance() to run.

Thanks,
Jason

