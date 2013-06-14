Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3FNOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:09:28 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59112 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3FNOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:09:26 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Simon Guinot <simon.guinot@sequanux.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH] gpio: ich: add GPO_BLINK support
Date: Fri, 14 Jun 2013 16:09:13 +0200
Message-Id: <1371218953-31777-1-git-send-email-vdonnefort@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure blink hardware is disabled for selected GPIO. Blink
hardware is controled by GPO_BLINK register and is available for GPIOs from 0
to 31.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index de3c317..181828f 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -41,12 +41,14 @@ enum GPIO_REG {
 	GPIO_USE_SEL = 0,
 	GPIO_IO_SEL,
 	GPIO_LVL,
+	GPO_BLINK
 };
 
-static const u8 ichx_regs[3][3] = {
+static const u8 ichx_regs[4][3] = {
 	{0x00, 0x30, 0x40},	/* USE_SEL[1-3] offsets */
 	{0x04, 0x34, 0x44},	/* IO_SEL[1-3] offsets */
 	{0x0c, 0x38, 0x48},	/* LVL[1-3] offsets */
+	{0x18, 0x18, 0x18},	/* BLINK offset */
 };
 
 static const u8 ichx_reglen[3] = {
@@ -154,6 +156,10 @@ static int ichx_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	if (!ichx_gpio_check_available(gpio, nr))
 		return -ENXIO;
 
+	/* Disable blink hardware which is available for GPIOs from 0 to 31. */
+	if (nr < 32)
+		ichx_write_bit(GPO_BLINK, nr, 0, 0);
+
 	/* Set GPIO output value. */
 	ichx_write_bit(GPIO_LVL, nr, val, 0);
 
-- 
1.7.9.5

