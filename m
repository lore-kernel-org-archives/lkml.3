Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966265AbaFRLYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:24:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34344 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbaFRLYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:24:52 -0400
Message-ID: <53A176F2.8060502@oracle.com>
Date: Wed, 18 Jun 2014 07:24:34 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Bob Liu <bob.liu@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: NULL ptr deref in remove_migration_pte
References: <534E9ACA.2090008@oracle.com> <5367B365.1070709@oracle.com> <537FE9F3.40508@oracle.com> <alpine.LSU.2.11.1405261255530.3649@eggly.anvils> <538498A1.7010305@oracle.com> <alpine.LSU.2.11.1406092104330.12382@eggly.anvils> <539F5BC5.3010501@oracle.com> <alpine.LSU.2.11.1406171959470.1535@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406171959470.1535@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 11:36 PM, Hugh Dickins wrote:
> On Mon, 16 Jun 2014, Sasha Levin wrote:
>> On 06/10/2014 12:20 AM, Hugh Dickins wrote:
>>> Although there's nothing in the backtrace to implicate it,
>>> I think this crash is caused by THP: please try this patch - thanks.
>>>
>>> [PATCH] mm: let mm_find_pmd fix buggy race with THP fault
> ...
>>
>> It took some time to hit something here,
> 
> I take that to mean that you were running with the mm_find_pmd patch in,
> and it seemed to take a little longer to hit the problem than before?

Yes. I've also only seen it once so far.

>> but I think that the following is related:
> 
> I agree it does look like a variant of what you got before the patch;
> but I still think the patch is good, and don't believe it caused this.
> 
> It looks as if these symptoms have an additional cause, which that patch
> did not even attempt to address.  I've looked around, but not found what.
> 
>>
>> [  489.152166] INFO: trying to register non-static key.
>> [  489.152166] the code is fine but needs lockdep annotation.
>> [  489.152166] turning off the locking correctness validator.
>> [  489.152166] CPU: 23 PID: 12148 Comm: trinity-c79 Not tainted 3.15.0-next-20140616-sasha-00025-g0fd1f7d-dirty #657
>> [  489.152166]  ffff8804dd013000 ffff8804e15a38e8 ffffffff965140d1 0000000000000002
>> [  489.152166]  ffffffff9a5ce7c0 ffff8804e15a39e8 ffffffff931ca363 ffff8804e15a3928
>> [  489.152166]  0000000000000000 0000000000000000 ffff8804e4730978 0000000000000001
>> [  489.152166] Call Trace:
>> [  489.152166] dump_stack (lib/dump_stack.c:52)
>> [  489.152166] __lock_acquire (kernel/locking/lockdep.c:743 kernel/locking/lockdep.c:3078)
>> [  489.152166] ? __lock_acquire (kernel/locking/lockdep.c:3189)
>> [  489.152166] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
>> [  489.152166] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
>> [  489.152166] ? __page_check_address (include/linux/spinlock.h:303 mm/rmap.c:630)
>> [  489.152166] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
>> [  489.152166] ? __page_check_address (include/linux/spinlock.h:303 mm/rmap.c:630)
>> [  489.152166] ? get_parent_ip (kernel/sched/core.c:2546)
>> [  489.152166] __page_check_address (include/linux/spinlock.h:303 mm/rmap.c:630)
>> [  489.152166] try_to_unmap_one (mm/rmap.c:1153)
>> [  489.152166] ? __const_udelay (arch/x86/lib/delay.c:126)
>> [  489.152166] ? __rcu_read_unlock (kernel/rcu/update.c:97)
>> [  489.152166] ? page_lock_anon_vma_read (mm/rmap.c:448)
>> [  489.152166] rmap_walk (mm/rmap.c:1654 mm/rmap.c:1725)
>> [  489.152166] ? preempt_count_sub (kernel/sched/core.c:2602)
>> [  489.152166] try_to_unmap (mm/rmap.c:1547)
>> [  489.152166] ? page_remove_rmap (mm/rmap.c:1144)
>> [  489.152166] ? invalid_migration_vma (mm/rmap.c:1503)
>> [  489.152166] ? try_to_unmap_one (mm/rmap.c:1411)
>> [  489.152166] ? anon_vma_prepare (mm/rmap.c:448)
>> [  489.152166] ? invalid_mkclean_vma (mm/rmap.c:1498)
>> [  489.152166] ? page_get_anon_vma (mm/rmap.c:405)
>> [  489.152166] migrate_pages (mm/migrate.c:913 mm/migrate.c:959 mm/migrate.c:1146)
>> [  489.152166] ? _raw_spin_unlock_irq (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:169 kernel/locking/spinlock.c:199)
>> [  489.152166] ? perf_trace_mm_numa_migrate_ratelimit (mm/migrate.c:1594)
>> [  489.152166] migrate_misplaced_page (mm/migrate.c:1754)
>> [  489.152166] __handle_mm_fault (mm/memory.c:3157 mm/memory.c:3207 mm/memory.c:3317)
>> [  489.152166] handle_mm_fault (include/linux/memcontrol.h:151 mm/memory.c:3343)
>> [  489.152166] ? __do_page_fault (arch/x86/mm/fault.c:1163)
>> [  489.152166] __do_page_fault (arch/x86/mm/fault.c:1230)
>> [  489.152166] ? vtime_account_user (kernel/sched/cputime.c:687)
>> [  489.152166] ? get_parent_ip (kernel/sched/core.c:2546)
>> [  489.152166] ? preempt_count_sub (kernel/sched/core.c:2602)
>> [  489.152166] ? context_tracking_user_exit (kernel/context_tracking.c:184)
>> [  489.152166] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
>> [  489.152166] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2638 (discriminator 2))
>> [  489.152166] trace_do_page_fault (arch/x86/mm/fault.c:1313 include/linux/jump_label.h:115 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1314)
>> [  489.152166] do_async_page_fault (arch/x86/kernel/kvm.c:264)
>> [  489.152166] async_page_fault (arch/x86/kernel/entry_64.S:1322)
> 
> Originally I thought that the trace above and the trace below were
> probably unrelated, there being more than five seconds between them.
> 
> But then noticed ffff8804e4730978 in the stack contents above, with
> ffff8804e4730e10 the object address in the slub diagnostic below.
> 
> As Christoph points out, the slub diagnostic shows that something
> has been overwriting with zeroes there.
> 
> Maybe the whole page (containing the slub-allocated page table lock
> being checked by lockdep above) has been overwritten with zeroes.
> 
> From experience a few months ago in another context, I believe that
> would issue precisely the cryptic "INFO: trying to register non-static
> key.  the code is fine but needs lockdep annotation." seen above.
> 
> I think I'm going to ignore this one for now, assuming it to be
> some randomish slab corruption from a bad patch in linux-next.
> 
> (I do take reports on 3.XY-rcZ more seriously than reports on
> linux-next; but recognize that you're trying to give advance
> warning, and to cover different territory than Dave does.)
> 
> If it's reproducible on linux-next in a week or so's time,
> please let me know, and I'll worry about it some more then.

Sounds good to me. I'll ping again whenever the issue reproduces. The
way it looks now it won't be any time soon.


Thanks,
Sasha

