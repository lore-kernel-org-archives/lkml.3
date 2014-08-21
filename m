Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHULbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:31:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:4850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaHULbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969535"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 12/14] mei: extract supported features from the hbm version
Date: Thu, 21 Aug 2014 14:29:21 +0300
Message-Id: <1408620563-25834-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extract supported hbm features and commands from the hbm version

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c     | 25 ++++++++++++++++++++++++-
 drivers/misc/mei/hw-me.c   |  6 +-----
 drivers/misc/mei/mei_dev.h |  4 ++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 280befc..9fc051b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -372,7 +372,8 @@ static int mei_hbm_prop_req(struct mei_device *dev)
  * @dev: the device structure
  * @pg_cmd: the pg command code
  *
- * This function returns -EIO on write failure
+ * returns -EIO on write failure
+ *         -EOPNOTSUPP if the operation is not supported by the protocol
  */
 int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd)
 {
@@ -381,6 +382,9 @@ int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd)
 	const size_t len = sizeof(struct hbm_power_gate);
 	int ret;
 
+	if (!dev->hbm_f_pg_supported)
+		return -EOPNOTSUPP;
+
 	mei_hbm_hdr(mei_hdr, len);
 
 	req = (struct hbm_power_gate *)dev->wr_msg.data;
@@ -660,6 +664,23 @@ static int mei_hbm_fw_disconnect_req(struct mei_device *dev,
 	return 0;
 }
 
+/**
+ * mei_hbm_config_features: check what hbm features and commands
+ *        are supported by the fw
+ *
+ * @dev: the device structure
+ */
+static void mei_hbm_config_features(struct mei_device *dev)
+{
+	/* Power Gating Isolation Support */
+	dev->hbm_f_pg_supported = 0;
+	if (dev->version.major_version > HBM_MAJOR_VERSION_PGI)
+		dev->hbm_f_pg_supported = 1;
+
+	if (dev->version.major_version == HBM_MAJOR_VERSION_PGI &&
+	    dev->version.minor_version >= HBM_MINOR_VERSION_PGI)
+		dev->hbm_f_pg_supported = 1;
+}
 
 /**
  * mei_hbm_version_is_supported - checks whether the driver can
@@ -743,6 +764,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			break;
 		}
 
+		mei_hbm_config_features(dev);
+
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_STARTING) {
 			dev_err(&dev->pdev->dev, "hbm: start: state mismatch, [%d, %d]\n",
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index caf0da3..498bd42 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -574,11 +574,7 @@ static bool mei_me_pg_is_enabled(struct mei_device *dev)
 	if ((reg & ME_PGIC_HRA) == 0)
 		goto notsupported;
 
-	if (dev->version.major_version < HBM_MAJOR_VERSION_PGI)
-		goto notsupported;
-
-	if (dev->version.major_version == HBM_MAJOR_VERSION_PGI &&
-	    dev->version.minor_version < HBM_MINOR_VERSION_PGI)
+	if (!dev->hbm_f_pg_supported)
 		goto notsupported;
 
 	return true;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 79124ae..719edee 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -402,6 +402,9 @@ struct mei_cfg {
  *
  * @reset_count - limits the number of consecutive resets
  * @hbm_state - state of host bus message protocol
+ *
+ * @hbm_f_pg_supported - hbm feature pgi protocol
+ *
  * @pg_event - power gating event
  * @mem_addr - mem mapped base register address
 
@@ -476,6 +479,7 @@ struct mei_device {
 	} wr_msg;
 
 	struct hbm_version version;
+	unsigned int hbm_f_pg_supported:1;
 
 	struct list_head me_clients;
 	DECLARE_BITMAP(me_clients_map, MEI_CLIENTS_MAX);
-- 
1.9.3

