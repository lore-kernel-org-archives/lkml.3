Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3DSSSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:18:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:1876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3DSSSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="297630461"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: revamp mei_amthif_irq_read_message
Date: Fri, 19 Apr 2013 21:16:53 +0300
Message-Id: <1366395415-13031-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function to mei_amthif_irq_read_msg
and change parameters order

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 10 +++++-----
 drivers/misc/mei/interrupt.c |  2 +-
 drivers/misc/mei/mei_dev.h   |  9 +++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 9a5e8c7..31a6212 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -505,14 +505,15 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
  * mei_amthif_irq_read_message - read routine after ISR to
  *			handle the read amthif message
  *
- * @complete_list: An instance of our list structure
  * @dev: the device structure
  * @mei_hdr: header of amthif message
+ * @complete_list: An instance of our list structure
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev, struct mei_msg_hdr *mei_hdr)
+int mei_amthif_irq_read_msg(struct mei_device *dev,
+			    struct mei_msg_hdr *mei_hdr,
+			    struct mei_cl_cb *complete_list)
 {
 	struct mei_cl_cb *cb;
 	unsigned char *buffer;
@@ -530,8 +531,7 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 	if (!mei_hdr->msg_complete)
 		return 0;
 
-	dev_dbg(&dev->pdev->dev,
-			"amthif_message_buffer_index =%d\n",
+	dev_dbg(&dev->pdev->dev, "amthif_message_buffer_index =%d\n",
 			mei_hdr->length);
 
 	dev_dbg(&dev->pdev->dev, "completed amthif read.\n ");
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 653fcfb..9bf64c0 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -427,7 +427,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
 		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
-		ret = mei_amthif_irq_read_message(cmpl_list, dev, mei_hdr);
+		ret = mei_amthif_irq_read_msg(dev, mei_hdr, cmpl_list);
 		if (ret)
 			goto end;
 	} else {
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 56dee56..c91c492 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -502,6 +502,15 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 
 void mei_amthif_run_next_cmd(struct mei_device *dev);
 
+int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
+
+void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
+int mei_amthif_irq_read_msg(struct mei_device *dev,
+			    struct mei_msg_hdr *mei_hdr,
+			    struct mei_cl_cb *complete_list);
+int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
+
 /*
  * NFC functions
  */
-- 
1.8.1.2

