Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3HMDk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:40:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58431 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3HMDk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:40:57 -0400
Date: Mon, 12 Aug 2013 20:40:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130813034054.GA18218@roeck-us.net>
References: <5207B3C3.9080508@roeck-us.net>
 <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net>
 <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 05:24:50PM +0100, Peter Maydell wrote:

[ ... ]

> If somebody would like to fix the kernel I am happy to
> locate the PCI backplane and test everything (again).
> I would suggest that producing some patches which work
> with QEMU 1.5 or later would be a good start; then we
> can test on h/w as confirmation before they are applied.
> 
Ok, putting a stake in the ground.

Patch tested and working with qemu 1.5.2, using the configuration file
from the yocto project. Patch applied on top of kernel version 3.11-rc5.

Guenter

---

>From 1e07521e935267f2d63ed3635fb93c7e325e0936 Mon Sep 17 00:00:00 2001
From: Guenter Roeck <linux@roeck-us.net>
Date: Mon, 12 Aug 2013 16:20:18 -0700
Subject: [PATCH] arm: Fix map_irq function for ARM versatile hardware

Booting the ARM versatile in qemu fails with the SCSI controller
timing out as follows:

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

Bisecting gives commit 1bc39ac5dab265b76ce6e20d6c85f900539fd190
("ARM: PCI: versatile: fix PCI interrupt setup") -- specifically
the change to use common swizzle instead of NULL.

Further analysis shows that interrupt mapping is wrong for the versatile
hardware.

Thanks to Paul Gortmaker for bisecting the problem and finding an initial
solution, to Russell King for providing the correct interrupt mapping,
and to Peter Maydell for tracking down board information.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/arm/mach-versatile/pci.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index e92e5e0..f435267 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -327,13 +327,13 @@ static int __init versatile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
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
-- 
1.7.9.7

