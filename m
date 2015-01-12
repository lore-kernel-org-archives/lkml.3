Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbbALStS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:49:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbbALSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 170/216] iser-target: Fix implicit termination of connections
Date: Mon, 12 Jan 2015 18:29:08 +0000
Message-Id: <1421087394-2712-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit b02efbfc9a051b41e71fe8f94ddf967260e024a6 upstream.

In situations such as bond failover, The new session establishment
implicitly invokes the termination of the old connection.

So, we don't want to wait for the old connection wait_conn to completely
terminate before we accept the new connection and post a login response.

The solution is to deffer the comp_wait completion and the conn_put to
a work so wait_conn will effectively be non-blocking (flush errors are
assumed to come very fast).

We allocate isert_release_wq with WQ_UNBOUND and WQ_UNBOUND_MAX_ACTIVE
to spread the concurrency of release works.

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 42 ++++++++++++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6705d0266862..8244ff44010c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -41,6 +41,7 @@ static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static struct workqueue_struct *isert_rx_wq;
 static struct workqueue_struct *isert_comp_wq;
+static struct workqueue_struct *isert_release_wq;
 
 static void
 isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
@@ -3338,6 +3339,24 @@ isert_free_np(struct iscsi_np *np)
 	kfree(isert_np);
 }
 
+static void isert_release_work(struct work_struct *work)
+{
+	struct isert_conn *isert_conn = container_of(work,
+						     struct isert_conn,
+						     release_work);
+
+	pr_info("Starting release conn %p\n", isert_conn);
+
+	wait_for_completion(&isert_conn->conn_wait);
+
+	mutex_lock(&isert_conn->conn_mutex);
+	isert_conn->state = ISER_CONN_DOWN;
+	mutex_unlock(&isert_conn->conn_mutex);
+
+	pr_info("Destroying conn %p\n", isert_conn);
+	isert_put_conn(isert_conn);
+}
+
 static void isert_wait_conn(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = conn->context;
@@ -3357,14 +3376,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	mutex_unlock(&isert_conn->conn_mutex);
 
 	wait_for_completion(&isert_conn->conn_wait_comp_err);
-	wait_for_completion(&isert_conn->conn_wait);
-
-	mutex_lock(&isert_conn->conn_mutex);
-	isert_conn->state = ISER_CONN_DOWN;
-	mutex_unlock(&isert_conn->conn_mutex);
 
-	pr_info("Destroying conn %p\n", isert_conn);
-	isert_put_conn(isert_conn);
+	INIT_WORK(&isert_conn->release_work, isert_release_work);
+	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
 static void isert_free_conn(struct iscsi_conn *conn)
@@ -3412,10 +3426,21 @@ static int __init isert_init(void)
 		goto destroy_rx_wq;
 	}
 
+	isert_release_wq = alloc_workqueue("isert_release_wq", WQ_UNBOUND,
+					WQ_UNBOUND_MAX_ACTIVE);
+	if (!isert_release_wq) {
+		pr_err("Unable to allocate isert_release_wq\n");
+		ret = -ENOMEM;
+		goto destroy_comp_wq;
+	}
+
 	iscsit_register_transport(&iser_target_transport);
-	pr_debug("iSER_TARGET[0] - Loaded iser_target_transport\n");
+	pr_info("iSER_TARGET[0] - Loaded iser_target_transport\n");
+
 	return 0;
 
+destroy_comp_wq:
+	destroy_workqueue(isert_comp_wq);
 destroy_rx_wq:
 	destroy_workqueue(isert_rx_wq);
 	return ret;
@@ -3424,6 +3449,7 @@ destroy_rx_wq:
 static void __exit isert_exit(void)
 {
 	flush_scheduled_work();
+	destroy_workqueue(isert_release_wq);
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
 	iscsit_unregister_transport(&iser_target_transport);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 5cad43d3de44..9372d4d4d14a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -149,6 +149,7 @@ struct isert_conn {
 	int			conn_fr_pool_size;
 	/* lock to protect fastreg pool */
 	spinlock_t		conn_lock;
+	struct work_struct	release_work;
 #define ISERT_COMP_BATCH_COUNT	8
 	int			conn_comp_batch;
 	struct llist_head	conn_comp_llist;
-- 
2.1.4

