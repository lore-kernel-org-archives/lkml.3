Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaDINxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:53:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60882 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933470AbaDINvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:37 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 13/15] pinctrl: sunxi: retrieve and enable PL reset line for A31 SoC
Date: Wed,  9 Apr 2014 15:51:16 +0200
Message-Id: <1397051478-4113-14-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve and deassert the reset line related to PL pins.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index da76ceb..09eea79 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -26,6 +26,7 @@
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/slab.h>
 
 #include "core.h"
@@ -878,6 +879,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	const struct of_device_id *device;
 	struct pinctrl_pin_desc *pins;
 	struct sunxi_pinctrl *pctl;
+	struct reset_control *rstc;
 	int i, ret, last_pin;
 	struct clk *clk;
 
@@ -905,6 +907,14 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 		ret = clk_prepare_enable(clk);
 		if (ret)
 			return ret;
+
+		rstc = devm_reset_control_get(&pdev->dev, NULL);
+		if (IS_ERR(rstc))
+			return PTR_ERR(rstc);
+
+		ret = reset_control_deassert(rstc);
+		if (ret)
+			return ret;
 	} else {
 		pctl->get_membase = sunxi_pinctrl_get_membase;
 	}
-- 
1.8.3.2

