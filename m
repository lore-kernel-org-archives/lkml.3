Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3FKWEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:04:01 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37827 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3FKWEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:04:00 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        James Hogan <james.hogan@imgtec.com>, linux-sh@vger.kernel.org
Subject: [RFC] pinctrl: generic: Add DT bindings
Date: Wed, 12 Jun 2013 00:03:57 +0200
Message-Id: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document DT properties for the generic pinctrl parameters and add a
parser function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          | 29 +++++++
 drivers/pinctrl/pinconf-generic.c                  | 94 ++++++++++++++++++++++
 drivers/pinctrl/pinconf.h                          | 17 ++++
 3 files changed, 140 insertions(+)

I've successfully tested this patch (or more accurately only the pull-up and
pull-down properties) with the Renesas sh-pfc pinctrl device driver. I will
resent the sh-pfc DT bindings patch series rebased on the generic pinconf
bindings.

Not all generic pinconf properties are currently implemented, but I don't
think that should be a showstopper. We can add them later as needed.

The code is based on both the sh-pfc pinconf DT parser and James Hogan's
tz1090 DT parser ("[PATCH v2 6/9] pinctrl-tz1090: add TZ1090 pinctrl driver").

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index c95ea82..e499ff0 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -126,3 +126,32 @@ device; they may be grandchildren, for example. Whether this is legal, and
 whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
+
+== Generic pinconf parameters ==
+
+Pin configuration parameters are expressed by DT properties in the pin
+controller device state nodes and child nodes. For devices that use the generic
+pinconf parameters the following properties are defined.
+
+- tristate: A boolean, put the pin into high impedance state when set.
+
+- pull-up: An integer representing the pull-up strength. 0 disables the pull-up,
+  non-zero values enable it.
+
+- pull-down: An integer representing the pull-down strength. 0 disables the
+  pull-down, non-zero values enables it.
+
+- schmitt: An integer, enable or disable Schmitt trigger mode for the pins.
+  Valid values are
+    0: Schmitt trigger disabled (no hysteresis)
+    1: Schmitt trigger enabled
+
+- slew-rate: An integer controlling the pin slew rate. Values are device-
+  dependent.
+
+- drive-strength: An integer representing the drive strength of pins in mA.
+  Valid values are device-dependent.
+
+The pinctrl device DT bindings documentation must list the properties that
+apply to the device, and define the valid range for all device-dependent
+values.
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 2ad5a8d..bd0e41d 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -135,3 +136,96 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
 #endif
+
+struct pinconf_generic_param {
+	const char *property;
+	enum pin_config_param param;
+	bool flag;
+};
+
+static const struct pinconf_generic_param pinconf_generic_params[] = {
+	{ "tristate",		PIN_CONFIG_BIAS_HIGH_IMPEDANCE,		true },
+	{ "pull-up",		PIN_CONFIG_BIAS_PULL_UP,		false },
+	{ "pull-down",		PIN_CONFIG_BIAS_PULL_DOWN,		false },
+	{ "schmitt",		PIN_CONFIG_INPUT_SCHMITT_ENABLE,	true },
+	{ "slew-rate",		PIN_CONFIG_SLEW_RATE,			false },
+	{ "drive-strength",	PIN_CONFIG_DRIVE_STRENGTH,		false },
+};
+
+static int pinconf_generic_add_config(unsigned long **configs,
+				      unsigned int *num_configs,
+				      unsigned long config)
+{
+	unsigned int count = *num_configs + 1;
+	unsigned long *cfgs;
+
+	cfgs = krealloc(*configs, sizeof(*cfgs) * count, GFP_KERNEL);
+	if (cfgs == NULL)
+		return -ENOMEM;
+
+	cfgs[count - 1] = config;
+
+	*configs = cfgs;
+	*num_configs = count;
+
+	return 0;
+}
+
+/**
+ * pinconf_generic_parse_params - Parse generic pinconf parameters from DT
+ * @dev: the device, used to print error messages
+ * @np: the DT node that contains generic pinconf parameters
+ * @cfgs: the returned array of pinconf parameters
+ *
+ * The parameters array is allocated dynamically and returned through the cfgs
+ * argument. The caller is responsible for freeing the array with kfree(). If no
+ * configuration parameter is found, or if an error occurs, no parameters array
+ * will be allocated and the cfgs argument will be set to NULL.
+ *
+ * Return the number of configuration parameters successfully parsed, or a
+ * negative value if an error occurred. Used error codes are
+ *
+ * -ENOMEM if memory can't be allocated for the parameters array
+ */
+int pinconf_generic_parse_params(struct device *dev, struct device_node *np,
+				 unsigned long **cfgs)
+{
+	unsigned long *configs = NULL;
+	unsigned int num_configs = 0;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(pinconf_generic_params); ++i) {
+		const struct pinconf_generic_param *param =
+			&pinconf_generic_params[i];
+		unsigned long config;
+		u32 val;
+
+		if (param->flag) {
+			ret = of_property_read_bool(np, param->property)
+			    ? 0 : -EINVAL;
+			val = 1;
+		} else {
+			ret = of_property_read_u32(np, param->property, &val);
+		}
+
+		if (ret) {
+			if (ret != -EINVAL)
+				dev_err(dev, "failed to parse property %s\n",
+					param->property);
+			continue;
+		}
+
+		config = pinconf_to_config_packed(param->param, val);
+		ret = pinconf_generic_add_config(&configs, &num_configs, config);
+		if (ret < 0) {
+			kfree(configs);
+			*cfgs = NULL;
+			return ret;
+		}
+	}
+
+	*cfgs = configs;
+	return num_configs;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_parse_params);
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 92c7267..eb8550b 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -90,6 +90,23 @@ static inline void pinconf_init_device_debugfs(struct dentry *devroot,
  * pin config.
  */
 
+#if defined(CONFIG_GENERIC_PINCONF)
+
+int pinconf_generic_parse_params(struct device *dev, struct device_node *np,
+				 unsigned long **cfgs);
+
+#else
+
+static inline int pinconf_generic_parse_params(struct device *dev,
+					       struct device_node *np,
+					       unsigned long **cfgs)
+{
+	*cfgs = NULL;
+	return 0;
+}
+
+#endif
+
 #if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_DEBUG_FS)
 
 void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
-- 
Regards,

Laurent Pinchart

