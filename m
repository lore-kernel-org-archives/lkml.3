Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaAVJ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:28:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:13947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaAVJ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:27:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="468912071"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: [PATCH 2/4] power_supply: Introduce Generic Power Supply charging driver
Date: Wed, 22 Jan 2014 22:49:52 +0530
Message-Id: <1390411194-21410-3-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Supply charging driver connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
thermal and battery communication subsystems (1wire).
With this the charging is handled in a generic way.

The driver makes use of different new features - Battery Identification
interfaces, pluggable charging algorithms, charger cable arbitrations etc.

At present the charging is done based on the static battery characteristics.
This is done at the boot time by passing the battery properties (max_voltage,
capacity) etc. as a platform data to the charger/battery driver.
But new generation high volt batteries needs to be identified dynamically
to do charging in a safe manner. The batteries are coming with different
communication protocols (BSI/SDQ/MIPI BIF). It become necessary to communicate
with battery and identify it's charging profiles before setup charging.

Also the charging algorithms can vary based on the battery characteristics
and the platform characteristics. To handle charging in a generic way it's
necessary to support pluggable charging algorithms. Power Supply Charging
driver selects algorithms based on the type of battery charging profile.
This is a simple binding and can be improved later. This may be improved to
select the algorithms based on the platform requirements. Also we can extend
this driver to plug algorithms from the user space.

The driver also introduces the charger cable arbitration. A charger may
supports multiple cables, but it may not be able to charge with multiple
cables at a time (USB/AC/Wireless etc). The arbitration logic inside the
driver selects the cable based on it's capabilities and the maximum
charge current the platform can support. Also the driver arbitrates between
different charger chip drivers based on their priority.

Also the driver exposes features to control charging on different platform
states. One such feature is thermal. The driver handles the thermal
throttling requests for charging and control charging based on the thermal
subsystem requirements.

The patch also introduces generic interface for charger cable notifications.
Charger cable events and capabilities can be notified using the generic
power_supply_notifier chain.

Overall this driver removes the charging logic out of the charger chip driver
and the charger chip driver can just listen to the request from the power
supply charging driver to set the charger properties. This can be implemented
by exposing get_property and set property callbacks.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 Documentation/power/power_supply_charger.txt |  332 +++++++
 drivers/power/Kconfig                        |    8 +
 drivers/power/Makefile                       |    1 +
 drivers/power/power_supply_charger.c         | 1191 ++++++++++++++++++++++++++
 drivers/power/power_supply_charger.h         |  218 +++++
 drivers/power/power_supply_core.c            |    3 +
 include/linux/power/power_supply_charger.h   |  190 ++++
 include/linux/power_supply.h                 |  158 ++++
 8 files changed, 2101 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

diff --git a/Documentation/power/power_supply_charger.txt b/Documentation/power/power_supply_charger.txt
new file mode 100644
index 0000000..d593dc5
--- /dev/null
+++ b/Documentation/power/power_supply_charger.txt
@@ -0,0 +1,332 @@
+1. Introduction
+===============
+
+The Power Supply charging driver connects multiple subsystems
+to do charging in a generic way. The subsystems involves power_supply,
+thermal and battery communication subsystems (1wire).With this the charging is
+handled in a generic way by plugging the driver to power supply subsystem.
+
+The driver introduces different new features - Battery Identification
+interfaces, pluggable charging algorithms, charger cable arbitrations etc.
+
+In existing driver implementations the charging is done based on the static
+battery characteristics. This is done at the boot time by passing the battery
+properties (max_voltage, capacity) etc. as a platform data to the
+charger/battery driver. But new generation high volt batteries needs to be
+identified dynamically to do charging in a safe manner. The batteries are coming
+with different communication protocols. It become necessary to communicate with
+battery and identify it's charging profiles before setup charging.
+
+Also the charging algorithms can vary based on the battery characteristics
+and the platform characteristics. To handle charging in a generic way it's
+necessary to support pluggable charging algorithms. Power Supply Charging
+driver selects algorithms based on the type of battery charging profile.
+This is a simple binding and can be improved later. This may be improved to
+select the algorithms based on the platform requirements. Also we can extend
+this driver to plug algorithms from the user space.
+
+The driver also introduces the charger cable arbitration. A charger may
+supports multiple cables, but it may not be able to charge with multiple
+cables at a time (USB/AC/Wireless etc). The arbitration logic inside the
+driver selects the cable based on it's capabilities and the maximum
+charge current the platform can support.
+
+Also the driver exposes features to control charging on different platform
+states. One such feature is thermal. The driver handles the thermal
+throttling requests for charging and control charging based on the thermal
+subsystem requirements.
+
+Overall this driver removes the charging logic out of the charger chip driver
+and the charger chip driver can just listen to the request from the power
+supply charging driver to set the charger properties. This can be implemented by
+exposing get_property and set property callbacks.
+
+2. Reading Battery charging profile
+===================================
+
+Power Supply charging driver expose sAPIs to retrieve battery profile of a
+battery. The battery profile can be read by battery identification driver which
+may be 1wire/I2C/SFI driver. Battery identification driver can register the
+battery profile with the power supply charging driver using the API
+psy_battery_prop_changed(). The driver also exposes API
+psy_get_batt_prop() to retrieve the battery profile which can be
+used by power supply drivers to setup the charging. Also drivers
+can register for battery removal/insertion notifications using
+power_supply_reg_notifier()
+
+3. Use Charging Driver to setup charging
+===========================================
+
+* Register the driver with the power_supply class
+* Register the driver with the power supply charging driver
+* Expose set_property and get_property functions so that charging
+  framework can control the charging
+
+3.1  Registering charger chip driver with power supply charging driver
+================================================================
+
+struct power_supply_class psy_usb;
+struct power_supply_charger psyc_usb;
+
+/* register with power supply subsystem */
+psy_usb.name = DEV_NAME;
+psy_usb.type = POWER_SUPPLY_TYPE_USB;
+
+/* pointer to power supply property structure */
+psy_usb.properties =  &psy_usb_props;
+psy_usb.num_properties = ARRAY_SIZE(psy_usb_props);
+
+/* pointer to power supply get property function */
+psy_usb.get_property = psy_usb_get_property;
+
+/* pointer to power supply set property function */
+psy_usb.set_property = psy_usb_set_property;
+
+/* pointer to the supplied_to argument to indicate the batteries
+   to which this charger is supplying power  */
+psy_usb.supplied_to = supplied_to;
+psy_usb.num_supplicants = num_supplicants;
+
+/* register with power_supply subsystem */
+power_supply_registe(device, &psy_usb);
+
+/* Register with power supply charging driver */
+
+/* Assign psy pointer to power supply charger */
+psyc_usb.psy = &chip->psy_usb;
+
+/* define supported cable types for this driver */
+psyc_usb.supported_cables = POWER_SUPPLY_CHARGER_TYPE_USB;
+
+/* pointer to power supply charger get property function */
+psyc_usb.get_property = bq24261_usb_psyc_get_property;
+
+/* pointer to power supply charger set property function */
+psyc_usb.set_property = bq24261_usb_psyc_set_property;
+
+/* pointer to throttle states */
+psyc_usb.throttle_states = chip->pdata->throttle_states;
+
+/* Number of throttle states */
+psyc_usb.num_throttle_states = chip->pdata->num_throttle_states;
+
+/*register with power supply charging */
+power_supply_register_charger(&chip->psyc_usb);
+
+3.2 Properties exposed to power supply class driver
+==================================================
+* POWER_SUPPLY_PROP_ONLINE
+	* Read access using get_property_function
+		* Returns the online property set using the set_property
+		  function
+	* Write access using set_property function
+		* Expose the value through get_property_fucntion.
+* POWER_SUPPLY_PROP_PRESENT
+	* Read access using get_property_function
+		* Returns the present property set using the set_property
+		  function
+	* Write access using set_property function
+		* Expose the value through get_property_fucntion.
+* POWER_SUPPLY_PROP_HEALTH
+	* Read access using get_property_function
+		* Returns charger health
+* POWER_SUPPLY_PROP_TYPE
+	* Read access using power_supply structure
+		* Returns charger type
+* POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT
+	* Read access using get property
+		* Returns the present charge control limit
+	* Write access using set property
+		* Set charge control limit.
+		* Action: Driver is not expected to take any actions on this.
+			  Instead need to expose this on the read interface.
+			  Charging framework process this and notifies the
+		  	  charging parameters accordingly.
+* POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX
+	* Read access using get property
+		* Returns the maximum charge control limit
+* POWER_SUPPLY_PROP_INLMT
+	* Read access using get property
+		* Returns the input current limit passed by set_property
+		  function
+		* Default value : 0
+	* Write access using set property
+		* Set input current limit
+		* Action : Write h/w register to set the input current limit
+			   based on the value
+* POWER_SUPPLY_PROP_CHARGE_CURRENT
+	* Read access using get property
+		* Returns charge current passed by set_property function
+		* Default value : 0
+	* Write access using set property
+		* Set charge current
+		* Action : Write h/w register to set the charge current based
+			   on the value
+* POWER_SUPPLY_PROP_CHARGE_VOLTAGE
+	* Read access using get property
+		* Returns charge voltage passed by set_property function
+		* Default value: 0
+	* Write access using set property
+		* Set charge voltage
+		* Action : Write h/w register to set the charge voltage based
+			   on the value
+* POWER_SUPPLY_PROP_CHARGE_TERM_CUR
+	* Read access using get property
+		* Returns charge termination current passed by set_property
+		  function
+		* Default value : 0
+	* Write access using set property
+		* Set charge termination current
+		* Action : Write h/w register to set the charge termination
+			   current
+			   based on the value
+* POWER_SUPPLY_PROP_TEMP_MIN
+	* Read access using get property
+		* Returns minimum charging  temperature passed by set_property
+		* Default value : Platform dependant
+	* Write access using set_property
+		* Set Minimum charging temperature
+		* Action : Write h/w register to set the minimum charging
+			   temperature based on the value
+* POWER_SUPPLY_PROP_TEMP_MAX
+	* Write access using set_property
+		* Set Maximum charging temperature
+		* Action : Write h/w register to set the maximum charging
+			   temperature based on the value
+	* Read access using get property
+		* Returns maximum charging  temperature passed by set_property
+		* Default value : Platform dependent
+* POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT
+	* Read access using get property
+		* Returns maximum charging  current passed by set_property
+		* Default value : Platform dependent
+	* Write access using set_property
+		* Set Maximum charging current
+		* Action: Configure safety charging registers if any. If not no
+			  actions expected for this.
+* POWER_SUPPLY_PROP_MAX_CHARGE_VOLTAGE
+	* Read access using get property
+		* Returns maximum charging  current passed by set_property
+		* Default value : Platform dependent
+	* Write access using set_property
+		* Set Maximum charging voltage
+		* Action: Configure safety charging registers if any. If not,
+			  no actions expected for this.
+
+3.3 Properties exposed to power supply charging driver
+=====================================================
+
+* POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING
+	* Write access using set_property
+		* Enable/Disable charging. Charger supplies power to platform,
+		  but charging is disabled
+		* Action: Configure charger chip registers to enable/disable
+		  charging
+* POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER
+	* Write access using set_property
+		* Enable/Disable charger. Charger doesn't supply power to
+		  platform or battery and battery start to discharge.
+		* Action: Configure charger chip registers to enable/disable
+		  charger
+* POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE
+	* Write access using set_property
+		* Set charger cable type.
+		* Action: Report power supply type based on cable type
+* POWER_SUPPLY_CHARGER_PROP_RESET_WDT
+	* Write access using set_property
+		* Reset charger Watch Dog Timer
+		* Action: Reset charger Watch dog timer.
+* POWER_SUPPLY_CHARGER_PROP_PRIORITY
+	* Read access using get property
+		* Expose charger driver/chips priority if platform has multiple
+		  charger chip/drivers.
+
+3.4 Throttling data configuration
+=============================
+Power supply charging driver can take actions for Thermal throttling requests.
+Power supply core sends event PSY_EVENT_THROTTLE  on power_supply_notifier
+chain. Power supply charging driver handle this event and takes throttling
+actions as in the throttling configuration structure. The throttling
+configuration structure has the following format
+
+struct psy_throttle_state {
+	enum psy_throttle_action throttle_action;
+	unsigned throttle_val;
+};
+
+Throttling configuration example:
+
+struct psy_throttle_state my_throttle_states[] = {
+
+	/* Level 0:  Limit charge current to 1500mA. Normal Level */
+	{
+		.throttle_action = PSY_THROTTLE_CC_LIMIT,
+		.throttle_val = 1500,
+	},
+
+	/* Level 1: Limit charge current to 500mA */
+	{
+		.throttle_action = PSY_THROTTLE_CC_LIMIT,
+		.throttle_val = 500,
+	},
+
+	/* Level 2: Disable charging: Stop charging, charger supply power to platform */
+	{
+		.throttle_action = PSY_THROTTLE_DISABLE_CHARGING,
+	},
+
+	/* Level 3: Disable charger: Battery start discharging */
+	{
+		.throttle_action = PSY_THROTTLE_DISABLE_CHARGER,
+	},
+
+};
+
+4. Charger Cable notifications
+==============================
+
+Charger cables can have different charging capabilities (current) depending on
+platform and cable type. The cable provider drivers detect and identify the
+cable types and notifies the power supply subsystem by posting an event
+PSY_EVENT_CABLE on the power_supply_notifier chain. The event notification
+should have a property structure pointer which indicates the cable type, event
+and capability.
+
+struct psy_cable_props cable;
+cable.chrg_evt = PSY_CHARGER_CABLE_EVENT_CONNECT;
+cable.chrg_type = PSY_CHARGER_CABLE_TYPE_USB_DCP;
+cable.ma = 1500;
+
+atomic_notifier_call_chain(&power_supply_notifier,
+				PSY_EVENT_CABLE, &cable);
+
+Power supply charging driver process this event and takes actions to setup
+charging
+
+5. Registering new charging algorithm
+===================================
+Power supply charging driver supports pluggable charging algorithms. Charging
+algorithms process charging profile and/or applies different logic (pulse
+charging/fast charging/relaxed charging) to decide the charging parameters (CC
+and CV).
+
+* Populate algorithm structure
+	struct psy_charging_algo new_algo;
+	/* populate the type charging profile the algorithm handles */
+	pse_algo.chrg_prof_type = PSY_CHRG_PROF_PSE;
+	pse_algo.name = "my_algo";
+	/* callback function to retrieve CC and CV */
+	pse_algo.get_next_cc_cv = my_algo_get_next_cc_cv;
+	/* callback function to retreive battery thresholds */
+	pse_algo.get_batt_thresholds = my_algo__get_bat_thresholds;
+	/* register charging algorithm */
+	power_supply_register_charging_algo(&pse_algo);
+
+When the type of charging profile reported by battery and algorithm matches,
+the algorithm will be invoked to get the charging parameters.
+
+6. TODO
+=======
+* Replace static cable array with dynamic list
+* Implement safety timer and watch dog timer features with more monitoring
+* Move charge full detection logic to psy charging driver from algorithm driver
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0196acf..7bfad7a 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -14,6 +14,14 @@ config POWER_SUPPLY_DEBUG
 	  Say Y here to enable debugging messages for power supply class
 	  and drivers.
 
+config POWER_SUPPLY_CHARGER
+	bool "Power Supply Charger"
+	help
+	  Say Y here to enable the power supply charging control driver. Charging
+	  control supports charging in a generic way. This allows the charger
+	  drivers to keep the charging logic outside and the charger driver
+	  just need to abstract the charger hardware
+
 config PDA_POWER
 	tristate "Generic PDA/phone power driver"
 	depends on !S390
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee54a3e..405f0f4 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -7,6 +7,7 @@ power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
 
+obj-$(CONFIG_POWER_SUPPLY_CHARGER) += power_supply_charger.o
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
 obj-$(CONFIG_MAX8925_POWER)	+= max8925_power.o
diff --git a/drivers/power/power_supply_charger.c b/drivers/power/power_supply_charger.c
new file mode 100644
index 0000000..40f90ab
--- /dev/null
+++ b/drivers/power/power_supply_charger.c
@@ -0,0 +1,1191 @@
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ */
+#define DEBUG
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/thermal.h>
+#include <linux/notifier.h>
+#include <linux/usb/otg.h>
+#include <linux/power/power_supply_charger.h>
+#include "power_supply_charger.h"
+
+
+#define MAX_CHARGER_COUNT 5
+
+static LIST_HEAD(algo_list);
+
+struct psy_event_node {
+	struct list_head node;
+	unsigned long event;
+	struct psy_cable_props cap;
+	struct power_supply *psy;
+	struct psy_ps_batt_chg_prof batt_property;
+};
+
+struct power_supply_charger_cxt {
+	bool is_usb_cable_evt_reg;
+	int psyc_cnt;
+	int batt_status;
+	/*cache battery and charger properties */
+	struct list_head chrgr_cache_lst;
+	struct list_head batt_cache_lst;
+	struct list_head evt_queue;
+	struct mutex evt_lock;
+	struct list_head event_queue;
+	struct psy_ps_batt_chg_prof batt_property;
+	wait_queue_head_t wait_chrg_enable;
+	spinlock_t battid_spinlock;
+	spinlock_t event_queue_lock;
+	struct work_struct event_work;
+};
+
+struct charger_cable {
+	struct psy_cable_props cable_props;
+	enum psy_charger_cable_type psy_cable_type;
+};
+
+static struct power_supply_charger_cxt psy_chrgr;
+
+static struct charger_cable cable_list[] = {
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_SDP,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_CDP,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_DCP,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_ACA,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_ACA_DOCK,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_SE1,
+	 },
+	{
+	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_AC,
+	 },
+};
+
+static int get_supplied_by_list(struct power_supply *psy,
+				struct power_supply *psy_lst[]);
+
+static int handle_event_notification(struct notifier_block *nb,
+				   unsigned long event, void *data);
+struct usb_phy *otg_xceiver;
+struct notifier_block nb = {
+		   .notifier_call = handle_event_notification,
+		};
+static void configure_chrgr_source(struct charger_cable *cable_lst);
+
+
+struct psy_charging_algo *power_supply_get_charging_algo
+		(struct power_supply *, struct psy_ps_batt_chg_prof *);
+static void __power_supply_trigger_charging_handler(struct power_supply *psy);
+static void power_supply_trigger_charging_handler(struct power_supply *psy);
+static void trigger_algo_psy_class(void);
+static int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state);
+
+
+static inline bool psy_is_battery_prop_changed(struct psy_batt_props bat_prop,
+		struct psy_batt_props bat_cache)
+{
+	/* return true if temperature, health or throttling state changed
+	*/
+	if ((bat_cache.temperature != bat_prop.temperature) ||
+		(bat_cache.health != bat_prop.health) ||
+		(bat_cache.throttle_state != bat_prop.throttle_state))
+		return true;
+
+	/* return true if voltage or current changed not within TTL limit
+	*/
+	if (time_after64(bat_prop.tstamp, bat_cache.tstamp + PROP_TTL) &&
+		(bat_cache.current_now != bat_prop.current_now ||
+		bat_cache.voltage_now != bat_prop.voltage_now))
+		return true;
+
+	return false;
+}
+
+static inline bool psy_is_charger_prop_changed(struct psy_charger_props prop,
+		struct psy_charger_props cache_prop)
+{
+	/* if online/prsent/health/is_charging is changed, then return true
+	*/
+
+	if (cache_prop.online != prop.online ||
+		cache_prop.present != prop.present ||
+		cache_prop.is_charging != prop.is_charging ||
+		cache_prop.health != prop.health)
+		return true;
+	else
+		return false;
+
+}
+
+static inline void get_cur_chrgr_prop(struct power_supply *psy,
+				      struct psy_charger_props *chrgr_prop)
+{
+	chrgr_prop->is_charging = psy_is_charging_enabled(psy);
+	chrgr_prop->name = psy->name;
+	chrgr_prop->online = psy_is_online(psy);
+	chrgr_prop->present = psy_is_present(psy);
+	chrgr_prop->cable = psy_cable_type(psy);
+	chrgr_prop->health = PSY_HEALTH(psy);
+	chrgr_prop->tstamp = get_jiffies_64();
+}
+
+static inline int get_chrgr_prop_cache(struct power_supply *psy,
+				       struct psy_charger_props *chrgr_cache)
+{
+	struct psy_charger_props *chrgr_prop;
+	int ret = -ENODEV;
+
+	list_for_each_entry(chrgr_prop, &psy_chrgr.chrgr_cache_lst, node) {
+		if (!strcmp(chrgr_prop->name, psy->name)) {
+			memcpy(chrgr_cache, chrgr_prop, sizeof(*chrgr_cache));
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void dump_charger_props(struct psy_charger_props *props)
+{
+	pr_devel("%s:name=%s present=%d is_charging=%d health=%d online=%d cable=%ld tstamp=%ld\n",
+		__func__, props->name, props->present, props->is_charging,
+		props->health, props->online, props->cable,
+		props->tstamp);
+}
+
+static void dump_battery_props(struct psy_batt_props *props)
+{
+	pr_devel("%s:name=%s voltage_now=%ld current_now=%ld temperature=%d status=%ld health=%d tstamp=%lld algo_stat=%d ",
+		__func__, props->name, props->voltage_now, props->current_now,
+		props->temperature, props->status, props->health,
+		props->tstamp, props->algo_stat);
+}
+
+static inline void cache_chrgr_prop(struct psy_charger_props *chrgr_prop_new)
+{
+	struct psy_charger_props *chrgr_cache;
+
+	list_for_each_entry(chrgr_cache, &psy_chrgr.chrgr_cache_lst, node) {
+		if (!strcmp(chrgr_cache->name, chrgr_prop_new->name))
+			goto update_props;
+	}
+
+	chrgr_cache = kzalloc(sizeof(*chrgr_cache), GFP_KERNEL);
+	if (chrgr_cache == NULL) {
+		pr_err("%s:%dError in allocating memory\n", __FILE__, __LINE__);
+		return;
+	}
+
+	INIT_LIST_HEAD(&chrgr_cache->node);
+	list_add_tail(&chrgr_cache->node, &psy_chrgr.chrgr_cache_lst);
+
+	chrgr_cache->name = chrgr_prop_new->name;
+
+update_props:
+	chrgr_cache->is_charging = chrgr_prop_new->is_charging;
+	chrgr_cache->online = chrgr_prop_new->online;
+	chrgr_cache->health = chrgr_prop_new->health;
+	chrgr_cache->present = chrgr_prop_new->present;
+	chrgr_cache->cable = chrgr_prop_new->cable;
+	chrgr_cache->tstamp = chrgr_prop_new->tstamp;
+	chrgr_cache->psyc = chrgr_prop_new->psyc;
+}
+
+static inline int __power_supply_register_charger(struct power_supply *psy,
+	struct power_supply_charger *psyc)
+{
+	struct psy_charger_props chrgr_props;
+
+	if (!get_chrgr_prop_cache(psy, &chrgr_props))
+		return -EEXIST;
+
+	get_cur_chrgr_prop(psy, &chrgr_props);
+	chrgr_props.psyc = psyc;
+	cache_chrgr_prop(&chrgr_props);
+	dump_charger_props(&chrgr_props);
+
+	return 0;
+}
+
+inline struct power_supply_charger *psy_to_psyc(struct power_supply *psy)
+{
+	struct psy_charger_props chrgr_props;
+
+	if (psy_is_charger(psy) && !get_chrgr_prop_cache(psy, &chrgr_props))
+		return  chrgr_props.psyc;
+
+	return  NULL;
+}
+
+
+static inline bool is_chrgr_prop_changed(struct power_supply *psy)
+{
+	struct psy_charger_props chrgr_prop_cache, chrgr_prop;
+
+	get_cur_chrgr_prop(psy, &chrgr_prop);
+	/* Get cached battery property. If no cached property available
+	 *  then cache the new property and return true
+	 */
+	if (get_chrgr_prop_cache(psy, &chrgr_prop_cache)) {
+		cache_chrgr_prop(&chrgr_prop);
+		return true;
+	}
+
+	pr_devel("%s\n", __func__);
+	dump_charger_props(&chrgr_prop);
+	dump_charger_props(&chrgr_prop_cache);
+
+	if (!psy_is_charger_prop_changed(chrgr_prop, chrgr_prop_cache))
+		return false;
+
+	chrgr_prop.psyc = chrgr_prop_cache.psyc;
+	cache_chrgr_prop(&chrgr_prop);
+	return true;
+}
+static void cache_successive_samples(long *sample_array, long new_sample)
+{
+	int i;
+
+	for (i = 0; i < MAX_CUR_VOLT_SAMPLES - 1; ++i)
+		*(sample_array + i) = *(sample_array + i + 1);
+
+	*(sample_array + i) = new_sample;
+}
+
+static inline void cache_bat_prop(struct psy_batt_props *bat_prop_new)
+{
+	struct psy_batt_props *bat_cache;
+
+	/* Find entry in cache list. If an entry is located update
+	 * the existing entry else create new entry in the list */
+	list_for_each_entry(bat_cache, &psy_chrgr.batt_cache_lst, node) {
+		if (!strcmp(bat_cache->name, bat_prop_new->name))
+			goto update_props;
+	}
+
+	bat_cache = kzalloc(sizeof(*bat_cache), GFP_KERNEL);
+	if (bat_cache == NULL) {
+		pr_err("%s:%dError in allocating memory\n", __FILE__, __LINE__);
+		return;
+	}
+	INIT_LIST_HEAD(&bat_cache->node);
+	list_add_tail(&bat_cache->node, &psy_chrgr.batt_cache_lst);
+
+	bat_cache->name = bat_prop_new->name;
+
+update_props:
+	if (time_after64(bat_prop_new->tstamp,
+		(bat_cache->tstamp + DEF_CUR_VOLT_SAMPLE_JIFF)) ||
+						bat_cache->tstamp == 0) {
+		cache_successive_samples(bat_cache->voltage_now_cache,
+						bat_prop_new->voltage_now);
+		cache_successive_samples(bat_cache->current_now_cache,
+						bat_prop_new->current_now);
+		bat_cache->tstamp = bat_prop_new->tstamp;
+	}
+
+	bat_cache->voltage_now = bat_prop_new->voltage_now;
+	bat_cache->current_now = bat_prop_new->current_now;
+	bat_cache->health = bat_prop_new->health;
+
+	bat_cache->temperature = bat_prop_new->temperature;
+	bat_cache->status = bat_prop_new->status;
+	bat_cache->algo_stat = bat_prop_new->algo_stat;
+	bat_cache->throttle_state = bat_prop_new->throttle_state;
+}
+
+static inline int get_bat_prop_cache(struct power_supply *psy,
+				     struct psy_batt_props *bat_cache)
+{
+	struct psy_batt_props *bat_prop;
+	int ret = -ENODEV;
+
+	list_for_each_entry(bat_prop, &psy_chrgr.batt_cache_lst, node) {
+		if (!strcmp(bat_prop->name, psy->name)) {
+			memcpy(bat_cache, bat_prop, sizeof(*bat_cache));
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static inline void get_cur_bat_prop(struct power_supply *psy,
+				    struct psy_batt_props *bat_prop)
+{
+	struct psy_batt_props bat_prop_cache;
+	int ret;
+
+	bat_prop->name = psy->name;
+	bat_prop->voltage_now = PSY_VOLTAGE_OCV(psy) / 1000;
+	bat_prop->current_now = PSY_CURRENT_NOW(psy) / 1000;
+	bat_prop->temperature = PSY_TEMPERATURE(psy) / 10;
+	bat_prop->status = PSY_STATUS(psy);
+	bat_prop->health = PSY_HEALTH(psy);
+	bat_prop->tstamp = get_jiffies_64();
+	bat_prop->throttle_state = psy_current_throttle_state(psy);
+
+	/* Populate cached algo data to new profile */
+	ret = get_bat_prop_cache(psy, &bat_prop_cache);
+	if (!ret)
+		bat_prop->algo_stat = bat_prop_cache.algo_stat;
+}
+
+static inline bool is_batt_prop_changed(struct power_supply *psy)
+{
+	struct psy_batt_props bat_prop_cache, bat_prop;
+
+	/* Get cached battery property. If no cached property available
+	 *  then cache the new property and return true
+	 */
+	get_cur_bat_prop(psy, &bat_prop);
+	if (get_bat_prop_cache(psy, &bat_prop_cache)) {
+		cache_bat_prop(&bat_prop);
+		return true;
+	}
+
+	pr_devel("%s\n", __func__);
+	dump_battery_props(&bat_prop);
+	dump_battery_props(&bat_prop_cache);
+
+	if (!psy_is_battery_prop_changed(bat_prop, bat_prop_cache))
+		return false;
+
+	cache_bat_prop(&bat_prop);
+	return true;
+}
+
+static inline bool is_supplied_to_has_ext_pwr_changed(struct power_supply *psy)
+{
+	int i;
+	struct power_supply *psb;
+	bool is_pwr_changed_defined = true;
+
+	for (i = 0; i < psy->num_supplicants; i++) {
+		psb =
+		    power_supply_get_by_name(psy->
+					     supplied_to[i]);
+		if (psb && !psb->external_power_changed)
+			is_pwr_changed_defined &= false;
+	}
+
+	return is_pwr_changed_defined;
+}
+
+static inline bool is_supplied_by_changed(struct power_supply *psy)
+{
+	int cnt;
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+	while (cnt--) {
+		if ((psy_is_charger(chrgr_lst[cnt])) &&
+			is_chrgr_prop_changed(chrgr_lst[cnt]))
+			return true;
+	}
+
+	return false;
+}
+
+struct charger_cable *get_cable(unsigned long chrgr_type)
+{
+	switch (chrgr_type) {
+	case PSY_CHARGER_CABLE_TYPE_USB_SDP:
+		return &cable_list[0];
+	case PSY_CHARGER_CABLE_TYPE_USB_CDP:
+		return &cable_list[1];
+	case PSY_CHARGER_CABLE_TYPE_USB_DCP:
+		return &cable_list[2];
+	case PSY_CHARGER_CABLE_TYPE_USB_ACA:
+		return &cable_list[3];
+	case PSY_CHARGER_CABLE_TYPE_ACA_DOCK:
+		return &cable_list[4];
+	case PSY_CHARGER_CABLE_TYPE_AC:
+		return &cable_list[6];
+	case PSY_CHARGER_CABLE_TYPE_SE1:
+		return &cable_list[5];
+	}
+
+	return NULL;
+}
+
+
+static int process_cable_props(struct psy_cable_props *cap)
+{
+	struct charger_cable *cable = NULL;
+
+	pr_info("%s: event:%d, type:%d, ma:%d\n",
+		__func__, cap->chrg_evt, cap->chrg_type, cap->ma);
+
+	cable = get_cable(cap->chrg_type);
+	if (!cable) {
+		pr_err("%s:%d Error in getting charger cable from get_cable\n",
+				__FILE__, __LINE__);
+		return -EINVAL;
+	}
+	memcpy((void *)&cable->cable_props, (void *)cap,
+			sizeof(cable->cable_props));
+
+	configure_chrgr_source(cable_list);
+
+	return 0;
+}
+
+static void event_worker(struct work_struct *work)
+{
+	int state;
+	struct psy_event_node *evt, *tmp;
+
+	spin_lock(&psy_chrgr.event_queue_lock);
+	list_for_each_entry_safe(evt, tmp, &psy_chrgr.event_queue, node) {
+		list_del(&evt->node);
+		spin_unlock(&psy_chrgr.event_queue_lock);
+
+		mutex_lock(&psy_chrgr.evt_lock);
+
+		switch (evt->event) {
+		case PSY_EVENT_CABLE:
+			process_cable_props(&evt->cap);
+			break;
+		case PSY_EVENT_PROP_CHANGED:
+			power_supply_trigger_charging_handler(evt->psy);
+			break;
+		case PSY_EVENT_THROTTLE:
+			state = psy_current_throttle_state(evt->psy);
+			psy_charger_throttle_charger(evt->psy, state);
+			break;
+		case PSY_EVENT_BATTERY:
+			power_supply_trigger_charging_handler(NULL);
+			/*TODO: Cache battery profile */
+			break;
+		default:
+			pr_err("%s: Invalid event\n", __func__);
+			break;
+		}
+
+		mutex_unlock(&psy_chrgr.evt_lock);
+
+		spin_lock(&psy_chrgr.event_queue_lock);
+		kfree(evt);
+	}
+
+	spin_unlock(&psy_chrgr.event_queue_lock);
+}
+
+static int handle_event_notification(struct notifier_block *nb,
+				   unsigned long event, void *data)
+{
+	struct psy_event_node *evt;
+
+	evt = kzalloc(sizeof(*evt), GFP_ATOMIC);
+	if (!evt) {
+		pr_err("%s: failed to allocate memory for event\n", __func__);
+		return NOTIFY_DONE;
+	}
+
+	evt->event = event;
+
+	switch (event) {
+	case PSY_EVENT_CABLE:
+		memcpy(&evt->cap, data, sizeof(struct psy_cable_props));
+		break;
+	case PSY_EVENT_PROP_CHANGED:
+	case PSY_EVENT_THROTTLE:
+		evt->psy = data;
+		break;
+	case PSY_EVENT_BATTERY:
+		memcpy(&evt->batt_property, data,
+			sizeof(struct psy_ps_batt_chg_prof));
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	INIT_LIST_HEAD(&evt->node);
+	spin_lock(&psy_chrgr.event_queue_lock);
+	list_add_tail(&evt->node, &psy_chrgr.event_queue);
+	spin_unlock(&psy_chrgr.event_queue_lock);
+	queue_work(system_wq, &psy_chrgr.event_work);
+	return NOTIFY_OK;
+}
+
+static int register_usb_notifier(void)
+{
+	int retval = 0;
+
+	otg_xceiver = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (!otg_xceiver) {
+		pr_err("failure to get otg transceiver\n");
+		retval = -EIO;
+		goto notifier_reg_failed;
+	}
+	retval = usb_register_notifier(otg_xceiver, &nb);
+	if (retval) {
+		pr_err("failure to register otg notifier\n");
+		goto notifier_reg_failed;
+	}
+
+notifier_reg_failed:
+	return retval;
+}
+
+static inline bool is_trigger_charging_algo(struct power_supply *psy)
+{
+	/* trigger charging alorithm if battery or
+	 * charger properties are changed. Also no need to
+	 * invoke algorithm for power_supply_changed from
+	 * charger, if all supplied_to has the ext_port_changed defined.
+	 * On invoking the ext_port_changed the supplied to can send
+	 * power_supplied_changed event.
+	 */
+
+	if ((psy_is_charger(psy) && !is_supplied_to_has_ext_pwr_changed(psy)) &&
+			is_chrgr_prop_changed(psy))
+		return true;
+
+	if ((psy_is_battery(psy)) && (is_batt_prop_changed(psy) ||
+				is_supplied_by_changed(psy)))
+		return true;
+
+	return false;
+}
+
+static int get_supplied_by_list(struct power_supply *psy,
+				struct power_supply *psy_lst[])
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+	struct power_supply *pst;
+	int cnt = 0, i, j;
+
+	if (!psy_is_battery(psy))
+		return 0;
+
+	/* Identify chargers which are supplying power to the battery */
+	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		pst = (struct power_supply *)dev_get_drvdata(dev);
+		if (!psy_is_charger(pst))
+			continue;
+		for (i = 0; i < pst->num_supplicants; i++) {
+			if (!strcmp(pst->supplied_to[i], psy->name))
+				psy_lst[cnt++] = pst;
+		}
+	}
+	class_dev_iter_exit(&iter);
+
+	if (cnt <= 1)
+		return cnt;
+
+	/*sort based on priority. 0 has the highest priority  */
+	for (i = 0; i < cnt; ++i)
+		for (j = 0; j < cnt; ++j)
+			if (psy_prioirty(psy_lst[j]) > psy_prioirty(psy_lst[i]))
+				swap(psy_lst[j], psy_lst[i]);
+
+	return cnt;
+}
+
+static int get_battery_status(struct power_supply *psy)
+{
+	int cnt, status, ret;
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+	struct psy_batt_props bat_prop;
+
+	if (!psy_is_battery(psy))
+		return -EINVAL;
+
+	ret = get_bat_prop_cache(psy, &bat_prop);
+	if (ret)
+		return ret;
+
+	status = POWER_SUPPLY_STATUS_DISCHARGING;
+
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+
+	while (cnt--) {
+
+		if (psy_is_present(chrgr_lst[cnt]))
+			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+
+		if (psy_is_charging_can_be_enabled(chrgr_lst[cnt]) &&
+			(psy_is_health_good(psy)) &&
+				(psy_is_health_good(chrgr_lst[cnt]))) {
+
+			if ((bat_prop.algo_stat == PSY_ALGO_STAT_FULL) ||
+				(bat_prop.algo_stat == PSY_ALGO_STAT_MAINT))
+				status = POWER_SUPPLY_STATUS_FULL;
+			else if (psy_is_charging_enabled(chrgr_lst[cnt]))
+				status = POWER_SUPPLY_STATUS_CHARGING;
+		}
+	}
+
+	pr_devel("%s: Set status=%d for %s\n", __func__, status, psy->name);
+
+	return status;
+}
+
+static void update_charger_online(struct power_supply *psy)
+{
+	if (psy_is_charger_enabled(psy))
+		psy_set_charger_online(psy, 1);
+	else
+		psy_set_charger_online(psy, 0);
+}
+
+static void update_sysfs(struct power_supply *psy)
+{
+	int i, cnt;
+	struct power_supply *psb;
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+
+	if (psy_is_battery(psy)) {
+		/* set battery status */
+		psy_set_battery_status(psy, get_battery_status(psy));
+
+		/* set charger online */
+		cnt = get_supplied_by_list(psy, chrgr_lst);
+		while (cnt--) {
+			if (!psy_is_present(chrgr_lst[cnt]))
+				continue;
+
+			update_charger_online(psy);
+		}
+	} else {
+		/*set battery status */
+		for (i = 0; i < psy->num_supplicants; i++) {
+			psb =
+			    power_supply_get_by_name(psy->
+						     supplied_to[i]);
+			if (psb && psy_is_battery(psb) && psy_is_present(psb))
+				psy_set_battery_status(psb,
+					get_battery_status(psb));
+		}
+
+		/*set charger online */
+		update_charger_online(psy);
+	}
+}
+
+static int trigger_algo(struct power_supply *psy)
+{
+	unsigned long cc = 0, cv = 0, cc_min;
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+	struct psy_batt_props bat_prop;
+	struct psy_charging_algo *algo;
+	struct psy_ps_batt_chg_prof chrg_profile;
+	int cnt;
+
+	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
+		return 0;
+
+	if (psy_get_batt_prop(&chrg_profile)) {
+		pr_err("Error in getting charge profile:%s:%d\n", __FILE__,
+		       __LINE__);
+		return -EINVAL;
+	}
+
+	get_bat_prop_cache(psy, &bat_prop);
+
+	algo = power_supply_get_charging_algo(psy, &chrg_profile);
+	if (!algo) {
+		pr_err("%s:Error in getting charging algo!!\n", __func__);
+		return -EINVAL;
+	}
+
+	bat_prop.algo_stat = algo->get_next_cc_cv(bat_prop,
+						chrg_profile, &cc, &cv);
+
+	pr_info("%s:Algo_status:%d\n", __func__, bat_prop.algo_stat);
+
+	cache_bat_prop(&bat_prop);
+
+	if (!cc || !cv)
+		return -ENODATA;
+
+	/* CC needs to be updated for all chargers which are supplying
+	 *  power to this battery to ensure that the sum of CCs of all
+	 * chargers are never more than the CC selected by the algo.
+	 * The CC is set based on the charger priority.
+	 */
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+
+	while (cnt--) {
+		if (!psy_is_present(chrgr_lst[cnt]))
+			continue;
+
+		cc_min = min_t(unsigned long, PSY_MAX_CC(chrgr_lst[cnt]), cc);
+		if (cc_min < 0)
+			cc_min = 0;
+		cc -= cc_min;
+		psy_set_cc(chrgr_lst[cnt], cc_min);
+		psy_set_cv(chrgr_lst[cnt], cv);
+	}
+
+	return 0;
+}
+
+static inline void wait_for_charging_enabled(struct power_supply *psy)
+{
+	wait_event_timeout(psy_chrgr.wait_chrg_enable,
+			(psy_is_charging_enabled(psy)), HZ);
+}
+
+static inline void enable_supplied_by_charging
+		(struct power_supply *psy, bool is_enable)
+{
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+	int cnt;
+
+	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
+		return;
+	/* Get list of chargers supplying power to this battery and
+	 * disable charging for all chargers
+	 */
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+	if (cnt == 0)
+		return;
+
+	while (cnt--) {
+		if (!psy_is_present(chrgr_lst[cnt]))
+			continue;
+		if (is_enable &&
+			psy_is_charging_can_be_enabled(chrgr_lst[cnt])) {
+
+			psy_enable_charging(chrgr_lst[cnt]);
+			wait_for_charging_enabled(chrgr_lst[cnt]);
+
+		} else
+			psy_disable_charging(chrgr_lst[cnt]);
+	}
+}
+
+static void __power_supply_trigger_charging_handler(struct power_supply *psy)
+{
+	int i;
+	struct power_supply *psb = NULL;
+
+
+	if (is_trigger_charging_algo(psy)) {
+		if (psy_is_battery(psy)) {
+			if (trigger_algo(psy))
+				enable_supplied_by_charging(psy, false);
+			else
+				enable_supplied_by_charging(psy, true);
+		} else if (psy_is_charger(psy)) {
+			for (i = 0; i < psy->num_supplicants; i++) {
+				psb =
+				    power_supply_get_by_name(psy->
+							     supplied_to[i]);
+
+				if (psb && psy_is_battery(psb) &&
+							psy_is_present(psb)) {
+					if (trigger_algo(psb)) {
+						psy_disable_charging(psy);
+						break;
+					} else if
+						(psy_is_charging_can_be_enabled
+								(psy)) {
+						psy_enable_charging(psy);
+						wait_for_charging_enabled(psy);
+					}
+				}
+			}
+		}
+		update_sysfs(psy);
+		power_supply_changed(psy);
+	}
+}
+
+static int __trigger_charging_handler(struct device *dev, void *data)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	__power_supply_trigger_charging_handler(psy);
+
+	return 0;
+}
+
+static void trigger_algo_psy_class(void)
+{
+	class_for_each_device(power_supply_class, NULL, NULL,
+			__trigger_charging_handler);
+}
+
+static void power_supply_trigger_charging_handler(struct power_supply *psy)
+{
+	if (!psy_chrgr.psyc_cnt)
+		return;
+
+	wake_up(&psy_chrgr.wait_chrg_enable);
+
+	if (psy)
+		__power_supply_trigger_charging_handler(psy);
+	else
+		trigger_algo_psy_class();
+
+}
+
+static inline int get_battery_thresholds(struct power_supply *psy,
+	struct psy_batt_thresholds *bat_thresh)
+{
+	struct psy_charging_algo *algo;
+	struct psy_ps_batt_chg_prof chrg_profile;
+
+	/* FIXME: Get iterm only for supplied_to arguments*/
+	if (psy_get_batt_prop(&chrg_profile)) {
+		pr_err("%s:Error in getting charge profile\n", __func__);
+		return -EINVAL;
+	}
+
+	algo = power_supply_get_charging_algo(psy, &chrg_profile);
+	if (!algo) {
+		pr_err("%s:Error in getting charging algo!!\n", __func__);
+		return -EINVAL;
+	}
+
+	if (algo->get_batt_thresholds) {
+		algo->get_batt_thresholds(chrg_profile, bat_thresh);
+	} else {
+		pr_err("%s:Error in getting battery thresholds from: %s\n",
+			__func__, algo->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int select_chrgr_cable(struct device *dev, void *data)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct charger_cable *cable, *max_ma_cable = NULL;
+	struct charger_cable *cable_lst = (struct charger_cable *)data;
+	struct psy_batt_thresholds bat_thresh;
+	unsigned int max_ma = 0;
+	int i;
+
+	if (!psy_is_charger(psy))
+		return 0;
+
+
+	/* get cable with maximum capability */
+	for (i = 0; i < ARRAY_SIZE(cable_list); ++i) {
+		cable = cable_lst + i;
+		if ((!psy_is_cable_active(cable->cable_props.chrg_evt)) ||
+		    (!psy_is_supported_cable(psy, cable->psy_cable_type)))
+			continue;
+
+		if (cable->cable_props.ma > max_ma) {
+			max_ma_cable = cable;
+			max_ma = cable->cable_props.ma;
+		}
+	}
+
+	/* no cable connected. disable charging */
+	if (!max_ma_cable) {
+
+		if ((psy_is_charger_enabled(psy) ||
+				psy_is_charging_enabled(psy))) {
+			psy_disable_charging(psy);
+			psy_disable_charger(psy);
+		}
+		psy_set_cc(psy, 0);
+		psy_set_cv(psy, 0);
+		psy_set_inlmt(psy, 0);
+
+		/* set present and online as 0 */
+		psy_set_present(psy, 0);
+		update_charger_online(psy);
+
+		psy_switch_cable(psy, PSY_CHARGER_CABLE_TYPE_NONE);
+
+		power_supply_changed(psy);
+		return 0;
+	}
+
+	/* cable type changed.New cable connected or existing cable
+	 * capabilities changed.switch cable and enable charger and charging
+	 */
+	psy_set_present(psy, 1);
+
+	if (psy_cable_type(psy) != max_ma_cable->psy_cable_type)
+		psy_switch_cable(psy, max_ma_cable->psy_cable_type);
+
+	if (psy_is_charger_can_be_enabled(psy)) {
+		memset(&bat_thresh, 0, sizeof(bat_thresh));
+		psy_enable_charger(psy);
+
+		update_charger_online(psy);
+
+		psy_set_inlmt(psy, max_ma_cable->cable_props.ma);
+		if (!get_battery_thresholds(psy, &bat_thresh)) {
+			psy_set_iterm(psy, bat_thresh.iterm);
+			psy_set_min_temp(psy, bat_thresh.temp_min);
+			psy_set_max_temp(psy, bat_thresh.temp_max);
+		}
+
+	} else {
+		psy_disable_charger(psy);
+		update_charger_online(psy);
+	}
+
+	power_supply_trigger_charging_handler(NULL);
+	/* Cable status is same as previous. No action to be taken */
+	return 0;
+}
+
+static void configure_chrgr_source(struct charger_cable *cable_lst)
+{
+	class_for_each_device(power_supply_class, NULL,
+			      cable_lst, select_chrgr_cable);
+}
+
+static int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state)
+{
+	if (state < 0 || state > psy_max_throttle_state(psy))
+		return -EINVAL;
+
+
+	switch (psy_throttle_action(psy, state)) {
+	case PSY_THROTTLE_DISABLE_CHARGER:
+		psy_set_max_cc(psy, 0);
+		psy_disable_charger(psy);
+		break;
+	case PSY_THROTTLE_DISABLE_CHARGING:
+		psy_set_max_cc(psy, 0);
+		psy_disable_charging(psy);
+		break;
+	case PSY_THROTTLE_CC_LIMIT:
+		psy_set_max_cc(psy, psy_throttle_cc_value(psy, state));
+		break;
+	case PSY_THROTTLE_INPUT_LIMIT:
+		psy_set_inlmt(psy, psy_throttle_cc_value(psy, state));
+		break;
+	default:
+		pr_err("Invalid throttle action for %s\n", psy->name);
+		return -EINVAL;
+	}
+
+	configure_chrgr_source(cable_list);
+	return 0;
+}
+
+
+static inline void flush_charger_context(struct power_supply *psy)
+{
+	struct psy_charger_props *chrgr_prop, *tmp;
+
+
+	list_for_each_entry_safe(chrgr_prop, tmp,
+				&psy_chrgr.chrgr_cache_lst, node) {
+		if (!strcmp(chrgr_prop->name, psy->name)) {
+			list_del(&chrgr_prop->node);
+			kfree(chrgr_prop);
+		}
+	}
+}
+
+
+int power_supply_register_charging_algo(struct psy_charging_algo *algo)
+{
+
+	struct psy_charging_algo *algo_new;
+
+	algo_new = kzalloc(sizeof(*algo_new), GFP_KERNEL);
+	if (algo_new == NULL) {
+		pr_err("%s: Error allocating memory for algo!!", __func__);
+		return -ENOMEM;
+	}
+	memcpy(algo_new, algo, sizeof(*algo_new));
+
+	list_add_tail(&algo_new->node, &algo_list);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_register_charging_algo);
+
+int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
+{
+	struct psy_charging_algo *algo_l, *tmp;
+
+	list_for_each_entry_safe(algo_l, tmp, &algo_list, node) {
+		if (!strcmp(algo_l->name, algo->name)) {
+			list_del(&algo_l->node);
+			kfree(algo_l);
+		}
+	}
+	return 0;
+
+}
+EXPORT_SYMBOL(power_supply_unregister_charging_algo);
+
+
+static struct psy_charging_algo *get_charging_algo_by_type
+		(enum psy_batt_chrg_prof_type chrg_prof_type)
+{
+	struct psy_charging_algo *algo;
+
+	list_for_each_entry(algo, &algo_list, node) {
+		if (algo->chrg_prof_type == chrg_prof_type)
+			return algo;
+	}
+
+	return NULL;
+}
+
+struct psy_charging_algo *power_supply_get_charging_algo
+	(struct power_supply *psy, struct psy_ps_batt_chg_prof *batt_prof)
+{
+
+	return get_charging_algo_by_type(batt_prof->chrg_prof_type);
+
+}
+EXPORT_SYMBOL_GPL(power_supply_get_charging_algo);
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
+	spin_lock(&psy_chrgr.battid_spinlock);
+	if (psy_chrgr.batt_status != battery_conn_stat) {
+		if (battery_conn_stat == POWER_SUPPLY_BATTERY_INSERTED)
+			memcpy(&psy_chrgr.batt_property, batt_prop,
+				sizeof(psy_chrgr.batt_property));
+		psy_chrgr.batt_status = battery_conn_stat;
+	}
+	spin_unlock(&psy_chrgr.battid_spinlock);
+
+	atomic_notifier_call_chain(&power_supply_notifier,
+			PSY_EVENT_BATTERY, &psy_chrgr.batt_property);
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
+	spin_lock(&psy_chrgr.battid_spinlock);
+
+	if (psy_chrgr.batt_status != POWER_SUPPLY_BATTERY_INSERTED)
+		ret = -ENODATA;
+	else
+		memcpy(batt_prop, &psy_chrgr.batt_property,
+			sizeof(*batt_prop));
+
+	spin_unlock(&psy_chrgr.battid_spinlock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psy_get_batt_prop);
+
+
+int power_supply_register_charger(struct power_supply_charger *psyc)
+{
+	int ret;
+	if (!psyc->psy || !psyc->get_property || !psyc->set_property) {
+		pr_err("%s:Failed to register power_supply_charger\n",
+					__func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&psy_chrgr.evt_lock);
+
+	if (!psy_chrgr.is_usb_cable_evt_reg && !register_usb_notifier())
+		psy_chrgr.is_usb_cable_evt_reg = true;
+
+	ret = __power_supply_register_charger(psyc->psy, psyc);
+
+	if (ret) {
+		pr_err("%s:Failed to register power_supply_charger\n",
+					__func__);
+		mutex_unlock(&psy_chrgr.evt_lock);
+		return ret;
+	}
+
+	psy_chrgr.psyc_cnt++;
+
+	mutex_unlock(&psy_chrgr.evt_lock);
+
+	power_supply_changed(psyc->psy);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_register_charger);
+
+int power_supply_unregister_charger(struct power_supply_charger *psyc)
+{
+	mutex_lock(&psy_chrgr.evt_lock);
+	flush_charger_context(psyc->psy);
+	psy_chrgr.psyc_cnt--;
+	mutex_unlock(&psy_chrgr.evt_lock);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_unregister_charger);
+
+static int __init power_supply_charger_init(void)
+{
+	mutex_init(&psy_chrgr.evt_lock);
+	init_waitqueue_head(&psy_chrgr.wait_chrg_enable);
+	INIT_LIST_HEAD(&psy_chrgr.chrgr_cache_lst);
+	INIT_LIST_HEAD(&psy_chrgr.batt_cache_lst);
+	INIT_LIST_HEAD(&psy_chrgr.event_queue);
+	spin_lock_init(&psy_chrgr.battid_spinlock);
+	spin_lock_init(&psy_chrgr.event_queue_lock);
+	INIT_WORK(&psy_chrgr.event_work, event_worker);
+
+	if (power_supply_reg_notifier(&nb))
+		pr_err("%s:Failed to register power_supply notifier\n",
+				__func__);
+
+	return 0;
+}
+
+/* init before charger and cable drivers, but after power_supply_core
+*/
+
+fs_initcall(power_supply_charger_init);
diff --git a/drivers/power/power_supply_charger.h b/drivers/power/power_supply_charger.h
new file mode 100644
index 0000000..0e0d05b
--- /dev/null
+++ b/drivers/power/power_supply_charger.h
@@ -0,0 +1,218 @@
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ */
+#include <linux/power_supply.h>
+#include <linux/power/power_supply_charger.h>
+
+extern inline struct power_supply_charger
+		*psy_to_psyc(struct power_supply *psy);
+
+static inline int psyc_set_ps_int_property(struct power_supply_charger *psyc,
+				      enum power_supply_charger_property psp,
+				      int prop_val)
+{
+	union power_supply_propval val;
+
+	val.intval = prop_val;
+	if (psyc)
+		return psyc->set_property(psyc, psp, &val);
+	else
+		return -EINVAL;
+}
+
+static inline int psyc_get_ps_int_property(struct power_supply_charger *psyc,
+				      enum power_supply_charger_property psp)
+{
+	union power_supply_propval val;
+
+	val.intval = 0;
+	if (psyc)
+		psyc->get_property(psyc, psp, &val);
+
+	return val.intval;
+}
+
+
+static inline int psy_prioirty(struct power_supply *psy)
+{
+
+	return psyc_get_ps_int_property(psy_to_psyc(psy),
+				POWER_SUPPLY_CHARGER_PROP_PRIORITY);
+}
+
+static inline int psy_cable_type(struct power_supply *psy)
+{
+	return psyc_get_ps_int_property(psy_to_psyc(psy),
+				POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE);
+}
+
+static inline int psy_throttle_action
+		(struct power_supply *psy, unsigned int state)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	if (psyc)
+		return ((psyc->throttle_states)+state)->throttle_action;
+
+	/* If undetermined state, better disable charger for safety reasons
+	*/
+
+	return PSY_THROTTLE_DISABLE_CHARGER;
+}
+
+static inline int psy_max_throttle_state(struct power_supply *psy)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	if (psyc)
+		return psyc->num_throttle_states;
+
+	return -EINVAL;
+}
+
+static inline int psy_current_throttle_state(struct power_supply *psy)
+{
+	return psy_get_ps_int_property(psy,
+				POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT);
+}
+
+static inline int psy_current_throttle_action(struct power_supply *psy)
+{
+	return psy_throttle_action(psy, psy_current_throttle_state(psy));
+
+}
+
+static inline int psy_throttle_cc_value
+		(struct power_supply *psy, unsigned int state)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	if (psyc)
+		return ((psyc->throttle_states)+state)->throttle_val;
+
+	/* If undetermined state, better set CC as 0
+	*/
+	return 0;
+}
+
+static inline int psy_is_charging_enabled(struct power_supply *psy)
+{
+	return	psyc_get_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING);
+}
+
+static inline int psy_is_charger_enabled(struct power_supply *psy)
+{
+	return	psyc_get_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER);
+}
+
+static inline bool psy_is_supported_cable(struct power_supply *psy,
+		enum psy_charger_cable_type cable_type)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	/* if unable to determine the state, better return cable not supported
+	*/
+	if (!psyc)
+		return false;
+
+	return psy_to_psyc(psy)->supported_cables &&
+		(psy_to_psyc(psy)->supported_cables & cable_type);
+}
+
+static inline int psy_reset_charger_wdt(struct power_supply *psy)
+{
+	return psyc_set_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_RESET_WDT, true);
+}
+
+static inline int psy_enable_charger(struct power_supply *psy)
+{
+	return psyc_set_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER, true);
+}
+
+static inline int psy_enable_charging(struct power_supply *psy)
+{
+	int ret;
+
+	if ((psy_cable_type(psy) != PSY_CHARGER_CABLE_TYPE_NONE) &&
+			!psy_is_charging_enabled(psy)) {
+
+		ret = psy_enable_charger(psy);
+		if (ret)
+			return ret;
+		ret = psyc_set_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING, true);
+		if (ret)
+			return ret;
+	}
+
+	return psy_reset_charger_wdt(psy);
+}
+
+static inline int psy_disable_charging(struct power_supply *psy)
+{
+	return psyc_set_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING, false);
+}
+
+static inline int psy_disable_charger(struct power_supply *psy)
+{
+	psy_disable_charging(psy);
+	return psyc_set_ps_int_property(psy_to_psyc(psy),
+			POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER, false);
+}
+
+static inline int psy_switch_cable(struct power_supply *psy,
+		enum psy_charger_cable_type cable)
+{
+	return	psyc_set_ps_int_property(psy_to_psyc(psy),
+		POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE, cable);
+}
+
+static inline bool psy_is_charging_can_be_enabled(struct power_supply *psy)
+{
+	return (psy_current_throttle_action(psy) !=
+					PSY_THROTTLE_DISABLE_CHARGER) &&
+		(psy_current_throttle_action(psy) !=
+				PSY_THROTTLE_DISABLE_CHARGING);
+}
+
+static inline bool psy_is_charger_can_be_enabled(struct power_supply *psy)
+{
+	return psy_current_throttle_action(psy) !=
+			PSY_THROTTLE_DISABLE_CHARGER;
+}
+
+static inline bool psy_is_cable_active(unsigned long status)
+{
+	if (status == PSY_CHARGER_CABLE_EVENT_DISCONNECT ||
+			status == PSY_CHARGER_CABLE_EVENT_SUSPEND)
+		return false;
+	else
+		return true;
+}
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 2660664..1daa5c2 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -483,6 +483,9 @@ static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
 	ret = psy->set_property(psy,
 		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
 
+	atomic_notifier_call_chain(&power_supply_notifier,
+		PSY_EVENT_THROTTLE, psy);
+
 	return ret;
 }
 
diff --git a/include/linux/power/power_supply_charger.h b/include/linux/power/power_supply_charger.h
new file mode 100644
index 0000000..e871898
--- /dev/null
+++ b/include/linux/power/power_supply_charger.h
@@ -0,0 +1,190 @@
+
+#ifndef __LINUX_POWER_SUPPLY_CHARGER_H__
+#define __LINUX_POWER_SUPPLY_CHARGER_H__
+
+#include <linux/power_supply.h>
+
+#define MAX_CUR_VOLT_SAMPLES 3
+#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)
+
+
+
+/* Define a TTL for some properies to optimize the frequency of
+* algorithm calls. This can be used by properties which will be changed
+* very frequently (eg. current, volatge..)
+*/
+#define PROP_TTL (HZ*10)
+enum psy_charger_cable_event {
+	PSY_CHARGER_CABLE_EVENT_DISCONNECT = 0,
+	PSY_CHARGER_CABLE_EVENT_CONNECT,
+	PSY_CHARGER_CABLE_EVENT_UPDATE,
+	PSY_CHARGER_CABLE_EVENT_RESUME,
+	PSY_CHARGER_CABLE_EVENT_SUSPEND,
+};
+
+enum psy_charger_cable_type {
+	PSY_CHARGER_CABLE_TYPE_NONE = 0,
+	PSY_CHARGER_CABLE_TYPE_USB_SDP = 1 << 0,
+	PSY_CHARGER_CABLE_TYPE_USB_DCP = 1 << 1,
+	PSY_CHARGER_CABLE_TYPE_USB_CDP = 1 << 2,
+	PSY_CHARGER_CABLE_TYPE_USB_ACA = 1 << 3,
+	PSY_CHARGER_CABLE_TYPE_AC = 1 << 4,
+	PSY_CHARGER_CABLE_TYPE_ACA_DOCK = 1 << 5,
+	PSY_CHARGER_CABLE_TYPE_ACA_A = 1 << 6,
+	PSY_CHARGER_CABLE_TYPE_ACA_B = 1 << 7,
+	PSY_CHARGER_CABLE_TYPE_ACA_C = 1 << 8,
+	PSY_CHARGER_CABLE_TYPE_SE1 = 1 << 9,
+	PSY_CHARGER_CABLE_TYPE_MHL = 1 << 10,
+	PSY_CHARGER_CABLE_TYPE_B_DEVICE = 1 << 11,
+};
+
+struct psy_cable_props {
+	enum psy_charger_cable_event	chrg_evt;
+	enum psy_charger_cable_type	chrg_type;
+	unsigned int			ma;	/* input current limit */
+};
+
+#define PSY_CHARGER_CABLE_TYPE_USB \
+	(PSY_CHARGER_CABLE_TYPE_USB_SDP | \
+	PSY_CHARGER_CABLE_TYPE_USB_DCP | \
+	PSY_CHARGER_CABLE_TYPE_USB_CDP | \
+	PSY_CHARGER_CABLE_TYPE_USB_ACA | \
+	PSY_CHARGER_CABLE_TYPE_ACA_DOCK)
+
+enum psy_throttle_action {
+	PSY_THROTTLE_DISABLE_CHARGER = 0,
+	PSY_THROTTLE_DISABLE_CHARGING,
+	PSY_THROTTLE_CC_LIMIT,
+	PSY_THROTTLE_INPUT_LIMIT,
+};
+
+struct psy_throttle_state {
+	enum psy_throttle_action throttle_action;
+	unsigned throttle_val;
+};
+
+enum psy_algo_stat {
+	PSY_ALGO_STAT_UNKNOWN,
+	PSY_ALGO_STAT_NOT_CHARGE,
+	PSY_ALGO_STAT_CHARGE,
+	PSY_ALGO_STAT_FULL,
+	PSY_ALGO_STAT_MAINT,
+};
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
+struct psy_batt_props {
+	struct list_head node;
+	const char *name;
+	long voltage_now;
+	long voltage_now_cache[MAX_CUR_VOLT_SAMPLES];
+	long current_now;
+	long current_now_cache[MAX_CUR_VOLT_SAMPLES];
+	int temperature;
+	long status;
+	unsigned long long tstamp;
+	enum psy_algo_stat algo_stat;
+	int health;
+	int throttle_state;
+};
+
+struct psy_charger_props {
+	struct list_head node;
+	struct power_supply_charger *psyc;
+	const char *name;
+	bool present;
+	bool is_charging;
+	int health;
+	bool online;
+	unsigned long cable;
+	unsigned long tstamp;
+};
+
+struct psy_batt_thresholds {
+	int temp_min;
+	int temp_max;
+	unsigned int iterm;
+};
+
+enum power_supply_charger_property {
+	POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING = 0,
+	POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER,
+	POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE,
+	POWER_SUPPLY_CHARGER_PROP_PRIORITY,
+	POWER_SUPPLY_CHARGER_PROP_RESET_WDT,
+};
+
+struct power_supply_charger {
+	struct power_supply *psy;
+	struct psy_throttle_state *throttle_states;
+	size_t num_throttle_states;
+	unsigned long supported_cables;
+	int (*get_property)(struct power_supply_charger *psyc,
+			    enum power_supply_charger_property psp,
+			    union power_supply_propval *val);
+	int (*set_property)(struct power_supply_charger *psyc,
+			    enum power_supply_charger_property psp,
+			    const union power_supply_propval *val);
+	int (*property_is_writeable)(struct power_supply_charger *psyc,
+				     enum power_supply_charger_property psp);
+};
+
+struct psy_charging_algo {
+	struct list_head node;
+	unsigned int chrg_prof_type;
+	char *name;
+	enum psy_algo_stat (*get_next_cc_cv)(struct psy_batt_props,
+			struct psy_ps_batt_chg_prof, unsigned long *cc,
+			unsigned long *cv);
+	int (*get_batt_thresholds)(struct psy_ps_batt_chg_prof,
+			struct psy_batt_thresholds *bat_thr);
+};
+
+
+/* power_supply_charger functions
+*/
+
+
+#ifdef CONFIG_POWER_SUPPLY_CHARGER
+
+extern int power_supply_register_charger(struct power_supply_charger *psyc);
+extern int power_supply_unregister_charger(struct power_supply_charger *psyc);
+extern int power_supply_register_charging_algo(struct psy_charging_algo *);
+extern int power_supply_unregister_charging_algo(struct psy_charging_algo *);
+extern int psy_get_batt_prop(struct psy_ps_batt_chg_prof *batt_prop);
+extern void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_ps_batt_chg_prof *batt_prop);
+
+#else
+
+static int power_supply_register_charger(struct power_supply_charger *psyc)
+{ return 0; }
+static  int power_supply_unregister_charger(struct power_supply_charger *psyc)
+{ return 0; }
+static int power_supply_register_charging_algo(struct psy_charging_algo *algo)
+{ return 0; }
+static int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
+{ return 0; }
+static inline int psy_get_batt_prop(struct psy_ps_batt_chg_prof *batt_prop)
+{
+	return -ENOMEM;
+}
+static void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_ps_batt_chg_prof *batt_prop) { }
+#endif
+
+
+#endif
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 4dbb543..0b91e42 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -165,6 +165,9 @@ enum power_supply_type {
 
 enum power_supply_notifier_events {
 	PSY_EVENT_PROP_CHANGED,
+	PSY_EVENT_BATTERY,
+	PSY_EVENT_THROTTLE,
+	PSY_EVENT_CABLE,
 };
 
 union power_supply_propval {
@@ -324,4 +327,159 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	return 0;
 }
 
+static inline int psy_set_ps_int_property(struct power_supply *psy,
+				      enum power_supply_property psp,
+				      int prop_val)
+{
+	union power_supply_propval val;
+
+	val.intval = prop_val;
+	return psy->set_property(psy, psp, &val);
+}
+
+static inline int psy_get_ps_int_property(struct power_supply *psy,
+				      enum power_supply_property psp)
+{
+	union power_supply_propval val;
+
+	val.intval = 0;
+	psy->get_property(psy, psp, &val);
+	return val.intval;
+}
+
+
+#define PSY_HEALTH(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_HEALTH)
+#define PSY_CV(psy) \
+		psy_get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE)
+#define PSY_CC(psy) \
+		psy_get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT)
+#define PSY_INLMT(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT)
+#define PSY_MAX_CC(psy) \
+		psy_get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX)
+#define PSY_MAX_CV(psy) \
+		psy_get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX)
+#define PSY_VOLTAGE_NOW(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
+#define PSY_VOLTAGE_OCV(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_OCV)
+#define PSY_CURRENT_NOW(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
+#define PSY_STATUS(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
+#define PSY_TEMPERATURE(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
+#define PSY_BATTERY_TYPE(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
+#define PSY_ONLINE(psy) \
+		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE)
+
+
+static inline int psy_set_present(struct power_supply *psy, int present)
+{
+	return	psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_PRESENT, present);
+}
+
+static inline int psy_set_iterm(struct power_supply *psy, int iterm)
+{
+	return	psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_CHARGE_TERM_CUR, iterm);
+}
+
+static inline int psy_set_max_temp(struct power_supply *psy, int temp)
+{
+	return	psy_set_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP_MAX, temp);
+}
+
+static inline int psy_set_min_temp(struct power_supply *psy, int temp)
+{
+	return	psy_set_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP_MIN, temp);
+}
+
+static inline int psy_is_online(struct power_supply *psy)
+{
+	return	psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE);
+}
+
+static inline int psy_is_present(struct power_supply *psy)
+{
+	return	psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_PRESENT);
+}
+
+static inline bool psy_is_health_good(struct power_supply *psy)
+{
+	return PSY_HEALTH(psy) == POWER_SUPPLY_HEALTH_GOOD;
+}
+
+static inline int psy_set_cc(struct power_supply *psy, int cc)
+{
+	return	psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT, cc);
+}
+
+static inline int psy_set_cv(struct power_supply *psy, int cc)
+{
+	return	psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE, cc);
+}
+
+static inline int psy_set_inlmt(struct power_supply *psy, int inlmt)
+{
+	return	psy_set_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT, inlmt);
+}
+
+static inline int psy_set_max_cc(struct power_supply *psy, int max_cc)
+{
+	return psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX, max_cc);
+}
+
+static inline int psy_set_max_cv(struct power_supply *psy, int max_cv)
+{
+	return psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX, max_cv);
+}
+
+static inline bool psy_is_battery(struct power_supply *psy)
+{
+	return psy->type == POWER_SUPPLY_TYPE_BATTERY;
+}
+
+static inline bool psy_is_charger(struct power_supply *psy)
+{
+	return psy->type == POWER_SUPPLY_TYPE_USB ||
+			psy->type == POWER_SUPPLY_TYPE_USB_CDP ||
+			psy->type == POWER_SUPPLY_TYPE_USB_DCP ||
+			psy->type == POWER_SUPPLY_TYPE_USB_ACA;
+}
+
+static inline bool is_online(struct power_supply *psy)
+{
+	return psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE) == 1;
+}
+
+static inline bool is_present(struct power_supply *psy)
+{
+	return psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_PRESENT) == 1;
+}
+
+
+static inline void psy_set_battery_status(struct power_supply *psy, int status)
+{
+	if (PSY_STATUS(psy) != status)
+		psy_set_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS, status);
+}
+
+static inline void psy_set_charger_online(struct power_supply *psy, int online)
+{
+	if (PSY_ONLINE(psy) != online)
+		psy_set_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE, online);
+}
+
 #endif /* __LINUX_POWER_SUPPLY_H__ */
-- 
1.7.9.5

