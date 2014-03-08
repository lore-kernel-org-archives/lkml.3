Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaCHBIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:08:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaCHBIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:08:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.khan@hp.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 92/99] iwlwifi: handle DMA mapping failures
Date: Fri,  7 Mar 2014 17:08:28 -0800
Message-Id: <20140308010614.515388530@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Johannes Berg <johannes.berg@intel.com>

commit 7c34158231b2eda8dcbd297be2bb1559e69cb433 upstream.

The RX replenish code doesn't handle DMA mapping failures,
which will cause issues if there actually is a failure. This
was reported by Shuah Khan who found a DMA mapping framework
warning ("device driver failed to check map error").

Reported-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2:
 - Adjust filename, context, indentation
 - Use bus(trans) instead of trans where necessary
 - Use hw_params(trans).rx_page_order instead of trans_pcie->rx_page_order]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wujg: Backported to 3.4:
 - Adjust context
 - Use trans instead of bus(trans)
 - Use hw_params(trans).rx_page_order instead of trans_pcie->rx_page_order]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -315,6 +315,14 @@ static void iwlagn_rx_allocate(struct iw
 		rxb->page_dma = dma_map_page(trans->dev, page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			rxb->page = NULL;
+			spin_lock_irqsave(&rxq->lock, flags);
+			list_add(&rxb->list, &rxq->rx_used);
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, hw_params(trans).rx_page_order);
+			return;
+		}
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -450,8 +458,19 @@ static void iwl_rx_handle_rxbuf(struct i
 			dma_map_page(trans->dev, rxb->page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			/*
+			 * free the page(s) as well to not break
+			 * the invariant that the items on the used
+			 * list have no page(s)
+			 */
+			__free_pages(rxb->page, hw_params(trans).rx_page_order);
+			rxb->page = NULL;
+			list_add_tail(&rxb->list, &rxq->rx_used);
+		} else {
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
 	spin_unlock_irqrestore(&rxq->lock, flags);


