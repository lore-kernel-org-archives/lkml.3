Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3KKQUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:20:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38055 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3KKQUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:20:38 -0500
Date: Mon, 11 Nov 2013 17:20:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more
 than 120 seconds.
Message-ID: <20131111162022.GB21461@twins.programming.kicks-ass.net>
References: <20131110101612.GC21916@localhost>
 <52808B7F.6000309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52808B7F.6000309@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 03:47:11PM +0800, Michael wang wrote:
> Hi, Fengguang
> 
> On 11/10/2013 06:16 PM, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> 
> I guess this will disappear when '!CONFIG_RCU_BOOST'...
> 
> AFAIK, if the rsp was in boost mode, we count on smpboot-thread
> 'rcu_cpu_thread_spec' to finish the callback, which will be
> parked before do sync-rcu inside _cpu_down(), if that was true,
> then the sync will never finish...
> 
> May be some brainless fix like this?
> 
> 
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 63aa50d..aa24338 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -306,7 +306,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>                                 __func__, cpu);
>                 goto out_release;
>         }
> -       smpboot_park_threads(cpu);
>  
>         /*
>          * By now we've cleared cpu_active_mask, wait for all preempt-disabled
> @@ -321,6 +320,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  #endif
>         synchronize_rcu();
>  
> +       smpboot_park_threads(cpu);
> +
>         /*
>          * So now all preempt/rcu users must observe !cpu_active().
>          */

Good thinking.. Wu did this cure stuff?
