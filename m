Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423156Ab3CVVNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:13:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44029 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423058Ab3CVVNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:13:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 1/2] thermal: introduce thermal_zone_lookup_temperature helper function
Date: Fri, 22 Mar 2013 17:13:06 -0400
Message-ID: <1363986787-28147-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function to get temperature of
a thermal zone, based on the zone type name.

It will perform a zone name lookup and return the last
sensor temperature reading. In case the zone is not found
or if the required parameters are invalid, it will return
the corresponding error code.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/thermal.h       |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5bd95d4..f0caa13 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1790,6 +1790,38 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
 
+/**
+ * thermal_lookup_temperature - search for a zone and returns its temperature
+ * @name: thermal zone name to fetch the temperature
+ * @temperature: pointer to store the zone temperature, in case it is found
+ *
+ * When the zone is found, updates @temperature and returns 0.
+ *
+ * Return: -EINVAL in case of wrong parameters, -ENODEV in case the zone
+ * is not found and 0 when it is successfully found.
+ */
+int thermal_zone_lookup_temperature(const char *name, int *temperature)
+{
+	struct thermal_zone_device *pos = NULL;
+	bool found = false;
+
+	if (!name || !temperature)
+		return -EINVAL;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(pos, &thermal_tz_list, node)
+		if (!strcmp(pos->type, name)) {
+			found = true;
+			break;
+		}
+	if (found)
+		*temperature = pos->last_temperature;
+	mutex_unlock(&thermal_list_lock);
+
+	return found ? 0 : -ENODEV;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_lookup_temperature);
+
 #ifdef CONFIG_NET
 static struct genl_family thermal_event_genl_family = {
 	.id = GENL_ID_GENERATE,
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 542a39c..2b2f902 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -237,6 +237,7 @@ void thermal_zone_device_update(struct thermal_zone_device *);
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
+int thermal_zone_lookup_temperature(const char *name, int *temperature);
 
 int thermal_zone_trend_get(struct thermal_zone_device *, int);
 struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
-- 
1.7.7.1.488.ge8e1c

