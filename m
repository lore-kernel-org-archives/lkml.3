Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJ0QXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:23:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39723 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaJ0QXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:23:46 -0400
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, johan@kernel.org, linux-pm@vger.kernel.org,
        linux@roeck-us.net, lee.jones@linaro.org, balbi@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v1 01/10] of: Rename "poweroff-source" property to "system-power-controller"
Date: Mon, 27 Oct 2014 16:26:46 +0000
Message-Id: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed on the mailing list, it makes more sense to rename this property
to "system-power-controller". Problem being that the word "source" usually tends
to be used for inputs and that is out of control of the OS. The poweroff
capability is an output which simply turns the system-power off. Also, this
property might be used by drivers which power-off the system and power back on
subsequent RTC alarms. This seems to suggest to remove "poweroff" from the
property name and to choose "system-power-controller" as the more generic name.
This patchs adds the required renaming changes and defines an helper function
which is compatible with both properties, the old one prefixed by a vendor name
and the new one without any prefix.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 include/linux/of.h | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 27b3ba1..c1ed2a5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -867,14 +867,33 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
 extern int of_resolve_phandles(struct device_node *tree);
 
 /**
- * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
+ * of_is_system_power_controller - Tells if the property for controlling system
+ * power is found in device_node.
  * @np: Pointer to the given device_node
  *
  * return true if present false otherwise
  */
-static inline bool of_system_has_poweroff_source(const struct device_node *np)
-{
-	return of_property_read_bool(np, "poweroff-source");
+static inline bool of_is_system_power_controller(const struct device_node *np)
+{
+	struct property *pp;
+	unsigned long flags;
+	char *sep;
+	bool found = false;
+
+	raw_spin_lock_irqsave(&devtree_lock, flags);
+	for_each_property_of_node(np, pp) {
+		if (of_prop_cmp(pp->name, "system-power-controller") == 0) {
+			found = true;
+			break;
+		}
+		sep = strchr(pp->name, ',');
+		if (sep && sep - pp->name && of_prop_cmp(sep + 1, "system-power-controller") == 0) {
+			found = true;
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+	return found;
 }
 
 #endif /* _LINUX_OF_H */
-- 
1.9.1

