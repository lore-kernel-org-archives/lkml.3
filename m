Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbaLBGNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 01:13:50 -0500
Received: from m50-135.163.com ([123.125.50.135]:39283 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbaLBGNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 01:13:49 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 01:13:47 EST
Message-ID: <547D54FC.3080202@163.com>
Date: Tue, 02 Dec 2014 13:58:20 +0800
From: Huang Bo <huangbobupt@163.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/1] HID: add BETOP game controller force feedback support
References: <54768284.4060201@163.com> <alpine.LNX.2.00.1411271004260.23174@pobox.suse.cz> <5477CDD4.8000908@163.com> <alpine.LNX.2.00.1412012111020.2524@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412012111020.2524@pobox.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------040801050903080606070907"
X-CM-TRANSID: D9GowACn1RoBVX1UC_QsAw--.706S3
X-Coremail-Antispam: 1Uf129KBjvJXoW3JryDGFyDurykWFy3Zr1kKrg_yoW3Kr1rpa
	9xJrZIy3yDAry7KrW8tw1DCF98Zws7J340gFW7Cw1F9F15Aa95Xrn3t3y0yry5JrZ5K3y7
	ur18G3y5Cayrt3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07USiihUUUUU=
X-Originating-IP: [123.126.33.253]
X-CM-SenderInfo: xkxd0wpere31rw6rljoofrz/xtbBoh5W-FD+lZ+oBwAAsd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040801050903080606070907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/02/2014 04:11 AM, Jiri Kosina wrote:
> On Fri, 28 Nov 2014, Huang Bo wrote:
>
>> On 11/27/2014 05:05 PM, Jiri Kosina wrote:
>>> except ...
>> thanks firstly.
>> 1. tested the BETOP2185 gamecontroller, it really not need it.
>> 2. check with engineers of Betop, they design only one report descriptor.
>>
>> so I modify it.
> Thanks, but please put the comment into the code (jus before you are 
> zeroing the fields), so that it's immediately obvious to everybody who is 
> reading the code.
>
> Other than that, I am OK with the patch and will be applying it once you 
> resend it with the comments added.
>
> Thanks,
>
From: Huang Bo <huangbobupt@163.com>

Adds force feedback support for BETOP USB game controllers.
These devices are mass produced in China.

Signed-off-by: Huang Bo <huangbobupt@163.com>
---
 drivers/hid/Kconfig       |   10 +++
 drivers/hid/Makefile      |    1 +
 drivers/hid/hid-betopff.c |  160 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c    |    4 ++
 drivers/hid/hid-ids.h     |    5 ++
 5 files changed, 180 insertions(+)
 create mode 100644 drivers/hid/hid-betopff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4938bd3..3b4c47d 100755
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -146,6 +146,16 @@ config HID_BELKIN
     ---help---
     Support for Belkin Flip KVM and Wireless keyboard.
 
+config HID_BETOP_FF
+    tristate "Betop Production Inc. force feedback support"
+    depends on USB_HID
+    select INPUT_FF_MEMLESS
+    ---help---
+    Say Y here if you want to enable force feedback support for devices by
+    BETOP Production Ltd.
+    Currently the following devices are known to be supported:
+     - BETOP 2185 PC & BFM MODE
+
 config HID_CHERRY
     tristate "Cherry Cymotion keyboard" if EXPERT
     depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 4113999..edd4825 100755
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_HID_APPLE)        += hid-apple.o
 obj-$(CONFIG_HID_APPLEIR)    += hid-appleir.o
 obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
 obj-$(CONFIG_HID_BELKIN)    += hid-belkin.o
+obj-$(CONFIG_HID_BETOP_FF)    += hid-betopff.o
 obj-$(CONFIG_HID_CHERRY)    += hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)    += hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)    += hid-cypress.o
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
new file mode 100644
index 0000000..69cfc8d
--- /dev/null
+++ b/drivers/hid/hid-betopff.c
@@ -0,0 +1,160 @@
+/*
+ *  Force feedback support for Betop based devices
+ *
+ *  The devices are distributed under various names and the same USB device ID
+ *  can be used in both adapters and actual game controllers.
+ *
+ *  0x11c2:0x2208 "BTP2185 BFM mode Joystick"
+ *   - tested with BTP2185 BFM Mode.
+ *
+ *  0x11C0:0x5506 "BTP2185 PC mode Joystick"
+ *   - tested with BTP2185 PC Mode.
+ *
+ *  0x8380:0x1850 "BTP2185 V2 PC mode USB Gamepad"
+ *   - tested with BTP2185 PC Mode with another version.
+ *
+ *  0x20bc:0x5500 "BTP2185 V2 BFM mode Joystick"
+ *   - tested with BTP2171s.
+ *  Copyright (c) 2014 Huang Bo <huangbobupt@163.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/hid.h>
+
+#include "hid-ids.h"
+
+struct betopff_device {
+    struct hid_report *report;
+};
+
+static int hid_betopff_play(struct input_dev *dev, void *data,
+             struct ff_effect *effect)
+{
+    struct hid_device *hid = input_get_drvdata(dev);
+    struct betopff_device *betopff = data;
+    __u16 left, right;
+
+    left = effect->u.rumble.strong_magnitude;
+    right = effect->u.rumble.weak_magnitude;
+
+    betopff->report->field[2]->value[0] = left / 256;
+    betopff->report->field[3]->value[0] = right / 256;
+
+    hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+    return 0;
+}
+
+static int betopff_init(struct hid_device *hid)
+{
+    struct betopff_device *betopff;
+    struct hid_report *report;
+    struct hid_input *hidinput =
+            list_first_entry(&hid->inputs, struct hid_input, list);
+    struct list_head *report_list =
+            &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+    struct input_dev *dev = hidinput->input;
+    int field_count = 0;
+    int error;
+    int i, j;
+
+    if (list_empty(report_list)) {
+        hid_err(hid, "no output reports found\n");
+        return -ENODEV;
+    }
+
+    report = list_first_entry(report_list, struct hid_report, list);
+    /*
+     * Actually there are 4 fields for 4 Bytes as below:
+     * -----------------------------------------
+     * Byte0  Byte1  Byte2      Byte3
+     * 0x00   0x00   left_motor right_motor
+     * -----------------------------------------
+     * Do init them with default value.
+     */
+    for (i = 0; i < report->maxfield; i++) {
+        for (j = 0; j < report->field[i]->report_count; j++) {
+            report->field[i]->value[j] = 0x00;
+            field_count++;
+        }
+    }
+
+    if (field_count < 4) {
+        hid_err(hid, "not enough fields in the report: %d\n",
+                field_count);
+        return -ENODEV;
+    }
+
+    betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
+    if (!betopff)
+        return -ENOMEM;
+
+    set_bit(FF_RUMBLE, dev->ffbit);
+
+    error = input_ff_create_memless(dev, betopff, hid_betopff_play);
+    if (error) {
+        kfree(betopff);
+        return error;
+    }
+
+    betopff->report = report;
+    hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+    hid_info(hid, "Force feedback for betop devices by huangbo <huangbobupt@163.com>\n");
+
+    return 0;
+}
+
+static int betop_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+    int ret;
+
+    if (id->driver_data)
+        hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+
+    ret = hid_parse(hdev);
+    if (ret) {
+        hid_err(hdev, "parse failed\n");
+        goto err;
+    }
+
+    ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+    if (ret) {
+        hid_err(hdev, "hw start failed\n");
+        goto err;
+    }
+
+    betopff_init(hdev);
+
+    return 0;
+err:
+    return ret;
+}
+
+static const struct hid_device_id betop_devices[] = {
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
+    { }
+};
+MODULE_DEVICE_TABLE(hid, betop_devices);
+
+static struct hid_driver betop_driver = {
+    .name = "betop",
+    .id_table = betop_devices,
+    .probe = betop_probe,
+};
+module_hid_driver(betop_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a622590..e64ccfc 100755
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1642,6 +1642,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
     { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
     { HID_USB_DEVICE(USB_VENDOR_ID_AUREAL, USB_DEVICE_ID_AUREAL_W01RN) },
     { HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
     { HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
     { HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
     { HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 161ee89..c432be9 100755
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -185,6 +185,11 @@
 #define USB_VENDOR_ID_BERKSHIRE        0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD    0x1140
 
+#define USB_VENDOR_ID_BETOP_2185BFM    0x11c2
+#define USB_VENDOR_ID_BETOP_2185PC    0x11c0
+#define USB_VENDOR_ID_BETOP_2185V2PC    0x8380
+#define USB_VENDOR_ID_BETOP_2185V2BFM    0x20bc
+
 #define USB_VENDOR_ID_BTC        0x046e
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE    0x5578
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE_2    0x5577
-- 
1.7.9.5


--------------040801050903080606070907
Content-Type: text/x-patch;
 name="0001-HID-add-BETOP-game-controller-force-feedback-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-HID-add-BETOP-game-controller-force-feedback-support.pa";
 filename*1="tch"

>From b362f0b16c2376103237931307f927eca32219b3 Mon Sep 17 00:00:00 2001
From: Huang Bo <huangbobupt@163.com>
Date: Wed, 26 Nov 2014 18:21:03 +0800
Subject: [PATCH] HID: add BETOP game controller force feedback support

Adds force feedback support for BETOP USB game controllers.
These devices are mass produced in China.

Signed-off-by: Huang Bo <huangbobupt@163.com>
---
 drivers/hid/Kconfig       |   10 +++
 drivers/hid/Makefile      |    1 +
 drivers/hid/hid-betopff.c |  160 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c    |    4 ++
 drivers/hid/hid-ids.h     |    5 ++
 5 files changed, 180 insertions(+)
 create mode 100644 drivers/hid/hid-betopff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4938bd3..3b4c47d 100755
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -146,6 +146,16 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
+config HID_BETOP_FF
+	tristate "Betop Production Inc. force feedback support"
+	depends on USB_HID
+	select INPUT_FF_MEMLESS
+	---help---
+	Say Y here if you want to enable force feedback support for devices by
+	BETOP Production Ltd.
+	Currently the following devices are known to be supported:
+	 - BETOP 2185 PC & BFM MODE
+
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 4113999..edd4825 100755
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_APPLEIR)	+= hid-appleir.o
 obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BETOP_FF)	+= hid-betopff.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
new file mode 100644
index 0000000..69cfc8d
--- /dev/null
+++ b/drivers/hid/hid-betopff.c
@@ -0,0 +1,160 @@
+/*
+ *  Force feedback support for Betop based devices
+ *
+ *  The devices are distributed under various names and the same USB device ID
+ *  can be used in both adapters and actual game controllers.
+ *
+ *  0x11c2:0x2208 "BTP2185 BFM mode Joystick"
+ *   - tested with BTP2185 BFM Mode.
+ *
+ *  0x11C0:0x5506 "BTP2185 PC mode Joystick"
+ *   - tested with BTP2185 PC Mode.
+ *
+ *  0x8380:0x1850 "BTP2185 V2 PC mode USB Gamepad"
+ *   - tested with BTP2185 PC Mode with another version.
+ *
+ *  0x20bc:0x5500 "BTP2185 V2 BFM mode Joystick"
+ *   - tested with BTP2171s.
+ *  Copyright (c) 2014 Huang Bo <huangbobupt@163.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/hid.h>
+
+#include "hid-ids.h"
+
+struct betopff_device {
+	struct hid_report *report;
+};
+
+static int hid_betopff_play(struct input_dev *dev, void *data,
+			 struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct betopff_device *betopff = data;
+	__u16 left, right;
+
+	left = effect->u.rumble.strong_magnitude;
+	right = effect->u.rumble.weak_magnitude;
+
+	betopff->report->field[2]->value[0] = left / 256;
+	betopff->report->field[3]->value[0] = right / 256;
+
+	hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+	return 0;
+}
+
+static int betopff_init(struct hid_device *hid)
+{
+	struct betopff_device *betopff;
+	struct hid_report *report;
+	struct hid_input *hidinput =
+			list_first_entry(&hid->inputs, struct hid_input, list);
+	struct list_head *report_list =
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct input_dev *dev = hidinput->input;
+	int field_count = 0;
+	int error;
+	int i, j;
+
+	if (list_empty(report_list)) {
+		hid_err(hid, "no output reports found\n");
+		return -ENODEV;
+	}
+
+	report = list_first_entry(report_list, struct hid_report, list);
+	/*
+	 * Actually there are 4 fields for 4 Bytes as below:
+	 * -----------------------------------------
+	 * Byte0  Byte1  Byte2	  Byte3
+	 * 0x00   0x00   left_motor right_motor
+	 * -----------------------------------------
+	 * Do init them with default value.
+	 */
+	for (i = 0; i < report->maxfield; i++) {
+		for (j = 0; j < report->field[i]->report_count; j++) {
+			report->field[i]->value[j] = 0x00;
+			field_count++;
+		}
+	}
+
+	if (field_count < 4) {
+		hid_err(hid, "not enough fields in the report: %d\n",
+				field_count);
+		return -ENODEV;
+	}
+
+	betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
+	if (!betopff)
+		return -ENOMEM;
+
+	set_bit(FF_RUMBLE, dev->ffbit);
+
+	error = input_ff_create_memless(dev, betopff, hid_betopff_play);
+	if (error) {
+		kfree(betopff);
+		return error;
+	}
+
+	betopff->report = report;
+	hid_hw_request(hid, betopff->report, HID_REQ_SET_REPORT);
+
+	hid_info(hid, "Force feedback for betop devices by huangbo <huangbobupt@163.com>\n");
+
+	return 0;
+}
+
+static int betop_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	if (id->driver_data)
+		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "parse failed\n");
+		goto err;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+	if (ret) {
+		hid_err(hdev, "hw start failed\n");
+		goto err;
+	}
+
+	betopff_init(hdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id betop_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, betop_devices);
+
+static struct hid_driver betop_driver = {
+	.name = "betop",
+	.id_table = betop_devices,
+	.probe = betop_probe,
+};
+module_hid_driver(betop_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a622590..e64ccfc 100755
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1642,6 +1642,10 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AUREAL, USB_DEVICE_ID_AUREAL_W01RN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185BFM, 0x2208) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185PC, 0x5506) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2PC, 0x1850) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BETOP_2185V2BFM, 0x5500) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 161ee89..c432be9 100755
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -185,6 +185,11 @@
 #define USB_VENDOR_ID_BERKSHIRE		0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD	0x1140
 
+#define USB_VENDOR_ID_BETOP_2185BFM	0x11c2
+#define USB_VENDOR_ID_BETOP_2185PC	0x11c0
+#define USB_VENDOR_ID_BETOP_2185V2PC	0x8380
+#define USB_VENDOR_ID_BETOP_2185V2BFM	0x20bc
+
 #define USB_VENDOR_ID_BTC		0x046e
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE	0x5578
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE_2	0x5577
-- 
1.7.9.5


--------------040801050903080606070907--

