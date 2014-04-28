Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbaD1VLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:11:48 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58521 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbaD1VLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:11:45 -0400
Date: Mon, 28 Apr 2014 15:11:41 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: linux-next: Tree for Apr 28 (drivers/pnp/quirks.c)
Message-ID: <20140428211141.GA24070@google.com>
References: <20140428165724.6361cf10ebd3067b7f998c0f@canb.auug.org.au>
 <535E93C1.90908@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E93C1.90908@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:45:37AM -0700, Randy Dunlap wrote:
> On 04/27/14 23:57, Stephen Rothwell wrote:
> > Hi all,
> > 
> > This tree still fails (more than usual) the powerpc allyesconfig build.
> > 
> > Changes since 20140424:
> > 
> 
> on i386:
> 
>   CC      drivers/pnp/quirks.o
> drivers/pnp/quirks.c: In function 'quirk_intel_mch':
> drivers/pnp/quirks.c:393:2: error: implicit declaration of function 'pcibios_bus_to_resource' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/pnp/quirks.o] Error 1

Thanks Randy.  This is a config that doesn't define CONFIG_PCI.  Rafael,
here's an incremental fix, or the full updated patch is below.


diff -u b/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
--- b/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -335,7 +335,7 @@
 }
 #endif
 
-#ifdef CONFIG_X86
+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
 /* Device IDs of parts that have 32KB MCH space */
 static const unsigned int mch_quirk_devices[] = {
 	0x0154,	/* Ivy Bridge */
@@ -440,7 +440,7 @@
 #ifdef CONFIG_AMD_NB
 	{"PNP0c01", quirk_amd_mmconfig_area},
 #endif
-#ifdef CONFIG_X86
+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
 	{"PNP0c02", quirk_intel_mch},
 #endif
 	{""}


Full updated commit below:

commit 742fd103a3fbf2d5b0ed1f2a0f20ff234a82949b
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Thu Apr 17 14:22:18 2014 -0600

    PNP: Work around BIOS defects in Intel MCH area reporting
    
    Work around BIOSes that don't report the entire Intel MCH area.
    
    MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
    PNP0C02 resource.  The MCH space was once 16KB, but is 32KB in newer parts.
    Some BIOSes still report a PNP0C02 resource that is only 16KB, which means
    the rest of the MCH space is consumed but unreported.
    
    This can cause resource map sanity check warnings or (theoretically) a
    device conflict if we assigned the unreported space to another device.
    
    The Intel perf event uncore driver tripped over this when it claimed the
    MCH region:
    
      resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
      Info: mapping multiple BARs. Your kernel is fine.
    
    To prevent this, if we find a PNP0C02 resource that covers part of the MCH
    space, extend it to cover the entire space.
    
    Link: http://lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
    Reported-by: Borislav Petkov <bp@alien8.de>
    Tested-by: Borislav Petkov <bp@suse.de>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Borislav Petkov <bp@suse.de>
    Acked-by: Stephane Eranian <eranian@google.com>

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 258fef272ea7..2fc505df5daf 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/pci.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
@@ -334,6 +335,81 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
 }
 #endif
 
+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
+/* Device IDs of parts that have 32KB MCH space */
+static const unsigned int mch_quirk_devices[] = {
+	0x0154,	/* Ivy Bridge */
+	0x0c00,	/* Haswell */
+};
+
+static struct pci_dev *get_intel_host(void)
+{
+	int i;
+	struct pci_dev *host;
+
+	for (i = 0; i < ARRAY_SIZE(mch_quirk_devices); i++) {
+		host = pci_get_device(PCI_VENDOR_ID_INTEL, mch_quirk_devices[i],
+				      NULL);
+		if (host)
+			return host;
+	}
+	return NULL;
+}
+
+static void quirk_intel_mch(struct pnp_dev *dev)
+{
+	struct pci_dev *host;
+	u32 addr_lo, addr_hi;
+	struct pci_bus_region region;
+	struct resource mch;
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+
+	host = get_intel_host();
+	if (!host)
+		return;
+
+	/*
+	 * MCHBAR is not an architected PCI BAR, so MCH space is usually
+	 * reported as a PNP0C02 resource.  The MCH space was originally
+	 * 16KB, but is 32KB in newer parts.  Some BIOSes still report a
+	 * PNP0C02 resource that is only 16KB, which means the rest of the
+	 * MCH space is consumed but unreported.
+	 */
+
+	/*
+	 * Read MCHBAR for Host Member Mapped Register Range Base
+	 * https://www-ssl.intel.com/content/www/us/en/processors/core/4th-gen-core-family-desktop-vol-2-datasheet
+	 * Sec 3.1.12.
+	 */
+	pci_read_config_dword(host, 0x48, &addr_lo);
+	region.start = addr_lo & ~0x7fff;
+	pci_read_config_dword(host, 0x4c, &addr_hi);
+	region.start |= (u64) addr_hi << 32;
+	region.end = region.start + 32*1024 - 1;
+
+	memset(&mch, 0, sizeof(mch));
+	mch.flags = IORESOURCE_MEM;
+	pcibios_bus_to_resource(host->bus, &mch, &region);
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (res->end < mch.start || res->start > mch.end)
+			continue;	/* no overlap */
+		if (res->start == mch.start && res->end == mch.end)
+			continue;	/* exact match */
+
+		dev_info(&dev->dev, FW_BUG "PNP resource %pR covers only part of %s Intel MCH; extending to %pR\n",
+			 res, pci_name(host), &mch);
+		res->start = mch.start;
+		res->end = mch.end;
+		break;
+	}
+
+	pci_dev_put(host);
+}
+#endif
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -364,6 +440,9 @@ static struct pnp_fixup pnp_fixups[] = {
 #ifdef CONFIG_AMD_NB
 	{"PNP0c01", quirk_amd_mmconfig_area},
 #endif
+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
+	{"PNP0c02", quirk_intel_mch},
+#endif
 	{""}
 };
 
