Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3GAR6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:58:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3GAR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:58:00 -0400
Date: Mon, 1 Jul 2013 13:57:34 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        axboe@kernel.dk
Subject: block layer softlockup
Message-ID: <20130701175734.GA13641@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>, axboe@kernel.dk
References: <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628035437.GB29338@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:54:37PM +1000, Dave Chinner wrote:
 > On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
 > > On Thu, Jun 27, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
 > > >
 > > > Right, that will be what is happening - the entire system will go
 > > > unresponsive when a sync call happens, so it's entirely possible
 > > > to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
 > > > trying to get the lock because of the way ticket spinlocks work...
 > > 
 > > So what made it all start happening now? I don't recall us having had
 > > these kinds of issues before..
 > 
 > Not sure - it's a sudden surprise for me, too. Then again, I haven't
 > been looking at sync from a performance or lock contention point of
 > view any time recently.  The algorithm that wait_sb_inodes() is
 > effectively unchanged since at least 2009, so it's probably a case
 > of it having been protected from contention by some external factor
 > we've fixed/removed recently.  Perhaps the bdi-flusher thread
 > replacement in -rc1 has changed the timing sufficiently that it no
 > longer serialises concurrent sync calls as much....

This mornings new trace reminded me of this last sentence. Related ?

BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child1:7219]
Modules linked in: lec sctp dlci 8021q garp mpoa dccp_ipv4 dccp bridge stp tun snd_seq_dummy fuse bnep rfcomm nfnetlink scsi_transport_iscsi hidp ipt_ULOG can_raw can_bcm af_key af_rxrpc rose ipx p8023 p8022 atm llc2 pppoe pppox ppp_generic slhc bluetooth rds af_802154 appletalk nfc psnap phonet llc rfkill netrom x25 ax25 irda can caif_socket caif crc_ccitt coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
irq event stamp: 3181543
hardirqs last  enabled at (3181542): [<ffffffff816edc60>] restore_args+0x0/0x30
hardirqs last disabled at (3181543): [<ffffffff816f676a>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (1794686): [<ffffffff810542e4>] __do_softirq+0x194/0x440
softirqs last disabled at (1794689): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
CPU: 0 PID: 7219 Comm: trinity-child1 Not tainted 3.10.0+ #38
task: ffff8801d3a0ca40 ti: ffff88022e07e000 task.ti: ffff88022e07e000
RIP: 0010:[<ffffffff816ed037>]  [<ffffffff816ed037>] _raw_spin_unlock_irqrestore+0x67/0x80
RSP: 0018:ffff880244803db0  EFLAGS: 00000286
RAX: ffff8801d3a0ca40 RBX: ffffffff816edc60 RCX: 0000000000000002
RDX: 0000000000004730 RSI: ffff8801d3a0d1c0 RDI: ffff8801d3a0ca40
RBP: ffff880244803dc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff880244803d28
R13: ffffffff816f676f R14: ffff880244803dc0 R15: ffff88023d1307f8
FS:  00007f00e7ab6740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002f18000 CR3: 000000022d31b000 CR4: 00000000001407f0
DR0: 0000000000ad9000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff88023e21a680 0000000000000000 ffff880244803df0 ffffffff812da4c1
 ffff88023e21a680 0000000000000000 0000000000000000 0000000000000000
 ffff880244803e00 ffffffff812da4e0 ffff880244803e60 ffffffff8149ba13
Call Trace:
 <IRQ> 

 [<ffffffff812da4c1>] blk_end_bidi_request+0x51/0x60
 [<ffffffff812da4e0>] blk_end_request+0x10/0x20
 [<ffffffff8149ba13>] scsi_io_completion+0xf3/0x6e0
 [<ffffffff81491a60>] scsi_finish_command+0xb0/0x110
 [<ffffffff8149b81f>] scsi_softirq_done+0x12f/0x160
 [<ffffffff812e1e08>] blk_done_softirq+0x88/0xa0
 [<ffffffff8105424f>] __do_softirq+0xff/0x440
 [<ffffffff8105474d>] irq_exit+0xcd/0xe0
 [<ffffffff816f760b>] smp_apic_timer_interrupt+0x6b/0x9b
 [<ffffffff816f676f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 

 [<ffffffff816edc60>] ? retint_restore_args+0xe/0xe
 [<ffffffff812ff465>] ? idr_find_slowpath+0x115/0x150
 [<ffffffff812ff475>] ? idr_find_slowpath+0x125/0x150
 [<ffffffff8108ceb0>] ? scheduler_tick_max_deferment+0x60/0x60
 [<ffffffff816f1765>] ? add_preempt_count+0xa5/0xf0
 [<ffffffff810fc8ea>] rcu_lockdep_current_cpu_online+0x3a/0xa0
 [<ffffffff812ff475>] idr_find_slowpath+0x125/0x150
 [<ffffffff812a3879>] ipcget+0x89/0x380
 [<ffffffff810b76e5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff812a4f76>] SyS_msgget+0x56/0x60
 [<ffffffff812a4560>] ? rcu_read_lock+0x80/0x80
 [<ffffffff812a43a0>] ? sysvipc_msg_proc_show+0xd0/0xd0
 [<ffffffff816f5d14>] tracesys+0xdd/0xe2
 [<ffffffffa00000b4>] ? libcrc32c_mod_fini+0x48/0xf94 [libcrc32c]
Code: 00 e8 9e 47 00 00 65 48 8b 04 25 f0 b9 00 00 48 8b 80 38 e0 ff ff a8 08 75 13 5b 41 5c 5d c3 0f 1f 44 00 00 e8 7b a7 9c ff 53 9d <eb> cf 0f 1f 80 00 00 00 00 e8 bb ea ff ff eb df 66 0f 1f 84 00 


My read of this is that block layer was taking a *long* time to do something,
and prevented the msgget from progressing within the watchdog cutoff time.

Plausible ?

	Dave
