Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093AbaJ3Pdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:33:42 -0400
Received: from mail-bn1bon0068.outbound.protection.outlook.com ([157.56.111.68]:40667
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933587AbaJ3PcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:32:04 -0400
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
Subject: [PATCHv3 1/5] arm: socfpga: Enable L2 Cache ECC on startup.
Date: Thu, 30 Oct 2014 10:32:07 -0500
Message-ID: <1414683131-20786-2-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0002.namprd02.prod.outlook.com (25.160.191.140)
 To BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(22564002)(199003)(189002)(101416001)(87286001)(88136002)(15202345003)(50226001)(81156004)(50466002)(106356001)(85306004)(40100003)(33646002)(87976001)(95666004)(21056001)(122386002)(77156001)(76482002)(48376002)(4396001)(86362001)(31966008)(575784001)(120916001)(93916002)(229853001)(107046002)(102836001)(53416004)(86152002)(47776003)(2201001)(92566001)(97736003)(50986999)(19580395003)(62966002)(19580405001)(76176999)(64706001)(89996001)(85852003)(105586002)(69596002)(104166001)(92726001)(66066001)(77096002)(42186005)(46102003)(15975445006)(20776003)(80022003)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
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

v3: No change
---
 MAINTAINERS                      |    1 +
 arch/arm/mach-socfpga/Makefile   |    1 +
 arch/arm/mach-socfpga/l2_cache.c |   44 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/l2_cache.h |   28 ++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c  |    5 ++++-
 5 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/l2_cache.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ee1bc5b..d0c7752 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1407,6 +1407,7 @@ ARM/SOCFPGA EDAC SUPPORT
 M:	Thor Thayer <tthayer@opensource.altera.com>
 S:	Maintained
 F:	drivers/edac/altera_edac.
+F:	arch/arm/mach-socfpga/l2_cache.*
 
 ARM/STI ARCHITECTURE
 M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
index 6dd7a93..142609e 100644
--- a/arch/arm/mach-socfpga/Makefile
+++ b/arch/arm/mach-socfpga/Makefile
@@ -4,3 +4,4 @@
 
 obj-y					:= socfpga.o
 obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
+obj-$(CONFIG_EDAC_ALTERA_L2C) += l2_cache.o
diff --git a/arch/arm/mach-socfpga/l2_cache.c b/arch/arm/mach-socfpga/l2_cache.c
new file mode 100644
index 0000000..8e109f3
--- /dev/null
+++ b/arch/arm/mach-socfpga/l2_cache.c
@@ -0,0 +1,44 @@
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
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+
+#include "l2_cache.h"
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
+
diff --git a/arch/arm/mach-socfpga/l2_cache.h b/arch/arm/mach-socfpga/l2_cache.h
new file mode 100644
index 0000000..58e140d
--- /dev/null
+++ b/arch/arm/mach-socfpga/l2_cache.h
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
+#ifndef MACH_SOCFPGA_L2_CACHE_H
+#define MACH_SOCFPGA_L2_CACHE_H
+
+#ifdef CONFIG_EDAC_ALTERA_L2C
+void socfpga_init_l2_ecc(void);
+#else
+inline void socfpga_init_l2_ecc(void)
+{
+}
+#endif
+
+#endif /* #ifndef MACH_SOCFPGA_L2_CACHE_H */
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index adbf383..af6413a 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2012 Altera Corporation
+ *  Copyright (C) 2012;2014 Altera Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -25,6 +25,8 @@
 #include <asm/mach/map.h>
 
 #include "core.h"
+#include "l2_cache.h"
+#include "ocram.h"
 
 void __iomem *socfpga_scu_base_addr = ((void __iomem *)(SOCFPGA_SCU_VIRT_BASE));
 void __iomem *sys_manager_base_addr;
@@ -83,6 +85,7 @@ static void __init socfpga_init_irq(void)
 {
 	irqchip_init();
 	socfpga_sysmgr_init();
+	socfpga_init_l2_ecc();
 }
 
 static void socfpga_cyclone5_restart(enum reboot_mode mode, const char *cmd)
-- 
1.7.9.5

