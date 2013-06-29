Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3F2UNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3F2UNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:13:30 -0400
Date: Sat, 29 Jun 2013 16:13:11 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130629201311.GA23838@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628035825.GC29338@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:58:25PM +1000, Dave Chinner wrote:

 > > Oh, that's easy enough to fix. It's just changing the wait_sb_inodes
 > > loop to use a spin_trylock(&inode->i_lock), moving the inode to
 > > the end of the sync list, dropping all locks and starting again...
 > 
 > New version below, went through xfstests with lockdep enabled this
 > time....

So with that patch, those two boxes have now been fuzzing away for
over 24hrs without seeing that specific sync related bug.

I did see the trace below, but I think that's a different problem..
Not sure who to point at for that one though. Linus?

I'm not even sure why cpu_stopper_thread is even running at that point.

[ 1547.161076] hrtimer: interrupt took 4539 ns
[ 1583.293902] BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:28]
[ 1583.293905] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:7]
[ 1583.293932] Modules linked in: tun hidp bnep nfnetlink rfcomm scsi_transport_iscsi ipt_ULOG can_raw af_rxrpc netrom nfc can_bcm can appletalk ipx p8023 af_key psnap irda p8022 rose caif_socket caif ax25 crc_ccitt llc2 af_802154 llc rds bluetooth phonet rfkill pppoe pppox atm ppp_generic slhc x25 coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode snd_hda_intel pcspkr snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e snd_pcm ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
[ 1583.293932] irq event stamp: 108950
[ 1583.293937] hardirqs last  enabled at (108949): [<ffffffff816e9320>] restore_args+0x0/0x30
[ 1583.293940] hardirqs last disabled at (108950): [<ffffffff816f1dea>] apic_timer_interrupt+0x6a/0x80
[ 1583.293943] softirqs last  enabled at (108948): [<ffffffff810541d4>] __do_softirq+0x194/0x440
[ 1583.293945] softirqs last disabled at (108943): [<ffffffff8105463d>] irq_exit+0xcd/0xe0
[ 1583.293947] CPU: 0 PID: 7 Comm: migration/0 Not tainted 3.10.0-rc7+ #5
[ 1583.293948] task: ffff880244190000 ti: ffff88024418a000 task.ti: ffff88024418a000
[ 1583.293952] RIP: 0010:[<ffffffff810dd856>]  [<ffffffff810dd856>] stop_machine_cpu_stop+0x86/0x110
[ 1583.293953] RSP: 0018:ffff88024418bce8  EFLAGS: 00000293
[ 1583.293953] RAX: 0000000000000001 RBX: ffffffff816e9320 RCX: 0000000000000000
[ 1583.293954] RDX: ffff88024418bf00 RSI: ffffffff81084b2c RDI: ffff8801ecd51b88
[ 1583.293954] RBP: ffff88024418bd10 R08: 0000000000000001 R09: 0000000000000000
[ 1583.293955] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88024418bc58
[ 1583.293956] R13: ffff88024418bfd8 R14: ffff88024418a000 R15: 0000000000000046
[ 1583.293956] FS:  0000000000000000(0000) GS:ffff880245600000(0000) knlGS:0000000000000000
[ 1583.293957] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1583.293958] CR2: 0000000006ff0158 CR3: 00000001ea0df000 CR4: 00000000001407f0
[ 1583.293958] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1583.293959] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1583.293959] Stack:
[ 1583.293961]  ffff8802457cd880 ffff8801ecd51ac0 ffff8801ecd51b88 ffffffff810dd7d0
[ 1583.293963]  ffff88024418bfd8 ffff88024418bde0 ffffffff810dd6ed ffff88024418bfd8
[ 1583.293965]  ffff8802457cd8d0 000000000000017f ffff88024418bd48 00000007810b463e
[ 1583.293965] Call Trace:
[ 1583.293967]  [<ffffffff810dd7d0>] ? cpu_stopper_thread+0x180/0x180
[ 1583.293969]  [<ffffffff810dd6ed>] cpu_stopper_thread+0x9d/0x180
[ 1583.293971]  [<ffffffff816e86d5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[ 1583.293973]  [<ffffffff810b75b5>] ? trace_hardirqs_on_caller+0x115/0x1e0
[ 1583.293976]  [<ffffffff81084b2c>] smpboot_thread_fn+0x1ac/0x320
[ 1583.293978]  [<ffffffff81084980>] ? lg_global_unlock+0xe0/0xe0
[ 1583.293981]  [<ffffffff8107a88d>] kthread+0xed/0x100
[ 1583.293983]  [<ffffffff816e597f>] ? wait_for_completion+0xdf/0x110
[ 1583.293985]  [<ffffffff8107a7a0>] ? insert_kthread_work+0x80/0x80
[ 1583.293987]  [<ffffffff816f10dc>] ret_from_fork+0x7c/0xb0
[ 1583.293989]  [<ffffffff8107a7a0>] ? insert_kthread_work+0x80/0x80
[ 1583.294007] Code: f0 ff 4b 24 0f 94 c2 84 d2 44 89 e0 74 12 8b 43 20 8b 53 10 83 c0 01 89 53 24 89 43 20 44 89 e0 83 f8 04 74 20 f3 90 44 8b 63 20 <41> 39 c4 74 f0 41 83 fc 02 75 bf fa e8 49 66 fd ff eb c2 0f 1f 


