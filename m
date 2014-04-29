Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbaD2Tme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:42:34 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:59837 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbaD2Tmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:42:32 -0400
From: Alexey Charkov <alchark@gmail.com>
To: linus.walleij@linaro.org, linux@prisktech.co.nz,
        linux-kernel@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH] pinctrl: vt8500: Ensure value reg is updated when setting direction
Date: Tue, 29 Apr 2014 23:42:00 +0400
Message-Id: <1398800520-18135-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code only touches the direction register when setting direction
to output, which breaks logic like

echo high > /sys/class/gpio/gpio0/direction

which is expected to also set the value. This patch also adds a call
to update the value register when setting direction to output.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/pinctrl/vt8500/pinctrl-wmt.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 9802b67..2c61281 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -523,17 +523,6 @@ static int wmt_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
 		return GPIOF_DIR_IN;
 }
 
-static int wmt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	return pinctrl_gpio_direction_input(chip->base + offset);
-}
-
-static int wmt_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
-				     int value)
-{
-	return pinctrl_gpio_direction_output(chip->base + offset);
-}
-
 static int wmt_gpio_get_value(struct gpio_chip *chip, unsigned offset)
 {
 	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
@@ -568,6 +557,18 @@ static void wmt_gpio_set_value(struct gpio_chip *chip, unsigned offset,
 		wmt_clearbits(data, reg_data_out, BIT(bit));
 }
 
+static int wmt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(chip->base + offset);
+}
+
+static int wmt_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				     int value)
+{
+	wmt_gpio_set_value(chip, offset, value);
+	return pinctrl_gpio_direction_output(chip->base + offset);
+}
+
 static struct gpio_chip wmt_gpio_chip = {
 	.label = "gpio-wmt",
 	.owner = THIS_MODULE,
-- 
1.9.1

