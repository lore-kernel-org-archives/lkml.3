Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaFWVgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:36:40 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:46212 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752669AbaFWVgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:36:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2729:2828:2914:3138:3139:3140:3141:3142:3353:3865:3867:3868:4225:4250:4321:4385:4419:4605:5007:7652:7903:8603:10004:10400:10848:11026:11233:11657:11658:11914:12043:12296:12438:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: store79_39c99f1ec5f17
X-Filterd-Recvd-Size: 4374
Message-ID: <1403559395.20657.8.camel@joe-AO725>
Subject: [PATCH] amd: Neaten and remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Don Fry <pcnet32@frontier.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 23 Jun 2014 14:36:35 -0700
In-Reply-To: <1403557507.20657.3.camel@joe-AO725>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
	 <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code flow a little better for 80 columns.

Use a consistent style for the RX and TX rings allocation.
Use BIT macro.
Use a temporary unsiged int entries for (1<<size).
Remove the OOM messages as they duplicate the generic
OOM and dump_stack() provided by the memory subsystem.
Reflow allocs to 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 43 ++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 8099fdc..4a8fdc4 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -481,36 +481,32 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 	dma_addr_t *new_dma_addr_list;
 	struct pcnet32_tx_head *new_tx_ring;
 	struct sk_buff **new_skb_list;
+	unsigned int entries = BIT(size);
 
 	pcnet32_purge_tx_ring(dev);
 
-	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_tx_head) *
-					    (1 << size),
-					    &new_ring_dma_addr);
-	if (new_tx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_tx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_tx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_tx_ring == NULL)
 		return;
-	}
 
-	new_dma_addr_list = kcalloc(1 << size, sizeof(dma_addr_t),
-				    GFP_ATOMIC);
+	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
 		goto free_new_tx_ring;
 
-	new_skb_list = kcalloc(1 << size, sizeof(struct sk_buff *),
-			       GFP_ATOMIC);
+	new_skb_list = kcalloc(entries, sizeof(struct sk_buff *), GFP_ATOMIC);
 	if (!new_skb_list)
 		goto free_new_lists;
 
 	kfree(lp->tx_skbuff);
 	kfree(lp->tx_dma_addr);
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    lp->tx_ring_size, lp->tx_ring,
-			    lp->tx_ring_dma_addr);
+			    sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+			    lp->tx_ring, lp->tx_ring_dma_addr);
 
-	lp->tx_ring_size = (1 << size);
+	lp->tx_ring_size = entries;
 	lp->tx_mod_mask = lp->tx_ring_size - 1;
 	lp->tx_len_bits = (size << 12);
 	lp->tx_ring = new_tx_ring;
@@ -523,8 +519,7 @@ free_new_lists:
 	kfree(new_dma_addr_list);
 free_new_tx_ring:
 	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) *
-			    (1 << size),
+			    sizeof(struct pcnet32_tx_head) * entries,
 			    new_tx_ring,
 			    new_ring_dma_addr);
 }
@@ -548,16 +543,14 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 	struct pcnet32_rx_head *new_rx_ring;
 	struct sk_buff **new_skb_list;
 	int new, overlap;
-	unsigned int entries = 1 << size;
+	unsigned int entries = BIT(size);
 
-	new_rx_ring = pci_zalloc_consistent(lp->pci_dev,
-					    sizeof(struct pcnet32_rx_head) *
-					    entries,
-					    &new_ring_dma_addr);
-	if (new_rx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+	new_rx_ring =
+		pci_zalloc_consistent(lp->pci_dev,
+				      sizeof(struct pcnet32_rx_head) * entries,
+				      &new_ring_dma_addr);
+	if (new_rx_ring == NULL)
 		return;
-	}
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)


