Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKGQy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:54:56 -0500
Received: from mail-bl2on0076.outbound.protection.outlook.com ([65.55.169.76]:53792
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752233AbaKGQyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:54:54 -0500
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv4 2/5] arm: socfpga: Enable OCRAM ECC on startup.
Date: Fri, 7 Nov 2014 10:54:19 -0600
Message-ID: <1415379263-12391-3-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
References: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: GRUPR80CA004.lamprd80.prod.outlook.com (10.242.28.14) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(95666004)(76176999)(19580405001)(19580395003)(102836001)(40100003)(105586002)(106356001)(21056001)(107046002)(81156004)(77096003)(97736003)(101416001)(33646002)(62966003)(50226001)(4396001)(575784001)(69596002)(48376002)(86152002)(93916002)(92566001)(77156002)(92726001)(86362001)(104166001)(2201001)(31966008)(20776003)(99396003)(64706001)(53416004)(120916001)(89996001)(42186005)(15975445006)(47776003)(15202345003)(50986999)(229853001)(66066001)(50466002)(88136002)(122386002)(46102003)(87286001)(87976001)(1121002)(2004002)(921003)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

This patch enables the ECC for On-Chip RAM on machine
startup.  The ECC has to be enabled before data is
is stored in memory otherwise the ECC will fail on
reads.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Split OCRAM ECC portion separately. Addition of iounmap()
and reorganization of gen_pool_free. Remove defconfig from patch.

v3/4: No change
---
 MAINTAINERS                     |    1 +
 arch/arm/mach-socfpga/Makefile  |    1 +
 arch/arm/mach-socfpga/ocram.c   |   90 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/ocram.h   |   28 ++++++++++++
 arch/arm/mach-socfpga/socfpga.c |    8 ++++
 5 files changed, 128 insertions(+)
 create mode 100644 arch/arm/mach-socfpga/ocram.c
 create mode 100644 arch/arm/mach-socfpga/ocram.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d0c7752..c6d390e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1408,6 +1408,7 @@ M:	Thor Thayer <tthayer@opensource.altera.com>
 S:	Maintained
 F:	drivers/edac/altera_edac.
 F:	arch/arm/mach-socfpga/l2_cache.*
+F:	arch/arm/mach-socfpga/ocram.*
 
 ARM/STI ARCHITECTURE
 M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
index 142609e..1552ca5 100644
--- a/arch/arm/mach-socfpga/Makefile
+++ b/arch/arm/mach-socfpga/Makefile
@@ -5,3 +5,4 @@
 obj-y					:= socfpga.o
 obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
 obj-$(CONFIG_EDAC_ALTERA_L2C) += l2_cache.o
+obj-$(CONFIG_EDAC_ALTERA_OCRAM) += ocram.o
diff --git a/arch/arm/mach-socfpga/ocram.c b/arch/arm/mach-socfpga/ocram.c
new file mode 100644
index 0000000..9136009
--- /dev/null
+++ b/arch/arm/mach-socfpga/ocram.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/clk-provider.h>
+#include <linux/genalloc.h>
+#include <linux/of_platform.h>
+
+#include "ocram.h"
+
+void socfpga_init_ocram_ecc(void)
+{
+	struct device_node *np;
+	const __be32 *prop;
+	u32 ocr_edac_addr, iram_addr, len;
+	void __iomem  *mapped_ocr_edac_addr;
+	size_t size;
+	struct gen_pool *gp;
+
+	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find altr,ocram-edac in dtb\n");
+		return;
+	}
+
+	prop = of_get_property(np, "reg", &size);
+	ocr_edac_addr = be32_to_cpup(prop++);
+	len = be32_to_cpup(prop);
+	if (!prop || size < sizeof(*prop)) {
+		pr_err("SOCFPGA: Unable to find OCRAM ECC mapping in dtb\n");
+		return;
+	}
+
+	gp = of_get_named_gen_pool(np, "iram", 0);
+	if (!gp) {
+		pr_err("SOCFPGA: OCRAM cannot find gen pool\n");
+		return;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find mmio-sram in dtb\n");
+		return;
+	}
+	/* Determine the OCRAM address and size */
+	prop = of_get_property(np, "reg", &size);
+	iram_addr = be32_to_cpup(prop++);
+	len = be32_to_cpup(prop);
+
+	if (!prop || size < sizeof(*prop)) {
+		pr_err("SOCFPGA: Unable to find OCRAM mapping in dtb\n");
+		return;
+	}
+
+	iram_addr = gen_pool_alloc(gp, len);
+	if (iram_addr == 0) {
+		pr_err("SOCFPGA: cannot alloc from gen pool\n");
+		return;
+	}
+
+	memset((void *)iram_addr, 0, len);
+
+	gen_pool_free(gp, iram_addr, len);
+
+	mapped_ocr_edac_addr = ioremap(ocr_edac_addr, 4);
+	if (!mapped_ocr_edac_addr) {
+		pr_err("SOCFPGA: Unable to map OCRAM ecc regs.\n");
+		return;
+	}
+
+	/* Clear any pending OCRAM ECC interrupts, then enable ECC */
+	writel(0x18, mapped_ocr_edac_addr);
+	writel(0x19, mapped_ocr_edac_addr);
+
+	iounmap(mapped_ocr_edac_addr);
+
+	pr_debug("SOCFPGA: Success Initializing OCRAM\n");
+}
+
diff --git a/arch/arm/mach-socfpga/ocram.h b/arch/arm/mach-socfpga/ocram.h
new file mode 100644
index 0000000..f93cf84
--- /dev/null
+++ b/arch/arm/mach-socfpga/ocram.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef MACH_SOCFPGA_OCRAM_H
+#define MACH_SOCFPGA_OCRAM_H
+
+#ifdef CONFIG_EDAC_ALTERA_OCRAM
+void socfpga_init_ocram_ecc(void);
+#else
+inline void socfpga_init_ocram_ecc(void)
+{
+}
+#endif
+
+#endif /* #ifndef MACH_SOCFPGA_OCRAM_H */
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index af6413a..fb41aca 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -101,6 +101,13 @@ static void socfpga_cyclone5_restart(enum reboot_mode mode, const char *cmd)
 	writel(temp, rst_manager_base_addr + SOCFPGA_RSTMGR_CTRL);
 }
 
+static void __init socfpga_cyclone5_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     NULL, NULL);
+	socfpga_init_ocram_ecc();
+}
+
 static const char *altera_dt_match[] = {
 	"altr,socfpga",
 	NULL
@@ -112,6 +119,7 @@ DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
 	.smp		= smp_ops(socfpga_smp_ops),
 	.map_io		= socfpga_map_io,
 	.init_irq	= socfpga_init_irq,
+	.init_machine	= socfpga_cyclone5_init,
 	.restart	= socfpga_cyclone5_restart,
 	.dt_compat	= altera_dt_match,
 MACHINE_END
-- 
1.7.9.5

