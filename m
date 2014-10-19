Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaJSP5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:57:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:40789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaJSP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:57:38 -0400
From: Christoph Hellwig <hch@lst.de>
To: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] scsi: device handlers must have attach and detach methods
Date: Sun, 19 Oct 2014 18:00:02 +0200
Message-Id: <1413734404-1426-5-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413734404-1426-1-git-send-email-hch@lst.de>
References: <1413734404-1426-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 1a8dbf3..d8a8aac 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -108,19 +108,17 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 		return 0;
 	}
 
-	if (scsi_dh->attach) {
-		if (!try_module_get(scsi_dh->module))
-			return -EINVAL;
-
-		err = scsi_dh->attach(sdev);
-		if (err) {
-			module_put(scsi_dh->module);
-			return err;
-		}
+	if (!try_module_get(scsi_dh->module))
+		return -EINVAL;
 
-		kref_init(&sdev->scsi_dh_data->kref);
-		sdev->scsi_dh_data->sdev = sdev;
+	err = scsi_dh->attach(sdev);
+	if (err) {
+		module_put(scsi_dh->module);
+		return err;
 	}
+
+	kref_init(&sdev->scsi_dh_data->kref);
+	sdev->scsi_dh_data->sdev = sdev;
 	return err;
 }
 
@@ -154,7 +152,7 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
 	if (!scsi_dh)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 
-	if (scsi_dh && scsi_dh->detach)
+	if (scsi_dh)
 		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
 }
 
@@ -343,6 +341,9 @@ int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 	if (get_device_handler(scsi_dh->name))
 		return -EBUSY;
 
+	if (!scsi_dh->attach || !scsi_dh->detach)
+		return -EINVAL;
+
 	spin_lock(&list_lock);
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
-- 
1.9.1

