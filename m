Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaGCJVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbaGCJVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/198] Target/iser: Improve cm events handling
Date: Thu,  3 Jul 2014 10:17:55 +0100
Message-Id: <1404379241-8590-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 26 ++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 434113247c62..cfb8824d6a9e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -573,8 +573,10 @@ isert_disconnect_work(struct work_struct *work)
 		return;
 	}
 
-	/* Send DREQ/DREP towards our initiator */
-	rdma_disconnect(isert_conn->conn_cm_id);
+	if (isert_conn->disconnect) {
+		/* Send DREQ/DREP towards our initiator */
+		rdma_disconnect(isert_conn->conn_cm_id);
+	}
 
 	mutex_unlock(&isert_conn->conn_mutex);
 
@@ -584,10 +586,11 @@ wake_up:
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
@@ -596,29 +599,28 @@ static int
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
index 62a7a1de4365..174c4fffd8c4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -105,6 +105,7 @@ struct isert_conn {
 	struct completion	conn_wait;
 	struct completion	conn_wait_comp_err;
 	struct kref		conn_kref;
+	bool                    disconnect;
 };
 
 #define ISERT_MAX_CQ 64
-- 
1.9.1

