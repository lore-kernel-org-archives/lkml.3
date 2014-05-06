Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaEFWsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:48:18 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46264 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaEFWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:48:11 -0400
Subject: [PATCH v2 1/5] DMA-API: Clarify physical/bus address distinction
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 May 2014 16:48:19 -0600
Message-ID: <20140506224819.17968.2922.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA-API documentation sometimes refers to "physical addresses" when it
really means "bus addresses."  Sometimes these are identical, but they may
be different if the bridge leading to the bus performs address translation.
Update the documentation to use "bus address" when appropriate.

Also, consistently capitalize "DMA", use parens with function names, use
dev_printk() in examples, and reword a few sections for clarity.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/DMA-API-HOWTO.txt |  122 ++++++++++++++++------------------
 Documentation/DMA-API.txt       |  140 ++++++++++++++++++++-------------------
 Documentation/DMA-ISA-LPC.txt   |    4 +
 include/linux/dma-mapping.h     |    7 ++
 include/linux/types.h           |    1 
 5 files changed, 140 insertions(+), 134 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 5e983031cc11..ad07f89974f9 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -9,16 +9,14 @@ This is a guide to device driver writers on how to use the DMA API
 with example pseudo-code.  For a concise description of the API, see
 DMA-API.txt.
 
-Most of the 64bit platforms have special hardware that translates bus
+Most 64-bit platforms have special IOMMU hardware that translates bus
 addresses (DMA addresses) into physical addresses.  This is similar to
 how page tables and/or a TLB translates virtual addresses to physical
-addresses on a CPU.  This is needed so that e.g. PCI devices can
-access with a Single Address Cycle (32bit DMA address) any page in the
-64bit physical address space.  Previously in Linux those 64bit
+addresses on a CPU.  This is needed so that, e.g., PCI devices can
+access with a Single Address Cycle (32-bit DMA address) any page in the
+64-bit physical address space.  Previously in Linux those 64-bit
 platforms had to set artificial limits on the maximum RAM size in the
-system, so that the virt_to_bus() static scheme works (the DMA address
-translation tables were simply filled on bootup to map each bus
-address to the physical page __pa(bus_to_virt())).
+system so devices could address all physical memory.
 
 So that Linux can use the dynamic DMA mapping, it needs some help from the
 drivers, namely it has to take into account that DMA addresses should be
@@ -30,16 +28,16 @@ hardware exists.
 
 Note that the DMA API works with any bus independent of the underlying
 microprocessor architecture. You should use the DMA API rather than
-the bus specific DMA API (e.g. pci_dma_*).
+the bus-specific DMA API (e.g. pci_dma_*).
 
 First of all, you should make sure
 
 #include <linux/dma-mapping.h>
 
-is in your driver. This file will obtain for you the definition of the
-dma_addr_t (which can hold any valid DMA address for the platform)
-type which should be used everywhere you hold a DMA (bus) address
-returned from the DMA mapping functions.
+is in your driver, which provides the definition of dma_addr_t.  This type
+can hold any valid DMA or bus address for the platform and should be used
+everywhere you hold a DMA address returned from the DMA mapping functions
+or a bus address read from a device register such as a PCI BAR.
 
 			 What memory is DMA'able?
 
@@ -123,9 +121,9 @@ Here, dev is a pointer to the device struct of your device, and mask
 is a bit mask describing which bits of an address your device
 supports.  It returns zero if your card can perform DMA properly on
 the machine given the address mask you provided.  In general, the
-device struct of your device is embedded in the bus specific device
-struct of your device.  For example, a pointer to the device struct of
-your PCI device is pdev->dev (pdev is a pointer to the PCI device
+device struct of your device is embedded in the bus-specific device
+struct of your device.  For example, &pdev->dev is a pointer to the
+device struct of a PCI device (pdev is a pointer to the PCI device
 struct of your device).
 
 If it returns non-zero, your device cannot perform DMA properly on
@@ -147,8 +145,7 @@ exactly why.
 The standard 32-bit addressing device would do something like this:
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
+		dev_warn(dev, "mydev: No suitable DMA available\n");
 		goto ignore_this_device;
 	}
 
@@ -170,8 +167,7 @@ all 64-bits when accessing streaming DMA:
 	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
+		dev_warn(dev, "mydev: No suitable DMA available\n");
 		goto ignore_this_device;
 	}
 
@@ -187,8 +183,7 @@ the case would look like this:
 		using_dac = 0;
 		consistent_using_dac = 0;
 	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
+		dev_warn(dev, "mydev: No suitable DMA available\n");
 		goto ignore_this_device;
 	}
 
@@ -201,8 +196,7 @@ Finally, if your device can only drive the low 24-bits of
 address you might do something like:
 
 	if (dma_set_mask(dev, DMA_BIT_MASK(24))) {
-		printk(KERN_WARNING
-		       "mydev: 24-bit DMA addressing not available.\n");
+		dev_warn(dev, "mydev: 24-bit DMA addressing not available\n");
 		goto ignore_this_device;
 	}
 
@@ -232,14 +226,14 @@ Here is pseudo-code showing how this might be done:
 		card->playback_enabled = 1;
 	} else {
 		card->playback_enabled = 0;
-		printk(KERN_WARNING "%s: Playback disabled due to DMA limitations.\n",
+		dev_warn(dev, "%s: Playback disabled due to DMA limitations\n",
 		       card->name);
 	}
 	if (!dma_set_mask(dev, RECORD_ADDRESS_BITS)) {
 		card->record_enabled = 1;
 	} else {
 		card->record_enabled = 0;
-		printk(KERN_WARNING "%s: Record disabled due to DMA limitations.\n",
+		dev_warn(dev, "%s: Record disabled due to DMA limitations\n",
 		       card->name);
 	}
 
@@ -331,7 +325,7 @@ context with the GFP_ATOMIC flag.
 Size is the length of the region you want to allocate, in bytes.
 
 This routine will allocate RAM for that region, so it acts similarly to
-__get_free_pages (but takes size instead of a page order).  If your
+__get_free_pages() (but takes size instead of a page order).  If your
 driver needs regions sized smaller than a page, you may prefer using
 the dma_pool interface, described below.
 
@@ -343,11 +337,11 @@ the consistent DMA mask has been explicitly changed via
 dma_set_coherent_mask().  This is true of the dma_pool interface as
 well.
 
-dma_alloc_coherent returns two values: the virtual address which you
+dma_alloc_coherent() returns two values: the virtual address which you
 can use to access it from the CPU and dma_handle which you pass to the
 card.
 
-The cpu return address and the DMA bus master address are both
+The CPU virtual address and the DMA bus address are both
 guaranteed to be aligned to the smallest PAGE_SIZE order which
 is greater than or equal to the requested size.  This invariant
 exists (for example) to guarantee that if you allocate a chunk
@@ -359,13 +353,13 @@ To unmap and free such a DMA region, you call:
 	dma_free_coherent(dev, size, cpu_addr, dma_handle);
 
 where dev, size are the same as in the above call and cpu_addr and
-dma_handle are the values dma_alloc_coherent returned to you.
+dma_handle are the values dma_alloc_coherent() returned to you.
 This function may not be called in interrupt context.
 
 If your driver needs lots of smaller memory regions, you can write
-custom code to subdivide pages returned by dma_alloc_coherent,
+custom code to subdivide pages returned by dma_alloc_coherent(),
 or you can use the dma_pool API to do that.  A dma_pool is like
-a kmem_cache, but it uses dma_alloc_coherent not __get_free_pages.
+a kmem_cache, but it uses dma_alloc_coherent(), not __get_free_pages().
 Also, it understands common hardware constraints for alignment,
 like queue heads needing to be aligned on N byte boundaries.
 
@@ -381,29 +375,29 @@ type of data is "align" (which is expressed in bytes, and must be a
 power of two).  If your device has no boundary crossing restrictions,
 pass 0 for alloc; passing 4096 says memory allocated from this pool
 must not cross 4KByte boundaries (but at that time it may be better to
-go for dma_alloc_coherent directly instead).
+use dma_alloc_coherent() directly instead).
 
-Allocate memory from a dma pool like this:
+Allocate memory from a DMA pool like this:
 
 	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
 
 flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
-holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
+holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent(),
 this returns two values, cpu_addr and dma_handle.
 
 Free memory that was allocated from a dma_pool like this:
 
 	dma_pool_free(pool, cpu_addr, dma_handle);
 
-where pool is what you passed to dma_pool_alloc, and cpu_addr and
-dma_handle are the values dma_pool_alloc returned. This function
+where pool is what you passed to dma_pool_alloc(), and cpu_addr and
+dma_handle are the values dma_pool_alloc() returned. This function
 may be called in interrupt context.
 
 Destroy a dma_pool by calling:
 
 	dma_pool_destroy(pool);
 
-Make sure you've called dma_pool_free for all memory allocated
+Make sure you've called dma_pool_free() for all memory allocated
 from a pool before you destroy the pool. This function may not
 be called in interrupt context.
 
@@ -418,7 +412,7 @@ one of the following values:
  DMA_FROM_DEVICE
  DMA_NONE
 
-One should provide the exact DMA direction if you know it.
+You should provide the exact DMA direction if you know it.
 
 DMA_TO_DEVICE means "from main memory to the device"
 DMA_FROM_DEVICE means "from the device to main memory"
@@ -489,14 +483,14 @@ and to unmap it:
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
 
@@ -516,12 +510,12 @@ Incorrect example 2:
 		goto map_error;
 	}
 
-You should call dma_unmap_single when the DMA activity is finished, e.g.
+You should call dma_unmap_single() when the DMA activity is finished, e.g.,
 from the interrupt which told you that the DMA transfer is done.
 
-Using cpu pointers like this for single mappings has a disadvantage,
+Using cpu pointers like this for single mappings has a disadvantage:
 you cannot reference HIGHMEM memory in this way.  Thus, there is a
-map/unmap interface pair akin to dma_{map,unmap}_single.  These
+map/unmap interface pair akin to dma_{map,unmap}_single().  These
 interfaces deal with page/offset pairs instead of cpu pointers.
 Specifically:
 
@@ -550,7 +544,7 @@ Here, "offset" means byte offset within the given page.
 You should call dma_mapping_error() as dma_map_page() could fail and return
 error as outlined under the dma_map_single() discussion.
 
-You should call dma_unmap_page when the DMA activity is finished, e.g.
+You should call dma_unmap_page() when the DMA activity is finished, e.g.,
 from the interrupt which told you that the DMA transfer is done.
 
 With scatterlists, you map a region gathered from several regions by:
@@ -588,18 +582,16 @@ PLEASE NOTE:  The 'nents' argument to the dma_unmap_sg call must be
 	      it should _NOT_ be the 'count' value _returned_ from the
               dma_map_sg call.
 
-Every dma_map_{single,sg} call should have its dma_unmap_{single,sg}
-counterpart, because the bus address space is a shared resource (although
-in some ports the mapping is per each BUS so less devices contend for the
-same bus address space) and you could render the machine unusable by eating
-all bus addresses.
+Every dma_map_{single,sg}() call should have its dma_unmap_{single,sg}()
+counterpart, because the bus address space is a shared resource and
+you could render the machine unusable by consuming all bus addresses.
 
 If you need to use the same streaming DMA region multiple times and touch
 the data in between the DMA transfers, the buffer needs to be synced
-properly in order for the cpu and device to see the most uptodate and
+properly in order for the cpu and device to see the most up-to-date and
 correct copy of the DMA buffer.
 
-So, firstly, just map it with dma_map_{single,sg}, and after each DMA
+So, firstly, just map it with dma_map_{single,sg}(), and after each DMA
 transfer call either:
 
 	dma_sync_single_for_cpu(dev, dma_handle, size, direction);
@@ -623,9 +615,9 @@ or:
 as appropriate.
 
 After the last DMA transfer call one of the DMA unmap routines
-dma_unmap_{single,sg}. If you don't touch the data from the first dma_map_*
-call till dma_unmap_*, then you don't have to call the dma_sync_*
-routines at all.
+dma_unmap_{single,sg}(). If you don't touch the data from the first
+dma_map_*() call till dma_unmap_*(), then you don't have to call the
+dma_sync_*() routines at all.
 
 Here is pseudo code which shows a situation in which you would need
 to use the dma_sync_*() interfaces.
@@ -690,12 +682,12 @@ to use the dma_sync_*() interfaces.
 		}
 	}
 
-Drivers converted fully to this interface should not use virt_to_bus any
-longer, nor should they use bus_to_virt. Some drivers have to be changed a
-little bit, because there is no longer an equivalent to bus_to_virt in the
+Drivers converted fully to this interface should not use virt_to_bus() any
+longer, nor should they use bus_to_virt(). Some drivers have to be changed a
+little bit, because there is no longer an equivalent to bus_to_virt() in the
 dynamic DMA mapping scheme - you have to always store the DMA addresses
-returned by the dma_alloc_coherent, dma_pool_alloc, and dma_map_single
-calls (dma_map_sg stores them in the scatterlist itself if the platform
+returned by the dma_alloc_coherent(), dma_pool_alloc(), and dma_map_single()
+calls (dma_map_sg() stores them in the scatterlist itself if the platform
 supports dynamic DMA mapping in hardware) in your driver structures and/or
 in the card registers.
 
@@ -709,9 +701,9 @@ as it is impossible to correctly support them.
 DMA address space is limited on some architectures and an allocation
 failure can be determined by:
 
-- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
+- checking if dma_alloc_coherent() returns NULL or dma_map_sg returns 0
 
-- checking the returned dma_addr_t of dma_map_single and dma_map_page
+- checking the dma_addr_t returned from dma_map_single() and dma_map_page()
   by using dma_mapping_error():
 
 	dma_addr_t dma_handle;
@@ -794,7 +786,7 @@ Example 2: (if buffers are allocated in a loop, unmap all mapped buffers when
 		dma_unmap_single(array[i].dma_addr);
 	}
 
-Networking drivers must call dev_kfree_skb to free the socket buffer
+Networking drivers must call dev_kfree_skb() to free the socket buffer
 and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
 (ndo_start_xmit). This means that the socket buffer is just dropped in
 the failure case.
@@ -831,7 +823,7 @@ transform some example code.
 		DEFINE_DMA_UNMAP_LEN(len);
 	};
 
-2) Use dma_unmap_{addr,len}_set to set these values.
+2) Use dma_unmap_{addr,len}_set() to set these values.
    Example, before:
 
 	ringp->mapping = FOO;
@@ -842,7 +834,7 @@ transform some example code.
 	dma_unmap_addr_set(ringp, mapping, FOO);
 	dma_unmap_len_set(ringp, len, BAR);
 
-3) Use dma_unmap_{addr,len} to access these values.
+3) Use dma_unmap_{addr,len}() to access these values.
    Example, before:
 
 	dma_unmap_single(dev, ringp->mapping, ringp->len,
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index e865279cec58..1699e26c6284 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -4,22 +4,27 @@
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
 
-To get the dma_ API, you must #include <linux/dma-mapping.h>
+To get the dma_ API, you must #include <linux/dma-mapping.h>.  This
+provides dma_addr_t and the interfaces described below.
 
+A dma_addr_t can hold any valid DMA or bus address for the platform.  It
+can be given to a device to use as a DMA source or target, or it may appear
+on the bus when a cpu performs programmed I/O.  A cpu cannot reference a
+dma_addr_t directly because there may be translation between its physical
+address space and the bus address space.
 
-Part Ia - Using large dma-coherent buffers
+Part Ia - Using large DMA-coherent buffers
 ------------------------------------------
 
 void *
@@ -33,20 +38,21 @@ to make sure to flush the processor's write buffers before telling
 devices to read that memory.)
 
 This routine allocates a region of <size> bytes of consistent memory.
-It also returns a <dma_handle> which may be cast to an unsigned
-integer the same width as the bus and used as the physical address
-base of the region.
 
-Returns: a pointer to the allocated region (in the processor's virtual
+It returns a pointer to the allocated region (in the processor's virtual
 address space) or NULL if the allocation failed.
 
+It also returns a <dma_handle> which may be cast to an unsigned integer the
+same width as the bus and given to the device as the bus address base of
+the region.
+
 Note: consistent memory can be expensive on some platforms, and the
 minimum allocation length may be as big as a page, so you should
 consolidate your requests for consistent memory as much as possible.
 The simplest way to do that is to use the dma_pool calls (see below).
 
-The flag parameter (dma_alloc_coherent only) allows the caller to
-specify the GFP_ flags (see kmalloc) for the allocation (the
+The flag parameter (dma_alloc_coherent() only) allows the caller to
+specify the GFP_ flags (see kmalloc()) for the allocation (the
 implementation may choose to ignore flags that affect the location of
 the returned memory, like GFP_DMA).
 
@@ -61,24 +67,24 @@ void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
 
-Free the region of consistent memory you previously allocated.  dev,
-size and dma_handle must all be the same as those passed into the
-consistent allocate.  cpu_addr must be the virtual address returned by
-the consistent allocate.
+Free a region of consistent memory you previously allocated.  dev,
+size and dma_handle must all be the same as those passed into
+dma_alloc_coherent().  cpu_addr must be the virtual address returned by
+the dma_alloc_coherent().
 
 Note that unlike their sibling allocation calls, these routines
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
 
@@ -87,7 +93,7 @@ for alignment, like queue heads needing to be aligned on N-byte boundaries.
 	dma_pool_create(const char *name, struct device *dev,
 			size_t size, size_t align, size_t alloc);
 
-The pool create() routines initialize a pool of dma-coherent buffers
+dma_pool_create() initializes a pool of DMA-coherent buffers
 for use with a given device.  It must be called in a context which
 can sleep.
 
@@ -102,25 +108,26 @@ from this pool must not cross 4KByte boundaries.
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
+dma_pool_alloc(); the cpu (vaddr) and DMA addresses are what
 were returned when that routine allocated the memory being freed.
 
 
 	void dma_pool_destroy(struct dma_pool *pool);
 
-The pool destroy() routines free the resources of the pool.  They must be
+dma_pool_destroy() frees the resources of the pool.  It must be
 called in a context which can sleep.  Make sure you've freed all allocated
 memory back to the pool before you destroy it.
 
@@ -187,9 +194,9 @@ dma_map_single(struct device *dev, void *cpu_addr, size_t size,
 		      enum dma_data_direction direction)
 
 Maps a piece of processor virtual memory so it can be accessed by the
-device and returns the physical handle of the memory.
+device and returns the bus address of the memory.
 
-The direction for both api's may be converted freely by casting.
+The direction for both APIs may be converted freely by casting.
 However the dma_ API uses a strongly typed enumerator for its
 direction:
 
@@ -198,31 +205,30 @@ DMA_TO_DEVICE		data is going from the memory to the device
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
@@ -281,9 +287,9 @@ cache width is.
 int
 dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
-In some circumstances dma_map_single and dma_map_page will fail to create
+In some circumstances dma_map_single() and dma_map_page() will fail to create
 a mapping. A driver can check for these errors by testing the returned
-dma address with dma_mapping_error(). A non-zero return value means the mapping
+DMA address with dma_mapping_error(). A non-zero return value means the mapping
 could not be created and the driver should take appropriate action (e.g.
 reduce current DMA mapping usage or delay and try again later).
 
@@ -291,7 +297,7 @@ reduce current DMA mapping usage or delay and try again later).
 	dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction direction)
 
-Returns: the number of physical segments mapped (this may be shorter
+Returns: the number of bus address segments mapped (this may be shorter
 than <nents> passed in if some elements of the scatter/gather list are
 physically or virtually adjacent and an IOMMU maps them with a single
 entry).
@@ -299,7 +305,7 @@ entry).
 Please note that the sg cannot be mapped again if it has been mapped once.
 The mapping process is allowed to destroy information in the sg.
 
-As with the other mapping interfaces, dma_map_sg can fail. When it
+As with the other mapping interfaces, dma_map_sg() can fail. When it
 does, 0 is returned and a driver must take appropriate action. It is
 critical that the driver do something, in the case of a block driver
 aborting the request or even oopsing is better than doing nothing and
@@ -335,7 +341,7 @@ must be the same as those and passed in to the scatter/gather mapping
 API.
 
 Note: <nents> must be the number you passed in, *not* the number of
-physical entries returned.
+bus address entries returned.
 
 void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
@@ -391,10 +397,10 @@ The four functions above are just like the counterpart functions
 without the _attrs suffixes, except that they pass an optional
 struct dma_attrs*.
 
-struct dma_attrs encapsulates a set of "dma attributes". For the
+struct dma_attrs encapsulates a set of "DMA attributes". For the
 definition of struct dma_attrs see linux/dma-attrs.h.
 
-The interpretation of dma attributes is architecture-specific, and
+The interpretation of DMA attributes is architecture-specific, and
 each attribute should be documented in Documentation/DMA-attributes.txt.
 
 If struct dma_attrs* is NULL, the semantics of each of these
@@ -458,7 +464,7 @@ Note: where the platform can return consistent memory, it will
 guarantee that the sync points become nops.
 
 Warning:  Handling non-consistent memory is a real pain.  You should
-only ever use this API if you positively know your driver will be
+only use this API if you positively know your driver will be
 required to work on one of the rare (usually non-PCI) architectures
 that simply cannot make consistent memory.
 
@@ -496,26 +502,26 @@ dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 			    dma_addr_t device_addr, size_t size, int
 			    flags)
 
-Declare region of memory to be handed out by dma_alloc_coherent when
+Declare region of memory to be handed out by dma_alloc_coherent() when
 it's asked for coherent memory for this device.
 
 bus_addr is the physical address to which the memory is currently
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
 
 DMA_MEMORY_IO - request that the memory returned from
-dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
+dma_alloc_coherent() be addressable using read()/write()/memcpy_toio() etc.
 
 One or both of these flags must be present.
 
@@ -572,7 +578,7 @@ region is occupied.
 Part III - Debug drivers use of the DMA-API
 -------------------------------------------
 
-The DMA-API as described above as some constraints. DMA addresses must be
+The DMA-API as described above has some constraints. DMA addresses must be
 released with the corresponding function with the same size for example. With
 the advent of hardware IOMMUs it becomes more and more important that drivers
 do not violate those constraints. In the worst case such a violation can
@@ -690,11 +696,11 @@ architectural default.
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
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fd4aee29ad10..0808d3e7e218 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -8,6 +8,13 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 
+/*
+ * A dma_addr_t can hold any valid DMA or bus address for the platform.
+ * It can be given to a device to use as a DMA source or target, or it may
+ * appear on the bus when a CPU performs programmed I/O.  A CPU cannot
+ * reference a dma_addr_t directly because there may be translation between
+ * its physical address space and the bus address space.
+ */
 struct dma_map_ops {
 	void* (*alloc)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp,
diff --git a/include/linux/types.h b/include/linux/types.h
index 4d118ba11349..a0bb7048687f 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -142,6 +142,7 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
+/* A dma_addr_t can hold any valid DMA or bus address for the platform */
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 typedef u64 dma_addr_t;
 #else

