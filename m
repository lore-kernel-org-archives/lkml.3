Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaDQUxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:53:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44246 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaDQUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:31 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 11/19] bus: omap_l3_noc: convert flagmux information into a structure
Date: Thu, 17 Apr 2014 15:49:27 -0500
Message-ID: <1397767775-10965-12-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to encompass target information and flag mux offset that
points to the target information into a singular structure. This saves
us the need to look up two different arrays indexed by module ID for
information.

This allows us to reduce the static target information allocation to
just the ones that are documented.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
V2: reordering changes only
V1: https://patchwork.kernel.org/patch/3984171/
 drivers/bus/omap_l3_noc.c |   16 +++++++----
 drivers/bus/omap_l3_noc.h |   70 +++++++++++++++++++++++++++++----------------
 2 files changed, 56 insertions(+), 30 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index fd31d37..300e168 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -60,6 +60,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
 	char *target_name, *master_name = "UN IDENTIFIED";
 	struct l3_target_data *l3_targ_inst;
+	struct l3_flagmux_data *flag_mux;
 	struct l3_masters_data *master;
 
 	/* Get the Type of interrupt */
@@ -71,7 +72,8 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 		 * to determine the source
 		 */
 		base = l3->l3_base[i];
-		err_reg = readl_relaxed(base + l3->l3_flagmux[i] +
+		flag_mux = l3->l3_flagmux[i];
+		err_reg = readl_relaxed(base + flag_mux->offset +
 					L3_FLAGMUX_REGERR0 + (inttype << 3));
 
 		/* Get the corresponding error and analyse */
@@ -82,9 +84,13 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 			/* We DONOT expect err_src to go out of bounds */
 			BUG_ON(err_src > MAX_CLKDM_TARGETS);
 
-			l3_targ_inst = &l3->l3_targ[i][err_src];
-			target_name = l3_targ_inst->name;
-			l3_targ_base = base + l3_targ_inst->offset;
+			if (err_src < flag_mux->num_targ_data) {
+				l3_targ_inst = &flag_mux->l3_targ[err_src];
+				target_name = l3_targ_inst->name;
+				l3_targ_base = base + l3_targ_inst->offset;
+			} else {
+				target_name = L3_TARGET_NOT_SUPPORTED;
+			}
 
 			/*
 			 * If we do not know of a register offset to decode
@@ -104,7 +110,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 					inttype ? "debug" : "application",
 					err_src, i, "(unclearable)");
 
-				mask_reg = base + l3->l3_flagmux[i] +
+				mask_reg = base + flag_mux->offset +
 					   L3_FLAGMUX_MASK0 + (inttype << 3);
 				mask_val = readl(mask_reg);
 				mask_val &= ~(1 << err_src);
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index e60865f..64869fe 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -17,8 +17,8 @@
 #ifndef __OMAP_L3_NOC_H
 #define __OMAP_L3_NOC_H
 
-#define OMAP_L3_MODULES			3
 #define MAX_L3_MODULES			3
+#define MAX_CLKDM_TARGETS		31
 
 #define CLEAR_STDERR_LOG		(1 << 31)
 #define CUSTOM_ERROR			0x2
@@ -36,8 +36,6 @@
 
 #define L3_TARGET_NOT_SUPPORTED		NULL
 
-#define MAX_CLKDM_TARGETS		31
-
 /**
  * struct l3_masters_data - L3 Master information
  * @id:		ID of the L3 Master
@@ -60,21 +58,32 @@ struct l3_target_data {
 	char *name;
 };
 
+/**
+ * struct l3_flagmux_data - Flag Mux information
+ * @offset:	offset from base for flagmux register
+ * @l3_targ:	array indexed by flagmux index (bit offset) pointing to the
+ *		target data. unsupported ones are marked with
+ *		L3_TARGET_NOT_SUPPORTED
+ * @num_targ_data: number of entries in target data
+ */
+struct l3_flagmux_data {
+	u32 offset;
+	struct l3_target_data *l3_targ;
+	u8 num_targ_data;
+};
+
 
 /**
  * struct omap_l3 - Description of data relevant for L3 bus.
  * @dev:	device representing the bus (populated runtime)
  * @l3_base:	base addresses of modules (populated runtime)
- * @l3_flag_mux: array containing offsets to flag mux per module
+ * @l3_flag_mux: array containing flag mux data per module
  *		 offset from corresponding module base indexed per
  *		 module.
  * @num_modules: number of clock domains / modules.
  * @l3_masters:	array pointing to master data containing name and register
  *		offset for the master.
  * @num_master: number of masters
- * @l3_targ:	array indexed by flagmux index (bit offset) pointing to the
- *		target data. unsupported ones are marked with
- *		L3_TARGET_NOT_SUPPORTED
  * @debug_irq:	irq number of the debug interrupt (populated runtime)
  * @app_irq:	irq number of the application interrupt (populated runtime)
  */
@@ -82,25 +91,17 @@ struct omap_l3 {
 	struct device *dev;
 
 	void __iomem *l3_base[MAX_L3_MODULES];
-	u32 *l3_flagmux;
+	struct l3_flagmux_data **l3_flagmux;
 	int num_modules;
 
 	struct l3_masters_data *l3_masters;
 	int num_masters;
 
-	struct l3_target_data **l3_targ;
-
 	int debug_irq;
 	int app_irq;
 };
 
-static u32 omap_l3_flagmux[OMAP_L3_MODULES] = {
-	0x500,
-	0x1000,
-	0X0200
-};
-
-static struct l3_target_data omap_l3_target_data_clk1[MAX_CLKDM_TARGETS] = {
+static struct l3_target_data omap_l3_target_data_clk1[] = {
 	{0x100,	"DMM1",},
 	{0x200,	"DMM2",},
 	{0x300,	"ABE",},
@@ -110,7 +111,14 @@ static struct l3_target_data omap_l3_target_data_clk1[MAX_CLKDM_TARGETS] = {
 	{0x900,	"L4WAKEUP",},
 };
 
-static struct l3_target_data omap_l3_target_data_clk2[MAX_CLKDM_TARGETS] = {
+static struct l3_flagmux_data omap_l3_flagmux_clk1 = {
+	.offset = 0x500,
+	.l3_targ = omap_l3_target_data_clk1,
+	.num_targ_data = ARRAY_SIZE(omap_l3_target_data_clk1),
+};
+
+
+static struct l3_target_data omap_l3_target_data_clk2[] = {
 	{0x500,	"CORTEXM3",},
 	{0x300,	"DSS",},
 	{0x100,	"GPMC",},
@@ -134,12 +142,25 @@ static struct l3_target_data omap_l3_target_data_clk2[MAX_CLKDM_TARGETS] = {
 	{0x1700, "LLI",},
 };
 
-static struct l3_target_data omap_l3_target_data_clk3[MAX_CLKDM_TARGETS] = {
+static struct l3_flagmux_data omap_l3_flagmux_clk2 = {
+	.offset = 0x1000,
+	.l3_targ = omap_l3_target_data_clk2,
+	.num_targ_data = ARRAY_SIZE(omap_l3_target_data_clk2),
+};
+
+
+static struct l3_target_data omap_l3_target_data_clk3[] = {
 	{0x0100, "EMUSS",},
 	{0x0300, "DEBUG SOURCE",},
 	{0x0,	"HOST CLK3",},
 };
 
+static struct l3_flagmux_data omap_l3_flagmux_clk3 = {
+	.offset = 0x0200,
+	.l3_targ = omap_l3_target_data_clk3,
+	.num_targ_data = ARRAY_SIZE(omap_l3_target_data_clk3),
+};
+
 static struct l3_masters_data omap_l3_masters[] = {
 	{ 0x0 , "MPU"},
 	{ 0x10, "CS_ADP"},
@@ -168,18 +189,17 @@ static struct l3_masters_data omap_l3_masters[] = {
 	{ 0xC8, "USBHOSTFS"}
 };
 
-static struct l3_target_data *omap_l3_targ[OMAP_L3_MODULES] = {
-	omap_l3_target_data_clk1,
-	omap_l3_target_data_clk2,
-	omap_l3_target_data_clk3,
+static struct l3_flagmux_data *omap_l3_flagmux[] = {
+	&omap_l3_flagmux_clk1,
+	&omap_l3_flagmux_clk2,
+	&omap_l3_flagmux_clk3,
 };
 
 static const struct omap_l3 omap_l3_data = {
 	.l3_flagmux = omap_l3_flagmux,
-	.num_modules = OMAP_L3_MODULES,
+	.num_modules = ARRAY_SIZE(omap_l3_flagmux),
 	.l3_masters = omap_l3_masters,
 	.num_masters = ARRAY_SIZE(omap_l3_masters),
-	.l3_targ = omap_l3_targ,
 };
 
 #endif	/* __OMAP_L3_NOC_H */
-- 
1.7.9.5

