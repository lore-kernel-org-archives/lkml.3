Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbaKAAdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:33:11 -0400
Received: from ozlabs.org ([103.22.144.67]:58037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbaKAAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:33:08 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
In-Reply-To: <cover.1412189265.git.luto@amacapital.net>
References: <cover.1412189265.git.luto@amacapital.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 01 Nov 2014 10:50:39 +1030
Message-ID: <877fzf4vqg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> Anish Bhatt noticed that user programs can set RFLAGS.NT before
> syscall or sysenter, and the kernel entry code doesn't filter out
> NT.  This causes kernel C code and, depending on thread flags, the
> exit slow path to run with NT set.

OK, this causes oopsen as a guest under kvm for me.  Details below:

commit 8c7aa698baca5e8f1ba9edb68081f1e7a1abf455
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Wed Oct 1 11:49:04 2014 -0700

    x86_64, entry: Filter RFLAGS.NT on entry from userspace

Some dmesg:

[    0.820982] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.822118] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.824445] mousedev: PS/2 mouse device common for all mice
[    0.827262] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.830249] rtc_cmos 00:00: RTC can wake from S4
[    0.831830] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.833314] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.835128] device-mapper: uevent: version 1.0.3
[    0.836526] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.838566] TCP: cubic registered
[    0.839891] NET: Registered protocol family 10
[    0.841868] NET: Registered protocol family 17
[    0.843005] Key type dns_resolver registered
[    0.845481] registered taskstats version 1
[    0.847120] kworker/u2:2 (48) used greatest stack depth: 14400 bytes left
[    0.849147] kworker/u2:3 (50) used greatest stack depth: 14048 bytes left
[    0.850779] Key type trusted registered
[    0.853360] Key type encrypted registered
[    0.855561] AppArmor: AppArmor sha1 policy hashing enabled
[    0.856768] cryptomgr_probe (63) used greatest stack depth: 13712 bytes left
[    0.858156] evm: HMAC attrs: 0x1
[    0.859577]   Magic number: 2:172:455
[    0.860833] rtc_cmos 00:00: setting system clock to 2014-10-31 23:26:48 UTC (1414798008)
[    0.862465] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.863663] EDD information not available.
[    0.964548] ata2.00: ATAPI: QEMU DVD-ROM, 2.1.0, max UDMA/100
[    0.966081] ata2.00: configured for MWDMA2
[    0.968174] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.1. PQ: 0 ANSI: 5
[    0.977913] sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    0.978861] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.981138] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    0.982634] md: Waiting for all devices to be available before autodetect
[    0.986583] md: If you don't use raid, use raid=noautodetect
[    0.990236] md: Autodetecting RAID arrays.
[    0.991035] md: Scanned 0 and added 0 devices.
[    0.991815] md: autorun ...
[    0.992215] md: ... autorun DONE.
[    0.994068] EXT3-fs (vda1): error: couldn't mount because of unsupported optional features (240)
[    0.996331] EXT4-fs (vda1): couldn't mount as ext2 due to feature incompatibilities
[    1.003145] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.006600] VFS: Mounted root (ext4 filesystem) readonly on device 253:1.
[    1.010007] devtmpfs: mounted
[    1.011632] debug: unmapping init [mem 0xffffffff81d2b000-0xffffffff81e6ffff]
[    1.012631] Write protecting the kernel read-only data: 12288k
[    1.013571] debug: unmapping init [mem 0xffff88000170d000-0xffff8800017fffff]
[    1.014639] debug: unmapping init [mem 0xffff880001b21000-0xffff880001bfffff]
[    1.123201] random: init urandom read with 8 bits of entropy available
[    1.126953] BUG: unable to handle kernel paging request at ffff88001da4c018
[    1.128482] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.129513] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001da4c060
[    1.129513] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    1.129513] Modules linked in:
[    1.129513] CPU: 0 PID: 69 Comm: init Not tainted 3.17.0-rc7+ #245
[    1.129513] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.129513] task: ffff88001da08000 ti: ffff88001da48000 task.ti: ffff88001da48000
[    1.129513] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.129513] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296
[    1.129513] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
[    1.129513] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
[    1.129513] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 00000000ffcaba58
[    1.129513] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
[    1.129513] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.129513] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
[    1.129513] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.129513] CR2: ffff88001da4c018 CR3: 000000001da2c000 CR4: 00000000000006f0
[    1.129513] Stack:
[    1.129513]  0000000000000000 0000000000000000 00000000ffcaba58 ffffffff8138aa0b
[    1.129513]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
[    1.129513]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
[    1.129513] Call Trace:
[    1.129513]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.129513] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.129513] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.129513]  RSP <ffff88001da4bf88>
[    1.129513] CR2: ffff88001da4c018
[    1.129513] ---[ end trace 7d7a8bfdc14fe3bb ]---
[    1.129513] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:41
[    1.129513] in_atomic(): 0, irqs_disabled(): 1, pid: 69, name: init
[    1.129513] INFO: lockdep is turned off.
[    1.129513] irq event stamp: 62
[    1.129513] hardirqs last  enabled at (61): [<ffffffff81705909>] retint_swapgs+0xe/0x13
[    1.129513] hardirqs last disabled at (62): [<ffffffff81706b13>] error_sti+0x5/0x6
[    1.129513] softirqs last  enabled at (0): [<ffffffff81054a28>] copy_process.part.30+0x5b8/0x1c70
[    1.129513] softirqs last disabled at (0): [<          (null)>]           (null)
[    1.129513] CPU: 0 PID: 69 Comm: init Tainted: G      D        3.17.0-rc7+ #245
[    1.129513] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.129513]  0000000000000009 ffff88001da4bc08 ffffffff816fbd34 ffff88001f7d35d8
[    1.129513]  ffff88001da4bc18 ffffffff8107d181 ffff88001da4bc38 ffffffff81702314
[    1.129513]  ffff88001da08000 ffff88001da08000 ffff88001da4bc58 ffffffff81067464
[    1.129513] Call Trace:
[    1.129513]  [<ffffffff816fbd34>] dump_stack+0x4d/0x66
[    1.129513]  [<ffffffff8107d181>] __might_sleep+0xf1/0x120
[    1.129513]  [<ffffffff81702314>] down_read+0x24/0x70
[    1.129513]  [<ffffffff81067464>] exit_signals+0x24/0x130
[    1.129513]  [<ffffffff81058743>] do_exit+0xb3/0xbd0
[    1.129513]  [<ffffffff810b4328>] ? kmsg_dump+0x108/0x120
[    1.129513]  [<ffffffff810b4242>] ? kmsg_dump+0x22/0x120
[    1.129513]  [<ffffffff810064eb>] oops_end+0x8b/0xd0
[    1.129513]  [<ffffffff810452ac>] no_context+0x12c/0x380
[    1.129513]  [<ffffffff81704197>] ? _raw_spin_unlock+0x27/0x40
[    1.129513]  [<ffffffff81180dd5>] ? do_read_fault.isra.77+0xd5/0x2c0
[    1.129513]  [<ffffffff81045585>] __bad_area_nosemaphore+0x85/0x210
[    1.129513]  [<ffffffff81045723>] bad_area_nosemaphore+0x13/0x20
[    1.129513]  [<ffffffff81045bb6>] __do_page_fault+0xd6/0x5d0
[    1.129513]  [<ffffffff81045c72>] ? __do_page_fault+0x192/0x5d0
[    1.129513]  [<ffffffff8109d36f>] ? up_read+0x1f/0x40
[    1.129513]  [<ffffffff81045d74>] ? __do_page_fault+0x294/0x5d0
[    1.129513]  [<ffffffff8138aa4a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    1.129513]  [<ffffffff810460bc>] do_page_fault+0xc/0x10
[    1.129513]  [<ffffffff81706912>] page_fault+0x22/0x30
[    1.129513]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.129513]  [<ffffffff8170703d>] ? ia32_sysenter_target+0x4d/0x5e
[    1.129513]  [<ffffffff81705909>] ? retint_swapgs+0xe/0x13
[    1.129513]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.217584] init (69) used greatest stack depth: 13528 bytes left
[    1.229190] BUG: unable to handle kernel paging request at ffff88001da7c018
[    1.230520] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.231890] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001da7c060
[    1.232181] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[    1.232181] Modules linked in:
[    1.232181] CPU: 0 PID: 71 Comm: init Tainted: G      D        3.17.0-rc7+ #245
[    1.232181] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.232181] task: ffff88001d9f2110 ti: ffff88001da78000 task.ti: ffff88001da78000
[    1.232181] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.232181] RSP: 0018:ffff88001da7bf88  EFLAGS: 00010296
[    1.232181] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
[    1.232181] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
[    1.232181] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.232181] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
[    1.232181] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.232181] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
[    1.232181] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.232181] CR2: ffff88001da7c018 CR3: 000000001da5e000 CR4: 00000000000006f0
[    1.232181] Stack:
[    1.232181]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.232181]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
[    1.232181]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
[    1.232181] Call Trace:
[    1.232181]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.232181] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.232181] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.232181]  RSP <ffff88001da7bf88>
[    1.232181] CR2: ffff88001da7c018
[    1.232181] ---[ end trace 7d7a8bfdc14fe3bc ]---
[    1.265113] BUG: unable to handle kernel paging request at ffff88001da84018
[    1.266545] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.267854] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001da84060
[    1.268444] Oops: 0000 [#3] SMP DEBUG_PAGEALLOC
[    1.268444] Modules linked in:
[    1.268444] CPU: 0 PID: 72 Comm: init Tainted: G      D        3.17.0-rc7+ #245
[    1.268444] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.268444] task: ffff88001d9f4220 ti: ffff88001da80000 task.ti: ffff88001da80000
[    1.268444] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.268444] RSP: 0018:ffff88001da83f88  EFLAGS: 00010296
[    1.268444] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
[    1.268444] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
[    1.268444] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.268444] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
[    1.268444] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.268444] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
[    1.268444] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.268444] CR2: ffff88001da84018 CR3: 000000001da5f000 CR4: 00000000000006f0
[    1.268444] Stack:
[    1.268444]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.268444]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
[    1.268444]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
[    1.268444] Call Trace:
[    1.268444]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.268444] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.268444] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.268444]  RSP <ffff88001da83f88>
[    1.268444] CR2: ffff88001da84018
[    1.268444] ---[ end trace 7d7a8bfdc14fe3bd ]---
[    1.301978] init: Error while reading from descriptor: Bad file descriptor
[    1.303740] init: hostname main process (69) killed by KILL signal
[    1.306985] init: hwclock main process (71) killed by KILL signal
[    1.309804] init: ureadahead main process (72) killed by KILL signal
[    1.322693] BUG: unable to handle kernel paging request at ffff88001daa4018
[    1.324040] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.324040] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001daa4060
[    1.324040] Oops: 0000 [#4] SMP DEBUG_PAGEALLOC
[    1.324040] Modules linked in:
[    1.324040] CPU: 0 PID: 75 Comm: init Tainted: G      D        3.17.0-rc7+ #245
[    1.324040] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.324040] task: ffff88001d9f2110 ti: ffff88001daa0000 task.ti: ffff88001daa0000
[    1.324040] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.324040] RSP: 0018:ffff88001daa3f88  EFLAGS: 00010296
[    1.324040] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
[    1.324040] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
[    1.324040] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.324040] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
[    1.324040] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.324040] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
[    1.324040] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.324040] CR2: ffff88001daa4018 CR3: 000000001da6e000 CR4: 00000000000006f0
[    1.324040] Stack:
[    1.324040]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.324040]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
[    1.324040]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
[    1.324040] Call Trace:
[    1.324040]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.324040] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.324040] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.324040]  RSP <ffff88001daa3f88>
[    1.324040] CR2: ffff88001daa4018
[    1.324040] ---[ end trace 7d7a8bfdc14fe3be ]---
[    1.372657] plymouthd (70) used greatest stack depth: 13256 bytes left
[    1.374306] init: Error while reading from descriptor: Bad file descriptor
[    1.376348] init: mountall main process (75) killed by KILL signal
[    1.386907] sh (76) used greatest stack depth: 13208 bytes left
[    1.388173] tsc: Refined TSC clocksource calibration: 2594.100 MHz
[    1.390528] BUG: unable to handle kernel paging request at ffff88001daa4018
[    1.392121] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.392121] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001daa4060
[    1.392121] Oops: 0000 [#5] SMP DEBUG_PAGEALLOC
[    1.392121] Modules linked in:
[    1.392121] CPU: 0 PID: 78 Comm: init Tainted: G      D        3.17.0-rc7+ #245
[    1.392121] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.392121] task: ffff88001da0a110 ti: ffff88001daa0000 task.ti: ffff88001daa0000
[    1.392121] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.392121] RSP: 0018:ffff88001daa3f88  EFLAGS: 00010296
[    1.392121] RAX: 0000000000000137 RBX: 00000000f754e730 RCX: 000000000000000c
[    1.392121] RDX: 00000000f7711000 RSI: 0000000000000000 RDI: 00000000f77c3040
[    1.392121] RBP: 00000000ffca97c8 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.392121] R10: 00000000f77a1b70 R11: 0000000000000000 R12: 0000000000000000
[    1.392121] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.392121] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f754e6c0
[    1.392121] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.392121] CR2: ffff88001daa4018 CR3: 000000001da27000 CR4: 00000000000006f0
[    1.392121] Stack:
[    1.392121]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.392121]  0000000000000137 000000000000000c 00000000f7711000 0000000000000000
[    1.392121]  00000000f77c3040 0000000000000137 00000000f77a1b70 0000000000000023
[    1.392121] Call Trace:
[    1.392121]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.392121] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.392121] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.392121]  RSP <ffff88001daa3f88>
[    1.392121] CR2: ffff88001daa4018
[    1.392121] ---[ end trace 7d7a8bfdc14fe3bf ]---
[    1.436568] BUG: unable to handle kernel paging request at ffff88001da4c018
[    1.438056] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.439308] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001da4c060
[    1.440088] Oops: 0000 [#6] SMP DEBUG_PAGEALLOC
[    1.440088] Modules linked in:
[    1.440088] CPU: 0 PID: 73 Comm: plymouthd Tainted: G      D        3.17.0-rc7+ #245
[    1.440088] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.440088] task: ffff88001d9f0000 ti: ffff88001da48000 task.ti: ffff88001da48000
[    1.440088] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.440088] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296
[    1.440088] RAX: 0000000000000066 RBX: 0000000000000005 RCX: 00000000ffdc3810
[    1.440088] RDX: 000000000a048bd0 RSI: 000000000a048ca0 RDI: 0000000000000000
[    1.440088] RBP: 000000000a048c58 R08: 0000000000000000 R09: 0000000000000000
[    1.440088] R10: 00000000f775ab70 R11: 0000000000000000 R12: 0000000000000000
[    1.440088] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.440088] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f75176c0
[    1.440088] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[    1.440088] CR2: ffff88001da4c018 CR3: 000000001da64000 CR4: 00000000000006f0
[    1.440088] Stack:
[    1.440088]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    1.440088]  0000000000000066 00000000ffdc3810 000000000a048bd0 000000000a048ca0
[    1.440088]  0000000000000000 0000000000000066 00000000f775ab70 0000000000000023
[    1.440088] Call Trace:
[    1.440088] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.440088] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.440088]  RSP <ffff88001da4bf88>
[    1.440088] CR2: ffff88001da4c018
[    1.440088] ---[ end trace 7d7a8bfdc14fe3c0 ]---
[    1.478043] init: console-setup main process (78) killed by KILL signal
[    1.485084] plymouthd (73) used greatest stack depth: 13048 bytes left
[    1.493827] init: plymouth main process (73) killed by KILL signal
[    1.496444] init: plymouth-stop pre-start process (79) terminated with status 2
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
[    1.651076] BUG: unable to handle kernel paging request at ffff88001daa4018
[    1.653236] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.654249] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001daa4060
[    1.654249] Oops: 0000 [#7] SMP DEBUG_PAGEALLOC
[    1.654249] Modules linked in:
[    1.654249] CPU: 0 PID: 83 Comm: bash Tainted: G      D        3.17.0-rc7+ #245
[    1.654249] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.654249] task: ffff88001d9f2110 ti: ffff88001daa0000 task.ti: ffff88001daa0000
[    1.654249] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.654249] RSP: 0018:ffff88001daa3f88  EFLAGS: 00010296
[    1.654249] RAX: 00000000000000af RBX: 0000000000000002 RCX: 000000000812e380
[    1.654249] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000f773d000
[    1.654249] RBP: 00000000fffd1da0 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.654249] R10: 00000000f777bb70 R11: 0000000000000000 R12: 0000000000000000
[    1.654249] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.654249] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f75966c0
[    1.654249] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.654249] CR2: ffff88001daa4018 CR3: 000000001da37000 CR4: 00000000000006f0
[    1.654249] Stack:
[    1.654249]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.654249]  00000000000000af 000000000812e380 0000000000000000 0000000000000008
[    1.654249]  00000000f773d000 00000000000000af 00000000f777bb70 0000000000000023
[    1.654249] Call Trace:
[    1.654249]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.654249] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.654249] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.654249]  RSP <ffff88001daa3f88>
[    1.654249] CR2: ffff88001daa4018
[    1.654249] ---[ end trace 7d7a8bfdc14fe3c1 ]---
[    1.846659] BUG: unable to handle kernel paging request at ffff88001daa4018
[    1.847580] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.848331] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001daa4060
[    1.849222] Oops: 0000 [#8] SMP DEBUG_PAGEALLOC
[    1.849318] Modules linked in:
[    1.849318] CPU: 0 PID: 85 Comm: bash Tainted: G      D        3.17.0-rc7+ #245
[    1.849318] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.849318] task: ffff88001d9f2110 ti: ffff88001daa0000 task.ti: ffff88001daa0000
[    1.849318] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.849318] RSP: 0018:ffff88001daa3f88  EFLAGS: 00010296
[    1.849318] RAX: 00000000000000af RBX: 0000000000000002 RCX: 000000000812e380
[    1.849318] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000f773d000
[    1.849318] RBP: 00000000fffd1cf0 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.849318] R10: 00000000f777bb70 R11: 0000000000000000 R12: 0000000000000000
[    1.849318] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.849318] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f75966c0
[    1.849318] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.849318] CR2: ffff88001daa4018 CR3: 000000001da65000 CR4: 00000000000006f0
[    1.849318] Stack:
[    1.849318]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.849318]  00000000000000af 000000000812e380 0000000000000000 0000000000000008
[    1.849318]  00000000f773d000 00000000000000af 00000000f777bb70 0000000000000023
[    1.849318] Call Trace:
[    1.849318]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.849318] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.849318] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.849318]  RSP <ffff88001daa3f88>
[    1.849318] CR2: ffff88001daa4018
[    1.849318] ---[ end trace 7d7a8bfdc14fe3c2 ]---
[    1.882411] BUG: unable to handle kernel paging request at ffff88001daa8018
[    1.884212] IP: [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.884506] PGD 2d6c067 PUD 2d6d067 PMD 1fdf4067 PTE 800000001daa8060
[    1.884506] Oops: 0000 [#9] SMP DEBUG_PAGEALLOC
[    1.884506] Modules linked in:
[    1.884506] CPU: 0 PID: 86 Comm: bash Tainted: G      D        3.17.0-rc7+ #245
[    1.884506] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
[    1.884506] task: ffff88001da08000 ti: ffff88001daa4000 task.ti: ffff88001daa4000
[    1.884506] RIP: 0010:[<ffffffff8170703d>]  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.884506] RSP: 0018:ffff88001daa7f88  EFLAGS: 00010296
[    1.884506] RAX: 00000000000000af RBX: 0000000000000002 RCX: 000000000812e380
[    1.884506] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000f773d000
[    1.884506] RBP: 00000000fffd19e0 R08: ffffffff8138aa0b R09: 0000000000000000
[    1.884506] R10: 00000000f777bb70 R11: 0000000000000000 R12: 0000000000000000
[    1.884506] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.884506] FS:  0000000000000000(0000) GS:ffff88001fa00000(0063) knlGS:00000000f75966c0
[    1.884506] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.884506] CR2: ffff88001daa8018 CR3: 000000001da6e000 CR4: 00000000000006f0
[    1.884506] Stack:
[    1.884506]  0000000000000000 0000000000000000 0000000000000000 ffffffff8138aa0b
[    1.884506]  00000000000000af 000000000812e380 0000000000000000 0000000000000008
[    1.884506]  00000000f773d000 00000000000000af 00000000f777bb70 0000000000000023
[    1.884506] Call Trace:
[    1.884506]  [<ffffffff8138aa0b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.884506] Code: c0 41 52 50 fc 48 83 ec 48 48 89 7c 24 40 48 89 74 24 38 48 89 54 24 30 48 89 4c 24 28 48 89 44 24 20 66 66 90 8b 6d 00 66 66 90 <f7> 84 24 90 00 00 00 00 40 00 00 0f 85 2f 01 00 00 83 8c 24 8c 
[    1.884506] RIP  [<ffffffff8170703d>] ia32_sysenter_target+0x4d/0x5e
[    1.884506]  RSP <ffff88001daa7f88>
[    1.884506] CR2: ffff88001daa8018
[    1.884506] ---[ end trace 7d7a8bfdc14fe3c3 ]---
root@(none):~# [    2.388435] Switched to clocksource tsc

Qemu version:
QEMU emulator version 2.1.0 (Debian 2.1+dfsg-4ubuntu6), Copyright (c) 2003-2008 Fabrice Bellard

Invoked as:

$QEMU -machine pc,accel=kvm $ARGS -m 512 -net user,restrict=off -net nic,model=virtio -drive file=$QEMUIMAGE,index=0,media=disk,if=virtio -drive file=$QEMUIMAGEB,index=1,media=disk,if=virtio -kernel arch/x86/boot/bzImage -append "ro root=/dev/vda1 $KARGS $*"

The guest is a 32-bit Ubuntu 12.10, running the modern kernel of course.

Thanks,
Rusty.

