Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaAGBiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:38:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaAGBiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:38:08 -0500
Date: Mon, 06 Jan 2014 20:38:06 -0500 (EST)
Message-Id: <20140106.203806.913798650848633178.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: akpm@linux-foundation.org, rmody@brocade.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2014-01-02-14-35 uploaded (brocade/bna)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140106.172427.1901836894729408800.davem@davemloft.net>
References: <20140102223649.D8FB931C206@corp2gmr1-1.hot.corp.google.com>
	<52C700B9.8040504@infradead.org>
	<20140106.172427.1901836894729408800.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 17:38:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 06 Jan 2014 17:24:27 -0500 (EST)

> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Fri, 03 Jan 2014 10:26:01 -0800
> 
>> as reported for linux-next of Dec.20, 2013
>> when CONFIG_NEED_DMA_MAP_STATE is not enabled:
>> 
>> drivers/net/ethernet/brocade/bna/bnad.c: In function 'bnad_start_xmit':
>> drivers/net/ethernet/brocade/bna/bnad.c:3074:26: error: 'struct bnad_tx_vector' has no member named 'dma_len'
> 
> Sorry for taking so long, I plan to look into this tonight Randy.

I just committed the following fix for this, thanks!

====================
[PATCH] bna: Fix build due to missing use of dma_unmap_len_set()

> as reported for linux-next of Dec.20, 2013
> when CONFIG_NEED_DMA_MAP_STATE is not enabled:
>
> drivers/net/ethernet/brocade/bna/bnad.c: In function 'bnad_start_xmit':
> drivers/net/ethernet/brocade/bna/bnad.c:3074:26: error: 'struct bnad_tx_vector' has no member named 'dma_len'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index d31524f..5f24a9f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3071,11 +3071,11 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 		dma_addr = skb_frag_dma_map(&bnad->pcidev->dev, frag,
 					    0, size, DMA_TO_DEVICE);
-		unmap->vectors[vect_id].dma_len = size;
+		dma_unmap_len_set(&unmap->vectors[vect_id], dma_len, size);
 		BNA_SET_DMA_ADDR(dma_addr, &txqent->vector[vect_id].host_addr);
 		txqent->vector[vect_id].length = htons(size);
 		dma_unmap_addr_set(&unmap->vectors[vect_id], dma_addr,
-						dma_addr);
+				   dma_addr);
 		head_unmap->nvecs++;
 	}
 
-- 
1.7.11.7

