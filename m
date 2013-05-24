Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3EXQX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:23:26 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59967 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab3EXQWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:25 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 7/9] gpio-tz1090: add TZ1090 gpio driver
Date: Fri, 24 May 2013 17:21:14 +0100
Message-ID: <1369412476-14245-8-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
This doesn't include low-power GPIOs as they're controlled separately
via the Powerdown Controller (PDC) registers.

The driver is instantiated by device tree and supports interrupts for
all GPIOs.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-doc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
Changes in v2:
 - gpio-tz1090: remove references to Linux flags in dt bindings
 - gpio-tz1090: make use of BIT() from linux/bitops.h
 - gpio-tz1090: make register accessors inline to match pinctrl
 - gpio-tz1090: update gpio-ranges to use 3 cells after recent ABI
   breakage

 .../devicetree/bindings/gpio/gpio-tz1090.txt       |  83 +++
 arch/metag/Kconfig.soc                             |   1 +
 arch/metag/boot/dts/tz1090.dtsi                    |  35 ++
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-tz1090.c                         | 629 +++++++++++++++++++++
 6 files changed, 756 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 drivers/gpio/gpio-tz1090.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
new file mode 100644
index 0000000..6fd98be
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
@@ -0,0 +1,83 @@
+ImgTec TZ1090 GPIO Controller
+
+Required properties:
+- compatible: Compatible property value should be "img,tz1090-gpio>".
+
+- reg: Physical base address of the controller and length of memory mapped
+  region.
+
+- #address-cells: Should be 1 (for bank subnodes)
+
+- #size-cells: Should be 0 (for bank subnodes)
+
+- Each bank of GPIOs should have a subnode to represent it.
+
+  Bank subnode required properties:
+  - reg: Index of bank in the range 0 to 2.
+
+  - gpio-controller: Specifies that the node is a gpio controller.
+
+  - #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
+    nodes should have the following values.
+       <[phandle of the gpio controller node]
+        [gpio number within the gpio bank]
+        [gpio flags]>
+
+    Values for gpio specifier:
+    - GPIO number: a value in the range 0 to 29.
+    - GPIO flags: bit field of flags:
+        1: active low
+
+  Bank subnode optional properties:
+  - gpio-ranges: Mapping to pin controller pins
+
+  - interrupts: Interrupt for the entire bank
+
+  - interrupt-controller: Specifies that the node is an interrupt controller
+
+  - #interrupt-cells: Should be 2. The syntax of the interrupt specifier used by
+    client nodes should have the following values.
+       <[phandle of the interurupt controller]
+        [gpio number within the gpio bank]
+        [irq flags]>
+
+    Values for irq specifier:
+    - GPIO number: a value in the range 0 to 29
+    - IRQ flags: value to describe edge and level triggering
+        1: trigger on rising edge
+        2: trigger on falling edge
+        3: trigger on both rising and falling edges
+        4: trigger when high
+        8: trigger when low
+
+
+
+Example:
+
+	gpios: gpio-controller@02005800 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "img,tz1090-gpio";
+		reg = <0x02005800 0x90>;
+
+		/* bank 0 with an interrupt */
+		gpios0: bank@0 {
+			#gpio-cells = <2>;
+			#interrupt-cells = <2>;
+			reg = <0>;
+			interrupts = <13 4 /* level */>;
+			gpio-controller;
+			gpio-ranges = <&pinctrl 0 30>;
+			interrupt-controller;
+		};
+
+		/* bank 2 without interrupt */
+		gpios2: bank@2 {
+			#gpio-cells = <2>;
+			reg = <2>;
+			gpio-controller;
+			gpio-ranges = <&pinctrl 60 30>;
+		};
+	};
+
+
diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 944dc30..d61d687 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -16,6 +16,7 @@ config META21_FPGA
 
 config SOC_TZ1090
 	bool "Toumaz Xenif TZ1090 SoC (Comet)"
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select IMGPDC_IRQ
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index e3f117c..fdd382d 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -47,5 +47,40 @@
 			compatible = "img,tz1090-pinctrl";
 			reg = <0x02005800 0xe4>;
 		};
+
+		gpios: gpios@02005800 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "img,tz1090-gpio";
+			reg = <0x02005800 0x90>;
+
+			gpios0: bank@0 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <0>;
+				interrupts = <13 4 /* level */>;
+				gpio-ranges = <&pinctrl 0 0 30>;
+			};
+			gpios1: bank@1 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <1>;
+				interrupts = <14 4 /* level */>;
+				gpio-ranges = <&pinctrl 0 30 30>;
+			};
+			gpios2: bank@2 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <2>;
+				interrupts = <15 4 /* level */>;
+				gpio-ranges = <&pinctrl 0 60 30>;
+			};
+		};
 	};
 };
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 87d5670..49e4f67 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -232,6 +232,13 @@ config GPIO_TS5500
 	  blocks of the TS-5500: DIO1, DIO2 and the LCD port, and the TS-5600
 	  LCD port.
 
+config GPIO_TZ1090
+	bool "Toumaz Xenif TZ1090 GPIO support"
+	depends on SOC_TZ1090
+	default y
+	help
+	  Say yes here to support Toumaz Xenif TZ1090 GPIOs.
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0cb2d65..37bdc1e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
+obj-$(CONFIG_GPIO_TZ1090)	+= gpio-tz1090.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
new file mode 100644
index 0000000..7f4b521
--- /dev/null
+++ b/drivers/gpio/gpio-tz1090.c
@@ -0,0 +1,629 @@
+/*
+ * Toumaz Xenif TZ1090 GPIO handling.
+ *
+ * Copyright (C) 2008-2013 Imagination Technologies Ltd.
+ *
+ *  Based on ARM PXA code and others.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/export.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/of_irq.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/syscore_ops.h>
+#include <asm/global_lock.h>
+
+/* Register offsets from bank base address */
+#define REG_GPIO_DIR		0x00
+#define REG_GPIO_IRQ_PLRT	0x20
+#define REG_GPIO_IRQ_TYPE	0x30
+#define REG_GPIO_IRQ_EN		0x40
+#define REG_GPIO_IRQ_STS	0x50
+#define REG_GPIO_BIT_EN		0x60
+#define REG_GPIO_DIN		0x70
+#define REG_GPIO_DOUT		0x80
+
+/* REG_GPIO_IRQ_PLRT */
+#define GPIO_POLARITY_LOW	0
+#define GPIO_POLARITY_HIGH	1
+
+/* REG_GPIO_IRQ_TYPE */
+#define GPIO_LEVEL_TRIGGERED	0
+#define GPIO_EDGE_TRIGGERED	1
+
+/**
+ * struct tz1090_gpio_bank - GPIO bank private data
+ * @chip:	Generic GPIO chip for GPIO bank
+ * @domain:	IRQ domain for GPIO bank (may be NULL)
+ * @reg:	Base of registers, offset for this GPIO bank
+ * @irq:	IRQ number for GPIO bank
+ * @label:	Debug GPIO bank label, used for storage of chip->label
+ *
+ * This is the main private data for a GPIO bank. It encapsulates a gpio_chip,
+ * and the callbacks for the gpio_chip can access the private data with the
+ * to_bank() macro below.
+ */
+struct tz1090_gpio_bank {
+	struct gpio_chip chip;
+	struct irq_domain *domain;
+	void __iomem *reg;
+	int irq;
+	char label[16];
+};
+#define to_bank(c)	container_of(c, struct tz1090_gpio_bank, chip)
+
+/**
+ * struct tz1090_gpio - Overall GPIO device private data
+ * @dev:	Device (from platform device)
+ * @reg:	Base of GPIO registers
+ *
+ * Represents the overall GPIO device. This structure is actually only
+ * temporary, and used during init.
+ */
+struct tz1090_gpio {
+	struct device *dev;
+	void __iomem *reg;
+};
+
+/**
+ * struct tz1090_gpio_bank_info - Temporary registration info for GPIO bank
+ * @priv:	Overall GPIO device private data
+ * @node:	Device tree node specific to this GPIO bank
+ * @index:	Index of bank in range 0-2
+ */
+struct tz1090_gpio_bank_info {
+	struct tz1090_gpio *priv;
+	struct device_node *node;
+	unsigned int index;
+};
+
+/* Convenience register accessors */
+static inline void tz1090_gpio_write(struct tz1090_gpio_bank *bank,
+			      unsigned int reg_offs, u32 data)
+{
+	iowrite32(data, bank->reg + reg_offs);
+}
+
+static inline u32 tz1090_gpio_read(struct tz1090_gpio_bank *bank,
+			    unsigned int reg_offs)
+{
+	return ioread32(bank->reg + reg_offs);
+}
+
+/* caller must hold LOCK2 */
+static inline void _tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
+					  unsigned int reg_offs,
+					  unsigned int offset)
+{
+	u32 value;
+
+	value = tz1090_gpio_read(bank, reg_offs);
+	value &= ~BIT(offset);
+	tz1090_gpio_write(bank, reg_offs, value);
+}
+
+static void tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
+				  unsigned int reg_offs,
+				  unsigned int offset)
+{
+	int lstat;
+
+	__global_lock2(lstat);
+	_tz1090_gpio_clear_bit(bank, reg_offs, offset);
+	__global_unlock2(lstat);
+}
+
+/* caller must hold LOCK2 */
+static inline void _tz1090_gpio_set_bit(struct tz1090_gpio_bank *bank,
+					unsigned int reg_offs,
+					unsigned int offset)
+{
+	u32 value;
+
+	value = tz1090_gpio_read(bank, reg_offs);
+	value |= BIT(offset);
+	tz1090_gpio_write(bank, reg_offs, value);
+}
+
+static void tz1090_gpio_set_bit(struct tz1090_gpio_bank *bank,
+				unsigned int reg_offs,
+				unsigned int offset)
+{
+	int lstat;
+
+	__global_lock2(lstat);
+	_tz1090_gpio_set_bit(bank, reg_offs, offset);
+	__global_unlock2(lstat);
+}
+
+/* caller must hold LOCK2 */
+static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
+					unsigned int reg_offs,
+					unsigned int offset,
+					int val)
+{
+	u32 value;
+
+	value = tz1090_gpio_read(bank, reg_offs);
+	value &= ~BIT(offset);
+	value |= !!val << offset;
+	tz1090_gpio_write(bank, reg_offs, value);
+}
+
+static void tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
+				unsigned int reg_offs,
+				unsigned int offset,
+				int val)
+{
+	int lstat;
+
+	__global_lock2(lstat);
+	_tz1090_gpio_mod_bit(bank, reg_offs, offset, val);
+	__global_unlock2(lstat);
+}
+
+static inline int tz1090_gpio_read_bit(struct tz1090_gpio_bank *bank,
+				       unsigned int reg_offs,
+				       unsigned int offset)
+{
+	return tz1090_gpio_read(bank, reg_offs) & BIT(offset);
+}
+
+/* GPIO chip callbacks */
+
+static int tz1090_gpio_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
+
+	return 0;
+}
+
+static int tz1090_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int output_value)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+	int lstat;
+
+	__global_lock2(lstat);
+	_tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
+	_tz1090_gpio_clear_bit(bank, REG_GPIO_DIR, offset);
+	__global_unlock2(lstat);
+
+	return 0;
+}
+
+/*
+ * Return GPIO level
+ */
+static int tz1090_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+
+	return tz1090_gpio_read_bit(bank, REG_GPIO_DIN, offset);
+}
+
+/*
+ * Set output GPIO level
+ */
+static void tz1090_gpio_set(struct gpio_chip *chip, unsigned offset,
+			    int output_value)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+
+	tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
+}
+
+static int tz1090_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+	int ret;
+
+	ret = pinctrl_request_gpio(chip->base + offset);
+	if (ret)
+		return ret;
+
+	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
+	tz1090_gpio_set_bit(bank, REG_GPIO_BIT_EN, offset);
+
+	return 0;
+}
+
+static void tz1090_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+
+	pinctrl_free_gpio(chip->base + offset);
+
+	tz1090_gpio_clear_bit(bank, REG_GPIO_BIT_EN, offset);
+}
+
+static int tz1090_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_gpio_bank *bank = to_bank(chip);
+
+	if (!bank->domain)
+		return -EINVAL;
+
+	return irq_create_mapping(bank->domain, offset);
+}
+
+/* IRQ chip handlers */
+
+/* Get TZ1090 GPIO chip from irq data provided to generic IRQ callbacks */
+static inline struct tz1090_gpio_bank *irqd_to_gpio_bank(struct irq_data *data)
+{
+	return (struct tz1090_gpio_bank *)data->domain->host_data;
+}
+
+static void tz1090_gpio_irq_clear(struct tz1090_gpio_bank *bank,
+				  unsigned int offset)
+{
+	tz1090_gpio_clear_bit(bank, REG_GPIO_IRQ_STS, offset);
+}
+
+static void tz1090_gpio_irq_enable(struct tz1090_gpio_bank *bank,
+				   unsigned int offset, unsigned int enable)
+{
+	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_EN, offset, enable);
+}
+
+static void tz1090_gpio_irq_polarity(struct tz1090_gpio_bank *bank,
+				     unsigned int offset, unsigned int polarity)
+{
+	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_PLRT, offset, polarity);
+}
+
+static int tz1090_gpio_valid_handler(struct irq_desc *desc)
+{
+	return desc->handle_irq == handle_level_irq ||
+		desc->handle_irq == handle_edge_irq;
+}
+
+static void tz1090_gpio_irq_type(struct tz1090_gpio_bank *bank,
+				 unsigned int offset, unsigned int type)
+{
+	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_TYPE, offset, type);
+}
+
+/* set polarity to trigger on next edge, whether rising or falling */
+static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
+				      unsigned int offset)
+{
+	unsigned int value_p, value_i;
+	int lstat;
+
+	__global_lock2(lstat);
+	/* irq_polarity[offset] = !input[offset] */
+	value_i = ~tz1090_gpio_read(bank, REG_GPIO_DIN);
+	value_p = tz1090_gpio_read(bank, REG_GPIO_IRQ_PLRT);
+	value_p &= ~BIT(offset);
+	value_p |= value_i & BIT(offset);
+	tz1090_gpio_write(bank, REG_GPIO_IRQ_PLRT, value_p);
+	__global_unlock2(lstat);
+}
+
+static void gpio_ack_irq(struct irq_data *data)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+
+	tz1090_gpio_irq_clear(bank, data->hwirq);
+}
+
+static void gpio_mask_irq(struct irq_data *data)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+
+	tz1090_gpio_irq_enable(bank, data->hwirq, 0);
+}
+
+static void gpio_unmask_irq(struct irq_data *data)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+
+	tz1090_gpio_irq_enable(bank, data->hwirq, 1);
+}
+
+static unsigned int gpio_startup_irq(struct irq_data *data)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+	irq_hw_number_t hw = data->hwirq;
+	struct irq_desc *desc = irq_to_desc(data->irq);
+
+	/*
+	 * This warning indicates that the type of the irq hasn't been set
+	 * before enabling the irq. This would normally be done by passing some
+	 * trigger flags to request_irq().
+	 */
+	WARN(!tz1090_gpio_valid_handler(desc),
+		"irq type not set before enabling gpio irq %d", data->irq);
+
+	tz1090_gpio_irq_clear(bank, hw);
+	tz1090_gpio_irq_enable(bank, hw, 1);
+	return 0;
+}
+
+static int gpio_set_irq_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+	unsigned int type;
+	unsigned int polarity;
+
+	switch (flow_type) {
+	case IRQ_TYPE_EDGE_BOTH:
+		type = GPIO_EDGE_TRIGGERED;
+		polarity = GPIO_POLARITY_LOW;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		type = GPIO_EDGE_TRIGGERED;
+		polarity = GPIO_POLARITY_HIGH;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		type = GPIO_EDGE_TRIGGERED;
+		polarity = GPIO_POLARITY_LOW;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		type = GPIO_LEVEL_TRIGGERED;
+		polarity = GPIO_POLARITY_HIGH;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		type = GPIO_LEVEL_TRIGGERED;
+		polarity = GPIO_POLARITY_LOW;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tz1090_gpio_irq_type(bank, data->hwirq, type);
+	if (type == GPIO_LEVEL_TRIGGERED)
+		__irq_set_handler_locked(data->irq, handle_level_irq);
+	else
+		__irq_set_handler_locked(data->irq, handle_edge_irq);
+
+	if (flow_type == IRQ_TYPE_EDGE_BOTH)
+		tz1090_gpio_irq_next_edge(bank, data->hwirq);
+	else
+		tz1090_gpio_irq_polarity(bank, data->hwirq, polarity);
+
+	return 0;
+}
+
+#ifdef CONFIG_SUSPEND
+static int gpio_set_irq_wake(struct irq_data *data, unsigned int on)
+{
+	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
+
+#ifdef CONFIG_PM_DEBUG
+	pr_info("irq_wake irq%d state:%d\n", data->irq, on);
+#endif
+
+	/* wake on gpio block interrupt */
+	return irq_set_irq_wake(bank->irq, on);
+}
+#else
+#define gpio_set_irq_wake NULL
+#endif
+
+/* gpio virtual interrupt functions */
+static struct irq_chip gpio_irq_chip = {
+	.irq_startup	= gpio_startup_irq,
+	.irq_ack	= gpio_ack_irq,
+	.irq_mask	= gpio_mask_irq,
+	.irq_unmask	= gpio_unmask_irq,
+	.irq_set_type	= gpio_set_irq_type,
+	.irq_set_wake	= gpio_set_irq_wake,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND,
+};
+
+static void tz1090_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	irq_hw_number_t hw;
+	unsigned int irq_stat, irq_no;
+	struct tz1090_gpio_bank *bank;
+	struct irq_desc *child_desc;
+
+	bank = (struct tz1090_gpio_bank *)irq_desc_get_handler_data(desc);
+	irq_stat = tz1090_gpio_read(bank, REG_GPIO_DIR) &
+		   tz1090_gpio_read(bank, REG_GPIO_IRQ_STS) &
+		   tz1090_gpio_read(bank, REG_GPIO_IRQ_EN) &
+		   0x3FFFFFFF; /* 30 bits only */
+
+	for (hw = 0; irq_stat; irq_stat >>= 1, ++hw) {
+		if (!(irq_stat & 1))
+			continue;
+
+		irq_no = irq_linear_revmap(bank->domain, hw);
+		child_desc = irq_to_desc(irq_no);
+
+		/* Toggle edge for pin with both edges triggering enabled */
+		if (irqd_get_trigger_type(&child_desc->irq_data)
+				== IRQ_TYPE_EDGE_BOTH)
+			tz1090_gpio_irq_next_edge(bank, hw);
+
+		BUG_ON(!tz1090_gpio_valid_handler(child_desc));
+		generic_handle_irq_desc(irq_no, child_desc);
+	}
+}
+
+static int tz1090_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+			       irq_hw_number_t hw)
+{
+	irq_set_chip(irq, &gpio_irq_chip);
+	return 0;
+}
+
+static const struct irq_domain_ops tz1090_gpio_irq_domain_ops = {
+	.map	= tz1090_gpio_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
+{
+	struct device_node *np = info->node;
+	struct device *dev = info->priv->dev;
+	struct tz1090_gpio_bank *bank;
+
+	bank = devm_kzalloc(dev, sizeof(*bank), GFP_KERNEL);
+	if (!bank) {
+		dev_err(dev, "unable to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	/* Offset the main registers to the first register in this bank */
+	bank->reg = info->priv->reg + info->index * 4;
+
+	/* Set up GPIO chip */
+	snprintf(bank->label, sizeof(bank->label), "tz1090-gpio-%u",
+		 info->index);
+	bank->chip.label		= bank->label;
+	bank->chip.dev			= dev;
+	bank->chip.direction_input	= tz1090_gpio_direction_input;
+	bank->chip.direction_output	= tz1090_gpio_direction_output;
+	bank->chip.get			= tz1090_gpio_get;
+	bank->chip.set			= tz1090_gpio_set;
+	bank->chip.free			= tz1090_gpio_free;
+	bank->chip.request		= tz1090_gpio_request;
+	bank->chip.to_irq		= tz1090_gpio_to_irq;
+	bank->chip.of_node		= np;
+
+	/* GPIO numbering from 0 */
+	bank->chip.base			= info->index * 30;
+	bank->chip.ngpio		= 30;
+
+	/* Add the GPIO bank */
+	gpiochip_add(&bank->chip);
+
+	/* Get the GPIO bank IRQ if provided */
+	bank->irq = irq_of_parse_and_map(np, 0);
+
+	/* The interrupt is optional (it may be used by another core on chip) */
+	if (bank->irq < 0) {
+		dev_info(dev, "IRQ not provided for bank %u, IRQs disabled\n",
+			 info->index);
+		return 0;
+	}
+
+	dev_info(dev, "Setting up IRQs for GPIO bank %u\n",
+		 info->index);
+
+	/*
+	 * Initialise all interrupts to disabled so we don't get
+	 * spurious ones on a dirty boot and hit the BUG_ON in the
+	 * handler.
+	 */
+	tz1090_gpio_write(bank, REG_GPIO_IRQ_EN, 0);
+
+	/* Add a virtual IRQ for each GPIO */
+	bank->domain = irq_domain_add_linear(np,
+					     bank->chip.ngpio,
+					     &tz1090_gpio_irq_domain_ops,
+					     bank);
+
+	/* Setup chained handler for this GPIO bank */
+	irq_set_handler_data(bank->irq, bank);
+	irq_set_chained_handler(bank->irq, tz1090_gpio_irq_handler);
+
+	return 0;
+}
+
+static void tz1090_gpio_register_banks(struct tz1090_gpio *priv)
+{
+	struct device_node *np = priv->dev->of_node;
+	struct device_node *node;
+
+	for_each_available_child_of_node(np, node) {
+		struct tz1090_gpio_bank_info info;
+		const __be32 *addr;
+		int len, ret;
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || (len < sizeof(int))) {
+			dev_err(priv->dev, "invalid reg on %s\n",
+				node->full_name);
+			continue;
+		}
+
+		info.index = be32_to_cpup(addr);
+		if (info.index >= 3) {
+			dev_err(priv->dev, "index %u in %s out of range\n",
+				info.index, node->full_name);
+			continue;
+		}
+		info.node = of_node_get(node);
+		info.priv = priv;
+
+		ret = tz1090_gpio_bank_probe(&info);
+		if (ret) {
+			dev_err(priv->dev, "failure registering %s\n",
+				node->full_name);
+			of_node_put(node);
+			continue;
+		}
+	}
+}
+
+static int tz1090_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *res_regs;
+	struct tz1090_gpio priv;
+
+	if (!np) {
+		dev_err(&pdev->dev, "must be instantiated via devicetree\n");
+		return -ENOENT;
+	}
+
+	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_regs) {
+		dev_err(&pdev->dev, "cannot find registers resource\n");
+		return -ENOENT;
+	}
+
+	priv.dev = &pdev->dev;
+
+	/* Ioremap the registers */
+	priv.reg = devm_ioremap(&pdev->dev, res_regs->start,
+				 res_regs->end - res_regs->start);
+	if (!priv.reg) {
+		dev_err(&pdev->dev, "unable to ioremap registers\n");
+		return -ENOMEM;
+	}
+
+	/* Look for banks */
+	tz1090_gpio_register_banks(&priv);
+
+	return 0;
+}
+
+static struct of_device_id tz1090_gpio_of_match[] = {
+	{ .compatible = "img,tz1090-gpio" },
+	{ },
+};
+
+static struct platform_driver tz1090_gpio_driver = {
+	.driver = {
+		.name		= "tz1090-gpio",
+		.owner		= THIS_MODULE,
+		.of_match_table	= tz1090_gpio_of_match,
+	},
+	.probe		= tz1090_gpio_probe,
+};
+
+static int __init tz1090_gpio_init(void)
+{
+	return platform_driver_register(&tz1090_gpio_driver);
+}
+postcore_initcall(tz1090_gpio_init);
-- 
1.8.1.2


