Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaEDWoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:44:32 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:55700 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaEDWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:44:29 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        git@xilinx.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 3/5] net: macb: Re-enable RX interrupt only when RX is done
Date: Sun,  4 May 2014 15:43:00 -0700
Message-Id: <1399243382-12528-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.2.1.g06c4abd
In-Reply-To: <1399243382-12528-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1399243382-12528-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When data is received during the driver processing received data the
NAPI is re-scheduled. In that case the RX interrupt should not be
re-enabled.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 drivers/net/ethernet/cadence/macb.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index e38fe39d9589..3f4b8ee0b0e7 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -891,16 +891,15 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete(napi);
 
-		/*
-		 * We've done what we can to clean the buffers. Make sure we
-		 * get notified when new packets arrive.
-		 */
-		macb_writel(bp, IER, MACB_RX_INT_FLAGS);
-
 		/* Packets received while interrupts were disabled */
 		status = macb_readl(bp, RSR);
-		if (unlikely(status))
+		if (unlikely(status)) {
+			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+				macb_writel(bp, ISR, MACB_BIT(RCOMP));
 			napi_reschedule(napi);
+		} else {
+			macb_writel(bp, IER, MACB_RX_INT_FLAGS);
+		}
 	}
 
 	/* TODO: Handle errors */
-- 
1.9.2.1.g06c4abd

