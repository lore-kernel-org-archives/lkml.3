Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaDVAh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:37:28 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34641 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaDVAh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <5355A9E9.9070102@zytor.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com> <5355A9E9.9070102@zytor.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Mon, 21 Apr 2014 17:37:05 -0700
Message-ID: <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 4:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/21/2014 04:19 PM, Andrew Lutomirski wrote:
>>
>> Hahaha! :)
>>
>> Some comments:
>>
>> Does returning to 64-bit CS with 16-bit SS not need espfix?
>
> There is no such thing.  With a 64-bit CS, the flags on SS are ignored
> (although you still have to have a non-null SS... the conditions are a
> bit complex.)
>
>> Conversely, does 16-bit CS and 32-bit SS need espfix?
>
> It does not, at least to the best of my knowledge (it is controlled by
> the SS size, not the CS size.)
>
> I'm going to double-check the corner cases just out of healthy paranoia,
> but I'm 98% sure this is correct (and if not, the 32-bit code needs to
> be fixed, too.)
>
>>> @@ -1058,6 +1095,7 @@ bad_iret:
>>>          * So pretend we completed the iret and took the #GPF in user mode.
>>>          *
>>>          * We are now running with the kernel GS after exception recovery.
>>> +        * Exception entry will have removed us from the espfix stack.
>>>          * But error_entry expects us to have user GS to match the user %cs,
>>>          * so swap back.
>>>          */
>>
>> What is that referring to?
>
> It means that we have already switched back from the espfix stack to the
> real stack.
>
>>> +       /*
>>> +        * Switch from the espfix stack to the proper stack: tricky stuff.
>>> +        * On the stack right now is 5 words of exception frame,
>>> +        * error code/oldeax, RDI, and the return value, so no additional
>>> +        * stack is available.
>>> +        *
>>> +        * We will always be using the user space GS on entry.
>>> +       */
>>> +ENTRY(espfix_fix_stack)
>>> +       SWAPGS
>>> +       cld
>>> +       movq PER_CPU_VAR(kernel_stack),%rdi
>>> +       subq $8*8,%rdi
>>> +       /* Use the real stack to hold these registers for now */
>>> +       movq %rsi,-8(%rdi)
>>> +       movq %rcx,-16(%rdi)
>>> +       movq %rsp,%rsi
>>> +       movl $8,%ecx
>>> +       rep;movsq
>>> +       leaq -(10*8)(%rdi),%rsp
>>> +       popq %rcx
>>> +       popq %rsi
>>> +       SWAPGS
>>> +       retq
>>>
>>
>> Is it guaranteed that the userspace thread that caused this is dead?
>> If not, do you need to change RIP so that espfix gets invoked again
>> when you return from the exception?
>
> It is not guaranteed to be dead at all.  Why would you need to change
> RIP, though?

Oh.  You're not changing the RSP that you return to.  So this should be okay.

>
>>> +
>>> +void init_espfix_cpu(void)
>>> +{
>>> +       int cpu = smp_processor_id();
>>> +       unsigned long addr;
>>> +       pgd_t pgd, *pgd_p;
>>> +       pud_t pud, *pud_p;
>>> +       pmd_t pmd, *pmd_p;
>>> +       pte_t pte, *pte_p;
>>> +       int n;
>>> +       void *stack_page;
>>> +
>>> +       cpu = smp_processor_id();
>>> +       BUG_ON(cpu >= (8 << 20)/ESPFIX_STACK_SIZE);
>>> +
>>> +       /* We only have to do this once... */
>>> +       if (likely(this_cpu_read(espfix_stack)))
>>> +               return;         /* Already initialized */
>>> +
>>> +       addr = espfix_base_addr(cpu);
>>> +
>>> +       /* Did another CPU already set this up? */
>>> +       if (likely(espfix_already_there(addr)))
>>> +               goto done;
>>> +
>>> +       mutex_lock(&espfix_init_mutex);
>>> +
>>> +       if (unlikely(espfix_already_there(addr)))
>>> +               goto unlock_done;
>>
>> Wouldn't it be simpler to just have a single static bool to indicate
>> whether espfix is initialized?
>
> No, you would have to allocate memory for every possible CPU, which I
> wanted to avoid in case NR_CPUS >> actual CPUs (I don't know if we have
> already done that for percpu, but we *should* if we haven't yet.)
>
>> Even better: why not separate the percpu init from the pagetable init
>> and just do the pagetable init once from main or even modify_ldt?
>
> It needs to be done once per CPU.  I wanted to do it late enough that
> the page allocator is fully functional, so we don't have to do the ugly
> hacks to call one allocator or another as the percpu initialization code
> does (otherwise it would have made a lot of sense to co-locate with percpu.)

Hmm.  I guess espfix_already_there isn't so bad.  Given that, in the
worst case, I think there are 16 pages allocated, it might make sense
to just track which of those 16 pages have been allocated in some
array.  That whole array would probably be shorter than the test of
espfix_already_there.  Or am I still failing to understand how this
works?

--Andy
