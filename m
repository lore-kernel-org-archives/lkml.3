Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaCQXwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:52:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53712 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaCQXwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:52:45 -0400
Date: Mon, 17 Mar 2014 17:52:40 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jouni =?iso-8859-1?Q?Mett=E4l=E4?= <jtmettala@gmail.com>
Cc: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Yinghai Lu <yinghai@kernel.org>, Guo Chao <yan@linux.vnet.ibm.com>,
        David Airlie <airlied@linux.ie>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] e501 "agp: Support 64-bit APBASE" agp fails without
 iommu=remap=2
Message-ID: <20140317235240.GA14292@google.com>
References: <CAGG0vUg+No2GHLbOLQzV+fNm37OW-pfhmoQ3moxhr8uEObj9pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG0vUg+No2GHLbOLQzV+fNm37OW-pfhmoQ3moxhr8uEObj9pQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Daniel, Dave, Yinghai, Guo, Aaron, LKML]

On Sat, Mar 15, 2014 at 02:32:22PM +0200, Jouni Mettälä wrote:
> Hi. I can't start xsession without iommu=remap=2 kernel parameter.
> 
> Kernel bisect lead to this commit
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e501b3d87f003dfad8fcbd0f55ae17ea52495a56
> 
> Reverting e501b3d87f003dfad8fcbd0f55ae17ea52495a56 fixes if for me.
> 
> I think this is relevant part of dmesg from affected kernel
> 
> agpgart-amd64 0000:00:04.0: AGP bridge [10b9/1689]
> agpgart-amd64 0000:00:04.0: aperture from AGP @ 0 size 4096 MB
> pci 0000:00:18.3: no usable aperture found
> pci 0000:00:18.3: consider rebooting with iommu=memaper=2 to get a good
> aperture
> agpgart-amd64 0000:00:04.0: AGP bridge [10b9/1689]
> agpgart-amd64 0000:00:04.0: aperture from AGP @ 0 size 4096 MB
> pci 0000:00:18.3: no usable aperture found
> pci 0000:00:18.3: consider rebooting with iommu=memaper=2 to get a good
> aperture
> agpgart-amd64 0000:04:00.0: AGP bridge [1002/4150]
> agpgart-amd64 0000:04:00.0: aperture size 4096 MB is not right, using
> settings from NB
> agpgart-amd64 0000:04:00.0: AGP aperture is 256M @ 0xa0000000

Jouni also opened this bug report with complete dmesg logs:
https://bugzilla.kernel.org/show_bug.cgi?id=72201

This is a regression that appeared in v3.14-rc1, when we merged
e501b3d87f00.  The relevant part of that change is this:

    --- a/drivers/char/agp/amd64-agp.c
    +++ b/drivers/char/agp/amd64-agp.c
    @@ -295,9 +294,7 @@ static int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp, u16 cap)

    -       pci_read_config_dword(agp, 0x10, &aper_low);
    -       pci_read_config_dword(agp, 0x14, &aper_hi);
    -       aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
    +       aper = pci_bus_address(agp, AGP_APERTURE_BAR);

Here's what I think is happening: Previously, we read the GART
aperture base directly from the BAR.  After e501b3d87f00, we use
pci_bus_address() to convert the aperture *resource* (which the PCI
core has previously read from the BAR and converted to a CPU address)
back into a bus address.

Normally both ways would give the same result, but here we had this:

    Node 0: aperture @ a0000000 size 256 MB
    pci 0000:00:04.0: reg 0x10: [mem 0xa0000000-0xafffffff pref]
    pci 0000:00:04.0: address space collision: [mem 0xa0000000-0xafffffff pref] conflicts with GART [mem 0xa0000000-0xafffffff]

The "Node 0" line is where we inserted the "GART [mem 0xa0000000-
0xafffffff]" resource in gart_iommu_hole_init().  Then we enumerated
the northbridge, which had a BAR containing 0xa0000000.  When we tried
to claim that BAR, it conflicted with the "GART" resource, and we set
r->start = 0 (in pcibios_allocate_dev_resources()).  So when we
finally got to fix_northbridge(), the aperture resource was set to
zero, not 0xa0000000.

Note that we complained about the collision even before e501b3d87f00.
The only difference is that we used to re-read the BAR, where we still
got 0xa0000000 even though the PCI core thought the resource was
invalid and had set it to zero.

I think we should stop inserting the GART resource directly in
iomem_resource in gart_iommu_hole_init().  That should avoid the
collision and leave the BAR resource valid, which means
pci_bus_address() should work.

Jouni, could you try the patch below?

Bjorn



Revert "[PATCH] Insert GART region into resource map"

From: Bjorn Helgaas <bhelgaas@google.com>

This reverts commit 56dd669a138c, which makes the GART visible in
/proc/iomem.

The GART addresses are bus addresses, not CPU addresses, and therefore
should not be inserted in iomem_resource.

On many machines, the GART region is addressable by the CPU as well as by
an AGP master, but CPU addressability is not required by the spec.  On some
of these machines, the GART is mapped by a PCI BAR, and in that case, the
PCI core automatically inserts it into iomem_resource, just as it does for
all BARs.

Inserting it here means we'll have a conflict if the PCI core later tries
to claim the GART region.

Conflicts:
	arch/x86_64/kernel/aperture.c

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
 
