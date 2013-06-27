Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3F0Obo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3F0Obm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:31:42 -0400
Date: Thu, 27 Jun 2013 10:30:55 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627143055.GA1000@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627075543.GA32195@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 05:55:43PM +1000, Dave Chinner wrote:
 
 > Is this just a soft lockup warning? Or is the system hung?
 
I've only seen it completely lock up the box 2-3 times out of dozens
of times I've seen this, and tbh that could have been a different bug.

 > I mean, what you see here is probably sync_inodes_sb() having called
 > wait_sb_inodes() and is spinning on the inode_sb_list_lock.
 > 
 > There's nothing stopping multiple sys_sync() calls from executing on
 > the same superblock simulatenously, and if there's lots of cached
 > inodes on a single filesystem and nothing much to write back then
 > concurrent sync() calls will enter wait_sb_inodes() concurrently and
 > contend on the inode_sb_list_lock.
 > 
 > Get enough sync() calls running at the same time, and you'll see
 > this. e.g. I just ran a parallel find/stat workload over a
 > filesystem with 50 million inodes in it, and once that had reached a
 > steady state of about 2 million cached inodes in RAM:
 
It's not even just sync calls it seems. Here's the latest victim from
last nights overnight run, failing in hugetlb mmap.
Same lock, but we got there by different way. (I suppose it could be
that the other CPUs were running sync() at the time of this mmap call)

BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child1:24304]
BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:25603]
Modules linked in: bridge stp dlci fuse tun snd_seq_dummy bnep rfcomm hidp nfnetlink scsi_transport_iscsi can_raw rose pppoe pppox ppp_generic caif_socket slhc caif nfc ipx p8023 x25 p8022 bluetooth irda crc_ccitt rfkill llc2 netrom rds ax25 af_key ipt_ULOG af_rxrpc can_bcm phonet can appletalk af_802154 psnap llc atm coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e snd_pcm ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
irq event stamp: 83048
hardirqs last  enabled at (83047): [<ffffffff816e9560>] restore_args+0x0/0x30
hardirqs last disabled at (83048): [<ffffffff816f202a>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (83046): [<ffffffff810541d4>] __do_softirq+0x194/0x440
softirqs last disabled at (83023): [<ffffffff8105463d>] irq_exit+0xcd/0xe0
CPU: 0 PID: 25603 Comm: trinity-child0 Not tainted 3.10.0-rc7+ #6
task: ffff880232a7a3e0 ti: ffff88023aec0000 task.ti: ffff88023aec0000
RIP: 0010:[<ffffffff81306143>]  [<ffffffff81306143>] delay_tsc+0x73/0xe0
RSP: 0018:ffff88023aec1db8  EFLAGS: 00000202
RAX: 0000000005cee9e0 RBX: ffffffff816e9560 RCX: 000000000000b910
RDX: 000000000000197f RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff88023aec1de0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88023aec1d28
R13: ffff88023aec1fd8 R14: ffff88023aec0000 R15: 0000000000000046
FS:  00007f5b482e3740(0000) GS:ffff880245600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5b482e7070 CR3: 000000023f9ef000 CR4: 00000000001407f0
DR0: 0000000000cbb000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffffffff81c04640 000000002a279c22 0000000088c74df8 0000000000000000
 ffff880243c8b000 ffff88023aec1df0 ffffffff8130602f ffff88023aec1e18
 ffffffff8130e641 ffffffff81c04640 ffffffff81c04658 0000000000000000
Call Trace:
 [<ffffffff8130602f>] __delay+0xf/0x20
 [<ffffffff8130e641>] do_raw_spin_lock+0xe1/0x130
 [<ffffffff816e84e0>] _raw_spin_lock+0x60/0x80
 [<ffffffff811c4429>] ? inode_sb_list_add+0x19/0x50
 [<ffffffff811c4429>] inode_sb_list_add+0x19/0x50
 [<ffffffff811c6a69>] new_inode+0x29/0x30
 [<ffffffff8128ed00>] hugetlbfs_get_inode+0x20/0x140
 [<ffffffff8128fd5f>] hugetlb_file_setup+0xff/0x2d0
 [<ffffffff81176a32>] SyS_mmap_pgoff+0xb2/0x250
 [<ffffffff8100f388>] ? syscall_trace_enter+0x18/0x290
 [<ffffffff81007232>] SyS_mmap+0x22/0x30
 [<ffffffff816f15d4>] tracesys+0xdd/0xe2
Code: 3e 00 49 8b 87 38 e0 ff ff a8 08 75 5a f3 90 bf 01 00 00 00 e8 6f 6e 3e 00 e8 8a 9e 00 00 41 39 c5 75 4b 0f 1f 00 0f ae e8 0f 31 <48> c1 e2 20 89 c0 48 09 c2 41 89 d6 29 da 44 39 e2 72 ba bf 01 
XXX HIRQ  0    timer : sum_delta=      20 on_this_cpu=      20
XXX HIRQ  1    i8042 : sum_delta=      10 on_this_cpu=      10
XXX HIRQ  8     rtc0 : sum_delta=       1 on_this_cpu=       1
XXX HIRQ 16 ehci_hcd:usb1 : sum_delta=     138 on_this_cpu=      33
XXX HIRQ 23 ehci_hcd:usb2 : sum_delta=     124 on_this_cpu=     109
XXX HIRQ 42     i915 : sum_delta=      80 on_this_cpu=      80
XXX HIRQ 43     ahci : sum_delta=   89683 on_this_cpu=    3163
XXX HIRQ 45  enp0s25 : sum_delta=   30655 on_this_cpu=      20
XXX HIRQ 46 snd_hda_intel : sum_delta=     457 on_this_cpu=     457
XXX HIRQ 47 snd_hda_intel : sum_delta=    2961 on_this_cpu=    2961
XXX SIRQ  1    TIMER : sum_delta= 3397163 on_this_cpu= 1219258
XXX SIRQ  2   NET_TX : sum_delta=    2447 on_this_cpu=    2440
XXX SIRQ  3   NET_RX : sum_delta=   31103 on_this_cpu=     150
XXX SIRQ  4    BLOCK : sum_delta=   72285 on_this_cpu=    2950
XXX SIRQ  6  TASKLET : sum_delta=       1 on_this_cpu=       0
XXX SIRQ  7    SCHED : sum_delta= 1103706 on_this_cpu=  393605
XXX SIRQ  8  HRTIMER : sum_delta=   16656 on_this_cpu=    3663
XXX SIRQ  9      RCU : sum_delta= 2123140 on_this_cpu=  576876
BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child3:24661]


 > I didn't realise that just calling sync caused this lock contention
 > problem until I read this thread, so fixing this just went up
 > several levels of priority given the affect an unprivileged user can
 > have on the system just by running lots of concurrent sync calls.
 > 
 > > I'll work on trying to narrow down what trinity is doing. That might at least
 > > make it easier to reproduce it in a shorter timeframe.
 > 
 > This is only occurring on your new machines, right? They have more
 > memory than your old machines, and faster drives? So the caches are
 > larger and the IO completion faster? Those combinations will put
 > more pressure on wait_sb_inodes() from concurrent sync operations...

Sounds feasible.  Maybe I should add something to trinity to create more
dirty pages, perhaps that would have triggered this faster.

8gb ram, 80MB/s SSD's, nothing exciting there (compared to my other machines)
so I think it's purely down to the CPUs being faster, or some other architectural
improvement with Haswell that increases parallelism.

	Dave

