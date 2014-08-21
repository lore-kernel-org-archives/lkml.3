Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaHUFBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:01:24 -0400
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:58322 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaHUFBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:01:22 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=/MiPqmMwFv6ha2ZBybe0ZU9m+O5sXPp7gEUgHVyRzyY= c=1 sm=1
 a=Km5pPO3BmbUA:10 a=2bGWP9j6KM4A:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=Zs2Tfr0Oe0jB4w8rBYIA:9
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [RFC 1/4] HID:hid-logitech: Add modparam to allow/disable switch to native mode
Date: Wed, 20 Aug 2014 22:51:39 -0600
Message-Id: <1408596702-3895-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-lg.c    | 17 ++++++++++++++++-
 drivers/hid/hid-lg.h    |  7 +++++--
 drivers/hid/hid-lg4ff.c |  4 ++--
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index a976f48..81ba24d 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -334,6 +334,16 @@ static __u8 momo2_rdesc_fixed[] = {
 };
 
 /*
+ * Certain Logitech wheels provide various compatibililty modes
+ * for games that cannot handle their advanced features properly.
+ * This switch forces the wheel into a specific compatibililty
+ * instead of its native mode
+ */
+#ifdef CONFIG_LOGIWHEELS_FF
+static int lg4ff_switch_mode = LG4FF_MSW_NAT;	/* Default to native mode */
+#endif
+
+/*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
  * the original value of 0x28c of logical maximum to 0x104d
@@ -717,7 +727,7 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (drv_data->quirks & LG_FF3)
 		lg3ff_init(hdev);
 	if (drv_data->quirks & LG_FF4)
-		lg4ff_init(hdev);
+		lg4ff_init(hdev, lg4ff_switch_mode);
 
 	return 0;
 err_free:
@@ -818,4 +828,9 @@ static struct hid_driver lg_driver = {
 };
 module_hid_driver(lg_driver);
 
+#ifdef CONFIG_LOGIWHEELS_FF
+module_param_named(lg4ff_switch_mode, lg4ff_switch_mode, int, S_IRUGO);
+MODULE_PARM_DESC(lg4ff_switch_mode, "Enable switch from compatibililty mode to native mode (only certain devices)");
+#endif
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-lg.h b/drivers/hid/hid-lg.h
index 142ce3f..fc4bdae 100644
--- a/drivers/hid/hid-lg.h
+++ b/drivers/hid/hid-lg.h
@@ -25,14 +25,17 @@ static inline int lg3ff_init(struct hid_device *hdev) { return -1; }
 #endif
 
 #ifdef CONFIG_LOGIWHEELS_FF
+#define LG4FF_MSW_NAT -1	/* allow native mode */
+#define LG4FF_MSW_EMU 0		/* remain in or force emulation mode */
+
 int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 			     struct hid_usage *usage, __s32 value, struct lg_drv_data *drv_data);
-int lg4ff_init(struct hid_device *hdev);
+int lg4ff_init(struct hid_device *hdev, const int switch_mode);
 int lg4ff_deinit(struct hid_device *hdev);
 #else
 static inline int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 					   struct hid_usage *usage, __s32 value, struct lg_drv_data *drv_data) { return 0; }
-static inline int lg4ff_init(struct hid_device *hdev) { return -1; }
+static inline int lg4ff_init(struct hid_device *hdev, const int switch_mode) { return -1; }
 static inline int lg4ff_deinit(struct hid_device *hdev) { return -1; }
 #endif
 
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index cc2bd20..9247227 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -556,7 +556,7 @@ static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cde
 }
 #endif
 
-int lg4ff_init(struct hid_device *hid)
+int lg4ff_init(struct hid_device *hid, const int switch_mode)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
 	struct input_dev *dev = hidinput->input;
@@ -594,7 +594,7 @@ int lg4ff_init(struct hid_device *hid)
 	rev_maj = bcdDevice >> 8;
 	rev_min = bcdDevice & 0xff;
 
-	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL) {
+	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL && switch_mode != LG4FF_MSW_EMU) {
 		dbg_hid("Generic wheel detected, can it do native?\n");
 		dbg_hid("USB revision: %2x.%02x\n", rev_maj, rev_min);
 
-- 
1.9.1

