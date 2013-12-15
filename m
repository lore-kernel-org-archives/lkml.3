Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3LOHDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 02:03:00 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5911 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098Ab3LOHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 02:02:01 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 3/4] pinctrl-msm: Remove separate allocation of bitmaps
Date: Sat, 14 Dec 2013 23:01:53 -0800
Message-ID: <1387090914-4755-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the bitmaps part of the msm_pinctrl allocation instead of
separately allocating them.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index c1a3053..011e263 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -36,6 +36,8 @@
 #include "pinctrl-msm.h"
 #include "pinctrl-utils.h"
 
+#define MAX_NR_GPIO 300
+
 /**
  * struct msm_pinctrl - state for a pinctrl-msm device
  * @dev:            device handle.
@@ -61,9 +63,9 @@ struct msm_pinctrl {
 
 	spinlock_t lock;
 
-	unsigned long *enabled_irqs;
-	unsigned long *dual_edge_irqs;
-	unsigned long *wake_irqs;
+	DECLARE_BITMAP(dual_edge_irqs, MAX_NR_GPIO);
+	DECLARE_BITMAP(enabled_irqs, MAX_NR_GPIO);
+	DECLARE_BITMAP(wake_irqs, MAX_NR_GPIO);
 
 	const struct msm_pinctrl_soc_data *soc;
 	void __iomem *regs;
@@ -875,30 +877,6 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	chip->owner = THIS_MODULE;
 	chip->of_node = pctrl->dev->of_node;
 
-	pctrl->enabled_irqs = devm_kzalloc(pctrl->dev,
-					   sizeof(unsigned long) * BITS_TO_LONGS(chip->ngpio),
-					   GFP_KERNEL);
-	if (!pctrl->enabled_irqs) {
-		dev_err(pctrl->dev, "Failed to allocate enabled_irqs bitmap\n");
-		return -ENOMEM;
-	}
-
-	pctrl->dual_edge_irqs = devm_kzalloc(pctrl->dev,
-					     sizeof(unsigned long) * BITS_TO_LONGS(chip->ngpio),
-					     GFP_KERNEL);
-	if (!pctrl->dual_edge_irqs) {
-		dev_err(pctrl->dev, "Failed to allocate dual_edge_irqs bitmap\n");
-		return -ENOMEM;
-	}
-
-	pctrl->wake_irqs = devm_kzalloc(pctrl->dev,
-					sizeof(unsigned long) * BITS_TO_LONGS(chip->ngpio),
-					GFP_KERNEL);
-	if (!pctrl->wake_irqs) {
-		dev_err(pctrl->dev, "Failed to allocate wake_irqs bitmap\n");
-		return -ENOMEM;
-	}
-
 	ret = gpiochip_add(&pctrl->chip);
 	if (ret) {
 		dev_err(pctrl->dev, "Failed register gpiochip\n");
-- 
1.7.9.5

