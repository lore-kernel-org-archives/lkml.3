Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab3AQJTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:19:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36612 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab3AQJTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:19:46 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 2/2] pwm: pwm-tiecap: Low power sleep support
Date: Thu, 17 Jan 2013 14:50:03 +0530
Message-ID: <1358414403-13431-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
References: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In low power modes of AM33XX platforms, peripherals power is cut off.
This patch supports low power sleep transition support for ECAP driver.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v1:
	- check the enabled status of pwm device for handling module
	  enable/disable on resume/suspend

 drivers/pwm/pwm-tiecap.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 5cf016d..05b676d 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -41,10 +41,17 @@
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
 
+struct ecap_context {
+	u32	cap3;
+	u32	cap4;
+	u16	ecctl2;
+};
+
 struct ecap_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	struct ecap_context ctx;
 };
 
 static inline struct ecap_pwm_chip *to_ecap_pwm_chip(struct pwm_chip *chip)
@@ -288,11 +295,57 @@ static int ecap_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
+void ecap_pwm_save_context(struct ecap_pwm_chip *pc)
+{
+	pm_runtime_get_sync(pc->chip.dev);
+	pc->ctx.ecctl2 = readw(pc->mmio_base + ECCTL2);
+	pc->ctx.cap4 = readl(pc->mmio_base + CAP4);
+	pc->ctx.cap3 = readl(pc->mmio_base + CAP3);
+	pm_runtime_put_sync(pc->chip.dev);
+}
+
+void ecap_pwm_restore_context(struct ecap_pwm_chip *pc)
+{
+	writel(pc->ctx.cap3, pc->mmio_base + CAP3);
+	writel(pc->ctx.cap4, pc->mmio_base + CAP4);
+	writew(pc->ctx.ecctl2, pc->mmio_base + ECCTL2);
+}
+
+static int ecap_pwm_suspend(struct device *dev)
+{
+	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
+	struct pwm_device *pwm = pc->chip.pwms;
+
+	ecap_pwm_save_context(pc);
+
+	/* Disable explicitly if PWM is running */
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		pm_runtime_put_sync(dev);
+
+	return 0;
+}
+
+static int ecap_pwm_resume(struct device *dev)
+{
+	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
+	struct pwm_device *pwm = pc->chip.pwms;
+
+	/* Enable explicitly if PWM was running */
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		pm_runtime_get_sync(dev);
+
+	ecap_pwm_restore_context(pc);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ecap_pwm_pm_ops, ecap_pwm_suspend, ecap_pwm_resume);
+
 static struct platform_driver ecap_pwm_driver = {
 	.driver = {
 		.name	= "ecap",
 		.owner	= THIS_MODULE,
 		.of_match_table = ecap_of_match,
+		.pm	= &ecap_pwm_pm_ops,
 	},
 	.probe = ecap_pwm_probe,
 	.remove = ecap_pwm_remove,
-- 
1.7.9.5

