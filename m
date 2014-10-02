Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaJBKk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:40:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:6547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJBKky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="582394050"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: drop unneeded client NULL check in cb structure
Date: Thu,  2 Oct 2014 13:39:31 +0300
Message-Id: <1412246372-15531-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

The pointer to client in the callback structure (cb->cl)
can't be NULL with current locking.
We can drop check and warnings as in some cases this just
uselessly complicates the code flow.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 24 +++++++++---------------
 drivers/misc/mei/client.c    |  2 +-
 drivers/misc/mei/hbm.c       |  5 -----
 drivers/misc/mei/interrupt.c | 12 +-----------
 4 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 6cdce84..0b5a315 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -360,8 +360,7 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 void mei_amthif_run_next_cmd(struct mei_device *dev)
 {
 	struct mei_cl_cb *cb;
-	struct mei_cl_cb *next;
-	int status;
+	int ret;
 
 	if (!dev)
 		return;
@@ -376,16 +375,14 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 
 	dev_dbg(dev->dev, "complete amthif cmd_list cb.\n");
 
-	list_for_each_entry_safe(cb, next, &dev->amthif_cmd_list.list, list) {
-		list_del(&cb->list);
-		if (!cb->cl)
-			continue;
-		status = mei_amthif_send_cmd(dev, cb);
-		if (status)
-			dev_warn(dev->dev, "amthif write failed status = %d\n",
-						status);
-		break;
-	}
+	cb = list_first_entry_or_null(&dev->amthif_cmd_list.list,
+					typeof(*cb), list);
+	if (!cb)
+		return;
+	list_del(&cb->list);
+	ret =  mei_amthif_send_cmd(dev, cb);
+	if (ret)
+		dev_warn(dev->dev, "amthif write failed status = %d\n", ret);
 }
 
 
@@ -536,9 +533,6 @@ int mei_amthif_irq_read_msg(struct mei_device *dev,
 	cb = dev->iamthif_current_cb;
 	dev->iamthif_current_cb = NULL;
 
-	if (!cb->cl)
-		return -ENODEV;
-
 	dev->iamthif_stall_timer = 0;
 	cb->buf_idx = dev->iamthif_msg_buf_index;
 	cb->read_time = jiffies;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 03c95e0..3e55d2a 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -146,7 +146,7 @@ static void __mei_io_list_flush(struct mei_cl_cb *list,
 
 	/* enable removing everything if no cl is specified */
 	list_for_each_entry_safe(cb, next, &list->list, list) {
-		if (!cl || (cb->cl && mei_cl_cmp_id(cl, cb->cl))) {
+		if (!cl || mei_cl_cmp_id(cl, cb->cl)) {
 			list_del(&cb->list);
 			if (free)
 				mei_io_cb_free(cb);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 49a2653..57c1bde 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -637,11 +637,6 @@ static void mei_hbm_cl_res(struct mei_device *dev,
 	list_for_each_entry_safe(cb, next, &dev->ctrl_rd_list.list, list) {
 
 		cl = cb->cl;
-		/* this should not happen */
-		if (WARN_ON(!cl)) {
-			list_del_init(&cb->list);
-			continue;
-		}
 
 		if (cb->fop_type != fop_type)
 			continue;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 20c6c51..711cddf 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -44,8 +44,6 @@ void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 	list_for_each_entry_safe(cb, next, &compl_list->list, list) {
 		cl = cb->cl;
 		list_del(&cb->list);
-		if (!cl)
-			continue;
 
 		dev_dbg(dev->dev, "completing call back.\n");
 		if (cl == &dev->iamthif_cl)
@@ -105,7 +103,7 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 
 	list_for_each_entry_safe(cb, next, &dev->read_list.list, list) {
 		cl = cb->cl;
-		if (!cl || !mei_cl_is_reading(cl, mei_hdr))
+		if (!mei_cl_is_reading(cl, mei_hdr))
 			continue;
 
 		cl->reading_state = MEI_READING;
@@ -449,8 +447,6 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	list = &dev->write_waiting_list;
 	list_for_each_entry_safe(cb, next, &list->list, list) {
 		cl = cb->cl;
-		if (cl == NULL)
-			continue;
 
 		cl->status = 0;
 		list_del(&cb->list);
@@ -489,10 +485,6 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	dev_dbg(dev->dev, "complete control write list cb.\n");
 	list_for_each_entry_safe(cb, next, &dev->ctrl_wr_list.list, list) {
 		cl = cb->cl;
-		if (!cl) {
-			list_del(&cb->list);
-			return -ENODEV;
-		}
 		switch (cb->fop_type) {
 		case MEI_FOP_DISCONNECT:
 			/* send disconnect message */
@@ -530,8 +522,6 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	dev_dbg(dev->dev, "complete write list cb.\n");
 	list_for_each_entry_safe(cb, next, &dev->write_list.list, list) {
 		cl = cb->cl;
-		if (cl == NULL)
-			continue;
 		if (cl == &dev->iamthif_cl)
 			ret = mei_amthif_irq_write(cl, cb, cmpl_list);
 		else
-- 
1.9.3

