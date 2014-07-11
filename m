Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaGKOEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49151 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaGKOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:39 -0400
X-AuditID: cbfee61a-f79e46d00000134f-74-53bfeef5fdf6
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 02/21] leds: implement sysfs interface locking mechanism
Date: Fri, 11 Jul 2014 16:04:05 +0200
Message-id: <1405087464-13762-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2v7/YHG1zaJmaxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8bpO33sBR90Kvbu/8jYwLhAtYuRk0NCwERiyrXVLBC2
	mMSFe+vZuhi5OIQEpjNKXP/0iBXCaWeSeLvpLStIFZuAocTPF6+ZQGwRgXKJnvfPwDqYBVYz
	StzZ+hWsSFjAX2Jx40ygsRwcLAKqEls3BICEeQU8JM69b2AFCUsIKEjMmWQDEuYU8JQ42H+T
	DcQWAip5uPYE+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsPrmdQOxpUNFocY
	BTgYlXh4FdbvCxZiTSwrrsw9xCjBwawkwnv1zf5gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLJMHJxSDYwzQwu+KFaHmS2accN1sazhafbg5xG+K2oelN9/O2Um
	7xl3n19tumsY3Ra2R/hfKXWfWzRr1S4T/ts2s35ssAqzbH5a3xPdH3eRI8vRz0ktpPbp+vy8
	Y9vX//q20+eInpepieink7Pe6TD8iV6lWfO9XKZ305cXHZbGP6My8rXK/D7syb6o/laJpTgj
	0VCLuag4EQDt3pgYKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mechanism for locking LED subsystem sysfs interface.
This patch prepares ground for addition of LED Flash Class extension.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c    |   13 +++++++++++--
 drivers/leds/led-core.c     |   18 ++++++++++++++++++
 drivers/leds/led-triggers.c |   11 ++++++++---
 include/linux/leds.h        |   31 +++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index aa29198..ea04891 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -45,17 +45,23 @@ static ssize_t brightness_store(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	unsigned long state;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
 
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
 	__led_set_brightness(led_cdev, state);
 
 	return size;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 static DEVICE_ATTR_RW(brightness);
 
@@ -219,6 +225,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
+	mutex_init(&led_cdev->led_lock);
 	/* add to the list of leds */
 	down_write(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
@@ -272,6 +279,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
+
+	mutex_destroy(&led_cdev->led_lock);
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 71b40d3..4d7cb31 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -126,3 +126,21 @@ void led_set_brightness(struct led_classdev *led_cdev,
 	__led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_set_brightness);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_lock(struct led_classdev *led_cdev)
+{
+	WARN_ON(!mutex_is_locked(&led_cdev->led_lock));
+
+	led_cdev->flags |= LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL_GPL(led_sysfs_lock);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_unlock(struct led_classdev *led_cdev)
+{
+	WARN_ON(!mutex_is_locked(&led_cdev->led_lock));
+
+	led_cdev->flags &= ~LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL_GPL(led_sysfs_unlock);
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index c3734f1..0545530 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -37,6 +37,9 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	char trigger_name[TRIG_NAME_MAX];
 	struct led_trigger *trig;
 	size_t len;
+	int ret = count;
+
+	mutex_lock(&led_cdev->led_lock);
 
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
@@ -47,7 +50,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 
 	if (!strcmp(trigger_name, "none")) {
 		led_trigger_remove(led_cdev);
-		return count;
+		goto exit_unlock;
 	}
 
 	down_read(&triggers_list_lock);
@@ -58,12 +61,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 			up_write(&led_cdev->trigger_lock);
 
 			up_read(&triggers_list_lock);
-			return count;
+			goto exit_unlock;
 		}
 	}
 	up_read(&triggers_list_lock);
 
-	return -EINVAL;
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(led_trigger_store);
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 995f933..da7c6b5 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -13,6 +13,7 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
 #include <linux/timer.h>
@@ -42,6 +43,7 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT	(1 << 17)
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
+#define LED_SYSFS_LOCK		(1 << 20)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -85,6 +87,9 @@ struct led_classdev {
 	/* true if activated - deactivate routine uses it to do cleanup */
 	bool			activated;
 #endif
+
+	/* Ensures consistent access to the LED Flash Class device */
+	struct mutex		led_lock;
 };
 
 extern int led_classdev_register(struct device *parent,
@@ -140,6 +145,32 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
  */
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
+/**
+ * led_sysfs_lock - lock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Lock the LED's sysfs interface
+ */
+extern void led_sysfs_lock(struct led_classdev *led_cdev);
+
+/**
+ * led_sysfs_unlock - unlock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Unlock the LED's sysfs interface
+ */
+extern void led_sysfs_unlock(struct led_classdev *led_cdev);
+
+/**
+ * led_sysfs_is_locked
+ * @led_cdev: the LED to query
+ *
+ * Returns: true if the sysfs interface of the led is locked
+ */
+static inline bool led_sysfs_is_locked(struct led_classdev *led_cdev)
+{
+	return led_cdev->flags & LED_SYSFS_LOCK;
+}
 
 /*
  * LED Triggers
-- 
1.7.9.5

