Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab3BSRpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:45:32 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:53320 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab3BSRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:45:31 -0500
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 19:45:29 +0200
Message-ID: <CA+ydwtpmoxqOfDa=VESPmgiozxEhdfZRA3+AZznh+ztugRYufg@mail.gmail.com>
Subject: NULL pointer deref at drm_newctx()
From: Tommi Rantala <tt.rantala@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit this oops a few times while fuzzing the kernel with trinity in a qemu VM:

[  139.826369] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  139.827023] IP: [<ffffffff8143cb04>] drm_newctx+0x64/0xb0
[  139.827023] PGD 36f6d067 PUD 36f6e067 PMD 0
[  139.827023] Oops: 0000 [#1] SMP
[  139.827023] CPU 0
[  139.827023] Pid: 2300, comm: trinity-child14 Not tainted 3.8.0-rc7+
#86 Bochs Bochs
[  139.827023] RIP: 0010:[<ffffffff8143cb04>]  [<ffffffff8143cb04>]
drm_newctx+0x64/0xb0
[  139.827023] RSP: 0018:ffff880036f75d58  EFLAGS: 00010246
[  139.827023] RAX: 0000000000000000 RBX: ffff88003ca08000 RCX: ffffffff8217c9c4
[  139.827023] RDX: ffffffff81e72933 RSI: ffffffff8214f6d4 RDI: 0000000000000001
[  139.827023] RBP: ffff880036f75d78 R08: 00000000000000ff R09: ffffffff8143caa0
[  139.827023] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880036f75dd8
[  139.827023] R13: ffff88003b65f400 R14: 0000000040086425 R15: ffff880036f75dd8
[  139.827023] FS:  00007ff5974af700(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[  139.827023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  139.827023] CR2: 0000000000000000 CR3: 0000000036f6c000 CR4: 00000000000006f0
[  139.827023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  139.827023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  139.827023] Process trinity-child14 (pid: 2300, threadinfo
ffff880036f74000, task ffff880036ef2290)
[  139.827023] Stack:
[  139.827023]  ffff88003b65f400 ffff88003ca08000 ffff88003b65f400
fffffffffffffff2
[  139.827023]  ffff880036f75e88 ffffffff8143d6f0 ffff880000000025
000000000000e200
[  139.827023]  ffff880000000001 ffff880036ef2960 ffff880036f75dc8
ffffffff82273a78
[  139.827023] Call Trace:
[  139.827023]  [<ffffffff8143d6f0>] drm_ioctl+0x3d0/0x4d0
[  139.827023]  [<ffffffff8143caa0>] ? drm_switchctx+0xb0/0xb0
[  139.827023]  [<ffffffff812fb640>] ? avc_has_perm_flags+0x1d0/0x2a0
[  139.827023]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
[  139.827023]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  139.827023]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[  139.827023]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[  139.827023]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[  139.827023]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[  139.827023]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  139.827023]  [<ffffffff81ca06e9>] system_call_fastpath+0x16/0x1b
[  139.827023] Code: 00 00 00 e8 9f 63 00 00 41 8b 04 24 89 83 94 03
00 00 48 8b 05 0e d5 ee 00 48 89 83 98 03 00 00 49 8b 85 00 01 00 00
48 8b 40 58 <8b> 00 85 c0 78 15 48 c7 c6 f8 79 0e 82 48 c7 c7 40 29 e7
81 31
[  139.827023] RIP  [<ffffffff8143cb04>] drm_newctx+0x64/0xb0
[  139.827023]  RSP <ffff880036f75d58>
[  139.827023] CR2: 0000000000000000
[  139.927760] ---[ end trace a9f9687d9fc4b403 ]---

Tommi
