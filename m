Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166AbaFQVs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966144AbaFQVsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Rui <rui.zhang@intel.com>, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 098/212] ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
Date: Tue, 17 Jun 2014 14:43:12 -0700
Message-Id: <1403041506-13646-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 98012849e0cbf980326f8e34d571f4474866a88e upstream.

Revert commit cc8ef5270734 (ACPI / AC: convert ACPI ac driver to
platform bus) that is reported to break thermal management on
MacBook Air 2013 with ArchLinux.

Fixes: cc8ef5270734 (ACPI / AC: convert ACPI ac driver to platform bus)
References: https://bugzilla.kernel.org/show_bug.cgi?id=71711
Cc: Zhang Rui <rui.zhang@intel.com>
Reported-and-tested-by: Manuel Krause <manuelkrause@netscape.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ac.c            | 117 +++++++++++++++++++++----------------------
 drivers/acpi/acpi_platform.c |   1 -
 2 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 3c2e4aa..cfcfd89 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -52,11 +52,39 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
+static int acpi_ac_add(struct acpi_device *device);
+static int acpi_ac_remove(struct acpi_device *device);
+static void acpi_ac_notify(struct acpi_device *device, u32 event);
+
+static const struct acpi_device_id ac_device_ids[] = {
+	{"ACPI0003", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, ac_device_ids);
+
+#ifdef CONFIG_PM_SLEEP
+static int acpi_ac_resume(struct device *dev);
+#endif
+static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
+
 static int ac_sleep_before_get_state_ms;
 
+static struct acpi_driver acpi_ac_driver = {
+	.name = "ac",
+	.class = ACPI_AC_CLASS,
+	.ids = ac_device_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = acpi_ac_add,
+		.remove = acpi_ac_remove,
+		.notify = acpi_ac_notify,
+		},
+	.drv.pm = &acpi_ac_pm,
+};
+
 struct acpi_ac {
 	struct power_supply charger;
-	struct platform_device *pdev;
+	struct acpi_device * device;
 	unsigned long long state;
 };
 
@@ -68,10 +96,12 @@ struct acpi_ac {
 
 static int acpi_ac_get_state(struct acpi_ac *ac)
 {
-	acpi_status status;
-	acpi_handle handle = ACPI_HANDLE(&ac->pdev->dev);
+	acpi_status status = AE_OK;
+
+	if (!ac)
+		return -EINVAL;
 
-	status = acpi_evaluate_integer(handle, "_PSR", NULL,
+	status = acpi_evaluate_integer(ac->device->handle, "_PSR", NULL,
 				       &ac->state);
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status,
@@ -116,10 +146,9 @@ static enum power_supply_property ac_props[] = {
                                    Driver Model
    -------------------------------------------------------------------------- */
 
-static void acpi_ac_notify_handler(acpi_handle handle, u32 event, void *data)
+static void acpi_ac_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_ac *ac = data;
-	struct acpi_device *adev;
+	struct acpi_ac *ac = acpi_driver_data(device);
 
 	if (!ac)
 		return;
@@ -142,11 +171,10 @@ static void acpi_ac_notify_handler(acpi_handle handle, u32 event, void *data)
 			msleep(ac_sleep_before_get_state_ms);
 
 		acpi_ac_get_state(ac);
-		adev = ACPI_COMPANION(&ac->pdev->dev);
-		acpi_bus_generate_netlink_event(adev->pnp.device_class,
-						dev_name(&ac->pdev->dev),
-						event, (u32) ac->state);
-		acpi_notifier_call_chain(adev, event, (u32) ac->state);
+		acpi_bus_generate_netlink_event(device->pnp.device_class,
+						  dev_name(&device->dev), event,
+						  (u32) ac->state);
+		acpi_notifier_call_chain(device, event, (u32) ac->state);
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
 	}
 
@@ -171,49 +199,39 @@ static struct dmi_system_id ac_dmi_table[] = {
 	{},
 };
 
-static int acpi_ac_probe(struct platform_device *pdev)
+static int acpi_ac_add(struct acpi_device *device)
 {
 	int result = 0;
 	struct acpi_ac *ac = NULL;
-	struct acpi_device *adev;
 
-	if (!pdev)
-		return -EINVAL;
 
-	adev = ACPI_COMPANION(&pdev->dev);
-	if (!adev)
-		return -ENODEV;
+	if (!device)
+		return -EINVAL;
 
 	ac = kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
 	if (!ac)
 		return -ENOMEM;
 
-	strcpy(acpi_device_name(adev), ACPI_AC_DEVICE_NAME);
-	strcpy(acpi_device_class(adev), ACPI_AC_CLASS);
-	ac->pdev = pdev;
-	platform_set_drvdata(pdev, ac);
+	ac->device = device;
+	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
+	device->driver_data = ac;
 
 	result = acpi_ac_get_state(ac);
 	if (result)
 		goto end;
 
-	ac->charger.name = acpi_device_bid(adev);
+	ac->charger.name = acpi_device_bid(device);
 	ac->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
 	ac->charger.get_property = get_ac_property;
-	result = power_supply_register(&pdev->dev, &ac->charger);
+	result = power_supply_register(&ac->device->dev, &ac->charger);
 	if (result)
 		goto end;
 
-	result = acpi_install_notify_handler(ACPI_HANDLE(&pdev->dev),
-			ACPI_ALL_NOTIFY, acpi_ac_notify_handler, ac);
-	if (result) {
-		power_supply_unregister(&ac->charger);
-		goto end;
-	}
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
-	       acpi_device_name(adev), acpi_device_bid(adev),
+	       acpi_device_name(device), acpi_device_bid(device),
 	       ac->state ? "on-line" : "off-line");
 
 end:
@@ -233,7 +251,7 @@ static int acpi_ac_resume(struct device *dev)
 	if (!dev)
 		return -EINVAL;
 
-	ac = platform_get_drvdata(to_platform_device(dev));
+	ac = acpi_driver_data(to_acpi_device(dev));
 	if (!ac)
 		return -EINVAL;
 
@@ -245,19 +263,17 @@ static int acpi_ac_resume(struct device *dev)
 	return 0;
 }
 #endif
-static SIMPLE_DEV_PM_OPS(acpi_ac_pm_ops, NULL, acpi_ac_resume);
 
-static int acpi_ac_remove(struct platform_device *pdev)
+static int acpi_ac_remove(struct acpi_device *device)
 {
-	struct acpi_ac *ac;
+	struct acpi_ac *ac = NULL;
+
 
-	if (!pdev)
+	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
-	acpi_remove_notify_handler(ACPI_HANDLE(&pdev->dev),
-			ACPI_ALL_NOTIFY, acpi_ac_notify_handler);
+	ac = acpi_driver_data(device);
 
-	ac = platform_get_drvdata(pdev);
 	if (ac->charger.dev)
 		power_supply_unregister(&ac->charger);
 
@@ -266,23 +282,6 @@ static int acpi_ac_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct acpi_device_id acpi_ac_match[] = {
-	{ "ACPI0003", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, acpi_ac_match);
-
-static struct platform_driver acpi_ac_driver = {
-	.probe          = acpi_ac_probe,
-	.remove         = acpi_ac_remove,
-	.driver         = {
-		.name   = "acpi-ac",
-		.owner  = THIS_MODULE,
-		.pm     = &acpi_ac_pm_ops,
-		.acpi_match_table = ACPI_PTR(acpi_ac_match),
-	},
-};
-
 static int __init acpi_ac_init(void)
 {
 	int result;
@@ -290,7 +289,7 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	result = platform_driver_register(&acpi_ac_driver);
+	result = acpi_bus_register_driver(&acpi_ac_driver);
 	if (result < 0)
 		return -ENODEV;
 
@@ -299,7 +298,7 @@ static int __init acpi_ac_init(void)
 
 static void __exit acpi_ac_exit(void)
 {
-	platform_driver_unregister(&acpi_ac_driver);
+	acpi_bus_unregister_driver(&acpi_ac_driver);
 }
 module_init(acpi_ac_init);
 module_exit(acpi_ac_exit);
diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index dbfe49e..1d49503 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -29,7 +29,6 @@ ACPI_MODULE_NAME("platform");
 static const struct acpi_device_id acpi_platform_device_ids[] = {
 
 	{ "PNP0D40" },
-	{ "ACPI0003" },
 	{ "VPC2004" },
 	{ "BCM4752" },
 
-- 
1.9.1

