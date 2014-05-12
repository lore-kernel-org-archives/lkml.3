Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaELS02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:26:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51174 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaELS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:26:26 -0400
Message-ID: <5371122D.6020605@oracle.com>
Date: Mon, 12 May 2014 14:25:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: sched: spinlock recursion in migrate_swap_stop
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[ 1738.758667] BUG: spinlock recursion on CPU#23, migration/23/328
[ 1738.761291]  lock: 0xffff8801f93b0c30, .magic: dead4ead, .owner: migration/23/328, .owner_cpu: 23
[ 1738.762733] CPU: 23 PID: 328 Comm: migration/23 Not tainted 3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
[ 1738.764081]  ffff8801f93b0c30 ffff8805505efbc8 ffffffff9453e1ec 0000000000000004
[ 1738.764914]  ffff8805505cb000 ffff8805505efbe8 ffffffff94531095 ffff8801f93b0c30
[ 1738.765120]  ffffffff9583485e ffff8805505efc08 ffffffff945310c0 ffff8801f93b0c30
[ 1738.765120] Call Trace:
[ 1738.768386] dump_stack (lib/dump_stack.c:52)
[ 1738.768386] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 6))
[ 1738.768386] spin_bug (kernel/locking/spinlock_debug.c:76)
[ 1738.768386] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135)
[ 1738.768386] _raw_spin_lock_nested (kernel/locking/spinlock.c:362 (discriminator 2))
[ 1738.768386] ? migrate_swap_stop (arch/x86/include/asm/paravirt.h:804 kernel/sched/sched.h:1406 kernel/sched/core.c:1099)
[ 1738.768386] ? _raw_spin_lock (kernel/locking/spinlock.c:152)
[ 1738.768386] ? migrate_swap_stop (kernel/sched/sched.h:1393 kernel/sched/core.c:1097)
[ 1738.768386] migrate_swap_stop (arch/x86/include/asm/paravirt.h:804 kernel/sched/sched.h:1406 kernel/sched/core.c:1099)
[ 1738.768386] ? queue_stop_cpus_work (include/linux/cpumask.h:108 include/linux/cpumask.h:174 kernel/stop_machine.c:375)
[ 1738.768386] multi_cpu_stop (kernel/stop_machine.c:225)
[ 1738.768386] ? queue_stop_cpus_work (kernel/stop_machine.c:171)
[ 1738.768386] cpu_stopper_thread (kernel/stop_machine.c:498)
[ 1738.768386] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 1738.768386] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[ 1738.768386] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1738.768386] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 1738.768386] smpboot_thread_fn (kernel/smpboot.c:160)
[ 1738.768386] ? __smpboot_create_thread (kernel/smpboot.c:105)
[ 1738.768386] kthread (kernel/kthread.c:210)
[ 1738.768386] ? complete (kernel/sched/completion.c:35)
[ 1738.768386] ? kthread_create_on_node (kernel/kthread.c:176)
[ 1738.768386] ret_from_fork (arch/x86/kernel/entry_64.S:553)
[ 1738.768386] ? kthread_create_on_node (kernel/kthread.c:176)


Thanks,
Sasha
