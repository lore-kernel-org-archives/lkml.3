Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaCRROO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:14:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46632 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaCRROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:14:06 -0400
Subject: [PATCH] Revert "[PATCH] Insert GART region into resource map"
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Durbin <adurbin@google.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ingo Molnar <mingo@redhat.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jouni =?utf-8?b?TWV0dMOkbMOk?= <jtmettala@gmail.com>
Date: Tue, 18 Mar 2014 11:14:01 -0600
Message-ID: <20140318171401.8189.46642.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140318170841.8189.7972.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140318170841.8189.7972.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 56dd669a138c, which makes the GART visible in
/proc/iomem.  This fixes a regression: e501b3d87f00 ("agp: Support 64-bit
APBASE") exposed an existing problem with a conflict between the GART
region and a PCI BAR region.

The GART addresses are bus addresses, not CPU addresses, and therefore
should not be inserted in iomem_resource.

On many machines, the GART region is addressable by the CPU as well as by
an AGP master, but CPU addressability is not required by the spec.  On some
of these machines, the GART is mapped by a PCI BAR, and in that case, the
PCI core automatically inserts it into iomem_resource, just as it does for
all BARs.

Inserting it here means we'll have a conflict if the PCI core later tries
to claim the GART region, so let's drop the insertion here.

The conflict indirectly causes X failures, as reported by Jouni in the
bugzilla below.  We detected the conflict even before e501b3d87f00, but
after it the AGP code (fix_northbridge()) uses the PCI resource (which is
zeroed because of the conflict) instead of reading the BAR again.

Conflicts:
	arch/x86_64/kernel/aperture.c

Fixes: e501b3d87f00 agp: Support 64-bit APBASE
Link: https://bugzilla.kernel.org/show_bug.cgi?id=72201
Reported-and-tested-by: Jouni Mettälä <jtmettala@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/aperture_64.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index fd972a3e4cbb..9fa8aa051f54 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -18,7 +18,6 @@
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
-#include <linux/ioport.h>
 #include <linux/suspend.h>
 #include <asm/e820.h>
 #include <asm/io.h>
@@ -54,18 +53,6 @@ int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 
-static struct resource gart_resource = {
-	.name	= "GART",
-	.flags	= IORESOURCE_MEM,
-};
-
-static void __init insert_aperture_resource(u32 aper_base, u32 aper_size)
-{
-	gart_resource.start = aper_base;
-	gart_resource.end = aper_base + aper_size - 1;
-	insert_resource(&iomem_resource, &gart_resource);
-}
-
 /* This code runs before the PCI subsystem is initialized, so just
    access the northbridge directly. */
 
@@ -96,7 +83,6 @@ static u32 __init allocate_aperture(void)
 	memblock_reserve(addr, aper_size);
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, addr);
-	insert_aperture_resource((u32)addr, aper_size);
 	register_nosave_region(addr >> PAGE_SHIFT,
 			       (addr+aper_size) >> PAGE_SHIFT);
 
@@ -444,12 +430,8 @@ int __init gart_iommu_hole_init(void)
 
 out:
 	if (!fix && !fallback_aper_force) {
-		if (last_aper_base) {
-			unsigned long n = (32 * 1024 * 1024) << last_aper_order;
-
-			insert_aperture_resource((u32)last_aper_base, n);
+		if (last_aper_base)
 			return 1;
-		}
 		return 0;
 	}
 

