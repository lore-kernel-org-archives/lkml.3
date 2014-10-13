Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaJMNet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:34:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaJMNen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:34:43 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d6-543bd4f09635
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] power: charger-manager: Fix accessing invalidated power
 supply after charger unbind
Date: Mon, 13 Oct 2014 15:34:31 +0200
Message-id: <1413207271-23836-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413207271-23836-1-git-send-email-k.kozlowski@samsung.com>
References: <1413207271-23836-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7ofrliHGNyaJ29xcKumxcYZ61kt
	rn95zmox6cl7ZouJKyczW3SefcJs8fqFocXZpjfsFpd3zWGz+Nx7hNFi7ZG77Ba3G1ewWZze
	XWKxYOMjRgc+jwn9nxg9ds66y+6xeYWWx6ZVnWwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fA
	lXH6gE/BeveKOU8+szcw7rDqYuTkkBAwkfg5axU7hC0mceHeerYuRi4OIYGljBInlpxjgnD6
	mCQWPH3JClLFJmAssXn5ErAqEYGnTBKdZxoZQRxmgSuMEk+/vwarEhbIklj2fSkziM0ioCpx
	7dx7MJtXwF3i2Jp2qH1yEiePTQar5xTwkNg5ZzFYjRBQzfZn+5knMPIuYGRYxSiaWppcUJyU
	nmukV5yYW1yal66XnJ+7iRESoF93MC49ZnWIUYCDUYmH1+KPVYgQa2JZcWXuIUYJDmYlEV7R
	S9YhQrwpiZVVqUX58UWlOanFhxiZODilGhjtBRpS5++Z8H6Caov66Re96Rw/8hbqysSJfY9r
	lJ43a8OhT6pzdbdWfzT5oZHvcTr/U5LHn1v7mndYnbBZetOpt55x44L9nM0sjDKnY84ePRXa
	cX7hXQerp1offVfqLHkk7OvBFRLq85ktuKX7x7qHHidm3r9xofme6MOELosYhmlzdGw0VpUr
	sRRnJBpqMRcVJwIAq5Tjbi4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger manager obtained in probe references to power supplies for
all chargers with power_supply_get_by_name() for later usage. However
if such charger driver was removed then this reference would point to
old power supply (from driver which was removed).

This lead to accessing invalid memory which could be observed with:
$ echo "max77693-charger" > /sys/bus/platform/drivers/max77693-charger/unbind
$ grep . /sys/devices/virtual/power_supply/battery/charger.0/*
$ grep . /sys/devices/virtual/power_supply/battery/*
[   15.339817] Unable to handle kernel paging request at virtual address 0001c12c
[   15.346187] pgd = edd08000
[   15.348814] [0001c12c] *pgd=6dce2831, *pte=00000000, *ppte=00000000
[   15.355075] Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
[   15.360967] Modules linked in:
[   15.364010] CPU: 2 PID: 1388 Comm: grep Not tainted 3.17.0-next-20141007-00027-ga95e761db1b0 #245
[   15.372859] task: ee03ad00 ti: edcf6000 task.ti: edcf6000
[   15.378241] PC is at 0x1c12c
[   15.381113] LR is at is_ext_pwr_online+0x30/0x6c
[   15.385706] pc : [<0001c12c>]    lr : [<c0339fc4>]    psr: a0000013
[   15.385706] sp : edcf7e88  ip : 00000000  fp : 00000000
[   15.397161] r10: eeb02c08  r9 : c04b1f84  r8 : eeb02c00
[   15.402369] r7 : edc69a10  r6 : eea6ac10  r5 : eea6ac10  r4 : 00000004
[   15.408878] r3 : 0001c12c  r2 : edcf7e8c  r1 : 00000004  r0 : ee914418
[   15.415390] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   15.422506] Control: 10c5387d  Table: 6dd0804a  DAC: 00000015
[   15.428236] Process grep (pid: 1388, stack limit = 0xedcf6240)
[   15.434050] Stack: (0xedcf7e88 to 0xedcf8000)
[   15.438395] 7e80:                   ee03ad00 00000000 edcf7f80 eea6aca8 edcf7ec4 c033b7b0
[   15.446554] 7ea0: 00000001 ee1cc3f0 00000004 c06e1e44 eebdc000 c06e1e44 eeb02c00 c0337144
[   15.454713] 7ec0: ee2dac68 c005cffc ee1cc3c0 c06e1e44 00000fff 00001000 eebdc000 c0278ca8
[   15.462872] 7ee0: c0278c8c ee1cc3c0 eeb7ce00 c014422c edcf7f20 00008000 ee1cc3c0 ee9a48c0
[   15.471030] 7f00: 00000001 00000001 edcf7f80 c0142d94 c0142d70 c01060f4 00021000 ee1cc3f0
[   15.479190] 7f20: 00000000 00000000 c06a2150 eebdc000 2e7ec000 ee9a48c0 00008000 00021000
[   15.487349] 7f40: edcf7f80 00008000 edcf6000 00021000 00021000 c00e39a4 00000000 ee9a48c0
[   15.495508] 7f60: 00004000 00000000 00000000 ee9a48c0 ee9a48c0 00008000 00021000 c00e3aa0
[   15.503668] 7f80: 00000000 00000000 0001f2e0 0001f2e0 00021000 00001000 00000003 c000f364
[   15.511826] 7fa0: 00000000 c000f1a0 0001f2e0 00021000 00000003 00021000 00008000 00000000
[   15.519986] 7fc0: 0001f2e0 00021000 00001000 00000003 00000001 000205e8 00000000 00021000
[   15.528145] 7fe0: 00008000 bebbe910 0000a7ad b6edc49c 60000010 00000003 aaaaaaaa aaaaaaaa
[   15.536320] [<c0339fc4>] (is_ext_pwr_online) from [<c033b7b0>] (charger_get_property+0x170/0x314)
[   15.545164] [<c033b7b0>] (charger_get_property) from [<c0337144>] (power_supply_show_property+0x48/0x20c)
[   15.554719] [<c0337144>] (power_supply_show_property) from [<c0278ca8>] (dev_attr_show+0x1c/0x48)
[   15.563577] [<c0278ca8>] (dev_attr_show) from [<c014422c>] (sysfs_kf_seq_show+0x84/0x104)
[   15.571725] [<c014422c>] (sysfs_kf_seq_show) from [<c0142d94>] (kernfs_seq_show+0x24/0x28)
[   15.579973] [<c0142d94>] (kernfs_seq_show) from [<c01060f4>] (seq_read+0x1b0/0x484)
[   15.587614] [<c01060f4>] (seq_read) from [<c00e39a4>] (vfs_read+0x88/0x144)
[   15.594552] [<c00e39a4>] (vfs_read) from [<c00e3aa0>] (SyS_read+0x40/0x8c)
[   15.601417] [<c00e3aa0>] (SyS_read) from [<c000f1a0>] (ret_fast_syscall+0x0/0x48)
[   15.608877] Code: bad PC value
[   15.611991] ---[ end trace a88fcc95208db283 ]---

The charger-manager should get reference to charger power supply on
each use of get_property callback.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 3bb3dbbd56ea ("power_supply: Add initial Charger-Manager driver")
---
 drivers/power/charger-manager.c       | 64 +++++++++++++++++++++--------------
 include/linux/power/charger-manager.h |  2 --
 2 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index c37409a2bcb7..b5d272cb7c4a 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -118,10 +118,17 @@ static bool is_batt_present(struct charger_manager *cm)
 			present = true;
 		break;
 	case CM_CHARGER_STAT:
-		for (i = 0; cm->charger_stat[i]; i++) {
-			ret = cm->charger_stat[i]->get_property(
-					cm->charger_stat[i],
-					POWER_SUPPLY_PROP_PRESENT, &val);
+		for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
+			psy = power_supply_get_by_name(
+					cm->desc->psy_charger_stat[i]);
+			if (!psy) {
+				dev_err(cm->dev, "Cannot find power supply \"%s\"\n",
+					cm->desc->psy_charger_stat[i]);
+				continue;
+			}
+
+			ret = psy->get_property(psy, POWER_SUPPLY_PROP_PRESENT,
+					&val);
 			if (ret == 0 && val.intval) {
 				present = true;
 				break;
@@ -144,14 +151,20 @@ static bool is_batt_present(struct charger_manager *cm)
 static bool is_ext_pwr_online(struct charger_manager *cm)
 {
 	union power_supply_propval val;
+	struct power_supply *psy;
 	bool online = false;
 	int i, ret;
 
 	/* If at least one of them has one, it's yes. */
-	for (i = 0; cm->charger_stat[i]; i++) {
-		ret = cm->charger_stat[i]->get_property(
-				cm->charger_stat[i],
-				POWER_SUPPLY_PROP_ONLINE, &val);
+	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
+		psy = power_supply_get_by_name(cm->desc->psy_charger_stat[i]);
+		if (!psy) {
+			dev_err(cm->dev, "Cannot find power supply \"%s\"\n",
+					cm->desc->psy_charger_stat[i]);
+			continue;
+		}
+
+		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
 		if (ret == 0 && val.intval) {
 			online = true;
 			break;
@@ -196,6 +209,7 @@ static bool is_charging(struct charger_manager *cm)
 {
 	int i, ret;
 	bool charging = false;
+	struct power_supply *psy;
 	union power_supply_propval val;
 
 	/* If there is no battery, it cannot be charged */
@@ -203,17 +217,22 @@ static bool is_charging(struct charger_manager *cm)
 		return false;
 
 	/* If at least one of the charger is charging, return yes */
-	for (i = 0; cm->charger_stat[i]; i++) {
+	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
 		/* 1. The charger sholuld not be DISABLED */
 		if (cm->emergency_stop)
 			continue;
 		if (!cm->charger_enabled)
 			continue;
 
+		psy = power_supply_get_by_name(cm->desc->psy_charger_stat[i]);
+		if (!psy) {
+			dev_err(cm->dev, "Cannot find power supply \"%s\"\n",
+					cm->desc->psy_charger_stat[i]);
+			continue;
+		}
+
 		/* 2. The charger should be online (ext-power) */
-		ret = cm->charger_stat[i]->get_property(
-				cm->charger_stat[i],
-				POWER_SUPPLY_PROP_ONLINE, &val);
+		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read ONLINE value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
@@ -226,9 +245,7 @@ static bool is_charging(struct charger_manager *cm)
 		 * 3. The charger should not be FULL, DISCHARGING,
 		 * or NOT_CHARGING.
 		 */
-		ret = cm->charger_stat[i]->get_property(
-				cm->charger_stat[i],
-				POWER_SUPPLY_PROP_STATUS, &val);
+		ret = psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &val);
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read STATUS value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
@@ -1772,15 +1789,12 @@ static int charger_manager_probe(struct platform_device *pdev)
 	while (desc->psy_charger_stat[i])
 		i++;
 
-	cm->charger_stat = devm_kzalloc(&pdev->dev,
-				sizeof(struct power_supply *) * i, GFP_KERNEL);
-	if (!cm->charger_stat)
-		return -ENOMEM;
-
+	/* Check if charger's supplies are present at probe */
 	for (i = 0; desc->psy_charger_stat[i]; i++) {
-		cm->charger_stat[i] = power_supply_get_by_name(
-					desc->psy_charger_stat[i]);
-		if (!cm->charger_stat[i]) {
+		struct power_supply *psy;
+
+		psy = power_supply_get_by_name(desc->psy_charger_stat[i]);
+		if (!psy) {
 			dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
 				desc->psy_charger_stat[i]);
 			return -ENODEV;
@@ -2109,8 +2123,8 @@ static bool find_power_supply(struct charger_manager *cm,
 	int i;
 	bool found = false;
 
-	for (i = 0; cm->charger_stat[i]; i++) {
-		if (psy == cm->charger_stat[i]) {
+	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
+		if (!strcmp(psy->name, cm->desc->psy_charger_stat[i])) {
 			found = true;
 			break;
 		}
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 5d90d329e0ba..e97fc656a058 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -253,8 +253,6 @@ struct charger_manager {
 	struct device *dev;
 	struct charger_desc *desc;
 
-	struct power_supply **charger_stat;
-
 #ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd_batt;
 #endif
-- 
1.9.1

