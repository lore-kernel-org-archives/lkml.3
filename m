Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaEGNwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:52:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:53709 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbaEGNwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:52:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1003,1389772800"; 
   d="scan'208";a="535205343"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: fix memory leak of mei_clients array
Date: Wed,  7 May 2014 16:51:28 +0300
Message-Id: <1399470688-22530-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we never freed the mei_clients array on driver shutdown
only on reset
add mei_hbm_reset function that wraps the hbm cleanup

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
This should go to stable but it doesn't apply cleanly
using 'git am' so separate patches will be published

 drivers/misc/mei/hbm.c  | 46 +++++++++++++++++++++++++++++-----------------
 drivers/misc/mei/hbm.h  |  1 +
 drivers/misc/mei/init.c |  2 +-
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index b9a4bb5..8041062 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -60,6 +60,34 @@ static int mei_cl_conn_status_to_errno(enum mei_cl_connect_status status)
 }
 
 /**
+ * mei_hbm_idle - set hbm to idle state
+ *
+ * @dev: the device structure
+ */
+void mei_hbm_idle(struct mei_device *dev)
+{
+	dev->init_clients_timer = 0;
+	dev->hbm_state = MEI_HBM_IDLE;
+}
+
+/**
+ * mei_hbm_reset - reset hbm counters and book keeping data structurs
+ *
+ * @dev: the device structure
+ */
+void mei_hbm_reset(struct mei_device *dev)
+{
+	dev->me_clients_num = 0;
+	dev->me_client_presentation_num = 0;
+	dev->me_client_index = 0;
+
+	kfree(dev->me_clients);
+	dev->me_clients = NULL;
+
+	mei_hbm_idle(dev);
+}
+
+/**
  * mei_hbm_me_cl_allocate - allocates storage for me clients
  *
  * @dev: the device structure
@@ -71,9 +99,7 @@ static int mei_hbm_me_cl_allocate(struct mei_device *dev)
 	struct mei_me_client *clients;
 	int b;
 
-	dev->me_clients_num = 0;
-	dev->me_client_presentation_num = 0;
-	dev->me_client_index = 0;
+	mei_hbm_reset(dev);
 
 	/* count how many ME clients we have */
 	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
@@ -82,9 +108,6 @@ static int mei_hbm_me_cl_allocate(struct mei_device *dev)
 	if (dev->me_clients_num == 0)
 		return 0;
 
-	kfree(dev->me_clients);
-	dev->me_clients = NULL;
-
 	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%ld.\n",
 		dev->me_clients_num * sizeof(struct mei_me_client));
 	/* allocate storage for ME clients representation */
@@ -135,17 +158,6 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
 }
 
 
-/**
- * mei_hbm_idle - set hbm to idle state
- *
- * @dev: the device structure
- */
-void mei_hbm_idle(struct mei_device *dev)
-{
-	dev->init_clients_timer = 0;
-	dev->hbm_state = MEI_HBM_IDLE;
-}
-
 int mei_hbm_start_wait(struct mei_device *dev)
 {
 	int ret;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index 8e39cee..683eb28 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -50,6 +50,7 @@ static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 }
 
 void mei_hbm_idle(struct mei_device *dev);
+void mei_hbm_reset(struct mei_device *dev);
 int mei_hbm_start_req(struct mei_device *dev);
 int mei_hbm_start_wait(struct mei_device *dev);
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index b3f70eb..510f378 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -122,8 +122,8 @@ int mei_reset(struct mei_device *dev)
 		mei_amthif_reset_params(dev);
 	}
 
+	mei_hbm_reset(dev);
 
-	dev->me_clients_num = 0;
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;
 
-- 
1.9.0

