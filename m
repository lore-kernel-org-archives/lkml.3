Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3KKL2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:28:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:54087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3KKL14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:27:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="406751060"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: cleanup mei_irq_read_handler
Date: Mon, 11 Nov 2013 13:26:08 +0200
Message-Id: <1384169168-30281-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
References: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Simplify function flow
2. Display errors in error or warnings level instead of debug.
3. Remove excessive debug messages

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 79 ++++++++++++++++++++++----------------------
 drivers/misc/mei/mei_dev.h   | 10 ++++++
 2 files changed, 50 insertions(+), 39 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7a95c07..9c8225b 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -301,13 +301,11 @@ int mei_irq_read_handler(struct mei_device *dev,
 		struct mei_cl_cb *cmpl_list, s32 *slots)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
-	int ret = 0;
+	struct mei_cl *cl;
+	int ret;
 
 	if (!dev->rd_msg_hdr) {
 		dev->rd_msg_hdr = mei_read_hdr(dev);
-		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
 		(*slots)--;
 		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
 	}
@@ -315,61 +313,64 @@ int mei_irq_read_handler(struct mei_device *dev,
 	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 	if (mei_hdr->reserved || !dev->rd_msg_hdr) {
-		dev_dbg(&dev->pdev->dev, "corrupted message header.\n");
+		dev_err(&dev->pdev->dev, "corrupted message header 0x%08X\n",
+				dev->rd_msg_hdr);
 		ret = -EBADMSG;
 		goto end;
 	}
 
-	if (mei_hdr->host_addr || mei_hdr->me_addr) {
-		list_for_each_entry_safe(cl_pos, cl_next,
-					&dev->file_list, link) {
-			dev_dbg(&dev->pdev->dev,
-					"list_for_each_entry_safe read host"
-					" client = %d, ME client = %d\n",
-					cl_pos->host_client_id,
-					cl_pos->me_client_id);
-			if (mei_cl_hbm_equal(cl_pos, mei_hdr))
-				break;
-		}
-
-		if (&cl_pos->link == &dev->file_list) {
-			dev_dbg(&dev->pdev->dev, "corrupted message header\n");
-			ret = -EBADMSG;
-			goto end;
-		}
-	}
-	if (((*slots) * sizeof(u32)) < mei_hdr->length) {
-		dev_err(&dev->pdev->dev,
-				"we can't read the message slots =%08x.\n",
+	if (mei_slots2data(*slots) < mei_hdr->length) {
+		dev_err(&dev->pdev->dev, "less data available than length=%08x.\n",
 				*slots);
 		/* we can't read the message */
 		ret = -ERANGE;
 		goto end;
 	}
 
-	/* decide where to read the message too */
-	if (!mei_hdr->host_addr) {
-		dev_dbg(&dev->pdev->dev, "call mei_hbm_dispatch.\n");
+	/*  HBM message */
+	if (mei_hdr->host_addr == 0 && mei_hdr->me_addr == 0) {
 		mei_hbm_dispatch(dev, mei_hdr);
-		dev_dbg(&dev->pdev->dev, "end mei_hbm_dispatch.\n");
-	} else if (mei_hdr->host_addr == dev->iamthif_cl.host_client_id &&
-		   (MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
-		   (dev->iamthif_state == MEI_IAMTHIF_READING)) {
+		ret = 0;
+		dev_dbg(&dev->pdev->dev, "mei_hbm_dispatch.\n");
+		goto reset_slots;
+	}
 
-		dev_dbg(&dev->pdev->dev, "call mei_amthif_irq_read_msg.\n");
-		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
+	/* find recepient cl */
+	list_for_each_entry(cl, &dev->file_list, link) {
+		if (mei_cl_hbm_equal(cl, mei_hdr)) {
+			cl_dbg(dev, cl, "got a message\n");
+			break;
+		}
+	}
+
+	/* if no recepient cl was found we assume corrupted header\n */
+	if (&cl->link == &dev->file_list) {
+		dev_err(&dev->pdev->dev, "no destination client found 0x%08X\n",
+				dev->rd_msg_hdr);
+		ret = -EBADMSG;
+		goto end;
+	}
+
+	if (mei_hdr->host_addr == dev->iamthif_cl.host_client_id &&
+	    MEI_FILE_CONNECTED == dev->iamthif_cl.state &&
+	    dev->iamthif_state == MEI_IAMTHIF_READING) {
 
 		ret = mei_amthif_irq_read_msg(dev, mei_hdr, cmpl_list);
-		if (ret)
+		if (ret) {
+			dev_err(&dev->pdev->dev, "mei_amthif_irq_read_msg failed = %d\n",
+					ret);
 			goto end;
+		}
 	} else {
-		dev_dbg(&dev->pdev->dev, "call mei_cl_irq_read_msg.\n");
-		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 		ret = mei_cl_irq_read_msg(dev, mei_hdr, cmpl_list);
-		if (ret)
+		if (ret) {
+			dev_err(&dev->pdev->dev, "mei_cl_irq_read_msg failed = %d\n",
+					ret);
 			goto end;
+		}
 	}
 
+reset_slots:
 	/* reset the number of slots and header */
 	*slots = mei_count_full_read_slots(dev);
 	dev->rd_msg_hdr = 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 6f577bf..4a7ee81 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -456,6 +456,16 @@ static inline u32 mei_data2slots(size_t length)
 	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
 }
 
+/**
+ * mei_slots2data- get data in slots - bytes from slots
+ * @slots -  number of available slots
+ * returns  - number of bytes in slots
+ */
+static inline u32 mei_slots2data(int slots)
+{
+	return slots * 4;
+}
+
 /*
  * mei init function prototypes
  */
-- 
1.8.3.1

