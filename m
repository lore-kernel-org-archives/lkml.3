Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3IPErR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:47:17 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:37530
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3IPErQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:47:16 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, vojtech@suse.cz, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V synthetic keyboard
Date: Sun, 15 Sep 2013 22:28:54 -0700
Message-Id: <1379309334-25042-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new driver to support synthetic keyboard. On the next generation
Hyper-V guest firmware, many legacy devices will not be emulated and this
driver will be required.

I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
details of the AT keyboard driver. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/input/serio/Kconfig           |    7 +
 drivers/input/serio/Makefile          |    1 +
 drivers/input/serio/hyperv-keyboard.c |  379 +++++++++++++++++++++++++++++++++
 3 files changed, 387 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/hyperv-keyboard.c

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 1e691a3..f3996e7 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -267,4 +267,11 @@ config SERIO_OLPC_APSP
 	  To compile this driver as a module, choose M here: the module will
 	  be called olpc_apsp.
 
+config HYPERV_KEYBOARD
+	tristate "Microsoft Synthetic Keyboard driver"
+	depends on HYPERV
+	default HYPERV
+	help
+	  Select this option to enable the Hyper-V Keyboard driver.
+
 endif
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index 12298b1..815d874 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_SERIO_ALTERA_PS2)	+= altera_ps2.o
 obj-$(CONFIG_SERIO_ARC_PS2)	+= arc_ps2.o
 obj-$(CONFIG_SERIO_APBPS2)	+= apbps2.o
 obj-$(CONFIG_SERIO_OLPC_APSP)	+= olpc_apsp.o
+obj-$(CONFIG_HYPERV_KEYBOARD)	+= hyperv-keyboard.o
diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
new file mode 100644
index 0000000..0d4625f
--- /dev/null
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -0,0 +1,379 @@
+/*
+ *  Copyright (c) 2013, Microsoft Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms and conditions of the GNU General Public License,
+ *  version 2, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *  more details.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/completion.h>
+#include <linux/hyperv.h>
+#include <linux/serio.h>
+#include <linux/slab.h>
+
+
+/*
+ * Current version 1.0
+ *
+ */
+#define SYNTH_KBD_VERSION_MAJOR 1
+#define SYNTH_KBD_VERSION_MINOR	0
+#define SYNTH_KBD_VERSION		(SYNTH_KBD_VERSION_MINOR | \
+					 (SYNTH_KBD_VERSION_MAJOR << 16))
+
+
+/*
+ * Message types in the synthetic input protocol
+ */
+enum synth_kbd_msg_type {
+	SYNTH_KBD_PROTOCOL_REQUEST = 1,
+	SYNTH_KBD_PROTOCOL_RESPONSE = 2,
+	SYNTH_KBD_EVENT = 3,
+	SYNTH_KBD_LED_INDICATORS = 4,
+};
+
+/*
+ * Basic message structures.
+ */
+struct synth_kbd_msg_hdr {
+	enum synth_kbd_msg_type type;
+};
+
+struct synth_kbd_msg {
+	struct synth_kbd_msg_hdr header;
+	char data[1]; /* Enclosed message */
+};
+
+union synth_kbd_version {
+	struct {
+		u16 minor_version;
+		u16 major_version;
+	};
+	u32 version;
+};
+
+/*
+ * Protocol messages
+ */
+struct synth_kbd_protocol_request {
+	struct synth_kbd_msg_hdr header;
+	union synth_kbd_version version_requested;
+};
+
+struct synth_kbd_protocol_response {
+	struct synth_kbd_msg_hdr header;
+	u32 accepted:1;
+	u32 reserved:31;
+};
+
+struct synth_kbd_keystroke {
+	struct synth_kbd_msg_hdr header;
+	u16 make_code;
+	u16 reserved0;
+	u32 is_unicode:1;
+	u32 is_break:1;
+	u32 is_e0:1;
+	u32 is_e1:1;
+	u32 reserved:28;
+};
+
+
+#define HK_MAXIMUM_MESSAGE_SIZE 256
+
+#define KBD_VSC_SEND_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
+#define KBD_VSC_RECV_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
+
+#define XTKBD_EMUL0     0xe0
+#define XTKBD_EMUL1     0xe1
+#define XTKBD_RELEASE   0x80
+
+
+/*
+ * Represents a keyboard device
+ */
+struct hv_kbd_dev {
+	unsigned char keycode[256];
+	struct hv_device	*device;
+	struct synth_kbd_protocol_request protocol_req;
+	struct synth_kbd_protocol_response protocol_resp;
+	/* Synchronize the request/response if needed */
+	struct completion	wait_event;
+	struct serio		*hv_serio;
+};
+
+
+static struct hv_kbd_dev *hv_kbd_alloc_device(struct hv_device *device)
+{
+	struct hv_kbd_dev *kbd_dev;
+	struct serio	*hv_serio;
+
+	kbd_dev = kzalloc(sizeof(struct hv_kbd_dev), GFP_KERNEL);
+
+	if (!kbd_dev)
+		return NULL;
+
+	hv_serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+
+	if (hv_serio == NULL) {
+		kfree(kbd_dev);
+		return NULL;
+	}
+
+	hv_serio->id.type	= SERIO_8042_XL;
+	strlcpy(hv_serio->name, dev_name(&device->device),
+		sizeof(hv_serio->name));
+	strlcpy(hv_serio->phys, dev_name(&device->device),
+		sizeof(hv_serio->phys));
+	hv_serio->dev.parent  = &device->device;
+
+
+	kbd_dev->device = device;
+	kbd_dev->hv_serio = hv_serio;
+	hv_set_drvdata(device, kbd_dev);
+	init_completion(&kbd_dev->wait_event);
+
+	return kbd_dev;
+}
+
+static void hv_kbd_free_device(struct hv_kbd_dev *device)
+{
+	serio_unregister_port(device->hv_serio);
+	kfree(device->hv_serio);
+	hv_set_drvdata(device->device, NULL);
+	kfree(device);
+}
+
+static void hv_kbd_on_receive(struct hv_device *device,
+				struct vmpacket_descriptor *packet)
+{
+	struct synth_kbd_msg *msg;
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
+	struct synth_kbd_keystroke *ks_msg;
+	u16 scan_code;
+
+	msg = (struct synth_kbd_msg *)((unsigned long)packet +
+					(packet->offset8 << 3));
+
+	switch (msg->header.type) {
+	case SYNTH_KBD_PROTOCOL_RESPONSE:
+		memcpy(&kbd_dev->protocol_resp, msg,
+			sizeof(struct synth_kbd_protocol_response));
+		complete(&kbd_dev->wait_event);
+		break;
+	case SYNTH_KBD_EVENT:
+		ks_msg = (struct synth_kbd_keystroke *)msg;
+		scan_code = ks_msg->make_code;
+
+		/*
+		 * Inject the information through the serio interrupt.
+		 */
+		if (ks_msg->is_e0)
+			serio_interrupt(kbd_dev->hv_serio, XTKBD_EMUL0, 0);
+		serio_interrupt(kbd_dev->hv_serio,
+				scan_code | (ks_msg->is_break ?
+				XTKBD_RELEASE : 0),
+				0);
+
+		break;
+
+	default:
+		pr_err("unhandled message type %d\n", msg->header.type);
+	}
+}
+
+static void hv_kbd_on_channel_callback(void *context)
+{
+	const int packet_size = 0x100;
+	int ret;
+	struct hv_device *device = context;
+	u32 bytes_recvd;
+	u64 req_id;
+	struct vmpacket_descriptor *desc;
+	unsigned char	*buffer;
+	int	bufferlen = packet_size;
+
+	buffer = kmalloc(bufferlen, GFP_ATOMIC);
+	if (!buffer)
+		return;
+
+	do {
+		ret = vmbus_recvpacket_raw(device->channel, buffer,
+					bufferlen, &bytes_recvd, &req_id);
+
+		switch (ret) {
+		case 0:
+			if (bytes_recvd <= 0) {
+				kfree(buffer);
+				return;
+			}
+			desc = (struct vmpacket_descriptor *)buffer;
+
+			switch (desc->type) {
+			case VM_PKT_COMP:
+				break;
+
+			case VM_PKT_DATA_INBAND:
+				hv_kbd_on_receive(device, desc);
+				break;
+
+			default:
+				pr_err("unhandled packet type %d, tid %llx len %d\n",
+					desc->type, req_id, bytes_recvd);
+				break;
+			}
+
+			break;
+
+		case -ENOBUFS:
+			kfree(buffer);
+			/* Handle large packet */
+			bufferlen = bytes_recvd;
+			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
+
+			if (!buffer)
+				return;
+
+			break;
+		}
+	} while (1);
+
+}
+
+static int hv_kbd_connect_to_vsp(struct hv_device *device)
+{
+	int ret = 0;
+	int t;
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
+	struct synth_kbd_protocol_request *request;
+	struct synth_kbd_protocol_response *response;
+
+	request = &kbd_dev->protocol_req;
+	memset(request, 0, sizeof(struct synth_kbd_protocol_request));
+
+	request->header.type = SYNTH_KBD_PROTOCOL_REQUEST;
+	request->version_requested.version = SYNTH_KBD_VERSION;
+
+	ret = vmbus_sendpacket(device->channel, request,
+				sizeof(struct synth_kbd_protocol_request),
+				(unsigned long)request,
+				VM_PKT_DATA_INBAND,
+				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret)
+		goto cleanup;
+
+	t = wait_for_completion_timeout(&kbd_dev->wait_event, 10 * HZ);
+	if (!t) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	response = &kbd_dev->protocol_resp;
+
+	if (!response->accepted) {
+		pr_err("synth_kbd protocol request failed (version %d)\n",
+		       SYNTH_KBD_VERSION);
+		ret = -ENODEV;
+		goto cleanup;
+	}
+
+
+cleanup:
+	return ret;
+}
+
+static int hv_kbd_probe(struct hv_device *device,
+			const struct hv_vmbus_device_id *dev_id)
+{
+	int ret;
+	struct hv_kbd_dev *kbd_dev;
+
+	kbd_dev = hv_kbd_alloc_device(device);
+
+	if (!kbd_dev)
+		return -ENOMEM;
+
+	ret = vmbus_open(device->channel,
+		KBD_VSC_SEND_RING_BUFFER_SIZE,
+		KBD_VSC_RECV_RING_BUFFER_SIZE,
+		NULL,
+		0,
+		hv_kbd_on_channel_callback,
+		device
+		);
+
+	if (ret)
+		goto probe_err0;
+
+	ret = hv_kbd_connect_to_vsp(device);
+
+	if (ret)
+		goto probe_err1;
+
+	serio_register_port(kbd_dev->hv_serio);
+
+	return ret;
+
+probe_err1:
+	vmbus_close(device->channel);
+
+probe_err0:
+	hv_kbd_free_device(kbd_dev);
+
+	return ret;
+}
+
+
+static int hv_kbd_remove(struct hv_device *dev)
+{
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(dev);
+
+	vmbus_close(dev->channel);
+	hv_kbd_free_device(kbd_dev);
+	return 0;
+}
+
+/*
+ * Keyboard GUID
+ * {f912ad6d-2b17-48ea-bd65-f927a61c7684}
+ */
+#define HV_KBD_GUID \
+	.guid = { \
+			0x6d, 0xad, 0x12, 0xf9, 0x17, 0x2b, 0xea, 0x48, \
+			0xbd, 0x65, 0xf9, 0x27, 0xa6, 0x1c, 0x76, 0x84 \
+	}
+
+static const struct hv_vmbus_device_id id_table[] = {
+	/* Keyboard guid */
+	{ HV_KBD_GUID, },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(vmbus, id_table);
+
+static struct  hv_driver hv_kbd_drv = {
+	.name = KBUILD_MODNAME,
+	.id_table = id_table,
+	.probe = hv_kbd_probe,
+	.remove = hv_kbd_remove,
+};
+
+static int __init hv_kbd_init(void)
+{
+	return vmbus_driver_register(&hv_kbd_drv);
+}
+
+static void __exit hv_kbd_exit(void)
+{
+	vmbus_driver_unregister(&hv_kbd_drv);
+}
+
+MODULE_LICENSE("GPL");
+module_init(hv_kbd_init);
+module_exit(hv_kbd_exit);
-- 
1.7.4.1

