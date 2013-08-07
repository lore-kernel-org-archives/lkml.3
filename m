Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab3HGXWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:22:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35800 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933689Ab3HGXWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:22:34 -0400
Date: Wed, 7 Aug 2013 19:22:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130807232224.GA10476@Krystal>
References: <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com> <1375811885.25420.44.camel@gandalf.local.home> <20130806203319.GA16170@Krystal> <1375821817.25420.50.camel@gandalf.local.home> <1375836304.25420.76.camel@gandalf.local.home> <1375836960.25420.80.camel@gandalf.local.home> <20130807050601.GA5385@domone.kolej.mff.cuni.cz> <1375887730.6848.7.camel@gandalf.local.home> <20130807160336.GA1336@Krystal> <1375891895.6848.9.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375891895.6848.9.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2013-08-07 at 12:03 -0400, Mathieu Desnoyers wrote:
> 
> > You might want to try creating a global array of counters (accessible
> > both from C for printout and assembly for update).
> > 
> > Index the array from assembly using:   (2f - 1f)
> > 
> > 1:
> >         jmp ...;
> > 2:
> > 
> > And put an atomic increment of the counter. This increment instruction
> > should be located prior to the jmp for obvious reasons.
> > 
> > You'll end up with the sums you're looking for at indexes 2 and 5 of the
> > array.
> 
> After I post the patches, feel free to knock yourself out.

I just need the calculation, not the entire patchset. For this purpose:

Based on top of 3.10.5:

---
 arch/x86/include/asm/jump_label.h |   15 ++++++++++++++-
 include/linux/jump_label.h        |    3 +++
 kernel/jump_label.c               |   12 ++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/x86/include/asm/jump_label.h
+++ linux/arch/x86/include/asm/jump_label.h
@@ -15,9 +15,20 @@ static __always_inline bool arch_static_
 {
 	asm goto("1:"
 		STATIC_KEY_INITIAL_NOP
+#ifdef CONFIG_X86_64
+		"lock; incq 4f \n\t"
+#else
+		"lock; incl 4f \n\t"
+#endif
+		"jmp 3f \n\t"
+		"2:"
+		"jmp %l[l_yes] \n\t"
+		"3:"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
-		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0, (3b - 2b) \n\t"
+		"4:"	/* nr_hit */
+		_ASM_PTR "0 \n\t"
 		".popsection \n\t"
 		: :  "i" (key) : : l_yes);
 	return false;
@@ -37,6 +48,8 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	jump_label_t jmp_insn_len;
+	jump_label_t nr_hit;
 };
 
 #endif
Index: linux/include/linux/jump_label.h
===================================================================
--- linux.orig/include/linux/jump_label.h
+++ linux/include/linux/jump_label.h
@@ -208,4 +208,7 @@ static inline bool static_key_enabled(st
 	return (atomic_read(&key->enabled) > 0);
 }
 
+struct jump_entry *get_jump_label_start(void);
+struct jump_entry *get_jump_label_stop(void);
+
 #endif	/* _LINUX_JUMP_LABEL_H */
Index: linux/kernel/jump_label.c
===================================================================
--- linux.orig/kernel/jump_label.c
+++ linux/kernel/jump_label.c
@@ -16,6 +16,18 @@
 
 #ifdef HAVE_JUMP_LABEL
 
+struct jump_entry *get_jump_label_start(void)
+{
+	return __start___jump_table;
+}
+EXPORT_SYMBOL_GPL(get_jump_label_start);
+
+struct jump_entry *get_jump_label_stop(void)
+{
+	return __stop___jump_table;
+}
+EXPORT_SYMBOL_GPL(get_jump_label_stop);
+
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
---------
test.c:

/*
 * Copyright 2013 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 *
 * GPLv2 license.
 */

#include <linux/module.h>
#include <linux/mm.h>
#include <linux/kernel.h>
#include <linux/jump_label.h>
#include <linux/kallsyms.h>

void print_static_jumps(void)
{
	struct jump_entry *iter_start = get_jump_label_start();
	struct jump_entry *iter_stop = get_jump_label_stop();
	struct jump_entry *iter;

	for (iter = iter_start; iter < iter_stop; iter++) {
		char symbol[KSYM_SYMBOL_LEN] = "";

		if (sprint_symbol(symbol, iter->code) == 0) {
			WARN_ON_ONCE(1);
		}
		printk("Jump label: addr: %lx symbol: %s ilen: %lu hits: %lu\n",
			(unsigned long) iter->code, symbol,
			(unsigned long) iter->jmp_insn_len,
			(unsigned long) iter->nr_hit);
	}
}

int initfct(void)
{
	print_static_jumps();

	return -EPERM;
}

module_init(initfct);

MODULE_LICENSE("GPL");

----------------------

Results sorted by reverse number of hits, after boot + starting firefox,
200s after boot:

Jump label: addr: ffffffff810d9805 symbol: balance_dirty_pages_ratelimited+0x425/0x9c0 ilen: 5  814700
Jump label: addr: ffffffff81138135 symbol: writeback_sb_inodes+0x195/0x4a0 ilen: 5  752021
Jump label: addr: ffffffff8103695e symbol: call_console_drivers.constprop.13+0xe/0x140 ilen: 5  726153
Jump label: addr: ffffffff8103ce11 symbol: __do_softirq+0xe1/0x310 ilen: 5  724803
Jump label: addr: ffffffff810e07a6 symbol: shrink_inactive_list+0x2e6/0x420 ilen: 2  328701
Jump label: addr: ffffffff810dfdad symbol: shrink_page_list+0x56d/0x8c0 ilen: 5  315157
Jump label: addr: ffffffff810e9510 symbol: congestion_wait+0xb0/0x170 ilen: 2  241653
Jump label: addr: ffffffff810deb0f symbol: shrink_slab+0x1df/0x390 ilen: 5  231215
Jump label: addr: ffffffff810d9bd7 symbol: balance_dirty_pages_ratelimited+0x7f7/0x9c0 ilen: 5  166859
Jump label: addr: ffffffff815a8270 symbol: rcu_cpu_notify+0x14/0x882 ilen: 5  162468
Jump label: addr: ffffffff810a182d symbol: rcu_process_callbacks+0x2d/0x980 ilen: 5  162385
Jump label: addr: ffffffff8116a4e7 symbol: oom_score_adj_write+0x187/0x280 ilen: 2  157640
Jump label: addr: ffffffff810746c7 symbol: cpu_startup_entry+0x107/0x2d0 ilen: 2  140922
Jump label: addr: ffffffff8145e44f symbol: cpuidle_idle_call+0x9f/0x2d0 ilen: 5  140814
Jump label: addr: ffffffff810a04ab symbol: rcu_eqs_exit_common+0x12b/0x250 ilen: 2  133403
Jump label: addr: ffffffff810a07a8 symbol: rcu_eqs_enter_common+0x128/0x250 ilen: 2  133305
Jump label: addr: ffffffff810a2ec5 symbol: rcu_irq_enter+0x55/0x150 ilen: 2  133213
Jump label: addr: ffffffff810a289a symbol: __call_rcu.constprop.45+0x17a/0x3a0 ilen: 5  132999
Jump label: addr: ffffffff8105243e symbol: __queue_work+0xbe/0x380 ilen: 5  113973
Jump label: addr: ffffffff810deeb4 symbol: isolate_lru_pages.isra.56+0x104/0x230 ilen: 2  102282
Jump label: addr: ffffffff8100e537 symbol: syscall_trace_enter+0x207/0x2b0 ilen: 2  92971
Jump label: addr: ffffffff8100e763 symbol: syscall_trace_leave+0x183/0x210 ilen: 2  92890
Jump label: addr: ffffffff81084d04 symbol: __module_get+0x44/0x130 ilen: 2  88347
Jump label: addr: ffffffff8105c8e6 symbol: kthread_stop+0x66/0x1a0 ilen: 5  88347
Jump label: addr: ffffffff815a7af7 symbol: hrtimer_cpu_notify+0x147/0x228 ilen: 5  85377
Jump label: addr: ffffffff8105feb8 symbol: hrtimer_try_to_cancel+0x48/0x140 ilen: 2  85374
Jump label: addr: ffffffff8103b12e symbol: set_cpu_itimer+0x17e/0x270 ilen: 2  85371
Jump label: addr: ffffffff8109ff98 symbol: rcu_report_qs_rnp+0x88/0x200 ilen: 2  82824
Jump label: addr: ffffffff810a06af symbol: rcu_eqs_enter_common+0x2f/0x250 ilen: 2  67220
Jump label: addr: ffffffff810d9286 symbol: __bdi_update_bandwidth+0x2d6/0x430 ilen: 2  58486
Jump label: addr: ffffffff810a1986 symbol: rcu_process_callbacks+0x186/0x980 ilen: 5  42037
Jump label: addr: ffffffff810d0152 symbol: add_to_page_cache_locked+0x92/0x1a0 ilen: 2  41077
Jump label: addr: ffffffff810a1ac4 symbol: rcu_process_callbacks+0x2c4/0x980 ilen: 5  38498
Jump label: addr: ffffffff815a854e symbol: rcu_cpu_notify+0x2f2/0x882 ilen: 5  37915
Jump label: addr: ffffffff8100a193 symbol: default_idle+0x13/0x170 ilen: 2  36821
Jump label: addr: ffffffff8145c41d symbol: __cpufreq_notify_transition+0x19d/0x240 ilen: 5  36820
Jump label: addr: ffffffff81182025 symbol: ext3_truncate+0xc5/0x6f0 ilen: 5  36175
Jump label: addr: ffffffff810a0eab symbol: rcu_accelerate_cbs+0x19b/0x420 ilen: 5  34230
Jump label: addr: ffffffff810a1257 symbol: __rcu_process_gp_end+0x57/0x170 ilen: 2  34212
Jump label: addr: ffffffff810a1a38 symbol: rcu_process_callbacks+0x238/0x980 ilen: 5  33883
Jump label: addr: ffffffff810a1b3b symbol: rcu_process_callbacks+0x33b/0x980 ilen: 5  33882
Jump label: addr: ffffffff81059544 symbol: do_trace_rcu_torture_read+0x34/0x120 ilen: 2  33881
Jump label: addr: ffffffff81286602 symbol: blk_queue_bio+0x1b2/0x420 ilen: 2  32736
Jump label: addr: ffffffff8106906e symbol: rt_mutex_setprio+0x7e/0x290 ilen: 5  31821
Jump label: addr: ffffffff8127fb6b symbol: __elv_add_request+0x2b/0x350 ilen: 5  27443
Jump label: addr: ffffffff815afd2b symbol: __schedule+0x15b/0x8e0 ilen: 5  21613
Jump label: addr: ffffffff8104fd85 symbol: __request_module+0xf5/0x320 ilen: 5  21613
Jump label: addr: ffffffff810d8c39 symbol: global_dirty_limits+0xa9/0x1b0 ilen: 2  20980
Jump label: addr: ffffffff81286720 symbol: blk_queue_bio+0x2d0/0x420 ilen: 2  19492
Jump label: addr: ffffffff810a03be symbol: rcu_eqs_exit_common+0x3e/0x250 ilen: 2  17205
Jump label: addr: ffffffff8117e93f symbol: ext3_new_inode+0x3f/0xb60 ilen: 5  16992
Jump label: addr: ffffffff8117e5da symbol: ext3_free_inode+0x5a/0x380 ilen: 2  16992
Jump label: addr: ffffffff8113932f symbol: bdi_writeback_workfn+0x7f/0x270 ilen: 2  15614
Jump label: addr: ffffffff81138a29 symbol: wb_writeback+0x159/0x400 ilen: 5  15614
Jump label: addr: ffffffff81044f85 symbol: detach_if_pending+0x35/0x160 ilen: 2  14664
Jump label: addr: ffffffff81044e72 symbol: init_timer_key+0x22/0x100 ilen: 2  14403
Jump label: addr: ffffffff81049c52 symbol: get_signal_to_deliver+0x162/0x670 ilen: 5  14400
Jump label: addr: ffffffff810496a2 symbol: send_sigqueue+0x102/0x230 ilen: 2  14174
Jump label: addr: ffffffff81048118 symbol: __send_signal.constprop.29+0x188/0x3b0 ilen: 2  14174
Jump label: addr: ffffffff810a2d63 symbol: rcu_irq_exit+0x53/0x160 ilen: 2  13479
Jump label: addr: ffffffff81034321 symbol: do_fork+0xc1/0x320 ilen: 5  12516
Jump label: addr: ffffffff81182d8a symbol: ext3_journalled_write_end+0x3a/0x270 ilen: 5  11670
Jump label: addr: ffffffff8142c358 symbol: make_request+0x268/0xb60 ilen: 2  11625
Jump label: addr: ffffffff81329fcf symbol: credit_entropy_bits+0x12f/0x210 ilen: 5  11625
Jump label: addr: ffffffff8132a8a9 symbol: get_random_bytes_arch+0x19/0x130 ilen: 5  11540
Jump label: addr: ffffffff812837bf symbol: bio_attempt_back_merge+0x3f/0x150 ilen: 2  11075
Jump label: addr: ffffffff8128406c symbol: queue_unplugged+0x2c/0x120 ilen: 2  10989
Jump label: addr: ffffffff8144670d symbol: dec_pending+0x19d/0x390 ilen: 2  10904
Jump label: addr: ffffffff8151b640 symbol: udp_recvmsg+0x350/0x440 ilen: 2  10642
Jump label: addr: ffffffff8105fb40 symbol: __run_hrtimer+0x80/0x2a0 ilen: 2  10276
Jump label: addr: ffffffff8105fb1f symbol: __run_hrtimer+0x5f/0x2a0 ilen: 5  10276
Jump label: addr: ffffffff8105f622 symbol: enqueue_hrtimer+0x22/0x100 ilen: 2  10276
Jump label: addr: ffffffff81182fff symbol: ext3_get_blocks_handle+0x3f/0xd80 ilen: 2  9342
Jump label: addr: ffffffff81284fde symbol: get_request+0x37e/0x680 ilen: 5  8942
Jump label: addr: ffffffff81184c1f symbol: ext3_evict_inode+0x1f/0x300 ilen: 5  8428
Jump label: addr: ffffffff811819fd symbol: ext3_mark_inode_dirty+0x2d/0x110 ilen: 2  8419
Jump label: addr: ffffffff81039e05 symbol: do_wait+0x15/0x2b0 ilen: 5  8310
Jump label: addr: ffffffff810a4650 symbol: rcu_note_context_switch+0x10/0x3d0 ilen: 2  8183
Jump label: addr: ffffffff815a89fe symbol: rcu_cpu_notify+0x7a2/0x882 ilen: 5  7871
Jump label: addr: ffffffff8105fae7 symbol: __run_hrtimer+0x27/0x2a0 ilen: 5  7746
Jump label: addr: ffffffff8158c796 symbol: svc_udp_recvfrom+0x276/0x470 ilen: 2  7540
Jump label: addr: ffffffff8106ca15 symbol: update_curr+0xb5/0x1e0 ilen: 2  7149
Jump label: addr: ffffffff814c144c symbol: kfree_skb+0x3c/0x120 ilen: 2  6955
Jump label: addr: ffffffff81100f61 symbol: blk_queue_bounce+0x2e1/0x320 ilen: 5  6673
Jump label: addr: ffffffff81365b8f symbol: wakeup_source_deactivate+0xaf/0x190 ilen: 2  6608
Jump label: addr: ffffffff81088561 symbol: load_module+0x1a21/0x2390 ilen: 5  6605
Jump label: addr: ffffffff81283913 symbol: bio_attempt_front_merge+0x43/0x1b0 ilen: 5  6296
Jump label: addr: ffffffff8106a4d7 symbol: wake_up_new_task+0xc7/0x1e0 ilen: 2  6057
Jump label: addr: ffffffff8105c88d symbol: kthread_stop+0xd/0x1a0 ilen: 2  6057
Jump label: addr: ffffffff81427d48 symbol: return_io+0x58/0x110 ilen: 2  5594
Jump label: addr: ffffffff8109f7d0 symbol: _rcu_barrier_trace+0x40/0x120 ilen: 2  5356
Jump label: addr: ffffffff81560625 symbol: udpv6_recvmsg+0x515/0x610 ilen: 2  5342
Jump label: addr: ffffffff810600cc symbol: __hrtimer_start_range_ns+0x4c/0x420 ilen: 5  5025
Jump label: addr: ffffffff810071e9 symbol: emulate_vsyscall+0x59/0x400 ilen: 5  4906
Jump label: addr: ffffffff810dea68 symbol: shrink_slab+0x138/0x390 ilen: 5  4203
Jump label: addr: ffffffff81285e55 symbol: blk_peek_request+0x65/0x270 ilen: 5  4091
Jump label: addr: ffffffff814cc1fa symbol: netif_receive_skb+0x1a/0xc0 ilen: 2  4078
Jump label: addr: ffffffff81189404 symbol: ext3_unlink+0x14/0x300 ilen: 5  3943
Jump label: addr: ffffffff8109d830 symbol: handle_percpu_devid_irq+0x50/0x1c0 ilen: 2  3862
Jump label: addr: ffffffff810e1aa0 symbol: try_to_free_pages+0x3c0/0x530 ilen: 2  3696
Jump label: addr: ffffffff8103cdf7 symbol: __do_softirq+0xc7/0x310 ilen: 5  3669
Jump label: addr: ffffffff810a4541 symbol: rcu_read_unlock_special+0x2c1/0x3c0 ilen: 2  3662
Jump label: addr: ffffffff8109d84c symbol: handle_percpu_devid_irq+0x6c/0x1c0 ilen: 5  3662
Jump label: addr: ffffffff8117d24d symbol: ext3_trim_fs+0x53d/0x8c0 ilen: 5  3524
Jump label: addr: ffffffff812844a7 symbol: blk_update_request+0x27/0x420 ilen: 5  3487
Jump label: addr: ffffffff8109a438 symbol: handle_irq_event_percpu+0x68/0x2a0 ilen: 5  3400
Jump label: addr: ffffffff8107de91 symbol: __tick_nohz_idle_enter+0x1b1/0x4c0 ilen: 5  3400
Jump label: addr: ffffffff8117bb4e symbol: ext3_discard_reservation+0x7e/0x170 ilen: 2  3393
Jump label: addr: ffffffff8117b474 symbol: ext3_try_to_allocate_with_rsv+0x184/0x760 ilen: 5  3393
Jump label: addr: ffffffff810450ec symbol: call_timer_fn+0x3c/0x1f0 ilen: 5  2989
Jump label: addr: ffffffff815886a3 symbol: __rpc_execute+0x293/0x3d0 ilen: 2  2806
Jump label: addr: ffffffff8157ff7c symbol: call_status+0x8c/0x280 ilen: 2  2806
Jump label: addr: ffffffff815878c5 symbol: __rpc_sleep_on_priority+0x35/0x350 ilen: 5  2804
Jump label: addr: ffffffff814cadb7 symbol: dev_queue_xmit_nit+0x107/0x220 ilen: 5  2584
Jump label: addr: ffffffff814cc1e8 symbol: netif_receive_skb+0x8/0xc0 ilen: 2  2536
Jump label: addr: ffffffff811143c6 symbol: search_binary_handler+0x266/0x3c0 ilen: 5  2369
Jump label: addr: ffffffff810d0703 symbol: __delete_from_page_cache+0x23/0x1a0 ilen: 5  2324
Jump label: addr: ffffffff810457cf symbol: mod_timer_pinned+0x5f/0x1c0 ilen: 5  2108
Jump label: addr: ffffffff813656a0 symbol: wakeup_source_report_event+0xa0/0x140 ilen: 2  2051
Jump label: addr: ffffffff81074077 symbol: suspend_devices_and_enter+0x177/0x3b0 ilen: 5  2051
Jump label: addr: ffffffff81073f21 symbol: suspend_devices_and_enter+0x21/0x3b0 ilen: 5  2051
Jump label: addr: ffffffff815801f0 symbol: call_bind_status+0x50/0x230 ilen: 2  1835
Jump label: addr: ffffffff814c85a5 symbol: net_tx_action+0x65/0x1f0 ilen: 5  1701
Jump label: addr: ffffffff814c8996 symbol: __netif_receive_skb_core+0x16/0x5e0 ilen: 5  1683
Jump label: addr: ffffffff814ca83d symbol: netif_rx+0xd/0x1f0 ilen: 5  1681
Jump label: addr: ffffffff81066eae symbol: finish_task_switch+0x2e/0xf0 ilen: 2  1679
Jump label: addr: ffffffff815afd65 symbol: __schedule+0x195/0x8e0 ilen: 5  1677
Jump label: addr: ffffffff810d858a symbol: write_cache_pages+0x1aa/0x470 ilen: 5  1619
Jump label: addr: ffffffff811387b0 symbol: queue_io+0x150/0x270 ilen: 2  1614
Jump label: addr: ffffffff810459bb symbol: mod_timer+0x8b/0x270 ilen: 5  1587
Jump label: addr: ffffffff8151d70d symbol: udp_destroy_sock+0x2d/0x90 ilen: 2  1452
Jump label: addr: ffffffff815afd50 symbol: __schedule+0x180/0x8e0 ilen: 5  1445
Jump label: addr: ffffffff8109a458 symbol: handle_irq_event_percpu+0x88/0x2a0 ilen: 2  1427
Jump label: addr: ffffffff8117fee0 symbol: ext3_writeback_writepage+0xd0/0x230 ilen: 5  1303
Jump label: addr: ffffffff81180110 symbol: ext3_ordered_writepage+0xd0/0x2f0 ilen: 5  1209
Jump label: addr: ffffffff8151a063 symbol: raw_sendmsg+0x793/0x940 ilen: 5  1128
Jump label: addr: ffffffff81588b03 symbol: rpc_execute+0x23/0x120 ilen: 2  1127
Jump label: addr: ffffffff8158848a symbol: __rpc_execute+0x7a/0x3d0 ilen: 2  1127
Jump label: addr: ffffffff8157f230 symbol: call_connect_status+0x30/0x190 ilen: 2  1127
Jump label: addr: ffffffff814f7632 symbol: __ip_local_out+0x32/0x80 ilen: 2  1121
Jump label: addr: ffffffff81538d89 symbol: xfrm4_output+0x39/0xa0 ilen: 2  1120
Jump label: addr: ffffffff8103d1eb symbol: __raise_softirq_irqoff+0x1b/0xe0 ilen: 2  1119
Jump label: addr: ffffffff814f2eae symbol: ip_rcv+0x1fe/0x330 ilen: 2  1110
Jump label: addr: ffffffff81085905 symbol: module_put+0x45/0x150 ilen: 2  907
Jump label: addr: ffffffff81067bf7 symbol: ttwu_do_wakeup+0x27/0x150 ilen: 5  907
Jump label: addr: ffffffff81138598 symbol: __bdi_start_writeback+0x88/0x150 ilen: 2  613
Jump label: addr: ffffffff811e3dca symbol: ext4_es_find_delayed_extent_range+0x2a/0x260 ilen: 5  514
Jump label: addr: ffffffff810453f1 symbol: run_timer_softirq+0x151/0x2b0 ilen: 5  419
Jump label: addr: ffffffff814ca867 symbol: netif_rx+0x37/0x1f0 ilen: 2  414
Jump label: addr: ffffffff8103b6d4 symbol: do_setitimer+0x164/0x2e0 ilen: 5  398
Jump label: addr: ffffffff8117b828 symbol: ext3_try_to_allocate_with_rsv+0x538/0x760 ilen: 5  351
Jump label: addr: ffffffff81184919 symbol: ext3_direct_IO+0x169/0x450 ilen: 5  299
Jump label: addr: ffffffff81184831 symbol: ext3_direct_IO+0x81/0x450 ilen: 5  276
Jump label: addr: ffffffff8117afbb symbol: read_block_bitmap+0x3b/0x230 ilen: 2  206
Jump label: addr: ffffffff81138e6b symbol: bdi_start_background_writeback+0x1b/0xe0 ilen: 2  205
Jump label: addr: ffffffff8118068b symbol: ext3_readpage+0x1b/0xd0 ilen: 2  202
Jump label: addr: ffffffff8117caa7 symbol: ext3_new_blocks+0x6b7/0x790 ilen: 2  183
Jump label: addr: ffffffff8117c288 symbol: ext3_free_blocks+0x38/0x130 ilen: 2  183
Jump label: addr: ffffffff81074701 symbol: cpu_startup_entry+0x141/0x2d0 ilen: 5  183
Jump label: addr: ffffffff8100a1b0 symbol: default_idle+0x30/0x170 ilen: 5  183
Jump label: addr: ffffffff810e9c15 symbol: bdi_register+0x115/0x1c0 ilen: 2  175
Jump label: addr: ffffffff810e9902 symbol: bdi_unregister+0x22/0x220 ilen: 5  175
Jump label: addr: ffffffff810a469c symbol: rcu_note_context_switch+0x5c/0x3d0 ilen: 5  171
Jump label: addr: ffffffff811e3a30 symbol: ext4_es_lookup_extent+0xa0/0x230 ilen: 5  169
Jump label: addr: ffffffff8117e24f symbol: ext3_sync_file+0x4f/0x2e0 ilen: 2  167
Jump label: addr: ffffffff8127f157 symbol: elv_abort_queue+0x37/0xf0 ilen: 2  161
Jump label: addr: ffffffff811828b5 symbol: ext3_ordered_write_end+0x45/0x220 ilen: 5  140
Jump label: addr: ffffffff811826c9 symbol: ext3_writeback_write_end+0x59/0x200 ilen: 5  140
Jump label: addr: ffffffff811e3ea1 symbol: ext4_es_find_delayed_extent_range+0x101/0x260 ilen: 2  138
Jump label: addr: ffffffff811e39a6 symbol: ext4_es_lookup_extent+0x16/0x230 ilen: 5  138
Jump label: addr: ffffffff814ff669 symbol: tcp_prequeue_process+0x59/0xc0 ilen: 2  127
Jump label: addr: ffffffff814cc00e symbol: __netif_receive_skb+0xe/0x80 ilen: 2  109
Jump label: addr: ffffffff81180d03 symbol: ext3_forget+0x33/0x1c0 ilen: 5  100
Jump label: addr: ffffffff8132924d symbol: __mix_pool_bytes+0x3d/0x110 ilen: 2  85
Jump label: addr: ffffffff812835aa symbol: generic_make_request_checks+0x20a/0x3e0 ilen: 5  85
Jump label: addr: ffffffff811f7986 symbol: do_get_write_access+0x2a6/0x770 ilen: 2  76
Jump label: addr: ffffffff811f07cc symbol: log_do_checkpoint+0x1c/0x6b0 ilen: 5  76
Jump label: addr: ffffffff811ee570 symbol: journal_commit_transaction+0x630/0x1720 ilen: 5  76
Jump label: addr: ffffffff811ee1b8 symbol: journal_commit_transaction+0x278/0x1720 ilen: 5  76
Jump label: addr: ffffffff811edfb7 symbol: journal_commit_transaction+0x77/0x1720 ilen: 5  76
Jump label: addr: ffffffff811edf89 symbol: journal_commit_transaction+0x49/0x1720 ilen: 5  76
Jump label: addr: ffffffff810e179b symbol: try_to_free_pages+0xbb/0x530 ilen: 5  75
Jump label: addr: ffffffff811f9ece symbol: jbd2_journal_commit_transaction+0x150e/0x1f90 ilen: 5  74
Jump label: addr: ffffffff8118b042 symbol: ext3_sync_fs+0x22/0x120 ilen: 2  71
Jump label: addr: ffffffff8117e371 symbol: ext3_sync_file+0x171/0x2e0 ilen: 2  71
Jump label: addr: ffffffff81139146 symbol: wb_do_writeback+0xa6/0x210 ilen: 2  64
Jump label: addr: ffffffff81137622 symbol: bdi_queue_work+0x22/0x130 ilen: 2  64
Jump label: addr: ffffffff81137179 symbol: __writeback_single_inode+0x219/0x380 ilen: 2  64
Jump label: addr: ffffffff814ce724 symbol: dev_hard_start_xmit+0x214/0x620 ilen: 5  62
Jump label: addr: ffffffff81045c1c symbol: mod_timer_pending+0x5c/0x1b0 ilen: 5  59
Jump label: addr: ffffffff810d7e52 symbol: account_page_dirtied+0x22/0x170 ilen: 5  49
Jump label: addr: ffffffff8117fc50 symbol: ext3_journalled_writepage+0xd0/0x290 ilen: 5  34
Jump label: addr: ffffffff8109fa94 symbol: rcu_implicit_dynticks_qs+0x64/0x230 ilen: 2  33
Jump label: addr: ffffffff8145e4a8 symbol: cpuidle_idle_call+0xf8/0x2d0 ilen: 2  30
Jump label: addr: ffffffff81137004 symbol: __writeback_single_inode+0xa4/0x380 ilen: 5  29
Jump label: addr: ffffffff814f7d3f symbol: ip_mc_output+0xef/0x240 ilen: 2  28
Jump label: addr: ffffffff810a2c48 symbol: rcu_bh_qs+0x38/0x100 ilen: 2  24
Jump label: addr: ffffffff81084bc3 symbol: try_module_get+0x53/0x150 ilen: 2  24
Jump label: addr: ffffffff8103a2fe symbol: do_exit+0x25e/0xa20 ilen: 5  24
Jump label: addr: ffffffff814285e7 symbol: raid5_align_endio+0x87/0x240 ilen: 5  22
Jump label: addr: ffffffff810682ee symbol: wait_task_inactive+0x5e/0x1d0 ilen: 5  22
Jump label: addr: ffffffff81067f64 symbol: set_task_cpu+0x34/0x1d0 ilen: 5  22
Jump label: addr: ffffffff810e9362 symbol: wait_iff_congested+0xb2/0x1b0 ilen: 2  20
Jump label: addr: ffffffff810a2b48 symbol: rcu_sched_qs+0x38/0x100 ilen: 2  19
Jump label: addr: ffffffff8116a76a symbol: oom_adj_write+0x18a/0x2f0 ilen: 2  14
Jump label: addr: ffffffff81045622 symbol: add_timer_on+0x72/0x150 ilen: 2  12
Jump label: addr: ffffffff81538924 symbol: xfrm4_transport_finish+0x54/0x100 ilen: 2  10
Jump label: addr: ffffffff8132a1a6 symbol: mix_pool_bytes.constprop.16+0x36/0x120 ilen: 2  10
Jump label: addr: ffffffff814f7cec symbol: ip_mc_output+0x9c/0x240 ilen: 5  9
Jump label: addr: ffffffff814f2c35 symbol: ip_local_deliver+0x25/0xa0 ilen: 2  9
Jump label: addr: ffffffff810a0b1b symbol: __note_new_gpnum.isra.16+0x3b/0x110 ilen: 2  9
Jump label: addr: ffffffff810864fb symbol: free_module+0xb/0x290 ilen: 5  8
Jump label: addr: ffffffff81562237 symbol: udpv6_queue_rcv_skb+0x57/0x370 ilen: 5  7
Jump label: addr: ffffffff8156143b symbol: udpv6_destroy_sock+0x1b/0x70 ilen: 2  7
Jump label: addr: ffffffff8105dbc4 symbol: check_cpu_itimer.part.3+0x74/0x1b0 ilen: 5  6
Jump label: addr: ffffffff81431f8c symbol: raid5d+0x2dc/0x5a0 ilen: 5  5
Jump label: addr: ffffffff815ae662 symbol: schedule_timeout+0x92/0x250 ilen: 5  4
Jump label: addr: ffffffff8151f08c symbol: arp_xmit+0xc/0x60 ilen: 2  4
Jump label: addr: ffffffff814f7ec8 symbol: ip_output+0x38/0x90 ilen: 2  4
Jump label: addr: ffffffff81181f87 symbol: ext3_truncate+0x27/0x6f0 ilen: 5  3
Jump label: addr: ffffffff814c38b0 symbol: __netdev_alloc_skb+0x70/0x110 ilen: 2  2
Jump label: addr: ffffffff814c2267 symbol: __alloc_skb+0x37/0x2b0 ilen: 5  2
Jump label: addr: ffffffff811f5e27 symbol: jbd2_journal_extend+0x137/0x340 ilen: 2  2
Jump label: addr: ffffffff81573d52 symbol: xfrm6_transport_finish+0x62/0xc0 ilen: 2  1
Jump label: addr: ffffffff81284f43 symbol: get_request+0x2e3/0x680 ilen: 5  1
Jump label: addr: ffffffff8110b4fd symbol: kmem_cache_free+0xdd/0x220 ilen: 2  1
Jump label: addr: ffffffff8110b254 symbol: kfree+0x14/0x1e0 ilen: 5  1
Jump label: addr: ffffffff810a32d9 symbol: rcu_gp_kthread+0x179/0x920 ilen: 5  1
Jump label: addr: ffffffff81067f9e symbol: set_task_cpu+0x6e/0x1d0 ilen: 5  1
Jump label: addr: ffffffff815b4ad8 symbol: __do_page_fault+0x378/0x580 ilen: 2  0
Jump label: addr: ffffffff815b4953 symbol: __do_page_fault+0x1f3/0x580 ilen: 5  0
Jump label: addr: ffffffff815b4898 symbol: __do_page_fault+0x138/0x580 ilen: 5  0
Jump label: addr: ffffffff815aabef symbol: migrate_timer_list+0x1f/0xc0 ilen: 2  0
Jump label: addr: ffffffff815a844c symbol: rcu_cpu_notify+0x1f0/0x882 ilen: 5  0
Jump label: addr: ffffffff81587db0 symbol: rpc_wake_up_task_queue_locked+0x70/0x280 ilen: 5  0
Jump label: addr: ffffffff815812ad symbol: rpc_task_set_client+0x3d/0xd0 ilen: 2  0
Jump label: addr: ffffffff81574124 symbol: xfrm6_output+0x14/0x70 ilen: 2  0
Jump label: addr: ffffffff8156842f symbol: igmp6_send+0x20f/0x3a0 ilen: 2  0
Jump label: addr: ffffffff8156785f symbol: mld_sendpack+0x12f/0x290 ilen: 2  0
Jump label: addr: ffffffff8156409d symbol: rawv6_sendmsg+0x67d/0xb60 ilen: 5  0
Jump label: addr: ffffffff8155d751 symbol: ndisc_send_skb+0x151/0x2a0 ilen: 2  0
Jump label: addr: ffffffff8154d2dc symbol: ip6_input+0xc/0x60 ilen: 2  0
Jump label: addr: ffffffff8154d113 symbol: ipv6_rcv+0x263/0x420 ilen: 5  0
Jump label: addr: ffffffff8154ca5d symbol: ip6_output+0x2d/0xb0 ilen: 2  0
Jump label: addr: ffffffff8154b994 symbol: ip6_forward+0x1f4/0x7c0 ilen: 2  0
Jump label: addr: ffffffff8154b313 symbol: __ip6_local_out+0x33/0x90 ilen: 2  0
Jump label: addr: ffffffff8154b0dc symbol: ip6_xmit+0x1ac/0x3b0 ilen: 5  0
Jump label: addr: ffffffff8154ac46 symbol: ip6_finish_output2+0x346/0x470 ilen: 2  0
Jump label: addr: ffffffff8151fc56 symbol: arp_rcv+0xd6/0x160 ilen: 2  0
Jump label: addr: ffffffff8151d9f7 symbol: udp_queue_rcv_skb+0x57/0x350 ilen: 5  0
Jump label: addr: ffffffff8151a7c5 symbol: __udp_queue_rcv_skb+0x95/0x1a0 ilen: 2  0
Jump label: addr: ffffffff815145d9 symbol: tcp_prequeue+0xe9/0x260 ilen: 2  0
Jump label: addr: ffffffff81510d41 symbol: tcp_delack_timer_handler+0xb1/0x1e0 ilen: 2  0
Jump label: addr: ffffffff814f7dcd symbol: ip_mc_output+0x17d/0x240 ilen: 2  0
Jump label: addr: ffffffff814f4408 symbol: ip_forward+0x218/0x3b0 ilen: 5  0
Jump label: addr: ffffffff814ceb84 symbol: dev_queue_xmit+0x54/0x4d0 ilen: 5  0
Jump label: addr: ffffffff814ce847 symbol: dev_hard_start_xmit+0x337/0x620 ilen: 2  0
Jump label: addr: ffffffff814cc501 symbol: net_rx_action+0xa1/0x200 ilen: 2  0
Jump label: addr: ffffffff814ca852 symbol: netif_rx+0x22/0x1f0 ilen: 5  0
Jump label: addr: ffffffff814c89ae symbol: __netif_receive_skb_core+0x2e/0x5e0 ilen: 5  0
Jump label: addr: ffffffff814c4ddb symbol: skb_copy_datagram_iovec+0x2b/0x2c0 ilen: 5  0
Jump label: addr: ffffffff814c1333 symbol: consume_skb+0x33/0x110 ilen: 2  0
Jump label: addr: ffffffff814bb85b symbol: sock_queue_rcv_skb+0x3b/0x230 ilen: 2  0
Jump label: addr: ffffffff814bb743 symbol: sk_receive_skb+0x93/0x170 ilen: 2  0
Jump label: addr: ffffffff814baf38 symbol: release_sock+0x88/0x170 ilen: 5  0
Jump label: addr: ffffffff814ba800 symbol: __sk_mem_schedule+0xf0/0x310 ilen: 5  0
Jump label: addr: ffffffff81456b7c symbol: ghes_edac_report_mem_error+0x2fc/0xdc0 ilen: 2  0
Jump label: addr: ffffffff81451cf7 symbol: edac_mc_handle_error+0x417/0x6b0 ilen: 2  0
Jump label: addr: ffffffff8144890c symbol: dm_request_fn+0x12c/0x2b0 ilen: 2  0
Jump label: addr: ffffffff814469c5 symbol: __map_bio+0xc5/0x1d0 ilen: 2  0
Jump label: addr: ffffffff81430147 symbol: handle_stripe+0x9a7/0x22c0 ilen: 5  0
Jump label: addr: ffffffff8142ffea symbol: handle_stripe+0x84a/0x22c0 ilen: 5  0
Jump label: addr: ffffffff8142c795 symbol: make_request+0x6a5/0xb60 ilen: 5  0
Jump label: addr: ffffffff8142afc7 symbol: raid5_unplug+0x97/0x150 ilen: 2  0
Jump label: addr: ffffffff8138bba9 symbol: scsi_times_out+0x29/0x150 ilen: 2  0
Jump label: addr: ffffffff8138b988 symbol: scsi_eh_wakeup+0x48/0x100 ilen: 2  0
Jump label: addr: ffffffff81387b55 symbol: scsi_dispatch_cmd+0xd5/0x2c0 ilen: 5  0
Jump label: addr: ffffffff81387b1d symbol: scsi_dispatch_cmd+0x9d/0x2c0 ilen: 5  0
Jump label: addr: ffffffff813870db symbol: scsi_done+0x1b/0xd0 ilen: 2  0
Jump label: addr: ffffffff8133d17b symbol: drm_wait_vblank+0x46b/0x650 ilen: 2  0
Jump label: addr: ffffffff8133c76d symbol: drm_handle_vblank+0x2cd/0x3a0 ilen: 2  0
Jump label: addr: ffffffff8133b083 symbol: send_vblank_event+0x93/0x1a0 ilen: 2  0
Jump label: addr: ffffffff8132ab51 symbol: extract_entropy_user+0x31/0x1c0 ilen: 5  0
Jump label: addr: ffffffff8132a75e symbol: extract_entropy+0x3e/0x170 ilen: 5  0
Jump label: addr: ffffffff81283b4f symbol: blk_requeue_request+0x2f/0x120 ilen: 2  0
Jump label: addr: ffffffff812834a6 symbol: generic_make_request_checks+0x106/0x3e0 ilen: 5  0
Jump label: addr: ffffffff81201f05 symbol: __jbd2_update_log_tail+0x75/0x1b0 ilen: 2  0
Jump label: addr: ffffffff81200dd0 symbol: jbd2_write_superblock+0x30/0x1f0 ilen: 5  0
Jump label: addr: ffffffff811fc229 symbol: jbd2_log_do_checkpoint+0x29/0x570 ilen: 5  0
Jump label: addr: ffffffff811fbf89 symbol: __jbd2_journal_remove_checkpoint+0xf9/0x1f0 ilen: 2  0
Jump label: addr: ffffffff811fbd65 symbol: __jbd2_journal_drop_transaction+0xe5/0x210 ilen: 2  0
Jump label: addr: ffffffff811fa052 symbol: jbd2_journal_commit_transaction+0x1692/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f8fa1 symbol: jbd2_journal_commit_transaction+0x5e1/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f8e5b symbol: jbd2_journal_commit_transaction+0x49b/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f8d37 symbol: jbd2_journal_commit_transaction+0x377/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f8ac6 symbol: jbd2_journal_commit_transaction+0x106/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f8a8a symbol: jbd2_journal_commit_transaction+0xca/0x1f90 ilen: 5  0
Jump label: addr: ffffffff811f6367 symbol: jbd2_journal_stop+0x147/0x4f0 ilen: 5  0
Jump label: addr: ffffffff811f5bf9 symbol: jbd2__journal_start+0x119/0x200 ilen: 2  0
Jump label: addr: ffffffff811f2bab symbol: journal_write_superblock+0x2b/0x200 ilen: 5  0
Jump label: addr: ffffffff811f03a0 symbol: __journal_drop_transaction+0xd0/0x190 ilen: 2  0
Jump label: addr: ffffffff811f0128 symbol: cleanup_journal_tail+0xf8/0x220 ilen: 2  0
Jump label: addr: ffffffff811ef5ad symbol: journal_commit_transaction+0x166d/0x1720 ilen: 2  0
Jump label: addr: ffffffff811ef376 symbol: journal_commit_transaction+0x1436/0x1720 ilen: 2  0
Jump label: addr: ffffffff811ef0c2 symbol: journal_commit_transaction+0x1182/0x1720 ilen: 5  0
Jump label: addr: ffffffff811ee428 symbol: journal_commit_transaction+0x4e8/0x1720 ilen: 5  0
Jump label: addr: ffffffff811e3c27 symbol: ext4_es_insert_extent+0x67/0x190 ilen: 2  0
Jump label: addr: ffffffff811e378a symbol: ext4_es_remove_extent+0x2a/0x130 ilen: 2  0
Jump label: addr: ffffffff811e2fbf symbol: ext4_es_shrink+0x23f/0x3c0 ilen: 5  0
Jump label: addr: ffffffff811e2db3 symbol: ext4_es_shrink+0x33/0x3c0 ilen: 2  0
Jump label: addr: ffffffff811e1ba1 symbol: ext4_ind_map_blocks+0xb1/0x740 ilen: 5  0
Jump label: addr: ffffffff811e1b3c symbol: ext4_ind_map_blocks+0x4c/0x740 ilen: 5  0
Jump label: addr: ffffffff811dd1ad symbol: ext4_trim_fs+0x47d/0xa90 ilen: 5  0
Jump label: addr: ffffffff811dd0f1 symbol: ext4_trim_fs+0x3c1/0xa90 ilen: 5  0
Jump label: addr: ffffffff811dcef9 symbol: ext4_trim_fs+0x1c9/0xa90 ilen: 5  0
Jump label: addr: ffffffff811dc094 symbol: ext4_free_blocks+0x434/0xbd0 ilen: 5  0
Jump label: addr: ffffffff811dc002 symbol: ext4_free_blocks+0x3a2/0xbd0 ilen: 5  0
Jump label: addr: ffffffff811dbcbe symbol: ext4_free_blocks+0x5e/0xbd0 ilen: 5  0
Jump label: addr: ffffffff811dbaca symbol: ext4_mb_new_blocks+0x45a/0x5f0 ilen: 5  0
Jump label: addr: ffffffff811db7ee symbol: ext4_mb_new_blocks+0x17e/0x5f0 ilen: 5  0
Jump label: addr: ffffffff811db698 symbol: ext4_mb_new_blocks+0x28/0x5f0 ilen: 5  0
Jump label: addr: ffffffff811db218 symbol: ext4_discard_preallocations+0x38/0x490 ilen: 5  0
Jump label: addr: ffffffff811d9e52 symbol: ext4_mb_release_inode_pa.isra.23+0x152/0x3a0 ilen: 5  0
Jump label: addr: ffffffff811d9e27 symbol: ext4_mb_release_inode_pa.isra.23+0x127/0x3a0 ilen: 5  0
Jump label: addr: ffffffff811d99e0 symbol: ext4_mb_release_context+0x2b0/0x5d0 ilen: 2  0
Jump label: addr: ffffffff811d981a symbol: ext4_mb_release_context+0xea/0x5d0 ilen: 2  0
Jump label: addr: ffffffff811d92e4 symbol: ext4_mb_release_group_pa+0x94/0x1d0 ilen: 5  0
Jump label: addr: ffffffff811d9268 symbol: ext4_mb_release_group_pa+0x18/0x1d0 ilen: 5  0
Jump label: addr: ffffffff811d8fab symbol: ext4_free_data_callback+0x4b/0x2f0 ilen: 5  0
Jump label: addr: ffffffff811d6b37 symbol: ext4_mb_init_cache+0x3e7/0x780 ilen: 5  0
Jump label: addr: ffffffff811d69cc symbol: ext4_mb_init_cache+0x27c/0x780 ilen: 5  0
Jump label: addr: ffffffff811d5448 symbol: ext4_mb_new_inode_pa+0x158/0x3c0 ilen: 5  0
Jump label: addr: ffffffff811d50ad symbol: ext4_mb_new_group_pa+0xdd/0x320 ilen: 5  0
Jump label: addr: ffffffff811d375e symbol: __ext4_forget+0x3e/0x2a0 ilen: 5  0
Jump label: addr: ffffffff811d3394 symbol: __ext4_journal_start_sb+0x34/0x1e0 ilen: 2  0
Jump label: addr: ffffffff811d2bba symbol: ext4_fallocate+0x50a/0x5e0 ilen: 2  0
Jump label: addr: ffffffff811d2924 symbol: ext4_fallocate+0x274/0x5e0 ilen: 5  0
Jump label: addr: ffffffff811d2720 symbol: ext4_fallocate+0x70/0x5e0 ilen: 5  0
Jump label: addr: ffffffff811d1739 symbol: ext4_ext_map_blocks+0x1b9/0x1070 ilen: 5  0
Jump label: addr: ffffffff811d1661 symbol: ext4_ext_map_blocks+0xe1/0x1070 ilen: 5  0
Jump label: addr: ffffffff811d15d2 symbol: ext4_ext_map_blocks+0x52/0x1070 ilen: 5  0
Jump label: addr: ffffffff811d0eac symbol: ext4_ext_handle_uninitialized_extents+0x7dc/0xe90 ilen: 5  0
Jump label: addr: ffffffff811d0cbb symbol: ext4_ext_handle_uninitialized_extents+0x5eb/0xe90 ilen: 5  0
Jump label: addr: ffffffff811d0b92 symbol: ext4_ext_handle_uninitialized_extents+0x4c2/0xe90 ilen: 5  0
Jump label: addr: ffffffff811d0707 symbol: ext4_ext_handle_uninitialized_extents+0x37/0xe90 ilen: 5  0
Jump label: addr: ffffffff811d057a symbol: get_reserved_cluster_alloc+0x5a/0x1b0 ilen: 2  0
Jump label: addr: ffffffff811cfbd3 symbol: ext4_ext_remove_space+0x7a3/0x1060 ilen: 5  0
Jump label: addr: ffffffff811cf9dd symbol: ext4_ext_remove_space+0x5ad/0x1060 ilen: 5  0
Jump label: addr: ffffffff811cf879 symbol: ext4_ext_remove_space+0x449/0x1060 ilen: 5  0
Jump label: addr: ffffffff811cf4c0 symbol: ext4_ext_remove_space+0x90/0x1060 ilen: 5  0
Jump label: addr: ffffffff811cd4bd symbol: ext4_ext_find_extent+0x14d/0x400 ilen: 5  0
Jump label: addr: ffffffff811cd09e symbol: ext4_ext_rm_idx+0xde/0x240 ilen: 5  0
Jump label: addr: ffffffff811cc704 symbol: get_implied_cluster_alloc+0xe4/0x240 ilen: 5  0
Jump label: addr: ffffffff811cc688 symbol: get_implied_cluster_alloc+0x68/0x240 ilen: 5  0
Jump label: addr: ffffffff811b898e symbol: ext4_sync_fs+0x2e/0x130 ilen: 2  0
Jump label: addr: ffffffff811b88a9 symbol: ext4_drop_inode+0x39/0xf0 ilen: 2  0
Jump label: addr: ffffffff811b5496 symbol: ext4_unlink+0x1c6/0x3a0 ilen: 5  0
Jump label: addr: ffffffff811b52e4 symbol: ext4_unlink+0x14/0x3a0 ilen: 5  0
Jump label: addr: ffffffff811ade40 symbol: ext4_evict_inode+0x440/0x530 ilen: 2  0
Jump label: addr: ffffffff811ada0d symbol: ext4_evict_inode+0xd/0x530 ilen: 2  0
Jump label: addr: ffffffff811ad73a symbol: ext4_journalled_write_end+0x3a/0x300 ilen: 2  0
Jump label: addr: ffffffff811ad5ea symbol: ext4_da_writepages+0x59a/0x6b0 ilen: 2  0
Jump label: addr: ffffffff811ad3f9 symbol: ext4_da_writepages+0x3a9/0x6b0 ilen: 5  0
Jump label: addr: ffffffff811ad091 symbol: ext4_da_writepages+0x41/0x6b0 ilen: 2  0
Jump label: addr: ffffffff811ac4f6 symbol: ext4_da_write_end+0x76/0x2e0 ilen: 5  0
Jump label: addr: ffffffff811ac1ae symbol: ext4_write_end+0x3e/0x310 ilen: 5  0
Jump label: addr: ffffffff811abc61 symbol: ext4_punch_hole+0x71/0x580 ilen: 2  0
Jump label: addr: ffffffff811aba94 symbol: ext4_setattr+0x4d4/0x630 ilen: 5  0
Jump label: addr: ffffffff811ab2db symbol: ext4_da_write_begin+0x5b/0x340 ilen: 5  0
Jump label: addr: ffffffff811aae3e symbol: ext4_write_begin+0x2e/0x470 ilen: 5  0
Jump label: addr: ffffffff811aaba8 symbol: ext4_truncate+0x198/0x400 ilen: 5  0
Jump label: addr: ffffffff811aaa3b symbol: ext4_truncate+0x2b/0x400 ilen: 5  0
Jump label: addr: ffffffff811aa7f8 symbol: ext4_mark_inode_dirty+0x38/0x250 ilen: 2  0
Jump label: addr: ffffffff811a957f symbol: ext4_writepage+0x2f/0x460 ilen: 5  0
Jump label: addr: ffffffff811a864b symbol: ext4_alloc_da_blocks+0x1b/0x110 ilen: 2  0
Jump label: addr: ffffffff811a7bee symbol: ext4_da_update_reserve_space+0x4e/0x2e0 ilen: 5  0
Jump label: addr: ffffffff811a7933 symbol: ext4_da_invalidatepage+0x163/0x2f0 ilen: 2  0
Jump label: addr: ffffffff811a70bc symbol: ext4_da_get_block_prep+0x48c/0x760 ilen: 5  0
Jump label: addr: ffffffff811a6f74 symbol: ext4_da_get_block_prep+0x344/0x760 ilen: 5  0
Jump label: addr: ffffffff811a6b26 symbol: ext4_readpage+0x26/0x130 ilen: 2  0
Jump label: addr: ffffffff811a68a1 symbol: ext4_releasepage+0x41/0x180 ilen: 2  0
Jump label: addr: ffffffff811a6591 symbol: ext4_direct_IO+0x321/0x510 ilen: 2  0
Jump label: addr: ffffffff811a6381 symbol: ext4_direct_IO+0x111/0x510 ilen: 5  0
Jump label: addr: ffffffff811a5d42 symbol: ext4_invalidatepage+0x22/0x110 ilen: 2  0
Jump label: addr: ffffffff811a5a30 symbol: __ext4_get_inode_loc+0x180/0x470 ilen: 2  0
Jump label: addr: ffffffff811a57e1 symbol: __ext4_journalled_invalidatepage+0x41/0x110 ilen: 2  0
Jump label: addr: ffffffff811a4e2b symbol: __ext4_new_inode+0x13bb/0x1460 ilen: 2  0
Jump label: addr: ffffffff811a3ad4 symbol: __ext4_new_inode+0x64/0x1460 ilen: 5  0
Jump label: addr: ffffffff811a350c symbol: ext4_free_inode+0x6c/0x5d0 ilen: 5  0
Jump label: addr: ffffffff811a30b6 symbol: ext4_read_inode_bitmap+0x246/0x630 ilen: 5  0
Jump label: addr: ffffffff811a26de symbol: ext4_sync_file+0x1be/0x410 ilen: 2  0
Jump label: addr: ffffffff811a2586 symbol: ext4_sync_file+0x66/0x410 ilen: 2  0
Jump label: addr: ffffffff811a01d0 symbol: ext4_read_block_bitmap_nowait+0x180/0x330 ilen: 5  0
Jump label: addr: ffffffff8118af69 symbol: ext3_drop_inode+0x39/0xf0 ilen: 2  0
Jump label: addr: ffffffff81189499 symbol: ext3_unlink+0xa9/0x300 ilen: 5  0
Jump label: addr: ffffffff8118305b symbol: ext3_get_blocks_handle+0x9b/0xd80 ilen: 5  0
Jump label: addr: ffffffff81182acb symbol: ext3_write_begin+0x3b/0x2c0 ilen: 5  0
Jump label: addr: ffffffff8118205d symbol: ext3_truncate+0xfd/0x6f0 ilen: 5  0
Jump label: addr: ffffffff81180909 symbol: __ext3_get_inode_loc+0x149/0x3c0 ilen: 2  0
Jump label: addr: ffffffff811804d1 symbol: ext3_invalidatepage+0x41/0x110 ilen: 2  0
Jump label: addr: ffffffff81180371 symbol: ext3_releasepage+0x41/0x160 ilen: 2  0
Jump label: addr: ffffffff8117f38a symbol: ext3_new_inode+0xa8a/0xb60 ilen: 2  0
Jump label: addr: ffffffff8117c467 symbol: ext3_new_blocks+0x77/0x790 ilen: 5  0
Jump label: addr: ffffffff8117b1dd symbol: ext3_rsv_window_add+0x2d/0x140 ilen: 2  0
Jump label: addr: ffffffff81142e31 symbol: bio_split+0x51/0x2f0 ilen: 5  0
Jump label: addr: ffffffff81140af4 symbol: __find_get_block+0x94/0x270 ilen: 2  0
Jump label: addr: ffffffff8113ebd6 symbol: mark_buffer_dirty+0x26/0x160 ilen: 2  0
Jump label: addr: ffffffff8113e15b symbol: touch_buffer+0x1b/0xd0 ilen: 2  0
Jump label: addr: ffffffff8113947b symbol: bdi_writeback_workfn+0x1cb/0x270 ilen: 2  0
Jump label: addr: ffffffff811389da symbol: wb_writeback+0x10a/0x400 ilen: 5  0
Jump label: addr: ffffffff81138992 symbol: wb_writeback+0xc2/0x400 ilen: 5  0
Jump label: addr: ffffffff81137a7a symbol: __mark_inode_dirty+0x5a/0x3d0 ilen: 5  0
Jump label: addr: ffffffff81137a51 symbol: __mark_inode_dirty+0x31/0x3d0 ilen: 5  0
Jump label: addr: ffffffff81137150 symbol: __writeback_single_inode+0x1f0/0x380 ilen: 5  0
Jump label: addr: ffffffff81136f8c symbol: __writeback_single_inode+0x2c/0x380 ilen: 5  0
Jump label: addr: ffffffff81115db7 symbol: set_task_comm+0x37/0x110 ilen: 2  0
Jump label: addr: ffffffff8110c779 symbol: __kmalloc_track_caller+0xb9/0x1e0 ilen: 2  0
Jump label: addr: ffffffff8110bf0e symbol: __kmalloc+0xbe/0x1e0 ilen: 2  0
Jump label: addr: ffffffff8110b8ef symbol: kmem_cache_alloc_trace+0xaf/0x1d0 ilen: 2  0
Jump label: addr: ffffffff8110b724 symbol: kmem_cache_alloc+0xb4/0x1d0 ilen: 2  0
Jump label: addr: ffffffff8110a6e1 symbol: kmalloc_order_trace+0x51/0x120 ilen: 2  0
Jump label: addr: ffffffff810e1551 symbol: kswapd+0x7a1/0x930 ilen: 5  0
Jump label: addr: ffffffff810e0f1a symbol: kswapd+0x16a/0x930 ilen: 5  0
Jump label: addr: ffffffff810df1b6 symbol: wakeup_kswapd+0xa6/0x1a0 ilen: 2  0
Jump label: addr: ffffffff810d7a66 symbol: free_hot_cold_page_list+0x46/0x100 ilen: 2  0
Jump label: addr: ffffffff810d7141 symbol: free_pcppages_bulk+0x181/0x420 ilen: 5  0
Jump label: addr: ffffffff810d6474 symbol: __alloc_pages_nodemask+0x114/0x7e0 ilen: 2  0
Jump label: addr: ffffffff810d5bee symbol: free_pages_prepare+0xe/0x160 ilen: 5  0
Jump label: addr: ffffffff810d53e0 symbol: __rmqueue+0x2b0/0x560 ilen: 5  0
Jump label: addr: ffffffff810d53a2 symbol: __rmqueue+0x272/0x560 ilen: 5  0
Jump label: addr: ffffffff810a48b6 symbol: rcu_note_context_switch+0x276/0x3d0 ilen: 2  0
Jump label: addr: ffffffff810a43bd symbol: rcu_read_unlock_special+0x13d/0x3c0 ilen: 5  0
Jump label: addr: ffffffff810a3d17 symbol: rcu_check_callbacks+0x297/0x7a0 ilen: 5  0
Jump label: addr: ffffffff810a3a94 symbol: rcu_check_callbacks+0x14/0x7a0 ilen: 5  0
Jump label: addr: ffffffff810a3800 symbol: rcu_gp_kthread+0x6a0/0x920 ilen: 5  0
Jump label: addr: ffffffff810a340f symbol: rcu_gp_kthread+0x2af/0x920 ilen: 5  0
Jump label: addr: ffffffff810a27fe symbol: __call_rcu.constprop.45+0xde/0x3a0 ilen: 5  0
Jump label: addr: ffffffff810a1c52 symbol: rcu_process_callbacks+0x452/0x980 ilen: 5  0
Jump label: addr: ffffffff810a1000 symbol: rcu_accelerate_cbs+0x2f0/0x420 ilen: 2  0
Jump label: addr: ffffffff810a09de symbol: trace_rcu_future_gp.isra.5+0x5e/0x160 ilen: 2  0
Jump label: addr: ffffffff8109fbbd symbol: rcu_implicit_dynticks_qs+0x18d/0x230 ilen: 2  0
Jump label: addr: ffffffff8109f958 symbol: rcu_preempt_qs+0x38/0x110 ilen: 2  0
Jump label: addr: ffffffff8105f7fa symbol: hrtimer_init+0x2a/0x1c0 ilen: 5  0
Jump label: addr: ffffffff81052de7 symbol: process_one_work+0x157/0x4a0 ilen: 5  0
Jump label: addr: ffffffff81052dcc symbol: process_one_work+0x13c/0x4a0 ilen: 5  0
Jump label: addr: ffffffff8105247d symbol: __queue_work+0xfd/0x380 ilen: 5  0
Jump label: addr: ffffffff810505bf symbol: pwq_activate_delayed_work+0x2f/0x100 ilen: 2  0
Jump label: addr: ffffffff81045108 symbol: call_timer_fn+0x58/0x1f0 ilen: 2  0
Jump label: addr: ffffffff8103b4a3 symbol: it_real_fn+0x23/0xf0 ilen: 2  0
Jump label: addr: ffffffff81038f1e symbol: delayed_put_task_struct+0x2e/0x120 ilen: 2  0
Jump label: addr: ffffffff81033cf6 symbol: copy_process+0xe16/0x1350 ilen: 2  0
Jump label: addr: ffffffff8101cadd symbol: mce_log+0xd/0x1c0 ilen: 5  0

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
