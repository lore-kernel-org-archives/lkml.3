Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3I2T34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3I2T3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Vasiliy Glazov <vascom2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 58/71] skge: fix broken driver
Date: Sun, 29 Sep 2013 12:28:10 -0700
Message-Id: <20130929192647.501119952@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c194992cbe71c20bb3623a566af8d11b0bfaa721 upstream.

The patch 136d8f377e1575463b47840bc5f1b22d94bf8f63 broke the skge driver.
Note this part of the patch:
+               if (skge_rx_setup(skge, e, nskb, skge->rx_buf_size) < 0) {
+                       dev_kfree_skb(nskb);
+                       goto resubmit;
+               }
+
                pci_unmap_single(skge->hw->pdev,
                                 dma_unmap_addr(e, mapaddr),
                                 dma_unmap_len(e, maplen),
                                 PCI_DMA_FROMDEVICE);
                skb = e->skb;
                prefetch(skb->data);
-               skge_rx_setup(skge, e, nskb, skge->rx_buf_size);

The function skge_rx_setup modifies e->skb to point to the new skb. Thus,
after this change, the new buffer, not the old, is returned to the
networking stack.

This bug is present in kernels 3.11, 3.11.1 and 3.12-rc1. The patch should
be queued for 3.11-stable.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Vasiliy Glazov <vascom2@gmail.com>
Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/skge.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3092,6 +3092,9 @@ static struct sk_buff *skge_rx_get(struc
 		if (!nskb)
 			goto resubmit;
 
+		skb = e->skb;
+		prefetch(skb->data);
+
 		if (skge_rx_setup(skge, e, nskb, skge->rx_buf_size) < 0) {
 			dev_kfree_skb(nskb);
 			goto resubmit;
@@ -3101,8 +3104,6 @@ static struct sk_buff *skge_rx_get(struc
 				 dma_unmap_addr(e, mapaddr),
 				 dma_unmap_len(e, maplen),
 				 PCI_DMA_FROMDEVICE);
-		skb = e->skb;
-		prefetch(skb->data);
 	}
 
 	skb_put(skb, len);


