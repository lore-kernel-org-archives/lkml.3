Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3LSL6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab3LSL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/208] tg3: avoid double-freeing of rx data memory
Date: Thu, 19 Dec 2013 11:53:25 +0000
Message-Id: <1387454106-19326-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index a04d2da..9f535de 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6795,12 +6795,6 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
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
@@ -6808,6 +6802,12 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 
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
-- 
1.8.3.2

