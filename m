Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaHUFBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:01:16 -0400
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:60961 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaHUFBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:01:14 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 01:01:12 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=/MiPqmMwFv6ha2ZBybe0ZU9m+O5sXPp7gEUgHVyRzyY= c=1 sm=1
 a=wZiHtcDKXq4A:10 a=jR8rNBcWf5MA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=47LbCVvxAAAA:8 a=pGLkceISAAAA:8
 a=AjIl7p0_xisDldJ3iEcA:9 a=QhNQsjeWOoAA:10 a=MSl-tDqOz04A:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [RFC 2/4] HID:hid-logitech: New detection of native capable devices
Date: Wed, 20 Aug 2014 22:51:40 -0600
Message-Id: <1408596702-3895-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408596702-3895-1-git-send-email-simon@mungewell.org>
References: <1408596702-3895-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-lg.h    |   5 +++
 drivers/hid/hid-lg4ff.c | 115 ++++++++++++++++++++++++------------------------
 2 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/drivers/hid/hid-lg.h b/drivers/hid/hid-lg.h
index fc4bdae..cf442e5 100644
--- a/drivers/hid/hid-lg.h
+++ b/drivers/hid/hid-lg.h
@@ -27,6 +27,11 @@ static inline int lg3ff_init(struct hid_device *hdev) { return -1; }
 #ifdef CONFIG_LOGIWHEELS_FF
 #define LG4FF_MSW_NAT -1	/* allow native mode */
 #define LG4FF_MSW_EMU 0		/* remain in or force emulation mode */
+#define LG4FF_MSW_DFP 1
+#define LG4FF_MSW_G25 2
+#define LG4FF_MSW_DFGT 3
+#define LG4FF_MSW_G27 4
+#define LG4FF_MSW_MAX 5		/* end-stop */
 
 int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 			     struct hid_usage *usage, __s32 value, struct lg_drv_data *drv_data);
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 9247227..eda07a2 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -56,6 +56,7 @@ static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_r
 
 struct lg4ff_device_entry {
 	__u32 product_id;
+	__u16 type;
 	__u16 range;
 	__u16 min_range;
 	__u16 max_range;
@@ -73,23 +74,19 @@ static const signed short lg4ff_wheel_effects[] = {
 	-1
 };
 
-struct lg4ff_wheel {
-	const __u32 product_id;
-	const signed short *ff_effects;
-	const __u16 min_range;
-	const __u16 max_range;
+struct lg4ff_mode_switcher {
+	const u16 bcdDevice;
+	const u16 mask;
+	const u16 type;
+	const __u32 native_pid;
 	void (*set_range)(struct hid_device *hid, u16 range);
 };
 
-static const struct lg4ff_wheel lg4ff_devices[] = {
-	{USB_DEVICE_ID_LOGITECH_WHEEL,       lg4ff_wheel_effects, 40, 270, NULL},
-	{USB_DEVICE_ID_LOGITECH_MOMO_WHEEL,  lg4ff_wheel_effects, 40, 270, NULL},
-	{USB_DEVICE_ID_LOGITECH_DFP_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_dfp},
-	{USB_DEVICE_ID_LOGITECH_G25_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
-	{USB_DEVICE_ID_LOGITECH_DFGT_WHEEL,  lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
-	{USB_DEVICE_ID_LOGITECH_G27_WHEEL,   lg4ff_wheel_effects, 40, 900, hid_lg4ff_set_range_g25},
-	{USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2, lg4ff_wheel_effects, 40, 270, NULL},
-	{USB_DEVICE_ID_LOGITECH_WII_WHEEL,   lg4ff_wheel_effects, 40, 270, NULL}
+static const struct lg4ff_mode_switcher lg4ff_mode_switchers[] = {	/* Note: Order is important for detection process */
+	{0x1300, 0xff00, LG4FF_MSW_DFGT, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL, hid_lg4ff_set_range_g25},
+	{0x1230, 0xfff0, LG4FF_MSW_G27, USB_DEVICE_ID_LOGITECH_G27_WHEEL, hid_lg4ff_set_range_g25},
+	{0x1200, 0xff00, LG4FF_MSW_G25, USB_DEVICE_ID_LOGITECH_G25_WHEEL, hid_lg4ff_set_range_g25},
+	{0x1000, 0xf000, LG4FF_MSW_DFP, USB_DEVICE_ID_LOGITECH_DFP_WHEEL, hid_lg4ff_set_range_dfp},
 };
 
 struct lg4ff_native_cmd {
@@ -570,50 +567,12 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
 
-	/* Check what wheel has been connected */
-	for (i = 0; i < ARRAY_SIZE(lg4ff_devices); i++) {
-		if (hid->product == lg4ff_devices[i].product_id) {
-			dbg_hid("Found compatible device, product ID %04X\n", lg4ff_devices[i].product_id);
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(lg4ff_devices)) {
-		hid_err(hid, "Device is not supported by lg4ff driver. If you think it should be, consider reporting a bug to"
-			     "LKML, Simon Wood <simon@mungewell.org> or Michal Maly <madcatxster@gmail.com>\n");
-		return -1;
-	}
-
 	/* Attempt to switch wheel to native mode when applicable */
 	udesc = &(hid_to_usb_dev(hid)->descriptor);
 	if (!udesc) {
 		hid_err(hid, "NULL USB device descriptor\n");
 		return -1;
 	}
-	bcdDevice = le16_to_cpu(udesc->bcdDevice);
-	rev_maj = bcdDevice >> 8;
-	rev_min = bcdDevice & 0xff;
-
-	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL && switch_mode != LG4FF_MSW_EMU) {
-		dbg_hid("Generic wheel detected, can it do native?\n");
-		dbg_hid("USB revision: %2x.%02x\n", rev_maj, rev_min);
-
-		for (j = 0; j < ARRAY_SIZE(lg4ff_revs); j++) {
-			if (lg4ff_revs[j].rev_maj == rev_maj && lg4ff_revs[j].rev_min == rev_min) {
-				hid_lg4ff_switch_native(hid, lg4ff_revs[j].command);
-				hid_info(hid, "Switched to native mode\n");
-			}
-		}
-	}
-
-	/* Set supported force feedback capabilities */
-	for (j = 0; lg4ff_devices[i].ff_effects[j] >= 0; j++)
-		set_bit(lg4ff_devices[i].ff_effects[j], dev->ffbit);
-
-	error = input_ff_create_memless(dev, NULL, hid_lg4ff_play);
-
-	if (error)
-		return error;
 
 	/* Get private driver data */
 	drv_data = hid_get_drvdata(hid);
@@ -630,10 +589,52 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	}
 	drv_data->device_props = entry;
 
-	entry->product_id = lg4ff_devices[i].product_id;
-	entry->min_range = lg4ff_devices[i].min_range;
-	entry->max_range = lg4ff_devices[i].max_range;
-	entry->set_range = lg4ff_devices[i].set_range;
+	entry->product_id = hid->product;
+	entry->set_range = NULL;
+	entry->type = LG4FF_MSW_EMU;
+
+	/* Check which wheel has been connected */
+	bcdDevice = le16_to_cpu(udesc->bcdDevice);
+	rev_maj = bcdDevice >> 8;
+	rev_min = bcdDevice & 0xff;
+
+	for (i = 0; i < ARRAY_SIZE(lg4ff_mode_switchers); i++) {
+		const struct lg4ff_mode_switcher *s = &lg4ff_mode_switchers[i];
+
+		if (s->bcdDevice != (bcdDevice & s->mask))
+			continue;
+
+		entry->type = s->type;
+		dbg_hid("Native capable device detected (Native ID %04X, type %d)\n", s->native_pid, s->type);
+
+		if (hid->product == s->native_pid) {
+			entry->product_id = s->native_pid;
+			entry->min_range = 40;
+			entry->max_range = 900;
+			entry->set_range = s->set_range;
+		}
+
+		if (hid->product != s->native_pid && switch_mode != LG4FF_MSW_EMU) {
+			dbg_hid("Switching to native mode\n");
+
+			for (j = 0; j < ARRAY_SIZE(lg4ff_revs); j++) {
+				if (lg4ff_revs[j].rev_maj == rev_maj && lg4ff_revs[j].rev_min == rev_min) {
+					hid_lg4ff_switch_native(hid, lg4ff_revs[j].command);
+					hid_info(hid, "Switched to native mode\n");
+				}
+			}
+		}
+		break;
+	}
+
+	/* Set supported force feedback capabilities */
+	for (j = 0; lg4ff_wheel_effects[j] >= 0; j++)
+		set_bit(lg4ff_wheel_effects[j], dev->ffbit);
+
+	error = input_ff_create_memless(dev, NULL, hid_lg4ff_play);
+
+	if (error)
+		return error;
 
 	/* Check if autocentering is available and
 	 * set the centering force to zero by default */
@@ -663,7 +664,7 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	for (j = 0; j < 5; j++)
 		entry->led[j] = NULL;
 
-	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_G27_WHEEL) {
+	if (entry->type == LG4FF_MSW_G27) {
 		struct led_classdev *led;
 		size_t name_sz;
 		char *name;
-- 
1.9.1

