Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaDGS0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:26:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:53141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaDGS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:26:34 -0400
Message-ID: <5342EDD6.3050706@linutronix.de>
Date: Mon, 07 Apr 2014 20:26:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Gerhard Sittig <gsi@denx.de>
CC: jamie@jamieiles.com, atull@altera.com, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@altera.com, linus.walleij@linaro.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH 5/5] gpio: dwapb: use d->mask instead od BIT(bit)
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de> <1396865589-9972-6-git-send-email-bigeasy@linutronix.de> <20140407122620.GX11339@book.gsilab.sittig.org>
In-Reply-To: <20140407122620.GX11339@book.gsilab.sittig.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 02:26 PM, Gerhard Sittig wrote:
> On Mon, 2014-04-07 at 12:13 +0200, Sebastian Andrzej Siewior wrote:
>>
>> d->mask contains exact the same information as BIT(bit) so we could save
>> a few cycles here.
> 
> ISTR that the benefit of saving cycles was questioned in previous
> review comments.  On ARM, the shift "comes for free".

I can't recall that some pointed this out. However:
- you load one variable in both cases. Not performing the shift means
  there is at least one instruction less to be performed.
- that gpio controller is generic IP core from Synopsys. Every can buy
  it and but into their IP core so it is not limited to ARM.

>> --- a/drivers/gpio/gpio-dwapb.c
>> +++ b/drivers/gpio/gpio-dwapb.c
>> @@ -113,7 +113,7 @@ static void dwapb_irq_enable(struct irq_data *d)
>>  
>>  	irq_gc_lock(igc);
>>  	val = readl(gpio->regs + GPIO_INTEN);
>> -	val |= BIT(d->hwirq);
>> +	val |= d->mask;
> 
> these are equally costly or cheap, nothing saved here

I still thing not performing an instruction is more efficient than
performing one.

>>  	struct dwapb_gpio *gpio = igc->private;
>> -	int bit = d->hwirq;
>> +	u32 mask = d->mask;
>>  	unsigned long level, polarity;
>>  
>>  	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
>> @@ -171,24 +171,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>>  
>>  	switch (type) {
>>  	case IRQ_TYPE_EDGE_BOTH:
>> -		level |= BIT(bit);
>> -		dwapb_toggle_trigger(gpio, bit);
>> +		level |= mask;
>> +		dwapb_toggle_trigger(gpio, d->hwirq);
> 
> these introduce another pointer dereference, unless 'bit' was
> assigned from a pointer dereference (as is shown above), so
> nothing was gained

dwapb_toggle_trigger() is a bit special and it needs both. However,
size on ARM says

   text    data     bss     dec     hex filename
   3264      96       0    3360     d20 drivers/gpio/gpio-dwapb.o.before
   3224      96       0    3320     cf8 drivers/gpio/gpio-dwapb.o.after

that with the patch the code is smaller by 40 bytes. Does 40 bytes
smaller code quality for "safe a few cycles" statement?

> virtually yours
> Gerhard Sittig

Sebastian
