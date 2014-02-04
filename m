Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbaBDVNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:13:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934643AbaBDVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 107/140] ARM: mvebu: Add support to get the ID and the revision of a SoC
Date: Tue,  4 Feb 2014 13:11:34 -0800
Message-Id: <20140204211040.032259646@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit af8d1c63afcbf36eea06789c92e22d4af118d2fb upstream.

All the mvebu SoCs have information related to their variant and
revision that can be read from the PCI control register.

This patch adds support for Armada XP and Armada 370. This reading of
the revision and the ID are done before the PCI initialization to
avoid any conflicts. Once these data are retrieved, the resources are
freed to let the PCI subsystem use it.

Fixes: 930ab3d403ae (i2c: mv64xxx: Add I2C Transaction Generator support)
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/Makefile       |    2 
 arch/arm/mach-mvebu/mvebu-soc-id.c |  119 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mvebu/mvebu-soc-id.h |   32 +++++++++
 3 files changed, 152 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-mvebu/Makefile
+++ b/arch/arm/mach-mvebu/Makefile
@@ -3,7 +3,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) :=
 
 AFLAGS_coherency_ll.o		:= -Wa,-march=armv7-a
 
-obj-y				 += system-controller.o
+obj-y				 += system-controller.o mvebu-soc-id.o
 obj-$(CONFIG_MACH_ARMADA_370_XP) += armada-370-xp.o
 obj-$(CONFIG_ARCH_MVEBU)	 += coherency.o coherency_ll.o pmsu.o
 obj-$(CONFIG_SMP)                += platsmp.o headsmp.o
--- /dev/null
+++ b/arch/arm/mach-mvebu/mvebu-soc-id.c
@@ -0,0 +1,119 @@
+/*
+ * ID and revision information for mvebu SoCs
+ *
+ * Copyright (C) 2014 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * All the mvebu SoCs have information related to their variant and
+ * revision that can be read from the PCI control register. This is
+ * done before the PCI initialization to avoid any conflict. Once the
+ * ID and revision are retrieved, the mapping is freed.
+ */
+
+#define pr_fmt(fmt) "mvebu-soc-id: " fmt
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include "mvebu-soc-id.h"
+
+#define PCIE_DEV_ID_OFF		0x0
+#define PCIE_DEV_REV_OFF	0x8
+
+#define SOC_ID_MASK	    0xFFFF0000
+#define SOC_REV_MASK	    0xFF
+
+static u32 soc_dev_id;
+static u32 soc_rev;
+static bool is_id_valid;
+
+static const struct of_device_id mvebu_pcie_of_match_table[] = {
+	{ .compatible = "marvell,armada-xp-pcie", },
+	{ .compatible = "marvell,armada-370-pcie", },
+	{},
+};
+
+int mvebu_get_soc_id(u32 *dev, u32 *rev)
+{
+	if (is_id_valid) {
+		*dev = soc_dev_id;
+		*rev = soc_rev;
+		return 0;
+	} else
+		return -1;
+}
+
+static int __init mvebu_soc_id_init(void)
+{
+	struct device_node *np;
+	int ret = 0;
+	void __iomem *pci_base;
+	struct clk *clk;
+	struct device_node *child;
+
+	np = of_find_matching_node(NULL, mvebu_pcie_of_match_table);
+	if (!np)
+		return ret;
+
+	/*
+	 * ID and revision are available from any port, so we
+	 * just pick the first one
+	 */
+	child = of_get_next_child(np, NULL);
+	if (child == NULL) {
+		pr_err("cannot get pci node\n");
+		ret = -ENOMEM;
+		goto clk_err;
+	}
+
+	clk = of_clk_get_by_name(child, NULL);
+	if (IS_ERR(clk)) {
+		pr_err("cannot get clock\n");
+		ret = -ENOMEM;
+		goto clk_err;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("cannot enable clock\n");
+		goto clk_err;
+	}
+
+	pci_base = of_iomap(child, 0);
+	if (IS_ERR(pci_base)) {
+		pr_err("cannot map registers\n");
+		ret = -ENOMEM;
+		goto res_ioremap;
+	}
+
+	/* SoC ID */
+	soc_dev_id = readl(pci_base + PCIE_DEV_ID_OFF) >> 16;
+
+	/* SoC revision */
+	soc_rev = readl(pci_base + PCIE_DEV_REV_OFF) & SOC_REV_MASK;
+
+	is_id_valid = true;
+
+	pr_info("MVEBU SoC ID=0x%X, Rev=0x%X\n", soc_dev_id, soc_rev);
+
+	iounmap(pci_base);
+
+res_ioremap:
+	clk_disable_unprepare(clk);
+
+clk_err:
+	of_node_put(child);
+	of_node_put(np);
+
+	return ret;
+}
+core_initcall(mvebu_soc_id_init);
+
--- /dev/null
+++ b/arch/arm/mach-mvebu/mvebu-soc-id.h
@@ -0,0 +1,32 @@
+/*
+ * Marvell EBU SoC ID and revision definitions.
+ *
+ * Copyright (C) 2014 Marvell Semiconductor
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __LINUX_MVEBU_SOC_ID_H
+#define __LINUX_MVEBU_SOC_ID_H
+
+/* Armada XP ID */
+#define MV78230_DEV_ID	    0x7823
+#define MV78260_DEV_ID	    0x7826
+#define MV78460_DEV_ID	    0x7846
+
+/* Armada XP Revision */
+#define MV78XX0_A0_REV	    0x1
+#define MV78XX0_B0_REV	    0x2
+
+#ifdef CONFIG_ARCH_MVEBU
+int mvebu_get_soc_id(u32 *dev, u32 *rev);
+#else
+static inline int mvebu_get_soc_id(u32 *dev, u32 *rev)
+{
+	return -1;
+}
+#endif
+
+#endif /* __LINUX_MVEBU_SOC_ID_H */


