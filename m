Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaJFQAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:00:30 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37747 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJFQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:00:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-36-5432bc9859c6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] power: charger-manager: Avoid recursive thermal get_temp call
Date: Mon, 06 Oct 2014 18:00:12 +0200
Message-id: <1412611212-24803-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xK7oz9hiFGMzcpWdxcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLV6/MLS4vGsOm8Xn3iOMFrcbV7BZnN5d4sDlMaH/E6PHzll32T02
	r9Dy2LSqk82jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mv41XWcpuG1esfh/O3MD4wT9LkZO
	DgkBE4lJv1tZIGwxiQv31rN1MXJxCAksZZT41LMTyuljknjwfAc7SBWbgLHE5uVLwBIiAreY
	JPbu3QDWzixgKPHz3R+wImEBP4l9d3ewgdgsAqoSR392M4PYvALuEt+bH7FBrJOTOHlsMusE
	Ru4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIC6esOxqXHrA4xCnAwKvHwRu4wDBFi
	TSwrrsw9xCjBwawkwms+zyhEiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Mgo/Bvowfb7nxU8Cy7
	sPrAlOsVrS2mq8w8e+f8uTGlSbE344DHp1/3nzZmNSxo4OSa3/JnA4dgxF4Bua3c7oFpHc8U
	r60261+he6/vwQpnpUeXEp/2z/wrH6X9xvJf6Karodt8XixxK9vGalWk9NRRXJbjptMe34al
	9SszazMm805rep6q+liJpTgj0VCLuag4EQAi4A41AgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
as a thermal zone if any of these conditions match:
1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
2. 'cm-thermal-zone' property is present in DTS (then it will supersede
   the fuel gauge temperature property).

However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
is not set) the charger manager forwards its get_temp calls to fuel
gauge thermal zone.

This leads to reporting by lockdep a false positive deadlock for thermal
zone's mutex because of nested calls to thermal_zone_get_temp(). This is
false positive because these are different mutexes: one for charger
manager thermal zone and second for fuel gauge thermal zone.

Get rid of false lockdep alert and recursive call by accessing fuel gauge
temperature through power supply property instead of thermal zone API.

The lockdep report:
[    2.540339] charger-manager charger-manager@0: Ignoring full-battery voltage threshold as it is not supplied
[    2.540351] charger-manager charger-manager@0: Ignoring full-battery full capacity threshold as it is not supplied
[    2.546296]
[    2.546302] =============================================
[    2.546305] [ INFO: possible recursive locking detected ]
[    2.546312] 3.17.0-rc6-next-20140926-00012-gbb13895e46af-dirty #39 Not tainted
[    2.546316] ---------------------------------------------
[    2.546321] swapper/0/1 is trying to acquire lock:
[    2.546348]  (&tz->lock){+.+...}, at: [<c0321d24>] thermal_zone_get_temp+0x38/0x68
[    2.546352]
[    2.546352] but task is already holding lock:
[    2.546369]  (&tz->lock){+.+...}, at: [<c0321d24>] thermal_zone_get_temp+0x38/0x68
[    2.546373]
[    2.546373] other info that might help us debug this:
[    2.546376]  Possible unsafe locking scenario:
[    2.546376]
[    2.546378]        CPU0
[    2.546380]        ----
[    2.546386]   lock(&tz->lock);
[    2.546392]   lock(&tz->lock);
[    2.546394]
[    2.546394]  *** DEADLOCK ***
[    2.546394]
[    2.546397]  May be due to missing lock nesting notation
[    2.546397]
[    2.546401] 2 locks held by swapper/0/1:
[    2.546430]  #0:  (&dev->mutex){......}, at: [<c02720c4>] __driver_attach+0x58/0x98
[    2.546448]  #1:  (&tz->lock){+.+...}, at: [<c0321d24>] thermal_zone_get_temp+0x38/0x68
[    2.546451]
[    2.546451] stack backtrace:
[    2.546460] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-next-20140926-00012-gbb13895e46af-dirty #39
[    2.546497] [<c00140f0>] (unwind_backtrace) from [<c0011228>] (show_stack+0x10/0x14)
[    2.546526] [<c0011228>] (show_stack) from [<c046158c>] (dump_stack+0x70/0xbc)
[    2.546554] [<c046158c>] (dump_stack) from [<c005e32c>] (validate_chain.isra.24+0x718/0x890)
[    2.546569] [<c005e32c>] (validate_chain.isra.24) from [<c005f0a0>] (__lock_acquire+0x498/0xa78)
[    2.546581] [<c005f0a0>] (__lock_acquire) from [<c005fb50>] (lock_acquire+0x78/0xb8)
[    2.546594] [<c005fb50>] (lock_acquire) from [<c0464260>] (mutex_lock_nested+0x64/0x458)
[    2.546605] [<c0464260>] (mutex_lock_nested) from [<c0321d24>] (thermal_zone_get_temp+0x38/0x68)
[    2.546634] [<c0321d24>] (thermal_zone_get_temp) from [<c031f1e0>] (charger_get_property+0x10c/0x348)
[    2.546649] [<c031f1e0>] (charger_get_property) from [<c031af18>] (power_supply_read_temp+0x28/0x58)
[    2.546662] [<c031af18>] (power_supply_read_temp) from [<c0321d38>] (thermal_zone_get_temp+0x4c/0x68)
[    2.546676] [<c0321d38>] (thermal_zone_get_temp) from [<c03233d8>] (thermal_zone_device_update+0x24/0x9c)
[    2.546687] [<c03233d8>] (thermal_zone_device_update) from [<c0323874>] (thermal_zone_device_register+0x424/0x550)
[    2.546701] [<c0323874>] (thermal_zone_device_register) from [<c031b3c0>] (__power_supply_register+0x2a4/0x348)
[    2.546714] [<c031b3c0>] (__power_supply_register) from [<c031ff64>] (charger_manager_probe+0x600/0xe5c)
[    2.546727] [<c031ff64>] (charger_manager_probe) from [<c0273384>] (platform_drv_probe+0x48/0xa4)
[    2.546746] [<c0273384>] (platform_drv_probe) from [<c0271f54>] (driver_probe_device+0x10c/0x224)
[    2.546760] [<c0271f54>] (driver_probe_device) from [<c0272100>] (__driver_attach+0x94/0x98)
[    2.546772] [<c0272100>] (__driver_attach) from [<c0270780>] (bus_for_each_dev+0x54/0x88)
[    2.546784] [<c0270780>] (bus_for_each_dev) from [<c027173c>] (bus_add_driver+0xd4/0x1d0)
[    2.546797] [<c027173c>] (bus_add_driver) from [<c027271c>] (driver_register+0x78/0xf4)
[    2.546809] [<c027271c>] (driver_register) from [<c0008984>] (do_one_initcall+0x80/0x1d4)
[    2.546829] [<c0008984>] (do_one_initcall) from [<c0612d60>] (kernel_init_freeable+0x10c/0x1d8)
[    2.546847] [<c0612d60>] (kernel_init_freeable) from [<c045c238>] (kernel_init+0x8/0xec)
[    2.546863] [<c045c238>] (kernel_init) from [<c000e828>] (ret_from_fork+0x14/0x2c)
[    2.551396] charger-manager charger-manager@0: 'chg-reg' regulator's externally_control is 0

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/charger-manager.c       | 21 +++++++++++----------
 include/linux/power/charger-manager.h |  2 --
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index c1ed3c99c059..871fb91429c8 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -559,16 +559,18 @@ static int cm_get_battery_temperature(struct charger_manager *cm,
 	if (!cm->desc->measure_battery_temp)
 		return -ENODEV;
 
-#ifdef CONFIG_THERMAL
-	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
-	if (!ret)
-		/* Calibrate temperature unit */
-		*temp /= 100;
-#else
-	ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+	if (IS_ENABLED(CONFIG_THERMAL) && cm->tzd_batt) {
+		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
+		if (!ret)
+			/* Calibrate temperature unit */
+			*temp /= 100;
+	} else {
+		/* No external thermometer or no CONFIG_THERMAL */
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_TEMP,
 				(union power_supply_propval *)temp);
-#endif
+	}
+
 	return ret;
 }
 
@@ -1501,9 +1503,8 @@ static int cm_init_thermal_data(struct charger_manager *cm)
 		cm->charger_psy.num_properties++;
 		cm->desc->measure_battery_temp = true;
 	}
-#ifdef CONFIG_THERMAL
-	cm->tzd_batt = cm->fuel_gauge->tzd;
 
+#ifdef CONFIG_THERMAL
 	if (ret && desc->thermal_zone) {
 		cm->tzd_batt =
 			thermal_zone_get_zone_by_name(desc->thermal_zone);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 07e7945a1ff2..743ed6d472c6 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -256,9 +256,7 @@ struct charger_manager {
 	struct power_supply *fuel_gauge;
 	struct power_supply **charger_stat;
 
-#ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd_batt;
-#endif
 	bool charger_enabled;
 
 	unsigned long fullbatt_vchk_jiffies_at;
-- 
1.9.1

