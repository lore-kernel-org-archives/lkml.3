Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaIXMvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35253 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e0-5422be3c19fc
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
        Dave Jones <davej@redhat.com>
Subject: [PATCH v3 00/13] Kernel address sanitizer - runtime memory debugger.
Date: Wed, 24 Sep 2014 16:43:56 +0400
Message-id: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xy7o2+5RCDLqvylhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtfizaweTxeVdc9gs7q35z2px6cACJouWfReYLNo+/2O1ON57gMni7Z3pLBZtSzYyWSw+
	cpvZ4t2zycwWmzdNZba4uuogu8X5v8dZLX5seMzqIOMxf+dHRo+ds+6yeyzYVOqxeYWWx+I9
	L5k8Nq3qZPPY9GkSu0fX2ytMHu/OnWP3ODHjN4vHkyvTmTw+Pr3F4vF+31U2j74tqxg9ziw4
	wu7xeZNcgFAUl01Kak5mWWqRvl0CV8aFnT2MBVv9KpZ2/GNpYNxl1cXIySEhYCLx5/cCJghb
	TOLCvfVsXYxcHEICSxklNn/7A+X0MUksmvsGrIpNQE/i36ztbCC2iICCxObeZ6wgRcwC99kl
	Ts37xgySEBbwlZizdhcjiM0ioCqxefILsGZeATeJbw8nskCsk5PYO3k1mM0JFJ8w/RpQLwfQ
	NleJCSvUJjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREpFfdjAuPmZ1iFGAg1GJ
	h3eCuFKIEGtiWXFl7iFGCQ5mJRHesD1AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyNU8/Hz/lp
	uWV512M/8xk+8vx2Nmf2fa4oOmZd4sierLTqcercv42fOaTvcQhMzHBzrT7TPeNywBfZmXl7
	Xgc/3XAwv81Pc2Jf/+rDXNybD7zl3b3Ghkkg+yFj89rd98q1So+drBeV/3hnZ3Kj1CafkGbj
	bzvzLUVNLKVnMjAqfNW2NX695o0SS3FGoqEWc1FxIgDUdIXfpgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This is a third iteration of kerenel address sanitizer (KASan).

KASan is a runtime memory debugger designed to find use-after-free
and out-of-bounds bugs.

Currently KASAN supported only for x86_64 architecture and requires kernel
to be build with SLUB allocator.
KASAN uses compile-time instrumentation for checking every memory access, therefore you
will need a fresh GCC >= v5.0.0.

Patches are based on mmotm-2014-09-22-16-57 tree and also avaliable in git:

	git://github.com/aryabinin/linux --branch=kasan/kasan_v3

Note: patch (https://lkml.org/lkml/2014/9/4/364) for gcc5 support
somewhat just disappeared from the last mmotm, so you will need to apply it.
It's already done in my git above.

Changes since v2:

    - Shadow moved to vmalloc area.
    - Added posion page. This page mapped to shadow correspondig to
      shadow region itself:
       [kasan_mem_to_shadow(KASAN_SHADOW_START) - kasan_mem_to_shadow(KASAN_SHADOW_END)]
      It used to catch memory access to shadow outside mm/kasan/.

    - Fixed boot with CONFIG_DEBUG_VIRTUAL=y
    - Fixed boot with KASan and stack protector enabled
         (patch "x86_64: load_percpu_segment: read irq_stack_union.gs_base before load_segment")

    - Fixed build with CONFIG_EFI_STUB=y
    - Some slub specific stuf moved from mm/slab.h to include/linux/slub_def.h
    - Fixed Kconfig dependency. CONFIG_KASAN depends on CONFIG_SLUB_DEBUG.
    - Optimizations of __asan_load/__asan_store.
    - Spelling fixes from Randy.
    - Misc minor cleanups in different places.


    - Added inline instrumentation in last patch. This will require two not
         yet-in-trunk-patches for GCC:
             https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00452.html
             https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00605.html

Changes since v1:

    - The main change is in shadow memory laoyut.
      Now for shadow memory we reserve 1/8 of all virtual addresses available for kernel.
      16TB on x86_64 to cover all 128TB of kernel's address space.
      At early stage we map whole shadow region with zero page.
      Latter, after physical memory mapped to direct mapping address range
      we unmap zero pages from corresponding shadow and allocate and map a real
      memory.

     - Since per-arch work is much bigger now, support for arm/x86_32 platforms was dropped.

     - CFLAGS was change from -fsanitize=address with different --params to -fsanitize=kernel-address

     - If compiler doesn't support -fsanitize=kernel-address warning printed and build continues without -fsanitize

     - Removed kasan_memset/kasan_memcpy/kasan_memmove hooks. It turned out that this hooks are not needed. Compiler
       already instrument memset/memcpy/memmove (inserts __asan_load/__asan_store call before mem*() calls).

     - branch profiling disabled for mm/kasan/kasan.c to avoid recursion (__asan_load -> ftrace_likely_update -> __asan_load -> ...)

     - kasan hooks for buddy allocator moved to right places


Comparison with other debuggin features:
=======================================

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
    (on x86_64 16TB of virtual address space reserved for shadow to cover all 128TB)
    and uses direct mapping with a scale and offset to translate a memory
    address to its corresponding shadow address.

    Here is function to translate address to corresponding shadow address:

         unsigned long kasan_mem_to_shadow(unsigned long addr)
         {
                    return (addr >> KASAN_SHADOW_SCALE_SHIFT) + KASAN_SHADOW_OFFSET;
         }
    where KASAN_SHADOW_SCALE_SHIFT = 3.

    So for every 8 bytes there is one corresponding byte of shadow memory.
    The following encoding used for each shadow byte: 0 means that all 8 bytes of the
    corresponding memory region are valid for access; k (1 <= k <= 7) means that
    the first k bytes are valid for access, and other (8 - k) bytes are not;
    Any negative value indicates that the entire 8-bytes are inaccessible.
    Different negative values used to distinguish between different kinds of
    inaccessible memory (redzones, freed memory) (see mm/kasan/kasan.h).

    To be able to detect accesses to bad memory we need a special compiler.
    Such compiler inserts a specific function calls (__asan_load*(addr), __asan_store*(addr))
    before each memory access of size 1, 2, 4, 8 or 16.

    These functions check whether memory region is valid to access or not by checking
    corresponding shadow memory. If access is not valid an error printed.


Andrey Ryabinin (13):
  Add kernel address sanitizer infrastructure.
  efi: libstub: disable KASAN for efistub
  x86_64: load_percpu_segment: read irq_stack_union.gs_base before
    load_segment
  x86_64: add KASan support
  mm: page_alloc: add kasan hooks on alloc and free paths
  mm: slub: introduce virt_to_obj function.
  mm: slub: share slab_err and object_err functions
  mm: slub: introduce metadata_access_enable()/metadata_access_disable()
  mm: slub: add kernel address sanitizer support for slub allocator
  fs: dcache: manually unpoison dname after allocation to shut up
    kasan's reports
  kmemleak: disable kasan instrumentation for kmemleak
  lib: add kasan test module
  kasan: introduce inline instrumentation

 Documentation/kasan.txt               | 179 ++++++++++++++
 Makefile                              |  16 +-
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/Makefile                |   2 +
 arch/x86/boot/compressed/Makefile     |   2 +
 arch/x86/include/asm/kasan.h          |  27 +++
 arch/x86/kernel/Makefile              |   2 +
 arch/x86/kernel/cpu/common.c          |   4 +-
 arch/x86/kernel/dumpstack.c           |   5 +-
 arch/x86/kernel/head64.c              |   9 +-
 arch/x86/kernel/head_64.S             |  28 +++
 arch/x86/mm/Makefile                  |   3 +
 arch/x86/mm/init.c                    |   3 +
 arch/x86/mm/kasan_init_64.c           |  87 +++++++
 arch/x86/realmode/Makefile            |   2 +-
 arch/x86/realmode/rm/Makefile         |   1 +
 arch/x86/vdso/Makefile                |   1 +
 drivers/firmware/efi/libstub/Makefile |   1 +
 fs/dcache.c                           |   5 +
 include/linux/kasan.h                 |  72 ++++++
 include/linux/sched.h                 |   3 +
 include/linux/slab.h                  |  11 +-
 include/linux/slub_def.h              |   9 +
 lib/Kconfig.debug                     |   2 +
 lib/Kconfig.kasan                     |  54 +++++
 lib/Makefile                          |   1 +
 lib/test_kasan.c                      | 254 ++++++++++++++++++++
 mm/Makefile                           |   4 +
 mm/compaction.c                       |   2 +
 mm/kasan/Makefile                     |   3 +
 mm/kasan/kasan.c                      | 441 ++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h                      |  37 +++
 mm/kasan/report.c                     | 259 ++++++++++++++++++++
 mm/kmemleak.c                         |   6 +
 mm/page_alloc.c                       |   3 +
 mm/slab_common.c                      |   5 +-
 mm/slub.c                             |  56 ++++-
 scripts/Makefile.lib                  |  10 +
 38 files changed, 1595 insertions(+), 15 deletions(-)
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
Cc: Dave Jones <davej@redhat.com>


-- 
2.1.1

