Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaATEet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:34:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50239 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaATEed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:33 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 1/5] sc_phy:SmartCard(SC) PHY interface to SC controller
Date: Mon, 20 Jan 2014 10:03:50 +0530
Message-ID: <1390192434-19386-2-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SmartCard controller uses this interface to communicate with
SmartCard via PHY

Some SmartCard PHY has multiple slots for cards.
This inerface also enables controller to communicate
with one or more SmartCard connected over phy.

interface structure includes following APIs
- set/get config
- activate/deactivate smart card
- warm reset
- register_notify (for card insert/remove/overheat)
- unregister_notify

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 Documentation/sc_phy.txt |  171 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sc_phy.h   |  132 +++++++++++++++++++++++++++++++++++
 2 files changed, 303 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/sc_phy.txt
 create mode 100644 include/linux/sc_phy.h

diff --git a/Documentation/sc_phy.txt b/Documentation/sc_phy.txt
new file mode 100644
index 0000000..d610e26
--- /dev/null
+++ b/Documentation/sc_phy.txt
@@ -0,0 +1,171 @@
+		SmartCard PHY Interface
+	Satish Patel <satish.patel@ti.com>
+
+This document explains the SmartCard interface between SmartCard
+controller and SmartCard phy. Document also describes how-to-use.
+
+1. Why SmartCard PHY Interface?
+
+The use of smartcard is increasing in embedded industry. As smartcard
+not only prevent duplication but also, brings key based authentication
+flow into picture.
+
+SmartCard standards like EMV(EuroPay-Mastercard-Visa) are becoming
+mandatory for payment terminals.
+
+Till date, most of the SmartCard readers are based on USB serial
+interface. Which drives its logic within firmware lies on device.
+Few are based on FPGA solutions. But now SoCs are coming up with
+inbuilt smartcard controller. e.g. TI-AM43x
+
+Role of SmartCard controller and SmartCard phy:
+
+Smartcard Phy:
+Forms electrical interface between controller and SmartCard. Phy
+enables access to more than one smartcard and in addition it provides
+fast deactivation logic when card gets removed from the slot. It can
+also generate the signals like card insert/remove/overheat etc.
+
+Smartcard Controller:
+In built mechanism to meet EMV L1 specification (e.g. T=0, T=1
+protocol timings, ATR timeout etc..) for SmartCard transaction. In
+addition to this, it has FIFO to store tx/rx bytes, internal state
+machine for ATR, Tx/Rx, Synchronous/Asynchronous mode, timing
+counters etc..
+
+Controller can also have direct interface through which SmartCard
+can be connected without phy.
+
+Below is the brief of SmartCard block diagram from user to h/w
+layer.
+
+
+        -----------
+        |PC/SC App|
+        -----------
+        -----------     -----------
+        |PC/SC F/W|     | Visa APP|
+        -----------     -----------
+        -----------     ------------    ------------
+        |IFD Hand.|     | EMV L1/L2|    | Test App |
+        -----------     ------------    ------------
+User Space
+--------------------------------------------------------------------
+
+        -----------------------------------------
+        |   SmartCard Controller Driver        |
+        -----------------------------------------
+                 |                     |
+                 |                     |
+        -------------                  |
+        | Phy Driver |                 |
+        -------------                  |
+                 |                     |
+Kernel Space     |                     |
+--------------------------------------------------------------------
+                 |                     |
+           ---------              ----------------
+           | PHY   |              |Controller IP |
+           ---------              ----------------
+                |                       |
+--------------------------------------------------------------------
+                |                       |
+           _______________________________________
+           |                |                |
+         VISA card       Master Card      Custom Card
+
+
+At present in Linux there is no public interface exist which acts as
+bridge between controller and phy. Mostly vendors uses proprietary
+solution in such cases.
+
+2. Introduction to SmartCard PHY interface
+
+SmartCard PHY interface that exposes phy's capabilities to the smart
+card controller. SmartCard controller uses this interface to
+communicate with SmartCard via phy.
+
+Such capabilities are:
+1) Some SmartCard phy (e.g. TDA8026-NxP) has multiple slots for smart
+cards. This interface enables controller to communicate with specific
+SmartCard inserted to the specific phy's slot.
+
+2) Warm reset to SmartCard inserted to phy slot.
+
+3) Bit banging of SmartCard pins to support vedor specific memory
+cards. Mostly when it comes to sychorous SmartCard
+
+4) Notification of card insert/remove/overheat etc.
+
+
+3. How to use
+
+SmartCard PHY:
+The SmartCard PHY driver, who wants to be interfaced with SmartCard
+controller require to follow below step
+
+- include "sc_phy.h"
+
+- use "sc_phy" structure as driver(client) data. PHY driver can use
+'void *pdata' of "sc_phy" to hold its private data(if any)
+
+- implement following capabilities (whichever is applicable)
+	set_config
+	get_config
+	activate_card
+	deactivate_card
+	warm_reset
+	register_notify
+	unregister_notify
+e.g.
+phyxx_init()
+{
+
+	struct sc_phy *sc_phy;
+	struct phyxx *pdata;
+
+	...
+	...
+	sc_phy->pdata = pdata;
+	sc_phy->set_config	= phyxx_set_config;
+	sc_phy->get_config	= phyxx_get_config;
+	sc_phy->activate_card	= phyxx_activate_card;
+}
+
+Device Tree Binding:
+Refer following reference to bind SmartCard PHY with SmartCard
+controller.
+
+	/* SmartCard PHY node */
+	&i2c0 {
+		clock-frequency = <10000000>;
+		phyxx: phyxx@yy {
+			compatible = "xyz,abc";
+			reg = <0xyy>;
+		 };
+	};
+
+	/* SmartCard Controller node*/
+	&usim0 {
+		....
+		phy = <&phyxx>;
+		phy-slots = <1>;
+	};
+
+SmartCard Controller:
+- Access PHY interface using DT.
+Refer below example code
+
+	phy_i2c = of_find_i2c_device_by_node(phy_node);
+	if (phy_i2c == NULL) {
+		ret = -EINVAL;
+	}
+
+	/* get phy interface */
+	sc_phy = (struct sc_phy *)i2c_get_clientdata(phy_i2c);
+
+	/* register notifier */
+	sc_phy->register_notify(sc_phy, &notifier_cb, (void *)data);
+
+
+- Controller can use then after all defined SmartCard PHY interface
diff --git a/include/linux/sc_phy.h b/include/linux/sc_phy.h
new file mode 100644
index 0000000..fb3ad78
--- /dev/null
+++ b/include/linux/sc_phy.h
@@ -0,0 +1,132 @@
+/*
+ * sc_phy.h - Header file for Smart Card PHY operations.
+ * This is a smart card phy's interface to smart card controller.
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SC_PHY_H__
+#define __SC_PHY_H__
+
+#include <linux/notifier.h>
+
+/* defines used in notify action
+ * action will be composed of two part
+ * | 0x0000 | <slot> - 2 bytes| <action>- 2 bytes |
+ */
+#define SC_PHY_NOTIFICATION_ACTION_MASK (0x000000ffU)
+#define SC_PHY_NOTIFICATION_ACTION_SHIFT (0)
+
+#define SC_PHY_NOTIFICATION_SLOT_MASK (0x0000ff00U)
+#define SC_PHY_NOTIFICATION_SLOT_SHIFT (8)
+/*
+ * smart card supply voltage levels
+ */
+enum sc_supply_voltage {
+	SC_PHY_5V = 0,
+	SC_PHY_3V,
+	SC_PHY_1_8V
+};
+
+/*
+ * smarcard type - async or sync
+ */
+enum sc_phy_card_mode {
+	SC_PHY_ASYNC = 0,
+	SC_PHY_SYNC,
+};
+
+/*
+ * phy operational modes
+ */
+enum sc_phy_mode {
+	SC_PHY_ACTIVE = 0,
+	SC_PHY_CLOCKSTOP,
+	SC_PHY_STANDBY,
+	SC_PHY_SHUTDOWN,
+	SC_PHY_REMOVED,
+};
+
+/*
+ * smartcard actions. more actions will be as they gets introduced in upcoming
+ * smart card phys.
+ */
+enum sc_phy_card_action {
+	SC_PHY_CARD_INSERTED	= 0x1,
+	SC_PHY_CARD_REMOVED	= 0x2,
+	SC_PHY_CARD_OVERHEAT	= 0x4,
+	SC_PHY_CARD_ATR_TIMEOUT	= 0x8,
+};
+
+/*
+ * configuration parameters of smart card phy
+ */
+enum sc_phy_config {
+	SC_PHY_VERSION = 0,
+	SC_PHY_CARD_SUPPLY_VOLTAGE,
+	SC_PHY_CARD_PRESENCE,
+	SC_PHY_ATR_MUTE_TIME,
+	SC_PHY_ATR_EARLY_TIME,
+	SC_PHY_CARD_MODE,	/* sync or async mode */
+	SC_PHY_IO,	/* disable or enable i/o line connected to phy */
+	SC_PHY_CLKDIV,	/* clock division for the clock supplied to phy */
+	SC_PHY_MODE,
+	SC_PHY_PIN_CLK,
+	SC_PHY_PIN_RST,
+	SC_PHY_PIN_C4,
+	SC_PHY_PIN_C8
+};
+/**
+ * struct sc_phy - The basic smart card phy structure
+ *
+ * @dev: phy device
+ * @pdata: pointer to phy's private data structure
+ * @set_config: called to set phy's configuration
+ * @get_config: called to get phy's configuration
+ * @activate_card: perform smart card activation
+ * @deactivate_card: perform smart card de-activation
+ * @warm_reset: execute smart card warm reset sequence
+ * @register_card_activity_cb: register call back to phy device.
+ * This call back will be called on card insert or remove event
+ *
+ * smart card controller uses this interface to communicate with
+ * smart card via phy.Some smart card phy has multiple slots for
+ * cards. This inerface also enables controller to communicate with
+ * one or more smart card connected over phy.
+ */
+struct sc_phy {
+	/* phy's device pointer */
+	struct device *dev;
+
+	/* phy's private data */
+	void *pdata;
+
+	/* notify data, passed by interface user as a part of
+	 * register_notify API. Data should be passed back when
+	 * notification raised to the interface user
+	 */
+	void *notify_data;
+
+	int	(*set_config)(struct sc_phy *phy, u8 slot,
+			enum sc_phy_config attr, int value);
+	int	(*get_config)(struct sc_phy *phy, u8 slot, enum
+			sc_phy_config attr);
+	int	(*activate_card)(struct sc_phy *phy, u8 slot);
+	int	(*deactivate_card)(struct sc_phy *phy, u8 slot);
+	int	(*warm_reset)(struct sc_phy *phy, u8 slot);
+	int	(*register_notify)(struct sc_phy *phy,
+			 struct	notifier_block *nb, void *notify_data);
+	int	(*unregister_notify)(struct sc_phy *phy,
+			struct	notifier_block *nb);
+};
+
+#endif /* __SC_PHY_H__ */
-- 
1.7.1

