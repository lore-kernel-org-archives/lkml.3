Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaKDSZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:25:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:53915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaKDSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:25:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411324600"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc V4 3.18] mei: nfc: clean nfc internal struct on host exit
Date: Tue,  4 Nov 2014 20:24:00 +0200
Message-Id: <1415125440-27112-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFC internal structure cleaning was dropped by commit

commit 487056932d372cc4f6c636f21a928d6667b151d7
Author: Tomas Winkler <tomas.winkler@intel.com>
Date:   Mon Feb 17 15:13:19 2014 +0200

    mei: Remove all bus devices from the mei_dev list when stopping the MEI

    When stopping the MEI, we should remove and potentially unregister
    all bus devices queued on the mei_dev linked list.

We allocate nfc_dev and free it across the reset
so we do not keep it in dirty state

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
V2: allocate mei_nfc_dev dynamically
V3: Drop the stable request as manual rebase is required,
    a seperate request will be sent
V4: use upstream entry for reference for regressing commit
 

 drivers/misc/mei/bus.c     |  4 ++--
 drivers/misc/mei/mei_dev.h |  1 +
 drivers/misc/mei/nfc.c     | 42 ++++++++++++++++++++++++++++++++----------
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4d20d60ca38d..b3a72bca5242 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -140,7 +140,7 @@ static struct device_type mei_cl_device_type = {
 	.release	= mei_cl_dev_release,
 };
 
-static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_device *dev,
+struct mei_cl *mei_cl_bus_find_cl_by_uuid(struct mei_device *dev,
 						uuid_le uuid)
 {
 	struct mei_cl *cl;
@@ -160,7 +160,7 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 	struct mei_cl *cl;
 	int status;
 
-	cl = mei_bus_find_mei_cl_by_uuid(dev, uuid);
+	cl = mei_cl_bus_find_cl_by_uuid(dev, uuid);
 	if (cl == NULL)
 		return NULL;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 71744b16cc8c..1288a5cf60b9 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -349,6 +349,7 @@ void mei_cl_bus_rx_event(struct mei_cl *cl);
 void mei_cl_bus_remove_devices(struct mei_device *dev);
 int mei_cl_bus_init(void);
 void mei_cl_bus_exit(void);
+struct mei_cl *mei_cl_bus_find_cl_by_uuid(struct mei_device *dev, uuid_le uuid);
 
 
 /**
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 622654323177..82f38613c550 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -117,8 +117,6 @@ struct mei_nfc_dev {
 	u16 recv_req_id;
 };
 
-static struct mei_nfc_dev nfc_dev;
-
 /* UUIDs for NFC F/W clients */
 const uuid_le mei_nfc_guid = UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50,
 				     0x94, 0xd4, 0x50, 0x26,
@@ -138,6 +136,9 @@ static const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
 
 static void mei_nfc_free(struct mei_nfc_dev *ndev)
 {
+	if (!ndev)
+		return;
+
 	if (ndev->cl) {
 		list_del(&ndev->cl->device_link);
 		mei_cl_unlink(ndev->cl);
@@ -150,7 +151,7 @@ static void mei_nfc_free(struct mei_nfc_dev *ndev)
 		kfree(ndev->cl_info);
 	}
 
-	memset(ndev, 0, sizeof(struct mei_nfc_dev));
+	kfree(ndev);
 }
 
 static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
@@ -319,9 +320,10 @@ err:
 static int mei_nfc_enable(struct mei_cl_device *cldev)
 {
 	struct mei_device *dev;
-	struct mei_nfc_dev *ndev = &nfc_dev;
+	struct mei_nfc_dev *ndev;
 	int ret;
 
+	ndev = (struct mei_nfc_dev *)cldev->priv_data;
 	dev = ndev->cl->dev;
 
 	ret = mei_nfc_connect(ndev);
@@ -479,14 +481,16 @@ err:
 
 int mei_nfc_host_init(struct mei_device *dev)
 {
-	struct mei_nfc_dev *ndev = &nfc_dev;
+	struct mei_nfc_dev *ndev;
 	struct mei_cl *cl_info, *cl = NULL;
 	struct mei_me_client *me_cl;
 	int ret;
 
-	/* already initialized */
-	if (ndev->cl_info)
-		return 0;
+	ndev = kzalloc(sizeof(struct mei_nfc_dev), GFP_KERNEL);
+	if (!ndev) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	ndev->cl_info = mei_cl_allocate(dev);
 	ndev->cl = mei_cl_allocate(dev);
@@ -550,9 +554,27 @@ err:
 
 void mei_nfc_host_exit(struct mei_device *dev)
 {
-	struct mei_nfc_dev *ndev = &nfc_dev;
+	struct mei_nfc_dev *ndev;
+	struct mei_cl *cl;
+	struct mei_cl_device *cldev;
+
+	cl = mei_cl_bus_find_cl_by_uuid(dev, mei_nfc_guid);
+	if (!cl)
+		return;
+
+	cldev = cl->device;
+	if (!cldev)
+		return;
+
+	ndev = (struct mei_nfc_dev *)cldev->priv_data;
+	if (ndev)
+		cancel_work_sync(&ndev->init_work);
+
+	mutex_lock(&dev->device_lock);
+	mei_nfc_free(ndev);
+	mutex_unlock(&dev->device_lock);
 
-	cancel_work_sync(&ndev->init_work);
+	cldev->priv_data = NULL;
 }
 
 
-- 
1.9.3

