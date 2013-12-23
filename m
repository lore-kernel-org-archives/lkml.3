Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3LWQYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:24:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39762 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3LWQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:11 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 17/18] misc: Versatile Express System Config interface driver
Date: Mon, 23 Dec 2013 16:23:49 +0000
Message-Id: <1387815830-8794-18-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:09.0040 (UTC) FILETIME=[68337500:01CEFFFB]
X-MC-Unique: 113122316241000301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGPCK8026604

Versatile Express System Config (syscfg) interface, usually
part of the System Registers (sysreg) block, can be used
to generate transactions on the platform configuration bus.

The driver registers itself as a bridge in the VE config
core and provides a regmap abstraction for the components
functions.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |   5 +-
 arch/arm/mach-vexpress/ct-ca9x4.c          |   8 +-
 arch/arm/mach-vexpress/v2m.c               |  35 ++--
 drivers/misc/Kconfig                       |   9 +
 drivers/misc/Makefile                      |   1 +
 drivers/misc/vexpress-syscfg.c             | 322 +++++++++++++++++++++++++++++
 include/linux/vexpress.h                   |  11 +-
 7 files changed, 356 insertions(+), 35 deletions(-)
 create mode 100644 drivers/misc/vexpress-syscfg.c

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 15f98cb..a25c262 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -312,6 +312,7 @@
 			arm,vexpress-sysreg,func = <12 0>;
 			label = "A15 Pcore";
 		};
+
 		power@1 {
 			/* Total power for the three A7 cores */
 			compatible = "arm,vexpress-power";
@@ -322,14 +323,14 @@
 		energy@0 {
 			/* Total energy for the two A15 cores */
 			compatible = "arm,vexpress-energy";
-			arm,vexpress-sysreg,func = <13 0>;
+			arm,vexpress-sysreg,func = <13 0>, <13 1>;
 			label = "A15 Jcore";
 		};
 
 		energy@2 {
 			/* Total energy for the three A7 cores */
 			compatible = "arm,vexpress-energy";
-			arm,vexpress-sysreg,func = <13 2>;
+			arm,vexpress-sysreg,func = <13 2>, <13 3>;
 			label = "A7 Jcore";
 		};
 	};
diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
index 6f34497..0df4bf6 100644
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -130,11 +130,7 @@ static struct platform_device pmu_device = {
 
 static struct platform_device osc1_device = {
 	.name		= "vexpress-osc",
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0xf, 1),
-	},
+	.id		= -1,
 };
 
 static void __init ct_ca9x4_init(void)
@@ -156,6 +152,8 @@ static void __init ct_ca9x4_init(void)
 
 	platform_device_register(&pmu_device);
 	platform_device_register(&osc1_device);
+	devm_vexpress_syscfg_regmap_init(&osc1_device.dev,
+			vexpress_config_get_master(), 0, 0, 1, 1);
 
 	WARN_ON(clk_register_clkdev(vexpress_osc_setup(&osc1_device.dev),
 			NULL, "ct:clcd"));
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 5437956..325ae06 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -222,38 +222,22 @@ static struct platform_device v2m_sysreg_device = {
 
 static struct platform_device v2m_muxfpga_device = {
 	.name		= "vexpress-muxfpga",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 7),
-	}
+	.id		= -1,
 };
 
 static struct platform_device v2m_shutdown_device = {
 	.name		= "vexpress-shutdown",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 8),
-	}
+	.id		= -1,
 };
 
 static struct platform_device v2m_reboot_device = {
 	.name		= "vexpress-reboot",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 9),
-	}
+	.id		= -1,
 };
 
 static struct platform_device v2m_dvimode_device = {
 	.name		= "vexpress-dvimode",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 11),
-	}
+	.id		= -1,
 };
 
 static AMBA_APB_DEVICE(aaci,  "mb:aaci",  0, V2M_AACI, IRQ_V2M_AACI, NULL);
@@ -340,12 +324,21 @@ static void __init v2m_init(void)
 	regulator_register_fixed(0, v2m_eth_supplies,
 			ARRAY_SIZE(v2m_eth_supplies));
 
+	platform_device_register(&v2m_sysreg_device);
+
 	platform_device_register(&v2m_muxfpga_device);
+	devm_vexpress_syscfg_regmap_init(&v2m_muxfpga_device.dev,
+			VEXPRESS_SITE_MB, 0, 0, 7, 0);
 	platform_device_register(&v2m_shutdown_device);
+	devm_vexpress_syscfg_regmap_init(&v2m_shutdown_device.dev,
+			VEXPRESS_SITE_MB, 0, 0, 8, 0);
 	platform_device_register(&v2m_reboot_device);
+	devm_vexpress_syscfg_regmap_init(&v2m_reboot_device.dev,
+			VEXPRESS_SITE_MB, 0, 0, 9, 0);
 	platform_device_register(&v2m_dvimode_device);
+	devm_vexpress_syscfg_regmap_init(&v2m_dvimode_device.dev,
+			VEXPRESS_SITE_MB, 0, 0, 11, 0);
 
-	platform_device_register(&v2m_sysreg_device);
 	platform_device_register(&v2m_pcie_i2c_device);
 	platform_device_register(&v2m_ddc_i2c_device);
 	platform_device_register(&v2m_flash_device);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..7c53770 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,15 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config VEXPRESS_SYSCFG
+	bool "Versatile Express System Configuration driver"
+	depends on VEXPRESS_CONFIG
+	default y
+	help
+	  ARM Ltd. Versatile Express uses specialised platform configuration
+	  bus. System Configuration registers are one of the possible means
+	  of generating transactions on this bus.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f45473e..ca3338d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
+obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
new file mode 100644
index 0000000..6c4632d
--- /dev/null
+++ b/drivers/misc/vexpress-syscfg.c
@@ -0,0 +1,322 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2013 ARM Limited
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscore_ops.h>
+#include <linux/vexpress.h>
+
+
+#define SYS_CFGDATA		0x0
+
+#define SYS_CFGCTRL		0x4
+#define SYS_CFGCTRL_START	(1 << 31)
+#define SYS_CFGCTRL_WRITE	(1 << 30)
+#define SYS_CFGCTRL_DCC(n)	(((n) & 0xf) << 26)
+#define SYS_CFGCTRL_FUNC(n)	(((n) & 0x3f) << 20)
+#define SYS_CFGCTRL_SITE(n)	(((n) & 0x3) << 16)
+#define SYS_CFGCTRL_POSITION(n)	(((n) & 0xf) << 12)
+#define SYS_CFGCTRL_DEVICE(n)	(((n) & 0xfff) << 0)
+
+#define SYS_CFGSTAT		0x8
+#define SYS_CFGSTAT_ERR		(1 << 1)
+#define SYS_CFGSTAT_COMPLETE	(1 << 0)
+
+
+struct vexpress_syscfg {
+	struct device *dev;
+	void __iomem *base;
+};
+
+struct vexpress_syscfg_reg {
+	struct vexpress_syscfg *syscfg;
+	int regs_num;
+	u32 templates[0];
+};
+
+
+static int vexpress_syscfg_delay_schedule(unsigned int us)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(usecs_to_jiffies(us));
+	if (signal_pending(current))
+		return -EINTR;
+
+	return 0;
+}
+
+static int vexpress_syscfg_delay_loop(unsigned int us)
+{
+	unsigned long long timeout_ns = sched_clock() + us * 1000;
+
+	while (time_before64(sched_clock(), timeout_ns))
+		cpu_relax();
+
+	return 0;
+}
+
+static int (*vexpress_syscfg_delay)(unsigned int us) =
+		vexpress_syscfg_delay_schedule;
+
+static void vexpress_syscfg_shutdown(void)
+{
+	/* Can't relay on the scheduler when the system is going down */
+	vexpress_syscfg_delay = vexpress_syscfg_delay_loop;
+}
+
+static struct syscore_ops vexpress_syscfg_syscore_ops = {
+	.shutdown = vexpress_syscfg_shutdown,
+};
+
+
+static int vexpress_syscfg_exec(struct vexpress_syscfg_reg *reg,
+		int index, bool write, u32 *data)
+{
+	struct vexpress_syscfg *syscfg = reg->syscfg;
+	u32 command, status;
+	int tries;
+	long timeout;
+
+	if (WARN_ON(index > reg->regs_num))
+		return -EINVAL;
+
+	command = readl(syscfg->base + SYS_CFGCTRL);
+	if (WARN_ON(command & SYS_CFGCTRL_START))
+		return -EBUSY;
+
+	command = reg->templates[index];
+	command |= SYS_CFGCTRL_START;
+	command |= write ? SYS_CFGCTRL_WRITE : 0;
+
+	/* Use a canary for reads */
+	if (!write)
+		*data = 0xdeadbeef;
+
+	dev_dbg(syscfg->dev, "command %x, data %x\n",
+			command, *data);
+	writel(*data, syscfg->base + SYS_CFGDATA);
+	writel(0, syscfg->base + SYS_CFGSTAT);
+	writel(command, syscfg->base + SYS_CFGCTRL);
+	mb();
+
+	/* The operation can take ages... Go to sleep, 100us initially */
+	tries = 100;
+	timeout = 100;
+	do {
+		int err = vexpress_syscfg_delay(timeout);
+		if (err)
+			return err;
+
+		status = readl(syscfg->base + SYS_CFGSTAT);
+		if (status & SYS_CFGSTAT_ERR)
+			return -EFAULT;
+
+		if (timeout > 20)
+			timeout -= 20;
+	} while (--tries && !(status & SYS_CFGSTAT_COMPLETE));
+	if (WARN_ON_ONCE(!tries))
+		return -ETIMEDOUT;
+
+	if (!write) {
+		*data = readl(syscfg->base + SYS_CFGDATA);
+		dev_dbg(syscfg->dev, "read data %x\n", *data);
+	}
+
+	return 0;
+}
+
+static int vexpress_syscfg_reg_read(void *context, unsigned int index,
+		unsigned int *val)
+{
+	struct vexpress_syscfg_reg *reg = context;
+
+	return vexpress_syscfg_exec(reg, index, false, val);
+}
+
+static int vexpress_syscfg_reg_write(void *context, unsigned int index,
+		unsigned int val)
+{
+	struct vexpress_syscfg_reg *reg = context;
+
+	return vexpress_syscfg_exec(reg, index, true, &val);
+}
+
+static struct vexpress_syscfg_reg *vexpress_syscfg_alloc_reg(
+		struct vexpress_syscfg *syscfg,
+		int site, int position, int dcc, int regs_num)
+{
+	struct vexpress_syscfg_reg *reg;
+	int i;
+
+	reg = kzalloc(sizeof(*reg) + sizeof(*reg->templates) * regs_num,
+			GFP_KERNEL);
+	if (!reg)
+		return NULL;
+
+	reg->syscfg = syscfg;
+	reg->regs_num = regs_num;
+
+	for (i = 0; i < regs_num; i++) {
+		reg->templates[i] = SYS_CFGCTRL_DCC(dcc);
+		reg->templates[i] |= SYS_CFGCTRL_SITE(site);
+		reg->templates[i] |= SYS_CFGCTRL_POSITION(position);
+	}
+
+	return reg;
+}
+
+static void vexpress_syscfg_set_reg(struct vexpress_syscfg_reg *reg,
+		int index, u32 function, u32 device)
+{
+	if (WARN_ON(index >= reg->regs_num))
+		return;
+
+	reg->templates[index] |= SYS_CFGCTRL_FUNC(function);
+	reg->templates[index] |= SYS_CFGCTRL_DEVICE(device);
+}
+
+static void vexpress_syscfg_free_reg(void *reg)
+{
+	kfree(reg);
+}
+
+struct regmap_config vexpress_syscfg_regmap_config = {
+	.lock = vexpress_config_lock,
+	.unlock = vexpress_config_unlock,
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_read = vexpress_syscfg_reg_read,
+	.reg_write = vexpress_syscfg_reg_write,
+	.free_context = vexpress_syscfg_free_reg,
+	.reg_format_endian = REGMAP_ENDIAN_LITTLE,
+	.val_format_endian = REGMAP_ENDIAN_LITTLE,
+};
+
+
+/* Non-DT hack, to be gone... */
+static struct vexpress_syscfg *vexpress_syscfg_not_of;
+
+struct regmap *devm_vexpress_syscfg_regmap_init(struct device *dev,
+		u32 site, u32 position, u32 dcc, u32 function, u32 device)
+{
+	struct vexpress_syscfg_reg *reg;
+
+	reg = vexpress_syscfg_alloc_reg(vexpress_syscfg_not_of,
+			site, position, dcc, 1);
+	if (!reg)
+		return NULL;
+
+	vexpress_syscfg_set_reg(reg, 0, function, device);
+
+	return devm_regmap_init(dev, NULL, reg, &vexpress_syscfg_regmap_config);
+}
+
+
+static int vexpress_syscfg_bridge_regmap_init(struct device *dev, void *context)
+{
+	struct vexpress_syscfg *syscfg = context;
+	int err;
+	u32 site, position, dcc;
+	struct property *prop;
+	int regs_num;
+	struct vexpress_syscfg_reg *reg;
+	const __be32 *val;
+	int i;
+	struct regmap *regmap;
+
+	if (!dev->of_node)
+		return -EINVAL;
+
+	err = vexpress_config_get_topo(dev->of_node, &site, &position, &dcc);
+	if (err)
+		return err;
+
+	prop = of_find_property(dev->of_node, "arm,vexpress-sysreg,func", NULL);
+	if (!prop)
+		return -EINVAL;
+
+	/* Each "register" is defined by two numbers - function and device */
+	regs_num = prop->length / sizeof(u32) / 2;
+	reg = vexpress_syscfg_alloc_reg(syscfg, site, position, dcc,
+			regs_num);
+	if (!reg)
+		return -ENOMEM;
+
+	for (i = 0, val = prop->value; i < regs_num; i++) {
+		u32 function = be32_to_cpup(val++);
+		u32 device = be32_to_cpup(val++);
+
+		vexpress_syscfg_set_reg(reg, i, function, device);
+	}
+	if (err)
+		return err;
+
+	vexpress_syscfg_regmap_config.max_register = regs_num - 1;
+	regmap = devm_regmap_init(dev, NULL, reg,
+			&vexpress_syscfg_regmap_config);
+	return IS_ERR(regmap) ? PTR_ERR(regmap) : 0;
+}
+
+int vexpress_syscfg_probe(struct platform_device *pdev)
+{
+	struct vexpress_syscfg *syscfg;
+	struct resource *res;
+	struct device *bridge;
+
+	syscfg = devm_kzalloc(&pdev->dev, sizeof(*syscfg), GFP_KERNEL);
+	if (!syscfg)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), pdev->name))
+		return -EBUSY;
+
+	syscfg->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!syscfg->base)
+		return -EFAULT;
+
+	bridge = vexpress_config_bridge_register(pdev->dev.parent,
+			vexpress_syscfg_bridge_regmap_init, syscfg);
+	if (IS_ERR(bridge))
+		return PTR_ERR(bridge);
+
+	if (!pdev->dev.of_node)
+		vexpress_syscfg_not_of = syscfg;
+
+	register_syscore_ops(&vexpress_syscfg_syscore_ops);
+
+	return 0;
+}
+
+static const struct platform_device_id vexpress_syscfg_id_table[] = {
+	{ "vexpress-syscfg", },
+	{},
+};
+
+static struct platform_driver vexpress_syscfg_driver = {
+	.driver.name = "vexpress-syscfg",
+	.id_table = vexpress_syscfg_id_table,
+	.probe = vexpress_syscfg_probe,
+};
+
+static int __init vexpress_syscfg_init(void)
+{
+	return platform_driver_register(&vexpress_syscfg_driver);
+}
+core_initcall(vexpress_syscfg_init);
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 1b8889f..203f63a 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 #include <linux/reboot.h>
+#include <linux/regmap.h>
 
 #define VEXPRESS_SITE_MB		0
 #define VEXPRESS_SITE_DB1		1
@@ -34,13 +35,6 @@
 #define VEXPRESS_GPIO_LED6		9
 #define VEXPRESS_GPIO_LED7		10
 
-#define VEXPRESS_RES_FUNC(_site, _func)	\
-{					\
-	.start = (_site),		\
-	.end = (_func),			\
-	.flags = IORESOURCE_BUS,	\
-}
-
 /* Config infrastructure */
 
 void vexpress_config_set_master(u32 site);
@@ -57,6 +51,9 @@ struct device *vexpress_config_bridge_register(struct device *parent,
 
 /* Platform control */
 
+struct regmap *devm_vexpress_syscfg_regmap_init(struct device *dev,
+               u32 site, u32 position, u32 dcc, u32 function, u32 device);
+
 u32 vexpress_get_procid(int site);
 u32 vexpress_get_hbi(int site);
 void *vexpress_get_24mhz_clock_base(void);
-- 
1.8.3.2


