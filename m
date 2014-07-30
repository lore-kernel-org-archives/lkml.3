Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaG3Aft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:35:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55568 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbaG3Afq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:35:46 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Markus Mayer <markus.mayer@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCHv3 1/5] Documentation: dt: add omap mailbox bindings
Date: Tue, 29 Jul 2014 19:34:35 -0500
Message-ID: <1406680479-18446-2-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406680479-18446-1-git-send-email-s-anna@ti.com>
References: <1406680479-18446-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree bindings document for OMAP2+ mailbox.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 .../devicetree/bindings/mailbox/omap-mailbox.txt   | 108 +++++++++++++++++++++
 1 file changed, 108 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/omap-mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
new file mode 100644
index 0000000..48edc4b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
@@ -0,0 +1,108 @@
+OMAP2+ Mailbox Driver
+=====================
+
+The OMAP mailbox hardware facilitates communication between different processors
+using a queued mailbox interrupt mechanism. The IP block is external to the
+various processor subsystems and is connected on an interconnect bus. The
+communication is achieved through a set of registers for message storage and
+interrupt configuration registers.
+
+Each mailbox IP block has a certain number of h/w fifo queues and output
+interrupt lines. An output interrupt line is routed to an interrupt controller
+within a processor subsystem, and there can be more than one line going to a
+specific processor's interrupt controller. The interrupt line connections are
+fixed for an instance and are dictated by the IP integration into the SoC
+(excluding the SoCs that have a Interrupt Crossbar IP). Each interrupt line is
+programmable through a set of interrupt configuration registers, and have a rx
+and tx interrupt source per h/w fifo. Communication between different processors
+is achieved through the appropriate programming of the rx and tx interrupt
+sources on the appropriate interrupt lines.
+
+The number of h/w fifo queues and interrupt lines dictate the usable registers.
+All the current OMAP SoCs except for the newest DRA7xx SoC has a single IP
+instance. DRA7xx has multiple instances with different number of h/w fifo queues
+and interrupt lines between different instances. The interrupt lines can also be
+routed to different processor sub-systems on DRA7xx as they are routed through
+the Crossbar, a kind of interrupt router/multiplexer.
+
+Mailbox Device Node:
+====================
+A Mailbox device node is used to represent a Mailbox IP instance within a SoC.
+The sub-mailboxes are represented as child nodes of this parent node.
+
+Required properties:
+--------------------
+- compatible:		Should be one of the following,
+			    "ti,omap2-mailbox" for OMAP2420, OMAP2430 SoCs
+			    "ti,omap3-mailbox" for OMAP3430, OMAP3630 SoCs
+			    "ti,omap4-mailbox" for OMAP44xx, OMAP54xx, AM33xx,
+						   AM43xx and DRA7xx SoCs
+- reg:			Contains the mailbox register address range (base
+			address and length)
+- interrupts:		Contains the interrupt information for the mailbox
+			device. The format is dependent on which interrupt
+			controller the OMAP device uses
+- ti,hwmods:		Name of the hwmod associated with the mailbox
+- ti,mbox-num-users:	Number of targets (processor devices) that the mailbox
+			device can interrupt
+- ti,mbox-num-fifos:	Number of h/w fifo queues within the mailbox IP block
+
+Child Nodes:
+============
+A child node is used for representing the actual sub-mailbox device that is
+used for the communication between the host processor and a remote processor.
+Each child node should have a unique node name across all the different
+mailbox device nodes.
+
+Required properties:
+--------------------
+- ti,mbox-tx:		sub-mailbox descriptor property defining a Tx fifo
+- ti,mbox-rx:		sub-mailbox descriptor property defining a Rx fifo
+
+Sub-mailbox Descriptor Data
+---------------------------
+Each of the above ti,mbox-tx and ti,mbox-rx properties should have 3 cells of
+data that represent the following:
+    Cell #1 (fifo_id) - mailbox fifo id used either for transmitting
+                        (ti,mbox-tx) or for receiving (ti,mbox-rx)
+    Cell #2 (irq_id)  - irq identifier index number to use from the parent's
+                        interrupts data. Should be 0 for most of the cases, a
+                        positive index value is seen only on mailboxes that have
+                        multiple interrupt lines connected to the MPU processor.
+    Cell #3 (usr_id)  - mailbox user id for identifying the interrupt line
+                        associated with generating a tx/rx fifo interrupt.
+
+Example:
+--------
+
+/* OMAP4 */
+mailbox: mailbox@4a0f4000 {
+	compatible = "ti,omap4-mailbox";
+	reg = <0x4a0f4000 0x200>;
+	interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+	ti,hwmods = "mailbox";
+	ti,mbox-num-users = <3>;
+	ti,mbox-num-fifos = <8>;
+	mbox_ipu: mbox_ipu {
+		ti,mbox-tx = <0 0 0>;
+		ti,mbox-rx = <1 0 0>;
+	};
+	mbox_dsp: mbox_dsp {
+		ti,mbox-tx = <3 0 0>;
+		ti,mbox-rx = <2 0 0>;
+	};
+};
+
+/* AM33xx */
+mailbox: mailbox@480C8000 {
+	compatible = "ti,omap4-mailbox";
+	reg = <0x480C8000 0x200>;
+	interrupts = <77>;
+	ti,hwmods = "mailbox";
+	ti,mbox-num-users = <4>;
+	ti,mbox-num-fifos = <8>;
+	mbox_wkupm3: wkup_m3 {
+		ti,mbox-tx = <0 0 0>;
+		ti,mbox-rx = <0 0 3>;
+	};
+};
-- 
2.0.0

