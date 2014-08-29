Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaH2WOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:14:46 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:58781 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaH2WOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:44 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] of: Add binding document for MIPS GIC
Date: Fri, 29 Aug 2014 15:14:30 -0700
Message-Id: <1409350479-19108-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Global Interrupt Controller (GIC) present on certain MIPS systems
can be used to route external interrupts to individual VPEs and CPU
interrupt vectors.  It also supports a timer and software-generated
interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mips/gic.txt

diff --git a/Documentation/devicetree/bindings/mips/gic.txt b/Documentation/devicetree/bindings/mips/gic.txt
new file mode 100644
index 0000000..725f1ef
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/gic.txt
@@ -0,0 +1,50 @@
+MIPS Global Interrupt Controller (GIC)
+
+The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
+It also supports a timer and software-generated interrupts which can be
+used as IPIs.
+
+Required properties:
+- compatible : Should be "mti,global-interrupt-controller"
+- reg : Base address and length of the GIC registers.
+- interrupts : Core interrupts to which the GIC may route external interrupts.
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt specifier.  Should be 3.
+  - The first cell is the GIC interrupt number.
+  - The second cell encodes the interrupt flags.
+    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
+    flags.
+  - The optional third cell indicates which CPU interrupt vector the GIC
+    interrupt should be routed to.  It is a 0-based index into the list of
+    GIC-to-CPU interrupts specified in the "interrupts" property described
+    above.  For example, a '2' in this cell will route the interrupt to the
+    3rd core interrupt listed in 'interrupts'.  If omitted, the interrupt will
+    be routed to the 1st core interrupt.
+
+Example:
+
+	cpu_intc: interrupt-controller@0 {
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	gic: interrupt-controller@1bdc0000 {
+		compatible = "mti,global-interrupt-controller";
+		reg = <0x1bdc0000 0x20000>;
+
+		interrupt-controller;
+		#interrupt-cells = <3>;
+
+		interrupt-parent = <&cpu_intc>;
+		interrupts = <3>, <4>;
+	};
+
+	uart@18101400 {
+		...
+		interrupt-parent = <&gic>;
+		interrupts = <24 IRQ_TYPE_LEVEL_HIGH 0>;
+		...
+	};
-- 
2.1.0.rc2.206.gedb03e5

