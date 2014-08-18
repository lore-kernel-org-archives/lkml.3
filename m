Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaHRMct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:32:49 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41346 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaHRMcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:32:48 -0400
Date: Mon, 18 Aug 2014 15:32:34 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] qib_keys: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140818123214.GA8174@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
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
 drivers/infiniband/hw/qib/qib_keys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 3b9afcc..ad843c7 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -122,10 +122,10 @@ void qib_free_lkey(struct qib_mregion *mr)
 	if (!mr->lkey_published)
 		goto out;
 	if (lkey == 0)
-		rcu_assign_pointer(dev->dma_mr, NULL);
+		RCU_INIT_POINTER(dev->dma_mr, NULL);
 	else {
 		r = lkey >> (32 - ib_qib_lkey_table_size);
-		rcu_assign_pointer(rkt->table[r], NULL);
+		RCU_INIT_POINTER(rkt->table[r], NULL);
 	}
 	qib_put_mr(mr);
 	mr->lkey_published = 0;
-- 
1.9.1

