Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935571AbaDJNzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:55:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39199 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934951AbaDJNx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:53:57 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 6/7] pinctrl: sunxi: add reset control support
Date: Thu, 10 Apr 2014 15:52:45 +0200
Message-Id: <1397137966-30818-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 SoC define a reset line for the R_PIO block which needs to be
deasserted.

Try to retrieve a reset control and deassert if one was found.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 17b5f80..07af35a 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -26,6 +26,7 @@
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/slab.h>
 
 #include "core.h"
@@ -792,6 +793,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	const struct of_device_id *device;
 	struct pinctrl_pin_desc *pins;
 	struct sunxi_pinctrl *pctl;
+	struct reset_control *rstc;
 	int i, ret, last_pin;
 	struct clk *clk;
 
@@ -887,10 +889,17 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	if (ret)
 		goto gpiochip_error;
 
+	rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
+	if (!IS_ERR(rstc)) {
+		ret = reset_control_deassert(rstc);
+		if (ret)
+			goto clk_error;
+	}
+
 	pctl->irq = irq_of_parse_and_map(node, 0);
 	if (!pctl->irq) {
 		ret = -EINVAL;
-		goto clk_error;
+		goto rstc_error;
 	}
 
 	pctl->domain = irq_domain_add_linear(node, SUNXI_IRQ_NUMBER,
@@ -898,7 +907,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	if (!pctl->domain) {
 		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
 		ret = -ENOMEM;
-		goto clk_error;
+		goto rstc_error;
 	}
 
 	for (i = 0; i < SUNXI_IRQ_NUMBER; i++) {
@@ -916,6 +925,9 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 
 	return 0;
 
+rstc_error:
+	if (!IS_ERR(rstc))
+		reset_control_assert(rstc);
 clk_error:
 	clk_disable_unprepare(clk);
 gpiochip_error:
-- 
1.8.3.2

