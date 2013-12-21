Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3LUSuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 13:50:51 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44399 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3LUSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 13:50:49 -0500
Date: Sat, 21 Dec 2013 11:50:45 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 10/10] intel-gtt: Read 64bit for gmar_bus_addr
Message-ID: <20131221185045.GA22728@google.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
 <1385429290-25397-11-git-send-email-yinghai@kernel.org>
 <CAErSpo7THxjUQ=EWxicPYCwQCHReJ=sxPyPPRFv4QQ=ex6wmOA@mail.gmail.com>
 <CAE9FiQUDkuBnuYo4OfZncFw6k22PcapgjqzapVFt5UneiqoVDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUDkuBnuYo4OfZncFw6k22PcapgjqzapVFt5UneiqoVDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Daniel]

On Fri, Dec 20, 2013 at 05:19:38PM -0800, Yinghai Lu wrote:
> On Fri, Dec 20, 2013 at 4:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> 
> > Why are we reading these BARs directly anyway?  These look like
> > standard PCI BARs (I810_GMADDR == 0x10 and I915_GMADDR == 0x18), so
> > the PCI core should already be reading them correctly, shouldn't it?
> > Can't we just use pcibios_resource_to_bus(pci_resource_start())?
> >
> > It looks like i810_setup(), i830_setup(), and i9xx_setup() have the
> > same problem and should also be using pci_resource_start() or
> > something similar.
> 
> Agreed.
> 
> should be sth like:
> 
> 
> Index: linux-2.6/drivers/char/agp/intel-gtt.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/agp/intel-gtt.c
> +++ linux-2.6/drivers/char/agp/intel-gtt.c
> @@ -608,9 +608,9 @@ static bool intel_gtt_can_wc(void)
> 
>  static int intel_gtt_init(void)
>  {
> -       u32 gma_addr;
> +       struct pci_bus_region r;
>         u32 gtt_map_size;
> -       int ret;
> +       int ret, idx;
> 
>         ret = intel_private.driver->setup();
>         if (ret != 0)
> @@ -660,13 +660,14 @@ static int intel_gtt_init(void)
>         }
> 
>         if (INTEL_GTT_GEN <= 2)
> -               pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
> -                                     &gma_addr);
> +               idx = 0; /* I810_GMADDR */
>         else
> -               pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
> -                                     &gma_addr);
> +               idx = 2; /* I915_GMADDR */
> 
> -       intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
> +       pcibios_resource_to_bus(intel_private.pcidev->bus, &r,
> +                               &intel_private.pcidev->resource[idx]);
> +
> +       intel_private.gma_bus_addr = r.start;
> 
>         return 0;
>  }

I think it's even worse than we first thought.  Not only does the current
code fail on 64-bit BARs, but it also ignores the CPU/bus address
difference, and I think we want the CPU address.  So I think we need
something like these:


commit 8ba262d78f9d218672486c62ba6a1c7a073bd272
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Sat Dec 21 10:49:58 2013 -0700

    agp/intel: Rename "*_bus_addr" to "*_phys_addr"
    
    We're dealing with CPU physical addresses here, which may be different from
    bus addresses, so rename "gtt_bus_addr" to "gtt_phys_addr" and
    "gma_bus_addr" to "gma_phys_addr" to avoid confusion.
    
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index b8e2014cb9cb..dca04a6aa7f8 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -64,7 +64,7 @@ static struct _intel_private {
 	struct pci_dev *pcidev;	/* device one */
 	struct pci_dev *bridge_dev;
 	u8 __iomem *registers;
-	phys_addr_t gtt_bus_addr;
+	phys_addr_t gtt_phys_addr;
 	u32 PGETBL_save;
 	u32 __iomem *gtt;		/* I915G */
 	bool clear_fake_agp; /* on first access via agp, fill with scratch */
@@ -78,7 +78,7 @@ static struct _intel_private {
 	int refcount;
 	/* Whether i915 needs to use the dmar apis or not. */
 	unsigned int needs_dmar : 1;
-	phys_addr_t gma_bus_addr;
+	phys_addr_t gma_phys_addr;
 	/*  Size of memory reserved for graphics by the BIOS */
 	unsigned int stolen_size;
 	/* Total number of gtt entries. */
@@ -191,7 +191,7 @@ static int i810_setup(void)
 	writel(virt_to_phys(gtt_table) | I810_PGETBL_ENABLED,
 	       intel_private.registers+I810_PGETBL_CTL);
 
-	intel_private.gtt_bus_addr = reg_addr + I810_PTE_BASE;
+	intel_private.gtt_phys_addr = reg_addr + I810_PTE_BASE;
 
 	if ((readl(intel_private.registers+I810_DRAM_CTL)
 		& I810_DRAM_ROW_0) == I810_DRAM_ROW_0_SDRAM) {
@@ -636,10 +636,10 @@ static int intel_gtt_init(void)
 
 	intel_private.gtt = NULL;
 	if (intel_gtt_can_wc())
-		intel_private.gtt = ioremap_wc(intel_private.gtt_bus_addr,
+		intel_private.gtt = ioremap_wc(intel_private.gtt_phys_addr,
 					       gtt_map_size);
 	if (intel_private.gtt == NULL)
-		intel_private.gtt = ioremap(intel_private.gtt_bus_addr,
+		intel_private.gtt = ioremap(intel_private.gtt_phys_addr,
 					    gtt_map_size);
 	if (intel_private.gtt == NULL) {
 		intel_private.driver->cleanup();
@@ -666,7 +666,7 @@ static int intel_gtt_init(void)
 		pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
 				      &gma_addr);
 
-	intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+	intel_private.gma_phys_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
 
 	return 0;
 }
@@ -796,7 +796,7 @@ static int i830_setup(void)
 	if (!intel_private.registers)
 		return -ENOMEM;
 
-	intel_private.gtt_bus_addr = reg_addr + I810_PTE_BASE;
+	intel_private.gtt_phys_addr = reg_addr + I810_PTE_BASE;
 
 	return 0;
 }
@@ -821,7 +821,7 @@ static int intel_fake_agp_configure(void)
 	    return -EIO;
 
 	intel_private.clear_fake_agp = true;
-	agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
+	agp_bridge->gart_bus_addr = intel_private.gma_phys_addr;
 
 	return 0;
 }
@@ -1123,13 +1123,13 @@ static int i9xx_setup(void)
 	case 3:
 		pci_read_config_dword(intel_private.pcidev,
 				      I915_PTEADDR, &gtt_addr);
-		intel_private.gtt_bus_addr = gtt_addr;
+		intel_private.gtt_phys_addr = gtt_addr;
 		break;
 	case 5:
-		intel_private.gtt_bus_addr = reg_addr + MB(2);
+		intel_private.gtt_phys_addr = reg_addr + MB(2);
 		break;
 	default:
-		intel_private.gtt_bus_addr = reg_addr + KB(512);
+		intel_private.gtt_phys_addr = reg_addr + KB(512);
 		break;
 	}
 
@@ -1409,7 +1409,7 @@ void intel_gtt_get(size_t *gtt_total, size_t *stolen_size,
 {
 	*gtt_total = intel_private.gtt_total_entries << PAGE_SHIFT;
 	*stolen_size = intel_private.stolen_size;
-	*mappable_base = intel_private.gma_bus_addr;
+	*mappable_base = intel_private.gma_phys_addr;
 	*mappable_end = intel_private.gtt_mappable_entries << PAGE_SHIFT;
 }
 EXPORT_SYMBOL(intel_gtt_get);

commit 31349de4ce32a0c2c2d14df35717544e94d56066
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Sat Dec 21 10:09:19 2013 -0700

    intel-gtt: Use CPU address (not BAR value) for GART
    
    There were two problems here:
    
      1) The GMADR can be either a 32-bit or a 64-bit BAR, but we only read the
         low 32 bits, so this failed if GMADR was above 4GB.
    
      2) The value read from the BAR is a bus address, not a CPU physical
         address, and these may be different.
    
    Use pci_resource_start() instead of reading the BAR directly to remove the
    BAR size and bus/CPU address issue, as gen8_gmch_probe() already does.
    
    Reference: http://lkml.kernel.org/r/1385429290-25397-11-git-send-email-yinghai@kernel.org
    Based-on-patch-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index dca04a6aa7f8..35169ff0ffe1 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -610,7 +610,7 @@ static int intel_gtt_init(void)
 {
 	u32 gma_addr;
 	u32 gtt_map_size;
-	int ret;
+	int ret, bar;
 
 	ret = intel_private.driver->setup();
 	if (ret != 0)
@@ -660,14 +660,12 @@ static int intel_gtt_init(void)
 	}
 
 	if (INTEL_GTT_GEN <= 2)
-		pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
-				      &gma_addr);
+		bar = 0;	/* I810_GMADDR */
 	else
-		pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
-				      &gma_addr);
-
-	intel_private.gma_phys_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+		bar = 2;	/* I915_GMADDR */
 
+	intel_private.gma_phys_addr = pci_resource_start(intel_private.pcidev,
+							 bar);
 	return 0;
 }
 
