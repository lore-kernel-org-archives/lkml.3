Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161564Ab3DEMiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:38:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48911 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161378Ab3DEMiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:38:19 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <durgadoss.r@intel.com>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv3 1/3] thermal: introduce thermal_zone_get_zone_by_name helper function
Date: Fri, 5 Apr 2013 08:32:28 -0400
Message-ID: <1365165150-11720-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1365165150-11720-1-git-send-email-eduardo.valentin@ti.com>
References: <1365165150-11720-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function to get a reference of
a thermal zone, based on the zone type name.

It will perform a zone name lookup and return a reference
to a thermal zone device that matches the name requested.
In case the zone is not found or when several zones match
same name or if the required parameters are invalid, it will return
the corresponding error code (ERR_PTR).

Cc: Durgadoss R <durgadoss.r@intel.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |    1 +
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5bd95d4..e9b636b 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1790,6 +1790,44 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
 
+/**
+ * thermal_zone_get_zone_by_name() - search for a zone and returns its ref
+ * @name: thermal zone name to fetch the temperature
+ *
+ * When only one zone is found with the passed name, returns a reference to it.
+ *
+ * Return: On success returns a reference to an unique thermal zone with
+ * matching name equals to @name, an ERR_PTR otherwise (-EINVAL for invalid
+ * paramenters, -ENODEV for not found and -EEXIST for multiple matches).
+ */
+struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name)
+{
+	struct thermal_zone_device *pos = NULL, *ref = ERR_PTR(-EINVAL);
+	unsigned int found = 0;
+
+	if (!name)
+		goto exit;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(pos, &thermal_tz_list, node)
+		if (!strnicmp(name, pos->type, THERMAL_NAME_LENGTH)) {
+			found++;
+			ref = pos;
+		}
+	mutex_unlock(&thermal_list_lock);
+
+	/* nothing has been found, thus an error code for it */
+	if (found == 0)
+		ref = ERR_PTR(-ENODEV);
+	else if (found > 1)
+	/* Success only when an unique zone is found */
+		ref = ERR_PTR(-EEXIST);
+
+exit:
+	return ref;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_get_zone_by_name);
+
 #ifdef CONFIG_NET
 static struct genl_family thermal_event_genl_family = {
 	.id = GENL_ID_GENERATE,
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 542a39c..0cf9eb5 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -237,6 +237,7 @@ void thermal_zone_device_update(struct thermal_zone_device *);
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
+struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
 
 int thermal_zone_trend_get(struct thermal_zone_device *, int);
 struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
-- 
1.7.7.1.488.ge8e1c

