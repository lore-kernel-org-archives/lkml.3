Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259AbaDJNyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:54:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39180 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934368AbaDJNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:53:53 -0400
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
Subject: [PATCH v3 2/7] pinctrl: sunxi: disable clk when failing to probe pin controller
Date: Thu, 10 Apr 2014 15:52:41 +0200
Message-Id: <1397137966-30818-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the clk when failing to probe the pin controller device.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 2d9ca1c..73d11e2 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -891,7 +891,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	pctl->irq = irq_of_parse_and_map(node, 0);
 	if (!pctl->irq) {
 		ret = -EINVAL;
-		goto gpiochip_error;
+		goto clk_error;
 	}
 
 	pctl->domain = irq_domain_add_linear(node, SUNXI_IRQ_NUMBER,
@@ -899,7 +899,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	if (!pctl->domain) {
 		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
 		ret = -ENOMEM;
-		goto gpiochip_error;
+		goto clk_error;
 	}
 
 	for (i = 0; i < SUNXI_IRQ_NUMBER; i++) {
@@ -917,6 +917,8 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 
 	return 0;
 
+clk_error:
+	clk_disable_unprepare(clk);
 gpiochip_error:
 	if (gpiochip_remove(pctl->chip))
 		dev_err(&pdev->dev, "failed to remove gpio chip\n");
-- 
1.8.3.2

