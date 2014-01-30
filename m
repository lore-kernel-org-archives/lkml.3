Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaA3QLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:11:09 -0500
Received: from smtp.citrix.com ([66.165.176.89]:43070 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbaA3QLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:11:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,750,1384300800"; 
   d="scan'208";a="98154827"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] arm: document "mach-virt" platform.
Date: Thu, 30 Jan 2014 16:11:02 +0000
Message-ID: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-virt has existed for a while but it is not written down what it actually
consists of. Although it seems a bit unusual to document a binding for an
entire platform since mach-virt is entirely virtual it is helpful to have
something to refer to in the absence of a single concrete implementation.

I've done my best to capture the requirements based on the git log and my
memory/understanding.

While here remove the xenvm dts example, the Xen tools will now build a
suitable mach-virt compatible dts when launching the guest.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
I'm not sure which tree this sort of thing should go though, sorry for the
huge Cc.
---
 .../devicetree/bindings/arm/mach-virt.txt          |   32 ++++++++
 arch/arm/boot/dts/xenvm-4.2.dts                    |   81 --------------------
 2 files changed, 32 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mach-virt.txt
 delete mode 100644 arch/arm/boot/dts/xenvm-4.2.dts

diff --git a/Documentation/devicetree/bindings/arm/mach-virt.txt b/Documentation/devicetree/bindings/arm/mach-virt.txt
new file mode 100644
index 0000000..562bcda
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mach-virt.txt
@@ -0,0 +1,32 @@
+* Mach-virt "Dummy Virtual Machine" platform
+
+"mach-virt" is the smallest, dumbest platform possible, to be used as
+a guest for Xen, KVM and other hypervisors. It has no
+properties/functionality of its own and is driven entirely by device
+tree.
+
+This document defines the requirements for such a platform.
+
+* Required properties:
+
+- compatible: should be one of:
+	"linux,dummy-virt"
+	"xen,xenvm"
+
+In addition to the standard nodes (chosen, cpus, memory etc) the
+platform is required to provide certain other basic functionality
+which must be described in the device tree:
+
+    The platform must provide an ARM Generic Interrupt Controller
+    (GIC), defined in Documentation/devicetree/bindings/arm/gic.txt.
+
+    The platform must provide ARM architected timer, defined in
+    Documentation/devicetree/bindings/arm/arch_timer.txt.
+
+    If the platform is SMP then it must provide the Power State
+    Coordination Interface (PSCI) described in
+    Documentation/devicetree/bindings/arm/psci.txt.
+
+The platform may also provide hypervisor specific functionality
+(e.g. PV I/O), if it does so then this functionality must be
+discoverable (directly or indirectly) via device tree.
diff --git a/arch/arm/boot/dts/xenvm-4.2.dts b/arch/arm/boot/dts/xenvm-4.2.dts
deleted file mode 100644
index 3369151..0000000
--- a/arch/arm/boot/dts/xenvm-4.2.dts
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Xen Virtual Machine for unprivileged guests
- *
- * Based on ARM Ltd. Versatile Express CoreTile Express (single CPU)
- * Cortex-A15 MPCore (V2P-CA15)
- *
- */
-
-/dts-v1/;
-
-/ {
-	model = "XENVM-4.2";
-	compatible = "xen,xenvm-4.2", "xen,xenvm";
-	interrupt-parent = <&gic>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-
-	chosen {
-		/* this field is going to be adjusted by the hypervisor */
-		bootargs = "console=hvc0 root=/dev/xvda";
-	};
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		cpu@0 {
-			device_type = "cpu";
-			compatible = "arm,cortex-a15";
-			reg = <0>;
-		};
-
-		cpu@1 {
-			device_type = "cpu";
-			compatible = "arm,cortex-a15";
-			reg = <1>;
-		};
-	};
-
-	psci {
-		compatible      = "arm,psci";
-		method          = "hvc";
-		cpu_off         = <1>;
-		cpu_on          = <2>;
-	};
-
-	memory@80000000 {
-		device_type = "memory";
-		/* this field is going to be adjusted by the hypervisor */
-		reg = <0 0x80000000 0 0x08000000>;
-	};
-
-	gic: interrupt-controller@2c001000 {
-		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
-		#interrupt-cells = <3>;
-		#address-cells = <0>;
-		interrupt-controller;
-		reg = <0 0x2c001000 0 0x1000>,
-		      <0 0x2c002000 0 0x100>;
-	};
-
-	timer {
-		compatible = "arm,armv7-timer";
-		interrupts = <1 13 0xf08>,
-			     <1 14 0xf08>,
-			     <1 11 0xf08>,
-			     <1 10 0xf08>;
-	};
-
-	hypervisor {
-		compatible = "xen,xen-4.2", "xen,xen";
-		/* this field is going to be adjusted by the hypervisor */
-		reg = <0 0xb0000000 0 0x20000>;
-		/* this field is going to be adjusted by the hypervisor */
-		interrupts = <1 15 0xf08>;
-	};
-
-	motherboard {
-		arm,v2m-memory-map = "rs1";
-	};
-};
-- 
1.7.10.4

