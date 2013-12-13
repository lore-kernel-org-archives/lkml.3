Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3LMW0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37180 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3LMW0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 000/115] Android ION for drivers/staging
Date: Fri, 13 Dec 2013 14:23:34 -0800
Message-Id: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to submit the Android ION code to drivers/staging.

ION is a constraint aware memory allocator used by Android in order
to allocate memory that can be properly shared between a number of
devices that possibly have different memory access constraints.

You can read some background on ION as well as some problematic
aspects of ION in my lwn summary here:
	https://lwn.net/Articles/565469/

Recently, Colin Cross has put in quite a bit of effort to resolve
a number of the issues identified in that article as well as other.

While a number of issues remain, including negative sentiments
from upstream maintainers about the interface, ION provides
functionality (constraints based allocation), which is not currently
available upstream.

As discussed at Linux Plumbers this year (https://lwn.net/Articles/569704/)
it was proposed to merge the ION code into staging. This will allow for
better visibility to the upstream community, allowing further review
and understanding of the code, but it will also aid in the design of
dma-buf constraint-aware memory allocation helpers, allowing us to share
the backing heap allocation implementations.

In order to preserve authorship history, I've taken all the ION changes
in AOSP's common.git android-3.10 branch up to commit 8f1c42284159ebd6
(Improve ION config descriptions). The only modifications to the patches
that I've made is pushing down Colin's patch to migrate ION to staging
(ION was originally implemented in drivers/gpu/ion) so all the patches
apply to staging from the start.

I've also had to add a single patch (the last one) which moves ION
to use the new scan/count shrinker api introduced in 3.12.

Other then this one change, the only diff from AOSP's 3.10 branch are
corrected path names in the header comment. ie:
	- * drivers/gpu/ion/ion.c
	+ * drivers/staging/android/ion/ion.c

This is a fairly large patchset, and is also available here:
http://git.linaro.org/git/people/john.stultz/android-dev.git dev/ion-staging

Please let me know if you have any thoughts or objections.

thanks
-john



Arve Hjønnevåg (2):
  gpu: ion: __dma_page_cpu_to_dev -> arm_dma_ops.sync_single_for_device
    hack
  gpu: ion: Remove __GFP_NO_KSWAPD

Benjamin Gaignard (4):
  gpu: ion: fix carveout ops
  gpu: ion: fix compilation warning
  gpu: ion: fix ion_platform_data definition
  gpu: ion: add CMA heap

Colin Cross (36):
  gpu: ion: ion_carveout_heap: fix for 3.4
  ion: chunk_heap: fix leak in allocated counter
  ion: add free list size to heap debug files
  ion: convert map_kernel to return ERR_PTR
  ion: remove IS_ERR_OR_NULL
  ion: replace userspace handle cookies with idr
  ion: index client->handles rbtree by buffer
  ion: don't use id 0 for handle cookie
  gpu: ion: delete ion_system_mapper.c
  ion: move userspace api into uapi/ion.h
  ion: hold reference to handle after ion_uhandle_get
  ion: fix crash when alloc len is -1
  ion: fix dma APIs
  ion: convert sg_dma_len(sg) to sg->length
  ion: check invalid values in ion_system_heap
  ion: add test device for unit tests to interact with dma_bufs
  ion: update idr to avoid deprecated apis
  ion: don't use __arm_ioremap to map pages
  ion: don't use phys_to_page or __phys_to_pfn
  ion: fix printk warnings
  gpu: ion: remove unnecessary function from system heap
  ion: clean up ioctls
  ion: drop dependency on ARM
  ion: add alignment check to carveout heap
  ion: optimize ion_heap_buffer_zero
  ion: free low memory from page pools first
  ion: check return value from remap_pfn_range
  ion: use vm_insert_pfn for faulted pages
  ion: remove ion_heap_alloc_pages
  ion: allow cached mappings of chunk and system heap buffers
  ion: use alloc_pages in system contig heap
  ion: fix sparse warnings
  ion: carveout heap: zero buffers on free, fix memory leak
  ion: add helper to zero contiguous region of pages
  ion: add alignment check to chunk heap
  ion: fix bugs in cma heap

Dima Zavin (1):
  gpu: ion: do not ask for compound pages in system heap

Greg Hackmann (2):
  gpu: ion: fill in buffer->{dev,size} before mapping new buffers
  gpu: ion: fix page offset in dma_buf_kmap()

JP Abgrall (1):
  gpu: ion: fix kfree/list_del order

Johan Mossberg (2):
  gpu: ion: Export ion_client_create
  gpu: ion: Add support for sharing buffers with dma buf kernel handles

John Stultz (6):
  ion: Add Kconfig dependency to ARM
  ion: Fix compat support to use proper compat ioctl numbers
  ion: Fix two small issues in system_heap allocation
  ion: Cleanup whitespace issues and other checkpatch problems
  ion: Improve ION config description
  ion: Update system heap shrinker to use the new count/scan interface

KyongHo Cho (1):
  gpu: ion: several bugfixes and enhancements of ION

Laura Abbott (3):
  gpu: ion: Loop on the handle count when destroying
  gpu: ion: Map only the vma size given
  gpu: ion: Don't call ion_buffer_put on error path

Mitchel Humpherys (1):
  gpu: ion: fix use-after-free in ion_heap_freelist_drain

Olav Haugan (3):
  gpu: ion: Add missing argument to WARN call
  gpu: ion: Add EXPORT_SYMBOL to functions
  gpu: ion: IOCTL return success when error occurs

Rebecca Schultz Zavin (50):
  gpu: ion: Add ION Memory Manager
  ion: Switch map/unmap dma api to sg_tables
  ion: Add reserve function to ion
  ion: Switch ion to use dma-buf
  gpu: ion: Use alloc_pages instead of vmalloc from the system heap
  gpu: ion: support begin/end and kmap/kunmap dma_buf ops
  gpu: ion: Allocate the sg_table at creation time rather than
    dynamically
  gpu: ion: Get an sg_table from an ion handle
  gpu: ion: Set the dma_address of the sg list at alloc time
  gpu: ion: ion_system_heap: Change allocations to GFP_HIGHUSER
  gpu: ion: Add cache maintenance to ion.
  gpu: ion: Modify the system heap to try to allocate large/huge pages
  gpu: ion: Add explicit sync ioctl
  gpu: ion: Only map as much of the vma as the user requested
  gpu: ion: Switch to using kmalloc rather than kmap during allocation
  gpu: ion: Fix race between ion_import and ion_free
  gpu: ion: Fix bug in ion_free
  gpu: ion: Add debug information for orphaned handles
  gpu: ion: Fix memory leak of dirty bits
  gpu: ion: Add support for cached mappings that don't fault
  gpu: ion: optimize system heap for non fault buffers
  gpu: ion: Stop trying to allocate from an order on first failure
  gpu: ion: ion_system_heap: Fix bug preventing compilation
  gpu: ion: use vmalloc to allocate page array to map kernel
  gpu: ion: Add ion_page_pool.
  gpu: ion: Use the ion_page_pool from the system heap
  gpu: ion: Modify gfp flags in ion_system_heap
  gpu: ion: Fix several issues with page pool
  gpu: ion: Fix lockdep issue in ion_page_pool
  gpu: ion: Switch to using a single shrink function
  gpu: ion: Refactor locking
  gpu: ion: Clear GFP_WAIT flag on high order allocations
  gpu: ion: Don't flush allocatoins that come from the page pools
  gpu: ion: Fix bug in ion_system_heap map_user
  gpu: ion: Fix bug in zeroing pages in system heap
  gpu: ion: Modify reserve function for carveouts with no start address
  gpu: ion: Fix bug where MAP ioctl was no longer supported
  gpu: ion: Switch heap rbtree to a prio list
  gpu: ion: Refactor common mapping functions out of system heap
  gpu: ion: Add chunk heap
  gpu: ion: Clarify variable names and comments around heap ids v types
  gpu: ion: Remove heapmask from client
  gpu: ion: Modify zeroing code so it only allocates address space once
  gpu: ion: Refactor the code to zero buffers
  gpu: ion: Only flush buffers in the chunk heap if they were used
    cached
  gpu: ion: Make ion_free asynchronous
  gpu: ion: ion_chunk_heap: Zero chunk heap memory at creation time
  gpu: ion: Fix bug in ion shrinker
  gpu: ion: Also shrink memory cached in the deferred free list
  gpu: ion: Fix performance issue in faulting code

Rom Lemarchand (3):
  ion: add new ion_user_handle_t type for the user-space token
  ion: change ion_user_handle_t definition to int
  ion: add compat_ioctl

 drivers/staging/android/Kconfig                 |    2 +
 drivers/staging/android/Makefile                |    2 +
 drivers/staging/android/ion/Kconfig             |   24 +
 drivers/staging/android/ion/Makefile            |    7 +
 drivers/staging/android/ion/compat_ion.c        |  177 +++
 drivers/staging/android/ion/compat_ion.h        |   30 +
 drivers/staging/android/ion/ion.c               | 1549 +++++++++++++++++++++++
 drivers/staging/android/ion/ion.h               |  204 +++
 drivers/staging/android/ion/ion_carveout_heap.c |  194 +++
 drivers/staging/android/ion/ion_chunk_heap.c    |  195 +++
 drivers/staging/android/ion/ion_cma_heap.c      |  218 ++++
 drivers/staging/android/ion/ion_heap.c          |  314 +++++
 drivers/staging/android/ion/ion_page_pool.c     |  195 +++
 drivers/staging/android/ion/ion_priv.h          |  360 ++++++
 drivers/staging/android/ion/ion_system_heap.c   |  483 +++++++
 drivers/staging/android/ion/ion_test.c          |  281 ++++
 drivers/staging/android/ion/tegra/Makefile      |    1 +
 drivers/staging/android/ion/tegra/tegra_ion.c   |   96 ++
 drivers/staging/android/uapi/ion.h              |  196 +++
 drivers/staging/android/uapi/ion_test.h         |   71 ++
 20 files changed, 4599 insertions(+)
 create mode 100644 drivers/staging/android/ion/Kconfig
 create mode 100644 drivers/staging/android/ion/Makefile
 create mode 100644 drivers/staging/android/ion/compat_ion.c
 create mode 100644 drivers/staging/android/ion/compat_ion.h
 create mode 100644 drivers/staging/android/ion/ion.c
 create mode 100644 drivers/staging/android/ion/ion.h
 create mode 100644 drivers/staging/android/ion/ion_carveout_heap.c
 create mode 100644 drivers/staging/android/ion/ion_chunk_heap.c
 create mode 100644 drivers/staging/android/ion/ion_cma_heap.c
 create mode 100644 drivers/staging/android/ion/ion_heap.c
 create mode 100644 drivers/staging/android/ion/ion_page_pool.c
 create mode 100644 drivers/staging/android/ion/ion_priv.h
 create mode 100644 drivers/staging/android/ion/ion_system_heap.c
 create mode 100644 drivers/staging/android/ion/ion_test.c
 create mode 100644 drivers/staging/android/ion/tegra/Makefile
 create mode 100644 drivers/staging/android/ion/tegra/tegra_ion.c
 create mode 100644 drivers/staging/android/uapi/ion.h
 create mode 100644 drivers/staging/android/uapi/ion_test.h

-- 
1.8.3.2

