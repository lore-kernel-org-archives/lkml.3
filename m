Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaJJKsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:48:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44996 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaJJKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:48:47 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b3-5437b98b3b3b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH fixes v2] mfd: max77693: Fix always masked MUIC interrupts
Date: Fri, 10 Oct 2014 12:48:35 +0200
Message-id: <1412938115-11606-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xa7rdO81DDHbNUbbYOGM9q8X1L89Z
	LV6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF7cYVbBanu1ktFmx8xOjA5XHn2h42j3knAz36
	tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48asVsaCP6IVrx98Y2xgXCLUxcjJISFgIrH7wQlW
	CFtM4sK99WxdjFwcQgJLGSVu3b3MDOH0MUmcn7WOCaSKTcBYYvPyJWBVIgK7GSW+7V3EBOIw
	C9xllGi++54RpEpYwEvi0JxtYHNZBFQl5jW+YQGxeQXcJfq7lzBD7JOTOHlsMusERu4FjAyr
	GEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIC5+sOxqXHrA4xCnAwKvHwXpAxDxFiTSwrrsw9
	xCjBwawkwqu7BSjEm5JYWZValB9fVJqTWnyIkYmDU6qBcfV5lx97hWakbO5lvP+s5rCSm230
	054CnlW50nknc/ok23v4rr/b2HDk0eON1Sbrd7M+abeYvixc74bci6PfFste+Lv5bMxKjkf/
	VAw2lZtv1J27UjH+kIxPsYK45J9vu6cfd3os0rdo7snU/g7mh0s0dYUrrGfkMi/vCdr4eskt
	xX7PqCkVvkosxRmJhlrMRcWJAL19hhP6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All interrupts coming from MUIC were ignored because interrupt source
register was masked.

The Maxim 77693 has a "interrupt source" - a separate register and interrupts
which give information about PMIC block triggering the individual
interrupt (charger, topsys, MUIC, flash LED).

By default bootloader could initialize this register to "mask all"
value. In such case (observed on Trats2 board) MUIC interrupts won't be
generated regardless of their mask status. Regmap irq chip was unmasking
individual MUIC interrupts but the source was masked

Before introducing regmap irq chip this interrupt source was unmasked,
read and acked. Reading and acking is not necessary but unmasking is.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")

---

Changes since v1:
1. Do the unmasking in main MFD driver. Additionally unmask all
   interrupts, not only MUIC. Suggested by Chanwoo Choi.
---
 drivers/mfd/max77693.c               | 12 ++++++++++++
 include/linux/mfd/max77693-private.h |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 4b54da1ff7ab..4e4e6a1a6301 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -253,6 +253,17 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		goto err_irq_muic;
 	}
 
+	/* Unmask interrupts from all blocks in interrupt source register */
+	ret = regmap_update_bits(max77693->regmap,
+				MAX77693_PMIC_REG_INTSRC_MASK,
+				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
+	if (ret < 0) {
+		dev_err(max77693->dev,
+			"Could not unmask interrupts in INTSRC: %d\n",
+			ret);
+		goto err_intsrc;
+	}
+
 	pm_runtime_set_active(max77693->dev);
 
 	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
@@ -264,6 +275,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 
 err_mfd:
 	mfd_remove_devices(max77693->dev);
+err_intsrc:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
 err_irq_muic:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index e1b2b61285b9..15fed5365a20 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -438,6 +438,13 @@ enum max77693_irq_source {
 	MAX77693_IRQ_GROUP_NR,
 };
 
+#define SRC_IRQ_CHARGER			BIT(0)
+#define SRC_IRQ_TOP			BIT(1)
+#define SRC_IRQ_FLASH			BIT(2)
+#define SRC_IRQ_MUIC			BIT(3)
+#define SRC_IRQ_ALL			(SRC_IRQ_CHARGER | SRC_IRQ_TOP \
+						| SRC_IRQ_FLASH | SRC_IRQ_MUIC)
+
 #define LED_IRQ_FLED2_OPEN		BIT(0)
 #define LED_IRQ_FLED2_SHORT		BIT(1)
 #define LED_IRQ_FLED1_OPEN		BIT(2)
-- 
1.9.1

