Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaLWIol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:44:41 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36350 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaLWIoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:44:39 -0500
Message-ID: <54992B73.5080305@dev.rtsoft.ru>
Date: Tue, 23 Dec 2014 11:44:35 +0300
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Arseny Solokha <asolokha@kb.kras.ru>,
        Alan Stern <stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] OHCI: add a quirk for ULi M5237 blocking on reset
References: <Pine.LNX.4.44L0.1412060945160.25285-100000@netrider.rowland.org> <5498FF69.2080000@kb.kras.ru> <54990266.2070404@dev.rtsoft.ru>
In-Reply-To: <54990266.2070404@dev.rtsoft.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my case root cause was elsewhere - USB port that I thought was driven
> by ULI, actually was not. And ULI's builtin OHCI was not
> hardware-enabled (but still was available on bus). I workarounded it by
> masking entire device in platform-specific quirk.

For reference, here is the patch that was finally applied to the product (3.10 based).

commit 16cf72cfa72269b55fc5c878689e00c99b640d86
Author: Nikita Yushchenko <nyoushchenko@mvista.com>
Date:   Thu Apr 3 08:35:36 2014 +0400

    powerpc: fix IRQ routing on Freescale boards with ULI1575 chip
    
    Source: MontaVista Software, LLC
    MR: 55925
    Type: Defect Fix
    Disposition: Needs submitting to mainline
    ChangeID: 1d46876594e80ef2fad575d1f4161ad2c5f0cb28
    Description:
    
    At least on some Freescale boards with ULI1575 southbridge chip,
    interrupts from PCI slots are routed to more then one IRQ input,
    causing IRQ storms when more than one path happens to be enabled.
    
    - On MPC8572DS, interrupts from PCI slots are documented to be connected
      both to SoC's IRQ inputs and to ULI1575's IRQ inputs.
    
    - On P2020DS, MPIC IRQ4 input is shared between cascade interrupt from
      ULI1575 i8259, and "Assert INTA" message from PCIe1 bus, which is
      ULI1575's upstream bus. Experiments show that with some ULI1575 IRQ
      routing settings, ULI1575 does generate "Assert INTA" message. How
      in particular this is controlled, currently is not clear. The only
      mention of such messages in 1575's datasheet is in APIC settings,
      however 1575's APIC is not used in Freescale boards.
    
    This patch does the following:
    
    - changes 1575's IRQ routing (that is currently configured in PCI quirk,
      same for all supported boards) such that
      - on boards other than P2020DS, routing from 1575's PIRQ[ABCD] is
        disabled, since interrupts from PCI slots are routed both to these
        pins and directly to SoC, and need to break one of two routes to
        avoid interrupt duplication,
      - on P2020DS, routing from PIRQA and PIRQB is kept enabled since it is
        the only path for interrupts from PCI slot,
      - routing interrupts from 1575's internal PCI devices is changed to go
        through those PIRQx that are kept enabled,
      - routing from PIRQx to i8259 inputs is configured such that, per
        experiment, "Assert INTA" messages do not appear on upstream PCIe
        bus.
    
    - updates device tree files to match new configuration,
    
    - does some related cleanup:
      - disables routing interrupts from 1575's internal devices that are
        not used in any supported boards,
      - modifies device masking to hide USB controllers on P2020DS (these
        are not disabled in hardware and thus respond to bus scans and
        appear in the system, but are not wired on the board so can't be
        used - so better to hide them completely).
    
    Signed-off-by: Nikita Yushchenko <nyoushchenko@mvista.com>
    Signed-off-by: Armin Kuster <akuster@mvista.com>

diff --git a/arch/powerpc/boot/dts/mpc8544ds.dtsi b/arch/powerpc/boot/dts/mpc8544ds.dtsi
index b219d03..fd1ac5d 100644
--- a/arch/powerpc/boot/dts/mpc8544ds.dtsi
+++ b/arch/powerpc/boot/dts/mpc8544ds.dtsi
@@ -124,13 +124,13 @@
 		interrupt-map-mask = <0xff00 0x0 0x0 0x7>;
 		interrupt-map = <
 			// IDSEL 0x1c  USB
-			0xe000 0x0 0x0 0x1 &i8259 0xc 0x2
-			0xe100 0x0 0x0 0x2 &i8259 0x9 0x2
-			0xe200 0x0 0x0 0x3 &i8259 0xa 0x2
+			0xe000 0x0 0x0 0x1 &i8259 0x5 0x2
+			0xe100 0x0 0x0 0x2 &i8259 0x6 0x2
+			0xe200 0x0 0x0 0x3 &i8259 0x7 0x2
 			0xe300 0x0 0x0 0x4 &i8259 0xb 0x2
 
 			// IDSEL 0x1d  Audio
-			0xe800 0x0 0x0 0x1 &i8259 0x6 0x2
+			0xe800 0x0 0x0 0x1 &i8259 0x7 0x2
 
 			// IDSEL 0x1e Legacy
 			0xf000 0x0 0x0 0x1 &i8259 0x7 0x2
@@ -138,7 +138,7 @@
 
 			// IDSEL 0x1f IDE/SATA
 			0xf800 0x0 0x0 0x1 &i8259 0xe 0x2
-			0xf900 0x0 0x0 0x1 &i8259 0x5 0x2
+			0xf900 0x0 0x0 0x1 &i8259 0x9 0x2
 			>;
 
 
diff --git a/arch/powerpc/boot/dts/mpc8572ds.dtsi b/arch/powerpc/boot/dts/mpc8572ds.dtsi
index 357490b..1b13572 100644
--- a/arch/powerpc/boot/dts/mpc8572ds.dtsi
+++ b/arch/powerpc/boot/dts/mpc8572ds.dtsi
@@ -343,13 +343,13 @@
 			0x9700 0x0 0x0 0x4 &mpic 0x2 0x1 0 0
 
 			// IDSEL 0x1c  USB
-			0xe000 0x0 0x0 0x1 &i8259 0xc 0x2
-			0xe100 0x0 0x0 0x2 &i8259 0x9 0x2
-			0xe200 0x0 0x0 0x3 &i8259 0xa 0x2
+			0xe000 0x0 0x0 0x1 &i8259 0x5 0x2
+			0xe100 0x0 0x0 0x2 &i8259 0x6 0x2
+			0xe200 0x0 0x0 0x3 &i8259 0x7 0x2
 			0xe300 0x0 0x0 0x4 &i8259 0xb 0x2
 
 			// IDSEL 0x1d  Audio
-			0xe800 0x0 0x0 0x1 &i8259 0x6 0x2
+			0xe800 0x0 0x0 0x1 &i8259 0x7 0x2
 
 			// IDSEL 0x1e Legacy
 			0xf000 0x0 0x0 0x1 &i8259 0x7 0x2
@@ -357,7 +357,7 @@
 
 			// IDSEL 0x1f IDE/SATA
 			0xf800 0x0 0x0 0x1 &i8259 0xe 0x2
-			0xf900 0x0 0x0 0x1 &i8259 0x5 0x2
+			0xf900 0x0 0x0 0x1 &i8259 0x9 0x2
 			>;
 
 
diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 1e8666c..25a08af 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -508,13 +508,13 @@
 			0x9700 0 0 4 &mpic 2 1
 
 			// IDSEL 0x1c  USB
-			0xe000 0 0 1 &i8259 12 2
-			0xe100 0 0 2 &i8259 9 2
-			0xe200 0 0 3 &i8259 10 2
+			0xe000 0 0 1 &i8259 5 2
+			0xe100 0 0 2 &i8259 6 2
+			0xe200 0 0 3 &i8259 7 2
 			0xe300 0 0 4 &i8259 11 2
 
 			// IDSEL 0x1d  Audio
-			0xe800 0 0 1 &i8259 6 2
+			0xe800 0 0 1 &i8259 7 2
 
 			// IDSEL 0x1e Legacy
 			0xf000 0 0 1 &i8259 7 2
@@ -522,7 +522,7 @@
 
 			// IDSEL 0x1f IDE/SATA
 			0xf800 0 0 1 &i8259 14 2
-			0xf900 0 0 1 &i8259 5 2
+			0xf900 0 0 1 &i8259 9 2
 			>;
 
 		pcie@0 {
diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts b/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
index fd4cd4d..60d4883 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
@@ -474,13 +474,13 @@
 			0x9700 0 0 4 &mpic 2 1
 
 			// IDSEL 0x1c  USB
-			0xe000 0 0 1 &i8259 12 2
-			0xe100 0 0 2 &i8259 9 2
-			0xe200 0 0 3 &i8259 10 2
+			0xe000 0 0 1 &i8259 5 2
+			0xe100 0 0 2 &i8259 6 2
+			0xe200 0 0 3 &i8259 7 2
 			0xe300 0 0 4 &i8259 11 2
 
 			// IDSEL 0x1d  Audio
-			0xe800 0 0 1 &i8259 6 2
+			0xe800 0 0 1 &i8259 7 2
 
 			// IDSEL 0x1e Legacy
 			0xf000 0 0 1 &i8259 7 2
@@ -488,7 +488,7 @@
 
 			// IDSEL 0x1f IDE/SATA
 			0xf800 0 0 1 &i8259 14 2
-			0xf900 0 0 1 &i8259 5 2
+			0xf900 0 0 1 &i8259 9 2
 			>;
 
 		pcie@0 {
diff --git a/arch/powerpc/boot/dts/p2020ds.dtsi b/arch/powerpc/boot/dts/p2020ds.dtsi
index 2105701..91a85ca 100644
--- a/arch/powerpc/boot/dts/p2020ds.dtsi
+++ b/arch/powerpc/boot/dts/p2020ds.dtsi
@@ -230,39 +230,39 @@
 		interrupt-map = <
 
 			// IDSEL 0x11 func 0 - PCI slot 1
-			0x8800 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8800 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8800 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 1 - PCI slot 1
-			0x8900 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8900 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8900 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 2 - PCI slot 1
-			0x8a00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8a00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8a00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 3 - PCI slot 1
-			0x8b00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8b00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8b00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 4 - PCI slot 1
-			0x8c00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8c00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8c00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 5 - PCI slot 1
-			0x8d00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8d00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8d00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 6 - PCI slot 1
-			0x8e00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8e00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8e00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x11 func 7 - PCI slot 1
-			0x8f00 0x0 0x0 0x1 &i8259 0x9 0x2
+			0x8f00 0x0 0x0 0x1 &i8259 0xb 0x2
 			0x8f00 0x0 0x0 0x2 &i8259 0xa 0x2
 
 			// IDSEL 0x1d  Audio
-			0xe800 0x0 0x0 0x1 &i8259 0x6 0x2
+			0xe800 0x0 0x0 0x1 &i8259 0x7 0x2
 
 			// IDSEL 0x1e Legacy
 			0xf000 0x0 0x0 0x1 &i8259 0x7 0x2
@@ -270,7 +270,7 @@
 
 			// IDSEL 0x1f IDE/SATA
 			0xf800 0x0 0x0 0x1 &i8259 0xe 0x2
-			0xf900 0x0 0x0 0x1 &i8259 0x5 0x2
+			0xf900 0x0 0x0 0x1 &i8259 0x9 0x2
 			>;
 
 		uli1575@0 {
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index 92ac9b5..640a6fa 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -17,6 +17,7 @@
 
 #include <asm/pci-bridge.h>
 
+#define ULI_PIRQ_NONE	0x00
 #define ULI_PIRQA	0x08
 #define ULI_PIRQB	0x09
 #define ULI_PIRQC	0x0a
@@ -24,6 +25,7 @@
 #define ULI_PIRQE	0x0c
 #define ULI_PIRQF	0x0d
 #define ULI_PIRQG	0x0e
+#define ULI_PIRQH	0x0f
 
 #define ULI_8259_NONE	0x00
 #define ULI_8259_IRQ1	0x08
@@ -39,17 +41,6 @@
 #define ULI_8259_IRQ14	0x0d
 #define ULI_8259_IRQ15	0x0f
 
-u8 uli_pirq_to_irq[8] = {
-	ULI_8259_IRQ9,		/* PIRQA */
-	ULI_8259_IRQ10,		/* PIRQB */
-	ULI_8259_IRQ11,		/* PIRQC */
-	ULI_8259_IRQ12,		/* PIRQD */
-	ULI_8259_IRQ5,		/* PIRQE */
-	ULI_8259_IRQ6,		/* PIRQF */
-	ULI_8259_IRQ7,		/* PIRQG */
-	ULI_8259_NONE,		/* PIRQH */
-};
-
 static inline bool is_quirk_valid(void)
 {
 	return (machine_is(mpc86xx_hpcn) ||
@@ -84,8 +75,6 @@ static void early_uli5249(struct pci_dev *dev)
 
 static void quirk_uli1575(struct pci_dev *dev)
 {
-	int i;
-
 	if (!is_quirk_valid())
 		return;
 
@@ -93,50 +82,84 @@ static void quirk_uli1575(struct pci_dev *dev)
 	 * ULI1575 interrupts route setup
 	 */
 
-	/* ULI1575 IRQ mapping conf register maps PIRQx to IRQn */
-	for (i = 0; i < 4; i++) {
-		u8 val = uli_pirq_to_irq[i*2] | (uli_pirq_to_irq[i*2+1] << 4);
-		pci_write_config_byte(dev, 0x48 + i, val);
-	}
-
-	/* USB 1.1 OHCI controller 1: dev 28, func 0 - IRQ12 */
-	pci_write_config_byte(dev, 0x86, ULI_PIRQD);
-
-	/* USB 1.1 OHCI controller 2: dev 28, func 1 - IRQ9 */
-	pci_write_config_byte(dev, 0x87, ULI_PIRQA);
+	/* On MPC8572DS, need to disable routing from PIRQA/B/C/D,
+	 * since this is causing double-routing for interrupts that come
+	 * from PCI slots.
+	 *
+	 * On P2020DS, have to keep PIRQA and PIRQB enabled since these
+	 * get interrupts from PCI slot.
+	 *
+	 * Experiments show that some PIRQ routing settings cause 1575 to
+	 * route some interrupts using upstream bus "Assert INTx" messages.
+	 * On P2020 "Assert INTa" message causes assertion og the same MPIC
+	 * input as is used to accept i8259 cascade - causing IRQ storm.
+	 *
+	 * How generation of "Assert INTx" messages is controlled, is not
+	 * clear. The setting below is tested not to cause it.
+	 */
 
-	/* USB 1.1 OHCI controller 3: dev 28, func 2 - IRQ10 */
-	pci_write_config_byte(dev, 0x88, ULI_PIRQB);
+	/* bits 0..3 - PIRQA, bits 4..7 - PIRQB */
+	if (machine_is(p2020_ds))
+		pci_write_config_byte(dev, 0x48,
+				ULI_8259_IRQ11 | (ULI_8259_IRQ10 << 4));
+	else
+		pci_write_config_byte(dev, 0x48,
+				ULI_8259_NONE | (ULI_8259_NONE << 4));
+
+	/* bits 0..3 - PIRQC, bits 4..7 - PIRQD */
+	pci_write_config_byte(dev, 0x49, ULI_8259_NONE | (ULI_8259_NONE << 4));
+
+	/* bits 0..3 - PIRQE, bits 4..7 - PIRQF */
+	pci_write_config_byte(dev, 0x4a, ULI_8259_IRQ9 | (ULI_8259_IRQ7 << 4));
+
+	/* bits 0..3 - PIRQG, bits 4..7 - PIRQH */
+	pci_write_config_byte(dev, 0x4b, ULI_8259_IRQ6 | (ULI_8259_IRQ5 << 4));
+
+	/* On P2020DS, USB is not wired.
+	 * In othred boards, set routing
+	 *   OHCI 28:0 -> PIRQH -> IRQ5
+	 *   OHCI 28:1 -> PIRQG -> IRQ6
+	 *   OHCI 28:2 -> PIRQF -> IRQ7
+	 *   EHCI 28:3 -> IRQ11 (this is not routed via PIRQx)
+	 */
+	if (machine_is(p2020_ds)) {
+		pci_write_config_byte(dev, 0x86, ULI_PIRQ_NONE);
+		pci_write_config_byte(dev, 0x87, ULI_PIRQ_NONE);
+		pci_write_config_byte(dev, 0x88, ULI_PIRQ_NONE);
+		pci_write_config_byte(dev, 0x74, ULI_8259_NONE);
+	} else {
+		pci_write_config_byte(dev, 0x86, ULI_PIRQH);
+		pci_write_config_byte(dev, 0x87, ULI_PIRQG);
+		pci_write_config_byte(dev, 0x88, ULI_PIRQF);
+		pci_write_config_byte(dev, 0x74, ULI_8259_IRQ11);
+	}
 
-	/* Lan controller: dev 27, func 0 - IRQ6 */
-	pci_write_config_byte(dev, 0x89, ULI_PIRQF);
+	/* Lan controller 27:0 is not used on any board */
+	pci_write_config_byte(dev, 0x89, ULI_PIRQ_NONE);
 
-	/* AC97 Audio controller: dev 29, func 0 - IRQ6 */
+	/* AC97 Audio controller 29:0 -> PIRQF -> IRQ7 */
 	pci_write_config_byte(dev, 0x8a, ULI_PIRQF);
 
-	/* Modem controller: dev 29, func 1 - IRQ6 */
-	pci_write_config_byte(dev, 0x8b, ULI_PIRQF);
+	/* Modem controller 29:1 is not used on any board */
+	pci_write_config_byte(dev, 0x8b, ULI_PIRQ_NONE);
 
-	/* HD Audio controller: dev 29, func 2 - IRQ6 */
-	pci_write_config_byte(dev, 0x8c, ULI_PIRQF);
+	/* HD Audio controller 29:2 is not used on any board */
+	pci_write_config_byte(dev, 0x8c, ULI_PIRQ_NONE);
 
-	/* SATA controller: dev 31, func 1 - IRQ5 */
+	/* SATA controller 31:1 -> PIRQE -> IRQ9 */
 	pci_write_config_byte(dev, 0x8d, ULI_PIRQE);
 
-	/* SMB interrupt: dev 30, func 1 - IRQ7 */
-	pci_write_config_byte(dev, 0x8e, ULI_PIRQG);
+	/* SMB interrupt 30:1 -> PIRQF -> IRQ7 */
+	pci_write_config_byte(dev, 0x8e, ULI_PIRQF);
 
-	/* PMU ACPI SCI interrupt: dev 30, func 2 - IRQ7 */
-	pci_write_config_byte(dev, 0x8f, ULI_PIRQG);
+	/* Power management device 30:2 is not used on any board */
+	pci_write_config_byte(dev, 0x8f, ULI_PIRQ_NONE);
 
-	/* USB 2.0 controller: dev 28, func 3 */
-	pci_write_config_byte(dev, 0x74, ULI_8259_IRQ11);
-
-	/* Primary PATA IDE IRQ: 14
-	 * Secondary PATA IDE IRQ: 15
-	 */
+	/* Primary PATA IDE IRQ: 14 */
 	pci_write_config_byte(dev, 0x44, 0x30 | ULI_8259_IRQ14);
-	pci_write_config_byte(dev, 0x75, ULI_8259_IRQ15);
+
+	/* Secondary IDE is not used on any board */
+	pci_write_config_byte(dev, 0x75, ULI_8259_NONE);
 }
 
 static void quirk_final_uli1575(struct pci_dev *dev)
@@ -355,6 +378,10 @@ int uli_exclude_device(struct pci_controller *hose,
 		/* exclude HD Audio controller */
 		if ((PCI_SLOT(devfn) == 29) && (PCI_FUNC(devfn) == 2))
 			return PCIBIOS_DEVICE_NOT_FOUND;
+
+		/* exclude unwired USB on P2020DS */
+		if (machine_is(p2020_ds) && PCI_SLOT(devfn) == 28)
+			return PCIBIOS_DEVICE_NOT_FOUND;
 	}
 
 	return PCIBIOS_SUCCESSFUL;


