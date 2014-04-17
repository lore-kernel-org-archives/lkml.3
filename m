Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDQUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:50:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38103 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaDQUuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:03 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 12/19] bus: omap_l3_noc: fix masterid detection
Date: Thu, 17 Apr 2014 15:49:28 -0500
Message-ID: <1397767775-10965-13-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
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

So when we matchup currently with the master ID list, we never get a
proper match other than when MPU is the master (thanks to 0). Fix this
by using the relevant 6MSBits to identify the master ID for standard
and custom errors.

Reported-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

New patch.

 drivers/bus/omap_l3_noc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 300e168..29d6206 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -127,7 +127,12 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 					  L3_TARG_STDERRLOG_MSTADDR;
 
 			std_err_main = readl_relaxed(l3_targ_stderr);
-			masterid = readl_relaxed(l3_targ_mstaddr);
+			/*
+			 * STDERRLOG_MSTADDR Stores the NTTP master address.
+			 * The 6 MSBs are used to distinguish the different
+			 * initiators
+			 */
+			masterid = (readl_relaxed(l3_targ_mstaddr) & 0xFF) >> 2;
 
 			switch (std_err_main & CUSTOM_ERROR) {
 			case STANDARD_ERROR:
-- 
1.7.9.5

