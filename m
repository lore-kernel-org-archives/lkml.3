Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3EPRMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:12:43 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60482 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3EPRMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:12:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
Date: Thu, 16 May 2013 10:12:31 -0700
Message-Id: <1368724352-10849-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368724352-10849-1-git-send-email-dianders@chromium.org>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO states need to be restored after s2r and this is not currently
supported in the pinctrl driver. This patch saves the gpio states before
suspend and restores them after resume.

Logic and commenting for samsung_pinctrl_resume_noirq() is heavily
borrowed from the old samsung_gpio_pm_2bit_resume(), which seemed to
do this a reasonable way.

Patch originally from Prathyush K <prathyush.k@samsung.com> but
rewritten by Doug Anderson <dianders@chromium.org>.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-samsung.c | 199 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h |  11 +++
 2 files changed, 210 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 9763668..0891667 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -964,6 +964,204 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+/**
+ * samsung_pinctrl_resume_noirq - save pinctrl state for suspend
+ *
+ * Save data for all banks handled by this device.
+ */
+static int samsung_pinctrl_suspend_noirq(struct device *dev)
+{
+	struct samsung_pinctrl_drv_data *drvdata = dev_get_drvdata(dev);
+	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
+	void __iomem * const virt_base = drvdata->virt_base;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; i++) {
+		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+		const struct samsung_pin_bank_type *type = bank->type;
+		void __iomem * const reg = virt_base + bank->pctl_offset;
+
+		bank->pm_save.con = readl(reg +
+					  type->reg_offset[PINCFG_TYPE_FUNC]);
+		if (type->fld_width[PINCFG_TYPE_FUNC] > 4)
+			bank->pm_save.con |= (u64)readl(reg + 4 +
+				      type->reg_offset[PINCFG_TYPE_FUNC]) << 32;
+		bank->pm_save.dat = readl(reg +
+					  type->reg_offset[PINCFG_TYPE_DAT]);
+		bank->pm_save.pud = readl(reg +
+					  type->reg_offset[PINCFG_TYPE_PUD]);
+		bank->pm_save.drv = readl(reg +
+					  type->reg_offset[PINCFG_TYPE_DRV]);
+
+		if (type->fld_width[PINCFG_TYPE_CON_PDN]) {
+			bank->pm_save.conpdn = readl(reg +
+				type->reg_offset[PINCFG_TYPE_CON_PDN]);
+			bank->pm_save.pudpdn = readl(reg +
+				type->reg_offset[PINCFG_TYPE_PUD_PDN]);
+		}
+
+		dev_dbg(dev, "Save %s @ %p (con %#010llx)\n",
+			bank->name, reg, bank->pm_save.con);
+	}
+
+	return 0;
+}
+
+/**
+ * is_sfn - test whether a pin config represents special function.
+ *
+ * Test whether the given masked+shifted bits of an GPIO configuration
+ * are one of the SFN (special function) modes.
+ */
+static inline int is_sfn(u32 con)
+{
+	return con >= 2;
+}
+
+/**
+ * is_in - test if the given masked+shifted GPIO configuration is an input.
+ */
+static inline int is_in(u32 con)
+{
+	return con == 0;
+}
+
+/**
+ * is_out - test if the given masked+shifted GPIO configuration is an output.
+ */
+static inline int is_out(u32 con)
+{
+	return con == 1;
+}
+
+/**
+ * samsung_pinctrl_resume_noirq - restore pinctrl state from suspend
+ *
+ * Restore one of the GPIO banks that was saved during suspend. This is
+ * not as simple as once thought, due to the possibility of glitches
+ * from the order that the CON and DAT registers are set in.
+ *
+ * The three states the pin can be are {IN,OUT,SFN} which gives us 9
+ * combinations of changes to check. Three of these, if the pin stays
+ * in the same configuration can be discounted. This leaves us with
+ * the following:
+ *
+ * { IN => OUT }  Change DAT first
+ * { IN => SFN }  Change CON first
+ * { OUT => SFN } Change CON first, so new data will not glitch
+ * { OUT => IN }  Change CON first, so new data will not glitch
+ * { SFN => IN }  Change CON first
+ * { SFN => OUT } Change DAT first, so new data will not glitch [1]
+ *
+ * We do not currently deal with the UP registers as these control
+ * weak resistors, so a small delay in change should not need to bring
+ * these into the calculations.
+ *
+ * [1] this assumes that writing to a pin DAT whilst in SFN will set the
+ *     state for when it is next output.
+ */
+static int samsung_pinctrl_resume_noirq(struct device *dev)
+{
+	struct samsung_pinctrl_drv_data *drvdata = dev_get_drvdata(dev);
+	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
+	void __iomem * const virt_base = drvdata->virt_base;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; i++) {
+		const struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+		void __iomem * const reg = virt_base + bank->pctl_offset;
+		const struct samsung_pin_bank_type *type = bank->type;
+		const u8 func_offset = type->reg_offset[PINCFG_TYPE_FUNC];
+		const u32 func_width = type->fld_width[PINCFG_TYPE_FUNC];
+		const u32 func_mask = (1 << func_width) - 1;
+		const bool is64bit = type->fld_width[PINCFG_TYPE_FUNC] > 4;
+		const u64 to_con = bank->pm_save.con;
+		u64 from_con = readl(reg + func_offset);
+		u64 change_mask = 0;
+		u64 to_write;
+		int pin;
+
+		if (is64bit)
+			from_con |= (u64)readl(reg + 4 + func_offset) << 32;
+
+		/* Easy--the PUD and DRV can go first */
+		writel(bank->pm_save.pud,
+		       reg + type->reg_offset[PINCFG_TYPE_PUD]);
+		writel(bank->pm_save.drv,
+		       reg + type->reg_offset[PINCFG_TYPE_DRV]);
+
+		/*
+		 * Create a change_mask of all the items that need to have
+		 * their CON value changed before their DAT value, so that
+		 * we minimise the work between the two settings.
+		 */
+		for (pin = 0; pin < bank->nr_pins; pin++) {
+			u32 shift = pin * func_width;
+			u32 from_func = (from_con >> shift) & func_mask;
+			u32 to_func = (to_con >> shift) & func_mask;
+
+			/* If there is no change, then skip */
+			if (from_func == to_func)
+				continue;
+
+			/* If both are special function, then skip */
+			if (is_sfn(from_func) && is_sfn(to_func))
+				continue;
+
+			/* Change is IN => OUT, do not change now */
+			if (is_in(from_func) && is_out(to_func))
+				continue;
+
+			/* Change is SFN => OUT, do not change now */
+			if (is_sfn(from_func) && is_out(to_func))
+				continue;
+
+			/*
+			 * We should now be at the case of:
+			 *   IN=>SFN, OUT=>SFN, OUT=>IN, SFN=>IN.
+			 */
+			change_mask |= (func_mask << shift);
+		}
+
+		/* Write the new CON settings */
+		to_write = (from_con & ~change_mask) | (to_con & change_mask);
+		writel((u32)to_write, reg + func_offset);
+		if (is64bit)
+			writel((u32)(to_write >> 32), reg + 4 + func_offset);
+
+		/* Now change any items that require DAT,CON */
+		writel(bank->pm_save.dat,
+		       reg + type->reg_offset[PINCFG_TYPE_DAT]);
+		writel((u32)to_con, reg + func_offset);
+		if (is64bit)
+			writel((u32)(to_con >> 32), reg + 4 + to_con);
+
+		if (type->fld_width[PINCFG_TYPE_CON_PDN]) {
+			writel(bank->pm_save.conpdn,
+			       reg + type->reg_offset[PINCFG_TYPE_CON_PDN]);
+			writel(bank->pm_save.pudpdn,
+			       reg + type->reg_offset[PINCFG_TYPE_PUD_PDN]);
+		}
+
+		dev_dbg(dev, "Restore %s@%p (%#010llx=>%#010llx ch %#010llx)\n",
+			bank->name, reg, from_con, to_con, change_mask);
+	}
+
+	return 0;
+}
+
+#else
+#define samsung_pinctrl_suspend_noirq	NULL
+#define samsung_pinctrl_resume_noirq	NULL
+#endif
+
+static const struct dev_pm_ops samsung_pinctrl_dev_pm_ops = {
+	.suspend_noirq = samsung_pinctrl_suspend_noirq,
+	.resume_noirq = samsung_pinctrl_resume_noirq,
+};
+
 static const struct of_device_id samsung_pinctrl_dt_match[] = {
 #ifdef CONFIG_PINCTRL_EXYNOS
 	{ .compatible = "samsung,exynos4210-pinctrl",
@@ -987,6 +1185,7 @@ static struct platform_driver samsung_pinctrl_driver = {
 		.name	= "samsung-pinctrl",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(samsung_pinctrl_dt_match),
+		.pm = &samsung_pinctrl_dev_pm_ops,
 	},
 };
 
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index 7c7f9eb..c9a7b6e 100644
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
@@ -144,6 +145,16 @@ struct samsung_pin_bank {
 	struct gpio_chip gpio_chip;
 	struct pinctrl_gpio_range grange;
 	spinlock_t slock;
+#ifdef CONFIG_PM
+	struct {
+		u64	con;
+		u32	dat;
+		u32	pud;
+		u32	drv;
+		u32	conpdn;
+		u32	pudpdn;
+	} pm_save;
+#endif
 };
 
 /**
-- 
1.8.2.1

