Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaDQUvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:51:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39205 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaDQUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:04 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 14/19] bus: omap_l3_noc: improve readability by using helper for slave event parsing
Date: Thu, 17 Apr 2014 15:49:30 -0500
Message-ID: <1397767775-10965-15-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current interrupt handler does the first level parse to identify the
slave and then handles the slave even identification, reporting and
clearing of event as well. It is hence logical to split the handler
into two where the primary handler just parses the flagmux till it
identifies a slave and the slave handling, reporting and clearing is
done in a helper function.

While at it update the documentation in kerneldoc style.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

New Patch

 drivers/bus/omap_l3_noc.c |  218 ++++++++++++++++++++++++---------------------
 1 file changed, 117 insertions(+), 101 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index b03c415..e45b960 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -26,14 +26,20 @@
 
 #include "omap_l3_noc.h"
 
-/*
- * Interrupt Handler for L3 error detection.
- *	1) Identify the L3 clockdomain partition to which the error belongs to.
- *	2) Identify the slave where the error information is logged
- *	3) Print the logged information.
- *	4) Add dump stack to provide kernel trace.
+/**
+ * l3_handle_target() - Handle Target specific parse and reporting
+ * @l3:		pointer to l3 struct
+ * @base:	base address of clkdm
+ * @flag_mux:	flagmux corresponding to the event
+ * @err_src:	error source index of the slave (target)
+ *
+ * This does the second part of the error interrupt handling:
+ *	3) Parse in the slave information
+ *	4) Print the logged information.
+ *	5) Add dump stack to provide kernel trace.
+ *	6) Clear the source if known.
  *
- * Two Types of errors :
+ * This handles two types of errors:
  *	1) Custom errors in L3 :
  *		Target like DMM/FW/EMIF generates SRESP=ERR error
  *	2) Standard L3 error:
@@ -49,22 +55,111 @@
  *	can be trapped as well. But the trapping is implemented as part
  *	secure software and hence need not be implemented here.
  */
-static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
+static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
+			    struct l3_flagmux_data *flag_mux, int err_src)
 {
-
-	struct omap_l3 *l3 = _l3;
-	int inttype, i, k;
-	int err_src = 0;
-	u32 std_err_main, err_reg, clear, masterid;
-	void __iomem *base, *l3_targ_base;
+	int k;
+	u32 std_err_main, clear, masterid;
+	void __iomem *l3_targ_base;
 	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
-	char *target_name, *master_name = "UN IDENTIFIED";
 	struct l3_target_data *l3_targ_inst;
-	struct l3_flagmux_data *flag_mux;
 	struct l3_masters_data *master;
+	char *target_name, *master_name = "UN IDENTIFIED";
 	char *err_description;
 	char err_string[30] = { 0 };
 
+	/* We DONOT expect err_src to go out of bounds */
+	BUG_ON(err_src > MAX_CLKDM_TARGETS);
+
+	if (err_src < flag_mux->num_targ_data) {
+		l3_targ_inst = &flag_mux->l3_targ[err_src];
+		target_name = l3_targ_inst->name;
+		l3_targ_base = base + l3_targ_inst->offset;
+	} else {
+		target_name = L3_TARGET_NOT_SUPPORTED;
+	}
+
+	if (target_name == L3_TARGET_NOT_SUPPORTED)
+		return -ENODEV;
+
+	/* Read the stderrlog_main_source from clk domain */
+	l3_targ_stderr = l3_targ_base + L3_TARG_STDERRLOG_MAIN;
+	l3_targ_slvofslsb = l3_targ_base + L3_TARG_STDERRLOG_SLVOFSLSB;
+
+	std_err_main = readl_relaxed(l3_targ_stderr);
+
+	switch (std_err_main & CUSTOM_ERROR) {
+	case STANDARD_ERROR:
+		err_description = "Standard";
+		snprintf(err_string, sizeof(err_string),
+			 ": At Address: 0x%08X ",
+			 readl_relaxed(l3_targ_slvofslsb));
+
+		l3_targ_mstaddr = l3_targ_base + L3_TARG_STDERRLOG_MSTADDR;
+		break;
+
+	case CUSTOM_ERROR:
+		err_description = "Custom";
+
+		l3_targ_mstaddr = l3_targ_base +
+				  L3_TARG_STDERRLOG_CINFO_MSTADDR;
+		break;
+
+	default:
+		/* Nothing to be handled here as of now */
+		return 0;
+	}
+
+
+	/*
+	 * STDERRLOG_MSTADDR Stores the NTTP master
+	 * address. The 6 MSBs are used to distinguish
+	 * the different initiators
+	 */
+	masterid = (readl_relaxed(l3_targ_mstaddr) & 0xFF) >> 2;
+
+	for (k = 0, master = l3->l3_masters; k < l3->num_masters;
+	     k++, master++) {
+		if (masterid == master->id) {
+			master_name = master->name;
+			break;
+		}
+	}
+
+	WARN(true,
+	     "%s:L3 %s Error: MASTER %s TARGET %s%s\n",
+	     dev_name(l3->dev),
+	     err_description,
+	     master_name, target_name,
+	     err_string);
+
+	/* clear the std error log*/
+	clear = std_err_main | CLEAR_STDERR_LOG;
+	writel_relaxed(clear, l3_targ_stderr);
+
+	return 0;
+}
+
+/**
+ * l3_interrupt_handler() - interrupt handler for l3 events
+ * @irq:	irq number
+ * @_l3:	pointer to l3 structure
+ *
+ * Interrupt Handler for L3 error detection.
+ *	1) Identify the L3 clockdomain partition to which the error belongs to.
+ *	2) Identify the slave where the error information is logged
+ *	... handle the slave event..
+ *	7) if the slave is unknown, mask out the slave.
+ */
+static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
+{
+	struct omap_l3 *l3 = _l3;
+	int inttype, i, ret;
+	int err_src = 0;
+	u32 err_reg, mask_val;
+	void __iomem *base, *mask_reg;
+	struct l3_flagmux_data *flag_mux;
+
 	/* Get the Type of interrupt */
 	inttype = irq == l3->app_irq ? L3_APPLICATION_ERROR : L3_DEBUG_ERROR;
 
@@ -80,35 +175,18 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 		/* Get the corresponding error and analyse */
 		if (err_reg) {
-			bool std_err = true;
-
 			/* Identify the source from control status register */
 			err_src = __ffs(err_reg);
 
-			/* We DONOT expect err_src to go out of bounds */
-			BUG_ON(err_src > MAX_CLKDM_TARGETS);
-
-			if (err_src < flag_mux->num_targ_data) {
-				l3_targ_inst = &flag_mux->l3_targ[err_src];
-				target_name = l3_targ_inst->name;
-				l3_targ_base = base + l3_targ_inst->offset;
-			} else {
-				target_name = L3_TARGET_NOT_SUPPORTED;
-			}
+			ret = l3_handle_target(l3, base, flag_mux, err_src);
 
 			/*
-			 * If we do not know of a register offset to decode
-			 * and clear, then mask.
+			 * Certain plaforms may have "undocumented" status
+			 * pending on boot. So dont generate a severe warning
+			 * here. Just mask it off to prevent the error from
+			 * reoccuring and locking up the system.
 			 */
-			if (target_name == L3_TARGET_NOT_SUPPORTED) {
-				u32 mask_val;
-				void __iomem *mask_reg;
-
-				/*
-				 * Certain plaforms may have "undocumented"
-				 * status pending on boot.. So dont generate
-				 * a severe warning here.
-				 */
+			if (ret) {
 				dev_err(l3->dev,
 					"L3 %s error: target %d mod:%d %s\n",
 					inttype ? "debug" : "application",
@@ -119,70 +197,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 				mask_val = readl(mask_reg);
 				mask_val &= ~(1 << err_src);
 				writel(mask_val, mask_reg);
-
-				break;
-			}
-
-			/* Read the stderrlog_main_source from clk domain */
-			l3_targ_stderr = l3_targ_base + L3_TARG_STDERRLOG_MAIN;
-			l3_targ_slvofslsb = l3_targ_base +
-					    L3_TARG_STDERRLOG_SLVOFSLSB;
-
-			std_err_main = readl_relaxed(l3_targ_stderr);
-
-			switch (std_err_main & CUSTOM_ERROR) {
-			case STANDARD_ERROR:
-				err_description = "Standard";
-				snprintf(err_string, sizeof(err_string),
-					 ": At Address: 0x%08X ",
-					 readl_relaxed(l3_targ_slvofslsb));
-
-				l3_targ_mstaddr = l3_targ_base +
-						L3_TARG_STDERRLOG_MSTADDR;
-				break;
-
-			case CUSTOM_ERROR:
-				err_description = "Custom";
-
-				l3_targ_mstaddr = l3_targ_base +
-						L3_TARG_STDERRLOG_CINFO_MSTADDR;
-				break;
-
-			default:
-				std_err = false;
-				/* Nothing to be handled here as of now */
-				break;
-			}
-
-			if (!std_err)
-				break;
-
-			/*
-			 * STDERRLOG_MSTADDR Stores the NTTP master
-			 * address. The 6 MSBs are used to distinguish
-			 * the different initiators
-			 */
-			masterid = (readl_relaxed(l3_targ_mstaddr) &
-				    0xFF) >> 2;
-
-			for (k = 0, master = l3->l3_masters;
-			     k < l3->num_masters; k++, master++) {
-				if (masterid == master->id) {
-					master_name = master->name;
-					break;
-				}
 			}
 
-			WARN(true,
-			     "%s:L3 %s Error: MASTER %s TARGET %s%s\n",
-			     dev_name(l3->dev),
-			     err_description,
-			     master_name, target_name,
-			     err_string);
-			/* clear the std error log*/
-			clear = std_err_main | CLEAR_STDERR_LOG;
-			writel_relaxed(clear, l3_targ_stderr);
-
 			/* Error found so break the for loop */
 			break;
 		}
-- 
1.7.9.5

