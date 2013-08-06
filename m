Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3HFWwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:52:06 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57389 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab3HFWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:52:03 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] thermal: new asus driver
Date: Tue,  6 Aug 2013 17:48:20 -0500
Message-Id: <1375829300-14081-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.267.gbb4989f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple driver to enable control of the fan in ASUS laptops. So far this
has only been tested in ASUS Zenbook Prime UX31A, but according to some
online reference [1], it should work in other models as well.

Another source was a patch acpi4asus-user's mailing list [2].

[1]
http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
[2]
http://www.mail-archive.com/acpi4asus-user@lists.sourceforge.net/msg00065.html

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---

I've never implemented a driver like this, so I've no idea if this is the right way to do it.

 drivers/thermal/Kconfig        |  7 ++++
 drivers/thermal/Makefile       |  1 +
 drivers/thermal/asus_thermal.c | 94 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+)
 create mode 100644 drivers/thermal/asus_thermal.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e988c81..0c5b624 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -184,4 +184,11 @@ menu "Texas Instruments thermal drivers"
 source "drivers/thermal/ti-soc-thermal/Kconfig"
 endmenu
 
+config ASUS_THERMAL
+	tristate "ASUS thermal driver"
+	depends on THERMAL
+	depends on X86
+	help
+	  Enables control of the fan in ASUS laptops.
+
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 67184a2..ab4ea6f 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
 obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
 obj-$(CONFIG_X86_PKG_TEMP_THERMAL)	+= x86_pkg_temp_thermal.o
 obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
+obj-$(CONFIG_ASUS_THERMAL)	+= asus_thermal.o
diff --git a/drivers/thermal/asus_thermal.c b/drivers/thermal/asus_thermal.c
new file mode 100644
index 0000000..eceeee3
--- /dev/null
+++ b/drivers/thermal/asus_thermal.c
@@ -0,0 +1,94 @@
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
+static struct thermal_cooling_device *cdev;
+
+static int fan_get_max_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	*state = 0xff;
+	return 0;
+}
+
+static int fan_get_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long *state)
+{
+	struct acpi_object_list params;
+	union acpi_object in_objs[1];
+	unsigned long long value;
+	acpi_status r;
+
+	params.count = ARRAY_SIZE(in_objs);
+	params.pointer = in_objs;
+	in_objs[0].type = ACPI_TYPE_INTEGER;
+	in_objs[0].integer.value = 0;
+
+	r = acpi_evaluate_integer(NULL, "\\_TZ.RFAN", &params, &value);
+	if (r != AE_OK)
+		return r;
+
+	*state = value;
+
+	return 0;
+}
+
+static int fan_set(struct thermal_cooling_device *cdev, int fan, int speed)
+{
+	struct acpi_object_list params;
+	union acpi_object in_objs[2];
+	unsigned long long value;
+
+	params.count = ARRAY_SIZE(in_objs);
+	params.pointer = in_objs;
+	in_objs[0].type = ACPI_TYPE_INTEGER;
+	in_objs[0].integer.value = fan;
+	in_objs[1].type = ACPI_TYPE_INTEGER;
+	in_objs[1].integer.value = speed;
+
+	return acpi_evaluate_integer(NULL, "\\_SB.PCI0.LPCB.EC0.SFNV", &params, &value);
+}
+
+static int fan_set_cur_state(struct thermal_cooling_device *cdev,
+		unsigned long state)
+{
+	return fan_set(cdev, 1, state);
+}
+
+static int fan_set_auto(struct thermal_cooling_device *cdev)
+{
+	return fan_set(cdev, 0, 0);
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
+	if (strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "ASUSTeK COMPUTER INC."))
+		return -ENODEV;
+	cdev = thermal_cooling_device_register("Fan", NULL, &fan_cooling_ops);
+	if (IS_ERR(cdev))
+		return PTR_ERR(cdev);
+	fan_set_auto(cdev);
+	return 0;
+}
+
+static void __exit fan_exit(void)
+{
+	fan_set_auto(cdev);
+	thermal_cooling_device_unregister(cdev);
+}
+
+module_init(fan_init);
+module_exit(fan_exit);
-- 
1.8.3.267.gbb4989f

