Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbbA2Jxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:53:50 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44798 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759007AbbA2JDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/176] alx: fix alx_poll()
Date: Wed, 28 Jan 2015 15:28:14 +0100
Message-Id: <cbac92132ff61018792166045ce2c362cd7f48e0.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 7a05dc64e2e4c611d89007b125b20c0d2a4d31a5 ]

Commit d75b1ade567f ("net: less interrupt masking in NAPI") uncovered
wrong alx_poll() behavior.

A NAPI poll() handler is supposed to return exactly the budget when/if
napi_complete() has not been called.

It is also supposed to return number of frames that were received, so
that netdev_budget can have a meaning.

Also, in case of TX pressure, we still have to dequeue received
packets : alx_clean_rx_irq() has to be called even if
alx_clean_tx_irq(alx) returns false, otherwise device is half duplex.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: d75b1ade567f ("net: less interrupt masking in NAPI")
Reported-by: Oded Gabbay <oded.gabbay@amd.com>
Bisected-by: Oded Gabbay <oded.gabbay@amd.com>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/atheros/alx/main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 6305a5d29db2..754ac8ef2484 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -184,15 +184,16 @@ static void alx_schedule_reset(struct alx_priv *alx)
 	schedule_work(&alx->reset_wk);
 }
 
-static bool alx_clean_rx_irq(struct alx_priv *alx, int budget)
+static int alx_clean_rx_irq(struct alx_priv *alx, int budget)
 {
 	struct alx_rx_queue *rxq = &alx->rxq;
 	struct alx_rrd *rrd;
 	struct alx_buffer *rxb;
 	struct sk_buff *skb;
 	u16 length, rfd_cleaned = 0;
+	int work = 0;
 
-	while (budget > 0) {
+	while (work < budget) {
 		rrd = &rxq->rrd[rxq->rrd_read_idx];
 		if (!(rrd->word3 & cpu_to_le32(1 << RRD_UPDATED_SHIFT)))
 			break;
@@ -203,7 +204,7 @@ static bool alx_clean_rx_irq(struct alx_priv *alx, int budget)
 		    ALX_GET_FIELD(le32_to_cpu(rrd->word0),
 				  RRD_NOR) != 1) {
 			alx_schedule_reset(alx);
-			return 0;
+			return work;
 		}
 
 		rxb = &rxq->bufs[rxq->read_idx];
@@ -243,7 +244,7 @@ static bool alx_clean_rx_irq(struct alx_priv *alx, int budget)
 		}
 
 		napi_gro_receive(&alx->napi, skb);
-		budget--;
+		work++;
 
 next_pkt:
 		if (++rxq->read_idx == alx->rx_ringsz)
@@ -258,21 +259,22 @@ next_pkt:
 	if (rfd_cleaned)
 		alx_refill_rx_ring(alx, GFP_ATOMIC);
 
-	return budget > 0;
+	return work;
 }
 
 static int alx_poll(struct napi_struct *napi, int budget)
 {
 	struct alx_priv *alx = container_of(napi, struct alx_priv, napi);
 	struct alx_hw *hw = &alx->hw;
-	bool complete = true;
 	unsigned long flags;
+	bool tx_complete;
+	int work;
 
-	complete = alx_clean_tx_irq(alx) &&
-		   alx_clean_rx_irq(alx, budget);
+	tx_complete = alx_clean_tx_irq(alx);
+	work = alx_clean_rx_irq(alx, budget);
 
-	if (!complete)
-		return 1;
+	if (!tx_complete || work == budget)
+		return budget;
 
 	napi_complete(&alx->napi);
 
@@ -284,7 +286,7 @@ static int alx_poll(struct napi_struct *napi, int budget)
 
 	alx_post_write(hw);
 
-	return 0;
+	return work;
 }
 
 static irqreturn_t alx_intr_handle(struct alx_priv *alx, u32 intr)
-- 
2.2.2

