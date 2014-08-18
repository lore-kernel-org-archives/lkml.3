Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHROlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:41:15 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58606 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaHROlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:41:14 -0400
Date: Mon, 18 Aug 2014 17:41:01 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: willy@linux.intel.com, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] nvme: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818144101.GA13840@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/block/nvme-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 02351e2..cb25bdd 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1209,7 +1209,7 @@ static void nvme_free_queues(struct nvme_dev *dev, int lowest)
 
 	for (i = dev->queue_count - 1; i >= lowest; i--) {
 		struct nvme_queue *nvmeq = raw_nvmeq(dev, i);
-		rcu_assign_pointer(dev->queues[i], NULL);
+		RCU_INIT_POINTER(dev->queues[i], NULL);
 		call_rcu(&nvmeq->r_head, nvme_free_queue);
 		dev->queue_count--;
 	}
-- 
1.9.1

