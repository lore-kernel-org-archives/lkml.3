Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3C2QCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:02:41 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46676 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3C2QCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:02:40 -0400
Date: Fri, 29 Mar 2013 17:01:42 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Johan Hovold <jhovold@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-ID: <20130329160142.GB1166@localhost>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
 <20130326192713.GA31628@localhost>
 <51520EA7.8090808@interlog.com>
 <20130328095718.GA30276@localhost>
 <515489E1.6050603@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515489E1.6050603@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 02:20:17PM -0400, Douglas Gilbert wrote:
> On 13-03-28 05:57 AM, Johan Hovold wrote:
> > On Tue, Mar 26, 2013 at 05:09:59PM -0400, Douglas Gilbert wrote:
> >> On 13-03-26 03:27 PM, Johan Hovold wrote:
> >>> On Fri, Mar 15, 2013 at 06:37:12PM +0100, Nicolas Ferre wrote:
> >>>> On some revisions of AT91 SoCs, the RTC IMR register is not working.
> >>>> Instead of elaborating a workaround for that specific SoC or IP version,
> >>>> we simply use a software variable to store the Interrupt Mask Register and
> >>>> modify it for each enabling/disabling of an interrupt. The overhead of this
> >>>> is negligible anyway.
> >>>
> >>> The patch does not add any memory barriers or register read-backs when
> >>> manipulating the interrupt-mask variable. This could possibly lead to
> >>> spurious interrupts both when enabling and disabling the various
> >>> RTC-interrupts due to write reordering and bus latencies.
> >>>
> >>> Has this been considered? And is this reason enough for a more targeted
> >>> work-around so that the SOCs with functional RTC_IMR are not affected?
> >>
> >> The SoCs in question use a single embedded ARM926EJ-S and
> >> according to the Atmel documentation, that CPU's instruction
> >> set contains no barrier (or related) instructions.
> >
> > The ARM926EJ-S actually does have a Drain Write Buffer instruction but
> > it's not used by the ARM barrier-implementation unless
> > CONFIG_ARM_DMA_MEM_BUFFERABLE or CONFIG_SMP is set.
> 
> The ARM926EJ-S is ARMv5 so CONFIG_ARM_DMA_MEM_BUFFERABLE is not
> available. SMP is not an option for arm/mach-at91.

Never said it was. I merely disputed the claim that the ARM926EJ-S has
no barrier instruction.

> > However, wmb() always implies a compiler barrier which is what is needed
> > in this case.
> 
> Even if wmb() did anything, would it make this case "safe"?

As I write above, wmb() always implies a compiler barrier, which is is
sufficient to prevent write reordering on this SoC. In particular, wmb()
is defined as a compiler barrier on AT91.

> >> In the arch/arm/mach-at91 sub-tree of the kernel source
> >> I can find no use of the wmb() call. Also checked all drivers
> >> in the kernel containing "at91" and none called wmb().
> >
> > I/O-operations are normally not reordered, but this patch is faking a
> > hardware register and thus extra care needs to be taken.
> >
> > To repeat:
> >
> >> @@ -198,9 +203,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
> >>
> >>        if (enabled) {
> >>                at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> >> +             at91_rtc_imr |= AT91_RTC_ALARM;
> >
> > Here a barrier is needed to prevent the compiler from reordering the two
> > writes (i.e., mask update and interrupt enable).
> 
> Isn't either order potentially unsafe? So even if the compiler
> did foolishly re-order them, the sequence is still unsafe when
> a SYS interrupt splits those two lines (since the SYS interrupt
> is shared, it can occur at any time).

Good point. This would not cause any problem as the interrupt mask is
ANDed with the (hardware) status register in the interrupt handler, but
only if the status register is _guaranteed_ to be cleared before
updating the mask and that would require another wmb() after writing
SCCR above.

To avoid having to worry about such subtleties, a spinlock (and the
barriers it implies) seems like the most reasonable way to prevent the
race in this case. Note however that this only fixes the reordering part
of the problem. The register read back would still be needed below.

> >>                at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
> >> -     } else
> >> +     } else {
> >>                at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
> >
> > Here a barrier is again needed to prevent the compiler from reordering,
> > but we also need a register read back (of some RTC-register) before
> > updating the mask. Without the register read back, there could be a
> > window where the mask does not match the hardware state due to bus
> > latencies.
> >
> > Note that even with a register read back there is a (theoretical)
> > possibility that the interrupts have not yet been disabled when the fake
> > mask is updated. The only way to know for sure is to poll RTC_IMR but
> > that is the very register you're trying to emulate.
> >
> >> +             at91_rtc_imr &= ~AT91_RTC_ALARM;
> >> +     }
> >>
> >>        return 0;
> >> }
> >
> > In the worst-case scenario ignoring the shared RTC-interrupt could lead
> > to the disabling of the system interrupt and thus also PIT, DBGU, ...
> 
> And how often does the AT91_RTC_ALARM alarm interrupt fire?

That's not relevant is it? We should not knowingly add code that could
potentially blow up, no matter how improbable it is, and at least not
when there are options.

> > I think this patch should be reverted and a fix for the broken SoCs be
> > implemented which does not penalise the other SoCs. That is, only
> > fall-back to faking IMR on the SoCs where it is actually broken.
> 
> Even though I sent a patch to fix this problem to Nicolas,
> what was presented is not my version. In mine I added DT
> support:
> 
> #ifdef CONFIG_OF
> static const struct of_device_id at91rm9200_rtc_dt_ids[] = {
>         { .compatible = "atmel,at91rm9200-rtc", .data = &at91rm9200_config },
>         { .compatible = "atmel,at91sam9x5-rtc", .data = &at91sam9x5_config },
>         { /* sentinel */ }
> };
> MODULE_DEVICE_TABLE(of, at91rm9200_rtc_dt_ids);
> #else
> #define at91rm9200_rtc_dt_ids NULL
> #endif /* CONFIG_OF */
> 
> The shadow IMR variable was only active in the
>       .compatible = "atmel,at91sam9x5-rtc"
> case. That protected all existing users from any problems
> that might be introduced.

That's all I'm asking for.

Do you have a link to your patch and the thread it was posted in?

Is there a hardware erratum for the bug?

Thanks,
Johan
