Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3CNMl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:41:28 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60344 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3CNMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:41:26 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 14:41:25 +0200
Message-ID: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
Subject: i915 drm oopses while fuzzing
From: Tommi Rantala <tt.rantala@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw these i915 oopses while fuzzing with trinity. The kernel is
mainline v3.9-rc2-188-g6c23cbb, along with these two patches from Dave
Airlie applied:

[PATCH 1/2] drm: fix idr_remove warning during fuzzing
[PATCH 2/2] drm: don't oops in ioctls that require the lock if no lock


[    4.680583] Non-volatile memory driver v1.3
[    4.680671] Linux agpgart interface v0.103
[    4.682599] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    4.682945] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K
total, 262144K mappable
[    4.684285] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    4.685235] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    4.686333] [drm] Initialized drm 1.1.0 20060810
[    4.699841] [drm] Memory usable by graphics device = 2048M
[    4.700102] i915 0000:00:02.0: setting latency timer to 64
[    4.768588] ACPI: Battery Slot [BAT0] (battery present)
[    4.771120] ACPI: Battery Slot [BAT1] (battery absent)
[    4.791695] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    4.791851] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.791939] [drm] Driver supports precise vblank timestamp query.
[    4.792697] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    5.020103] fbcon: inteldrmfb (fb0) is primary device
[    5.786751] Console: switching to colour frame buffer device 160x50
[    5.790393] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.790436] i915 0000:00:02.0: registered panic notifier
[    5.815188] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index
(0x0000000000000005) is beyond end of object (20130117/exoparg2-418)
[    5.815572] ACPI Error: Method parse/execution failed
[\_SB_.PCI0.GFX0._DOD] (Node ffff880139f17870), AE_AML_PACKAGE_LIMIT
(20130117/psparse-537)
[    5.815800] ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD
(20130117/video-1163)
[    5.915730] acpi device:03: registered as cooling_device7
[    5.922613] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    5.923509] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    5.924172] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[...]

[  415.416288] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[  415.417015] IP: [<ffffffff81579ad7>] i915_gem_execbuffer+0x17/0x460
[  415.417015] PGD 1194c1067 PUD 1309d1067 PMD 0
[  415.417015] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  415.417015] CPU 0
[  415.417015] Pid: 5762, comm: trinity-child0 Tainted: G          I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.417015] RIP: 0010:[<ffffffff81579ad7>]  [<ffffffff81579ad7>]
i915_gem_execbuffer+0x17/0x460
[  415.417015] RSP: 0018:ffff88011cef7ce8  EFLAGS: 00010296
[  415.417015] RAX: 0000000000000000 RBX: ffff8801324cb3d8 RCX: ffffffff82a8c420
[  415.417015] RDX: ffff88012f648fd8 RSI: 0000000000000000 RDI: ffff8801324cb3d8
[  415.417015] RBP: ffff88011cef7d78 R08: 0000000000001682 R09: ffffffff81579ac0
[  415.417015] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  415.417015] R13: ffff8801324cb3d8 R14: 0000000000005454 R15: 0000000000000000
[  415.417015] FS:  00007f97b703a740(0000) GS:ffff88013a800000(0000)
knlGS:0000000000000000
[  415.417015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.417015] CR2: 0000000000000008 CR3: 0000000135d18000 CR4: 00000000000407f0
[  415.417015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.417015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.417015] Process trinity-child0 (pid: 5762, threadinfo
ffff88011cef6000, task ffff880138a623e0)
[  415.417015] Stack:
[  415.417015]  ffff880138a62ab0 ffffffff00000082 ffff88011cef7d08
ffffffff8106c545
[  415.417015]  ffff88011cef7d18 ffffffff8106c599 ffff88011cef7d48
ffffffff810e3bc5
[  415.417015]  ffff88011cef7d38 ffff88013a9d5240 00000000001d5240
0000000000000000
[  415.417015] Call Trace:
[  415.417015]  [<ffffffff8106c545>] ? native_sched_clock+0x35/0x80
[  415.417015]  [<ffffffff8106c599>] ? sched_clock+0x9/0x10
[  415.417015]  [<ffffffff810e3bc5>] ? sched_clock_local+0x25/0xa0
[  415.417015]  [<ffffffff81537e5e>] drm_ioctl+0x39e/0x4d0
[  415.417015]  [<ffffffff81101ac8>] ? lock_release_holdtime+0x28/0x190
[  415.417015]  [<ffffffff81579ac0>] ?
i915_gem_do_execbuffer.isra.14+0xfe0/0xfe0
[  415.417015]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.417015]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.417015]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.417015]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.417015]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.417015]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.417015]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.417015] Code: 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00
00 00 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 49 89 f4 53
48 83 ec 68 <8b> 7e 08 48 89 55 80 85 ff 75 2e 45 31 c0 48 c7 c1 14 9f
80 82
[  415.417015] RIP  [<ffffffff81579ad7>] i915_gem_execbuffer+0x17/0x460
[  415.417015]  RSP <ffff88011cef7ce8>
[  415.417015] CR2: 0000000000000008
[  415.438008] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  415.481838] ---[ end trace 3d41acba4e4a6890 ]---
[  415.481959] IP: [<ffffffff81572b67>] i915_gem_mmap_gtt_ioctl+0x7/0x20
[  415.481959] PGD 11ce61067 PUD 135d2d067 PMD 0
[  415.481959] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[  415.481959] CPU 1
[  415.481959] Pid: 5763, comm: trinity-child1 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.481959] RIP: 0010:[<ffffffff81572b67>]  [<ffffffff81572b67>]
i915_gem_mmap_gtt_ioctl+0x7/0x20
[  415.481959] RSP: 0018:ffff88011ce53d78  EFLAGS: 00010202
[  415.481959] RAX: 0000000000000000 RBX: ffff8801324cb3d8 RCX: ffffffff82a8c5a0
[  415.481959] RDX: ffff88012f648fd8 RSI: 0000000000000000 RDI: ffff88012f648fd8
[  415.481959] RBP: ffff88011ce53e88 R08: ffff8801324cb3d8 R09: ffffffff81572b60
[  415.481959] R10: 0000000000000000 R11: 0000000000000246 R12: ffff88012f648fd8
[  415.481959] R13: 0000000000000010 R14: 0000000000004b64 R15: 0000000000000000
[  415.481959] FS:  00007f97b703a740(0000) GS:ffff88013aa00000(0000)
knlGS:0000000000000000
[  415.481959] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.481959] CR2: 0000000000000000 CR3: 0000000135d25000 CR4: 00000000000407e0
[  415.481959] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.481959] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.481959] Process trinity-child1 (pid: 5763, threadinfo
ffff88011ce52000, task ffff880131cd47c0)
[  415.481959] Stack:
[  415.481959]  ffff88011ce53e88 ffffffff81537e5e 0000000000000064
000000000000e200
[  415.481959]  0000000000000001 0000000000000046 0000000000000002
ffffffff82a8c5a0
[  415.481959]  ffffffff81572b60 ffff88011ce53dd8 000000001ce53f28
0000000001157000
[  415.481959] Call Trace:
[  415.481959]  [<ffffffff81537e5e>] ? drm_ioctl+0x39e/0x4d0
[  415.481959]  [<ffffffff81572b60>] ? i915_gem_mmap_gtt+0x180/0x180
[  415.481959]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.481959]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.481959]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.481959]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.481959]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  415.481959]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.481959]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.481959]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.481959] Code: 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0
4c 8b 7d f8 c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 49 89
f8 48 89 d7 <8b> 16 48 8d 4e 08 4c 89 c6 48 89 e5 e8 68 fe ff ff 5d c3
66 0f
[  415.481959] RIP  [<ffffffff81572b67>] i915_gem_mmap_gtt_ioctl+0x7/0x20
[  415.481959]  RSP <ffff88011ce53d78>
[  415.481959] CR2: 0000000000000000
[  415.495010] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  415.545288] ---[ end trace 3d41acba4e4a6891 ]---
[  415.495010] IP: [<ffffffff81560548>] i915_getparam+0x38/0x270
[  415.495010] PGD 130bd7067 PUD 1194c3067 PMD 0
[  415.495010] Oops: 0000 [#3] SMP DEBUG_PAGEALLOC
[  415.495010] CPU 0
[  415.495010] Pid: 5764, comm: trinity-child2 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.495010] RIP: 0010:[<ffffffff81560548>]  [<ffffffff81560548>]
i915_getparam+0x38/0x270
[  415.495010] RSP: 0018:ffff88011f12fd48  EFLAGS: 00010286
[  415.495010] RAX: ffff880132720000 RBX: ffff8801324cb3d8 RCX: 0000000000000000
[  415.495010] RDX: ffff88012f648fd8 RSI: 0000000000000000 RDI: ffff8801324cb3d8
[  415.495010] RBP: ffff88011f12fd78 R08: 2222222222222222 R09: ffffffff81560510
[  415.495010] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88012f648fd8
[  415.495010] R13: 0000000000000010 R14: 0000000000004b46 R15: 0000000000000000
[  415.495010] FS:  00007f97b703a740(0000) GS:ffff88013a800000(0000)
knlGS:0000000000000000
[  415.495010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.495010] CR2: 0000000000000000 CR3: 00000001354f9000 CR4: 00000000000407f0
[  415.495010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.495010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.495010] Process trinity-child2 (pid: 5764, threadinfo
ffff88011f12e000, task ffff88011b818000)
[  415.495010] Stack:
[  415.495010]  0000000000000002 ffff8801324cb3d8 ffff88012f648fd8
0000000000000010
[  415.495010]  0000000000004b46 ffff8801324cb3d8 ffff88011f12fe88
ffffffff81537e90
[  415.495010]  0000000000000046 000000000000e200 0000000000000001
0000000000000046
[  415.495010] Call Trace:
[  415.495010]  [<ffffffff81537e90>] drm_ioctl+0x3d0/0x4d0
[  415.495010]  [<ffffffff81560510>] ? i915_vga_set_decode+0x30/0x30
[  415.495010]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.495010]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.495010]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.495010]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.495010]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  415.495010]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.495010]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.495010]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.495010] Code: 06 00 00 48 85 c0 75 23 48 c7 c6 50 5b 79 82 48
c7 c7 12 b4 29 82 e8 18 d8 fd ff b8 ea ff ff ff e9 30 02 00 00 66 0f
1f 44 00 00 <44> 8b 06 41 83 f8 1a 0f 87 ab 01 00 00 44 89 c2 ff 24 d5
a0 b2
[  415.495010] RIP  [<ffffffff81560548>] i915_getparam+0x38/0x270
[  415.495010]  RSP <ffff88011f12fd48>
[  415.495010] CR2: 0000000000000000
[  415.600011] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[  415.611020] ---[ end trace 3d41acba4e4a6892 ]---
[  415.612024] IP: [<ffffffff81579ad7>] i915_gem_execbuffer+0x17/0x460
[  415.612024] PGD 11cfb0067 PUD 11cfb1067 PMD 0
[  415.612024] Oops: 0000 [#4] SMP DEBUG_PAGEALLOC
[  415.612024] CPU 1
[  415.612024] Pid: 5768, comm: trinity-child6 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.612024] RIP: 0010:[<ffffffff81579ad7>]  [<ffffffff81579ad7>]
i915_gem_execbuffer+0x17/0x460
[  415.612024] RSP: 0018:ffff88011de57ce8  EFLAGS: 00010296
[  415.612024] RAX: 0000000000000000 RBX: ffff8801324cb3d8 RCX: ffffffff82a8c420
[  415.612024] RDX: ffff88012f648fd8 RSI: 0000000000000000 RDI: ffff8801324cb3d8
[  415.612024] RBP: ffff88011de57d78 R08: 0000000000001688 R09: ffffffff81579ac0
[  415.612024] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
[  415.612024] R13: ffff8801324cb3d8 R14: 0000000000005454 R15: 0000000000000000
[  415.612024] FS:  00007f97b703a740(0000) GS:ffff88013aa00000(0000)
knlGS:0000000000000000
[  415.612024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.612024] CR2: 0000000000000008 CR3: 000000011cfaf000 CR4: 00000000000407e0
[  415.612024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.612024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.612024] Process trinity-child6 (pid: 5768, threadinfo
ffff88011de56000, task ffff88011de58000)
[  415.612024] Stack:
[  415.612024]  0000000000000000 0000020000000000 ffff880120d6f4b8
00007f97b6a97ea0
[  415.612024]  ffffea0000000028 0000000000000021 00007f97b6a97000
ffffea0004fc9440
[  415.612024]  ffff88011cf97868 ffff88011dc5e200 00007f97b6a97ea0
ffff88011cf97800
[  415.612024] Call Trace:
[  415.612024]  [<ffffffff81537e5e>] drm_ioctl+0x39e/0x4d0
[  415.612024]  [<ffffffff81579ac0>] ?
i915_gem_do_execbuffer.isra.14+0xfe0/0xfe0
[  415.612024]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.612024]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.612024]  [<ffffffff810d328e>] ? up_read+0x1e/0x40
[  415.612024]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.612024]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.612024]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  415.612024]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.612024]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.612024]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.612024] Code: 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00
00 00 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 49 89 f4 53
48 83 ec 68 <8b> 7e 08 48 89 55 80 85 ff 75 2e 45 31 c0 48 c7 c1 14 9f
80 82
[  415.612024] RIP  [<ffffffff81579ad7>] i915_gem_execbuffer+0x17/0x460
[  415.612024]  RSP <ffff88011de57ce8>
[  415.612024] CR2: 0000000000000008
[  415.677046] ---[ end trace 3d41acba4e4a6893 ]---
[  415.784401] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  415.785011] IP: [<ffffffff815751a4>] i915_gem_unpin_ioctl+0x34/0xf0
[  415.785011] PGD 1205d2067 PUD 1205d3067 PMD 0
[  415.785011] Oops: 0000 [#5] SMP DEBUG_PAGEALLOC
[  415.785011] CPU 1
[  415.785011] Pid: 5774, comm: trinity-child12 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.785011] RIP: 0010:[<ffffffff815751a4>]  [<ffffffff815751a4>]
i915_gem_unpin_ioctl+0x34/0xf0
[  415.785011] RSP: 0018:ffff88011cd6fd48  EFLAGS: 00010246
[  415.785011] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  415.785011] RDX: ffff8801324cb490 RSI: 2222222222222222 RDI: 2222222222222222
[  415.785011] RBP: ffff88011cd6fd78 R08: 2222222222222222 R09: 2222222222222222
[  415.785011] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801324cb3d8
[  415.785011] R13: 0000000000000008 R14: ffff88012f648fd8 R15: 0000000000000000
[  415.785011] FS:  00007f97b703a740(0000) GS:ffff88013aa00000(0000)
knlGS:0000000000000000
[  415.785011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  415.785011] CR2: 0000000000000000 CR3: 00000001205d1000 CR4: 00000000000407e0
[  415.785011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.785011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.785011] Process trinity-child12 (pid: 5774, threadinfo
ffff88011cd6e000, task ffff88011cd70000)
[  415.785011] Stack:
[  415.785011]  0000000000000002 ffff8801324cb3d8 ffff88012f648fd8
0000000000000008
[  415.785011]  0000000000005456 0000000000000000 ffff88011cd6fe88
ffffffff81537e5e
[  415.785011]  0000000000000056 000000000000e200 0000000000000001
0000000000000046
[  415.785011] Call Trace:
[  415.785011]  [<ffffffff81537e5e>] drm_ioctl+0x39e/0x4d0
[  415.785011]  [<ffffffff81575170>] ? i915_gem_pin_ioctl+0x150/0x150
[  415.785011]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.785011]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.785011]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.785011]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.785011]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  415.785011]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.785011]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.785011]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.785011] Code: 89 5d d8 4c 89 65 e0 49 89 fc 4c 89 75 f0 4c 89
7d f8 49 89 d6 4c 89 6d e8 49 89 f7 e8 b6 a9 ff ff 85 c0 89 c3 0f 85
96 00 00 00 <41> 8b 17 4c 89 f6 4c 89 e7 e8 8e 45 fc ff 48 85 c0 49 89
c5 74
[  415.785011] RIP  [<ffffffff815751a4>] i915_gem_unpin_ioctl+0x34/0xf0
[  415.785011]  RSP <ffff88011cd6fd48>
[  415.785011] CR2: 0000000000000000
[  415.846239] ---[ end trace 3d41acba4e4a6894 ]---
[  415.975107] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  415.976009] IP: [<ffffffff815b56f7>] intel_sprite_set_colorkey+0x27/0xb0
[  415.976009] PGD 11dd3e067 PUD 11dd3f067 PMD 0
[  415.976009] Oops: 0000 [#6] SMP DEBUG_PAGEALLOC
[  415.976009] CPU 0
[  415.976009] Pid: 5782, comm: trinity-child0 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  415.976009] RIP: 0010:[<ffffffff815b56f7>]  [<ffffffff815b56f7>]
intel_sprite_set_colorkey+0x27/0xb0
[  415.976009] RSP: 0018:ffff880120579d58  EFLAGS: 00010202
[  415.976009] RAX: ffffffff82a8bf00 RBX: ffff8801324cb3d8 RCX: ffffffff82a8c648
[  415.976009] RDX: ffff88012f648fd8 RSI: 0000000000000000 RDI: ffff8801324cb3d8
[  415.976009] RBP: ffff880120579d78 R08: 0000000000001696 R09: ffffffff815b56d0
[  415.976009] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88012f648fd8
[  415.976009] R13: 0000000000000014 R14: 0000000000004b6b R15: 0000000000000000
[  415.976009] FS:  00007f97b703a740(0000) GS:ffff88013a800000(0000)
knlGS:0000000000000000
[  415.976009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  415.976009] CR2: 0000000000000010 CR3: 000000011dd3d000 CR4: 00000000000407f0
[  415.976009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  415.976009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  415.976009] Process trinity-child0 (pid: 5782, threadinfo
ffff880120578000, task ffff88011dd1a3e0)
[  415.976009] Stack:
[  415.976009]  0000000000000000 ffff8801324cb3d8 ffff88012f648fd8
0000000000000014
[  415.976009]  ffff880120579e88 ffffffff81537e5e 000000000000006b
000000000000e200
[  415.976009]  0000000000000001 0000000000000046 0000000000000002
ffffffff82a8c648
[  415.976009] Call Trace:
[  415.976009]  [<ffffffff81537e5e>] drm_ioctl+0x39e/0x4d0
[  415.976009]  [<ffffffff815b56d0>] ? ilk_update_plane+0x2d0/0x2d0
[  415.976009]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  415.976009]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  415.976009]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  415.976009]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  415.976009]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  415.976009]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  415.976009]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  415.976009]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  415.976009] Code: 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8
4c 89 65 f0 48 89 fb 4c 89 6d f8 48 8b 87 e8 06 00 00 f6 80 a1 01 00
00 20 74 49 <8b> 46 10 49 89 f4 83 e0 06 83 f8 06 74 4b e8 46 e5 f8 ff
41 8b
[  415.976009] RIP  [<ffffffff815b56f7>] intel_sprite_set_colorkey+0x27/0xb0
[  415.976009]  RSP <ffff880120579d58>
[  415.976009] CR2: 0000000000000010
[  416.005009] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  416.038639] ---[ end trace 3d41acba4e4a6895 ]---
[  416.005009] IP: [<ffffffff8157c692>] i915_gem_get_tiling+0x12/0x130
[  416.005009] PGD 12049c067 PUD 12049d067 PMD 0
[  416.005009] Oops: 0000 [#7] SMP DEBUG_PAGEALLOC
[  416.005009] CPU 1
[  416.005009] Pid: 5785, comm: trinity-child6 Tainted: G      D   I
3.9.0-rc2+ #130 Hewlett-Packard HP Compaq 6530b (VW620EC#AK8)/30DD
[  416.005009] RIP: 0010:[<ffffffff8157c692>]  [<ffffffff8157c692>]
i915_gem_get_tiling+0x12/0x130
[  416.005009] RSP: 0018:ffff880120ec7d58  EFLAGS: 00010282
[  416.005009] RAX: 0000000000000000 RBX: ffff8801324cb3d8 RCX: ffffffff82a8c570
[  416.005009] RDX: ffff88012f648fd8 RSI: ffff88012f648fd8 RDI: ffff8801324cb3d8
[  416.005009] RBP: ffff880120ec7d78 R08: 0000000000001699 R09: ffffffff8157c680
[  416.005009] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  416.005009] R13: 000000000000000c R14: 0000000000004b62 R15: 0000000000000000
[  416.005009] FS:  00007f97b703a740(0000) GS:ffff88013aa00000(0000)
knlGS:0000000000000000
[  416.005009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  416.005009] CR2: 0000000000000000 CR3: 000000012049b000 CR4: 00000000000407e0
[  416.005009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  416.005009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  416.005009] Process trinity-child6 (pid: 5785, threadinfo
ffff880120ec6000, task ffff88011b818000)
[  416.005009] Stack:
[  416.005009]  0000000000000000 ffff88012f648fd8 0000000000001699
0000000000004b62
[  416.005009]  ffff880120ec7e88 ffffffff81537e5e 0000000000000062
000000000000e200
[  416.005009]  0000000000000001 0000000000000046 0000000000000002
ffffffff82a8c570
[  416.005009] Call Trace:
[  416.005009]  [<ffffffff81537e5e>] drm_ioctl+0x39e/0x4d0
[  416.005009]  [<ffffffff8157c680>] ? i915_gem_set_tiling+0x4c0/0x4c0
[  416.005009]  [<ffffffff813e4c90>] ? avc_has_perm_flags+0x2a0/0x380
[  416.005009]  [<ffffffff813e4a18>] ? avc_has_perm_flags+0x28/0x380
[  416.005009]  [<ffffffff811cf0c2>] do_vfs_ioctl+0x522/0x570
[  416.005009]  [<ffffffff813e5e13>] ? file_has_perm+0x83/0xa0
[  416.005009]  [<ffffffff8110391d>] ? trace_hardirqs_on+0xd/0x10
[  416.005009]  [<ffffffff811cf16d>] sys_ioctl+0x5d/0xa0
[  416.005009]  [<ffffffff81444cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  416.005009]  [<ffffffff820bed29>] system_call_fastpath+0x16/0x1b
[  416.005009] Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 66
2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 65 e8 49 89
f4 48 89 d6 <41> 8b 14 24 48 89 5d e0 4c 89 6d f0 4c 89 75 f8 49 89 fd
4c 8b
[  416.005009] RIP  [<ffffffff8157c692>] i915_gem_get_tiling+0x12/0x130
[  416.005009]  RSP <ffff880120ec7d58>
[  416.005009] CR2: 0000000000000000
[  416.103012] ---[ end trace 3d41acba4e4a6896 ]---

Tommi
