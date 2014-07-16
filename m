Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaGPIBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:01:06 -0400
Received: from server721-han.de-nserver.de ([85.158.180.102]:33237 "EHLO
	server721-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbaGPIBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:01:03 -0400
X-Fcrdns: Yes
Message-ID: <53C63139.7000608@kristov.de>
Date: Wed, 16 Jul 2014 10:00:57 +0200
From: Christoph Schulz <develop@kristov.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Robert Resch <fli4l@robert.reschpara.de>
Subject: [PATCH 1/1] x86: don't exclude low BIOS area when allocating address
 space for non-PCI cards
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by mail@kristov.de through 89.182.109.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Schulz <develop@kristov.de>

Commit 30919b0bf356a8ee0ef4f7d38ca8ad99b96820b2 ("x86: avoid low BIOS area when
allocating address space") moved the test for resource allocations that fall
within the first 1MB of address space from the PCI-specific path to a generic
path, such that all resource allocations will avoid this area. However, this
breaks ISA cards which need to allocate a memory region within the first 1MB.
An example is the i82365 PCMCIA controller and derivatives like the Ricoh
RF5C296/396 which map part of the PCMCIA socket memory address space into the
first 1MB of system memory address space. They do not work anymore as no usable
memory region exists due to this change:

Intel ISA PCIC probe: Ricoh RF5C296/396 ISA-to-PCMCIA at port 0x3e0 ofs 0x00, 2 sockets
host opts [0]: none
host opts [1]: none
ISA irqs (scanned) = 3,4,5,9,10 status change on irq 10
pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcff: excluding 0xcf8-0xcff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3ff: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x37f 0x3c0-0x3e7 0x3f0-0x3ff
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0affff: excluding 0xa0000-0xaffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0b0000-0x0bffff: excluding 0xb0000-0xbffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0cffff: excluding 0xc0000-0xcbfff
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d0000-0x0dffff: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0e0000-0x0effff: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcff: excluding 0xcf8-0xcff
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3ff: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x37f 0x3c0-0x3e7 0x3f0-0x3ff
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0a0000-0x0affff: excluding 0xa0000-0xaffff
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0b0000-0x0bffff: excluding 0xb0000-0xbffff
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0cffff: excluding 0xc0000-0xcbfff
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0d0000-0x0dffff: clean.
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0e0000-0x0effff: clean.
pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff: clean.
pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia_socket pcmcia_socket1: cs: memory probe 0x0cc000-0x0effff: excluding 0xe0000-0xeffff
pcmcia_socket pcmcia_socket1: cs: unable to map card memory!

If filtering out the first 1MB is reverted, everything works as expected.

Signed-off-by: Christoph Schulz <develop@kristov.de>
Tested-by: Robert Resch <fli4l@robert.reschpara.de>
---
diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 2a26819..80eab01 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -37,10 +37,12 @@ static void remove_e820_regions(struct resource *avail)
 
 void arch_remove_reservations(struct resource *avail)
 {
-	/* Trim out BIOS areas (low 1MB and high 2MB) and E820 regions */
+	/*
+	 * Trim out BIOS area (high 2MB) and E820 regions. We do not remove
+	 * the low 1MB unconditionally, as this area is needed for some ISA
+	 * cards requiring a memory range, e.g. the i82365 PCMCIA controller.
+	 */
 	if (avail->flags & IORESOURCE_MEM) {
-		if (avail->start < BIOS_END)
-			avail->start = BIOS_END;
 		resource_clip(avail, BIOS_ROM_BASE, BIOS_ROM_END);
 
 		remove_e820_regions(avail);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index a19ed92..2ae525e 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -162,6 +162,10 @@ pcibios_align_resource(void *data, const struct resource *res,
 			return start;
 		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
+	} else if (res->flags & IORESOURCE_MEM) {
+		/* The low 1MB range is reserved for ISA cards */
+		if (start < BIOS_END)
+			start = BIOS_END;
 	}
 	return start;
 }
