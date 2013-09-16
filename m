Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3IPUqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:7255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab3IPUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571800"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/7] mei: revamp open handler counts
Date: Mon, 16 Sep 2013 23:44:47 +0300
Message-Id: <1379364288-16374-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make open counter to be incremented and decremented
from mei_cl_link and mei_cl_unlik function respectively

Nfc was assuming symmetric linking API and thus open handler
count was never decreased. This patch fixes that.
We need to add separate open hander count for amthif which
is handled out of link/unlink functions and doesn't break
the symmetric API.

Last we do not waste clients slots if amthif or wd are not present
in the device. we don't need to allocates slots ahead
it is all covered by link/unlink before the devices is responding
to user space connection and thus not racing on allocation

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |  5 +++--
 drivers/misc/mei/client.c  | 19 +++++++++++++++----
 drivers/misc/mei/init.c    |  5 -----
 drivers/misc/mei/main.c    |  6 +-----
 drivers/misc/mei/mei_dev.h |  1 +
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 226c3f3..4f259d4 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -58,6 +58,7 @@ void mei_amthif_reset_params(struct mei_device *dev)
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 	dev->iamthif_timer = 0;
 	dev->iamthif_stall_timer = 0;
+	dev->iamthif_open_count = 0;
 }
 
 /**
@@ -731,8 +732,8 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 */
 int mei_amthif_release(struct mei_device *dev, struct file *file)
 {
-	if (dev->open_handle_count > 0)
-		dev->open_handle_count--;
+	if (dev->iamthif_open_count > 0)
+		dev->iamthif_open_count--;
 
 	if (dev->iamthif_file_object == file &&
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index f62bf76..37ed142 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -275,6 +275,7 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 int mei_cl_link(struct mei_cl *cl, int id)
 {
 	struct mei_device *dev;
+	long open_handle_count;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
@@ -291,7 +292,8 @@ int mei_cl_link(struct mei_cl *cl, int id)
 		return -EMFILE;
 	}
 
-	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
+	open_handle_count = dev->open_handle_count + dev->iamthif_open_count;
+	if (open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
 		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
 			MEI_MAX_OPEN_HANDLE_COUNT);
 		return -EMFILE;
@@ -331,6 +333,17 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 	cl_dbg(dev, cl, "unlink client");
 
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
+
+	/* never clear the 0 bit */
+	if (cl->host_client_id)
+		clear_bit(cl->host_client_id, dev->host_clients_map);
+
+	list_del_init(&cl->link);
+
+	cl->state = MEI_FILE_INITIALIZING;
+
 	list_del_init(&cl->link);
 
 	return 0;
@@ -352,10 +365,8 @@ void mei_host_client_init(struct work_struct *work)
 	/*
 	 * Reserving the first three client IDs
 	 * 0: Reserved for MEI Bus Message communications
-	 * 1: Reserved for Watchdog
-	 * 2: Reserved for AMTHI
 	 */
-	bitmap_set(dev->host_clients_map, 0, 3);
+	bitmap_set(dev->host_clients_map, 0, 1);
 
 	for (i = 0; i < dev->me_clients_num; i++) {
 		client_props = &dev->me_clients[i].props;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index eca24df..bcb4a6b 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -166,12 +166,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		/* remove entry if already in list */
 		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
 		mei_cl_unlink(&dev->wd_cl);
-		if (dev->open_handle_count > 0)
-			dev->open_handle_count--;
 		mei_cl_unlink(&dev->iamthif_cl);
-		if (dev->open_handle_count > 0)
-			dev->open_handle_count--;
-
 		mei_amthif_reset_params(dev);
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 	}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 87ab5ca..9661a81 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -141,10 +141,6 @@ static int mei_release(struct inode *inode, struct file *file)
 	    cl->host_client_id,
 	    cl->me_client_id);
 
-	if (dev->open_handle_count > 0) {
-		clear_bit(cl->host_client_id, dev->host_clients_map);
-		dev->open_handle_count--;
-	}
 	mei_cl_unlink(cl);
 
 
@@ -498,11 +494,11 @@ static int mei_ioctl_connect_client(struct file *file,
 			rets = -ENODEV;
 			goto end;
 		}
-		clear_bit(cl->host_client_id, dev->host_clients_map);
 		mei_cl_unlink(cl);
 
 		kfree(cl);
 		cl = NULL;
+		dev->iamthif_open_count++;
 		file->private_data = &dev->iamthif_cl;
 
 		client = &data->out_client_properties;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 456b322..406f68e 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -414,6 +414,7 @@ struct mei_device {
 	struct file *iamthif_file_object;
 	struct mei_cl iamthif_cl;
 	struct mei_cl_cb *iamthif_current_cb;
+	long iamthif_open_count;
 	int iamthif_mtu;
 	unsigned long iamthif_timer;
 	u32 iamthif_stall_timer;
-- 
1.8.3.1

