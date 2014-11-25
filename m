Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaKYM2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:28:39 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60106 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaKYM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:28:36 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: johan@kernel.org, lee.jones@linaro.org, broonie@kernel.org,
        grant.likely@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: [PATCH v5 1/2] of: Rename "poweroff-source" property to "system-power-controller"
Date: Tue, 25 Nov 2014 12:28:25 +0000
Message-Id: <1416918506-9366-2-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").
As discussed on the mailing list, it makes more sense to rename back to the
old established property name, without the vendor prefix. Problem being that
the word "source" usually tends to be used for inputs and that is out of control
of the OS. The poweroff capability is an output which simply turns the
system-power off. Also, this property might be used by drivers which power-off
the system and power back on subsequent RTC alarms. This seems to suggest to
remove "poweroff" from the property name and to choose "system-power-controller"
as the more generic name. This patchs adds the required renaming changes and
defines an helper function which checks if this property is set.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 .../bindings/power/{poweroff.txt => power-controller.txt}           | 0
 Documentation/devicetree/bindings/regulator/act8865-regulator.txt   | 4 ++--
 drivers/regulator/act8865-regulator.c                               | 2 +-
 include/linux/of.h                                                  | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)
 rename Documentation/devicetree/bindings/power/{poweroff.txt => power-controller.txt} (100%)

diff --git a/Documentation/devicetree/bindings/power/poweroff.txt b/Documentation/devicetree/bindings/power/power-controller.txt
similarity index 100%
rename from Documentation/devicetree/bindings/power/poweroff.txt
rename to Documentation/devicetree/bindings/power/power-controller.txt
diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
index 01a5b07..dad6358 100644
--- a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
@@ -6,8 +6,8 @@ Required properties:
 - reg: I2C slave address
 
 Optional properties:
-- poweroff-source: Telling whether or not this pmic is controlling
-  the system power. See Documentation/devicetree/bindings/power/poweroff.txt .
+- system-power-controller: Telling whether or not this pmic is controlling
+  the system power. See Documentation/devicetree/bindings/power/power-controller.txt .
 
 Any standard regulator properties can be used to configure the single regulator.
 
diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index 76301ed..9eec453 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -365,7 +365,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (of_system_has_poweroff_source(dev->of_node)) {
+	if (of_device_is_system_power_controller(dev->of_node)) {
 		if (!pm_power_off) {
 			act8865_i2c_client = client;
 			act8865->off_reg = off_reg;
diff --git a/include/linux/of.h b/include/linux/of.h
index b81dbcf..0abdd70 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -964,14 +964,14 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
 extern int of_resolve_phandles(struct device_node *tree);
 
 /**
- * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
+ * of_device_is_system_power_controller - Tells if system-power-controller is found for device_node
  * @np: Pointer to the given device_node
  *
  * return true if present false otherwise
  */
-static inline bool of_system_has_poweroff_source(const struct device_node *np)
+static inline bool of_device_is_system_power_controller(const struct device_node *np)
 {
-	return of_property_read_bool(np, "poweroff-source");
+	return of_property_read_bool(np, "system-power-controller");
 }
 
 #endif /* _LINUX_OF_H */
-- 
1.9.1

