Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaDDWGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:06:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaDDWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:06:47 -0400
Message-ID: <533F2CED.3070006@oracle.com>
Date: Fri, 04 Apr 2014 18:06:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: bdi: lockdep warning in bdi_queue_work
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:

[  323.192041] INFO: trying to register non-static key.
[  323.193083] the code is fine but needs lockdep annotation.
[  323.193949] turning off the locking correctness validator.
[  323.194687] CPU: 15 PID: 21793 Comm: trinity-c94 Not tainted 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
[  323.196300]  0000000000000000 ffff8804d9067cf8 ffffffff954bfb2f 0000000000000000
[  323.197522]  ffffffff99378b10 ffff8804d9067df8 ffffffff921c3912 ffff88082bddaeb0
[  323.198879]  ffff880800000000 ffff880400000001 ffffffff00000000 ffff8804d9067d48
[  323.200063] Call Trace:
[  323.200487] dump_stack (lib/dump_stack.c:52)
[  323.200581] __lock_acquire (kernel/locking/lockdep.c:743 kernel/locking/lockdep.c:3078)
[  323.200581] ? __slab_alloc (mm/slub.c:2385 (discriminator 2))
[  323.200581] ? __lock_acquire (kernel/locking/lockdep.c:3189)
[  323.200581] ? kvm_clock_read (arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[  323.200581] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  323.200581] ? bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
[  323.200581] _raw_spin_lock_bh (include/linux/spinlock_api_smp.h:136 kernel/locking/spinlock.c:175)
[  323.200581] ? bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
[  323.200581] bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
[  323.200581] __bdi_start_writeback (fs/fs-writeback.c:141)
[  323.200581] wakeup_flusher_threads (fs/fs-writeback.c:1077)
[  323.200581] ? wakeup_flusher_threads (include/linux/rcupdate.h:800 fs/fs-writeback.c:1076)
[  323.200581] ? syscall_trace_enter (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1461)
[  323.200581] sys_sync (fs/sync.c:107)
[  323.200581] tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
