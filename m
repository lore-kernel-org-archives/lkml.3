Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaIJAof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:44:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43162 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaIJAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:44:32 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, tglx@linutronix.de, computersforpeace@gmail.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 2/2] Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding
Date: Tue,  9 Sep 2014 17:44:22 -0700
Message-Id: <1410309862-27784-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410309862-27784-1-git-send-email-f.fainelli@gmail.com>
References: <1410309862-27784-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device Tree binding document for the Broadcom
BCM7120-style Set-top-box Level 2 interrupt controller hardware.

We provide some ascii art explaining the different roles and reasons why
some properties are introduced to represent that interrupt controller.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- add an ascii diagram explaining how the HW works to clarify the binding
- add some small bullet points explaining the HW roles and features
- remove 'interrupt-names' since we are not using it and cannot document all
  possible names as of today
- clarify the values for the 'interrupts' property
- clarify the terminology used to avoid using software concepts

 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  | 86 ++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
new file mode 100644
index 000000000000..67651886a317
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -0,0 +1,86 @@
+Broadcom BCM7120-style Level 2 interrupt controller
+
+This interrupt controller hardware is a second level interrupt controller that
+is hooked to a parent interrupt controller: e.g: ARM GIC for ARM-based
+platforms. It can be found on BCM7xxx products starting with BCM7120.
+
+Such an interrupt controller has the following hardware design:
+
+- outputs multiple interrupts signals towards its interrupt controller parent
+
+- controls how some of the interrupts will be flowing, whether they will
+  directly output an interrupt signal towards the interrupt controller parent,
+  or if they will output an interrupt signal at this 2nd level interrupt
+  controller, in particular for UARTs
+
+- not all 32-bits within the interrupt controller actually map to an interrupt
+
+The typical hardware layout for this controller is represented below:
+
+2nd level interrupt line		Outputs for the parent controller (e.g: ARM GIC)
+
+0 -----[ MUX ] ------------|==========> GIC interrupt 75
+          \-----------\
+                       |
+1 -----[ MUX ] --------)---|==========> GIC interrupt 76
+          \------------|
+                       |
+2 -----[ MUX ] --------)---|==========> GIC interrupt 77
+          \------------|
+                       |
+3 ---------------------|
+4 ---------------------|
+5 ---------------------|
+7 ---------------------|---|===========> GIC interrupt 66
+9 ---------------------|
+10 --------------------|
+11 --------------------/
+
+6 ------------------------\
+                           |===========> GIC interrupt 64
+8 ------------------------/
+
+12 ........................ X
+13 ........................ X 		(not connected)
+..
+31 ........................ X
+
+Required properties:
+
+- compatible: should be "brcm,bcm7120-l2-intc"
+- reg: specifies the base physical address and size of the registers
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: specifies the number of cells needed to encode an interrupt
+  source, should be 1.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this one is cascaded from
+- interrupts: specifies the interrupt line(s) in the interrupt-parent controller
+  node, valid values depend on the type of parent interrupt controller
+- brcm,int-map-mask: 32-bits bit mask describing how many and which interrupts
+  are wired to this 2nd level interrupt controller, and how they match their
+  respective interrupt parents. Should match exactly the number of interrupts
+  specified in the 'interrupts' property.
+
+Optional properties:
+
+- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
+  wakeup source for system suspend/resume.
+
+- brcm,int-fwd-mask: if present, a 32-bits bit mask to configure for the
+  interrupts which have a mux gate, typically UARTs. Setting these bits will
+  make their respective interrupts outputs bypass this 2nd level interrupt
+  controller completely, it completely transparent for the interrupt controller
+  parent
+
+Example:
+
+irq0_intc: interrupt-controller@f0406800 {
+	compatible = "brcm,bcm7120-l2-intc";
+	interrupt-parent = <&intc>;
+	#interrupt-cells = <1>;
+	reg = <0xf0406800 0x8>;
+	interrupt-controller;
+	interrupts = <0x0 0x42 0x0>, <0x0 0x40 0x0>;
+	brcm,int-map-mask = <0xeb8>, <0x140>;
+	brcm,int-fwd-mask = <0x7>;
+};
-- 
1.9.1

