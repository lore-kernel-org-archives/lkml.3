Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaHNOXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:23:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:36889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbaHNOXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:23:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="576685308"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: amthif: don't check amthif client identity on amthif queues
Date: Thu, 14 Aug 2014 17:22:21 +0300
Message-Id: <1408026141-18241-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408026141-18241-1-git-send-email-tomas.winkler@intel.com>
References: <1408026141-18241-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Amthif has its own queues therefore it is redundant
to check the client type when processing the queues

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 0d6234d..ab60959 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -130,12 +130,9 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 						struct file *file)
 {
 	struct mei_cl_cb *cb;
-
-	list_for_each_entry(cb, &dev->amthif_rd_complete_list.list, list) {
-		if (cb->cl && cb->cl == &dev->iamthif_cl &&
-			cb->file_object == file)
+	list_for_each_entry(cb, &dev->amthif_rd_complete_list.list, list)
+		if (cb->file_object == file)
 			return cb;
-	}
 	return NULL;
 }
 
@@ -168,8 +165,8 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	int i;
 
 	/* Only possible if we are in timeout */
-	if (!cl || cl != &dev->iamthif_cl) {
-		dev_dbg(&dev->pdev->dev, "bad file ext.\n");
+	if (!cl) {
+		dev_err(&dev->pdev->dev, "bad file ext.\n");
 		return -ETIME;
 	}
 
@@ -371,8 +368,8 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
  */
 void mei_amthif_run_next_cmd(struct mei_device *dev)
 {
-	struct mei_cl_cb *pos = NULL;
-	struct mei_cl_cb *next = NULL;
+	struct mei_cl_cb *cb;
+	struct mei_cl_cb *next;
 	int status;
 
 	if (!dev)
@@ -388,19 +385,15 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 
 	dev_dbg(&dev->pdev->dev, "complete amthif cmd_list cb.\n");
 
-	list_for_each_entry_safe(pos, next, &dev->amthif_cmd_list.list, list) {
-		list_del(&pos->list);
-
-		if (pos->cl && pos->cl == &dev->iamthif_cl) {
-			status = mei_amthif_send_cmd(dev, pos);
-			if (status) {
-				dev_dbg(&dev->pdev->dev,
-					"amthif write failed status = %d\n",
+	list_for_each_entry_safe(cb, next, &dev->amthif_cmd_list.list, list) {
+		list_del(&cb->list);
+		if (!cb->cl)
+			continue;
+		status = mei_amthif_send_cmd(dev, cb);
+		if (status)
+			dev_warn(&dev->pdev->dev, "amthif write failed status = %d\n",
 						status);
-				return;
-			}
-			break;
-		}
+		break;
 	}
 }
 
@@ -559,7 +552,7 @@ int mei_amthif_irq_read_msg(struct mei_device *dev,
 	dev->iamthif_stall_timer = 0;
 	cb->buf_idx = dev->iamthif_msg_buf_index;
 	cb->read_time = jiffies;
-	if (dev->iamthif_ioctl && cb->cl == &dev->iamthif_cl) {
+	if (dev->iamthif_ioctl) {
 		/* found the iamthif cb */
 		dev_dbg(&dev->pdev->dev, "complete the amthif read cb.\n ");
 		dev_dbg(&dev->pdev->dev, "add the amthif read cb to complete.\n ");
-- 
1.9.3

