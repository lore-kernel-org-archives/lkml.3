Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaKCPfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:35:15 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42128 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaKCPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:35:03 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 3/9] PM / Domains: Add DT bindings for the R-Mobile System Controller
Date: Mon,  3 Nov 2014 16:34:50 +0100
Message-Id: <1415028896-9005-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
References: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Renesas R-Mobile System Controller provides a.o. power management
support, following the generic PM domain bindings in
Documentation/devicetree/bindings/power/power_domain.txt.

For now this supports the R-Mobile A1 (r8a7740) only, but it should be
sufficiently generic to handle other members of the SH-Mobile/R-Mobile
family in the future.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v4:
  - Drop device save/restore state latencies, as they're Linux driver-specific,
  - Drop PM QoS device latencies, as they're put on hold,
v3:
  - Reword,
v2:
  - Fix copy-and-paste s/#address-cells/#size-cells/,
  - Add optional PM QoS device latencies.
---
 .../bindings/power/renesas,sysc-rmobile.txt        | 107 +++++++++++++++++++++
 1 file changed, 107 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt

diff --git a/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
new file mode 100644
index 0000000000000000..89ca3f35aec69750
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
@@ -0,0 +1,107 @@
+DT bindings for the Renesas R-Mobile System Controller
+
+== System Controller Node ==
+
+The R-Mobile System Controller provides the following functions:
+  - Boot mode management,
+  - Reset generation,
+  - Power management.
+
+Required properties:
+- compatible: Should be "renesas,sysc-<soctype>", "renesas,sysc-rmobile" as
+	      fallback.
+	      Examples with soctypes are:
+		- "renesas,sysc-r8a7740" (R-Mobile A1)
+- reg: Two address start and address range blocks for the device:
+         - The first block refers to the normally accessible registers,
+         - the second block refers to the registers protected by the HPB
+	   semaphore.
+
+Optional nodes:
+- pm-domains: This node contains a hierarchy of PM domain nodes, which should
+  match the Power Area Hierarchy in the Power Domain Specifications section of
+  the device's datasheet.
+
+
+== PM Domain Nodes ==
+
+Each of the PM domain nodes represents a PM domain, as documented by the
+generic PM domain bindings in
+Documentation/devicetree/bindings/power/power_domain.txt.
+
+The nodes should be named by the real power area names, and thus their names
+should be unique.
+
+Required properties:
+  - #power-domain-cells: Must be 0.
+
+Optional properties:
+- reg: If the PM domain is not always-on, this property must contain the bit
+       index number for the corresponding power area in the various Power
+       Control and Status Registers. The parent's node must contain the
+       following two properties:
+	 - #address-cells: Must be 1,
+	 - #size-cells: Must be 0.
+       If the PM domain is always-on, this property must be omitted.
+- power-on-latency: Power-on latency of the PM domain, in ns,
+- power-off-latency: Power-off latency of the PM domain, in ns.
+
+
+Example:
+
+This shows a subset of the r8a7740 PM domain hierarchy, containing the
+C5 "always-on" domain, 2 of its subdomains (A4S and A4SU), and the A3SP domain,
+which is a subdomain of A4S.
+
+	sysc: system-controller@e6180000 {
+		compatible = "renesas,sysc-r8a7740", "renesas,sysc-rmobile";
+		reg = <0xe6180000 8000>, <0xe6188000 8000>;
+
+		pm-domains {
+			pd_c5: c5 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#power-domain-cells = <0>;
+
+				pd_a4s: a4s@10 {
+					reg = <10>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
+
+					pd_a3sp: a3sp@11 {
+						reg = <11>;
+						#power-domain-cells = <0>;
+						power-on-latency = <250000>;
+						power-off-latency = <250000>;
+					};
+				};
+
+				pd_a4su: a4su@20 {
+					reg = <20>;
+					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
+				};
+			};
+		};
+	};
+
+
+== PM Domain Consumers ==
+
+Hardware blocks belonging to a PM domain should contain a "power-domains"
+property that is a phandle pointing to the corresponding PM domain node,
+and optional PM QoS device latencies:
+
+Example:
+
+	tpu: pwm@e6600000 {
+		compatible = "renesas,tpu-r8a7740", "renesas,tpu";
+		reg = <0xe6600000 0x100>;
+		clocks = <&mstp3_clks R8A7740_CLK_TPU0>;
+		power-domains = <&pd_a3sp>;
+		#pwm-cells = <3>;
+	};
-- 
1.9.1

