Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbbAFQpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:45:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62073 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbAFQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:45:45 -0500
From: mathieu.poirier@linaro.org
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH] ARM: vexpress: bindings: Add generic PD awareness to the spc controller
Date: Tue,  6 Jan 2015 09:45:32 -0700
Message-Id: <1420562732-4353-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Among other things, the serial power controller (SPC) controls power to
the A7 and A15 clusters.  Theses clusters also happen to contains the
coresight tracers used for HW assisted tracing.

By modellling these to power domains in a way that is comprehensible to
the generic power domain sub-system and using the runtime PM API in the
coresight drivers, we can prevent power to the domains from being
turned off while tracing related operations are still pending.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../bindings/arm/vexpress-power-controller.txt     | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/vexpress-power-controller.txt

diff --git a/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
new file mode 100644
index 000000000000..3af5624dc5cb
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
@@ -0,0 +1,54 @@
+ARM Versatile Express Power Controller
+--------------------------------------
+
+This binding models the serial power controller (SPC) in a way that is
+intelligible to the generic power domain subsystem and in accordance
+with the guidelines from:
+
+Documentation/devicetree/bindings/power/power_domain.txt
+
+The binding doesn't have a '<reg>' property as the base address for HW
+access is provided by the vexpress-scc sub-system.
+
+Required node properties:
+- compatible value : = "arm,vexpress-power-controller";
+- #power-domain-cells : = Number of cells in a PM domain specifier, as
+  specified in "power_domain.txt" referenced above.
+
+Example:
+	A7_A15_cluster_pd: A7-A15-cluster-pd {
+		compatible = "arm,vexpress-power-controller";
+		#power-domain-cells = <1>;
+        };
+
+	....
+
+	ptm@0,2201d000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2201d000 0 0x1000>;
+
+		cpu = <&cpu1>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 0>;
+		port {
+			ptm1_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port1>;
+			};
+		};
+	};
+
+	etm@0,2203c000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2203c000 0 0x1000>;
+
+		cpu = <&cpu2>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 1>;
+		port {
+			etm0_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port2>;
+			};
+		};
+	};
-- 
1.9.1

