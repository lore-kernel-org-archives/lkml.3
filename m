Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaL2RLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:11:16 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53723
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbaL2RKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,659,1413237600"; 
   d="scan'208";a="94921797"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] ath10k: fix error return code
Date: Mon, 29 Dec 2014 18:04:43 +0100
Message-Id: <1419872683-32709-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 4bc51d8..2836f4c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -480,8 +480,10 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	skb_cb->htt.txbuf = dma_pool_alloc(htt->tx_pool, GFP_ATOMIC,
 					   &paddr);
-	if (!skb_cb->htt.txbuf)
+	if (!skb_cb->htt.txbuf) {
+		res = -ENOMEM;
 		goto err_free_msdu_id;
+	}
 	skb_cb->htt.txbuf_paddr = paddr;
 
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,

