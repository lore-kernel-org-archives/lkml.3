Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaFRRWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:22:20 -0400
Received: from fallback7.mail.ru ([94.100.181.128]:41311 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaFRRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:22:18 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2014 13:22:17 EDT
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v2] mfd: mc13xxx: Use regmap irq framework for interrupts
Date: Wed, 18 Jun 2014 21:05:40 +0400
Message-Id: <1403111140-17056-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.5.5
X-Spam: Not detected
X-Spam: Not detected
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch convert mc13xxx MFD driver to use regmap irq framework
for interrupt registration.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/Kconfig         |   1 +
 drivers/mfd/mc13xxx-core.c  | 310 ++++++--------------------------------------
 drivers/mfd/mc13xxx.h       |  11 +-
 include/linux/mfd/mc13783.h |   1 -
 include/linux/mfd/mc13xxx.h |  23 +++-
 5 files changed, 65 insertions(+), 281 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee8204c..c7a1270 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -187,6 +187,7 @@ config MFD_MC13XXX
 	tristate
 	depends on (SPI_MASTER || I2C)
 	select MFD_CORE
+	select REGMAP_IRQ
 	help
 	  Enable support for the Freescale MC13783 and MC13892 PMICs.
 	  This driver provides common support for accessing the device,
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index acf5dd7..2b6bc86 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -10,106 +10,18 @@
  * Free Software Foundation.
  */
 
-#include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/interrupt.h>
-#include <linux/mfd/core.h>
-#include <linux/mfd/mc13xxx.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
 
 #include "mc13xxx.h"
 
 #define MC13XXX_IRQSTAT0	0
-#define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
-#define MC13XXX_IRQSTAT0_ADCBISDONEI	(1 << 1)
-#define MC13XXX_IRQSTAT0_TSI		(1 << 2)
-#define MC13783_IRQSTAT0_WHIGHI		(1 << 3)
-#define MC13783_IRQSTAT0_WLOWI		(1 << 4)
-#define MC13XXX_IRQSTAT0_CHGDETI	(1 << 6)
-#define MC13783_IRQSTAT0_CHGOVI		(1 << 7)
-#define MC13XXX_IRQSTAT0_CHGREVI	(1 << 8)
-#define MC13XXX_IRQSTAT0_CHGSHORTI	(1 << 9)
-#define MC13XXX_IRQSTAT0_CCCVI		(1 << 10)
-#define MC13XXX_IRQSTAT0_CHGCURRI	(1 << 11)
-#define MC13XXX_IRQSTAT0_BPONI		(1 << 12)
-#define MC13XXX_IRQSTAT0_LOBATLI	(1 << 13)
-#define MC13XXX_IRQSTAT0_LOBATHI	(1 << 14)
-#define MC13783_IRQSTAT0_UDPI		(1 << 15)
-#define MC13783_IRQSTAT0_USBI		(1 << 16)
-#define MC13783_IRQSTAT0_IDI		(1 << 19)
-#define MC13783_IRQSTAT0_SE1I		(1 << 21)
-#define MC13783_IRQSTAT0_CKDETI		(1 << 22)
-#define MC13783_IRQSTAT0_UDMI		(1 << 23)
-
 #define MC13XXX_IRQMASK0	1
-#define MC13XXX_IRQMASK0_ADCDONEM	MC13XXX_IRQSTAT0_ADCDONEI
-#define MC13XXX_IRQMASK0_ADCBISDONEM	MC13XXX_IRQSTAT0_ADCBISDONEI
-#define MC13XXX_IRQMASK0_TSM		MC13XXX_IRQSTAT0_TSI
-#define MC13783_IRQMASK0_WHIGHM		MC13783_IRQSTAT0_WHIGHI
-#define MC13783_IRQMASK0_WLOWM		MC13783_IRQSTAT0_WLOWI
-#define MC13XXX_IRQMASK0_CHGDETM	MC13XXX_IRQSTAT0_CHGDETI
-#define MC13783_IRQMASK0_CHGOVM		MC13783_IRQSTAT0_CHGOVI
-#define MC13XXX_IRQMASK0_CHGREVM	MC13XXX_IRQSTAT0_CHGREVI
-#define MC13XXX_IRQMASK0_CHGSHORTM	MC13XXX_IRQSTAT0_CHGSHORTI
-#define MC13XXX_IRQMASK0_CCCVM		MC13XXX_IRQSTAT0_CCCVI
-#define MC13XXX_IRQMASK0_CHGCURRM	MC13XXX_IRQSTAT0_CHGCURRI
-#define MC13XXX_IRQMASK0_BPONM		MC13XXX_IRQSTAT0_BPONI
-#define MC13XXX_IRQMASK0_LOBATLM	MC13XXX_IRQSTAT0_LOBATLI
-#define MC13XXX_IRQMASK0_LOBATHM	MC13XXX_IRQSTAT0_LOBATHI
-#define MC13783_IRQMASK0_UDPM		MC13783_IRQSTAT0_UDPI
-#define MC13783_IRQMASK0_USBM		MC13783_IRQSTAT0_USBI
-#define MC13783_IRQMASK0_IDM		MC13783_IRQSTAT0_IDI
-#define MC13783_IRQMASK0_SE1M		MC13783_IRQSTAT0_SE1I
-#define MC13783_IRQMASK0_CKDETM		MC13783_IRQSTAT0_CKDETI
-#define MC13783_IRQMASK0_UDMM		MC13783_IRQSTAT0_UDMI
-
 #define MC13XXX_IRQSTAT1	3
-#define MC13XXX_IRQSTAT1_1HZI		(1 << 0)
-#define MC13XXX_IRQSTAT1_TODAI		(1 << 1)
-#define MC13783_IRQSTAT1_ONOFD1I	(1 << 3)
-#define MC13783_IRQSTAT1_ONOFD2I	(1 << 4)
-#define MC13783_IRQSTAT1_ONOFD3I	(1 << 5)
-#define MC13XXX_IRQSTAT1_SYSRSTI	(1 << 6)
-#define MC13XXX_IRQSTAT1_RTCRSTI	(1 << 7)
-#define MC13XXX_IRQSTAT1_PCI		(1 << 8)
-#define MC13XXX_IRQSTAT1_WARMI		(1 << 9)
-#define MC13XXX_IRQSTAT1_MEMHLDI	(1 << 10)
-#define MC13783_IRQSTAT1_PWRRDYI	(1 << 11)
-#define MC13XXX_IRQSTAT1_THWARNLI	(1 << 12)
-#define MC13XXX_IRQSTAT1_THWARNHI	(1 << 13)
-#define MC13XXX_IRQSTAT1_CLKI		(1 << 14)
-#define MC13783_IRQSTAT1_SEMAFI		(1 << 15)
-#define MC13783_IRQSTAT1_MC2BI		(1 << 17)
-#define MC13783_IRQSTAT1_HSDETI		(1 << 18)
-#define MC13783_IRQSTAT1_HSLI		(1 << 19)
-#define MC13783_IRQSTAT1_ALSPTHI	(1 << 20)
-#define MC13783_IRQSTAT1_AHSSHORTI	(1 << 21)
-
 #define MC13XXX_IRQMASK1	4
-#define MC13XXX_IRQMASK1_1HZM		MC13XXX_IRQSTAT1_1HZI
-#define MC13XXX_IRQMASK1_TODAM		MC13XXX_IRQSTAT1_TODAI
-#define MC13783_IRQMASK1_ONOFD1M	MC13783_IRQSTAT1_ONOFD1I
-#define MC13783_IRQMASK1_ONOFD2M	MC13783_IRQSTAT1_ONOFD2I
-#define MC13783_IRQMASK1_ONOFD3M	MC13783_IRQSTAT1_ONOFD3I
-#define MC13XXX_IRQMASK1_SYSRSTM	MC13XXX_IRQSTAT1_SYSRSTI
-#define MC13XXX_IRQMASK1_RTCRSTM	MC13XXX_IRQSTAT1_RTCRSTI
-#define MC13XXX_IRQMASK1_PCM		MC13XXX_IRQSTAT1_PCI
-#define MC13XXX_IRQMASK1_WARMM		MC13XXX_IRQSTAT1_WARMI
-#define MC13XXX_IRQMASK1_MEMHLDM	MC13XXX_IRQSTAT1_MEMHLDI
-#define MC13783_IRQMASK1_PWRRDYM	MC13783_IRQSTAT1_PWRRDYI
-#define MC13XXX_IRQMASK1_THWARNLM	MC13XXX_IRQSTAT1_THWARNLI
-#define MC13XXX_IRQMASK1_THWARNHM	MC13XXX_IRQSTAT1_THWARNHI
-#define MC13XXX_IRQMASK1_CLKM		MC13XXX_IRQSTAT1_CLKI
-#define MC13783_IRQMASK1_SEMAFM		MC13783_IRQSTAT1_SEMAFI
-#define MC13783_IRQMASK1_MC2BM		MC13783_IRQSTAT1_MC2BI
-#define MC13783_IRQMASK1_HSDETM		MC13783_IRQSTAT1_HSDETI
-#define MC13783_IRQMASK1_HSLM		MC13783_IRQSTAT1_HSLI
-#define MC13783_IRQMASK1_ALSPTHM	MC13783_IRQSTAT1_ALSPTHI
-#define MC13783_IRQMASK1_AHSSHORTM	MC13783_IRQSTAT1_AHSSHORTI
 
 #define MC13XXX_REVISION	7
 #define MC13XXX_REVISION_REVMETAL	(0x07 <<  0)
@@ -189,45 +101,21 @@ EXPORT_SYMBOL(mc13xxx_reg_rmw);
 
 int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq)
 {
-	int ret;
-	unsigned int offmask = irq < 24 ? MC13XXX_IRQMASK0 : MC13XXX_IRQMASK1;
-	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
-	u32 mask;
-
-	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
-		return -EINVAL;
-
-	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
-	if (ret)
-		return ret;
+	int virq = regmap_irq_get_virq(mc13xxx->irq_data, irq);
 
-	if (mask & irqbit)
-		/* already masked */
-		return 0;
+	disable_irq_nosync(virq);
 
-	return mc13xxx_reg_write(mc13xxx, offmask, mask | irqbit);
+	return 0;
 }
 EXPORT_SYMBOL(mc13xxx_irq_mask);
 
 int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq)
 {
-	int ret;
-	unsigned int offmask = irq < 24 ? MC13XXX_IRQMASK0 : MC13XXX_IRQMASK1;
-	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
-	u32 mask;
-
-	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
-		return -EINVAL;
+	int virq = regmap_irq_get_virq(mc13xxx->irq_data, irq);
 
-	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
-	if (ret)
-		return ret;
+	enable_irq(virq);
 
-	if (!(mask & irqbit))
-		/* already unmasked */
-		return 0;
-
-	return mc13xxx_reg_write(mc13xxx, offmask, mask & ~irqbit);
+	return 0;
 }
 EXPORT_SYMBOL(mc13xxx_irq_unmask);
 
@@ -239,7 +127,7 @@ int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
 	unsigned int offstat = irq < 24 ? MC13XXX_IRQSTAT0 : MC13XXX_IRQSTAT1;
 	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
 
-	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
+	if (irq < 0 || irq >= ARRAY_SIZE(mc13xxx->irqs))
 		return -EINVAL;
 
 	if (enabled) {
@@ -266,147 +154,26 @@ int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
 }
 EXPORT_SYMBOL(mc13xxx_irq_status);
 
-int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq)
-{
-	unsigned int offstat = irq < 24 ? MC13XXX_IRQSTAT0 : MC13XXX_IRQSTAT1;
-	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
-
-	BUG_ON(irq < 0 || irq >= MC13XXX_NUM_IRQ);
-
-	return mc13xxx_reg_write(mc13xxx, offstat, val);
-}
-EXPORT_SYMBOL(mc13xxx_irq_ack);
-
-int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
-	BUG_ON(!handler);
-
-	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
-		return -EINVAL;
-
-	if (mc13xxx->irqhandler[irq])
-		return -EBUSY;
-
-	mc13xxx->irqhandler[irq] = handler;
-	mc13xxx->irqdata[irq] = dev;
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13xxx_irq_request_nounmask);
-
 int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
 		irq_handler_t handler, const char *name, void *dev)
 {
-	int ret;
+	int virq = regmap_irq_get_virq(mc13xxx->irq_data, irq);
 
-	ret = mc13xxx_irq_request_nounmask(mc13xxx, irq, handler, name, dev);
-	if (ret)
-		return ret;
-
-	ret = mc13xxx_irq_unmask(mc13xxx, irq);
-	if (ret) {
-		mc13xxx->irqhandler[irq] = NULL;
-		mc13xxx->irqdata[irq] = NULL;
-		return ret;
-	}
-
-	return 0;
+	return devm_request_threaded_irq(mc13xxx->dev, virq, NULL, handler,
+					 0, name, dev);
 }
 EXPORT_SYMBOL(mc13xxx_irq_request);
 
 int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev)
 {
-	int ret;
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+	int virq = regmap_irq_get_virq(mc13xxx->irq_data, irq);
 
-	if (irq < 0 || irq >= MC13XXX_NUM_IRQ || !mc13xxx->irqhandler[irq] ||
-			mc13xxx->irqdata[irq] != dev)
-		return -EINVAL;
-
-	ret = mc13xxx_irq_mask(mc13xxx, irq);
-	if (ret)
-		return ret;
-
-	mc13xxx->irqhandler[irq] = NULL;
-	mc13xxx->irqdata[irq] = NULL;
+	devm_free_irq(mc13xxx->dev, virq, dev);
 
 	return 0;
 }
 EXPORT_SYMBOL(mc13xxx_irq_free);
 
-static inline irqreturn_t mc13xxx_irqhandler(struct mc13xxx *mc13xxx, int irq)
-{
-	return mc13xxx->irqhandler[irq](irq, mc13xxx->irqdata[irq]);
-}
-
-/*
- * returns: number of handled irqs or negative error
- * locking: holds mc13xxx->lock
- */
-static int mc13xxx_irq_handle(struct mc13xxx *mc13xxx,
-		unsigned int offstat, unsigned int offmask, int baseirq)
-{
-	u32 stat, mask;
-	int ret = mc13xxx_reg_read(mc13xxx, offstat, &stat);
-	int num_handled = 0;
-
-	if (ret)
-		return ret;
-
-	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
-	if (ret)
-		return ret;
-
-	while (stat & ~mask) {
-		int irq = __ffs(stat & ~mask);
-
-		stat &= ~(1 << irq);
-
-		if (likely(mc13xxx->irqhandler[baseirq + irq])) {
-			irqreturn_t handled;
-
-			handled = mc13xxx_irqhandler(mc13xxx, baseirq + irq);
-			if (handled == IRQ_HANDLED)
-				num_handled++;
-		} else {
-			dev_err(mc13xxx->dev,
-					"BUG: irq %u but no handler\n",
-					baseirq + irq);
-
-			mask |= 1 << irq;
-
-			ret = mc13xxx_reg_write(mc13xxx, offmask, mask);
-		}
-	}
-
-	return num_handled;
-}
-
-static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
-{
-	struct mc13xxx *mc13xxx = data;
-	irqreturn_t ret;
-	int handled = 0;
-
-	mc13xxx_lock(mc13xxx);
-
-	ret = mc13xxx_irq_handle(mc13xxx, MC13XXX_IRQSTAT0,
-			MC13XXX_IRQMASK0, 0);
-	if (ret > 0)
-		handled = 1;
-
-	ret = mc13xxx_irq_handle(mc13xxx, MC13XXX_IRQSTAT1,
-			MC13XXX_IRQMASK1, 24);
-	if (ret > 0)
-		handled = 1;
-
-	mc13xxx_unlock(mc13xxx);
-
-	return IRQ_RETVAL(handled);
-}
-
 #define maskval(reg, mask)	(((reg) & (mask)) >> __ffs(mask))
 static void mc13xxx_print_revision(struct mc13xxx *mc13xxx, u32 revision)
 {
@@ -475,8 +242,6 @@ static irqreturn_t mc13xxx_handler_adcdone(int irq, void *data)
 {
 	struct mc13xxx_adcdone_data *adcdone_data = data;
 
-	mc13xxx_irq_ack(adcdone_data->mc13xxx, irq);
-
 	complete_all(&adcdone_data->done);
 
 	return IRQ_HANDLED;
@@ -544,7 +309,6 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	dev_dbg(mc13xxx->dev, "%s: request irq\n", __func__);
 	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
-	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_ADCDONE);
 
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, adc0);
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC1, adc1);
@@ -599,7 +363,8 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (!cell.name)
 		return -ENOMEM;
 
-	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0, NULL);
+	return mfd_add_devices(mc13xxx->dev, -1, &cell, 1, NULL, 0,
+			       regmap_irq_get_domain(mc13xxx->irq_data));
 }
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
@@ -640,8 +405,8 @@ int mc13xxx_common_init(struct device *dev)
 {
 	struct mc13xxx_platform_data *pdata = dev_get_platdata(dev);
 	struct mc13xxx *mc13xxx = dev_get_drvdata(dev);
-	int ret;
 	u32 revision;
+	int i, ret;
 
 	mc13xxx->dev = dev;
 
@@ -651,31 +416,32 @@ int mc13xxx_common_init(struct device *dev)
 
 	mc13xxx->variant->print_revision(mc13xxx, revision);
 
-	/* mask all irqs */
-	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
-	if (ret)
-		return ret;
+	for (i = 0; i < ARRAY_SIZE(mc13xxx->irqs); i++) {
+		mc13xxx->irqs[i].reg_offset = i / MC13XXX_IRQ_PER_REG;
+		mc13xxx->irqs[i].mask = BIT(i % MC13XXX_IRQ_PER_REG);
+	}
 
-	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
+	mc13xxx->irq_chip.name = dev_name(dev);
+	mc13xxx->irq_chip.status_base = MC13XXX_IRQSTAT0;
+	mc13xxx->irq_chip.mask_base = MC13XXX_IRQMASK0;
+	mc13xxx->irq_chip.ack_base = MC13XXX_IRQSTAT0;
+	mc13xxx->irq_chip.irq_reg_stride = MC13XXX_IRQSTAT1 - MC13XXX_IRQSTAT0;
+	mc13xxx->irq_chip.init_ack_masked = true;
+	mc13xxx->irq_chip.use_ack = true;
+	mc13xxx->irq_chip.num_regs = MC13XXX_IRQ_REG_CNT;
+	mc13xxx->irq_chip.irqs = mc13xxx->irqs;
+	mc13xxx->irq_chip.num_irqs = ARRAY_SIZE(mc13xxx->irqs);
+
+	ret = regmap_add_irq_chip(mc13xxx->regmap, mc13xxx->irq, IRQF_ONESHOT,
+				  0, &mc13xxx->irq_chip, &mc13xxx->irq_data);
 	if (ret)
 		return ret;
 
 	mutex_init(&mc13xxx->lock);
 
-	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
-			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
-	if (ret)
-		return ret;
-
 	if (mc13xxx_probe_flags_dt(mc13xxx) < 0 && pdata)
 		mc13xxx->flags = pdata->flags;
 
-	if (mc13xxx->flags & MC13XXX_USE_ADC)
-		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
-
-	if (mc13xxx->flags & MC13XXX_USE_RTC)
-		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
-
 	if (pdata) {
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-regulator",
 			&pdata->regulators, sizeof(pdata->regulators));
@@ -699,6 +465,12 @@ int mc13xxx_common_init(struct device *dev)
 			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
 	}
 
+	if (mc13xxx->flags & MC13XXX_USE_ADC)
+		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
+
+	if (mc13xxx->flags & MC13XXX_USE_RTC)
+		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mc13xxx_common_init);
@@ -707,8 +479,8 @@ int mc13xxx_common_exit(struct device *dev)
 {
 	struct mc13xxx *mc13xxx = dev_get_drvdata(dev);
 
-	free_irq(mc13xxx->irq, mc13xxx);
 	mfd_remove_devices(dev);
+	regmap_del_irq_chip(mc13xxx->irq, mc13xxx->irq_data);
 	mutex_destroy(&mc13xxx->lock);
 
 	return 0;
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
index ae7f165..33677d1 100644
--- a/drivers/mfd/mc13xxx.h
+++ b/drivers/mfd/mc13xxx.h
@@ -13,7 +13,9 @@
 #include <linux/regmap.h>
 #include <linux/mfd/mc13xxx.h>
 
-#define MC13XXX_NUMREGS 0x3f
+#define MC13XXX_NUMREGS		0x3f
+#define MC13XXX_IRQ_REG_CNT	2
+#define MC13XXX_IRQ_PER_REG	24
 
 struct mc13xxx;
 
@@ -33,13 +35,14 @@ struct mc13xxx {
 	struct device *dev;
 	const struct mc13xxx_variant *variant;
 
+	struct regmap_irq irqs[MC13XXX_IRQ_PER_REG * MC13XXX_IRQ_REG_CNT];
+	struct regmap_irq_chip irq_chip;
+	struct regmap_irq_chip_data *irq_data;
+
 	struct mutex lock;
 	int irq;
 	int flags;
 
-	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
-	void *irqdata[MC13XXX_NUM_IRQ];
-
 	int adcflags;
 };
 
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index a8eeda7..4ff6137 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -86,6 +86,5 @@
 #define MC13783_IRQ_HSL		43
 #define MC13783_IRQ_ALSPTH	44
 #define MC13783_IRQ_AHSSHORT	45
-#define MC13783_NUM_IRQ		MC13XXX_NUM_IRQ
 
 #endif /* ifndef __LINUX_MFD_MC13783_H */
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index d63b1d3..638222e 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -23,15 +23,10 @@ int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
 
 int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
 		irq_handler_t handler, const char *name, void *dev);
-int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
-		irq_handler_t handler, const char *name, void *dev);
 int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev);
 
-int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq);
-int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq);
 int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
 		int *enabled, int *pending);
-int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq);
 
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
 
@@ -39,6 +34,22 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
 		unsigned int mode, unsigned int channel,
 		u8 ato, bool atox, unsigned int *sample);
 
+/* Deprecated calls */
+static inline int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq)
+{
+	return 0;
+}
+
+static inline int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
+					       irq_handler_t handler,
+					       const char *name, void *dev)
+{
+	return mc13xxx_irq_request(mc13xxx, irq, handler, name, dev);
+}
+
+int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq);
+int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq);
+
 #define MC13783_AUDIO_RX0	36
 #define MC13783_AUDIO_RX1	37
 #define MC13783_AUDIO_TX	38
@@ -68,8 +79,6 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
 #define MC13XXX_IRQ_THWARNH	37
 #define MC13XXX_IRQ_CLK		38
 
-#define MC13XXX_NUM_IRQ		46
-
 struct regulator_init_data;
 
 struct mc13xxx_regulator_init_data {
-- 
1.8.5.5

