Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3JOAuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:50:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:8916 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab3JOAup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:50:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,495,1378882800"; 
   d="scan'208";a="416842508"
From: xiao jin <jin.xiao@intel.com>
To: oliver@neukum.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: xiao jin <jin.xiao@intel.com>
Subject: [PATCH v2] cdc-acm: put delayed_wb to list
Date: Tue, 15 Oct 2013 09:01:35 +0800
Message-Id: <1381798895-2980-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If acm_write_start during acm suspend, write acm_wb is backuped
to delayed_wb. When acm resume, the delayed_wb will be started.
This mechanism can only record one write during acm suspend. More
acm write will be abandoned.

This patch is to use list_head to record the write acm_wb during acm
suspend. It can ensure no acm write abandoned.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/usb/class/cdc-acm.c |   30 ++++++++++++++++++++----------
 drivers/usb/class/cdc-acm.h |    7 ++++++-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 9f49bfe..be679be 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -607,6 +607,7 @@ static int acm_tty_write(struct tty_struct *tty,
 	unsigned long flags;
 	int wbn;
 	struct acm_wb *wb;
+	struct delayed_wb *d_wb;
 
 	if (!count)
 		return 0;
@@ -634,12 +635,17 @@ static int acm_tty_write(struct tty_struct *tty,
 
 	usb_autopm_get_interface_async(acm->control);
 	if (acm->susp_count) {
-		if (!acm->delayed_wb)
-			acm->delayed_wb = wb;
-		else
+		d_wb = kmalloc(sizeof(struct delayed_wb), GFP_ATOMIC);
+		if (d_wb == NULL) {
 			usb_autopm_put_interface_async(acm->control);
-		spin_unlock_irqrestore(&acm->write_lock, flags);
-		return count;	/* A white lie */
+			spin_unlock_irqrestore(&acm->write_lock, flags);
+			return -ENOMEM;
+		} else {
+			d_wb->wb = wb;
+			list_add_tail(&d_wb->list, &acm->delayed_wb_list);
+			spin_unlock_irqrestore(&acm->write_lock, flags);
+			return count;	/* A white lie */
+		}
 	}
 	usb_mark_last_busy(acm->dev);
 
@@ -1255,6 +1261,7 @@ made_compressed_probe:
 		snd->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		snd->instance = acm;
 	}
+	INIT_LIST_HEAD(&acm->delayed_wb_list);
 
 	usb_set_intfdata(intf, acm);
 
@@ -1449,6 +1456,7 @@ static int acm_resume(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
 	struct acm_wb *wb;
+	struct delayed_wb *d_wb, *nd_wb;
 	int rv = 0;
 	int cnt;
 
@@ -1464,14 +1472,16 @@ static int acm_resume(struct usb_interface *intf)
 		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
 
 		spin_lock_irq(&acm->write_lock);
-		if (acm->delayed_wb) {
-			wb = acm->delayed_wb;
-			acm->delayed_wb = NULL;
+		list_for_each_entry_safe(d_wb, nd_wb,
+				&acm->delayed_wb_list, list) {
+			wb = d_wb->wb;
+			list_del(&d_wb->list);
+			kfree(d_wb);
 			spin_unlock_irq(&acm->write_lock);
 			acm_start_wb(acm, wb);
-		} else {
-			spin_unlock_irq(&acm->write_lock);
+			spin_lock_irq(&acm->write_lock);
 		}
+		spin_unlock_irq(&acm->write_lock);
 
 		/*
 		 * delayed error checking because we must
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index 0f76e4a..5eed93f 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -79,6 +79,11 @@ struct acm_rb {
 	struct acm		*instance;
 };
 
+struct delayed_wb {
+	struct list_head        list;
+	struct acm_wb		*wb;
+}
+
 struct acm {
 	struct usb_device *dev;				/* the corresponding usb device */
 	struct usb_interface *control;			/* control interface */
@@ -117,7 +122,7 @@ struct acm {
 	unsigned int throttled:1;			/* actually throttled */
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
-	struct acm_wb *delayed_wb;			/* write queued for a device about to be woken */
+	struct list_head delayed_wb_list;		/* delayed wb list */
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a
-- 
1.7.1

