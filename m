Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaD0Obt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:31:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9516 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752661AbaD0Obn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:31:43 -0400
Message-Id: <20140427143140.384915886@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:31:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 2/4] net: gianfar: do not try to cleanup TX packets if they are not done
References: <20140427143119.898655303@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-net-gianfar-do-not-try-to-cleanup-TX-packets-if-they.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.37-rt38-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

What I observe is that the TX queue is not empty and does not make any
progress. gfar_clean_tx_ring() does not clean up the packet because it
is not completed yet.
The root cause is that the DMA engine did not start yet (it was
preempted before doing so) and that dumb loop, loops until that packet
is gone.
This is broken since c233cf4 ("gianfar: Fix tx napi polling").

What remains are spurious interrupts if CPU0 cleans up TX packages and
CPU1 returns with IRQ_NONE.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 5c0efcc..8aecc1d 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -132,7 +132,6 @@ static int gfar_poll(struct napi_struct *napi, int budget);
 static void gfar_netpoll(struct net_device *dev);
 #endif
 int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit);
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue);
 static void gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
 			       int amount_pull, struct napi_struct *napi);
 void gfar_halt(struct net_device *dev);
@@ -2475,7 +2474,7 @@ static void gfar_align_skb(struct sk_buff *skb)
 }
 
 /* Interrupt Handler for Transmit complete */
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
+static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 {
 	struct net_device *dev = tx_queue->dev;
 	struct netdev_queue *txq;
@@ -2856,10 +2855,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
 			tx_queue = priv->tx_queue[i];
 			/* run Tx cleanup to completion */
 			if (tx_queue->tx_skbuff[tx_queue->skb_dirtytx]) {
-				gfar_clean_tx_ring(tx_queue);
-				has_tx_work = 1;
+				int ret;
+
+				ret = gfar_clean_tx_ring(tx_queue);
+				if (ret)
+					has_tx_work++;
 			}
 		}
+		work_done += has_tx_work;
 
 		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
 			/* skip queue if not active */
-- 
1.8.5.3


