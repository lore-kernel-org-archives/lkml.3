Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3KRR4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:56:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3KRR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:56:41 -0500
Date: Mon, 18 Nov 2013 18:56:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
Message-ID: <20131118175633.GB3694@twins.programming.kicks-ass.net>
References: <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
 <1384243595.15180.63.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
 <20131115163008.GB12164@linutronix.de>
 <20131115201436.GC12164@linutronix.de>
 <20131118141021.GA10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118141021.GA10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:10:21PM +0100, Peter Zijlstra wrote:
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -746,13 +746,23 @@ void irq_exit(void)
>  #endif
>  
>  	account_irq_exit_time(current);
> -	trace_hardirq_exit();
>  	sub_preempt_count(HARDIRQ_OFFSET);
> -	if (!in_interrupt() && local_softirq_pending())
> +	if (!in_interrupt() && local_softirq_pending()) {
> +		/*
> +		 * Temp. disable hardirq context so as not to confuse lockdep;
> +		 * otherwise it might think we're running softirq handler from
> +		 * hardirq context.
> +		 *
> +		 * Should probably sort this someplace else..
> +		 */
> +		trace_hardirq_exit();
>  		invoke_softirq();
> +		trace_hardirq_enter();
> +	}
>  
>  	tick_irq_exit();
>  	rcu_irq_exit();
> +	trace_hardirq_exit();
>  }
>  
>  void raise_softirq(unsigned int nr)

*SPLAT*

---
[ 7794.620512] =================================
[ 7794.620513] [ INFO: inconsistent lock state ]
[ 7794.620515] 3.12.0-rt2-dirty #585 Not tainted
[ 7794.620517] ---------------------------------
[ 7794.620518] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[ 7794.620520] swapper/0/0 [HC1[0]:SC0[0]:HE0:SE1] takes:
[ 7794.620527]  (&(&(&base->lock)->lock)->wait_lock){?.+...}, at: [<ffffffff811036af>] rt_mutex_slowtrylock+0xf/0x80
[ 7794.620528] {HARDIRQ-ON-W} state was registered at:
[ 7794.620532]   [<ffffffff810fb58c>] __lock_acquire+0x64c/0x1ec0
[ 7794.620534]   [<ffffffff810fd430>] lock_acquire+0x90/0x150
[ 7794.620537]   [<ffffffff8166079b>] _raw_spin_lock+0x3b/0x50
[ 7794.620540]   [<ffffffff8165f273>] rt_spin_lock_slowlock+0x33/0x260
[ 7794.620542]   [<ffffffff81660009>] rt_spin_lock+0x69/0x70
[ 7794.620546]   [<ffffffff8109f48a>] run_timer_softirq+0x4a/0x2f0
[ 7794.620548]   [<ffffffff81096441>] do_current_softirqs+0x231/0x460
[ 7794.620550]   [<ffffffff810966a8>] run_ksoftirqd+0x38/0x60
[ 7794.620553]   [<ffffffff810c0fec>] smpboot_thread_fn+0x22c/0x350
[ 7794.620555]   [<ffffffff810b7e0d>] kthread+0xcd/0xe0
[ 7794.620558]   [<ffffffff816687ec>] ret_from_fork+0x7c/0xb0
[ 7794.620559] irq event stamp: 15216954
[ 7794.620562] hardirqs last  enabled at (15216953): [<ffffffff81508f67>] cpuidle_enter_state+0x67/0xf0
[ 7794.620564] hardirqs last disabled at (15216954): [<ffffffff8166106a>] common_interrupt+0x6a/0x6f
[ 7794.620565] softirqs last  enabled at (0): [<          (null)>]           (null)
[ 7794.620566] softirqs last disabled at (0): [<          (null)>]           (null)
[ 7794.620566] 
[ 7794.620566] other info that might help us debug this:
[ 7794.620566]  Possible unsafe locking scenario:
[ 7794.620566] 
[ 7794.620567]        CPU0
[ 7794.620567]        ----
[ 7794.620568]   lock(&(&(&base->lock)->lock)->wait_lock);
[ 7794.620568]   <Interrupt>
[ 7794.620569]     lock(&(&(&base->lock)->lock)->wait_lock);
[ 7794.620569] 
[ 7794.620569]  *** DEADLOCK ***
[ 7794.620569] 
[ 7794.620570] no locks held by swapper/0/0.
[ 7794.620570] 
[ 7794.620570] stack backtrace:
[ 7794.620572] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rt2-dirty #585
[ 7794.620573] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[ 7794.620577]  ffffffff820fb6f0 ffff880237c03bf8 ffffffff8165aca2 ffffffff81c164c0
[ 7794.620579]  ffff880237c03c48 ffffffff816569d9 0000000000000000 ffffffff00000000
[ 7794.620581]  ffff880200000001 0000000000000002 ffffffff81c164c0 ffffffff810f9150
[ 7794.620582] Call Trace:
[ 7794.620585]  <IRQ>  [<ffffffff8165aca2>] dump_stack+0x4e/0x8f
[ 7794.620588]  [<ffffffff816569d9>] print_usage_bug+0x1f2/0x203
[ 7794.620591]  [<ffffffff810f9150>] ? check_usage_backwards+0x130/0x130
[ 7794.620596]  [<ffffffff810f9ced>] mark_lock+0x2ad/0x320
[ 7794.620598]  [<ffffffff810fb7ba>] __lock_acquire+0x87a/0x1ec0
[ 7794.620600]  [<ffffffff810fb34f>] ? __lock_acquire+0x40f/0x1ec0
[ 7794.620601]  [<ffffffff810fb34f>] ? __lock_acquire+0x40f/0x1ec0
[ 7794.620604]  [<ffffffff810fd430>] lock_acquire+0x90/0x150
[ 7794.620605]  [<ffffffff811036af>] ? rt_mutex_slowtrylock+0xf/0x80
[ 7794.620607]  [<ffffffff8166079b>] _raw_spin_lock+0x3b/0x50
[ 7794.620609]  [<ffffffff811036af>] ? rt_mutex_slowtrylock+0xf/0x80
[ 7794.620610]  [<ffffffff811036af>] rt_mutex_slowtrylock+0xf/0x80
[ 7794.620612]  [<ffffffff8165f0aa>] rt_mutex_trylock+0x2a/0x30
[ 7794.620614]  [<ffffffff8165fe36>] rt_spin_trylock+0x16/0x50
[ 7794.620616]  [<ffffffff810a0091>] get_next_timer_interrupt+0x51/0x290
[ 7794.620618]  [<ffffffff810501c4>] ? native_sched_clock+0x24/0x80
[ 7794.620620]  [<ffffffff810f6115>] __tick_nohz_idle_enter+0x305/0x4a0
[ 7794.620622]  [<ffffffff810501c4>] ? native_sched_clock+0x24/0x80
[ 7794.620624]  [<ffffffff810f6854>] tick_nohz_irq_exit+0x34/0x40
[ 7794.620626]  [<ffffffff8109709d>] irq_exit+0x10d/0x140
[ 7794.620628]  [<ffffffff8166a793>] do_IRQ+0x63/0xd0
[ 7794.620629]  [<ffffffff8166106f>] common_interrupt+0x6f/0x6f
[ 7794.620632]  <EOI>  [<ffffffff81508f6b>] ? cpuidle_enter_state+0x6b/0xf0
[ 7794.620634]  [<ffffffff815090f6>] cpuidle_idle_call+0x106/0x2b0
[ 7794.620636]  [<ffffffff810519de>] arch_cpu_idle+0xe/0x30
[ 7794.620639]  [<ffffffff810e44b8>] cpu_startup_entry+0x298/0x310
[ 7794.620642]  [<ffffffff8164b683>] rest_init+0xc3/0xd0
[ 7794.620644]  [<ffffffff8164b5c5>] ? rest_init+0x5/0xd0
[ 7794.620648]  [<ffffffff81cece74>] start_kernel+0x3dd/0x3ea
[ 7794.620650]  [<ffffffff81cec89f>] ? repair_env_string+0x5e/0x5e
[ 7794.620652]  [<ffffffff81cec5a5>] x86_64_start_reservations+0x2a/0x2c
[ 7794.620653]  [<ffffffff81cec6a2>] x86_64_start_kernel+0xfb/0xfe
