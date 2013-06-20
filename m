Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab3FTHZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:25:34 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58010 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3FTHZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:25:30 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 2/2] pinctrl: abx500: fix abx500_gpio_get()
Date: Thu, 20 Jun 2013 09:24:44 +0200
Message-Id: <1371713084-19098-3-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1371713084-19098-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1371713084-19098-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

_ allow to get output GPIO value.
_ as there is no GPIO0 on ABX500, use correct offset with 
  abx500_gpio_get_bit().

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 4307b0f..070442d 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -162,10 +162,22 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	bool bit;
+	bool is_out;
+	u8 gpio_offset = offset - 1;
 	int ret;
 
-	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
-				  offset, &bit);
+	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG, gpio_offset, &is_out);
+	if (ret < 0) {
+		dev_err(pct->dev, "%s failed\n", __func__);
+		return ret;
+	}
+
+	if (is_out)
+		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_OUT1_REG,
+				gpio_offset, &bit);
+	else
+		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
+				gpio_offset, &bit);
 	if (ret < 0) {
 		dev_err(pct->dev, "%s failed\n", __func__);
 		return ret;
-- 
1.7.10

