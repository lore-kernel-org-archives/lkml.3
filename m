Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKKMvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:51:52 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40598 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKKMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:51:51 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: sa11x0: Use void __iomem * in MMIO accessors
Date: Tue, 11 Nov 2014 13:51:48 +0100
Message-Id: <1415710308-29662-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

MMIO accessors such as readl() and writel() want a void __iomem * for
the address. Update the BSE nanoEngine PCI driver to pass such pointers
instead of unsigned long in preparation to converting ARM to use generic
and more rigidly typed accessors.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Hi Arnd,

This is a follow-up patch to the asm-generic/io.h overhaul series that
fixes a couple of build warnings reported by Fengguang's build system.
I've sorted this near the beginning of the series, like so:

	ARM: ebsa110: Properly override I/O accessors
	ARM: sa11x0: Use void __iomem * in MMIO accessors
	ARC: Remove redundant PCI_IOBASE declaration

But I think anywhere before commit

	ARM: Use include/asm-generic/io.h

should be fine, too.

Thierry

 arch/arm/mach-sa1100/pci-nanoengine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
index ff02e2da99f2..b704433c529c 100644
--- a/arch/arm/mach-sa1100/pci-nanoengine.c
+++ b/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -33,12 +33,12 @@
 static DEFINE_SPINLOCK(nano_lock);
 
 static int nanoengine_get_pci_address(struct pci_bus *bus,
-	unsigned int devfn, int where, unsigned long *address)
+	unsigned int devfn, int where, void __iomem **address)
 {
 	int ret = PCIBIOS_DEVICE_NOT_FOUND;
 	unsigned int busnr = bus->number;
 
-	*address = NANO_PCI_CONFIG_SPACE_VIRT +
+	*address = (void __iomem *)NANO_PCI_CONFIG_SPACE_VIRT +
 		((bus->number << 16) | (devfn << 8) | (where & ~3));
 
 	ret = (busnr > 255 || devfn > 255 || where > 255) ?
@@ -51,7 +51,7 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
 	int size, u32 *val)
 {
 	int ret;
-	unsigned long address;
+	void __iomem *address;
 	unsigned long flags;
 	u32 v;
 
@@ -85,7 +85,7 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
 	int size, u32 val)
 {
 	int ret;
-	unsigned long address;
+	void __iomem *address;
 	unsigned long flags;
 	unsigned shift;
 	u32 v;
-- 
2.1.3

