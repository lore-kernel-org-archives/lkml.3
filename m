Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689Ab3DHS5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:57:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:55282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935549Ab3DHS5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224698903"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: notify about the reset in error level
Date: Mon,  8 Apr 2013 21:56:38 +0300
Message-Id: <1365447398-15537-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365447398-15537-1-git-send-email-tomas.winkler@intel.com>
References: <1365447398-15537-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display errors causing device reset using dev_err and not dev_dbg
also change messages text to something more concise

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c       | 21 +++++++++------------
 drivers/misc/mei/interrupt.c |  6 +++---
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index fb9e63b..de7f5ba 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -145,7 +145,7 @@ void mei_hbm_start_req(struct mei_device *dev)
 
 	dev->recvd_msg = false;
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
+		dev_err(&dev->pdev->dev, "version message writet failed\n");
 		dev->dev_state = MEI_DEV_RESETING;
 		mei_reset(dev, 1);
 	}
@@ -175,7 +175,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev->dev_state = MEI_DEV_RESETING;
-		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
+		dev_err(&dev->pdev->dev, "enumeration request write failed.\n");
 		mei_reset(dev, 1);
 	}
 	dev->init_clients_state = MEI_ENUM_CLIENTS_MESSAGE;
@@ -227,7 +227,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev->dev_state = MEI_DEV_RESETING;
-		dev_err(&dev->pdev->dev, "Properties request command failed\n");
+		dev_err(&dev->pdev->dev, "properties request write failed\n");
 		mei_reset(dev, 1);
 
 		return -EIO;
@@ -557,7 +557,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			mei_hbm_enum_clients_req(dev);
 		} else {
 			dev->recvd_msg = false;
-			dev_dbg(&dev->pdev->dev, "reset due to received hbm: host start\n");
+			dev_err(&dev->pdev->dev, "reset: wrong host start response\n");
 			mei_reset(dev, 1);
 			return;
 		}
@@ -591,23 +591,20 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		me_client = &dev->me_clients[dev->me_client_presentation_num];
 
 		if (props_res->status || !dev->me_clients) {
-			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message wrong status.\n");
+			dev_err(&dev->pdev->dev, "reset: properties response hbm wrong status.\n");
 			mei_reset(dev, 1);
 			return;
 		}
 
 		if (me_client->client_id != props_res->address) {
-			dev_err(&dev->pdev->dev,
-				"Host client properties reply mismatch\n");
+			dev_err(&dev->pdev->dev, "reset: host properties response address mismatch\n");
 			mei_reset(dev, 1);
-
 			return;
 		}
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->init_clients_state != MEI_CLIENT_PROPERTIES_MESSAGE) {
-			dev_err(&dev->pdev->dev,
-				"Unexpected client properties reply\n");
+			dev_err(&dev->pdev->dev, "reset: unexpected properties response\n");
 			mei_reset(dev, 1);
 
 			return;
@@ -637,7 +634,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 				/* first property reqeust */
 				mei_hbm_prop_req(dev);
 		} else {
-			dev_dbg(&dev->pdev->dev, "reset due to received host enumeration clients response bus message.\n");
+			dev_err(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
 			mei_reset(dev, 1);
 			return;
 		}
@@ -645,7 +642,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case HOST_STOP_RES_CMD:
 		dev->dev_state = MEI_DEV_DISABLED;
-		dev_dbg(&dev->pdev->dev, "resetting because of FW stop response.\n");
+		dev_info(&dev->pdev->dev, "reset: FW stop response.\n");
 		mei_reset(dev, 1);
 		break;
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 255e085..9ff8c61 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -623,7 +623,7 @@ void mei_timer(struct work_struct *work)
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS) {
 			if (dev->init_clients_timer) {
 				if (--dev->init_clients_timer == 0) {
-					dev_dbg(&dev->pdev->dev, "IMEI reset due to init clients timeout ,init clients state = %d.\n",
+					dev_err(&dev->pdev->dev, "reset: init clients timeout ,init clients state = %d.\n",
 						dev->init_clients_state);
 					mei_reset(dev, 1);
 				}
@@ -635,7 +635,7 @@ void mei_timer(struct work_struct *work)
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
 		if (cl_pos->timer_count) {
 			if (--cl_pos->timer_count == 0) {
-				dev_dbg(&dev->pdev->dev, "HECI reset due to connect/disconnect timeout.\n");
+				dev_err(&dev->pdev->dev, "reset: connect/disconnect timeout.\n");
 				mei_reset(dev, 1);
 				goto out;
 			}
@@ -644,7 +644,7 @@ void mei_timer(struct work_struct *work)
 
 	if (dev->iamthif_stall_timer) {
 		if (--dev->iamthif_stall_timer == 0) {
-			dev_dbg(&dev->pdev->dev, "resetting because of hang to amthi.\n");
+			dev_err(&dev->pdev->dev, "reset: amthif  hanged.\n");
 			mei_reset(dev, 1);
 			dev->iamthif_msg_buf_size = 0;
 			dev->iamthif_msg_buf_index = 0;
-- 
1.8.1.2

