Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3LQPtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:49:25 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46163 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3LQPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:21 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 1/4] Input: uinput: add full absinfo support
Date: Tue, 17 Dec 2013 16:48:51 +0100
Message-Id: <1387295334-1744-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently lack support for abs-resolution and abs-value parameters
during uinput ABS initialization. Furthermore, our parsers don't allow
growing ABS_CNT values. Therefore, introduce uinput_user_dev2.

User-space is free to write uinput_user_dev2 objects instead of
uinput_user_dev legacy objects now. If the kernel lacks support for it,
our comparison for "count != sizeof(struct uinput_user_dev)" will catch
this and return EINVAL. User-space shall retry with the legacy mode then.

Internally, we transform the legacy object into uinput_user_dev2 and then
handle both the same way.

The new uinput_user_dev2 object has multiple new features:
 - abs payload now has "value" and "resolution" parameters as part of the
   switch to "struct input_absinfo". We simply copy these over.
 - Our parser allows growing ABS_CNT. We automatically detect the payload
   size of the caller, thus, calculating the ABS_CNT the program was
   compiled with.
 - A "version" field to denote the uinput-version used. This is required
   to properly support changing "struct input_user_dev2" changes in the
   future. Due to the dynamic ABS_CNT support, we cannot simply add new
   fields, as we cannot deduce the structure size from the user-space
   given size. Thus, we need the "version" field to allow changing the
   object and properly detecting it in our write() handler.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/input/misc/uinput.c | 142 ++++++++++++++++++++++++++++++++------------
 include/uapi/linux/uinput.h |   9 +++
 2 files changed, 114 insertions(+), 37 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 7728359..927ad9a 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -358,14 +358,16 @@ static int uinput_allocate_device(struct uinput_device *udev)
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
+	struct input_absinfo	*abs;
 
-	if (count != sizeof(struct uinput_user_dev))
+	/* Ensure name is filled in */
+	if (!user_dev2->name[0])
 		return -EINVAL;
 
 	if (!udev->dev) {
@@ -375,37 +377,27 @@ static int uinput_setup_device(struct uinput_device *udev,
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
-
-	dev->id.bustype	= user_dev->id.bustype;
-	dev->id.vendor	= user_dev->id.vendor;
-	dev->id.product	= user_dev->id.product;
-	dev->id.version	= user_dev->id.version;
+	if (!dev->name)
+		return -ENOMEM;
 
-	for (i = 0; i < ABS_CNT; i++) {
-		input_abs_set_max(dev, i, user_dev->absmax[i]);
-		input_abs_set_min(dev, i, user_dev->absmin[i]);
-		input_abs_set_fuzz(dev, i, user_dev->absfuzz[i]);
-		input_abs_set_flat(dev, i, user_dev->absflat[i]);
+	dev->id.bustype = user_dev2->id.bustype;
+	dev->id.vendor = user_dev2->id.vendor;
+	dev->id.product = user_dev2->id.product;
+	dev->id.version = user_dev2->id.version;
+
+	for (i = 0; i < abscnt; i++) {
+		abs = &user_dev2->abs[i];
+		input_abs_set_val(dev, i, abs->value);
+		input_abs_set_max(dev, i, abs->maximum);
+		input_abs_set_min(dev, i, abs->minimum);
+		input_abs_set_fuzz(dev, i, abs->fuzz);
+		input_abs_set_flat(dev, i, abs->flat);
+		input_abs_set_res(dev, i, abs->resolution);
 	}
 
 	/* check if absmin/absmax/absfuzz/absflat are filled as
@@ -413,7 +405,7 @@ static int uinput_setup_device(struct uinput_device *udev,
 	if (test_bit(EV_ABS, dev->evbit)) {
 		retval = uinput_validate_absbits(dev);
 		if (retval < 0)
-			goto exit;
+			return retval;
 		if (test_bit(ABS_MT_SLOT, dev->absbit)) {
 			int nslot = input_abs_get_max(dev, ABS_MT_SLOT) + 1;
 			input_mt_init_slots(dev, nslot, 0);
@@ -423,11 +415,84 @@ static int uinput_setup_device(struct uinput_device *udev,
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
+	user_dev2->version = UINPUT_VERSION;
+	memcpy(user_dev2->name, user_dev->name, UINPUT_MAX_NAME_SIZE);
+	memcpy(&user_dev2->id, &user_dev->id, sizeof(struct input_id));
+	user_dev2->ff_effects_max = user_dev->ff_effects_max;
+
+	for (i = 0; i < ABS_CNT; ++i) {
+		user_dev2->abs[i].value = 0;
+		user_dev2->abs[i].maximum = user_dev->absmax[i];
+		user_dev2->abs[i].minimum = user_dev->absmin[i];
+		user_dev2->abs[i].fuzz = user_dev->absfuzz[i];
+		user_dev2->abs[i].flat = user_dev->absflat[i];
+		user_dev2->abs[i].resolution = 0;
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
+	size_t			off, abscnt, max;
+
+	/* The first revision of "uinput_user_dev2" is bigger than
+	 * "uinput_user_dev" and growing. Disallow any smaller payloads. */
+	if (count <= sizeof(struct uinput_user_dev))
+		return -EINVAL;
+
+	/* rough check to avoid huge kernel space allocations */
+	max = ABS_CNT * sizeof(*user_dev2->abs) + sizeof(*user_dev2);
+	if (count > max)
+		return -EINVAL;
+
+	user_dev2 = memdup_user(buffer, count);
+	if (IS_ERR(user_dev2))
+		return PTR_ERR(user_dev2);
+
+	if (user_dev2->version > UINPUT_VERSION) {
+		retval = -EINVAL;
+	} else {
+		off = offsetof(struct uinput_user_dev2, abs);
+		abscnt = (count - off) / sizeof(*user_dev2->abs);
+		retval = uinput_setup_device(udev, user_dev2, abscnt);
+	}
+
+	kfree(user_dev2);
+
+	return retval ? retval : count;
 }
 
 static ssize_t uinput_inject_events(struct uinput_device *udev,
@@ -469,9 +534,12 @@ static ssize_t uinput_write(struct file *file, const char __user *buffer,
 	if (retval)
 		return retval;
 
-	retval = udev->state == UIST_CREATED ?
-			uinput_inject_events(udev, buffer, count) :
-			uinput_setup_device(udev, buffer, count);
+	if (udev->state == UIST_CREATED)
+		retval = uinput_inject_events(udev, buffer, count);
+	else if (count <= sizeof(struct uinput_user_dev))
+		retval = uinput_setup_device1(udev, buffer, count);
+	else
+		retval = uinput_setup_device2(udev, buffer, count);
 
 	mutex_unlock(&udev->mutex);
 
diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
index fe46431..c2e8710 100644
--- a/include/uapi/linux/uinput.h
+++ b/include/uapi/linux/uinput.h
@@ -134,4 +134,13 @@ struct uinput_user_dev {
 	__s32 absfuzz[ABS_CNT];
 	__s32 absflat[ABS_CNT];
 };
+
+struct uinput_user_dev2 {
+	__u8 version;
+	char name[UINPUT_MAX_NAME_SIZE];
+	struct input_id id;
+	__u32 ff_effects_max;
+	struct input_absinfo abs[ABS_CNT];
+};
+
 #endif /* _UAPI__UINPUT_H_ */
-- 
1.8.5.1

