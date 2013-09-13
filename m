Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3IML1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab3IML12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:27:28 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org (open list:USB ATTACHED SCSI),
        usb-storage@lists.one-eyed-alien.net (open list:USB MASS STORAGE...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/6] uas: make work list per-device
Date: Fri, 13 Sep 2013 13:27:12 +0200
Message-Id: <1379071635-30701-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplifies locking, we'll protect the list with the device spin lock.
Also plugs races which can happen when two devices operate on the
global list.

While being at it rename the list head from "list" to "work", preparing
for the addition of a second list.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 106 +++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 62 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index fc08ee9..3cf5a5f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -51,6 +51,8 @@ struct uas_dev_info {
 	unsigned uas_sense_old:1;
 	struct scsi_cmnd *cmnd;
 	spinlock_t lock;
+	struct work_struct work;
+	struct list_head work_list;
 };
 
 enum {
@@ -77,7 +79,7 @@ struct uas_cmd_info {
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
-	struct list_head list;
+	struct list_head work;
 };
 
 /* I hate forward declarations, but I actually have a loop */
@@ -88,10 +90,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
 static void uas_configure_endpoints(struct uas_dev_info *devinfo);
 static void uas_free_streams(struct uas_dev_info *devinfo);
 
-static DECLARE_WORK(uas_work, uas_do_work);
-static DEFINE_SPINLOCK(uas_work_lock);
-static LIST_HEAD(uas_work_list);
-
 static void uas_unlink_data_urbs(struct uas_dev_info *devinfo,
 				 struct uas_cmd_info *cmdinfo)
 {
@@ -118,75 +116,66 @@ static void uas_unlink_data_urbs(struct uas_dev_info *devinfo,
 
 static void uas_do_work(struct work_struct *work)
 {
+	struct uas_dev_info *devinfo =
+		container_of(work, struct uas_dev_info, work);
 	struct uas_cmd_info *cmdinfo;
 	struct uas_cmd_info *temp;
-	struct list_head list;
 	unsigned long flags;
 	int err;
 
-	spin_lock_irq(&uas_work_lock);
-	list_replace_init(&uas_work_list, &list);
-	spin_unlock_irq(&uas_work_lock);
-
-	list_for_each_entry_safe(cmdinfo, temp, &list, list) {
+	spin_lock_irqsave(&devinfo->lock, flags);
+	list_for_each_entry_safe(cmdinfo, temp, &devinfo->work_list, work) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
-		struct scsi_cmnd *cmnd = container_of(scp,
-							struct scsi_cmnd, SCp);
-		struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
-		spin_lock_irqsave(&devinfo->lock, flags);
+		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
+						      SCp);
 		err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
-		if (!err)
+		if (!err) {
 			cmdinfo->state &= ~IS_IN_WORK_LIST;
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		if (err) {
-			list_del(&cmdinfo->list);
-			spin_lock_irq(&uas_work_lock);
-			list_add_tail(&cmdinfo->list, &uas_work_list);
-			spin_unlock_irq(&uas_work_lock);
-			schedule_work(&uas_work);
+			list_del(&cmdinfo->work);
+		} else {
+			schedule_work(&devinfo->work);
 		}
 	}
+	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
 static void uas_abort_work(struct uas_dev_info *devinfo)
 {
 	struct uas_cmd_info *cmdinfo;
 	struct uas_cmd_info *temp;
-	struct list_head list;
 	unsigned long flags;
 
-	spin_lock_irq(&uas_work_lock);
-	list_replace_init(&uas_work_list, &list);
-	spin_unlock_irq(&uas_work_lock);
-
 	spin_lock_irqsave(&devinfo->lock, flags);
-	list_for_each_entry_safe(cmdinfo, temp, &list, list) {
+	list_for_each_entry_safe(cmdinfo, temp, &devinfo->work_list, work) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
-		struct scsi_cmnd *cmnd = container_of(scp,
-							struct scsi_cmnd, SCp);
-		struct uas_dev_info *di = (void *)cmnd->device->hostdata;
-
-		if (di == devinfo) {
-			cmdinfo->state |= COMMAND_ABORTED;
-			cmdinfo->state &= ~IS_IN_WORK_LIST;
-			if (devinfo->resetting) {
-				/* uas_stat_cmplt() will not do that
-				 * when a device reset is in
-				 * progress */
-				cmdinfo->state &= ~COMMAND_INFLIGHT;
-			}
-			uas_try_complete(cmnd, __func__);
-		} else {
-			/* not our uas device, relink into list */
-			list_del(&cmdinfo->list);
-			spin_lock_irq(&uas_work_lock);
-			list_add_tail(&cmdinfo->list, &uas_work_list);
-			spin_unlock_irq(&uas_work_lock);
+		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
+						      SCp);
+		cmdinfo->state |= COMMAND_ABORTED;
+		cmdinfo->state &= ~IS_IN_WORK_LIST;
+		if (devinfo->resetting) {
+			/* uas_stat_cmplt() will not do that
+			 * when a device reset is in
+			 * progress */
+			cmdinfo->state &= ~COMMAND_INFLIGHT;
 		}
+		uas_try_complete(cmnd, __func__);
+		list_del(&cmdinfo->work);
 	}
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
+static void uas_add_work(struct uas_cmd_info *cmdinfo)
+{
+	struct scsi_pointer *scp = (void *)cmdinfo;
+	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
+	struct uas_dev_info *devinfo = cmnd->device->hostdata;
+
+	WARN_ON(!spin_is_locked(&devinfo->lock));
+	list_add_tail(&cmdinfo->work, &devinfo->work_list);
+	cmdinfo->state |= IS_IN_WORK_LIST;
+	schedule_work(&devinfo->work);
+}
+
 static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 {
 	struct sense_iu *sense_iu = urb->transfer_buffer;
@@ -288,11 +277,7 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
-		cmdinfo->state |= IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
-		schedule_work(&uas_work);
+		uas_add_work(cmdinfo);
 	}
 }
 
@@ -694,11 +679,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 			spin_unlock_irqrestore(&devinfo->lock, flags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
-		cmdinfo->state |= IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
-		schedule_work(&uas_work);
+		uas_add_work(cmdinfo);
 	}
 
 	spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -764,10 +745,8 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	spin_lock_irqsave(&devinfo->lock, flags);
 	cmdinfo->state |= COMMAND_ABORTED;
 	if (cmdinfo->state & IS_IN_WORK_LIST) {
-		spin_lock(&uas_work_lock);
-		list_del(&cmdinfo->list);
+		list_del(&cmdinfo->work);
 		cmdinfo->state &= ~IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
 	}
 	if (cmdinfo->state & COMMAND_INFLIGHT) {
 		spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -1007,6 +986,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	init_usb_anchor(&devinfo->sense_urbs);
 	init_usb_anchor(&devinfo->data_urbs);
 	spin_lock_init(&devinfo->lock);
+	INIT_WORK(&devinfo->work, uas_do_work);
+	INIT_LIST_HEAD(&devinfo->work_list);
 	uas_configure_endpoints(devinfo);
 
 	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 3);
@@ -1050,6 +1031,7 @@ static void uas_disconnect(struct usb_interface *intf)
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 
 	devinfo->resetting = 1;
+	cancel_work_sync(&devinfo->work);
 	uas_abort_work(devinfo);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
-- 
1.8.3.1

