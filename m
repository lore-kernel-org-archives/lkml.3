Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaJZBjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 21:39:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47621 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaJZBjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 21:39:40 -0400
Message-ID: <544C50CB.4090408@oracle.com>
Date: Sat, 25 Oct 2014 21:39:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: fs: lockup on rename_mutex in fs/dcache.c:1035
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 6172.870045] =============================================
[ 6172.870045] [ INFO: possible recursive locking detected ]
[ 6172.870045] 3.18.0-rc1-next-20141023-sasha-00036-g4dcabd5 #1415 Not tainted
[ 6172.870045] ---------------------------------------------
[ 6172.870045] trinity-c55/12752 is trying to acquire lock:
[ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045]
[ 6172.870045] but task is already holding lock:
[ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045]
[ 6172.870045] other info that might help us debug this:
[ 6172.900904] FAULT_INJECTION: forcing a failure
[ 6172.870045]  Possible unsafe locking scenario:
[ 6172.870045]
[ 6172.870045]        CPU0
[ 6172.870045]        ----
[ 6172.870045]   lock(rename_lock);
[ 6172.870045]   lock(rename_lock);
[ 6172.870045]
[ 6172.870045]  *** DEADLOCK ***
[ 6172.870045]
[ 6172.870045]  May be due to missing lock nesting notation
[ 6172.870045]
[ 6172.870045] 1 lock held by trinity-c55/12752:
[ 6172.870045] #0: (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045]
[ 6172.870045] stack backtrace:
[ 6172.870045] CPU: 1 PID: 12752 Comm: trinity-c55 Not tainted 3.18.0-rc1-next-20141023-sasha-00036-g4dcabd5 #1415
[ 6172.870045]  ffff88070945b000 0000000000000000 ffffffffb6312fd0 ffff8806d69ff728
[ 6172.870045]  ffffffffa8ff75ca 0000000000000011 ffffffffb6312fd0 ffff8806d69ff828
[ 6172.870045]  ffffffff9f3a012b ffff880107fd76c0 ffff880107fd76c0 0000000000000001
[ 6172.870045] Call Trace:
[ 6172.870045] dump_stack (lib/dump_stack.c:52)
[ 6172.870045] validate_chain.isra.10 (kernel/locking/lockdep.c:2134)
[ 6172.870045] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 6172.870045] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 6172.870045] __lock_acquire (kernel/locking/lockdep.c:3184)
[ 6172.870045] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3604)
[ 6172.870045] ? d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045] ? put_lock_stats.isra.7 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 6172.870045] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 6172.870045] ? d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045] d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
[ 6172.870045] ? d_walk (fs/dcache.c:1087)
[ 6172.870045] ? d_drop (fs/dcache.c:1336)
[ 6172.870045] ? select_collect (fs/dcache.c:1323)
[ 6172.870045] d_invalidate (fs/dcache.c:1381)
[ 6172.870045] lookup_fast (fs/namei.c:1440)
[ 6172.870045] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[ 6172.870045] ? lockref_put_or_lock (lib/lockref.c:135)
[ 6172.870045] ? dput (fs/dcache.c:626)
[ 6172.870045] walk_component (fs/namei.c:1545)
[ 6172.870045] ? security_inode_permission (security/security.c:573)
[ 6172.870045] ? __inode_permission (fs/namei.c:418)
[ 6172.870045] link_path_walk (fs/namei.c:1805)
[ 6172.870045] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 6172.870045] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[ 6172.870045] ? getname_flags (fs/namei.c:145)
[ 6172.870045] path_lookupat (fs/namei.c:1956)
[ 6172.870045] ? kmem_cache_alloc (include/linux/rcupdate.h:479 include/trace/events/kmem.h:53 mm/slub.c:2463)
[ 6172.870045] ? getname_flags (fs/namei.c:145)
[ 6172.870045] filename_lookup (fs/namei.c:2000)
[ 6172.870045] user_path_at_empty (fs/namei.c:2151)
[ 6172.870045] ? preempt_count_sub (kernel/sched/core.c:2662)
[ 6172.870045] user_path_at (fs/namei.c:2162)
[ 6172.870045] vfs_fstatat (fs/stat.c:106)
[ 6172.870045] SYSC_newlstat (fs/stat.c:284)
[ 6172.870045] ? syscall_trace_enter_phase2 (arch/x86/kernel/ptrace.c:1598)
[ 6172.870045] ? tracesys_phase2 (arch/x86/kernel/entry_64.S:518)
[ 6172.870045] SyS_newlstat (fs/stat.c:277)
[ 6172.870045] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

The machine proceeded to actually lock up, so this isn't a false positive.


Thanks,
Sasha
