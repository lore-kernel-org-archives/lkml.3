Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab3DBAGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:06:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:37889 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab3DBAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:06:50 -0400
Date: Mon, 1 Apr 2013 20:07:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Christoph Lameter <cl@linux.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
Message-ID: <20130402000712.GE3606@windriver.com>
References: <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
 <1364236355.6345.185.camel@gandalf.local.home>
 <20130327025957.GA17125@lge.com>
 <1364355032.6345.200.camel@gandalf.local.home>
 <20130327061351.GB17125@lge.com>
 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com>
 <0000013dc63a9086-7d10c4a8-748c-4e19-829a-856d8d42c8eb-000000@email.amazonses.com>
 <5159B06B.30007@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5159B06B.30007@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RT LATENCY] 249 microsecond latency caused by slub's unfreeze_partials() code.] On 01/04/2013 (Mon 12:06) Paul Gortmaker wrote:

> On 13-04-01 11:32 AM, Christoph Lameter wrote:

[...]

> > Here is an updated patch. I will also send an updated fixup patch.
> 
> I'll give these some local testing today.

So, ignoring for the moment, the mismatched #ifdef args I'd reported a
couple hrs ago, since they do not matter for the case where
CONFIG_SLUB_CPU_PARTIAL = off/disabled, I'm seeing this when applying
these two commits to today's linux-next (since I'm assuming this is 3.10
material).

I can't say for sure it is these patches, and it hasn't happened every
reboot -- but it has happened twice in approximately four reboots.  The
1st time I missed capturing the log.  But this time I've captured it.

The finger pointed at __slab_free is the only reason I have to assume
it may be related to these two changes.  Both times, it got angry only when
I tried to reboot....

Paul.

--------------------------------------

root@canoehead:~# reboot

Broadcast message from root@canoehead
        (/dev/ttyS0) at 19:42 ...

Therpcbind: rpcbind terminating on signal. Restart with "rpcbind -w"
[ 7935.268075] NOHZ: local_softirq_pending 80
[ 7936.356160] general protection fault: 0000 [#1] SMP
[ 7936.361747] Modules linked in:
[ 7936.365184] CPU 15
[ 7936.367354] Pid: 5824, comm: reboot Not tainted 3.9.0-rc4-next-20130328+ #3 Intel Corporation S2600CP/S2600CP
[ 7936.378628] RIP: 0010:[<ffffffff817e30c6>]  [<ffffffff817e30c6>] __slab_free+0x242/0x2ba

[ 7936.387692] RSP: 0018:ffff88042bb69a58  EFLAGS: 00010082
[ 7936.393623] RAX: dead000000200200 RBX: ffff88082cf7ecb0 RCX: 0000000100240000
[ 7936.401582] RDX: dead000000100100 RSI: 0000000000240000 RDI: ffff88082f000580
[ 7936.409555] RBP: ffff88042bb69b08 R08: ffff88082f000580 R09: dead000000100100
[ 7936.417520] R10: dead000000200200 R11: ffffea0020ae7740 R12: ffffea0020b3df80
[ 7936.425492] R13: ffff88082cf7ed20 R14: 0000000100240000 R15: ffff88042f44cb00
[ 7936.433451] FS:  00007f6687342700(0000) GS:ffff88083f6e0000(0000) knlGS:0000000000000000
[ 7936.442476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7936.448890] CR2: 00007f2f603a06a8 CR3: 000000042a0a6000 CR4: 00000000000407e0
[ 7936.456849] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7936.464813] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7936.472786] Process reboot (pid: 5824, threadinfo ffff88042bb68000, task ffff88042c208f20)
[ 7936.482003] Stack:
[ 7936.484265]  ffff88042f403a00 0000000000000001 ffff880400240000 0000000000000000
[ 7936.492561]  0000000100240001 ffff88082f000580 ffff88083f6f2a30 0000000000000203
[ 7936.500864]  ffff880400240023 ffff880800000000 0000000100240024 0000000100240000
[ 7936.509160] Call Trace:
[ 7936.511907]  [<ffffffff810fa434>] ? __mod_zone_page_state+0x44/0x50
[ 7936.518924]  [<ffffffff8119ab43>] ? release_sysfs_dirent+0x73/0xf0
[ 7936.525844]  [<ffffffff811245c3>] kmem_cache_free+0x193/0x1b0
[ 7936.532253]  [<ffffffff8119ab43>] release_sysfs_dirent+0x73/0xf0
[ 7936.538961]  [<ffffffff8119b38a>] sysfs_addrm_finish+0x9a/0xc0
[ 7936.545468]  [<ffffffff8119b3de>] remove_dir+0x2e/0x40
[ 7936.551200]  [<ffffffff8119b88f>] sysfs_remove_dir+0x8f/0xa0
[ 7936.557537]  [<ffffffff812a48a6>] kobject_del+0x16/0x40
[ 7936.563358]  [<ffffffff812a4938>] kobject_cleanup+0x68/0x80
[ 7936.569574]  [<ffffffff812a47db>] kobject_put+0x2b/0x60
[ 7936.575426]  [<ffffffff817d7040>] cacheinfo_cpu_callback+0xa7/0xe2
[ 7936.582346]  [<ffffffff817f04dd>] notifier_call_chain+0x4d/0x70
[ 7936.588974]  [<ffffffff810619a9>] __raw_notifier_call_chain+0x9/0x10
[ 7936.596074]  [<ffffffff8103d5cb>] __cpu_notify+0x1b/0x40
[ 7936.601999]  [<ffffffff8103d600>] cpu_notify+0x10/0x20
[ 7936.607738]  [<ffffffff8103d739>] cpu_notify_nofail+0x9/0x20
[ 7936.614075]  [<ffffffff817d3c2b>] _cpu_down+0xfb/0x280
[ 7936.619808]  [<ffffffff8103d89f>] disable_nonboot_cpus+0x7f/0x110
[ 7936.626615]  [<ffffffff81050b16>] kernel_restart+0x16/0x60
[ 7936.632733]  [<ffffffff81050d1f>] SYSC_reboot+0x1af/0x260
[ 7936.638779]  [<ffffffff811580a0>] ? do_sync_work+0x90/0x90
[ 7936.644921]  [<ffffffff810eb609>] ? do_writepages+0x19/0x40
[ 7936.651161]  [<ffffffff810e1799>] ? __filemap_fdatawrite_range+0x49/0x50
[ 7936.658660]  [<ffffffff81144b63>] ? iput+0x43/0x190
[ 7936.664101]  [<ffffffff811580e0>] ? sync_inodes_one_sb+0x20/0x20
[ 7936.670824]  [<ffffffff811628b7>] ? iterate_bdevs+0xe7/0x100
[ 7936.677138]  [<ffffffff81050dd9>] SyS_reboot+0x9/0x10
[ 7936.682794]  [<ffffffff817f4552>] system_call_fastpath+0x16/0x1b
[ 7936.689493] Code: 99 00 00 e9 89 00 00 00 4d 85 ed 74 3c 49 8b 44 24 28 49 8b 54 24 20 49 b9 00 01 10 00 00 00 ad de 49 ba 00 02 20 00 00 00 ad de <48> 89 42 08 48 89 10 4d 89 4c 24 20 4d 89 54 24 28 49
[ 7936.711304] RIP  [<ffffffff817e30c6>] __slab_free+0x242/0x2ba
[ 7936.717724]  RSP <ffff88042bb69a58>
[ 7936.722196] ---[ end trace 8dd02e4a39a05014 ]---
[ 7936.728514] general protection fault: 0000 [#2] SMP
[ 7936.734075] Modules linked in:
[ 7936.737489] CPU 0
[ 7936.739547] Pid: 5682, comm: rc Tainted: G      D      3.9.0-rc4-next-20130328+ #3 Intel Corporation S2600CP/S2600CP
[ 7936.751504] RIP: 0010:[<ffffffff817e30c6>]  [<ffffffff817e30c6>] __slab_free+0x242/0x2ba
[ 7936.760562] RSP: 0018:ffff8808287e1cb8  EFLAGS: 00010086
[ 7936.766486] RAX: dead000000200200 RBX: ffff88082874fa98 RCX: 00000001002c0000
[ 7936.774445] RDX: dead000000100100 RSI: 00000000002c0000 RDI: ffff88082f000b40
[ 7936.782417] RBP: ffff8808287e1d68 R08: ffff88082f000b40 R09: dead000000100100
[ 7936.790376] R10: dead000000200200 R11: 0000000000000000 R12: ffffea0020a1d380
[ 7936.798342] R13: ffff88082874f648 R14: 00000001002c0000 R15: ffff88042f44c600
[ 7936.806302] FS:  0000000000000000(0000) GS:ffff88042fa00000(0000) knlGS:0000000000000000
[ 7936.815334] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7936.821743] CR2: 00007fcc7ca776a8 CR3: 0000000001c0b000 CR4: 00000000000407f0
[ 7936.829702] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7936.837661] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7936.845622] Process rc (pid: 5682, threadinfo ffff8808287e0000, task ffff88082b58f170)
[ 7936.854452] Stack:
[ 7936.856693]  ffff88042a3f9ee0 ffff88042a3f9ee0 ffff8808002c0000 0000000000000000
[ 7936.864986]  00000001002c0001 ffff88082f000b40 0000000000000246 0000000000000203
[ 7936.873280]  ffffea0020a1c320 ffffea00209f1ea0 ffff88082870cff8 00000001002c0000
[ 7936.881573] Call Trace:
[ 7936.884306]  [<ffffffff811096ae>] ? remove_vma+0x5e/0x70
[ 7936.890239]  [<ffffffff811245c3>] kmem_cache_free+0x193/0x1b0
[ 7936.896641]  [<ffffffff811096ae>] remove_vma+0x5e/0x70
[ 7936.902385]  [<ffffffff8110c68c>] exit_mmap+0xfc/0x140
[ 7936.908139]  [<ffffffff810375f8>] mmput+0x38/0xc0
[ 7936.913393]  [<ffffffff8103f2a7>] do_exit+0x267/0xad0
[ 7936.919043]  [<ffffffff8104b2aa>] ? recalc_sigpending+0x1a/0x60
[ 7936.925654]  [<ffffffff8104bbd2>] ? __set_task_blocked+0x32/0x80
[ 7936.932365]  [<ffffffff8104e2fa>] ? __set_current_blocked+0x3a/0x60
[ 7936.939358]  [<ffffffff8103fc8a>] do_group_exit+0x3a/0xa0
[ 7936.945388]  [<ffffffff8103fd02>] SyS_exit_group+0x12/0x20
[ 7936.951510]  [<ffffffff817f4552>] system_call_fastpath+0x16/0x1b
[ 7936.958198] Code: 99 00 00 e9 89 00 00 00 4d 85 ed 74 3c 49 8b 44 24 28 49 8b 54 24 20 49 b9 00 01 10 00 00 00 ad de 49 ba 00 02 20 00 00 00 ad de <48> 89 42 08 48 89 10 4d 89 4c 24 20 4d 89 54 24 28 49
[ 7936.979907] RIP  [<ffffffff817e30c6>] __slab_free+0x242/0x2ba
[ 7936.986326]  RSP <ffff8808287e1cb8>
[ 7936.990216] ---[ end trace 8dd02e4a39a05015 ]---
[ 7936.995372] Fixing recursive fault but reboot is needed!
[ 7967.655335] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 7967.663220] sr 5:0:0:0: CDB:
[ 7967.666538] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
[ 7967.674178] ata6.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
[ 7967.674178]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
[ 7967.690579] ata6.00: status: { DRDY }
[ 7967.694674] ata6: hard resetting link
[ 7973.049829] ata6: link is slow to respond, please be patient (ready=0)
[ 7977.695714] ata6: COMRESET failed (errno=-16)
[ 7977.700575] ata6: hard resetting link
[ 7983.055260] ata6: link is slow to respond, please be patient (ready=0)
[ 7987.701140] ata6: COMRESET failed (errno=-16)
[ 7987.706003] ata6: hard resetting link
[ 7993.060694] ata6: link is slow to respond, please be patient (ready=0)
[ 8022.736150] ata6: COMRESET failed (errno=-16)
[ 8022.741030] ata6: limiting SATA link speed to 1.5 Gbps
[ 8022.746767] ata6: hard resetting link
[ 8027.744864] ata6: COMRESET failed (errno=-16)
[ 8027.749725] ata6: reset failed, giving up
[ 8027.754210] ata6.00: disabled
[ 8027.757545] ata6: EH complete
