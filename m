Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaJ0Uzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:55:42 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:2142 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaJ0Uzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:55:41 -0400
Message-ID: <544EB146.1070708@hp.com>
Date: Mon, 27 Oct 2014 16:55:34 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization support
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com> <1413483040-58399-10-git-send-email-Waiman.Long@hp.com> <20141024085437.GV21513@worktop.programming.kicks-ass.net> <544E830C.6070307@hp.com> <20141027180252.GC12989@laptop.dumpdata.com>
In-Reply-To: <20141027180252.GC12989@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 02:02 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 27, 2014 at 01:38:20PM -0400, Waiman Long wrote:
>> On 10/24/2014 04:54 AM, Peter Zijlstra wrote:
>>> On Thu, Oct 16, 2014 at 02:10:38PM -0400, Waiman Long wrote:
>>>
>>>> Since enabling paravirt spinlock will disable unlock function inlining,
>>>> a jump label can be added to the unlock function without adding patch
>>>> sites all over the kernel.
>>> But you don't have to. My patches allowed for the inline to remain,
>>> again reducing the overhead of enabling PV spinlocks while running on a
>>> real machine.
>>>
>>> Look at:
>>>
>>>    http://lkml.kernel.org/r/20140615130154.213923590@chello.nl
>>>
>>> In particular this hunk:
>>>
>>> Index: linux-2.6/arch/x86/kernel/paravirt_patch_64.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/paravirt_patch_64.c
>>> +++ linux-2.6/arch/x86/kernel/paravirt_patch_64.c
>>> @@ -22,6 +22,10 @@ DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs")
>>>   DEF_NATIVE(, mov32, "mov %edi, %eax");
>>>   DEF_NATIVE(, mov64, "mov %rdi, %rax");
>>>
>>> +#if defined(CONFIG_PARAVIRT_SPINLOCKS)&&   defined(CONFIG_QUEUE_SPINLOCK)
>>> +DEF_NATIVE(pv_lock_ops, queue_unlock, "movb $0, (%rdi)");
>>> +#endif
>>> +
>>>   unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
>>>   {
>>>          return paravirt_patch_insns(insnbuf, len,
>>> @@ -61,6 +65,9 @@ unsigned native_patch(u8 type, u16 clobb
>>>                  PATCH_SITE(pv_cpu_ops, clts);
>>>                  PATCH_SITE(pv_mmu_ops, flush_tlb_single);
>>>                  PATCH_SITE(pv_cpu_ops, wbinvd);
>>> +#if defined(CONFIG_PARAVIRT_SPINLOCKS)&&   defined(CONFIG_QUEUE_SPINLOCK)
>>> +               PATCH_SITE(pv_lock_ops, queue_unlock);
>>> +#endif
>>>
>>>          patch_site:
>>>                  ret = paravirt_patch_insns(ibuf, len, start, end);
>>>
>>>
>>> That makes sure to overwrite the callee-saved call to the
>>> pv_lock_ops::queue_unlock with the immediate asm "movb $0, (%rdi)".
>>>
>>>
>>> Therefore you can retain the inlined unlock with hardly (there might be
>>> some NOP padding) any overhead at all. On PV it reverts to a callee
>>> saved function call.
>> My concern is that spin_unlock() can be called in many places, including
>> loadable kernel modules. Can the paravirt_patch_ident_32() function able to
>> patch all of them in reasonable time? How about a kernel module loaded later
>> at run time?
> It has too. When the modules are loaded the .paravirt symbols are exposed
> and the module loader patches that.
>
> And during bootup time (before modules are loaded) it also patches everything
> - when it only runs on one CPU.
>> So I think we may still need to disable unlock function inlining even if we
>> used your way kernel site patching.
> No need. Inline should (And is) working just fine.
>> Regards,
>> Longman

Thanks for letting me know about the paravirt patching capability 
available in the kernel. In this case, I would say we should use Peter's 
way of doing unlock without disabling unlock function inlining. That 
will further reduce the performance difference of kernels with and 
without PV.

Cheer,
Longman
