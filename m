Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbbAVUdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:33:44 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:48568 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbbAVUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:40 -0500
Date: Thu, 22 Jan 2015 14:33:36 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/16] ARM: integrator: convert PCI to use generic config
 accesses
Message-ID: <20150122203336.GD13072@google.com>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-8-git-send-email-robh@kernel.org>
 <CACRpkdbwKN9LenqrWeu4WykhdZOGAdxpC_BYr2cYpc2_cn5GfA@mail.gmail.com>
 <4938579.0KIk3QtTCP@wuerfel>
 <CACRpkdZSXWrVudiadVjbhQDS_zQrYttaytW-TUoeFUrc=beD1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZSXWrVudiadVjbhQDS_zQrYttaytW-TUoeFUrc=beD1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 01:05:12AM +0100, Linus Walleij wrote:
> On Sat, Jan 10, 2015 at 10:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 10 January 2015 22:40:22 Linus Walleij wrote:
> >> >  static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
> >> >                           int size, u32 *val)
> >> >  {
> >> > -       addr = v3_open_config_window(bus, devfn, where);
> >> > +       int ret = pci_generic_config_read(bus, devfn, where, size, val);
> >> >         v3_close_config_window();
> >> > +       return ret;
> >> >  }
> >> >
> >> >  static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
> >> >                            int size, u32 val)
> >> >  {
> >> > +       int ret = pci_generic_config_write(bus, devfn, where, size, val);
> >> >         v3_close_config_window();
> >> > -       raw_spin_unlock_irqrestore(&v3_lock, flags);
> >> > +       return ret;
> >> >  }
> >> >
> >> >  static struct pci_ops pci_v3_ops = {
> >> > +       .map_bus = v3_open_config_window,
> >> >         .read   = v3_read_config,
> >> >         .write  = v3_write_config,
> >>
> >> So .map_bus is called before every .read/.write operation I take it.
> >>
> >> Wouldn't it be proper to call the v3_close_config_window() from a
> >> matching .unmap_bus() callback for symmetry?
> >
> > It would be nicer for integrator but useless for anything else, so
> > I'd vote for leaving it the way Rob posted.
> 
> OK I buy that, throw in a comment about it in the code if there
> is some time for iterating the patch.

Would you prefer something like the following instead?  It keeps the
v3_open/close symmetry, but it does break apart and duplicate some of the
logic from v3_open_config_window().

I can't build or test this.


commit 3e0c269a560968002298d22ac47bde4bd45aea8e
Author: Rob Herring <robh@kernel.org>
Date:   Fri Jan 9 20:34:41 2015 -0600

    ARM: integrator: Convert PCI to use generic config accessors
    
    Convert the integrator PCI driver to use the generic config access
    functions.
    
    This changes accesses from __raw_readX/__raw_writeX to readX/writeX
    variants.  The spinlock is removed because it is unnecessary.  The config
    read and write functions are already protected with a spinlock and no
    access can occur during the .pre_init function.
    
    Signed-off-by: Rob Herring <robh@kernel.org>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    CC: Russell King <linux@arm.linux.org.uk>
    CC: linux-arm-kernel@lists.infradead.org

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index c186a17c2cff..c1098729cf8a 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -324,7 +324,7 @@ static u64 pre_mem_pci_sz;
  * configuration address space, you present the V3 with the following pattern
  * (which is very nearly a type 1 (except that the lower two bits are 00 and
  * not 01).   In order for this mapping to work you need to set up one of
- * the local to PCI aperatures to 16Mbytes in length translating to
+ * the local to PCI apertures to 16Mbytes in length translating to
  * PCI configuration space starting at 0x0000.0000.
  *
  * PCI configuration cycles look like this:
@@ -356,15 +356,14 @@ static u64 pre_mem_pci_sz;
  *	 7:2	register number
  *
  */
-static DEFINE_RAW_SPINLOCK(v3_lock);
 
 #undef V3_LB_BASE_PREFETCH
 #define V3_LB_BASE_PREFETCH 0
 
-static void __iomem *v3_open_config_window(struct pci_bus *bus,
-					   unsigned int devfn, int offset)
+static void v3_open_config_window(struct pci_bus *bus, unsigned int devfn,
+				  int offset)
 {
-	unsigned int address, mapaddress, busnr;
+	unsigned int mapaddress, busnr;
 
 	busnr = bus->number;
 
@@ -381,14 +380,10 @@ static void __iomem *v3_open_config_window(struct pci_bus *bus,
 		/*
 		 * local bus segment so need a type 0 config cycle
 		 *
-		 * build the PCI configuration "address" with one-hot in
-		 * A31-A11
-		 *
 		 * mapaddress:
 		 *  3:1 = config cycle (101)
 		 *  0   = PCI A1 & A0 are 0 (0)
 		 */
-		address = PCI_FUNC(devfn) << 8;
 		mapaddress = V3_LB_MAP_TYPE_CONFIG;
 
 		if (slot > 12)
@@ -396,26 +391,15 @@ static void __iomem *v3_open_config_window(struct pci_bus *bus,
 			 * high order bits are handled by the MAP register
 			 */
 			mapaddress |= 1 << (slot - 5);
-		else
-			/*
-			 * low order bits handled directly in the address
-			 */
-			address |= 1 << (slot + 11);
 	} else {
         	/*
 		 * not the local bus segment so need a type 1 config cycle
 		 *
-		 * address:
-		 *  23:16 = bus number
-		 *  15:11 = slot number (7:3 of devfn)
-		 *  10:8  = func number (2:0 of devfn)
-		 *
 		 * mapaddress:
 		 *  3:1 = config cycle (101)
 		 *  0   = PCI A1 & A0 from host bus (1)
 		 */
 		mapaddress = V3_LB_MAP_TYPE_CONFIG | V3_LB_MAP_AD_LOW_EN;
-		address = (busnr << 16) | (devfn << 8);
 	}
 
 	/*
@@ -432,8 +416,6 @@ static void __iomem *v3_open_config_window(struct pci_bus *bus,
 	v3_writel(V3_LB_BASE1, v3_addr_to_lb_base(conf_mem.start) |
 			V3_LB_BASE_ADR_SIZE_16MB | V3_LB_BASE_ENABLE);
 	v3_writew(V3_LB_MAP1, mapaddress);
-
-	return PCI_CONFIG_VADDR + address + offset;
 }
 
 static void v3_close_config_window(void)
@@ -454,70 +436,66 @@ static void v3_close_config_window(void)
 			V3_LB_BASE_ADR_SIZE_256MB | V3_LB_BASE_ENABLE);
 }
 
-static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
-			  int size, u32 *val)
+static void __iomem *v3_map_bus(struct pci_bus *bus,
+					   unsigned int devfn, int offset)
 {
-	void __iomem *addr;
-	unsigned long flags;
-	u32 v;
+	unsigned int busnr = bus->number;
+	unsigned int address;
 
-	raw_spin_lock_irqsave(&v3_lock, flags);
-	addr = v3_open_config_window(bus, devfn, where);
-
-	switch (size) {
-	case 1:
-		v = __raw_readb(addr);
-		break;
+	if (busnr == 0) {
+		int slot = PCI_SLOT(devfn);
 
-	case 2:
-		v = __raw_readw(addr);
-		break;
+		/*
+		 * build the PCI configuration "address" with function in
+		 * A10-A8 and device one-hot in A31-A11
+		 */
+		address = PCI_FUNC(devfn) << 8;
 
-	default:
-		v = __raw_readl(addr);
-		break;
+		/*
+		 * high order bits are handled by the MAP register;
+		 * low order bits handled directly in the address
+		 */
+		if (slot <= 12)
+			address |= 1 << (slot + 11);
+	} else {
+		/*
+		 * not the local bus segment so need a type 1 config cycle
+		 *
+		 * address:
+		 *  23:16 = bus number
+		 *  15:11 = slot number (7:3 of devfn)
+		 *  10:8  = func number (2:0 of devfn)
+		 */
+		address = (busnr << 16) | (devfn << 8);
 	}
 
-	v3_close_config_window();
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
+	return PCI_CONFIG_VADDR + address + offset;
+}
+
+static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
+			  int size, u32 *val)
+{
+	int ret;
 
-	*val = v;
-	return PCIBIOS_SUCCESSFUL;
+	v3_open_config_window();
+	ret = pci_generic_config_read(bus, devfn, where, size, val);
+	v3_close_config_window();
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
+	int ret;
 
+	v3_open_config_window();
+	ret = pci_generic_config_write(bus, devfn, where, size, val);
 	v3_close_config_window();
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
-
-	return PCIBIOS_SUCCESSFUL;
+	return ret;
 }
 
 static struct pci_ops pci_v3_ops = {
+	.map_bus = v3_map_bus,
 	.read	= v3_read_config,
 	.write	= v3_write_config,
 };
@@ -672,8 +650,6 @@ static void __init pci_v3_preinit(void)
 	hook_fault_code(8, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 	hook_fault_code(10, v3_pci_fault, SIGBUS, 0, "external abort on non-linefetch");
 
-	raw_spin_lock_irqsave(&v3_lock, flags);
-
 	/*
 	 * Unlock V3 registers, but only if they were previously locked.
 	 */
@@ -736,8 +712,6 @@ static void __init pci_v3_preinit(void)
 	v3_writew(V3_LB_CFG, v3_readw(V3_LB_CFG) | (1 << 10));
 	v3_writeb(V3_LB_IMASK, 0x28);
 	__raw_writel(3, ap_syscon_base + INTEGRATOR_SC_PCIENABLE_OFFSET);
-
-	raw_spin_unlock_irqrestore(&v3_lock, flags);
 }
 
 static void __init pci_v3_postinit(void)
