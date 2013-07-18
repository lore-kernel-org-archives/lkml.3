Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab3GRTGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:06:45 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:20957 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab3GRTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:06:43 -0400
Message-ID: <1374174399.1792.42.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Thu, 18 Jul 2013 12:06:39 -0700
In-Reply-To: <51E7D89A.8010009@redhat.com>
References: <20130716202015.GX17211@twins.programming.kicks-ass.net>
	 <1374014881.2332.21.camel@j-VirtualBox>
	 <20130717072504.GY17211@twins.programming.kicks-ass.net>
	 <1374048701.6000.21.camel@j-VirtualBox>
	 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
	 <1374076741.7412.35.camel@j-VirtualBox>
	 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
	 <51E6D9B7.1030705@redhat.com>
	 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
	 <1374120144.1816.45.camel@j-VirtualBox>
	 <20130718093218.GH27075@twins.programming.kicks-ass.net>
	 <51E7D89A.8010009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 07:59 -0400, Rik van Riel wrote:
> On 07/18/2013 05:32 AM, Peter Zijlstra wrote:
> > On Wed, Jul 17, 2013 at 09:02:24PM -0700, Jason Low wrote:
> >
> >> I ran a few AIM7 workloads for the 8 socket HT enabled case and I needed
> >> to set N to more than 20 in order to get the big performance gains.
> >>
> >> One thing that I thought of was to have N be based on how often idle
> >> balance attempts does not pull task(s).
> >>
> >> For example, N can be calculated based on the number of idle balance
> >> attempts for the CPU  since the last "successful" idle balance attempt.
> >> So if the previous 30 idle balance attempts resulted in no tasks moved,
> >> then n = 30 / 5. So idle balance gets less time to run as the number of
> >> unneeded idle balance attempts increases, and thus N will not be set too
> >> high during situations where idle balancing is "successful" more often.
> >> Any comments on this idea?
> >
> > It would be good to get a solid explanation for why we need such high N.
> > But yes that might work.
> 
> I have some idea, though no proof :)
> 
> I suspect a lot of the idle balancing time is spent waiting for
> and acquiring the runqueue locks of remote CPUs.
> 
> If we spend half our idle time causing contention to remote
> runqueue locks, we could be a big factor in keeping those other
> CPUs from getting work done.

I collected some perf samples when running fserver when N=1 and N=60.

N = 1
-----
19.21%  reaim  [k] __read_lock_failed                     
14.79%  reaim  [k] mspin_lock                             
12.19%  reaim  [k] __write_lock_failed                    
7.87%   reaim  [k] _raw_spin_lock                          
2.03%   reaim  [k] start_this_handle                       
1.98%   reaim  [k] update_sd_lb_stats                      
1.92%   reaim  [k] mutex_spin_on_owner                     
1.86%   reaim  [k] update_cfs_rq_blocked_load              
1.14%   swapper  [k] intel_idle                              
1.10%   reaim  [.] add_long                                
1.09%   reaim  [.] add_int                                 
1.08%   reaim  [k] load_balance                            

N = 60
------
7.70%  reaim  [k] _raw_spin_lock                             
7.25%  reaim  [k] mspin_lock                                 
6.30%  reaim  [.] add_long                                   
6.26%  reaim  [.] add_int                                    
4.05%  reaim  [.] strncat                                    
3.81%  reaim  [.] string_rtns_1                              
3.66%  reaim  [.] div_long                                   
3.44%  reaim  [k] mutex_spin_on_owner                        
2.91%  reaim  [.] add_short                                  
2.73%  swapper  [k] intel_idle                                 
2.65%  reaim  [k] __read_lock_failed

With idle_balance(), we get more contention in kernel functions such as
update_sd_lb_stats(), load_balance(), and spin_lock() for the rq lock.
Additionally, it increases the time spent in mutex's mspin_lock(),
__read_lock_failed() and __write_lock_failed() by a lot.

N needs to be large because avg_idle time is still a lot higher than the
avg time spent in each load_balance() call per sched domain. Despite the
high ratio of avg_idle time to time spent in load_balance(),
load_balance() still increases the time spent in the kernel by quite a
bit, probably because of how often it is being used.

Jason


