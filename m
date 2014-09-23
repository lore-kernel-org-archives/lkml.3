Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaIWTGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:06:21 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34827 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbaIWTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:56 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 5/5] pinctrl: samsung: Separate per-bank init and runtime data
Date: Tue, 23 Sep 2014 21:05:41 +0200
Message-Id: <1411499141-26551-6-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver mixes constant init data with runtime data, which
is far from being elegant and can invite potential hard to track issues.
This patch intends to solve this by introducing a new
samsung_pin_bank_data structure to hold only constant data known at
compile time, which can be copied to main samsung_pin_bank struct used
at runtime.

In addition, thanks to this change, all per-bank initdata can be marked
with const and __initconst keywords and dropped after init completes.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 44 +++++++++++++++----------------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  8 +++---
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  2 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c | 18 +++++++++++--
 drivers/pinctrl/samsung/pinctrl-samsung.h | 33 ++++++++++++++++++++---
 5 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 552f7c75243d..b4490cb2a439 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -633,7 +633,7 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
 }
 
 /* pin banks of s5pv210 pin-controller */
-static struct samsung_pin_bank s5pv210_pin_bank[] = {
+static const struct samsung_pin_bank_data s5pv210_pin_bank[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
@@ -683,7 +683,7 @@ const struct samsung_pin_ctrl s5pv210_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos3250 pin-controller 0 */
-static struct samsung_pin_bank exynos3250_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos3250_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb",  0x08),
@@ -694,7 +694,7 @@ static struct samsung_pin_bank exynos3250_pin_banks0[] = {
 };
 
 /* pin banks of exynos3250 pin-controller 1 */
-static struct samsung_pin_bank exynos3250_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos3250_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTN(8, 0x120, "gpe0"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x140, "gpe1"),
 	EXYNOS_PIN_BANK_EINTN(3, 0x180, "gpe2"),
@@ -737,7 +737,7 @@ const struct samsung_pin_ctrl exynos3250_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos4210 pin-controller 0 */
-static struct samsung_pin_bank exynos4210_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos4210_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
@@ -757,7 +757,7 @@ static struct samsung_pin_bank exynos4210_pin_banks0[] = {
 };
 
 /* pin banks of exynos4210 pin-controller 1 */
-static struct samsung_pin_bank exynos4210_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos4210_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpj0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpj1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(7, 0x040, "gpk0", 0x08),
@@ -781,7 +781,7 @@ static struct samsung_pin_bank exynos4210_pin_banks1[] = {
 };
 
 /* pin banks of exynos4210 pin-controller 2 */
-static struct samsung_pin_bank exynos4210_pin_banks2[] = {
+static const struct samsung_pin_bank_data exynos4210_pin_banks2[] __initconst = {
 	EXYNOS_PIN_BANK_EINTN(7, 0x000, "gpz"),
 };
 
@@ -813,7 +813,7 @@ const struct samsung_pin_ctrl exynos4210_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos4x12 pin-controller 0 */
-static struct samsung_pin_bank exynos4x12_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos4x12_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
@@ -830,7 +830,7 @@ static struct samsung_pin_bank exynos4x12_pin_banks0[] = {
 };
 
 /* pin banks of exynos4x12 pin-controller 1 */
-static struct samsung_pin_bank exynos4x12_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos4x12_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x040, "gpk0", 0x08),
 	EXYNOS_PIN_BANK_EINTG(7, 0x060, "gpk1", 0x0c),
 	EXYNOS_PIN_BANK_EINTG(7, 0x080, "gpk2", 0x10),
@@ -857,12 +857,12 @@ static struct samsung_pin_bank exynos4x12_pin_banks1[] = {
 };
 
 /* pin banks of exynos4x12 pin-controller 2 */
-static struct samsung_pin_bank exynos4x12_pin_banks2[] = {
+static const struct samsung_pin_bank_data exynos4x12_pin_banks2[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
 };
 
 /* pin banks of exynos4x12 pin-controller 3 */
-static struct samsung_pin_bank exynos4x12_pin_banks3[] = {
+static const struct samsung_pin_bank_data exynos4x12_pin_banks3[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpv0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpv1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpv2", 0x08),
@@ -908,7 +908,7 @@ const struct samsung_pin_ctrl exynos4x12_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos5250 pin-controller 0 */
-static struct samsung_pin_bank exynos5250_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos5250_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpa2", 0x08),
@@ -937,7 +937,7 @@ static struct samsung_pin_bank exynos5250_pin_banks0[] = {
 };
 
 /* pin banks of exynos5250 pin-controller 1 */
-static struct samsung_pin_bank exynos5250_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos5250_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpe0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(2, 0x020, "gpe1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(4, 0x040, "gpf0", 0x08),
@@ -950,7 +950,7 @@ static struct samsung_pin_bank exynos5250_pin_banks1[] = {
 };
 
 /* pin banks of exynos5250 pin-controller 2 */
-static struct samsung_pin_bank exynos5250_pin_banks2[] = {
+static const struct samsung_pin_bank_data exynos5250_pin_banks2[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpv0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpv1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpv2", 0x08),
@@ -959,7 +959,7 @@ static struct samsung_pin_bank exynos5250_pin_banks2[] = {
 };
 
 /* pin banks of exynos5250 pin-controller 3 */
-static struct samsung_pin_bank exynos5250_pin_banks3[] = {
+static const struct samsung_pin_bank_data exynos5250_pin_banks3[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
 };
 
@@ -1001,7 +1001,7 @@ const struct samsung_pin_ctrl exynos5250_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos5260 pin-controller 0 */
-static struct samsung_pin_bank exynos5260_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos5260_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpa2", 0x08),
@@ -1026,7 +1026,7 @@ static struct samsung_pin_bank exynos5260_pin_banks0[] = {
 };
 
 /* pin banks of exynos5260 pin-controller 1 */
-static struct samsung_pin_bank exynos5260_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos5260_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpc0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpc1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(7, 0x040, "gpc2", 0x08),
@@ -1035,7 +1035,7 @@ static struct samsung_pin_bank exynos5260_pin_banks1[] = {
 };
 
 /* pin banks of exynos5260 pin-controller 2 */
-static struct samsung_pin_bank exynos5260_pin_banks2[] = {
+static const struct samsung_pin_bank_data exynos5260_pin_banks2[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
 };
@@ -1065,7 +1065,7 @@ const struct samsung_pin_ctrl exynos5260_pin_ctrl[] __initconst = {
 };
 
 /* pin banks of exynos5420 pin-controller 0 */
-static struct samsung_pin_bank exynos5420_pin_banks0[] = {
+static const struct samsung_pin_bank_data exynos5420_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpy7", 0x00),
 	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
 	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
@@ -1074,7 +1074,7 @@ static struct samsung_pin_bank exynos5420_pin_banks0[] = {
 };
 
 /* pin banks of exynos5420 pin-controller 1 */
-static struct samsung_pin_bank exynos5420_pin_banks1[] = {
+static const struct samsung_pin_bank_data exynos5420_pin_banks1[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpc0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpc1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(7, 0x040, "gpc2", 0x08),
@@ -1091,7 +1091,7 @@ static struct samsung_pin_bank exynos5420_pin_banks1[] = {
 };
 
 /* pin banks of exynos5420 pin-controller 2 */
-static struct samsung_pin_bank exynos5420_pin_banks2[] = {
+static const struct samsung_pin_bank_data exynos5420_pin_banks2[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpe0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(2, 0x020, "gpe1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(6, 0x040, "gpf0", 0x08),
@@ -1103,7 +1103,7 @@ static struct samsung_pin_bank exynos5420_pin_banks2[] = {
 };
 
 /* pin banks of exynos5420 pin-controller 3 */
-static struct samsung_pin_bank exynos5420_pin_banks3[] = {
+static const struct samsung_pin_bank_data exynos5420_pin_banks3[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
 	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpa2", 0x08),
@@ -1116,7 +1116,7 @@ static struct samsung_pin_bank exynos5420_pin_banks3[] = {
 };
 
 /* pin banks of exynos5420 pin-controller 4 */
-static struct samsung_pin_bank exynos5420_pin_banks4[] = {
+static const struct samsung_pin_bank_data exynos5420_pin_banks4[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
 };
 
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
index c0c7924657e6..f1993f42114c 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -561,7 +561,7 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_drv_data *d)
 	return 0;
 }
 
-static struct samsung_pin_bank s3c2412_pin_banks[] = {
+static const struct samsung_pin_bank_data s3c2412_pin_banks[] __initconst = {
 	PIN_BANK_A(23, 0x000, "gpa"),
 	PIN_BANK_2BIT(11, 0x010, "gpb"),
 	PIN_BANK_2BIT(16, 0x020, "gpc"),
@@ -581,7 +581,7 @@ const struct samsung_pin_ctrl s3c2412_pin_ctrl[] __initconst = {
 	},
 };
 
-static struct samsung_pin_bank s3c2416_pin_banks[] = {
+static const struct samsung_pin_bank_data s3c2416_pin_banks[] __initconst = {
 	PIN_BANK_A(27, 0x000, "gpa"),
 	PIN_BANK_2BIT(11, 0x010, "gpb"),
 	PIN_BANK_2BIT(16, 0x020, "gpc"),
@@ -603,7 +603,7 @@ const struct samsung_pin_ctrl s3c2416_pin_ctrl[] __initconst = {
 	},
 };
 
-static struct samsung_pin_bank s3c2440_pin_banks[] = {
+static const struct samsung_pin_bank_data s3c2440_pin_banks[] __initconst = {
 	PIN_BANK_A(25, 0x000, "gpa"),
 	PIN_BANK_2BIT(11, 0x010, "gpb"),
 	PIN_BANK_2BIT(16, 0x020, "gpc"),
@@ -623,7 +623,7 @@ const struct samsung_pin_ctrl s3c2440_pin_ctrl[] __initconst = {
 	},
 };
 
-static struct samsung_pin_bank s3c2450_pin_banks[] = {
+static const struct samsung_pin_bank_data s3c2450_pin_banks[] __initconst = {
 	PIN_BANK_A(28, 0x000, "gpa"),
 	PIN_BANK_2BIT(11, 0x010, "gpb"),
 	PIN_BANK_2BIT(16, 0x020, "gpc"),
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
index 14c3f9823cc5..7756c1e9e763 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -780,7 +780,7 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 }
 
 /* pin banks of s3c64xx pin-controller 0 */
-static struct samsung_pin_bank s3c64xx_pin_banks0[] = {
+static const struct samsung_pin_bank_data s3c64xx_pin_banks0[] __initconst = {
 	PIN_BANK_4BIT_EINTG(8, 0x000, "gpa", 0),
 	PIN_BANK_4BIT_EINTG(7, 0x020, "gpb", 8),
 	PIN_BANK_4BIT_EINTG(8, 0x040, "gpc", 16),
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index e46fd0a25de7..04fabbd6c58a 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -979,6 +979,7 @@ samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
 	const struct of_device_id *match;
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *np;
+	const struct samsung_pin_bank_data *bdata;
 	const struct samsung_pin_ctrl *ctrl;
 	struct samsung_pin_bank *bank;
 	int i;
@@ -993,11 +994,24 @@ samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
 
 	d->suspend = ctrl->suspend;
 	d->resume = ctrl->resume;
-	d->pin_banks = ctrl->pin_banks;
 	d->nr_banks = ctrl->nr_banks;
+	d->pin_banks = devm_kcalloc(&pdev->dev, d->nr_banks,
+					sizeof(*d->pin_banks), GFP_KERNEL);
+	if (!d->pin_banks)
+		return ERR_PTR(-ENOMEM);
 
 	bank = d->pin_banks;
-	for (i = 0; i < d->nr_banks; ++i, ++bank) {
+	bdata = ctrl->pin_banks;
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bdata, ++bank) {
+		bank->type = bdata->type;
+		bank->pctl_offset = bdata->pctl_offset;
+		bank->nr_pins = bdata->nr_pins;
+		bank->eint_func = bdata->eint_func;
+		bank->eint_type = bdata->eint_type;
+		bank->eint_mask = bdata->eint_mask;
+		bank->eint_offset = bdata->eint_offset;
+		bank->name = bdata->name;
+
 		spin_lock_init(&bank->slock);
 		bank->drvdata = d;
 		bank->pin_base = d->nr_pins;
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index cf2d61d0f001..ec43b7d49fb9 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -113,15 +113,39 @@ struct samsung_pin_bank_type {
 };
 
 /**
+ * struct samsung_pin_bank_data: represent a controller pin-bank (init data).
+ * @type: type of the bank (register offsets and bitfield widths)
+ * @pctl_offset: starting offset of the pin-bank registers.
+ * @nr_pins: number of pins included in this bank.
+ * @eint_func: function to set in CON register to configure pin as EINT.
+ * @eint_type: type of the external interrupt supported by the bank.
+ * @eint_mask: bit mask of pins which support EINT function.
+ * @eint_offset: SoC-specific EINT register or interrupt offset of bank.
+ * @name: name to be prefixed for each pin in this pin bank.
+ */
+struct samsung_pin_bank_data {
+	const struct samsung_pin_bank_type *type;
+	u32		pctl_offset;
+	u8		nr_pins;
+	u8		eint_func;
+	enum eint_type	eint_type;
+	u32		eint_mask;
+	u32		eint_offset;
+	const char	*name;
+};
+
+/**
  * struct samsung_pin_bank: represent a controller pin-bank.
  * @type: type of the bank (register offsets and bitfield widths)
  * @pctl_offset: starting offset of the pin-bank registers.
- * @pin_base: starting pin number of the bank.
  * @nr_pins: number of pins included in this bank.
  * @eint_func: function to set in CON register to configure pin as EINT.
  * @eint_type: type of the external interrupt supported by the bank.
  * @eint_mask: bit mask of pins which support EINT function.
+ * @eint_offset: SoC-specific EINT register or interrupt offset of bank.
  * @name: name to be prefixed for each pin in this pin bank.
+ * @pin_base: starting pin number of the bank.
+ * @soc_priv: per-bank private data for SoC-specific code.
  * @of_node: OF node of the bank.
  * @drvdata: link to controller driver data
  * @irq_domain: IRQ domain of the bank.
@@ -133,13 +157,14 @@ struct samsung_pin_bank_type {
 struct samsung_pin_bank {
 	const struct samsung_pin_bank_type *type;
 	u32		pctl_offset;
-	u32		pin_base;
 	u8		nr_pins;
 	u8		eint_func;
 	enum eint_type	eint_type;
 	u32		eint_mask;
 	u32		eint_offset;
-	char		*name;
+	const char	*name;
+
+	u32		pin_base;
 	void		*soc_priv;
 	struct device_node *of_node;
 	struct samsung_pinctrl_drv_data *drvdata;
@@ -161,7 +186,7 @@ struct samsung_pin_bank {
  *	interrupts for the controller.
  */
 struct samsung_pin_ctrl {
-	struct samsung_pin_bank	*pin_banks;
+	const struct samsung_pin_bank_data *pin_banks;
 	u32		nr_banks;
 
 	int		(*eint_gpio_init)(struct samsung_pinctrl_drv_data *);
-- 
2.1.0

