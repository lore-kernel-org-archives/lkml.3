Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423600Ab3FUSWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:22:12 -0400
Received: from mail1b.islandnet.com ([199.175.107.121]:36509 "EHLO
	mail1.islandnet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423383Ab3FUSWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:22:11 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jun 2013 14:22:11 EDT
Message-ID: <51C497EF.1070108@acumalabs.com>
Date: Fri, 21 Jun 2013 11:14:07 -0700
From: Simon Pearson <spearson@acumalabs.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
CC: shawn.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001/001] gpio-mxs: Select faster gpio-generic set methods
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Pearson <spearson@acumalabs.com>

Kernel 3.8.4.  By defining both the set and clear registers,
the speed of the gpio isimproved. gpio-generic.c, selects the
bgpio_set_with_clear() which isfaster than the current
bgpio_set_set().  This has performance implications for all
bitbang drivers (i2c, spi, etc).  Slow SPI as compared to
2.6.35.33 improved by a factor of 10 (80kHz CLK to 800kHz CLK).

Signed-off-by: Simon Pearson <spearson@acumalabs.com>

---
--- a/drivers/gpio/gpio-mxs.c.orig    2013-03-20 13:11:19.000000000 -0700
+++ b/drivers/gpio/gpio-mxs.c    2013-06-21 10:02:33.000000000 -0700
@@ -292,7 +292,8 @@ static int mxs_gpio_probe(struct platfor

      err = bgpio_init(&port->bgc, &pdev->dev, 4,
               port->base + PINCTRL_DIN(port),
-             port->base + PINCTRL_DOUT(port), NULL,
+             port->base + PINCTRL_DOUT(port) + MXS_SET,
+             port->base + PINCTRL_DOUT(port) + MXS_CLR,
               port->base + PINCTRL_DOE(port), NULL, 0);
      if (err)
          goto out_irqdesc_free;
