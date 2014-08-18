Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaHRMm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:42:59 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43188 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHRMm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:42:57 -0400
Date: Mon, 18 Aug 2014 15:42:47 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] qib_qp: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818124246.GA18423@ada>
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
 drivers/infiniband/hw/qib/qib_qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 7fcc150..17daf42 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -255,10 +255,10 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 
 	if (rcu_dereference_protected(ibp->qp0,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		rcu_assign_pointer(ibp->qp0, NULL);
+		RCU_INIT_POINTER(ibp->qp0, NULL);
 	} else if (rcu_dereference_protected(ibp->qp1,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		rcu_assign_pointer(ibp->qp1, NULL);
+		RCU_INIT_POINTER(ibp->qp1, NULL);
 	} else {
 		struct qib_qp *q;
 		struct qib_qp __rcu **qpp;
@@ -315,7 +315,7 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 	for (n = 0; n < dev->qp_table_size; n++) {
 		qp = rcu_dereference_protected(dev->qp_table[n],
 			lockdep_is_held(&dev->qpt_lock));
-		rcu_assign_pointer(dev->qp_table[n], NULL);
+		RCU_INIT_POINTER(dev->qp_table[n], NULL);
 
 		for (; qp; qp = rcu_dereference_protected(qp->next,
 					lockdep_is_held(&dev->qpt_lock)))
-- 
1.9.1

