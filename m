Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3C2P66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:58:58 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33966 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3C2P65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:58:57 -0400
Date: Fri, 29 Mar 2013 16:57:59 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Johan Hovold <jhovold@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-ID: <20130329155759.GA1166@localhost>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
 <20130326192713.GA31628@localhost>
 <51520EA7.8090808@interlog.com>
 <20130328095718.GA30276@localhost>
 <51546CC0.1040207@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51546CC0.1040207@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 05:16:00PM +0100, Nicolas Ferre wrote:
> On 03/28/2013 10:57 AM, Johan Hovold :
> > On Tue, Mar 26, 2013 at 05:09:59PM -0400, Douglas Gilbert wrote:
> >> On 13-03-26 03:27 PM, Johan Hovold wrote:
> >>> On Fri, Mar 15, 2013 at 06:37:12PM +0100, Nicolas Ferre wrote:

[...]

> >> @@ -198,9 +203,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
> >>
> >>       if (enabled) {
> >>               at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> >> +             at91_rtc_imr |= AT91_RTC_ALARM;
> > 
> > Here a barrier is needed to prevent the compiler from reordering the two
> > writes (i.e., mask update and interrupt enable).
> > 
> >>               at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
> >> -     } else
> >> +     } else {
> >>               at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
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
> 
> In fact, if we protect the two code lines with the proper spinlock, we
> may find that all this reordering issue will not lead to a race
> condition. So I guess it is a simpler solution to the problem that you
> highlight.

A spinlock would also be a solution to the reordering problem, albeit a
slightly heavier one than the wmb(). A comment from from Doug made me
realise that one more barrier would actually be needed, so I think using
a spinlock is indeed preferred.

It would however not be sufficient to address the second problem, which
is that the interrupt disable is not immediate. An RTC-register read
back is needed to make sure the IDR-write has reached the peripheral,
but as I mentioned above it is merely a reasonable heuristic as the only
way to be certain that the interrupts have been disabled in hardware
would be to poll the RTC_IMR-register, which is register we are trying
to emulate.

In practice, the read-back heuristic would most likely be perfectly
sufficient, but I'd prefer this to only be used for SoCs where the
RTC_IMR-register is actually broken.

> >> +             at91_rtc_imr &= ~AT91_RTC_ALARM;
> >> +     }
> >>
> >>       return 0;
> >> }
> > 
> > In the worst-case scenario ignoring the shared RTC-interrupt could lead
> > to the disabling of the system interrupt and thus also PIT, DBGU, ...
> > 
> > I think this patch should be reverted and a fix for the broken SoCs be
> > implemented which does not penalise the other SoCs. That is, only
> > fall-back to faking IMR on the SoCs where it is actually broken.
> > 
> > Nicolas, should I send a revert patch and follow up with a fix for the
> > broken SoCs which includes the required barriers and read-backs?
> 
> I prefer to not distinguish between broken SoC and others. But I may be
> too optimistic...

If you agree with me that the second problem (interrupt-disable latency)
cannot be solved without resorting to heuristics (e.g., adding
read-backs or delays) then I think that should be the deciding point.

I'm responding to this message with an RFC of how the work-around could
be implemented (adding DT-support to the driver in the process). It
applies after having reverted the current workaround.

Note that only using the shadow interrupt mask when it is actually
needed does not add much extra code at all.

Thanks,
Johan
