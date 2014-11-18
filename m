Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaKRMXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:23:01 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53806 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaKRMW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:22:57 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/14] of: document new emc-timings subnode in nvidia,tegra124-car
Date: Tue, 18 Nov 2014 13:13:06 +0100
Message-Id: <1416312860-4446-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMC clock needs some extra information for changing its rate.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v5:	* Remove constraint on the unit-address of the timings and timing subnodes

v4:	* Remove comma from unit-address of CAR node in the example
	* Simplify reg property value in the example
---
 .../bindings/clock/nvidia,tegra124-car.txt         | 42 +++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
index ded5d62..2197ffd 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
@@ -19,10 +19,31 @@ Required properties :
   In clock consumers, this cell represents the bit number in the CAR's
   array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
 
+The node should contain a "emc-timings" subnode for each supported RAM type (see
+field RAM_CODE in register PMC_STRAPPING_OPT_A).
+
+Required properties for "emc-timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
+  is used for.
+
+Each "emc-timings" node should contain a "timing" subnode for every supported
+EMC clock rate.
+
+Required properties for "timing" nodes :
+- clock-frequency : Should contain the memory clock rate to which this timing
+relates.
+- nvidia,parent-clock-frequency : Should contain the rate at which the current
+parent of the EMC clock should be running at this timing.
+- clocks : Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names : Must include the following entries:
+  - emc-parent : the clock that should be the parent of the EMC clock at this
+timing.
+
 Example SoC include file:
 
 / {
-	tegra_car: clock {
+	tegra_car: clock@60006000 {
 		compatible = "nvidia,tegra124-car";
 		reg = <0x60006000 0x1000>;
 		#clock-cells = <1>;
@@ -60,4 +81,23 @@ Example board file:
 	&tegra_car {
 		clocks = <&clk_32k> <&osc>;
 	};
+
+	clock@60006000 {
+		emc-timings-3 {
+			nvidia,ram-code = <3>;
+
+			timing-12750000 {
+				clock-frequency = <12750000>;
+				nvidia,parent-clock-frequency = <408000000>;
+				clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
+				clock-names = "emc-parent";
+			};
+			timing-20400000 {
+				clock-frequency = <20400000>;
+				nvidia,parent-clock-frequency = <408000000>;
+				clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
+				clock-names = "emc-parent";
+			};
+		};
+	};
 };
-- 
1.9.3

