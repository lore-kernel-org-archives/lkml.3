Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3LSPIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:19 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61493 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3LSPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:16 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Mike Christie <michaelc@cs.wisc.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: [PATCH 33/38] scsi: transport: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:47 +0100
Message-Id: <1387465612-3673-34-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Remove the kfree() as well, because the put_device() will result in
iscsi_endpoint_release being called and hence it will be kfree'd.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 63a6ca4..ff20f35 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -219,8 +219,10 @@ iscsi_create_endpoint(int dd_size)
 	ep->dev.class = &iscsi_endpoint_class;
 	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
 	err = device_register(&ep->dev);
-        if (err)
-                goto free_ep;
+        if (err) {
+        	put_device(&ep->dev);
+	        return NULL;
+	}
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -233,10 +235,6 @@ iscsi_create_endpoint(int dd_size)
 unregister_dev:
 	device_unregister(&ep->dev);
 	return NULL;
-
-free_ep:
-	kfree(ep);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
-- 
1.8.3.1

