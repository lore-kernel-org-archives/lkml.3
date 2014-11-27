Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaK0IvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:51:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:43018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbaK0Iub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:31 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Narendra K <narendra_k@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 90/91] ixgbevf: Prevent RX/TX statistics getting reset to zero
Date: Thu, 27 Nov 2014 16:43:13 +0800
Message-Id: <1417077794-9299-90-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Narendra K <narendra_k@dell.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 936597631dd310e220544dc5c6075d924efd39b2 upstream.

The commit 4197aa7bb81877ebb06e4f2cc1b5fea2da23a7bd implements 64 bit
per ring statistics. But the driver resets the 'total_bytes' and
'total_packets' from RX and TX rings in the RX and TX interrupt
handlers to zero. This results in statistics being lost and user space
reporting RX and TX statistics as zero. This patch addresses the
issue by preventing the resetting of RX and TX ring statistics to
zero.

Signed-off-by: Narendra K <narendra_k@dell.com>
Tested-by: Sibai Li <sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 307611a..d8e4562 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -969,8 +969,6 @@ static irqreturn_t ixgbevf_msix_clean_tx(int irq, void *data)
 	r_idx = find_first_bit(q_vector->txr_idx, adapter->num_tx_queues);
 	for (i = 0; i < q_vector->txr_count; i++) {
 		tx_ring = &(adapter->tx_ring[r_idx]);
-		tx_ring->total_bytes = 0;
-		tx_ring->total_packets = 0;
 		ixgbevf_clean_tx_irq(adapter, tx_ring);
 		r_idx = find_next_bit(q_vector->txr_idx, adapter->num_tx_queues,
 				      r_idx + 1);
@@ -994,16 +992,6 @@ static irqreturn_t ixgbevf_msix_clean_rx(int irq, void *data)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct ixgbevf_ring  *rx_ring;
 	int r_idx;
-	int i;
-
-	r_idx = find_first_bit(q_vector->rxr_idx, adapter->num_rx_queues);
-	for (i = 0; i < q_vector->rxr_count; i++) {
-		rx_ring = &(adapter->rx_ring[r_idx]);
-		rx_ring->total_bytes = 0;
-		rx_ring->total_packets = 0;
-		r_idx = find_next_bit(q_vector->rxr_idx, adapter->num_rx_queues,
-				      r_idx + 1);
-	}
 
 	if (!q_vector->rxr_count)
 		return IRQ_HANDLED;
-- 
1.9.1

