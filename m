Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaGAP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:28:43 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59123 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaGAP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:28:41 -0400
From: Alex Elder <elder@linaro.org>
To: devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lorenzo.pieralisi@arm.com,
        gregory.clement@free-electrons.com, rvaswani@codeaurora.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 RESEND] devicetree: bindings: separate CPU enable method descriptions
Date: Tue,  1 Jul 2014 10:28:36 -0500
Message-Id: <1404228516-14620-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings for CPU enable methods are defined in ".../arm/cpus.txt".  As
additional 32-bit ARM CPUS are converted to use the "enable-method" CPU
property to imply a particular set of SMP operations to use, the list of these
methods is likely to become unwieldy.  The current documentation already
contains several property descriptions that are meaningful only for certain
enable methods.

This patch defines a new Documentation subdirectory whose purpose is to give
each CPU enable method its own place to define how and when it's used, as
well as what other properties (optional or required) are associated with
the method.  The existing enable method documentation is expanded and moved
from ".../arm/cpus.txt" into new files accordingly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v4  - Rebased on top of v3.16-rc1.
    - Added description files for recently-added enable methods:
        "allwinner,sun6i-a31"
        "marvell,armada-375-smp"
        "marvell,armada-380-smp"
        "marvell,armada-xp-smp"
        "rockchip,rk3066-smp"
    - Updated "psci.txt" with a 32-bit ARM example.
v3  - Got rid of contrived examples.
    - Identified some compatible CPUs more generically (e.g. using
      "Any AArch64 CPU") rather than using only specific compatible
      string values.
    - Fixed and reworded the "psci" description (without incorporating 
      "arm/psci.txt").
    - Now provide a more real example for the "spin-table" method.
v2  - Rename "arm,psci.txt" to be "psci.txt" and fix its content.

 .../bindings/arm/cpu-enable-method/README          | 20 +++++++
 .../arm/cpu-enable-method/allwinner,sun6i-a31      | 44 +++++++++++++++
 .../arm/cpu-enable-method/marvell,armada-xp-smp    | 34 +++++++++++
 .../arm/cpu-enable-method/marvell,armada375-smp    | 31 +++++++++++
 .../arm/cpu-enable-method/marvell,armada380-smp    | 32 +++++++++++
 .../bindings/arm/cpu-enable-method/psci.txt        | 65 ++++++++++++++++++++++
 .../arm/cpu-enable-method/qcom,gcc-msm8660         | 42 ++++++++++++++
 .../arm/cpu-enable-method/qcom,kpss-acc-v1         | 56 +++++++++++++++++++
 .../arm/cpu-enable-method/qcom,kpss-acc-v2         | 56 +++++++++++++++++++
 .../arm/cpu-enable-method/rockchip,rk3066-smp      | 32 +++++++++++
 .../bindings/arm/cpu-enable-method/spin-table.txt  | 55 ++++++++++++++++++
 Documentation/devicetree/bindings/arm/cpus.txt     | 29 +---------
 12 files changed, 470 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/README
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/allwinner,sun6i-a31
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada-xp-smp
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada375-smp
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada380-smp
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/rockchip,rk3066-smp
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt

diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/README b/Documentation/devicetree/bindings/arm/cpu-enable-method/README
new file mode 100644
index 0000000..cc9431e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/README
@@ -0,0 +1,20 @@
+==========================
+CPU enable-method bindings
+==========================
+
+The device tree describes the layout of CPUs in a machine in a single "cpus"
+node, which in turn contains a number of "cpu" sub-nodes defining properties
+for each cpu.
+
+For multiprocessing configurations, CPU cores can be individually enabled
+and disabled.  The enabling capability is used for SMP startup as well as
+CPU hotplug.  A CPU enable method--normally specified in the device tree
+using an "enable-method" property--defines how cores are enabled.  If all
+CPUs in a machine use the same enable method and related property values,
+these properties should be defined in the "cpus" node, which associates the
+property values with all CPUs.  Alternatively, every "cpu" node can define
+its "enable-method" separately.
+
+Documents in this directory define how each of the CPU enable methods are to
+be used, as well the names and possible values of related properties that
+are required by or affect each enable method.
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/allwinner,sun6i-a31 b/Documentation/devicetree/bindings/arm/cpu-enable-method/allwinner,sun6i-a31
new file mode 100644
index 0000000..bbc661e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/allwinner,sun6i-a31
@@ -0,0 +1,44 @@
+=========================================================
+Secondary CPU enable-method "allwinner,sun6i-a31" binding
+=========================================================
+
+This document describes the "allwinner,sun6i-a31" method for enabling
+CPUs.  This enable method should be used in the "cpus" node, but can
+also be defined in individual "cpu" nodes.
+
+Enable method name:	"allwinner,sun6i-a31"
+Compatible machine:	"sun6i-a31"
+Compatible cpu:		"arm,cortex-a7"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		enable-method = "allwinner,sun6i-a31";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <1>;
+		};
+
+		cpu@2 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <2>;
+		};
+
+		cpu@3 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <3>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada-xp-smp b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada-xp-smp
new file mode 100644
index 0000000..4a21b54
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada-xp-smp
@@ -0,0 +1,34 @@
+===========================================================
+Secondary CPU enable-method "marvell,armada-xp-smp" binding
+===========================================================
+
+This document describes the "marvell,armada-xp-smp" method for enabling
+CPUs.  This enable method should be used in the "cpus" node, but can
+also be defined in individual "cpu" nodes.
+
+Enable method name:	"marvell,armada-xp-smp"
+Compatible machines:	"marvell,armadaxp-mv78230"
+			"marvell,armadaxp-mv78260
+			"marvell,armadaxp-mv78460"
+Compatible cpu:		"marvell,sheeva-v7"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "marvell,armada-xp-smp";
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <1>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada375-smp b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada375-smp
new file mode 100644
index 0000000..a3fa89f
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada375-smp
@@ -0,0 +1,31 @@
+============================================================
+Secondary CPU enable-method "marvell,armada-375-smp" binding
+============================================================
+
+This document describes the "marvell,armada-375-smp" method for enabling
+CPUs.  This enable method should be used in the "cpus" node, but can
+also be defined in individual "cpu" nodes.
+
+Enable method name:	"marvell,armada-375-smp"
+Compatible machine:	"marvell,armada375"
+Compatible cpu:		"arm,cortex-a9"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "marvell,armada-375-smp";
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada380-smp b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada380-smp
new file mode 100644
index 0000000..dff225d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,armada380-smp
@@ -0,0 +1,32 @@
+===========================================================
+Secondary CPU enable-method "marvell,armada380-smp" binding
+===========================================================
+
+This document describes the "marvell,armada380-smp" method for enabling
+CPUs.  This enable method should be used in the "cpus" node, but can
+also be defined in individual "cpu" nodes.
+
+Enable method name:	"marvell,armada-380-smp"
+Compatible machine:	"marvell,armada380"
+			"marvell,armada385"
+Compatible cpu:		"arm,cortex-a9"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "marvell,armada-380-smp";
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
new file mode 100644
index 0000000..c85b888
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
@@ -0,0 +1,65 @@
+================================
+CPU enable-method "psci" binding
+================================
+
+This document describes the "psci" method for enabling secondary CPUs.
+Unlike most secondary CPU enable methods, this method is not defined
+by properties in CPU-related device tree nodes.  Instead, a "psci"
+node[1] that includes a "cpu_on" property defines how secondary CPUs
+are enabled.
+
+Enable method name:	"psci"
+Compatible cpus:	32- or 64-bit ARM architectures, including
+			Cortex-A7, Cortex-A15, Cortex-A53, Cortex-A57
+			as well as AEM.
+Related properties:	(none)
+
+Example 1:
+
+	psci {
+		compatible = "arm,psci";
+		method = "smc";
+		cpu_on = <0x1>;
+	};
+	cpus {
+		#size-cells = <0>;
+		#address-cells = <2>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x1>;
+		};
+	};
+
+Example 2:
+	psci {
+		compatible      = "arm,psci";
+		method          = "hvc";
+		cpu_on          = <2>;
+	};
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <1>;
+		};
+	};
+
+--
+[1] arm/psci.txt
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
new file mode 100644
index 0000000..fee9782
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
@@ -0,0 +1,42 @@
+======================================================
+Secondary CPU enable-method "qcom,gcc-msm8660" binding
+======================================================
+
+This document describes the "qcom,gcc-msm8660" method for enabling
+secondary CPUs.  A "qcom,gcc-msm8660" enable method should only be
+used in the "cpus" node--to apply to all CPUs--but it can also be
+defined in individual CPU nodes.
+
+Note that a node compatible with "qcom,gcc-msm8660" must also be
+present in the device tree, to define a memory range that contains
+registers used to control the secondary core.
+
+Enable method name:	"qcom,gcc-msm8660"
+Compatible cpu:		"qcom,scorpion"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "qcom,scorpion";
+			enable-method = "qcom,gcc-msm8660";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "qcom,scorpion";
+			enable-method = "qcom,gcc-msm8660";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	gcc: clock-controller@900000 {
+		compatible = "qcom,gcc-msm8660";
+		reg = <0x900000 0x4000>;
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
new file mode 100644
index 0000000..3f6ce56
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
@@ -0,0 +1,56 @@
+======================================================
+Secondary CPU enable-method "qcom,kpss-acc-v1" binding
+======================================================
+
+This document describes the "qcom,kpss-acc-v1" method for enabling CPUs.
+This enable method can be used in either the "cpus" node or in individual
+"cpu" nodes.  Note that each "cpu" node must have both "qcom,saw" and
+"qcom,acc" properties defined (even if the "enable-method" property was
+defined only in the "cpus" node).
+
+Enable method name:	"qcom,kpss-acc-v1"
+Compatible machine:	"qcom,msm8960"
+Compatible cpu:		"qcom,krait"
+Related properties:
+	- qcom,saw
+		Usage:		required (in each "cpu" node")
+		Value type:	<phandle>
+		Definition:
+			Specifies the SAW[1] node associated with this CPU.
+
+	- qcom,acc
+		Usage:		required (in each "cpu" node")
+		Value type:	<phandle>
+		Definition:
+			Specifies the ACC[2] node associated with this CPU.
+
+Example:
+
+/ {
+	compatible = "qcom,msm8960";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,kpss-acc-v1";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			qcom,acc = <&acc0>;
+			qcom,saw = <&saw0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			qcom,acc = <&acc1>;
+			qcom,saw = <&saw1>;
+		};
+	};
+};
+
+--
+[1] arm/msm/qcom,saw2.txt
+[2] arm/msm/qcom,kpss-acc.txt
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
new file mode 100644
index 0000000..4368d904
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
@@ -0,0 +1,56 @@
+======================================================
+Secondary CPU enable-method "qcom,kpss-acc-v2" binding
+======================================================
+
+This document describes the "qcom,kpss-acc-v2" method for enabling CPUs.
+This enable method can be used in either the "cpus" node or in individual
+"cpu" nodes.  Note that each "cpu" node must have both "qcom,saw" and
+"qcom,acc" properties defined (even if the "enable-method" property was
+defined only in the "cpus" node).
+
+Enable method name:	"qcom,kpss-acc-v2"
+Compatible machine:	"qcom,msm8974"
+Compatible cpu:		"qcom,krait"
+Related properties:
+	- qcom,saw
+		Usage:		required (in each "cpu" node")
+		Value type:	<phandle>
+		Definition:
+			Specifies the SAW[1] node associated with this CPU.
+
+	- qcom,acc
+		Usage:		required (in each "cpu" node")
+		Value type:	<phandle>
+		Definition:
+			Specifies the ACC[2] node associated with this CPU.
+
+Example:
+
+/ {
+	compatible = "qcom,msm8974";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,kpss-acc-v2";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			qcom,acc = <&acc0>;
+			qcom,saw = <&saw0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			qcom,acc = <&acc1>;
+			qcom,saw = <&saw1>;
+		};
+	};
+};
+
+--
+[1] arm/msm/qcom,saw2.txt
+[2] arm/msm/qcom,kpss-acc.txt
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/rockchip,rk3066-smp b/Documentation/devicetree/bindings/arm/cpu-enable-method/rockchip,rk3066-smp
new file mode 100644
index 0000000..617f0c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/rockchip,rk3066-smp
@@ -0,0 +1,32 @@
+=========================================================
+Secondary CPU enable-method "rockchip,rk3066-smp" binding
+=========================================================
+
+This document describes the "rockchip,rk3066-smp" method for enabling
+CPUs.  This enable method should be used in the "cpus" node, but can
+also be defined in individual "cpu" nodes.
+
+Enable method name:	"rockchip,rk3066-smp"
+Compatible machine:	"rockchip,rk3066a"
+			"rockchip,rk3188"
+Compatible cpu:		"arm,cortex-a9"
+Related properties:	(none)
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "rockchip,rk3066-smp";
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
new file mode 100644
index 0000000..d579829
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
@@ -0,0 +1,55 @@
+================================================
+Secondary CPU enable-method "spin-table" binding
+================================================
+
+This document describes the "spin-table" method for enabling secondary
+CPUs.  A "spin-table" enable method must be specified only in individual
+"cpu" nodes in the device tree.
+
+Enable method name:	"spin-table"
+Compatible cpus:	Any AArch64 CPU
+Related properties:
+	- cpu-release-addr
+		Usage:		required
+		Value type:	<64-bit value>    (two cells)
+		Definition:
+			A two cell value identifying a 64-bit memory location
+			used by the boot CPU to inform a secondary CPU it
+			should begin its kernel bootstrap.  Memory at this
+			location must initially be zeroed.
+
+Example:
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x1>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x2>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x3>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 1fe72a0..06e18fc 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -191,30 +191,8 @@ nodes to be present and contain the properties described below.
 			    "qcom,kpss-acc-v1"
 			    "qcom,kpss-acc-v2"
 			    "rockchip,rk3066-smp"
-
-	- cpu-release-addr
-		Usage: required for systems that have an "enable-method"
-		       property value of "spin-table".
-		Value type: <prop-encoded-array>
-		Definition:
-			# On ARM v8 64-bit systems must be a two cell
-			  property identifying a 64-bit zero-initialised
-			  memory location.
-
-	- qcom,saw
-		Usage: required for systems that have an "enable-method"
-		       property value of "qcom,kpss-acc-v1" or
-		       "qcom,kpss-acc-v2"
-		Value type: <phandle>
-		Definition: Specifies the SAW[1] node associated with this CPU.
-
-	- qcom,acc
-		Usage: required for systems that have an "enable-method"
-		       property value of "qcom,kpss-acc-v1" or
-		       "qcom,kpss-acc-v2"
-		Value type: <phandle>
-		Definition: Specifies the ACC[2] node associated with this CPU.
-
+		Details about use of these CPU enable methods is documented
+		elsewhere[1].
 
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
@@ -409,5 +387,4 @@ cpus {
 };
 
 --
-[1] arm/msm/qcom,saw2.txt
-[2] arm/msm/qcom,kpss-acc.txt
+[1] arm/cpu-enable-method/
-- 
1.9.1

