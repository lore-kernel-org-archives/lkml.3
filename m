Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3KSKWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:22:08 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55208 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3KSKWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:22:05 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH v2 1/3] power_supply: Add power_supply notifier
Date: Tue, 19 Nov 2013 11:18:03 +0100
Message-Id: <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a notifier chain to the power_supply.
This notifier helps drivers in other subsystem to listen to
changes in power supply subsystem. This would help to take some
actions in those drivers on changing the power supply properties.
One such scenario is to increase/decrease system performance based
on the battery capacity/voltage. Another scenario is to adjust the
h/w peak current detection voltage/current thresholds based on battery
voltage/capacity. The notifier helps drivers to listen to changes
in power_suppy susbystem without polling the power_supply properties

Signed-off-by: Jenny TC <jenny.tc@intel.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/power_supply_core.c |   17 +++++++++++++++++
 include/linux/power_supply.h      |   10 ++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 00e6672..08bce22 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -24,6 +24,9 @@
 struct class *power_supply_class;
 EXPORT_SYMBOL_GPL(power_supply_class);
 
+ATOMIC_NOTIFIER_HEAD(power_supply_notifier);
+EXPORT_SYMBOL_GPL(power_supply_notifier);
+
 static struct device_type power_supply_dev_type;
 
 static bool __power_supply_is_supplied_by(struct power_supply *supplier,
@@ -80,6 +83,8 @@ static void power_supply_changed_work(struct work_struct *work)
 		class_for_each_device(power_supply_class, NULL, psy,
 				      __power_supply_changed_work);
 		power_supply_update_leds(psy);
+		atomic_notifier_call_chain(&power_supply_notifier,
+				PSY_EVENT_PROP_CHANGED, psy);
 		kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
 		spin_lock_irqsave(&psy->changed_lock, flags);
 	}
@@ -347,6 +352,18 @@ static void power_supply_dev_release(struct device *dev)
 	kfree(dev);
 }
 
+int power_supply_reg_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&power_supply_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(power_supply_reg_notifier);
+
+void power_supply_unreg_notifier(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&power_supply_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(power_supply_unreg_notifier);
+
 #ifdef CONFIG_THERMAL
 static int power_supply_read_temp(struct thermal_zone_device *tzd,
 		unsigned long *temp)
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 5c26006..c6f52c0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -158,6 +158,13 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_USB_ACA,	/* Accessory Charger Adapters */
 };
 
+enum power_supply_notifier_events {
+	PSY_EVENT_NONE,
+	PSY_EVENT_PROP_CHANGED,
+	PSY_EVENT_BATTERY,
+	PSY_EVENT_CABLE,
+};
+
 union power_supply_propval {
 	int intval;
 	const char *strval;
@@ -235,6 +242,9 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
+extern struct atomic_notifier_head    power_supply_notifier;
+extern int power_supply_reg_notifier(struct notifier_block *nb);
+extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
-- 
1.7.9.5

