Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3G2REU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:04:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55014 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab3G2RDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:03:43 -0400
From: Nishanth Menon <nm@ti.com>
To: Benoit Cousson <benoit.cousson@gmail.com>,
        Tony Lindgren <tony@atomide.com>
CC: l-o <linux-omap@vger.kernel.org>, dt list <devicetree@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/3] ARM: dts: omap5-uevm: fix regulator configurations mandatory for SoC
Date: Mon, 29 Jul 2013 12:03:02 -0500
Message-ID: <1375117383-19285-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375117383-19285-1-git-send-email-nm@ti.com>
References: <51F67D7D.9070003@ti.com>
 <1375117383-19285-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e00c27ef3b4c23e39d0a77b7c8e5be44c28001c7
(ARM: dts: OMAP5: Add Palmas MFD node and regulator nodes)
introduced regulator entries for OMAP5uEVM.

However, The regulator information is based on an older temporary
pre-production board variant and does not reflect production board
750-2628-XXX boards.

The following fixes are hence mandatory to ensure right voltage is
supplied to key OMAP5 SoC voltage rails:

- LDO1 supplies VDDAPHY_CAM which is OMAP5's vdda_csiporta/b/c. This
can only be supplied at 1.5V or 1.8V and we currently supply 2.8V.

To prevent any potential device damage risk, use the specified
1.5V-1.8V supply.

Remove 'always-on' and 'boot-on' settings here as it is
a 'on need' supply to SoC IP and is not enabled by PMIC by
default at boot.

- LDO3 supplies Low Latency Interface(LLI) hardware module which is a
special hardware to communicate with Modem. However since uEVM is
not setup by default for this communication, this should be disabled
by default.

Further, vdda_lli is supposed to be 1.5V and not 3V.

- LDO4 supplies VDDAPHY_DISP which is vdda_dsiporta/c/vdda_hdmi

This can only be supplied at 1.5V or 1.8V and we currently
supply 2.2V.

To prevent any potential device damage risk, use the specified
1.5V-1.8V supply.

Remove 'always-on' and 'boot-on' settings here as it is a 'on need'
supply to SoC IP and is not enabled by PMIC by default at boot.

- LDO6 supplies the board specified VDDS_1V2_WKUP supply going to
ldo_emu_wkup/vdds_hsic. To stay within the SoC specification supply
1.2V instead of 1.5V.

- LDO7 supplies VDD_VPP which is vpp1. This is currently configured for
1.5V which as per data manual "A pulse width of 1000 ns and an amplitude
of 2V is required to program each eFuse bit. Otherwise, VPP1 must not
be supplied".

So, fix the voltage to 2V. and disable the supply since we have no plans
of programming efuse bits - it can only be done once - in factory.

Further it is not enabled by default by PMIC so, 'boot-on' must be
removed, and the 'always-on' needs to be removed to achieve pulsing
if efuse needs to be programmed.

- LDO9 supplies the board specified vdds_sdcard supply going within SoC
specification of 1.8V or 3.0V. Further the supply is controlled by
switch enabled by REGEN3. So, introduce REGEN3 and map sdcard slot to
be powered by LDO9. Remove 'always-on' allowing the LDO to be disabled
on need basis.

Reported-by: Marc Jüttner <m-juettner@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: J Keerthy <j-keerthy@ti.com>
---

V2: squash of multiple patches from V1, as suggested in:
	http://marc.info/?l=devicetree&m=137510852731656&w=2

 arch/arm/boot/dts/omap5-uevm.dts |   43 ++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index b430b8f..247c03c 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -235,7 +235,7 @@
 };
 
 &mmc1 {
-	vmmc-supply = <&vmmcsd_fixed>;
+	vmmc-supply = <&ldo9_reg>;
 	bus-width = <4>;
 };
 
@@ -348,10 +348,8 @@
 				ldo1_reg: ldo1 {
 					/* VDDAPHY_CAM: vdda_csiport */
 					regulator-name = "ldo1";
-					regulator-min-microvolt = <2800000>;
-					regulator-max-microvolt = <2800000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1800000>;
 				};
 
 				ldo2_reg: ldo2 {
@@ -366,19 +364,18 @@
 				ldo3_reg: ldo3 {
 					/* VDDAPHY_MDM: vdda_lli */
 					regulator-name = "ldo3";
-					regulator-min-microvolt = <3000000>;
-					regulator-max-microvolt = <3000000>;
-					regulator-always-on;
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
 					regulator-boot-on;
+					/* Only if Modem is used */
+					status = "disabled";
 				};
 
 				ldo4_reg: ldo4 {
 					/* VDDAPHY_DISP: vdda_dsiport/hdmi */
 					regulator-name = "ldo4";
-					regulator-min-microvolt = <2200000>;
-					regulator-max-microvolt = <2200000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1800000>;
 				};
 
 				ldo5_reg: ldo5 {
@@ -393,8 +390,8 @@
 				ldo6_reg: ldo6 {
 					/* VDDS_1V2_WKUP: hsic/ldo_emu_wkup */
 					regulator-name = "ldo6";
-					regulator-min-microvolt = <1500000>;
-					regulator-max-microvolt = <1500000>;
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
 					regulator-boot-on;
 				};
@@ -402,10 +399,10 @@
 				ldo7_reg: ldo7 {
 					/* VDD_VPP: vpp1 */
 					regulator-name = "ldo7";
-					regulator-min-microvolt = <1500000>;
-					regulator-max-microvolt = <1500000>;
-					regulator-always-on;
-					regulator-boot-on;
+					regulator-min-microvolt = <2000000>;
+					regulator-max-microvolt = <2000000>;
+					/* Only for efuse reprograming! */
+					status = "disabled";
 				};
 
 				ldo8_reg: ldo8 {
@@ -421,8 +418,7 @@
 					/* VCC_DV_SDIO: vdds_sdcard */
 					regulator-name = "ldo9";
 					regulator-min-microvolt = <1800000>;
-					regulator-max-microvolt = <3300000>;
-					regulator-always-on;
+					regulator-max-microvolt = <3000000>;
 					regulator-boot-on;
 				};
 
@@ -443,6 +439,13 @@
 					regulator-always-on;
 					regulator-boot-on;
 				};
+
+				regen3_reg: regen3 {
+					/* REGEN3 controls LDO9 supply to card */
+					regulator-name = "regen3";
+					regulator-always-on;
+					regulator-boot-on;
+				};
 			};
 		};
 	};
-- 
1.7.9.5

