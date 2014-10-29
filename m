Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaJ2TGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:06:03 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13700 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaJ2TGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:06:01 -0400
Message-ID: <54513A90.3080108@hp.com>
Date: Wed, 29 Oct 2014 15:05:52 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization support
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com> <1413483040-58399-10-git-send-email-Waiman.Long@hp.com> <20141024085437.GV21513@worktop.programming.kicks-ass.net> <544E830C.6070307@hp.com> <20141027180439.GL3337@twins.programming.kicks-ass.net> <544EB79E.6020200@hp.com>
In-Reply-To: <544EB79E.6020200@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 05:22 PM, Waiman Long wrote:
> On 10/27/2014 02:04 PM, Peter Zijlstra wrote:
>> On Mon, Oct 27, 2014 at 01:38:20PM -0400, Waiman Long wrote:
>>> On 10/24/2014 04:54 AM, Peter Zijlstra wrote:
>>>> On Thu, Oct 16, 2014 at 02:10:38PM -0400, Waiman Long wrote:
>>>>
>>>>> Since enabling paravirt spinlock will disable unlock function 
>>>>> inlining,
>>>>> a jump label can be added to the unlock function without adding patch
>>>>> sites all over the kernel.
>>>> But you don't have to. My patches allowed for the inline to remain,
>>>> again reducing the overhead of enabling PV spinlocks while running 
>>>> on a
>>>> real machine.
>>>>
>>>> Look at:
>>>>
>>>>    http://lkml.kernel.org/r/20140615130154.213923590@chello.nl
>>>>
>>>> In particular this hunk:
>>>>
>>>> Index: linux-2.6/arch/x86/kernel/paravirt_patch_64.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/kernel/paravirt_patch_64.c
>>>> +++ linux-2.6/arch/x86/kernel/paravirt_patch_64.c
>>>> @@ -22,6 +22,10 @@ DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs")
>>>>   DEF_NATIVE(, mov32, "mov %edi, %eax");
>>>>   DEF_NATIVE(, mov64, "mov %rdi, %rax");
>>>>
>>>> +#if defined(CONFIG_PARAVIRT_SPINLOCKS)&&   
>>>> defined(CONFIG_QUEUE_SPINLOCK)
>>>> +DEF_NATIVE(pv_lock_ops, queue_unlock, "movb $0, (%rdi)");
>>>> +#endif
>>>> +
>>>>   unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
>>>>   {
>>>>          return paravirt_patch_insns(insnbuf, len,
>>>> @@ -61,6 +65,9 @@ unsigned native_patch(u8 type, u16 clobb
>>>>                  PATCH_SITE(pv_cpu_ops, clts);
>>>>                  PATCH_SITE(pv_mmu_ops, flush_tlb_single);
>>>>                  PATCH_SITE(pv_cpu_ops, wbinvd);
>>>> +#if defined(CONFIG_PARAVIRT_SPINLOCKS)&&   
>>>> defined(CONFIG_QUEUE_SPINLOCK)
>>>> +               PATCH_SITE(pv_lock_ops, queue_unlock);
>>>> +#endif
>>>>
>>>>          patch_site:
>>>>                  ret = paravirt_patch_insns(ibuf, len, start, end);
>>>>
>>>>
>>>> That makes sure to overwrite the callee-saved call to the
>>>> pv_lock_ops::queue_unlock with the immediate asm "movb $0, (%rdi)".
>>>>
>>>>
>>>> Therefore you can retain the inlined unlock with hardly (there 
>>>> might be
>>>> some NOP padding) any overhead at all. On PV it reverts to a callee
>>>> saved function call.
>>> My concern is that spin_unlock() can be called in many places, 
>>> including
>>> loadable kernel modules. Can the paravirt_patch_ident_32() function 
>>> able to
>>> patch all of them in reasonable time? How about a kernel module 
>>> loaded later
>>> at run time?
>> modules should be fine, see arch/x86/kernel/module.c:module_finalize()
>> ->  apply_paravirt().
>>
>> Also note that the 'default' text is an indirect call into the paravirt
>> ops table which routes to the 'right' function, so even if the text
>> patching would be 'late' calls would 'work' as expected, just slower.
>
> Thanks for letting me know about that. I have this concern because 
> your patch didn't change the current configuration of disabling unlock 
> inlining when paravirt_spinlock is enabled. With that, I think it is 
> worthwhile to reduce the performance delta between the PV and non-PV 
> kernel on bare metal.

I am sorry that the unlock call sites patching code doesn't work in a 
virtual guest. Your pvqspinlock patch did an unconditional patching even 
in a virtual guest. I added check for the paravirt_spinlocks_enabled, 
but it turned out that some spin_unlock() seemed to be called before 
paravirt_spinlocks_enabled is set. As a result, some call sites were 
still patched resulting in missed wake up's and system hang.

At this point, I am going to leave out that change from my patch set 
until we can figure out a better way of doing that.

-Longman
