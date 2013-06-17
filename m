Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3FQLrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:47:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51164 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3FQLrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:47:15 -0400
Message-ID: <51BEF6FD.3070108@ti.com>
Date: Mon, 17 Jun 2013 17:16:05 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Enable pcf857x GPIO expander for Device Tree
References: <1370527523-1030-1-git-send-email-archit@ti.com> <CACRpkdY-HZ4AGqKr-DA1pvfnaVYEGZoEDn_wfDr8=9Qr+6dpiw@mail.gmail.com>
In-Reply-To: <CACRpkdY-HZ4AGqKr-DA1pvfnaVYEGZoEDn_wfDr8=9Qr+6dpiw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 17 June 2013 02:35 PM, Linus Walleij wrote:
> On Thu, Jun 6, 2013 at 4:05 PM, Archit Taneja <archit@ti.com> wrote:
>
>> Add code to parse the GPIO expander Device Tree node and extract platform data
>> out of it, and populate the struct 'pcf857x_platform_data' maintained by the
>> driver. This enables devices to reference the gpio expander from Device Tree.
>>
>> Add DT binding info in Documentation.
>>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Archit Taneja <archit@ti.com>
>
> (...)
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
>> @@ -0,0 +1,44 @@
>> +PCF857x I2C based GPIO controller bindings
>> +
>> +Required properties:
>> +- compatible:
>> +  - "nxp,pca9670" for NXP PCA9670 8 bit I/O expander
>> +  - "nxp,pca9672" for NXP PCA9672 8 bit I/O expander with interrupt
>> +  - "nxp,pca9674" for NXP PCA9672 8 bit I/O expander with interrupt
>> +  - "nxp,pca8574" for NXP PCA8574 8 bit I/O expander with interrupt
>> +  - "nxp,pca8575" for NXP PCA8575 16 bit I/O expander with interrupt
>> +  - "nxp,pca9671" for NXP PCA9671 16 bit I/O expander
>> +  - "nxp,pca9673" for NXP PCA9673 16 bit I/O expander with interrupt
>> +  - "nxp,pca9675" for NXP PCA9675 16 bit I/O expander with interrupt
>> +  - "ti,pcf8574"  for TI PCF8574 8 bit I/O expander with interrupt
>> +  - "ti,pcf8574a" for TI PCF8574A 8 bit I/O expander with interrupt
>> +  - "ti,pcf8575"  for TI PCF8575 16 bit I/O expander with interrupt
>> +  - "ti,tca9554"  for TI TCA9554 8 bit I/O expander with interrupt
>> +  - "maxim,max7328" for MAXIM MAX7328 8 bit I/O expander with interrupt
>> +  - "maxim,max7329" for MAXIM MAX7329 8 bit I/O expander with interrupt
>> +- gpio-controller : Marks the device node as a GPIO controller.
>> +- #gpio-cells : Should be two.
>> +  - first cell is the pin number.
>> +  - second cell is unused.
>
> I guess you're adding this because the generic GPIO bindings use it and
> of_gpio_simple_xlate() depends on this two-cell layout.

Thanks for the review. I'm new to this and clearly lacking some 
knowledge here.

>
> Make a reference to the generic GPIO bindings and note that the
> second cell is *NOT* unused, as it is used in the GPIOlib!

Right, my mistake. Just a query, there is an example in gpio.txt in the 
gpio bindings documentation which sets #gpio-cells as 1. Is this is a 
wrong example, or are 1 cell gpio controllers valid?

>
>> +- interrupt-controller: Mark the device node as an interrupt controller.
>> +- #interrupt-cells : Should be two.
>> +  - first cell is the GPIO number.
>
> Surely it is the IRQ number and not the GPIO number.
> The fact that the IRQ originates in a GPIO controller does not
> matter.

Okay, I took gpio-omap.txt as reference(in other words, copy-pasted from 
there), I guess 'first cell is the GPIO number' means that a slave 
having it's interrupt line connected to an omap gpio bank has to mention 
the gpio number in the first cell.

About this chip, a change in any of it's GPIOs configured as inputs will 
generate an interrupt, then it's up to the driver to figure out which 
GPIOs changed and handle their corresponding irqs. So shouldn't a device 
connected to the chip describe the gpio number within the pcf857x chip 
as it's first cell?

I've made a hypothetical example of a pcf8575 chip, which has it's 
interrupt line connected to an omap gpio, and pcf8575's 7th gpio is 
connected to 'pcf_slave'. The pcf_slave's driver requests for an 
interrupt. Is this the correct way to describe this? :

pcf: pcf8575@23 {
	compatible = "ti,pcf8575";
	reg = <0x23>;
	gpio-controller;
	#gpio-cells = <2>;
	#interrupt-controller;
	#interrupt-cells = <1>;
	interrupt-parent = <&gpio2>;	/* an omap gpio bank */
	interrupts = <2 8>;		/* gpio line 34, low triggered*/
};

pcf_slave: slave {
	...
	...
	#interrupt-parent = <&pcf>;
	interrupts = <7>;	/* connected to 7th IO pin of pcf857x*/	
};

>
>> +  - second cell is unused.
>
> So why do you add it? Usually this is used for trigger flags.
> Are you planning to add this later, i.e. does the chip support this,
> and if it doesn't then get rid of this flag.

I haven't used the chip for interrupts, but going through the driver and 
it's platform_data struct for board files, I don't see any trigger 
information needed. I'll remove it.

>
>> +- reg: I2C address of the chip.
>> +
>> +Device speific properties:
>> +- n_latch:             optional bit-inverse of initial register value; if
>> +                       you leave this initialized to zero the driver will act
>> +                       like the chip was just reset.
>
> Explain what happens if you do *not* leave it as zero and what the
> bits mean in that case.

I'll do that. Apologies for the trivial issues.

Thanks,
Archit

