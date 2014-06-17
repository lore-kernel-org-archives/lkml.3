Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967461AbaFQWKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:10:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966882AbaFQVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 130/212] Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
Date: Tue, 17 Jun 2014 14:43:44 -0700
Message-Id: <1403041506-13646-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 531b7bf4bd795d9a09eac92504322a472c010bc8 upstream.

RDMA CM and iSCSI target flows are asynchronous and completely
uncorrelated. Relying on the fact that iscsi_accept_np will be called
after CM connection request event and will wait for it is a mistake.

When attempting to login to a few targets this flow is racy and
unpredictable, but for parallel login to dozens of targets will
race and hang every time.

The correct synchronizing mechanism in this case is pending on
a semaphore rather than a wait_for_event. We keep the pending
interruptible for iscsi_np cleanup stage.

(Squash patch to remove dead code into parent - nab)

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 25 ++++++-------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d2dec1f..0169850 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -28,6 +28,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
+#include <linux/semaphore.h>
 
 #include "isert_proto.h"
 #include "ib_isert.h"
@@ -576,8 +577,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
-	pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);
-	wake_up(&isert_np->np_accept_wq);
+	pr_debug("isert_connect_request() up np_sem np: %p\n", np);
+	up(&isert_np->np_sem);
 	return 0;
 
 out_conn_dev:
@@ -2553,7 +2554,7 @@ isert_setup_np(struct iscsi_np *np,
 		pr_err("Unable to allocate struct isert_np\n");
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&isert_np->np_accept_wq);
+	sema_init(&isert_np->np_sem, 0);
 	mutex_init(&isert_np->np_accept_mutex);
 	INIT_LIST_HEAD(&isert_np->np_accept_list);
 	init_completion(&isert_np->np_login_comp);
@@ -2602,18 +2603,6 @@ out:
 }
 
 static int
-isert_check_accept_queue(struct isert_np *isert_np)
-{
-	int empty;
-
-	mutex_lock(&isert_np->np_accept_mutex);
-	empty = list_empty(&isert_np->np_accept_list);
-	mutex_unlock(&isert_np->np_accept_mutex);
-
-	return empty;
-}
-
-static int
 isert_rdma_accept(struct isert_conn *isert_conn)
 {
 	struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
@@ -2705,16 +2694,14 @@ isert_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
 	int max_accept = 0, ret;
 
 accept_wait:
-	ret = wait_event_interruptible(isert_np->np_accept_wq,
-			!isert_check_accept_queue(isert_np) ||
-			np->np_thread_state == ISCSI_NP_THREAD_RESET);
+	ret = down_interruptible(&isert_np->np_sem);
 	if (max_accept > 5)
 		return -ENODEV;
 
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		spin_unlock_bh(&np->np_thread_lock);
-		pr_err("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
+		pr_debug("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
 		return -ENODEV;
 	}
 	spin_unlock_bh(&np->np_thread_lock);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 466dd5e..68d9f35 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -160,7 +160,7 @@ struct isert_device {
 };
 
 struct isert_np {
-	wait_queue_head_t	np_accept_wq;
+	struct semaphore	np_sem;
 	struct rdma_cm_id	*np_cm_id;
 	struct mutex		np_accept_mutex;
 	struct list_head	np_accept_list;
-- 
1.9.1

