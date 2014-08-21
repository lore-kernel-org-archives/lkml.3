Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaHULiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:38:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:4826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbaHULa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969466"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/14] mei: use wrapper for simple hbm client message
Date: Thu, 21 Aug 2014 14:29:11 +0300
Message-Id: <1408620563-25834-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce few code lines by using wrappers for sending
simple hbm client messages

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 51 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 68a1cba..2b4ea16 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -124,7 +124,7 @@ static int mei_hbm_me_cl_allocate(struct mei_device *dev)
 /**
  * mei_hbm_cl_hdr - construct client hbm header
  *
- * @cl: - client
+ * @cl: client
  * @hbm_cmd: host bus message command
  * @buf: buffer for cl header
  * @len: buffer length
@@ -142,6 +142,26 @@ void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
 }
 
 /**
+ * mei_hbm_cl_write - write simple hbm client message
+ *
+ * @dev: the device structure
+ * @cl: client
+ * @hbm_cmd: host bus message command
+ * @len: buffer length
+ */
+static inline
+int mei_hbm_cl_write(struct mei_device *dev,
+		     struct mei_cl *cl, u8 hbm_cmd, size_t len)
+{
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
+
+	mei_hbm_hdr(mei_hdr, len);
+	mei_hbm_cl_hdr(cl, hbm_cmd, dev->wr_msg.data, len);
+
+	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
+}
+
+/**
  * mei_hbm_cl_addr_equal - tells if they have the same address
  *
  * @cl: - client
@@ -365,15 +385,9 @@ static int mei_hbm_stop_req(struct mei_device *dev)
  */
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_flow_control);
-
-	mei_hbm_hdr(mei_hdr, len);
-	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, dev->wr_msg.data, len);
-
 	cl_dbg(dev, cl, "sending flow control\n");
-
-	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
+	return mei_hbm_cl_write(dev, cl, MEI_FLOW_CONTROL_CMD, len);
 }
 
 /**
@@ -452,13 +466,8 @@ static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
  */
 int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
-
-	mei_hbm_hdr(mei_hdr, len);
-	mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_REQ_CMD, dev->wr_msg.data, len);
-
-	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
+	return mei_hbm_cl_write(dev, cl, CLIENT_DISCONNECT_REQ_CMD, len);
 }
 
 /**
@@ -471,13 +480,8 @@ int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
  */
 int mei_hbm_cl_disconnect_rsp(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_response);
-
-	mei_hbm_hdr(mei_hdr, len);
-	mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_RES_CMD, dev->wr_msg.data, len);
-
-	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
+	return mei_hbm_cl_write(dev, cl, CLIENT_DISCONNECT_RES_CMD, len);
 }
 
 /**
@@ -526,13 +530,8 @@ static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
  */
 int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
-
-	mei_hbm_hdr(mei_hdr, len);
-	mei_hbm_cl_hdr(cl, CLIENT_CONNECT_REQ_CMD, dev->wr_msg.data, len);
-
-	return mei_write_message(dev, mei_hdr,  dev->wr_msg.data);
+	return mei_hbm_cl_write(dev, cl, CLIENT_CONNECT_REQ_CMD, len);
 }
 
 /**
-- 
1.9.3

