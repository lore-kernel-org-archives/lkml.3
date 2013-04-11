Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936987Ab3DKBDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:03:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:36512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935511Ab3DKBDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,451,1363158000"; 
   d="scan'208";a="284555208"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 1/3 v7] mei: nfc: Initial nfc implementation
Date: Thu, 11 Apr 2013 03:03:29 +0200
Message-Id: <1365642211-21421-2-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
References: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFC ME device is exported through the MEI bus to be consumed by the
NFC subsystem.

NFC is represented by two mei clients: An info one and the actual
NFC one. In order to properly build the ME id we first need to retrieve
the firmware information from the info client and then disconnect from it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile  |    1 +
 drivers/misc/mei/client.c  |    3 +
 drivers/misc/mei/init.c    |    2 +
 drivers/misc/mei/mei_dev.h |   10 ++
 drivers/misc/mei/nfc.c     |  311 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 327 insertions(+)
 create mode 100644 drivers/misc/mei/nfc.c

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 3612d57..08698a4 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -11,6 +11,7 @@ mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
 mei-objs += bus.o
+mei-objs += nfc.o
 mei-$(CONFIG_DEBUG_FS) += debugfs.o
 
 obj-$(CONFIG_INTEL_MEI_ME) += mei-me.o
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index ecadd00..9541aa9 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -358,6 +358,9 @@ void mei_host_client_init(struct work_struct *work)
 			mei_amthif_host_init(dev);
 		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
 			mei_wd_host_init(dev);
+		else if (!uuid_le_cmp(client_props->protocol_name, mei_nfc_guid))
+			mei_nfc_host_init(dev);
+
 	}
 
 	dev->dev_state = MEI_DEV_ENABLED;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 54b51c0..4e102ad 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -219,6 +219,8 @@ void mei_stop(struct mei_device *dev)
 
 	mei_wd_stop(dev);
 
+	mei_nfc_host_exit();
+
 	dev->dev_state = MEI_DEV_POWER_DOWN;
 	mei_reset(dev, 0);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c02967d..cd5b6d4 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -509,6 +509,16 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 
 void mei_amthif_run_next_cmd(struct mei_device *dev);
 
+/*
+ * NFC functions
+ */
+int mei_nfc_host_init(struct mei_device *dev);
+void mei_nfc_host_exit(void);
+
+/*
+ * NFC Client UUID
+ */
+extern const uuid_le mei_nfc_guid;
 
 int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
new file mode 100644
index 0000000..37d4b09
--- /dev/null
+++ b/drivers/misc/mei/nfc.c
@@ -0,0 +1,311 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/mei_cl_bus.h>
+
+#include "mei_dev.h"
+#include "client.h"
+
+struct mei_nfc_cmd {
+	u8 command;
+	u8 status;
+	u16 req_id;
+	u32 reserved;
+	u16 data_size;
+	u8 sub_command;
+	u8 data[];
+} __packed;
+
+struct mei_nfc_reply {
+	u8 command;
+	u8 status;
+	u16 req_id;
+	u32 reserved;
+	u16 data_size;
+	u8 sub_command;
+	u8 reply_status;
+	u8 data[];
+} __packed;
+
+struct mei_nfc_if_version {
+	u8 radio_version_sw[3];
+	u8 reserved[3];
+	u8 radio_version_hw[3];
+	u8 i2c_addr;
+	u8 fw_ivn;
+	u8 vendor_id;
+	u8 radio_type;
+} __packed;
+
+struct mei_nfc_connect {
+	u8 fw_ivn;
+	u8 vendor_id;
+} __packed;
+
+struct mei_nfc_connect_resp {
+	u8 fw_ivn;
+	u8 vendor_id;
+	u16 me_major;
+	u16 me_minor;
+	u16 me_hotfix;
+	u16 me_build;
+} __packed;
+
+struct mei_nfc_hci_hdr {
+	u8 cmd;
+	u8 status;
+	u16 req_id;
+	u32 reserved;
+	u16 data_size;
+} __packed;
+
+#define MEI_NFC_CMD_MAINTENANCE 0x00
+#define MEI_NFC_CMD_HCI_SEND 0x01
+#define MEI_NFC_CMD_HCI_RECV 0x02
+
+#define MEI_NFC_SUBCMD_CONNECT    0x00
+#define MEI_NFC_SUBCMD_IF_VERSION 0x01
+
+#define MEI_NFC_HEADER_SIZE 10
+
+/** mei_nfc_dev - NFC mei device
+ *
+ * @cl: NFC host client
+ * @cl_info: NFC info host client
+ * @init_work: perform connection to the info client
+ * @fw_ivn: NFC Intervace Version Number
+ * @vendor_id: NFC manufacturer ID
+ * @radio_type: NFC radio type
+ */
+struct mei_nfc_dev {
+	struct mei_cl *cl;
+	struct mei_cl *cl_info;
+	struct work_struct init_work;
+	u8 fw_ivn;
+	u8 vendor_id;
+	u8 radio_type;
+};
+
+static struct mei_nfc_dev nfc_dev;
+
+/* UUIDs for NFC F/W clients */
+const uuid_le mei_nfc_guid = UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50,
+				     0x94, 0xd4, 0x50, 0x26,
+				     0x67, 0x23, 0x77, 0x5c);
+
+static const uuid_le mei_nfc_info_guid = UUID_LE(0xd2de1625, 0x382d, 0x417d,
+					0x48, 0xa4, 0xef, 0xab,
+					0xba, 0x8a, 0x12, 0x06);
+
+static void mei_nfc_free(struct mei_nfc_dev *ndev)
+{
+	if (ndev->cl) {
+		list_del(&ndev->cl->device_link);
+		mei_cl_unlink(ndev->cl);
+		kfree(ndev->cl);
+	}
+
+	if (ndev->cl_info) {
+		list_del(&ndev->cl_info->device_link);
+		mei_cl_unlink(ndev->cl_info);
+		kfree(ndev->cl_info);
+	}
+}
+
+static int mei_nfc_if_version(struct mei_nfc_dev *ndev)
+{
+	struct mei_device *dev;
+	struct mei_cl *cl;
+
+	struct mei_nfc_cmd cmd;
+	struct mei_nfc_reply *reply = NULL;
+	struct mei_nfc_if_version *version;
+	size_t if_version_length;
+	int bytes_recv, ret;
+
+	cl = ndev->cl_info;
+	dev = cl->dev;
+
+	memset(&cmd, 0, sizeof(struct mei_nfc_cmd));
+	cmd.command = MEI_NFC_CMD_MAINTENANCE;
+	cmd.data_size = 1;
+	cmd.sub_command = MEI_NFC_SUBCMD_IF_VERSION;
+
+	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(struct mei_nfc_cmd));
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "Could not send IF version cmd\n");
+		return ret;
+	}
+
+	/* to be sure on the stack we alloc memory */
+	if_version_length = sizeof(struct mei_nfc_reply) +
+		sizeof(struct mei_nfc_if_version);
+
+	reply = kzalloc(if_version_length, GFP_KERNEL);
+	if (!reply)
+		return -ENOMEM;
+
+	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length);
+	if (bytes_recv < 0 || bytes_recv < sizeof(struct mei_nfc_reply)) {
+		dev_err(&dev->pdev->dev, "Could not read IF version\n");
+		ret = -EIO;
+		goto err;
+	}
+
+	version = (struct mei_nfc_if_version *)reply->data;
+
+	ndev->fw_ivn = version->fw_ivn;
+	ndev->vendor_id = version->vendor_id;
+	ndev->radio_type = version->radio_type;
+
+err:
+	kfree(reply);
+	return ret;
+}
+
+static void mei_nfc_init(struct work_struct *work)
+{
+	struct mei_device *dev;
+	struct mei_nfc_dev *ndev;
+	struct mei_cl *cl_info;
+
+	ndev = container_of(work, struct mei_nfc_dev, init_work);
+
+	cl_info = ndev->cl_info;
+	dev = cl_info->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	if (mei_cl_connect(cl_info, NULL) < 0) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev,
+			"Could not connect to the NFC INFO ME client");
+
+		goto err;
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	if (mei_nfc_if_version(ndev) < 0) {
+		dev_err(&dev->pdev->dev, "Could not get the NFC interfave version");
+
+		goto err;
+	}
+
+	dev_info(&dev->pdev->dev,
+		"NFC MEI VERSION: IVN 0x%x Vendor ID 0x%x Type 0x%x\n",
+		ndev->fw_ivn, ndev->vendor_id, ndev->radio_type);
+
+	mutex_lock(&dev->device_lock);
+
+	if (mei_cl_disconnect(cl_info) < 0) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev,
+			"Could not disconnect the NFC INFO ME client");
+
+		goto err;
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	return;
+
+err:
+	mei_nfc_free(ndev);
+
+	return;
+}
+
+
+int mei_nfc_host_init(struct mei_device *dev)
+{
+	struct mei_nfc_dev *ndev = &nfc_dev;
+	struct mei_cl *cl_info, *cl = NULL;
+	int i, ret;
+
+	/* already initialzed */
+	if (ndev->cl_info)
+		return 0;
+
+	cl_info = mei_cl_allocate(dev);
+	cl = mei_cl_allocate(dev);
+
+	if (!cl || !cl_info) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* check for valid client id */
+	i = mei_me_cl_by_uuid(dev, &mei_nfc_info_guid);
+	if (i < 0) {
+		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	cl_info->me_client_id = dev->me_clients[i].client_id;
+
+	ret = mei_cl_link(cl_info, MEI_HOST_CLIENT_ID_ANY);
+	if (ret)
+		goto err;
+
+	cl_info->device_uuid = mei_nfc_info_guid;
+
+	list_add_tail(&cl_info->device_link, &dev->device_list);
+
+	/* check for valid client id */
+	i = mei_me_cl_by_uuid(dev, &mei_nfc_guid);
+	if (i < 0) {
+		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	cl->me_client_id = dev->me_clients[i].client_id;
+
+	ret = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
+	if (ret)
+		goto err;
+
+	cl->device_uuid = mei_nfc_guid;
+
+	list_add_tail(&cl->device_link, &dev->device_list);
+
+	ndev->cl_info = cl_info;
+	ndev->cl = cl;
+
+	INIT_WORK(&ndev->init_work, mei_nfc_init);
+	schedule_work(&ndev->init_work);
+
+	return 0;
+
+err:
+	mei_nfc_free(ndev);
+
+	return ret;
+}
+
+void mei_nfc_host_exit(void)
+{
+	struct mei_nfc_dev *ndev = &nfc_dev;
+
+	mei_nfc_free(ndev);
+}
-- 
1.7.10.4

