Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaIJPzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:55:02 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57514 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaIJPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:58 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 3/4] backlight: add kernel-internal backlight API
Date: Wed, 10 Sep 2014 17:54:22 +0200
Message-Id: <1410364463-12692-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far backlights have only been controlled via sysfs. However, sysfs is
not a proper user-space API for runtime modifications, and never was
intended to provide such. The DRM drivers are now prepared to provide
such a backlight link so user-space can control backlight via DRM
connector properties. This allows us to employ the same access-management
we use for mode-setting.

This patch adds few kernel-internal backlight helpers so we can modify
backlights from within DRM.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/backlight/backlight.c | 65 +++++++++++++++++++++++++++++++++++++
 include/linux/backlight.h           | 16 +++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 33b64be..04f323b 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -480,6 +480,71 @@ int backlight_unregister_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL(backlight_unregister_notifier);
 
 /**
+ * backlight_device_lookup - find a backlight device
+ * @name: sysname of the backlight device
+ *
+ * @return Reference to the backlight device, NULL if not found.
+ *
+ * This searches through all registered backlight devices for a device with the
+ * given device name. In case none is found, NULL is returned, otherwise a
+ * new reference to the backlight device is returned. You must drop this
+ * reference via backlight_device_unref() once done.
+ * Note that the devices might get unregistered at any time. You need to lock
+ * around this lookup and inside of your backlight-notifier if you need to know
+ * when a device gets unregistered.
+ *
+ * This function can be safely called from IRQ context.
+ */
+struct backlight_device *backlight_device_lookup(const char *name)
+{
+	struct backlight_device *bd;
+	unsigned long flags;
+	const char *t;
+
+	spin_lock_irqsave(&backlight_dev_list_lock, flags);
+
+	list_for_each_entry(bd, &backlight_dev_list, entry) {
+		t = dev_name(&bd->dev);
+		if (t && !strcmp(t, name))
+			goto out;
+	}
+
+	bd = NULL;
+
+out:
+	spin_unlock_irqrestore(&backlight_dev_list_lock, flags);
+	backlight_device_ref(bd);
+	return bd;
+}
+EXPORT_SYMBOL_GPL(backlight_device_lookup);
+
+/**
+ * backlight_set_brightness - set brightness on a backlight device
+ * @bd: backlight device to operate on
+ * @value: brightness value to set on the device
+ * @reason: backlight-change reason to use for notifications
+ *
+ * This is the in-kernel API equivalent of writing into the 'brightness' sysfs
+ * file. It calls into the underlying backlight driver to change the brightness
+ * value. The value is clamped according to device bounds.
+ * A uevent notification is sent with the reason set to @reason.
+ */
+void backlight_set_brightness(struct backlight_device *bd, unsigned int value,
+			      enum backlight_update_reason reason)
+{
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops) {
+		value = clamp(value, 0U, (unsigned)bd->props.max_brightness);
+		pr_debug("set brightness to %u\n", value);
+		bd->props.brightness = value;
+		backlight_update_status(bd);
+	}
+	mutex_unlock(&bd->ops_lock);
+	backlight_generate_event(bd, reason);
+}
+EXPORT_SYMBOL_GPL(backlight_set_brightness);
+
+/**
  * devm_backlight_device_register - resource managed backlight_device_register()
  * @dev: the device to register
  * @name: the name of the device
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index adb14a8..bcc0dec 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -141,6 +141,22 @@ extern bool backlight_device_registered(enum backlight_type type);
 extern int backlight_register_notifier(struct notifier_block *nb);
 extern int backlight_unregister_notifier(struct notifier_block *nb);
 
+struct backlight_device *backlight_device_lookup(const char *name);
+void backlight_set_brightness(struct backlight_device *bd, unsigned int value,
+			      enum backlight_update_reason reason);
+
+static inline void backlight_device_ref(struct backlight_device *bd)
+{
+	if (bd)
+		get_device(&bd->dev);
+}
+
+static inline void backlight_device_unref(struct backlight_device *bd)
+{
+	if (bd)
+		put_device(&bd->dev);
+}
+
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
 static inline void * bl_get_data(struct backlight_device *bl_dev)
-- 
2.1.0

