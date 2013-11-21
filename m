Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3KUNjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:39:02 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:38987 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751225Ab3KUNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:39:00 -0500
MIME-Version: 1.0
In-Reply-To: <1382531997.14960.8.camel@mbp>
References: <1382529163-31968-1-git-send-email-tinamdar@apm.com>
	<1382531997.14960.8.camel@mbp>
Date: Thu, 21 Nov 2013 19:08:59 +0530
Message-ID: <CACoXjcmJPHdkrGRng8oWosgo9V_pLDNYw5Z3R_yN6w_rUe=G8Q@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: Add arch support for PCI
From: Tanmay Inamdar <tinamdar@apm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 6:09 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Hi Tanmay,
>
> On Wed, 2013-10-23 at 12:52 +0100, Tanmay Inamdar wrote:
>> This patch adds the PCI arch support in arm64 required by PCI
>> midlayer. The PCI support is based on support in 32bit arm arch.
>
> We had a discussion yesterday at the ARM mini-summit in Edinburgh about
> PCI(e) support on ARMv8. Rather than creating yet another
> implementation, there is a lot of code in there which is not arch
> specific and should rather be generalised. There are still some debates
> around whether to make the powerpc one generic (and it seems to have
> some advantages in terms of DT handling) or making parts of the AArch32
> implementation generic. ARM started looking into this but we don't yet
> have code to share.
>

Thanks for your reply.
It looks like my first email missed the mailing list.  Just pasting it
for the reference. Sorry for the inconvenience.
-->

This patch adds the PCI(e) arch support in arm64. The files are
based on PCI(e) support in 32bit arm.


Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/arm64/Kconfig               |   19 ++
 arch/arm64/include/asm/dma.h     |   18 +
 arch/arm64/include/asm/pci.h     |   74 ++++
 arch/arm64/include/asm/pcibios.h |   98 ++++++
 arch/arm64/kernel/Makefile       |    1 +
 arch/arm64/kernel/pcibios.c      |  689 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/Makefile           |    2 +-
 arch/arm64/mm/iomap.c            |   31 ++
 drivers/pci/Makefile             |    1 +
 9 files changed, 932 insertions(+), 1 deletion(-)

 create mode 100644 arch/arm64/include/asm/dma.h
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/include/asm/pcibios.h
 create mode 100644 arch/arm64/kernel/pcibios.c
 create mode 100644 arch/arm64/mm/iomap.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..54ffa0e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -115,6 +115,8 @@ config ARCH_VEXPRESS
   Express).

 config ARCH_XGENE
+ select PCI
+ select NO_GENERIC_PCI_IOPORT_MAP
  bool "AppliedMicro X-Gene SOC Family"
  help
   This enables support for AppliedMicro X-Gene SOC Family
@@ -126,6 +128,23 @@ menu "Bus support"
 config ARM_AMBA
  bool

+config PCI
+ bool "PCI support"
+ help
+  Find out whether you have a PCI motherboard. PCI is the name of a
+  bus system, i.e. the way the CPU talks to the other stuff inside
+  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+  VESA. If you have PCI, say Y, otherwise N.
+
+config PCI_DOMAINS
+ bool
+ depends on PCI
+
+config PCI_SYSCALL
+ def_bool PCI
+
+source "drivers/pci/Kconfig"
+
 endmenu

 menu "Kernel Features"index 0000000..810a408
--- /dev/null
+++ b/arch/arm64/kernel/pcibios.c
@@ -0,0 +1,689 @@+/*
+ * We don't use this to fix the device, but initialisation of it.
+ * It's not the correct use for this, but it works.
+ * Note that the arbiter/ISA bridge appears to be buggy, specifically in
+ * the following area:
+ * 1. park on CPU
+ * 2. ISA bridge ping-pong
+ * 3. ISA bridge master handling of target RETRY
+ *
+ * Bug 3 is responsible for the sound DMA grinding to a halt.  We now
+ * live with bug 2.
+ */
+static void pci_fixup_83c553(struct pci_dev *dev)
+{
+ /*
+ * Set memory region to start at address 0, and enable IO
+ */
+ pci_write_config_dword(dev, PCI_BASE_ADDRESS_0,
+       PCI_BASE_ADDRESS_SPACE_MEMORY);
+ pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_IO);

+
+ dev->resource[0].end -= dev->resource[0].start;
+ dev->resource[0].start = 0;
+
+ /*
+ * All memory requests from ISA to be channelled to PCI
+ */
+ pci_write_config_byte(dev, 0x48, 0xff);
+
+ /*
+ * Enable ping-pong on bus master to ISA bridge transactions.
+ * This improves the sound DMA substantially.  The fixed
+ * priority arbiter also helps (see below).
+ */
+ pci_write_config_byte(dev, 0x42, 0x01);
+
+ /*
+ * Enable PCI retry
+ */
+ pci_write_config_byte(dev, 0x40, 0x22);
+
+ /*
+ * We used to set the arbiter to "park on last master" (bit
+ * 1 set), but unfortunately the CyberPro does not park the
+ * bus.  We must therefore park on CPU.  Unfortunately, this
+ * may trigger yet another bug in the 553.
+ */
+ pci_write_config_byte(dev, 0x83, 0x02);
+
+ /*
+ * Make the ISA DMA request lowest priority, and disable
+ * rotating priorities completely.
+ */
+ pci_write_config_byte(dev, 0x80, 0x11);
+ pci_write_config_byte(dev, 0x81, 0x00);
+
+ /*
+ * Route INTA input to IRQ 11, and set IRQ11 to be level
+ * sensitive.
+ */
+ pci_write_config_word(dev, 0x44, 0xb000);
+ outb(0x08, 0x4d1);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_83C553,
+ pci_fixup_83c553);+/*
+ * The CY82C693 needs some rather major fixups to ensure that it does
+ * the right thing.  Idea from the Alpha people, with a few additions.
+ *
+ * We ensure that the IDE base registers are set to 1f0/3f4 for the
+ * primary bus, and 170/374 for the secondary bus.  Also, hide them
+ * from the PCI subsystem view as well so we won't try to perform
+ * our own auto-configuration on them.
+ *
+ * In addition, we ensure that the PCI IDE interrupts are routed to
+ * IRQ 14 and IRQ 15 respectively.
+ *
+ * The above gets us to a point where the IDE on this device is
+ * functional.  However, The CY82C693U _does not work_ in bus
+ * master mode without locking the PCI bus solid.
+ */
+static void pci_fixup_cy82c693(struct pci_dev *dev)
+{
+ if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
+ u32 base0, base1;
+
+ if (dev->class & 0x80) { /* primary */
+ base0 = 0x1f0;
+ base1 = 0x3f4;
+ } else { /* secondary */
+ base0 = 0x170;
+ base1 = 0x374;
+ }
+
+ pci_write_config_dword(dev, PCI_BASE_ADDRESS_0,
+       base0 | PCI_BASE_ADDRESS_SPACE_IO);
+ pci_write_config_dword(dev, PCI_BASE_ADDRESS_1,
+       base1 | PCI_BASE_ADDRESS_SPACE_IO);
+
+ dev->resource[0].start = 0;
+ dev->resource[0].end = 0;
+ dev->resource[0].flags = 0;
+
+ dev->resource[1].start = 0;
+ dev->resource[1].end = 0;
+ dev->resource[1].flags = 0;
+ } else if (PCI_FUNC(dev->devfn) == 0) {
+ /*
+ * Setup IDE IRQ routing.
+ */
+ pci_write_config_byte(dev, 0x4b, 14);
+ pci_write_config_byte(dev, 0x4c, 15);
+
+ /*
+ * Disable FREQACK handshake, enable USB.
+ */
+ pci_write_config_byte(dev, 0x4d, 0x41);
+
+ /*
+ * Enable PCI retry, and PCI post-write buffer.
+ */
+ pci_write_config_byte(dev, 0x44, 0x17);
+
+ /*
+ * Enable ISA master and DMA post write buffering.
+ */
+ pci_write_config_byte(dev, 0x45, 0x03);
+ }
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693,
+ pci_fixup_cy82c693);index 0000000..42585c6
--- /dev/null
+++ b/arch/arm64/mm/iomap.c
@@ -0,0 +1,31 @@

+/*
+ *  Based on linux/arch/arm/mm/iomap.c
+ *
+ * Map IO port and PCI memory spaces so that {read,write}[bwl] can
+ * be used to access this memory.
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+
+#ifdef __io
+void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+ return __io(port);
+}
+EXPORT_SYMBOL(ioport_map);
+
+void ioport_unmap(void __iomem *addr)
+{
+}
+EXPORT_SYMBOL(ioport_unmap);
+#endif

+
+#ifdef CONFIG_PCI
+unsigned long pcibios_min_io = 0x1000;
+EXPORT_SYMBOL(pcibios_min_io);
+
+unsigned long pcibios_min_mem = 0x01000000;
+EXPORT_SYMBOL(pcibios_min_mem);
+#endif
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 6ebf5bf..0f3f821 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_MICROBLAZE) += setup-bus.o
 obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
 obj-$(CONFIG_SPARC_LEON) += setup-bus.o setup-irq.o
 obj-$(CONFIG_M68K) += setup-bus.o setup-irq.o
+obj-$(CONFIG_ARM64) += setup-bus.o setup-irq.o

 #
 # ACPI Related PCI FW Functions


> Catalin
>
