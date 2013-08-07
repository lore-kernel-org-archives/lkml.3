Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3HGA4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:56:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3HGA4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:56:02 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=iSGqrqYpDDRK1dF5iGkA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375836960.25420.80.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 06 Aug 2013 20:56:00 -0400
In-Reply-To: <1375836304.25420.76.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <1375727977.22073.112.camel@gandalf.local.home>
	 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	 <1375798783.25420.30.camel@gandalf.local.home>
	 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
	 <1375811885.25420.44.camel@gandalf.local.home>
	 <20130806203319.GA16170@Krystal>
	 <1375821817.25420.50.camel@gandalf.local.home>
	 <1375836304.25420.76.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 20:45 -0400, Steven Rostedt wrote:

> [    3.387362] short jumps: 106
> [    3.390277]  long jumps: 330
> 
> Thus, approximately 25%. Not bad.

Also, where these happen to be is probably even more important than how
many. If all the short jumps happen in slow paths, it's rather
pointless. But they seem to be in some rather hot paths. I had it print
out where it placed the short jumps too:

[    0.000000] short jump at: place_entity+0x53/0x87 ffffffff8106e139^M
[    0.000000] short jump at: place_entity+0x17/0x87 ffffffff8106e0fd^M
[    0.000000] short jump at: check_preempt_wakeup+0x11c/0x16e ffffffff8106f92b^M
[    0.000000] short jump at: can_migrate_task+0xc6/0x15d ffffffff8106e72e
[    0.000000] short jump at: update_group_power+0x72/0x1df ffffffff81070394
[    0.000000] short jump at: update_group_power+0xaf/0x1df ffffffff810703d1^M
[    0.000000] short jump at: hrtick_enabled+0x4/0x35 ffffffff8106de51
[    0.000000] short jump at: task_tick_fair+0x5c/0xf9 ffffffff81070102^M
[    0.000000] short jump at: source_load+0x27/0x40 ffffffff8106da7c^M
[    0.000000] short jump at: target_load+0x27/0x40 ffffffff8106dabc^M
[    0.000000] short jump at: try_to_wake_up+0x127/0x1e2 ffffffff8106b1d4^M
[    0.000000] short jump at: build_sched_domains+0x219/0x90b ffffffff8106bc24^M
[    0.000000] short jump at: smp_trace_call_function_single_interrupt+0x79/0x112 ffffffff8102616f^M
[    0.000000] short jump at: smp_trace_call_function_interrupt+0x7a/0x111 ffffffff81026038
[    0.000000] short jump at: smp_trace_error_interrupt+0x72/0x109 ffffffff81028c9e
[    0.000000] short jump at: smp_trace_spurious_interrupt+0x71/0x107 ffffffff81028b77
[    0.000000] short jump at: smp_trace_reschedule_interrupt+0x7a/0x110 ffffffff81025f01^M
[    0.000000] short jump at: __raise_softirq_irqoff+0xf/0x90 ffffffff810406e0^M
[    0.000000] short jump at: it_real_fn+0x17/0xb2 ffffffff8103ed85
[    0.000000] short jump at: trace_itimer_state+0x13/0x97 ffffffff8103e9ff^M
[    0.000000] short jump at: debug_deactivate+0xa/0x7a ffffffff8106014d^M
[    0.000000] short jump at: debug_activate+0x10/0x86 ffffffff810478c7^M
[    0.000000] short jump at: __send_signal+0x233/0x268 ffffffff8104a6bb
[    0.000000] short jump at: send_sigqueue+0x103/0x148 ffffffff8104bbbf^M
[    0.000000] short jump at: trace_workqueue_activate_work+0xa/0x7a ffffffff81053deb^M
[    0.000000] short jump at: _rcu_barrier_trace+0x31/0xbc ffffffff810b8f81
[    0.000000] short jump at: trace_rcu_dyntick+0x14/0x8f ffffffff810ba3a2^M
[    0.000000] short jump at: rcu_implicit_dynticks_qs+0x95/0xc4 ffffffff810ba35f
[    0.000000] short jump at: rcu_implicit_dynticks_qs+0x47/0xc4 ffffffff810ba311^M
[    0.000000] short jump at: trace_rcu_future_gp.isra.38+0x46/0xe9 ffffffff810b91e8
[    0.000000] short jump at: trace_rcu_grace_period+0x14/0x8f ffffffff810b90d3
[    0.000000] short jump at: trace_rcu_utilization+0xa/0x7a ffffffff810b9a6b
[    0.000000] short jump at: update_curr+0x89/0x14f ffffffff8106f4c9^M
[    0.000000] short jump at: update_stats_wait_end+0x5a/0xda ffffffff8106f203^M
[    0.000000] short jump at: delayed_put_task_struct+0x1b/0x95 ffffffff8103c798^M
[    0.000000] short jump at: trace_module_get+0x10/0x86 ffffffff81096b44^M
[    0.000000] short jump at: pm_qos_update_flags+0xc5/0x149 ffffffff81076fa0^M
[    0.000000] short jump at: pm_qos_update_request+0x51/0xf3 ffffffff81076b1e^M
[    0.000000] short jump at: pm_qos_add_request+0xb7/0x14e ffffffff81076db9^M
[    0.000000] short jump at: wakeup_source_report_event+0x7b/0xfc ffffffff81323045
[    0.000000] short jump at: trace_rpm_return_int+0x14/0x8f ffffffff81323d3d^M
[    0.000000] short jump at: __activate_page+0xdd/0x183 ffffffff810f8a1d^M
[    0.000000] short jump at: __pagevec_lru_add_fn+0x139/0x1c4 ffffffff810f88b5^M
[    0.000000] short jump at: shrink_inactive_list+0x364/0x400 ffffffff810fcee8^M
[    0.000000] short jump at: isolate_lru_pages.isra.57+0xb6/0x14a ffffffff810fbafb^M
[    0.000000] short jump at: wakeup_kswapd+0xaf/0x14a ffffffff810fbd20^M
[    0.000000] short jump at: free_hot_cold_page_list+0x2a/0xca ffffffff810f3d1e
[    0.000000] short jump at: kmem_cache_free+0x74/0xee ffffffff81129f9a^M
[    0.000000] short jump at: kmem_cache_alloc_node+0xe6/0x17b ffffffff8112afb1^M
[    0.000000] short jump at: kmem_cache_alloc_node_trace+0xe1/0x176 ffffffff8112b615^M
[    0.000000] short jump at: kmem_cache_alloc+0xd8/0x168 ffffffff8112c1fe^M
[    0.000000] short jump at: trace_kmalloc+0x21/0xac ffffffff8112aa7e^M
[    0.000000] short jump at: wait_iff_congested+0xdc/0x158 ffffffff81105ee3^M
[    0.000000] short jump at: congestion_wait+0xa6/0x122 ffffffff81106005^M
[    0.000000] short jump at: global_dirty_limits+0xd7/0x151 ffffffff810f5f74
[    0.000000] short jump at: queue_io+0x165/0x1e6 ffffffff811568ec
[    0.000000] short jump at: bdi_register+0xe9/0x161 ffffffff81106329^M
[    0.000000] short jump at: bdi_start_background_writeback+0xf/0x9c ffffffff8115755d^M
[    0.000000] short jump at: trace_writeback_pages_written+0xa/0x7a ffffffff81156717^M
[    0.000000] short jump at: trace_ext3_truncate_exit+0xa/0x7a ffffffff8119d57a^M
[    0.000000] short jump at: ext3_readpage+0xf/0x8c ffffffff8119d4f3
[    0.000000] short jump at: ext3_drop_inode+0x2b/0xae ffffffff811a9435^M
[    0.000000] short jump at: ext4_es_find_delayed_extent_range+0x143/0x1e9 ffffffff811ea671^M
[    0.000000] short jump at: trace_ext4_get_implied_cluster_alloc_exit+0x14/0x8f ffffffff811d7b5a^M
[    0.000000] short jump at: __ext4_journal_start_reserved+0xf4/0x11a ffffffff811dd59b^M
[    0.000000] short jump at: ext4_truncate+0x25e/0x2fd ffffffff811ba6e3
[    0.000000] short jump at: ext4_fallocate+0x39f/0x435 ffffffff811dcb20^M
[    0.000000] short jump at: trace_ext4_da_reserve_space+0x11/0x87 ffffffff811b707f^M
[    0.000000] short jump at: ext4_mb_release_group_pa+0xd9/0x112 ffffffff811e2413^M
[    0.000000] short jump at: ext4_mb_release_context+0x424/0x4d3 ffffffff811e2a74^M
[    0.000000] short jump at: ext4_alloc_da_blocks+0xf/0xa2 ffffffff811b87c9^M
[    0.000000] short jump at: trace_ext4_sync_fs+0x11/0x92 ffffffff811ce6e1^M
[    0.000000] short jump at: ext4_drop_inode+0x2b/0xae ffffffff811ce64d^M
[    0.000000] short jump at: trace_jbd_do_submit_data+0x11/0x87 ffffffff811f2a57
[    0.000000] short jump at: __journal_drop_transaction+0xe0/0x160 ffffffff811f4958
[    0.000000] short jump at: __jbd2_journal_drop_transaction+0xd8/0x152 ffffffff811fdb82^M
[    0.000000] short jump at: trace_block_plug+0xa/0x7a ffffffff81243e17^M
[    0.000000] short jump at: dec_pending+0x258/0x2e7 ffffffff813ec27c^M
[    0.000000] short jump at: elv_abort_queue+0x2a/0xc6 ffffffff8123fff5^M
[    0.000000] short jump at: touch_buffer+0xa/0x8c ffffffff8115cfb0
[    0.000000] short jump at: trace_gpio_value+0x13/0x97 ffffffff81273682^M
[    0.000000] short jump at: trace_gpio_direction+0x13/0x97 ffffffff8127380f
[    0.000000] short jump at: _regulator_disable+0x1e8/0x22b ffffffff812dfce6
[    0.000000] short jump at: scsi_eh_wakeup+0x21/0xcb ffffffff8133287a
[    0.000000] short jump at: scsi_done+0xf/0x8a ffffffff8132e568
[    0.000000] short jump at: __udp_queue_rcv_skb+0xae/0x132 ffffffff814939f4^M
[    0.000000] short jump at: consume_skb+0x38/0xbe ffffffff8142b3b5
[    0.000000] short jump at: kfree_skb+0x3f/0xcb ffffffff8142a01c
[    0.000000] short jump at: perf_event_task_sched_out+0x16/0x57 ffffffff810677ad
[    0.000000] short jump at: netif_receive_skb+0x25/0x8a ffffffff81435c6d^M
[    0.000000] short jump at: netif_receive_skb+0x11/0x8a ffffffff81435c59^M
[    0.000000] short jump at: udp_destroy_sock+0x37/0x5d ffffffff81494e22
[    0.000000] short jump at: udpv6_destroy_sock+0x26/0x54 ffffffff814d4fa0^M
[    0.000000] short jump at: perf_event_task_sched_out+0x14/0x57 ffffffff810677ab^M
[    0.000000] short jump at: set_task_cpu+0x137/0x1b7 ffffffff81069933
[    0.000000] short jump at: tcp_prequeue_process+0x30/0x76 ffffffff81479f88^M
[    0.000000] short jump at: __netif_receive_skb+0xc/0x5b ffffffff81435abc^M
[    0.000000] short jump at: __netdev_alloc_skb+0x34/0xae ffffffff81429ed7^M
[    0.000000] short jump at: sk_backlog_rcv+0x7/0x2b ffffffff81425659
[    0.000000] short jump at: ac_put_obj.isra.36+0xd/0x41 ffffffff81129cad^M
[    0.000000] short jump at: ipmr_queue_xmit.isra.29+0x3b7/0x403 ffffffff814af2bc^M
[    0.000000] short jump at: ip_forward+0x200/0x28b ffffffff81470661
[    0.000000] short jump at: __br_multicast_send_query+0x412/0x45d ffffffff814f818f^M
[    0.000000] short jump at: br_send_bpdu+0x10e/0x14b ffffffff814f308a
[    0.000000] short jump at: NF_HOOK.constprop.29+0xf/0x49 ffffffff814dafe0^M
[    0.000000] short jump at: ndisc_send_skb+0x1c6/0x29b ffffffff814d20b8^M


The kmem_cache_* and the try_to_wake_up* are the hot paths that caught
my eye.

But still, is this worth it?

-- Steve


