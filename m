Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab3GPU2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:28:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34250 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582Ab3GPU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
References: <20130716183441.GA14232@www.outflux.net>
	<CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
Date: Tue, 16 Jul 2013 13:28:17 -0700
X-Google-Sender-Auth: tMu7ehCo49d74Y0kqrloZVPDvmY
Message-ID: <CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Kees Cook <keescook@chromium.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 1:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jul 16, 2013 at 11:34 AM, Kees Cook <keescook@chromium.org> wrote:
>> Since the IDT is referenced from a fixmap, make sure it is page aligned.
>> Merge with 32-bit one, since it was already aligned to deal with F00F
>> bug. Since bss is cleared before IDT setup, it can live there. This also
>> moves the other *_idt_table variables into common locations.
>>
>> This avoids the risk of the IDT ever being moved in the bss and having
>> the mapping be offset, resulting in calling incorrect handlers. In the
>> current upstream kernel this is not a manifested bug, but heavily patched
>> kernels (such as those using the PaX patch series) did encounter this bug.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Reported-by: PaX Team <pageexec@gmail.com>
>> ---
>> v5:
>>  - add comments to all IDTs about alignment reasoning, suggested by Linus
>
> Where is thread for that?

That was off list, part of trying to coordinate this cleanup vs
minimal changes for the stable tree.

>> v4:
>>  - rework using __page_aligned_bss, suggested by Yinghai LU
>>  - move all the other IDT variables as well, suggested by HPA
>> v3:
>>  - merge 32-bit and 64-bit idt_table definition
>> v2:
>>  - 32-bit was already aligned
>> ---
>>  arch/x86/kernel/head_64.S    |   15 ---------------
>>  arch/x86/kernel/tracepoint.c |    6 ++----
>>  arch/x86/kernel/traps.c      |   12 ++++++------
>>  3 files changed, 8 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index 5e4d8a8..e1aabdb 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -512,21 +512,6 @@ ENTRY(phys_base)
>>
>>  #include "../../x86/xen/xen-head.S"
>>
>> -       .section .bss, "aw", @nobits
>> -       .align L1_CACHE_BYTES
>> -ENTRY(idt_table)
>> -       .skip IDT_ENTRIES * 16
>> -
>> -       .align L1_CACHE_BYTES
>> -ENTRY(debug_idt_table)
>> -       .skip IDT_ENTRIES * 16
>> -
>> -#ifdef CONFIG_TRACING
>> -       .align L1_CACHE_BYTES
>> -ENTRY(trace_idt_table)
>> -       .skip IDT_ENTRIES * 16
>> -#endif
>> -
>>         __PAGE_ALIGNED_BSS
>>  NEXT_PAGE(empty_zero_page)
>>         .skip PAGE_SIZE
>> diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
>> index 4e584a8..1c113db 100644
>> --- a/arch/x86/kernel/tracepoint.c
>> +++ b/arch/x86/kernel/tracepoint.c
>> @@ -12,10 +12,8 @@ atomic_t trace_idt_ctr = ATOMIC_INIT(0);
>>  struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
>>                                 (unsigned long) trace_idt_table };
>>
>> -#ifndef CONFIG_X86_64
>> -gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
>> -                                       = { { { { 0, 0 } } }, };
>> -#endif
>> +/* No need to be aligned, but done to keep all IDTs defined the same way. */
>> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
>
> in that case why not add __cacheline_aligned_bss?

It seemed more correct to me to define all the IDTs the same, but
there was no technical reason for that, just one of regularity. I only
care about keeping the real IDT page aligned. :) I'm fine to do
whatever is deemed "correct". :)

-Kees

--
Kees Cook
Chrome OS Security
