Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbbADGYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 01:24:30 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49362 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbADGYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 01:24:25 -0500
From: Tristan Lelong <tristan@lelong.xyz>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tristan Lelong <tristan@lelong.xyz>
Subject: [PATCH] input: Add soft kill switch for input devices
Date: Sat,  3 Jan 2015 22:24:05 -0800
Message-Id: <1420352645-3706-1-git-send-email-tristan@lelong.xyz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a sysfs attribute named 'mute' to all input devices.
It allows to disable them by software in a generic way.

It can be set to 0 or 1:
echo 1 > /sys/class/input/inputX/mute: will set all the input_events() call to return immediately.
echo 0 > /sys/class/input/inputX/mute: will reset to default behavior.

mute is set to 0 by default when calling alloc_input_device().

Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
---
Hi,

I created this patch to answer a need on my machine: I want to be able to disable momentarily the touchscreen
in order to wipe out a dust or clean the display without creating a mess on my desktop and opened docs.
It seemed consistent to have that kill switch at a central point, and moreover,
it doesn't depend on any tool linked to a specifc X server, graphical toolkit, desktop environment...

This patch uses the 0/1 values to enable or disable the mute, but I could update it to use
enable/disable instead if it is preferred.
Also, the permissions are write for group or ownoer only.
I thought about setting it world writable in order to allow easy shortcut creation, but it might also be a security flaw.

Let me know what you think about all this, at least it is really useful in my case, linked to a keyboard shortcut.

Best regards
---
 drivers/input/input.c | 30 +++++++++++++++++++++++++++++-
 include/linux/input.h |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index a1e609a..2f80fee 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -425,7 +425,7 @@ void input_event(struct input_dev *dev,
 {
 	unsigned long flags;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if (!dev->mute && is_event_supported(type, dev->evbit, EV_MAX)) {
 
 		spin_lock_irqsave(&dev->event_lock, flags);
 		input_handle_event(dev, type, code, value);
@@ -1384,10 +1384,38 @@ static ssize_t input_dev_show_properties(struct device *dev,
 }
 static DEVICE_ATTR(properties, S_IRUGO, input_dev_show_properties, NULL);
 
+static ssize_t input_dev_show_mute(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", input_dev->mute);
+}
+
+static ssize_t input_dev_store_mute(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	int err;
+	long mute;
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	err = kstrtol(buf, 0, &mute);
+	if (err < 0)
+		return err;
+	input_dev->mute = mute;
+
+	return count;
+}
+static DEVICE_ATTR(mute, S_IRUGO | S_IWUSR | S_IWGRP, input_dev_show_mute,
+		   input_dev_store_mute);
+
 static struct attribute *input_dev_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_phys.attr,
 	&dev_attr_uniq.attr,
+	&dev_attr_mute.attr,
 	&dev_attr_modalias.attr,
 	&dev_attr_properties.attr,
 	NULL
diff --git a/include/linux/input.h b/include/linux/input.h
index 3b4c32f..e45672f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -151,6 +151,7 @@ struct input_dev {
 
 	struct ff_device *ff;
 
+	unsigned int mute;
 	unsigned int repeat_key;
 	struct timer_list timer;
 
-- 
2.1.3

