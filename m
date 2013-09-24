Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3IXJrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:47:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:13092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3IXJq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:46:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,969,1371106800"; 
   d="scan'208";a="364767602"
From: Aaron Lu <aaron.lu@intel.com>
To: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Ben Jencks <ben@bjencks.net>,
        Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH v3 1/4] backlight: introduce backlight_device_registered
Date: Tue, 24 Sep 2013 17:47:29 +0800
Message-Id: <1380016052-15315-2-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
In-Reply-To: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new API for modules to query if a specific type of backlight
device has been registered. This is useful for some backlight device
provider module(e.g. ACPI video) to know if a native control
interface(e.g. the interface created by i915) is available and then do
things accordingly(e.g. avoid register its own on Win8 systems).

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
---
 drivers/video/backlight/backlight.c | 31 +++++++++++++++++++++++++++++++
 include/linux/backlight.h           |  4 ++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 94a403a..bf2d71d 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -21,6 +21,9 @@
 #include <asm/backlight.h>
 #endif
 
+static struct list_head bd_list_head;
+static struct mutex bd_list_mutex;
+
 static const char *const backlight_types[] = {
 	[BACKLIGHT_RAW] = "raw",
 	[BACKLIGHT_PLATFORM] = "platform",
@@ -349,10 +352,32 @@ struct backlight_device *backlight_device_register(const char *name,
 	mutex_unlock(&pmac_backlight_mutex);
 #endif
 
+	mutex_lock(&bd_list_mutex);
+	list_add(&new_bd->entry, &bd_list_head);
+	mutex_unlock(&bd_list_mutex);
+
 	return new_bd;
 }
 EXPORT_SYMBOL(backlight_device_register);
 
+bool backlight_device_registered(enum backlight_type type)
+{
+	bool found = false;
+	struct backlight_device *bd;
+
+	mutex_lock(&bd_list_mutex);
+	list_for_each_entry(bd, &bd_list_head, entry) {
+		if (bd->props.type == type) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&bd_list_mutex);
+
+	return found;
+}
+EXPORT_SYMBOL(backlight_device_registered);
+
 /**
  * backlight_device_unregister - unregisters a backlight device object.
  * @bd: the backlight device object to be unregistered and freed.
@@ -364,6 +389,10 @@ void backlight_device_unregister(struct backlight_device *bd)
 	if (!bd)
 		return;
 
+	mutex_lock(&bd_list_mutex);
+	list_del(&bd->entry);
+	mutex_unlock(&bd_list_mutex);
+
 #ifdef CONFIG_PMAC_BACKLIGHT
 	mutex_lock(&pmac_backlight_mutex);
 	if (pmac_backlight == bd)
@@ -499,6 +528,8 @@ static int __init backlight_class_init(void)
 
 	backlight_class->dev_groups = bl_device_groups;
 	backlight_class->pm = &backlight_class_dev_pm_ops;
+	INIT_LIST_HEAD(&bd_list_head);
+	mutex_init(&bd_list_mutex);
 	return 0;
 }
 
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 53b7794..5f9cd96 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -100,6 +100,9 @@ struct backlight_device {
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
 
+	/* list entry of all registered backlight devices */
+	struct list_head entry;
+
 	struct device dev;
 };
 
@@ -123,6 +126,7 @@ extern void devm_backlight_device_unregister(struct device *dev,
 					struct backlight_device *bd);
 extern void backlight_force_update(struct backlight_device *bd,
 				   enum backlight_update_reason reason);
+extern bool backlight_device_registered(enum backlight_type type);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
-- 
1.8.4.12.g2ea3df6

