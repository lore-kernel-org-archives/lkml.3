Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbaDBX3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:29:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:37163 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819AbaDBX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="txt'?scan'208";a="513286160"
Date: Wed, 2 Apr 2014 16:29:48 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org,
        kpreempt-tech@lists.sourceforge.net
Subject: Soft lockup regression since kernel 3.13
Message-ID: <20140402232948.GA4725@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've detected a regression from upstream (using an Intel Merrifield
device) since 3.13 (still exists in 3.14) which I never had much time
to start to investigate until now. The symptoms are: the device boots
and works fine for while until it silently hangs.

I finally bisected v3.12..v3.13 and found exactly which commit created
the issue:

commit f27dde8deef33c9e58027df11ceab2198601d6a6
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Aug 14 14:55:31 2013 +0200

    sched: Add NEED_RESCHED to the preempt_count

    In order to combine the preemption and need_resched test we need to
    fold the need_resched information into the preempt_count value.

    Since the NEED_RESCHED flag is set across CPUs this needs to be an
    atomic operation, however we very much want to avoid making
    preempt_count atomic, therefore we keep the existing TIF_NEED_RESCHED
    infrastructure in place but at 3 sites test it and fold its value into
    preempt_count; namely:

     - resched_task() when setting TIF_NEED_RESCHED on the current task
     - scheduler_ipi() when resched_task() sets TIF_NEED_RESCHED on a
                       remote task it follows it up with a reschedule IPI
                       and we can modify the cpu local preempt_count from
                       there.
     - cpu_idle_loop() for when resched_task() found tsk_is_polling().

    We use an inverted bitmask to indicate need_resched so that a 0 means
    both need_resched and !atomic.

    Also remove the barrier() in preempt_enable() between
    preempt_enable_no_resched() and preempt_check_resched() to avoid
    having to reload the preemption value and allow the compiler to use
    the flags of the previuos decrement. I couldn't come up with any sane
    reason for this barrier() to be there as preempt_enable_no_resched()
    already has a barrier() before doing the decrement.

    Suggested-by: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>
--

I dumped directly from memory the content of __log_buf when device crashes
(refer to attached text file), since serial console is unable to show anything.

I also found an external references to something similar:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1269404

Is this a known issue being worked currently?

Br, David Cohen

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="syslog.txt"

BUG: soft lockup - CPU#1 stuck for 23s! [kmemleak:51]
Modules linked in: cfg80211 g_ffs libcomposite
CPU: 1 PID: 51 Comm: kmemleak Not tainted 3.12.0-00109-gd948a8c
Hardware name: Intel Corporation Merrifield/SALT BAY, BIOS 419 2013.12.11:10.58.26
task: ed536ba0 ti: ed028000 task.ti: ed028000
EIP: 0060:[<c189da49>] EFLAGS: 00000286 CPU: 1
EIP is at add_preempt_count+0x19/0xa0
EAX: 00000001 EBX: 00000001 ECX: 80000000 EDX: ed028000
ESI: 000033f5 EDI: 097449c2 EBP: ed029e8c ESP: ed029e78
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b8e2df50 CR3: 01cbf000 CR4: 001007f0
Stack:
c132697e 00000046 00000001 0974596c 09745b1a ed029ea4 c14c23ef 00000001e
ed536ba0 00000001 00000000 ed029eac c14c233e ed029eb8 c125b72c 00200200
ed029ee0 c13269b5 00000002 00000001 00000000 c1326930 ed029ee0 00000000
Call Trace:
[<c132697e>] ? find_and_get_object+0x4e/0x120
[<c14c23ef>] delay_tsc+0x4f/0xb0
[<c14c233e>] __const_udelay+0x1e/0x20
[<c125b72c>] __rcu_read_unlock+0x3c/0x60
[<c13269b5>] find_and_get_object+0x85/0x120
[<c1326930>] ? rcu_read_lock+0x40/0x40
[<c1326b32>] scan_block+0x42/0x100
[<c1327189>] kmemleak_scan+0x3f9/0x430
[<c1326d90>] ? delete_object_full+0x30/0x30
[<c1327480>] ? kmemleak_write+0x2c0/0x2c0
[<c13274d8>] kmemleak_scan_thread+0x58/0xc0
[<c125e834>] kthread+0x94/0xa0
[<c1890000>] ? pcpu_dump_alloc_info+0xb2/0x20a
[<c18a0d77>] ret_from_kernel_thread+0x1b/0x28
[<c125e7a0>] ? kthread_create_on_node+0xc0/0xc0
Code: 3d b4 0c 13 c2 00 0f 85 73 ff ff ff c7 44 24 0c 66 03 aa c1 c7 44 24 08 fc fc a9 c1 c7 44 24 04 cb 08 00 00 c7 04 24 f4 68 ae c1 e8 ad 09 9a ff e9 4a ff ff ff 90 8d b4 26 00 00 00 00 55 89 e5 53 83 ec 10 3e 8d 74 26 00 89 e2 89 c3 81 e2 00 e0 ff ff 8b 4a 14 <01> c1 a1 30 09 cd c1 89 4a 14 85 c0 74 29 81 e1 ff ff ff 7f 39 cb 74 07 83 c4 10 5b 5d c3 90 8b 45 00 8b 40 04 e8 fd e4 9c ff
Kernel panic - not syncing: softlockup: hung tasks
CPU: 1 PID: 51 Comm: kmemleak Not tainted 3.12.0-00109-gd948a8c
Hardware name: Intel Corporation Merrifield/SALT BAY, BIOS 419 2013.12.11:10.58.26
00000000 00000000 ed029d30 c1891f00 00000017 ed029d50 c188e44c c1ae5080D
c1cccc80 ffffffff 00000017 ed536ba0 00000000 ed029d84 c12b6e81 c1aa3bc6al
00000001 00000017 ed536eac 00000033 00000033 ed029e3c 0000003b eebf1220
Call Trace:
[<c1891f00>] dump_stack+0x4b/0x78
[<c188e44c>] panic+0x87/0x181
[<c12b6e81>] watchdog_timer_fn+0x151/0x160
[<c126194b>] __run_hrtimer+0x7b/0x200
[<c12b6d30>] ? watchdog+0x20/0x20
[<c126259f>] hrtimer_interrupt+0x10f/0x2c0
[<c1207f1c>] ? native_sched_clock+0x2c/0xb0
[<c122a0ae>] local_apic_timer_interrupt+0x2e/0x60
[<c124302e>] ? irq_enter+0x4e/0x70
[<c18a1433>] smp_apic_timer_interrupt+0x33/0x50
[<c189a932>] apic_timer_interrupt+0x32/0x38O
[<c189da49>] ? add_preempt_count+0x19/0xa0
[<c132697e>] ? find_and_get_object+0x4e/0x120
[<c14c23ef>] delay_tsc+0x4f/0xb0
[<c14c233e>] __const_udelay+0x1e/0x20
[<c125b72c>] __rcu_read_unlock+0x3c/0x60
[<c13269b5>] find_and_get_object+0x85/0x120
[<c1326930>] ? rcu_read_lock+0x40/0x40
[<c1326b32>] scan_block+0x42/0x100
[<c1327189>] kmemleak_scan+0x3f9/0x430
[<c1326d90>] ? delete_object_full+0x30/0x30r
[<c1327480>] ? kmemleak_write+0x2c0/0x2c0
[<c13274d8>] kmemleak_scan_thread+0x58/0xc0
[<c125e834>] kthread+0x94/0xa0
[<c1890000>] ? pcpu_dump_alloc_info+0xb2/0x20a
[<c18a0d77>] ret_from_kernel_thread+0x1b/0x28
[<c125e7a0>] ? kthread_create_on_node+0xc0/0xc0

--pWyiEgJYm5f9v55/--
