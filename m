Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaLAN0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:26:15 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60733 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaLANZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:19 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Sandeep Nair <sandeep_n@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v5 6/7] ARM: zynq: Add OCM controller driver
Date: Mon,  1 Dec 2014 14:24:57 +0100
Message-Id: <4788755d350890d81f1bac4bf237c5ddfb68b795.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3316-1417440315-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3316-1417440315-0001

The driver provide memory allocator which can
be used by others drivers to allocate memory inside OCM.
All locations for 64kB blocks are supported
and driver is trying to allocate the largest continuous
block of memory.

Checking mpcore addressing filterring is not done here
but could be added in future.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---

Changes in v5:
- Fix commit message reported by Linus W
- Use SZ_64K instead size in HEX reported by Linus W
- Fix dev_dbg message for allocate reset vector table
- Detect start address not base for SMP trampoline allocation
- Move binding to separate patch

Changes in v4:
- Use }; instead of } ; in doc
- Use memory-controller@... instead of ocmc@...
- Create Kconfig entry for OCMC driver - enable GENERIC_ALLOCATOR here
- Add entry to MAINTAINERS file

Changes in v3:
- Move OCM to drivers/soc
- Update year
- Extract DTS node to be able to apply it out of driver
- Remove generic allocator enabling
- Extract SLCR part
- Use const in of_device_id
- OCM->OCMC
- Use ocmc-1.0 compatible string

Changes in v2:
- Change compatibility string to be in xilinx format
- Fix kernel-doc format

 MAINTAINERS                  |   1 +
 drivers/soc/Kconfig          |   1 +
 drivers/soc/Makefile         |   1 +
 drivers/soc/zynq/Kconfig     |  13 +++
 drivers/soc/zynq/Makefile    |   1 +
 drivers/soc/zynq/zynq_ocmc.c | 249 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 266 insertions(+)
 create mode 100644 drivers/soc/zynq/Kconfig
 create mode 100644 drivers/soc/zynq/Makefile
 create mode 100644 drivers/soc/zynq/zynq_ocmc.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b6ed1f667ad..ad56d68273fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1550,6 +1550,7 @@ S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
 F:	drivers/block/xsysace.c
+F:	drivers/soc/zynq/
 F:	include/soc/zynq/
 N:	zynq
 N:	xilinx
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4da138..25cc114a982d 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -3,5 +3,6 @@ menu "SOC (System On Chip) specific Drivers"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
+source "drivers/soc/zynq/Kconfig"

 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d0bd38..77a7865a3367 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
+obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
diff --git a/drivers/soc/zynq/Kconfig b/drivers/soc/zynq/Kconfig
new file mode 100644
index 000000000000..0163c54acbc6
--- /dev/null
+++ b/drivers/soc/zynq/Kconfig
@@ -0,0 +1,13 @@
+#
+# Xilnx Zynq SoC drivers
+#
+
+if ARCH_ZYNQ
+
+config ZYNQ_OCMC
+	def_bool y
+	select GENERIC_ALLOCATOR
+	help
+	  Xilinx Zynq On Chip Memory Controller driver
+
+endif
diff --git a/drivers/soc/zynq/Makefile b/drivers/soc/zynq/Makefile
new file mode 100644
index 000000000000..807c9b83850d
--- /dev/null
+++ b/drivers/soc/zynq/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ZYNQ_OCMC) += zynq_ocmc.o
diff --git a/drivers/soc/zynq/zynq_ocmc.c b/drivers/soc/zynq/zynq_ocmc.c
new file mode 100644
index 000000000000..1237ff702ad0
--- /dev/null
+++ b/drivers/soc/zynq/zynq_ocmc.c
@@ -0,0 +1,249 @@
+/*
+ * Copyright (C) 2013 - 2014 Xilinx
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
+#include <linux/err.h>
+#include <linux/genalloc.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+
+#include <soc/zynq/slcr.h>
+#include <soc/zynq/smp.h>
+
+#define ZYNQ_OCMC_HIGHADDR	0xfffc0000
+#define ZYNQ_OCMC_LOWADDR	0x0
+#define ZYNQ_OCMC_BLOCK_SIZE	SZ_64K
+#define ZYNQ_OCMC_BLOCKS		4
+#define ZYNQ_OCMC_GRANULARITY	32
+
+#define ZYNQ_OCMC_PARITY_CTRL	0x0
+#define ZYNQ_OCMC_PARITY_ENABLE	0x1e
+
+#define ZYNQ_OCMC_PARITY_ERRADDRESS	0x4
+
+#define ZYNQ_OCMC_IRQ_STS		0x8
+#define ZYNQ_OCMC_IRQ_STS_ERR_MASK	0x7
+
+struct zynq_ocmc_dev {
+	void __iomem *base;
+	int irq;
+	struct gen_pool *pool;
+	struct resource res[ZYNQ_OCMC_BLOCKS];
+};
+
+/**
+ * zynq_ocmc_irq_handler - Interrupt service routine of the OCM controller
+ * @irq:	IRQ number
+ * @data:	Pointer to the zynq_ocmc_dev structure
+ *
+ * Return:     IRQ_HANDLED always
+ */
+static irqreturn_t zynq_ocmc_irq_handler(int irq, void *data)
+{
+	u32 sts;
+	u32 err_addr;
+	struct zynq_ocmc_dev *zynq_ocmc = data;
+
+	/* check status */
+	sts = readl(zynq_ocmc->base + ZYNQ_OCMC_IRQ_STS);
+	if (sts & ZYNQ_OCMC_IRQ_STS_ERR_MASK) {
+		/* check error address */
+		err_addr = readl(zynq_ocmc->base + ZYNQ_OCMC_PARITY_ERRADDRESS);
+		pr_err("%s: OCM err intr generated at 0x%04x (stat: 0x%08x).",
+		       __func__, err_addr, sts & ZYNQ_OCMC_IRQ_STS_ERR_MASK);
+	}
+	pr_warn("%s: Interrupt generated by OCM, but no error is found.",
+		__func__);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * zynq_ocmc_probe - Probe method for the OCM driver
+ * @pdev:	Pointer to the platform_device structure
+ *
+ * This function initializes the driver data structures and the hardware.
+ *
+ * Return:	0 on success and error value on failure
+ */
+static int zynq_ocmc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct zynq_ocmc_dev *zynq_ocmc;
+	u32 i, ocm_config, curr;
+	struct resource *res;
+
+	ocm_config = zynq_slcr_get_ocm_config();
+
+	zynq_ocmc = devm_kzalloc(&pdev->dev, sizeof(*zynq_ocmc), GFP_KERNEL);
+	if (!zynq_ocmc)
+		return -ENOMEM;
+
+	zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
+					       ilog2(ZYNQ_OCMC_GRANULARITY),
+					       -1);
+	if (!zynq_ocmc->pool)
+		return -ENOMEM;
+
+	curr = 0; /* For storing current struct resource for OCM */
+	for (i = 0; i < ZYNQ_OCMC_BLOCKS; i++) {
+		u32 base, start, end;
+
+		/* Setup base address for 64kB OCM block */
+		if (ocm_config & BIT(i))
+			base = ZYNQ_OCMC_HIGHADDR;
+		else
+			base = ZYNQ_OCMC_LOWADDR;
+
+		/* Calculate start and end block addresses */
+		start = i * ZYNQ_OCMC_BLOCK_SIZE + base;
+		end = start + (ZYNQ_OCMC_BLOCK_SIZE - 1);
+
+		/* Concatenate OCM blocks together to get bigger pool */
+		if (i > 0 && start == (zynq_ocmc->res[curr - 1].end + 1)) {
+			zynq_ocmc->res[curr - 1].end = end;
+		} else {
+#ifdef CONFIG_SMP
+			/*
+			 * OCM block if placed at 0x0 has special meaning
+			 * for SMP because jump trampoline is added there.
+			 * Ensure that this address won't be allocated.
+			 */
+			if (!start) {
+				u32 trampoline_code_size =
+					&zynq_secondary_trampoline_end -
+					&zynq_secondary_trampoline;
+				dev_dbg(&pdev->dev,
+					"Allocate reset vector table %dBytes\n",
+					trampoline_code_size);
+				/* Postpone start offset */
+				start += trampoline_code_size;
+			}
+#endif
+			/* First resource is always initialized */
+			zynq_ocmc->res[curr].start = start;
+			zynq_ocmc->res[curr].end = end;
+			zynq_ocmc->res[curr].flags = IORESOURCE_MEM;
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
+	for (i = 0; i < ZYNQ_OCMC_BLOCKS; i++) {
+		unsigned long size;
+		void __iomem *virt_base;
+
+		/* Skip all zero size resources */
+		if (zynq_ocmc->res[i].end == 0)
+			break;
+		dev_dbg(&pdev->dev, "OCM resources %d, start %x, end %x\n",
+			i, zynq_ocmc->res[i].start, zynq_ocmc->res[i].end);
+		size = resource_size(&zynq_ocmc->res[i]);
+		virt_base = devm_ioremap_resource(&pdev->dev,
+						  &zynq_ocmc->res[i]);
+		if (IS_ERR(virt_base))
+			return PTR_ERR(virt_base);
+
+		ret = gen_pool_add_virt(zynq_ocmc->pool,
+					(unsigned long)virt_base,
+					zynq_ocmc->res[i].start, size, -1);
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
+	zynq_ocmc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(zynq_ocmc->base))
+		return PTR_ERR(zynq_ocmc->base);
+
+	/* Allocate OCM parity IRQ */
+	zynq_ocmc->irq = platform_get_irq(pdev, 0);
+	if (zynq_ocmc->irq < 0) {
+		dev_err(&pdev->dev, "irq resource not found\n");
+		return zynq_ocmc->irq;
+	}
+	ret = devm_request_irq(&pdev->dev, zynq_ocmc->irq,
+			       zynq_ocmc_irq_handler,
+			       0, pdev->name, zynq_ocmc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		return ret;
+	}
+
+	/* Enable parity errors */
+	writel(ZYNQ_OCMC_PARITY_ENABLE,
+	       zynq_ocmc->base + ZYNQ_OCMC_PARITY_CTRL);
+
+	platform_set_drvdata(pdev, zynq_ocmc);
+
+	return 0;
+}
+
+/**
+ * zynq_ocmc_remove - Remove method for the OCM driver
+ * @pdev:	Pointer to the platform_device structure
+ *
+ * Return:	0 on success and error value on failure
+ *
+ * This function is called if a device is physically removed from the system or
+ * if the driver module is being unloaded. It frees all resources allocated to
+ * the device.
+ */
+static int zynq_ocmc_remove(struct platform_device *pdev)
+{
+	struct zynq_ocmc_dev *zynq_ocmc = platform_get_drvdata(pdev);
+
+	dev_info(&pdev->dev, "Removed\n");
+	if (gen_pool_avail(zynq_ocmc->pool) < gen_pool_size(zynq_ocmc->pool))
+		dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
+
+	return 0;
+}
+
+static const struct of_device_id zynq_ocmc_dt_ids[] = {
+	{ .compatible = "xlnx,zynq-ocmc-1.0" },
+	{ /* end of table */ }
+};
+
+static struct platform_driver zynq_ocmc_driver = {
+	.driver = {
+		.name = "zynq_ocmc",
+		.of_match_table = zynq_ocmc_dt_ids,
+	},
+	.probe = zynq_ocmc_probe,
+	.remove = zynq_ocmc_remove,
+};
+
+static int __init zynq_ocmc_init(void)
+{
+	return platform_driver_register(&zynq_ocmc_driver);
+}
+
+arch_initcall(zynq_ocmc_init);
--
1.8.2.3


--=_mimegpg-monstr-desktop-3316-1417440315-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bDsACgkQykllyylKDCHGWwCffGWBexcPBqrjoLL8H9umjNE8
iKIAoIFCV5ewnJIjkjMsvWPGpemFf1SM
=QYmu
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3316-1417440315-0001--
