Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab3CZT2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:28:12 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37426 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3CZT2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:28:10 -0400
Date: Tue, 26 Mar 2013 20:27:13 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dgilbert@interlog.com
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-ID: <20130326192713.GA31628@localhost>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 06:37:12PM +0100, Nicolas Ferre wrote:
> On some revisions of AT91 SoCs, the RTC IMR register is not working.
> Instead of elaborating a workaround for that specific SoC or IP version,
> we simply use a software variable to store the Interrupt Mask Register and
> modify it for each enabling/disabling of an interrupt. The overhead of this
> is negligible anyway.

The patch does not add any memory barriers or register read-backs when
manipulating the interrupt-mask variable. This could possibly lead to
spurious interrupts both when enabling and disabling the various
RTC-interrupts due to write reordering and bus latencies.

Has this been considered? And is this reason enough for a more targeted
work-around so that the SOCs with functional RTC_IMR are not affected?

> Reported-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/rtc/rtc-at91rm9200.c | 50 +++++++++++++++++++++++++++-----------------
>  drivers/rtc/rtc-at91rm9200.h |  1 -
>  2 files changed, 31 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 79233d0..29b92e4 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -46,6 +46,7 @@ static DECLARE_COMPLETION(at91_rtc_updated);
>  static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
>  static void __iomem *at91_rtc_regs;
>  static int irq;
> +static u32 at91_rtc_imr;
>  
>  /*
>
> * Decode time/date into rtc_time structure

[...]

> @@ -198,9 +203,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
>  
>  	if (enabled) {
>  		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> +		at91_rtc_imr |= AT91_RTC_ALARM;

wmb() needed before enabling interrupt as at91_rtc_write() uses
__raw_writel() which does not add any barriers?

>  		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
> -	} else
> +	} else {
>  		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);

wmb() and register read-back needed before updating interrupt mask?

> +		at91_rtc_imr &= ~AT91_RTC_ALARM;
> +	}
>  
>  	return 0;
> }

[...]

> @@ -229,7 +235,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
>  	unsigned int rtsr;
>  	unsigned long events = 0;
>  
> -	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
> +	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;

Does at91_rtc_imr necessarily match the hardware state here?

>  	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
>  		if (rtsr & AT91_RTC_ALARM)
>  			events |= (RTC_AF | RTC_IRQF);

Johan
