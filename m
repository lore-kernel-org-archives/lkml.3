Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3KLJzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:55:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:43191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3KLJzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:55:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,684,1378882800"; 
   d="scan'208";a="426103850"
Date: Tue, 12 Nov 2013 17:55:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more
 than 120 seconds.
Message-ID: <20131112095516.GB32441@localhost>
References: <20131110101612.GC21916@localhost>
 <52808B7F.6000309@linux.vnet.ibm.com>
 <20131111162022.GB21461@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111162022.GB21461@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 05:20:22PM +0100, Peter Zijlstra wrote:
> On Mon, Nov 11, 2013 at 03:47:11PM +0800, Michael wang wrote:
> > Hi, Fengguang
> > 
> > On 11/10/2013 06:16 PM, Fengguang Wu wrote:
> > > Greetings,
> > > 
> > > I got the below dmesg and the first bad commit is
> > 
> > I guess this will disappear when '!CONFIG_RCU_BOOST'...
> > 
> > AFAIK, if the rsp was in boost mode, we count on smpboot-thread
> > 'rcu_cpu_thread_spec' to finish the callback, which will be
> > parked before do sync-rcu inside _cpu_down(), if that was true,
> > then the sync will never finish...
> > 
> > May be some brainless fix like this?
> > 
> > 
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index 63aa50d..aa24338 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -306,7 +306,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> >                                 __func__, cpu);
> >                 goto out_release;
> >         }
> > -       smpboot_park_threads(cpu);
> >  
> >         /*
> >          * By now we've cleared cpu_active_mask, wait for all preempt-disabled
> > @@ -321,6 +320,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> >  #endif
> >         synchronize_rcu();
> >  
> > +       smpboot_park_threads(cpu);
> > +
> >         /*
> >          * So now all preempt/rcu users must observe !cpu_active().
> >          */
> 
> Good thinking.. Wu did this cure stuff?

Yes, it fixed the problem.

Tested-by: Fengguang Wu <fengguang.wu@intel.com>


/kernel/i386-randconfig-j3-11101308/484f4e66a6a1102edf02407479f6f7632aade0f3

+--------------------------------------------------+--------------+--------------+
|                                                  | e5137b50a064 | 484f4e66a6a1 |
+--------------------------------------------------+--------------+--------------+
| boot_successes                                   | 42           | 100          |
| boot_failures                                    | 58           |              |
| INFO:task_blocked_for_more_than_seconds          | 58           |              |
| Kernel_panic-not_syncing:hung_task:blocked_tasks | 58           |              |
+--------------------------------------------------+--------------+--------------+

/kernel/x86_64-randconfig-x4-1108/484f4e66a6a1102edf02407479f6f7632aade0f3

+------------------------------------------------------------------------------------+-----------+--------------+--------------+
|                                                                                    | v3.12-rc7 | e5137b50a064 | 484f4e66a6a1 |
+------------------------------------------------------------------------------------+-----------+--------------+--------------+
| boot_successes                                                                     | 59        | 34           | 100          |
| has_kernel_error_warning                                                           | 4         |              |              |
| BUG:kernel_early_hang_without_any_printk_output                                    | 4         |              |              |
| boot_failures                                                                      | 0         | 66           |              |
| INFO:task_blocked_for_more_than_seconds                                            | 0         | 66           |              |
| INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0         | 55           |              |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0         | 66           |              |
+------------------------------------------------------------------------------------+-----------+--------------+--------------+

