Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3GONNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100Ab3GONNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:13:14 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>
Subject: [PATCH 1/2] input/uinput: support abs resolution
Date: Mon, 15 Jul 2013 15:12:51 +0200
Message-Id: <1373893972-6734-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Input resolution has been added in kernel v2.6.31 with commit
ec20a022aa24fc63. However, uinput was never updated since, meaning that
devices cannot be emulated in full. User-space processes that rely on the
resolution to be accurate need this.

Resolution is added in struct uinput_user_dev in a way it won't break
current programs relying on the old implementation.

Bump the UINPUT_VERSION number to 4 to aid detection of this in user-space.

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/input/misc/uinput.c | 17 ++++++++++++-----
 include/linux/uinput.h      |  2 ++
 include/uapi/linux/uinput.h |  3 +++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index a0a4bba..7d518b4 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -20,6 +20,8 @@
  * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
  *
  * Changes/Revisions:
+ *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
+ *		- update uinput_user_dev struct to allow abs resolution
  *	0.3	09/04/2006 (Anssi Hannula <anssi.hannula@gmail.com>)
  *		- updated ff support for the changes in kernel interface
  *		- added MODULE_VERSION
@@ -364,9 +366,9 @@ static int uinput_setup_device(struct uinput_device *udev,
 	struct input_dev	*dev;
 	int			i;
 	int			retval;
+	size_t			size;
 
-	if (count != sizeof(struct uinput_user_dev))
-		return -EINVAL;
+	size = min_t(size_t, count, sizeof(struct uinput_user_dev));
 
 	if (!udev->dev) {
 		retval = uinput_allocate_device(udev);
@@ -376,9 +378,13 @@ static int uinput_setup_device(struct uinput_device *udev,
 
 	dev = udev->dev;
 
-	user_dev = memdup_user(buffer, sizeof(struct uinput_user_dev));
-	if (IS_ERR(user_dev))
-		return PTR_ERR(user_dev);
+	user_dev = kzalloc(sizeof(struct uinput_user_dev), GFP_KERNEL);
+	if (!user_dev)
+		return -ENOMEM;
+	if (copy_from_user(user_dev, buffer, size)) {
+		retval = -EFAULT;
+		goto exit;
+	}
 
 	udev->ff_effects_max = user_dev->ff_effects_max;
 
@@ -406,6 +412,7 @@ static int uinput_setup_device(struct uinput_device *udev,
 		input_abs_set_min(dev, i, user_dev->absmin[i]);
 		input_abs_set_fuzz(dev, i, user_dev->absfuzz[i]);
 		input_abs_set_flat(dev, i, user_dev->absflat[i]);
+		input_abs_set_res(dev, i, user_dev->absres[i]);
 	}
 
 	/* check if absmin/absmax/absfuzz/absflat are filled as
diff --git a/include/linux/uinput.h b/include/linux/uinput.h
index 0a4487d..6291a22 100644
--- a/include/linux/uinput.h
+++ b/include/linux/uinput.h
@@ -20,6 +20,8 @@
  * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
  *
  * Changes/Revisions:
+ *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
+ *		- update uinput_user_dev struct to allow abs resolution
  *	0.3	24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
  *		- update ff support for the changes in kernel interface
  *		- add UINPUT_VERSION
diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
index fe46431..f6a393b 100644
--- a/include/uapi/linux/uinput.h
+++ b/include/uapi/linux/uinput.h
@@ -20,6 +20,8 @@
  * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
  *
  * Changes/Revisions:
+ *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
+ *		- update uinput_user_dev struct to allow abs resolution
  *	0.3	24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
  *		- update ff support for the changes in kernel interface
  *		- add UINPUT_VERSION
@@ -133,5 +135,6 @@ struct uinput_user_dev {
 	__s32 absmin[ABS_CNT];
 	__s32 absfuzz[ABS_CNT];
 	__s32 absflat[ABS_CNT];
+	__s32 absres[ABS_CNT];
 };
 #endif /* _UAPI__UINPUT_H_ */
-- 
1.8.3.1

