Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaJICDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:03:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaJICDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:03:19 -0400
Date: Wed, 8 Oct 2014 22:02:40 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer deadlock caused by nohz_full
Message-ID: <20141009020240.GA14090@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140925141425.GA21702@redhat.com>
 <alpine.DEB.2.10.1409251630210.4604@nanos>
 <20140925234657.GB14870@lerouge>
 <20141002182409.GA29934@redhat.com>
 <20141007153024.GA14119@lerouge>
 <20141007173730.GA12147@redhat.com>
 <alpine.DEB.2.11.1410071942100.4292@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410071942100.4292@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:42:47PM +0200, Thomas Gleixner wrote:
 > On Tue, 7 Oct 2014, Dave Jones wrote:
 > 
 > > On Tue, Oct 07, 2014 at 05:30:27PM +0200, Frederic Weisbecker wrote:
 > > 
 > >  > >  > Right, this patchset fixes it: "[PATCH 0/8] nohz: Fix nohz kick irq work on tick v3"
 > >  > >  > 
 > >  > >  > I was about to make the pull request, the branch is acked by peterz.
 > >  > >  > Would you like to pull it? It's all merge window material.
 > >  > >  > 
 > >  > >  > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
 > >  > >  > 	nohz/fixes-v3
 > >  > > 
 > >  > > I'm now hitting this with such regularity that it's preventing me from
 > >  > > tracking down other bugs.  Can we get this merged soon please ?
 > >  > 
 > >  > I asked Thomas to pull but he probably missed it. So I did a formal pull request
 > >  > to Ingo a few days later but he told me that the pull request was made too late
 > >  > as the merge window was too close. I told him it fixes annoying bugs but that was on IRC
 > >  > so this probably got lost.
 > 
 > Aarg. Lemme get this done.

So, time for sad news.
This still doesn't solve the problem for me.

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
CPU: 2 PID: 8193 Comm: kworker/u8:1 Not tainted 3.17.0+ #67
Workqueue: netns cleanup_net
 0000000000000000 000000002a473fb8 ffff880244c06c00 ffffffff9f81ea56
 ffffffff9fc63e00 ffff880244c06c80 ffffffff9f819003 0000000000000010
 ffff880244c06c90 ffff880244c06c30 000000002a473fb8 0000000000000000
Call Trace:
 <NMI>  [<ffffffff9f81ea56>] dump_stack+0x4e/0x7a
 [<ffffffff9f819003>] panic+0xd7/0x20a
 [<ffffffff9f149f30>] ? restart_watchdog_hrtimer+0x50/0x50
 [<ffffffff9f14a048>] watchdog_overflow_callback+0x118/0x120
 [<ffffffff9f18b69c>] __perf_event_overflow+0xac/0x350
 [<ffffffff9f019ece>] ? x86_perf_event_set_period+0xde/0x150
 [<ffffffff9f18c5b4>] perf_event_overflow+0x14/0x20
 [<ffffffff9f01fc26>] intel_pmu_handle_irq+0x206/0x410
 [<ffffffff9f018d2b>] perf_event_nmi_handler+0x2b/0x50
 [<ffffffff9f007752>] nmi_handle+0xd2/0x3b0
 [<ffffffff9f007685>] ? nmi_handle+0x5/0x3b0
 [<ffffffff9f0cef39>] ? get_lock_stats+0x19/0x60
 [<ffffffff9f007c62>] default_do_nmi+0x72/0x1c0
 [<ffffffff9f0fd318>] ? hrtimer_try_to_cancel+0x58/0x1f0
 [<ffffffff9f007e68>] do_nmi+0xb8/0xf0
 [<ffffffff9f82c9ea>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff9f0fd318>] ? hrtimer_try_to_cancel+0x58/0x1f0
 [<ffffffff9f0cef39>] ? get_lock_stats+0x19/0x60
 [<ffffffff9f0cef39>] ? get_lock_stats+0x19/0x60
 [<ffffffff9f0cef39>] ? get_lock_stats+0x19/0x60
 <<EOE>>  <IRQ>  [<ffffffff9f0cf880>] lock_release_holdtime.part.29+0x50/0x160
 [<ffffffff9f0d4f75>] lock_release+0x235/0x300
 [<ffffffff9f829bf4>] _raw_spin_unlock_irqrestore+0x24/0x70
 [<ffffffff9f0fd318>] hrtimer_try_to_cancel+0x58/0x1f0
 [<ffffffff9f0fd4ca>] hrtimer_cancel+0x1a/0x30
 [<ffffffff9f10de07>] tick_nohz_restart+0x17/0x90
 [<ffffffff9f10ec58>] __tick_nohz_full_check+0xc8/0xe0
 [<ffffffff9f10ec7e>] nohz_full_kick_work_func+0xe/0x10
 [<ffffffff9f1806df>] irq_work_run_list+0x4f/0x70
 [<ffffffff9f18091b>] irq_work_tick+0x2b/0x50
 [<ffffffff9f0fc00b>] update_process_times+0x5b/0x70
 [<ffffffff9f10dae5>] tick_sched_handle.isra.21+0x25/0x60
 [<ffffffff9f10ddd1>] tick_sched_timer+0x41/0x60
 [<ffffffff9f0fc991>] __run_hrtimer+0x81/0x480
 [<ffffffff9f10dd90>] ? tick_sched_do_timer+0x90/0x90
 [<ffffffff9f0fd847>] hrtimer_interrupt+0x107/0x260
 [<ffffffff9f033274>] local_apic_timer_interrupt+0x34/0x60
 [<ffffffff9f82d48f>] smp_apic_timer_interrupt+0x3f/0x60
 [<ffffffff9f82b8af>] apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffffc0415436>] ? cache_clean+0x66/0x2f0 [sunrpc]
 [<ffffffffc04156f7>] cache_flush+0x37/0x70 [sunrpc]
 [<ffffffffc041577f>] cache_purge+0x4f/0x80 [sunrpc]
 [<ffffffffc040c80a>] svcauth_unix_purge+0xca/0x1c0 [sunrpc]
 [<ffffffffc040c745>] ? svcauth_unix_purge+0x5/0x1c0 [sunrpc]
 [<ffffffffc04d4f72>] nfsd_export_shutdown+0x112/0x250 [nfsd]
 [<ffffffffc04d4e65>] ? nfsd_export_shutdown+0x5/0x250 [nfsd]
 [<ffffffffc04c972a>] nfsd_exit_net+0x1a/0x20 [nfsd]
 [<ffffffff9f6cdf39>] ops_exit_list.isra.1+0x39/0x60
 [<ffffffff9f6ceae0>] cleanup_net+0x100/0x1e0
 [<ffffffff9f097b30>] process_one_work+0x1e0/0x6b0
 [<ffffffff9f097ac7>] ? process_one_work+0x177/0x6b0
 [<ffffffff9f09811b>] worker_thread+0x11b/0x490
 [<ffffffff9f098000>] ? process_one_work+0x6b0/0x6b0
 [<ffffffff9f09ee46>] kthread+0xf6/0x110
 [<ffffffff9f09ed50>] ? kthread_create_on_node+0x250/0x250
 [<ffffffff9f82a8ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff9f09ed50>] ? kthread_create_on_node+0x250/0x250

Here's what I have on top of Linus' current tree..
http://paste.fedoraproject.org/140505/20075141/raw/

Do I miss some other essential patch ?

	Dave

