Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaIJOiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:38:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11110 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaIJOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:23 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-79-5410625cb9f0
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC/PATCH v2 00/10] Kernel address sainitzer (KASan) - dynamic memory
 error deetector.
Date: Wed, 10 Sep 2014 18:31:17 +0400
Message-id: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xq7oxSQIhBtsvSlps+/WIzeL33pms
	FnPWr2GzOHLtO7vF+2U9jBbXv71htPj08gGjxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtfizaweTxeVdc9gs7q35z2px6cACJouWfReYLNo+/2O1ON57gMni7Z3pLBZtSzYyWSw+
	cpvZ4t2zycwWmzdNZba4uuogu8X5v8dZLX5seMzqIOOxZt4aRo/5Oz8yeuycdZfdY8GmUo/N
	K7Q8Fu95yeSxaVUnm8emT5PYPbreXmHyeHfuHLvHiRm/WTyeXJnO5PHx6S0Wj/f7rrJ59G1Z
	xehxZsER9gDhKC6blNSczLLUIn27BK6Mmw0X2QqW+1asPDyBrYHxhkUXIyeHhICJxPUrrYwQ
	tpjEhXvr2boYuTiEBJYySjw80c4C4fQxSVxvmgBWxSagJ/Fv1nY2EFtEQEFic+8zVhCbWeAt
	u0T7jnIQW1ggSWLrh8lMIDaLgKrE/C1zwGp4BdwkZm77xQKxTU5iw+7/YDM5geITpl9j7mLk
	AFrmKjFhhdoERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi8usOxqXHrA4xCnAw
	KvHwRuzhDxFiTSwrrsw9xCjBwawkwtvkIBAixJuSWFmVWpQfX1Sak1p8iJGJg1OqgVFUPDnr
	XeGObdl5Hrs+qIkd9n8ycVuT3ckWw97wirZa0Wf1/6VjG7c0pmofvHt951uzJIupU/Ky6yq7
	PvvuN5hZ5PLWpO3M2ZC9Rw5OPXtxg+5XCYH6jEePp1pqBeQ7TtFfMGXZswm1HYa/DU4l7Dos
	nCTov4ld4LaX5MIuzlzm1ym9Z05JPldiKc5INNRiLipOBAAGuj3gpgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This is a second iteration of kerenel address sanitizer (KASan).

KASan is a dynamic memory error detector designed to find use-after-free
and out-of-bounds bugs.

Currently KASAN supported only for x86_64 architecture and requires kernel
to be build with SLUB allocator.
KASAN uses compile-time instrumentation for checking every memory access, therefore you
will need a fresh GCC >= v5.0.0.

Patches are aplied on mmotm/next trees and also avaliable in git:

	git://github.com/aryabinin/linux --branch=kasan/kasan_v2

A lot of people asked about how kasan is different from other debuggin features,
so here is a short comparison:

KMEMCHECK:
	- KASan can do almost everything that kmemcheck can. KASan uses compile-time
	  instrumentation, which makes it significantly faster than kmemcheck.
	  The only advantage of kmemcheck over KASan is detection of unitialized
	  memory reads.

DEBUG_PAGEALLOC:
	- KASan is slower than DEBUG_PAGEALLOC, but KASan works on sub-page
	  granularity level, so it able to find more bugs.

SLUB_DEBUG (poisoning, redzones):
	- SLUB_DEBUG has lower overhead than KASan.

	- SLUB_DEBUG in most cases are not able to detect bad reads,
	  KASan able to detect both reads and writes.

	- In some cases (e.g. redzone overwritten) SLUB_DEBUG detect
	  bugs only on allocation/freeing of object. KASan catch
	  bugs right before it will happen, so we always know exact
	  place of first bad read/write.


Basic idea:
===========

    The main idea of KASAN is to use shadow memory to record whether each byte of memory
    is safe to access or not, and use compiler's instrumentation to check the shadow memory
    on each memory access.

    Address sanitizer uses 1/8 of the memory addressable in kernel for shadow memory
    and uses direct mapping with a scale and offset to translate a memory
    address to its corresponding shadow address.

    Here is function to translate address to corresponding shadow address:

         unsigned long kasan_mem_to_shadow(unsigned long addr)
         {
                    return ((addr - KASAN_SHADOW_START) >> KASAN_SHADOW_SCALE_SHIFT)
                                 + KASAN_SHADOW_START;
         }
    where KASAN_SHADOW_SCALE_SHIFT = 3.

    So for every 8 bytes there is one corresponding byte of shadow memory.
    The following encoding used for each shadow byte: 0 means that all 8 bytes of the
    corresponding memory region are valid for access; k (1 <= k <= 7) means that
    the first k bytes are valid for access, and other (8 - k) bytes are not;
    Any negative value indicates that the entire 8-bytes are unaccessible.
    Different negative values used to distinguish between different kinds of
    unaccessible memory (redzones, freed memory) (see mm/kasan/kasan.h).

    To be able to detect accesses to bad memory we need a special compiler.
    Such compiler inserts a specific function calls (__asan_load*(addr), __asan_store*(addr))
    before each memory access of size 1, 2, 4, 8 or 16.

    These functions check whether memory region is valid to access or not by checking
    corresponding shadow memory. If access is not valid an error printed.


Changes since v1:

    - The main change is in shadow memory laoyut.
      Now for shadow memory we reserve 1/8 of all virtual addresses available for kernel.
      16TB on x86_64 to cover all 128TB of kernel's address space.
      At early stage we map whole shadow region with zero page.
      Latter, after physical memory mapped to direct mapping address range
      we unmap zero pages from corresponding shadow and allocate and map a real
      memory.

        There are several reasons for such change.
         - Shadow for every available kernel address allows us to get rid of checks like that:
             if (addr >= PAGE_OFFSET && addr < high_memory)
                 // check shadow ...

         - Latter we want to catch out of bounds accesses in global variables, so we will need shadow
           to cover kernel image and modules address ranges

         - Such shadow allows us easily to deal with sparse memory configurations, and memory hotplug (not supported
	   yet, though should be easy to do).

         - The last and the main reason is that we want to keep simple 'real address' -> 'shadow address' translation:

                    (addr >> 3) + some_offset

            because it is fast, and because that's how inline instrumentation works in GCC.
            Inline instrumentation means that compiler directly insert code checking shadow
            instead of function calls __asan_load/__asan_store (outline instrumentation).1f41351A

             BTW, with a few changes in this patches and this two patches for GCC
             ( https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00452.html ,
               https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00605.html )
              inline instrumentation is already possible.


     - Since per-arch work is much bigger now, support for arm/x86_32 platforms was dropped.

     - CFLAGS was change from -fsanitize=address with different --params to -fsanitize=kernel-address

     - If compiler doesn't support -fsanitize=kernel-address warning printed and build continues without -fsanitize

     - Removed kasan_memset/kasan_memcpy/kasan_memmove hooks. It turned out that this hooks are not needed. Compiler
       already instrument memset/memcpy/memmove (inserts __asan_load/__asan_store call before mem*() calls).

     - branch profiling disabled for mm/kasan/kasan.c to avoid recursion (__asan_load -> ftrace_likely_update -> __asan_load -> ...)

     - kasan hooks for buddy allocator moved to right places


Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: <linux-kbuild@vger.kernel.org>
Cc: <x86@kernel.org>
Cc: <linux-mm@kvack.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>

Andrey Ryabinin (10):
  Add kernel address sanitizer infrastructure.
  x86_64: add KASan support
  mm: page_alloc: add kasan hooks on alloc and free pathes
  mm: slub: introduce virt_to_obj function.
  mm: slub: share slab_err and object_err functions
  mm: slub: introduce metadata_access_enable()/metadata_access_disable()
  mm: slub: add kernel address sanitizer support for slub allocator
  fs: dcache: manually unpoison dname after allocation to shut up
    kasan's reports
  kmemleak: disable kasan instrumentation for kmemleak
  lib: add kasan test module

 Documentation/kasan.txt              | 180 +++++++++++++++++++++
 Makefile                             |  10 +-
 arch/x86/Kconfig                     |   1 +
 arch/x86/boot/Makefile               |   2 +
 arch/x86/boot/compressed/Makefile    |   2 +
 arch/x86/include/asm/kasan.h         |  20 +++
 arch/x86/include/asm/page_64_types.h |   4 +
 arch/x86/include/asm/pgtable.h       |   7 +-
 arch/x86/kernel/Makefile             |   2 +
 arch/x86/kernel/dumpstack.c          |   5 +-
 arch/x86/kernel/head64.c             |   6 +
 arch/x86/kernel/head_64.S            |  16 ++
 arch/x86/mm/Makefile                 |   3 +
 arch/x86/mm/init.c                   |   3 +
 arch/x86/mm/kasan_init_64.c          |  59 +++++++
 arch/x86/realmode/Makefile           |   2 +-
 arch/x86/realmode/rm/Makefile        |   1 +
 arch/x86/vdso/Makefile               |   1 +
 fs/dcache.c                          |   5 +
 include/linux/kasan.h                |  75 +++++++++
 include/linux/sched.h                |   3 +
 include/linux/slab.h                 |  11 +-
 lib/Kconfig.debug                    |  10 ++
 lib/Kconfig.kasan                    |  18 +++
 lib/Makefile                         |   1 +
 lib/test_kasan.c                     | 254 +++++++++++++++++++++++++++++
 mm/Makefile                          |   4 +
 mm/compaction.c                      |   2 +
 mm/kasan/Makefile                    |   3 +
 mm/kasan/kasan.c                     | 299 +++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h                     |  38 +++++
 mm/kasan/report.c                    | 214 +++++++++++++++++++++++++
 mm/kmemleak.c                        |   6 +
 mm/page_alloc.c                      |   3 +
 mm/slab.h                            |  11 ++
 mm/slab_common.c                     |   5 +-
 mm/slub.c                            |  56 ++++++-
 scripts/Makefile.lib                 |  10 ++
 38 files changed, 1340 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/kasan.txt
 create mode 100644 arch/x86/include/asm/kasan.h
 create mode 100644 arch/x86/mm/kasan_init_64.c
 create mode 100644 include/linux/kasan.h
 create mode 100644 lib/Kconfig.kasan
 create mode 100644 lib/test_kasan.c
 create mode 100644 mm/kasan/Makefile
 create mode 100644 mm/kasan/kasan.c
 create mode 100644 mm/kasan/kasan.h
 create mode 100644 mm/kasan/report.c

-- 
1.8.5.5

