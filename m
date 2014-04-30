Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbaD3Tmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:42:35 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61167 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955AbaD3Tmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:42:32 -0400
Subject: [PATCH] DMA-API: Clarify physical/bus address distinction
To: Randy Dunlap <rdunlap@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-doc@vger.kernel.org
Date: Wed, 30 Apr 2014 13:42:29 -0600
Message-ID: <20140430194229.8155.98965.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA-API documentation sometimes refers to "physical addresses" when it
really means "bus addresses."  Historically these were often the same, but
they may be different if the bridge leading to the bus performs address
transaction.  Update the documentation to use "bus address" when
appropriate.

Also, consistently capitalize "DMA" and reword a few sections to improve
clarity.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/DMA-API-HOWTO.txt |   26 ++++------
 Documentation/DMA-API.txt       |  103 +++++++++++++++++++--------------------
 Documentation/DMA-ISA-LPC.txt   |    4 +-
 3 files changed, 64 insertions(+), 69 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 5e983031cc11..fe1f710c3882 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -9,16 +9,14 @@ This is a guide to device driver writers on how to use the DMA API
 with example pseudo-code.  For a concise description of the API, see
 DMA-API.txt.
 
-Most of the 64bit platforms have special hardware that translates bus
+Most 64bit platforms have special IOMMU hardware that translates bus
 addresses (DMA addresses) into physical addresses.  This is similar to
 how page tables and/or a TLB translates virtual addresses to physical
 addresses on a CPU.  This is needed so that e.g. PCI devices can
 access with a Single Address Cycle (32bit DMA address) any page in the
 64bit physical address space.  Previously in Linux those 64bit
 platforms had to set artificial limits on the maximum RAM size in the
-system, so that the virt_to_bus() static scheme works (the DMA address
-translation tables were simply filled on bootup to map each bus
-address to the physical page __pa(bus_to_virt())).
+system so devices could address all physical memory.
 
 So that Linux can use the dynamic DMA mapping, it needs some help from the
 drivers, namely it has to take into account that DMA addresses should be
@@ -30,7 +28,7 @@ hardware exists.
 
 Note that the DMA API works with any bus independent of the underlying
 microprocessor architecture. You should use the DMA API rather than
-the bus specific DMA API (e.g. pci_dma_*).
+the bus-specific DMA API (e.g. pci_dma_*).
 
 First of all, you should make sure
 
@@ -347,7 +345,7 @@ dma_alloc_coherent returns two values: the virtual address which you
 can use to access it from the CPU and dma_handle which you pass to the
 card.
 
-The cpu return address and the DMA bus master address are both
+The CPU virtual address and the DMA bus address are both
 guaranteed to be aligned to the smallest PAGE_SIZE order which
 is greater than or equal to the requested size.  This invariant
 exists (for example) to guarantee that if you allocate a chunk
@@ -383,7 +381,7 @@ pass 0 for alloc; passing 4096 says memory allocated from this pool
 must not cross 4KByte boundaries (but at that time it may be better to
 go for dma_alloc_coherent directly instead).
 
-Allocate memory from a dma pool like this:
+Allocate memory from a DMA pool like this:
 
 	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
 
@@ -489,14 +487,14 @@ and to unmap it:
 	dma_unmap_single(dev, dma_handle, size, direction);
 
 You should call dma_mapping_error() as dma_map_single() could fail and return
-error. Not all dma implementations support dma_mapping_error() interface.
+error. Not all DMA implementations support the dma_mapping_error() interface.
 However, it is a good practice to call dma_mapping_error() interface, which
 will invoke the generic mapping error check interface. Doing so will ensure
-that the mapping code will work correctly on all dma implementations without
+that the mapping code will work correctly on all DMA implementations without
 any dependency on the specifics of the underlying implementation. Using the
 returned address without checking for errors could result in failures ranging
 from panics to silent data corruption. A couple of examples of incorrect ways
-to check for errors that make assumptions about the underlying dma
+to check for errors that make assumptions about the underlying DMA
 implementation are as follows and these are applicable to dma_map_page() as
 well.
 
@@ -589,14 +587,12 @@ PLEASE NOTE:  The 'nents' argument to the dma_unmap_sg call must be
               dma_map_sg call.
 
 Every dma_map_{single,sg} call should have its dma_unmap_{single,sg}
-counterpart, because the bus address space is a shared resource (although
-in some ports the mapping is per each BUS so less devices contend for the
-same bus address space) and you could render the machine unusable by eating
-all bus addresses.
+counterpart, because the bus address space is a shared resource and
+you could render the machine unusable by consuming all bus addresses.
 
 If you need to use the same streaming DMA region multiple times and touch
 the data in between the DMA transfers, the buffer needs to be synced
-properly in order for the cpu and device to see the most uptodate and
+properly in order for the cpu and device to see the most up-to-date and
 correct copy of the DMA buffer.
 
 So, firstly, just map it with dma_map_{single,sg}, and after each DMA
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index e865279cec58..0371ad0f37e7 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -4,14 +4,13 @@
         James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
 
 This document describes the DMA API.  For a more gentle introduction
-of the API (and actual examples) see
-Documentation/DMA-API-HOWTO.txt.
+of the API (and actual examples), see Documentation/DMA-API-HOWTO.txt.
 
-This API is split into two pieces.  Part I describes the API.  Part II
-describes the extensions to the API for supporting non-consistent
-memory machines.  Unless you know that your driver absolutely has to
-support non-consistent platforms (this is usually only legacy
-platforms) you should only use the API described in part I.
+This API is split into two pieces.  Part I describes the basic API.
+Part II describes extensions for supporting non-consistent memory
+machines.  Unless you know that your driver absolutely has to support
+non-consistent platforms (this is usually only legacy platforms) you
+should only use the API described in part I.
 
 Part I - dma_ API
 -------------------------------------
@@ -19,7 +18,7 @@ Part I - dma_ API
 To get the dma_ API, you must #include <linux/dma-mapping.h>
 
 
-Part Ia - Using large dma-coherent buffers
+Part Ia - Using large DMA-coherent buffers
 ------------------------------------------
 
 void *
@@ -34,8 +33,8 @@ devices to read that memory.)
 
 This routine allocates a region of <size> bytes of consistent memory.
 It also returns a <dma_handle> which may be cast to an unsigned
-integer the same width as the bus and used as the physical address
-base of the region.
+integer the same width as the bus and used as the bus address base
+of the region.
 
 Returns: a pointer to the allocated region (in the processor's virtual
 address space) or NULL if the allocation failed.
@@ -70,15 +69,15 @@ Note that unlike their sibling allocation calls, these routines
 may only be called with IRQs enabled.
 
 
-Part Ib - Using small dma-coherent buffers
+Part Ib - Using small DMA-coherent buffers
 ------------------------------------------
 
 To get this part of the dma_ API, you must #include <linux/dmapool.h>
 
-Many drivers need lots of small dma-coherent memory regions for DMA
+Many drivers need lots of small DMA-coherent memory regions for DMA
 descriptors or I/O buffers.  Rather than allocating in units of a page
 or more using dma_alloc_coherent(), you can use DMA pools.  These work
-much like a struct kmem_cache, except that they use the dma-coherent allocator,
+much like a struct kmem_cache, except that they use the DMA-coherent allocator,
 not __get_free_pages().  Also, they understand common hardware constraints
 for alignment, like queue heads needing to be aligned on N-byte boundaries.
 
@@ -87,7 +86,7 @@ for alignment, like queue heads needing to be aligned on N-byte boundaries.
 	dma_pool_create(const char *name, struct device *dev,
 			size_t size, size_t align, size_t alloc);
 
-The pool create() routines initialize a pool of dma-coherent buffers
+The pool create() routines initialize a pool of DMA-coherent buffers
 for use with a given device.  It must be called in a context which
 can sleep.
 
@@ -102,19 +101,20 @@ from this pool must not cross 4KByte boundaries.
 	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
 			dma_addr_t *dma_handle);
 
-This allocates memory from the pool; the returned memory will meet the size
-and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
-prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
-pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
-two values:  an address usable by the cpu, and the dma address usable by the
-pool's device.
+This allocates memory from the pool; the returned memory will meet the
+size and alignment requirements specified at creation time.  Pass
+GFP_ATOMIC to prevent blocking, or if it's permitted (not
+in_interrupt, not holding SMP locks), pass GFP_KERNEL to allow
+blocking.  Like dma_alloc_coherent(), this returns two values:  an
+address usable by the cpu, and the DMA address usable by the pool's
+device.
 
 
 	void dma_pool_free(struct dma_pool *pool, void *vaddr,
 			dma_addr_t addr);
 
 This puts memory back into the pool.  The pool is what was passed to
-the pool allocation routine; the cpu (vaddr) and dma addresses are what
+the pool allocation routine; the cpu (vaddr) and DMA addresses are what
 were returned when that routine allocated the memory being freed.
 
 
@@ -187,9 +187,9 @@ dma_map_single(struct device *dev, void *cpu_addr, size_t size,
 		      enum dma_data_direction direction)
 
 Maps a piece of processor virtual memory so it can be accessed by the
-device and returns the physical handle of the memory.
+device and returns the bus address of the memory.
 
-The direction for both api's may be converted freely by casting.
+The direction for both APIs may be converted freely by casting.
 However the dma_ API uses a strongly typed enumerator for its
 direction:
 
@@ -198,31 +198,30 @@ DMA_TO_DEVICE		data is going from the memory to the device
 DMA_FROM_DEVICE		data is coming from the device to the memory
 DMA_BIDIRECTIONAL	direction isn't known
 
-Notes:  Not all memory regions in a machine can be mapped by this
-API.  Further, regions that appear to be physically contiguous in
-kernel virtual space may not be contiguous as physical memory.  Since
-this API does not provide any scatter/gather capability, it will fail
-if the user tries to map a non-physically contiguous piece of memory.
-For this reason, it is recommended that memory mapped by this API be
-obtained only from sources which guarantee it to be physically contiguous
-(like kmalloc).
-
-Further, the physical address of the memory must be within the
-dma_mask of the device (the dma_mask represents a bit mask of the
-addressable region for the device.  I.e., if the physical address of
-the memory anded with the dma_mask is still equal to the physical
-address, then the device can perform DMA to the memory).  In order to
+Notes:  Not all memory regions in a machine can be mapped by this API.
+Further, contiguous kernel virtual space may not be contiguous as
+physical memory.  Since this API does not provide any scatter/gather
+capability, it will fail if the user tries to map a non-physically
+contiguous piece of memory.  For this reason, memory to be mapped by
+this API should be obtained from sources which guarantee it to be
+physically contiguous (like kmalloc).
+
+Further, the bus address of the memory must be within the
+dma_mask of the device (the dma_mask is a bit mask of the
+addressable region for the device, i.e., if the bus address of
+the memory ANDed with the dma_mask is still equal to the bus
+address, then the device can perform DMA to the memory).  To
 ensure that the memory allocated by kmalloc is within the dma_mask,
 the driver may specify various platform-dependent flags to restrict
-the physical memory range of the allocation (e.g. on x86, GFP_DMA
-guarantees to be within the first 16Mb of available physical memory,
+the bus address range of the allocation (e.g., on x86, GFP_DMA
+guarantees to be within the first 16MB of available bus addresses,
 as required by ISA devices).
 
 Note also that the above constraints on physical contiguity and
 dma_mask may not apply if the platform has an IOMMU (a device which
-supplies a physical to virtual mapping between the I/O memory bus and
-the device).  However, to be portable, device driver writers may *not*
-assume that such an IOMMU exists.
+maps an I/O bus address to a physical memory address).  However, to be
+portable, device driver writers may *not* assume that such an IOMMU
+exists.
 
 Warnings:  Memory coherency operates at a granularity called the cache
 line width.  In order for memory mapped by this API to operate
@@ -283,7 +282,7 @@ dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 In some circumstances dma_map_single and dma_map_page will fail to create
 a mapping. A driver can check for these errors by testing the returned
-dma address with dma_mapping_error(). A non-zero return value means the mapping
+DMA address with dma_mapping_error(). A non-zero return value means the mapping
 could not be created and the driver should take appropriate action (e.g.
 reduce current DMA mapping usage or delay and try again later).
 
@@ -291,7 +290,7 @@ reduce current DMA mapping usage or delay and try again later).
 	dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction direction)
 
-Returns: the number of physical segments mapped (this may be shorter
+Returns: the number of bus address segments mapped (this may be shorter
 than <nents> passed in if some elements of the scatter/gather list are
 physically or virtually adjacent and an IOMMU maps them with a single
 entry).
@@ -335,7 +334,7 @@ must be the same as those and passed in to the scatter/gather mapping
 API.
 
 Note: <nents> must be the number you passed in, *not* the number of
-physical entries returned.
+bus address entries returned.
 
 void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
@@ -391,10 +390,10 @@ The four functions above are just like the counterpart functions
 without the _attrs suffixes, except that they pass an optional
 struct dma_attrs*.
 
-struct dma_attrs encapsulates a set of "dma attributes". For the
+struct dma_attrs encapsulates a set of "DMA attributes". For the
 definition of struct dma_attrs see linux/dma-attrs.h.
 
-The interpretation of dma attributes is architecture-specific, and
+The interpretation of DMA attributes is architecture-specific, and
 each attribute should be documented in Documentation/DMA-attributes.txt.
 
 If struct dma_attrs* is NULL, the semantics of each of these
@@ -458,7 +457,7 @@ Note: where the platform can return consistent memory, it will
 guarantee that the sync points become nops.
 
 Warning:  Handling non-consistent memory is a real pain.  You should
-only ever use this API if you positively know your driver will be
+only use this API if you positively know your driver will be
 required to work on one of the rare (usually non-PCI) architectures
 that simply cannot make consistent memory.
 
@@ -503,13 +502,13 @@ bus_addr is the physical address to which the memory is currently
 assigned in the bus responding region (this will be used by the
 platform to perform the mapping).
 
-device_addr is the physical address the device needs to be programmed
+device_addr is the bus address the device needs to be programmed
 with actually to address this memory (this will be handed out as the
 dma_addr_t in dma_alloc_coherent()).
 
 size is the size of the area (must be multiples of PAGE_SIZE).
 
-flags can be or'd together and are:
+flags can be ORed together and are:
 
 DMA_MEMORY_MAP - request that the memory returned from
 dma_alloc_coherent() be directly writable.
@@ -690,11 +689,11 @@ architectural default.
 void debug_dmap_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
 dma-debug interface debug_dma_mapping_error() to debug drivers that fail
-to check dma mapping errors on addresses returned by dma_map_single() and
+to check DMA mapping errors on addresses returned by dma_map_single() and
 dma_map_page() interfaces. This interface clears a flag set by
 debug_dma_map_page() to indicate that dma_mapping_error() has been called by
 the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
 this flag is still set, prints warning message that includes call trace that
 leads up to the unmap. This interface can be called from dma_mapping_error()
-routines to enable dma mapping error check debugging.
+routines to enable DMA mapping error check debugging.
 
diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/DMA-ISA-LPC.txt
index e767805b4182..b1a19835e907 100644
--- a/Documentation/DMA-ISA-LPC.txt
+++ b/Documentation/DMA-ISA-LPC.txt
@@ -16,7 +16,7 @@ To do ISA style DMA you need to include two headers:
 #include <asm/dma.h>
 
 The first is the generic DMA API used to convert virtual addresses to
-physical addresses (see Documentation/DMA-API.txt for details).
+bus addresses (see Documentation/DMA-API.txt for details).
 
 The second contains the routines specific to ISA DMA transfers. Since
 this is not present on all platforms make sure you construct your
@@ -50,7 +50,7 @@ early as possible and not release it until the driver is unloaded.)
 Part III - Address translation
 ------------------------------
 
-To translate the virtual address to a physical use the normal DMA
+To translate the virtual address to a bus address, use the normal DMA
 API. Do _not_ use isa_virt_to_phys() even though it does the same
 thing. The reason for this is that the function isa_virt_to_phys()
 will require a Kconfig dependency to ISA, not just ISA_DMA_API which

