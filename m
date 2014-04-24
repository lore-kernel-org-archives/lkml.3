Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaDXLOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:14:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaDXIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/182] mei: fix memory leak of pending write cb objects
Date: Thu, 24 Apr 2014 09:49:40 +0100
Message-Id: <1398329507-5911-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit cc99ecfdac01215594c73907726b12f251c21e20 upstream.

Write callbacks are released on the write completed path but
when file handler is closed before the writes are
completed those are left dangling on write and write_waiting queues.

We add mei_io_list_free function to perform this task

Also move static functions to client.c form client.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/client.c | 76 ++++++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/client.h | 17 -----------
 2 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index b254132..12513e2 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -74,23 +74,69 @@ int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 
 
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
@@ -192,8 +238,8 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 
 	dev_dbg(&cl->dev->pdev->dev, "remove list entry belonging to cl\n");
 	mei_io_list_flush(&cl->dev->read_list, cl);
-	mei_io_list_flush(&cl->dev->write_list, cl);
-	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
+	mei_io_list_free(&cl->dev->write_list, cl);
+	mei_io_list_free(&cl->dev->write_waiting_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_wr_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_rd_list, cl);
 	mei_io_list_flush(&cl->dev->amthif_cmd_list, cl);
@@ -915,20 +961,8 @@ void mei_cl_all_read_wakeup(struct mei_device *dev)
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
index b1717bb..78df8f0 100644
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
@@ -61,21 +59,6 @@ int mei_cl_unlink(struct mei_cl *cl);
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
 static inline bool mei_cl_is_transitioning(struct mei_cl *cl)
 {
 	return (MEI_FILE_INITIALIZING == cl->state ||
-- 
1.9.1

