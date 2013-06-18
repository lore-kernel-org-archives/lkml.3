Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3FRVBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:01:50 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:40733 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932610Ab3FRVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:01:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <51C0CAB3.3090302@iki.fi>
Date: Wed, 19 Jun 2013 00:01:39 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [cryptomgr_test] BUG: unable to handle kernel NULL pointer dereference
 at (null)
References: <20130617003358.GB9596@localhost>
In-Reply-To: <20130617003358.GB9596@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Appears to be caused by some memory corruption. Changing from SLOB allocator to SLUB made this crash disappear.

Some different crashes with same config:

[    0.246152] cryptomgr_test (23) used greatest stack depth: 6400 bytes left
[    0.246929] cryptomgr_test (24) used greatest stack depth: 5384 bytes left
[    0.248851] modprobe (33) used greatest stack depth: 5376 bytes left
[    0.250351] alg: No test for crc32 (crc32-pclmul)
[    0.251669] BUG: unable to handle kernel paging request at ffff882006646e18
[    0.252007] IP: [<ffffffff81085f07>] task_active_pid_ns+0x17/0x30
[    0.252007] PGD 2af8067 PUD 0 
[    0.252007] Oops: 0000 [#1] SMP 
[    0.252007] Modules linked in:
[    0.252007] CPU: 0 PID: 43 Comm: kworker/u2:1 Not tainted 3.10.0-rc1-crash1-00048-gf9a31a2 #24
[    0.252007] task: ffff880006694000 ti: ffff880006698000 task.ti: ffff880006698000
[    0.252007] RIP: 0010:[<ffffffff81085f07>]  [<ffffffff81085f07>] task_active_pid_ns+0x17/0x30
[    0.252007] RSP: 0018:ffff880006699dd8  EFLAGS: 00010002
[    0.252007] RAX: ffff880006646e00 RBX: ffff880006694000 RCX: 0000000000000001
[    0.252007] RDX: 0000001fffffffe0 RSI: 0000000000098000 RDI: ffff880006655000
[    0.252007] RBP: ffff880006699dd8 R08: 000000000000000d R09: ffff8800066945d0
[    0.252007] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000011
[    0.252007] R13: 0000000000000000 R14: ffff88000704c000 R15: ffff880006693ff0
[    0.252007] FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
[    0.252007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.252007] CR2: ffff882006646e18 CR3: 0000000002015000 CR4: 00000000001407f0
[    0.252007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.252007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.252007] Stack:
[    0.252007]  ffff880006699e98 ffffffff81078054 ffffffff81077fc2 0000000000000011
[    0.252007]  0000000000000000 0000000000000000 0000000000000000 ffff880006699e78
[    0.252007]  0000000000000046 0000000000000000 ffffffff8106c5ef 0000000000000000
[    0.252007] Call Trace:
[    0.252007]  [<ffffffff81078054>] do_notify_parent+0x114/0x580
[    0.252007]  [<ffffffff81077fc2>] ? do_notify_parent+0x82/0x580
[    0.252007]  [<ffffffff8106c5ef>] ? do_exit+0x80f/0xa20
[    0.252007]  [<ffffffff8106c6be>] do_exit+0x8de/0xa20
[    0.252007]  [<ffffffff8107f628>] wait_for_helper+0x98/0xa0
[    0.252007]  [<ffffffff8107f590>] ? call_helper+0x20/0x20
[    0.252007]  [<ffffffff8196207c>] ret_from_fork+0x7c/0xb0
[    0.252007]  [<ffffffff8107f590>] ? call_helper+0x20/0x20
[    0.252007] Code: 1f 44 00 00 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 48 02 00 00 55 48 89 e5 48 85 c0 74 10 8b 50 04 48 c1 e2 05 <48> 8b 44 10 38 eb 0a 66 90 31 c0 66 0f 1f 44 00 00 5d c3 66 0f 
[    0.252007] RIP  [<ffffffff81085f07>] task_active_pid_ns+0x17/0x30
[    0.252007]  RSP <ffff880006699dd8>
[    0.252007] CR2: ffff882006646e18
[    0.252007] ---[ end trace 7caca246688ed8b9 ]---
[    0.252007] Kernel panic - not syncing: Fatal exception

...

[    0.328072] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.328683] BUG: unable to handle kernel paging request at ffff88000644cd98
[    0.329227] IP: [<ffff88000644cd98>] 0xffff88000644cd97
[    0.329690] PGD 2af8067 PUD 2af9067 PMD 80000000064001e3 
[    0.330182] Oops: 0011 [#1] SMP 
[    0.330449] Modules linked in:
[    0.330694] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc1-crash1-00048-gf9a31a2 #24
[    0.331314] task: ffff88000644d000 ti: ffff88000644e000 task.ti: ffff88000644e000
[    0.331899] RIP: 0010:[<ffff88000644cd98>]  [<ffff88000644cd98>] 0xffff88000644cd97
[    0.332004] RSP: 0018:ffff880007d03eb8  EFLAGS: 00010296
[    0.332004] RAX: ffff88000644cd98 RBX: ffff880007d0e880 RCX: 0000000000000002
[    0.332004] RDX: ffff880006a82560 RSI: ffff88000644d5d0 RDI: ffff880006a82560
[    0.332004] RBP: ffff880007d03f20 R08: 0000000000000002 R09: 0000000000000000
[    0.332004] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8203d000
[    0.332004] R13: ffff880006a6dd40 R14: 000000000000000a R15: 0000000000000008
[    0.332004] FS:  0000000000000000(0000) GS:ffff880007d00000(0000) knlGS:0000000000000000
[    0.332004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.332004] CR2: ffff88000644cd98 CR3: 0000000002015000 CR4: 00000000001407e0
[    0.332004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.332004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.332004] Stack:
[    0.332004]  ffffffff810db172 ffff880005252e80 ffff88000644d000 ffff8800070bfe80
[    0.332004]  ffff88000644d000 ffff88000644ffd8 ffff880007d0e8a8 0000000000000000
[    0.332004]  ffff88000644ffd8 0000000000000009 0000000000000101 ffffffff82007048
[    0.332004] Call Trace:
[    0.332004]  <IRQ> 
[    0.332004]  [<ffffffff810db172>] ? rcu_process_callbacks+0x322/0x5a0
[    0.332004]  [<ffffffff8106e8b0>] __do_softirq+0xd0/0x1a0
[    0.332004]  [<ffffffff8106eac9>] irq_exit+0x59/0xb0
[    0.332004]  [<ffffffff810219ea>] smp_apic_timer_interrupt+0x8a/0xa0
[    0.332004]  [<ffffffff81962eaf>] apic_timer_interrupt+0x6f/0x80
[    0.332004]  <EOI> 
[    0.332004]  [<ffffffff810b549e>] ? __lock_acquire+0xaee/0xcc0
[    0.332004]  [<ffffffff810b5c82>] ? lock_acquire+0xc2/0xe0
[    0.332004]  [<ffffffff81190d3d>] ? sysfs_addrm_start+0x1d/0x20
[    0.332004]  [<ffffffff8195e459>] mutex_lock_nested+0x69/0x3a0
[    0.332004]  [<ffffffff81190d3d>] ? sysfs_addrm_start+0x1d/0x20
[    0.332004]  [<ffffffff81961332>] ? _raw_spin_unlock+0x22/0x40
[    0.332004]  [<ffffffff81190c70>] ? sysfs_new_dirent+0xa0/0x150
[    0.332004]  [<ffffffff81190d3d>] sysfs_addrm_start+0x1d/0x20
[    0.332004]  [<ffffffff811910ba>] create_dir+0x6a/0xd0
[    0.332004]  [<ffffffff81191472>] sysfs_create_dir+0xc2/0xf0
[    0.332004]  [<ffffffff812b7d2a>] kobject_add_internal+0xda/0x210
[    0.332004]  [<ffffffff812b82ec>] kobject_add+0xac/0xe0
[    0.332004]  [<ffffffff81380b07>] device_add+0xf7/0x690
[    0.332004]  [<ffffffff8108b181>] ? __init_waitqueue_head+0x41/0x60
[    0.332004]  [<ffffffff813810b5>] device_register+0x15/0x20
[    0.332004]  [<ffffffff8135b220>] tty_register_device_attr+0x1a0/0x210
[    0.332004]  [<ffffffff810b33fd>] ? trace_hardirqs_on+0xd/0x10
[    0.332004]  [<ffffffff8135b29e>] tty_register_device+0xe/0x10
[    0.332004]  [<ffffffff8135b3da>] tty_register_driver+0x13a/0x220
[    0.332004]  [<ffffffff8135a51e>] ? __tty_alloc_driver+0x11e/0x1a0
[    0.332004]  [<ffffffff8214bbb8>] pty_init+0x176/0x3a3
[    0.332004]  [<ffffffff8214ba42>] ? tty_init+0x12e/0x12e
[    0.332004]  [<ffffffff81000282>] do_one_initcall+0x92/0x170
[    0.332004]  [<ffffffff82126fb2>] kernel_init_freeable+0xfc/0x189
[    0.332004]  [<ffffffff821267d8>] ? loglevel+0x31/0x31
[    0.332004]  [<ffffffff819486d0>] ? rest_init+0x150/0x150
[    0.332004]  [<ffffffff819486d9>] kernel_init+0x9/0xf0
[    0.332004]  [<ffffffff8196207c>] ret_from_fork+0x7c/0xb0
[    0.332004]  [<ffffffff819486d0>] ? rest_init+0x150/0x150
[    0.332004] Code: 00 00 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00 <60> 25 a8 06 00 88 ff ff a8 d8 45 06 00 88 ff ff 00 00 00 00 00 
[    0.332004] RIP  [<ffff88000644cd98>] 0xffff88000644cd97
[    0.332004]  RSP <ffff880007d03eb8>
[    0.332004] CR2: ffff88000644cd98
[    0.332004] ---[ end trace 638bf5007134f6ed ]---
[    0.332004] Kernel panic - not syncing: Fatal exception in interrupt

...

[    0.251053] alg: No test for crc32 (crc32-pclmul)
[    0.252426] BUG: unable to handle kernel paging request at ffff8800ffffffff
[    0.253010] IP: [<ffffffff81097aa5>] wake_up_process+0x5/0x40
[    0.253491] PGD 2af8067 PUD 0 
[    0.253777] Oops: 0000 [#1] SMP 
[    0.254109] Modules linked in:
[    0.254380] CPU: 0 PID: 42 Comm: cryptomgr_test Not tainted 3.10.0-rc1-crash1-00048-gf9a31a2 #24
[    0.255104] task: ffff880006684000 ti: ffff880006692000 task.ti: ffff880006692000
[    0.255718] RIP: 0010:[<ffffffff81097aa5>]  [<ffffffff81097aa5>] wake_up_process+0x5/0x40
[    0.256006] RSP: 0018:ffff880006693978  EFLAGS: 00010082
[    0.256006] RAX: ffff88000663bec8 RBX: ffff88000663bdc8 RCX: ffff88000663bdd0
[    0.256006] RDX: 0000000000000001 RSI: ffff88000705d860 RDI: ffff8800ffffffff
[    0.256006] RBP: ffff880006693980 R08: 0000000000000001 R09: 0000000000000001
[    0.256006] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880007074c00
[    0.256006] R13: ffff88000705d848 R14: 0000000000000005 R15: 0000000000000000
[    0.256006] FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
[    0.256006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.256006] CR2: ffff8800ffffffff CR3: 0000000002015000 CR4: 00000000001407f0
[    0.256006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.256006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.256006] Stack:
[    0.256006]  ffff88000663bdc8 ffff880006693990 ffffffff8107fe6f ffff8800066939c8
[    0.256006]  ffffffff810821d3 ffff8800070749c8 ffff880007074c00 ffff88000663bdc8
[    0.256006]  ffff8800070749c8 0000000000000008 ffff880006693a08 ffffffff8108241b
[    0.256006] Call Trace:
[    0.256006]  [<ffffffff8107fe6f>] wake_up_worker+0x1f/0x30
[    0.256006]  [<ffffffff810821d3>] insert_work+0xa3/0xc0
[    0.256006]  [<ffffffff8108241b>] __queue_work+0x22b/0x280
[    0.256006]  [<ffffffff810824ed>] queue_work_on+0x5d/0xb0
[    0.256006]  [<ffffffff8107f234>] call_usermodehelper_exec+0x1b4/0x1e0
[    0.256006]  [<ffffffff8107f98c>] __request_module+0x1bc/0x230
[    0.256006]  [<ffffffff81274ae7>] crypto_larval_lookup+0x87/0x180
[    0.256006]  [<ffffffff81274bfe>] crypto_alg_mod_lookup+0x1e/0x70
[    0.256006]  [<ffffffff81274cbc>] crypto_alloc_base+0x3c/0xb0
[    0.256006]  [<ffffffff8128af66>] cryptd_alloc_ablkcipher+0x56/0x90
[    0.256006]  [<ffffffff81031444>] ablk_init_common+0x14/0x30
[    0.256006]  [<ffffffff81031497>] ablk_init+0x37/0x40
[    0.256006]  [<ffffffff81125ee6>] ? __kmalloc_node+0x46/0x90
[    0.256006]  [<ffffffff8127444e>] __crypto_alloc_tfm+0xfe/0x150
[    0.256006]  [<ffffffff81277d4d>] crypto_alloc_ablkcipher+0x6d/0xc0
[    0.256006]  [<ffffffff8127e5b6>] alg_test_skcipher+0x26/0xc0
[    0.256006]  [<ffffffff8127ff85>] alg_test+0x225/0x290
[    0.256006]  [<ffffffff810b33fd>] ? trace_hardirqs_on+0xd/0x10
[    0.256006]  [<ffffffff8127cb00>] ? cryptomgr_probe+0xd0/0xd0
[    0.256006]  [<ffffffff8127cb23>] cryptomgr_test+0x23/0x40
[    0.256006]  [<ffffffff8108a711>] kthread+0xd1/0xe0
[    0.256006]  [<ffffffff8108a640>] ? __init_kthread_worker+0x70/0x70
[    0.256006]  [<ffffffff8196207c>] ret_from_fork+0x7c/0xb0
[    0.256006]  [<ffffffff8108a640>] ? __init_kthread_worker+0x70/0x70
[    0.256006] Code: 00 48 83 c4 10 44 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 00 55 48 8b 7f 08 48 89 e5 e8 33 fd ff ff 5d c3 90 55 48 89 e5 53 <48> 8b 07 48 89 fb a8 0c 74 11 be 23 06 00 00 48 c7 c7 86 bc d1 
[    0.256006] RIP  [<ffffffff81097aa5>] wake_up_process+0x5/0x40
[    0.256006]  RSP <ffff880006693978>
[    0.256006] CR2: ffff8800ffffffff
[    0.256006] ---[ end trace 05f41b3646c55953 ]---
[    0.256006] Kernel panic - not syncing: Fatal exception

-Jussi

On 17.06.2013 03:33, Fengguang Wu wrote:
> Greetings,
> 
> This seems to be an old bug that dates back at least to v2.6.37
> and is still in linux-next.
> 
> [    2.045020] cryptomgr_test (34) used greatest stack depth: 4904 bytes left
> [    2.046321] alg: No test for crc32 (crc32-pclmul)
> [    2.050060] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    2.051088] IP: [<ffffffff810a07ac>] wake_up_process+0xc/0x40
> [    2.051832] PGD 0 
> [    2.052009] Oops: 0000 [#1] SMP 
> [    2.052009] Modules linked in:
> [    2.052009] CPU: 1 PID: 46 Comm: cryptomgr_test Not tainted 3.10.0-rc4-00150-g4d3797d #48
> [    2.052009] task: ffff88000f733000 ti: ffff88000f744000 task.ti: ffff88000f744000
> [    2.052009] RIP: 0010:[<ffffffff810a07ac>]  [<ffffffff810a07ac>] wake_up_process+0xc/0x40
> [    2.052009] RSP: 0018:ffff88000f7458d8  EFLAGS: 00010096
> [    2.052009] RAX: ffff88000f6f1670 RBX: 0000000000000000 RCX: ffff88000f722aa8
> [    2.052009] RDX: 0000000000000001 RSI: ffff88000d859860 RDI: 0000000000000000
> [    2.052009] RBP: ffff88000f7458e8 R08: 0000000000000001 R09: 0000000000000001
> [    2.052009] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88000d991200
> [    2.052009] R13: ffff88000d859848 R14: 0000000000000005 R15: 0000000000000000
> [    2.052009] FS:  0000000000000000(0000) GS:ffff88000df00000(0000) knlGS:0000000000000000
> [    2.052009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.052009] CR2: 0000000000000000 CR3: 0000000002015000 CR4: 00000000000407e0
> [    2.052009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    2.052009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    2.052009] Stack:
> [    2.052009]  ffff88000f7458f8 ffff88000f722aa0 ffff88000f7458f8 ffffffff810888bf
> [    2.052009]  ffff88000f745938 ffffffff8108acf3 ffff88000f745938 ffffffff81977854
> [    2.052009]  ffff88000d991200 ffff88000f722aa0 ffff88000d991008 0000000000000008
> [    2.052009] Call Trace:
> [    2.052009]  [<ffffffff810888bf>] wake_up_worker+0x1f/0x30
> [    2.052009]  [<ffffffff8108acf3>] insert_work+0xa3/0xc0
> [    2.052009]  [<ffffffff81977854>] ? _raw_spin_lock+0x44/0x50
> [    2.052009]  [<ffffffff8108af3b>] __queue_work+0x22b/0x280
> [    2.052009]  [<ffffffff8108b00d>] queue_work_on+0x5d/0xb0
> [    2.052009]  [<ffffffff81087c64>] call_usermodehelper_exec+0x1c4/0x1f0
> [    2.052009]  [<ffffffff810883c6>] __request_module+0x1c6/0x230
> [    2.052009]  [<ffffffff8109714e>] ? up_read+0x1e/0x40
> [    2.052009]  [<ffffffff81280387>] crypto_larval_lookup+0x87/0x180
> [    2.052009]  [<ffffffff8128049e>] crypto_alg_mod_lookup+0x1e/0x70
> [    2.052009]  [<ffffffff8128055c>] crypto_alloc_base+0x3c/0xb0
> [    2.052009]  [<ffffffff81296686>] cryptd_alloc_ablkcipher+0x56/0x90
> [    2.052009]  [<ffffffff810314b8>] ablk_init_common+0x18/0x40
> [    2.052009]  [<ffffffff81031517>] ablk_init+0x37/0x40
> [    2.052009]  [<ffffffff8112f136>] ? __kmalloc_node+0x46/0x90
> [    2.052009]  [<ffffffff8127fcce>] __crypto_alloc_tfm+0xfe/0x150
> [    2.052009]  [<ffffffff8128361d>] crypto_alloc_ablkcipher+0x6d/0xc0
> [    2.052009]  [<ffffffff81289e76>] alg_test_skcipher+0x26/0xc0
> [    2.052009]  [<ffffffff8128b65b>] alg_test+0x18b/0x1f0
> [    2.052009]  [<ffffffff819781c5>] ? _raw_spin_unlock_irqrestore+0x55/0x80
> [    2.052009]  [<ffffffff810bc33d>] ? trace_hardirqs_on+0xd/0x10
> [    2.052009]  [<ffffffff81288490>] ? cryptomgr_probe+0xd0/0xd0
> [    2.052009]  [<ffffffff812884b7>] cryptomgr_test+0x27/0x50
> [    2.052009]  [<ffffffff810932f1>] kthread+0xd1/0xe0
> [    2.052009]  [<ffffffff8197821b>] ? _raw_spin_unlock_irq+0x2b/0x50
> [    2.052009]  [<ffffffff81093220>] ? __init_kthread_worker+0x70/0x70
> [    2.052009]  [<ffffffff81978ebc>] ret_from_fork+0x7c/0xb0
> [    2.052009]  [<ffffffff81093220>] ? __init_kthread_worker+0x70/0x70
> [    2.052009] Code: f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 00 55 48 8b 7f 08 48 89 e5 e8 33 fd ff ff 5d c3 90 55 48 89 e5 53 48 89 fb 48 83 ec 08 <48> 8b 07 a8 0c 74 15 be 23 06 00 00 48 c7 c7 98 e1 d1 81 e8 bc 
> [    2.052009] RIP  [<ffffffff810a07ac>] wake_up_process+0xc/0x40
> [    2.052009]  RSP <ffff88000f7458d8>
> [    2.052009] CR2: 0000000000000000
> [    2.052009] ---[ end trace 32e990773010885e ]---
> 
> git bisect  bad 4d3797d7e1861ac1af150a6189315786c5e1c820  # 04:04      0-  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect  bad 4d3797d7e1861ac1af150a6189315786c5e1c820  # 04:05      0-  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 04:06      0-  Linux 3.9
> git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 04:06      0-  Linux 3.8
> git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 04:06      0-  Linux 3.7
> git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 04:06      0-  Linux 3.6
> git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 04:06      0-  Linux 3.5
> git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 04:06      0-  Linux 3.4
> git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 04:06      0-  Linux 3.3
> git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 04:06      0-  Linux 3.2
> git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 04:06      0-  Linux 3.1
> git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 04:07      0-  Linux 3.0
> git bisect  bad 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf  # 04:14      0-  Linux 2.6.39
> git bisect  bad 521cb40b0c44418a4fd36dc633f575813d59a43d  # 04:20      0-  Linux 2.6.38
> git bisect  bad 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5  # 04:25      0-  Linux 2.6.37
> git bisect  bad 8177a9d79c0e942dcac3312f15585d0344d505a5  # 05:29      0-  lseek(fd, n, SEEK_END) does *not* go to eof - n
> git bisect  bad c04efed734409f5a44715b54a6ca1b54b0ccf215  # 05:35      0-  Add linux-next specific files for 20130607
> 
> Thanks,
> Fengguang
> 

