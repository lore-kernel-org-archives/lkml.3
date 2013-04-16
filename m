Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514Ab3DPNob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:44:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934991Ab3DPNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:44:30 -0400
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <liam.r.girdwood@intel.com>, <navada@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH V2 2/4] mfd: Interrupt handling support for AIC family
Date: Tue, 16 Apr 2013 19:14:20 +0530
Message-ID: <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
References: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides Interrupt handling features for common interface
to series of low power AIC audio CODECS.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig                     |   13 ++
 drivers/mfd/Makefile                    |    1 +
 drivers/mfd/tlv320aic-irq.c             |  234 +++++++++++++++++++++++++++++++
 include/linux/mfd/tlv320aic-core.h      |   49 ++++++-
 include/linux/mfd/tlv320aic-registers.h |   57 ++++++++
 5 files changed, 348 insertions(+), 6 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 629d374..3019897 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -58,6 +58,19 @@ config MFD_AIC
 	  you have to select individual components like codec device
 	  to use AIC features.
 
+menu "AIC Interface Drivers"
+	depends on MFD_AIC
+
+config MFD_AIC_IRQ
+	bool "Support of IRQ for AIC"
+	depends on MFD_AIC
+	help
+	  Say yes here if you want support of IRQ for Texas Instruments
+	  AIC codec family.
+	  You have to select individual components like codec device
+	  under the corresponding menus.
+endmenu
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b975c94..3b39454 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
 obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
+obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-irq.c b/drivers/mfd/tlv320aic-irq.c
new file mode 100644
index 0000000..e299495
--- /dev/null
+++ b/drivers/mfd/tlv320aic-irq.c
@@ -0,0 +1,234 @@
+/*
+ * tlv320aic-irq.c  --  Interrupt controller support for
+ *			 TI TLV320AIC family
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+#include <linux/mfd/tlv320aic-registers.h>
+
+#include <linux/delay.h>
+
+struct aic_irq_data {
+	int mask;
+	int status;
+};
+
+static struct aic_irq_data aic_irqs[] = {
+	{
+	 .mask = AIC_HEADSET_IN_M,
+	 .status = AIC_HEADSET_PLUG_UNPLUG_INT,
+	 },
+	{
+	 .mask = AIC_BUTTON_PRESS_M,
+	 .status = AIC_BUTTON_PRESS_INT,
+	 },
+	{
+	 .mask = AIC_DAC_DRC_THRES_M,
+	 .status = AIC_LEFT_DRC_THRES_INT | AIC_RIGHT_DRC_THRES_INT,
+	 },
+	{
+	 .mask = AIC_AGC_NOISE_M,
+	 .status = AIC_LEFT_AGC_NOISE_INT | AIC_RIGHT_AGC_NOISE_INT,
+	 },
+	{
+	 .mask = AIC_OVER_CURRENT_M,
+	 .status = AIC_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT
+	 | AIC_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT,
+	 },
+	{
+	 .mask = AIC_OVERFLOW_M,
+	 .status =
+	 AIC_LEFT_DAC_OVERFLOW_INT | AIC_RIGHT_DAC_OVERFLOW_INT |
+	 AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT |
+	 AIC_LEFT_ADC_OVERFLOW_INT | AIC_RIGHT_ADC_OVERFLOW_INT |
+	 AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT,
+	 },
+	{
+	 .mask = AIC_SPK_OVERCURRENT_M,
+	 .status = AIC_SPK_OVER_CURRENT_INT,
+	 },
+
+};
+
+static void aic_irq_lock(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&aic->irq_lock);
+}
+
+static void aic_irq_sync_unlock(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+
+	/* write back to hardware any change in irq mask */
+	if (aic->irq_masks_cur != aic->irq_masks_cache) {
+		aic->irq_masks_cache = aic->irq_masks_cur;
+		aic_reg_write(aic, AIC_INT1_CNTL,
+				  aic->irq_masks_cur);
+	}
+
+	mutex_unlock(&aic->irq_lock);
+}
+
+
+static void aic_irq_enable(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+	struct aic_irq_data *irq_data = &aic_irqs[data->hwirq];
+	aic->irq_masks_cur |= irq_data->mask;
+}
+
+static void aic_irq_disable(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+	struct aic_irq_data *irq_data = &aic_irqs[data->hwirq];
+
+	aic->irq_masks_cur &= ~irq_data->mask;
+}
+
+static struct irq_chip aic_irq_chip = {
+	.name = "tlv320aic",
+	.irq_bus_lock = aic_irq_lock,
+	.irq_bus_sync_unlock = aic_irq_sync_unlock,
+	.irq_enable = aic_irq_enable,
+	.irq_disable = aic_irq_disable
+};
+
+static irqreturn_t aic_irq_thread(int irq, void *data)
+{
+	struct aic *aic = data;
+	u8 status[4];
+
+	/* Reading sticky bit registers acknowledges
+		the interrupt to the device */
+	aic_bulk_read(aic, AIC_INT_STICKY_FLAG1, 4, status);
+
+	/* report  */
+	if (status[2] & aic_irqs[AIC_IRQ_HEADSET_DETECT].status)
+		handle_nested_irq(aic->irq_base);
+	if (status[2] & aic_irqs[AIC_IRQ_BUTTON_PRESS].status)
+		handle_nested_irq(aic->irq_base + 1);
+	if (status[2] & aic_irqs[AIC_IRQ_DAC_DRC].status)
+		handle_nested_irq(aic->irq_base + 2);
+	if (status[3] & aic_irqs[AIC_IRQ_AGC_NOISE].status)
+		handle_nested_irq(aic->irq_base + 3);
+	if (status[2] & aic_irqs[AIC_IRQ_OVER_CURRENT].status)
+		handle_nested_irq(aic->irq_base + 4);
+	if (status[0] & aic_irqs[AIC_IRQ_OVERFLOW_EVENT].status)
+		handle_nested_irq(aic->irq_base + 5);
+	if (status[3] & aic_irqs[AIC_IRQ_SPEAKER_OVER_TEMP].status)
+		handle_nested_irq(aic->irq_base + 6);
+
+	return IRQ_HANDLED;
+}
+
+static int aic_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct aic *aic = h->host_data;
+
+	irq_set_chip_data(virq, aic);
+	irq_set_chip_and_handler(virq, &aic_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static const struct irq_domain_ops aic_domain_ops = {
+	.map    = aic_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
+};
+
+int aic_irq_init(struct aic *aic)
+{
+	int ret;
+
+	mutex_init(&aic->irq_lock);
+
+	/* mask the individual interrupt sources */
+	aic->irq_masks_cur = 0x0;
+	aic->irq_masks_cache = 0x0;
+	aic_reg_write(aic, AIC_INT1_CNTL, 0x0);
+
+	if (!aic->irq) {
+		dev_warn(aic->dev, "no interrupt specified\n");
+		aic->irq_base = 0;
+		return 0;
+	}
+	if (aic->irq_base) {
+		aic->domain = irq_domain_add_legacy(aic->dev->of_node,
+					ARRAY_SIZE(aic_irqs),
+					aic->irq_base, 0,
+					&aic_domain_ops, aic);
+	} else {
+		aic->domain = irq_domain_add_linear(aic->dev->of_node,
+					ARRAY_SIZE(aic_irqs),
+					&aic_domain_ops, aic);
+		/* initiallizing irq_base from irq_domain*/
+	}
+	if (!aic->domain) {
+		dev_err(aic->dev, "Failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	aic->irq_base = irq_create_mapping(aic->domain, 0);
+
+	ret = request_threaded_irq(aic->irq, NULL, aic_irq_thread,
+				   IRQF_ONESHOT,
+				   "tlv320aic", aic);
+	if (ret < 0) {
+		dev_err(aic->dev, "failed to request IRQ %d: %d\n",
+			aic->irq, ret);
+		return ret;
+	}
+	irq_set_irq_type(aic->irq, IRQF_TRIGGER_RISING);
+
+	return 0;
+}
+EXPORT_SYMBOL(aic_irq_init);
+
+void aic_irq_exit(struct aic *aic)
+{
+	if (aic->irq)
+		free_irq(aic->irq, aic);
+}
+EXPORT_SYMBOL(aic_irq_exit);
+MODULE_AUTHOR("Mukund navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_DESCRIPTION("Interrupt controller support for TI TLV320AIC family");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tlv320aic-core.h b/include/linux/mfd/tlv320aic-core.h
index 60d7146..66a46fb 100644
--- a/include/linux/mfd/tlv320aic-core.h
+++ b/include/linux/mfd/tlv320aic-core.h
@@ -23,12 +23,22 @@
 #ifndef __MFD_AIC_CORE_H__
 #define __MFD_AIC_CORE_H__
 
+#include <linux/interrupt.h>
 #include <linux/mfd/core.h>
+#include <linux/irqdomain.h>
 
 enum aic_type {
 	TLV320AIC3262 = 0,
 };
 
+#define AIC_IRQ_HEADSET_DETECT		0
+#define AIC_IRQ_BUTTON_PRESS		1
+#define AIC_IRQ_DAC_DRC			2
+#define AIC_IRQ_AGC_NOISE		3
+#define AIC_IRQ_OVER_CURRENT		4
+#define AIC_IRQ_OVERFLOW_EVENT		5
+#define AIC_IRQ_SPEAKER_OVER_TEMP	6
+
 union aic_reg_union {
 	struct aic_reg {
 		u8 offset;
@@ -93,19 +103,46 @@ struct aic {
 	u8 page_no;
 };
 
+static inline int aic_request_irq(struct aic *aic, int irq,
+				      irq_handler_t handler,
+				      unsigned long irqflags, const char *name,
+				      void *data)
+{
+	irq = irq_create_mapping(aic->domain, irq);
+	if (irq < 0) {
+		dev_err(aic->dev,
+			"Mapping hardware interrupt failed %d\n", irq);
+		return irq;
+	}
+
+	return request_threaded_irq(irq, NULL, handler,
+				    irqflags, name, data);
+}
+
+static inline int aic_free_irq(struct aic *aic, int irq, void *data)
+{
+	if (!aic->irq_base)
+		return -EINVAL;
+
+	free_irq(aic->irq_base + irq, data);
+	return 0;
+}
+
 /* Device I/O API */
 int aic_reg_read(struct aic *aic, unsigned int reg);
 int aic_reg_write(struct aic *aic, unsigned int reg,
-		      unsigned char val);
+			unsigned char val);
 int aic_set_bits(struct aic *aic, unsigned int reg,
-		     unsigned char mask, unsigned char val);
+			unsigned char mask, unsigned char val);
 int aic_bulk_read(struct aic *aic, unsigned int reg,
-		      int count, u8 *buf);
+			int count, u8 *buf);
 int aic_bulk_write(struct aic *aic, unsigned int reg,
-		       int count, const u8 *buf);
+			int count, const u8 *buf);
 int aic_wait_bits(struct aic *aic, unsigned int reg,
-		      unsigned char mask, unsigned char val, int delay,
-		      int counter);
+			unsigned char mask, unsigned char val, int delay,
+			int counter);
+int aic_irq_init(struct aic *aic);
+void aic_irq_exit(struct aic *aic);
 int aic_device_init(struct aic *aic);
 void aic_device_exit(struct aic *aic);
 
diff --git a/include/linux/mfd/tlv320aic-registers.h b/include/linux/mfd/tlv320aic-registers.h
index 8b56532..c940fae 100644
--- a/include/linux/mfd/tlv320aic-registers.h
+++ b/include/linux/mfd/tlv320aic-registers.h
@@ -28,5 +28,62 @@
 								offset)
 
 #define AIC_RESET			AIC_MAKE_REG(0, 0, 1)
+#define AIC_REV_PG_ID			AIC_MAKE_REG(0, 0, 2)
+#define AIC_INT_STICKY_FLAG1		AIC_MAKE_REG(0, 0, 42)
+#define AIC_INT_STICKY_FLAG2		AIC_MAKE_REG(0, 0, 44)
+#define AIC_INT_STICKY_FLAG3		AIC_MAKE_REG(0, 0, 45)
+#define AIC_INT1_CNTL			AIC_MAKE_REG(0, 0, 48)
+#define AIC_INT2_CNTL			AIC_MAKE_REG(0, 0, 49)
+#define AIC_INT_FMT			AIC_MAKE_REG(0, 0, 51)
 #define AIC_DEVICE_ID			AIC_MAKE_REG(0, 0, 125)
+
+/*
+ *  B0_P0_R2 (0x000002) – Revision ID register.
+ */
+#define AIC_REV_M			(0b01110000)
+#define AIC_REV_S			(0b00000100)
+#define AIC_PG_M			(0b00000111)
+#define AIC_PG_S			(0b00000000)
+/*
+ * B0_P0_R42 (0x00002a) – Interrupt Status 1
+ */
+#define AIC_LEFT_DAC_OVERFLOW_INT		0x80
+#define AIC_RIGHT_DAC_OVERFLOW_INT		0x40
+#define AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT	0x20
+#define AIC_LEFT_ADC_OVERFLOW_INT		0x08
+#define AIC_RIGHT_ADC_OVERFLOW_INT		0x04
+#define AIC_MINIDSP_A_BARREL_SHIFT_OVERFLOW_INT	0x02
+/*
+ * B0_P0_R44 (0x00002c) - Interrupt Status 2
+ */
+#define AIC_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT	0x80
+#define AIC_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT	0x40
+#define AIC_BUTTON_PRESS_INT			0x20
+#define AIC_HEADSET_PLUG_UNPLUG_INT		0x10
+#define AIC_LEFT_DRC_THRES_INT			0x08
+#define AIC_RIGHT_DRC_THRES_INT			0x04
+#define AIC_MINIDSP_D_STD_INT			0x02
+#define AIC_MINIDSP_D_AUX_INT			0x01
+/*
+ * B0_P0_R45 (0x00002d) - Interrupt Status 3
+ */
+#define AIC_SPK_OVER_CURRENT_INT		0x80
+#define AIC_LEFT_AGC_NOISE_INT			0x40
+#define AIC_RIGHT_AGC_NOISE_INT			0x20
+#define AIC_MINIDSP_A_STD_INT			0x10
+#define AIC_MINIDSP_A_AUX_INT			0x08
+#define AIC_LEFT_ADC_DC_DATA_AVAILABLE_INT	0x04
+#define AIC_RIGHT_ADC_DC_DATA_AVAILABLE_INT	0x02
+#define AIC_CP_SHORT_CIRCUIT_INT		0x01
+/*
+ * B0_P0_R48 (0x000030) - Interrupt Control 1
+ */
+#define AIC_HEADSET_IN_M			0x80
+#define AIC_BUTTON_PRESS_M			0x40
+#define AIC_DAC_DRC_THRES_M			0x20
+#define AIC_AGC_NOISE_M				0x10
+#define AIC_OVER_CURRENT_M			0x08
+#define AIC_OVERFLOW_M				0x04
+#define AIC_SPK_OVERCURRENT_M			0x02
+#define AIC_CP_SHORT_CIRCUIT_M			0x02
 #endif
-- 
1.7.0.4

