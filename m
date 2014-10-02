Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaJBRz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaJBRzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:55:25 -0400
Date: Thu, 2 Oct 2014 13:55:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com
Subject: RCU stalls -> lockup.
Message-ID: <20141002175515.GA28665@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just hit this on my box running 3.17rc7
It was followed by a userspace lockup. (Could still ping, and sysrq
from the console, but even getty wasn't responding on the console).

I was trying to reproduce another bug faster, and had ramped up the
number of processes trinity to uses to 512. This didn't take long
to fall out..


INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 3, t=6502 jiffies, g=1014253, c=1014252, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 0, t=26007 jiffies, g=1014253, c=1014252, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 2, t=45512 jiffies, g=1014253, c=1014252, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 1, t=65017 jiffies, g=1014253, c=1014252, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P15547 P15232 P15616 P15634
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P15547 P15232 P15616 P15634
	(detected by 1, t=6502 jiffies, g=1014254, c=1014253, q=0)
trinity-c318    R  running task    13480 15547  14371 0x00000000
 ffff880031df7df0 0000000000000002 ffffffff870cb70e ffff88008ec30000
 00000000001d4080 0000000000000000 ffff880031df7fd8 00000000001d4080
 ffff8802166c2de0 ffff88008ec30000 ffff880031df7fd8 ffffffff872361f4
Call Trace:
 [<ffffffff870cb70e>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8781df46>] preempt_schedule+0x36/0x60
 [<ffffffff8700e3d6>] ___preempt_schedule+0x56/0xb0
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8707db77>] ? __local_bh_enable_ip+0xb7/0xe0
 [<ffffffff87823a45>] _raw_spin_unlock_bh+0x35/0x40
 [<ffffffff872361f4>] bdi_queue_work+0xe4/0x1a0
 [<ffffffff87236318>] __bdi_start_writeback+0x68/0x190
 [<ffffffff87238eb0>] wakeup_flusher_threads+0x100/0x1e0
 [<ffffffff87238de0>] ? wakeup_flusher_threads+0x30/0x1e0
 [<ffffffff8723cd86>] sys_sync+0x36/0xb0
 [<ffffffff878249e4>] tracesys+0xdd/0xe2
trinity-c9      R  running task    13496 15232  14371 0x00000000
 ffff88011a01fdf0 0000000000000002 ffffffff870cb70e ffff8800a19616f0
 00000000001d4080 0000000000000000 ffff88011a01ffd8 00000000001d4080
 ffff8802166c2de0 ffff8800a19616f0 ffff88011a01ffd8 ffffffff872361f4
Call Trace:
 [<ffffffff870cb70e>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8781df46>] preempt_schedule+0x36/0x60
 [<ffffffff8700e3d6>] ___preempt_schedule+0x56/0xb0
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8707db77>] ? __local_bh_enable_ip+0xb7/0xe0
 [<ffffffff87823a45>] _raw_spin_unlock_bh+0x35/0x40
 [<ffffffff872361f4>] bdi_queue_work+0xe4/0x1a0
 [<ffffffff87236318>] __bdi_start_writeback+0x68/0x190
 [<ffffffff87238eb0>] wakeup_flusher_threads+0x100/0x1e0
 [<ffffffff87238de0>] ? wakeup_flusher_threads+0x30/0x1e0
 [<ffffffff8723cd86>] sys_sync+0x36/0xb0
 [<ffffffff878249e4>] tracesys+0xdd/0xe2
trinity-c387    R  running task    13272 15616  14371 0x00000004
 ffff880043fd37f8 0000000000000002 ffff880001fd3868 ffff88023304ade0
 00000000001d4080 0000000000000000 ffff880043fd3fd8 00000000001d4080
 ffff8802166c2de0 ffff88023304ade0 ffff880043fd3fd8 0000000000000000
Call Trace:
 [<ffffffff8781e182>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff87825550>] retint_kernel+0x20/0x30
 [<ffffffff87190624>] ? find_get_entry+0xb4/0x270
 [<ffffffff8719076e>] ? find_get_entry+0x1fe/0x270
 [<ffffffff87190575>] ? find_get_entry+0x5/0x270
 [<ffffffff871907ff>] find_lock_entry+0x1f/0x90
 [<ffffffff871acb65>] shmem_getpage_gfp+0xd5/0xa10
 [<ffffffff871adb3d>] shmem_fault+0x6d/0x1c0
 [<ffffffff871bff58>] __do_fault+0x48/0xd0
 [<ffffffff871c25e0>] do_shared_fault.isra.75+0x40/0x1c0
 [<ffffffff8718892b>] ? __perf_sw_event+0x4b/0x380
 [<ffffffff871c3b21>] handle_mm_fault+0x261/0xcd0
 [<ffffffff870cb687>] ? __lock_is_held+0x57/0x80
 [<ffffffff87042c84>] __do_page_fault+0x1a4/0x600
 [<ffffffff870cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8718eda7>] ? context_tracking_user_exit+0x67/0x1b0
 [<ffffffff870430fe>] do_page_fault+0x1e/0x70
 [<ffffffff878264b2>] page_fault+0x22/0x30
 [<ffffffff871bd7e3>] ? copy_page_to_iter+0x3b3/0x500
 [<ffffffff871bd5fe>] ? copy_page_to_iter+0x1ce/0x500
 [<ffffffff8723a2b0>] ? vmsplice_to_user+0x130/0x130
 [<ffffffff8723a2d2>] pipe_to_user+0x22/0x40
 [<ffffffff87239d4e>] __splice_from_pipe+0x11e/0x190
 [<ffffffff8723a254>] vmsplice_to_user+0xd4/0x130
 [<ffffffff870cb101>] ? trace_hardirqs_off_caller+0x21/0xc0
 [<ffffffff878253e4>] ? retint_restore_args+0xe/0xe
 [<ffffffff870ac74d>] ? get_parent_ip+0xd/0x50
 [<ffffffff870ac8ab>] ? preempt_count_sub+0x6b/0xf0
 [<13480 15547  14371 0x00000000
 ffff880031df7df0 0000000000000002 ffffffff870cb70e ffff88008ec30000
 00000000001d4080 0000000000000000 ffff880031df7fd8 00000000001d4080
 ffff8801039344d0 ffff88008ec30000 ffff880031df7fd8 ffffffff872361f4
Call Trace:
 [<ffffffff870cb70e>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8781df46>] preempt_schedule+0x36/0x60
 [<ffffffff8700e3d6>] ___preempt_schedule+0x56/0xb0
 [<ffffffff872361f4>] ? bdi_queue_work+0xe4/0x1a0
 [<ffffffff8707db77>] ? __local_bh_enable_ip+0xb7/0xe0
 [<ffffffff87823a45>] _raw_spin_unlock_bh+0x35/0x40
 [<ffffffff872361f4>] bdi_queue_work+0xe4/0x1a0
 [<ffffffff87236318>] __bdi_start_writeback+0x68/0x190
 [<ffffffff87238eb0>] wakeup_flusher_threads+0x100/0x1e0
 [<ffffffff87238de0>] ? wakeup_flusher_threads+0x30/0x1e0
 [<ffffffff8723cd86>] sys_sync+0x36/0xb0
 [<ffffffff878249e4>] tracesys+0xdd/0xe2
trinity-c9      R  running task    13496 15232  14371 0x00000000
 ffff88011a01fe58 0000000000000002 ffffffff87238ecf ffff8800a19616f0
 00000000001d4080 0000000000000000 ffff88011a01ffd8 00000000001d4080
 ffff880085d35bc0 ffff8800a19616f0 ffff88011a01ffd8 0000000000000000
Call Trace:
 [<ffffffff87238ecf>] ? wakeup_flusher_threads+0x11f/0x1e0
 [<ffffffff87238ecf>] ? wakeup_flusher_threads+0x11f/0x1e0
 [<ffffffff8781e182>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff87825550>] retint_kernel+0x20/0x30
 [<ffffffff87238ecf>] ? wakeup_flusher_threads+0x11f/0x1e0
 [<ffffffff870d1049>] ? lock_release+0x29/0x300
 [<ffffffff87238ee7>] wakeup_flusher_threads+0x137/0x1e0
 [<ffffffff87238de0>] ? wakeup_flusher_threads+0x30/0x1e0
 [<ffffffff8723cd86>] sys_sync+0x36/0xb0
 [<ffffffff878249e4>] tracesys+0xdd/0xe2
trinity-c387    R  running task    13272 15616  14371 0x00000004
 ffff880043fd37f8 0000000000000002 ffff880001fd3868 ffff88023304ade0
 00000000001d4080 0000000000000000 ffff880043fd3fd8 00000000001d4080
 ffff8801039344d0 ffff88023304ade0 ffff880043fd3fd8 0000000000000000
Call Trace:
 [<ffffffff8781e182>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff87825550>] retint_kernel+0x20/0x30
 [<ffffffff87190624>] ? find_get_entry+0xb4/0x270
 [<ffffffff8719076e>] ? find_get_entry+0x1fe/0x270
 [<ffffffff87190575>] ? find_get_entry+0x5/0x270
 [<ffffffff871907ff>] find_lock_entry+0x1f/0x90
 [<ffffffff871acb65>] shmem_getpage_gfp+0xd5/0xa10
 [<ffffffff871adb3d>] shmem_fault+0x6d/0x1c0
 [<ffffffff871bff58>] __do_fault+0x48/0xd0
 [<ffffffff871c25e0>] do_shared_fault.isra.75+0x40/0x1c0
 [<ffffffff8718892b>] ? __perf_sw_event+0x4b/0x380
 [<ffffffff871c3b21>] handle_mm_fault+0x261/0xcd0
 [<ffffffff870cb687>] ? __lock_is_held+0x57/0x80
 [<ffffffff87042c84>] __do_page_fault+0x1a4/0x600
 [<ffffffff870cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8718eda7>] ? context_tracking_user_exit+0x67/0x1b0
 [<ffffffff870430fe>] do_page_fault+0x1e/0x70
 [<ffffffff878264b2>] page_fault+0x22/0x30
 [<ffffffff871bd7e3>] ? copy_page_to_iter+0x3b3/0x500
 [<ffffffff871bd5fe>] ? copy_page_to_iter+0x1ce/0x500
 [<ffffffff8723a2b0>] ? vmsplice_to_user+0x130/0x130
 [<ffffffff8723a2d2>] pipe_to_user+0x22/0x40
 [<ffffffff87239d4e>] __splice_from_pipe+0x11e/0x190
 [<ffffffff8723a254>] vmsplice_to_user+0xd4/0x130
 [<ffffffff870cb101>] ? trace_hardirqs_off_caller+0x21/0xc0
 [<ffffffff878253e4>] ? retint_restore_args+0xe/0xe
 [<ffffffff870ac74d>] ? get_parent_ip+0xd/0x50
 [<ffffffff870ac8ab>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffff8723bd31>] SyS_vmsplice+0xc1/0xe0

