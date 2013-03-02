Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3CBU5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 15:57:18 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34974 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3CBU5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 15:57:17 -0500
MIME-Version: 1.0
Date: Sat, 2 Mar 2013 22:57:16 +0200
Message-ID: <CA+ydwtruzDg+qs5r1pSVV5DAceXRhPeAqCDM+GUyK5Jn_J83Gw@mail.gmail.com>
Subject: kmemleak BUG: unable to handle kernel paging request at ffffc90000c68000
From: Tommi Rantala <tt.rantala@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit the following BUG while fuzzing the kernel with trinity in a qemu
virtual machine as the root user.

The kernel is b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50 (Merge tag
'lzo-update-signature-20130226' of
git://github.com/markus-oberhumer/linux).

[   78.001652] kmemleak: Cannot allocate a kmemleak_object structure
[   78.003647] kmemleak: Kernel memory leak detector disabled
[   78.059339] device-mapper: ioctl: Unable to rename non-existent device,  to ▒
[   78.339932] BUG: unable to handle kernel paging request at ffffc90000c68000
[   78.340712] IP: [<ffffffff8136b5b0>] crc32_le+0x60/0x110
[   78.340712] PGD 7cc73067 PUD 7cc74067 PMD 7ad1e067 PTE 0
[   78.340712] Oops: 0000 [#1] SMP
[   78.340712] CPU 0
[   78.340712] Pid: 1399, comm: kmemleak Not tainted 3.8.0+ #93 Bochs Bochs
[   78.340712] RIP: 0010:[<ffffffff8136b5b0>]  [<ffffffff8136b5b0>]
crc32_le+0x60/0x110
[   78.340712] RSP: 0000:ffff88007a4f7da0  EFLAGS: 00010046
[   78.340712] RAX: 0000000000000000 RBX: ffff8800290c2450 RCX: 0000000000000028
[   78.340712] RDX: 0000000000000f00 RSI: ffffc90000c68000 RDI: ffffc90000c67ffc
[   78.340712] RBP: ffff88007a4f7da8 R08: 0000000000000000 R09: 0000000000000001
[   78.340712] R10: 0000000000000000 R11: ffffc90000c67ffc R12: 0000000000000286
[   78.340712] R13: 0000000000000000 R14: 000000000007fffe R15: 0000000000000040
[   78.340712] FS:  0000000000000000(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   78.340712] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   78.340712] CR2: ffffc90000c68000 CR3: 000000000aba2000 CR4: 00000000000006f0
[   78.340712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   78.340712] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   78.340712] Process kmemleak (pid: 1399, threadinfo
ffff88007a4f6000, task ffff88007ae68000)
[   78.340712] Stack:
[   78.340712]  ffff8800290c2450 ffff88007a4f7e18 ffffffff811a40af
ffffffff811a3fa0
[   78.340712]  ffffffff820d041d 2222222222222222 0000000000000286
2222222222222222
[   78.340712]  ffff8800290c24a0 ffffffff811a4860 00000000000927c0
0000000000000000
[   78.340712] Call Trace:
[   78.340712]  [<ffffffff811a40af>] kmemleak_scan+0x58f/0x8d0
[   78.340712]  [<ffffffff811a3fa0>] ? kmemleak_scan+0x480/0x8d0
[   78.340712]  [<ffffffff811a4860>] ? kmemleak_write+0x470/0x470
[   78.340712]  [<ffffffff811a4860>] ? kmemleak_write+0x470/0x470
[   78.340712]  [<ffffffff811a48ca>] kmemleak_scan_thread+0x6a/0xd0
[   78.340712]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[   78.340712]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[   78.340712]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[   78.340712]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[   78.340712]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[   78.340712] Code: 00 40 f6 c6 03 75 da 0f 1f 40 00 49 89 d2 48 c1
ea 03 4c 8d 5e fc 41 83 e2 07 48 85 d2 0f 84 82 00 00 00 4c 89 df 45
31 c0 66 90 <8b> 5f 04 48 83 c7 08 49 83 c0 01 8b 0f 31 c3 89 d8 44 0f
b6 cb
[   78.340712] RIP  [<ffffffff8136b5b0>] crc32_le+0x60/0x110
[   78.340712]  RSP <ffff88007a4f7da0>
[   78.340712] CR2: ffffc90000c68000
[   78.340712] ---[ end trace 93ec389b16e7ea85 ]---

Tommi
