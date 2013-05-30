Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3E3Nww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:52:52 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:37904 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756669Ab3E3Nw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:52:26 -0400
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 2/3] mfd: twl4030-power: Start transition to DT
Date: Thu, 30 May 2013 15:51:55 +0200
Message-Id: <1369921916-7435-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
References: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for loading twl4030-power module via devicetree.
For now, when booting with a DT, only the poweroff callback
feature is supported through the ti,use_poweroff property.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 .../devicetree/bindings/mfd/twl4030-power.txt      |   28 +++++++
 drivers/mfd/twl4030-power.c                        |   86 +++++++++++++++----
 2 files changed, 96 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-power.txt

diff --git a/Documentation/devicetree/bindings/mfd/twl4030-power.txt b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
new file mode 100644
index 0000000..8e15ec3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
@@ -0,0 +1,28 @@
+Texas Instruments TWL family (twl4030) reset and power management module
+
+The power management module inside the TWL family provides several facilities
+to control the power resources, including power scripts. For now, the
+binding only supports the complete shutdown of the system after poweroff.
+
+Required properties:
+- compatible : must be "ti,twl4030-power"
+
+Optional properties:
+- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
+		   SLEEP-to-OFF transition when the system poweroffs.
+
+Example:
+&i2c1 {
+	clock-frequency = <2600000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+
+		twl_power: power {
+			compatible = "ti,twl4030-power";
+			ti,use_poweroff;
+		};
+	};
+};
diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index c9a2a5c..d12d748 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -28,6 +28,7 @@
 #include <linux/pm.h>
 #include <linux/i2c/twl.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/mach-types.h>
 
@@ -492,6 +493,39 @@ int twl4030_remove_script(u8 flags)
 	return err;
 }
 
+int twl4030_power_configure_scripts(struct twl4030_power_data *pdata)
+{
+	int err;
+	int i;
+	u8 address = twl4030_start_script_address;
+
+	for (i = 0; i < pdata->num; i++) {
+		err = load_twl4030_script(pdata->scripts[i], address);
+		if (err)
+			return err;
+		address += pdata->scripts[i]->size;
+	}
+
+	return 0;
+}
+
+int twl4030_power_configure_resources(struct twl4030_power_data *pdata)
+{
+	struct twl4030_resconfig *resconfig = pdata->resource_config;
+	int err;
+
+	if (resconfig) {
+		while (resconfig->resource) {
+			err = twl4030_configure_resource(resconfig);
+			if (err)
+				return err;
+			resconfig++;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * In master mode, start the power off sequence.
  * After a successful execution, TWL shuts down the power to the SoC
@@ -507,13 +541,29 @@ void twl4030_power_off(void)
 		pr_err("TWL4030 Unable to power off\n");
 }
 
+static bool twl4030_power_use_poweroff(struct twl4030_power_data *pdata,
+					struct device_node *node)
+{
+	if (pdata && pdata->use_poweroff)
+		return true;
+
+	if (of_property_read_bool(node, "ti,use_poweroff"))
+		return true;
+
+	return false;
+}
+
 int twl4030_power_probe(struct platform_device *pdev)
 {
 	struct twl4030_power_data *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	int err = 0;
-	int i;
-	struct twl4030_resconfig *resconfig;
-	u8 val, address = twl4030_start_script_address;
+	u8 val;
+
+	if (!pdata && !node) {
+		dev_err(&pdev->dev, "Platform data is missing\n");
+		return -EINVAL;
+	}
 
 	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
 			       TWL4030_PM_MASTER_PROTECT_KEY);
@@ -525,26 +575,17 @@ int twl4030_power_probe(struct platform_device *pdev)
 	if (err)
 		goto unlock;
 
-	for (i = 0; i < pdata->num; i++) {
-		err = load_twl4030_script(pdata->scripts[i], address);
+	if (pdata) {
+		err = twl4030_power_configure_scripts(pdata);
 		if (err)
 			goto load;
-		address += pdata->scripts[i]->size;
-	}
-
-	resconfig = pdata->resource_config;
-	if (resconfig) {
-		while (resconfig->resource) {
-			err = twl4030_configure_resource(resconfig);
-			if (err)
-				goto resource;
-			resconfig++;
-
-		}
+		err = twl4030_power_configure_resources(pdata);
+		if (err)
+			goto resource;
 	}
 
 	/* Board has to be wired properly to use this feature */
-	if (pdata->use_poweroff && !pm_power_off) {
+	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
 		/* Default for SEQ_OFFSYNC is set, lets ensure this */
 		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
 				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
@@ -590,10 +631,19 @@ static int twl4030_power_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id twl4030_power_of_match[] = {
+	{.compatible = "ti,twl4030-power", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl4030_power_of_match);
+#endif
+
 static struct platform_driver twl4030_power_driver = {
 	.driver = {
 		.name	= "twl4030_power",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(twl4030_power_of_match),
 	},
 	.probe		= twl4030_power_probe,
 	.remove		= twl4030_power_remove,
-- 
1.7.5.4

