Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3LJQFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:05:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50551 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LJQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:05:47 -0500
X-IronPort-AV: E=Sophos;i="4.93,865,1378857600"; 
   d="scan'208";a="80504502"
From: Stefano Panella <stefano.panella@citrix.com>
To: <gregkh@linuxfoundation.org>, <maarten.lankhorst@canonical.com>,
        <mingo@kernel.org>, <stefano.stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <zoltan.kiss@citrix.com>, <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        Stefano Panella <stefano.panella@citrix.com>
Subject: [RFC] dma-mapping: dma_alloc_coherent_mask return dma_addr_t
Date: Tue, 10 Dec 2013 16:05:37 +0000
Message-ID: <1386691537-10319-1-git-send-email-stefano.panella@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a 32bit kernel there are still some pci devices
capable of 64bit addressing (eg. sound/pci/hda/hda_intel.c)

If these drivers are setting:

dev->coherent_dma_mask = 0xFFFFFFFFFFFFFFFF

why dma_alloc_coherent_mask is returning unsigned long instead
of dma_addr_t resulting in truncation of the dma_mask to 32bit
if running a 32bit kernel?

There are some examples where the dma_alloc_coherent running
32bit kernel can return a machine address bigger than 32bit.

This can be true in particular if running  the 32bit kernel as a
pv dom0 under the Xen Hypervisor or PAE on bare metal.

In both cases it would be good if dma_alloc_coherent could return
a machine address bigger than 32bit so more constrained 32bit address
space could be used by devices not 64bit capable.

I am proposing this patch to eliminate this limitation but I agree
that there might be some more reasons to do it in the current way of
which I am not awere.

This is why I am just asking for a RFC.

The current patch apply to v3.13-rc3-74-g6c843f5

Signed-off-by: Stefano Panella <stefano.panella@citrix.com>
---
 Documentation/DMA-API.txt          |    5 ++---
 arch/x86/include/asm/dma-mapping.h |    8 ++++----
 arch/x86/kernel/pci-dma.c          |    2 +-
 drivers/xen/swiotlb-xen.c          |    6 +++---
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index e865279..483458b 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -33,9 +33,8 @@ to make sure to flush the processor's write buffers before telling
 devices to read that memory.)
 
 This routine allocates a region of <size> bytes of consistent memory.
-It also returns a <dma_handle> which may be cast to an unsigned
-integer the same width as the bus and used as the physical address
-base of the region.
+It also returns a <dma_handle> which should be used as the physical 
+address base of the region.
 
 Returns: a pointer to the allocated region (in the processor's virtual
 address space) or NULL if the allocation failed.
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 808dae6..6357810 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -100,10 +100,10 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	flush_write_buffers();
 }
 
-static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
-						    gfp_t gfp)
+static inline dma_addr_t dma_alloc_coherent_mask(struct device *dev,
+						 gfp_t gfp)
 {
-	unsigned long dma_mask = 0;
+	dma_addr_t dma_mask = 0;
 
 	dma_mask = dev->coherent_dma_mask;
 	if (!dma_mask)
@@ -114,7 +114,7 @@ static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 
 static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 {
-	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
+	dma_addr_t dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
 	if (dma_mask <= DMA_BIT_MASK(24))
 		gfp |= GFP_DMA;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..a061f7b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -90,7 +90,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag,
 				 struct dma_attrs *attrs)
 {
-	unsigned long dma_mask;
+	dma_addr_t dma_mask;
 	struct page *page;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	dma_addr_t addr;
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1eac073..6f75599 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -54,10 +54,10 @@
  */
 
 #ifndef CONFIG_X86
-static unsigned long dma_alloc_coherent_mask(struct device *dev,
-					    gfp_t gfp)
+static dma_addr_t dma_alloc_coherent_mask(struct device *dev,
+					  gfp_t gfp)
 {
-	unsigned long dma_mask = 0;
+	dma_addr_t dma_mask = 0;
 
 	dma_mask = dev->coherent_dma_mask;
 	if (!dma_mask)
-- 
1.7.9.5

