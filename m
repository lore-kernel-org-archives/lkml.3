Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab3AQJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:19:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3AQJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:19:23 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Date: Thu, 17 Jan 2013 14:50:02 +0530
Message-ID: <1358414403-13431-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
References: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In low power modes of AM33XX platforms, peripherals power is cut off.
This patch supports low power sleep transition support for EHRPWM
driver.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v1:
	- check the enabled status of pwm device for handling module
	  enable/disable on resume/suspend

 drivers/pwm/pwm-tiehrpwm.c |   83 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 4058df4..6627f42 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -113,6 +113,17 @@
 
 #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
 
+struct ehrpwm_context {
+	u16 tbctl;
+	u16 tbprd;
+	u16 cmpa;
+	u16 cmpb;
+	u16 aqctla;
+	u16 aqctlb;
+	u16 aqsfrc;
+	u16 aqcsfrc;
+};
+
 struct ehrpwm_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
@@ -120,6 +131,7 @@ struct ehrpwm_pwm_chip {
 	unsigned long period_cycles[NUM_PWM_CHANNEL];
 	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
 	struct	clk	*tbclk;
+	struct ehrpwm_context ctx;
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -127,6 +139,11 @@ static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
 	return container_of(chip, struct ehrpwm_pwm_chip, chip);
 }
 
+static u16 ehrpwm_read(void *base, int offset)
+{
+	return readw(base + offset);
+}
+
 static void ehrpwm_write(void *base, int offset, unsigned int val)
 {
 	writew(val & 0xFFFF, base + offset);
@@ -516,11 +533,77 @@ static int ehrpwm_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
+void ehrpwm_pwm_save_context(struct ehrpwm_pwm_chip *pc)
+{
+	pm_runtime_get_sync(pc->chip.dev);
+	pc->ctx.tbctl = ehrpwm_read(pc->mmio_base, TBCTL);
+	pc->ctx.tbprd = ehrpwm_read(pc->mmio_base, TBPRD);
+	pc->ctx.cmpa = ehrpwm_read(pc->mmio_base, CMPA);
+	pc->ctx.cmpb = ehrpwm_read(pc->mmio_base, CMPB);
+	pc->ctx.aqctla = ehrpwm_read(pc->mmio_base, AQCTLA);
+	pc->ctx.aqctlb = ehrpwm_read(pc->mmio_base, AQCTLB);
+	pc->ctx.aqsfrc = ehrpwm_read(pc->mmio_base, AQSFRC);
+	pc->ctx.aqcsfrc = ehrpwm_read(pc->mmio_base, AQCSFRC);
+	pm_runtime_put_sync(pc->chip.dev);
+}
+
+void ehrpwm_pwm_restore_context(struct ehrpwm_pwm_chip *pc)
+{
+	ehrpwm_write(pc->mmio_base, TBPRD, pc->ctx.tbprd);
+	ehrpwm_write(pc->mmio_base, CMPA, pc->ctx.cmpa);
+	ehrpwm_write(pc->mmio_base, CMPB, pc->ctx.cmpb);
+	ehrpwm_write(pc->mmio_base, AQCTLA, pc->ctx.aqctla);
+	ehrpwm_write(pc->mmio_base, AQCTLB, pc->ctx.aqctlb);
+	ehrpwm_write(pc->mmio_base, AQSFRC, pc->ctx.aqsfrc);
+	ehrpwm_write(pc->mmio_base, AQCSFRC, pc->ctx.aqcsfrc);
+	ehrpwm_write(pc->mmio_base, TBCTL, pc->ctx.tbctl);
+}
+
+static int ehrpwm_pwm_suspend(struct device *dev)
+{
+	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
+	int i;
+
+	ehrpwm_pwm_save_context(pc);
+	for (i = 0; i < pc->chip.npwm; i++) {
+		struct pwm_device *pwm = &pc->chip.pwms[i];
+
+		if (!test_bit(PWMF_ENABLED, &pwm->flags))
+			continue;
+
+		/* Disable explicitly if PWM is running */
+		pm_runtime_put_sync(dev);
+	}
+	return 0;
+}
+
+static int ehrpwm_pwm_resume(struct device *dev)
+{
+	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < pc->chip.npwm; i++) {
+		struct pwm_device *pwm = &pc->chip.pwms[i];
+
+		if (!test_bit(PWMF_ENABLED, &pwm->flags))
+			continue;
+
+		/* Enable explicitly if PWM was running */
+		pm_runtime_get_sync(dev);
+	}
+	ehrpwm_pwm_restore_context(pc);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ehrpwm_pwm_pm_ops, ehrpwm_pwm_suspend,
+		ehrpwm_pwm_resume);
+
 static struct platform_driver ehrpwm_pwm_driver = {
 	.driver = {
 		.name	= "ehrpwm",
 		.owner	= THIS_MODULE,
 		.of_match_table = ehrpwm_of_match,
+		.pm	= &ehrpwm_pwm_pm_ops,
 	},
 	.probe = ehrpwm_pwm_probe,
 	.remove = ehrpwm_pwm_remove,
-- 
1.7.9.5

