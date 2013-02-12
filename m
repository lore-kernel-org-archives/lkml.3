Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3BLVEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:04:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3BLUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Eric Dumazet <edumazet@google.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 29/61] netxen: fix off by one bug in netxen_release_tx_buffer()
Date: Tue, 12 Feb 2013 12:34:49 -0800
Message-Id: <20130212203422.235762643@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a05948f296ce103989b28a2606e47d2e287c3c89 ]

Christoph Paasch found netxen could trigger a BUG in its dismantle
phase, in netxen_release_tx_buffer(), using full size TSO packets.

cmd_buf->frag_count includes the skb->data part, so the loop must
start at index 1 instead of 0, or else we can make an out
of bound access to cmd_buff->frag_array[MAX_SKB_FRAGS + 2]

Christoph provided the fixes in netxen_map_tx_skb() function.
In case of a dma mapping error, its better to clear the dma fields
so that we don't try to unmap them again in netxen_release_tx_buffer()

Reported-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: Sony Chacko <sony.chacko@qlogic.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |    2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -144,7 +144,7 @@ void netxen_release_tx_buffers(struct ne
 					 buffrag->length, PCI_DMA_TODEVICE);
 			buffrag->dma = 0ULL;
 		}
-		for (j = 0; j < cmd_buf->frag_count; j++) {
+		for (j = 1; j < cmd_buf->frag_count; j++) {
 			buffrag++;
 			if (buffrag->dma) {
 				pci_unmap_page(adapter->pdev, buffrag->dma,
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1963,10 +1963,12 @@ unwind:
 	while (--i >= 0) {
 		nf = &pbuf->frag_array[i+1];
 		pci_unmap_page(pdev, nf->dma, nf->length, PCI_DMA_TODEVICE);
+		nf->dma = 0ULL;
 	}
 
 	nf = &pbuf->frag_array[0];
 	pci_unmap_single(pdev, nf->dma, skb_headlen(skb), PCI_DMA_TODEVICE);
+	nf->dma = 0ULL;
 
 out_err:
 	return -ENOMEM;


