Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCGSWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:22:43 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:51982 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaCGSWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:22:41 -0500
Message-ID: <531A0E6C.2070203@gmail.com>
Date: Fri, 07 Mar 2014 10:22:36 -0800
From: "Peter F. Patel-Schneider" <pfpschneider@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: ike.pan@canonical.com, matthew.garrett@nebula.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: proposed patch to ideapad-laptop module for Yoga 2 Pro
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lenovo Ideapad Yoga laptops have a VPC2004 ACPI device, so the
ideapad-laptop module loads for them.  The module enables the Airplane Mode
and Novo keys of the laptop.  Most of the other features of this module
are harmless for these laptops.  However, the laptops do not have hardware
RF kill switches and when the module loads it turns off the WiFi.

This patch adds a flag (rfkill_present) to the ideapad_private data
indicating whether the laptop has an RF kill switch.   On initialization,
there is a check whether the laptop is a Yoga 2 Pro by matching against the
DMI product version of the system information.  If there is a match the flag
is set to false, otherwise it is set to true.  All manipulations of the
rfkill structures are conditioned on this flag being true.

This is a minimal change to make the ideapad-laptop module work correctly
for Yoga 2 Pro Ideapads.  The initialization check should be generalized for
other Ideapads that do not have RF kill switches, particularly other Yogas,
but I do not have precise information on their DMI version information.

What should be done to get this patchapplied?

Peter F. Patel-Schneider

---

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -27,6 +27,7 @@
  #include <linux/init.h>
  #include <linux/types.h>
  #include <linux/acpi.h>
+#include <linux/dmi.h>
  #include <linux/rfkill.h>
  #include <linux/platform_device.h>
  #include <linux/input.h>
@@ -84,6 +85,7 @@ struct ideapad_private {
      struct input_dev *inputdev;
      struct backlight_device *blightdev;
      struct dentry *debug;
+        bool rfkill_present;
      unsigned long cfg;
  };

@@ -474,13 +476,15 @@ static void ideapad_sync_rfk_state(struct 
ideapad_private *priv)
      unsigned long hw_blocked;
      int i;

-    if (read_ec_data(priv->adev->handle, VPCCMD_R_RF, &hw_blocked))
-        return;
-    hw_blocked = !hw_blocked;
+    if (priv->rfkill_present) {
+        if (read_ec_data(priv->adev->handle, VPCCMD_R_RF, &hw_blocked))
+            return;
+        hw_blocked = !hw_blocked;

-    for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
-        if (priv->rfk[i])
-            rfkill_set_hw_state(priv->rfk[i], hw_blocked);
+        for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
+            if (priv->rfk[i])
+                rfkill_set_hw_state(priv->rfk[i], hw_blocked);
+    }
  }

  static int ideapad_register_rfkill(struct ideapad_private *priv, int dev)
@@ -825,6 +829,7 @@ static int ideapad_acpi_add(struct platform_device *pdev)
      int cfg;
      struct ideapad_private *priv;
      struct acpi_device *adev;
+    char const *s;

      ret = acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev);
      if (ret)
@@ -842,6 +847,15 @@ static int ideapad_acpi_add(struct platform_device *pdev)
      priv->adev = adev;
      priv->platform_device = pdev;

+    /*  check for Yoga 2 Pro, which has no rfkill switches */
+    s = dmi_get_system_info(DMI_PRODUCT_VERSION);
+    if (s && !(strncmp(s, "Lenovo Yoga 2 Pro", 17)) ) {
+        priv->rfkill_present = false;
+    } else {
+        priv->rfkill_present = true;
+    }
+
+
      ret = ideapad_sysfs_init(priv);
      if (ret)
          goto sysfs_failed;
@@ -854,11 +868,13 @@ static int ideapad_acpi_add(struct platform_device *pdev)
      if (ret)
          goto input_failed;

-    for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
-        if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
-            ideapad_register_rfkill(priv, i);
-        else
-            priv->rfk[i] = NULL;
+    if (priv->rfkill_present) {
+        for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
+            if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
+                ideapad_register_rfkill(priv, i);
+            else
+                priv->rfk[i] = NULL;
+        }
      }
      ideapad_sync_rfk_state(priv);
      ideapad_sync_touchpad_state(priv);
@@ -877,8 +893,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
  notification_failed:
      ideapad_backlight_exit(priv);
  backlight_failed:
-    for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
-        ideapad_unregister_rfkill(priv, i);
+    if (priv->rfkill_present) {
+        for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
+            ideapad_unregister_rfkill(priv, i);
+    }
      ideapad_input_exit(priv);
  input_failed:
      ideapad_debugfs_exit(priv);
@@ -897,8 +915,10 @@ static int ideapad_acpi_remove(struct platform_device *pdev)
      acpi_remove_notify_handler(priv->adev->handle,
          ACPI_DEVICE_NOTIFY, ideapad_acpi_notify);
      ideapad_backlight_exit(priv);
-    for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
-        ideapad_unregister_rfkill(priv, i);
+    if (priv->rfkill_present) {
+        for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
+            ideapad_unregister_rfkill(priv, i);
+    }
      ideapad_input_exit(priv);
      ideapad_debugfs_exit(priv);
      ideapad_sysfs_exit(priv);

