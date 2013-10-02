Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3JBWKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:10:43 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:56598 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3JBWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:10:41 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC] Input: introduce ABS_MAX2/CNT2 and friends
Date: Thu,  3 Oct 2013 00:10:36 +0200
Message-Id: <1380751836-10829-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we painfully noticed during the 3.12 merge-window our
EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried several
hacks to work around it but if we ever decide to increase ABS_MAX, the
EVIOCSABS ioctl ABI might overflow into the next byte causing horrible
misinterpretations in the kernel that we cannot catch.

Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two new
ioctls to get/set abs-params. They no longer encode the ABS code in the
ioctl number and thus allow up to 4 billion ABS codes.

Unfortunately, the uinput API also hard-coded the ABS_CNT value in its
ABI. To avoid any hacks in uinput, we simply introduce a new
uinput_user_dev2 to replace the old one. The new API allows growing
ABS_CNT2 values without any API changes.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi

This is only compile-tested but I wanted to get a first revision out to let
people know what we're working on. Unfortunately, the ABS API has this horribly
low ABS_MAX limit and we couldn't figure out a way to increase it while keeping
ABI compatibility.

Any feedback and review is welcome. And if anyone spots ABI breakage by this
patch, please let me know. If nothing comes up I will patch libevdev to use the
new API, write some extensive test-cases and push this forward.

As a sidenote: I didn't modify joydev to use the new values. Fortunately, the
joydev API would allow switching to ABS_CNT2 without breaking API, but it would
limit the new ABS_CNT2 to 16k. This is quite high but nothing compared to the
 2^32 that we can theoretically support now. If you think 16k ought to be enough
(probably?) I can adjust the joydev API, too.
All other kernel users were converted to the new values. Nothing left behind..

Thanks
David

 drivers/hid/hid-debug.c                  |   2 +-
 drivers/hid/hid-input.c                  |   2 +-
 drivers/input/evdev.c                    |  63 ++++++++++++++-
 drivers/input/input.c                    |  14 ++--
 drivers/input/keyboard/goldfish_events.c |   6 +-
 drivers/input/keyboard/hil_kbd.c         |   2 +-
 drivers/input/misc/uinput.c              | 128 ++++++++++++++++++++++---------
 include/linux/hid.h                      |   2 +-
 include/linux/input.h                    |   6 +-
 include/linux/mod_devicetable.h          |   2 +-
 include/uapi/linux/input.h               |  31 +++++++-
 include/uapi/linux/uinput.h              |  13 ++++
 12 files changed, 213 insertions(+), 58 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 8453214..d32fa30 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -862,7 +862,7 @@ static const char *relatives[REL_MAX + 1] = {
 	[REL_WHEEL] = "Wheel",		[REL_MISC] = "Misc",
 };
 
-static const char *absolutes[ABS_CNT] = {
+static const char *absolutes[ABS_CNT2] = {
 	[ABS_X] = "X",			[ABS_Y] = "Y",
 	[ABS_Z] = "Z",			[ABS_RX] = "Rx",
 	[ABS_RY] = "Ry",		[ABS_RZ] = "Rz",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8741d95..3e879bf 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1305,7 +1305,7 @@ static bool hidinput_has_been_populated(struct hid_input *hidinput)
 	for (i = 0; i < BITS_TO_LONGS(REL_CNT); i++)
 		r |= hidinput->input->relbit[i];
 
-	for (i = 0; i < BITS_TO_LONGS(ABS_CNT); i++)
+	for (i = 0; i < BITS_TO_LONGS(ABS_CNT2); i++)
 		r |= hidinput->input->absbit[i];
 
 	for (i = 0; i < BITS_TO_LONGS(MSC_CNT); i++)
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index b6ded17..c76b87e 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -635,7 +635,7 @@ static int handle_eviocgbit(struct input_dev *dev,
 	case      0: bits = dev->evbit;  len = EV_MAX;  break;
 	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
 	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
-	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
+	case EV_ABS: bits = dev->absbit; len = ABS_MAX2; break;
 	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
 	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
 	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
@@ -663,6 +663,61 @@ static int handle_eviocgbit(struct input_dev *dev,
 }
 #undef OLD_KEY_MAX
 
+static int evdev_handle_get_abs2(struct input_dev *dev, void __user *p)
+{
+	u32 code;
+	struct input_absinfo2 __user *pinfo = p;
+	struct input_absinfo abs;
+
+	if (!dev->absinfo)
+		return -EINVAL;
+
+	if (copy_from_user(&code, &pinfo->code, sizeof(code)))
+		return -EFAULT;
+
+	if (code >= ABS_CNT2)
+		return -EINVAL;
+
+	/*
+	 * Take event lock to ensure that we are not
+	 * copying data while EVIOCSABS2 changes it.
+	 * Might be inconsistent, otherwise.
+	 */
+	spin_lock_irq(&dev->event_lock);
+	abs = dev->absinfo[code];
+	spin_unlock_irq(&dev->event_lock);
+
+	if (copy_to_user(&pinfo->info, &abs, sizeof(abs)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int evdev_handle_set_abs2(struct input_dev *dev, void __user *p)
+{
+	struct input_absinfo2 info;
+
+	if (!dev->absinfo)
+		return -EINVAL;
+
+	if (copy_from_user(&info, p, sizeof(info)))
+		return -EFAULT;
+
+	if (info.code == ABS_MT_SLOT || info.code >= ABS_CNT2)
+		return -EINVAL;
+
+	/*
+	 * Take event lock to ensure that we are not
+	 * changing device parameters in the middle
+	 * of event.
+	 */
+	spin_lock_irq(&dev->event_lock);
+	dev->absinfo[info.code] = info.info;
+	spin_unlock_irq(&dev->event_lock);
+
+	return 0;
+}
+
 static int evdev_handle_get_keycode(struct input_dev *dev, void __user *p)
 {
 	struct input_keymap_entry ke = {
@@ -890,6 +945,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		client->clkid = i;
 		return 0;
 
+	case EVIOCGABS2:
+		return evdev_handle_get_abs2(dev, p);
+
+	case EVIOCSABS2:
+		return evdev_handle_set_abs2(dev, p);
+
 	case EVIOCGKEYCODE:
 		return evdev_handle_get_keycode(dev, p);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index c044699..bc88f17 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -305,7 +305,7 @@ static int input_get_disposition(struct input_dev *dev,
 		break;
 
 	case EV_ABS:
-		if (is_event_supported(code, dev->absbit, ABS_MAX))
+		if (is_event_supported(code, dev->absbit, ABS_MAX2))
 			disposition = input_handle_abs_event(dev, code, &value);
 
 		break;
@@ -474,7 +474,7 @@ EXPORT_SYMBOL(input_inject_event);
 void input_alloc_absinfo(struct input_dev *dev)
 {
 	if (!dev->absinfo)
-		dev->absinfo = kcalloc(ABS_CNT, sizeof(struct input_absinfo),
+		dev->absinfo = kcalloc(ABS_CNT2, sizeof(struct input_absinfo),
 					GFP_KERNEL);
 
 	WARN(!dev->absinfo, "%s(): kcalloc() failed?\n", __func__);
@@ -954,7 +954,7 @@ static const struct input_device_id *input_match_device(struct input_handler *ha
 		if (!bitmap_subset(id->relbit, dev->relbit, REL_MAX))
 			continue;
 
-		if (!bitmap_subset(id->absbit, dev->absbit, ABS_MAX))
+		if (!bitmap_subset(id->absbit, dev->absbit, ABS_MAX2))
 			continue;
 
 		if (!bitmap_subset(id->mscbit, dev->mscbit, MSC_MAX))
@@ -1147,7 +1147,7 @@ static int input_devices_seq_show(struct seq_file *seq, void *v)
 	if (test_bit(EV_REL, dev->evbit))
 		input_seq_print_bitmap(seq, "REL", dev->relbit, REL_MAX);
 	if (test_bit(EV_ABS, dev->evbit))
-		input_seq_print_bitmap(seq, "ABS", dev->absbit, ABS_MAX);
+		input_seq_print_bitmap(seq, "ABS", dev->absbit, ABS_MAX2);
 	if (test_bit(EV_MSC, dev->evbit))
 		input_seq_print_bitmap(seq, "MSC", dev->mscbit, MSC_MAX);
 	if (test_bit(EV_LED, dev->evbit))
@@ -1333,7 +1333,7 @@ static int input_print_modalias(char *buf, int size, struct input_dev *id,
 	len += input_print_modalias_bits(buf + len, size - len,
 				'r', id->relbit, 0, REL_MAX);
 	len += input_print_modalias_bits(buf + len, size - len,
-				'a', id->absbit, 0, ABS_MAX);
+				'a', id->absbit, 0, ABS_MAX2);
 	len += input_print_modalias_bits(buf + len, size - len,
 				'm', id->mscbit, 0, MSC_MAX);
 	len += input_print_modalias_bits(buf + len, size - len,
@@ -1592,7 +1592,7 @@ static int input_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 	if (test_bit(EV_REL, dev->evbit))
 		INPUT_ADD_HOTPLUG_BM_VAR("REL=", dev->relbit, REL_MAX);
 	if (test_bit(EV_ABS, dev->evbit))
-		INPUT_ADD_HOTPLUG_BM_VAR("ABS=", dev->absbit, ABS_MAX);
+		INPUT_ADD_HOTPLUG_BM_VAR("ABS=", dev->absbit, ABS_MAX2);
 	if (test_bit(EV_MSC, dev->evbit))
 		INPUT_ADD_HOTPLUG_BM_VAR("MSC=", dev->mscbit, MSC_MAX);
 	if (test_bit(EV_LED, dev->evbit))
@@ -1924,7 +1924,7 @@ static unsigned int input_estimate_events_per_packet(struct input_dev *dev)
 
 	events = mt_slots + 1; /* count SYN_MT_REPORT and SYN_REPORT */
 
-	for (i = 0; i < ABS_CNT; i++) {
+	for (i = 0; i < ABS_CNT2; i++) {
 		if (test_bit(i, dev->absbit)) {
 			if (input_is_mt_axis(i))
 				events += mt_slots;
diff --git a/drivers/input/keyboard/goldfish_events.c b/drivers/input/keyboard/goldfish_events.c
index 9f60a2e..9999cea 100644
--- a/drivers/input/keyboard/goldfish_events.c
+++ b/drivers/input/keyboard/goldfish_events.c
@@ -90,8 +90,8 @@ static void events_import_abs_params(struct event_dev *edev)
 	__raw_writel(PAGE_ABSDATA, addr + REG_SET_PAGE);
 
 	count = __raw_readl(addr + REG_LEN) / sizeof(val);
-	if (count > ABS_MAX)
-		count = ABS_MAX;
+	if (count > ABS_MAX2)
+		count = ABS_MAX2;
 
 	for (i = 0; i < count; i++) {
 		if (!test_bit(i, input_dev->absbit))
@@ -158,7 +158,7 @@ static int events_probe(struct platform_device *pdev)
 	events_import_bits(edev, input_dev->evbit, EV_SYN, EV_MAX);
 	events_import_bits(edev, input_dev->keybit, EV_KEY, KEY_MAX);
 	events_import_bits(edev, input_dev->relbit, EV_REL, REL_MAX);
-	events_import_bits(edev, input_dev->absbit, EV_ABS, ABS_MAX);
+	events_import_bits(edev, input_dev->absbit, EV_ABS, ABS_MAX2);
 	events_import_bits(edev, input_dev->mscbit, EV_MSC, MSC_MAX);
 	events_import_bits(edev, input_dev->ledbit, EV_LED, LED_MAX);
 	events_import_bits(edev, input_dev->sndbit, EV_SND, SND_MAX);
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index 589e3c2..4e4e010 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -387,7 +387,7 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 					0, HIL_IDD_AXIS_MAX(idd, i - 3), 0, 0);
 
 #ifdef TABLET_AUTOADJUST
-		for (i = 0; i < ABS_MAX; i++) {
+		for (i = 0; i < ABS_MAX2; i++) {
 			int diff = input_abs_get_max(input_dev, ABS_X + i) / 10;
 			input_abs_set_min(input_dev, ABS_X + i,
 				input_abs_get_min(input_dev, ABS_X + i) + diff);
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index a0a4bba..72029d6 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -311,7 +311,7 @@ static int uinput_validate_absbits(struct input_dev *dev)
 	unsigned int cnt;
 	int retval = 0;
 
-	for (cnt = 0; cnt < ABS_CNT; cnt++) {
+	for (cnt = 0; cnt < ABS_CNT2; cnt++) {
 		int min, max;
 		if (!test_bit(cnt, dev->absbit))
 			continue;
@@ -358,14 +358,15 @@ static int uinput_allocate_device(struct uinput_device *udev)
 }
 
 static int uinput_setup_device(struct uinput_device *udev,
-			       const char __user *buffer, size_t count)
+			       struct uinput_user_dev2 *user_dev2,
+			       size_t abscnt)
 {
-	struct uinput_user_dev	*user_dev;
 	struct input_dev	*dev;
 	int			i;
 	int			retval;
 
-	if (count != sizeof(struct uinput_user_dev))
+	/* Ensure name is filled in */
+	if (!user_dev2->name[0])
 		return -EINVAL;
 
 	if (!udev->dev) {
@@ -375,37 +376,24 @@ static int uinput_setup_device(struct uinput_device *udev,
 	}
 
 	dev = udev->dev;
-
-	user_dev = memdup_user(buffer, sizeof(struct uinput_user_dev));
-	if (IS_ERR(user_dev))
-		return PTR_ERR(user_dev);
-
-	udev->ff_effects_max = user_dev->ff_effects_max;
-
-	/* Ensure name is filled in */
-	if (!user_dev->name[0]) {
-		retval = -EINVAL;
-		goto exit;
-	}
+	udev->ff_effects_max = user_dev2->ff_effects_max;
 
 	kfree(dev->name);
-	dev->name = kstrndup(user_dev->name, UINPUT_MAX_NAME_SIZE,
+	dev->name = kstrndup(user_dev2->name, UINPUT_MAX_NAME_SIZE,
 			     GFP_KERNEL);
-	if (!dev->name) {
-		retval = -ENOMEM;
-		goto exit;
-	}
+	if (!dev->name)
+		return -ENOMEM;
 
-	dev->id.bustype	= user_dev->id.bustype;
-	dev->id.vendor	= user_dev->id.vendor;
-	dev->id.product	= user_dev->id.product;
-	dev->id.version	= user_dev->id.version;
+	dev->id.bustype = user_dev2->id.bustype;
+	dev->id.vendor = user_dev2->id.vendor;
+	dev->id.product = user_dev2->id.product;
+	dev->id.version = user_dev2->id.version;
 
-	for (i = 0; i < ABS_CNT; i++) {
-		input_abs_set_max(dev, i, user_dev->absmax[i]);
-		input_abs_set_min(dev, i, user_dev->absmin[i]);
-		input_abs_set_fuzz(dev, i, user_dev->absfuzz[i]);
-		input_abs_set_flat(dev, i, user_dev->absflat[i]);
+	for (i = 0; i < abscnt; i++) {
+		input_abs_set_max(dev, i, user_dev2->abs[i].max);
+		input_abs_set_min(dev, i, user_dev2->abs[i].min);
+		input_abs_set_fuzz(dev, i, user_dev2->abs[i].fuzz);
+		input_abs_set_flat(dev, i, user_dev2->abs[i].flat);
 	}
 
 	/* check if absmin/absmax/absfuzz/absflat are filled as
@@ -413,7 +401,7 @@ static int uinput_setup_device(struct uinput_device *udev,
 	if (test_bit(EV_ABS, dev->evbit)) {
 		retval = uinput_validate_absbits(dev);
 		if (retval < 0)
-			goto exit;
+			return retval;
 		if (test_bit(ABS_MT_SLOT, dev->absbit)) {
 			int nslot = input_abs_get_max(dev, ABS_MT_SLOT) + 1;
 			input_mt_init_slots(dev, nslot, 0);
@@ -423,11 +411,72 @@ static int uinput_setup_device(struct uinput_device *udev,
 	}
 
 	udev->state = UIST_SETUP_COMPLETE;
-	retval = count;
+	return 0;
+}
+
+static int uinput_setup_device1(struct uinput_device *udev,
+				const char __user *buffer, size_t count)
+{
+	struct uinput_user_dev	*user_dev;
+	struct uinput_user_dev2	*user_dev2;
+	int			i;
+	int			retval;
+
+	if (count != sizeof(struct uinput_user_dev))
+		return -EINVAL;
+
+	user_dev = memdup_user(buffer, sizeof(struct uinput_user_dev));
+	if (IS_ERR(user_dev))
+		return PTR_ERR(user_dev);
+
+	user_dev2 = kmalloc(sizeof(*user_dev2), GFP_KERNEL);
+	if (!user_dev2) {
+		kfree(user_dev);
+		return -ENOMEM;
+	}
+
+	memcpy(user_dev2->name, user_dev->name, UINPUT_MAX_NAME_SIZE);
+	memcpy(&user_dev2->id, &user_dev->id, sizeof(struct input_id));
+	user_dev2->ff_effects_max = user_dev->ff_effects_max;
+
+	for (i = 0; i < ABS_CNT; ++i) {
+		user_dev2->abs[i].max = user_dev->absmax[i];
+		user_dev2->abs[i].min = user_dev->absmin[i];
+		user_dev2->abs[i].fuzz = user_dev->absfuzz[i];
+		user_dev2->abs[i].flat = user_dev->absflat[i];
+	}
+
+	retval = uinput_setup_device(udev, user_dev2, ABS_CNT);
 
- exit:
 	kfree(user_dev);
-	return retval;
+	kfree(user_dev2);
+
+	return retval ? retval : count;
+}
+
+static int uinput_setup_device2(struct uinput_device *udev,
+			       const char __user *buffer, size_t count)
+{
+	struct uinput_user_dev2	*user_dev2;
+	int			retval;
+	size_t			off, abscnt;
+
+	/* The first revision of "uinput_user_dev2" is bigger than
+	 * "uinput_user_dev" and growing. Disallow any smaller payloads. */
+	if (count <= sizeof(struct uinput_user_dev))
+		return -EINVAL;
+
+	user_dev2 = memdup_user(buffer, count);
+	if (IS_ERR(user_dev2))
+		return PTR_ERR(user_dev2);
+
+	off = offsetof(struct uinput_user_dev2, abs);
+	abscnt = (count - off) / sizeof(struct uinput_user_absinfo);
+	retval = uinput_setup_device(udev, user_dev2, abscnt);
+
+	kfree(user_dev2);
+
+	return retval ? retval : count;
 }
 
 static ssize_t uinput_inject_event(struct uinput_device *udev,
@@ -459,9 +508,12 @@ static ssize_t uinput_write(struct file *file, const char __user *buffer,
 	if (retval)
 		return retval;
 
-	retval = udev->state == UIST_CREATED ?
-			uinput_inject_event(udev, buffer, count) :
-			uinput_setup_device(udev, buffer, count);
+	if (udev->state == UIST_CREATED)
+		retval = uinput_inject_event(udev, buffer, count);
+	else if (count <= sizeof(struct uinput_user_dev))
+		retval = uinput_setup_device1(udev, buffer, count);
+	else
+		retval = uinput_setup_device2(udev, buffer, count);
 
 	mutex_unlock(&udev->mutex);
 
@@ -702,7 +754,7 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
 			break;
 
 		case UI_SET_ABSBIT:
-			retval = uinput_set_bit(arg, absbit, ABS_MAX);
+			retval = uinput_set_bit(arg, absbit, ABS_MAX2);
 			break;
 
 		case UI_SET_MSCBIT:
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 31b9d29..c21d8bb 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -828,7 +828,7 @@ static inline void hid_map_usage(struct hid_input *hidinput,
 	switch (type) {
 	case EV_ABS:
 		*bit = input->absbit;
-		*max = ABS_MAX;
+		*max = ABS_MAX2;
 		break;
 	case EV_REL:
 		*bit = input->relbit;
diff --git a/include/linux/input.h b/include/linux/input.h
index 82ce323..c6add6f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -129,7 +129,7 @@ struct input_dev {
 	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
 	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
-	unsigned long absbit[BITS_TO_LONGS(ABS_CNT)];
+	unsigned long absbit[BITS_TO_LONGS(ABS_CNT2)];
 	unsigned long mscbit[BITS_TO_LONGS(MSC_CNT)];
 	unsigned long ledbit[BITS_TO_LONGS(LED_CNT)];
 	unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
@@ -210,8 +210,8 @@ struct input_dev {
 #error "REL_MAX and INPUT_DEVICE_ID_REL_MAX do not match"
 #endif
 
-#if ABS_MAX != INPUT_DEVICE_ID_ABS_MAX
-#error "ABS_MAX and INPUT_DEVICE_ID_ABS_MAX do not match"
+#if ABS_MAX2 != INPUT_DEVICE_ID_ABS_MAX
+#error "ABS_MAX2 and INPUT_DEVICE_ID_ABS_MAX do not match"
 #endif
 
 #if MSC_MAX != INPUT_DEVICE_ID_MSC_MAX
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..329aa30 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -277,7 +277,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
 #define INPUT_DEVICE_ID_KEY_MAX		0x2ff
 #define INPUT_DEVICE_ID_REL_MAX		0x0f
-#define INPUT_DEVICE_ID_ABS_MAX		0x3f
+#define INPUT_DEVICE_ID_ABS_MAX		0x4f
 #define INPUT_DEVICE_ID_MSC_MAX		0x07
 #define INPUT_DEVICE_ID_LED_MAX		0x0f
 #define INPUT_DEVICE_ID_SND_MAX		0x07
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index a372627..4a6082a 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -74,6 +74,21 @@ struct input_absinfo {
 };
 
 /**
+ * struct input_absinfo2 - used by EVIOC[G/S]ABS2 ioctls
+ * @code: ABS code to query
+ * @info: absinfo structure to get/set abs parameters for @code
+ *
+ * This structure is used by the new EVIOC[G/S]ABS2 ioctls which
+ * do the same as the old EVIOC[G/S]ABS ioctls but avoid encoding
+ * the ABS code in the ioctl number. This allows a much wider
+ * range of ABS codes.
+ */
+struct input_absinfo2 {
+	__u32 code;
+	struct input_absinfo info;
+};
+
+/**
  * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
  * @scancode: scancode represented in machine-endian form.
  * @len: length of the scancode that resides in @scancode buffer.
@@ -153,6 +168,8 @@ struct input_keymap_entry {
 
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 #define EVIOCREVOKE		_IOW('E', 0x91, int)			/* Revoke device access */
+#define EVIOCGABS2		_IOR('E', 0x92, struct input_absinfo2)	/* get abs value/limits */
+#define EVIOCSABS2		_IOW('E', 0x93, struct input_absinfo2)	/* set abs value/limits */
 
 #define EVIOCSCLOCKID		_IOW('E', 0xa0, int)			/* Set clockid to be used for timestamps */
 
@@ -832,11 +849,23 @@ struct input_keymap_entry {
 #define ABS_MT_TOOL_X		0x3c	/* Center X tool position */
 #define ABS_MT_TOOL_Y		0x3d	/* Center Y tool position */
 
-
+/*
+ * ABS_MAX/CNT is limited to a maximum of 0x3f due to the design of EVIOCGABS
+ * and EVIOCSABS ioctls. Other kernel APIs like uinput also hardcoded it. Do
+ * not modify this value and instead use the extended ABS_MAX2/CNT2 API.
+ */
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
 
 /*
+ * Due to API restrictions the legacy evdev API only supports ABS values up to
+ * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
+ * between ABS_MAX and ABS_MAX2.
+ */
+#define ABS_MAX2		0x4f
+#define ABS_CNT2		(ABS_MAX2+1)
+
+/*
  * Switch events
  */
 
diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
index fe46431..124e20c 100644
--- a/include/uapi/linux/uinput.h
+++ b/include/uapi/linux/uinput.h
@@ -134,4 +134,17 @@ struct uinput_user_dev {
 	__s32 absfuzz[ABS_CNT];
 	__s32 absflat[ABS_CNT];
 };
+
+struct uinput_user_dev2 {
+	char name[UINPUT_MAX_NAME_SIZE];
+	struct input_id id;
+	__u32 ff_effects_max;
+	struct uinput_user_absinfo {
+		__s32 max;
+		__s32 min;
+		__s32 fuzz;
+		__s32 flat;
+	} abs[ABS_CNT2];
+};
+
 #endif /* _UAPI__UINPUT_H_ */
-- 
1.8.4

