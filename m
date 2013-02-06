Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3BFMHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:07:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:39807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3BFMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310888"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/6] mei: move clients cleanup code from init.c to client.c
Date: Wed,  6 Feb 2013 14:06:44 +0200
Message-Id: <1360152404-5769-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

during reset we clean up client data structures
we move that code into wrappers in client
and call the wrappers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c |   51 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/client.h |    5 ++++
 drivers/misc/mei/init.c   |   28 +++++-------------------
 3 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e46663e..1569afe 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -676,3 +676,54 @@ err:
 	return rets;
 }
 
+/**
+ * mei_cl_all_disconnect - disconnect forcefully all connected clients
+ *
+ * @dev - mei device
+ */
+
+void mei_cl_all_disconnect(struct mei_device *dev)
+{
+	struct mei_cl *cl, *next;
+
+	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
+		cl->state = MEI_FILE_DISCONNECTED;
+		cl->mei_flow_ctrl_creds = 0;
+		cl->read_cb = NULL;
+		cl->timer_count = 0;
+	}
+}
+
+
+/**
+ * mei_cl_all_read_wakeup  - wake up all readings so they can be interrupted
+ *
+ * @dev  - mei device
+ */
+void mei_cl_all_read_wakeup(struct mei_device *dev)
+{
+	struct mei_cl *cl, *next;
+	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
+		if (waitqueue_active(&cl->rx_wait)) {
+			dev_dbg(&dev->pdev->dev, "Waking up client!\n");
+			wake_up_interruptible(&cl->rx_wait);
+		}
+	}
+}
+
+/**
+ * mei_cl_all_write_clear - clear all pending writes
+
+ * @dev - mei device
+ */
+void mei_cl_all_write_clear(struct mei_device *dev)
+{
+	struct mei_cl_cb *cb, *next;
+
+	list_for_each_entry_safe(cb, next, &dev->write_list.list, list) {
+		list_del(&cb->list);
+		mei_io_cb_free(cb);
+	}
+}
+
+
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 240a1f3..214b239 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -94,4 +94,9 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file);
 void mei_host_client_init(struct work_struct *work);
 
 
+void mei_cl_all_disconnect(struct mei_device *dev);
+void mei_cl_all_read_wakeup(struct mei_device *dev);
+void mei_cl_all_write_clear(struct mei_device *dev);
+
+
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 51a005e..6ec5301 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -135,10 +135,6 @@ err:
  */
 void mei_reset(struct mei_device *dev, int interrupts_enabled)
 {
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
-	struct mei_cl_cb *cb_pos = NULL;
-	struct mei_cl_cb *cb_next = NULL;
 	bool unexpected;
 
 	if (dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET)
@@ -157,13 +153,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
 			dev->dev_state = MEI_DEV_RESETING;
 
-		list_for_each_entry_safe(cl_pos,
-				cl_next, &dev->file_list, link) {
-			cl_pos->state = MEI_FILE_DISCONNECTED;
-			cl_pos->mei_flow_ctrl_creds = 0;
-			cl_pos->read_cb = NULL;
-			cl_pos->timer_count = 0;
-		}
+		mei_cl_all_disconnect(dev);
+
 		/* remove entry if already in list */
 		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
 		mei_cl_unlink(&dev->wd_cl);
@@ -185,18 +176,11 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
 
-	/* Wake up all readings so they can be interrupted */
-	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if (waitqueue_active(&cl_pos->rx_wait)) {
-			dev_dbg(&dev->pdev->dev, "Waking up client!\n");
-			wake_up_interruptible(&cl_pos->rx_wait);
-		}
-	}
+	/* wake up all readings so they can be interrupted */
+	mei_cl_all_read_wakeup(dev);
+
 	/* remove all waiting requests */
-	list_for_each_entry_safe(cb_pos, cb_next, &dev->write_list.list, list) {
-		list_del(&cb_pos->list);
-		mei_io_cb_free(cb_pos);
-	}
+	mei_cl_all_write_clear(dev);
 }
 
 
-- 
1.7.4.4

