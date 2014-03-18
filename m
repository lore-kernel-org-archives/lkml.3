Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaCRUxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:53:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbaCRUxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172310"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 01/13] mei: implement power gating isolation hbm layer
Date: Tue, 18 Mar 2014 22:51:55 +0200
Message-Id: <1395175927-10562-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add send message functions and receive dispatch stubs
for power gating isolation hbm protocol.

The protocol consist of requests for entering and exiting
the power gating isolation state and their responses.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hbm.c     | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hbm.h     |  1 +
 drivers/misc/mei/hw.h      | 16 ++++++++++++++++
 drivers/misc/mei/init.c    |  1 +
 drivers/misc/mei/mei_dev.h |  1 +
 5 files changed, 60 insertions(+)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 4960288..a16b47c 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/export.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -289,6 +290,34 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	return 0;
 }
 
+/*
+ * mei_hbm_pg - sends pg command
+ *
+ * @dev: the device structure
+ * @pg_cmd: the pg command code
+ *
+ * This function returns -EIO on write failure
+ */
+int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd)
+{
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
+	struct hbm_power_gate *req;
+	const size_t len = sizeof(struct hbm_power_gate);
+	int ret;
+
+	mei_hbm_hdr(mei_hdr, len);
+
+	req = (struct hbm_power_gate *)dev->wr_msg.data;
+	memset(req, 0, len);
+	req->hbm_cmd = pg_cmd;
+
+	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
+	if (ret)
+		dev_err(&dev->pdev->dev, "power gate command write failed.\n");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mei_hbm_pg);
+
 /**
  * mei_hbm_stop_req - send stop request message
  *
@@ -701,6 +730,18 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		mei_hbm_cl_flow_control_res(dev, flow_control);
 		break;
 
+	case MEI_PG_ISOLATION_ENTRY_RES_CMD:
+		dev_dbg(&dev->pdev->dev, "power gate isolation entry response received\n");
+		if (waitqueue_active(&dev->wait_pg))
+			wake_up(&dev->wait_pg);
+		break;
+
+	case MEI_PG_ISOLATION_EXIT_REQ_CMD:
+		dev_dbg(&dev->pdev->dev, "power gate isolation exit request received\n");
+		if (waitqueue_active(&dev->wait_pg))
+			wake_up(&dev->wait_pg);
+		break;
+
 	case HOST_CLIENT_PROPERTIES_RES_CMD:
 		dev_dbg(&dev->pdev->dev, "hbm: properties response: message received.\n");
 
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index 20e8782..8e39cee 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -57,6 +57,7 @@ int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_disconnect_rsp(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
 bool mei_hbm_version_is_supported(struct mei_device *dev);
+int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd);
 
 #endif /* _MEI_HBM_H_ */
 
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 6b476ab..1d70968 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -69,6 +69,11 @@
 
 #define MEI_FLOW_CONTROL_CMD                0x08
 
+#define MEI_PG_ISOLATION_ENTRY_REQ_CMD      0x0a
+#define MEI_PG_ISOLATION_ENTRY_RES_CMD      0x8a
+#define MEI_PG_ISOLATION_EXIT_REQ_CMD       0x0b
+#define MEI_PG_ISOLATION_EXIT_RES_CMD       0x8b
+
 /*
  * MEI Stop Reason
  * used by hbm_host_stop_request.reason
@@ -208,6 +213,17 @@ struct hbm_props_response {
 } __packed;
 
 /**
+ * struct hbm_power_gate - power gate request/response
+ *
+ * @hbm_cmd - bus message command header
+ * @reserved[3]
+ */
+struct hbm_power_gate {
+	u8 hbm_cmd;
+	u8 reserved[3];
+} __packed;
+
+/**
  * struct hbm_client_connect_request - connect/disconnect request
  *
  * @hbm_cmd - bus message command header
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4460975..cc604e1 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -312,6 +312,7 @@ void mei_device_init(struct mei_device *dev)
 	INIT_LIST_HEAD(&dev->device_list);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_hw_ready);
+	init_waitqueue_head(&dev->wait_pg);
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 94a5167..4d4c041 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -371,6 +371,7 @@ struct mei_device {
 	 * waiting queue for receive message from FW
 	 */
 	wait_queue_head_t wait_hw_ready;
+	wait_queue_head_t wait_pg;
 	wait_queue_head_t wait_recvd_msg;
 	wait_queue_head_t wait_stop_wd;
 
-- 
1.8.5.3

