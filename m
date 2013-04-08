Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936552Ab3DHXmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:42:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:17403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760469Ab3DHXmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="316268333"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Date: Tue,  9 Apr 2013 02:41:33 +0300
Message-Id: <1365464495-17642-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

NFC ME device is exported through the MEI bus to be consumed by the
NFC subsystem.

NFC is represented by two mei clients: An info one and the actual
NFC one. In order to properly build the ME id we first need to retrieve
the firmware information from the info client and then disconnect from it.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile     |   1 +
 drivers/misc/mei/client.c     |   3 +
 drivers/misc/mei/init.c       |   2 +
 drivers/misc/mei/mei_dev.h    |  10 ++
 drivers/misc/mei/nfc.c        | 250 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild     |   1 +
 include/uapi/linux/mei/Kbuild |   2 +
 include/uapi/linux/mei/nfc.h  | 135 +++++++++++++++++++++++
 8 files changed, 404 insertions(+)
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 include/uapi/linux/mei/Kbuild
 create mode 100644 include/uapi/linux/mei/nfc.h

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
index 0000000..29a4e03
--- /dev/null
+++ b/drivers/misc/mei/nfc.c
@@ -0,0 +1,250 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
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
+#include <linux/mei/nfc.h>
+#include <linux/mei_cl_bus.h>
+
+#include "mei_dev.h"
+#include "client.h"
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
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 5c8a1d2..d329d63 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -6,6 +6,7 @@ header-y += dvb/
 header-y += hdlc/
 header-y += hsi/
 header-y += isdn/
+header-y += mei/
 header-y += mmc/
 header-y += nfsd/
 header-y += raid/
diff --git a/include/uapi/linux/mei/Kbuild b/include/uapi/linux/mei/Kbuild
new file mode 100644
index 0000000..a20a693
--- /dev/null
+++ b/include/uapi/linux/mei/Kbuild
@@ -0,0 +1,2 @@
+# UAPI Header export list
+header-y += nfc.h
diff --git a/include/uapi/linux/mei/nfc.h b/include/uapi/linux/mei/nfc.h
new file mode 100644
index 0000000..fe5d8aa
--- /dev/null
+++ b/include/uapi/linux/mei/nfc.h
@@ -0,0 +1,135 @@
+/******************************************************************************
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Intel MEI Interface NFC Header
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *	Intel Corporation.
+ *	linux-mei@linux.intel.com
+ *	http://www.intel.com
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#ifndef _LINUX_MEI_NFC_H
+#define _LINUX_MEI_NFC_H
+
+/* NFC commands and structures */
+
+struct mei_nfc_cmd {
+	__u8 command;
+	__u8 status;
+	__u16 req_id;
+	__u32 reserved;
+	__u16 data_size;
+	__u8 sub_command;
+	__u8 data[];
+} __packed;
+
+struct mei_nfc_reply {
+	__u8 command;
+	__u8 status;
+	__u16 req_id;
+	__u32 reserved;
+	__u16 data_size;
+	__u8 sub_command;
+	__u8 reply_status;
+	__u8 data[];
+} __packed;
+
+struct mei_nfc_if_version {
+	__u8 radio_version_sw[3];
+	__u8 reserved[3];
+	__u8 radio_version_hw[3];
+	__u8 i2c_addr;
+	__u8 fw_ivn;
+	__u8 vendor_id;
+	__u8 radio_type;
+} __packed;
+
+struct mei_nfc_connect {
+	__u8 fw_ivn;
+	__u8 vendor_id;
+} __packed;
+
+struct mei_nfc_connect_resp {
+	__u8 fw_ivn;
+	__u8 vendor_id;
+	__u16 me_major;
+	__u16 me_minor;
+	__u16 me_hotfix;
+	__u16 me_build;
+} __packed;
+
+struct mei_nfc_hci_hdr {
+	__u8 cmd;
+	__u8 status;
+	__u16 req_id;
+	__u32 reserved;
+	__u16 data_size;
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
+#define MEI_NFC_MAX_HCI_PAYLOAD 300
+
+#endif /* _LINUX_MEI_NFC_H  */
-- 
1.8.1.2

