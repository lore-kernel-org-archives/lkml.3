Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaHQD2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:28:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62270 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHQD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:28:48 -0400
Date: Sat, 16 Aug 2014 20:27:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vincent Donnefort <vdonnefort@gmail.com>
cc: Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Message-ID: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we safely revert your 8b37e1bef5a6 ("leds: convert blink timer to
workqueue"), or have there been other changes which now depend upon it?

Your commit comment says:
This patch converts the blink timer from led-core to workqueue which is
more suitable for this kind of non-priority operations. Moreover, timer
may lead to errors when a LED setting function use a scheduling function
such as pinctrl which is using mutex.

Which sounds like a good change, except led_blink_set() itself may now
sleep, and at least one established user calls it while holding a lock.

I have CONFIG_DEBUG_ATOMIC_SLEEP=y, plus lockdep: once wireless comes up,
I get the stream of messages below.  Reverting 8b37e1bef5a6 works for me,
but perhaps something else would need to be reverted too?

Hugh

BUG: sleeping function called from invalid context at kernel/workqueue.c:2650
in_atomic(): 1, irqs_disabled(): 0, pid: 332, name: wpa_supplicant
7 locks held by wpa_supplicant/332:
 #0:  (cb_lock){++++++}, at: [<ffffffff814a32b3>] genl_rcv+0x14/0x32
 #1:  (genl_mutex){+.+.+.}, at: [<ffffffff814a2820>] genl_lock+0x12/0x14
 #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81491a7e>] rtnl_lock+0x12/0x14
 #3:  (&wdev->mtx){+.+.+.}, at: [<ffffffff81559faf>] nl80211_authenticate+0x20f/0x2ad
 #4:  (&local->mtx){+.+.+.}, at: [<ffffffff815a0bc5>] ieee80211_prep_connection+0x37a/0xbe9
 #5:  (&local->chanctx_mtx){+.+.+.}, at: [<ffffffff8159ea88>] ieee80211_vif_use_channel+0x6c/0x21e
 #6:  (&trig->leddev_list_lock){.+.+..}, at: [<ffffffff815a8653>] tpt_trig_timer+0xd0/0x11b
Preemption disabled at:[<ffffffff815a8653>] tpt_trig_timer+0xd0/0x11b

CPU: 3 PID: 332 Comm: wpa_supplicant Not tainted 3.17.0-rc1 #2
Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
 0000000000000000 ffff8800b359b5e8 ffffffff815b4eb1 0000000000000000
 ffff8800b359b610 ffffffff810a2f46 ffff8800b34051b0 ffff8800b34051d0
 0000000ffffffff1 ffff8800b359b6d8 ffffffff8109966f ffffffff81099610
Call Trace:
 [<ffffffff815b4eb1>] dump_stack+0x4e/0x7a
 [<ffffffff810a2f46>] __might_sleep+0x1fa/0x201
 [<ffffffff8109966f>] flush_work+0x5f/0x213
 [<ffffffff81099610>] ? mod_delayed_work_on+0x75/0x75
 [<ffffffff810bda17>] ? __lock_acquire+0x10ec/0x17e8
 [<ffffffff810bc4ec>] ? mark_held_locks+0x50/0x6e
 [<ffffffff8109a5b7>] ? __cancel_work_timer+0x9d/0xec
 [<ffffffff810bc64c>] ? trace_hardirqs_on_caller+0x142/0x19e
 [<ffffffff8109a5c3>] __cancel_work_timer+0xa9/0xec
 [<ffffffff8109a621>] cancel_delayed_work_sync+0xe/0x10
 [<ffffffff8145a9fb>] led_blink_set+0x1d/0x39
 [<ffffffff815a866f>] tpt_trig_timer+0xec/0x11b
 [<ffffffff815a8b17>] ieee80211_mod_tpt_led_trig+0x103/0x130
 [<ffffffff8158125b>] __ieee80211_recalc_idle+0xcf/0x122
 [<ffffffff815814e9>] ieee80211_idle_off+0xe/0x10
 [<ffffffff8159c296>] ieee80211_add_chanctx+0x65/0x110
 [<ffffffff8159d20c>] ieee80211_new_chanctx+0x6c/0xcb
 [<ffffffff8159eb79>] ieee80211_vif_use_channel+0x15d/0x21e
 [<ffffffff815a0bd3>] ieee80211_prep_connection+0x388/0xbe9
 [<ffffffff815a5c7c>] ieee80211_mgd_auth+0x1db/0x266
 [<ffffffff815519b9>] ? cfg80211_get_bss+0x196/0x1b2
 [<ffffffff81587868>] ieee80211_auth+0x13/0x15
 [<ffffffff81566b61>] cfg80211_mlme_auth+0x123/0x171
 [<ffffffff8155a00f>] nl80211_authenticate+0x26f/0x2ad
 [<ffffffff814a34c4>] genl_family_rcv_msg+0x1f3/0x254
 [<ffffffff814a3560>] genl_rcv_msg+0x3b/0x5c
 [<ffffffff814a3525>] ? genl_family_rcv_msg+0x254/0x254
 [<ffffffff814a3525>] ? genl_family_rcv_msg+0x254/0x254
 [<ffffffff814a25fc>] netlink_rcv_skb+0x3c/0x88
 [<ffffffff814a32c2>] genl_rcv+0x23/0x32
 [<ffffffff814a203f>] netlink_unicast+0xf4/0x19c
 [<ffffffff814a248b>] netlink_sendmsg+0x325/0x37b
 [<ffffffff8146cc82>] sock_sendmsg+0x69/0x7a
 [<ffffffff81125a20>] ? might_fault+0x9c/0xa1
 [<ffffffff811259d7>] ? might_fault+0x53/0xa1
 [<ffffffff8147a5e6>] ? verify_iovec+0x64/0xb6
 [<ffffffff8146db03>] ___sys_sendmsg+0x1f4/0x272
 [<ffffffff81272a7e>] ? debug_smp_processor_id+0x17/0x19
 [<ffffffff81177ad9>] ? __fget_light+0xb3/0xda
 [<ffffffff8146fa65>] __sys_sendmsg+0x3d/0x5e
 [<ffffffff8146fa93>] SyS_sendmsg+0xd/0x19
 [<ffffffff815bef52>] system_call_fastpath+0x16/0x1b
wlp3s0: send auth to c0:3f:0e:ad:ff:ee (try 1/3)
wlp3s0: authenticated
wlp3s0: associate with c0:3f:0e:ad:ff:ee (try 1/3)
wlp3s0: RX AssocResp from c0:3f:0e:ad:ff:ee (capab=0x411 status=0 aid=4)
wlp3s0: associated
IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready

=================================
[ INFO: inconsistent lock state ]
3.17.0-rc1 #2 Not tainted
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/3/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 ((&(&led_cdev->blink_work)->work)){+.?...}, at: [<ffffffff81099610>] flush_work+0x0/0x213
{SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810bcf41>] __lock_acquire+0x616/0x17e8
  [<ffffffff810be752>] lock_acquire+0x61/0x78
  [<ffffffff81099648>] flush_work+0x38/0x213
  [<ffffffff8109a5c3>] __cancel_work_timer+0xa9/0xec
  [<ffffffff8109a621>] cancel_delayed_work_sync+0xe/0x10
  [<ffffffff8145a9fb>] led_blink_set+0x1d/0x39
  [<ffffffff815a866f>] tpt_trig_timer+0xec/0x11b
  [<ffffffff815a8b17>] ieee80211_mod_tpt_led_trig+0x103/0x130
  [<ffffffff8158125b>] __ieee80211_recalc_idle+0xcf/0x122
  [<ffffffff815814e9>] ieee80211_idle_off+0xe/0x10
  [<ffffffff8159c296>] ieee80211_add_chanctx+0x65/0x110
  [<ffffffff8159d20c>] ieee80211_new_chanctx+0x6c/0xcb
  [<ffffffff8159eb79>] ieee80211_vif_use_channel+0x15d/0x21e
  [<ffffffff815a0bd3>] ieee80211_prep_connection+0x388/0xbe9
  [<ffffffff815a5c7c>] ieee80211_mgd_auth+0x1db/0x266
  [<ffffffff81587868>] ieee80211_auth+0x13/0x15
  [<ffffffff81566b61>] cfg80211_mlme_auth+0x123/0x171
  [<ffffffff8155a00f>] nl80211_authenticate+0x26f/0x2ad
  [<ffffffff814a34c4>] genl_family_rcv_msg+0x1f3/0x254
  [<ffffffff814a3560>] genl_rcv_msg+0x3b/0x5c
  [<ffffffff814a25fc>] netlink_rcv_skb+0x3c/0x88
  [<ffffffff814a32c2>] genl_rcv+0x23/0x32
  [<ffffffff814a203f>] netlink_unicast+0xf4/0x19c
  [<ffffffff814a248b>] netlink_sendmsg+0x325/0x37b
  [<ffffffff8146cc82>] sock_sendmsg+0x69/0x7a
  [<ffffffff8146db03>] ___sys_sendmsg+0x1f4/0x272
  [<ffffffff8146fa65>] __sys_sendmsg+0x3d/0x5e
  [<ffffffff8146fa93>] SyS_sendmsg+0xd/0x19
  [<ffffffff815bef52>] system_call_fastpath+0x16/0x1b
irq event stamp: 45440
hardirqs last  enabled at (45440): [<ffffffff8109a5b7>] __cancel_work_timer+0x9d/0xec
hardirqs last disabled at (45439): [<ffffffff810991eb>] try_to_grab_pending+0x21/0x14d
softirqs last  enabled at (45432): [<ffffffff81087d06>] _local_bh_enable+0x3e/0x40
softirqs last disabled at (45433): [<ffffffff810886c3>] irq_exit+0x3d/0x92
other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((&(&led_cdev->blink_work)->work));
  <Interrupt>
    lock((&(&led_cdev->blink_work)->work));
*** DEADLOCK ***

2 locks held by swapper/3/0:
 #0:  (((&tpt_trig->timer))){+.-...}, at: [<ffffffff810d5c55>] call_timer_fn+0x0/0xd4
 #1:  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff815a8653>] tpt_trig_timer+0xd0/0x11b
stack backtrace:
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.17.0-rc1 #2
Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
 0000000000000000 ffff88023e383b98 ffffffff815b4eb1 ffff8802339ac310
 ffff88023e383be8 ffffffff815b1351 0000000000000001 0000000000000001
 ffff880200000000 ffff8802339acb28 0000000000000004 0000000000000006
Call Trace:
 <IRQ>  [<ffffffff815b4eb1>] dump_stack+0x4e/0x7a
 [<ffffffff815b1351>] print_usage_bug+0x2ac/0x2bd
 [<ffffffff810bb609>] ? print_irq_inversion_bug+0x1cc/0x1cc
 [<ffffffff810bc256>] mark_lock+0x348/0x58e
 [<ffffffff810bceca>] __lock_acquire+0x59f/0x17e8
 [<ffffffff810bb6b4>] ? check_usage_forwards+0xab/0xe7
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff810be752>] lock_acquire+0x61/0x78
 [<ffffffff81099610>] ? mod_delayed_work_on+0x75/0x75
 [<ffffffff81099648>] flush_work+0x38/0x213
 [<ffffffff81099610>] ? mod_delayed_work_on+0x75/0x75
 [<ffffffff810bda17>] ? __lock_acquire+0x10ec/0x17e8
 [<ffffffff810bc161>] ? mark_lock+0x253/0x58e
 [<ffffffff810bc4ec>] ? mark_held_locks+0x50/0x6e
 [<ffffffff8109a5b7>] ? __cancel_work_timer+0x9d/0xec
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff810bc699>] ? trace_hardirqs_on_caller+0x18f/0x19e
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff8109a5c3>] __cancel_work_timer+0xa9/0xec
 [<ffffffff8109a621>] cancel_delayed_work_sync+0xe/0x10
 [<ffffffff8145a9fb>] led_blink_set+0x1d/0x39
 [<ffffffff815a866f>] tpt_trig_timer+0xec/0x11b
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff810d5cbc>] call_timer_fn+0x67/0xd4
 [<ffffffff810d5c55>] ? process_timeout+0xb/0xb
 [<ffffffff810d6819>] run_timer_softirq+0x1aa/0x1f2
 [<ffffffff810883a9>] __do_softirq+0xfc/0x21f
 [<ffffffff810886c3>] irq_exit+0x3d/0x92
 [<ffffffff81052fe4>] smp_apic_timer_interrupt+0x3f/0x4b
 [<ffffffff815bfe1c>] apic_timer_interrupt+0x6c/0x80
 <EOI>  [<ffffffff81444829>] ? cpuidle_enter_state+0x44/0xa0
 [<ffffffff81444835>] ? cpuidle_enter_state+0x50/0xa0
 [<ffffffff81444926>] cpuidle_enter+0x12/0x14
 [<ffffffff810b633c>] cpu_startup_entry+0x183/0x23f
 [<ffffffff81051860>] start_secondary+0x1b0/0x1b5
BUG: sleeping function called from invalid context at kernel/workqueue.c:2650
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/3
INFO: lockdep is turned off.
Preemption disabled at:[<ffffffff810b63e8>] cpu_startup_entry+0x22f/0x23f

CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.17.0-rc1 #2
Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
 0000000000000000 ffff88023e383cf8 ffffffff815b4eb1 0000000000000000
 ffff88023e383d20 ffffffff810a2f46 ffff8800b34051b0 ffff8800b34051d0
 0000000ffffffff1 ffff88023e383de8 ffffffff8109966f ffffffff81099610
Call Trace:
 <IRQ>  [<ffffffff815b4eb1>] dump_stack+0x4e/0x7a
 [<ffffffff810a2f46>] __might_sleep+0x1fa/0x201
 [<ffffffff8109966f>] flush_work+0x5f/0x213
 [<ffffffff81099610>] ? mod_delayed_work_on+0x75/0x75
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff81099206>] ? try_to_grab_pending+0x3c/0x14d
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff8109a5c3>] __cancel_work_timer+0xa9/0xec
 [<ffffffff8109a621>] cancel_delayed_work_sync+0xe/0x10
 [<ffffffff8145a9fb>] led_blink_set+0x1d/0x39
 [<ffffffff815a866f>] tpt_trig_timer+0xec/0x11b
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff810d5cbc>] call_timer_fn+0x67/0xd4
 [<ffffffff810d5c55>] ? process_timeout+0xb/0xb
 [<ffffffff810d6819>] run_timer_softirq+0x1aa/0x1f2
 [<ffffffff810883a9>] __do_softirq+0xfc/0x21f
 [<ffffffff810886c3>] irq_exit+0x3d/0x92
 [<ffffffff81052fe4>] smp_apic_timer_interrupt+0x3f/0x4b
 [<ffffffff815bfe1c>] apic_timer_interrupt+0x6c/0x80
 <EOI>  [<ffffffff81444829>] ? cpuidle_enter_state+0x44/0xa0
 [<ffffffff81444831>] ? cpuidle_enter_state+0x4c/0xa0
 [<ffffffff81444835>] ? cpuidle_enter_state+0x50/0xa0
 [<ffffffff81444926>] cpuidle_enter+0x12/0x14
 [<ffffffff810b633c>] cpu_startup_entry+0x183/0x23f
 [<ffffffff81051860>] start_secondary+0x1b0/0x1b5
BUG: sleeping function called from invalid context at kernel/workqueue.c:2650
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/3
INFO: lockdep is turned off.
Preemption disabled at:[<ffffffff810b63e8>] cpu_startup_entry+0x22f/0x23f

CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.17.0-rc1 #2
Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
 0000000000000000 ffff88023e383cf8 ffffffff815b4eb1 0000000000000000
 ffff88023e383d20 ffffffff810a2f46 ffff8800b34051b0 ffff8800b34051d0
 0000000ffffffff1 ffff88023e383de8 ffffffff8109966f ffffffff81099610
Call Trace:
 <IRQ>  [<ffffffff815b4eb1>] dump_stack+0x4e/0x7a
 [<ffffffff810a2f46>] __might_sleep+0x1fa/0x201
 [<ffffffff8109966f>] flush_work+0x5f/0x213
 [<ffffffff81099610>] ? mod_delayed_work_on+0x75/0x75
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff81099206>] ? try_to_grab_pending+0x3c/0x14d
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff8109a5c3>] __cancel_work_timer+0xa9/0xec
 [<ffffffff8109a621>] cancel_delayed_work_sync+0xe/0x10
 [<ffffffff8145a9fb>] led_blink_set+0x1d/0x39
 [<ffffffff815a866f>] tpt_trig_timer+0xec/0x11b
 [<ffffffff815a8583>] ? __ieee80211_create_tpt_led_trigger+0xf3/0xf3
 [<ffffffff810d5cbc>] call_timer_fn+0x67/0xd4
 [<ffffffff810d5c55>] ? process_timeout+0xb/0xb
 [<ffffffff810d6819>] run_timer_softirq+0x1aa/0x1f2
 [<ffffffff810883a9>] __do_softirq+0xfc/0x21f
 [<ffffffff810886c3>] irq_exit+0x3d/0x92
 [<ffffffff81052fe4>] smp_apic_timer_interrupt+0x3f/0x4b
 [<ffffffff815bfe1c>] apic_timer_interrupt+0x6c/0x80
 <EOI>  [<ffffffff81444829>] ? cpuidle_enter_state+0x44/0xa0
 [<ffffffff81444831>] ? cpuidle_enter_state+0x4c/0xa0
 [<ffffffff81444835>] ? cpuidle_enter_state+0x50/0xa0
 [<ffffffff81444926>] cpuidle_enter+0x12/0x14
 [<ffffffff810b633c>] cpu_startup_entry+0x183/0x23f
 [<ffffffff81051860>] start_secondary+0x1b0/0x1b5

and another such message every second.
