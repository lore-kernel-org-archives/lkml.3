Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935201AbaLLRzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:55:06 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61739 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaLLRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:55:03 -0500
MIME-Version: 1.0
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EFE6C@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
 <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
 <alpine.DEB.2.11.1412022044410.16275@nanos> <CALCETrW1hsmUrrG9KzfAujFuGcF1g1b8m++hJkxSGxketobUHw@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356ECDFD@IRSMSX110.ger.corp.intel.com>
 <CALCETrVk6XiFeAPKU4bM_ZFFSRmQQvDS=Ascs17qcRM3503ETQ@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356ED34A@IRSMSX110.ger.corp.intel.com>
 <CALCETrWr=6BnQ7r4KYDVJzeNPO-pxk9wRmkkLy+mM1T_85Y=jw@mail.gmail.com>
 <87fvctnk7c.fsf@intel.com> <CALCETrXhfzd9Fkikvm5qj0LWgWtDzgdpY_0EC3ChwyyGZksTMw@mail.gmail.com>
 <87bnnfnw0f.fsf@intel.com> <CALCETrUoVJzZL3hqe+nih+eDHUX3LERpJWw8-S4mowHhR1PEqA@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EFE6C@IRSMSX110.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 09:54:41 -0800
Message-ID: <CALCETrWaqsorOAC-_V4yPkjzE+Kuq6iH1ebaNbCSPyoF2dWdHA@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
Cc: "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 9:30 AM, Berthier, Emmanuel
<emmanuel.berthier@intel.com> wrote:
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Sunday, December 7, 2014 8:10 PM
>> To: Jarzmik, Robert
>> Cc: linux-kernel@vger.kernel.org; H. Peter Anvin; X86 ML; Thomas Gleixner;
>> Berthier, Emmanuel; Tejun Heo
>> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
>>
>> On Sun, Dec 7, 2014 at 10:40 AM, Robert Jarzmik <robert.jarzmik@intel.com>
>> wrote:
>> > Hi Andy,
>> >
>> > Andy Lutomirski <luto@amacapital.net> writes:
>> >> On Dec 6, 2014 2:31 AM, "Robert Jarzmik" <robert.jarzmik@intel.com>
>> wrote:
>> >>> We would have a "LBR resource" variable to track who owns the LBR :
>> >>> - nobody : LBR_UNCLAIMED
>> >>> - the exception handler : LBR_EXCEPTION_DEBUG_USAGE
>> >>
>> >> Which exception handler? There can be several on the stack.
>> > All of them, ie. LBR is used by exception handlers, ie. perf cannot
>> > use it, just as what Emmanuel's patch is doing I think. Or said
>> > differently LBR are reserved for expeption handlers only, whichever have
>> the implementation to use them.
>> >
>> >>> - case 3d: kernel exception with a reschedule inside
>> >>> -> exception entry
>> >>> -> test lbr_dump_state == EXCEPTION_OWNED => true => STOP LBR
>> >>> -> exception handling
>> >>> -> context_switch()
>> >>> -> perf cannot touch LBR, nobody can test lbr_dump_state ==
>> >>> -> EXCEPTION_OWNED => true => START LBR
>> >>
>> >> Careful. This is still the nested exception, and it just did the wrong thing.
>> > Can you be more explicit about the "wrong" thing ? And would that
>> > wrong thing be solved by a per-cpu reference counter ?
>>
>> Suppose you have an int3 with a page fault inside.  If the int3 disabled LBR,
>> then the int3 should re-enable it, and the page fault should not.  This means
>> that, if the inner page fault is, in fact, an OOPS, then you don't get the LBR
>> trace.
>
> Please keep in mind that LBR STOP/START is implemented in Exception handlers only, not in Interruption ones.
>
>> A per-cpu reference counter would solve it.  So would using rdmsr instead of
>> wrmsr, because there would be nothing to re-enable.  (The latter also means
>> that both exceptions get the LBR trace if they turn out to be OOPSes.)
>>
>> But a per-cpu reference counter still has the per-cpu issue below.
>>
>> >
>> >>> I might be very wrong in the description as I'm not that sharp on
>> >>> x86, but is there a flaw in the above cases ?
>> >>>
>> >>> If not, a couple of tests and Thomas's per-cpu variable can solve
>> >>> the issue, while keeping the exception handler code simple as
>> >>> Emmanual has proposed
>> >> (given
>> >>> the additionnal test inclusion - which will be designed to not
>> >>> pollute the
>> >> LBR),
>> >>> and having a small impact on perf to solve the resource acquire issue.
>> >>
>> >> On current kernels, percpu memory is vmalloced, so accessing it can
>> >> fault, so you can't touch percpu memory at all from page_fault until
>> >> the vmalloc fixup runs. Sorry :(
>> > What about INIT_PER_CPU_VAR (as in gdt_page) ? Won't that be mapped
>> > all the time without need for faulting in pages ?
>>
>> I'm not sure.  It may not if CPUs are hotplugged.
>
> I propose to replace PER_CPU variable by an atomic usage counter.
> The behavior will be all or nothing: as soon as perf_event uses LBR on any Core, the lbr dump feature will be disabled.
>
>> >
>> >> This is a problem with rdmsr, too.
>> > You mean rdmsr can fault in a non-hypervisor environment ? Because
>> > that definetely opens a new range of corner cases.
>> >
>> >> It may be worth fixing that. In fact, it may be worth getting rid of
>> >> lazy vmap entirely.
>> > Your battle ? ;)
>> >
>> > Anyway, would a static per-cpu variable (or variables, one about
>> > resources usage, one reference counter) solve our cases (ie. 3d) ?
>> >
>>
>> Possibly, but only if static per-cpu reference counters are safe to touch in the
>> exception entry code.
>>
>> Tejun?
>>
>> --Andy
>
> For the nested exception/rescheduling topic, the only solution I see would be to store LBRs into the stack.
> But as the purpose of this feature is to catch stack corruption issue, this is not an option.

I don't understand the problem here.

If the stack is corrupt, causing you to follow a bad pointer and get a
page fault, the new frame written by the page fault will be fine.

If the stack *pointer* is bad, then you won't enter page_fault at all
-- you'll enter double_fault instead.  double_fault will be called
with a valid stack pointer from the IST table.

If you were to put LBRs on the stack, you'd probably want to put them
below pt_regs, which might require a bit of gymnastics, but it would
certainly be doable.  You wouldn't be able to do that by tweaking the
IDT entry, though.

You could also put them above pt_regs, which could be done by tweaking
the IDT entry (no exit changed would be needed whatsoever), but you'd
have to move the hardware frame down by the size of the LBR record in
your stub.

--Andy

> So, we have to accept that the nested case is not supported, and in case of crash inside the nested treatment, LBR dump will be irrelevant.
> I will try to add a test to report this case in the dumpstack.
>
> Thanks,
>
> Emmanuel.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
