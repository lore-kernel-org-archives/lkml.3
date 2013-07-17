Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3GQWyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:54:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab3GQWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 098/145] iwlwifi: pcie: fix race in queue unmapping
Date: Wed, 17 Jul 2013 15:47:10 -0700
Message-Id: <1374101277-7915-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b967613d7e7c7bad176f5627c55e2d8c5aa2480e upstream.

When a queue is disabled, it frees all its entries. Later,
the op_mode might still get notifications from the firmware
that triggers to free entries in the tx queue. The transport
should be prepared for these races and know to ignore
reclaim calls on queues that have been disabled and whose
entries have been freed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d760da9..c93a7cd 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -574,9 +574,12 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
+		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
+				   txq_id, q->read_ptr);
 		iwl_pcie_txq_free_tfd(trans, txq, dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
+	txq->active = false;
 	spin_unlock_bh(&txq->lock);
 }
 
@@ -907,6 +910,12 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	spin_lock(&txq->lock);
 
+	if (!txq->active) {
+		IWL_DEBUG_TX_QUEUES(trans, "Q %d inactive - ignoring idx %d\n",
+				    txq_id, ssn);
+		goto out;
+	}
+
 	if (txq->q.read_ptr == tfd_num)
 		goto out;
 
@@ -1083,6 +1092,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 		       (fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
 		       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
 		       SCD_QUEUE_STTS_REG_MSK);
+	trans_pcie->txq[txq_id].active = true;
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d WrPtr: %d\n",
 			    txq_id, fifo, ssn & 0xff);
 }
-- 
1.8.1.2

