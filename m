Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaAFPgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:36:19 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51360 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaAFPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:36:16 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Add OCM driver
Date: Mon,  6 Jan 2014 16:36:09 +0100
Message-Id: <299e37ab245da9132808c6d4265a17b9a417bf62.1389022555.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20335-1389022569-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20335-1389022569-0001

The driver provide memory allocator which can
be used by others drivers to allocate memory inside OCM.
All location for 64kB blocks are supported
and driver is trying to allocate the largest continuous
block of memory.

Checking mpcore addressing filterring is not done here
but could be added in future.

Also enable generic allocator by default.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
- Based on slcr patches I have just sent.

---
 .../devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt |  17 ++
 arch/arm/boot/dts/zynq-7000.dtsi                   |   7 +
 arch/arm/mach-zynq/Kconfig                         |   1 +
 arch/arm/mach-zynq/Makefile                        |   2 +-
 arch/arm/mach-zynq/common.h                        |   1 +
 arch/arm/mach-zynq/slcr.c                          |  15 ++
 arch/arm/mach-zynq/zynq_ocm.c                      | 243 +++++++++++++++++++++
 7 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt
 create mode 100644 arch/arm/mach-zynq/zynq_ocm.c

diff --git a/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt
new file mode 100644
index 0000000..64cb5e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt
@@ -0,0 +1,17 @@
+Device tree bindings for Zynq's OCM
+
+The OCM is divided to 4 64kB segments which can be separately configured
+to low or high location. Location is controlled via SLCR.
+
+Required properties:
+ compatible: Compatibility string. Must be "xlnx,zynq-ocm-1.0".
+ reg: Specify the base and size of the OCM registers in the memory map.
+      E.g.: reg = <0xf800c000 0x1000>;
+
+Example:
+ocmc: ocmc@f800c000 {
+	compatible =  "xlnx,zynq-ocm-1.0";
+	interrupt-parent = <&intc>;
+	interrupts = <0 3 4>;
+	reg = <0xf800c000 0x1000>;
+} ;
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 1d942e2..4929be5 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -66,6 +66,13 @@
 			cache-level = <2>;
 		};

+		ocmc: ocmc@f800c000 {
+			compatible = "xlnx,zynq-ocm-1.0";
+			interrupt-parent = <&intc>;
+			interrupts = <0 3 4>;
+			reg = <0xf800c000 0x1000>;
+		} ;
+
 		uart0: uart@e0000000 {
 			compatible = "xlnx,xuartps";
 			status = "disabled";
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 323e505..f3e6ce4 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -15,5 +15,6 @@ config ARCH_ZYNQ
 	select CADENCE_TTC_TIMER
 	select ARM_GLOBAL_TIMER
 	select MFD_SYSCON
+	select GENERIC_ALLOCATOR
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
index 1b25d92..626f64b 100644
--- a/arch/arm/mach-zynq/Makefile
+++ b/arch/arm/mach-zynq/Makefile
@@ -3,7 +3,7 @@
 #

 # Common support
-obj-y				:= common.o slcr.o
+obj-y				:= common.o slcr.o zynq_ocm.o
 CFLAGS_REMOVE_hotplug.o		=-march=armv6k
 CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index b097844..953f6a1 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -24,6 +24,7 @@ extern int zynq_early_slcr_init(void);
 extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
 extern void zynq_slcr_cpu_start(int cpu);
+extern u32 zynq_slcr_get_ocm_config(void);

 #ifdef CONFIG_SMP
 extern void secondary_startup(void);
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index c1f1499..9a37ab3 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -26,6 +26,7 @@
 #define SLCR_PS_RST_CTRL_OFFSET		0x200 /* PS Software Reset Control */
 #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
 #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
+#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */

 #define SLCR_UNLOCK_MAGIC		0xDF0D
 #define SLCR_A9_CPU_CLKSTOP		0x10
@@ -107,6 +108,20 @@ void zynq_slcr_system_reset(void)
 }

 /**
+ * zynq_slcr_get_ocm_config - Get SLCR OCM config
+ *
+ * return:	OCM config bits
+ */
+u32 zynq_slcr_get_ocm_config(void)
+{
+	u32 val;
+
+	zynq_slcr_read(&val, SLCR_OCM_CFG_OFFSET);
+
+	return val;
+}
+
+/**
  * zynq_slcr_cpu_start - Start cpu
  * @cpu:	cpu number
  */
diff --git a/arch/arm/mach-zynq/zynq_ocm.c b/arch/arm/mach-zynq/zynq_ocm.c
new file mode 100644
index 0000000..034a65b
--- /dev/null
+++ b/arch/arm/mach-zynq/zynq_ocm.c
@@ -0,0 +1,243 @@
+/*
+ * Copyright (C) 2013 Xilinx
+ *
+ * Based on "Generic on-chip SRAM allocation driver"
+ *
+ * Copyright (C) 2012 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/genalloc.h>
+
+#include "common.h"
+
+#define ZYNQ_OCM_HIGHADDR	0xfffc0000
+#define ZYNQ_OCM_LOWADDR	0x0
+#define ZYNQ_OCM_BLOCK_SIZE	0x10000
+#define ZYNQ_OCM_BLOCKS		4
+#define ZYNQ_OCM_GRANULARITY	32
+
+#define ZYNQ_OCM_PARITY_CTRL	0x0
+#define ZYNQ_OCM_PARITY_ENABLE	0x1e
+
+#define ZYNQ_OCM_PARITY_ERRADDRESS	0x4
+
+#define ZYNQ_OCM_IRQ_STS		0x8
+#define ZYNQ_OCM_IRQ_STS_ERR_MASK	0x7
+
+struct zynq_ocm_dev {
+	void __iomem *base;
+	int irq;
+	struct gen_pool *pool;
+	struct resource res[ZYNQ_OCM_BLOCKS];
+};
+
+/**
+ * zynq_ocm_irq_handler - Interrupt service routine of the OCM controller
+ * @irq:        IRQ number
+ * @data:     Pointer to the zynq_ocm_dev structure
+ *
+ * returns:     IRQ_HANDLED always
+ */
+static irqreturn_t zynq_ocm_irq_handler(int irq, void *data)
+{
+	u32 sts;
+	u32 err_addr;
+	struct zynq_ocm_dev *zynq_ocm = data;
+
+	/* check status */
+	sts = readl(zynq_ocm->base + ZYNQ_OCM_IRQ_STS);
+	if (sts & ZYNQ_OCM_IRQ_STS_ERR_MASK) {
+		/* check error address */
+		err_addr = readl(zynq_ocm->base + ZYNQ_OCM_PARITY_ERRADDRESS);
+		pr_err("%s: OCM err intr generated at 0x%04x (stat: 0x%08x).",
+		       __func__, err_addr, sts & ZYNQ_OCM_IRQ_STS_ERR_MASK);
+	}
+	pr_warn("%s: Interrupt generated by OCM, but no error is found.",
+		__func__);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * zynq_ocm_probe - Probe method for the OCM driver
+ * @pdev:       Pointer to the platform_device structure
+ *
+ * This function initializes the driver data structures and the hardware.
+ *
+ * returns:     0 on success and error value on failure
+ */
+static int zynq_ocm_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct zynq_ocm_dev *zynq_ocm;
+	u32 i, ocm_config, curr;
+	struct resource *res;
+
+	ocm_config = zynq_slcr_get_ocm_config();
+
+	zynq_ocm = devm_kzalloc(&pdev->dev, sizeof(*zynq_ocm), GFP_KERNEL);
+	if (!zynq_ocm)
+		return -ENOMEM;
+
+	zynq_ocm->pool = devm_gen_pool_create(&pdev->dev,
+					      ilog2(ZYNQ_OCM_GRANULARITY), -1);
+	if (!zynq_ocm->pool)
+		return -ENOMEM;
+
+	curr = 0; /* For storing current struct resource for OCM */
+	for (i = 0; i < ZYNQ_OCM_BLOCKS; i++) {
+		u32 base, start, end;
+
+		/* Setup base address for 64kB OCM block */
+		if (ocm_config & BIT(i))
+			base = ZYNQ_OCM_HIGHADDR;
+		else
+			base = ZYNQ_OCM_LOWADDR;
+
+		/* Calculate start and end block addresses */
+		start = i * ZYNQ_OCM_BLOCK_SIZE + base;
+		end = start + (ZYNQ_OCM_BLOCK_SIZE - 1);
+
+		/* Concatenate OCM blocks together to get bigger pool */
+		if (i > 0 && start == (zynq_ocm->res[curr - 1].end + 1)) {
+			zynq_ocm->res[curr - 1].end = end;
+		} else {
+#ifdef CONFIG_SMP
+			/*
+			 * OCM block if placed at 0x0 has special meaning
+			 * for SMP because jump trampoline is added there.
+			 * Ensure that this address won't be allocated.
+			 */
+			if (!base) {
+				u32 trampoline_code_size =
+					&zynq_secondary_trampoline_end -
+					&zynq_secondary_trampoline;
+				dev_dbg(&pdev->dev,
+					"Allocate reset vector table %dB\n",
+					trampoline_code_size);
+				/* postpone start offset */
+				start += trampoline_code_size;
+			}
+#endif
+			/* First resource is always initialized */
+			zynq_ocm->res[curr].start = start;
+			zynq_ocm->res[curr].end = end;
+			zynq_ocm->res[curr].flags = IORESOURCE_MEM;
+			curr++; /* Increment curr value */
+		}
+		dev_dbg(&pdev->dev, "OCM block %d, start %x, end %x\n",
+			i, start, end);
+	}
+
+	/*
+	 * Separate pool allocation from OCM block detection to ensure
+	 * the biggest possible pool.
+	 */
+	for (i = 0; i < ZYNQ_OCM_BLOCKS; i++) {
+		unsigned long size;
+		void __iomem *virt_base;
+
+		/* Skip all zero size resources */
+		if (zynq_ocm->res[i].end == 0)
+			break;
+		dev_dbg(&pdev->dev, "OCM resources %d, start %x, end %x\n",
+			i, zynq_ocm->res[i].start, zynq_ocm->res[i].end);
+		size = resource_size(&zynq_ocm->res[i]);
+		virt_base = devm_ioremap_resource(&pdev->dev,
+						  &zynq_ocm->res[i]);
+		if (IS_ERR(virt_base))
+			return PTR_ERR(virt_base);
+
+		ret = gen_pool_add_virt(zynq_ocm->pool,
+					(unsigned long)virt_base,
+					zynq_ocm->res[i].start, size, -1);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Gen pool failed\n");
+			return ret;
+		}
+		dev_info(&pdev->dev, "ZYNQ OCM pool: %ld KiB @ 0x%p\n",
+			 size / 1024, virt_base);
+	}
+
+	/* Get OCM config space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	zynq_ocm->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(zynq_ocm->base))
+		return PTR_ERR(zynq_ocm->base);
+
+	/* Allocate OCM parity IRQ */
+	zynq_ocm->irq = platform_get_irq(pdev, 0);
+	if (zynq_ocm->irq < 0) {
+		dev_err(&pdev->dev, "irq resource not found\n");
+		return zynq_ocm->irq;
+	}
+	ret = devm_request_irq(&pdev->dev, zynq_ocm->irq, zynq_ocm_irq_handler,
+			       0, pdev->name, zynq_ocm);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		return ret;
+	}
+
+	/* Enable parity errors */
+	writel(ZYNQ_OCM_PARITY_ENABLE, zynq_ocm->base + ZYNQ_OCM_PARITY_CTRL);
+
+	platform_set_drvdata(pdev, zynq_ocm);
+
+	return 0;
+}
+
+/**
+ * zynq_ocm_remove - Remove method for the OCM driver
+ * @pdev:       Pointer to the platform_device structure
+ *
+ * This function is called if a device is physically removed from the system or
+ * if the driver module is being unloaded. It frees all resources allocated to
+ * the device.
+ *
+ * returns:     0 on success and error value on failure
+ */
+static int zynq_ocm_remove(struct platform_device *pdev)
+{
+	struct zynq_ocm_dev *zynq_ocm = platform_get_drvdata(pdev);
+
+	if (gen_pool_avail(zynq_ocm->pool) < gen_pool_size(zynq_ocm->pool))
+		dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
+
+	return 0;
+}
+
+static struct of_device_id zynq_ocm_dt_ids[] = {
+	{ .compatible = "xlnx,zynq-ocm-1.0" },
+	{ /* end of table */ }
+};
+
+static struct platform_driver zynq_ocm_driver = {
+	.driver = {
+		.name = "zynq_ocm",
+		.of_match_table = zynq_ocm_dt_ids,
+	},
+	.probe = zynq_ocm_probe,
+	.remove = zynq_ocm_remove,
+};
+
+static int __init zynq_ocm_init(void)
+{
+	return platform_driver_register(&zynq_ocm_driver);
+}
+
+arch_initcall(zynq_ocm_init);
--
1.8.2.3


--=_mimegpg-monstr-desktop-20335-1389022569-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKzWkACgkQykllyylKDCHySgCfaLma0+5r86wnjdBWXPzT4zoq
VV4AnisVQb4jH7M2ZY56Fbfh5zQNiq+V
=8W5I
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20335-1389022569-0001--
