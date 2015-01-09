Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbbAID1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:27:22 -0500
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:18016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752782AbbAID1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:27:20 -0500
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
Subject: [PATCHv6 2/5] arm: socfpga: Enable OCRAM ECC on startup.
Date: Thu, 8 Jan 2015 20:53:53 -0600
Message-ID: <1420772036-3112-3-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
References: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BY2PR0301MB0629.namprd03.prod.outlook.com (25.160.125.27)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tthayer@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(86362001)(48376002)(40100003)(106356001)(50466002)(50986999)(76176999)(101416001)(2950100001)(97736003)(42186005)(50226001)(4396001)(19580395003)(120916001)(19580405001)(105586002)(122386002)(99396003)(33646002)(229853001)(68736005)(31966008)(107046002)(20776003)(15975445007)(64706001)(66066001)(46102003)(77156002)(2201001)(92566001)(89996001)(21056001)(86152002)(62966003)(47776003)(87976001)(921003)(217873001)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0301MB0629;H:localhost.localdomain;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:54:50.9418 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
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

v5: Remove ocram.h, use io.h instead of clk-provider.h
    Check prop in correct place. Add ECC EN defines.

v6: Implement OCRAM discovery changes from community. Add
    of_node_put(). Remove be32_to_cpup(). Use __init() which
    allows removal of .init_machine(). Update year in header.
---
 arch/arm/mach-socfpga/Makefile |    1 +
 arch/arm/mach-socfpga/ocram.c  |   97 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 arch/arm/mach-socfpga/ocram.c

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
index 0000000..1f12a38
--- /dev/null
+++ b/arch/arm/mach-socfpga/ocram.c
@@ -0,0 +1,97 @@
+/*
+ * Copyright Altera Corporation (C) 2015. All rights reserved.
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
+#include <linux/io.h>
+#include <linux/genalloc.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#define ALTR_OCRAM_CLEAR_ECC          0x00000018
+#define ALTR_OCRAM_ECC_EN             0x00000019
+
+static int __init socfpga_init_ocram_ecc(void)
+{
+	struct device_node *np;
+	struct resource    res;
+	u32                iram_addr;
+	void __iomem       *mapped_ocr_edac_addr;
+	resource_size_t    size;
+	struct gen_pool    *gp;
+	int                ret;
+
+	/* Get the size of the on-chip RAM */
+	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
+	if (!np) {
+		pr_err("%s: Unable to find mmio-sram in dtb\n", __func__);
+		return -ENODEV;
+	}
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret) {
+		of_node_put(np);
+		pr_err("%s: Problem getting SRAM address in dtb\n", __func__);
+		return -ENODEV;
+	}
+	size = resource_size(&res);
+	of_node_put(np);
+
+	/* Find the OCRAM EDAC device tree node */
+	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
+	if (!np) {
+		pr_err("%s: Unable to find altr,ocram-edac\n", __func__);
+		return -ENODEV;
+	}
+
+	mapped_ocr_edac_addr = of_iomap(np, 0);
+	if (!mapped_ocr_edac_addr) {
+		of_node_put(np);
+		pr_err("%s: Unable to map OCRAM ecc regs.\n", __func__);
+		return -ENODEV;
+	}
+
+	gp = of_get_named_gen_pool(np, "iram", 0);
+	if (!gp) {
+		of_node_put(np);
+		pr_err("%s: OCRAM cannot find gen pool\n", __func__);
+		return -ENODEV;
+	}
+	of_node_put(np);
+
+	iram_addr = gen_pool_alloc(gp, size / sizeof(size_t));
+	if (iram_addr == 0) {
+		pr_err("%s: cannot alloc from gen pool\n", __func__);
+		return -ENODEV;
+	}
+
+	/* Clear any pending OCRAM ECC interrupts, then enable ECC */
+	writel(ALTR_OCRAM_CLEAR_ECC, mapped_ocr_edac_addr);
+	writel(ALTR_OCRAM_ECC_EN, mapped_ocr_edac_addr);
+
+	memset((void *)iram_addr, 0, size);
+
+	gen_pool_free(gp, iram_addr, size / sizeof(size_t));
+
+	iounmap(mapped_ocr_edac_addr);
+
+	return 0;
+}
+
+static void __exit socfpga_exit_ocram_ecc(void)
+{
+}
+
+module_init(socfpga_init_ocram_ecc);
+module_exit(socfpga_exit_ocram_ecc);
-- 
1.7.9.5

