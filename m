Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3EaKLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:11:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3EaKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:11:48 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH 01/11] pinctrl: single: adopt pinctrl sleep mode management
Date: Fri, 31 May 2013 15:43:01 +0530
Message-ID: <1369995191-20855-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pinctrl-single able to handle suspend/resume events and change
hogged pins states accordingly.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
:100644 100644 b9fa046... bfd4f6a... M	drivers/pinctrl/pinctrl-single.c
 drivers/pinctrl/pinctrl-single.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index b9fa046..bfd4f6a 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1346,6 +1346,29 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 	return ret;
 }
 
+static int pinctrl_single_suspend(struct platform_device *pdev,
+					pm_message_t state)
+{
+	struct pcs_device *pcs;
+
+	pcs = platform_get_drvdata(pdev);
+	if (!pcs)
+		return -EINVAL;
+
+	return pinctrl_force_sleep(pcs->pctl);
+}
+
+static int pinctrl_single_resume(struct platform_device *pdev)
+{
+	struct pcs_device *pcs;
+
+	pcs = platform_get_drvdata(pdev);
+	if (!pcs)
+		return -EINVAL;
+
+	return pinctrl_force_default(pcs->pctl);
+}
+
 static int pcs_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -1494,6 +1517,10 @@ static struct platform_driver pcs_driver = {
 		.name		= DRIVER_NAME,
 		.of_match_table	= pcs_of_match,
 	},
+#ifdef CONFIG_PM
+	.suspend = pinctrl_single_suspend,
+	.resume = pinctrl_single_resume,
+#endif
 };
 
 module_platform_driver(pcs_driver);
-- 
1.7.9.5

