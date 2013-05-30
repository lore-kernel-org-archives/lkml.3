Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3E3Nwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:52:42 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:37884 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756470Ab3E3NwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:52:25 -0400
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
Subject: [PATCH 1/3] mfd: twl4030-power: Split from twl-core into a dedicated module
Date: Thu, 30 May 2013 15:51:54 +0200
Message-Id: <1369921916-7435-2-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
References: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, the call to twl4030-power is hard-wired inside twl-core.
To ease the future transition to DT, make twl4030-power as a
separate module, like what is already done for twl4030-audio
and others.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/mfd/twl-core.c      |   12 ++++++---
 drivers/mfd/twl4030-power.c |   54 +++++++++++++++++++++++++++++++++++--------
 include/linux/i2c/twl.h     |    1 -
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 89ab4d9..d1b9d14 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1023,6 +1023,14 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
+	if (IS_ENABLED(CONFIG_TWL4030_POWER) && pdata->power) {
+		child = add_child(TWL_MODULE_PM_MASTER, "twl4030_power",
+				  pdata->power, sizeof(*pdata->power), false,
+				  0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	return 0;
 }
 
@@ -1234,10 +1242,6 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		WARN(status < 0, "Error: reading twl_idcode register value\n");
 	}
 
-	/* load power event scripts */
-	if (IS_ENABLED(CONFIG_TWL4030_POWER) && pdata && pdata->power)
-		twl4030_power_init(pdata->power);
-
 	/* Maybe init the T2 Interrupt subsystem */
 	if (client->irq) {
 		if (twl_class_is_4030()) {
diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index dd362c1..c9a2a5c 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -507,8 +507,9 @@ void twl4030_power_off(void)
 		pr_err("TWL4030 Unable to power off\n");
 }
 
-void twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
+int twl4030_power_probe(struct platform_device *pdev)
 {
+	struct twl4030_power_data *pdata = pdev->dev.platform_data;
 	int err = 0;
 	int i;
 	struct twl4030_resconfig *resconfig;
@@ -524,14 +525,14 @@ void twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	if (err)
 		goto unlock;
 
-	for (i = 0; i < twl4030_scripts->num; i++) {
-		err = load_twl4030_script(twl4030_scripts->scripts[i], address);
+	for (i = 0; i < pdata->num; i++) {
+		err = load_twl4030_script(pdata->scripts[i], address);
 		if (err)
 			goto load;
-		address += twl4030_scripts->scripts[i]->size;
+		address += pdata->scripts[i]->size;
 	}
 
-	resconfig = twl4030_scripts->resource_config;
+	resconfig = pdata->resource_config;
 	if (resconfig) {
 		while (resconfig->resource) {
 			err = twl4030_configure_resource(resconfig);
@@ -543,7 +544,7 @@ void twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	}
 
 	/* Board has to be wired properly to use this feature */
-	if (twl4030_scripts->use_poweroff && !pm_power_off) {
+	if (pdata->use_poweroff && !pm_power_off) {
 		/* Default for SEQ_OFFSYNC is set, lets ensure this */
 		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
 				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
@@ -568,18 +569,51 @@ relock:
 			       TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		pr_err("TWL4030 Unable to relock registers\n");
-	return;
+	return err;
 
 unlock:
 	if (err)
 		pr_err("TWL4030 Unable to unlock registers\n");
-	return;
+	return err;
 load:
 	if (err)
 		pr_err("TWL4030 failed to load scripts\n");
-	return;
+	return err;
 resource:
 	if (err)
 		pr_err("TWL4030 failed to configure resource\n");
-	return;
+	return err;
+}
+
+static int twl4030_power_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver twl4030_power_driver = {
+	.driver = {
+		.name	= "twl4030_power",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= twl4030_power_probe,
+	.remove		= twl4030_power_remove,
+};
+
+static int __init twl4030_power_init(void)
+{
+	return platform_driver_register(&twl4030_power_driver);
 }
+subsys_initcall(twl4030_power_init);
+
+static void __exit twl4030_power_exit(void)
+{
+	platform_driver_unregister(&twl4030_power_driver);
+}
+module_exit(twl4030_power_exit);
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_AUTHOR("Texas Instruments, Inc.");
+MODULE_DESCRIPTION("Power management for TWL4030");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:twl4030_power");
+
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 488debb..2167c0d0 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -658,7 +658,6 @@ struct twl4030_power_data {
 	bool use_poweroff;	/* Board is wired for TWL poweroff */
 };
 
-extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 extern int twl4030_remove_script(u8 flags);
 extern void twl4030_power_off(void);
 
-- 
1.7.5.4

