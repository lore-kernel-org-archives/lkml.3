Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967913Ab3DSIL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:11:27 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:37071 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416Ab3DSILX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:11:23 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2  3/3] pwm: pxa: add device tree support
Date: Fri, 19 Apr 2013 04:08:41 -0400
Message-ID: <1366358921-24478-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366358921-24478-1-git-send-email-chao.xie@marvell.com>
References: <1366358921-24478-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the deice tree support for pwm-pxa.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/pwm-pxa.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index aa4bea7..c942f01 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -18,6 +18,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/pwm.h>
 
 #include <asm/div64.h>
@@ -124,9 +126,52 @@ static struct pwm_ops pxa_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
-static int pwm_probe(struct platform_device *pdev)
+static struct of_device_id pxa_pwm_of_match[] = {
+	{
+		.compatible = "mrvl,pxa25x-pwm",
+	}, {
+		.compatible = "mrvl,pxa27x-pwm",
+		.data = (void *)HAS_SECONDARY_PWM
+	}, {
+		.compatible = "mrvl,pxa168-pwm",
+	}, {
+		.compatible = "mrvl,pxa910-pwm",
+	},
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, pxa_pwm_of_match);
+
+#ifdef CONFIG_OF
+static int pxa_pwm_parse_data(struct platform_device *pdev,
+				struct pxa_pwm_chip *pwm)
+{
+	const struct of_device_id *of_id =
+			of_match_device(pxa_pwm_of_match, &pdev->dev);
+	unsigned int npwm;
+
+	if (!of_id)
+		return -ENODEV;
+
+	npwm = (unsigned int)(of_id->data);
+	pwm->chip.npwm = (npwm & HAS_SECONDARY_PWM) ? 2 : 1;
+
+	return 0;
+}
+#else
+static int pxa_pwm_parse_data(struct platform_device *pdev,
+				struct pxa_pwm_chip *pwm)
 {
 	const struct platform_device_id *id = platform_get_device_id(pdev);
+
+	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
+
+	return 0;
+}
+#endif
+
+static int pwm_probe(struct platform_device *pdev)
+{
 	struct pxa_pwm_chip *pwm;
 	struct resource *r;
 	int ret = 0;
@@ -144,7 +189,6 @@ static int pwm_probe(struct platform_device *pdev)
 	pwm->chip.dev = &pdev->dev;
 	pwm->chip.ops = &pxa_pwm_ops;
 	pwm->chip.base = -1;
-	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
@@ -156,6 +200,12 @@ static int pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(pwm->mmio_base))
 		return PTR_ERR(pwm->mmio_base);
 
+	ret = pxa_pwm_parse_data(pdev, pwm);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to parse data from device id\n");
+		return ret;
+	}
+
 	ret = pwmchip_add(&pwm->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
@@ -181,6 +231,7 @@ static struct platform_driver pwm_driver = {
 	.driver		= {
 		.name	= "pxa25x-pwm",
 		.owner	= THIS_MODULE,
+		.of_match_table	= pxa_pwm_of_match,
 	},
 	.probe		= pwm_probe,
 	.remove		= pwm_remove,
-- 
1.7.4.1

