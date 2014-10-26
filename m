Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaJZDCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 23:02:36 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35866 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaJZDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 23:02:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
References: <544C50CB.4090408@oracle.com>
Date: Sat, 25 Oct 2014 20:01:41 -0700
In-Reply-To: <544C50CB.4090408@oracle.com> (Sasha Levin's message of "Sat, 25
	Oct 2014 21:39:23 -0400")
Message-ID: <87siibttyi.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19E1Ga0t87sBgZBG2hvJpXSGtpoNOyTA20=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 966 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.7 (0.4%), b_tie_ro: 2.6 (0.3%), parse: 1.23 (0.1%),
	extract_message_metadata: 28 (2.9%), get_uri_detail_list: 6 (0.6%),
	tests_pri_-1000: 8 (0.8%), tests_pri_-950: 2.1 (0.2%), tests_pri_-900: 1.66
	(0.2%), tests_pri_-400: 43 (4.4%), check_bayes: 40 (4.2%), b_tokenize: 19
	(2.0%), b_tok_get_all: 11 (1.1%), b_comp_prob: 4.7 (0.5%), b_tok_touch_all:
	2.3 (0.2%), b_finish: 0.84 (0.1%), tests_pri_0: 865 (89.6%), tests_pri_500: 7
	(0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:

Weird.  I took a quick look and I don't see any changes in d_walk that
in Al's tree or in Linus's kernel for years.

Has read_seqbegin_or_lock changed somewhere?

>From a quick reading of the code it simply isn't possible for d_walk to
take the lock twice short of memory corruption.  And the fact that the
code has not changed in years seems to suggest it isn't the obvious
cause of d_walk talking the rename_lock twice.

Eric

> [ 6172.870045] =============================================
> [ 6172.870045] [ INFO: possible recursive locking detected ]
> [ 6172.870045] 3.18.0-rc1-next-20141023-sasha-00036-g4dcabd5 #1415 Not tainted
> [ 6172.870045] ---------------------------------------------
> [ 6172.870045] trinity-c55/12752 is trying to acquire lock:
> [ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045]
> [ 6172.870045] but task is already holding lock:
> [ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045]
> [ 6172.870045] other info that might help us debug this:
> [ 6172.900904] FAULT_INJECTION: forcing a failure
> [ 6172.870045]  Possible unsafe locking scenario:
> [ 6172.870045]
> [ 6172.870045]        CPU0
> [ 6172.870045]        ----
> [ 6172.870045]   lock(rename_lock);
> [ 6172.870045]   lock(rename_lock);
> [ 6172.870045]
> [ 6172.870045]  *** DEADLOCK ***
> [ 6172.870045]
> [ 6172.870045]  May be due to missing lock nesting notation
> [ 6172.870045]
> [ 6172.870045] 1 lock held by trinity-c55/12752:
> [ 6172.870045] #0: (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045]
> [ 6172.870045] stack backtrace:
> [ 6172.870045] CPU: 1 PID: 12752 Comm: trinity-c55 Not tainted 3.18.0-rc1-next-20141023-sasha-00036-g4dcabd5 #1415
> [ 6172.870045]  ffff88070945b000 0000000000000000 ffffffffb6312fd0 ffff8806d69ff728
> [ 6172.870045]  ffffffffa8ff75ca 0000000000000011 ffffffffb6312fd0 ffff8806d69ff828
> [ 6172.870045]  ffffffff9f3a012b ffff880107fd76c0 ffff880107fd76c0 0000000000000001
> [ 6172.870045] Call Trace:
> [ 6172.870045] dump_stack (lib/dump_stack.c:52)
> [ 6172.870045] validate_chain.isra.10 (kernel/locking/lockdep.c:2134)
> [ 6172.870045] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
> [ 6172.870045] ? sched_clock_cpu (kernel/sched/clock.c:311)
> [ 6172.870045] __lock_acquire (kernel/locking/lockdep.c:3184)
> [ 6172.870045] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3604)
> [ 6172.870045] ? d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045] ? put_lock_stats.isra.7 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [ 6172.870045] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [ 6172.870045] ? d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045] d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045] ? d_walk (fs/dcache.c:1087)
> [ 6172.870045] ? d_drop (fs/dcache.c:1336)
> [ 6172.870045] ? select_collect (fs/dcache.c:1323)
> [ 6172.870045] d_invalidate (fs/dcache.c:1381)
> [ 6172.870045] lookup_fast (fs/namei.c:1440)
> [ 6172.870045] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
> [ 6172.870045] ? lockref_put_or_lock (lib/lockref.c:135)
> [ 6172.870045] ? dput (fs/dcache.c:626)
> [ 6172.870045] walk_component (fs/namei.c:1545)
> [ 6172.870045] ? security_inode_permission (security/security.c:573)
> [ 6172.870045] ? __inode_permission (fs/namei.c:418)
> [ 6172.870045] link_path_walk (fs/namei.c:1805)
> [ 6172.870045] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 6172.870045] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
> [ 6172.870045] ? getname_flags (fs/namei.c:145)
> [ 6172.870045] path_lookupat (fs/namei.c:1956)
> [ 6172.870045] ? kmem_cache_alloc (include/linux/rcupdate.h:479 include/trace/events/kmem.h:53 mm/slub.c:2463)
> [ 6172.870045] ? getname_flags (fs/namei.c:145)
> [ 6172.870045] filename_lookup (fs/namei.c:2000)
> [ 6172.870045] user_path_at_empty (fs/namei.c:2151)
> [ 6172.870045] ? preempt_count_sub (kernel/sched/core.c:2662)
> [ 6172.870045] user_path_at (fs/namei.c:2162)
> [ 6172.870045] vfs_fstatat (fs/stat.c:106)
> [ 6172.870045] SYSC_newlstat (fs/stat.c:284)
> [ 6172.870045] ? syscall_trace_enter_phase2 (arch/x86/kernel/ptrace.c:1598)
> [ 6172.870045] ? tracesys_phase2 (arch/x86/kernel/entry_64.S:518)
> [ 6172.870045] SyS_newlstat (fs/stat.c:277)
> [ 6172.870045] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
>
> The machine proceeded to actually lock up, so this isn't a false positive.
>
>
> Thanks,
> Sasha
