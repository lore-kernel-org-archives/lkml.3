Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3APQrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:47:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab3APQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 102/222] solos-pci: fix double-free of TX skb in DMA mode
Date: Wed, 16 Jan 2013 13:55:02 -0200
Message-Id: <1358351822-7675-103-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit cae49ede00ec3d0cda290b03fee55b72b49efc11 upstream.

We weren't clearing card->tx_skb[port] when processing the TX done interrupt.
If there wasn't another skb ready to transmit immediately, this led to a
double-free because we'd free it *again* next time we did have a packet to
send.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/atm/solos-pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 9851093..1853a45 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -967,10 +967,11 @@ static uint32_t fpga_tx(struct solos_card *card)
 	for (port = 0; tx_pending; tx_pending >>= 1, port++) {
 		if (tx_pending & 1) {
 			struct sk_buff *oldskb = card->tx_skb[port];
-			if (oldskb)
+			if (oldskb) {
 				pci_unmap_single(card->dev, SKB_CB(oldskb)->dma_addr,
 						 oldskb->len, PCI_DMA_TODEVICE);
-
+				card->tx_skb[port] = NULL;
+			}
 			spin_lock(&card->tx_queue_lock);
 			skb = skb_dequeue(&card->tx_queue[port]);
 			if (!skb)
-- 
1.7.9.5

