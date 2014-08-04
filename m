Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaHDDEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:04:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51380 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaHDDEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140801231929.GB26491@localhost.localdomain>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <20140801231929.GB26491@localhost.localdomain>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 4 Aug 2014 05:03:42 +0200
Message-ID: <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2014 at 1:19 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Aug 01, 2014 at 04:48:17PM +0200, Denys Vlasenko wrote:
>>
>>  /* 0(%rsp): ~(interrupt number) */
>>       .macro interrupt func
>> -     /* reserve pt_regs for scratch regs and rbp */
>> -     subq $ORIG_RAX-RBP, %rsp
>> -     CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
>> -     cld
>> -     /* start from rbp in pt_regs and jump over */
>> -     movq_cfi rdi, (RDI-RBP)
>> -     movq_cfi rsi, (RSI-RBP)
>> -     movq_cfi rdx, (RDX-RBP)
>> -     movq_cfi rcx, (RCX-RBP)
>> -     movq_cfi rax, (RAX-RBP)
>> -     movq_cfi  r8,  (R8-RBP)
>> -     movq_cfi  r9,  (R9-RBP)
>> -     movq_cfi r10, (R10-RBP)
>> -     movq_cfi r11, (R11-RBP)
>> -
>> -     /* Save rbp so that we can unwind from get_irq_regs() */
>> -     movq_cfi rbp, 0
>
> Hmm SAVEE_C_REGS below doesn't seem to save rbp like we did before.
> Perhaps it's implicitely saved somewhere?
>
>> -
>> -     /* Save previous stack value */
>> -     movq %rsp, %rsi
>
> Also rsp isn't saved in %rsi like before. Maybe
> that's because we already save it in rdi? Makes sense since
> now arg1 == rsp. More on that later.
>
>> -
>> -     leaq -RBP(%rsp),%rdi    /* arg1 for handler */
>> -     testl $3, CS-RBP(%rsi)
>> +     ALLOC_PTREGS_ON_STACK
>> +     SAVE_C_REGS
>> +     movq %rsp, %rdi /* arg1 for handler */
>> +     testl $3, CS(%rsp)
>>       je 1f
>>       SWAPGS
>> -     /*
>> +1:   /*
>>        * irq_count is used to check if a CPU is already on an interrupt stack
>>        * or not. While this is essentially redundant with preempt_count it is
>>        * a little cheaper to use a separate counter in the PDA (short of
>>        * moving irq_enter into assembly, which would be too much work)
>>        */
>> -1:   incl PER_CPU_VAR(irq_count)
>> +     incl PER_CPU_VAR(irq_count)
>>       cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
>> -     CFI_DEF_CFA_REGISTER    rsi
>> +     CFI_DEF_CFA_REGISTER    rdi
>>
>>       /* Store previous stack value */
>> -     pushq %rsi
>> +     pushq %rdi
>
> So you push rdi instead...
>
>>       CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
>>                       0x77 /* DW_OP_breg7 */, 0, \
>>                       0x06 /* DW_OP_deref */, \
>> -                     0x08 /* DW_OP_const1u */, SS+8-RBP, \
>> +                     0x08 /* DW_OP_const1u */, SS+8, \
>>                       0x22 /* DW_OP_plus */
>>       /* We entered an interrupt context - irqs are off: */
>>       TRACE_IRQS_OFF
>> -
>>       call \func
>>       .endm
>>
>> @@ -749,10 +719,9 @@ ret_from_intr:
>>
>>       /* Restore saved previous stack */
>>       popq %rsi
>
> And then you pop to rsi. Ok that indeed works but perhaps we should keep it symetrical
> just for clarity? Any reason why we can't reuse rdi here?

I changed this entire area in v2: basically, I will not change the logic,
but will add comments explaining what are we doing here, and why.
(Some minor code changes will be done, not affecting the logic).

While we are at it, what this  CFI_ESCAPE thing does here?
As usual, it has no comment :/

-- 
vda
