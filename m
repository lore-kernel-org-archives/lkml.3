Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbaE3WL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:11:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51265 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345AbaE3WL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:11:56 -0400
From: Alex Elder <elder@linaro.org>
To: devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lorenzo.pieralisi@arm.com,
        gregory.clement@free-electrons.com, rvaswani@codeaurora.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] devicetree: bindings: separate CPU enable method descriptions
Date: Fri, 30 May 2014 17:11:54 -0500
Message-Id: <1401487914-21016-1-git-send-email-elder@linaro.org>
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
v2:  Rename "arm,psci.txt" to be "psci.txt" and fix its content

 .../bindings/arm/cpu-enable-method/README          | 20 +++++
 .../bindings/arm/cpu-enable-method/psci.txt        | 45 ++++++++++
 .../arm/cpu-enable-method/qcom,gcc-msm8660         | 30 +++++++
 .../arm/cpu-enable-method/qcom,kpss-acc-v1         | 56 +++++++++++++
 .../arm/cpu-enable-method/qcom,kpss-acc-v2         | 56 +++++++++++++
 .../bindings/arm/cpu-enable-method/spin-table.txt  | 95 ++++++++++++++++++++++
 Documentation/devicetree/bindings/arm/cpus.txt     | 29 +------
 7 files changed, 305 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/README
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
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
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
new file mode 100644
index 0000000..68b26c2
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
@@ -0,0 +1,45 @@
+================================
+CPU enable-method "psci" binding
+================================
+
+This document describes the "psci" method for enabling secondary CPUs.  A
+"psci" enable method is supported only in individual "cpu" nodes (even if
+	all CPU cores use the "psci" enable method).
+
+Enable method name:	"psci"
+Compatible cpus:	"arm,cortex-a57" (?)
+Related properties:	(none)
+
+Note:
+This enable method is only available if a valid PSCI node[1] (compatible
+with "arm,psci") is present in the device tree, and it defines a "cpu_on"
+property.
+
+Example (contrived 2-core ARM Cortex-A57 64-bit system):
+
+	psci {
+		compatible = "arm,psci";
+		method = "smc";
+		cpu_on = 0x1;
+	};
+	cpus {
+		#size-cells = <0>;
+		#address-cells = <2>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x0>;
+			enable-method = "psci";
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x1>;
+			enable-method = "psci";
+		};
+	};
+
+--
+[1] arm/psci.txt
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
new file mode 100644
index 0000000..b19f51c
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
@@ -0,0 +1,30 @@
+======================================================
+Secondary CPU enable-method "qcom,gcc-msm8660" binding
+======================================================
+
+This document describes the "qcom,gcc-msm8660" method for enabling secondary
+CPUs.  A "qcom,gcc-msm8660" enable method should only be used in the "cpus"
+node, to apply to all CPUs.
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
+		compatible = "qcom,scorpion";
+		enable-method = "qcom,gcc-msm8660";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+		};
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
diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
new file mode 100644
index 0000000..aee3617
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
@@ -0,0 +1,95 @@
+================================================
+Secondary CPU enable-method "spin-table" binding
+================================================
+
+This document describes the "spin-table" method for enabling secondary CPUs.
+A "spin-table" enable method can be used in either the "cpus" node or in
+individual "cpu" nodes.
+
+Enable method name:	"spin-table"
+Compatible cpus:	"arm,cortex-a57" (?)
+Related properties:
+	- cpu-release-addr
+		Usage:		required
+		Value type:	<prop-encoded-array>
+		Definition:
+			A two cell value identifying a 64-bit memory location
+			used by the boot CPU to inform a secondary CPU it
+			should begin its kernel bootstrap.  Memory at this
+			location must initially be zeroed.
+
+Examples (contrived 4-core ARM Cortex-A57 64-bit systems):
+
+The first example uses the same enable method for all cores.
+
+	cpus {
+		#size-cells = <0>;
+		#address-cells = <2>;
+		enable-method = "spin-table";
+		cpu-release-addr = <0 0x20000000>;
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
+
+		cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x100>;
+		};
+
+		cpu@101 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x101>;
+		};
+	};
+
+
+The second example uses specifies distinct enable method properties for each
+CPU core.
+
+	cpus {
+		#size-cells = <0>;
+		#address-cells = <2>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0 0x20000000>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x1>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0 0x20000008>;
+		};
+
+		cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x100>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0 0x20000010>;
+		};
+
+		cpu@101 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a57";
+			reg = <0x0 0x101>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0 0x20000018>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 333f4ae..2bb2a3e 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -185,30 +185,8 @@ nodes to be present and contain the properties described below.
 			    "qcom,gcc-msm8660"
 			    "qcom,kpss-acc-v1"
 			    "qcom,kpss-acc-v2"
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
 
@@ -403,5 +381,4 @@ cpus {
 };
 
 --
-[1] arm/msm/qcom,saw2.txt
-[2] arm/msm/qcom,kpss-acc.txt
+[1] arm/cpu-enable-method/
-- 
1.9.1

