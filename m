Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaG2IAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:00:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44929 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbaG2IAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:00:20 -0400
Date: Tue, 29 Jul 2014 10:00:17 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: =?UTF-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        voice.shen@atmel.com, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
Message-ID: <20140729100017.31f0b1be@bbrezillon>
In-Reply-To: <20140728223859.GA3214@piout.net>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz>
	<20140728122103.GR9532@piout.net>
	<53D64ADA.1000102@aksignal.cz>
	<20140728223859.GA3214@piout.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Tue, 29 Jul 2014 00:38:59 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> 
> > >>+		if (ret < 0) {
> > >>+			dev_err(&pdev->dev,
> > >>+				"failed to configure csgpio#%u (%d)\n",
> > >>+				i, ret);
> > >>+			goto out_free;
> > >>+		}
> > >>+	}
> > >>+
> 
> Mark: maybe it would make sense to do devm_gpio_request_one() in
> of_spi_register_master(), after of_get_named_gpio.

Might be the cleanest way to solve this issue, but you'll have to modify
all the drivers that request cs_gpio in their setup method/callback.

> 
> While this solves the particular issue Jiří is seeing, this will not
> solve the case where PA14 (CS0) is not used by the spi driver at all. It
> will remained muxed as CS0 and toggle when the spi master needs to
> access CS0 until another driver muxes it to something else. I still
> believe we should explicitly ask pinctrl to mux them as gpios.
> 

Do we really care about this case ?
After all, if a given pin needs a specific muxing during kernel boot
(i.e. a pin connected to a gpio-led that needs to stay in its previous
state or a pin connected to the reset line of a device that needs to
stay up and running during kernel boot) the bootloader/bootstrap should
have muxed this pin appropriately before booting the kernel.

What do you mean by "we should explicitly ask pinctrl to mux them as
gpios" ?
Do you mean configuring all the pins as GPIOs when the pin controller is
probed, or just adding a new pinctrl state configuring the pin as an
output GPIO and reference it in the pinctrl-0 property of the spi
controller.

If the former, you'll break devices that needs their pins to stay in
the state they were during the bootloader/boostrap phase.
The latter won't work if the pin you request as GPIO is later requested
by another device (which, if I'm correct, is exactly the case you're
trying to solve).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
