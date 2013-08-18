Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3HRUdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3HRUda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-mips@linux-mips.org
Subject: [ 04/34] MIPS: Expose missing pci_io{map,unmap} declarations
Date: Sun, 18 Aug 2013 13:34:17 -0700
Message-Id: <20130818203259.963776562@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 78857614104a26cdada4c53eea104752042bf5a1 upstream.

The GENERIC_PCI_IOMAP does not depend on CONFIG_PCI so move
it to the CONFIG_MIPS symbol so it's always selected for MIPS.
This fixes the missing pci_iomap declaration for MIPS.
Moreover, the pci_iounmap function was not defined in the
io.h header file if the CONFIG_PCI symbol is not set,
but it should since MIPS is not using CONFIG_GENERIC_IOMAP.

This fixes the following problem on a allyesconfig:

drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of
function 'pci_iomap' [-Werror=implicit-function-declaration]
drivers/net/ethernet/3com/3c59x.c:1044:3: error: implicit declaration of
function 'pci_iounmap' [-Werror=implicit-function-declaration]

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Acked-by: Steven J. Hill <Steven.Hill@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/5478/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/Kconfig          |    2 +-
 arch/mips/include/asm/io.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -24,6 +24,7 @@ config MIPS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_PCI_IOMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
 	select HAVE_MEMBLOCK
@@ -2356,7 +2357,6 @@ config PCI
 	bool "Support for PCI controller"
 	depends on HW_HAS_PCI
 	select PCI_DOMAINS
-	select GENERIC_PCI_IOMAP
 	select NO_GENERIC_PCI_IOPORT_MAP
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -168,6 +168,11 @@ static inline void * isa_bus_to_virt(uns
 extern void __iomem * __ioremap(phys_t offset, phys_t size, unsigned long flags);
 extern void __iounmap(const volatile void __iomem *addr);
 
+#ifndef CONFIG_PCI
+struct pci_dev;
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
+#endif
+
 static inline void __iomem * __ioremap_mode(phys_t offset, unsigned long size,
 	unsigned long flags)
 {


