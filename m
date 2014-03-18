Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbaCRU4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:56:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbaCRUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172445"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 07/13] mei: add function to check write queues
Date: Tue, 18 Mar 2014 22:52:01 +0200
Message-Id: <1395175927-10562-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver needs to check whether the write
queue idle before entering power gating

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/init.c    | 21 +++++++++++++++++++++
 drivers/misc/mei/mei_dev.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4b1eb37..abc5ea0 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -303,7 +303,28 @@ void mei_stop(struct mei_device *dev)
 }
 EXPORT_SYMBOL_GPL(mei_stop);
 
+/**
+ * mei_write_is_idle - check if the write queues are idle
+ *
+ * @dev: the device structure
+ *
+ * returns true of there is no pending write
+ */
+bool mei_write_is_idle(struct mei_device *dev)
+{
+	bool idle = (dev->dev_state == MEI_DEV_ENABLED &&
+		list_empty(&dev->ctrl_wr_list.list) &&
+		list_empty(&dev->write_list.list));
 
+	dev_dbg(&dev->pdev->dev, "write pg: is idle[%d] state=%s ctrl=%d write=%d\n",
+		idle,
+		mei_dev_state_str(dev->dev_state),
+		list_empty(&dev->ctrl_wr_list.list),
+		list_empty(&dev->write_list.list));
+
+	return idle;
+}
+EXPORT_SYMBOL_GPL(mei_write_is_idle);
 
 void mei_device_init(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index bec6ade..fe76e5b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -680,6 +680,8 @@ static inline int mei_count_full_read_slots(struct mei_device *dev)
 
 bool mei_hbuf_acquire(struct mei_device *dev);
 
+bool mei_write_is_idle(struct mei_device *dev);
+
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 int mei_dbgfs_register(struct mei_device *dev, const char *name);
 void mei_dbgfs_deregister(struct mei_device *dev);
-- 
1.8.5.3

