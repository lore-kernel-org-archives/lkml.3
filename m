Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaBQNO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:14:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:4049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaBQNOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852900"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/11] mei: hbm: revamp client connect and disconnection status
Date: Mon, 17 Feb 2014 15:13:20 +0200
Message-Id: <1392642807-8878-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

1. Return -ENOTTY on client connect if the requested client was not found
 on the enumeration list or the client was internally disabled, in the later
 case FW will return NOT_FOUND.
2. Return -EBUSY if the client cannot be connected because of resource
 contention
3. Change response status enum to have MEI_CL_ prefix
4. Add function to translate response status to a string
for more readable logging

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 13 ++++-----
 drivers/misc/mei/hbm.c    | 67 ++++++++++++++++++++++++++++++-----------------
 drivers/misc/mei/hw.h     | 16 +++++------
 drivers/misc/mei/main.c   |  2 +-
 4 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index f505764..6639bc3 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -536,18 +536,19 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 	}
 
 	mutex_unlock(&dev->device_lock);
-	rets = wait_event_timeout(dev->wait_recvd_msg,
-				 (cl->state == MEI_FILE_CONNECTED ||
-				  cl->state == MEI_FILE_DISCONNECTED),
-				 mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
+	wait_event_timeout(dev->wait_recvd_msg,
+			(cl->state == MEI_FILE_CONNECTED ||
+			 cl->state == MEI_FILE_DISCONNECTED),
+			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
 	if (cl->state != MEI_FILE_CONNECTED) {
-		rets = -EFAULT;
+		/* something went really wrong */
+		if (!cl->status)
+			cl->status = -EFAULT;
 
 		mei_io_list_flush(&dev->ctrl_rd_list, cl);
 		mei_io_list_flush(&dev->ctrl_wr_list, cl);
-		goto out;
 	}
 
 	rets = cl->status;
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index d3fcb23..d360e9a 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -23,6 +23,40 @@
 #include "hbm.h"
 #include "hw-me.h"
 
+static const char *mei_cl_conn_status_str(enum mei_cl_connect_status status)
+{
+#define MEI_CL_CS(status) case MEI_CL_CONN_##status: return #status
+	switch (status) {
+	MEI_CL_CS(SUCCESS);
+	MEI_CL_CS(NOT_FOUND);
+	MEI_CL_CS(ALREADY_STARTED);
+	MEI_CL_CS(OUT_OF_RESOURCES);
+	MEI_CL_CS(MESSAGE_SMALL);
+	default: return "unknown";
+	}
+#undef MEI_CL_CCS
+}
+
+/**
+ * mei_cl_conn_status_to_errno - convert client connect response
+ * status to error code
+ *
+ * @status: client connect response status
+ *
+ * returns corresponding error code
+ */
+static int mei_cl_conn_status_to_errno(enum mei_cl_connect_status status)
+{
+	switch (status) {
+	case MEI_CL_CONN_SUCCESS:          return 0;
+	case MEI_CL_CONN_NOT_FOUND:        return -ENOTTY;
+	case MEI_CL_CONN_ALREADY_STARTED:  return -EBUSY;
+	case MEI_CL_CONN_OUT_OF_RESOURCES: return -EBUSY;
+	case MEI_CL_CONN_MESSAGE_SMALL:    return -EINVAL;
+	default:                           return -EINVAL;
+	}
+}
+
 /**
  * mei_hbm_me_cl_allocate - allocates storage for me clients
  *
@@ -111,14 +145,11 @@ static bool is_treat_specially_client(struct mei_cl *cl,
 		struct hbm_client_connect_response *rs)
 {
 	if (mei_hbm_cl_addr_equal(cl, rs)) {
-		if (!rs->status) {
+		if (rs->status == MEI_CL_CONN_SUCCESS)
 			cl->state = MEI_FILE_CONNECTED;
-			cl->status = 0;
-
-		} else {
+		else
 			cl->state = MEI_FILE_DISCONNECTED;
-			cl->status = -ENODEV;
-		}
+		cl->status = mei_cl_conn_status_to_errno(rs->status);
 		cl->timer_count = 0;
 
 		return true;
@@ -438,14 +469,8 @@ static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
 	struct mei_cl *cl;
 	struct mei_cl_cb *pos = NULL, *next = NULL;
 
-	dev_dbg(&dev->pdev->dev,
-			"disconnect_response:\n"
-			"ME Client = %d\n"
-			"Host Client = %d\n"
-			"Status = %d\n",
-			rs->me_addr,
-			rs->host_addr,
-			rs->status);
+	dev_dbg(&dev->pdev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
+			rs->me_addr, rs->host_addr, rs->status);
 
 	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
 		cl = pos->cl;
@@ -458,7 +483,7 @@ static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
 		dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in ctrl_rd_list.\n");
 		if (mei_hbm_cl_addr_equal(cl, rs)) {
 			list_del(&pos->list);
-			if (!rs->status)
+			if (rs->status == MEI_CL_DISCONN_SUCCESS)
 				cl->state = MEI_FILE_DISCONNECTED;
 
 			cl->status = 0;
@@ -500,14 +525,9 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 	struct mei_cl *cl;
 	struct mei_cl_cb *pos = NULL, *next = NULL;
 
-	dev_dbg(&dev->pdev->dev,
-			"connect_response:\n"
-			"ME Client = %d\n"
-			"Host Client = %d\n"
-			"Status = %d\n",
-			rs->me_addr,
-			rs->host_addr,
-			rs->status);
+	dev_dbg(&dev->pdev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
+			rs->me_addr, rs->host_addr,
+			mei_cl_conn_status_str(rs->status));
 
 	/* if WD or iamthif client treat specially */
 
@@ -532,7 +552,6 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 		if (pos->fop_type == MEI_FOP_CONNECT) {
 			if (is_treat_specially_client(cl, rs)) {
 				list_del(&pos->list);
-				cl->status = 0;
 				cl->timer_count = 0;
 				break;
 			}
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index e06779d..6b476ab 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -89,19 +89,19 @@ enum mei_stop_reason_types {
  * Client Connect Status
  * used by hbm_client_connect_response.status
  */
-enum client_connect_status_types {
-	CCS_SUCCESS = 0x00,
-	CCS_NOT_FOUND = 0x01,
-	CCS_ALREADY_STARTED = 0x02,
-	CCS_OUT_OF_RESOURCES = 0x03,
-	CCS_MESSAGE_SMALL = 0x04
+enum mei_cl_connect_status {
+	MEI_CL_CONN_SUCCESS          = 0x00,
+	MEI_CL_CONN_NOT_FOUND        = 0x01,
+	MEI_CL_CONN_ALREADY_STARTED  = 0x02,
+	MEI_CL_CONN_OUT_OF_RESOURCES = 0x03,
+	MEI_CL_CONN_MESSAGE_SMALL    = 0x04
 };
 
 /*
  * Client Disconnect Status
  */
-enum client_disconnect_status_types {
-	CDS_SUCCESS = 0x00
+enum  mei_cl_disconnect_status {
+	MEI_CL_DISCONN_SUCCESS = 0x00
 };
 
 /*
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5424f8f..434242b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -471,7 +471,7 @@ static int mei_ioctl_connect_client(struct file *file,
 	if (i < 0 || dev->me_clients[i].props.fixed_address) {
 		dev_dbg(&dev->pdev->dev, "Cannot connect to FW Client UUID = %pUl\n",
 				&data->in_client_uuid);
-		rets = -ENODEV;
+		rets = -ENOTTY;
 		goto end;
 	}
 
-- 
1.8.5.3

