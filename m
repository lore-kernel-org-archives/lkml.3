Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaK2Jif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:38:35 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35574 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaK2Jic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:38:32 -0500
MIME-Version: 1.0
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 29 Nov 2014 13:38:10 +0400
Message-ID: <CACT4Y+aWankm-bfSKbnQYA4OLM5z7ffqL0F_3V8hNH3mxsmQ=w@mail.gmail.com>
Subject: Out-of-bounds write in driver_override_show
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kasan-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Greg Thelen <gthelen@google.com>, Kees Cook <keescook@google.com>,
        Robert Swiecki <swiecki@google.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Yury Gribov <y.gribov@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am working on Kernel AddressSanitizer, a fast memory error detector
for kernel:
https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel

Here is an error report that I got while running trinity:

BUG: AddressSanitizer: out of bounds access in vsnprintf+0xd0/0x890 at
addr ffff880057483261
Write of size 1 by task trinity-c54/4461
=============================================================================
BUG kmalloc-4096 (Tainted: G        W     ): kasan error
-----------------------------------------------------------------------------
INFO: Allocated in seq_open+0x5a/0xe0 age=1571449 cpu=0 pid=28869
__slab_alloc+0x4c4/0x4e0
__kmalloc+0x18b/0x1b0
seq_buf_alloc+0x16/0x40
traverse+0x243/0x350
seq_read+0x434/0x6b0
kernfs_fop_read+0x176/0x1f0
vfs_read+0xd7/0x240
SyS_read+0x57/0xc0
system_call_fastpath+0x12/0x17
INFO: Slab 0xffffea00015d2000 objects=7 used=7 fp=0x          (null)
flags=0x100000000004080
INFO: Object 0xffff880057482260 @offset=8800 fp=0xffffffffffffffff

CPU: 0 PID: 4461 Comm: trinity-c54 Tainted: G    B   W      3.18.0-rc1+ #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 ffffffff81fbdaac ffff88008e3ab8c8 ffffffff81c85c3f 0000000000001130
 ffff88011b003200 ffff88008e3ab8f8 ffffffff811ee018 ffff88011b003200
 ffffea00015d2000 ffff880057482260 ffff8800d748225f ffff88008e3ab928
Call Trace:
 [<ffffffff811f76a5>] __asan_store1+0x75/0xb0 mm/kasan/kasan.c:417
 [<ffffffff8147b660>] vsnprintf+0xd0/0x890 lib/vsprintf.c:1860
 [<ffffffff8147bf70>] sprintf+0x40/0x50 lib/vsprintf.c:1989
 [<ffffffff816e1e51>] driver_override_show+0x31/0x40 drivers/base/platform.c:755
 [<ffffffff816d92d9>] dev_attr_show+0x39/0x80 drivers/base/core.c:120
 [<ffffffff812a3892>] sysfs_kf_seq_show+0x152/0x230 fs/sysfs/file.c:63
 [<ffffffff812a13a6>] kernfs_seq_show+0x76/0x90 fs/kernfs/file.c:168
 [<ffffffff8122f755>] traverse+0x185/0x350 fs/seq_file.c:120
 [<ffffffff8122fee4>] seq_read+0x434/0x6b0 fs/seq_file.c:191
[<ffffffff812a22f6>] kernfs_fop_read+0x176/0x1f0 fs/kernfs/file.c:244
 [<ffffffff811fc131>] do_loop_readv_writev+0x71/0xa0 fs/read_write.c:708
 [<ffffffff811fe850>] do_readv_writev+0x350/0x360 fs/read_write.c:842
 [<ffffffff811fe8ab>] vfs_readv+0x4b/0x70 fs/read_write.c:867
 [<     inlined    >] SyS_preadv+0xca/0xf0 SYSC_preadv fs/read_write.c:945
 [<ffffffff811fec0a>] SyS_preadv+0xca/0xf0 fs/read_write.c:931
 [<ffffffff81c91f69>] system_call_fastpath+0x12/0x17
arch/x86/kernel/entry_64.S:422
Memory state around the buggy address:
 ffff880057482f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff880057483200: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
                                                       ^
 ffff880057483280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff880057483300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff880057483380: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880057483480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
dev_attr_show: driver_override_show+0x0/0x40 returned bad count
fill_read_buffer: dev_attr_show+0x0/0x80 returned bad count


My source is on revision f114040e3ea6e07372334ade75d1ee0775c355e1.

I've looked at source code and it seems that driver_override_store
does not do length sanitization, so driver_override_show smashes
subsequent memory blocks in sprinf (with user-provided data?).
