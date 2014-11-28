Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaK1CVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:21:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48731 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaK1CVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:21:49 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>, <arnd@arndb.de>, <yanhaifeng@gmail.com>,
        <zhangfei.gao@linaro.org>, <haojian.zhuang@linaro.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <jason@lakedaemon.net>, <jh80.chung@samsung.com>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <mark.rutland@arm.com>,
        <maxime.ripard@free-electrons.com>, <obh+dt@kernel.org>,
        <olof@lixom.net>, <pawel.moll@arm.com>, <swarren@nvidia.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 7/7] ARM: hisi: enable smp for HiP01
Date: Fri, 28 Nov 2014 02:15:50 +0000
Message-ID: <1417140950-67103-8-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
References: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable smp for HiP01 board.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/boot/dts/hip01-ca9x2.dts |  1 +
 arch/arm/mach-hisi/core.h         |  3 +++
 arch/arm/mach-hisi/hotplug.c      | 31 ++++++++++++++++++++++++
 arch/arm/mach-hisi/platsmp.c      | 50 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+)

diff --git a/arch/arm/boot/dts/hip01-ca9x2.dts b/arch/arm/boot/dts/hip01-ca9x2.dts
index 619d024..605d6b3 100644
--- a/arch/arm/boot/dts/hip01-ca9x2.dts
+++ b/arch/arm/boot/dts/hip01-ca9x2.dts
@@ -25,6 +25,7 @@
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
+		enable-method = "hisilicon,hip01-smp";
 
 		cpu@0 {
 			device_type = "cpu";
diff --git a/arch/arm/mach-hisi/core.h b/arch/arm/mach-hisi/core.h
index 75520b0..92a682d 100644
--- a/arch/arm/mach-hisi/core.h
+++ b/arch/arm/mach-hisi/core.h
@@ -17,4 +17,7 @@ extern struct smp_operations hix5hd2_smp_ops;
 extern void hix5hd2_set_cpu(int cpu, bool enable);
 extern void hix5hd2_cpu_die(unsigned int cpu);
 
+extern struct smp_operations hip01_smp_ops;
+extern void hip01_set_cpu(int cpu, bool enable);
+extern void hip01_cpu_die(unsigned int cpu);
 #endif
diff --git a/arch/arm/mach-hisi/hotplug.c b/arch/arm/mach-hisi/hotplug.c
index 84e6919..a129aae 100644
--- a/arch/arm/mach-hisi/hotplug.c
+++ b/arch/arm/mach-hisi/hotplug.c
@@ -65,6 +65,9 @@
 #define PMC0_CPU1_PMC_ENABLE		(1 << 7)
 #define PMC0_CPU1_POWERDOWN		(1 << 3)
 
+#define HIP01_PERI9                    0x50
+#define PERI9_CPU1_RESET               (1 << 1)
+
 enum {
 	HI3620_CTRL,
 	ERROR_CTRL,
@@ -209,6 +212,34 @@ void hix5hd2_set_cpu(int cpu, bool enable)
 	}
 }
 
+void hip01_set_cpu(int cpu, bool enable)
+{
+	unsigned int temp;
+	struct device_node *np;
+
+	if (!ctrl_base) {
+		np = of_find_compatible_node(NULL, NULL, "hisilicon,hip01-sysctrl");
+		if (np)
+			ctrl_base = of_iomap(np, 0);
+		else
+			BUG();
+	}
+
+	if (enable) {
+		/* reset on CPU1  */
+		temp = readl_relaxed(ctrl_base + HIP01_PERI9);
+		temp |= PERI9_CPU1_RESET;
+		writel_relaxed(temp, ctrl_base + HIP01_PERI9);
+
+		udelay(50);
+
+		/* unreset on CPU1 */
+		temp = readl_relaxed(ctrl_base + HIP01_PERI9);
+		temp &= ~PERI9_CPU1_RESET;
+		writel_relaxed(temp, ctrl_base + HIP01_PERI9);
+	}
+}
+
 static inline void cpu_enter_lowpower(void)
 {
 	unsigned int v;
diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index 4a70f56..8880c8e 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -10,10 +10,12 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
+#include <linux/delay.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
+#include <asm/mach/map.h>
 
 #include "core.h"
 
@@ -132,5 +134,53 @@ struct smp_operations hix5hd2_smp_ops __initdata = {
 #endif
 };
 
+
+#define SC_SCTL_REMAP_CLR      0x00000100
+#define HIP01_BOOT_ADDRESS     0x80000000
+#define REG_SC_CTRL            0x000
+
+void hip01_set_boot_addr(phys_addr_t start_addr, phys_addr_t jump_addr)
+{
+	void __iomem *virt;
+
+	virt = phys_to_virt(start_addr);
+
+	writel_relaxed(0xe51ff004, virt);
+	writel_relaxed(jump_addr, virt + 4);
+}
+
+static int hip01_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	phys_addr_t jumpaddr;
+	unsigned int remap_reg_value = 0;
+	struct device_node *node;
+
+
+	jumpaddr = virt_to_phys(hisi_secondary_startup);
+	hip01_set_boot_addr(HIP01_BOOT_ADDRESS, jumpaddr);
+
+	node = of_find_compatible_node(NULL, NULL, "hisilicon,hip01-sysctrl");
+	if (WARN_ON(!node))
+		return -1;
+	ctrl_base = of_iomap(node, 0);
+
+	/* set the secondary core boot from DDR */
+	remap_reg_value = readl_relaxed(ctrl_base + REG_SC_CTRL);
+	barrier();
+	remap_reg_value |= SC_SCTL_REMAP_CLR;
+	barrier();
+	writel_relaxed(remap_reg_value, ctrl_base + REG_SC_CTRL);
+
+	hip01_set_cpu(cpu, true);
+
+	return 0;
+}
+
+struct smp_operations hip01_smp_ops __initdata = {
+	.smp_prepare_cpus       = hisi_common_smp_prepare_cpus,
+	.smp_boot_secondary     = hip01_boot_secondary,
+};
+
 CPU_METHOD_OF_DECLARE(hi3xxx_smp, "hisilicon,hi3620-smp", &hi3xxx_smp_ops);
 CPU_METHOD_OF_DECLARE(hix5hd2_smp, "hisilicon,hix5hd2-smp", &hix5hd2_smp_ops);
+CPU_METHOD_OF_DECLARE(hip01_smp, "hisilicon,hip01-smp", &hip01_smp_ops);
-- 
1.8.3.4

