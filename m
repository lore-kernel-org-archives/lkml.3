Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3GNJmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 05:42:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:21640 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3GNJmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 05:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,662,1367996400"; 
   d="scan'208";a="331142291"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 2/3] power_supply : add charger cable properties
Date: Sun, 14 Jul 2013 23:08:02 +0530
Message-Id: <1373823482-2616-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the charger cables are related to power supply subsystem it
makes sense to define the properties associate with charger cables.
The properties include cable events and the input current. The cable
properties may come from different sources. Since they are associated
with power_supply subsystem, it make sense to unify the properties
in the power supply susbsyem layer.

Also a charger can support different types of charger sources (cables).
It make sense to define a field to inform the power supply subsystem
what kind of cable  a charger driver supports. Since a bitmask would
be the easy way to do define, it's good to have a enum which has
the bitmask definition for each cable types

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/power_supply.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1265131..5a24e10 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -165,6 +165,43 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_USB_ACA,	/* Accessory Charger Adapters */
 };
 
+enum psy_charger_cable_event {
+	PSY_CHARGER_CABLE_EVENT_CONNECT = 0,
+	PSY_CHARGER_CABLE_EVENT_UPDATE,
+	PSY_CHARGER_CABLE_EVENT_RESUME,
+	PSY_CHARGER_CABLE_EVENT_SUSPEND,
+	PSY_CHARGER_CABLE_EVENT_DISCONNECT,
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
+	unsigned int			mA;	/* input current limit */
+};
+
+#define PSY_CHARGER_CABLE_TYPE_USB \
+	(PSY_CHARGER_CABLE_TYPE_USB_SDP | \
+	PSY_CHARGER_CABLE_TYPE_USB_DCP | \
+	PSY_CHARGER_CABLE_TYPE_USB_CDP | \
+	PSY_CHARGER_CABLE_TYPE_USB_ACA | \
+	PSY_CHARGER_CABLE_TYPE_ACA_DOCK)
+
 union power_supply_propval {
 	int intval;
 	const char *strval;
@@ -180,6 +217,7 @@ struct power_supply {
 
 	char **supplied_to;
 	size_t num_supplicants;
+	unsigned long supported_cables;
 
 	char **supplied_from;
 	size_t num_supplies;
-- 
1.7.9.5

