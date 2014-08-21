Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaHULeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:34:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:16491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaHULbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969491"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/14] mei: add mei_me_cl_by_uuid_id function
Date: Thu, 21 Aug 2014 14:29:15 +0300
Message-Id: <1408620563-25834-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When handling dynamic clients there might be a race
scenario in which two me clients with the same me
address would be linked in the me clients list,
therefore we need to search by both uuid and me address.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |  1 +
 drivers/misc/mei/bus.c     |  4 ++--
 drivers/misc/mei/client.c  | 14 +++++++++++++-
 drivers/misc/mei/client.h  |  4 ++++
 drivers/misc/mei/main.c    |  3 ++-
 drivers/misc/mei/mei_dev.h |  2 +-
 drivers/misc/mei/nfc.c     |  6 ++----
 drivers/misc/mei/wd.c      |  1 +
 8 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index c1fc6dd..4114758 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -83,6 +83,7 @@ int mei_amthif_host_init(struct mei_device *dev)
 	}
 
 	cl->me_client_id = me_cl->client_id;
+	cl->cl_uuid = me_cl->props.protocol_name;
 
 	/* Assign iamthif_mtu to the value received from ME  */
 
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index c829676..09dad2d 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -147,7 +147,7 @@ static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_device *dev,
 	struct mei_cl *cl;
 
 	list_for_each_entry(cl, &dev->device_list, device_link) {
-		if (!uuid_le_cmp(uuid, cl->device_uuid))
+		if (!uuid_le_cmp(uuid, cl->cl_uuid))
 			return cl;
 	}
 
@@ -242,7 +242,7 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 		return -ENODEV;
 
 	/* Check if we have an ME client device */
-	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
 	if (!me_cl)
 		return -ENOTTY;
 
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 4dbcd92..1fb23e8 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -69,6 +69,18 @@ struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 	return NULL;
 }
 
+struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
+					   const uuid_le *uuid, u8 client_id)
+{
+	struct mei_me_client *me_cl;
+
+	list_for_each_entry(me_cl, &dev->me_clients, list)
+		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0 &&
+		    me_cl->client_id == client_id)
+			return me_cl;
+	return NULL;
+}
+
 /**
  * mei_me_cl_remove - remove me client matching uuid and client_id
  *
@@ -753,7 +765,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		cl_dbg(dev, cl, "read is pending.\n");
 		return -EBUSY;
 	}
-	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
 	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return  -ENOTTY;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 8871a85..f5d03d6 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -27,6 +27,10 @@
 struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 					const uuid_le *cuuid);
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
+
+struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
+					   const uuid_le *uuid, u8 client_id);
+
 void mei_me_cl_remove(struct mei_device *dev,
 		      const uuid_le *uuid, u8 client_id);
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index a65b7cc..957f44a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -321,7 +321,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
 	if (!me_cl) {
 		rets = -ENOTTY;
 		goto out;
@@ -459,6 +459,7 @@ static int mei_ioctl_connect_client(struct file *file,
 	}
 
 	cl->me_client_id = me_cl->client_id;
+	cl->cl_uuid = me_cl->props.protocol_name;
 
 	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
 			cl->me_client_id);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 76d8aa3..9f684b9 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -212,6 +212,7 @@ struct mei_cl {
 	wait_queue_head_t wait;
 	int status;
 	/* ID of client connected */
+	uuid_le cl_uuid;
 	u8 host_client_id;
 	u8 me_client_id;
 	u8 mei_flow_ctrl_creds;
@@ -223,7 +224,6 @@ struct mei_cl {
 	/* MEI CL bus data */
 	struct mei_cl_device *device;
 	struct list_head device_link;
-	uuid_le device_uuid;
 };
 
 /** struct mei_hw_ops
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 964b4c6..e0e75d4 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -507,12 +507,12 @@ int mei_nfc_host_init(struct mei_device *dev)
 	}
 
 	cl_info->me_client_id = me_cl->client_id;
+	cl_info->cl_uuid = me_cl->props.protocol_name;
 
 	ret = mei_cl_link(cl_info, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
 		goto err;
 
-	cl_info->device_uuid = mei_nfc_info_guid;
 
 	list_add_tail(&cl_info->device_link, &dev->device_list);
 
@@ -525,14 +525,12 @@ int mei_nfc_host_init(struct mei_device *dev)
 	}
 
 	cl->me_client_id = me_cl->client_id;
+	cl->cl_uuid = me_cl->props.protocol_name;
 
 	ret = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
 		goto err;
 
-	cl->device_uuid = mei_nfc_guid;
-
-
 	list_add_tail(&cl->device_link, &dev->device_list);
 
 	ndev->req_id = 1;
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 8b241ee..40f46e4 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -76,6 +76,7 @@ int mei_wd_host_init(struct mei_device *dev)
 	}
 
 	cl->me_client_id = me_cl->client_id;
+	cl->cl_uuid = me_cl->props.protocol_name;
 
 	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
 
-- 
1.9.3

