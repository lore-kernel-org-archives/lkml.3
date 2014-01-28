Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaA1XXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:23:21 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46489 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaA1XWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:08 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH 09/11] scsi: use device_remove_file_self() instead of device_schedule_callback()
Date: Tue, 28 Jan 2014 18:21:49 -0500
Message-Id: <1390951311-15325-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver-core now supports synchrnous self-deletion of attributes and
the asynchrnous removal mechanism is scheduled for removal.  Use it
instead of device_schedule_callback().  This makes "delete" behave
synchronously.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_sysfs.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..8ead24c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -649,23 +649,12 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
-static void sdev_store_delete_callback(struct device *dev)
-{
-	scsi_remove_device(to_scsi_device(dev));
-}
-
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int rc;
-
-	/* An attribute cannot be unregistered by one of its own methods,
-	 * so we have to use this roundabout approach.
-	 */
-	rc = device_schedule_callback(dev, sdev_store_delete_callback);
-	if (rc)
-		count = rc;
+	if (device_remove_file_self(dev, attr))
+		scsi_remove_device(to_scsi_device(dev));
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
-- 
1.8.5.3

