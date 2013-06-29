Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3F2XpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3F2XpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:45:14 -0400
Date: Sat, 29 Jun 2013 19:44:49 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130629234449.GA30554@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130629201311.GA23838@redhat.com>
 <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 03:23:48PM -0700, Linus Torvalds wrote:

 > > So with that patch, those two boxes have now been fuzzing away for
 > > over 24hrs without seeing that specific sync related bug.
 > 
 > Ok, so at least that confirms that yes, the problem is the excessive
 > contention on inode_sb_list_lock.
 > 
 > Ugh. There's no way we can do that patch by DaveC for 3.10. Not only
 > is it scary, Andi pointed out that it's actively buggy and will miss
 > inodes that need writeback due to moving things to private lists.
 > 
 > So I suspect we'll have to do 3.10 with this starvation issue in
 > place, and mark for stable backporting whatever eventual fix we find.

Given I'm the only person who seems to have been bitten by this,
I suspect it's not going to be a big deal.  Worst case we can tell
people "yeah, just disable the soft watchdog until this is fixed".

 > > I did see the trace below, but I think that's a different problem..
 > > Not sure who to point at for that one though. Linus?
 > 
 > Hmm.
 > 
 > > [ 1583.293952] RIP: 0010:[<ffffffff810dd856>]  [<ffffffff810dd856>] stop_machine_cpu_stop+0x86/0x110
 > 
 > I'm not sure how sane the watchdog is over stop_machine situations. I
 > think we disable the watchdog for suspend/resume exactly because
 > stop-machine can take almost arbitrarily long. I'm assuming you're
 > stress-testing (perhaps unintentionally) the cpu offlining/onlining
 > and/or memory migration, which is just fundamentally big expensive
 > things.
 >
 > Does the machine recover? Because if it does, I'd be inclined to just
 > ignore it.

It did, after spewing that a few times, followed by this one..

BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child3:2185]
Modules linked in: bridge stp dlci mpoa snd_seq_dummy sctp fuse hidp tun bnep nfnetlink scsi_transport_iscsi rfcomm can_raw can_bcm af_802154 appletalk caif_socket can caif ipt_ULOG x25 rose af_key pppoe pppox ipx phonet i
rda llc2 ppp_generic slhc p8023 psnap p8022 llc crc_ccitt atm bluetooth netrom ax25 nfc rfkill rds af_rxrpc coretemp hwmon kvm_intel kvm crc32c_intel snd_hda_codec_realtek ghash_clmulni_intel microcode pcspkr snd_hda_codec_hdmi snd_hda_i
ntel snd_hda_codec snd_hwdep usb_debug snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
irq event stamp: 2291065
hardirqs last  enabled at (2291064): [<ffffffff816edca0>] restore_args+0x0/0x30
hardirqs last disabled at (2291065): [<ffffffff816f67aa>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (2290298): [<ffffffff810542e4>] __do_softirq+0x194/0x440
softirqs last disabled at (2290301): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
CPU: 2 PID: 2185 Comm: trinity-child3 Not tainted 3.10.0-rc7+ #37 [loadavg: 27.02 10.32 6.81 60/194 2646]
task: ffff8801023e4a40 ti: ffff88022c958000 task.ti: ffff88022c958000
RIP: 0010:[<ffffffff81054201>]  [<ffffffff81054201>] __do_softirq+0xb1/0x440
RSP: 0000:ffff880244c03f08  EFLAGS: 00000206
RAX: ffff8801023e4a40 RBX: ffffffff816edca0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801023e4a40
RBP: ffff880244c03f70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244c03e78
R13: ffffffff816f67af R14: ffff880244c03f70 R15: 0000000000000000
FS:  00007f0f89ffb740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002c1b000 CR3: 0000000210a2f000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000a00406040 00000001002e7923 ffff88022c959fd8 ffff88022c959fd8
 ffff88022c959fd8 ffff8801023e4e38 ffff88022c959fd8 ffffffff00000002
 ffff8801023e4a40 0000000000000000 0000000000000006 0000000001807000
Call Trace:
 <IRQ> 
 [<ffffffff8105474d>] irq_exit+0xcd/0xe0
 [<ffffffff816f764b>] smp_apic_timer_interrupt+0x6b/0x9b
 [<ffffffff816f67af>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff816edca0>] ? retint_restore_args+0xe/0xe
 [<ffffffff816eacf0>] ? wait_for_completion_interruptible+0x170/0x170
 [<ffffffff816ebd93>] ? preempt_schedule_irq+0x53/0x90
 [<ffffffff816eddb6>] retint_kernel+0x26/0x30
 [<ffffffff81145ba7>] ? user_enter+0x87/0xd0
 [<ffffffff816f1345>] do_page_fault+0x45/0x50
 [<ffffffff816edee2>] page_fault+0x22/0x30
Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 d7 35 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 

But after that, and one more from stop_machine, it's been quiet since, still chugging along.

 > Although it would be interesting to hear what triggers this
 > - normal users - and I'm assuming you're still running trinity as
 > non-root - generally should not be able to trigger stop-machine
 > events..

Yeah, this is running as a user. Those don't sound like things that should
be possible.  What instrumentation could I add to figure out why 
that kthread got awakened ?

	Dave

