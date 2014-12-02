Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbaLBTeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:34:05 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:46812 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaLBTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:34:01 -0500
MIME-Version: 1.0
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com> <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Dec 2014 11:33:40 -0800
Message-ID: <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 11:09 AM, Berthier, Emmanuel
<emmanuel.berthier@intel.com> wrote:
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Friday, November 28, 2014 4:15 PM
>> To: Berthier, Emmanuel
>> Cc: Thomas Gleixner; H. Peter Anvin; X86 ML; Jarzmik, Robert; LKML
>> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
>>
>> On Fri, Nov 28, 2014 at 12:44 AM, Berthier, Emmanuel
>> <emmanuel.berthier@intel.com> wrote:
>> >  diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> > index df088bb..f39cded 100644
>> > --- a/arch/x86/kernel/entry_64.S
>> > +++ b/arch/x86/kernel/entry_64.S
>> > @@ -1035,6 +1035,46 @@ apicinterrupt IRQ_WORK_VECTOR \
>> >         irq_work_interrupt smp_irq_work_interrupt  #endif
>> >
>> > +.macro STOP_LBR
>> > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
>> > +       testl $3,CS+8(%rsp)             /* Kernel Space? */
>> > +       jz 1f
>> > +       testl $1, lbr_dump_on_exception
>>
>> Is there a guarantee that, if lbr_dump_on_exception is true, then LBR is on?
>> What happens if you schedule between stopping and resuming LBR?
>
> Good point. The current assumption is to rely on the numerous exceptions to "re-arm" the LBR recording.
> Even if we bypass UserSpace page faults, we can keep rely on kernel VMalloc page faults to re-arm the recording.

I don't really understand this.  Presumably page_fault should leave
the LBR setting exactly the way it found it, because otherwise it'll
need all kinds of fancy coordination with perf.  And vmalloc faults
are very rare.

You should also make sure that the perf code is okay with a PMI
nesting *inside* a fault that has disabled LBR.  Also, page faults are
rather performance sensitive, so the performance hit from this isn't
so great.

And keep in mind that we can context switch both inside an exception
handler and on the way out, so that all needs to work, too.

TBH, I'm wondering whether this is actually a good idea.  It might be
more valuable and less scary to try to make this work for BUG instead.
To get the most impact, it might be worth allocating a new exception
vector for BUG and using 'int 0xwhatever', and the prologue to that
could read out all the MSRs without any branches.

--Andy

>
>> > +       jz 1f
>> > +       push %rax
>> > +       push %rcx
>> > +       push %rdx
>> > +       movl $MSR_IA32_DEBUGCTLMSR, %ecx
>> > +       rdmsr
>> > +       and $~1, %eax                   /* Disable LBR recording */
>> > +       wrmsr
>>
>> wrmsr is rather slow.  Have you checked whether this is faster than just
>> saving the LBR trace on exception entry?
>
> The figures I have show that for common MSR, rdmsr and wrmsr have quite the same impact, around 100 cycles (greatly depends on the arch).
> The cost of stop/start is: 2 rdmsr + 2 wrmsr = 4 msr
> The cost of reading LBR is: 1 rdmsr for TOS + 2 rdmsr per record, and there are from 8 to 32 Records (Arch specific) = between 17 to 65 msr.
> I've measured on Atom arch (8 records): LBR read versus stop/start: around x3 more time.
> As the LBR size is arch dependent, it's not easy to implement the record reading in ASM without any branch, and this would generate maintenance dependency.
> I prefer to let perf_event_lbr dealing with all that stuff.
>
> Thx,
>
> Emmanuel.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
