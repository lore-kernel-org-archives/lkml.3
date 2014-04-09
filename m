Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846AbaDIPVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:21:35 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:54116 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933256AbaDIPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:21:29 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC PATCH 1/2] drivers/base: add new devres_update() interface to devres_*
Date: Wed,  9 Apr 2014 09:21:07 -0600
Message-Id: <e73e82c4b19e33171c3c5be991dc7f3d3f51d0a6.1397050852.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1397050852.git.shuah.kh@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1397050852.git.shuah.kh@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Media devices often have hardware resources that are shared
across several functions. For instance, TV tuner cards often
have MUXes, converters, radios, tuners, etc. that are shared
across various functions. However, v4l2, alsa, DVB, usbfs, and
all other drivers have no knowledge of what resources are
shared. For example, users can't access DVB and alsa at the same
time, or the DVB and V4L analog API at the same time, since many
only have one converter that can be in either analog or digital
mode. Accessing and/or changing mode of a converter while it is
in use by another function results in video stream error.

A shared devres that can be locked and unlocked by various drivers
that control media functions on a single media device is needed to
address the above problems.

A token devres that can be looked up by a token for locking, try
locking, unlocking will help avoid adding data structure
dependencies between various media drivers. This token is a unique
string that can be constructed from a common data structure such as
struct device, bus_name, and hardware address.

A new devres_* interface to update the status of this token resource
to busy when locked and free when unlocked is necessary to implement
this new managed resource.

devres_update() searches for the resource that matches supplied match
criteria similar to devres_find(). When a match is found, it calls
the update function caller passed in.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/devres.c  |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    4 ++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index db4e264..8620600 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -272,6 +272,42 @@ void * devres_find(struct device *dev, dr_release_t release,
 EXPORT_SYMBOL_GPL(devres_find);
 
 /**
+ * devres_update - Find device resource and call update function
+ * @dev: Device to lookup resource from
+ * @release: Look for resources associated with this release function
+ * @match: Match function - must be specified
+ * @match_data: Data for the match function
+ * @update: Update function - must be specified
+ *
+ * Find the latest devres of @dev which is associated with @release
+ * and for which @match returns 1. If match is found, update will be
+ * called. This is intended for changes to status type data in a devres
+ *
+ * RETURNS:
+ * Pointer to found and updated devres, NULL if not found.
+ */
+void *devres_update(struct device *dev, dr_release_t release,
+		   dr_match_t match, void *match_data, dr_update_t update)
+{
+	struct devres *dr;
+	unsigned long flags;
+
+	if (!match || !update)
+		return NULL;
+
+	spin_lock_irqsave(&dev->devres_lock, flags);
+	dr = find_dr(dev, release, match, match_data);
+	if (dr)
+		update(dev, dr->data);
+	spin_unlock_irqrestore(&dev->devres_lock, flags);
+
+	if (dr)
+		return dr->data;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(devres_update);
+
+/**
  * devres_get - Find devres, if non-existent, add one atomically
  * @dev: Device to lookup or add devres for
  * @new_res: Pointer to new initialized devres to add if not found
diff --git a/include/linux/device.h b/include/linux/device.h
index 233bbbe..39749df 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -576,6 +576,7 @@ extern int device_schedule_callback_owner(struct device *dev,
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
 typedef int (*dr_match_t)(struct device *dev, void *res, void *match_data);
+typedef void (*dr_update_t)(struct device *dev, void *data);
 
 #ifdef CONFIG_DEBUG_DEVRES
 extern void *__devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
@@ -593,6 +594,9 @@ extern void devres_free(void *res);
 extern void devres_add(struct device *dev, void *res);
 extern void *devres_find(struct device *dev, dr_release_t release,
 			 dr_match_t match, void *match_data);
+extern void *devres_update(struct device *dev, dr_release_t release,
+			dr_match_t match, void *match_data,
+			dr_update_t update);
 extern void *devres_get(struct device *dev, void *new_res,
 			dr_match_t match, void *match_data);
 extern void *devres_remove(struct device *dev, dr_release_t release,
-- 
1.7.10.4

