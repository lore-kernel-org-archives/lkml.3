Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaDNQkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:40:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbaDNQ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:08 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/15] bus: omap_l3_noc: make error reporting and handling common.
Date: Mon, 14 Apr 2014 11:25:17 -0500
Message-ID: <1397492726-17203-8-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic between handling CUSTOM_ERROR and STANDARD_ERROR
is just the reporting style.

So make it generic, simplify and standardize the reporting
with both master and target information printed to log.

While at it, fix a minor formatting error.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/bus/omap_l3_noc.c |   47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 0ef8b75..0f0417a 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -58,6 +58,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
 	char *target_name, *master_name = "UN IDENTIFIED";
 	struct l3_target_data *l3_targ_inst;
+	char *err_description;
+	char err_string[30] = { 0 };
 
 	/* Get the Type of interrupt */
 	inttype = irq == l3->app_irq ? L3_APPLICATION_ERROR : L3_DEBUG_ERROR;
@@ -73,6 +75,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 		/* Get the corresponding error and analyse */
 		if (err_reg) {
+			bool std_err = true;
+
 			/* Identify the source from control status register */
 			err_src = __ffs(err_reg);
 			l3_targ_inst = &l3_targ[i][err_src];
@@ -89,35 +93,42 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 			std_err_main = readl_relaxed(l3_targ_stderr);
 			masterid = readl_relaxed(l3_targ_mstaddr);
 
+			for (k = 0; k < NUM_OF_L3_MASTERS; k++) {
+				if (masterid == l3_masters[k].id)
+					master_name = l3_masters[k].name;
+			}
+
 			switch (std_err_main & CUSTOM_ERROR) {
 			case STANDARD_ERROR:
-				WARN(true, "L3 standard error: TARGET:%s at address 0x%x\n",
-					target_name,
-					readl_relaxed(l3_targ_slvofslsb));
-				/* clear the std error log*/
-				clear = std_err_main | CLEAR_STDERR_LOG;
-				writel_relaxed(clear, l3_targ_stderr);
+				err_description = "Standard";
+				snprintf(err_string, sizeof(err_string),
+					 ": At Address: 0x%08X",
+					 readl_relaxed(l3_targ_slvofslsb));
 				break;
 
 			case CUSTOM_ERROR:
-				for (k = 0; k < NUM_OF_L3_MASTERS; k++) {
-					if (masterid == l3_masters[k].id)
-						master_name =
-							l3_masters[k].name;
-				}
-				WARN(true, "L3 custom error: MASTER:%s TARGET:%s\n",
-					master_name, target_name);
-				/* clear the std error log*/
-				clear = std_err_main | CLEAR_STDERR_LOG;
-				writel_relaxed(clear, l3_targ_stderr);
+				err_description = "Custom";
 				break;
 
 			default:
+				std_err = false;
 				/* Nothing to be handled here as of now */
 				break;
 			}
-		/* Error found so break the for loop */
-		break;
+
+			if (std_err) {
+				WARN(true,
+				     "L3 %s Error: MASTER %s TARGET %s %s\n",
+				     err_description,
+				     master_name, target_name,
+				     err_string);
+				/* clear the std error log*/
+				clear = std_err_main | CLEAR_STDERR_LOG;
+				writel_relaxed(clear, l3_targ_stderr);
+			}
+
+			/* Error found so break the for loop */
+			break;
 		}
 	}
 	return IRQ_HANDLED;
-- 
1.7.9.5

