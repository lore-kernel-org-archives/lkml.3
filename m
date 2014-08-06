Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaHFTrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:47:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaHFTrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:47:24 -0400
Date: Wed, 6 Aug 2014 15:46:56 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: perf related boot hang.
Message-ID: <20140806194656.GA11570@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140806143621.GA13832@redhat.com>
 <20140806161934.GF19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806161934.GF19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 06:19:34PM +0200, Peter Zijlstra wrote:
 > On Wed, Aug 06, 2014 at 10:36:21AM -0400, Dave Jones wrote:
 > > On Linus current tree, when I cold-boot one of my boxes, it locks up
 > > during boot up with this trace..
 > > 
 > > Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
 > > CPU: 2 PID: 577 Comm: in:imjournal Not tainted 3.16.0+ #33
 > >  ffff880244c06c88 000000008b73013e ffff880244c06bf0 ffffffffb47ee207
 > >  ffffffffb4c51118 ffff880244c06c78 ffffffffb47ebcf8 0000000000000010
 > >  ffff880244c06c88 ffff880244c06c20 000000008b73013e 0000000000000000
 > > Call Trace:
 > >  <NMI>  [<ffffffffb47ee207>] dump_stack+0x4e/0x7a
 > >  [<ffffffffb47ebcf8>] panic+0xd4/0x207
 > >  [<ffffffffb4145448>] watchdog_overflow_callback+0x118/0x120
 > >  [<ffffffffb4186f0e>] __perf_event_overflow+0xae/0x350
 > >  [<ffffffffb4185380>] ? perf_event_task_disable+0xa0/0xa0
 > >  [<ffffffffb401a4ef>] ? x86_perf_event_set_period+0xbf/0x150
 > >  [<ffffffffb4187d34>] perf_event_overflow+0x14/0x20
 > >  [<ffffffffb40203a6>] intel_pmu_handle_irq+0x206/0x410
 > >  [<ffffffffb401939b>] perf_event_nmi_handler+0x2b/0x50
 > >  [<ffffffffb4007b72>] nmi_handle+0xd2/0x390
 > >  [<ffffffffb4007aa5>] ? nmi_handle+0x5/0x390
 > >  [<ffffffffb40d8301>] ? lock_acquired+0x131/0x450
 > >  [<ffffffffb4008062>] default_do_nmi+0x72/0x1c0
 > > 
 > > 
 > > If I reset it, it then seems to always boot up fine.
 > 
 > Uhm,. cute! And that's the entire stacktrace? It would seem to me there
 > would be at least a 'task' context below that. CPUs simply do not _only_
 > run NMI code, and that trace starts at default_do_nmi().

This one happened during runtime, but I got a whole stack..


 Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
 CPU: 2 PID: 7538 Comm: kworker/u8:8 Not tainted 3.16.0+ #34
 Workqueue: btrfs-endio-write normal_work_helper [btrfs]
  ffff880244c06c88 000000001b486fe1 ffff880244c06bf0 ffffffff8a7f1e37
  ffffffff8ac52a18 ffff880244c06c78 ffffffff8a7ef928 0000000000000010
  ffff880244c06c88 ffff880244c06c20 000000001b486fe1 0000000000000000
 Call Trace:
  <NMI>  [<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
  [<ffffffff8a7ef928>] panic+0xd4/0x207
  [<ffffffff8a1450e8>] watchdog_overflow_callback+0x118/0x120
  [<ffffffff8a186b0e>] __perf_event_overflow+0xae/0x350
  [<ffffffff8a184f80>] ? perf_event_task_disable+0xa0/0xa0
  [<ffffffff8a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
  [<ffffffff8a187934>] perf_event_overflow+0x14/0x20
  [<ffffffff8a020386>] intel_pmu_handle_irq+0x206/0x410
  [<ffffffff8a01937b>] perf_event_nmi_handler+0x2b/0x50
  [<ffffffff8a007b72>] nmi_handle+0xd2/0x390
  [<ffffffff8a007aa5>] ? nmi_handle+0x5/0x390
  [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
  [<ffffffff8a008062>] default_do_nmi+0x72/0x1c0
  [<ffffffff8a008268>] do_nmi+0xb8/0x100
  [<ffffffff8a7ff66a>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
  [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
  [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
  <<EOE>>  <IRQ>  [<ffffffff8a0ccd2f>] lock_acquired+0xaf/0x450
  [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
  [<ffffffff8a7fc678>] _raw_spin_lock_irqsave+0x78/0x90
  [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
  [<ffffffff8a0f74c5>] lock_hrtimer_base.isra.20+0x25/0x50
  [<ffffffff8a0f7723>] hrtimer_try_to_cancel+0x33/0x1e0
  [<ffffffff8a0f78ea>] hrtimer_cancel+0x1a/0x30
  [<ffffffff8a109237>] tick_nohz_restart+0x17/0x90
  [<ffffffff8a10a213>] __tick_nohz_full_check+0xc3/0x100
  [<ffffffff8a10a25e>] nohz_full_kick_work_func+0xe/0x10
  [<ffffffff8a17c884>] irq_work_run_list+0x44/0x70
  [<ffffffff8a17c8da>] irq_work_run+0x2a/0x50
  [<ffffffff8a0f700b>] update_process_times+0x5b/0x70
  [<ffffffff8a109005>] tick_sched_handle.isra.21+0x25/0x60
  [<ffffffff8a109b81>] tick_sched_timer+0x41/0x60
  [<ffffffff8a0f7aa2>] __run_hrtimer+0x72/0x470
  [<ffffffff8a109b40>] ? tick_sched_do_timer+0xb0/0xb0
  [<ffffffff8a0f8707>] hrtimer_interrupt+0x117/0x270
  [<ffffffff8a034357>] local_apic_timer_interrupt+0x37/0x60
  [<ffffffff8a80010f>] smp_apic_timer_interrupt+0x3f/0x50
  [<ffffffff8a7fe52f>] apic_timer_interrupt+0x6f/0x80
  <EOI>  [<ffffffff8a1f13ca>] ? __slab_alloc+0x1da/0x620
  [<ffffffff8a0ad9db>] ? preempt_count_sub+0xab/0x100
  [<ffffffff8a7fc7d1>] ? _raw_spin_unlock+0x31/0x50
  [<ffffffffc03df896>] ? btrfs_alloc_free_block+0x276/0x3e0 [btrfs]
  [<ffffffff8a0cb9f6>] ? __lock_is_held+0x56/0x80
  [<ffffffff8a1f1a2f>] kmem_cache_alloc+0x21f/0x300
  [<ffffffffc03df896>] ? btrfs_alloc_free_block+0x276/0x3e0 [btrfs]
  [<ffffffffc03df896>] btrfs_alloc_free_block+0x276/0x3e0 [btrfs]
  [<ffffffffc03cb987>] split_leaf+0x167/0x750 [btrfs]
  [<ffffffffc03cc949>] btrfs_search_slot+0x9d9/0xb10 [btrfs]
  [<ffffffffc0417fbf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
  [<ffffffffc03e6fea>] btrfs_csum_file_blocks+0x48a/0x720 [btrfs]
  [<ffffffffc03f5c10>] add_pending_csums.isra.41+0x50/0x70 [btrfs]
  [<ffffffffc03fc9c0>] btrfs_finish_ordered_io+0x340/0x660 [btrfs]
  [<ffffffffc03fcf75>] finish_ordered_fn+0x15/0x20 [btrfs]
  [<ffffffffc042605a>] normal_work_helper+0xca/0x5d0 [btrfs]
  [<ffffffff8a0993fe>] process_one_work+0x1fe/0x6d0
  [<ffffffff8a09939e>] ? process_one_work+0x19e/0x6d0
  [<ffffffff8a09993b>] worker_thread+0x6b/0x4a0
  [<ffffffff8a0998d0>] ? process_one_work+0x6d0/0x6d0
  [<ffffffff8a09fd98>] kthread+0x108/0x120
  [<ffffffff8a397cb7>] ? debug_smp_processor_id+0x17/0x20
  [<ffffffff8a09fc90>] ? kthread_create_on_node+0x250/0x250
  [<ffffffff8a7fd52c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8a09fc90>] ? kthread_create_on_node+0x250/0x250

