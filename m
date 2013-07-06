Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3GFAa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 20:30:57 -0400
Received: from peace.netnation.com ([204.174.223.2]:49295 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3GFAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 20:30:55 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2013 20:30:55 EDT
Date: Fri, 5 Jul 2013 17:09:49 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20130706000949.GD16853@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We saw two Oopses overnight on two separate boxes that seem possibly
related, but both are weird. These boxes typically run btrfs for rsync
snapshot backups (and usually Oops in btrfs ;), but not this time!
backup02 was running 3.10-rc6 plus btrfs-next at the time, and backup03
was running 3.10 release plus btrfs-next from yesterday. Full kern.log
and .config at http://0x.ca/sim/ref/3.10/

backup02's first Oops:

BUG: unable to handle kernel paging request at 0000000100000000
IP: [<ffffffff81124beb>] kmem_cache_alloc+0x4b/0x110
PGD 1f54f7067 PUD 0
Oops: 0000 [#1] SMP
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe microcode serio_raw bnx2 evdev
CPU: 0 PID: 23112 Comm: ionice Not tainted 3.10.0-rc6-hw+ #46
Hardware name: Dell Inc. PowerEdge 2950/0NH278, BIOS 2.7.0 10/30/2010
task: ffff8802c3f08000 ti: ffff8801b4876000 task.ti: ffff8801b4876000
RIP: 0010:[<ffffffff81124beb>]  [<ffffffff81124beb>] kmem_cache_alloc+0x4b/0x110
RSP: 0018:ffff8801b4877e88  EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff8802c3f08000 RCX: 00000000017f040e
RDX: 00000000017f040d RSI: 00000000000000d0 RDI: ffffffff8107a503
RBP: ffff8801b4877ec8 R08: 0000000000016a80 R09: 0000000000000000
R10: 00007fff025fe120 R11: 0000000000000246 R12: 00000000000000d0
R13: ffff88042d8019c0 R14: 0000000100000000 R15: 00007fc3588ee97f
FS:  0000000000000000(0000) GS:ffff88043fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000100000000 CR3: 0000000409d68000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffff8801b4877ed8 ffffffff8112a1bc ffff8800985acd20 ffff8802c3f08000
 0000000000000001 00007fc3588ee334 00007fc358af5758 00007fc3588ee97f
 ffff8801b4877ee8 ffffffff8107a503 ffff8801b4877ee8 ffffffffffffffea
Call Trace:
 [<ffffffff8112a1bc>] ? __fput+0x12c/0x240
 [<ffffffff8107a503>] prepare_creds+0x23/0x150
 [<ffffffff811272d4>] SyS_faccessat+0x34/0x1f0
 [<ffffffff811274a3>] SyS_access+0x13/0x20
 [<ffffffff8179e7a9>] system_call_fastpath+0x16/0x1b
Code: 75 f0 4c 89 7d f8 49 8b 4d 00 65 48 03 0c 25 68 da 00 00 48 8b 51 08 4c 8b 31 4d 85 f6 74 5f 49 63 45 20 4d 8b 45 00 48 8d 4a 01 <49> 8b 1c 06 4c 89 f0 65 49 0f c7 08 0f 94 c0 84 c0 74 c8 49 63
RIP  [<ffffffff81124beb>] kmem_cache_alloc+0x4b/0x110
 RSP <ffff8801b4877e88>
CR2: 0000000100000000
---[ end trace 744477356cd98306 ]---

backup03's first Oops:

BUG: unable to handle kernel paging request at ffff880502efc240
IP: [<ffffffff81124c4b>] kmem_cache_alloc+0x4b/0x110
PGD 1d3a067 PUD 0
Oops: 0000 [#1] SMP
Modules linked in: aoe ipmi_devintf ipmi_msghandler bnx2 microcode serio_raw evdev
CPU: 6 PID: 14066 Comm: perl Not tainted 3.10.0-hw+ #2
Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.11.0 07/23/2012
task: ffff88040111c3b0 ti: ffff8803c23ae000 task.ti: ffff8803c23ae000
RIP: 0010:[<ffffffff81124c4b>]  [<ffffffff81124c4b>] kmem_cache_alloc+0x4b/0x110
RSP: 0018:ffff8803c23afd90  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88040111c3b0 RCX: 000000000002a76e
RDX: 000000000002a76d RSI: 00000000000000d0 RDI: ffffffff8107a4e3
RBP: ffff8803c23afdd0 R08: 0000000000016a80 R09: 00000000ffffffff
R10: fffffffffffffffe R11: ffffffffffffffd0 R12: 00000000000000d0
R13: ffff88041d403980 R14: ffff880502efc240 R15: ffff88010e375a40
FS:  00007f2cae496700(0000) GS:ffff88041f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880502efc240 CR3: 00000001e0ced000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffff8803c23afe98 ffff8803c23afdb8 ffffffff81133811 ffff88040111c3b0
 ffff88010e375a40 0000000001200011 00007f2cae4969d0 ffff88010e375a40
 ffff8803c23afdf0 ffffffff8107a4e3 ffffffff81b49b80 0000000001200011
Call Trace:
 [<ffffffff81133811>] ? final_putname+0x21/0x50
 [<ffffffff8107a4e3>] prepare_creds+0x23/0x150
 [<ffffffff8107ab11>] copy_creds+0x31/0x160
 [<ffffffff8101a97b>] ? unlazy_fpu+0x9b/0xb0
 [<ffffffff8104ef09>] copy_process.part.49+0x239/0x1390
 [<ffffffff81143312>] ? __alloc_fd+0x42/0x100
 [<ffffffff81050134>] do_fork+0xa4/0x320
 [<ffffffff81131b77>] ? __do_pipe_flags+0x77/0xb0
 [<ffffffff81143426>] ? __fd_install+0x26/0x60
 [<ffffffff81050431>] SyS_clone+0x11/0x20
 [<ffffffff817ad849>] stub_clone+0x69/0x90
 [<ffffffff817ad569>] ? system_call_fastpath+0x16/0x1b
Code: 75 f0 4c 89 7d f8 49 8b 4d 00 65 48 03 0c 25 68 da 00 00 48 8b 51 08 4c 8b 31 4d 85 f6 74 5f 49 63 45 20 4d 8b 45 00 48 8d 4a 01 <49> 8b 1c 06 4c 89 f0 65 49 0f c7 08 0f 94 c0 84 c0 74 c8 49 63
RIP  [<ffffffff81124c4b>] kmem_cache_alloc+0x4b/0x110
 RSP <ffff8803c23afd90>
CR2: ffff880502efc240
---[ end trace 956d153150ecc57f ]---

Simon-
