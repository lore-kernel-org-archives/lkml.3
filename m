Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKLAOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:14:22 -0500
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:61264
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506AbaKLAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:14:19 -0500
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
Subject: [PATCHv5 1/5] arm: socfpga: Enable L2 Cache ECC on startup.
Date: Tue, 11 Nov 2014 18:14:19 -0600
Message-ID: <1415751263-1830-2-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA049.namprd06.prod.outlook.com (10.141.250.167) To
 BLUPR03MB118.namprd03.prod.outlook.com (10.255.212.19)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(87286001)(48376002)(101416001)(104166001)(66066001)(87976001)(46102003)(50466002)(64706001)(19580395003)(33646002)(21056001)(19580405001)(69596002)(15202345003)(86362001)(92566001)(89996001)(86152002)(92726001)(2201001)(15975445006)(95666004)(99396003)(81156004)(42186005)(106356001)(97736003)(120916001)(105586002)(31966008)(4396001)(62966003)(77096003)(77156002)(50226001)(76176999)(50986999)(122386002)(107046002)(47776003)(20776003)(102836001)(40100003)(53416004)(229853001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB118;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB359;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

This patch enables the ECC for L2 cache on machine
startup.  The ECC has to be enabled before data is
is stored in memory otherwise the ECC will fail on
reads.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Split OCRAM initialization into separate patch.

v3/4: No change

v5: Remove l2cache.h, use io.h instead of clk-provider.h
    Make copyright header inclusive. Remove MAINTAINERS entry.
---
 arch/arm/mach-socfpga/Makefile   |    1 +
 arch/arm/mach-socfpga/core.h     |    2 ++
 arch/arm/mach-socfpga/l2_cache.c |   41 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c  |    4 +++-
 4 files changed, 47 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c

diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
index 6dd7a93..142609e 100644
--- a/arch/arm/mach-socfpga/Makefile
+++ b/arch/arm/mach-socfpga/Makefile
@@ -4,3 +4,4 @@
 
 obj-y					:= socfpga.o
 obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
+obj-$(CONFIG_EDAC_ALTERA_L2C) += l2_cache.o
diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
index 572b8f7..385baba 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -44,4 +44,6 @@ extern unsigned long cpu1start_addr;
 
 #define SOCFPGA_SCU_VIRT_BASE   0xfffec000
 
+void socfpga_init_l2_ecc(void);
+
 #endif
diff --git a/arch/arm/mach-socfpga/l2_cache.c b/arch/arm/mach-socfpga/l2_cache.c
new file mode 100644
index 0000000..3461745
--- /dev/null
+++ b/arch/arm/mach-socfpga/l2_cache.c
@@ -0,0 +1,41 @@
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
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+
+void socfpga_init_l2_ecc(void)
+{
+	struct device_node *np;
+	void __iomem  *mapped_l2_edac_addr;
+
+	np = of_find_compatible_node(NULL, NULL, "altr,l2-edac");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find altr,l2-edac in dtb\n");
+		return;
+	}
+
+	mapped_l2_edac_addr = of_iomap(np, 0);
+	if (!mapped_l2_edac_addr) {
+		pr_err("SOCFPGA: Unable to find L2 ECC mapping in dtb\n");
+		return;
+	}
+
+	/* Enable ECC */
+	writel(0x01, mapped_l2_edac_addr);
+
+	pr_debug("SOCFPGA: Success Initializing L2 cache ECC\n");
+}
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index adbf383..0954011 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2012 Altera Corporation
+ *  Copyright (C) 2012-2014 Altera Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,6 +83,8 @@ static void __init socfpga_init_irq(void)
 {
 	irqchip_init();
 	socfpga_sysmgr_init();
+	if (IS_ENABLED(CONFIG_EDAC_ALTERA_L2C))
+		socfpga_init_l2_ecc();
 }
 
 static void socfpga_cyclone5_restart(enum reboot_mode mode, const char *cmd)
-- 
1.7.9.5

