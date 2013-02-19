Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3BSRdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:33:45 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:53936 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3BSRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:33:43 -0500
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 19:33:42 +0200
Message-ID: <CA+ydwtrmj_nXc3KNLW3YCE4BU_dOZnWRhkAC7wTXmrj5dXz6_Q@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request at ffffc90000669000, IP:
 [<ffffffff8139d84a>] bitfill_unaligned+0x10a/0x1a0
From: Tommi Rantala <tt.rantala@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit the following oops while fuzzing the kernel with Trinity in a qemu
virtual machine:

[ 2143.140647] BUG: unable to handle kernel paging request at ffffc90000669000
[ 2143.140652] IP: [<ffffffff8139d84a>] bitfill_unaligned+0x10a/0x1a0
[ 2143.140654] PGD 3e073067 PUD 3e074067 PMD 3ca84067 PTE 0
[ 2143.140656] Oops: 0002 [#1] SMP
[ 2143.140660] CPU 0
[ 2143.140660] Pid: 2894, comm: trinity-child0 Not tainted 3.8.0-rc7+
#86 Bochs Bochs
[ 2143.140662] RIP: 0010:[<ffffffff8139d84a>]  [<ffffffff8139d84a>]
bitfill_unaligned+0x10a/0x1a0
[ 2143.140663] RSP: 0018:ffff88003a967888  EFLAGS: 00010246
[ 2143.140664] RAX: 0000000003fffe1f RBX: 0000000000000000 RCX: 0000000000000008
[ 2143.140664] RDX: 0000000003f87fff RSI: ffffc900002a9f08 RDI: 0000000000000000
[ 2143.140665] RBP: ffff88003a9678a8 R08: 0000000000000008 R09: 0000000000000010
[ 2143.140666] R10: ffffc90000668fe8 R11: 0000000000000000 R12: 00000000ffff8800
[ 2143.140666] R13: 00000000ffffffc0 R14: ffffffffffffffff R15: 0000000000000018
[ 2143.140668] FS:  00007f965fc5e700(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[ 2143.140668] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2143.140669] CR2: ffffc90000669000 CR3: 0000000039c50000 CR4: 00000000000006f0
[ 2143.140675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2143.140678] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2143.140679] Process trinity-child0 (pid: 2894, threadinfo
ffff88003a966000, task ffff88003b0c0000)
[ 2143.140679] Stack:
[ 2143.140682]  ffff88003ca8d800 0000000000000000 ffffc900002a9f00
0000000000000000
[ 2143.140683]  ffff88003a967938 ffffffff8139debf ffffffffffff8800
ffff880000000040
[ 2143.140685]  ffffffff8225f1a0 ffff000000000000 ffff88003a9678e8
ffffffff810f5aed
[ 2143.140685] Call Trace:
[ 2143.140688]  [<ffffffff8139debf>] sys_fillrect+0x34f/0x370
[ 2143.140692]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[ 2143.140693]  [<ffffffff8139d740>] ? bitfill_aligned+0x120/0x120
[ 2143.140696]  [<ffffffff814bbcef>] cirrus_fillrect+0x1f/0x40
[ 2143.140697]  [<ffffffff8139aaba>] bit_clear_margins+0x12a/0x170
[ 2143.140701]  [<ffffffff81395641>] fbcon_clear_margins+0x71/0x80
[ 2143.140702]  [<ffffffff813998a9>] fbcon_switch+0x479/0x540
[ 2143.140705]  [<ffffffff814166c1>] redraw_screen+0x131/0x250
[ 2143.140707]  [<ffffffff81396c1c>] fbcon_modechanged+0x18c/0x210
[ 2143.140709]  [<ffffffff81397739>] fbcon_event_notify+0x1f9/0x850
[ 2143.140712]  [<ffffffff810c671d>] notifier_call_chain+0xbd/0xf0
[ 2143.140714]  [<ffffffff810c6c08>] __blocking_notifier_call_chain+0x98/0xc0
[ 2143.140716]  [<ffffffff810c6c41>] blocking_notifier_call_chain+0x11/0x20
[ 2143.140718]  [<ffffffff81389146>] fb_notifier_call_chain+0x16/0x20
[ 2143.140720]  [<ffffffff8138ae19>] fb_set_var+0x439/0x480
[ 2143.140721]  [<ffffffff8138b089>] do_fb_ioctl+0x189/0x5d0
[ 2143.140723]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[ 2143.140724]  [<ffffffff810d552a>] ? local_clock+0x4a/0x70
[ 2143.140726]  [<ffffffff810f1e98>] ? lock_release_holdtime+0x28/0x170
[ 2143.140728]  [<ffffffff8138b90a>] fb_ioctl+0x3a/0x40
[ 2143.140731]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[ 2143.140735]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[ 2143.140737]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[ 2143.140739]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2143.140741]  [<ffffffff81ca06e9>] system_call_fastpath+0x16/0x1b
[ 2143.140758] Code: 89 7a 08 48 d3 e3 44 89 c9 48 d3 ef 44 89 c1 48
09 df 48 89 fb 49 89 7a 10 48 d3 e3 44 89 c9 48 d3 ef 44 89 c1 48 09
df 48 89 fb <49> 89 7a 18 49 83 c2 20 48 d3 e3 44 89 c9 48 d3 ef 48 09
df 83
[ 2143.140760] RIP  [<ffffffff8139d84a>] bitfill_unaligned+0x10a/0x1a0
[ 2143.140760]  RSP <ffff88003a967888>
[ 2143.140761] CR2: ffffc90000669000
[ 2143.146366] BUG: unable to handle kernel paging request at ffffc90000669000
[ 2143.146369] IP: [<ffffffff8139d84a>] bitfill_unaligned+0x10a/0x1a0
[ 2143.146371] PGD 3e073067 PUD 3e074067 PMD 3ca84067 PTE 0
[ 2143.146372] Oops: 0002 [#2] SMP
[ 2143.146375] CPU 0
[ 2143.146375] Pid: 2894, comm: trinity-child0 Not tainted 3.8.0-rc7+
#86 Bochs Bochs
[ 2143.146377] RIP: 0010:[<ffffffff8139d84a>]  [<ffffffff8139d84a>]
bitfill_unaligned+0x10a/0x1a0
[ 2143.146378] RSP: 0018:ffff88003a967218  EFLAGS: 00010246
[ 2143.146378] RAX: 0000000003fffe1f RBX: 0000000000000000 RCX: 0000000000000008
[ 2143.146379] RDX: 0000000003f87fff RSI: ffffc900002a9f08 RDI: 0000000000000000
[ 2143.146380] RBP: ffff88003a967238 R08: 0000000000000008 R09: 0000000000000010
[ 2143.146380] R10: ffffc90000668fe8 R11: 0000000000000000 R12: 00000000ffff8800
[ 2143.146381] R13: 00000000ffffffc0 R14: ffffffffffffffff R15: 0000000000000018
[ 2143.146382] FS:  00007f965fc5e700(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[ 2143.146383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2143.146383] CR2: ffffc90000669000 CR3: 0000000039c50000 CR4: 00000000000006f0
[ 2143.146388] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2143.146391] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2143.146391] Process trinity-child0 (pid: 2894, threadinfo
ffff88003a966000, task ffff88003b0c0000)
[ 2143.146392] Stack:
[ 2143.146394]  ffff88003ca8d800 0000000000000000 ffffc900002a9f00
0000000000000000
[ 2143.146395]  ffff88003a9672c8 ffffffff8139debf ffffffffffff8800
ffff880000000040
[ 2143.146397]  ffffffff8225f1a0 ffff000000000000 ffff88003a967278
ffffffff810f5aed
[ 2143.146397] Call Trace:
[ 2143.146399]  [<ffffffff8139debf>] sys_fillrect+0x34f/0x370
[ 2143.146402]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[ 2143.146403]  [<ffffffff8139d740>] ? bitfill_aligned+0x120/0x120
[ 2143.146405]  [<ffffffff814bbcef>] cirrus_fillrect+0x1f/0x40
[ 2143.146406]  [<ffffffff8139aaba>] bit_clear_margins+0x12a/0x170
[ 2143.146408]  [<ffffffff81395641>] fbcon_clear_margins+0x71/0x80
[ 2143.146410]  [<ffffffff813998a9>] fbcon_switch+0x479/0x540
[ 2143.146412]  [<ffffffff814166c1>] redraw_screen+0x131/0x250
[ 2143.146414]  [<ffffffff81397f9a>] fbcon_blank+0x20a/0x2d0
[ 2143.146417]  [<ffffffff81c9effc>] ? _raw_spin_lock_irqsave+0x7c/0x90
[ 2143.146420]  [<ffffffff810a8ee3>] ? lock_timer_base.isra.25+0x33/0x70
[ 2143.146422]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[ 2143.146423]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[ 2143.146425]  [<ffffffff81c9f174>] ? _raw_spin_unlock_irqrestore+0x44/0x70
[ 2143.146427]  [<ffffffff810aa17b>] ? mod_timer+0x1ab/0x200
[ 2143.146429]  [<ffffffff814180f8>] do_unblank_screen+0xf8/0x1d0
[ 2143.146430]  [<ffffffff814181db>] unblank_screen+0xb/0x10
[ 2143.146432]  [<ffffffff81358239>] bust_spinlocks+0x19/0x30
[ 2143.146435]  [<ffffffff8105cde2>] oops_end+0x42/0xe0
[ 2143.146438]  [<ffffffff81c89d82>] no_context+0x253/0x27e
[ 2143.146439]  [<ffffffff81c89f73>] __bad_area_nosemaphore+0x1c6/0x1e5
[ 2143.146442]  [<ffffffff81091681>] ? kmemcheck_pte_lookup+0x11/0x40
[ 2143.146444]  [<ffffffff81c89fa0>] bad_area_nosemaphore+0xe/0x10
[ 2143.146445]  [<ffffffff8108a35e>] __do_page_fault+0x43e/0x4d0
[ 2143.146447]  [<ffffffff810f58d3>] ? mark_held_locks+0x123/0x140
[ 2143.146449]  [<ffffffff81c9fdb3>] ? retint_restore_args+0x13/0x13
[ 2143.146451]  [<ffffffff810f58d3>] ? mark_held_locks+0x123/0x140
[ 2143.146452]  [<ffffffff8135721d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2143.146454]  [<ffffffff8108a419>] do_page_fault+0x9/0x10
[ 2143.146456]  [<ffffffff8108492c>] do_async_page_fault+0x4c/0xa0
[ 2143.146458]  [<ffffffff81ca00b8>] async_page_fault+0x28/0x30
[ 2143.146459]  [<ffffffff8139d84a>] ? bitfill_unaligned+0x10a/0x1a0
[ 2143.146460]  [<ffffffff8139debf>] sys_fillrect+0x34f/0x370
[ 2143.146462]  [<ffffffff810f5aed>] ? trace_hardirqs_on+0xd/0x10
[ 2143.146464]  [<ffffffff8139d740>] ? bitfill_aligned+0x120/0x120
[ 2143.146465]  [<ffffffff814bbcef>] cirrus_fillrect+0x1f/0x40
[ 2143.146466]  [<ffffffff8139aaba>] bit_clear_margins+0x12a/0x170
[ 2143.146468]  [<ffffffff81395641>] fbcon_clear_margins+0x71/0x80
[ 2143.146470]  [<ffffffff813998a9>] fbcon_switch+0x479/0x540
[ 2143.146472]  [<ffffffff814166c1>] redraw_screen+0x131/0x250
[ 2143.146473]  [<ffffffff81396c1c>] fbcon_modechanged+0x18c/0x210
[ 2143.146475]  [<ffffffff81397739>] fbcon_event_notify+0x1f9/0x850
[ 2143.146477]  [<ffffffff810c671d>] notifier_call_chain+0xbd/0xf0
[ 2143.146479]  [<ffffffff810c6c08>] __blocking_notifier_call_chain+0x98/0xc0
[ 2143.146481]  [<ffffffff810c6c41>] blocking_notifier_call_chain+0x11/0x20
[ 2143.146483]  [<ffffffff81389146>] fb_notifier_call_chain+0x16/0x20
[ 2143.146484]  [<ffffffff8138ae19>] fb_set_var+0x439/0x480
[ 2143.146486]  [<ffffffff8138b089>] do_fb_ioctl+0x189/0x5d0
[ 2143.146487]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[ 2143.146488]  [<ffffffff810d552a>] ? local_clock+0x4a/0x70
[ 2143.146490]  [<ffffffff810f1e98>] ? lock_release_holdtime+0x28/0x170
[ 2143.146492]  [<ffffffff8138b90a>] fb_ioctl+0x3a/0x40
[ 2143.146494]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[ 2143.146496]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[ 2143.146498]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[ 2143.146499]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2143.146501]  [<ffffffff81ca06e9>] system_call_fastpath+0x16/0x1b
[ 2143.146518] Code: 89 7a 08 48 d3 e3 44 89 c9 48 d3 ef 44 89 c1 48
09 df 48 89 fb 49 89 7a 10 48 d3 e3 44 89 c9 48 d3 ef 44 89 c1 48 09
df 48 89 fb <49> 89 7a 18 49 83 c2 20 48 d3 e3 44 89 c9 48 d3 ef 48 09
df 83
[ 2143.146519] RIP  [<ffffffff8139d84a>] bitfill_unaligned+0x10a/0x1a0
[ 2143.146520]  RSP <ffff88003a967218>
[ 2143.146520] CR2: ffffc90000669000
[ 2143.146522] ---[ end trace bc6146191d8a6170 ]---

Tommi
