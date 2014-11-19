Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaKSWbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:31:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbaKSUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 035/141] mfd: twl4030-power: Fix poweroff with PM configuration enabled
Date: Wed, 19 Nov 2014 12:50:58 -0800
Message-Id: <20141119205151.804349493@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 481c7f868c6d855f31a29c69b445ac4aee9625a6 upstream.

Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
configuration") enabled configuring the PM features for twl4030.

This caused poweroff command to fail on devices that have the
BCI charger on twl4030 wired, or have power wired for VBUS.
Instead of powering off, the device reboots. This is because
voltage is detected on charger or VBUS with the default bits
enabled for the power transition registers.

To fix the issue, let's just clear VBUS and CHG bits as we want
poweroff command to keep the system powered off.

Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/twl4030-power.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -44,6 +44,15 @@ static u8 twl4030_start_script_address =
 #define PWR_DEVSLP		BIT(1)
 #define PWR_DEVOFF		BIT(0)
 
+/* Register bits for CFG_P1_TRANSITION (also for P2 and P3) */
+#define STARTON_SWBUG		BIT(7)	/* Start on watchdog */
+#define STARTON_VBUS		BIT(5)	/* Start on VBUS */
+#define STARTON_VBAT		BIT(4)	/* Start on battery insert */
+#define STARTON_RTC		BIT(3)	/* Start on RTC */
+#define STARTON_USB		BIT(2)	/* Start on USB host */
+#define STARTON_CHG		BIT(1)	/* Start on charger */
+#define STARTON_PWON		BIT(0)	/* Start on PWRON button */
+
 #define SEQ_OFFSYNC		(1 << 0)
 
 #define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
@@ -606,6 +615,44 @@ twl4030_power_configure_resources(const
 	return 0;
 }
 
+static int twl4030_starton_mask_and_set(u8 bitmask, u8 bitvalues)
+{
+	u8 regs[3] = { TWL4030_PM_MASTER_CFG_P1_TRANSITION,
+		       TWL4030_PM_MASTER_CFG_P2_TRANSITION,
+		       TWL4030_PM_MASTER_CFG_P3_TRANSITION, };
+	u8 val;
+	int i, err;
+
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
+	if (err)
+		goto relock;
+	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
+			       TWL4030_PM_MASTER_KEY_CFG2,
+			       TWL4030_PM_MASTER_PROTECT_KEY);
+	if (err)
+		goto relock;
+
+	for (i = 0; i < sizeof(regs); i++) {
+		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER,
+				      &val, regs[i]);
+		if (err)
+			break;
+		val = (~bitmask & val) | (bitmask & bitvalues);
+		err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
+				       val, regs[i]);
+		if (err)
+			break;
+	}
+
+	if (err)
+		pr_err("TWL4030 Register access failed: %i\n", err);
+
+relock:
+	return twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
+				TWL4030_PM_MASTER_PROTECT_KEY);
+}
+
 /*
  * In master mode, start the power off sequence.
  * After a successful execution, TWL shuts down the power to the SoC
@@ -615,6 +662,11 @@ void twl4030_power_off(void)
 {
 	int err;
 
+	/* Disable start on charger or VBUS as it can break poweroff */
+	err = twl4030_starton_mask_and_set(STARTON_VBUS | STARTON_CHG, 0);
+	if (err)
+		pr_err("TWL4030 Unable to configure start-up\n");
+
 	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, PWR_DEVOFF,
 			       TWL4030_PM_MASTER_P1_SW_EVENTS);
 	if (err)


