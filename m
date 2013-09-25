Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3IYAUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3IYAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [ 021/117] ARM: PCI: versatile: Fix map_irq function to match hardware
Date: Tue, 24 Sep 2013 17:18:07 -0700
Message-Id: <20130925001743.159577586@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Maydell <peter.maydell@linaro.org>

commit f9b71fef12f0d6ac5c7051cfd87f7700f78c56b6 upstream.

The PCI controller code for the Versatile board has never had the
correct IRQ mapping for hardware.  For many years it had an odd
mapping ("all interrupts are int 27") which aligned with the
equivalent bug in QEMU.  However as of commit 1bc39ac5dab265
the mapping changed and no longer matched either hardware or QEMU,
with the result that any PCI card beyond the first in QEMU would
not have functioning interrupts; for example a boot with a SCSI
controller would time out as follows:

 ------------
 sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 92
 sym0: SCSI BUS has been reset.
 scsi0 : sym-2.2.3
 [...]
 scsi 0:0:0:0: ABORT operation started
 scsi 0:0:0:0: ABORT operation timed-out.
 scsi 0:0:0:0: DEVICE RESET operation started
 scsi 0:0:0:0: DEVICE RESET operation timed-out.
 scsi 0:0:0:0: BUS RESET operation started
 scsi 0:0:0:0: BUS RESET operation timed-out.
 scsi 0:0:0:0: HOST RESET operation started
 sym0: SCSI BUS has been reset
 ------------

Fix the mapping so that it matches real hardware (checked against the
schematics for PB926 and backplane, and tested against the hardware).
This allows PCI cards using interrupts to work on hardware for the
first time; this change will also work with QEMU 1.5 or later, where
the equivalent bugs in the modelling of the hardware have been fixed.

Although QEMU will attempt to autodetect whether the kernel is
expecting the long-standing "everything is int 27" mapping or the one
hardware has, for certainty we force it into "definitely behave like
hardware mode"; this will avoid unexpected surprises later if we
implement sparse irqs. This is harmless on hardware.

Thanks to Paul Gortmaker for bisecting the problem and finding an initial
solution, to Russell King for providing the correct interrupt mapping,
and to Guenter Roeck for providing an initial version of this patch
and prodding me into relocating the hardware and retesting everything.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-versatile/pci.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -295,6 +295,19 @@ int __init pci_versatile_setup(int nr, s
 	__raw_writel(PHYS_OFFSET, local_pci_cfg_base + PCI_BASE_ADDRESS_2);
 
 	/*
+	 * For many years the kernel and QEMU were symbiotically buggy
+	 * in that they both assumed the same broken IRQ mapping.
+	 * QEMU therefore attempts to auto-detect old broken kernels
+	 * so that they still work on newer QEMU as they did on old
+	 * QEMU. Since we now use the correct (ie matching-hardware)
+	 * IRQ mapping we write a definitely different value to a
+	 * PCI_INTERRUPT_LINE register to tell QEMU that we expect
+	 * real hardware behaviour and it need not be backwards
+	 * compatible for us. This write is harmless on real hardware.
+	 */
+	__raw_writel(0, VERSATILE_PCI_VIRT_BASE+PCI_INTERRUPT_LINE);
+
+	/*
 	 * Do not to map Versatile FPGA PCI device into memory space
 	 */
 	pci_slot_ignore |= (1 << myslot);
@@ -327,13 +340,13 @@ static int __init versatile_map_irq(cons
 {
 	int irq;
 
-	/* slot,  pin,	irq
-	 *  24     1     IRQ_SIC_PCI0
-	 *  25     1     IRQ_SIC_PCI1
-	 *  26     1     IRQ_SIC_PCI2
-	 *  27     1     IRQ_SIC_PCI3
+	/*
+	 * Slot	INTA	INTB	INTC	INTD
+	 * 31	PCI1	PCI2	PCI3	PCI0
+	 * 30	PCI0	PCI1	PCI2	PCI3
+	 * 29	PCI3	PCI0	PCI1	PCI2
 	 */
-	irq = IRQ_SIC_PCI0 + ((slot - 24 + pin - 1) & 3);
+	irq = IRQ_SIC_PCI0 + ((slot + 2 + pin - 1) & 3);
 
 	return irq;
 }


