Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaLDKc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:32:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:14880 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaLDKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:32:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="618491964"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] pinctrl: cherryview: Save and restore pin configs over system sleep
Date: Thu,  4 Dec 2014 12:32:50 +0200
Message-Id: <1417689170-41627-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before resuming from system sleep BIOS restores its view of pin
configuration. If we have configured some pins differently from that, for
instance some driver requested a pin as a GPIO but it was not in GPIO mode
originally, our view of the pin configuration will not match the hardware
state anymore.

This patch saves the pin configuration and interrupt mask registers on
suspend and restores them on exit. This should make sure that the
previously configured state is still in effect.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 104 +++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index e9f8b39d1a9f..dde67d425e9c 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -148,6 +148,11 @@ struct chv_community {
 	size_t ngpios;
 };
 
+struct chv_pin_context {
+	u32 padctrl0;
+	u32 padctrl1;
+};
+
 /**
  * struct chv_pinctrl - CHV pinctrl private structure
  * @dev: Pointer to the parent device
@@ -172,6 +177,8 @@ struct chv_pinctrl {
 	spinlock_t lock;
 	unsigned intr_lines[16];
 	const struct chv_community *community;
+	u32 saved_intmask;
+	struct chv_pin_context *saved_pin_context;
 };
 
 #define gpiochip_to_pinctrl(c) container_of(c, struct chv_pinctrl, chip)
@@ -1443,6 +1450,14 @@ static int chv_pinctrl_probe(struct platform_device *pdev)
 	spin_lock_init(&pctrl->lock);
 	pctrl->dev = &pdev->dev;
 
+#ifdef CONFIG_PM_SLEEP
+	pctrl->saved_pin_context = devm_kcalloc(pctrl->dev,
+		pctrl->community->npins, sizeof(*pctrl->saved_pin_context),
+		GFP_KERNEL);
+	if (!pctrl->saved_pin_context)
+		return -ENOMEM;
+#endif
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pctrl->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(pctrl->regs))
@@ -1486,6 +1501,94 @@ static int chv_pinctrl_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int chv_pinctrl_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct chv_pinctrl *pctrl = platform_get_drvdata(pdev);
+	int i;
+
+	pctrl->saved_intmask = readl(pctrl->regs + CHV_INTMASK);
+
+	for (i = 0; i < pctrl->community->npins; i++) {
+		const struct pinctrl_pin_desc *desc;
+		struct chv_pin_context *ctx;
+		void __iomem *reg;
+
+		desc = &pctrl->community->pins[i];
+		if (chv_pad_locked(pctrl, desc->number))
+			continue;
+
+		ctx = &pctrl->saved_pin_context[i];
+
+		reg = chv_padreg(pctrl, desc->number, CHV_PADCTRL0);
+		ctx->padctrl0 = readl(reg) & ~CHV_PADCTRL0_GPIORXSTATE;
+
+		reg = chv_padreg(pctrl, desc->number, CHV_PADCTRL1);
+		ctx->padctrl1 = readl(reg);
+	}
+
+	return 0;
+}
+
+static int chv_pinctrl_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct chv_pinctrl *pctrl = platform_get_drvdata(pdev);
+	int i;
+
+	/*
+	 * Mask all interrupts before restoring per-pin configuration
+	 * registers because we don't know in which state BIOS left them
+	 * upon exiting suspend.
+	 */
+	chv_writel(0, pctrl->regs + CHV_INTMASK);
+
+	for (i = 0; i < pctrl->community->npins; i++) {
+		const struct pinctrl_pin_desc *desc;
+		const struct chv_pin_context *ctx;
+		void __iomem *reg;
+		u32 val;
+
+		desc = &pctrl->community->pins[i];
+		if (chv_pad_locked(pctrl, desc->number))
+			continue;
+
+		ctx = &pctrl->saved_pin_context[i];
+
+		/* Only restore if our saved state differs from the current */
+		reg = chv_padreg(pctrl, desc->number, CHV_PADCTRL0);
+		val = readl(reg) & ~CHV_PADCTRL0_GPIORXSTATE;
+		if (ctx->padctrl0 != val) {
+			chv_writel(ctx->padctrl0, reg);
+			dev_dbg(pctrl->dev, "restored pin %2u ctrl0 0x%08x\n",
+				desc->number, readl(reg));
+		}
+
+		reg = chv_padreg(pctrl, desc->number, CHV_PADCTRL1);
+		val = readl(reg);
+		if (ctx->padctrl1 != val) {
+			chv_writel(ctx->padctrl1, reg);
+			dev_dbg(pctrl->dev, "restored pin %2u ctrl1 0x%08x\n",
+				desc->number, readl(reg));
+		}
+	}
+
+	/*
+	 * Now that all pins are restored to known state, we can restore
+	 * the interrupt mask register as well.
+	 */
+	chv_writel(0xffff, pctrl->regs + CHV_INTSTAT);
+	chv_writel(pctrl->saved_intmask, pctrl->regs + CHV_INTMASK);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops chv_pinctrl_pm_ops = {
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(chv_pinctrl_suspend, chv_pinctrl_resume)
+};
+
 static const struct acpi_device_id chv_pinctrl_acpi_match[] = {
 	{ "INT33FF" },
 	{ }
@@ -1498,6 +1601,7 @@ static struct platform_driver chv_pinctrl_driver = {
 	.driver = {
 		.name = "cherryview-pinctrl",
 		.owner = THIS_MODULE,
+		.pm = &chv_pinctrl_pm_ops,
 		.acpi_match_table = chv_pinctrl_acpi_match,
 	},
 };
-- 
2.1.3

