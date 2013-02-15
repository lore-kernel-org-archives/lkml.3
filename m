Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3BOVy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:54:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40467 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3BOVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:54:55 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] gpio: tegra: assume CONFIG_OF
Date: Fri, 15 Feb 2013 14:54:48 -0700
Message-Id: <1360965288-14899-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Tegra only supports, and always enables, device tree. Remove all ifdefs
and runtime checks for DT support from the driver.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 414ad91..a78a81f 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -398,10 +398,11 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 	int j;
 
 	match = of_match_device(tegra_gpio_of_match, &pdev->dev);
-	if (match)
-		config = (struct tegra_gpio_soc_config *)match->data;
-	else
-		config = &tegra20_gpio_config;
+	if (!match) {
+		dev_err(&pdev->dev, "Error: No device match found\n");
+		return -ENODEV;
+	}
+	config = (struct tegra_gpio_soc_config *)match->data;
 
 	tegra_gpio_bank_stride = config->bank_stride;
 	tegra_gpio_upper_offset = config->upper_offset;
@@ -462,9 +463,7 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 		}
 	}
 
-#ifdef CONFIG_OF_GPIO
 	tegra_gpio_chip.of_node = pdev->dev.of_node;
-#endif
 
 	gpiochip_add(&tegra_gpio_chip);
 
-- 
1.7.10.4

