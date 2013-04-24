Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3DXC3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:29:45 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:55562 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab3DXC3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:29:44 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 3/3] pwm: pxa: add device tree support
Date: Tue, 23 Apr 2013 22:23:54 -0400
Message-ID: <1366770234-5829-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the deice tree support for pwm-pxa.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/pwm-pxa.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index aa4bea7..45d9047 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -9,6 +9,8 @@
  *
  * 2008-02-13	initial version
  * 		eric miao <eric.miao@marvell.com>
+ * 2013-04-24   add device tree support
+ * 		Chao Xie <chao.xie@marvell.com>
  */
 
 #include <linux/module.h>
@@ -18,6 +20,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/pwm.h>
 
 #include <asm/div64.h>
@@ -124,9 +128,52 @@ static struct pwm_ops pxa_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
-static int pwm_probe(struct platform_device *pdev)
+static struct of_device_id pxa_pwm_of_match[] = {
+	{
+		.compatible = "marvell,pxa25x-pwm",
+	}, {
+		.compatible = "marvell,pxa27x-pwm",
+		.data = (void *)HAS_SECONDARY_PWM
+	}, {
+		.compatible = "marvell,pxa168-pwm",
+	}, {
+		.compatible = "marvell,pxa910-pwm",
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
@@ -144,7 +191,6 @@ static int pwm_probe(struct platform_device *pdev)
 	pwm->chip.dev = &pdev->dev;
 	pwm->chip.ops = &pxa_pwm_ops;
 	pwm->chip.base = -1;
-	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
@@ -156,6 +202,12 @@ static int pwm_probe(struct platform_device *pdev)
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
@@ -181,6 +233,7 @@ static struct platform_driver pwm_driver = {
 	.driver		= {
 		.name	= "pxa25x-pwm",
 		.owner	= THIS_MODULE,
+		.of_match_table	= pxa_pwm_of_match,
 	},
 	.probe		= pwm_probe,
 	.remove		= pwm_remove,
-- 
1.7.4.1

