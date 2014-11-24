Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKXFoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:44:30 -0500
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:63677
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750899AbaKXFo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:44:29 -0500
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 00:44:28 EST
From: Zhuoyu Zhang <Zhuoyu.Zhang@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        <linuxppc-release@linux.freescale.net>, <chenhui.zhao@freescale.com>,
        <Zhuoyu.Zhang@freescale.com>
Subject: [PATCH v2 2/2] arm: ls1: provide a workaround for core soft reset
Date: Mon, 24 Nov 2014 13:28:10 +0800
Message-ID: <1416806890-26920-2-git-send-email-Zhuoyu.Zhang@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416806890-26920-1-git-send-email-Zhuoyu.Zhang@freescale.com>
References: <1416806890-26920-1-git-send-email-Zhuoyu.Zhang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(99396003)(106466001)(36756003)(88136002)(89996001)(87936001)(87286001)(64706001)(120916001)(105606002)(107046002)(62966003)(4396001)(50466002)(50226001)(77156002)(95666004)(46102003)(229853001)(50986999)(76176999)(104016003)(102836001)(6806004)(21056001)(104166001)(68736004)(44976005)(47776003)(20776003)(19580405001)(19580395003)(97736003)(31966008)(2201001)(92566001)(92726001)(93916002)(84676001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB398;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB398;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB398;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Zhuoyu.Zhang@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB398;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>

Due to a hardware erratum, after core soft reset, core state machine
registers need to force release manually.

Signed-off-by: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>
---
 arch/arm/mach-imx/platsmp.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index 7735ebb..73c2289 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -41,6 +41,7 @@ u32 g_diag_reg;
 static void __iomem *scu_base;
 static void __iomem *dcfg_base;
 static void __iomem *scfg_base;
+static void __iomem *dcsr_rcpm2_base;
 static u32 secondary_pre_boot_entry;
 
 static struct map_desc scu_io_desc __initdata = {
@@ -150,8 +151,25 @@ static int ls1021a_secondary_iomap(void)
 		goto scfg_err;
 	}
 
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcsr-rcpm");
+	if (!np) {
+		pr_err("%s: failed to find dcsr node.\n", __func__);
+		ret = -EINVAL;
+		goto dcsr_err;
+	}
+
+	dcsr_rcpm2_base = of_iomap(np, 1);
+	of_node_put(np);
+	if (!dcsr_rcpm2_base) {
+		pr_err("%s: failed to map dcsr.\n", __func__);
+		ret = -ENOMEM;
+		goto dcsr_err;
+	}
+
 	return 0;
 
+dcsr_err:
+	iounmap(scfg_base);
 scfg_err:
 	iounmap(dcfg_base);
 dcfg_err:
@@ -176,7 +194,7 @@ static int ls1021a_reset_secondary(unsigned int cpu)
 {
 	u32 tmp;
 
-	if (!scfg_base || !dcfg_base)
+	if (!scfg_base || !dcfg_base || !dcsr_rcpm2_base)
 		return -ENOMEM;
 
 	writel_relaxed(secondary_pre_boot_entry,
@@ -190,6 +208,15 @@ static int ls1021a_reset_secondary(unsigned int cpu)
 	iowrite32be(0x80000000, scfg_base + SCFG_CORESRENCR);
 	iowrite32be(0x80000000, scfg_base +
 				SCFG_CORE0_SFT_RST + STRIDE_4B * cpu);
+	mdelay(10);
+
+	/* LS1021a errata. after reset, core state machine registers
+	 * need to force release manually.
+	 */
+	iowrite32be(0x00000080, dcsr_rcpm2_base + DCSR_RCPM2_DEBUG1);
+	iowrite32be(0x00000080, dcsr_rcpm2_base + DCSR_RCPM2_DEBUG2);
+	iowrite32be(0, dcsr_rcpm2_base + DCSR_RCPM2_DEBUG1);
+	iowrite32be(0, dcsr_rcpm2_base + DCSR_RCPM2_DEBUG2);
 
 	/* Release secondary core */
 	iowrite32be(1 << cpu, dcfg_base + DCFG_CCSR_BRR);
-- 
2.1.0.27.g96db324

