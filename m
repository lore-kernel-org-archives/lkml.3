Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaHNOXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:23:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:36835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbaHNOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:23:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="576685292"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: amthif: use service function to flush amthif queue
Date: Thu, 14 Aug 2014 17:22:20 +0300
Message-Id: <1408026141-18241-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408026141-18241-1-git-send-email-tomas.winkler@intel.com>
References: <1408026141-18241-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Replace open coded loop with an existing service function:
mei_io_list_flush

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c    |  2 +-
 drivers/misc/mei/client.h    |  2 ++
 drivers/misc/mei/interrupt.c | 13 ++-----------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 7dfe2b5..a90052e 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -117,7 +117,7 @@ static void __mei_io_list_flush(struct mei_cl_cb *list,
  * @list:  An instance of our list structure
  * @cl: host client
  */
-static inline void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
 {
 	__mei_io_list_flush(list, cl, false);
 }
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 96d5de0..bf2b0b1 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -45,6 +45,8 @@ static inline void mei_io_list_init(struct mei_cl_cb *list)
 {
 	INIT_LIST_HEAD(&list->list);
 }
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
+
 /*
  * MEI Host Client Functions
  */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 4e3cba6d..19709b7 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -556,8 +556,6 @@ void mei_timer(struct work_struct *work)
 {
 	unsigned long timeout;
 	struct mei_cl *cl;
-	struct mei_cl_cb  *cb_pos = NULL;
-	struct mei_cl_cb  *cb_next = NULL;
 
 	struct mei_device *dev = container_of(work,
 					struct mei_device, timer_work.work);
@@ -632,15 +630,8 @@ void mei_timer(struct work_struct *work)
 
 			dev_dbg(&dev->pdev->dev, "freeing AMTHI for other requests\n");
 
-			list_for_each_entry_safe(cb_pos, cb_next,
-				&dev->amthif_rd_complete_list.list, list) {
-
-				cl = cb_pos->file_object->private_data;
-
-				/* Finding the AMTHI entry. */
-				if (cl == &dev->iamthif_cl)
-					list_del(&cb_pos->list);
-			}
+			mei_io_list_flush(&dev->amthif_rd_complete_list,
+				&dev->iamthif_cl);
 			mei_io_cb_free(dev->iamthif_current_cb);
 			dev->iamthif_current_cb = NULL;
 
-- 
1.9.3

