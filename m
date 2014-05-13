Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbaEMKkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60762 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/182] mei: fix memory leak of pending write cb objects
Date: Tue, 13 May 2014 11:26:23 +0200
Message-Id: <c62aa30f2631c4c32948b67eacc7a31d9c1867d7.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cc99ecfdac01215594c73907726b12f251c21e20 upstream.

Write callbacks are released on the write completed path but
when file handler is closed before the writes are
completed those are left dangling on write and write_waiting queues.

We add mei_io_list_free function to perform this task

Also move static functions to client.c form client.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/client.c | 76 ++++++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/client.h | 18 -----------
 2 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index b66cec93ebb3..9abe5a4e3ef7 100644
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
@@ -916,20 +962,8 @@ void mei_cl_all_wakeup(struct mei_device *dev)
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
index 892cc4207fa2..5d75ab523490 100644
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
1.9.3

