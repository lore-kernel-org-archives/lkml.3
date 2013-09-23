Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3IWKKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:10:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:3238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab3IWKKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="405750956"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jenny TC <jenny.tc@intel.com>,
        adavidra <ajay.thomas.david.rajamanickam@intel.com>
Subject: [PATCH 5/7] power_supply : Introduce battery identification framework
Date: Mon, 23 Sep 2013 23:34:03 +0530
Message-Id: <1379959445-28207-6-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces generic battid framework. Different battid
drivers sitting on different linux kernel subsystem (1wire,
I2C, SFI etc) can interface with the power supply susbsytem using
the APIs exposed in the power supply usbsystem. The consumers (charger
driver/battery driver/power management drivers) can register
for notification from the battery id drivers using the APIs from this
framework

Change-Id: I3f77f5fd63e050eba13d7e98fcb6bfbbe817621f
Signed-off-by: Jenny TC <jenny.tc@intel.com>
Signed-off-by: adavidra <ajay.thomas.david.rajamanickam@intel.com>
---
 Documentation/power/power_supply_class.txt |   12 ++++
 drivers/power/Kconfig                      |    8 +++
 drivers/power/Makefile                     |    1 +
 drivers/power/battery_id.c                 |   87 ++++++++++++++++++++++++++++
 include/linux/power/battery_id.h           |   55 ++++++++++++++++++
 5 files changed, 163 insertions(+)
 create mode 100644 drivers/power/battery_id.c
 create mode 100644 include/linux/power/battery_id.h

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 5a5e7fa..fc2ff29d 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -177,6 +177,18 @@ External power supply (AC) lists supplicants (batteries) names in
 issued by external power supply will notify supplicants via
 external_power_changed callback.
 
+Reading Battery charging profile
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Power Supply class battery identification framework (battery_id.c)
+exposes APIs to retrieve battery profile of a battery. The battery
+profile can be read by battery identification driver which may be
+1wire/I2C/SFI driver. Battery identification driver can register
+the battery profile with the power supply class using the API
+psy_battery_prop_changed(). The framework also exposes API
+psy_get_batt_prop() to retrieve the battery profile which can be
+used by power supply drivers to setup the charging. Also drivers
+can register for battery removal/insertion notifications using
+power_supply_reg_notifier()
 
 QA
 ~~
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e6f92b4..c95bc55 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -8,6 +8,14 @@ menuconfig POWER_SUPPLY
 
 if POWER_SUPPLY
 
+config POWER_SUPPLY_BATTID
+	bool "Power Supply Battery Identification Framework"
+	help
+	 Say Y here to enable the power supply battery idnetification
+	 framework. The framework would allow different battery identification
+	 drivers to interface with power supply subsystem. Also it allows consumer
+	 drivers to register for notification from the power_supply subsystem.
+
 config POWER_SUPPLY_DEBUG
 	bool "Power supply debug"
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index a4b7417..a8d71db 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -3,6 +3,7 @@ ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
 power_supply-y				:= power_supply_core.o
 power_supply-$(CONFIG_SYSFS)		+= power_supply_sysfs.o
 power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
+power_supply-$(CONFIG_POWER_SUPPLY_BATTID) += battery_id.o
 
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
diff --git a/drivers/power/battery_id.c b/drivers/power/battery_id.c
new file mode 100644
index 0000000..c5a5d02
--- /dev/null
+++ b/drivers/power/battery_id.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ * Author: Ajay Thomas David Rajamanickam <ajay.thomas.david.rajamanickam@intel.com>
+ */
+
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/notifier.h>
+#include <linux/power_supply.h>
+#include <linux/power/battery_id.h>
+
+static struct psy_ps_batt_chg_prof batt_property;
+static int batt_status;
+
+DEFINE_SPINLOCK(battid_spinlock);
+
+/**
+ * psy_battery_prop_changed - Update properties when  battery connection status
+ *                        changes
+ * @battery_conn_stat : The current connection status of battery
+ * @batt_prop : Address of the psy_ps_batt_chg_prof structure with the updated
+ *              values passed from the calling function
+ *
+ * Whenever the battery connection status changes this function will be called
+ * to indicate a change in the status and to update the status and value of
+ * properties
+ */
+void psy_battery_prop_changed(int battery_conn_stat,
+			struct psy_ps_batt_chg_prof *batt_prop)
+{
+
+	spin_lock(&battid_spinlock);
+	if (batt_status != battery_conn_stat) {
+		if (battery_conn_stat == POWER_SUPPLY_BATTERY_INSERTED)
+			memcpy(&batt_property, batt_prop,
+				sizeof(batt_property));
+		batt_status = battery_conn_stat;
+	}
+	spin_unlock(&battid_spinlock);
+
+	atomic_notifier_call_chain(&power_supply_notifier,
+			PSY_EVENT_BATTERY, &(batt_property));
+}
+EXPORT_SYMBOL_GPL(psy_battery_prop_changed);
+
+/**
+ * psy_get_batt_prop - Get the battery connection status and updated properties
+ * @batt_prop : battery properties structure copied to this address
+ */
+int psy_get_batt_prop(struct psy_ps_batt_chg_prof *batt_prop)
+{
+	int ret = 0;
+
+	spin_lock(&battid_spinlock);
+
+	if (batt_status != POWER_SUPPLY_BATTERY_INSERTED)
+		ret = -ENODATA;
+	else
+		memcpy(batt_prop, &batt_property,
+			sizeof(batt_property));
+
+	spin_unlock(&battid_spinlock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psy_get_batt_prop);
diff --git a/include/linux/power/battery_id.h b/include/linux/power/battery_id.h
new file mode 100644
index 0000000..ef4d0f9
--- /dev/null
+++ b/include/linux/power/battery_id.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ * Author: Ajay Thomas David Rajamanickam <ajay.thomas.david.rajamanickam@intel.com>
+ */
+#ifndef __BATTERY_ID_H__
+
+#define __BATTERY_ID_H__
+
+enum {
+	POWER_SUPPLY_BATTERY_REMOVED = 0,
+	POWER_SUPPLY_BATTERY_INSERTED,
+};
+
+enum psy_batt_chrg_prof_type {
+	PSY_CHRG_PROF_NONE = 0,
+};
+
+/* charging profile structure definition */
+struct psy_ps_batt_chg_prof {
+	enum psy_batt_chrg_prof_type chrg_prof_type;
+	void *batt_prof;
+};
+
+#ifdef CONFIG_POWER_SUPPLY_BATTID
+extern int psy_get_batt_prop(struct psy_ps_batt_chg_prof *batt_prop);
+extern void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_ps_batt_chg_prof *batt_prop);
+#else
+static inline int psy_get_batt_prop(struct psy_ps_batt_chg_prof *batt_prop)
+{
+	return -ENOMEM;
+}
+static void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_ps_batt_chg_prof *batt_prop) { }
+#endif
+
+#endif
-- 
1.7.9.5

