Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab3CMNab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:30:31 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:65168 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3CMNa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:30:29 -0400
MIME-Version: 1.0
Date: Wed, 13 Mar 2013 15:30:28 +0200
Message-ID: <CA+ydwtoSaNTxpj2KbAap+8udocfTUEDbnVXSU6VHULZ4T6mdfA@mail.gmail.com>
Subject: fanotify soft lockup / GPF
From: Tommi Rantala <tt.rantala@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit into some fanotify troubles while fuzzing v3.9-rc2-188-g6c23cbb
with trinity in a qemu virtual machine. I'm seeing a soft lockup in
some cases and sometimes a GPF, see below.

I modified trinity to open some fanotify handles before starting
fuzzing, so that might explain why this has not come up before.

Added 16136 filenames from /sys
[3570] Random reseed: 590679980
trinity: malloc.c:2369: sysmalloc: Assertion `(old_top == (((mbinptr)
(((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct
malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size)
>= (unsigned long)((((__builtin_offsetof (struct malloc_chunk,
fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t)))
- 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end &
pagemask) == 0)' failed.
[watchdog] 1854 iterations. [F:1838 S:15]
trinity: malloc.c:2369: sysmalloc: Assertion `(old_top == (((mbinptr)
(((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct
malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size)
>= (unsigned long)((((__builtin_offsetof (struct malloc_chunk,
fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t)))
- 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end &
pagemask) == 0)' failed.[   96.235028] BUG: soft lockup - CPU#0 stuck
for 22s! [trinity-child3:3578]
[   96.235028] irq event stamp: 212832
[   96.235028] hardirqs last  enabled at (212831):
[<ffffffff81ff9233>] restore_args+0x0/0x30
[   96.235028] hardirqs last disabled at (212832):
[<ffffffff81ffa7ed>] apic_timer_interrupt+0x6d/0x80
[   96.235028] softirqs last  enabled at (212830):
[<ffffffff810abb10>] __do_softirq+0x340/0x410
[   96.235028] softirqs last disabled at (212825):
[<ffffffff810abd29>] irq_exit+0x59/0xb0
[   96.235028] CPU 0
[   96.235028] Pid: 3578, comm: trinity-child3 Not tainted 3.9.0-rc2+
#127 Bochs Bochs
[   96.235028] RIP: 0010:[<ffffffff81107c46>]  [<ffffffff81107c46>]
lock_release+0x266/0x310
[   96.235028] RSP: 0018:ffff880070823e08  EFLAGS: 00000246
[   96.235028] RAX: ffff8800791a47c0 RBX: 0000000000000000 RCX: 0000000000005f60
[   96.235028] RDX: ffff88007f838180 RSI: 0000000000000001 RDI: 0000000000000246
[   96.235028] RBP: ffff880070823e38 R08: 0000000000000066 R09: 0000000000000001
[   96.235028] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007f9d5240
[   96.235028] R13: ffffffff8314faa0 R14: ffffffff810e2f95 R15: ffff880070823d88
[   96.235028] FS:  00007ff5f21f9700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   96.235028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   96.235028] CR2: 0000000002505f68 CR3: 000000007080c000 CR4: 00000000000006f0
[   96.235028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   96.235028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   96.235028] Process trinity-child3 (pid: 3578, threadinfo
ffff880070822000, task ffff8800791a47c0)
[   96.235028] Stack:
[   96.235028]  ffff880071788428 ffff880071788410 ffff880079032a40
ffff880071788410
[   96.235028]  0000000000000001 ffff880079032c20 ffff880070823e58
ffffffff81ff83de
[   96.235028]  ffff8800717883f0 ffff8800717883f0 ffff880070823e88
ffffffff81202431
[   96.235028] Call Trace:
[   96.235028]  [<ffffffff81ff83de>] _raw_spin_unlock+0x1e/0x40
[   96.235028]  [<ffffffff81202431>] fsnotify_destroy_mark_locked+0x51/0x1b0
[   96.235028]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   96.235028]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   96.235028]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   96.235028]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   96.235028]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   96.235028] Code: 00 00 00 00 00 4c 89 ea 4c 89 e6 48 89 df e8 f2
e7 ff ff 65 48 8b 04 25 00 c8 00 00 4c 89 f7 c7 80 d4 06 00 00 00 00
00 00 57 9d <0f> 1f 44 00 00 e9 88 00 00 00 65 48 8b 04 25 f0 c7 00 00
83 80
[  124.235023] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child3:3578]
[  124.235023] irq event stamp: 441952
[  124.235023] hardirqs last  enabled at (441951):
[<ffffffff81ff9233>] restore_args+0x0/0x30
[  124.235023] hardirqs last disabled at (441952):
[<ffffffff81ffa7ed>] apic_timer_interrupt+0x6d/0x80
[  124.235023] softirqs last  enabled at (441950):
[<ffffffff810abb10>] __do_softirq+0x340/0x410
[  124.235023] softirqs last disabled at (441945):
[<ffffffff810abd29>] irq_exit+0x59/0xb0
[  124.235023] CPU 0
[  124.235023] Pid: 3578, comm: trinity-child3 Not tainted 3.9.0-rc2+
#127 Bochs Bochs
[  124.235023] RIP: 0010:[<ffffffff81107e93>]  [<ffffffff81107e93>]
lock_acquire+0x1a3/0x220
[  124.235023] RSP: 0018:ffff880070823db8  EFLAGS: 00000246
[  124.235023] RAX: ffff8800791a47c0 RBX: ffffffff8108fbb8 RCX: 6000000000000000
[  124.235023] RDX: ffffffff8314faa0 RSI: 17d8000000000000 RDI: 0000000000000246
[  124.235023] RBP: ffff880070823e28 R08: ffff8800791a4ec8 R09: 0000000000000000
[  124.235023] R10: ffffffff839971b0 R11: fffffe6a747962fb R12: ffff880071788428
[  124.235023] R13: ffffffff83287610 R14: ffffffff81103305 R15: ffff880070823d28
[  124.235023] FS:  00007ff5f21f9700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[  124.235023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  124.235023] CR2: 0000000002505f68 CR3: 000000007080c000 CR4: 00000000000006f0
[  124.235023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  124.235023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  124.235023] Process trinity-child3 (pid: 3578, threadinfo
ffff880070822000, task ffff8800791a47c0)
[  124.235023] Stack:
[  124.235023]  0000000000000000 ffffffff8120241f ffff880000000000
ffff8800791a4ed0
[  124.235023]  ffff880070823df8 0000000000000246 00000000791a47c0
ffff880071788428
[  124.235023]  ffff880070823e38 ffff880071788410 ffff880071788428
ffff880071788410
[  124.235023] Call Trace:
[  124.235023]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[  124.235023]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[  124.235023]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[  124.235023]  [<ffffffff81ff83e6>] ? _raw_spin_unlock+0x26/0x40
[  124.235023]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[  124.235023]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[  124.235023]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[  124.235023]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[  124.235023]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  124.235023]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[  124.235023] Code: 09 48 8b 7d c8 49 83 f1 01 41 83 e1 01 e8 46 ca
ff ff 65 48 8b 04 25 00 c8 00 00 48 8b 7d b8 c7 80 d4 06 00 00 00 00
00 00 57 9d <0f> 1f 44 00 00 eb 56 65 48 8b 04 25 f0 c7 00 00 83 80 44
e0 ff
[  152.235027] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child3:3578]
[  152.235027] irq event stamp: 670930
[  152.235027] hardirqs last  enabled at (670929):
[<ffffffff81ff9233>] restore_args+0x0/0x30
[  152.235027] hardirqs last disabled at (670930):
[<ffffffff81ffa7ed>] apic_timer_interrupt+0x6d/0x80
[  152.235027] softirqs last  enabled at (670928):
[<ffffffff810abb10>] __do_softirq+0x340/0x410
[  152.235027] softirqs last disabled at (670923):
[<ffffffff810abd29>] irq_exit+0x59/0xb0
[  152.235027] CPU 0
[  152.235027] Pid: 3578, comm: trinity-child3 Not tainted 3.9.0-rc2+
#127 Bochs Bochs
[  152.235027] RIP: 0010:[<ffffffff81ff81d1>]  [<ffffffff81ff81d1>]
_raw_spin_lock+0x41/0x80
[  152.235027] RSP: 0018:ffff880070823e38  EFLAGS: 00000246
[  152.235027] RAX: ffff8800791a47c0 RBX: 0000000000000246 RCX: 6000000000000000
[  152.235027] RDX: ffffffff8314faa0 RSI: 17d8000000000000 RDI: 0000000000000246
[  152.235027] RBP: ffff880070823e58 R08: ffff8800791a4ec8 R09: 0000000000000000
[  152.235027] R10: ffffffff839971b0 R11: fffffe6a747962fb R12: 0000000000000000
[  152.235027] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
[  152.235027] FS:  00007ff5f21f9700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[  152.235027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  152.235027] CR2: 0000000002505f68 CR3: 000000007080c000 CR4: 00000000000006f0
[  152.235027] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.235027] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  152.235027] Process trinity-child3 (pid: 3578, threadinfo
ffff880070822000, task ffff8800791a47c0)
[  152.235027] Stack:
[  152.235027]  ffffffff8120241f ffffffff81ff83e6 ffff8800717883f0
ffff880079032a40
[  152.235027]  ffff880070823e88 ffffffff8120241f ffff8800717883f0
ffff8800717883f0
[  152.235027]  ffff880079032a40 0000000000000001 ffff880070823ed8
ffffffff8120293b
[  152.235027] Call Trace:
[  152.235027]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[  152.235027]  [<ffffffff81ff83e6>] ? _raw_spin_unlock+0x26/0x40
[  152.235027]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[  152.235027]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[  152.235027]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[  152.235027]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[  152.235027]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  152.235027]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[  152.235027] Code: 10 83 80 44 e0 ff ff 01 48 8b 45 08 4c 8d 67 18
45 31 c9 31 c9 31 d2 31 f6 41 b8 02 00 00 00 4c 89 e7 48 89 04 24 e8
1f fb 10 ff <48> 89 df e8 c7 64 39 ff 85 c0 75 14 48 8b 75 08 4c 89 e7
e8 17
[  180.235035] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child3:3578]



[   74.682156] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[   74.683040] CPU 0
[   74.683040] Pid: 3551, comm: trinity-child4 Not tainted 3.9.0-rc2+
#127 Bochs Bochs
[   74.683040] RIP: 0010:[<ffffffff81104ed0>]  [<ffffffff81104ed0>]
__lock_acquire+0x610/0x1b60
[   74.683040] RSP: 0000:ffff8800704abcb8  EFLAGS: 00010002
[   74.683040] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000002 RCX: 0000000000000000
[   74.683040] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880070445c08
[   74.683040] RBP: ffff8800704abda8 R08: 0000000000000002 R09: 0000000000000000
[   74.683040] R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
[   74.683040] R13: ffff88007ad38000 R14: ffff880070445c08 R15: 0000000000000000
[   74.683040] FS:  00007f38182d9700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   74.683040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.683040] CR2: 00007f38181bd068 CR3: 0000000070492000 CR4: 00000000000006f0
[   74.683040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   74.683040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   74.683040] Process trinity-child4 (pid: 3551, threadinfo
ffff8800704aa000, task ffff88007ad38000)
[   74.683040] Stack:
[   74.683040]  ffff88007ad386d8 0000000000000007 0000000000000006
ffff88007ad38000
[   74.683040]  ffff8800704abd28 ffffffff81103193 ffff88007ad38000
ffffffff812050c3
[   74.683040]  ffff88007bfb2900 ffffffff81fe3acd ffff88007ad38000
ffff880070445dc8
[   74.683040] Call Trace:
[   74.683040]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   74.683040]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   74.683040]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   74.683040]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   74.683040]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   74.683040]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   74.683040]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   74.683040]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   74.683040]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   74.683040]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   74.683040]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   74.683040]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   74.683040] Code: 00 0f 85 44 05 00 00 be 34 03 00 00 48 c7 c7 70
f6 72 82 e8 b3 d5 f9 ff e9 2e 05 00 00 4d 85 e4 0f 84 25 05 00 00 0f
1f 44 00 00 <3e> 41 ff 84 24 98 01 00 00 44 8b 3d 90 f7 df 01 45 8b 85
d0 06
[   74.683040] RIP  [<ffffffff81104ed0>] __lock_acquire+0x610/0x1b60
[   74.683040]  RSP <ffff8800704abcb8>
[   74.683040] ---[ end trace 12b20a714d5e7d42 ]---
[   74.683040] BUG: sleeping function called from invalid context at
/home/ttrantal/git/linux-2.6/kernel/rwsem.c:20
[   74.683040] in_atomic(): 1, irqs_disabled(): 1, pid: 3551, name:
trinity-child4
[   74.683040] INFO: lockdep is turned off.
[   74.683040] irq event stamp: 15213
[   74.683040] hardirqs last  enabled at (15213): [<ffffffff81fe3acd>]
__slab_free+0x1cf/0x438
[   74.683040] hardirqs last disabled at (15212): [<ffffffff81fe3a31>]
__slab_free+0x133/0x438
[   74.683040] softirqs last  enabled at (15002): [<ffffffff810abb10>]
__do_softirq+0x340/0x410
[   74.683040] softirqs last disabled at (14997): [<ffffffff810abd29>]
irq_exit+0x59/0xb0
[   74.683040] Pid: 3551, comm: trinity-child4 Tainted: G      D
3.9.0-rc2+ #127
[   74.683040] Call Trace:
[   74.683040]  [<ffffffff81102dc0>] ? print_irqtrace_events+0xd0/0xe0
[   74.683040]  [<ffffffff810e229c>] __might_sleep+0x1fc/0x210
[   74.683040]  [<ffffffff81ff57e5>] down_read+0x25/0xa0
[   74.683040]  [<ffffffff810bc94f>] exit_signals+0x1f/0x140
[   74.683040]  [<ffffffff810d4141>] ? blocking_notifier_call_chain+0x11/0x20
[   74.683040]  [<ffffffff810a86f8>] do_exit+0x108/0xbb0
[   74.683040]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   74.683040]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   74.683040]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   74.683040]  [<ffffffff810670f2>] die+0x62/0x80
[   74.683040]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   74.683040]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   74.683040]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   74.683040]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   74.683040]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   74.683040]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   74.683040]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   74.683040]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   74.683040]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   74.683040]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   74.683040]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   74.683040]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   74.683040]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   74.683040]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   74.683040]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   74.683040]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   74.683040]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   74.683040] note: trinity-child4[3551] exited with preempt_count 1
[   75.057237] BUG: scheduling while atomic: trinity-child4/3551/0x10000002
[   75.062194] INFO: lockdep is turned off.
[   75.065194] Pid: 3551, comm: trinity-child4 Tainted: G      D
3.9.0-rc2+ #127
[   75.070869] Call Trace:
[   75.072931]  [<ffffffff81fe1201>] __schedule_bug+0x5d/0x6d
[   75.076910]  [<ffffffff81ff5cf0>] __schedule+0x90/0x9a0
[   75.080786]  [<ffffffff810dcd85>] __cond_resched+0x25/0x40
[   75.084798]  [<ffffffff81ff673c>] _cond_resched+0x2c/0x40
[   75.088711]  [<ffffffff81ff57ea>] down_read+0x2a/0xa0
[   75.092418]  [<ffffffff810a8836>] do_exit+0x246/0xbb0
[   75.096171]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   75.100072]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   75.104008]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   75.107676]  [<ffffffff810670f2>] die+0x62/0x80
[   75.110944]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   75.115647]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   75.119914]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   75.124301]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   75.128677]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   75.133134]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   75.137640]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   75.141775]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   75.146667]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   75.150976]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   75.154920]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.159877]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   75.163795]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.168956]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.174764]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   75.179843]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   75.185697]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   75.189345]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   75.193559]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   75.201079] BUG: scheduling while atomic: trinity-child4/3551/0x10000002
[   75.206080] INFO: lockdep is turned off.
[   75.209050] Pid: 3551, comm: trinity-child4 Tainted: G      D W
3.9.0-rc2+ #127
[   75.214251] Call Trace:
[   75.216055]  [<ffffffff81fe1201>] __schedule_bug+0x5d/0x6d
[   75.219895]  [<ffffffff81ff5cf0>] __schedule+0x90/0x9a0
[   75.223816]  [<ffffffff810dcd85>] __cond_resched+0x25/0x40
[   75.227813]  [<ffffffff81ff673c>] _cond_resched+0x2c/0x40
[   75.231700]  [<ffffffff8118e8af>] unmap_page_range+0x5bf/0x750
[   75.235896]  [<ffffffff811b9617>] ? __khugepaged_exit+0x107/0x170
[   75.240282]  [<ffffffff8118eb1e>] unmap_single_vma+0xde/0xf0
[   75.244366]  [<ffffffff8118f095>] unmap_vmas+0x65/0x90
[   75.248164]  [<ffffffff811977f1>] exit_mmap+0xc1/0x170
[   75.251969]  [<ffffffff811af726>] ? kmem_cache_free+0x176/0x2c0
[   75.256278]  [<ffffffff8109f4f9>] mmput+0x59/0xe0
[   75.259839]  [<ffffffff810a896b>] do_exit+0x37b/0xbb0
[   75.263452]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   75.267279]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   75.271087]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   75.274850]  [<ffffffff810670f2>] die+0x62/0x80
[   75.278174]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   75.282612]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   75.286616]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   75.290865]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   75.295138]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   75.299451]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   75.303819]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   75.307855]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   75.312788]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   75.316926]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   75.320779]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.325684]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   75.329878]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.334899]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   75.339836]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   75.345073]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   75.350388]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   75.354796]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   75.359805]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[watchdog] 5103 iterations. [F:4925 S:177]
[watchdog] kernel became tainted! Last seed was 857689400
trinity: malloc.c:2369: sysmalloc: Assertion `(old_top == (((mbinptr)
(((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct
malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size)
>= (unsigned long)((((__builtin_offsetof (struct malloc_chunk,
fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t)))
- 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end &
pagemask) == 0)' failed.
[   75.579624] =============================================================================
[   75.580058] BUG fsnotify_mark (Tainted: G      D W   ): Poison overwritten
[   75.580058] -----------------------------------------------------------------------------
[   75.580058]
[   75.580058] INFO: 0xffff880070445bd4-0xffff880070445bd4. First byte
0x6c instead of 0x6b
[   75.580058] INFO: Allocated in sys_fanotify_mark+0x367/0x590
age=1131 cpu=0 pid=3547
[   75.580058]  __slab_alloc+0x4b1/0x54f
[   75.580058]  kmem_cache_alloc+0x80/0x280
[   75.580058]  sys_fanotify_mark+0x367/0x590
[   75.580058]  system_call_fastpath+0x16/0x1b
[   75.580058] INFO: Freed in fanotify_free_mark+0x13/0x20 age=898
cpu=0 pid=3550
[   75.580058]  __slab_free+0x30/0x438
[   75.580058]  kmem_cache_free+0x176/0x2c0
[   75.580058]  fanotify_free_mark+0x13/0x20
[   75.580058]  fsnotify_put_mark+0x2e/0x40
[   75.580058]  fsnotify_clear_marks_by_group_flags+0x93/0xb0
[   75.580058]  fsnotify_clear_inode_marks_by_group+0xe/0x10
[   75.580058]  sys_fanotify_mark+0x51d/0x590
[   75.580058]  system_call_fastpath+0x16/0x1b
[   75.580058] INFO: Slab 0xffffea0001c11140 objects=8 used=8 fp=0x
      (null) flags=0x100000000000080
[   75.580058] INFO: Object 0xffff880070445bd0 @offset=3024
fp=0xffff8800704453f0
[   75.580058]
[   75.580058] Bytes b4 ffff880070445bc0: ac 8f fc ff 00 00 00 00 5a
5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
[   75.580058] Object ffff880070445bd0: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
[   75.580058] Object ffff880070445be0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445bf0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   75.580058] Object ffff880070445c70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[   75.580058] Redzone ffff880070445c80: bb bb bb bb bb bb bb bb
                   ........
[   75.580058] Padding ffff880070445dc0: 5a 5a 5a 5a 5a 5a 5a 5a
                   ZZZZZZZZ
[   75.580058] Pid: 3554, comm: trinity-child7 Tainted: G    B D W
3.9.0-rc2+ #127
[   75.580058] Call Trace:
[   75.580058]  [<ffffffff811abaa8>] ? print_section+0x38/0x40
[   75.580058]  [<ffffffff811abbe1>] print_trailer+0x131/0x140
[   75.580058]  [<ffffffff811ac034>] check_bytes_and_report+0xc4/0x120
[   75.580058]  [<ffffffff811ac90e>] check_object+0x11e/0x240
[   75.580058]  [<ffffffff81206047>] ? sys_fanotify_mark+0x367/0x590
[   75.580058]  [<ffffffff81fe3658>] alloc_debug_processing+0x62/0x104
[   75.580058]  [<ffffffff81fe43f3>] __slab_alloc+0x4b1/0x54f
[   75.580058]  [<ffffffff81206047>] ? sys_fanotify_mark+0x367/0x590
[   75.580058]  [<ffffffff81201e42>] ? fsnotify_find_inode_mark+0x22/0x90
[   75.580058]  [<ffffffff811ae9a0>] kmem_cache_alloc+0x80/0x280
[   75.580058]  [<ffffffff81206047>] ? sys_fanotify_mark+0x367/0x590
[   75.580058]  [<ffffffff81206047>] sys_fanotify_mark+0x367/0x590
[   75.580058]  [<ffffffff811031c6>] ? trace_hardirqs_on_caller+0x16/0x1f0
[   75.580058]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   75.580058] FIX fsnotify_mark: Restoring
0xffff880070445bd4-0xffff880070445bd4=0x6b
[   75.580058]
[   75.580058] FIX fsnotify_mark: Marking all objects used
[   75.942158] BUG: sleeping function called from invalid context at
/home/ttrantal/git/linux-2.6/mm/memory.c:1266
[   75.949795] in_atomic(): 1, irqs_disabled(): 0, pid: 3551, name:
trinity-child4
[   75.955182] INFO: lockdep is turned off.
[   75.958218] Pid: 3551, comm: trinity-child4 Tainted: G    B D W
3.9.0-rc2+ #127
[   75.963954] Call Trace:
[   75.965981]  [<ffffffff810e229c>] __might_sleep+0x1fc/0x210
[   75.970173]  [<ffffffff8118e8a6>] unmap_page_range+0x5b6/0x750
[   75.974495]  [<ffffffff811b9617>] ? __khugepaged_exit+0x107/0x170
[   75.979108]  [<ffffffff8118eb1e>] unmap_single_vma+0xde/0xf0
[   75.983275]  [<ffffffff8118f095>] unmap_vmas+0x65/0x90
[   75.987044]  [<ffffffff811977f1>] exit_mmap+0xc1/0x170
[   75.990640]  [<ffffffff811af726>] ? kmem_cache_free+0x176/0x2c0
[   75.995053]  [<ffffffff8109f4f9>] mmput+0x59/0xe0
[   75.998510]  [<ffffffff810a896b>] do_exit+0x37b/0xbb0
[   76.002372]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   76.006390]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   76.010262]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   76.013980]  [<ffffffff810670f2>] die+0x62/0x80
[   76.017347]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   76.021890]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   76.026059]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   76.030429]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   76.034769]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   76.039076]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   76.043380]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   76.047442]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   76.052496]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   76.056730]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   76.060745]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.065819]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   76.069867]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.075008]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.080061]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   76.085492]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   76.090891]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   76.095197]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   76.100048]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   76.104572] BUG: scheduling while atomic: trinity-child4/3551/0x10000002
[   76.109546] INFO: lockdep is turned off.
[   76.112457] Pid: 3551, comm: trinity-child4 Tainted: G    B D W
3.9.0-rc2+ #127
[   76.117911] Call Trace:
[   76.119779]  [<ffffffff81fe1201>] __schedule_bug+0x5d/0x6d
[   76.123794]  [<ffffffff81ff5cf0>] __schedule+0x90/0x9a0
[   76.127639]  [<ffffffff810dcd85>] __cond_resched+0x25/0x40
[   76.131637]  [<ffffffff81ff673c>] _cond_resched+0x2c/0x40
[   76.135698]  [<ffffffff8118e8af>] unmap_page_range+0x5bf/0x750
[   76.140112]  [<ffffffff811b9617>] ? __khugepaged_exit+0x107/0x170
[   76.144627]  [<ffffffff8118eb1e>] unmap_single_vma+0xde/0xf0
[   76.148855]  [<ffffffff8118f095>] unmap_vmas+0x65/0x90
[   76.152560]  [<ffffffff811977f1>] exit_mmap+0xc1/0x170
[   76.156308]  [<ffffffff811af726>] ? kmem_cache_free+0x176/0x2c0
[   76.160833]  [<ffffffff8109f4f9>] mmput+0x59/0xe0
[   76.164402]  [<ffffffff810a896b>] do_exit+0x37b/0xbb0
[   76.168136]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   76.172094]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   76.176042]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   76.179696]  [<ffffffff810670f2>] die+0x62/0x80
[   76.183133]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   76.187805]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   76.191889]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   76.196139]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   76.200358]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   76.204521]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   76.208868]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x438
[   76.213060]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   76.217962]  [<ffffffff811033ad>] ? trace_hardirqs_on+0xd/0x10
[   76.222235]  [<ffffffff81107e7a>] lock_acquire+0x18a/0x220
[   76.226264]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.231392]  [<ffffffff81ff81d1>] _raw_spin_lock+0x41/0x80
[   76.235467]  [<ffffffff8120241f>] ? fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.240591]  [<ffffffff8120241f>] fsnotify_destroy_mark_locked+0x3f/0x1b0
[   76.245619]  [<ffffffff8120293b>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[   76.251176]  [<ffffffff81201e1e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[   76.256423]  [<ffffffff812061fd>] sys_fanotify_mark+0x51d/0x590
[   76.260788]  [<ffffffff81103305>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   76.265693]  [<ffffffff81ff9b69>] system_call_fastpath+0x16/0x1b
[   76.539089] BUG: scheduling while atomic: trinity-child4/3551/0x10000002
[   76.544131] INFO: lockdep is turned off.
[   76.547066] Pid: 3551, comm: trinity-child4 Tainted: G    B D W
3.9.0-rc2+ #127
[   76.552685] Call Trace:
[   76.554635]  [<ffffffff81fe1201>] __schedule_bug+0x5d/0x6d
[   76.558752]  [<ffffffff81ff5cf0>] __schedule+0x90/0x9a0
[   76.562652]  [<ffffffff810dcd85>] __cond_resched+0x25/0x40
[   76.566682]  [<ffffffff81ff673c>] _cond_resched+0x2c/0x40
[   76.570673]  [<ffffffff811941c6>] remove_vma+0x26/0x80
[   76.574530]  [<ffffffff8119784c>] exit_mmap+0x11c/0x170
[   76.578383]  [<ffffffff811af726>] ? kmem_cache_free+0x176/0x2c0
[   76.582840]  [<ffffffff8109f4f9>] mmput+0x59/0xe0
[   76.586394]  [<ffffffff810a896b>] do_exit+0x37b/0xbb0
[   76.590231]  [<ffffffff810a5ab8>] ? kmsg_dump+0x1f8/0x220
[   76.594253]  [<ffffffff810a58e0>] ? kmsg_dump+0x20/0x220
[   76.598199]  [<ffffffff81066f78>] oops_end+0xc8/0xe0
[   76.601863]  [<ffffffff810670f2>] die+0x62/0x80
[   76.605207]  [<ffffffff81064315>] do_general_protection+0xa5/0x160
[   76.609788]  [<ffffffff81ff9263>] ? restore_args+0x30/0x30
[   76.613863]  [<ffffffff81ff94d8>] general_protection+0x28/0x30
[   76.618109]  [<ffffffff81104ed0>] ? __lock_acquire+0x610/0x1b60
[   76.622497]  [<ffffffff81103193>] ? mark_held_locks+0x123/0x140
[   76.626764]  [<ffffffff812050c3>] ? fanotify_free_mark+0x13/0x20
[   76.631222]  [<ffffffff81fe3acd>] ? __slab_free+0x1cf/0x4QEMU: Terminated
