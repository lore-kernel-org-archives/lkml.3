Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaHEOHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:07:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:45206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbaHEOHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="571994433"
Date: Tue, 5 Aug 2014 22:07:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [rfcomm] WARNING: CPU: 0 PID: 105 at kernel/sched/core.c:7094
 __might_sleep()
Message-ID: <20140805140726.GC5593@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Here is an rfcomm error triggered by this debug check.

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/wait
commit 64c2181bc433b17f04da8fe8592aa83cceac9606
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon Aug 4 11:14:16 2014 +0200
Commit:     Peter Zijlstra <a.p.zijlstra@chello.nl>
CommitDate: Mon Aug 4 13:29:59 2014 +0200

    sched: Debug nested sleeps
    
    Validate we call might_sleep() with TASK_RUNNING, which catches places
    where we nest blocking primitives, eg. mutex usage in a wait loop.
    
    Since all blocking is arranged through task_struct::state, nesting
    this is going to cause two distinct issues:
    
     - the inner primitive will set TASK_RUNNING and the outer will not
       block
    
     - the outer sets !TASK_RUNNING and the inner expects to be called
       with TASK_RUNNING and blocks forever (mutex_lock).
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-0hge361rozfbng4z2t64t217@git.kernel.org

[    4.595230] mpoa:atm_mpoa_init: mpc.c: initialized
[    4.595625] 8021q: 802.1Q VLAN Support v1.8
[    4.596034] ------------[ cut here ]------------
[    4.596422] WARNING: CPU: 0 PID: 105 at kernel/sched/core.c:7094 __might_sleep+0x286/0x320()
[    4.597287] do not call blocking ops when !TASK_RUNNING; state=1 set at [<c21183b0>] rfcomm_run+0x160/0x27a0
[    4.598083] CPU: 0 PID: 105 Comm: krfcommd Not tainted 3.16.0-00053-g64c2181 #1
[    4.598668] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.599133]  c25eb548 d16ebe30 c236754c d16ebe60 c106fa44 c25eb644 d16ebe8c 00000069
[    4.599857]  c25eb548 00001bb6 c10b9b16 c10b9b16 d16bd810 c25ebd04 00000067 d16ebe78
[    4.600595]  c106fb3a 00000009 d16ebe70 c25eb644 d16ebe8c d16ebea8 c10b9b16 c25eb548
[    4.601320] Call Trace:
[    4.601531]  [<c236754c>] dump_stack+0x40/0x5e
[    4.601900]  [<c106fa44>] warn_slowpath_common+0xc4/0x110
[    4.602337]  [<c10b9b16>] ? __might_sleep+0x286/0x320
[    4.602752]  [<c10b9b16>] ? __might_sleep+0x286/0x320
[    4.603158]  [<c106fb3a>] warn_slowpath_fmt+0x4a/0x60
[    4.603581]  [<c10b9b16>] __might_sleep+0x286/0x320
[    4.603988]  [<c21183b0>] ? rfcomm_run+0x160/0x27a0
[    4.604384]  [<c21183b0>] ? rfcomm_run+0x160/0x27a0
[    4.604786]  [<c2118250>] ? rfcomm_check_accept+0x130/0x130
[    4.605241]  [<c23794c5>] mutex_lock+0x25/0x60
[    4.605604]  [<c2118412>] rfcomm_run+0x1c2/0x27a0
[    4.605993]  [<c10bd9bd>] ? pick_next_task_fair+0x12d/0x260
[    4.606441]  [<c237b7e1>] ? _raw_spin_unlock_irq+0x71/0xc0
[    4.606925]  [<c237229d>] ? __schedule+0x48d/0xb60
[    4.607316]  [<c237b6db>] ? _raw_spin_unlock_irqrestore+0x7b/0x110
[    4.607819]  [<c2372c69>] ? preempt_schedule+0x69/0xf0
[    4.608241]  [<c1013800>] ? ___preempt_schedule+0xc/0x1c
[    4.608667]  [<c237b700>] ? _raw_spin_unlock_irqrestore+0xa0/0x110
[    4.609170]  [<c2118250>] ? rfcomm_check_accept+0x130/0x130
[    4.609624]  [<c10a4258>] kthread+0x118/0x160
[    4.609987]  [<c237cac0>] ret_from_kernel_thread+0x20/0x30
[    4.610443]  [<c10a4140>] ? __kthread_unpark+0xa0/0xa0
[    4.610873] ---[ end trace 123887810d830305 ]---
[    4.611251] ------------[ cut here ]------------

This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang
