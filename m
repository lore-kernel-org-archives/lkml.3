Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab3BSSxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321Ab3BSSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 52/81] netxen: fix off by one bug in netxen_release_tx_buffer()
Date: Tue, 19 Feb 2013 15:49:15 -0300
Message-Id: <1361299784-8830-53-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a05948f296ce103989b28a2606e47d2e287c3c89 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 8694124..fdddfcc 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -144,7 +144,7 @@ void netxen_release_tx_buffers(struct netxen_adapter *adapter)
 					 buffrag->length, PCI_DMA_TODEVICE);
 			buffrag->dma = 0ULL;
 		}
-		for (j = 0; j < cmd_buf->frag_count; j++) {
+		for (j = 1; j < cmd_buf->frag_count; j++) {
 			buffrag++;
 			if (buffrag->dma) {
 				pci_unmap_page(adapter->pdev, buffrag->dma,
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index a77c558..d6a8218 100644
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
-- 
1.7.9.5

