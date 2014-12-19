Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaLSPc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:32:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51153 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaLSPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:32:26 -0500
Date: Fri, 19 Dec 2014 07:32:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141219153220.GR11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
 <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
 <20141211165010.GI25340@linux.vnet.ibm.com>
 <20141211190957.GA28172@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412121431450.6587@pobox.suse.cz>
 <20141212165829.GQ25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412151400090.17292@pobox.suse.cz>
 <alpine.LNX.2.00.1412191154260.14243@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412191154260.14243@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121915-0029-0000-0000-00000685761A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 12:09:48PM +0100, Miroslav Benes wrote:
> On Mon, 15 Dec 2014, Miroslav Benes wrote:
> 
> > On Fri, 12 Dec 2014, Paul E. McKenney wrote:
> > 
> > > On Fri, Dec 12, 2014 at 03:06:20PM +0100, Miroslav Benes wrote:
> > > 
> 
> [...]
> 
> > > > One last thing. Is there a reason that there is not any similar INFO in 
> > > > the console for tiny implementation? I enabled RCU_TRACE and still got 
> > > > nothing. I have only shallow knowledge of RCU, though.
> > > 
> > > It is supposed to work given CONFIG_RCU_TRACE=y, and it looks like
> > > it should, at least as long as scheduling-clock interrupts are being
> > > delivered.  One thing to try for diagnosis is to have every (say) 1000th
> > > call to check_cpu_stall() (in kernel/rcu/tiny_plugin.h) do a printk()
> > > and same for rcu_check_callbacks() (in kernel/rcu/tiny.c).
> > 
> > Unfortunately nothing is there. I'll look into it when I have more time 
> > later this week and let you know.
> 
> So I looked into it. Scheduling-clock interrupts are delivered and 
> check_cpu_stall() in tiny_plugin.h is called twice each tick, once for 
> rcu_bh and once for rcu_sched. What happens is the following (part of the 
> printk output in check_cpu_stall)...
> 
> ...
> [  276.049053] name: rcu_bh, jiffies: 4294943345, jiffies_stall: 4294964342, rcp->curtail:           (null)
> [  276.050046] name: rcu_sched, jiffies: 4294943345, jiffies_stall: 4294943357, rcp->curtail:           (null)
> [  276.051312] name: rcu_bh, jiffies: 4294943347, jiffies_stall: 4294964345, rcp->curtail:           (null)
> [  276.052305] name: rcu_sched, jiffies: 4294943347, jiffies_stall: 4294943357, rcp->curtail:           (null)
> [  276.054634] name: rcu_bh, jiffies: 4294943356, jiffies_stall: 4294964347, rcp->curtail:           (null)
> [  276.054634] name: rcu_sched, jiffies: 4294943356, jiffies_stall: 4294943357, rcp->curtail:           (null)
> [  276.062989] name: rcu_bh, jiffies: 4294943358, jiffies_stall: 4294964356, rcp->curtail:           (null)
> [  276.063982] name: rcu_sched, jiffies: 4294943358, jiffies_stall: 4294943357, rcp->curtail:           (null)
> [  276.065285] name: rcu_bh, jiffies: 4294943361, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.066278] name: rcu_sched, jiffies: 4294943361, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.068566] name: rcu_bh, jiffies: 4294943370, jiffies_stall: 4294964361, rcp->curtail:           (null)
> [  276.068566] name: rcu_sched, jiffies: 4294943370, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.076867] name: rcu_bh, jiffies: 4294943372, jiffies_stall: 4294964370, rcp->curtail:           (null)
> [  276.077861] name: rcu_sched, jiffies: 4294943372, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.079199] name: rcu_bh, jiffies: 4294943375, jiffies_stall: 4294964372, rcp->curtail:           (null)
> [  276.080193] name: rcu_sched, jiffies: 4294943375, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.082565] name: rcu_bh, jiffies: 4294943384, jiffies_stall: 4294964375, rcp->curtail:           (null)
> [  276.082565] name: rcu_sched, jiffies: 4294943384, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.090984] name: rcu_bh, jiffies: 4294943386, jiffies_stall: 4294964384, rcp->curtail:           (null)
> [  276.091976] name: rcu_sched, jiffies: 4294943386, jiffies_stall: 4294964358, rcp->curtail:           (null)
> [  276.093296] name: rcu_bh, jiffies: 4294943389, jiffies_stall: 4294964386, rcp->curtail:           (null)
> [  276.094289] name: rcu_sched, jiffies: 4294943389, jiffies_stall: 4294964358, rcp->curtail:           (null)
> ...
> 
> In case of rcu_bh jiffies_stall is regularly updated and no stall is thus 
> detected (if I understand the code correctly). In case of rcu_sched the 
> situation is different. jiffies_stall is updated every 21 seconds (my 
> RCU_CPU_STALL_TIMEOUT). So I would say the stall should be detected there. 
> Unfortunately it is bound to *rcp->curtail being not NULL, and it is in my 
> case (in printk output there is rcp->curtail, but it is *rcp->curtail in 
> fact). The patch below did the trick for me and cpu stall was detected and 
> info printed.
> 
> ...
> [  138.534004] INFO: rcu_sched stall on CPU (41980 ticks this GP) idle=140000000000001 (t=42000 jiffies q=64)
> [  138.534004] CPU: 0 PID: 4140 Comm: test_thread Tainted: G           O   3.18.0-next-20141218-rcu_tiny_patched+ #1
> [  138.534004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20141015_183547-build31 04/01/2014
> [  138.534004]  0000000000000000 ffffffff81e2ce28 ffffffff81881b77 ffffffff81e2ce48
> [  138.534004]  ffffffff810925c1 ffffffff81e2ce68 0000000000000000 ffffffff81e2ce68
> [  138.534004]  ffffffff810932c2 0000000000000000 ffff8801395bc650 ffffffff81e2ce88
> [  138.534004] Call Trace:
> [  138.534004]  <IRQ>  [<ffffffff81881b77>] dump_stack+0x19/0x1b
> [  138.534004]  [<ffffffff810925c1>] check_cpu_stall.part.6+0x61/0xb0
> [  138.534004]  [<ffffffff810932c2>] rcu_check_callbacks+0x82/0x90
> [  138.534004]  [<ffffffff81097258>] update_process_times+0x38/0x60
> [  138.534004]  [<ffffffff810a6635>] tick_sched_handle.isra.22+0x35/0x50
> [  138.534004]  [<ffffffff810a6ab3>] tick_sched_timer+0x43/0x70
> [  138.534004]  [<ffffffff81097e1a>] __run_hrtimer+0xaa/0x240
> [  138.534004]  [<ffffffff810981b6>] ? hrtimer_interrupt+0x66/0x250
> [  138.534004]  [<ffffffff810a6a70>] ? tick_sched_do_timer+0x30/0x30
> [  138.534004]  [<ffffffff8109822f>] hrtimer_interrupt+0xdf/0x250
> [  138.534004]  [<ffffffffa0000000>] ? 0xffffffffa0000000
> [  138.534004]  [<ffffffff8102d986>] local_apic_timer_interrupt+0x26/0x50
> [  138.534004]  [<ffffffff8189026f>] smp_apic_timer_interrupt+0x3f/0x60
> [  138.534004]  [<ffffffff8188e91d>] apic_timer_interrupt+0x6d/0x80
> [  138.534004]  <EOI>  [<ffffffff8188e75c>] ? retint_restore_args+0xe/0xe
> [  138.534004]  [<ffffffff81062c9d>] ? kthread_should_stop+0x1d/0x30
> [  138.534004]  [<ffffffffa0000015>] ? test_thread_fn+0x15/0x20 [kthread_mod]
> [  138.534004]  [<ffffffff81063139>] kthread+0xf9/0x110
> [  138.534004]  [<ffffffff81063040>] ? kthread_create_on_node+0x230/0x230
> [  138.534004]  [<ffffffff8188da2a>] ret_from_fork+0x7a/0xb0
> [  138.534004]  [<ffffffff81063040>] ? kthread_create_on_node+0x230/0x230
> ...
> 
> But I'm not sure whether it is possible that the list of pending callback 
> is empty. Maybe the bug is elsewhere. My understanding of RCU is limited 
> but I'll try to look around. Also the commit log might be imprecise :/

You found the problem, good show!  However, we do need a slightly
different fix, please see below.

> Best regards,
> Miroslav
> 
> -- >8 --
> >From be3495519513356daa366517bb458bc4f05ecf9b Mon Sep 17 00:00:00 2001
> From: Miroslav Benes <mbenes@suse.cz>
> Date: Fri, 19 Dec 2014 11:11:04 +0100
> Subject: [PATCH] rcu: fix rcu stall detection in tiny implementation

The first word following a ":" needs to be capitalized.

> The current tiny RCU stall detection depends on presence of pending callbacks in
> the list (*rcp->curtail et al.). But they are none even in case of real CPU
> stalls prohibiting the detection. When the check for callback presence is
> removed, INFO about the stall is correctly printed.

As you say, this needs to be reworked, but first please see below.

> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  kernel/rcu/tiny_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
> index 858c565..3f743fa 100644
> --- a/kernel/rcu/tiny_plugin.h
> +++ b/kernel/rcu/tiny_plugin.h
> @@ -145,7 +145,7 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
>  	rcp->ticks_this_gp++;
>  	j = jiffies;
>  	js = ACCESS_ONCE(rcp->jiffies_stall);
> -	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
> +	if (ULONG_CMP_GE(j, js)) {

The problem is that ->curtail is a tail pointer, and thus always points
to a NULL pointer, so the expression is always false.  However, we don't
want to give RCU CPU stall warnings if there are no callbacks, because
this can result in spurious stall warnings after long idle periods.

So we need to check the header pointer as follows:

+	if (rcp->rcucblist && ULONG_CMP_GE(j, js)) {

But what do you do if your test module happens to start spinning when
there is no callback?

One approach is to do a call_rcu() just after starting your loop.
Alternatively, do several just before starting your loop.

							Thanx, Paul

>  		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
>  		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
>  		       jiffies - rcp->gp_start, rcp->qlen);
> -- 
> 2.1.2
> 

