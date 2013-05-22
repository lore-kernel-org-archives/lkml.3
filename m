Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3EVMeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3EVMeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:34:19 -0400
Message-ID: <519CBB30.3060200@redhat.com>
Date: Wed, 22 May 2013 08:33:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH - sort of] x86: Livelock in handle_pte_fault
References: <5195ED8B.7060002@meduna.org> <1369183168.6828.168.camel@gandalf.local.home>
In-Reply-To: <1369183168.6828.168.camel@gandalf.local.home>
Content-Type: multipart/mixed;
 boundary="------------020901050200030000040607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020901050200030000040607
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/21/2013 08:39 PM, Steven Rostedt wrote:
> On Fri, 2013-05-17 at 10:42 +0200, Stanislav Meduna wrote:
>> Hi all,
>>
>> I don't know whether this is linux-rt specific or applies to
>> the mainline too, so I'll repeat some things the linux-rt
>> readers already know.
>>
>> Environment:
>>
>> - Geode LX or Celeron M
>> - _not_ CONFIG_SMP
>> - linux 3.4 with realtime patches and full preempt configured
>> - an application consisting of several mostly RR-class threads
>
> The threads do a mlockall too right? I'm not sure mlock will lock memory
> for a new thread's stack.
>
>> - the application runs with mlockall()
>
> With both MCL_FUTURE and MCL_CURRENT set, right?
>
>> - there is no swap
>
> Hmm, doesn't mean that code can't be swapped out, as it is just mapped
> from the file it came from. But you'd think mlockall would prevent that.
>
>>
>> Problem:
>>
>> - after several hours to 1-2 weeks some of the threads start to loop
>>    in the following way
>>
>>    0d...0 62811.755382: function:  do_page_fault
>>    0....0 62811.755386: function:     handle_mm_fault
>>    0....0 62811.755389: function:        handle_pte_fault
>>    0d...0 62811.755394: function:  do_page_fault
>>    0....0 62811.755396: function:     handle_mm_fault
>>    0....0 62811.755398: function:        handle_pte_fault
>>    0d...0 62811.755402: function:  do_page_fault
>>    0....0 62811.755404: function:     handle_mm_fault
>>    0....0 62811.755406: function:        handle_pte_fault
>>
>>    and stay in the loop until the RT throttling gets activated.
>>    One of the faulting addresses was in code (after returning
>>    from a syscall), a second one in stack (inside put_user right
>>    before a syscall ends), both were surely mapped.
>>
>> - After RT throttler activates it somehow magically fixes itself,
>>    probably (not verified) because another _process_ gets scheduled.
>>    When throttled the RR and FF threads are not allowed to run for
>>    a while (20 ms in my configuration). The livelocks lasts around
>>    1-3 seconds, and there is a SCHED_OTHER process that runs each
>>    2 seconds.
>
> Hmm, if there was a missed TLB flush, and we are faulting due to a bad
> TLB table, and it goes into an infinite faulting loop, the only thing
> that will stop it is the RT throttle. Then a new task gets scheduled,
> and we flush the TLB and everything is fine again.

That sounds like maybe we DO want a TLB flush on spurious
page faults, so we get rid of this problem.

Last fall we thought this problem could not happen on x86,
but your bug report suggests that it might.

We can get flush_tlb_fix_spurious_fault to do a local TLB
invalidate of just the address in question by removing the
x86-specific dummy version, falling back to the asm-generic
version that does something.

Can you test the attached patch?

-- 
All rights reversed

--------------020901050200030000040607
Content-Type: text/x-patch;
 name="flush-tlb-on-spurious-fault.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="flush-tlb-on-spurious-fault.patch"

Subject: x86,mm: flush TLB on spurious fault

It appears that certain x86 CPUs do not automatically flush the
TLB entry that caused a page fault, causing spurious faults to
loop forever under certain circumstances.

Remove the dummy flush_tlb_fix_spurious_fault define, so x86
falls back to the asm-generic version, which does do a local
TLB flush.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Stanislav Meduna <stano@meduna.org>
---
 arch/x86/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1e67223..43e7966 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -729,8 +729,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
-#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
-
 #define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
 
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS

--------------020901050200030000040607--
