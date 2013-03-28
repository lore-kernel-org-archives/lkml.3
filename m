Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3C1J6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:58:17 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:59459 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3C1J6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:58:15 -0400
Date: Thu, 28 Mar 2013 10:57:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-ID: <20130328095718.GA30276@localhost>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
 <20130326192713.GA31628@localhost>
 <51520EA7.8090808@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51520EA7.8090808@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 05:09:59PM -0400, Douglas Gilbert wrote:
> On 13-03-26 03:27 PM, Johan Hovold wrote:
> > On Fri, Mar 15, 2013 at 06:37:12PM +0100, Nicolas Ferre wrote:
> >> On some revisions of AT91 SoCs, the RTC IMR register is not working.
> >> Instead of elaborating a workaround for that specific SoC or IP version,
> >> we simply use a software variable to store the Interrupt Mask Register and
> >> modify it for each enabling/disabling of an interrupt. The overhead of this
> >> is negligible anyway.
> >
> > The patch does not add any memory barriers or register read-backs when
> > manipulating the interrupt-mask variable. This could possibly lead to
> > spurious interrupts both when enabling and disabling the various
> > RTC-interrupts due to write reordering and bus latencies.
> >
> > Has this been considered? And is this reason enough for a more targeted
> > work-around so that the SOCs with functional RTC_IMR are not affected?
> 
> The SoCs in question use a single embedded ARM926EJ-S and
> according to the Atmel documentation, that CPU's instruction
> set contains no barrier (or related) instructions.

The ARM926EJ-S actually does have a Drain Write Buffer instruction but
it's not used by the ARM barrier-implementation unless
CONFIG_ARM_DMA_MEM_BUFFERABLE or CONFIG_SMP is set.

However, wmb() always implies a compiler barrier which is what is needed
in this case.

> In the arch/arm/mach-at91 sub-tree of the kernel source
> I can find no use of the wmb() call. Also checked all drivers
> in the kernel containing "at91" and none called wmb().

I/O-operations are normally not reordered, but this patch is faking a
hardware register and thus extra care needs to be taken.

To repeat:

> @@ -198,9 +203,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
>
>       if (enabled) {
>               at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> +             at91_rtc_imr |= AT91_RTC_ALARM;

Here a barrier is needed to prevent the compiler from reordering the two
writes (i.e., mask update and interrupt enable).

>               at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
> -     } else
> +     } else {
>               at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);

Here a barrier is again needed to prevent the compiler from reordering,
but we also need a register read back (of some RTC-register) before
updating the mask. Without the register read back, there could be a
window where the mask does not match the hardware state due to bus
latencies.

Note that even with a register read back there is a (theoretical)
possibility that the interrupts have not yet been disabled when the fake
mask is updated. The only way to know for sure is to poll RTC_IMR but
that is the very register you're trying to emulate.

> +             at91_rtc_imr &= ~AT91_RTC_ALARM;
> +     }
>
>       return 0;
> }

In the worst-case scenario ignoring the shared RTC-interrupt could lead
to the disabling of the system interrupt and thus also PIT, DBGU, ...

I think this patch should be reverted and a fix for the broken SoCs be
implemented which does not penalise the other SoCs. That is, only
fall-back to faking IMR on the SoCs where it is actually broken.

Nicolas, should I send a revert patch and follow up with a fix for the
broken SoCs which includes the required barriers and read-backs?

Note that the patch is already being picked up for some stable trees.
The fix I'm proposing would require adding minimal DT-support to the
driver and is not really stable material. Therefore, a revert followed
by a patch for 3.10 seems like the way to go.

Johan
