Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3ICOlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:41:37 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64305 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3ICOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:41:36 -0400
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 3 Sep 2013 18:41:16 +0400
Message-ID: <CACT4Y+Y6r=HV7nFgbu=B=d-4ka3J4yotRjgX1M1xGkNkFn1sOQ@mail.gmail.com>
Subject: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
To: LKML <linux-kernel@vger.kernel.org>
Cc: ak@linux.intel.com, Paul Turner <pjt@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are working on a memory error detector AddressSanitizer for Linux
kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
it can detect use-after-free and buffer-overflow errors.

Here is a new report from the tool:

[  124.575597] ERROR: AddressSanitizer: heap-buffer-overflow on
address ffff88002e280000
[  124.576801] ffff88002e280000 is located 131938492886538 bytes to
the left of 28857600-byte region [ffffffff81282e0a, ffffffff82e0830a)
[  124.578633] Accessed by thread T10915:
[  124.579295]          inlined      in describe_heap_address
./arch/x86/mm/asan/report.c:164
[  124.579295]   #0 ffffffff810dd277 in asan_report_error
./arch/x86/mm/asan/report.c:278
[  124.580137]   #1 ffffffff810dc6a0 in asan_check_region
./arch/x86/mm/asan/asan.c:37
[  124.581050]   #2 ffffffff810dd423 in __tsan_read8 ??:0
[  124.581893]   #3 ffffffff8107c093 in get_wchan
./arch/x86/kernel/process_64.c:444
[  124.582763]   #4 ffffffff81342108 in do_task_stat array.c:0
[  124.583634]   #5 ffffffff81342dcc in proc_tgid_stat ??:0
[  124.584548]   #6 ffffffff8133c984 in proc_single_show base.c:0
[  124.585461]   #7 ffffffff812d18cc in seq_read ./fs/seq_file.c:222
[  124.586313]   #8 ffffffff8129e503 in vfs_read ??:0
[  124.587137]   #9 ffffffff8129f800 in SyS_read ??:0
[  124.587827]   #10 ffffffff81929bf5 in sysenter_dispatch
./arch/x86/ia32/ia32entry.S:164
[  124.588738]
[  124.588964] Allocated by thread T0:
[  124.592379]   #4 ffffffff00000008 in __per_cpu_start ??:0
[  124.593217]
[  124.593434] Shadow bytes around the buggy address:
[  124.594270]   ffff88002e27fd80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.595339]   ffff88002e27fe00: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.596453]   ffff88002e27fe80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.597466]   ffff88002e27ff00: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.598501]   ffff88002e27ff80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.599629] =>ffff88002e280000:[fa]fa fa fa fa fa fa fa fa fa 00 00
00 00 00 00
[  124.600873]   ffff88002e280080: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  124.601892]   ffff88002e280100: 00 fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  124.603037]   ffff88002e280180: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  124.604047]   ffff88002e280200: fa fa fa fa fa fa fa fd fd fd fd fd
fd fd fd fd
[  124.605054]   ffff88002e280280: fd fd fd fd fd fd fd fd fd fd fd fd
fd fd fa fa
[  124.605993] Shadow byte legend (one shadow byte represents 8
application bytes):
[  124.606958]   Addressable:           00
[  124.607483]   Partially addressable: 01 02 03 04 05 06 07
[  124.608219]   Heap redzone:          fa
[  124.608724]   Heap kmalloc redzone:  fb
[  124.609249]   Freed heap region:     fd
[  124.609753]   Shadow gap:            fe
[  124.610292] =========================================================================

Indeed, get_wchan ensures that fp<stack+THREAD_SIZE, but then dereferences fp+8:

434                 if (fp < (unsigned long)stack ||
435                     fp >= (unsigned long)stack+THREAD_SIZE)
436                         return 0;
437                 ip = *(u64 *)(fp+8);

It must check that fp+8<stack+THREAD_SIZE.
As far as I see, the bug can lead to garbage return values or in the
worst case to crash.
