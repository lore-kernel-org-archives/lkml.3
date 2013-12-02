Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab3LBVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3LBTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-gpio@vger.kernel.org
Subject: [PATCH 3.10 031/173] gpio: twl4030: Fix regression for twl gpio output
Date: Mon,  2 Dec 2013 11:10:14 -0800
Message-Id: <20131202191146.327705812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 0b2aa8bed3e13892fcac77e4f50ec6e80125469d upstream.

Commit c111feabe2e2 (gpio: twl4030: Cache the direction and output
states in private data) improved things in general, but caused a
regression for setting the GPIO output direction.

The change reorganized twl_direction_out() and twl_set() and swapped
the function names around in the process. While doing that, a bug got
introduced that's not obvious while reading the patch as it appears
as no change to the code.

The bug is we now call function twl4030_set_gpio_dataout() twice in
both twl_direction_out() and twl_set(). Instead, we should first
call twl_direction_out() in twl_direction_out() followed by
twl4030_set_gpio_dataout() in twl_set().

This regression probably has gone unnoticed for a long time as the
bootloader may have set the GPIO direction properly in many cases.
This fixes at least the LCD panel not turning on omap3 LDP for
example.

Cc: linux-gpio@vger.kernel.org
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-twl4030.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -354,17 +354,18 @@ static void twl_set(struct gpio_chip *ch
 static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
+	int ret = -EINVAL;
 
 	mutex_lock(&priv->mutex);
 	if (offset < TWL4030_GPIO_MAX)
-		twl4030_set_gpio_dataout(offset, value);
+		ret = twl4030_set_gpio_direction(offset, 0);
 
 	priv->direction |= BIT(offset);
 	mutex_unlock(&priv->mutex);
 
 	twl_set(chip, offset, value);
 
-	return 0;
+	return ret;
 }
 
 static int twl_to_irq(struct gpio_chip *chip, unsigned offset)


