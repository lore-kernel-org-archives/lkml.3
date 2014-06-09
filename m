Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561AbaFIJcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:32:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936287AbaFIJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/146] Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
Date: Mon,  9 Jun 2014 10:50:51 +0200
Message-Id: <9ac1060a228d2f0be0a65c4e6e20165390ed7e2b.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 25 ++++++-------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d62b61cc6175..e6737607a088 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -27,6 +27,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
+#include <linux/semaphore.h>
 
 #include "isert_proto.h"
 #include "ib_isert.h"
@@ -575,8 +576,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
-	pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);
-	wake_up(&isert_np->np_accept_wq);
+	pr_debug("isert_connect_request() up np_sem np: %p\n", np);
+	up(&isert_np->np_sem);
 	return 0;
 
 out_conn_dev:
@@ -2477,7 +2478,7 @@ isert_setup_np(struct iscsi_np *np,
 		pr_err("Unable to allocate struct isert_np\n");
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&isert_np->np_accept_wq);
+	sema_init(&isert_np->np_sem, 0);
 	mutex_init(&isert_np->np_accept_mutex);
 	INIT_LIST_HEAD(&isert_np->np_accept_list);
 	init_completion(&isert_np->np_login_comp);
@@ -2526,18 +2527,6 @@ out:
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
@@ -2629,16 +2618,14 @@ isert_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
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
index 52f4bf0d1a0f..ba695c33a2df 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -154,7 +154,7 @@ struct isert_device {
 };
 
 struct isert_np {
-	wait_queue_head_t	np_accept_wq;
+	struct semaphore	np_sem;
 	struct rdma_cm_id	*np_cm_id;
 	struct mutex		np_accept_mutex;
 	struct list_head	np_accept_list;
-- 
1.9.3

