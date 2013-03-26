Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3CZSAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:00:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3CZRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:06 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3_IyCoUOqXUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=acF-SXCFJX0A:10 a=1XWaLZrsAAAA:8 a=ZUspVpn8AAAA:8 a=J1Y8HTJGAAAA:8 a=1ZLoHIA5TJSJ93du4oAA:9 a=UTB_XpHje0EA:10 a=GkFi8FPdP50A:10 a=4N9Db7Z2_RYA:10 a=8F0L5dLGBNITeZV0:21 a=I4mlnqLbotGtORTW:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173602.503152491@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
        Eric Dumazet <edumazet@google.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 16/86] netxen: fix off by one bug in netxen_release_tx_buffer()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0016-netxen-fix-off-by-one-bug-in-netxen_release_tx_buffe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |    2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index bc165f4d..695667d 100644
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
1.7.10.4


