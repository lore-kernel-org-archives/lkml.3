Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3CNOLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:11:11 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:56886 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757300Ab3CNOKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:10:54 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hverkuil@xs4all.nl, elezegarcia@gmail.com,
        =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: [RFC V1 7/8] smi2021: Add smi2021_bl.c
Date: Thu, 14 Mar 2013 15:07:03 +0100
Message-Id: <1363270024-12127-8-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the smi2021-bootloader module.
This module will upload the firmware for the different somagic devices.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/usb/smi2021/smi2021_bl.c | 254 +++++++++++++++++++++++++++++++++
 1 file changed, 254 insertions(+)
 create mode 100644 drivers/media/usb/smi2021/smi2021_bl.c

diff --git a/drivers/media/usb/smi2021/smi2021_bl.c b/drivers/media/usb/smi2021/smi2021_bl.c
new file mode 100644
index 0000000..025b06c
--- /dev/null
+++ b/drivers/media/usb/smi2021/smi2021_bl.c
@@ -0,0 +1,254 @@
+/*******************************************************************************
+ * smi2021_bl.c								       *
+ *									       *
+ * USB Driver for SMI2021 - EasyCAP                                            *
+ * USB ID 1c88:003c                                                            *
+ *                                                                             *
+ * *****************************************************************************
+ *
+ * Copyright 2011-2013 Jon Arne Jørgensen
+ * <jonjon.arnearne--a.t--gmail.com>
+ *
+ * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
+ *
+ * This file is part of SMI2021
+ * http://code.google.com/p/easycap-somagic-linux/
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is heavily influensed by the STK1160 driver.
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include <linux/slab.h>
+
+#define FIRMWARE_CHUNK_SIZE		62
+#define FIRMWARE_HEADER_SIZE		2
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jon Arne Jørgensen <jonjon.arnearne--a.t--gmail.com>");
+MODULE_DESCRIPTION("SMI2021 - Bootloader");
+MODULE_VERSION("0.1");
+
+static unsigned int firmware_version;
+module_param(firmware_version, int, 0644);
+MODULE_PARM_DESC(firmware_version,
+			"Firmware version to be uploaded to device\n"
+			"if there are more than one firmware present");
+
+struct usb_device_id smi2021_bootloader_id_table[] = {
+	{ USB_DEVICE(0x1c88, 0x0007) },
+	{ }
+};
+
+struct smi2021_firmware {
+	int		id;
+	const char	*name;
+	int		found;
+};
+
+struct smi2021_firmware available_fw[] = {
+	{
+		.id = 0x3c,
+		.name = "smi2021_3c.bin",
+	},
+	{
+		.id = 0x3e,
+		.name = "smi2021_3e.bin",
+	},
+	{
+		.id = 0x3f,
+		.name = "smi2021_3f.bin",
+	}
+};
+
+static const struct firmware *firmware[ARRAY_SIZE(available_fw)];
+static int firmwares = -1;
+
+static int smi2021_load_firmware(struct usb_device *udev,
+					const struct firmware *firmware)
+{
+	int i, size, rc = 0;
+	u8 *chunk;
+	u16 ack = 0x0000;
+
+	if (udev == NULL)
+		goto end_out;
+
+	size = FIRMWARE_CHUNK_SIZE + FIRMWARE_HEADER_SIZE;
+	chunk = kzalloc(size, GFP_KERNEL);
+	chunk[0] = 0x05;
+	chunk[1] = 0xff;
+
+	if (chunk == NULL) {
+		dev_err(&udev->dev,
+			"could not allocate space for firmware chunk\n");
+		goto end_out;
+	}
+
+	if (firmware == NULL) {
+		dev_err(&udev->dev, "firmware is NULL\n");
+		rc = -ENODEV;
+		goto free_out;
+	}
+
+	if (firmware->size % FIRMWARE_CHUNK_SIZE) {
+		dev_err(&udev->dev, "firmware has wrong size\n");
+		rc = -ENODEV;
+		goto free_out;
+	}
+
+	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0x80), 0x01,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0x0001, 0x0000, &ack, sizeof(ack), 1000);
+
+	if (rc < 0) {
+		dev_err(&udev->dev, "could not prepare device for upload: %d\n",
+			rc);
+		goto free_out;
+	}
+	if (__cpu_to_be16(ack) != 0x0107) {
+		dev_err(&udev->dev, "could not prepare device for upload: %d\n",
+			rc);
+		goto free_out;
+	}
+
+	for (i = 0; i < firmware->size / FIRMWARE_CHUNK_SIZE; i++) {
+		memcpy(chunk + FIRMWARE_HEADER_SIZE,
+			firmware->data + (i * FIRMWARE_CHUNK_SIZE),
+			FIRMWARE_CHUNK_SIZE);
+
+		rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0x00), 0x01,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0x0005, 0x0000, chunk, size, 1000);
+		if (rc < 0) {
+			dev_err(&udev->dev, "firmware upload failed: %d\n",
+				rc);
+			goto free_out;
+		}
+	}
+
+	ack = __cpu_to_le16(0x0007);
+	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0x00), 0x01,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0x0007, 0x0000, &ack, sizeof(ack), 1000);
+
+	if (rc < 0) {
+		dev_err(&udev->dev, "device failed to ack firmware: %d\n", rc);
+		goto free_out;
+	}
+
+	rc = 0;
+
+free_out:
+	kfree(chunk);
+end_out:
+	return rc;
+}
+
+static int smi2021_choose_firmware(struct usb_device *udev)
+{
+	int i, found, id;
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		found = available_fw[i].found;
+		id = available_fw[i].id;
+		if (firmware_version == id && found >= 0) {
+			dev_info(&udev->dev, "uploading firmware for 0x%x\n",
+					id);
+			return smi2021_load_firmware(udev, firmware[found]);
+		}
+	}
+
+	dev_info(&udev->dev,
+	"could not decide what firmware to upload, user action required\n");
+	return 0;
+}
+
+static int smi2021_bootloader_probe(struct usb_interface *intf,
+					const struct usb_device_id *devid)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int rc, i;
+
+	/* Check what firmwares are available in the system */
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		dev_info(&udev->dev, "Looking for: %s\n", available_fw[i].name);
+		rc = request_firmware(&firmware[firmwares + 1],
+			available_fw[i].name, &udev->dev);
+
+		if (rc == 0) {
+			firmwares++;
+			available_fw[i].found = firmwares;
+			dev_info(&udev->dev, "Found firmware for 0x00%x\n",
+				available_fw[i].id);
+		} else if (rc == -ENOENT) {
+			available_fw[i].found = -1;
+		} else {
+			dev_err(&udev->dev,
+				"request_firmware failed with: %d\n", rc);
+			goto err_out;
+		}
+	}
+
+	if (firmwares < 0) {
+		dev_err(&udev->dev,
+			"could not find any firmware for this device\n");
+		goto no_dev;
+	} else if (firmwares == 0) {
+		rc = smi2021_load_firmware(udev, firmware[0]);
+		if (rc < 0)
+			goto err_out;
+	} else {
+		smi2021_choose_firmware(udev);
+	}
+
+	return 0;
+
+no_dev:
+	rc = -ENODEV;
+err_out:
+	return rc;
+}
+
+static void smi2021_bootloader_disconnect(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(available_fw); i++) {
+		if (available_fw[i].found >= 0) {
+			dev_info(&udev->dev, "Releasing firmware for 0x00%x\n",
+							available_fw[i].id);
+			release_firmware(firmware[available_fw[i].found]);
+			firmware[available_fw[i].found] = NULL;
+			available_fw[i].found = -1;
+		}
+	}
+	firmwares = -1;
+
+}
+
+struct usb_driver smi2021_bootloader_driver = {
+	.name		= "smi2021_bootloader",
+	.id_table	= smi2021_bootloader_id_table,
+	.probe		= smi2021_bootloader_probe,
+	.disconnect	= smi2021_bootloader_disconnect
+};
+
+module_usb_driver(smi2021_bootloader_driver);
-- 
1.8.1.1

