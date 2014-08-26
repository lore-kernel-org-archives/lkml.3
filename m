Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaHZOdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:33:33 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49249 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaHZOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:33:32 -0400
Date: Tue, 26 Aug 2014 17:33:22 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] qib: qib_qp: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140826143322.GA2498@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

This case fulfills the conditions above because between the
rcu_dereference_protected() call and the rcu_assign_pointer() call there is no
update of that value.
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (...,
(
 rtnl_dereference(...)
|
 rcu_dereference_protected(...)
) )

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/infiniband/hw/qib/qib_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 17daf42..cb0c680 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -269,7 +269,7 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 				lockdep_is_held(&dev->qpt_lock))) != NULL;
 				qpp = &q->next)
 			if (q == qp) {
-				rcu_assign_pointer(*qpp,
+				RCU_INIT_POINTER(*qpp,
 					rcu_dereference_protected(qp->next,
 					 lockdep_is_held(&dev->qpt_lock)));
 				removed = 1;
-- 
1.9.1

