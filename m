Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaCJNMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:12:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:42971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaCJNMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="497018238"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        stable <stable@vger.kernel.org>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc] mei: fix memory leak of pending write cb objects
Date: Mon, 10 Mar 2014 15:10:40 +0200
Message-Id: <1394457040-28729-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write callbacks are released on the write completed path but
when file handler is closed before the writes are
completed those are left dangling on write and write_waiting queues.

We add mei_io_list_free function to perform this task

Also move static functions to client.c form client.h

Cc: stable <stable@vger.kernel.org> # 3.11+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/client.c | 76 ++++++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/client.h | 18 -----------
 2 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index aac7cdb..36eca54 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -71,23 +71,69 @@ int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 
 
 /**
- * mei_io_list_flush - removes list entry belonging to cl.
+ * mei_cl_cmp_id - tells if the clients are the same
  *
- * @list:  An instance of our list structure
- * @cl: host client
+ * @cl1: host client 1
+ * @cl2: host client 2
+ *
+ * returns true  - if the clients has same host and me ids
+ *         false - otherwise
+ */
+static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
+				const struct mei_cl *cl2)
+{
+	return cl1 && cl2 &&
+		(cl1->host_client_id == cl2->host_client_id) &&
+		(cl1->me_client_id == cl2->me_client_id);
+}
+
+/**
+ * mei_io_list_flush - removes cbs belonging to cl.
+ *
+ * @list:  an instance of our list structure
+ * @cl:    host client, can be NULL for flushing the whole list
+ * @free:  whether to free the cbs
  */
-void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
+static void __mei_io_list_flush(struct mei_cl_cb *list,
+				struct mei_cl *cl, bool free)
 {
 	struct mei_cl_cb *cb;
 	struct mei_cl_cb *next;
 
+	/* enable removing everything if no cl is specified */
 	list_for_each_entry_safe(cb, next, &list->list, list) {
-		if (cb->cl && mei_cl_cmp_id(cl, cb->cl))
+		if (!cl || (cb->cl && mei_cl_cmp_id(cl, cb->cl))) {
 			list_del(&cb->list);
+			if (free)
+				mei_io_cb_free(cb);
+		}
 	}
 }
 
 /**
+ * mei_io_list_flush - removes list entry belonging to cl.
+ *
+ * @list:  An instance of our list structure
+ * @cl: host client
+ */
+static inline void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
+{
+	__mei_io_list_flush(list, cl, false);
+}
+
+
+/**
+ * mei_io_list_free - removes cb belonging to cl and free them
+ *
+ * @list:  An instance of our list structure
+ * @cl: host client
+ */
+static inline void mei_io_list_free(struct mei_cl_cb *list, struct mei_cl *cl)
+{
+	__mei_io_list_flush(list, cl, true);
+}
+
+/**
  * mei_io_cb_free - free mei_cb_private related memory
  *
  * @cb: mei callback struct
@@ -193,8 +239,8 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 
 	cl_dbg(dev, cl, "remove list entry belonging to cl\n");
 	mei_io_list_flush(&cl->dev->read_list, cl);
-	mei_io_list_flush(&cl->dev->write_list, cl);
-	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
+	mei_io_list_free(&cl->dev->write_list, cl);
+	mei_io_list_free(&cl->dev->write_waiting_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_wr_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_rd_list, cl);
 	mei_io_list_flush(&cl->dev->amthif_cmd_list, cl);
@@ -955,20 +1001,8 @@ void mei_cl_all_wakeup(struct mei_device *dev)
  */
 void mei_cl_all_write_clear(struct mei_device *dev)
 {
-	struct mei_cl_cb *cb, *next;
-	struct list_head *list;
-
-	list = &dev->write_list.list;
-	list_for_each_entry_safe(cb, next, list, list) {
-		list_del(&cb->list);
-		mei_io_cb_free(cb);
-	}
-
-	list = &dev->write_waiting_list.list;
-	list_for_each_entry_safe(cb, next, list, list) {
-		list_del(&cb->list);
-		mei_io_cb_free(cb);
-	}
+	mei_io_list_free(&dev->write_list, NULL);
+	mei_io_list_free(&dev->write_waiting_list, NULL);
 }
 
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index c11b663..8139393 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -45,8 +45,6 @@ static inline void mei_io_list_init(struct mei_cl_cb *list)
 {
 	INIT_LIST_HEAD(&list->list);
 }
-void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
-
 /*
  * MEI Host Client Functions
  */
@@ -61,22 +59,6 @@ int mei_cl_unlink(struct mei_cl *cl);
 int mei_cl_flush_queues(struct mei_cl *cl);
 struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl);
 
-/**
- * mei_cl_cmp_id - tells if file private data have same id
- *
- * @fe1: private data of 1. file object
- * @fe2: private data of 2. file object
- *
- * returns true  - if ids are the same and not NULL
- */
-static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
-				const struct mei_cl *cl2)
-{
-	return cl1 && cl2 &&
-		(cl1->host_client_id == cl2->host_client_id) &&
-		(cl1->me_client_id == cl2->me_client_id);
-}
-
 
 int mei_cl_flow_ctrl_creds(struct mei_cl *cl);
 
-- 
1.8.5.3

