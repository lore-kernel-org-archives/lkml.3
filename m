Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaJUOrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:47:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47522 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaJUOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:47:35 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
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
Subject: [PATCH v2 04/12] of: document new emc-timings subnode in nvidia,tegra124-car
Date: Tue, 21 Oct 2014 16:45:36 +0200
Message-Id: <1413902788-7727-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMC clock needs some extra information for changing its rate.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 .../bindings/clock/nvidia,tegra124-car.txt         | 46 +++++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
index ded5d62..42e0588 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
@@ -19,12 +19,35 @@ Required properties :
   In clock consumers, this cell represents the bit number in the CAR's
   array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
 
+The node should contain a "emc-timings" subnode for each supported RAM type (see
+field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address being its
+RAM_CODE.
+
+Required properties for "emc-timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
+  is used for.
+
+Each "emc-timings" node should contain a "timing" subnode for every supported
+EMC clock rate. The "timing" subnodes should have the clock rate in Hz as their
+unit address.
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
+	tegra_car: clock@0,60006000 {
 		compatible = "nvidia,tegra124-car";
-		reg = <0x60006000 0x1000>;
+		reg = <0x0 0x60006000 0x0 0x1000>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
 	};
@@ -60,4 +83,23 @@ Example board file:
 	&tegra_car {
 		clocks = <&clk_32k> <&osc>;
 	};
+
+	clock@0,60006000 {
+		emc-timings@3 {
+			nvidia,ram-code = <3>;
+
+			timing@12750000 {
+				clock-frequency = <12750000>;
+				nvidia,parent-clock-frequency = <408000000>;
+				clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
+				clock-names = "emc-parent";
+			};
+			timing@20400000 {
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

