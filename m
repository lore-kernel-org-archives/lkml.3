Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3JBSiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:38:05 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58068 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3JBSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
Date: Wed, 2 Oct 2013 22:38:01 +0400
Message-ID: <CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
Subject: Fwd: Potential out-of-bounds in ftrace_regex_release
From: Andrey Konovalov <andreyknvl@google.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com
Cc: Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I am working on AddressSanitizer -- a tool that detects use-after-free
and out-of-bounds bugs
(https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).
Below is one of the bug reports that I got while running trinity syscall fuzzer.
Kernel is built on revision d8efd82eece89f8a5790b0febf17522affe9e1f1.

[  286.473434] ERROR: AddressSanitizer: heap-buffer-overflow on
address ffff8800359c99f3
[  286.474598] ffff8800359c99f3 is located 0 bytes to the right of
243-byte region [ffff8800359c9900, ffff8800359c99f3)
[  286.476100] Accessed by thread T13003:
[  286.476735]   #0 ffffffff810dd2da (asan_report_error+0x32a/0x440)
[  286.477556]   #1 ffffffff810dc6b0 (asan_check_region+0x30/0x40)
[  286.478353]   #2 ffffffff810dd4d3 (__tsan_write1+0x13/0x20)
[  286.479112]   #3 ffffffff811cd19e (ftrace_regex_release+0x1be/0x260)
[  286.479929]   #4 ffffffff812a1065 (__fput+0x155/0x360)
[  286.480627]   #5 ffffffff812a12de (____fput+0x1e/0x30)
[  286.481331]   #6 ffffffff8111708d (task_work_run+0x10d/0x140)
[  286.482107]   #7 ffffffff810ea043 (do_exit+0x433/0x11f0)
[  286.482793]   #8 ffffffff810eaee4 (do_group_exit+0x84/0x130)
[  286.483552]   #9 ffffffff810eafb1 (SyS_exit_group+0x21/0x30)
[  286.484320]   #10 ffffffff81928782 (system_call_fastpath+0x16/0x1b)
[  286.485151]
[  286.485365] Allocated by thread T5167:
[  286.485979]   #0 ffffffff810dc778 (asan_slab_alloc+0x48/0xc0)
[  286.486750]   #1 ffffffff8128337c (__kmalloc+0xbc/0x500)
[  286.487474]   #2 ffffffff811d9d54 (trace_parser_get_init+0x34/0x90)
[  286.488313]   #3 ffffffff811cd7b3 (ftrace_regex_open+0x83/0x2e0)
[  286.489120]   #4 ffffffff811cda7d (ftrace_filter_open+0x2d/0x40)
[  286.489894]   #5 ffffffff8129b4ff (do_dentry_open+0x32f/0x430)
[  286.490674]   #6 ffffffff8129b668 (finish_open+0x68/0xa0)
[  286.491411]   #7 ffffffff812b66ac (do_last+0xb8c/0x1710)
[  286.492135]   #8 ffffffff812b7350 (path_openat+0x120/0xb50)
[  286.492855]   #9 ffffffff812b8884 (do_filp_open+0x54/0xb0)
[  286.493604]   #10 ffffffff8129d36c (do_sys_open+0x1ac/0x2c0)
[  286.494366]   #11 ffffffff8129d4b7 (SyS_open+0x37/0x50)
[  286.495078]   #12 ffffffff81928782 (system_call_fastpath+0x16/0x1b)
[  286.495878]
[  286.496120] Shadow bytes around the buggy address:
[  286.496810]   ffff8800359c9700: fd fd fd fd fd fd fd fd fd fd fd fd
fd fd fd fd
[  286.499707]   ffff8800359c9780: fd fd fd fd fd fd fd fd fa fa fa fa
fa fa fa fa
[  286.502622]   ffff8800359c9800: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  286.505521]   ffff8800359c9880: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  286.508459]   ffff8800359c9900: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  286.511345] =>ffff8800359c9980: 00 00 00 00 00 00 00 00 00 00 00 00
00 00[03]fb
[  286.514243]   ffff8800359c9a00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  286.517175]   ffff8800359c9a80: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  286.520059]   ffff8800359c9b00: fa fa fa fa fa fa fa fa 00 00 00 00
00 00 00 00
[  286.522936]   ffff8800359c9b80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  286.525921]   ffff8800359c9c00: 00 00 00 00 00 00 00 00 fa fa fa fa
fa fa fa fa
[  286.528738] Shadow byte legend (one shadow byte represents 8
application bytes):
[  286.529701]   Addressable:           00
[  286.530346]   Partially addressable: 01 02 03 04 05 06 07
[  286.531155]   Heap redzone:          fa
[  286.531753]   Heap kmalloc redzone:  fb
[  286.532414]   Freed heap region:     fd
[  286.533083]   Shadow gap:            fe

The out-of-bounds access happens on 'parser->buffer[parser->idx] = 0;'

My guess is that 'trace_get_user()' was called.
Checking that 'parser->idx < parser->size - 1' is not performed in 'if
(isspace(ch))' section, so 'parser->idx' becomes equal to
'parser->size' after 'parser->buffer[parser->idx++] = ch;'.
(However in 'while (cnt && !isspace(ch))' loop checking is performed.)

Please help to confirm/triage the report.
