Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3A3Tkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:40:42 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53988 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792Ab3A3Tki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:40:38 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] pinctrl/abx500: destroy mutex if returning early due to error
Date: Wed, 30 Jan 2013 20:40:22 +0100
Message-ID: <1359574822-15729-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Current failure path neglects to mutex_destroy() before returning
an error due to an invalid parameter or an error received from
gpiochip_add(). This patch aims to remedy that behaviour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 426b47c..81ef515 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1155,11 +1155,13 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
 				(int) platid->driver_data);
+		mutex_destroy(&pct->lock);
 		return -EINVAL;
 	}
 
 	if (!pct->soc) {
 		dev_err(&pdev->dev, "Invalid SOC data\n");
+		mutex_destroy(&pct->lock);
 		return -EINVAL;
 	}
 
@@ -1176,6 +1178,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	ret = gpiochip_add(&pct->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
+		mutex_destroy(&pct->lock);
 		goto out_rem_irq;
 	}
 	dev_info(&pdev->dev, "added gpiochip\n");
-- 
1.7.11.3

