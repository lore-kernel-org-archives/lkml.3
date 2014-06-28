Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaF1S6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaF1Rsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 75/77] Target/iser: Improve cm events handling
Date: Sat, 28 Jun 2014 10:47:08 -0700
Message-Id: <20140628174525.557420107@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   26 ++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h |    1 +
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -573,8 +573,10 @@ isert_disconnect_work(struct work_struct
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
 
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -105,6 +105,7 @@ struct isert_conn {
 	struct completion	conn_wait;
 	struct completion	conn_wait_comp_err;
 	struct kref		conn_kref;
+	bool			disconnect;
 };
 
 #define ISERT_MAX_CQ 64


