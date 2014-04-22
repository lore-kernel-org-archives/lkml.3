Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaDVPLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:11:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45199 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaDVPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:10:57 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 4/5] drm: Introduce drm_set_unique()
Date: Tue, 22 Apr 2014 17:09:32 +0200
Message-Id: <1398179373-29966-5-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add a helper function that allows drivers to statically set the unique
name of the device. This will allow platform and USB drivers to get rid
of their DRM bus implementations and directly use drm_dev_alloc() and
drm_dev_register().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_ioctl.c | 37 +++++++++++++++++++++++++++++++------
 drivers/gpu/drm/drm_stub.c  |  1 +
 include/drm/drmP.h          |  3 +++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 2dd3a6d8382b..371db3bef60c 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -42,6 +42,20 @@
 #include <asm/mtrr.h>
 #endif
 
+int drm_set_unique(struct drm_device *dev, const char *fmt, ...)
+{
+	va_list ap;
+
+	kfree(dev->unique);
+
+	va_start(ap, fmt);
+	dev->unique = kvasprintf(GFP_KERNEL, fmt, ap);
+	va_end(ap);
+
+	return dev->unique ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL(drm_set_unique);
+
 /**
  * Get the bus id.
  *
@@ -131,13 +145,24 @@ static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
 	if (master->unique != NULL)
 		drm_unset_busid(dev, master);
 
-	ret = dev->driver->bus->set_busid(dev, master);
-	if (ret)
-		goto err;
+	if (dev->driver->bus && dev->driver->bus->set_busid) {
+		ret = dev->driver->bus->set_busid(dev, master);
+		if (ret) {
+			drm_unset_busid(dev, master);
+			return ret;
+		}
+	} else {
+		WARN(dev->unique == NULL,
+		     "No drm_bus.set_busid() implementation provided by %ps. "
+		     "Set the unique name explicitly using drm_set_unique().",
+		     dev->driver);
+
+		master->unique = kstrdup(dev->unique, GFP_KERNEL);
+		if (master->unique)
+			master->unique_len = strlen(dev->unique);
+	}
+
 	return 0;
-err:
-	drm_unset_busid(dev, master);
-	return ret;
 }
 
 /**
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 3a8e832ad151..9465cf766fe7 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -646,6 +646,7 @@ static void drm_dev_release(struct kref *ref)
 	drm_minor_free(dev, DRM_MINOR_CONTROL);
 
 	mutex_destroy(&dev->master_mutex);
+	kfree(dev->unique);
 	kfree(dev);
 }
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 8c80c1894b41..8fdefcdc4036 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1158,6 +1158,8 @@ struct drm_device {
 	struct drm_vma_offset_manager *vma_offset_manager;
 	/*@} */
 	int switch_power_state;
+
+	char *unique;
 };
 
 #define DRM_SWITCH_POWER_ON 0
@@ -1238,6 +1240,7 @@ extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);
 				/* Misc. IOCTL support (drm_ioctl.h) */
 extern int drm_irq_by_busid(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv);
+extern int drm_set_unique(struct drm_device *dev, const char *fmt, ...);
 extern int drm_getunique(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv);
 extern int drm_setunique(struct drm_device *dev, void *data,
-- 
1.9.2

