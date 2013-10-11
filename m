Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3JKUKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:10:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3JKTlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 034/135] skge: fix invalid value passed to pci_unmap_sigle
Date: Fri, 11 Oct 2013 12:38:35 -0700
Message-Id: <20131011193948.940622012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 3361dc9538832a2a9150a8c722374ca844bf8dc8 ]

In my patch c194992cbe71c20bb3623a566af8d11b0bfaa721 ("skge: fix
broken driver") I didn't fix the skge bug correctly. The value of the
new mapping (not old) was passed to pci_unmap_single.

If we enable CONFIG_DMA_API_DEBUG, it results in this warning:
WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:986 check_sync+0x4c4/0x580()
skge 0000:02:07.0: DMA-API: device driver tries to sync DMA memory it has
not allocated [device address=0x000000023a0096c0] [size=1536 bytes]

This patch makes the skge driver pass the correct value to
pci_unmap_single and fixes the warning. It copies the old descriptor to
on-stack variable "ee" and unmaps it if mapping of the new descriptor
succeeded.

This patch should be backported to 3.11-stable.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/skge.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3086,13 +3086,16 @@ static struct sk_buff *skge_rx_get(struc
 					       PCI_DMA_FROMDEVICE);
 		skge_rx_reuse(e, skge->rx_buf_size);
 	} else {
+		struct skge_element ee;
 		struct sk_buff *nskb;
 
 		nskb = netdev_alloc_skb_ip_align(dev, skge->rx_buf_size);
 		if (!nskb)
 			goto resubmit;
 
-		skb = e->skb;
+		ee = *e;
+
+		skb = ee.skb;
 		prefetch(skb->data);
 
 		if (skge_rx_setup(skge, e, nskb, skge->rx_buf_size) < 0) {
@@ -3101,8 +3104,8 @@ static struct sk_buff *skge_rx_get(struc
 		}
 
 		pci_unmap_single(skge->hw->pdev,
-				 dma_unmap_addr(e, mapaddr),
-				 dma_unmap_len(e, maplen),
+				 dma_unmap_addr(&ee, mapaddr),
+				 dma_unmap_len(&ee, maplen),
 				 PCI_DMA_FROMDEVICE);
 	}
 


