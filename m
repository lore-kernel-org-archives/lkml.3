Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3FPGTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 02:19:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:9135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab3FPGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 02:19:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,874,1363158000"; 
   d="scan'208";a="354268526"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: support HBM versioning
Date: Sun, 16 Jun 2013 09:16:31 +0300
Message-Id: <1371363391-18008-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver can work properly if device support driver HBM version
or driver can downgrade its supported HBM version level

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c  | 37 ++++++++++++++++++++++++++++++++-----
 drivers/misc/mei/hbm.h  |  2 +-
 drivers/misc/mei/init.c |  3 +--
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 6916045..565027b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -536,6 +536,20 @@ static void mei_hbm_fw_disconnect_req(struct mei_device *dev,
 
 
 /**
+ * mei_hbm_version_is_supported - checks whether the driver can
+ *     support the hbm version of the device
+ *
+ * @dev: the device structure
+ * returns true if driver can support hbm version of the device
+ */
+bool mei_hbm_version_is_supported(struct mei_device *dev)
+{
+	return	(dev->version.major_version < HBM_MAJOR_VERSION) ||
+		(dev->version.major_version == HBM_MAJOR_VERSION &&
+		 dev->version.minor_version <= HBM_MINOR_VERSION);
+}
+
+/**
  * mei_hbm_dispatch - bottom half read routine after ISR to
  * handle the read bus message cmd processing.
  *
@@ -562,9 +576,24 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	switch (mei_msg->hbm_cmd) {
 	case HOST_START_RES_CMD:
 		version_res = (struct hbm_host_version_response *)mei_msg;
-		if (!version_res->host_version_supported) {
-			dev->version = version_res->me_max_version;
-			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
+
+		dev_dbg(&dev->pdev->dev, "HBM VERSION: DRIVER=%02d:%02d DEVICE=%02d:%02d\n",
+				HBM_MAJOR_VERSION, HBM_MINOR_VERSION,
+				version_res->me_max_version.major_version,
+				version_res->me_max_version.minor_version);
+
+		if (version_res->host_version_supported) {
+			dev->version.major_version = HBM_MAJOR_VERSION;
+			dev->version.minor_version = HBM_MINOR_VERSION;
+		} else {
+			dev->version.major_version =
+				version_res->me_max_version.major_version;
+			dev->version.minor_version =
+				version_res->me_max_version.minor_version;
+		}
+
+		if (!mei_hbm_version_is_supported(dev)) {
+			dev_warn(&dev->pdev->dev, "hbm version mismatch: stopping the driver.\n");
 
 			dev->hbm_state = MEI_HBM_STOP;
 			mei_hbm_stop_req_prepare(dev, &dev->wr_msg.hdr,
@@ -575,8 +604,6 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return;
 		}
 
-		dev->version.major_version = HBM_MAJOR_VERSION;
-		dev->version.minor_version = HBM_MINOR_VERSION;
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
 		    dev->hbm_state == MEI_HBM_START) {
 			dev->init_clients_timer = 0;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index e80dc24..4ae2e56 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -54,7 +54,7 @@ int mei_hbm_start_wait(struct mei_device *dev);
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
-
+bool mei_hbm_version_is_supported(struct mei_device *dev);
 
 #endif /* _MEI_HBM_H_ */
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index f580d30..79e9e1c 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -106,8 +106,7 @@ int mei_start(struct mei_device *dev)
 		goto err;
 	}
 
-	if (dev->version.major_version != HBM_MAJOR_VERSION ||
-	    dev->version.minor_version != HBM_MINOR_VERSION) {
+	if (!mei_hbm_version_is_supported(dev)) {
 		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
 		goto err;
 	}
-- 
1.8.1.2

