Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3KGVGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:06:08 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52192 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3KGVGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:06:06 -0500
MIME-Version: 1.0
In-Reply-To: <527AD477.9080704@gmail.com>
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com>
	<1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
	<20131106233427.GA6090@maple>
	<527AD477.9080704@gmail.com>
Date: Thu, 7 Nov 2013 15:06:04 -0600
Message-ID: <CANk1AXQSoZPpMFu3qWqHW9HurGA868RLTFei8cdxuS9wCnWTbg@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 5:44 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
>>> +struct dwapb_gpio {
>>> +       struct  device          *dev;
>>> +       void __iomem            *regs;
>>> +       struct dwapb_gpio_port  *ports;
>>> +       unsigned int            nr_ports;
>>> +       struct irq_domain       *domain;
>>> +       int                     hwirq;
>>
>>
>> I'm not sure I fully understand what hwirq is in this context - is it
>> the IRQ line from the Synopsys block to the system interrupt controller?
>> If so I don't think this covers all configurations - the Picochip
>> devices for instance have each GPIO in port A as an individual IRQ going
>> to the VIC.
>
>
> Usually, hwirq is the interrupt as seen from this very device, i.e. in
> this case it is 0 up to 32 referencing the portA gpio line that
> triggered an interrupt. In this drivers context 'hwirq' above is
> actually the virtual irq number Linux made up to identify an interrupt
> coming from this IP block.
>
> Therefore, above should really be irq instead of hwirq - but with a
> more detailed review, I think it can be removed completely.
>
>> It looks here like hwirq is used for all of the interrupt registers so
>> only one GPIO interrupt is supported?
>
>
> Looking in _probe, currently only one upstream interrupt is requested.
> Jamie is right, that you should grab all interrupts - but you can forget
> their virtual number after registering the handler. There are helper
> functions to get it back in irq handler.
>

The IP configuration I have has only one irq line going to the gic,
(that is the "hwirq" here) so I had one hwirq (the gic) for each IP
instance.  The domain maps a Linux IRQ number for each gpio line.

I will need to rework this to also support both this (one irq per IP
block) and the picochip (one irq per gpio line coming out of the IP
block).

>>> +static void __exit dwapb_gpio_exit(void)
>>> +{
>>> +       platform_driver_unregister(&dwapb_gpio_driver);
>>> +}
>>> +module_exit(dwapb_gpio_exit);
>>
>>
>> We can replace the registration and unregistration with
>> module_platform_driver() now.
>
>
> +1 (again)

OK

Alan

>
> Sebastian
>
