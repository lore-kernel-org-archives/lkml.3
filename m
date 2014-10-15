Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJOQVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:21:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33563 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaJOQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:21:05 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 7/9] regulator: max77802: Document regulator opmode DT properties
Date: Wed, 15 Oct 2014 18:20:37 +0200
Message-Id: <1413390039-19364-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators from the max77802 PMIC support to be configured in one
of two operating mode: Output ON (normal) and Output On Low Power Mode.
Not all regulators support these two modes and for some of them, the
mode can be changed while the system is running in normal operation
while others only support their mode to be changed on system suspend.

Extend the max77802 PMIC binding adding Device Tree properties so the
regulators operating modes can be configured.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 .../devicetree/bindings/regulator/max77802.txt     | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/max77802.txt b/Documentation/devicetree/bindings/regulator/max77802.txt
index 5aeaffc..34812e0 100644
--- a/Documentation/devicetree/bindings/regulator/max77802.txt
+++ b/Documentation/devicetree/bindings/regulator/max77802.txt
@@ -25,6 +25,39 @@ with their hardware counterparts as follow. The valid names are:
 			example: LDO1, LDO2, LDO35.
 	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 10.
 			example: BUCK1, BUCK5, BUCK10.
+
+Besides the standard regulator constraints, the max77802 regulator supports
+two different operating modes: Normal and Low Power Mode. Some regulators
+support the modes to be changed at startup or by the consumers during normal
+operation while others only support to change the mode during system suspend.
+The following optional properties can be used to configure the operating modes:
+
+- maxim,regulator-initial-mode: initial operating mode.
+  This property can only be used on regulators that support changing their mode
+  during normal operation. These regulators are LDO1, LDO3, LDO20 and LDO21.
+- maxim,regulator-disk-mode: operating mode for the regulator when the system
+  enters in the Suspend-to-Disk state.
+- maxim,regulator-mem-mode: operating mode for the regulator when the system
+  enters in the Suspend-to-RAM state.
+
+The value for maxim,regulator-[initial,disk,mem]-mode is one of the following:
+	1: Normal regulator voltage output mode.
+	3: Low Power which reduces the quiescent current down to only 1uA
+
+The list of valid modes are defined in the dt-bindings/regulator/regulator.h
+header and can be included by device tree source files. If no mode is defined,
+then the OS will not manage the modes and the HW default values will be used.
+
+The maxim,regulator-[initial,disk,mem]-mode properties can only be used with
+regulators that support changing their mode to Low Power Mode during suspend.
+These regulators are BUCKs 2-4 and LDOs 1-35.
+
+The maxim,regulator-[disk,mem]-mode property only takes effect if the regulator
+has been marked as enabled for the given suspend mode using the standard
+"regulator-on-in-suspend" property. If the regulator has not been explicitly
+enabled or if it was marked as disabled with "regulator-off-in-suspend", then
+setting the operating mode for that state will have no effect.
+
 Example:
 
 	max77802@09 {
@@ -36,11 +69,23 @@ Example:
 		#size-cells = <0>;
 
 		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "vdd_1v0";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				maxim,regulator-initial-mode = <MAX77802_OPMODE_LP>;
+			};
+
 			ldo11_reg: LDO11 {
 				regulator-name = "vdd_ldo11";
 				regulator-min-microvolt = <1900000>;
 				regulator-max-microvolt = <1900000>;
 				regulator-always-on;
+				maxim,regulator-mem-mode = <MAX77802_OPMODE_LP>;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck1_reg: BUCK1 {
-- 
2.1.0

