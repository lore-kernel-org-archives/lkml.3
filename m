Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3IBL0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616Ab3IBL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:26:08 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org (open list:USB ATTACHED SCSI),
        usb-storage@lists.one-eyed-alien.net (open list:USB MASS STORAGE...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/5] uas: properly reinitialize in uas_eh_bus_reset_handler
Date: Mon,  2 Sep 2013 13:25:26 +0200
Message-Id: <1378121129-32594-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
References: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index d966b59..f89202f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -85,6 +85,8 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 				struct uas_dev_info *devinfo, gfp_t gfp);
 static void uas_do_work(struct work_struct *work);
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
+static void uas_configure_endpoints(struct uas_dev_info *devinfo);
+static void uas_free_streams(struct uas_dev_info *devinfo);
 
 static DECLARE_WORK(uas_work, uas_do_work);
 static DEFINE_SPINLOCK(uas_work_lock);
@@ -800,7 +802,11 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
+	uas_free_streams(devinfo);
 	err = usb_reset_device(udev);
+	if (!err) {
+		uas_configure_endpoints(devinfo);
+	}
 	devinfo->resetting = 0;
 
 	if (err) {
-- 
1.8.3.1

