Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaF3J4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:56:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:63303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbaF3J4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,574,1400050800"; 
   d="scan'208";a="555187584"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Date: Mon, 30 Jun 2014 15:25:53 +0530
Message-Id: <1404122155-12369-3-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Supply charging driver connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
thermal and battery communication subsystems (1wire). With this the charging is
handled in a generic way.

The driver makes use of different new features - Battery Identification
interfaces, pluggable charging algorithms, charger cable arbitrations etc.
The patch also introduces generic interface for charger cable notifications.
Charger cable events and capabilities can be notified using the generic
power_supply_notifier chain.

Overall this driver removes the charging logic out of the charger chip driver
and the charger chip driver can just listen to the request from the power
supply charging driver to set the charger properties. This can be implemented
by exposing get_property and set property callbacks.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 Documentation/power/power_supply_charger.txt |  350 +++++++++
 drivers/power/Kconfig                        |    8 +
 drivers/power/Makefile                       |    1 +
 drivers/power/power_supply_charger.c         | 1016 ++++++++++++++++++++++++++
 drivers/power/power_supply_charger.h         |  226 ++++++
 drivers/power/power_supply_core.c            |    3 +
 include/linux/power/power_supply_charger.h   |  307 ++++++++
 include/linux/power_supply.h                 |  161 ++++
 8 files changed, 2072 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

diff --git a/Documentation/power/power_supply_charger.txt b/Documentation/power/power_supply_charger.txt
new file mode 100644
index 0000000..e81754b
--- /dev/null
+++ b/Documentation/power/power_supply_charger.txt
@@ -0,0 +1,350 @@
+1. Introduction
+===============
+
+The Power Supply charging driver connects multiple subsystems
+to do charging in a generic way. The subsystems involves power_supply,
+thermal and battery communication subsystems (1wire). With this the charging is
+handled in a generic way by plugging the driver to power supply subsystem.
+
+The driver introduces different new features - Battery Identification
+interfaces, pluggable charging algorithms, charger cable arbitrations etc.
+
+In existing driver implementations the charging is done based on the static
+battery characteristics. This is done at the boot time by passing the battery
+properties (max_voltage, capacity) etc. as a platform data to the
+charger/battery driver. But new generation high volt batteries needs to be
+identified dynamically to do charging in a safe manner. The batteries are
+coming with different communication protocols. It become necessary to
+communicate with battery and identify it's charging profiles before setup
+charging.
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
+cables at a time (USB/AC/Wireless etc.). The arbitration logic inside the
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
+supply charging driver to set the charger properties. This can be implemented
+by exposing get_property and set property callbacks.
+
+2. Reading Battery charging profile
+===================================
+
+Power Supply charging driver expose APIs to retrieve battery profile of a
+battery. The battery profile can be read by battery identification driver which
+may be 1wire/I2C/SFI driver. Battery identification driver can register the
+battery profile with the power supply charging driver using the API
+psy_battery_prop_changed(). The driver also exposes API
+psy_get_battery_prop() to retrieve the battery profile which can be
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
+power_supply_register(device, &psy_usb);
+
+/* Register with power supply charging driver */
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
+power_supply_register_charger(&chip->psy_usb, &chip->psyc_usb);
+
+3.2 Properties exposed to power supply class driver
+==================================================
+* POWER_SUPPLY_PROP_ONLINE
+	* Read access using get_property_function
+		* Returns the online property set using the set_property
+		  function
+	* Write access using set_property function
+		* Expose the value through get_property_function.
+* POWER_SUPPLY_PROP_PRESENT
+	* Read access using get_property_function
+		* Returns the present property set using the set_property
+		  function
+	* Write access using set_property function
+		* Expose the value through get_property_function.
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
+			  charging parameters accordingly.
+* POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX
+	* Read access using get property
+		* Returns the maximum charge control limit
+* POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT
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
+* POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT
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
+		* Action: Configure safety charging registers if any. If no h/w
+			  actions expected, report the value on the
+			  get_property interface.
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
+		  charging. Writing 0, disables charging, writing 1 enables
+		  charging
+* POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER
+	* Write access using set_property
+		* Enable/Disable charger. Charger doesn't supply power to
+		  platform or battery and battery start to discharge.
+		* Action: Configure charger chip registers to enable/disable
+		  charger. Writing 0 disables charger, writing 1 enables
+		  charger
+* POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE
+	* Write access using set_property
+		* Set charger cable type.
+		* Action: Report power supply type based on cable type
+* POWER_SUPPLY_CHARGER_PROP_RESET_WDT
+	* Write access using set_property
+		* Reset charger Watch Dog Timer
+		* Action: Reset charger Watch Dog Timer.
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
+configuration structure has the following format:
+
+struct psy_throttle_state {
+	enum psy_throttle_action throttle_action;
+	unsigned throttle_val;
+};
+
+enum psy_throttle_action {
+	/* Disable charger, charger doesn't supply VSYS */
+	PSY_THROTTLE_DISABLE_CHARGER = 0,
+
+	/* Disable charging, charger would supply VSYS */
+	PSY_THROTTLE_DISABLE_CHARGING,
+
+	/* Throttle charge current */
+	PSY_THROTTLE_CC_LIMIT,
+
+	/* Throttle input current limit */
+	PSY_THROTTLE_INPUT_LIMIT,
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
+	/*
+	* Level 2: Disable charging: Stop charging, charger supply power to
+	* platform.
+	*/
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
+charging.
+
+5. Registering new charging algorithm
+===================================
+Power supply charging driver supports pluggable charging algorithms. Charging
+algorithms processes charging profile and/or applies different logic (pulse
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
+	pse_algo.get_batt_thresholds = my_algo_get_bat_thresholds;
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
index 0196acf..f679f82 100644
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
+	  just need to abstract the charger hardware.
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
index 0000000..1993c8c
--- /dev/null
+++ b/drivers/power/power_supply_charger.c
@@ -0,0 +1,1016 @@
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
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/power_supply.h>
+#include <linux/power/power_supply_charger.h>
+#include <linux/slab.h>
+#include <linux/thermal.h>
+#include <linux/types.h>
+#include <linux/usb/otg.h>
+#include "power_supply_charger.h"
+
+
+#define MAX_CHARGER_COUNT 5
+#define MAX_CABLE_COUNT 15
+
+static LIST_HEAD(algo_list);
+
+struct psy_event_node {
+	struct list_head node;
+	unsigned long event;
+	struct psy_cable_props cap;
+	struct power_supply *psy;
+	struct psy_batt_chrg_prof batt_property;
+};
+
+struct charger_cable {
+	struct psy_cable_props cable_props;
+	unsigned long psy_cable_type;
+};
+
+struct psy_charger_drv_context {
+	bool is_usb_cable_evt_reg;
+	int psyc_cnt;
+	int batt_status;
+	/* cache battery and charger properties */
+	struct mutex event_lock;
+	struct list_head event_queue;
+	struct psy_batt_chrg_prof batt_property;
+	struct work_struct event_work;
+	struct charger_cable cable_list[MAX_CABLE_COUNT];
+	wait_queue_head_t wait_chrg_enable;
+	spinlock_t event_queue_lock;
+};
+
+DEFINE_MUTEX(battid_lock);
+
+static struct psy_charger_drv_context psy_chrgr;
+static struct usb_phy *otg_xceiver;
+static int handle_event_notification(struct notifier_block *nb,
+				   unsigned long event, void *data);
+static struct notifier_block nb = {
+		   .notifier_call = handle_event_notification,
+		};
+static void configure_chrgr_source(struct charger_cable *cable_lst);
+static struct psy_charging_algo *power_supply_get_charging_algo
+		(struct power_supply *, struct psy_batt_chrg_prof *);
+static void __power_supply_trigger_charging_handler(struct power_supply *psy);
+static void power_supply_trigger_charging_handler(struct power_supply *psy);
+static void trigger_algo_psy_class(void);
+static int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state);
+
+static inline bool psy_is_battery_prop_changed(struct psy_batt_props *bat_prop,
+		struct psy_batt_props *bat_cache)
+{
+	if (!bat_cache)
+		return true;
+
+	/* return true if temperature, health or throttling state changed */
+	if ((bat_cache->temperature != bat_prop->temperature) ||
+		(bat_cache->health != bat_prop->health) ||
+		(bat_cache->throttle_state != bat_prop->throttle_state))
+		return true;
+
+	/* return true if voltage or current changed not within TTL limit */
+	if (time_after64(bat_prop->tstamp, bat_cache->tstamp + PROP_TTL) &&
+		(bat_cache->current_now != bat_prop->current_now ||
+		bat_cache->voltage_now != bat_prop->voltage_now))
+		return true;
+
+	return false;
+}
+
+static inline bool psy_is_charger_prop_changed(struct psy_charger_props *prop,
+		struct psy_charger_props *cache_prop)
+{
+	/* if online/prsent/health/is_charging is changed, then return true */
+	if (!cache_prop)
+		return true;
+
+	if (cache_prop->online != prop->online ||
+		cache_prop->present != prop->present ||
+		cache_prop->is_charging != prop->is_charging ||
+		cache_prop->health != prop->health)
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
+	chrgr_prop->online = psy_is_online(psy);
+	chrgr_prop->present = psy_is_present(psy);
+	chrgr_prop->cable = psy_cable_type(psy);
+	chrgr_prop->health = PSY_HEALTH(psy);
+	chrgr_prop->tstamp = get_jiffies_64();
+}
+
+static void dump_charger_props(struct psy_charger_props *props)
+{
+	if (props)
+		pr_debug("%s: present=%d is_charging=%d health=%d online=%d cable=%ld tstamp=%ld\n",
+			__func__, props->present, props->is_charging,
+			props->health, props->online, props->cable,
+			props->tstamp);
+}
+
+static void dump_battery_props(struct psy_batt_props *props)
+{
+	if (props)
+		pr_debug("%s voltage_now=%ld current_now=%ld temperature=%d status=%ld health=%d tstamp=%lld",
+			__func__, props->voltage_now, props->current_now,
+			props->temperature, props->status, props->health,
+			props->tstamp);
+}
+
+static int  __update_supplied_psy(struct device *dev, void *data)
+{
+	struct psy_charger_context *charger_context;
+	struct psy_batt_context *batt_context;
+	struct power_supply *psb, *psy;
+	int i;
+
+	psy = dev_get_drvdata(dev);
+
+	if (!psy || !psy_is_charger(psy) || !psy->data)
+		return 0;
+
+	charger_context = psy->data;
+	charger_context->num_supplied_to_psy = 0;
+
+	for (i = 0; i < psy->num_supplicants; i++) {
+		psb = power_supply_get_by_name(psy->supplied_to[i]);
+		if (!psb)
+			continue;
+
+		if (!psb->data)
+			psb->data = devm_kzalloc(psb->dev,
+				sizeof(struct psy_batt_context), GFP_KERNEL);
+
+		batt_context = psb->data;
+		batt_context->supplied_by_psy
+				[batt_context->num_supplied_by_psy++] = psy;
+		charger_context->supplied_to_psy
+				[charger_context->num_supplied_to_psy++] = psb;
+	}
+
+	return 0;
+}
+
+static void update_supplied_psy(void)
+{
+
+	class_for_each_device(power_supply_class, NULL, NULL,
+			__update_supplied_psy);
+
+}
+
+static inline bool is_chrgr_prop_changed(struct power_supply *psy)
+{
+	struct psy_charger_context *charger_context;
+	struct psy_charger_props new_charger_props;
+
+	if (!psy->data) {
+		pr_err("%s:%d Invalid charger context\n", __func__, __LINE__);
+		return false;
+	}
+
+	charger_context = psy->data;
+
+	get_cur_chrgr_prop(psy, &new_charger_props);
+
+	dump_charger_props(&charger_context->charger_props);
+	dump_charger_props(&new_charger_props);
+
+	if (!psy_is_charger_prop_changed(&new_charger_props,
+				&charger_context->charger_props))
+		return false;
+
+	charger_context->charger_props =  new_charger_props;
+
+	return true;
+}
+
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
+
+static void psy_update_batt_context(struct psy_batt_context *batt_context,
+	struct psy_batt_props *new_bat_props)
+{
+	if (time_after64(new_bat_props->tstamp,
+		(batt_context->batt_props.tstamp + DEF_CUR_VOLT_SAMPLE_JIFF))) {
+
+		cache_successive_samples(batt_context->voltage_now_cache,
+						new_bat_props->voltage_now);
+		cache_successive_samples(batt_context->current_now_cache,
+						new_bat_props->current_now);
+	}
+
+	batt_context->batt_props = *new_bat_props;
+}
+
+static inline void get_cur_bat_prop(struct power_supply *psy,
+				    struct psy_batt_props *bat_prop)
+{
+	bat_prop->voltage_now = PSY_VOLTAGE_OCV(psy) / 1000;
+	bat_prop->current_now = PSY_CURRENT_NOW(psy) / 1000;
+	bat_prop->temperature = PSY_TEMPERATURE(psy) / 10;
+	bat_prop->status = PSY_STATUS(psy);
+	bat_prop->health = PSY_HEALTH(psy);
+	bat_prop->throttle_state = psy_current_throttle_state(psy);
+	bat_prop->tstamp = get_jiffies_64();
+}
+
+static inline bool is_batt_prop_changed(struct power_supply *psy)
+{
+	struct psy_batt_context *batt_context;
+	struct psy_batt_props new_batt_props;
+
+	if (!psy->data)
+		update_supplied_psy();
+
+	batt_context =  psy->data;
+	get_cur_bat_prop(psy, &new_batt_props);
+	dump_battery_props(&batt_context->batt_props);
+	dump_battery_props(&new_batt_props);
+
+	if (!psy_is_battery_prop_changed(&new_batt_props,
+					&batt_context->batt_props))
+		return false;
+
+	psy_update_batt_context(batt_context, &new_batt_props);
+
+	return true;
+}
+
+static inline bool is_supplied_to_has_ext_pwr_changed(struct power_supply *psy)
+{
+	int cnt;
+	struct power_supply *psb;
+	struct psy_charger_context *charger_context;
+
+	charger_context = psy->data;
+	cnt = charger_context->num_supplied_to_psy;
+
+	while (cnt--) {
+		psb = charger_context->supplied_to_psy[cnt];
+		if (!psb->external_power_changed)
+			return false;
+	}
+
+	return true;
+}
+
+static inline bool is_supplied_by_changed(struct power_supply *psy)
+{
+	int cnt;
+	struct power_supply *psc;
+	struct psy_batt_context *batt_context;
+
+	batt_context = psy->data;
+	cnt = batt_context->num_supplied_by_psy;
+
+	while (cnt--) {
+		psc = batt_context->supplied_by_psy[cnt];
+		if ((psy_is_charger(psc)) && is_chrgr_prop_changed(psc))
+			return true;
+	}
+
+	return false;
+}
+
+static int process_cable_props(struct psy_cable_props *cap)
+{
+	struct charger_cable *cable = NULL;
+	unsigned off;
+
+	pr_info("%s: event:%d, type:%lu, current_mA:%d\n",
+		__func__, cap->chrg_evt, cap->chrg_type, cap->current_mA);
+
+	off = ffs(cap->chrg_type);
+
+	if (!off || off >= ARRAY_SIZE(psy_chrgr.cable_list)) {
+		pr_err("%s:%d Invalid cable type\n", __FILE__, __LINE__);
+		return -EINVAL;
+	}
+
+	cable = &psy_chrgr.cable_list[off - 1];
+
+	if (cable->psy_cable_type == PSY_CHARGER_CABLE_TYPE_NONE)
+		cable->psy_cable_type = cap->chrg_type;
+
+	memcpy((void *)&cable->cable_props, (void *)cap,
+			sizeof(cable->cable_props));
+
+	configure_chrgr_source(psy_chrgr.cable_list);
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
+		mutex_lock(&psy_chrgr.event_lock);
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
+			/* TODO: Cache battery profile */
+			break;
+		default:
+			pr_err("%s: Invalid event\n", __func__);
+			break;
+		}
+
+		mutex_unlock(&psy_chrgr.event_lock);
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
+			sizeof(struct psy_batt_chrg_prof));
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
+	/*
+	* trigger charging algorithm if battery or
+	* charger properties are changed. Also no need to
+	* invoke algorithm for power_supply_changed from
+	* charger, if all supplied_to has the ext_port_changed defined.
+	* On invoking the ext_port_changed the supplied to can send
+	* power_supplied_changed event.
+	*/
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
+static int get_battery_status(struct power_supply *psy)
+{
+	int status;
+	struct power_supply *psc;
+	struct psy_batt_context *batt_context;
+	int cnt;
+
+	if (!psy_is_battery(psy) || (!psy->data))
+		return POWER_SUPPLY_STATUS_UNKNOWN;
+
+	batt_context = psy->data;
+	status = POWER_SUPPLY_STATUS_DISCHARGING;
+	cnt = batt_context->num_supplied_by_psy;
+
+	while (cnt--) {
+		psc = batt_context->supplied_by_psy[cnt];
+
+		if (psy_is_present(psc))
+			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+
+		if (!(psy_is_charging_can_be_enabled(psc)) ||
+			(!psy_is_health_good(psy)) ||
+				(!psy_is_health_good(psc)))
+			continue;
+
+		if ((batt_context->algo_stat == PSY_ALGO_STAT_FULL) ||
+			(batt_context->algo_stat == PSY_ALGO_STAT_MAINT))
+				status = POWER_SUPPLY_STATUS_FULL;
+		else if (psy_is_charging_enabled(psc))
+				status = POWER_SUPPLY_STATUS_CHARGING;
+	}
+
+	pr_debug("%s: Set status=%d for %s\n", __func__, status, psy->name);
+
+	return status;
+}
+
+static void update_charger_online(struct power_supply *psy)
+{
+	int online;
+	struct psy_charger_context *charger_context;
+
+	online = psy_is_charger_enabled(psy) ? 1 : 0;
+	psy_set_charger_online(psy, online);
+	charger_context = psy->data;
+	charger_context->charger_props.online = online;
+}
+
+static void update_battery_status(struct power_supply *psy)
+{
+	int status;
+	struct psy_batt_context *batt_context;
+
+	status = get_battery_status(psy);
+	psy_set_battery_status(psy, status);
+
+	batt_context = psy->data;
+	batt_context->batt_props.status = status;
+}
+
+static void update_sysfs(struct power_supply *psy)
+{
+	int cnt;
+	struct power_supply *psb;
+	struct power_supply *psc;
+	struct psy_batt_context *batt_context;
+	struct psy_charger_context *charger_context;
+
+	if (psy_is_battery(psy)) {
+
+		update_battery_status(psy);
+
+		batt_context = psy->data;
+		cnt = batt_context->num_supplied_by_psy;
+
+		while (cnt--) {
+			psc = batt_context->supplied_by_psy[cnt];
+			update_charger_online(psc);
+		}
+		return;
+	}
+
+	charger_context =  psy->data;
+	cnt = charger_context->num_supplied_to_psy;
+
+	while (cnt--) {
+		psb = charger_context->supplied_to_psy[cnt];
+		if (psb && psy_is_battery(psb) && psy_is_present(psb))
+			update_battery_status(psb);
+	}
+
+	update_charger_online(psy);
+
+}
+
+static int trigger_algo(struct power_supply *psy)
+{
+	unsigned long cc = 0, cv = 0, cc_min;
+	struct psy_batt_context *batt_context;
+	struct psy_charging_algo *algo;
+	struct psy_batt_chrg_prof chrg_profile;
+	struct power_supply *psc;
+	int cnt;
+
+	if (!psy_is_battery(psy))
+		return 0;
+
+	if (psy_get_battery_prop(&chrg_profile)) {
+		pr_err("%s:Battery profile missing!!\n", __FILE__);
+		return -EINVAL;
+	}
+
+	batt_context = psy->data;
+
+	algo = power_supply_get_charging_algo(psy, &chrg_profile);
+	if (!algo) {
+		pr_err("%s:Charging algo not found!!\n", __FILE__);
+		return -EINVAL;
+	}
+
+	batt_context->algo_stat = algo->get_next_cc_cv
+			(batt_context, chrg_profile, &cc, &cv);
+
+	pr_info("%s:Algo_status:%d\n", __func__, batt_context->algo_stat);
+
+	if (!cc || !cv)
+		return -ENODATA;
+
+	/*
+	* CC needs to be updated for all chargers which are supplying
+	* power to this battery to ensure that the sum of CCs of all
+	* chargers are never more than the CC selected by the algo.
+	* The CC is set based on the charger priority.
+	*/
+
+	cnt = batt_context->num_supplied_by_psy;
+
+	while (cnt--) {
+		psc = batt_context->supplied_by_psy[cnt];
+		if (!psy_is_present(psc))
+			continue;
+
+		cc_min = min_t(unsigned long, PSY_MAX_CC(psc), cc);
+		if (cc_min < 0)
+			cc_min = 0;
+		cc -= cc_min;
+		psy_set_cc(psc, cc_min);
+		psy_set_cv(psc, cv);
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
+static inline void enable_supplied_by_charging(struct power_supply *psy,
+					bool is_enable)
+{
+	struct power_supply *psc;
+	struct psy_batt_context *batt_context;
+	int cnt;
+
+	if (!psy_is_battery(psy))
+		return;
+	/*
+	* Get list of chargers supplying power to this battery and
+	* disable charging for all chargers
+	*/
+	batt_context  = psy->data;
+	cnt = batt_context->num_supplied_by_psy;
+
+	while (cnt--) {
+		psc = batt_context->supplied_by_psy[cnt];
+		if (!psy_is_present(psc))
+			continue;
+		if (is_enable && psy_is_charging_can_be_enabled(psc)) {
+			psy_enable_charging(psc);
+			wait_for_charging_enabled(psc);
+
+		} else {
+			psy_disable_charging(psc);
+		}
+	}
+}
+
+static void __power_supply_trigger_charging_handler(struct power_supply *psy)
+{
+	int cnt;
+	struct power_supply *psb = NULL;
+	struct psy_charger_context *charger_context;
+
+	if (!is_trigger_charging_algo(psy))
+		return;
+
+	if (psy_is_battery(psy)) {
+
+		enable_supplied_by_charging(psy, !trigger_algo(psy));
+		goto update_sysfs;
+
+	}
+
+	charger_context = psy->data;
+	cnt = charger_context->num_supplied_to_psy;
+
+	while (cnt--) {
+		psb = charger_context->supplied_to_psy[cnt];
+		if (psy_is_battery(psb) && psy_is_present(psb)) {
+			if (trigger_algo(psb)) {
+				psy_disable_charging(psy);
+				break;
+			} else if (psy_is_charging_can_be_enabled(psy)) {
+				psy_enable_charging(psy);
+				wait_for_charging_enabled(psy);
+			}
+		}
+	}
+
+update_sysfs:
+	update_sysfs(psy);
+	power_supply_changed(psy);
+
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
+	struct psy_batt_chrg_prof chrg_profile;
+
+	/* FIXME: Get iterm only for supplied_to arguments*/
+	if (psy_get_battery_prop(&chrg_profile)) {
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
+	struct charger_cable *cable, *max_mA_cable = NULL;
+	struct charger_cable *cable_lst = (struct charger_cable *)data;
+	struct psy_batt_thresholds bat_thresh;
+	unsigned int max_mA = 0;
+	int i;
+
+	if (!psy_is_charger(psy))
+		return 0;
+
+	/* get cable with maximum capability */
+	for (i = 0; i < ARRAY_SIZE(psy_chrgr.cable_list); ++i) {
+		cable = cable_lst + i;
+		if ((!psy_is_cable_active(cable->cable_props.chrg_evt)) ||
+		    (!psy_is_supported_cable(psy, cable->psy_cable_type)))
+			continue;
+
+		if (cable->cable_props.current_mA > max_mA) {
+			max_mA_cable = cable;
+			max_mA = cable->cable_props.current_mA;
+		}
+	}
+
+	/* no cable connected. disable charging */
+	if (!max_mA_cable) {
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
+
+		update_sysfs(psy);
+		psy_switch_cable(psy, PSY_CHARGER_CABLE_TYPE_NONE);
+
+		power_supply_changed(psy);
+		return 0;
+	}
+
+	/*
+	* cable type changed.New cable connected or existing cable
+	* capabilities changed.switch cable and enable charger and charging
+	*/
+	psy_set_present(psy, 1);
+
+	if (psy_cable_type(psy) != max_mA_cable->psy_cable_type)
+		psy_switch_cable(psy, max_mA_cable->psy_cable_type);
+
+	if (psy_is_charger_can_be_enabled(psy)) {
+		memset(&bat_thresh, 0, sizeof(bat_thresh));
+		psy_enable_charger(psy);
+
+		update_charger_online(psy);
+
+		psy_set_inlmt(psy, max_mA_cable->cable_props.current_mA);
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
+	configure_chrgr_source(psy_chrgr.cable_list);
+	return 0;
+}
+
+int power_supply_register_charging_algo(struct psy_charging_algo *algo)
+{
+	list_add_tail(&algo->node, &algo_list);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_register_charging_algo);
+
+int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
+{
+	struct psy_charging_algo *algo_l, *tmp;
+
+	list_for_each_entry_safe(algo_l, tmp, &algo_list, node) {
+		if (algo_l == algo) {
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
+static struct psy_charging_algo *power_supply_get_charging_algo
+	(struct power_supply *psy, struct psy_batt_chrg_prof *batt_prof)
+{
+
+	return get_charging_algo_by_type(batt_prof->chrg_prof_type);
+
+}
+
+/**
+ * psy_battery_prop_changed - Update properties when  battery connection status
+ *                        changes
+ * @battery_conn_stat : The current connection status of battery
+ * @batt_prop : Address of the psy_batt_chrg_prof structure with the updated
+ *              values passed from the calling function
+ *
+ * Whenever the battery connection status changes this function will be called
+ * to indicate a change in the status and to update the status and value of
+ * properties
+ */
+void psy_battery_prop_changed(int battery_conn_stat,
+			struct psy_batt_chrg_prof *batt_prop)
+{
+
+	mutex_lock(&battid_lock);
+	psy_chrgr.batt_property = *batt_prop;
+	psy_chrgr.batt_status = battery_conn_stat;
+	mutex_unlock(&battid_lock);
+
+	atomic_notifier_call_chain(&power_supply_notifier,
+			PSY_EVENT_BATTERY, &psy_chrgr.batt_property);
+}
+EXPORT_SYMBOL_GPL(psy_battery_prop_changed);
+
+/**
+ * psy_get_battery_prop - Get the battery connection status and updated properties
+ * @batt_prop : battery properties structure copied to this address
+ */
+int psy_get_battery_prop(struct psy_batt_chrg_prof *batt_prop)
+{
+	int ret = 0;
+
+	mutex_lock(&battid_lock);
+
+	if (psy_chrgr.batt_status != POWER_SUPPLY_BATTERY_INSERTED)
+		ret = -ENODATA;
+	else
+		*batt_prop = psy_chrgr.batt_property;
+
+	mutex_unlock(&battid_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psy_get_battery_prop);
+
+
+int power_supply_register_charger(struct power_supply *psy,
+		struct power_supply_charger *psyc)
+{
+	struct psy_charger_context *charger_context;
+
+
+	if (!psy || !psyc->get_property || !psyc->set_property || psy->data) {
+		pr_err("%s:Failed to register power_supply_charger\n",
+					__func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&psy_chrgr.event_lock);
+
+	if (!psy_chrgr.is_usb_cable_evt_reg && !register_usb_notifier())
+		psy_chrgr.is_usb_cable_evt_reg = true;
+
+	if (psy->data == NULL)
+		psy->data = devm_kzalloc(psy->dev,
+			sizeof(struct psy_charger_context), GFP_KERNEL);
+
+	charger_context =  psy->data;
+	charger_context->psyc = psyc;
+	psyc->psy = psy;
+	psy_chrgr.psyc_cnt++;
+	update_supplied_psy();
+
+	mutex_unlock(&psy_chrgr.event_lock);
+	power_supply_trigger_charging_handler(psy);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_register_charger);
+
+int power_supply_unregister_charger(struct power_supply_charger *psyc)
+{
+	mutex_lock(&psy_chrgr.event_lock);
+	update_supplied_psy();
+	psyc->psy->data = NULL;
+	psy_chrgr.psyc_cnt--;
+	mutex_unlock(&psy_chrgr.event_lock);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_unregister_charger);
+
+static int __init power_supply_charger_init(void)
+{
+	mutex_init(&psy_chrgr.event_lock);
+	init_waitqueue_head(&psy_chrgr.wait_chrg_enable);
+	INIT_LIST_HEAD(&psy_chrgr.event_queue);
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
+/*
+*  init before charger and cable drivers, but after power_supply_core
+*/
+
+fs_initcall(power_supply_charger_init);
diff --git a/drivers/power/power_supply_charger.h b/drivers/power/power_supply_charger.h
new file mode 100644
index 0000000..665ab7b
--- /dev/null
+++ b/drivers/power/power_supply_charger.h
@@ -0,0 +1,226 @@
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
+static inline struct power_supply_charger
+		*psy_to_psyc(struct power_supply *psy)
+{
+	struct psy_charger_context *charger_context;
+
+	if (!psy_is_charger(psy))
+		return NULL;
+	charger_context = (struct psy_charger_context *) psy->data;
+	return charger_context->psyc;
+}
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
+	/* If undetermined state, better disable charger for safety reasons */
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
+static inline int psy_throttle_cc_value(struct power_supply *psy,
+			unsigned int state)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	if (psyc)
+		return ((psyc->throttle_states)+state)->throttle_val;
+
+	/* If undetermined state, better set CC as 0 */
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
+		unsigned long cable_type)
+{
+	struct power_supply_charger *psyc;
+
+	psyc = psy_to_psyc(psy);
+
+	/*
+	*  if unable to determine the state, better return cable not supported
+	*/
+
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
+		unsigned long cable)
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
index 0000000..2b59817
--- /dev/null
+++ b/include/linux/power/power_supply_charger.h
@@ -0,0 +1,307 @@
+
+#ifndef __LINUX_POWER_SUPPLY_CHARGER_H__
+#define __LINUX_POWER_SUPPLY_CHARGER_H__
+
+#include <linux/power_supply.h>
+
+#define MAX_CUR_VOLT_SAMPLES 3
+#define DEF_CUR_VOLT_SAMPLE_PERIOD 30000
+#define DEF_CUR_VOLT_SAMPLE_JIFF msecs_to_jiffies(DEF_CUR_VOLT_SAMPLE_PERIOD)
+
+/*
+* Define a TTL for some properties to optimize the frequency of
+* algorithm calls. This can be used by properties which will be changed
+* very frequently (e.g. Current, Voltage..)
+*/
+#define PROP_TTL_PERIOD 10000
+#define PROP_TTL msecs_to_jiffies(PROP_TTL_PERIOD)
+
+/* Support maximum 2 charger drivers and 2 battery drivers simultaneously */
+#define MAX_BATTERY_NUMBER 2
+#define MAX_CHARGER_NUMBER 2
+#define PSY_CHRGR_MAX_SUPPLIED_TO MAX_BATTERY_NUMBER
+#define PSY_CHRGR_MAX_SUPPLIED_BY MAX_CHARGER_NUMBER
+
+enum psy_charger_cable_event {
+	PSY_CHARGER_CABLE_EVENT_DISCONNECT = 0,
+	PSY_CHARGER_CABLE_EVENT_CONNECT,
+	PSY_CHARGER_CABLE_EVENT_UPDATE,
+	PSY_CHARGER_CABLE_EVENT_RESUME,
+	PSY_CHARGER_CABLE_EVENT_SUSPEND,
+};
+
+#define PSY_CHARGER_CABLE_TYPE_NONE 0
+#define	PSY_CHARGER_CABLE_TYPE_USB_SDP BIT(0)
+#define	PSY_CHARGER_CABLE_TYPE_USB_DCP BIT(1)
+#define	PSY_CHARGER_CABLE_TYPE_USB_CDP BIT(2)
+#define	PSY_CHARGER_CABLE_TYPE_USB_ACA BIT(3)
+#define	PSY_CHARGER_CABLE_TYPE_AC BIT(4)
+#define	PSY_CHARGER_CABLE_TYPE_ACA_DOCK BIT(5)
+#define	PSY_CHARGER_CABLE_TYPE_ACA_A BIT(6)
+#define	PSY_CHARGER_CABLE_TYPE_ACA_B BIT(7)
+#define	PSY_CHARGER_CABLE_TYPE_ACA_C BIT(8)
+#define	PSY_CHARGER_CABLE_TYPE_SE1 BIT(9)
+#define	PSY_CHARGER_CABLE_TYPE_MHL BIT(10)
+
+/**
+ * struct osy_cable_props: charger cable properties structure
+ * @chrg_evt: charger cable event
+ * @chrg_type: charger cable type
+ * @current_mA: current supplied by the cable in mA
+ *
+ * cable properties structure is populated by the cable provider drivers after
+ * detecting the cable type and capabilities. The structure is then passed to
+ * power supply class using the power_supply_notifier chain
+*/
+
+struct psy_cable_props {
+	enum psy_charger_cable_event	chrg_evt;
+	unsigned long			chrg_type;
+	unsigned int			current_mA;
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
+enum battery_events {
+	POWER_SUPPLY_BATTERY_REMOVED = 0,
+	POWER_SUPPLY_BATTERY_INSERTED,
+};
+
+enum psy_batt_chrg_prof_type {
+	PSY_CHRG_PROF_NONE = 0,
+};
+
+/**
+ * struct psy_batt_chrg_prof - power supply charging profile structure
+ * @chrg_prof_type: charging profile type
+ * @batt_prof: pointer to battery charging profile structure
+ *
+ * This structure is populated by the battery identification driver
+ */
+
+struct psy_batt_chrg_prof {
+	enum psy_batt_chrg_prof_type chrg_prof_type;
+	void *batt_prof;
+};
+
+/**
+ * struct psy_batt_props - battery properties
+ * @voltage_now: voltage read from psy get_property and stored in in mV
+ * @current_now: current read from psy get_property and stored in in mA
+ * @temperature: battery temperature in degree Celsius
+ * @status: battery status as defined by POWER_SUPPLY_STATUS_*
+ * @health: battery health, as defined by POWER_SUPPLY_HEALTH_*
+ * @throttle_state: throttle state
+ * @tstamp: time stamp at which the properties are read
+ *
+ * battery properties structure is used to store important battery properties
+ * to decide on charging parameters
+ */
+
+struct psy_batt_props {
+	long voltage_now;
+	long current_now;
+	int temperature;
+	long status;
+	int health;
+	int throttle_state;
+	unsigned long long tstamp;
+};
+
+/**
+ * struct psy_batt_props - battery properties
+ * @batt_props: battery properties
+ * @voltage_now_cache: successive samples of voltage_now, used to determine end
+ *	of charge condition
+ * @current_now_cache: successive samples of current_now, used to determine end
+ *	of charge condition
+ * @algo_stat: algorithm status, returned by the charging algorithm
+ * @supplied_by_psy: psy pointer for all supplied by objects.
+ * @num_supplied_by_psy: number of supplied_by objects.
+ *
+ * battery context structure is used to store the battery context
+ * to decide on charging parameters
+ */
+
+struct psy_batt_context {
+	struct psy_batt_props batt_props;
+	long voltage_now_cache[MAX_CUR_VOLT_SAMPLES];
+	long current_now_cache[MAX_CUR_VOLT_SAMPLES];
+	enum psy_algo_stat algo_stat;
+	struct power_supply *supplied_by_psy[PSY_CHRGR_MAX_SUPPLIED_BY];
+	int num_supplied_by_psy;
+};
+
+/**
+ * struct psy_charger_props - charger properties
+ * @psyc: pointer to power_supply_charger structure
+ * @name: charger psy name
+ * @present: indicates charger source is present/not
+ * @is_charging: indicates charging is enabled or not
+ * @health: charger health, as defined in POWER_SUPPLY_HEALTH_*
+ * @online: charger online/not
+ * @cable: cable type
+ * @tstamp: time stamp at which the properties are read
+ *
+ * charger properties structure is used to store important charger properties
+ * to decide on charging parameters
+ */
+
+struct psy_charger_props {
+	bool present;
+	bool is_charging;
+	int health;
+	bool online;
+	unsigned long cable;
+	unsigned long tstamp;
+};
+
+/**
+ * struct psy_charger_props - charger properties
+ * @charger_props: charger properties
+ * @psyc: pointer to power_supply_charger structure
+ * @supplied_to_psy: psy pointers for all supplied to objects.
+ * @num_supplied_to_psy: number of supplied_to_psy pointers
+ */
+
+struct psy_charger_context {
+	struct psy_charger_props charger_props;
+	struct power_supply_charger *psyc;
+	struct power_supply *supplied_to_psy[PSY_CHRGR_MAX_SUPPLIED_TO];
+	int num_supplied_to_psy;
+};
+
+/**
+ * struct psy_batt_thresholds - battery thresholds structure
+ * @temp_min: minimum charging temperature in Degree Celsius
+ * @temp_max: maximum charging temperature in Degree Celsius
+ * @iterm: charge termination current
+ *
+ * battery thresholds structure to limit charging in different scenario
+ */
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
+/**
+ * struct power_supply_charger - power supply charger driver
+ * @psy: psy driver handle
+ * @throttle_states: pointer to throttle states array
+ * @num_throttle_states: number of throttling states
+ * @supported_cables: supported cable bitmask
+ * @get_property: get property function to retrieve charger properties defined
+ *	in enum power_supply_charger_property
+ * @set_property: get property function to retrieve charger properties defined
+ *	in enum power_supply_charger_property
+ *
+ * This structure is used by charger drivers to register with power supply
+ * charging driver
+ */
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
+};
+
+/**
+ * struct psy_charging_algo - charging algo structure
+ * @node: list head, not used by algo drivers.
+ * @chrg_prof_type: charging profile type which can be handled by the algorithm.
+ * @name: charging algorithm name
+ * @get_next_cc_cv: function pointer which returns CC and CV
+ * @get_batt_thresholds: function pointer to retrieve the battery thresholds
+ *	from battery charging profile
+ *
+ * This structure is used by charging algorithm drivers to register with power
+ * supply charging driver
+ */
+
+struct psy_charging_algo {
+	struct list_head node;
+	unsigned int chrg_prof_type;
+	char *name;
+	enum psy_algo_stat (*get_next_cc_cv)(struct psy_batt_context *,
+			struct psy_batt_chrg_prof, unsigned long *cc,
+			unsigned long *cv);
+	int (*get_batt_thresholds)(struct psy_batt_chrg_prof,
+			struct psy_batt_thresholds *bat_thr);
+};
+
+
+/* power_supply_charger functions */
+
+#ifdef CONFIG_POWER_SUPPLY_CHARGER
+
+extern int power_supply_register_charger(struct power_supply *psy,
+		struct power_supply_charger *psyc);
+extern int power_supply_unregister_charger(struct power_supply_charger *psyc);
+extern int power_supply_register_charging_algo(struct psy_charging_algo *);
+extern int power_supply_unregister_charging_algo(struct psy_charging_algo *);
+extern int psy_get_battery_prop(struct psy_batt_chrg_prof *batt_prop);
+extern void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_batt_chrg_prof *batt_prop);
+
+#else
+
+static int power_supply_register_charger(struct power_supply_charger *psyc)
+{ return -EINVAL; }
+static  int power_supply_unregister_charger(struct power_supply_charger *psyc)
+{ return -EINVAL; }
+static int power_supply_register_charging_algo(struct psy_charging_algo *algo)
+{ return -EINVAL; }
+static int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
+{ return -EINVAL; }
+static inline int psy_get_battery_prop(struct psy_batt_chrg_prof *batt_prop)
+{
+	return -ENOMEM;
+}
+static void psy_battery_prop_changed(int battery_conn_stat,
+				struct psy_batt_chrg_prof *batt_prop) { }
+#endif
+
+
+#endif
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 0278600..87af1e4 100644
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
@@ -206,6 +209,7 @@ struct power_supply {
 	struct work_struct changed_work;
 	spinlock_t changed_lock;
 	bool changed;
+	void *data;
 #ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd;
 	struct thermal_cooling_device *tcd;
@@ -324,4 +328,161 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
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
+		psy_get_ps_int_property(psy,\
+i			POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT)
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
+			POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT, iterm);
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
+	return	psy_set_ps_int_property(psy,
+			POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT, inlmt);
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

