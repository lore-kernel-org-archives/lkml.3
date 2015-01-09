Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbbAIDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:09:26 -0500
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:35631
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752785AbbAIDJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:09:24 -0500
X-Greylist: delayed 881 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 22:09:24 EST
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
Subject: [PATCHv6 1/5] arm: socfpga: Enable L2 Cache ECC on startup.
Date: Thu, 8 Jan 2015 20:53:52 -0600
Message-ID: <1420772036-3112-2-git-send-email-tthayer@opensource.altera.com>
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(86362001)(48376002)(40100003)(106356001)(50466002)(50986999)(76176999)(101416001)(2950100001)(97736003)(42186005)(50226001)(4396001)(19580395003)(120916001)(19580405001)(105586002)(122386002)(99396003)(33646002)(229853001)(68736005)(31966008)(107046002)(20776003)(15975445007)(64706001)(66066001)(46102003)(77156002)(2201001)(92566001)(89996001)(21056001)(86152002)(62966003)(47776003)(87976001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0301MB0629;H:localhost.localdomain;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:54:39.8167 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
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

v6: Remove pr_debug() & update year in header.
---
 arch/arm/mach-socfpga/Makefile   |    1 +
 arch/arm/mach-socfpga/core.h     |    2 ++
 arch/arm/mach-socfpga/l2_cache.c |   39 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c  |    4 +++-
 4 files changed, 45 insertions(+), 1 deletion(-)
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
index 483cb46..28c8a15 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -47,4 +47,6 @@ extern unsigned long socfpga_cpu1start_addr;
 
 #define SOCFPGA_SCU_VIRT_BASE   0xfffec000
 
+void socfpga_init_l2_ecc(void);
+
 #endif
diff --git a/arch/arm/mach-socfpga/l2_cache.c b/arch/arm/mach-socfpga/l2_cache.c
new file mode 100644
index 0000000..047759d
--- /dev/null
+++ b/arch/arm/mach-socfpga/l2_cache.c
@@ -0,0 +1,39 @@
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
+}
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index 383d61e..ce04313 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2012 Altera Corporation
+ *  Copyright (C) 2012-2015 Altera Corporation
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

