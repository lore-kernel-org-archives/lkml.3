Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3IBJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:27:39 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:41797 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab3IBJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:27:37 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.722
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 02 Sep 2013 11:25:25 +0200
Message-ID: <1521079.WSLhhfqBXl@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5220F8AE.2080300@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <521FE637.3010805@collabora.co.uk> <5220F8AE.2080300@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 30. August 2013, 13:55:26 schrieb Stephen Warren:
> On 08/29/2013 06:24 PM, Javier Martinez Canillas wrote:
> ...
> 
> > We have been trying to solve this issue for a few months by now and Linus'
> > approach seems to be the most sensible solution to me.
> > 
> > Drivers that request an IRQ and assume that platform code will request and
> > setup the GPIO have been broken since the boards using these drivers were
> > migrated to DT (e.g: smsc911x on OMAP2+ boards).
> 
> That's only true if the driver for the GPIO controller is buggy.
> Whatever request_irq() maps down to in the GPIO/IRQ controller driver
> simply needs to set up the pin as an interrupt input, then it doesn't
> matter which order the driver does things.

Is it really that easy?
request_irq() should request the gpio and set it to input that it needs to 
fulfill the irq request. That would then be the way to go for new drivers and 
in the DT case.
Some leagcy drivers currently do this:

request_gpio(gpio);
gpio_direction_input(gpio);
request_irq(gpio_to_irq(gpio));

In that case request_irq should not fail because the driver is already the 
correct owner of this gpio. But if some other entity owns this gpio it should 
fail.

Also if I understand you correct the other way round should also possible:

request_irq(gpio_to_irq(gpio));
request_gpio(gpio);
gpio_direction_input(gpio);

request_irq() also requests the gpio then but the following request_gpio() 
should also not fail.

To have it work that way we have to track the owners of all requested gpios 
somewhere. Or am I wrong here?
Where and how to record these owners? Can gpio system achieve this? gpios are 
requested without an owning device.
