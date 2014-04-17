Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDQUwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:52:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40711 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaDQUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:10 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 13/19] bus: omap_l3_noc: make error reporting and handling common
Date: Thu, 17 Apr 2014 15:49:29 -0500
Message-ID: <1397767775-10965-14-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic between handling CUSTOM_ERROR and STANDARD_ERROR is just the
reporting style.

So make it generic, simplify and standardize the reporting with both
master and target information printed to log.

Handle the register address difference for master code for standard
error and custom error as well.

While at it, fix a minor indentation error.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

V2: reordering only
V1: https://patchwork.kernel.org/patch/3983991/

 drivers/bus/omap_l3_noc.c |   76 ++++++++++++++++++++++++++++-----------------
 drivers/bus/omap_l3_noc.h |    3 +-
 2 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 29d6206..b03c415 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -62,6 +62,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 	struct l3_target_data *l3_targ_inst;
 	struct l3_flagmux_data *flag_mux;
 	struct l3_masters_data *master;
+	char *err_description;
+	char err_string[30] = { 0 };
 
 	/* Get the Type of interrupt */
 	inttype = irq == l3->app_irq ? L3_APPLICATION_ERROR : L3_DEBUG_ERROR;
@@ -78,6 +80,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 		/* Get the corresponding error and analyse */
 		if (err_reg) {
+			bool std_err = true;
+
 			/* Identify the source from control status register */
 			err_src = __ffs(err_reg);
 
@@ -123,48 +127,64 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 			l3_targ_stderr = l3_targ_base + L3_TARG_STDERRLOG_MAIN;
 			l3_targ_slvofslsb = l3_targ_base +
 					    L3_TARG_STDERRLOG_SLVOFSLSB;
-			l3_targ_mstaddr = l3_targ_base +
-					  L3_TARG_STDERRLOG_MSTADDR;
 
 			std_err_main = readl_relaxed(l3_targ_stderr);
-			/*
-			 * STDERRLOG_MSTADDR Stores the NTTP master address.
-			 * The 6 MSBs are used to distinguish the different
-			 * initiators
-			 */
-			masterid = (readl_relaxed(l3_targ_mstaddr) & 0xFF) >> 2;
 
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
+					 ": At Address: 0x%08X ",
+					 readl_relaxed(l3_targ_slvofslsb));
+
+				l3_targ_mstaddr = l3_targ_base +
+						L3_TARG_STDERRLOG_MSTADDR;
 				break;
 
 			case CUSTOM_ERROR:
-				for (k = 0, master = l3->l3_masters;
-				     k < l3->num_masters; k++, master++) {
-					if (masterid == master->id) {
-						master_name = master->name;
-						break;
-					}
-				}
-				WARN(true, "L3 custom error: MASTER:%s TARGET:%s\n",
-					master_name, target_name);
-				/* clear the std error log*/
-				clear = std_err_main | CLEAR_STDERR_LOG;
-				writel_relaxed(clear, l3_targ_stderr);
+				err_description = "Custom";
+
+				l3_targ_mstaddr = l3_targ_base +
+						L3_TARG_STDERRLOG_CINFO_MSTADDR;
 				break;
 
 			default:
+				std_err = false;
 				/* Nothing to be handled here as of now */
 				break;
 			}
-		/* Error found so break the for loop */
-		break;
+
+			if (!std_err)
+				break;
+
+			/*
+			 * STDERRLOG_MSTADDR Stores the NTTP master
+			 * address. The 6 MSBs are used to distinguish
+			 * the different initiators
+			 */
+			masterid = (readl_relaxed(l3_targ_mstaddr) &
+				    0xFF) >> 2;
+
+			for (k = 0, master = l3->l3_masters;
+			     k < l3->num_masters; k++, master++) {
+				if (masterid == master->id) {
+					master_name = master->name;
+					break;
+				}
+			}
+
+			WARN(true,
+			     "%s:L3 %s Error: MASTER %s TARGET %s%s\n",
+			     dev_name(l3->dev),
+			     err_description,
+			     master_name, target_name,
+			     err_string);
+			/* clear the std error log*/
+			clear = std_err_main | CLEAR_STDERR_LOG;
+			writel_relaxed(clear, l3_targ_stderr);
+
+			/* Error found so break the for loop */
+			break;
 		}
 	}
 	return IRQ_HANDLED;
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index 64869fe..18cdc25 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -29,8 +29,9 @@
 
 /* L3 TARG register offsets */
 #define L3_TARG_STDERRLOG_MAIN		0x48
+#define L3_TARG_STDERRLOG_MSTADDR	0x50
 #define L3_TARG_STDERRLOG_SLVOFSLSB	0x5c
-#define L3_TARG_STDERRLOG_MSTADDR	0x68
+#define L3_TARG_STDERRLOG_CINFO_MSTADDR	0x68
 #define L3_FLAGMUX_REGERR0		0xc
 #define L3_FLAGMUX_MASK0		0x8
 
-- 
1.7.9.5

