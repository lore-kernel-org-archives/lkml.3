Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaBJKag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:30:36 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55471 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaBJKad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:30:33 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Add support for SOC_BUS
Date: Mon, 10 Feb 2014 11:30:22 +0100
Message-Id: <279a88555538534075921b0a8a26ff9b0c49317d.1392028209.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21142-1392028222-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21142-1392028222-0001

Provide information through SOC_BUS to user space.
Silicon revision is provided through devcfg device.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Based on zynq/cleanup branch

---
 arch/arm/boot/dts/zynq-7000.dtsi |  5 +++
 arch/arm/mach-zynq/Kconfig       |  1 +
 arch/arm/mach-zynq/common.c      | 72 +++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-zynq/common.h      |  1 +
 arch/arm/mach-zynq/slcr.c        | 19 +++++++++++
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 116f83b5..7284499 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -155,6 +155,11 @@
 			};
 		};

+		devcfg: devcfg@f8007000 {
+			compatible = "xlnx,zynq-devcfg-1.00.a";
+			reg = <0xf8007000 0x100>;
+		} ;
+
 		global_timer: timer@f8f00200 {
 			compatible = "arm,cortex-a9-global-timer";
 			reg = <0xf8f00200 0x20>;
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index f3e6ce4..16ba63f 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -16,5 +16,6 @@ config ARCH_ZYNQ
 	select ARM_GLOBAL_TIMER
 	select MFD_SYSCON
 	select GENERIC_ALLOCATOR
+	select SOC_BUS
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5755129..9d3c88e 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -28,6 +28,8 @@
 #include <linux/of.h>
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>

 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -36,10 +38,15 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/smp_scu.h>
+#include <asm/system_info.h>
 #include <asm/hardware/cache-l2x0.h>

 #include "common.h"

+#define ZYNQ_DEVCFG_MCTRL		0x80
+#define ZYNQ_DEVCFG_PS_VERSION_SHIFT	28
+#define ZYNQ_DEVCFG_PS_VERSION_MASK	0xF
+
 void __iomem *zynq_scu_base;

 static struct platform_device zynq_cpuidle_device = {
@@ -47,17 +54,80 @@ static struct platform_device zynq_cpuidle_device = {
 };

 /**
+ * zynq_get_revision - Get Zynq silicon revision
+ *
+ * Return: Silicon version or -1 otherwise
+ */
+static int __init zynq_get_revision(void)
+{
+	struct device_node *np;
+	void __iomem *zynq_devcfg_base;
+	u32 revision;
+
+	np = of_find_compatible_node(NULL, NULL, "xlnx,zynq-devcfg-1.00.a");
+	if (!np) {
+		pr_err("%s: no devcfg node found\n", __func__);
+		return -1;
+	}
+
+	zynq_devcfg_base = of_iomap(np, 0);
+	if (!zynq_devcfg_base) {
+		pr_err("%s: Unable to map I/O memory\n", __func__);
+		return -1;
+	}
+
+	revision = readl(zynq_devcfg_base + ZYNQ_DEVCFG_MCTRL);
+	revision >>= ZYNQ_DEVCFG_PS_VERSION_SHIFT;
+	revision &= ZYNQ_DEVCFG_PS_VERSION_MASK;
+
+	iounmap(zynq_devcfg_base);
+
+	return revision;
+}
+
+/**
  * zynq_init_machine - System specific initialization, intended to be
  *		       called from board specific initialization.
  */
 static void __init zynq_init_machine(void)
 {
+	struct soc_device_attribute *soc_dev_attr;
+	struct soc_device *soc_dev;
+	struct device *parent = NULL;
+
 	/*
 	 * 64KB way size, 8-way associativity, parity disabled
 	 */
 	l2x0_of_init(0x02060000, 0xF0F0FFFF);

-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		goto out;
+
+	system_rev = zynq_get_revision();
+
+	soc_dev_attr->family = kasprintf(GFP_KERNEL, "Xilinx Zynq");
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "0x%x", system_rev);
+	soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "0x%x",
+					 zynq_slcr_get_device_id());
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(soc_dev)) {
+		kfree(soc_dev_attr->family);
+		kfree(soc_dev_attr->revision);
+		kfree(soc_dev_attr->soc_id);
+		kfree(soc_dev_attr);
+		goto out;
+	}
+
+	parent = soc_device_to_device(soc_dev);
+
+out:
+	/*
+	 * Finished with the static registrations now; fill in the missing
+	 * devices
+	 */
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);

 	platform_device_register(&zynq_cpuidle_device);

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 953f6a1..26a23fe 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -25,6 +25,7 @@ extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
 extern void zynq_slcr_cpu_start(int cpu);
 extern u32 zynq_slcr_get_ocm_config(void);
+extern u32 zynq_slcr_get_device_id(void);

 #ifdef CONFIG_SMP
 extern void secondary_startup(void);
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index f310081..594b280 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -26,11 +26,14 @@
 #define SLCR_PS_RST_CTRL_OFFSET		0x200 /* PS Software Reset Control */
 #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
 #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
+#define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
 #define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */

 #define SLCR_UNLOCK_MAGIC		0xDF0D
 #define SLCR_A9_CPU_CLKSTOP		0x10
 #define SLCR_A9_CPU_RST			0x1
+#define SLCR_PSS_IDCODE_DEVICE_SHIFT	12
+#define SLCR_PSS_IDCODE_DEVICE_MASK	0x1F

 static void __iomem *zynq_slcr_base;
 static struct regmap *zynq_slcr_regmap;
@@ -84,6 +87,22 @@ static inline int zynq_slcr_unlock(void)
 }

 /**
+ * zynq_slcr_get_device_id - Read device code id
+ *
+ * Return:	Device code id
+ */
+u32 zynq_slcr_get_device_id(void)
+{
+	u32 val;
+
+	zynq_slcr_read(&val, SLCR_PSS_IDCODE);
+	val >>= SLCR_PSS_IDCODE_DEVICE_SHIFT;
+	val &= SLCR_PSS_IDCODE_DEVICE_MASK;
+
+	return val;
+}
+
+/**
  * zynq_slcr_system_reset - Reset the entire system.
  */
 void zynq_slcr_system_reset(void)
--
1.8.2.3


--=_mimegpg-monstr-desktop-21142-1392028222-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL4qj4ACgkQykllyylKDCGKcQCZAWktN+dhuS9XaMH3Rws/fylf
YC0AnAzYwMX5PNo4IU49UKFe7xT8+P/W
=kxfl
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21142-1392028222-0001--
