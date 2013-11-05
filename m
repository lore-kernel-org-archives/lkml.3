Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3KEJGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:06:50 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63245 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3KEJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:06:46 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] staging: new asus fan driver
Date: Tue,  5 Nov 2013 02:59:47 -0600
Message-Id: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
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

Two incarnations of this code exists [1][2], one that used ACPI methods
directly, and one through WMI. Unfortunately the WMI version needs us to pass
physicall addresses which is not exactly clean, and that's the only reason the
code is proposed for staging.

Most likely this cannot graduate until acpica gets support to receive virtual
addresses.

 [1] http://article.gmane.org/gmane.linux.power-management.general/36774
 [2] http://article.gmane.org/gmane.linux.kernel/1576463

 drivers/staging/Kconfig                     |   2 +
 drivers/staging/Makefile                    |   1 +
 drivers/staging/asus-thermal/Kconfig        |   7 ++
 drivers/staging/asus-thermal/asus_thermal.c | 166 ++++++++++++++++++++++++++++
 4 files changed, 176 insertions(+)
 create mode 100644 drivers/staging/asus-thermal/Kconfig
 create mode 100644 drivers/staging/asus-thermal/asus_thermal.c

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 3626dbc8..b245af5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -148,4 +148,6 @@ source "drivers/staging/dgnc/Kconfig"
 
 source "drivers/staging/dgap/Kconfig"
 
+source "drivers/staging/asus-thermal/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d1b4b80..70e4456 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -66,3 +66,4 @@ obj-$(CONFIG_USB_BTMTK)		+= btmtk_usb/
 obj-$(CONFIG_XILLYBUS)		+= xillybus/
 obj-$(CONFIG_DGNC)			+= dgnc/
 obj-$(CONFIG_DGAP)			+= dgap/
+obj-$(CONFIG_ASUS_THERMAL)	+= asus-thermal/
diff --git a/drivers/staging/asus-thermal/Kconfig b/drivers/staging/asus-thermal/Kconfig
new file mode 100644
index 0000000..8bf7db4
--- /dev/null
+++ b/drivers/staging/asus-thermal/Kconfig
@@ -0,0 +1,7 @@
+config ASUS_THERMAL
+	tristate "ASUS thermal driver"
+	depends on THERMAL
+	depends on X86
+	help
+	  Enables control of the fan in ASUS laptops.
+
diff --git a/drivers/staging/asus-thermal/asus_thermal.c b/drivers/staging/asus-thermal/asus_thermal.c
new file mode 100644
index 0000000..a84856e
--- /dev/null
+++ b/drivers/staging/asus-thermal/asus_thermal.c
@@ -0,0 +1,166 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/thermal.h>
+#include <linux/dmi.h>
+
+MODULE_AUTHOR("Felipe Contreras <felipe.contreras@gmail.com>");
+MODULE_DESCRIPTION("ASUS fan driver");
+MODULE_LICENSE("GPL");
+
+#define ASUS_WMI_MGMT_GUID "97845ED0-4E6D-11DE-8A39-0800200C9A66"
+#define ASUS_WMI_METHODID_AGFN 0x4E464741
+#define ASUS_WMI_UNSUPPORTED_METHOD 0xFFFFFFFE
+
+static struct thermal_cooling_device *fan;
+static int fan_speed;
+
+struct bios_args {
+	u32 arg0;
+	u32 arg1;
+} __packed;
+
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
+/*
+ * Copied from [1], where this code belongs.
+ * [1] drivers/platform/x86/asus-wmi.c
+ */
+static int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1,
+				    u32 *retval)
+{
+	struct bios_args args = {
+		.arg0 = arg0,
+		.arg1 = arg1,
+	};
+	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status status;
+	union acpi_object *obj;
+	u32 tmp;
+
+	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1, method_id,
+				     &input, &output);
+
+	if (ACPI_FAILURE(status))
+		goto exit;
+
+	obj = (union acpi_object *)output.pointer;
+	if (obj && obj->type == ACPI_TYPE_INTEGER)
+		tmp = (u32) obj->integer.value;
+	else
+		tmp = 0;
+
+	if (retval)
+		*retval = tmp;
+
+	kfree(obj);
+
+exit:
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	if (tmp == ASUS_WMI_UNSUPPORTED_METHOD)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int fan_speed_helper(int write, int fan, unsigned long *speed)
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
+	if (!write && fan_speed >= 0) {
+		*speed = fan_speed;
+		return 0;
+	}
+
+	r = asus_wmi_evaluate_method(ASUS_WMI_METHODID_AGFN, virt_to_phys(&args), 0, &value);
+	if (r)
+		return r;
+	if (value || args.err)
+		return -EINVAL;
+
+	if (write)
+		fan_speed = fan > 0 ? *speed : -1;
+	else
+		*speed = args.speed;
+
+	return 0;
+}
+
+static int fan_set_auto(void)
+{
+	unsigned long speed = 0;
+	return fan_speed_helper(1, 0, &speed);
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
+	return fan_speed_helper(0, 1, state);
+}
+
+static int fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
+{
+	return fan_speed_helper(1, 1, &state);
+}
+
+static const struct thermal_cooling_device_ops fan_cooling_ops = {
+	.get_max_state = fan_get_max_state,
+	.get_cur_state = fan_get_cur_state,
+	.set_cur_state = fan_set_cur_state,
+};
+
+static int __init fan_init(void)
+{
+	struct thermal_cooling_device *cdev;
+	int r;
+
+	if (!wmi_has_guid(ASUS_WMI_MGMT_GUID))
+		return -ENODEV;
+
+	r = fan_set_auto();
+	if (r)
+		return r;
+
+	cdev = thermal_cooling_device_register("Fan", NULL, &fan_cooling_ops);
+	if (IS_ERR(cdev))
+		return PTR_ERR(cdev);
+	fan = cdev;
+	return 0;
+}
+
+static void __exit fan_exit(void)
+{
+	if (!fan)
+		return;
+	fan_set_auto();
+	thermal_cooling_device_unregister(fan);
+	fan = NULL;
+}
+
+module_init(fan_init);
+module_exit(fan_exit);
-- 
1.8.4.2+fc1

