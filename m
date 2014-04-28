Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaD1Pge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:36:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58612 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaD1PPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:36 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 12/20] bus: omap_l3_noc: fix masterid detection
Date: Mon, 28 Apr 2014 10:14:52 -0500
Message-ID: <1398698101-25513-13-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Documentation (OMAP4+), then masterid is infact encoded as
follows:
"L3_TARG_STDERRLOG_MSTADDR[7:0] STDERRLOG_MSTADDR stores the NTTP
master address. The master address is the concatenation of Prefix &
Initiator ConnID. It is defined on 8 bits. The 6 MSBs are used to
distinguish the different initiators."

So, when we matchup currently with the master ID list, we never get a
proper match other than when MPU is the master (thanks to 0).

Now, on other platforms such as AM437x, this tends to be bits[5:0].

Fix this by using the relevant 6MSBits to identify the master ID for
standard and custom errors.

Reported-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---

V3: made master id information into a structure field thanks to AM437x
information recently recieved.

 drivers/bus/omap_l3_noc.c |    6 +++++-
 drivers/bus/omap_l3_noc.h |    4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 9524452..8a1926d 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -127,7 +127,11 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 					  L3_TARG_STDERRLOG_MSTADDR;
 
 			std_err_main = readl_relaxed(l3_targ_stderr);
-			masterid = readl_relaxed(l3_targ_mstaddr);
+
+			/* STDERRLOG_MSTADDR Stores the NTTP master address. */
+			masterid = (readl_relaxed(l3_targ_mstaddr) &
+				    l3->mst_addr_mask) >>
+					__ffs(l3->mst_addr_mask);
 
 			switch (std_err_main & CUSTOM_ERROR) {
 			case STANDARD_ERROR:
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index 64869fe..ba86924 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -84,6 +84,7 @@ struct l3_flagmux_data {
  * @l3_masters:	array pointing to master data containing name and register
  *		offset for the master.
  * @num_master: number of masters
+ * @mst_addr_mask: Mask representing MSTADDR information of NTTP packet
  * @debug_irq:	irq number of the debug interrupt (populated runtime)
  * @app_irq:	irq number of the application interrupt (populated runtime)
  */
@@ -96,6 +97,7 @@ struct omap_l3 {
 
 	struct l3_masters_data *l3_masters;
 	int num_masters;
+	u32 mst_addr_mask;
 
 	int debug_irq;
 	int app_irq;
@@ -200,6 +202,8 @@ static const struct omap_l3 omap_l3_data = {
 	.num_modules = ARRAY_SIZE(omap_l3_flagmux),
 	.l3_masters = omap_l3_masters,
 	.num_masters = ARRAY_SIZE(omap_l3_masters),
+	/* The 6 MSBs of register field used to distinguish initiator */
+	.mst_addr_mask = 0xFC,
 };
 
 #endif	/* __OMAP_L3_NOC_H */
-- 
1.7.9.5

