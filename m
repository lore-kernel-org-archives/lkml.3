Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaLRPzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:55:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48991 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbaLRPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:55:30 -0500
Date: Thu, 18 Dec 2014 10:54:19 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Message-ID: <1418918059.17358.6@mail.thefacebook.com>
In-Reply-To: <20141218051327.GA31988@redhat.com>
References: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com> <20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-18_06:2014-12-18,2014-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=145.191669734525
 compositescore=0.160988131301636 urlsuspect_oldscore=0.160988131301636
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.160988131301636 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412180152
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Dec 18, 2014 at 12:13 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Dec 15, 2014 at 03:46:41PM -0800, Linus Torvalds wrote:
>  > On Mon, Dec 15, 2014 at 10:21 AM, Linus Torvalds
>  > <torvalds@linux-foundation.org> wrote:
>  > >
>  > > So let's just fix it. Here's a completely untested patch.
>  >
>  > So after looking at this more, I'm actually really convinced that 
> this
>  > was a pretty nasty bug.
>  >
>  > I'm *not* convinced that it's necessarily *your* bug, but I still
>  > think it could be.
> 
> Bah, I was getting all optimistic.
> I came home this evening to a locked up machine.
> Serial console had a *lot* more traces than usual though.
> Full log below.  The 12xxx.xxxxxx traces we seemed to recover from,
> followed by silence for a while, before the real fun begins at 
> 157xx.xxxxxx

CPU 2 seems to be the one making the least progress.  I think he's 
calling fork and then trying to allocate a debug object for his 
hrtimer, eventually wandering into fill_pool from __debug_object_init():

static void fill_pool(void)
{
        gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
        struct debug_obj *new;
        unsigned long flags;

        if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
                return;

        if (unlikely(!obj_cache))
                return;

        while (obj_pool_free < ODEBUG_POOL_MIN_LEVEL) {

                new = kmem_cache_zalloc(obj_cache, gfp);
                if (!new)
                        return;

                raw_spin_lock_irqsave(&pool_lock, flags);
                hlist_add_head(&new->node, &obj_pool);
                obj_pool_free++;
                raw_spin_unlock_irqrestore(&pool_lock, flags);
        }
}

It doesn't seem to be making progress out of __slab_alloc+0x52f/0x58f, 
but maybe the slab code is just a victim of being called in a while 
loop with GFP_ATOMIC set from a starvation prone loop.  Can you please 
line up where 0x52f is in __slab_alloc?

It might be fun to run with CONFIG_DEBUG_OBJECTS off...Linus' patch 
clearly helped, I think we're off in a different bug now.

> [12669.359905] Code: 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 
> 41 56 41 55 41 54 53 48 83 ec 48 44 8b 25 48 80 be 00 65 48 8b 1c 25 
> 00 aa 00 00 <45> 85 e4 0f 84 ef 00 00 00 44 8b 1d e7 32 ab 01 49 89 
> fe 41 89
> [12669.361354] INFO: NMI handler 
> (arch_trigger_all_cpu_backtrace_handler) took too long to run: 88.798 
> msecs
> [15739.449422] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! 
> [kworker/u16:3:14112]
> [15739.450087] Modules linked in: bridge 8021q garp stp snd_seq_dummy 
> dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm 
> scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif 
> af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox 
> ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx 
> p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon 
> x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel 
> ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek 
> snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel 
> snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd 
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> [15739.454475] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G       
>       L 3.18.0+ #106
> [15739.456686] Workqueue: khelper __call_usermodehelper
> [15739.457473] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: 
> ffff880227eac000
> [15739.458231] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] 
> __slab_alloc+0x52f/0x58f
> [15739.459015] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
> [15739.459794] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 
> 00000000000002e0
> [15739.460570] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: 
> ffff880244802000
> [15739.461343] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 
> 0000000000000000
> [15739.462113] R10: 0000000000000092 R11: 0000000000000000 R12: 
> ffffffff810135bf
> [15739.462885] R13: ffff880227eaf878 R14: 0000000100160015 R15: 
> ffffffff8138278d
> [15739.463648] FS:  0000000000000000(0000) GS:ffff880245200000(0000) 
> knlGS:0000000000000000
> [15739.464431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15739.465203] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 
> 00000000001407e0
> [15739.465985] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15739.466766] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15739.467542] Stack:
> [15739.468308]  000000000000005c ffff880240f8d790 ffff880240f8d790 
> ffff880240f8dd00
> [15739.469106]  0000000180230020 000000010000000f ffffffff8112ee12 
> 0000000000000000
> [15739.469912]  ffff8802453d7260 000000020023001f ffff880227eaf968 
> ffffffff8138278d
> [15739.470717] Call Trace:
> [15739.471511]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
> [15739.472325]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15739.473138]  [<ffffffff811ce860>] ? set_track+0x70/0x140
> [15739.473947]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
> [15739.474757]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15739.475571]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
> [15739.476374]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
> [15739.477174]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
> [15739.477983]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
> [15739.478781]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
> [15739.479590]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
> [15739.480387]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
> [15739.481184]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15739.481983]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15739.482797]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
> [15739.483598]  [<ffffffff81076c37>] do_fork+0xe7/0x490
> [15739.484382]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15739.485160]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15739.485922]  [<ffffffff81077006>] kernel_thread+0x26/0x30
> [15739.486669]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
> [15739.487407]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
> [15739.488126]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15739.488834]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
> [15739.489529]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
> [15739.490197]  [<ffffffff81098c89>] kthread+0xf9/0x110
> [15739.490845]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15739.491474]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15739.492092]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
> [15739.492689]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15739.493288] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 
> 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 
> ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c 
> e8 22 46
> [15739.494617] sending NMI to other CPUs:
> [15739.495221] NMI backtrace for cpu 3
> [15739.495787] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G          
>    L 3.18.0+ #106
> [15739.497539] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: 
> ffff880180e04000
> [15739.498153] RIP: 0010:[<ffffffff810c6014>]  [<ffffffff810c6014>] 
> lock_acquire+0xb4/0x120
> [15739.498772] RSP: 0018:ffff880180e07dd8  EFLAGS: 00000246
> [15739.499382] RAX: ffff8801adac4470 RBX: 0000000000000246 RCX: 
> ffff8802455cff98
> [15739.499994] RDX: 00000000000006a0 RSI: 0000000000000000 RDI: 
> 0000000000000000
> [15739.500609] RBP: ffff880180e07e38 R08: 0000000000000000 R09: 
> 0000000000000000
> [15739.501224] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 0000000000000000
> [15739.501829] R13: 0000000000000000 R14: 0000000000000002 R15: 
> 0000000000000000
> [15739.502422] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) 
> knlGS:0000000000000000
> [15739.503021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15739.503621] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 
> 00000000001407e0
> [15739.504217] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15739.504812] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15739.505403] Stack:
> [15739.505988]  ffffffff8107a8e9 0000000000000000 ffff8801adac4470 
> 0000000000000246
> [15739.506603]  0000000127cc4da0 ffffffff81c0a098 ffff8801adac4470 
> ffffffff81c0a080
> [15739.507220]  ffffffff81c0a098 ffff8801adac4470 ffff8801adac4470 
> ffff8801adac4470
> [15739.507839] Call Trace:
> [15739.508448]  [<ffffffff8107a8e9>] ? do_wait+0xd9/0x280
> [15739.509064]  [<ffffffff817cf3d1>] _raw_read_lock+0x41/0x80
> [15739.509678]  [<ffffffff8107a8e9>] ? do_wait+0xd9/0x280
> [15739.510293]  [<ffffffff8107a8e9>] do_wait+0xd9/0x280
> [15739.510907]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
> [15739.511518]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
> [15739.512130]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
> [15739.512739] Code: d8 49 c1 e8 09 48 89 04 24 49 83 f0 01 41 83 e0 
> 01 e8 01 ef ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 
> 00 00 53 9d <48> 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 
> 00 00 65
> [15739.514121] NMI backtrace for cpu 1
> [15739.514769] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G          
>    L 3.18.0+ #106
> [15739.516771] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: 
> ffff880153a4c000
> [15739.517467] RIP: 0010:[<ffffffff810961f9>]  [<ffffffff810961f9>] 
> find_pid_ns+0x39/0x90
> [15739.518177] RSP: 0018:ffff880153a4fe78  EFLAGS: 00000207
> [15739.518884] RAX: ffff88024e517120 RBX: 0000000000000d7f RCX: 
> 0000000000000034
> [15739.519599] RDX: ffff880094be6500 RSI: ffffffff81c486c0 RDI: 
> 0000000000000d7f
> [15739.520316] RBP: ffff880153a4fe78 R08: 0000000000000000 R09: 
> 0000000000000000
> [15739.521036] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 0000000000000000
> [15739.521752] R13: ffff880096b4c470 R14: 0000000000000000 R15: 
> 0000000000000000
> [15739.522464] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) 
> knlGS:0000000000000000
> [15739.523181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15739.523882] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 
> 00000000001407e0
> [15739.524580] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15739.525269] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15739.525957] Stack:
> [15739.526632]  ffff880153a4fe88 ffffffff8109627f ffff880153a4ff68 
> ffffffff81086e2a
> [15739.527319]  ffffffff81086df8 0000000000000000 ffff880096b4c840 
> 0000000000000000
> [15739.527992]  ffff880100000000 000003e800000b21 ffff880094be64c0 
> 00007fff123fb870
> [15739.528656] Call Trace:
> [15739.529301]  [<ffffffff8109627f>] find_vpid+0x2f/0x50
> [15739.529947]  [<ffffffff81086e2a>] SYSC_kill+0xba/0x240
> [15739.530587]  [<ffffffff81086df8>] ? SYSC_kill+0x88/0x240
> [15739[15763.435537] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 
> 22s! [kworker/u16:3:14112]
> [15763.436252] Modules linked in: bridge 8021q garp stp snd_seq_dummy 
> dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm 
> scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif 
> af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox 
> ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx 
> p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon 
> x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel 
> ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek 
> snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel 
> snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd 
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> [15763.441025] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G       
>       L 3.18.0+ #106
> [15763.443320] Workqueue: khelper __call_usermodehelper
> [15763.444090] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: 
> ffff880227eac000
> [15763.444861] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] 
> __slab_alloc+0x52f/0x58f
> [15763.445654] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
> [15763.446422] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 
> 00000000000002e0
> [15763.447201] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: 
> ffff880244802000
> [15763.447985] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 
> 0000000000000000
> [15763.448764] R10: 0000000000000092 R11: 0000000000000000 R12: 
> ffffffff810135bf
> [15763.449545] R13: ffff880227eaf878 R14: 0000000100160015 R15: 
> ffffffff8138278d
> [15763.450319] FS:  0000000000000000(0000) GS:ffff880245200000(0000) 
> knlGS:0000000000000000
> [15763.451100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15763.451876] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 
> 00000000001407e0
> [15763.452662] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15763.453451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15763.454230] Stack:
> [15763.455003]  000000000000005c ffff880240f8d790 ffff880240f8d790 
> ffff880240f8dd00
> [15763.455818]  0000000180230020 000000010000000f ffffffff8112ee12 
> 0000000000000000
> [15763.456608]  ffff8802453d7260 000000020023001f ffff880227eaf968 
> ffffffff8138278d
> [15763.457393] Call Trace:
> [15763.458166]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
> [15763.458960]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15763.459753]  [<ffffffff811ce860>] ? set_track+0x70/0x140
> [15763.460544]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
> [15763.461338]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15763.462127]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
> [15763.462921]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
> [15763.463707]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
> [15763.464503]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
> [15763.465294]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
> [15763.466086]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
> [15763.466875]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
> [15763.467664]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15763.468458]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15763.469251]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
> [15763.470041]  [<ffffffff81076c37>] do_fork+0xe7/0x490
> [15763.470828]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15763.471603]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15763.472371]  [<ffffffff81077006>] kernel_thread+0x26/0x30
> [15763.473120]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
> [15763.473854]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
> [15763.474578]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15763.475287]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
> [15763.475975]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
> [15763.476640]  [<ffffffff81098c89>] kthread+0xf9/0x110
> [15763.477285]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15763.477915]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15763.478532]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
> [15763.479131]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15763.479741] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 
> 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 
> ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c 
> e8 22 46
> [15763.481087] sending NMI to other CPUs:
> [15763.481693] NMI backtrace for cpu 3
> [15763.482255] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G          
>    L 3.18.0+ #106
> [15763.484005] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: 
> ffff880180e04000
> [15763.484618] RIP: 0010:[<ffffffff810c47f5>]  [<ffffffff810c47f5>] 
> lock_acquired+0x45/0x370
> [15763.485234] RSP: 0018:ffff880180e07db8  EFLAGS: 00000046
> [15763.485841] RAX: 0000000000000001 RBX: ffff880227cc4da0 RCX: 
> 0000000000000001
> [15763.486453] RDX: 000000000000dbdb RSI: ffffffff810bcc8d RDI: 
> ffff880227cc4db8
> [15763.487068] RBP: ffff880180e07df8 R08: 0000000000000000 R09: 
> 0000000000000001
> [15763.487687] R10: 0000000000000000 R11: 0000000000000000 R12: 
> ffff8801adac4470
> [15763.488303] R13: ffff880227cc4db8 R14: 0000000000000046 R15: 
> ffff8801adac4460
> [15763.488909] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) 
> knlGS:0000000000000000
> [15763.489522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15763.490133] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 
> 00000000001407e0
> [15763.490747] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15763.491356] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15763.491964] Stack:
> [15763.492564]  0000000100000002 ffffffff810bcc8d ffff880180e07dd8 
> ffff880227cc4da0
> [15763.493194]  ffff880227cc4db8 0000000000000292 ffff8801adac4470 
> ffff8801adac4460
> [15763.493828]  ffff880180e07e38 ffffffff817cf0d5 ffffffff810bcc8d 
> 0000000000000296
> [15763.494464] Call Trace:
> [15763.495088]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
> [15763.495726]  [<ffffffff817cf0d5>] _raw_spin_lock_irqsave+0x75/0x90
> [15763.496364]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
> [15763.497005]  [<ffffffff810bcc8d>] remove_wait_queue+0x1d/0x40
> [15763.497645]  [<ffffffff8107a95b>] do_wait+0x14b/0x280
> [15763.498283]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
> [15763.498917]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
> [15763.499551]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
> [15763.500183] Code: b8 00 45 85 c9 0f 84 d8 00 00 00 65 4c 8b 24 25 
> 00 aa 00 00 45 8b 84 24 6c 07 00 00 45 85 c0 0f 85 be 00 00 00 49 89 
> fd 9c 41 5e <fa> 8b 35 1c 3a ab 01 41 c7 84 24 6c 07 00 00 01 00 00 
> 00 41 8b
> [15763.501611] NMI backtrace for cpu 1
> [15763.502274] CPU: 1 PID: 3298 Comm: trinity-c183 Tainted: G         
>     L 3.18.0+ #106
> [15763.504345] task: ffff880227de16d0 ti: ffff880071060000 task.ti: 
> ffff880071060000
> [15763.505065] RIP: 0033:[<000000336eebc2fc>]  [<000000336eebc2fc>] 
> 0x336eebc2fc
> [15763.505796] RSP: 002b:00007fff123fb868  EFLAGS: 00000246
> [15763.506522] RAX: 0000000000000000 RBX: 0000000000000d7b RCX: 
> ffffffffffffffff
> [15763.507257] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 
> 0000000000000d7b
> [15763.507994] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 
> 0000000000000000
> [15763.508729] R10: 0000000000000000 R11: 0000000000000246 R12: 
> 00007f7996cf6000
> [15763.509460] R13: 00007f7996cf6068 R14: 0000000000000000 R15: 
> 0000000000000000
> [15763.510188] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) 
> knlGS:0000000000000000
> [15763.510908] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15763.511612] CR2: 00007f7996f24220 CR3: 000000009a646000 CR4: 
> 00000000001407e0
> [15763.512319] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15763.513027] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15763.513727]
> [15763.514403] NMI backtrace for cpu 0
> [15763.515067] CPU: 0 PID: 1876 Comm: trinity-c189 Tainted: G         
>     L 3.18.0+ #106
> [15763.517087] task: ffff880096b4ada0 ti: ffff8802253d0000 task.ti: 
> ffff8802253d0000
> [15763.517776] RIP: 0010:[<[15779.306349] INFO: rcu_sched detected 
> stalls on CPUs/tasks:
> [15779.307024] 	(detected by 0, t=6002 jiffies, g=481360, c=481359, 
> q=0)
> [15779.307662] INFO: Stall ended before state dump start
> [15787.421647] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! 
> [kworker/u16:3:14112]
> [15787.422333] Modules linked in: bridge 8021q garp stp snd_seq_dummy 
> dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm 
> scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif 
> af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox 
> ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx 
> p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon 
> x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel 
> ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek 
> snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel 
> snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd 
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> [15787.426946] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G       
>       L 3.18.0+ #106
> [15787.429181] Workqueue: khelper __call_usermodehelper
> [15787.429945] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: 
> ffff880227eac000
> [15787.430719] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] 
> __slab_alloc+0x52f/0x58f
> [15787.431507] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
> [15787.432297] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 
> 00000000000002e0
> [15787.433094] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: 
> ffff880244802000
> [15787.433886] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 
> 0000000000000000
> [15787.434671] R10: 0000000000000092 R11: 0000000000000000 R12: 
> ffffffff810135bf
> [15787.435452] R13: ffff880227eaf878 R14: 0000000100160015 R15: 
> ffffffff8138278d
> [15787.436234] FS:  0000000000000000(0000) GS:ffff880245200000(0000) 
> knlGS:0000000000000000
> [15787.437028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15787.437816] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 
> 00000000001407e0
> [15787.438605] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15787.439400] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15787.440183] Stack:
> [15787.440959]  000000000000005c ffff880240f8d790 ffff880240f8d790 
> ffff880240f8dd00
> [15787.441792]  0000000180230020 000000010000000f ffffffff8112ee12 
> 0000000000000000
> [15787.442615]  ffff8802453d7260 000000020023001f ffff880227eaf968 
> ffffffff8138278d
> [15787.443422] Call Trace:
> [15787.444217]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
> [15787.445027]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15787.445833]  [<ffffffff811ce860>] ? set_track+0x70/0x140
> [15787.446647]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
> [15787.447449]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15787.448258]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
> [15787.449067]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
> [15787.449879]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
> [15787.450688]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
> [15787.451497]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
> [15787.452307]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
> [15787.453122]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
> [15787.453928]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15787.454733]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15787.455524]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
> [15787.456299]  [<ffffffff81076c37>] do_fork+0xe7/0x490
> [15787.457062]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15787.457826]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15787.458587]  [<ffffffff81077006>] kernel_thread+0x26/0x30
> [15787.459336]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
> [15787.460078]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
> [15787.460794]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15787.461495]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
> [15787.462182]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
> [15787.462850]  [<ffffffff81098c89>] kthread+0xf9/0x110
> [15787.463496]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15787.464124]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15787.464742]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
> [15787.465341]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15787.465947] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 
> 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 
> ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c 
> e8 22 46
> [15787.467291] sending NMI to other CPUs:
> [15787.467904] NMI backtrace for cpu 3
> [15787.468463] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G          
>    L 3.18.0+ #106
> [15787.470211] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: 
> ffff880180e04000
> [15787.470824] RIP: 0033:[<000000336eebc2fc>]  [<000000336eebc2fc>] 
> 0x336eebc2fc
> [15787.471440] RSP: 002b:00007fff123fb868  EFLAGS: 00000246
> [15787.472043] RAX: 0000000000000000 RBX: 0000000000000d7e RCX: 
> ffffffffffffffff
> [15787.472652] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 
> 0000000000000d7e
> [15787.473259] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 
> 0000000000000000
> [15787.473868] R10: 0000000000000000 R11: 0000000000000246 R12: 
> 00007f7997265000
> [15787.474468] R13: 00007f7997265068 R14: 0000000000000000 R15: 
> 0000000000000000
> [15787.475063] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) 
> knlGS:0000000000000000
> [15787.475660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15787.476254] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 
> 00000000001407e0
> [15787.476851] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15787.477442] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15787.478032]
> [15787.478615] NMI backtrace for cpu 1
> [15787.479205] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G          
>    L 3.18.0+ #106
> [15787.481052] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: 
> ffff880153a4c000
> [15787.481696] RIP: 0010:[<ffffffff817cfea0>]  [<ffffffff817cfea0>] 
> system_call+0x0/0x3
> [15787.482351] RSP: 0018:00007fff123fb868  EFLAGS: 00000046
> [15787.483007] RAX: 000000000000003d RBX: 0000000000000d7f RCX: 
> 000000336eebc2fc
> [15787.483674] RDX: 000000000000000b RSI: 00007fff123fb870 RDI: 
> 0000000000000d7f
> [15787.484338] RBP: 0000000000000000 R08: 00007f79977d8740 R09: 
> 0000000000000000
> [15787.485000] R10: 0000000000000000 R11: 0000000000000246 R12: 
> 00007f799716e000
> [15787.485658] R13: 00007f799716e068 R14: 0000000000000000 R15: 
> 0000000000000000
> [15787.486314] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) 
> knlGS:0000000000000000
> [15787.486979] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15787.487641] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 
> 00000000001407e0
> [15787.488311] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15787.488982] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15787.489650] Stack:
> [15787.490312]  000000000041401b 00007f79976944e8 00007f799716e000 
> 0000000000000001
> [15787.490999]  00007f799716e07c 00007f799716e000 0000000000000000 
> 00007f799716e07c
> [15787.491690]  0000000000416c03 00000000000066b2 0000000000000155 
> 00000000cccccccd
> [15787.492383] Call Trace:
> [15787.493063]  <UNK>
> [15787.493070] Code: 8b 3c 24 4c 8b 74 24 08 4c 8b 6c 24 10 4c 8b 64 
> 24 18 48 8b 6c 24 20 48 8b 5c 24 28 48 83 c4 30 e9 74 02 00 00 66 0f 
> 1f 44 00 00 <0f> 01 f8 65 48 89 24 25 80 a0 00 00 65 48 8b 24 25 08 
> aa 00 00
> [15787.495270] NMI backtrace for cpu 0
> [15787.495987] CPU: 0 PID: 1876 Comm: trinity-c189 Tainted: G         
>     L 3.18.0+ #106
> [15787.498136] task: ffff880096b4ada0 ti: ffff8802253d0000 task.ti: 
> ffff8802253d0000
> [15787.498870] RIP: 0010:[<ffffffff810c9698>]  [<ffffffff810c9698>] 
> do_raw_spin_trylock+0x8/0x50
> [15787.499618] RSP: 0018:ffff880244e03d00  EFLAGS: 00000092
> [15787.500344] RAX: ffff880096b4ada0 RBX: ffff880240c51578 RCX: 
> ffff880244fcff98
> [15787.501064] RDX: 0000000000004a4a RSI: 0000000000000018 RDI: 
> ffff880240c51578
> [15787.501780] RBP: ffff880244e03d38 R08: 0000000000000001 R09: 
> 0000000000000000
> [15787.502487] R10: 0000000000000000 R11: 0000000000000000 R12: 
> ffff880240c51590
> [15787.503190] R13: 0000000000000092 R14: ff[15811.407761] NMI 
> watchdog: BUG: soft lockup - CPU#2 stuck for 22s! 
> [kworker/u16:3:14112]
> [15811.408334] Modules linked in: bridge 8021q garp stp snd_seq_dummy 
> dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm 
> scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif 
> af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox 
> ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx 
> p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon 
> x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel 
> ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek 
> snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel 
> snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd 
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> [15811.412296] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G       
>       L 3.18.0+ #106
> [15811.414324] Workqueue: khelper __call_usermodehelper
> [15811.415025] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: 
> ffff880227eac000
> [15811.415733] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] 
> __slab_alloc+0x52f/0x58f
> [15811.416455] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
> [15811.417171] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 
> 00000000000002e0
> [15811.417913] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: 
> ffff880244802000
> [15811.418645] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 
> 0000000000000000
> [15811.419374] R10: 0000000000000092 R11: 0000000000000000 R12: 
> ffffffff810135bf
> [15811.420102] R13: ffff880227eaf878 R14: 0000000100160015 R15: 
> ffffffff8138278d
> [15811.420831] FS:  0000000000000000(0000) GS:ffff880245200000(0000) 
> knlGS:0000000000000000
> [15811.421572] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15811.422317] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 
> 00000000001407e0
> [15811.423070] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15811.423828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15811.424583] Stack:
> [15811.425327]  000000000000005c ffff880240f8d790 ffff880240f8d790 
> ffff880240f8dd00
> [15811.426099]  0000000180230020 000000010000000f ffffffff8112ee12 
> 0000000000000000
> [15811.426872]  ffff8802453d7260 000000020023001f ffff880227eaf968 
> ffffffff8138278d
> [15811.427657] Call Trace:
> [15811.428437]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
> [15811.429231]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15811.430025]  [<ffffffff811ce860>] ? set_track+0x70/0x140
> [15811.430814]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
> [15811.431600]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15811.432394]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
> [15811.433180]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
> [15811.433972]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
> [15811.434768]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
> [15811.435559]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
> [15811.436349]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
> [15811.437141]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
> [15811.437937]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15811.438725]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15811.439519]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
> [15811.440307]  [<ffffffff81076c37>] do_fork+0xe7/0x490
> [15811.441094]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15811.441871]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15811.442637]  [<ffffffff81077006>] kernel_thread+0x26/0x30
> [15811.443385]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
> [15811.444121]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
> [15811.444838]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15811.445538]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
> [15811.446219]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
> [15811.446883]  [<ffffffff81098c89>] kthread+0xf9/0x110
> [15811.447527]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15811.448159]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15811.448776]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
> [15811.449371]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15811.449968] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 
> 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 
> ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c 
> e8 22 46
> [15811.451292] sending NMI to other CPUs:
> [15811.451901] NMI backtrace for cpu 3
> [15811.452459] CPU: 3 PID: 1650 Comm: trinity-c76 Tainted: G          
>    L 3.18.0+ #106
> [15811.454206] task: ffff8801adac4470 ti: ffff880180e04000 task.ti: 
> ffff880180e04000
> [15811.454817] RIP: 0010:[<ffffffff810c511a>]  [<ffffffff810c511a>] 
> __lock_acquire.isra.31+0x21a/0x9f0
> [15811.455437] RSP: 0018:ffff880180e07d18  EFLAGS: 00000002
> [15811.456045] RAX: 0000000000000008 RBX: ffff8801adac4470 RCX: 
> 0000000000000000
> [15811.456660] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
> 0000000000000000
> [15811.457274] RBP: ffff880180e07d88 R08: 0000000000000001 R09: 
> 0000000000000000
> [15811.457889] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 000000000000014e
> [15811.458493] R13: 0000000000000000 R14: ffff880227cc4db8 R15: 
> ffff8801adac4be0
> [15811.459092] FS:  00007f79977d8740(0000) GS:ffff880245400000(0000) 
> knlGS:0000000000000000
> [15811.459699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15811.460303] CR2: 0000000000000001 CR3: 00000001c9593000 CR4: 
> 00000000001407e0
> [15811.460907] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15811.461507] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15811.462108] Stack:
> [15811.462702]  ffff880180e07d98 ffffffff810c512c 0000000000000102 
> 0000000000000000
> [15811.463325]  ffff880180e07d48 ffffffff810abaf5 ffff880180e07dc8 
> 0000000000000000
> [15811.463945]  ffff880180e07dd8 0000000000000046 0000000000000000 
> 0000000000000000
> [15811.464564] Call Trace:
> [15811.465173]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15811.465797]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15811.466421]  [<ffffffff810c5fff>] lock_acquire+0x9f/0x120
> [15811.467047]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
> [15811.467672]  [<ffffffff817cf0a9>] _raw_spin_lock_irqsave+0x49/0x90
> [15811.468300]  [<ffffffff810bcc8d>] ? remove_wait_queue+0x1d/0x40
> [15811.468924]  [<ffffffff810bcc8d>] remove_wait_queue+0x1d/0x40
> [15811.469546]  [<ffffffff8107a95b>] do_wait+0x14b/0x280
> [15811.470166]  [<ffffffff8107aeb0>] SyS_wait4+0x80/0x110
> [15811.470782]  [<ffffffff81078990>] ? task_stopped_code+0x60/0x60
> [15811.471398]  [<ffffffff817d0109>] tracesys_phase2+0xd4/0xd9
> [15811.472011] Code: e0 7f 44 09 d0 41 88 47 31 41 0f b6 47 32 83 e0 
> f0 45 85 c0 0f 95 c2 09 c8 c1 e2 03 09 d0 41 88 47 32 0f b7 55 18 41 
> 0f b7 47 32 <c1> e2 04 83 e0 0f 09 d0 66 41 89 47 32 e8 a4 69 fe ff 
> 4c 8b 4d
> [15811.473409] NMI backtrace for cpu 1
> [15811.474061] CPU: 1 PID: 2849 Comm: trinity-c95 Tainted: G          
>    L 3.18.0+ #106
> [15811.476098] task: ffff880096b4c470 ti: ffff880153a4c000 task.ti: 
> ffff880153a4c000
> [15811.476808] RIP: 0010:[<ffffffff810c63cf>]  [<ffffffff810c63cf>] 
> lock_release+0x1f/0x240
> [15811.477535] RSP: 0018:ffff880153a4fe40  EFLAGS: 00000246
> [15811.478253] RAX: ffff880096b4c470 RBX: 0000000000000000 RCX: 
> 00000000000003a0
> [15811.478982] RDX: ffffffff81086d0c RSI: 0000000000000001 RDI: 
> ffffffff81c50e20
> [15811.479707] RBP: ffff880153a4fe48 R08: 0000000000000000 R09: 
> 0000000000000000
> [15811.480419] R10: 0000000000000000 R11: 0000000000000000 R12: 
> ffff880094be64c0
> [15811.481115] R13: ffff880153a4feb0 R14: 0000000000000000 R15: 
> 0000000000000000
> [15811.481803] FS:  00007f79977d8740(0000) GS:ffff880245000000(0000) 
> knlGS:0000000000000000
> [15811.482504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15811.483200] CR2: 00007f7996f24220 CR3: 00000002251b4000 CR4: 
> 00000000001407e0
> [15811.483890] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15811.484562] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15811.485221] Stack:
> [15811.485862]  0000000000000000 ffff880153a4fe88 ffffffff81086d24 
> ffffffff81086ca5
> [15811.486521]  0000000000000d7f 0000000000000d7f 0000000000000000 
> ffff880096[15835.393872] NMI watchdog: BUG: soft lockup - CPU#2 stuck 
> for 22s! [kworker/u16:3:14112]
> [15835.394432] Modules linked in: bridge 8021q garp stp snd_seq_dummy 
> dlci tun fuse rfcomm hidp bnep af_key llc2 nfnetlink can_bcm 
> scsi_transport_iscsi can_raw sctp libcrc32c nfc caif_socket caif 
> af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox 
> ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx 
> p8023 psnap p8022 llc ax25 usb_debug cfg80211 rfkill coretemp hwmon 
> x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel 
> ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek 
> snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel 
> snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> snd_pcm e1000e ptp pps_core snd_timer snd soundcore shpchp nfsd 
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> [15835.398378] CPU: 2 PID: 14112 Comm: kworker/u16:3 Tainted: G       
>       L 3.18.0+ #106
> [15835.400379] Workqueue: khelper __call_usermodehelper
> [15835.401080] task: ffff8801c95f0000 ti: ffff880227eac000 task.ti: 
> ffff880227eac000
> [15835.401795] RIP: 0010:[<ffffffff817c3407>]  [<ffffffff817c3407>] 
> __slab_alloc+0x52f/0x58f
> [15835.402534] RSP: 0018:ffff880227eaf8f8  EFLAGS: 00000246
> [15835.403252] RAX: 0000000000000002 RBX: ffff8802304cf5c8 RCX: 
> 00000000000002e0
> [15835.403995] RDX: ffff88024520d7e0 RSI: 0000000000000000 RDI: 
> ffff880244802000
> [15835.404727] RBP: ffff880227eaf9e8 R08: 0000000000000000 R09: 
> 0000000000000000
> [15835.405456] R10: 0000000000000092 R11: 0000000000000000 R12: 
> ffffffff810135bf
> [15835.406185] R13: ffff880227eaf878 R14: 0000000100160015 R15: 
> ffffffff8138278d
> [15835.406916] FS:  0000000000000000(0000) GS:ffff880245200000(0000) 
> knlGS:0000000000000000
> [15835.407667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15835.408410] CR2: 0000000000000008 CR3: 0000000225ab9000 CR4: 
> 00000000001407e0
> [15835.409165] DR0: 00007fbe591ef000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [15835.409924] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000600
> [15835.410679] Stack:
> [15835.411433]  000000000000005c ffff880240f8d790 ffff880240f8d790 
> ffff880240f8dd00
> [15835.412226]  0000000180230020 000000010000000f ffffffff8112ee12 
> 0000000000000000
> [15835.413002]  ffff8802453d7260 000000020023001f ffff880227eaf968 
> ffffffff8138278d
> [15835.413784] Call Trace:
> [15835.414563]  [<ffffffff8112ee12>] ? __delayacct_tsk_init+0x22/0x50
> [15835.415358]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15835.416162]  [<ffffffff811ce860>] ? set_track+0x70/0x140
> [15835.416952]  [<ffffffff811cf35d>] ? init_object+0x3d/0x70
> [15835.417745]  [<ffffffff8138278d>] ? __debug_object_init+0x43d/0x450
> [15835.418533]  [<ffffffff811d295b>] kmem_cache_alloc+0x1cb/0x1f0
> [15835.419328]  [<ffffffff8138278d>] __debug_object_init+0x43d/0x450
> [15835.420114]  [<ffffffff813827bb>] debug_object_init+0x1b/0x20
> [15835.420904]  [<ffffffff810e66d5>] hrtimer_init+0x25/0xb0
> [15835.421701]  [<ffffffff8109f069>] __sched_fork+0x99/0x230
> [15835.422491]  [<ffffffff810a59c9>] sched_fork+0x29/0x200
> [15835.423282]  [<ffffffff8107568c>] copy_process.part.26+0x65c/0x1a40
> [15835.424077]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15835.424865]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15835.425658]  [<ffffffff8108e340>] ? call_helper+0x20/0x20
> [15835.426447]  [<ffffffff81076c37>] do_fork+0xe7/0x490
> [15835.427239]  [<ffffffff810c512c>] ? 
> __lock_acquire.isra.31+0x22c/0x9f0
> [15835.428018]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15835.428776]  [<ffffffff81077006>] kernel_thread+0x26/0x30
> [15835.429525]  [<ffffffff8108e1b4>] __call_usermodehelper+0x64/0x80
> [15835.430259]  [<ffffffff8109301a>] process_one_work+0x1fa/0x550
> [15835.430986]  [<ffffffff81092f98>] ? process_one_work+0x178/0x550
> [15835.431694]  [<ffffffff8109348b>] worker_thread+0x11b/0x490
> [15835.432374]  [<ffffffff81093370>] ? process_one_work+0x550/0x550
> [15835.433049]  [<ffffffff81098c89>] kthread+0xf9/0x110
> [15835.433694]  [<ffffffff810abaf5>] ? local_clock+0x25/0x30
> [15835.434328]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15835.434947]  [<ffffffff817cfe6c>] ret_from_fork+0x7c/0xb0
> [15835.435543]  [<ffffffff81098b90>] ? 
> kthread_create_on_node+0x250/0x250
> [15835.436148] Code: 00 02 00 00 49 c7 45 00 00 00 00 00 75 11 ff b5 
> 78 ff ff ff 9d e8 7a 6d 98 ff 4c 89 e0 eb 0f e8 70 6e 98 ff ff b5 78 
> ff ff ff 9d <4c> 89 e0 48 8b 55 c8 65 48 33 14 25 28 00 00 00 74 3c 
> e8 22 46
> [15835.437494] sending NMI to other CPUs:
> 
> 

