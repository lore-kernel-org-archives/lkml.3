Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaHULcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:32:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:16496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbaHULbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969519"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 09/14] mei: revamp connect and disconnect response handling
Date: Thu, 21 Aug 2014 14:29:18 +0300
Message-Id: <1408620563-25834-9-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both responses have same flow only the client status
update is different. We introduce handler mei_hbm_cl_res()
that handles both responses
Also we use per client wait queue  (cl->wait) rather then
global dev->wait_recvd_msg

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c |   4 +-
 drivers/misc/mei/hbm.c    | 118 +++++++++++++++++++++++++---------------------
 2 files changed, 65 insertions(+), 57 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 3d4f311..4ec4e51 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -534,7 +534,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	}
 	mutex_unlock(&dev->device_lock);
 
-	wait_event_timeout(dev->wait_recvd_msg,
+	wait_event_timeout(cl->wait,
 			MEI_FILE_DISCONNECTED == cl->state,
 			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 
@@ -639,7 +639,7 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 	}
 
 	mutex_unlock(&dev->device_lock);
-	wait_event_timeout(dev->wait_recvd_msg,
+	wait_event_timeout(cl->wait,
 			(cl->state == MEI_FILE_CONNECTED ||
 			 cl->state == MEI_FILE_DISCONNECTED),
 			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index d50c8d1..cda9141 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -495,39 +495,24 @@ int mei_hbm_cl_disconnect_rsp(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_hbm_cl_disconnect_res - disconnect response from ME
+ * mei_hbm_cl_disconnect_res - update the client state according
+ *       disconnect response
  *
- * @dev: the device structure
- * @rs: disconnect response bus message
+ * @cl: mei host client
+ * @cmd: disconnect client response host bus message
  */
-static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
-		struct hbm_client_connect_response *rs)
+static void mei_hbm_cl_disconnect_res(struct mei_cl *cl,
+				      struct mei_hbm_cl_cmd *cmd)
 {
-	struct mei_cl *cl;
-	struct mei_cl_cb *cb, *next;
+	struct hbm_client_connect_response *rs =
+		(struct hbm_client_connect_response *)cmd;
 
-	dev_dbg(&dev->pdev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
+	dev_dbg(&cl->dev->pdev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
 			rs->me_addr, rs->host_addr, rs->status);
 
-	list_for_each_entry_safe(cb, next, &dev->ctrl_rd_list.list, list) {
-		cl = cb->cl;
-
-		/* this should not happen */
-		if (WARN_ON(!cl)) {
-			list_del(&cb->list);
-			return;
-		}
-
-		if (mei_hbm_cl_addr_equal(cl, rs)) {
-			list_del(&cb->list);
-			if (rs->status == MEI_CL_DISCONN_SUCCESS)
-				cl->state = MEI_FILE_DISCONNECTED;
-
-			cl->status = 0;
-			cl->timer_count = 0;
-			break;
-		}
-	}
+	if (rs->status == MEI_CL_DISCONN_SUCCESS)
+		cl->state = MEI_FILE_DISCONNECTED;
+	cl->status = 0;
 }
 
 /**
@@ -545,24 +530,45 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_hbm_cl_connect_res - connect response from the ME
+ * mei_hbm_cl_connect_res - update the client state according
+ *        connection response
  *
- * @dev: the device structure
- * @rs: connect response bus message
+ * @cl: mei host client
+ * @cmd: connect client response host bus message
  */
-static void mei_hbm_cl_connect_res(struct mei_device *dev,
-		struct hbm_client_connect_response *rs)
+static void mei_hbm_cl_connect_res(struct mei_cl *cl,
+				   struct mei_hbm_cl_cmd *cmd)
 {
+	struct hbm_client_connect_response *rs =
+		(struct hbm_client_connect_response *)cmd;
 
-	struct mei_cl *cl;
-	struct mei_cl_cb *cb, *next;
-
-	dev_dbg(&dev->pdev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
+	dev_dbg(&cl->dev->pdev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
 			rs->me_addr, rs->host_addr,
 			mei_cl_conn_status_str(rs->status));
 
-	cl = NULL;
+	if (rs->status == MEI_CL_CONN_SUCCESS)
+		cl->state = MEI_FILE_CONNECTED;
+	else
+		cl->state = MEI_FILE_DISCONNECTED;
+	cl->status = mei_cl_conn_status_to_errno(rs->status);
+}
+
+/**
+ * mei_hbm_cl_res - process hbm response received on behalf
+ *         an client
+ *
+ * @dev: the device structure
+ * @rs:  hbm client message
+ * @fop_type: file operation type
+ */
+static void mei_hbm_cl_res(struct mei_device *dev,
+			   struct mei_hbm_cl_cmd *rs,
+			   enum mei_cb_file_ops fop_type)
+{
+	struct mei_cl *cl;
+	struct mei_cl_cb *cb, *next;
 
+	cl = NULL;
 	list_for_each_entry_safe(cb, next, &dev->ctrl_rd_list.list, list) {
 
 		cl = cb->cl;
@@ -572,7 +578,7 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 			continue;
 		}
 
-		if (cb->fop_type !=  MEI_FOP_CONNECT)
+		if (cb->fop_type != fop_type)
 			continue;
 
 		if (mei_hbm_cl_addr_equal(cl, rs)) {
@@ -584,12 +590,19 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 	if (!cl)
 		return;
 
+	switch (fop_type) {
+	case MEI_FOP_CONNECT:
+		mei_hbm_cl_connect_res(cl, rs);
+		break;
+	case MEI_FOP_DISCONNECT:
+		mei_hbm_cl_disconnect_res(cl, rs);
+		break;
+	default:
+		return;
+	}
+
 	cl->timer_count = 0;
-	if (rs->status == MEI_CL_CONN_SUCCESS)
-		cl->state = MEI_FILE_CONNECTED;
-	else
-		cl->state = MEI_FILE_DISCONNECTED;
-	cl->status = mei_cl_conn_status_to_errno(rs->status);
+	wake_up(&cl->wait);
 }
 
 
@@ -657,17 +670,18 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 {
 	struct mei_bus_message *mei_msg;
 	struct hbm_host_version_response *version_res;
-	struct hbm_client_connect_response *connect_res;
-	struct hbm_client_connect_response *disconnect_res;
-	struct hbm_client_connect_request *disconnect_req;
-	struct hbm_flow_control *flow_control;
 	struct hbm_props_response *props_res;
 	struct hbm_host_enum_response *enum_res;
 
+	struct mei_hbm_cl_cmd *cl_cmd;
+	struct hbm_client_connect_request *disconnect_req;
+	struct hbm_flow_control *flow_control;
+
 	/* read the message to our buffer */
 	BUG_ON(hdr->length >= sizeof(dev->rd_msg_buf));
 	mei_read_slots(dev, dev->rd_msg_buf, hdr->length);
 	mei_msg = (struct mei_bus_message *)dev->rd_msg_buf;
+	cl_cmd  = (struct mei_hbm_cl_cmd *)mei_msg;
 
 	/* ignore spurious message and prevent reset nesting
 	 * hbm is put to idle during system reset
@@ -730,18 +744,12 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case CLIENT_CONNECT_RES_CMD:
 		dev_dbg(&dev->pdev->dev, "hbm: client connect response: message received.\n");
-
-		connect_res = (struct hbm_client_connect_response *) mei_msg;
-		mei_hbm_cl_connect_res(dev, connect_res);
-		wake_up(&dev->wait_recvd_msg);
+		mei_hbm_cl_res(dev, cl_cmd, MEI_FOP_CONNECT);
 		break;
 
 	case CLIENT_DISCONNECT_RES_CMD:
 		dev_dbg(&dev->pdev->dev, "hbm: client disconnect response: message received.\n");
-
-		disconnect_res = (struct hbm_client_connect_response *) mei_msg;
-		mei_hbm_cl_disconnect_res(dev, disconnect_res);
-		wake_up(&dev->wait_recvd_msg);
+		mei_hbm_cl_res(dev, cl_cmd, MEI_FOP_DISCONNECT);
 		break;
 
 	case MEI_FLOW_CONTROL_CMD:
-- 
1.9.3

