Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaK0XMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:12:36 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:49912 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaK0XMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:12:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Fri, 28 Nov 2014 00:12:25 +0100
Message-ID: <3935244.Dm2HkZj2Bg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127171243.GL4508@piout.net>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <3550407.q87bWB4Jdt@wuerfel> <20141127171243.GL4508@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BxbU4ZRvKd1aV5hbzZDdwG8ai9K3+A0cZ7M1Wvt1KNh
 L47ewH+apncbtoRRASZgU0HP/7D/BmsnOdwYpihgzAAn0FZTlu
 gVqLkJmwU+x/iEyZZ4LjTHws9oJk66YUXuy55zWP57+ijBIXt4
 LLd3Vo3j6MzquyfucQZqXBIMkOZGGh9moRxkpjCfipskhPfX4q
 4195TPGQM47QH3fQDWc0v9F9wt6Ev4jhx/7b7N+dHoy2/12ile
 soZN19JXsqNR4D1jN2nYgA6jsz60I35za1Dct8OmgPiHa1OOig
 hnzzR0M5yIpysQeWZ7TQC3cDv1R9KWjRMsxP9AdSNa5u48Gkfo
 f0IgMVETEc+kfQhpJUZU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
> 
> As discussed some weeks ago, I prepared patches to switch sama5d[3-4] to
> multiplatform. We are still missing the SMC and matrix drivers to switch
> sam9 and rm9200.

I just looked at the drivers because I got curious, and to see if
there are still any low-hanging fruit, but I guess you already picked
them all ;-)

> The currently affected drivers are:
>  - drivers/ata/pata_at91.c (SMC)
>  - drivers/pcmcia/at91_cf.c (SMC)

I guess the SMC should live in drivers/memory with an interface
similar to mvebu-devbus.c?

Seems doable but nontrivial.

>  - drivers/usb/gadget/udc/at91_udc.c (Matrix, this is the only one
>    for sam9)

Is at91_matrix a pin controller? With the board files removed, the udc
driver has the only two remaining calls to at91_matrix_{read,write}
for setting the pullup, so that could be modeled as a trivial pinctrl
driver

>  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)

This one seems fairly straightforward to do, including a DT binding,
but the result is still ugly as it supports the at32 chips that
do things very differently.

The patch below gets it to compile and should be enough as a replacement
once a compatible string gets added.

>  - drivers/watchdog/at91rm9200_wdt.c (WIP, will be converted properly to
>    an MFD)

I think we discussed this one before. Remind me why we can't just convert
it to use watchdog_register() for simplification and then move whatever
remains into the arch/arm/mach-at91/at91rm9200_time.c file, or both
into drivers/clocksource.

	Arnd

8<----
ASoC: atmel/ac97c: remove platform_data dependency

As at91 gets changed to multiplatform, we can't use the mach/cpu.h
header any more, but this is ok as it only gets used to check for
cpu_is_at32ap7000(), which arch/avr32.

In order to make the driver work without platform_data, this also
changes the reset gpio line handling so it can look up the gpio
descriptor from DT. It is still missing a compatible string and
a binding that describes the valid DT properties.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index b59427d5a697..4eec216b7f92 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -34,10 +34,10 @@
 #include <linux/platform_data/dma-dw.h>
 #include <linux/dma/dw.h>
 
+#ifdef CONFIG_AVR32
 #include <mach/cpu.h>
-
-#ifdef CONFIG_ARCH_AT91
-#include <mach/hardware.h>
+#else
+#define cpu_is_at32ap7000() (0)
 #endif
 
 #include "ac97c.h"
@@ -78,7 +78,7 @@ struct atmel_ac97c {
 	void __iomem			*regs;
 	int				irq;
 	int				opened;
-	int				reset_pin;
+	struct gpio_desc		*reset_pin;
 };
 
 #define get_chip(card) ((struct atmel_ac97c *)(card)->private_data)
@@ -890,11 +890,11 @@ static void atmel_ac97c_reset(struct atmel_ac97c *chip)
 	ac97c_writel(chip, CAMR, 0);
 	ac97c_writel(chip, COMR, 0);
 
-	if (gpio_is_valid(chip->reset_pin)) {
-		gpio_set_value(chip->reset_pin, 0);
+	if (chip->reset_pin) {
+		gpiod_set_value(chip->reset_pin, 0);
 		/* AC97 v2.2 specifications says minimum 1 us. */
 		udelay(2);
-		gpio_set_value(chip->reset_pin, 1);
+		gpiod_set_value(chip->reset_pin, 1);
 	} else {
 		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
 		udelay(2);
@@ -923,7 +923,7 @@ static int atmel_ac97c_probe(struct platform_device *pdev)
 	}
 
 	pdata = pdev->dev.platform_data;
-	if (!pdata) {
+	if (cpu_is_at32ap7000() && !pdata) {
 		dev_dbg(&pdev->dev, "no platform data\n");
 		return -ENXIO;
 	}
@@ -980,16 +980,18 @@ static int atmel_ac97c_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	if (gpio_is_valid(pdata->reset_pin)) {
-		if (gpio_request(pdata->reset_pin, "reset_pin")) {
+	if (pdata && gpio_is_valid(pdata->reset_pin)) {
+		if (devm_gpio_request(&pdev->dev, pdata->reset_pin, "reset")) {
 			dev_dbg(&pdev->dev, "reset pin not available\n");
-			chip->reset_pin = -ENODEV;
+			chip->reset_pin = NULL;
 		} else {
 			gpio_direction_output(pdata->reset_pin, 1);
-			chip->reset_pin = pdata->reset_pin;
+			chip->reset_pin = gpio_to_desc(pdata->reset_pin);
 		}
 	} else {
-		chip->reset_pin = -EINVAL;
+		chip->reset_pin = devm_gpiod_get(&pdev->dev, "reset", 0);
+		if (IS_ERR(chip->reset_pin))
+			chip->reset_pin = NULL;
 	}
 
 	atmel_ac97c_reset(chip);
@@ -1113,9 +1115,6 @@ err_dma:
 		chip->dma.tx_chan = NULL;
 	}
 err_ac97_bus:
-	if (gpio_is_valid(chip->reset_pin))
-		gpio_free(chip->reset_pin);
-
 	iounmap(chip->regs);
 err_ioremap:
 	free_irq(irq, chip);
@@ -1170,9 +1169,6 @@ static int atmel_ac97c_remove(struct platform_device *pdev)
 	struct snd_card *card = platform_get_drvdata(pdev);
 	struct atmel_ac97c *chip = get_chip(card);
 
-	if (gpio_is_valid(chip->reset_pin))
-		gpio_free(chip->reset_pin);
-
 	ac97c_writel(chip, CAMR, 0);
 	ac97c_writel(chip, COMR, 0);
 	ac97c_writel(chip, MR,   0);

