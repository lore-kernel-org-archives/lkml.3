Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaD1PQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:16:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58609 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbaD1PP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:29 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 15/20] bus: omap_l3_noc: ignore masked out unclearable targets
Date: Mon, 28 Apr 2014 10:14:55 -0500
Message-ID: <1398698101-25513-16-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Afzal Mohammed <afzal@ti.com>

Errors that cannot be cleared (determined by reading REGERR register)
are currently handled by masking it. Documentation states that REGERR
"Checks which application/debug error sources are active" - it does not
indicate that this is "interrupt status" - masked out status represented
eventually in the irq line to MPU.
For example:

Lets say module 0 bit 8(0x100) was unclearable, we do the mask it from
generating further errors. However in the following cases:
a) bit 9 of Module 0
OR
b) any bit of Module 1+
occur, the interrupt handler wrongly assumes that the raw interrupt
status of module 0 bit 8 is the root cause of the interrupt, and
returns. This causes unhandled interrupt and resultant infinite
interrupts.

Fix this scenario by storing the events we masked out and masking raw
status with masked ones before identifying and handling the error.

Reported-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@gmail.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
V3: new patch

 drivers/bus/omap_l3_noc.c |    9 +++++++++
 drivers/bus/omap_l3_noc.h |    4 ++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 0691e6d..00e4fed 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -169,6 +169,9 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 		err_reg = readl_relaxed(base + flag_mux->offset +
 					L3_FLAGMUX_REGERR0 + (inttype << 3));
 
+		err_reg &= ~(inttype ? flag_mux->mask_app_bits :
+				flag_mux->mask_dbg_bits);
+
 		/* Get the corresponding error and analyse */
 		if (err_reg) {
 			/* Identify the source from control status register */
@@ -193,6 +196,12 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 				mask_val = readl_relaxed(mask_reg);
 				mask_val &= ~(1 << err_src);
 				writel_relaxed(mask_val, mask_reg);
+
+				/* Mark these bits as to be ignored */
+				if (inttype)
+					flag_mux->mask_app_bits |= 1 << err_src;
+				else
+					flag_mux->mask_dbg_bits |= 1 << err_src;
 			}
 
 			/* Error found so break the for loop */
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index ea2f51c..4e18307 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -66,11 +66,15 @@ struct l3_target_data {
  *		target data. unsupported ones are marked with
  *		L3_TARGET_NOT_SUPPORTED
  * @num_targ_data: number of entries in target data
+ * @mask_app_bits: ignore these from raw application irq status
+ * @mask_dbg_bits: ignore these from raw debug irq status
  */
 struct l3_flagmux_data {
 	u32 offset;
 	struct l3_target_data *l3_targ;
 	u8 num_targ_data;
+	u32 mask_app_bits;
+	u32 mask_dbg_bits;
 };
 
 
-- 
1.7.9.5

