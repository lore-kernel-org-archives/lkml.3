Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3GWLHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:07:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50843 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab3GWLHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:07:07 -0400
Date: Tue, 23 Jul 2013 16:36:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
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
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
Message-ID: <20130723110646.GA27005@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
 <20130722070144.GC5138@linux.vnet.ibm.com>
 <1374519467.7608.87.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1374519467.7608.87.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072311-0320-0000-0000-000000625008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> A potential issue I have found with avg_idle is that it may sometimes be
> not quite as accurate for the purposes of this patch, because it is
> always given a max value (default is 1000000 ns). For example, a CPU
> could have remained idle for 1 second and avg_idle would be set to 1
> millisecond. Another question I have is whether we can update avg_idle
> at all times without putting a maximum value on avg_idle, or increase
> the maximum value of avg_idle by a lot.

May be the current max value is a limiting factor, but I think there
should be a limit to the maximum value. Peter and Ingo may help us
understand why they limited to the 1ms. But I dont think we should
introduce a new variable just for this.
> 
> > Should we take the consideration of whether a idle_balance was
> > successful or not?
> 
> I recently ran fserver on the 8 socket machine with HT-enabled and found
> that load balance was succeeding at a higher than average rate, but idle
> balance was still lowering performance of that workload by a lot.
> However, it makes sense to allow idle balance to run longer/more often
> when it has a higher success rate.
> 

If idle balance did succeed, then it means that the system was indeed
imbalanced. So idle balance was the right thing to do. May be we chose
the wrong task to pull. May be after numa balancing enhancements go in,
we pick a better task to pull atleast across nodes. And there could be
other opportunities/strategies to select a right task to pull.

Again, schedstats during the application run should give us hints here.

> > I am not sure whats a reasonable value for n can be, but may be we could
> > try with n=3.
> 
> Based on some of the data I collected, n = 10 to 20 provides much better
> performance increases.
> 

I was saying it the other way. 
your suggestion is to run idle balance once in n runs .. where n is 10
to 20. 
My thinking was to not run idle balance once in n unsuccessful runs. 


> > Also have we checked the performance after adjusting the
> > sched_migration_cost tunable?
> > 
> > I guess, if we increase the sched_migration_cost, we should have lesser
> > newly idle balance requests. 
> 
> Yes, I have done quite a bit of testing with sched_migration_cost and
> adjusting it does help performance when idle balance overhead is high.
> But I have found that a higher value may decrease the performance during
> situations where the cost of idle_balance is not high. Additionally,
> when to modify this tunable and by how much to modify it by can
> sometimes be unpredictable. 

I think people understand that migration_cost depends on the
hardware/application and thats why they kept it as a tunable.
But is there something that we can look from the hardware and the
application behaviour to set a migration cost? May be doing this 
just complicates stuff then necessary.

-- 
Thanks and Regards
Srikar Dronamraju

