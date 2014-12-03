Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaLCSmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:42:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLCSmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:42:00 -0500
Date: Wed, 3 Dec 2014 13:41:11 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203184111.GA32005@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417540493.21136.3@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 12:14:53PM -0500, Chris Mason wrote:
 > On Tue, Dec 2, 2014 at 11:33 AM, Linus Torvalds 
 > <torvalds@linux-foundation.org> wrote:
 > > On Tue, Dec 2, 2014 at 6:13 AM, Mike Galbraith 
 > > <umgwanakikbuti@gmail.com> wrote:
 > > 
 > > At the same time, the whole "incapacitated by the rt throttle long
 > > enough for the hard lockup detector to trigger" commentary about that
 > > skip_clock_update issue does make me go "Hmmm..". It would certainly
 > > explain Dave's incomprehensible watchdog messages..
 > 
 > Dave's first email mentioned that he had panic on softlockup enabled, 
 > but even with that off the box wasn't recovering.

Not sure if I mentioned in an earlier post, but when I'm local to the machine,
I've disabled reboot-on-lockup, but yes the problem case is the
situation where it actually does lock up afterwards.

 > In my trinity runs here, I've gotten softlockup warnings where the box 
 > eventually recovered.  I'm wondering if some of the "bad" commits in 
 > the bisection are really false positives where the box would have been 
 > able to recover if we'd killed off all the trinity procs and given it 
 > time to breath.

So I've done multiple runs against 3.17-rc1 during bisecting, and hit
the case you describe, where I get a dump like below, and then it
eventually recovers. (Trinity then exits because the taint flag
changes).

I've been stuck on this kernel for a few days now trying to prove it
good/bad one way or the other, and I'm leaning towards good, given
that it recovers, even though the traces look similar.

	Dave


[ 9862.915562] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c29:13237]
[ 9862.915684] Modules linked in: 8021q garp stp tun fuse bnep hidp llc2 af_key nfnetlink can_bcm scsi_transport_iscsi can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc rfcomm bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep e1000e snd_seq coretemp hwmon x86_pkg_temp_thermal nfsd kvm_intel kvm snd_seq_device snd_pcm snd_timer ptp auth_rpcgss snd shpchp oid_registry crct10dif_pclmul crc32c_intel ghash_clmulni_intel usb_debug soundcore pps_core nfs_acl microcode serio_raw pcspkr lockd sunrpc
[ 9862.915987] CPU: 0 PID: 13237 Comm: trinity-c29 Not tainted 3.17.0-rc1+ #112
[ 9862.916046] task: ffff88022657dbc0 ti: ffff8800962b0000 task.ti: ffff8800962b0000
[ 9862.916071] RIP: 0010:[<ffffffff81042569>]  [<ffffffff81042569>] lookup_address_in_pgd+0x89/0xe0
[ 9862.916103] RSP: 0018:ffff8800962b36a8  EFLAGS: 00000202
[ 9862.917024] RAX: ffff88024da748d0 RBX: ffffffff81164c63 RCX: 0000000000000001
[ 9862.917956] RDX: ffff8800962b3740 RSI: ffff8801a3417000 RDI: 000000024da74000
[ 9862.918891] RBP: ffff8800962b36a8 R08: 00003ffffffff000 R09: ffff880000000000
[ 9862.919828] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff81375a47
[ 9862.920758] R13: ffff8800962b3618 R14: ffff8802441d81f0 R15: fffff70c86134602
[ 9862.921681] FS:  00007f06c569f740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[ 9862.922603] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9862.923526] CR2: 0000000002378590 CR3: 00000000a1ba3000 CR4: 00000000001407f0
[ 9862.924459] DR0: 00007f40a579e000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9862.925386] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 9862.926342] Stack:
[ 9862.927255]  ffff8800962b36b8 ffffffff810425e8 ffff8800962b36c8 ffffffff810426ab
[ 9862.928188]  ffff8800962b37c0 ffffffff810427a0 ffffffff810bfc5e ffff8800962b36f0
[ 9862.929127]  ffffffff810a89f5 ffff8800962b3768 ffffffff810c19b4 0000000000000002
[ 9862.930072] Call Trace:
[ 9862.931008]  [<ffffffff810425e8>] lookup_address+0x28/0x30
[ 9862.931958]  [<ffffffff810426ab>] _lookup_address_cpa.isra.9+0x3b/0x40
[ 9862.932913]  [<ffffffff810427a0>] __change_page_attr_set_clr+0xf0/0xab0
[ 9862.933869]  [<ffffffff810bfc5e>] ? put_lock_stats.isra.23+0xe/0x30
[ 9862.934831]  [<ffffffff810a89f5>] ? local_clock+0x25/0x30
[ 9862.935827]  [<ffffffff810c19b4>] ? __lock_acquire.isra.31+0x264/0xa60
[ 9862.936798]  [<ffffffff8109bfed>] ? finish_task_switch+0x7d/0x120
[ 9862.937765]  [<ffffffff810bfc5e>] ? put_lock_stats.isra.23+0xe/0x30
[ 9862.938730]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[ 9862.939698]  [<ffffffff8104418b>] kernel_map_pages+0x7b/0x120
[ 9862.940653]  [<ffffffff81178517>] get_page_from_freelist+0x497/0xaa0
[ 9862.941597]  [<ffffffff81179498>] __alloc_pages_nodemask+0x228/0xb20
[ 9862.942539]  [<ffffffff810a89f5>] ? local_clock+0x25/0x30
[ 9862.943469]  [<ffffffff810c19b4>] ? __lock_acquire.isra.31+0x264/0xa60
[ 9862.944411]  [<ffffffff8135fe50>] ? __radix_tree_preload+0x60/0xf0
[ 9862.945357]  [<ffffffff8135fe50>] ? __radix_tree_preload+0x60/0xf0
[ 9862.946326]  [<ffffffff811c14c1>] alloc_pages_vma+0xf1/0x1b0
[ 9862.947263]  [<ffffffff8118766e>] ? shmem_alloc_page+0x6e/0xc0
[ 9862.948205]  [<ffffffff8118766e>] shmem_alloc_page+0x6e/0xc0
[ 9862.949148]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[ 9862.950090]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[ 9862.951012]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[ 9862.951913]  [<ffffffff81382666>] ? __percpu_counter_add+0x86/0xb0
[ 9862.952811]  [<ffffffff811a4362>] ? __vm_enough_memory+0x62/0x1c0
[ 9862.953700]  [<ffffffff812eb0c7>] ? cap_vm_enough_memory+0x47/0x50
[ 9862.954591]  [<ffffffff81189f00>[ 9893.337880] [sched_delayed] sched: RT throttling activated
[ 9918.893057] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 24s! [swapper/1:0]
[ 9918.894352] Modules linked in: 8021q garp stp tun fuse bnep hidp llc2 af_key nfnetlink can_bcm scsi_transport_iscsi can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc rfcomm bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep e1000e snd_seq coretemp hwmon x86_pkg_temp_thermal nfsd kvm_intel kvm snd_seq_device snd_pcm snd_timer ptp auth_rpcgss snd shpchp oid_registry crct10dif_pclmul crc32c_intel ghash_clmulni_intel usb_debug soundcore pps_core nfs_acl microcode serio_raw pcspkr lockd sunrpc
[ 9918.901158] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.17.0-rc1+ #112
[ 9918.903863] task: ffff880242b716f0 ti: ffff88024240c000 task.ti: ffff88024240c000
[ 9918.905218] RIP: 0010:[<ffffffff81645849>]  [<ffffffff81645849>] cpuidle_enter_state+0x79/0x1c0
[ 9918.906591] RSP: 0000:ffff88024240fe60  EFLAGS: 00000246
[ 9918.907933] RAX: 0000000000000000 RBX: ffff880242b716f0 RCX: 0000000000000019
[ 9918.909264] RDX: 20c49ba5e353f7cf RSI: 000000000003cea4 RDI: 00536da522b45eb6
[ 9918.910594] RBP: ffff88024240fe98 R08: 000000008baf9f86 R09: 0000000000000000
[ 9918.911916] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88024240fdf0
[ 9918.913243] R13: ffffffff810bfc5e R14: ffff88024240fdd0 R15: 00000000000001e1
[ 9918.914523] FS:  0000000000000000(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[ 9918.915815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9918.917108] CR2: 000000000044bfa0 CR3: 0000000001c11000 CR4: 00000000001407e0
[ 9918.918414] DR0: 00007f40a579e000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9918.919710] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 9918.920998] Stack:
[ 9918.922273]  00000906c89bd5bb ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff004da8
[ 9918.923576]  ffff88024240c000 ffffffff81cae620 ffff88024240c000 ffff88024240fea8
[ 9918.924845]  ffffffff81645a47 ffff88024240ff10 ffffffff810b9fb4 ffff88024240ffd8
[ 9918.926108] Call Trace:
[ 9918.927351]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[ 9918.928602]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[ 9918.929850]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[ 9918.931086] Code: d0 48 89 df ff 50 48 41 89 c5 e8 b3 5c aa ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 a2 19 b0 ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c8 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[ 9918.933755] sending NMI to other CPUs:
[ 9918.935008] NMI backtrace for cpu 2
[ 9918.936208] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.17.0-rc1+ #112
[ 9918.938592] task: ffff880242b744d0 ti: ffff880242414000 task.ti: ffff880242414000
[ 9918.939793] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[ 9918.941003] RSP: 0018:ffff880242417e20  EFLAGS: 00000046
[ 9918.942191] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[ 9918.943369] RDX: 0000000000000000 RSI: ffff880242417fd8 RDI: 0000000000000002
[ 9918.944535] RBP: ffff880242417e50 R08: 000000008baf9f86 R09: 0000000000000000
[ 9918.945695] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[ 9918.946856] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242414000
[ 9918.948013] FS:  0000000000000000(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[ 9918.949175] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9918.950339] CR2: 000000000068f760 CR3: 0000000001c11000 CR4: 00000000001407e0
[ 9918.951515] DR0: 00007f40a579e000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9918.952678] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 9918.953840] Stack:
[ 9918.954988]  0000000242414000 d7251be6f43cb9e7 ffffe8ffff204da8 0000000000000005
[ 9918.956164]  ffffffff81cae620 0000000000000002 ffff880242417e98 ffffffff81645825
[ 9918.957345]  00000906cb95d0a1 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff204da8
[ 9918.958527] Call Trace:
[ 9918.959692]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[ 9918.960866]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[ 9918.962029]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[ 9918.963185]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[ 9918.964339] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[ 9918.966852] NMI backtrace for cpu 3
[ 9918.968059] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.17.0-rc1+ #112
[ 9918.970450] task: ffff880242b72de0 ti: ffff880242418000 task.ti: ffff880242418000
[ 9918.971652] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[ 9918.972862] RSP: 0018:ffff88024241be20  EFLAGS: 00000046
[ 9918.974045] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[ 9918.975212] RDX: 0000000000000000 RSI: ffff88024241bfd8 RDI: 0000000000000003
[ 9918.976349] RBP: ffff88024241be50 R08: 000000008baf9f86 R09: 0000000000000000
[ 9918.977463] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[ 9918.978550] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242418000
[ 9918.979628] FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[ 9918.980695] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9918.981739] CR2: 00007f37d766f050 CR3: 0000000001c11000 CR4: 00000000001407e0
[ 9918.982786] DR0: 00007f40a579e000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9918.983821] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 9918.984849] Stack:
[ 9918.985866]  0000000342418000 63d0570b22f343d2 ffffe8ffff404da8 0000000000000005
[ 9918.986911]  ffffffff81cae620 0000000000000003 ffff88024241be98 ffffffff81645825
[ 9918.987961]  00000906cb9636ab ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff404da8
[ 9918.989007] Call Trace:
[ 9918.990036]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[ 9918.991072]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[ 9918.992097]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[ 9918.993127]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[ 9918.994152] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 

