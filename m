Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3JHMyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:54:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42137 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JHMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:54:46 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-pm@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2] platform: x86: asus-wmi: add fan control
Date: Tue,  8 Oct 2013 07:48:44 -0500
Message-Id: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4-fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple driver to enable control of the fan in ASUS laptops. So far this
has only been tested in ASUS Zenbook Prime UX31A, but according to some
online reference [1], it should work in other models as well.

The implementation is very straight-forward, the only caveat is that the
fan speed needs to be saved after it has been manually changed because
it won't be reported properly until it goes back to 'auto' mode.

[1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/platform/x86/asus-wmi.c | 105 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 19c313b..5fdfed6 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -78,6 +78,7 @@ MODULE_LICENSE("GPL");
 #define ASUS_WMI_METHODID_GPID		0x44495047 /* Get Panel ID?? (Resol) */
 #define ASUS_WMI_METHODID_QMOD		0x444F4D51 /* Quiet MODe */
 #define ASUS_WMI_METHODID_SPLV		0x4C425053 /* Set Panel Light Value */
+#define ASUS_WMI_METHODID_AGFN		0x4E464741
 #define ASUS_WMI_METHODID_SFUN		0x4E554653 /* FUNCtionalities */
 #define ASUS_WMI_METHODID_SDSP		0x50534453 /* Set DiSPlay output */
 #define ASUS_WMI_METHODID_GDSP		0x50534447 /* Get DiSPlay output */
@@ -155,6 +156,16 @@ struct bios_args {
 	u32 arg1;
 } __packed;
 
+struct fan_args {
+	u16 mfun;
+	u16 sfun;
+	u16 len;
+	u8 stas;
+	u8 err;
+	u8 fan;
+	u32 speed;
+} __packed;
+
 /*
  * <platform>/    - debugfs root directory
  *   dev_id      - current dev_id
@@ -205,6 +216,9 @@ struct asus_wmi {
 	struct asus_rfkill gps;
 	struct asus_rfkill uwb;
 
+	struct thermal_cooling_device *fan;
+	int fan_speed;
+
 	struct hotplug_slot *hotplug_slot;
 	struct mutex hotplug_lock;
 	struct mutex wmi_lock;
@@ -1022,6 +1036,90 @@ exit:
 }
 
 /*
+ * Fan
+ */
+
+static int fan_speed(struct asus_wmi *asus, int write, int fan, unsigned long *speed)
+{
+	struct fan_args args = {
+		.len = sizeof(args),
+		.mfun = 0x13,
+		.sfun = write ? 0x07 : 0x06,
+		.fan = fan,
+		.speed = write ? *speed : 0,
+	};
+	int r;
+	u32 value;
+
+	if (!write && asus->fan_speed >= 0) {
+		*speed = asus->fan_speed;
+		return 0;
+	}
+
+	r = asus_wmi_evaluate_method(ASUS_WMI_METHODID_AGFN, virt_to_phys(&args), 0, &value);
+	if (r || value || args.err)
+		return -1;
+
+	if (write)
+		asus->fan_speed = fan > 0 ? *speed : -1;
+	else
+		*speed = args.speed;
+
+	return 0;
+}
+
+static int fan_set_auto(struct asus_wmi *asus)
+{
+	unsigned long speed = 0;
+	return fan_speed(asus, 1, 0, &speed);
+}
+
+static int fan_get_max_state(struct thermal_cooling_device *cdev, unsigned long *state)
+{
+	*state = 0xff;
+	return 0;
+}
+
+static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long *state)
+{
+	return fan_speed(cdev->devdata, 0, 1, state);
+}
+
+static int fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
+{
+	return fan_speed(cdev->devdata, 1, 1, &state);
+}
+
+static const struct thermal_cooling_device_ops fan_cooling_ops = {
+	.get_max_state = fan_get_max_state,
+	.get_cur_state = fan_get_cur_state,
+	.set_cur_state = fan_set_cur_state,
+};
+
+static int asus_wmi_fan_init(struct asus_wmi *asus)
+{
+	struct thermal_cooling_device *cdev;
+
+	if (fan_set_auto(asus))
+		return 0;
+
+	cdev = thermal_cooling_device_register("Fan", asus, &fan_cooling_ops);
+	if (IS_ERR(cdev))
+		return PTR_ERR(cdev);
+	asus->fan = cdev;
+	return 0;
+}
+
+static void asus_wmi_fan_exit(struct asus_wmi *asus)
+{
+	if (!asus->fan)
+		return;
+	fan_set_auto(asus);
+	thermal_cooling_device_unregister(asus->fan);
+	asus->fan = NULL;
+}
+
+/*
  * Hwmon device
  */
 static ssize_t asus_hwmon_pwm1(struct device *dev,
@@ -1796,6 +1894,10 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (err)
 		goto fail_rfkill;
 
+	err = asus_wmi_fan_init(asus);
+	if (err)
+		goto fail_fan;
+
 	if (asus->driver->quirks->wmi_backlight_power)
 		acpi_video_dmi_promote_vendor();
 	if (!acpi_video_backlight_support()) {
@@ -1830,6 +1932,8 @@ fail_debugfs:
 fail_wmi_handler:
 	asus_wmi_backlight_exit(asus);
 fail_backlight:
+	asus_wmi_fan_exit(asus);
+fail_fan:
 	asus_wmi_rfkill_exit(asus);
 fail_rfkill:
 	asus_wmi_led_exit(asus);
@@ -1855,6 +1959,7 @@ static int asus_wmi_remove(struct platform_device *device)
 	asus_wmi_hwmon_exit(asus);
 	asus_wmi_led_exit(asus);
 	asus_wmi_rfkill_exit(asus);
+	asus_wmi_fan_exit(asus);
 	asus_wmi_debugfs_exit(asus);
 	asus_wmi_platform_exit(asus);
 
-- 
1.8.4-fc

