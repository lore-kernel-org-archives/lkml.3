Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab3KXXfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 18:35:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3KXXfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:35:36 -0500
Date: Mon, 25 Nov 2013 10:35:22 +1100
From: NeilBrown <neilb@suse.de>
To: fengguang.wu@intel.com
Cc: "Li, Shaohua" <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131125103522.6a1c1b36@notabene.brown>
In-Reply-To: <20131123032205.GB20794@localhost>
References: <20131123032205.GB20794@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hJ=E2a0uBG25BWOlhjjyyPK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hJ=E2a0uBG25BWOlhjjyyPK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Nov 2013 11:22:05 +0800 fengguang.wu@intel.com wrote:

> Shaohua,
>=20
> FYI, we are still seeing this bug.. dmesg attached.

Thanks for the report.  However the dmesg you attached doesn't mention:

     kernel BUG at drivers/md/raid5.c:693!

at all.  It is quite different.

The "BUG" it reports is that a spinlock is blocking for too long - over
99msecs.
As far as I can tell, this is a scheduling issue, possibly specific to qemu,
rather than a bug in raid5.

md/raid5 is calling md_wakeup_thread while holding a spinlock, and that see=
ms
to get lost in the scheduler for long enough that a different thread which
also wants the spinlock starts to complain.
It has always been safe to call 'wake_up' from under a spinlock before.

Ingo/Peter: is it considered OK to call wake_up while holding a spinlock?
Could "sleeping spinlocks" affect this at all? (some sample stack traces are
below).

Thanks,
NeilBrown

>=20
> 566c09c53455d7c4f1130928ef8071da1a24ea65 is the first bad commit
> commit 566c09c53455d7c4f1130928ef8071da1a24ea65
> Author: Shaohua Li <shli@kernel.org>
> Date:   Thu Nov 14 15:16:17 2013 +1100
>=20
>     raid5: relieve lock contention in get_active_stripe()
>    =20
>     get_active_stripe() is the last place we have lock contention. It has=
 two
>     paths. One is stripe isn't found and new stripe is allocated, the oth=
er is
>     stripe is found.
>    =20
>     The first path basically calls __find_stripe and init_stripe. It acce=
sses
>     conf->generation, conf->previous_raid_disks, conf->raid_disks,
>     conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
>     conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_lis=
t. Except
>     stripe_hashtbl and inactive_list, other fields are changed very rarel=
y.
>    =20
>     With this patch, we split inactive_list and add new hash locks. Each =
free
>     stripe belongs to a specific inactive list. Which inactive list is de=
termined
>     by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, =
it has a
>     lock_hash assigned. Stripe's inactive list is protected by a hash loc=
k, which
>     is determined by it's lock_hash too. The lock_hash is derivied from c=
urrent
>     stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be=
 assigned
>     to a specific lock_hash, so we can use new hash lock to protect strip=
e_hashtbl
>     list too. The goal of the new hash locks introduced is we can only us=
e the new
>     locks in the first path of get_active_stripe(). Since we have several=
 hash
>     locks, lock contention is relieved significantly.
>    =20
>     The first path of get_active_stripe() accesses other fields, since th=
ey are
>     changed rarely, changing them now need take conf->device_lock and all=
 hash
>     locks. For a slow path, this isn't a problem.
>    =20
>     If we need lock device_lock and hash lock, we always lock hash lock f=
irst. The
>     tricky part is release_stripe and friends. We need take device_lock f=
irst.
>     Neil's suggestion is we put inactive stripes to a temporary list and =
readd it
>     to inactive_list after device_lock is released. In this way, we add s=
tripes to
>     temporary list with device_lock hold and remove stripes from the list=
 with hash
>     lock hold. So we don't allow concurrent access to the temporary list,=
 which
>     means we need allocate temporary list for all participants of release=
_stripe.
>    =20
>     One downside is free stripes are maintained in their inactive list, t=
hey can't
>     across between the lists. By default, we have total 256 stripes and 8=
 lists, so
>     each list will have 32 stripes. It's possible one list has free strip=
e but
>     other list hasn't. The chance should be rare because stripes allocati=
on are
>     even distributed. And we can always allocate more stripes for cache, =
several
>     mega bytes memory isn't a big deal.
>    =20
>     This completely removes the lock contention of the first path of
>     get_active_stripe(). It slows down the second code path a little bit =
though
>     because we now need takes two locks, but since the hash lock isn't co=
ntended,
>     the overhead should be quite small (several atomic instructions). The=
 second
>     path of get_active_stripe() (basically sequential write or big reques=
t size
>     randwrite) still has lock contentions.
>    =20
>     Signed-off-by: Shaohua Li <shli@fusionio.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> :040000 040000 88fa28d1decc5454cf4d58421fa3eb12bc9ad524 5d1f104188f72b17d=
10cd569bf2924dab5d789cb M	drivers
> bisect run success
>=20
> # bad: [02ffe4cc90dce5a1bbee5daae98a40a431c29c6d] Merge 'yuanhan/slub-exp=
erimental' into devel-hourly-2013112217
> # good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
> git bisect start '02ffe4cc90dce5a1bbee5daae98a40a431c29c6d' '5e01dc7b26d9=
f24f39abace5da98ccbd6a5ceb52' '--'
> # good: [5cbb3d216e2041700231bcfc383ee5f8b7fc8b74] Merge branch 'akpm' (p=
atches from Andrew Morton)
> git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74
> # good: [d5ceede8dc86278d16dcad8f916ef323b5672bd8] drivers/rtc/rtc-hid-se=
nsor-time.c: use dev_get_platdata()
> git bisect good d5ceede8dc86278d16dcad8f916ef323b5672bd8
> # good: [ffd3c0260aeeb1fd4d36378d2e06e6410661dd0f] Merge branch 'for-linu=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good ffd3c0260aeeb1fd4d36378d2e06e6410661dd0f
> # good: [1ee2dcc2245340cf4ac94b99c4d00efbeba61824] Merge git://git.kernel=
.org/pub/scm/linux/kernel/git/davem/net
> git bisect good 1ee2dcc2245340cf4ac94b99c4d00efbeba61824
> # bad: [a50f09550a7dd58b4514630fec1676855084ec1f] Merge 'vireshk/cpufreq-=
next' into devel-hourly-2013112217
> git bisect bad a50f09550a7dd58b4514630fec1676855084ec1f
> # bad: [af2e2f328052082f58f041d574ed50c7f21c598f] Merge tag 'squashfs-upd=
ates' of git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next
> git bisect bad af2e2f328052082f58f041d574ed50c7f21c598f
> # good: [df12a3178d340319b1955be6b973a4eb84aff754] Merge commit 'dmaengin=
e-3.13-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine
> git bisect good df12a3178d340319b1955be6b973a4eb84aff754
> # good: [ed6a82546d2e8f6b5902269541733814d4adacc2] Merge branch 'acpi-hot=
plug'
> git bisect good ed6a82546d2e8f6b5902269541733814d4adacc2
> # bad: [6d6e352c80f22c446d933ca8103e02bac1f09129] Merge tag 'md/3.13' of =
git://neil.brown.name/md
> git bisect bad 6d6e352c80f22c446d933ca8103e02bac1f09129
> # bad: [30b8feb730f9b9b3c5de02580897da03f59b6b16] md/raid5: avoid deadloc=
k when raid5 array has unack badblocks during md_stop_writes.
> git bisect bad 30b8feb730f9b9b3c5de02580897da03f59b6b16
> # bad: [566c09c53455d7c4f1130928ef8071da1a24ea65] raid5: relieve lock con=
tention in get_active_stripe()
> git bisect bad 566c09c53455d7c4f1130928ef8071da1a24ea65
> # good: [02e5f5c0a0f726e66e3d8506ea1691e344277969] md: fix calculation of=
 stacking limits on level change.
> git bisect good 02e5f5c0a0f726e66e3d8506ea1691e344277969
> # good: [82e06c811163c4d853ed335d56c3378088bc89cc] wait: add wait_event_c=
md()
> git bisect good 82e06c811163c4d853ed335d56c3378088bc89cc
> # first bad commit: [566c09c53455d7c4f1130928ef8071da1a24ea65] raid5: rel=
ieve lock contention in get_active_stripe()


This process waited too long for a spinlock:


[   82.440547] BUG: spinlock lockup suspected on CPU#0, btrfs-submit-1/2938
[   82.440547]  lock: 0xffff88007f0aed20, .magic: dead4ead, .owner: md0_rai=
d5/2906, .owner_cpu: 2
[   82.440547] CPU: 0 PID: 2938 Comm: btrfs-submit-1 Not tainted 3.12.0-110=
88-gc710863 #1767
[   82.440547] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   82.440547]  0000000000000001 ffff8803cd1e3a10 ffffffff81a415f8 ffff8804=
081e8000
[   82.440547]  ffff8803cd1e3a30 ffffffff81a3a102 ffff88007f0aed20 00000000=
a08d1ad0
[   82.440547]  ffff8803cd1e3a58 ffffffff811055d4 ffff88007f0aed38 ffff8800=
7f0aed20
[   82.440547] Call Trace:
[   82.440547]  [<ffffffff81a415f8>] dump_stack+0x4d/0x66
[   82.440547]  [<ffffffff81a3a102>] spin_dump+0x91/0x96
[   82.440547]  [<ffffffff811055d4>] do_raw_spin_lock+0xc9/0x10e
[   82.440547]  [<ffffffff81a4c7b3>] _raw_spin_lock+0x5b/0x6d
[   82.440547]  [<ffffffff8189569b>] ? get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff8189569b>] get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff810fc068>] ? prepare_to_wait+0x6f/0x77
[   82.440547]  [<ffffffff81898fd9>] make_request+0x69a/0xac5
[   82.440547]  [<ffffffff818b58d1>] ? md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   82.440547]  [<ffffffff818b58d1>] md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff818b57ae>] ? md_make_request+0x68/0x2ce
[   82.440547]  [<ffffffff818906e5>] ? raid5_unplug+0x111/0x120
[   82.440547]  [<ffffffff814e68bf>] generic_make_request+0x9f/0xe0
[   82.440547]  [<ffffffff814e69ea>] submit_bio+0xea/0x12a
[   82.440547]  [<ffffffff8145a449>] run_scheduled_bios+0x26c/0x455
[   82.440547]  [<ffffffff8145a647>] pending_bios_fn+0x15/0x17
[   82.440547]  [<ffffffff81461925>] worker_loop+0x15c/0x4ee
[   82.440547]  [<ffffffff814617c9>] ? btrfs_queue_worker+0x280/0x280
[   82.440547]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   82.440547]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   82.440547]  [<ffffffff81a5487c>] ret_from_fork+0x7c/0xb0
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4


This process was holding it:

[   78.658626] NMI backtrace for cpu 2
[   78.658626] CPU: 2 PID: 2906 Comm: md0_raid5 Not tainted 3.12.0-11088-gc=
710863 #1767
[   78.658626] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   78.658626] task: ffff8804081e8000 ti: ffff8803cd1e6000 task.ti: ffff880=
3cd1e6000
[   78.658626] RIP: 0010:[<ffffffff81067501>]  [<ffffffff81067501>] pvclock=
_clocksource_read+0x10/0xa7
[   78.658626] RSP: 0018:ffff8803cd1e7b90  EFLAGS: 00000082
[   78.658626] RAX: 0000000000000002 RBX: ffff88040ebd4ac0 RCX: ffff8803cfb=
a57d8
[   78.658626] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88041f7=
e9080
[   78.658626] RBP: ffff8803cd1e7ba8 R08: 0000000000000000 R09: ffff8803cfb=
a57d8
[   78.658626] R10: 0000000000000008 R11: ffffffff810fbf46 R12: 00000000000=
00000
[   78.658626] R13: 0000000000000002 R14: ffff8803cfba57a8 R15: 00000000000=
00046
[   78.658626] FS:  0000000000000000(0000) GS:ffff88040ea00000(0000) knlGS:=
0000000000000000
[   78.658626] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   78.658626] CR2: 00000000006f86e4 CR3: 000000007f17e000 CR4: 00000000000=
006e0
[   78.658626] Stack:
[   78.658626]  ffff8803cfba57d8 ffff88040ebd4ac0 0000000000000000 ffff8803=
cd1e7bb8
[   78.658626]  ffffffff81066a05 ffff8803cd1e7bc8 ffffffff8103f9ce ffff8803=
cd1e7be8
[   78.658626]  ffffffff810f1f6d ffff88040ebd4ac0 00000000001d4ac0 ffff8803=
cd1e7c10
[   78.658626] Call Trace:
[   78.658626]  [<ffffffff81066a05>] kvm_clock_read+0x27/0x31
[   78.658626]  [<ffffffff8103f9ce>] sched_clock+0x9/0xd
[   78.658626]  [<ffffffff810f1f6d>] sched_clock_local+0x12/0x72
[   78.658626]  [<ffffffff810f20f5>] sched_clock_cpu+0xc1/0xcc
[   78.658626]  [<ffffffff810f2197>] local_clock+0x2a/0x5a
[   78.658626]  [<ffffffff81101202>] lock_release_holdtime.part.7+0xf/0xd9
[   78.658626]  [<ffffffff810fbf68>] ? __wake_up+0x44/0x4c
[   78.658626]  [<ffffffff811037b0>] lock_release+0x185/0x1ed
[   78.658626]  [<ffffffff81a4cb3e>] _raw_spin_unlock_irqrestore+0x24/0x5e
[   78.658626]  [<ffffffff810fbf68>] __wake_up+0x44/0x4c
[   78.658626]  [<ffffffff818b86f8>] md_wakeup_thread+0x55/0x58
[   78.658626]  [<ffffffff8188e8eb>] raid5_wakeup_stripe_thread+0xab/0x169
[   78.658626]  [<ffffffff81897eba>] raid5d+0x1ac/0x4a8
[   78.658626]  [<ffffffff811012bf>] ? lock_release_holdtime.part.7+0xcc/0x=
d9
[   78.658626]  [<ffffffff818b8c9c>] md_thread+0x10f/0x125
[   78.658626]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   78.658626]  [<ffffffff818b8b8d>] ? md_register_thread+0xd5/0xd5
[   78.658626]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   78.658626]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   78.658626]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   78.658626]  [<ffffffff81a5487c>] ret_from_fork+0x7c/0xb0
[   78.658626]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   78.658626] Code: 47 1d 66 66 90 0f ae e8 8b 17 f6 c2 01 75 e6 39 d1 75 =
e2 22 05 ad b8 2e 01 5d c3 55 48 89 e5 41 54 53 51 8b 37 66 66 90 0f ae e8 =
<0f> 31 48 c1 e2 20 89 c0 0f be 4f 1c 48 09 c2 48 2b 57 08 44 8b=20
[   78.658626] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 99.903 msecs


--Sig_/hJ=E2a0uBG25BWOlhjjyyPK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpKNOjnsnt1WYoG5AQJ1EBAAq9fSn2vDlwaaFP3I505l748JQ2UeAMNw
TE8s3tgU7hdwvodM0yVV6U1YKQlpnpdP3ucW8VuO+U3WjMXAkp50YDEy8jWRQnjF
GL9G3ovHl8yxO1EmqrVwOtAOnzwonlfQbFKRtRKI/7FvW1jSvxnGh60ylBI2r4AN
W5ubdpfqywBA8w8IHBoIkq+wjAWH2v463n5QwvbwbQm7F2K0RS37pa1Z/88Bvo9+
+rHKv8CZYqILVJqrlRqZJ6Fi0oVKCrh51nlFGJc1iOmxQ8nbcMo1JRbTw5EAltYu
xt42A+qWI9beFDrcXdFKymycO11lN5iEUPtTy0CSPpt41pnLc9XSMbyur7h+WtU7
hkhsNqgebHBf1h0z/LFEX9RfWhbGp3wLr9UwHBKSdndxkKraWZqjE1728bXjm+8s
rn0pWQrCZLGcO7UtHt5bJ12kpU5w5x6pDtRWt6QvIhTH53MHF7tUXZg/ec8uFpcz
7UJlcq23aftJllbIsqSp3d5dutf84dnb91qsN8WgKDSUCXHGZjlSqoCd0SoQ03z4
gkMLco4SZisv6vA+mcef0MW2dP/s/CfVTKbC8PfZNNTrjQOHpYR5gMpYqbykKuap
77kqQc1Rk+oXPdwt1I3CRQH1pp1rRjmeF7Wv4ybGrFtNvOmEc+DbIy52OsxGKJpa
idioxl0lOyg=
=ZwTb
-----END PGP SIGNATURE-----

--Sig_/hJ=E2a0uBG25BWOlhjjyyPK--
