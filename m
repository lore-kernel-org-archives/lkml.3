Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbbALStU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:49:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbbALSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 169/216] iser-target: Handle ADDR_CHANGE event for listener cm_id
Date: Mon, 12 Jan 2015 18:29:07 +0000
Message-Id: <1421087394-2712-57-git-send-email-luis.henriques@canonical.com>
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

commit ca6c1d82d12d8013fb75ce015900d62b9754623c upstream.

The np listener cm_id will also get ADDR_CHANGE event
upcall (in case it is bound to a specific IP). Handle
it correctly by creating a new cm_id and implicitly
destroy the old one.

Since this is the second event a listener np cm_id may
encounter, we move the np cm_id event handling to a
routine.

Squashed:

iser-target: Move cma_id setup to a function

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 107 +++++++++++++++++++++++---------
 drivers/infiniband/ulp/isert/ib_isert.h |   1 +
 2 files changed, 77 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 22d877f96f47..6705d0266862 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -58,6 +58,7 @@ static int
 isert_rdma_post_recvl(struct isert_conn *isert_conn);
 static int
 isert_rdma_accept(struct isert_conn *isert_conn);
+struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -573,8 +574,8 @@ err:
 static int
 isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
-	struct iscsi_np *np = cma_id->context;
-	struct isert_np *isert_np = np->np_context;
+	struct isert_np *isert_np = cma_id->context;
+	struct iscsi_np *np = isert_np->np;
 	struct isert_conn *isert_conn;
 	struct isert_device *device;
 	struct ib_device *ib_dev = cma_id->device;
@@ -849,17 +850,41 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 }
 
 static int
-isert_disconnected_handler(struct rdma_cm_id *cma_id)
+isert_np_cma_handler(struct isert_np *isert_np,
+		     enum rdma_cm_event_type event)
 {
-	struct iscsi_np *np = cma_id->context;
-	struct isert_np *isert_np = np->np_context;
-	struct isert_conn *isert_conn;
+	pr_debug("isert np %p, handling event %d\n", isert_np, event);
 
-	if (isert_np->np_cm_id == cma_id) {
+	switch (event) {
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		isert_np->np_cm_id = NULL;
-		return -1;
+		break;
+	case RDMA_CM_EVENT_ADDR_CHANGE:
+		isert_np->np_cm_id = isert_setup_id(isert_np);
+		if (IS_ERR(isert_np->np_cm_id)) {
+			pr_err("isert np %p setup id failed: %ld\n",
+				 isert_np, PTR_ERR(isert_np->np_cm_id));
+			isert_np->np_cm_id = NULL;
+		}
+		break;
+	default:
+		pr_err("isert np %p Unexpected event %d\n",
+			  isert_np, event);
 	}
 
+	return -1;
+}
+
+static int
+isert_disconnected_handler(struct rdma_cm_id *cma_id,
+			   enum rdma_cm_event_type event)
+{
+	struct isert_np *isert_np = cma_id->context;
+	struct isert_conn *isert_conn;
+
+	if (isert_np->np_cm_id == cma_id)
+		return isert_np_cma_handler(cma_id->context, event);
+
 	isert_conn = cma_id->qp->qp_context;
 
 	mutex_lock(&isert_conn->conn_mutex);
@@ -902,7 +927,7 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DISCONNECTED:   /* FALLTHRU */
 	case RDMA_CM_EVENT_DEVICE_REMOVAL: /* FALLTHRU */
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:  /* FALLTHRU */
-		ret = isert_disconnected_handler(cma_id);
+		ret = isert_disconnected_handler(cma_id, event->event);
 		break;
 	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
 	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
@@ -3076,13 +3101,51 @@ isert_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 	return ret;
 }
 
+struct rdma_cm_id *
+isert_setup_id(struct isert_np *isert_np)
+{
+	struct iscsi_np *np = isert_np->np;
+	struct rdma_cm_id *id;
+	struct sockaddr *sa;
+	int ret;
+
+	sa = (struct sockaddr *)&np->np_sockaddr;
+	pr_debug("ksockaddr: %p, sa: %p\n", &np->np_sockaddr, sa);
+
+	id = rdma_create_id(isert_cma_handler, isert_np,
+			    RDMA_PS_TCP, IB_QPT_RC);
+	if (IS_ERR(id)) {
+		pr_err("rdma_create_id() failed: %ld\n", PTR_ERR(id));
+		ret = PTR_ERR(id);
+		goto out;
+	}
+	pr_debug("id %p context %p\n", id, id->context);
+
+	ret = rdma_bind_addr(id, sa);
+	if (ret) {
+		pr_err("rdma_bind_addr() failed: %d\n", ret);
+		goto out_id;
+	}
+
+	ret = rdma_listen(id, ISERT_RDMA_LISTEN_BACKLOG);
+	if (ret) {
+		pr_err("rdma_listen() failed: %d\n", ret);
+		goto out_id;
+	}
+
+	return id;
+out_id:
+	rdma_destroy_id(id);
+out:
+	return ERR_PTR(ret);
+}
+
 static int
 isert_setup_np(struct iscsi_np *np,
 	       struct __kernel_sockaddr_storage *ksockaddr)
 {
 	struct isert_np *isert_np;
 	struct rdma_cm_id *isert_lid;
-	struct sockaddr *sa;
 	int ret;
 
 	isert_np = kzalloc(sizeof(struct isert_np), GFP_KERNEL);
@@ -3094,9 +3157,8 @@ isert_setup_np(struct iscsi_np *np,
 	mutex_init(&isert_np->np_accept_mutex);
 	INIT_LIST_HEAD(&isert_np->np_accept_list);
 	init_completion(&isert_np->np_login_comp);
+	isert_np->np = np;
 
-	sa = (struct sockaddr *)ksockaddr;
-	pr_debug("ksockaddr: %p, sa: %p\n", ksockaddr, sa);
 	/*
 	 * Setup the np->np_sockaddr from the passed sockaddr setup
 	 * in iscsi_target_configfs.c code..
@@ -3104,37 +3166,20 @@ isert_setup_np(struct iscsi_np *np,
 	memcpy(&np->np_sockaddr, ksockaddr,
 	       sizeof(struct __kernel_sockaddr_storage));
 
-	isert_lid = rdma_create_id(isert_cma_handler, np, RDMA_PS_TCP,
-				IB_QPT_RC);
+	isert_lid = isert_setup_id(isert_np);
 	if (IS_ERR(isert_lid)) {
-		pr_err("rdma_create_id() for isert_listen_handler failed: %ld\n",
-		       PTR_ERR(isert_lid));
 		ret = PTR_ERR(isert_lid);
 		goto out;
 	}
 
-	ret = rdma_bind_addr(isert_lid, sa);
-	if (ret) {
-		pr_err("rdma_bind_addr() for isert_lid failed: %d\n", ret);
-		goto out_lid;
-	}
-
-	ret = rdma_listen(isert_lid, ISERT_RDMA_LISTEN_BACKLOG);
-	if (ret) {
-		pr_err("rdma_listen() for isert_lid failed: %d\n", ret);
-		goto out_lid;
-	}
-
 	isert_np->np_cm_id = isert_lid;
 	np->np_context = isert_np;
-	pr_debug("Setup isert_lid->context: %p\n", isert_lid->context);
 
 	return 0;
 
-out_lid:
-	rdma_destroy_id(isert_lid);
 out:
 	kfree(isert_np);
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 97cb270d402a..5cad43d3de44 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -183,6 +183,7 @@ struct isert_device {
 };
 
 struct isert_np {
+	struct iscsi_np         *np;
 	struct semaphore	np_sem;
 	struct rdma_cm_id	*np_cm_id;
 	struct mutex		np_accept_mutex;
-- 
2.1.4

