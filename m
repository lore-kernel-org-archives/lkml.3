Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3FQMD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:03:56 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41676 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3FQMDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:03:55 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Simon Guinot <simon.guinot@sequanux.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH v2] gpio: ich: add GPO_BLINK support
Date: Mon, 17 Jun 2013 14:03:49 +0200
Message-Id: <1371470629-6408-1-git-send-email-vdonnefort@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CACRpkdZ85oFiWEOQXSWXiq3z5wwZJFBbYM_rHqSmrCOPQobwbQ@mail.gmail.com>
References: <CACRpkdZ85oFiWEOQXSWXiq3z5wwZJFBbYM_rHqSmrCOPQobwbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure blink hardware is disabled for selected GPIO. Blink
hardware is controled by GPO_BLINK register and is available for GPIOs from 0
to 31.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
---
Changes for v2:
	- Rebased on for-next branch of linux-gpio git tree
	  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git

 drivers/gpio/gpio-ich.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index e16d932..2729e3d 100644
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
@@ -148,6 +150,10 @@ static int ichx_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 static int ichx_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 					int val)
 {
+	/* Disable blink hardware which is available for GPIOs from 0 to 31. */
+	if (nr < 32)
+		ichx_write_bit(GPO_BLINK, nr, 0, 0);
+
 	/* Set GPIO output value. */
 	ichx_write_bit(GPIO_LVL, nr, val, 0);
 
-- 
1.7.9.5

