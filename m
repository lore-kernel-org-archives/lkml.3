Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3DCKSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:18:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:63541 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab3DCKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:18:50 -0400
Message-ID: <515C0208.2000605@atmel.com>
Date: Wed, 3 Apr 2013 12:18:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "drivers/rtc/rtc-at91rm9200.c: use a variable
 for storing IMR"
References: <20130403095150.GC27600@localhost> <1364982862-19759-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1364982862-19759-1-git-send-email-jhovold@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 11:54 AM, Johan Hovold :
> This reverts commit 0ef1594c017521ea89278e80fe3f80dafb17abde.
> 
> This patch introduced a few races which cannot be easily fixed with a
> small follow-up patch. Furthermore, the SoC with the broken hardware
> register, which this patch intended to add support for, can only be used
> with device trees, which this driver currently does not support.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Fair enough, after fighting to find a solution that can makes us move
forward... your strong arguments convinced me.

So, Andrew, please can you take this "revert" patch for 3.9-rc ?
And sorry for the noise.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

(Andrew, I figured out that you are not in copy of the original email:
do I need to send it back to you or can you pick it up in patchwork?
https://patchwork.kernel.org/patch/2385921/
)

> ---
>  drivers/rtc/rtc-at91rm9200.c | 50 +++++++++++++++++---------------------------
>  drivers/rtc/rtc-at91rm9200.h |  1 +
>  2 files changed, 20 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 0a9f27e..434ebc3 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -44,7 +44,6 @@ static DECLARE_COMPLETION(at91_rtc_updated);
>  static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
>  static void __iomem *at91_rtc_regs;
>  static int irq;
> -static u32 at91_rtc_imr;
>  
>  /*
>   * Decode time/date into rtc_time structure
> @@ -109,11 +108,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
>  	cr = at91_rtc_read(AT91_RTC_CR);
>  	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
>  
> -	at91_rtc_imr |= AT91_RTC_ACKUPD;
>  	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
>  	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
>  	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
> -	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
>  
>  	at91_rtc_write(AT91_RTC_TIMR,
>  			  bin2bcd(tm->tm_sec) << 0
> @@ -145,7 +142,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
>  	tm->tm_year = at91_alarm_year - 1900;
>  
> -	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
> +	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
>  			? 1 : 0;
>  
>  	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
> @@ -171,7 +168,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	tm.tm_sec = alrm->time.tm_sec;
>  
>  	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
> -	at91_rtc_imr &= ~AT91_RTC_ALARM;
>  	at91_rtc_write(AT91_RTC_TIMALR,
>  		  bin2bcd(tm.tm_sec) << 0
>  		| bin2bcd(tm.tm_min) << 8
> @@ -184,7 +180,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  
>  	if (alrm->enabled) {
>  		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> -		at91_rtc_imr |= AT91_RTC_ALARM;
>  		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
>  	}
>  
> @@ -201,12 +196,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
>  
>  	if (enabled) {
>  		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
> -		at91_rtc_imr |= AT91_RTC_ALARM;
>  		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
> -	} else {
> +	} else
>  		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
> -		at91_rtc_imr &= ~AT91_RTC_ALARM;
> -	}
>  
>  	return 0;
>  }
> @@ -215,10 +207,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
>   */
>  static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
>  {
> +	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
> +
>  	seq_printf(seq, "update_IRQ\t: %s\n",
> -			(at91_rtc_imr & AT91_RTC_ACKUPD) ? "yes" : "no");
> +			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
>  	seq_printf(seq, "periodic_IRQ\t: %s\n",
> -			(at91_rtc_imr & AT91_RTC_SECEV) ? "yes" : "no");
> +			(imr & AT91_RTC_SECEV) ? "yes" : "no");
>  
>  	return 0;
>  }
> @@ -233,7 +227,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
>  	unsigned int rtsr;
>  	unsigned long events = 0;
>  
> -	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
> +	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
>  	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
>  		if (rtsr & AT91_RTC_ALARM)
>  			events |= (RTC_AF | RTC_IRQF);
> @@ -297,7 +291,6 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
>  	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
>  					AT91_RTC_SECEV | AT91_RTC_TIMEV |
>  					AT91_RTC_CALEV);
> -	at91_rtc_imr = 0;
>  
>  	ret = request_irq(irq, at91_rtc_interrupt,
>  				IRQF_SHARED,
> @@ -336,7 +329,6 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
>  	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
>  					AT91_RTC_SECEV | AT91_RTC_TIMEV |
>  					AT91_RTC_CALEV);
> -	at91_rtc_imr = 0;
>  	free_irq(irq, pdev);
>  
>  	rtc_device_unregister(rtc);
> @@ -349,35 +341,31 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
>  
>  /* AT91RM9200 RTC Power management control */
>  
> -static u32 at91_rtc_bkpimr;
> -
> +static u32 at91_rtc_imr;
>  
>  static int at91_rtc_suspend(struct device *dev)
>  {
>  	/* this IRQ is shared with DBGU and other hardware which isn't
>  	 * necessarily doing PM like we are...
>  	 */
> -	at91_rtc_bkpimr = at91_rtc_imr & (AT91_RTC_ALARM|AT91_RTC_SECEV);
> -	if (at91_rtc_bkpimr) {
> -		if (device_may_wakeup(dev)) {
> +	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
> +			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
> +	if (at91_rtc_imr) {
> +		if (device_may_wakeup(dev))
>  			enable_irq_wake(irq);
> -		} else {
> -			at91_rtc_write(AT91_RTC_IDR, at91_rtc_bkpimr);
> -			at91_rtc_imr &= ~at91_rtc_bkpimr;
> -		}
> -}
> +		else
> +			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
> +	}
>  	return 0;
>  }
>  
>  static int at91_rtc_resume(struct device *dev)
>  {
> -	if (at91_rtc_bkpimr) {
> -		if (device_may_wakeup(dev)) {
> +	if (at91_rtc_imr) {
> +		if (device_may_wakeup(dev))
>  			disable_irq_wake(irq);
> -		} else {
> -			at91_rtc_imr |= at91_rtc_bkpimr;
> -			at91_rtc_write(AT91_RTC_IER, at91_rtc_bkpimr);
> -		}
> +		else
> +			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
>  	}
>  	return 0;
>  }
> diff --git a/drivers/rtc/rtc-at91rm9200.h b/drivers/rtc/rtc-at91rm9200.h
> index 5f940b6..da1945e 100644
> --- a/drivers/rtc/rtc-at91rm9200.h
> +++ b/drivers/rtc/rtc-at91rm9200.h
> @@ -64,6 +64,7 @@
>  #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
>  #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
>  #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
> +#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
>  
>  #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
>  #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
> 


-- 
Nicolas Ferre
