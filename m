Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaDQUuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:50:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaDQUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:04 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 05/19] bus: omap_l3_noc: switch over to relaxed variants of readl/writel
Date: Thu, 17 Apr 2014 15:49:21 -0500
Message-ID: <1397767775-10965-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we use __raw_readl and writel in this driver, however, there
is no strict sequencing needs for this driver, hence we should be good
with the relaxed variants.

While at it, simplify address computation using variables for register.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
V2: no functional change, just reordering
V1: https://patchwork.kernel.org/patch/3984051/
 drivers/bus/omap_l3_noc.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 37d71b7..c8facb0 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -55,6 +55,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 	int err_src = 0;
 	u32 std_err_main, err_reg, clear, masterid;
 	void __iomem *base, *l3_targ_base;
+	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
 	char *target_name, *master_name = "UN IDENTIFIED";
 
 	/* Get the Type of interrupt */
@@ -66,8 +67,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 		 * to determine the source
 		 */
 		base = l3->l3_base[i];
-		err_reg = __raw_readl(base + l3_flagmux[i] +
-					+ L3_FLAGMUX_REGERR0 + (inttype << 3));
+		err_reg = readl_relaxed(base + l3_flagmux[i] +
+					L3_FLAGMUX_REGERR0 + (inttype << 3));
 
 		/* Get the corresponding error and analyse */
 		if (err_reg) {
@@ -76,10 +77,14 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 			/* Read the stderrlog_main_source from clk domain */
 			l3_targ_base = base + *(l3_targ[i] + err_src);
-			std_err_main =  __raw_readl(l3_targ_base +
-					L3_TARG_STDERRLOG_MAIN);
-			masterid = __raw_readl(l3_targ_base +
-					L3_TARG_STDERRLOG_MSTADDR);
+			l3_targ_stderr = l3_targ_base + L3_TARG_STDERRLOG_MAIN;
+			l3_targ_slvofslsb = l3_targ_base +
+					    L3_TARG_STDERRLOG_SLVOFSLSB;
+			l3_targ_mstaddr = l3_targ_base +
+					  L3_TARG_STDERRLOG_MSTADDR;
+
+			std_err_main = readl_relaxed(l3_targ_stderr);
+			masterid = readl_relaxed(l3_targ_mstaddr);
 
 			switch (std_err_main & CUSTOM_ERROR) {
 			case STANDARD_ERROR:
@@ -87,12 +92,10 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 					l3_targ_inst_name[i][err_src];
 				WARN(true, "L3 standard error: TARGET:%s at address 0x%x\n",
 					target_name,
-					__raw_readl(l3_targ_base +
-						L3_TARG_STDERRLOG_SLVOFSLSB));
+					readl_relaxed(l3_targ_slvofslsb));
 				/* clear the std error log*/
 				clear = std_err_main | CLEAR_STDERR_LOG;
-				writel(clear, l3_targ_base +
-					L3_TARG_STDERRLOG_MAIN);
+				writel_relaxed(clear, l3_targ_stderr);
 				break;
 
 			case CUSTOM_ERROR:
@@ -107,8 +110,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 					master_name, target_name);
 				/* clear the std error log*/
 				clear = std_err_main | CLEAR_STDERR_LOG;
-				writel(clear, l3_targ_base +
-					L3_TARG_STDERRLOG_MAIN);
+				writel_relaxed(clear, l3_targ_stderr);
 				break;
 
 			default:
-- 
1.7.9.5

