Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3IQFDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:03:00 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:43084 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3IQFC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:02:57 -0400
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 16 Sep 2013 22:02:33 -0700
Message-ID: <CACT4Y+aBrLLSjOS7j-pn7T-X3-Ouqtarm_fZ5C7SrKKMhjdWbA@mail.gmail.com>
Subject: Potential use-after-free in SyS_remap_file_pages
To: LKML <linux-kernel@vger.kernel.org>, Ranjit Manomohan <ranjitm@google.com>,
        Paul Turner <pjt@google.com>, Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on AddressSanitizer -- a tool that detects use-after-free
and out-of-bounds bugs
(https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).

Here is one of the use-after-free reports:

[  296.869705] ERROR: AddressSanitizer: heap-use-after-free on address
ffff88005b47a670
[  296.870787] ffff88005b47a670 is located 80 bytes inside of 184-byte
region [ffff88005b47a620, ffff88005b47a6d8)
[  296.872146] Accessed by thread T12219:
[  296.872673]   #0      inlined     describe_heap_address
./arch/x86/mm/asan/report.c:170
[  296.872673]   #0 ffffffff810dd2a6 (asan_report_error+0x306/0x410)
./arch/x86/mm/asan/report.c:284
[  296.873509]   #1 ffffffff810dc6a0 (asan_check_region+0x30/0x40)
./arch/x86/mm/asan/asan.c:37
[  296.874328]   #2 ffffffff810dd453 (__tsan_read8+0x13/0x20) ??:0
[  296.875295]   #3 ffffffff8124d1b6 (SyS_remap_file_pages+0x486/0x4f0) ??:0
[  296.876243]   #4 ffffffff81928582 (system_call_fastpath+0x16/0x1b)
./arch/x86/kernel/entry_64.S:645
[  296.877098]
[  296.877319] Freed by thread T12219:
[  296.877797]   #0 ffffffff810dc849 (asan_slab_free+0x69/0xb0)
./arch/x86/mm/asan/asan.c:134
[  296.878590]   #1      inlined     __cache_free ./mm/slab.c:3591
[  296.878590]   #1 ffffffff81280c55 (kmem_cache_free+0x55/0x2e0)
./mm/slab.c:3800
[  296.879403]   #2 ffffffff81258bfd (remove_vma+0xad/0xc0) ./mm/mmap.c:256
[  296.880161]   #3      inlined     remove_vma_list ./mm/mmap.c:2321
[  296.880161]   #3 ffffffff8125c817 (do_munmap+0x4d7/0x5f0) ./mm/mmap.c:2542
[  296.880888]   #4 ffffffff8125d3f0 (mmap_region+0x280/0x960) ./mm/mmap.c:1506
[  296.881666]   #5 ffffffff8124d18e (SyS_remap_file_pages+0x45e/0x4f0) ??:0
[  296.882547]   #6 ffffffff81928582 (system_call_fastpath+0x16/0x1b)
./arch/x86/kernel/entry_64.S:645
[  296.883408]
[  296.883627] Allocated by thread T12219:
[  296.884182]   #0 ffffffff810dc768 (asan_slab_alloc+0x48/0xc0)
./arch/x86/mm/asan/asan.c:91
[  296.884954]   #1      inlined     slab_alloc ./mm/slab.c:3475
[  296.884954]   #1 ffffffff81282eca (kmem_cache_alloc+0x9a/0x4c0)
./mm/slab.c:3630
[  296.885773]   #2 ffffffff8125d660 (mmap_region+0x4f0/0x960) ./mm/mmap.c:1534
[  296.886550]   #3 ffffffff8125df0a (do_mmap_pgoff+0x43a/0x510)
./mm/mmap.c:1345
[  296.887349]   #4 ffffffff81240482 (vm_mmap_pgoff+0xb2/0xf0) ./mm/util.c:370
[  296.888129]   #5      inlined     SYSC_mmap_pgoff ./mm/mmap.c:1394
[  296.888129]   #5 ffffffff8125b552 (SyS_mmap_pgoff+0x282/0x2f0)
./mm/mmap.c:1352
[  296.888912]   #6 ffffffff8108441d (SyS_mmap+0x5d/0x80)
./arch/x86/kernel/sys_x86_64.c:79
[  296.889650]   #7 ffffffff81928582 (system_call_fastpath+0x16/0x1b)
./arch/x86/kernel/entry_64.S:645
[  296.890505]
[  296.890705] Shadow bytes around the buggy address:
[  296.891415]   ffff88005b47a380: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  296.892644]   ffff88005b47a400: fa fa fa fa fa fa 00 00 00 00 00 00
00 00 00 00
[  296.893706]   ffff88005b47a480: 00 00 00 00 00 00 00 00 00 00 00 00
00 fa fa fa
[  296.894753]   ffff88005b47a500: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  296.895798]   ffff88005b47a580: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  296.896844] =>ffff88005b47a600: fa fa fa fa fd fd fd fd fd fd fd fd
fd fd[fd]fd
[  296.897893]   ffff88005b47a680: fd fd fd fd fd fd fd fd fd fd fd fa
fa fa fa fa
[  296.899037]   ffff88005b47a700: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  296.900101]   ffff88005b47a780: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  296.901149]   ffff88005b47a800: fa fa 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  296.902190]   ffff88005b47a880: 00 00 00 00 00 00 00 00 00 fa fa fa
fa fa fa fa
[  296.903180] Shadow byte legend (one shadow byte represents 8
application bytes):
[  296.904185]   Addressable:           00
[  296.904714]   Partially addressable: 01 02 03 04 05 06 07
[  296.905515]   Heap redzone:          fa
[  296.906096]   Heap kmalloc redzone:  fb
[  296.906613]   Freed heap region:     fd
[  296.907177]   Shadow gap:            fe

SyS_remap_file_pages() calls mmap_region(), which calls
remove_vma_list(), which calls remove_vma(), which frees the vma.
Later (after out label) SyS_remap_file_pages() accesses the freed vma
in vm_flags = vma->vm_flags.

The report is obtained on revision 6a7492a4b2e05051a44458d7187023e22d580666.

Please help to confirm/triage the report.
