Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967958Ab3HIPdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:33:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2652 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056Ab3HIPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:33:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 09 Aug 2013 08:33:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <pawel.moll@arm.com>, <Mark.Rutland@arm.com>,
        <ian.campbell@citrix.com>, <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] drivers/rtc/rtc-palmas.c: rename charging dt property name
Date: Fri, 9 Aug 2013 21:17:10 +0530
Message-ID: <1376063230-22578-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming the charging property names to have more meaningful:

Renaming property "ti,back-battery-charge-enable" to "ti,backup-battery-chargeable"
to tells OS that attahced battery is chargeable and OS can do charging.

Renaming property "ti,back-battery-charge-low-current" to
"ti,backup-battery-charge-high-current" for safe configuration as maximum charging current
of battery depends on battery type and overcurrent charging can damage the battery. So
enable the high current charging only if this property is available.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The patch V4 version of the change
[PATCH V4] drivers/rtc/rtc-palmas.c: support for backup battery charging
is already applied but still the discussion is going on the property name.

To correct the property name, I am sending this patch on top of above patch
as per discussion on above patch.

 .../devicetree/bindings/rtc/rtc-palmas.txt         |   21 +++++++++++--------
 drivers/rtc/rtc-palmas.c                           |   14 ++++++------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
index 41bb445..8ef7660 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
@@ -7,13 +7,16 @@ Required properties:
 - interrupts: Interrupt number of RTC submodule on device.
 
 Optional properties:
-- ti,back-battery-charge-enable: The Palmas series device like TPS65913 or
-	TPS80036 supports the battery backup for powering the RTC when main
-	battery is removed or in very low power state. This flag will enable
-	the backup battery charging.
-- ti,back-battery-charge-low-current: Configure lower charging current. Device
-	supports the charging current as < 100mA or >100mA. Low current will
-	set as <100mA.
+- ti,backup-battery-chargeable: The Palmas series device like TPS65913 or
+	TPS80036 supports the backup battery for powering the RTC when main
+	battery is removed or in very low power state. The backup battery
+	can be chargeable or non-chargeable. This flag will tells whether
+	battery is chargeable or not. If charging battery then driver can
+	enable the charging.
+- ti,backup-battery-charge-high-current: Enable high current charging in
+	backup battery. Device supports the < 100mA and > 100mA charging.
+	The high current will be > 100mA. Absence of this property will
+	charge battery to lower current i.e. < 100mA.
 
 Example:
 	palmas: tps65913@58 {
@@ -22,8 +25,8 @@ Example:
 			compatible = "ti,palmas-rtc";
 			interrupt-parent = <&palmas>;
 			interrupts = <8 0>;
-			ti,back-battery-charge-enable;
-			ti,back-battery-charge-low-current;
+			ti,backup-battery-chargeable;
+			ti,backup-battery-charge-high-current;
 		};
 		...
 	};
diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index adb6e71..fffb7d3 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -239,13 +239,13 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 	struct palmas_rtc *palmas_rtc = NULL;
 	int ret;
 	bool enable_bb_charging = false;
-	bool low_bb_charging;
+	bool high_bb_charging;
 
 	if (pdev->dev.of_node) {
 		enable_bb_charging = of_property_read_bool(pdev->dev.of_node,
-					"ti,back-battery-charge-enable");
-		low_bb_charging = of_property_read_bool(pdev->dev.of_node,
-					"ti,back-battery-charge-low-current");
+					"ti,backup-battery-chargeable");
+		high_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,backup-battery-charge-high-current");
 	}
 
 	palmas_rtc = devm_kzalloc(&pdev->dev, sizeof(struct palmas_rtc),
@@ -264,10 +264,10 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, palmas_rtc);
 
 	if (enable_bb_charging) {
-		unsigned reg = 0;
+		unsigned reg = PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
 
-		if (low_bb_charging)
-			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
+		if (high_bb_charging)
+			reg = 0;
 
 		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
 			PALMAS_BACKUP_BATTERY_CTRL,
-- 
1.7.1.1

