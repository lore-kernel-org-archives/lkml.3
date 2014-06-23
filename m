Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaFWNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:44:18 -0400
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:45115 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756181AbaFWNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:1:41:69:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2639:2729:3138:3139:3140:3141:3142:3865:3870:4225:4250:4321:4385:4419:4605:5007:6119:6261:7903:8957:9592:10004:10026:10848:11026:11233:11473:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555:12731:12737,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leaf57_90e894938cb04
X-Filterd-Recvd-Size: 14371
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 20/22] staging: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:48 -0700
Message-Id: <39c296d08cd5cf8e3ea1607b213a4e30494e92f2.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 15 ++++-------
 drivers/staging/rtl8192ee/pci.c              | 37 +++++++++----------------
 drivers/staging/rtl8821ae/pci.c              | 36 +++++++++----------------
 drivers/staging/slicoss/slicoss.c            |  9 +++----
 drivers/staging/vt6655/device_main.c         | 40 +++++++++-------------------
 5 files changed, 44 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 2920e40..5729cf6 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2065,20 +2065,16 @@ static short rtl8192_alloc_rx_desc_ring(struct net_device *dev)
 	int i, rx_queue_idx;
 
 	for (rx_queue_idx = 0; rx_queue_idx < MAX_RX_QUEUE; rx_queue_idx++) {
-		priv->rx_ring[rx_queue_idx] = pci_alloc_consistent(priv->pdev,
-					sizeof(*priv->rx_ring[rx_queue_idx]) *
-					priv->rxringcount,
-					&priv->rx_ring_dma[rx_queue_idx]);
-
+		priv->rx_ring[rx_queue_idx] =
+			pci_zalloc_consistent(priv->pdev,
+					      sizeof(*priv->rx_ring[rx_queue_idx]) * priv->rxringcount,
+					      &priv->rx_ring_dma[rx_queue_idx]);
 		if (!priv->rx_ring[rx_queue_idx] ||
 		    (unsigned long)priv->rx_ring[rx_queue_idx] & 0xFF) {
 			RT_TRACE(COMP_ERR, "Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
-		memset(priv->rx_ring[rx_queue_idx], 0,
-		       sizeof(*priv->rx_ring[rx_queue_idx]) *
-		       priv->rxringcount);
 		priv->rx_idx[rx_queue_idx] = 0;
 
 		for (i = 0; i < priv->rxringcount; i++) {
@@ -2118,14 +2114,13 @@ static int rtl8192_alloc_tx_desc_ring(struct net_device *dev,
 	dma_addr_t dma;
 	int i;
 
-	ring = pci_alloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
+	ring = pci_zalloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(COMP_ERR, "Cannot allocate TX ring (prio = %d)\n",
 			 prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring)*entries);
 	priv->tx_ring[prio].desc = ring;
 	priv->tx_ring[prio].dma = dma;
 	priv->tx_ring[prio].idx = 0;
diff --git a/drivers/staging/rtl8192ee/pci.c b/drivers/staging/rtl8192ee/pci.c
index 3fe9b7b..ddfb25f 100644
--- a/drivers/staging/rtl8192ee/pci.c
+++ b/drivers/staging/rtl8192ee/pci.c
@@ -1224,10 +1224,10 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 
 	/* alloc tx buffer desc for new trx flow*/
 	if (rtlpriv->use_new_trx_flow) {
-		buffer_desc = pci_alloc_consistent(rtlpci->pdev,
-					sizeof(*buffer_desc) * entries,
-					&buffer_desc_dma);
-
+		buffer_desc =
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*buffer_desc) * entries,
+					      &buffer_desc_dma);
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
 				 ("Cannot allocate TX ring (prio = %d)\n",
@@ -1235,7 +1235,6 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 			return -ENOMEM;
 		}
 
-		memset(buffer_desc, 0, sizeof(*buffer_desc) * entries);
 		rtlpci->tx_ring[prio].buffer_desc = buffer_desc;
 		rtlpci->tx_ring[prio].buffer_desc_dma = buffer_desc_dma;
 
@@ -1245,16 +1244,14 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	}
 
 	/* alloc dma for this ring */
-	desc = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*desc) * entries, &desc_dma);
-
+	desc = pci_zalloc_consistent(rtlpci->pdev, sizeof(*desc) * entries,
+				     &desc_dma);
 	if (!desc || (unsigned long)desc & 0xFF) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
 			 ("Cannot allocate TX ring (prio = %d)\n", prio));
 		return -ENOMEM;
 	}
 
-	memset(desc, 0, sizeof(*desc) * entries);
 	rtlpci->tx_ring[prio].desc = desc;
 	rtlpci->tx_ring[prio].dma = desc_dma;
 
@@ -1290,11 +1287,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		struct rtl_rx_buffer_desc *entry = NULL;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].buffer_desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-						buffer_desc) *
-						rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1302,10 +1297,6 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].buffer_desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 
@@ -1320,19 +1311,15 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		u8 tmp_one = 1;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
 				 ("Cannot allocate RX ring\n"));
 			return -ENOMEM;
 		}
-		memset(rtlpci->rx_ring[rxring_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
-		       rtlpci->rxringcount);
 
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index e194ffe..f7efde1 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -1248,9 +1248,10 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 
 	/* alloc tx buffer desc for new trx flow*/
 	if (rtlpriv->use_new_trx_flow) {
-		buffer_desc = pci_alloc_consistent(rtlpci->pdev,
-					    sizeof(*buffer_desc) * entries,
-					    &buffer_desc_dma);
+		buffer_desc =
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*buffer_desc) * entries,
+					      &buffer_desc_dma);
 
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1259,7 +1260,6 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 			return -ENOMEM;
 		}
 
-		memset(buffer_desc, 0, sizeof(*buffer_desc) * entries);
 		rtlpci->tx_ring[prio].buffer_desc = buffer_desc;
 		rtlpci->tx_ring[prio].buffer_desc_dma = buffer_desc_dma;
 
@@ -1270,8 +1270,8 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	}
 
 	/* alloc dma for this ring */
-	desc = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*desc) * entries, &desc_dma);
+	desc = pci_zalloc_consistent(rtlpci->pdev, sizeof(*desc) * entries,
+				     &desc_dma);
 
 	if (!desc || (unsigned long)desc & 0xFF) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1279,7 +1279,6 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 		return -ENOMEM;
 	}
 
-	memset(desc, 0, sizeof(*desc) * entries);
 	rtlpci->tx_ring[prio].desc = desc;
 	rtlpci->tx_ring[prio].dma = desc_dma;
 
@@ -1316,21 +1315,15 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		struct rtl_rx_buffer_desc *entry = NULL;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].buffer_desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					        buffer_desc) *
-					        rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG, ("Cannot allocate RX ring\n"));
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].buffer_desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 		for (i = 0; i < rtlpci->rxringcount; i++) {
@@ -1344,10 +1337,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		u8 tmp_one = 1;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					        desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1355,10 +1347,6 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 		for (i = 0; i < rtlpci->rxringcount; i++) {
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 48841e7..ebcbf91 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1190,18 +1190,15 @@ static int slic_rspqueue_init(struct adapter *adapter)
 	rspq->num_pages = SLIC_RSPQ_PAGES_GB;
 
 	for (i = 0; i < rspq->num_pages; i++) {
-		rspq->vaddr[i] = pci_alloc_consistent(adapter->pcidev,
-						      PAGE_SIZE,
-						      &rspq->paddr[i]);
+		rspq->vaddr[i] = pci_zalloc_consistent(adapter->pcidev,
+						       PAGE_SIZE,
+						       &rspq->paddr[i]);
 		if (!rspq->vaddr[i]) {
 			dev_err(&adapter->pcidev->dev,
 				"pci_alloc_consistent failed\n");
 			slic_rspqueue_free(adapter);
 			return -ENOMEM;
 		}
-		/* FIXME:
-		 * do we really need this assertions (4K PAGE_SIZE aligned addr)? */
-		memset(rspq->vaddr[i], 0, PAGE_SIZE);
 
 		if (paddrh == 0) {
 			slic_reg32_write(&slic_regs->slic_rbar,
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 2327386..d17cb1a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1091,25 +1091,17 @@ static bool device_init_rings(PSDevice pDevice) {
 	void *vir_pool;
 
 	/*allocate all RD/TD rings a single pool*/
-	vir_pool = pci_alloc_consistent(pDevice->pcid,
-					pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-					pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-					pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-					pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
-					&pDevice->pool_dma);
-
+	vir_pool = pci_zalloc_consistent(pDevice->pcid,
+					 pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
+					 pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
+					 pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
+					 pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
+					 &pDevice->pool_dma);
 	if (vir_pool == NULL) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s : allocate desc dma memory failed\n", pDevice->dev->name);
 		return false;
 	}
 
-	memset(vir_pool, 0,
-	       pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-	       pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-	       pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-	       pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc)
-		);
-
 	pDevice->aRD0Ring = vir_pool;
 	pDevice->aRD1Ring = vir_pool +
 		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
@@ -1118,13 +1110,12 @@ static bool device_init_rings(PSDevice pDevice) {
 	pDevice->rd1_pool_dma = pDevice->rd0_pool_dma +
 		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
 
-	pDevice->tx0_bufs = pci_alloc_consistent(pDevice->pcid,
-						 pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-						 pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-						 CB_BEACON_BUF_SIZE +
-						 CB_MAX_BUF_SIZE,
-						 &pDevice->tx_bufs_dma0);
-
+	pDevice->tx0_bufs = pci_zalloc_consistent(pDevice->pcid,
+						  pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
+						  pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+						  CB_BEACON_BUF_SIZE +
+						  CB_MAX_BUF_SIZE,
+						  &pDevice->tx_bufs_dma0);
 	if (pDevice->tx0_bufs == NULL) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: allocate buf dma memory failed\n", pDevice->dev->name);
 		pci_free_consistent(pDevice->pcid,
@@ -1137,13 +1128,6 @@ static bool device_init_rings(PSDevice pDevice) {
 		return false;
 	}
 
-	memset(pDevice->tx0_bufs, 0,
-	       pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-	       pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-	       CB_BEACON_BUF_SIZE +
-	       CB_MAX_BUF_SIZE
-		);
-
 	pDevice->td0_pool_dma = pDevice->rd1_pool_dma +
 		pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc);
 
-- 
1.8.1.2.459.gbcd45b4.dirty

