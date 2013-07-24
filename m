Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3GXNYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:24:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:31433 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab3GXNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,735,1367996400"; 
   d="scan'208";a="336062308"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: wake also writers on reset
Date: Wed, 24 Jul 2013 16:22:57 +0300
Message-Id: <1374672179-23949-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
References: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wake writers otherwise might have processes waiting
endlessly on wait_tx during reset

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 10 +++++++---
 drivers/misc/mei/client.h |  2 +-
 drivers/misc/mei/init.c   |  2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 21d3f5a..af1e602 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -892,18 +892,22 @@ void mei_cl_all_disconnect(struct mei_device *dev)
 
 
 /**
- * mei_cl_all_read_wakeup  - wake up all readings so they can be interrupted
+ * mei_cl_all_wakeup  - wake up all readers and writers they can be interrupted
  *
  * @dev  - mei device
  */
-void mei_cl_all_read_wakeup(struct mei_device *dev)
+void mei_cl_all_wakeup(struct mei_device *dev)
 {
 	struct mei_cl *cl, *next;
 	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
 		if (waitqueue_active(&cl->rx_wait)) {
-			dev_dbg(&dev->pdev->dev, "Waking up client!\n");
+			dev_dbg(&dev->pdev->dev, "Waking up reading client!\n");
 			wake_up_interruptible(&cl->rx_wait);
 		}
+		if (waitqueue_active(&cl->tx_wait)) {
+			dev_dbg(&dev->pdev->dev, "Waking up writing client!\n");
+			wake_up_interruptible(&cl->tx_wait);
+		}
 	}
 }
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 26b157d..9bae4c7 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -99,7 +99,7 @@ void mei_host_client_init(struct work_struct *work);
 
 
 void mei_cl_all_disconnect(struct mei_device *dev);
-void mei_cl_all_read_wakeup(struct mei_device *dev);
+void mei_cl_all_wakeup(struct mei_device *dev);
 void mei_cl_all_write_clear(struct mei_device *dev);
 
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index e6f16f8..4bb7f3c 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -197,7 +197,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	mei_hbm_start_req(dev);
 
 	/* wake up all readings so they can be interrupted */
-	mei_cl_all_read_wakeup(dev);
+	mei_cl_all_wakeup(dev);
 
 	/* remove all waiting requests */
 	mei_cl_all_write_clear(dev);
-- 
1.8.1.2

