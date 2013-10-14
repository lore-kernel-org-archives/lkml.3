Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3JNAW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 20:22:29 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48540 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3JNAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 20:22:28 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH 1/1] drivers: infiniband: ulp: Fix possible use-after-free
Date: Sun, 13 Oct 2013 21:22:46 -0300
Message-Id: <1381710166-27341-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tx_desc variable is being used to access its type member
after a kmem_cache_free call

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 5388226..15b545c 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -610,17 +610,15 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
 		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
 					ISER_HEADERS_LEN, DMA_TO_DEVICE);
 		kmem_cache_free(ig.desc_cache, tx_desc);
-	}
-
-	atomic_dec(&ib_conn->post_send_buf_count);
-
-	if (tx_desc->type == ISCSI_TX_CONTROL) {
+	} else if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		task = (void *) ((long)(void *)tx_desc -
 				  sizeof(struct iscsi_task));
 		if (task->hdr->itt == RESERVED_ITT)
 			iscsi_put_task(task);
 	}
+
+	atomic_dec(&ib_conn->post_send_buf_count);
 }
 
 void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
-- 
1.7.10.4

