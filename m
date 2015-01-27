Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbbA0Mgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:36:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbbA0MSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 069/126] alx: fix alx_poll()
Date: Tue, 27 Jan 2015 12:16:14 +0000
Message-Id: <1422361031-19364-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 7a05dc64e2e4c611d89007b125b20c0d2a4d31a5 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/atheros/alx/main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 49faa97a30c3..e751b5db0132 100644
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
2.1.4

