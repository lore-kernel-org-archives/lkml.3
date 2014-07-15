Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbaGOV5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:57:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563AbaGOViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/198] Target/iser: Improve cm events handling
Date: Tue, 15 Jul 2014 14:28:31 -0700
Message-Id: <1405459868-15089-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 88c4015fda6d014392f76d3b1688347950d7a12d upstream.

There are 4 RDMA_CM events that all basically mean that
the user should teardown the IB connection:
- DISCONNECTED
- ADDR_CHANGE
- DEVICE_REMOVAL
- TIMEWAIT_EXIT

Only in DISCONNECTED/ADDR_CHANGE it makes sense to
call rdma_disconnect (send DREQ/DREP to our initiator).
So we keep the same teardown handler for all of them
but only indicate calling rdma_disconnect for the relevant
events.

This patch also removes redundant debug prints for each single
event.

v2 changes:
 - Call isert_disconnected_handler() for DEVICE_REMOVAL (Or + Sag)

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 26 ++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index cbd87ff..a281a7f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -685,8 +685,10 @@ isert_disconnect_work(struct work_struct *work)
 		return;
 	}
 
-	/* Send DREQ/DREP towards our initiator */
-	rdma_disconnect(isert_conn->conn_cm_id);
+	if (isert_conn->disconnect) {
+		/* Send DREQ/DREP towards our initiator */
+		rdma_disconnect(isert_conn->conn_cm_id);
+	}
 
 	mutex_unlock(&isert_conn->conn_mutex);
 
@@ -696,10 +698,11 @@ wake_up:
 }
 
 static void
-isert_disconnected_handler(struct rdma_cm_id *cma_id)
+isert_disconnected_handler(struct rdma_cm_id *cma_id, bool disconnect)
 {
 	struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
 
+	isert_conn->disconnect = disconnect;
 	INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
 	schedule_work(&isert_conn->conn_logout_work);
 }
@@ -708,29 +711,28 @@ static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	int ret = 0;
+	bool disconnect = false;
 
 	pr_debug("isert_cma_handler: event %d status %d conn %p id %p\n",
 		 event->event, event->status, cma_id->context, cma_id);
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
-		pr_debug("RDMA_CM_EVENT_CONNECT_REQUEST: >>>>>>>>>>>>>>>\n");
 		ret = isert_connect_request(cma_id, event);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		pr_debug("RDMA_CM_EVENT_ESTABLISHED >>>>>>>>>>>>>>\n");
 		isert_connected_handler(cma_id);
 		break;
-	case RDMA_CM_EVENT_DISCONNECTED:
-		pr_debug("RDMA_CM_EVENT_DISCONNECTED: >>>>>>>>>>>>>>\n");
-		isert_disconnected_handler(cma_id);
-		break;
-	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-	case RDMA_CM_EVENT_ADDR_CHANGE:
+	case RDMA_CM_EVENT_ADDR_CHANGE:    /* FALLTHRU */
+	case RDMA_CM_EVENT_DISCONNECTED:   /* FALLTHRU */
+	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
+		disconnect = true;
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
+		isert_disconnected_handler(cma_id, disconnect);
 		break;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	default:
-		pr_err("Unknown RDMA CMA event: %d\n", event->event);
+		pr_err("Unhandled RDMA CMA event: %d\n", event->event);
 		break;
 	}
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index abbc331..2b126e0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -127,6 +127,7 @@ struct isert_conn {
 #define ISERT_COMP_BATCH_COUNT	8
 	int			conn_comp_batch;
 	struct llist_head	conn_comp_llist;
+	bool                    disconnect;
 };
 
 #define ISERT_MAX_CQ 64
-- 
1.9.1

