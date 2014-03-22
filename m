Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaCVUjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:39:02 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53495 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaCVUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:39:00 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in hw/qib/qib_qp.c
Date: Sun, 23 Mar 2014 02:08:00 +0530
Message-Id: <1395520680-3459-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/infiniband/hw/qib/qib_qp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 0cad0c4..04c8b74 100644
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
1.7.9.5

