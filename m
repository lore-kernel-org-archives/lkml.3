Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbbAJVuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:50:19 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:43991 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbAJVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:50:17 -0500
Message-ID: <1420926614.5947.89.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] 3.19-rc1 net: less interrupt masking in NAPI
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>, Johannes Berg <johannes.berg@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Date: Sat, 10 Jan 2015 13:50:14 -0800
In-Reply-To: <54B199EB.1080004@amd.com>
References: <54B18DFF.80400@amd.com>
	 <1420923485.5947.85.camel@edumazet-glaptop2.roam.corp.google.com>
	 <54B199EB.1080004@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-10 at 23:30 +0200, Oded Gabbay wrote:

> Yes, no problem.
> I will update on the result.

Please try this more complete patch, solving the TX pressure problem as
well, and not lying about NAPI budget. thanks !


diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index e398eda07298..5f05b387c0a7 100644
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


