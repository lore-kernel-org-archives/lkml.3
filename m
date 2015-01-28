Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbbA2KcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:32:01 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755879AbbA2JA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 136/176] iser-target: Fix implicit termination of connections
Date: Wed, 28 Jan 2015 15:29:26 +0100
Message-Id: <7136cfa5542dc91eb16ff32c7055c4035c5cd1f1.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 42 ++++++++++++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 65dca0051d51..60a3ed9f0624 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -40,6 +40,7 @@ static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static struct workqueue_struct *isert_rx_wq;
 static struct workqueue_struct *isert_comp_wq;
+static struct workqueue_struct *isert_release_wq;
 
 static void
 isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
@@ -2812,6 +2813,24 @@ isert_free_np(struct iscsi_np *np)
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
@@ -2831,14 +2850,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
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
@@ -2884,10 +2898,21 @@ static int __init isert_init(void)
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
@@ -2896,6 +2921,7 @@ destroy_rx_wq:
 static void __exit isert_exit(void)
 {
 	flush_scheduled_work();
+	destroy_workqueue(isert_release_wq);
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
 	iscsit_unregister_transport(&iser_target_transport);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index d29970536828..1ea527974beb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -123,6 +123,7 @@ struct isert_conn {
 	int			conn_frwr_pool_size;
 	/* lock to protect frwr_pool */
 	spinlock_t		conn_lock;
+	struct work_struct	release_work;
 };
 
 #define ISERT_MAX_CQ 64
-- 
2.2.2

