Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaHULbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:31:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:4850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHULbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969531"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 11/14] mei: simplify handling of hbm client events
Date: Thu, 21 Aug 2014 14:29:20 +0300
Message-Id: <1408620563-25834-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mei_hbm_cl_find_by_cmd handler to retrieve
the destination client

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 74 +++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 31 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 2968b52..280befc 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -157,22 +157,43 @@ int mei_hbm_cl_write(struct mei_device *dev,
 }
 
 /**
- * mei_hbm_cl_addr_equal - tells if they have the same address
+ * mei_hbm_cl_addr_equal - check if the client's and
+ *	the message address match
  *
- * @cl: - client
- * @buf: buffer with cl header
+ * @cl: client
+ * @cmd: hbm client message
  *
  * returns true if addresses are the same
  */
 static inline
-bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
+bool mei_hbm_cl_addr_equal(struct mei_cl *cl, struct mei_hbm_cl_cmd *cmd)
 {
-	struct mei_hbm_cl_cmd *cmd = buf;
 	return cl->host_client_id == cmd->host_addr &&
 		cl->me_client_id == cmd->me_addr;
 }
 
 /**
+ * mei_hbm_cl_find_by_cmd - find recipient client
+ *
+ * @dev: the device structure
+ * @buf: a buffer with hbm cl command
+ *
+ * returns the recipient client or NULL if not found
+ */
+static inline
+struct mei_cl *mei_hbm_cl_find_by_cmd(struct mei_device *dev, void *buf)
+{
+	struct mei_hbm_cl_cmd *cmd = (struct mei_hbm_cl_cmd *)buf;
+	struct mei_cl *cl;
+
+	list_for_each_entry(cl, &dev->file_list, link)
+		if (mei_hbm_cl_addr_equal(cl, cmd))
+			return cl;
+	return NULL;
+}
+
+
+/**
  * mei_hbm_start_wait - wait for start response message.
  *
  * @dev: the device structure
@@ -449,7 +470,7 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
  * @flow_control: flow control response bus message
  */
 static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
-		struct hbm_flow_control *flow_control)
+					struct hbm_flow_control *flow_control)
 {
 	struct mei_cl *cl;
 
@@ -459,15 +480,11 @@ static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
 		return;
 	}
 
-	/* normal connection */
-	list_for_each_entry(cl, &dev->file_list, link) {
-		if (mei_hbm_cl_addr_equal(cl, flow_control)) {
-			cl->mei_flow_ctrl_creds++;
-			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d creds %d.\n",
-				flow_control->host_addr, flow_control->me_addr,
+	cl = mei_hbm_cl_find_by_cmd(dev, flow_control);
+	if (cl) {
+		cl->mei_flow_ctrl_creds++;
+		cl_dbg(dev, cl, "flow control creds = %d.\n",
 				cl->mei_flow_ctrl_creds);
-			break;
-		}
 	}
 }
 
@@ -627,23 +644,18 @@ static int mei_hbm_fw_disconnect_req(struct mei_device *dev,
 	struct mei_cl *cl;
 	struct mei_cl_cb *cb;
 
-	list_for_each_entry(cl, &dev->file_list, link) {
-		if (mei_hbm_cl_addr_equal(cl, disconnect_req)) {
-			dev_dbg(&dev->pdev->dev, "disconnect request host client %d ME client %d.\n",
-					disconnect_req->host_addr,
-					disconnect_req->me_addr);
-			cl->state = MEI_FILE_DISCONNECTED;
-			cl->timer_count = 0;
-
-			cb = mei_io_cb_init(cl, NULL);
-			if (!cb)
-				return -ENOMEM;
-			cb->fop_type = MEI_FOP_DISCONNECT_RSP;
-			cl_dbg(dev, cl, "add disconnect response as first\n");
-			list_add(&cb->list, &dev->ctrl_wr_list.list);
-
-			break;
-		}
+	cl = mei_hbm_cl_find_by_cmd(dev, disconnect_req);
+	if (cl) {
+		cl_dbg(dev, cl, "disconnect request received\n");
+		cl->state = MEI_FILE_DISCONNECTED;
+		cl->timer_count = 0;
+
+		cb = mei_io_cb_init(cl, NULL);
+		if (!cb)
+			return -ENOMEM;
+		cb->fop_type = MEI_FOP_DISCONNECT_RSP;
+		cl_dbg(dev, cl, "add disconnect response as first\n");
+		list_add(&cb->list, &dev->ctrl_wr_list.list);
 	}
 	return 0;
 }
-- 
1.9.3

