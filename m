Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaJBKl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:41:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:6547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaJBKkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="582394052"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: use local cl variables in wd and amthif
Date: Thu,  2 Oct 2014 13:39:32 +0300
Message-Id: <1412246372-15531-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412246372-15531-1-git-send-email-tomas.winkler@intel.com>
References: <1412246372-15531-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use local cl variable instead of dev->iamthif_cl and dev->wd_cl
as the first step to use dynamic allocation of these clients
as their are not supported on all platforms

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 10 ++++++----
 drivers/misc/mei/wd.c     |  9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 0b5a315..79f53941 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -262,6 +262,7 @@ out:
 static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 {
 	struct mei_msg_hdr mei_hdr;
+	struct mei_cl *cl;
 	int ret;
 
 	if (!dev || !cb)
@@ -277,8 +278,9 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	dev->iamthif_msg_buf_size = cb->request_buffer.size;
 	memcpy(dev->iamthif_msg_buf, cb->request_buffer.data,
 	       cb->request_buffer.size);
+	cl = &dev->iamthif_cl;
 
-	ret = mei_cl_flow_ctrl_creds(&dev->iamthif_cl);
+	ret = mei_cl_flow_ctrl_creds(cl);
 	if (ret < 0)
 		return ret;
 
@@ -292,8 +294,8 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 			mei_hdr.msg_complete = 1;
 		}
 
-		mei_hdr.host_addr = dev->iamthif_cl.host_client_id;
-		mei_hdr.me_addr = dev->iamthif_cl.me_client_id;
+		mei_hdr.host_addr = cl->host_client_id;
+		mei_hdr.me_addr = cl->me_client_id;
 		mei_hdr.reserved = 0;
 		mei_hdr.internal = 0;
 		dev->iamthif_msg_buf_index += mei_hdr.length;
@@ -302,7 +304,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 			return ret;
 
 		if (mei_hdr.msg_complete) {
-			if (mei_cl_flow_ctrl_reduce(&dev->iamthif_cl))
+			if (mei_cl_flow_ctrl_reduce(cl))
 				return -EIO;
 			dev->iamthif_flow_control_pending = true;
 			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index b836dff..b1d892c 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -270,15 +270,18 @@ static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 {
 	struct mei_device *dev;
+	struct mei_cl *cl;
 	int ret;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
 		return -ENODEV;
 
+	cl = &dev->wd_cl;
+
 	mutex_lock(&dev->device_lock);
 
-	if (dev->wd_cl.state != MEI_FILE_CONNECTED) {
+	if (cl->state != MEI_FILE_CONNECTED) {
 		dev_err(dev->dev, "wd: not connected.\n");
 		ret = -ENODEV;
 		goto end;
@@ -286,12 +289,12 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 
 	dev->wd_state = MEI_WD_RUNNING;
 
-	ret = mei_cl_flow_ctrl_creds(&dev->wd_cl);
+	ret = mei_cl_flow_ctrl_creds(cl);
 	if (ret < 0)
 		goto end;
+
 	/* Check if we can send the ping to HW*/
 	if (ret && mei_hbuf_acquire(dev)) {
-
 		dev_dbg(dev->dev, "wd: sending ping\n");
 
 		ret = mei_wd_send(dev);
-- 
1.9.3

