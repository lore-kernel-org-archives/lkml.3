Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaCYVRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:17:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:55461 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaCYVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:17:10 -0400
Date: Tue, 25 Mar 2014 22:17:08 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: delicious quinoa <delicious.quinoa@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
Message-ID: <20140325211708.GA31203@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
 <1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
 <CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
 <532D83F1.5070001@linutronix.de>
 <CACRpkdYxeieES5Y5tbCRfSe=Cnj2QsoU5KvSPZ99XsJ9AUrEmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACRpkdYxeieES5Y5tbCRfSe=Cnj2QsoU5KvSPZ99XsJ9AUrEmw@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij | 2014-03-25 21:43:49 [+0100]:

>> I looked at
>> those two links and you quote gpio_to_irq() which is not required.
>
>In a *lot* of drivers it is implicitly required that gpio_to_irq()
>is called first because they only call irq_create_mapping()
>there. (And not in subsequent interrupt handlers etc.)

so

--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -68,7 +68,7 @@ static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 						    dwapb_gpio_port, bgc);
 	struct dwapb_gpio *gpio = port->gpio;
 
-	return irq_find_mapping(gpio->domain, offset);
+	return irq_create_mapping(gpio->domain, offset);
 }
 
 static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)

would fix the problem then. That means you get the gpio number passed as
a value and you plan to use it as an irq via gpio_to_irq() and the
latter will create the interrupt mapping then.

>No matter what, I would worry less about that and spend
>some time on using my new gpiolib helpers for
>gpiochip_irqchip_add() and
>gpiochip_set_chained_irqchip().
>
>Yours,
>Linus Walleij

Sebastian
