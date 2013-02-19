Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab3BSRnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:43:09 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:46771 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3BSRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:43:07 -0500
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 19:43:06 +0200
Message-ID: <CA+ydwtpMBFxuzGZqzE4On7FhEKMMPFzHhWiD1AP6+QWMSnrZbQ@mail.gmail.com>
Subject: NULL pointer deref at drm_lock_free()
From: Tommi Rantala <tt.rantala@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit this oops a few times while fuzzing the kernel with Trinity in a
qemu virtual machine:

[  133.012360] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  133.013015] IP: [<ffffffff814424d0>] drm_lock_free+0x90/0x110
[  133.013015] PGD 2fed8067 PUD 2fed9067 PMD 0
[  133.013015] Oops: 0000 [#1] SMP
[  133.013015] CPU 0
[  133.013015] Pid: 2718, comm: trinity-child20 Not tainted 3.8.0+ #87
Bochs Bochs
[  133.013015] RIP: 0010:[<ffffffff814424d0>]  [<ffffffff814424d0>]
drm_lock_free+0x90/0x110
[  133.013015] RSP: 0018:ffff88001400fd28  EFLAGS: 00010292
[  133.013015] RAX: ffff8800140c2290 RBX: 0000000000000000 RCX: 0000000000000006
[  133.013015] RDX: 0000000000001580 RSI: ffff8800140c2960 RDI: ffff8800140c2290
[  133.013015] RBP: ffff88001400fd68 R08: 0000000000000000 R09: 0000000000000000
[  133.013015] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000055f4ff
[  133.013015] R13: ffff88003b335c58 R14: ffff88003b335cc8 R15: ffff88001400fdd8
[  133.013015] FS:  00007fb6cb6b6700(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[  133.013015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.013015] CR2: 0000000000000000 CR3: 000000001402f000 CR4: 00000000000006f0
[  133.013015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.013015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  133.013015] Process trinity-child20 (pid: 2718, threadinfo
ffff88001400e000, task ffff8800140c2290)
[  133.013015] Stack:
[  133.013015]  2222222222222222 2222222222222222 2222222222222222
2222222222222222
[  133.013015]  ffff88003ca08000 ffff88003a9a4800 fffffffffffffff2
000000004008642b
[  133.013015]  ffff88001400fd78 ffffffff814425a2 ffff88001400fe88
ffffffff8143d710
[  133.013015] Call Trace:
[  133.013015]  [<ffffffff814425a2>] drm_unlock+0x52/0x60
[  133.013015]  [<ffffffff8143d710>] drm_ioctl+0x3d0/0x4d0
[  133.013015]  [<ffffffff81442550>] ? drm_lock_free+0x110/0x110
[  133.013015]  [<ffffffff812fb640>] ? avc_has_perm_flags+0x1d0/0x2a0
[  133.013015]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
[  133.013015]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  133.013015]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[  133.013015]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[  133.013015]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[  133.013015]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[  133.013015]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  133.013015]  [<ffffffff81ca07e9>] system_call_fastpath+0x16/0x1b
[  133.013015] Code: 00 00 01 00 00 00 4c 89 f7 e8 2d ce 85 00 b8 01
00 00 00 e9 82 00 00 00 0f 1f 00 4c 89 f7 e8 18 ce 85 00 0f 1f 84 00
00 00 00 00 <44> 8b 03 44 89 c1 44 89 45 cc 81 e1 ff ff ff 3f 89 4d d0
44 8b
[  133.013015] RIP  [<ffffffff814424d0>] drm_lock_free+0x90/0x110
[  133.013015]  RSP <ffff88001400fd28>
[  133.013015] CR2: 0000000000000000
[  133.062048] ---[ end trace 3d5401684feb563f ]---

Tommi
