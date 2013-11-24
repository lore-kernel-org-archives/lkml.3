Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3KXQt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:49:59 -0500
Received: from ring0.de ([91.143.88.219]:60803 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab3KXQtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:49:52 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH 1/3] power_supply: add power_supply_get_by_phandle
Date: Sun, 24 Nov 2013 17:49:29 +0100
Message-Id: <1385311771-447-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385311771-447-1-git-send-email-sre@debian.org>
References: <1385311771-447-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add method to get power supply by device tree phandle.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/power/power_supply_core.c | 24 ++++++++++++++++++++++++
 include/linux/power_supply.h      |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 08bce22..99e4b41 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -340,6 +340,30 @@ struct power_supply *power_supply_get_by_name(const char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+static int power_supply_match_device_node(struct device *dev, const void *data)
+{
+	return dev->parent && dev->parent->of_node == data;
+}
+
+struct power_supply *power_supply_get_by_phandle(struct device_node *np,
+							const char *property)
+{
+	struct device_node *power_supply_np;
+	struct device *dev;
+
+	power_supply_np = of_parse_phandle(np, property, 0);
+	if (!power_supply_np)
+		return ERR_PTR(-ENODEV);
+
+	dev = class_find_device(power_supply_class, NULL, power_supply_np,
+						power_supply_match_device_node);
+
+	of_node_put(power_supply_np);
+
+	return dev ? dev_get_drvdata(dev) : NULL;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c6f52c0..4d0e0b4 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -246,6 +246,8 @@ extern struct atomic_notifier_head    power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
+extern struct power_supply *power_supply_get_by_phandle(struct device_node *np,
+							const char *property);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
-- 
1.8.4.3

