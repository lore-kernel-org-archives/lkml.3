Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3EPRMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:12:44 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:50010 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3EPRMj (ORCPT
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
Subject: [PATCH 2/2] pinctrl: exynos: fix eint wakeup by using irq_set_wake()
Date: Thu, 16 May 2013 10:12:32 -0700
Message-Id: <1368724352-10849-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368724352-10849-1-git-send-email-dianders@chromium.org>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prathyush K <prathyush.k@samsung.com>

Add the irq_set_wake function for exynos pinctrl to configure the
external interrupt wakeup mask register.

[dianders: minor nit fixes; port to ToT]

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-exynos.c  | 45 ++++++++++++++++++++++++++++-----------
 drivers/pinctrl/pinctrl-exynos.h  |  3 ++-
 drivers/pinctrl/pinctrl-samsung.h |  2 ++
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index ac74281..3ebb2ff 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -30,6 +30,8 @@
 #include <linux/spinlock.h>
 #include <linux/err.h>
 
+#include <plat/pm.h>
+
 #include "pinctrl-samsung.h"
 #include "pinctrl-exynos.h"
 
@@ -326,6 +328,24 @@ static int exynos_wkup_irq_set_type(struct irq_data *irqd, unsigned int type)
 	return 0;
 }
 
+static int exynos_wkup_irq_set_wake(struct irq_data *irqd, unsigned int state)
+{
+	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
+	const int eint_num = bank->eint_base + irqd->hwirq;
+	unsigned long bit = 1L << eint_num;
+
+	pr_info("wake %s for eint %d / %s[%ld]\n",
+		state ? "enabled" : "disabled",
+		eint_num, bank->name, irqd->hwirq);
+
+	if (!state)
+		s3c_irqwake_eintmask |= bit;
+	else
+		s3c_irqwake_eintmask &= ~bit;
+
+	return 0;
+}
+
 /*
  * irq_chip for wakeup interrupts
  */
@@ -335,6 +355,7 @@ static struct irq_chip exynos_wkup_irq_chip = {
 	.irq_mask	= exynos_wkup_irq_mask,
 	.irq_ack	= exynos_wkup_irq_ack,
 	.irq_set_type	= exynos_wkup_irq_set_type,
+	.irq_set_wake	= exynos_wkup_irq_set_wake,
 };
 
 /* interrupt handler for wakeup interrupts 0..15 */
@@ -543,10 +564,10 @@ static struct samsung_pin_bank exynos4210_pin_banks1[] = {
 	EXYNOS_PIN_BANK_EINTN(8, 0x1A0, "gpy4"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x1C0, "gpy5"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x1E0, "gpy6"),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00, 0),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04, 8),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08, 16),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c, 24),
 };
 
 /* pin banks of exynos4210 pin-controller 2 */
@@ -629,10 +650,10 @@ static struct samsung_pin_bank exynos4x12_pin_banks1[] = {
 	EXYNOS_PIN_BANK_EINTN(8, 0x1A0, "gpy4"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x1C0, "gpy5"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x1E0, "gpy6"),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00, 0),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04, 8),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08, 16),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c, 24),
 };
 
 /* pin banks of exynos4x12 pin-controller 2 */
@@ -724,10 +745,10 @@ static struct samsung_pin_bank exynos5250_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTN(8, 0x220, "gpy4"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x240, "gpy5"),
 	EXYNOS_PIN_BANK_EINTN(8, 0x260, "gpy6"),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
-	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00, 0),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04, 8),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08, 16),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c, 24),
 };
 
 /* pin banks of exynos5250 pin-controller 1 */
diff --git a/drivers/pinctrl/pinctrl-exynos.h b/drivers/pinctrl/pinctrl-exynos.h
index 9b1f77a..d98e9ff 100644
--- a/drivers/pinctrl/pinctrl-exynos.h
+++ b/drivers/pinctrl/pinctrl-exynos.h
@@ -65,13 +65,14 @@
 		.name		= id			\
 	}
 
-#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs)	\
+#define EXYNOS_PIN_BANK_EINTW(pins, reg, id, offs, base)\
 	{						\
 		.type		= &bank_type_alive,	\
 		.pctl_offset	= reg,			\
 		.nr_pins	= pins,			\
 		.eint_type	= EINT_TYPE_WKUP,	\
 		.eint_offset	= offs,			\
+		.eint_base	= base,			\
 		.name		= id			\
 	}
 
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index c9a7b6e..1e033ae 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -120,6 +120,7 @@ struct samsung_pin_bank_type {
  * @eint_func: function to set in CON register to configure pin as EINT.
  * @eint_type: type of the external interrupt supported by the bank.
  * @eint_mask: bit mask of pins which support EINT function.
+ * @eint_base: number of external wakeup interrupts from start to this bank.
  * @name: name to be prefixed for each pin in this pin bank.
  * @of_node: OF node of the bank.
  * @drvdata: link to controller driver data
@@ -138,6 +139,7 @@ struct samsung_pin_bank {
 	enum eint_type	eint_type;
 	u32		eint_mask;
 	u32		eint_offset;
+	u32		eint_base;
 	char		*name;
 	struct device_node *of_node;
 	struct samsung_pinctrl_drv_data *drvdata;
-- 
1.8.2.1

