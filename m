Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3CJLdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:33:06 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:41601 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab3CJLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:33:03 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net E589F3DC324
Subject: [PATCH 3/5] HID: roccat: Removed profile change reports for
 outside changes
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:33:00 +0100
Message-ID: <1362915180.2769.168.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userland-tools don't need to be notified about changes they issued themselves
anymore.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-isku.c     |    6 ------
 drivers/hid/hid-roccat-kone.c     |   16 +---------------
 drivers/hid/hid-roccat-koneplus.c |    7 -------
 drivers/hid/hid-roccat-kovaplus.c |    8 --------
 drivers/hid/hid-roccat-pyra.c     |    7 -------
 5 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index b43c792..8ac83bb 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -77,7 +77,6 @@ static ssize_t isku_sysfs_set_actual_profile(struct device *dev,
 	struct usb_device *usb_dev;
 	unsigned long profile;
 	int retval;
-	struct isku_roccat_report roccat_report;
 
 	dev = dev->parent->parent;
 	isku = hid_get_drvdata(dev_get_drvdata(dev));
@@ -98,11 +97,6 @@ static ssize_t isku_sysfs_set_actual_profile(struct device *dev,
 		return retval;
 	}
 
-	roccat_report.event = ISKU_REPORT_BUTTON_EVENT_PROFILE;
-	roccat_report.data1 = profile + 1;
-	roccat_report.data2 = 0;
-	roccat_report_event(isku->chrdev_minor, (uint8_t const *)&roccat_report);
-
 	mutex_unlock(&isku->isku_lock);
 
 	return size;
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 9ce2d0b..49132f8 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -43,15 +43,6 @@ static void kone_profile_activated(struct kone_device *kone, uint new_profile)
 	kone->actual_dpi = kone->profiles[new_profile - 1].startup_dpi;
 }
 
-static void kone_profile_report(struct kone_device *kone, uint new_profile)
-{
-	struct kone_roccat_report roccat_report;
-	roccat_report.event = kone_mouse_event_switch_profile;
-	roccat_report.value = new_profile;
-	roccat_report.key = 0;
-	roccat_report_event(kone->chrdev_minor, (uint8_t *)&roccat_report);
-}
-
 static int kone_receive(struct usb_device *usb_dev, uint usb_command,
 		void *data, uint size)
 {
@@ -296,7 +287,7 @@ static ssize_t kone_sysfs_write_settings(struct file *fp, struct kobject *kobj,
 			container_of(kobj, struct device, kobj)->parent->parent;
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0, difference, old_profile;
+	int retval = 0, difference;
 
 	/* I need to get my data in one piece */
 	if (off != 0 || count != sizeof(struct kone_settings))
@@ -312,13 +303,9 @@ static ssize_t kone_sysfs_write_settings(struct file *fp, struct kobject *kobj,
 			return retval;
 		}
 
-		old_profile = kone->settings.startup_profile;
 		memcpy(&kone->settings, buf, sizeof(struct kone_settings));
 
 		kone_profile_activated(kone, kone->settings.startup_profile);
-
-		if (kone->settings.startup_profile != old_profile)
-			kone_profile_report(kone, kone->settings.startup_profile);
 	}
 	mutex_unlock(&kone->kone_lock);
 
@@ -565,7 +552,6 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 
 	/* changing the startup profile immediately activates this profile */
 	kone_profile_activated(kone, new_startup_profile);
-	kone_profile_report(kone, new_startup_profile);
 
 	mutex_unlock(&kone->kone_lock);
 	return size;
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 1c9ed19..ddedcba 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -240,7 +240,6 @@ static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
 	struct usb_device *usb_dev;
 	unsigned long profile;
 	int retval;
-	struct koneplus_roccat_report roccat_report;
 
 	dev = dev->parent->parent;
 	koneplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -261,12 +260,6 @@ static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
 		return retval;
 	}
 
-	roccat_report.type = KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE;
-	roccat_report.data1 = profile + 1;
-	roccat_report.data2 = 0;
-	roccat_report_event(koneplus->chrdev_minor,
-			(uint8_t const *)&roccat_report);
-
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	return size;
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index eac248d..4644b6e 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -281,7 +281,6 @@ static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
 	struct usb_device *usb_dev;
 	unsigned long profile;
 	int retval;
-	struct kovaplus_roccat_report roccat_report;
 
 	dev = dev->parent->parent;
 	kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -303,13 +302,6 @@ static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
 
 	kovaplus_profile_activated(kovaplus, profile);
 
-	roccat_report.type = KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_1;
-	roccat_report.button = 0;
-	roccat_report.data1 = profile + 1;
-	roccat_report.data2 = 0;
-	roccat_report_event(kovaplus->chrdev_minor,
-			(uint8_t const *)&roccat_report);
-
 	mutex_unlock(&kovaplus->kovaplus_lock);
 
 	return size;
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index d4f1e3b..337329e4 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -230,7 +230,6 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval = 0;
-	struct pyra_roccat_report roccat_report;
 	struct pyra_settings const *settings;
 
 	if (off != 0 || count != PYRA_SIZE_SETTINGS)
@@ -248,12 +247,6 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 
 	profile_activated(pyra, settings->startup_profile);
 
-	roccat_report.type = PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2;
-	roccat_report.value = settings->startup_profile + 1;
-	roccat_report.key = 0;
-	roccat_report_event(pyra->chrdev_minor,
-			(uint8_t const *)&roccat_report);
-
 	mutex_unlock(&pyra->pyra_lock);
 	return PYRA_SIZE_SETTINGS;
 }
-- 
1.7.3.4



