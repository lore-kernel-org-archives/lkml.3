Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaH3OqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 10:46:20 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:46440 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbaH3OqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 10:46:19 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH] pinctrl: st: Add remove function and remove gpio_chip on failure
Date: Sat, 30 Aug 2014 20:15:35 +0530
Message-Id: <1409409935-8775-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a remove function to platform_driver to unload
the driver in a cleaner way. This also releases gpiochip related
resources by calling gpiochip_remove when gpiochip_irqchip_add fails.

CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>
CC: Maxime Coquelin <maxime.coquelin@st.com>
CC: Patrice Chotard <patrice.chotard@st.com>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-st.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 5475374..9296845 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1517,6 +1517,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 					   0, handle_simple_irq,
 					   IRQ_TYPE_LEVEL_LOW);
 		if (err) {
+			gpiochip_remove(&bank->gpio_chip);
 			dev_info(dev, "could not add irqchip\n");
 			return err;
 		}
@@ -1685,6 +1686,29 @@ static int st_pctl_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int st_pctl_remove(struct platform_device *pdev)
+{
+	struct st_pinctrl *info = platform_get_drvdata(pdev);
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *child;
+	struct gpio_chip gpio_chip;
+	int bank = 0;
+
+	if (info->nbanks) {
+		for_each_child_of_node(np, child) {
+			if (of_property_read_bool(child, "gpio-controller")) {
+				gpio_chip = info->banks[bank].gpio_chip;
+				gpiochip_remove(&gpio_chip);
+				bank++;
+			}
+		}
+	}
+
+	pinctrl_unregister(info->pctl);
+
+	return 0;
+}
+
 static struct platform_driver st_pctl_driver = {
 	.driver = {
 		.name = "st-pinctrl",
@@ -1692,6 +1716,7 @@ static struct platform_driver st_pctl_driver = {
 		.of_match_table = st_pctl_of_match,
 	},
 	.probe = st_pctl_probe,
+	.remove = st_pctl_remove,
 };
 
 static int __init st_pctl_init(void)
-- 
1.7.0.4

