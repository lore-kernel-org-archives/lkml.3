Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaDQUvU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 17 Apr 2014 16:51:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44229 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaDQUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:04 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 09/19] bus: omap_l3_noc: Add support for discountinous flag mux input numbers
Date: Thu, 17 Apr 2014 15:49:25 -0500
Message-ID: <1397767775-10965-10-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

On DRA7, unlike on OMAP4 and OMAP5, the flag mux input numbers used
to indicate the source of errors are not continous. Have a way in the
driver to catch these and WARN the user of the flag mux input thats
either undocumented or wrong.

In the similar vein, Timeout errors in AM43x can't be cleared per h/w
team, neither does it have a STDERRLOG_MAIN to clear the error.

Further, the mux bit offset might not even be indexed into our array
of known mux input description, in which case we'd have a abort.

So, define a static range check for bit description and any definition
which has target_name set to NULL (the ones that are not populated or
ones that are specifically marked in the case of discontinous input
numbers), can handle the same gracefully. Upon occurance of error from
such sources, mask it. Otherwise, we'd have an infinite interrupt
source without any means to clear it.

[nm@ti.com: rebase, squash and improve]
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
V2: reordering changes, There can be max upto 31 clkdm targets possible
V1: https://patchwork.kernel.org/patch/3984021/
 drivers/bus/omap_l3_noc.c |   31 +++++++++++++++++++++++++++++++
 drivers/bus/omap_l3_noc.h |   11 ++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 343f002..27c6ce2 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -75,10 +75,41 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 		if (err_reg) {
 			/* Identify the source from control status register */
 			err_src = __ffs(err_reg);
+
+			/* We DONOT expect err_src to go out of bounds */
+			BUG_ON(err_src > MAX_CLKDM_TARGETS);
+
 			l3_targ_inst = &l3_targ[i][err_src];
 			target_name = l3_targ_inst->name;
 			l3_targ_base = base + l3_targ_inst->offset;
 
+			/*
+			 * If we do not know of a register offset to decode
+			 * and clear, then mask.
+			 */
+			if (target_name == L3_TARGET_NOT_SUPPORTED) {
+				u32 mask_val;
+				void __iomem *mask_reg;
+
+				/*
+				 * Certain plaforms may have "undocumented"
+				 * status pending on boot.. So dont generate
+				 * a severe warning here.
+				 */
+				dev_err(l3->dev,
+					"L3 %s error: target %d mod:%d %s\n",
+					inttype ? "debug" : "application",
+					err_src, i, "(unclearable)");
+
+				mask_reg = base + l3_flagmux[i] +
+					   L3_FLAGMUX_MASK0 + (inttype << 3);
+				mask_val = readl(mask_reg);
+				mask_val &= ~(1 << err_src);
+				writel(mask_val, mask_reg);
+
+				break;
+			}
+
 			/* Read the stderrlog_main_source from clk domain */
 			l3_targ_stderr = l3_targ_base + L3_TARG_STDERRLOG_MAIN;
 			l3_targ_slvofslsb = l3_targ_base +
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index ae28784..66caece 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -30,6 +30,11 @@
 #define L3_TARG_STDERRLOG_SLVOFSLSB	0x5c
 #define L3_TARG_STDERRLOG_MSTADDR	0x68
 #define L3_FLAGMUX_REGERR0		0xc
+#define L3_FLAGMUX_MASK0		0x8
+
+#define L3_TARGET_NOT_SUPPORTED		NULL
+
+#define MAX_CLKDM_TARGETS		31
 
 #define NUM_OF_L3_MASTERS	(sizeof(l3_masters)/sizeof(l3_masters[0]))
 
@@ -61,7 +66,7 @@ static u32 l3_flagmux[L3_MODULES] = {
 	0X0200
 };
 
-static struct l3_target_data l3_target_inst_data_clk1[] = {
+static struct l3_target_data l3_target_inst_data_clk1[MAX_CLKDM_TARGETS] = {
 	{0x100,	"DMM1",},
 	{0x200,	"DMM2",},
 	{0x300,	"ABE",},
@@ -71,7 +76,7 @@ static struct l3_target_data l3_target_inst_data_clk1[] = {
 	{0x900,	"L4WAKEUP",},
 };
 
-static struct l3_target_data l3_target_inst_data_clk2[] = {
+static struct l3_target_data l3_target_inst_data_clk2[MAX_CLKDM_TARGETS] = {
 	{0x500,	"CORTEXM3",},
 	{0x300,	"DSS",},
 	{0x100,	"GPMC",},
@@ -95,7 +100,7 @@ static struct l3_target_data l3_target_inst_data_clk2[] = {
 	{0x1700, "LLI",},
 };
 
-static struct l3_target_data l3_target_inst_data_clk3[] = {
+static struct l3_target_data l3_target_inst_data_clk3[MAX_CLKDM_TARGETS] = {
 	{0x0100, "EMUSS",},
 	{0x0300, "DEBUG SOURCE",},
 	{0x0,	"HOST CLK3",},
-- 
1.7.9.5

