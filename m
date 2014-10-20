Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaJTOSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:18:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64766 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaJTOSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:18:07 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-96-5445199b785d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] power: charger-manager: Fix accessing invalidated thermal zone
 device after its unbind
Date: Mon, 20 Oct 2014 16:17:52 +0200
Message-id: <1413814672-22938-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Zd3Zkq4hBgebZC0ObtW02DhjPavF
	9S/PWS0mPXnPbDFx5WRmi86zT5gtXr8wtDjb9Ibd4vKuOWwWn3uPMFqsPXKX3eJ24wo2i9O7
	SywWbHzE6MDnMaH/E6PHzll32T02r9Dy2LSqk82jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4
	Mr5eWcxcMM2o4uavbsYGxiXaXYycHBICJhK7+s4yQthiEhfurWfrYuTiEBJYyiixc+EUFgin
	j0ni7eW9zCBVbALGEpuXLwGrEhG4xSSxd+8GsCpmgbuMEs1334PNEhbIlLh//isLiM0ioCrx
	bOtDpi5GDg5eAXeJE48dIdbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghAfdlB+PiY1aHGAU4GJV4eAUsXUKEWBPLiitzDzFKcDArifCeEnQNEeJNSaysSi3Kjy8q
	zUktPsTIxMEp1cA4MUDEV9Z/qa2pqHxQT4LtxEOWZcY7d6XseM7w8a9M4gTJO7GKa1T+B740
	32o73THY3n2lC59exW2BxSvnewQpLf3I+46ZV2ZugFHAQmsT2wW+Lr3/NMTq+b6kHmRU07ZN
	KVhw7E1W+OS/ef4nSu+tXbqoq3Xx/P37b71eFyu/aPeyja/zXk1VYinOSDTUYi4qTgQAwUcQ
	ShYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lock corruption happened after unbinding a driver which provided thermal
zone for charger manager.

The charger manager obtained in probe a reference to thermal zone device.
This device was used to report temperature in its own thermal zone and
get_temp call.

The thermal zone's reference was not updated even if device providing it was
unregistered (e.g. by unbinding a driver providing that thermal zone).  If such
driver was re-binded then charger manager would still use the old reference.

Reproduction:
1. 'cm-thermal-zone' present in DTS.
2. Fuel gauge driver not exporting temperature property.
$ echo "12-0036" > /sys/bus/i2c/drivers/max17042/unbind
$ cat /sys/devices/virtual/power_supply/battery/temp_ambient

[  153.450663] ------------[ cut here ]------------
[  153.455274] WARNING: CPU: 3 PID: 6 at kernel/locking/mutex.c:511 mutex_lock_nested+0x3c4/0x458()
[  153.464022] DEBUG_LOCKS_WARN_ON(l->magic != l)
[  153.468275] Modules linked in:
[  153.471493] CPU: 3 PID: 6 Comm: kworker/u8:0 Tainted: G        W      3.17.0-next-20141020-00047-g54f3de817616-dirty #374
[  153.482432] Workqueue: charger_manager cm_monitor_poller
[  153.487752] [<c0014d2c>] (unwind_backtrace) from [<c0011c98>] (show_stack+0x10/0x14)
[  153.495457] [<c0011c98>] (show_stack) from [<c04da6dc>] (dump_stack+0x70/0xbc)
[  153.502670] [<c04da6dc>] (dump_stack) from [<c0022e94>] (warn_slowpath_common+0x64/0x88)
[  153.510732] [<c0022e94>] (warn_slowpath_common) from [<c0022f4c>] (warn_slowpath_fmt+0x30/0x40)
[  153.519413] [<c0022f4c>] (warn_slowpath_fmt) from [<c04dd8a8>] (mutex_lock_nested+0x3c4/0x458)
[  153.528006] [<c04dd8a8>] (mutex_lock_nested) from [<c03944e4>] (thermal_zone_get_temp+0x38/0x68)
[  153.536768] [<c03944e4>] (thermal_zone_get_temp) from [<c038fe68>] (cm_get_battery_temperature+0x3c/0xb4)
[  153.546314] [<c038fe68>] (cm_get_battery_temperature) from [<c0390640>] (cm_monitor+0x78/0x31c)
[  153.554993] [<c0390640>] (cm_monitor) from [<c03908ec>] (cm_monitor_poller+0x8/0x28)
[  153.562727] [<c03908ec>] (cm_monitor_poller) from [<c00396b4>] (process_one_work+0x180/0x3f4)
[  153.571229] [<c00396b4>] (process_one_work) from [<c003998c>] (worker_thread+0x30/0x458)
[  153.579300] [<c003998c>] (worker_thread) from [<c003f374>] (kthread+0xd8/0xf4)
[  153.586506] [<c003f374>] (kthread) from [<c000f268>] (ret_from_fork+0x14/0x2c)
[  153.593703] ---[ end trace b421d57d48f82c7d ]---
[  360.487375] INFO: task kworker/u8:0:6 blocked for more than 120 seconds.
[  360.492655]       Tainted: G        W      3.17.0-next-20141020-00047-g54f3de817616-dirty #374
[  360.501236] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.509047] kworker/u8:0    D c04dbcc8     0     6      2 0x00000000
[  360.515357] Workqueue: charger_manager cm_monitor_poller
[  360.520665] [<c04dbcc8>] (__schedule) from [<c04dc4d4>] (schedule_preempt_disabled+0x14/0x20)
[  360.529203] [<c04dc4d4>] (schedule_preempt_disabled) from [<c04dd6a0>] (mutex_lock_nested+0x1bc/0x458)
[  360.538493] [<c04dd6a0>] (mutex_lock_nested) from [<c028fbb4>] (regmap_read+0x30/0x60)
[  360.546405] [<c028fbb4>] (regmap_read) from [<c038eae8>] (max17042_get_property+0x30c/0x350)
[  360.554808] [<c038eae8>] (max17042_get_property) from [<c038c2cc>] (power_supply_read_temp+0x28/0x58)
[  360.564008] [<c038c2cc>] (power_supply_read_temp) from [<c03944f8>] (thermal_zone_get_temp+0x4c/0x68)
[  360.573203] [<c03944f8>] (thermal_zone_get_temp) from [<c038fe68>] (cm_get_battery_temperature+0x3c/0xb4)
[  360.582749] [<c038fe68>] (cm_get_battery_temperature) from [<c0390640>] (cm_monitor+0x78/0x31c)
[  360.591428] [<c0390640>] (cm_monitor) from [<c03908ec>] (cm_monitor_poller+0x8/0x28)
[  360.599165] [<c03908ec>] (cm_monitor_poller) from [<c00396b4>] (process_one_work+0x180/0x3f4)
[  360.607669] [<c00396b4>] (process_one_work) from [<c003998c>] (worker_thread+0x30/0x458)
[  360.615733] [<c003998c>] (worker_thread) from [<c003f374>] (kthread+0xd8/0xf4)
[  360.622946] [<c003f374>] (kthread) from [<c000f268>] (ret_from_fork+0x14/0x2c)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 5c49a6256bed ("charger-manager: Modify the way of checking battery's temperature")
---
 drivers/power/charger-manager.c       | 21 +++++++++++++++------
 include/linux/power/charger-manager.h |  4 +---
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 60688c20594d..d5bdcda8dc5f 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -627,8 +627,14 @@ static int cm_get_battery_temperature(struct charger_manager *cm,
 		return -ENODEV;
 
 #ifdef CONFIG_THERMAL
-	if (cm->tzd_batt) {
-		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
+	if (cm->use_external_tzd) {
+		struct thermal_zone_device *tzd;
+
+		tzd = thermal_zone_get_zone_by_name(cm->desc->thermal_zone);
+		if (IS_ERR(tzd))
+			return PTR_ERR(tzd);
+
+		ret = thermal_zone_get_temp(tzd, (unsigned long *)temp);
 		if (!ret)
 			/* Calibrate temperature unit */
 			*temp /= 100;
@@ -1590,12 +1596,15 @@ static int cm_init_thermal_data(struct charger_manager *cm,
 	}
 #ifdef CONFIG_THERMAL
 	if (ret && desc->thermal_zone) {
-		cm->tzd_batt =
-			thermal_zone_get_zone_by_name(desc->thermal_zone);
-		if (IS_ERR(cm->tzd_batt))
-			return PTR_ERR(cm->tzd_batt);
+		struct thermal_zone_device *tzd;
+
+		/* Just check if we want to export TEMP_AMBIENT */
+		tzd = thermal_zone_get_zone_by_name(desc->thermal_zone);
+		if (IS_ERR(tzd))
+			return PTR_ERR(tzd);
 
 		/* Use external thermometer */
+		cm->use_external_tzd = true;
 		cm->charger_psy.properties[cm->charger_psy.num_properties] =
 				POWER_SUPPLY_PROP_TEMP_AMBIENT;
 		cm->charger_psy.num_properties++;
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index e97fc656a058..f3000d850995 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -253,9 +253,7 @@ struct charger_manager {
 	struct device *dev;
 	struct charger_desc *desc;
 
-#ifdef CONFIG_THERMAL
-	struct thermal_zone_device *tzd_batt;
-#endif
+	bool use_external_tzd;
 	bool charger_enabled;
 
 	unsigned long fullbatt_vchk_jiffies_at;
-- 
1.9.1

