Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbbAJCic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:38:32 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52545 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbbAJCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:41 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/16] ARM: integrator: convert PCI to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:41 -0600
Message-Id: <1420857290-8373-8-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the integrator PCI driver to use the generic config access
functions.

This changes accesses from __raw_readX/__raw_writeX to readX/writeX
variants. The spinlock is removed because it is unnecessary. The config
read and write functions are already protected with a spinlock and no
access can occur during the .pre_init function.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-integrator/pci_v3.c | 61 ++++-----------------------------------
 1 file changed, 5 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index c186a17..dc7782f 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -356,7 +356,6 @@ static u64 pre_mem_pci_sz;
  *	 7:2	register number
  *
  */
-static DEFINE_RAW_SPINLOCK(v3_lock);
 
 #undef V3_LB_BASE_PREFETCH
 #define V3_LB_BASE_PREFETCH 0
@@ -457,67 +456,21 @@ static void v3_close_config_window(void)
 static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 			  int size, u32 *val)
 {
-	void __iomem *addr;
-	unsigned long flags;
-	u32 v;
-
-	raw_spin_lock_irqsave(&v3_lock, flags);
-	addr = v3_open_config_window(bus, devfn, where);
-
-	switch (size) {
-	case 1:
-		v = __raw_readb(addr);
-		break;
-
-	case 2:
-		v = __raw_readw(addr);
-		break;
-
-	default:
-		v = __raw_readl(addr);
-		break;
-	}
-
+	int ret = pci_generic_config_read(bus, devfn, where, size, val);
 	v3_close_config_window();
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
-
-	*val = v;
-	return PCIBIOS_SUCCESSFUL;
+	return ret;
 }
 
 static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 			   int size, u32 val)
 {
-	void __iomem *addr;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&v3_lock, flags);
-	addr = v3_open_config_window(bus, devfn, where);
-
-	switch (size) {
-	case 1:
-		__raw_writeb((u8)val, addr);
-		__raw_readb(addr);
-		break;
-
-	case 2:
-		__raw_writew((u16)val, addr);
-		__raw_readw(addr);
-		break;
-
-	case 4:
-		__raw_writel(val, addr);
-		__raw_readl(addr);
-		break;
-	}
-
+	int ret = pci_generic_config_write(bus, devfn, where, size, val);
 	v3_close_config_window();
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
-
-	return PCIBIOS_SUCCESSFUL;
+	return ret;
 }
 
 static struct pci_ops pci_v3_ops = {
+	.map_bus = v3_open_config_window,
 	.read	= v3_read_config,
 	.write	= v3_write_config,
 };
@@ -672,8 +625,6 @@ static void __init pci_v3_preinit(void)
 	hook_fault_code(8, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 	hook_fault_code(10, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 
-	raw_spin_lock_irqsave(&v3_lock, flags);
-
 	/*
 	 * Unlock V3 registers, but only if they were previously locked.
 	 */
@@ -736,8 +687,6 @@ static void __init pci_v3_preinit(void)
 	v3_writew(V3_LB_CFG, v3_readw(V3_LB_CFG) | (1 << 10));
 	v3_writeb(V3_LB_IMASK, 0x28);
 	__raw_writel(3, ap_syscon_base + INTEGRATOR_SC_PCIENABLE_OFFSET);
-
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
 }
 
 static void __init pci_v3_postinit(void)
-- 
2.1.0

