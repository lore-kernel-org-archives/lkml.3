Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJUCME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:12:04 -0400
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:18896
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754159AbaJUCMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:12:02 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v1] ARM: imx6: add pm_power_off support for i.mx6 chips
Date: Tue, 21 Oct 2014 09:06:15 +0800
Message-ID: <1413853584-18325-2-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413853584-18325-1-git-send-email-b38343@freescale.com>
References: <1413853584-18325-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(84676001)(80022003)(104166001)(102836001)(46102003)(104016003)(95666004)(106466001)(4396001)(105606002)(76176999)(26826002)(50226001)(50466002)(48376002)(62966002)(21056001)(89996001)(50986999)(88136002)(36756003)(97736003)(85852003)(68736004)(76482002)(87286001)(99396003)(20776003)(87936001)(85306004)(19580405001)(47776003)(64706001)(44976005)(92726001)(33646002)(229853001)(93916002)(2201001)(6806004)(107046002)(120916001)(77156001)(31966008)(19580395003)(92566001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR03MB048;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:SN2PR03MB048;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All chips of i.mx6 can be powered off by programming SNVS.
For example :
On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
pmic ON/OFF pin, that will cause the whole PMIC powered off
except VSNVS. And system can restart once PMIC_ON_REQ goes
high by push POWRER key.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 arch/arm/mach-imx/common.h      |  1 +
 arch/arm/mach-imx/mach-imx6q.c  |  2 ++
 arch/arm/mach-imx/mach-imx6sl.c |  2 ++
 arch/arm/mach-imx/mach-imx6sx.c |  2 ++
 arch/arm/mach-imx/system.c      | 22 +++++++++++++++++++++-
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 1dabf43..baca11a 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -62,6 +62,7 @@ void mxc_set_cpu_type(unsigned int type);
 void mxc_restart(enum reboot_mode, const char *);
 void mxc_arch_reset_init(void __iomem *);
 void mxc_arch_reset_init_dt(void);
+void mxc_power_off_init(void);
 int mx51_revision(void);
 int mx53_revision(void);
 void imx_set_aips(void __iomem *);
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index d51c6e9..3d6610d 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -270,6 +270,8 @@ static void __init imx6q_init_machine(void)
 
 	mxc_arch_reset_init_dt();
 
+	mxc_power_off_init();
+
 	parent = imx_soc_device_init();
 	if (parent == NULL)
 		pr_warn("failed to initialize soc device\n");
diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
index ed263a2..c07e6e8 100644
--- a/arch/arm/mach-imx/mach-imx6sl.c
+++ b/arch/arm/mach-imx/mach-imx6sl.c
@@ -50,6 +50,8 @@ static void __init imx6sl_init_machine(void)
 
 	mxc_arch_reset_init_dt();
 
+	mxc_power_off_init();
+
 	parent = imx_soc_device_init();
 	if (parent == NULL)
 		pr_warn("failed to initialize soc device\n");
diff --git a/arch/arm/mach-imx/mach-imx6sx.c b/arch/arm/mach-imx/mach-imx6sx.c
index 3de3b73..68ea070 100644
--- a/arch/arm/mach-imx/mach-imx6sx.c
+++ b/arch/arm/mach-imx/mach-imx6sx.c
@@ -20,6 +20,8 @@ static void __init imx6sx_init_machine(void)
 
 	mxc_arch_reset_init_dt();
 
+	mxc_power_off_init();
+
 	parent = imx_soc_device_init();
 	if (parent == NULL)
 		pr_warn("failed to initialize soc device\n");
diff --git a/arch/arm/mach-imx/system.c b/arch/arm/mach-imx/system.c
index d14c33f..925fb29 100644
--- a/arch/arm/mach-imx/system.c
+++ b/arch/arm/mach-imx/system.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/pm.h>
 
 #include <asm/system_misc.h>
 #include <asm/proc-fns.h>
@@ -32,7 +33,9 @@
 #include "common.h"
 #include "hardware.h"
 
-static void __iomem *wdog_base;
+#define SNVS_LPCR               0x04
+
+static void __iomem *wdog_base, *snvs_base;
 static struct clk *wdog_clk;
 
 /*
@@ -104,6 +107,23 @@ void __init mxc_arch_reset_init_dt(void)
 		clk_prepare(wdog_clk);
 }
 
+static void power_off_snvs(void)
+{
+	 u32 value = readl(snvs_base + SNVS_LPCR);
+	/* set TOP and DP_EN bit */
+	writel(value | 0x60, snvs_base + SNVS_LPCR);
+}
+
+void __init mxc_power_off_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0-mon-rtc-lp");
+	snvs_base = of_iomap(np, 0);
+	WARN_ON(!snvs_base);
+	pm_power_off = power_off_snvs;
+}
+
 #ifdef CONFIG_CACHE_L2X0
 void __init imx_init_l2cache(void)
 {
-- 
1.9.1

