Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3EPXCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:02:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39315 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3EPXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:02:16 -0400
Message-ID: <51956574.5070206@wwwdotorg.org>
Date: Thu, 16 May 2013 17:02:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4 3/8] ARM: tegra: update device trees for USB binding
 rework
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com> <1368713582-29038-4-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1368713582-29038-4-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 08:12 AM, Venu Byravarasu wrote:
> This patch updates all Tegra board files so that they contain all the
> properties required by the updated USB DT binding. Note that this patch
> only adds the new properties and does not yet remove the old properties,
> in order to maintain bisectability. The old properties will be removed
> once the driver has been updated to assume the new bindings.

This series looks almost OK now. The one remaining issue is that in this
patch, the regulator-name properties don't match the schematics, and in
the Whistler patch below, both regulators you added have the same
regulator-name, which causes problems.

To fix this, when I apply this patch, I'm going to fold in the patch
I'll paste below.

Right now, I can't get Whistler to see the SD card. This is true even
without your patches. Once I've resolved that and tested Whistler,
assuming no more problems, I'll apply patches 1-3 to the Tegra tree, and
set up a branch that can be pulled into the USB tree so the rest of the
series can be applied there.

diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts
b/arch/arm/boot/dts/tegra20-seaboard.dts
index b832088..009dafe 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -822,7 +822,7 @@
 		vbus_reg: regulator@3 {
 			compatible = "regulator-fixed";
 			reg = <3>;
-			regulator-name = "vdd_5v0";
+			regulator-name = "vdd_vbus_wup1";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			gpio = <&gpio 24 0>; /* PD0 */
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts
b/arch/arm/boot/dts/tegra20-trimslice.dts
index d9b58cd..0e65c00e 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -404,7 +404,7 @@
 		vbus_reg: regulator@2 {
 			compatible = "regulator-fixed";
 			reg = <2>;
-			regulator-name = "vdd_5v0";
+			regulator-name = "usb1_vbus";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			gpio = <&gpio 170 0>; /* PV2 */
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts
b/arch/arm/boot/dts/tegra20-whistler.dts
index e405c2f..3c24c9b 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -513,7 +513,7 @@

 	usb-phy@c5000000 {
 		status = "okay";
-		vbus-supply = <&vbus_reg1>;
+		vbus-supply = <&vbus1_reg>;
 	};

 	usb@c5008000 {
@@ -523,7 +523,7 @@

 	usb-phy@c5008000 {
 		status = "okay";
-		vbus-supply = <&vbus_reg2>;
+		vbus-supply = <&vbus3_reg>;
 	};

 	sdhci@c8000400 {
@@ -579,19 +579,19 @@
 			regulator-always-on;
 		};

-		vbus_reg1: regulator@2 {
+		vbus1_reg: regulator@2 {
 			compatible = "regulator-fixed";
 			reg = <2>;
-			regulator-name = "vdd_5v0";
+			regulator-name = "vbus1";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			gpio = <&tca6416 0 0>; /* GPIO_PMU0 */
 		};

-		vbus_reg2: regulator@3 {
+		vbus3_reg: regulator@3 {
 			compatible = "regulator-fixed";
 			reg = <3>;
-			regulator-name = "vdd_5v0";
+			regulator-name = "vbus3";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			gpio = <&tca6416 1 0>; /* GPIO_PMU1 */
-- 
1.7.10.4
