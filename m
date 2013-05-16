Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3EPXUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:20:04 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41562 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3EPXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:20:02 -0400
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] pinctrl: samsung: fix suspend/resume functionality
Date: Thu, 16 May 2013 16:19:48 -0700
Message-Id: <1368746388-20194-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368724352-10849-1-git-send-email-dianders@chromium.org>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO states need to be restored after s2r and this is not currently
supported in the pinctrl driver. This patch saves the gpio states before
suspend and restores them after resume.

Saving and restoring is done very early using syscore_ops and must
happen before pins are released from their powerdown state.

Patch originally from Prathyush K <prathyush.k@samsung.com> but
rewritten by Doug Anderson <dianders@chromium.org>.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Now uses sycore_ops to make sure we're early enough.
- Try to handle two CON registers better.
- Should handle s3c24xx better as per Heiko.
- Simpler code; no longer tries to avoid glitching lines since
  we _think_ all current SoCs should have pins in power down state
  when the restore is called.
- Dropped eint patch for now; Tomasz will post his version.

 drivers/pinctrl/pinctrl-samsung.c | 140 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h |   5 ++
 2 files changed, 145 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 9763668..851eada 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -28,6 +28,7 @@
 #include <linux/gpio.h>
 #include <linux/irqdomain.h>
 #include <linux/spinlock.h>
+#include <linux/syscore_ops.h>
 
 #include "core.h"
 #include "pinctrl-samsung.h"
@@ -48,6 +49,9 @@ static struct pin_config {
 	{ "samsung,pin-pud-pdn", PINCFG_TYPE_PUD_PDN },
 };
 
+/* Global list of devices (struct samsung_pinctrl_drv_data) */
+LIST_HEAD(drvdata_list);
+
 static unsigned int pin_base;
 
 static inline struct samsung_pin_bank *gc_to_pin_bank(struct gpio_chip *gc)
@@ -961,9 +965,137 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 		ctrl->eint_wkup_init(drvdata);
 
 	platform_set_drvdata(pdev, drvdata);
+
+	/* Add to the global list */
+	list_add_tail(&drvdata->node, &drvdata_list);
+
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+/**
+ * samsung_pinctrl_suspend_dev - save pinctrl state for suspend for a device
+ *
+ * Save data for all banks handled by this device.
+ */
+static void samsung_pinctrl_suspend_dev(
+	struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
+	void __iomem *virt_base = drvdata->virt_base;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; i++) {
+		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+		void __iomem *reg = virt_base + bank->pctl_offset;
+
+		u8 *offs = bank->type->reg_offset;
+		u8 *widths = bank->type->fld_width;
+		enum pincfg_type type;
+
+		for (type = 0; type < PINCFG_TYPE_NUM; type++)
+			if (widths[type])
+				bank->pm_save[type] = readl(reg + offs[type]);
+
+		if (widths[PINCFG_TYPE_FUNC] * bank->nr_pins > 32) {
+			/* Some banks have two config registers */
+			bank->pm_save[PINCFG_TYPE_NUM] =
+				readl(reg + offs[PINCFG_TYPE_FUNC] + 4);
+			pr_debug("Save %s @ %p (con %#010x %08x)\n",
+				 bank->name, reg,
+				 bank->pm_save[PINCFG_TYPE_FUNC],
+				 bank->pm_save[PINCFG_TYPE_NUM]);
+		} else {
+			pr_debug("Save %s @ %p (con %#010x)\n", bank->name,
+				 reg, bank->pm_save[PINCFG_TYPE_FUNC]);
+		}
+	}
+}
+
+/**
+ * samsung_pinctrl_resume_dev - restore pinctrl state from suspend for a device
+ *
+ * Restore one of the banks that was saved during suspend.
+ *
+ * We don't bother doing anything complicated to avoid glitching lines since
+ * we're called before pad retention is turned off.
+ */
+static void samsung_pinctrl_resume_dev(struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
+	void __iomem *virt_base = drvdata->virt_base;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; i++) {
+		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+		void __iomem *reg = virt_base + bank->pctl_offset;
+
+		u8 *offs = bank->type->reg_offset;
+		u8 *widths = bank->type->fld_width;
+		enum pincfg_type type;
+
+		if (widths[PINCFG_TYPE_FUNC] * bank->nr_pins > 32) {
+			/* Some banks have two config registers */
+			pr_debug("%s @ %p (con %#010x %08x => %#010x %08x)\n",
+				 bank->name, reg,
+				 readl(reg + offs[PINCFG_TYPE_FUNC]),
+				 readl(reg + offs[PINCFG_TYPE_FUNC] + 4),
+				 bank->pm_save[PINCFG_TYPE_FUNC],
+				 bank->pm_save[PINCFG_TYPE_NUM]);
+			writel(bank->pm_save[PINCFG_TYPE_NUM],
+			       reg + offs[PINCFG_TYPE_FUNC] + 4);
+		} else {
+			pr_debug("%s @ %p (con %#010x => %#010x)\n", bank->name,
+				 reg, readl(reg + offs[PINCFG_TYPE_FUNC]),
+				 bank->pm_save[PINCFG_TYPE_FUNC]);
+		}
+		for (type = 0; type < PINCFG_TYPE_NUM; type++)
+			if (widths[type])
+				writel(bank->pm_save[type], reg + offs[type]);
+	}
+}
+
+/**
+ * samsung_pinctrl_suspend - save pinctrl state for suspend
+ *
+ * Save data for all banks across all devices.
+ */
+static int samsung_pinctrl_suspend(void)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	list_for_each_entry(drvdata, &drvdata_list, node) {
+		samsung_pinctrl_suspend_dev(drvdata);
+	}
+
+	return 0;
+}
+
+/**
+ * samsung_pinctrl_resume - restore pinctrl state for suspend
+ *
+ * Restore data for all banks across all devices.
+ */
+static void samsung_pinctrl_resume(void)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	list_for_each_entry_reverse(drvdata, &drvdata_list, node) {
+		samsung_pinctrl_resume_dev(drvdata);
+	}
+}
+
+#else
+#define samsung_pinctrl_suspend		NULL
+#define samsung_pinctrl_resume		NULL
+#endif
+
+static struct syscore_ops samsung_pinctrl_syscore_ops = {
+	.suspend	= samsung_pinctrl_suspend,
+	.resume		= samsung_pinctrl_resume,
+};
+
 static const struct of_device_id samsung_pinctrl_dt_match[] = {
 #ifdef CONFIG_PINCTRL_EXYNOS
 	{ .compatible = "samsung,exynos4210-pinctrl",
@@ -992,6 +1124,14 @@ static struct platform_driver samsung_pinctrl_driver = {
 
 static int __init samsung_pinctrl_drv_register(void)
 {
+	/*
+	 * Register syscore ops for save/restore of registers across suspend.
+	 * It's important to ensure that this driver is running at an earlier
+	 * initcall level than any arch-specific init calls that install syscore
+	 * ops that turn off pad retention (like exynos_pm_resume).
+	 */
+	register_syscore_ops(&samsung_pinctrl_syscore_ops);
+
 	return platform_driver_register(&samsung_pinctrl_driver);
 }
 postcore_initcall(samsung_pinctrl_drv_register);
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index 7c7f9eb..9f5cc81 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -127,6 +127,7 @@ struct samsung_pin_bank_type {
  * @gpio_chip: GPIO chip of the bank.
  * @grange: linux gpio pin range supported by this bank.
  * @slock: spinlock protecting bank registers
+ * @pm_save: saved register values during suspend
  */
 struct samsung_pin_bank {
 	struct samsung_pin_bank_type *type;
@@ -144,6 +145,8 @@ struct samsung_pin_bank {
 	struct gpio_chip gpio_chip;
 	struct pinctrl_gpio_range grange;
 	spinlock_t slock;
+
+	u32 pm_save[PINCFG_TYPE_NUM + 1]; /* +1 to handle double CON registers*/
 };
 
 /**
@@ -189,6 +192,7 @@ struct samsung_pin_ctrl {
 
 /**
  * struct samsung_pinctrl_drv_data: wrapper for holding driver data together.
+ * @node: global list node
  * @virt_base: register base address of the controller.
  * @dev: device instance representing the controller.
  * @irq: interrpt number used by the controller to notify gpio interrupts.
@@ -201,6 +205,7 @@ struct samsung_pin_ctrl {
  * @nr_function: number of such pin functions.
  */
 struct samsung_pinctrl_drv_data {
+	struct list_head		node;
 	void __iomem			*virt_base;
 	struct device			*dev;
 	int				irq;
-- 
1.8.2.1

