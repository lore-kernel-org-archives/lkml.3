Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3HAPQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:16:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10859 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3HAPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:16:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Aug 2013 08:14:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <pawel.moll@arm.com>, <Mark.Rutland@arm.com>,
        <ian.campbell@citrix.com>, <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3] drivers/rtc/rtc-palmas.c: support for backup battery charging
Date: Thu, 1 Aug 2013 20:58:51 +0530
Message-ID: <1375370931-2194-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas series device like TPS65913, TPS80036 supports the backup battery
for powering the RTC when no other energy source is available.

The backup battery is optional, connected to the VBACKUP pin, and can be
nonrechargeable or rechargeable. The rechargeable battery can be charged
from the system supply using the backup battery charger.

Add support for enabling charging of this backup battery.  Also add the DT
binding document and the new properties to have this support.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Converted DT property to boolean.
- cleanups as use "...".

Changes from V2:
- Change the property name "ti,back-charge-low-current" to
  "ti,back-battery-charge-low-current"

 .../devicetree/bindings/rtc/rtc-palmas.txt         |   29 ++++++++++++++++
 drivers/rtc/rtc-palmas.c                           |   35 ++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-palmas.txt

diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
new file mode 100644
index 0000000..4f930b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
@@ -0,0 +1,29 @@
+Palmas RTC controller bindings
+
+Required properties:
+- compatible:
+  - "ti,palmas-rtc" for palma series of the RTC controller
+- interrupt-parent: Parent interrupt device, must be handle of palmas node.
+- interrupts: Interrupt number of RTC submodule on device.
+
+Optional properties:
+- ti,back-battery-charge-enable: The palmas series device like TPS65913 or
+	TPS80036 supports the battery backup for powering the RTC when main
+	battery is removed or in very low power state. This flag will enable
+	the backup battery charging.
+- ti,back-battery-charge-low-current: Configure lower charging current. Device
+	supports the charging current as < 100mA or >100mA. Low current will
+	set as <100mA.
+
+Example:
+	palmas: tps65913@58 {
+		...
+		palmas_rtc: rtc {
+			compatible = "ti,palmas-rtc";
+			interrupt-parent = <&palmas>;
+			interrupts = <8 0>;
+			ti,back-battery-charge-enable;
+			ti,back-battery-charge-low-current;
+		};
+		...
+	};
diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index a1fecc8..adb6e71 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -238,6 +238,15 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_rtc *palmas_rtc = NULL;
 	int ret;
+	bool enable_bb_charging = false;
+	bool low_bb_charging;
+
+	if (pdev->dev.of_node) {
+		enable_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,back-battery-charge-enable");
+		low_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,back-battery-charge-low-current");
+	}
 
 	palmas_rtc = devm_kzalloc(&pdev->dev, sizeof(struct palmas_rtc),
 			GFP_KERNEL);
@@ -254,6 +263,32 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 	palmas_rtc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, palmas_rtc);
 
+	if (enable_bb_charging) {
+		unsigned reg = 0;
+
+		if (low_bb_charging)
+			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
+
+		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+			PALMAS_BACKUP_BATTERY_CTRL,
+			PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG, reg);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
+			return ret;
+		}
+
+		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+			PALMAS_BACKUP_BATTERY_CTRL,
+			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN,
+			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
+			return ret;
+		}
+	}
+
 	/* Start RTC */
 	ret = palmas_update_bits(palmas, PALMAS_RTC_BASE, PALMAS_RTC_CTRL_REG,
 			PALMAS_RTC_CTRL_REG_STOP_RTC,
-- 
1.7.1.1

