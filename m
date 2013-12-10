Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3LJIYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:24:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LJIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 37/52] tg3: avoid double-freeing of rx data memory
Date: Tue, 10 Dec 2013 00:01:10 -0800
Message-Id: <20131210075956.808179072@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit 85aec73d595b8847f9c4ea571deb127913f0d508 upstream.

If build_skb fails the memory associated with the ring buffer is freed but
the ri->data member is not zeroed in this case. This causes a double-free
of this memory in tg3_free_rings->... path. The patch moves this block after
setting ri->data to NULL.
It would be nice to fix this bug also in stable >= v3.4 trees.

Cc: Nithin Nayak Sujir <nsujir@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6722,12 +6722,6 @@ static int tg3_rx(struct tg3_napi *tnapi
 			pci_unmap_single(tp->pdev, dma_addr, skb_size,
 					 PCI_DMA_FROMDEVICE);
 
-			skb = build_skb(data, frag_size);
-			if (!skb) {
-				tg3_frag_free(frag_size != 0, data);
-				goto drop_it_no_recycle;
-			}
-			skb_reserve(skb, TG3_RX_OFFSET(tp));
 			/* Ensure that the update to the data happens
 			 * after the usage of the old DMA mapping.
 			 */
@@ -6735,6 +6729,12 @@ static int tg3_rx(struct tg3_napi *tnapi
 
 			ri->data = NULL;
 
+			skb = build_skb(data, frag_size);
+			if (!skb) {
+				tg3_frag_free(frag_size != 0, data);
+				goto drop_it_no_recycle;
+			}
+			skb_reserve(skb, TG3_RX_OFFSET(tp));
 		} else {
 			tg3_recycle_rx(tnapi, tpr, opaque_key,
 				       desc_idx, *post_ptr);


