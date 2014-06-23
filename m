Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaFWNnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:14 -0400
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:59199 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754673AbaFWNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3871:4250:4321:4419:4605:5007:6261:9592:10004:10026:10848:11026:11473:11657:11658:11914:12043:12114:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sack80_8eba1a2ac2052
X-Filterd-Recvd-Size: 2946
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/22] rtlwifi: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:46 -0700
Message-Id: <4aac54b883b1664453c24d292e9d20595a2794c6.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtlwifi/pci.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index dae5525..67d1ee6 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1092,16 +1092,14 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	u32 nextdescaddress;
 	int i;
 
-	ring = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*ring) * entries, &dma);
-
+	ring = pci_zalloc_consistent(rtlpci->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring) * entries);
 	rtlpci->tx_ring[prio].desc = ring;
 	rtlpci->tx_ring[prio].dma = dma;
 	rtlpci->tx_ring[prio].idx = 0;
@@ -1139,10 +1137,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
 	     rx_queue_idx++) {
 		rtlpci->rx_ring[rx_queue_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rx_queue_idx].
-						desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rx_queue_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rx_queue_idx].dma);
 
 		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
@@ -1151,10 +1148,6 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rx_queue_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) *
-		       rtlpci->rxringcount);
-
 		rtlpci->rx_ring[rx_queue_idx].idx = 0;
 
 		/* If amsdu_8k is disabled, set buffersize to 4096. This
-- 
1.8.1.2.459.gbcd45b4.dirty

