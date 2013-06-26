Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3FZNtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:49:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3FZNtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:49:18 -0400
Date: Wed, 26 Jun 2013 15:49:15 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.10-rc6] soft lockups from sync()
Message-ID: <20130626134915.GA14102@quack.suse.cz>
References: <20130617142611.GA16732@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617142611.GA16732@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-06-13 10:26:11, Dave Jones wrote:
> Haven't seen this happen before..  3.10-rc6 + a bunch of patches to
> survive other trinity induced bugs + some debug 'helpers' (the
> loadavg-at-oops for eg), but nothing that should be responsible for this.
  Hum, we are spinning on inode_sb_list_lock. I'm not aware of any recent
changes in that area. Is this reproducible? Has anything changed with
trinity so that it could start triggering this? Maybe using lockstat we
could see who are the worst offenders using the lock...

								Honza

 
> [15208.612347] BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:19193]
> [15208.612350] BUG: soft lockup - CPU#1 stuck for 23s! [trinity-child1:15177]
> [15208.612373] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15208.612374] irq event stamp: 1206048
> [15208.612379] hardirqs last  enabled at (1206047): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15208.612381] hardirqs last disabled at (1206048): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15208.612385] softirqs last  enabled at (1206046): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15208.612387] softirqs last disabled at (1206041): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15208.612390] CPU: 1 PID: 15177 Comm: trinity-child1 Not tainted 3.10.0-rc6+ #15 [loadavg: 21.98 9.76 7.20 41/174 19195]
> [15208.612391] task: ffff88023e25ca40 ti: ffff880217668000 task.ti: ffff880217668000
> [15208.612395] RIP: 0010:[<ffffffff81313410>]  [<ffffffff81313410>] btree_merge+0x100/0x100
> [15208.612396] RSP: 0018:ffff880217669d48  EFLAGS: 00000297
> [15208.612396] RAX: ffff880217669fd8 RBX: 0000000000000000 RCX: 000000000000b910
> [15208.612397] RDX: 000000000000d5d4 RSI: 0000000000000001 RDI: 0000000000000001
> [15208.612397] RBP: ffff880217669d78 R08: 0000000000000001 R09: 0000000000000000
> [15208.612398] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff816ed220
> [15208.612398] R13: ffffffff811038de R14: ffff880217669ca8 R15: 0000000000000046
> [15208.612399] FS:  00007ff7647d2740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
> [15208.612400] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15208.612400] CR2: 00007fc6d3a67000 CR3: 0000000211c8f000 CR4: 00000000001407e0
> [15208.612401] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15208.612401] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15208.612402] Stack:
> [15208.612403]  ffffffff81309544 ffffffff81c04640 0000000030f05c80 0000000088c820e8
> [15208.612405]  ffff88023b48d540 ffff88023b48d750 ffff880217669d88 ffffffff8130947f
> [15208.612406]  ffff880217669db0 ffffffff81311a91 ffffffff81c04640 ffffffff81c04658
> [15208.612407] Call Trace:
> [15208.612409]  [<ffffffff81309544>] ? delay_tsc+0x24/0xe0
> [15208.612411]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15208.612413]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15208.612414]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15208.612417]  [<ffffffff811da708>] ? sync_inodes_sb+0x228/0x2a0
> [15208.612419]  [<ffffffff811da708>] sync_inodes_sb+0x228/0x2a0
> [15208.612421]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15208.612424]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15208.612425]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15208.612426]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15208.612429]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15208.612430]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15208.612432]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15208.612447] Code: c7 46 10 00 00 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8d 65 d8 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 66 90 <55> 48 89 e5 53 65 48 8b 04 25 f0 b9 00 00 8b 80 44 e0 ff ff 65 
> [15208.642330] BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child2:18845]
> [15208.642354] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15208.642356] irq event stamp: 162644
> [15208.642360] hardirqs last  enabled at (162643): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15208.642362] hardirqs last disabled at (162644): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15208.642364] softirqs last  enabled at (162642): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15208.642366] softirqs last disabled at (162639): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15208.642369] CPU: 2 PID: 18845 Comm: trinity-child2 Not tainted 3.10.0-rc6+ #15 [loadavg: 21.98 9.76 7.20 41/174 19195]
> [15208.642370] task: ffff88023c5e8000 ti: ffff880234656000 task.ti: ffff880234656000
> [15208.642373] RIP: 0010:[<ffffffff813095f0>]  [<ffffffff813095f0>] delay_tsc+0xd0/0xe0
> [15208.642373] RSP: 0018:ffff880234657d50  EFLAGS: 00000202
> [15208.642374] RAX: 0000000000080008 RBX: ffffffff816ed220 RCX: 000000000000b910
> [15208.642375] RDX: 0000000000000018 RSI: 0000000000000001 RDI: 0000000000000001
> [15208.642375] RBP: ffff880234657d78 R08: 0000000000000001 R09: 0000000000000000
> [15208.642376] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880234657cc8
> [15208.642376] R13: 0000000000000046 R14: ffff880234656000 R15: ffff88023c5e8000
> [15208.642377] FS:  00007f87fde40740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
> [15208.642378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15208.642378] CR2: 0000000000000018 CR3: 00000001bc382000 CR4: 00000000001407e0
> [15208.642379] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15208.642379] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15208.642379] Stack:
> [15208.642381]  ffffffff81c04640 0000000030f5e7e1 0000000088c820e8 ffff88023b5fc4c0
> [15208.642382]  ffff88023b5fc6d0 ffff880234657d88 ffffffff8130947f ffff880234657db0
> [15208.642384]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffff88023c4be8c0
> [15208.642384] Call Trace:
> [15208.642386]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15208.642389]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15208.642391]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15208.642393]  [<ffffffff811da708>] ? sync_inodes_sb+0x228/0x2a0
> [15208.642394]  [<ffffffff811da708>] sync_inodes_sb+0x228/0x2a0
> [15208.642396]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15208.642398]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15208.642400]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15208.642401]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15208.642403]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15208.642404]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15208.642406]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15208.642420] Code: 41 5c 41 5d 41 5e 41 5f 5d c3 e8 ec 1a 3e 00 eb 9f e8 35 9e 00 00 44 29 f3 41 01 dc 41 89 c5 0f 1f 00 0f ae e8 0f 31 89 c3 eb 9b <e8> cb 1a 3e 00 eb cd 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
> [15208.672313] BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child0:17147]
> [15208.672335] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15208.672335] irq event stamp: 4183277
> [15208.672338] hardirqs last  enabled at (4183276): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15208.672340] hardirqs last disabled at (4183277): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15208.672342] softirqs last  enabled at (4182502): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15208.672344] softirqs last disabled at (4182505): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15208.672346] CPU: 3 PID: 17147 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 21.98 9.76 7.20 41/174 19195]
> [15208.672348] task: ffff88023c7ba520 ti: ffff88022b4c6000 task.ti: ffff88022b4c6000
> [15208.672350] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [15208.672351] RSP: 0000:ffff880244e03f08  EFLAGS: 00000202
> [15208.672351] RAX: ffff88023c7ba520 RBX: ffffffff816ed220 RCX: 0000000000000002
> [15208.672352] RDX: 0000000000000450 RSI: ffff88023c7bacd8 RDI: ffff88023c7ba520
> [15208.672352] RBP: ffff880244e03f70 R08: 0000000000000002 R09: 0000000000000000
> [15208.672353] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [15208.672353] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [15208.672354] FS:  00007f87fde40740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [15208.672355] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15208.672355] CR2: 00000000052da178 CR3: 0000000172dca000 CR4: 00000000001407e0
> [15208.672356] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15208.672356] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15208.672357] Stack:
> [15208.672358]  0000000a00406040 000000010016c2d5 ffff88022b4c7fd8 ffff88022b4c7fd8
> [15208.672360]  ffff88022b4c7fd8 ffff88023c7ba918 ffff88022b4c7fd8 ffffffff00000003
> [15208.672361]  ffff88023c7ba520 0000000000000000 ffff88023bc1b4e8 0000000000000000
> [15208.672361] Call Trace:
> [15208.672363]  <IRQ> 
> [15208.672364]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15208.672366]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [15208.672368]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [15208.672368]  <EOI> 
> [15208.672370]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [15208.672372]  [<ffffffff811da67f>] ? sync_inodes_sb+0x19f/0x2a0
> [15208.672373]  [<ffffffff811da678>] ? sync_inodes_sb+0x198/0x2a0
> [15208.672375]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15208.672377]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15208.672378]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15208.672379]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15208.672381]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15208.672382]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15208.672383]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15208.672398] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [15208.871052] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15208.882510] irq event stamp: 31508
> [15208.884037] hardirqs last  enabled at (31507): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15208.886155] hardirqs last disabled at (31508): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15208.888370] softirqs last  enabled at (31506): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15208.890526] softirqs last disabled at (31501): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15208.892623] CPU: 0 PID: 19193 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 21.98 9.76 7.20 41/174 19195]
> [15208.897735] task: ffff880215eb2520 ti: ffff880229d02000 task.ti: ffff880229d02000
> [15208.899824] RIP: 0010:[<ffffffff81309593>]  [<ffffffff81309593>] delay_tsc+0x73/0xe0
> [15208.901971] RSP: 0018:ffff880229d03b08  EFLAGS: 00000202
> [15208.903825] RAX: 000000004f8e861b RBX: ffffffff816ed220 RCX: 000000000000b910
> [15208.905880] RDX: 0000000000001fcf RSI: 0000000000000001 RDI: 0000000000000001
> [15208.907910] RBP: ffff880229d03b30 R08: 0000000000000001 R09: 0000000000000000
> [15208.909930] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880229d03a78
> [15208.911921] R13: 0000000000000046 R14: ffff880229d02000 R15: ffff880215eb2520
> [15208.913885] FS:  00007f4c8fca9740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> [15208.915945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15208.917711] CR2: 0000003850ae6500 CR3: 000000017b1a9000 CR4: 00000000001407f0
> [15208.919628] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15208.921529] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15208.923431] Stack:
> [15208.924728]  ffffffff81c04640 0000000030df1abe 0000000088c820e8 0000000000004af9
> [15208.926720]  0000000000000000 ffff880229d03b40 ffffffff8130947f ffff880229d03b68
> [15208.928705]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 0000000000000000
> [15208.930670] Call Trace:
> [15208.931993]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15208.933583]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15208.935284]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15208.936939]  [<ffffffff811c7719>] ? inode_sb_list_add+0x19/0x50
> [15208.938649]  [<ffffffff811c7719>] inode_sb_list_add+0x19/0x50
> [15208.940326]  [<ffffffff811c9d59>] new_inode+0x29/0x30
> [15208.941924]  [<ffffffff8121eeaf>] proc_pid_make_inode+0x1f/0x250
> [15208.943636]  [<ffffffff8121f0fb>] proc_pid_instantiate+0x1b/0xd0
> [15208.945329]  [<ffffffff812209dc>] proc_pid_lookup+0x13c/0x200
> [15208.946991]  [<ffffffff8122092e>] ? proc_pid_lookup+0x8e/0x200
> [15208.948657]  [<ffffffff8121ae4f>] proc_root_lookup+0x2f/0x40
> [15208.950301]  [<ffffffff811b712d>] lookup_real+0x1d/0x50
> [15208.951898]  [<ffffffff811b7723>] __lookup_hash+0x33/0x40
> [15208.953510]  [<ffffffff816e2f52>] lookup_slow+0x44/0xa9
> [15208.955091]  [<ffffffff811b9da3>] link_path_walk+0x733/0x900
> [15208.956722]  [<ffffffff811bd054>] path_openat+0x94/0x530
> [15208.958310]  [<ffffffff8100a384>] ? native_sched_clock+0x24/0x80
> [15208.959977]  [<ffffffff81091985>] ? sched_clock_cpu+0xb5/0x100
> [15208.961628]  [<ffffffff81091985>] ? sched_clock_cpu+0xb5/0x100
> [15208.963271]  [<ffffffff811bdb78>] do_filp_open+0x38/0x80
> [15208.964852]  [<ffffffff816ec521>] ? _raw_spin_unlock+0x31/0x60
> [15208.966493]  [<ffffffff811cc6cf>] ? __alloc_fd+0xaf/0x200
> [15208.968079]  [<ffffffff811ac009>] do_sys_open+0xe9/0x1c0
> [15208.969655]  [<ffffffff811ac0fe>] SyS_open+0x1e/0x20
> [15208.971185]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15208.972716] Code: 3e 00 49 8b 87 38 e0 ff ff a8 08 75 5a f3 90 bf 01 00 00 00 e8 ef 76 3e 00 e8 8a 9e 00 00 41 39 c5 75 4b 0f 1f 00 0f ae e8 0f 31 <48> c1 e2 20 89 c0 48 09 c2 41 89 d6 29 da 44 39 e2 72 ba bf 01 
> [15236.596709] BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:19193]
> [15236.596712] BUG: soft lockup - CPU#1 stuck for 23s! [trinity-child1:15177]
> [15236.596732] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15236.596732] irq event stamp: 1228866
> [15236.596735] hardirqs last  enabled at (1228865): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15236.596736] hardirqs last disabled at (1228866): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15236.596738] softirqs last  enabled at (1228864): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15236.596740] softirqs last disabled at (1228859): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15236.596742] CPU: 1 PID: 15177 Comm: trinity-child1 Not tainted 3.10.0-rc6+ #15 [loadavg: 31.01 12.86 8.30 45/174 19195]
> [15236.596743] task: ffff88023e25ca40 ti: ffff880217668000 task.ti: ffff880217668000
> [15236.596745] RIP: 0010:[<ffffffff8130954f>]  [<ffffffff8130954f>] delay_tsc+0x2f/0xe0
> [15236.596746] RSP: 0018:ffff880217669d50  EFLAGS: 00000202
> [15236.596746] RAX: 00000000453865bb RBX: 0000000000000001 RCX: 000000000000b910
> [15236.596747] RDX: 0000000000001fde RSI: 0000000000000001 RDI: 0000000000000001
> [15236.596747] RBP: ffff880217669d78 R08: 0000000000000001 R09: 0000000000000000
> [15236.596748] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [15236.596748] R13: 0000000000000001 R14: ffffffff816ed220 R15: ffffffff811038de
> [15236.596749] FS:  00007ff7647d2740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
> [15236.596750] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15236.596750] CR2: 00007fc6d3a67000 CR3: 0000000211c8f000 CR4: 00000000001407e0
> [15236.596751] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15236.596751] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15236.596751] Stack:
> [15236.596753]  ffffffff81c04640 0000000062eeaf74 0000000088c820e8 ffff88023b48d540
> [15236.596754]  ffff88023b48d750 ffff880217669d88 ffffffff8130947f ffff880217669db0
> [15236.596756]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffff88023c4be8c0
> [15236.596756] Call Trace:
> [15236.596758]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15236.596759]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15236.596761]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15236.596763]  [<ffffffff811da708>] ? sync_inodes_sb+0x228/0x2a0
> [15236.596764]  [<ffffffff811da708>] sync_inodes_sb+0x228/0x2a0
> [15236.596766]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15236.596768]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15236.596769]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15236.596770]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15236.596772]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15236.596773]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15236.596774]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15236.596789] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 31 77 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
> [15236.626693] BUG: soft lockup - CPU#2 stuck for 23s! [trinity-child2:18845]
> [15236.626714] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15236.626714] irq event stamp: 185294
> [15236.626718] hardirqs last  enabled at (185293): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15236.626720] hardirqs last disabled at (185294): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15236.626722] softirqs last  enabled at (185292): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15236.626723] softirqs last disabled at (185289): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15236.626726] CPU: 2 PID: 18845 Comm: trinity-child2 Not tainted 3.10.0-rc6+ #15 [loadavg: 31.01 12.86 8.30 45/174 19195]
> [15236.626728] task: ffff88023c5e8000 ti: ffff880234656000 task.ti: ffff880234656000
> [15236.626730] RIP: 0010:[<ffffffff816f0db1>]  [<ffffffff816f0db1>] sub_preempt_count+0x51/0x100
> [15236.626730] RSP: 0018:ffff880234657d38  EFLAGS: 00000202
> [15236.626731] RAX: ffff880234657fd8 RBX: ffffffff8130a8ee RCX: 000000000000b910
> [15236.626731] RDX: 0000000000000015 RSI: 0000000000000001 RDI: 0000000000000001
> [15236.626732] RBP: ffff880234657d40 R08: 0000000000000001 R09: 0000000000000000
> [15236.626732] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000062ed582a
> [15236.626733] R13: ffffffff81c04640 R14: ffffffff810b72dd R15: ffff880234657ca8
> [15236.626733] FS:  00007f87fde40740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
> [15236.626734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15236.626734] CR2: 0000000000000018 CR3: 00000001bc382000 CR4: 00000000001407e0
> [15236.626735] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15236.626735] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15236.626736] Stack:
> [15236.626737]  000000004952d18a ffff880234657d78 ffffffff813095b0 ffffffff81c04640
> [15236.626738]  0000000062f203bd 0000000088c820e8 ffff88023b5fc4c0 ffff88023b5fc6d0
> [15236.626740]  ffff880234657d88 ffffffff8130947f ffff880234657db0 ffffffff81311a91
> [15236.626740] Call Trace:
> [15236.626742]  [<ffffffff813095b0>] delay_tsc+0x90/0xe0
> [15236.626743]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15236.626745]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15236.626747]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15236.626749]  [<ffffffff811da708>] ? sync_inodes_sb+0x228/0x2a0
> [15236.626750]  [<ffffffff811da708>] sync_inodes_sb+0x228/0x2a0
> [15236.626753]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15236.626755]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15236.626756]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15236.626757]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15236.626759]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15236.626760]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15236.626761]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15236.626776] Code: ff 7c 4a 81 ff fe 00 00 00 76 7d 65 48 8b 04 25 f0 b9 00 00 3b 98 44 e0 ff ff 74 16 65 48 8b 04 25 f0 b9 00 00 29 98 44 e0 ff ff <5b> 5d c3 0f 1f 40 00 48 8b 45 00 48 8b 78 08 e8 5b c0 99 ff 48 
> [15236.656665] BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child0:17147]
> [15236.656685] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15236.656685] irq event stamp: 6367699
> [15236.656687] hardirqs last  enabled at (6367698): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15236.656689] hardirqs last disabled at (6367699): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15236.656691] softirqs last  enabled at (6366924): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15236.656692] softirqs last disabled at (6366927): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15236.656695] CPU: 3 PID: 17147 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 31.01 12.86 8.30 45/174 19195]
> [15236.656696] task: ffff88023c7ba520 ti: ffff88022b4c6000 task.ti: ffff88022b4c6000
> [15236.656698] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [15236.656699] RSP: 0000:ffff880244e03f08  EFLAGS: 00000212
> [15236.656699] RAX: ffff88023c7ba520 RBX: ffffffff816ed220 RCX: 0000000000000002
> [15236.656700] RDX: 00000000000031c0 RSI: ffff88023c7bad10 RDI: ffff88023c7ba520
> [15236.656700] RBP: ffff880244e03f70 R08: 0000000000000003 R09: 0000000000000000
> [15236.656700] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [15236.656701] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [15236.656702] FS:  00007f87fde40740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [15236.656702] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15236.656703] CR2: 00000000052da178 CR3: 0000000172dca000 CR4: 00000000001407e0
> [15236.656703] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15236.656704] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15236.656704] Stack:
> [15236.656705]  0000000a00406040 000000010016cdc5 ffff88022b4c7fd8 ffff88022b4c7fd8
> [15236.656707]  ffff88022b4c7fd8 ffff88023c7ba918 ffff88022b4c7fd8 ffffffff00000003
> [15236.656708]  ffff88023c7ba520 0000000000000000 0000000000000000 0000000000000002
> [15236.656708] Call Trace:
> [15236.656709]  <IRQ> 
> [15236.656711]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15236.656713]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [15236.656714]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [15236.656715]  <EOI> 
> [15236.656716]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [15236.656718]  [<ffffffff810b9946>] ? lock_acquire+0xa6/0x1f0
> [15236.656720]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15236.656722]  [<ffffffff816ec190>] _raw_spin_lock+0x40/0x80
> [15236.656723]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15236.656725]  [<ffffffff811da6a2>] sync_inodes_sb+0x1c2/0x2a0
> [15236.656726]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15236.656728]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15236.656729]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15236.656730]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15236.656732]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15236.656733]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15236.656734]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15236.656749] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [15236.857644] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15236.868730] irq event stamp: 55072
> [15236.870164] hardirqs last  enabled at (55071): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15236.872193] hardirqs last disabled at (55072): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15236.874315] softirqs last  enabled at (55070): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15236.876379] softirqs last disabled at (55065): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15236.878406] CPU: 0 PID: 19193 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 31.01 12.86 8.30 11/182 19203]
> [15236.883338] task: ffff880215eb2520 ti: ffff880229d02000 task.ti: ffff880229d02000
> [15236.885317] RIP: 0010:[<ffffffff8130954f>]  [<ffffffff8130954f>] delay_tsc+0x2f/0xe0
> [15236.887342] RSP: 0018:ffff880229d03b08  EFLAGS: 00000202
> [15236.889040] RAX: 00000000453865be RBX: ffffffff816ed220 RCX: 000000000000b910
> [15236.890938] RDX: 0000000000001fde RSI: 0000000000000001 RDI: 0000000000000001
> [15236.892815] RBP: ffff880229d03b30 R08: 0000000000000001 R09: 0000000000000000
> [15236.894663] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880229d03a78
> [15236.896496] R13: 0000000000000046 R14: ffff880229d02000 R15: ffff880215eb2520
> [15236.898309] FS:  00007f4c8fca9740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> [15236.900232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15236.901881] CR2: 0000003850ae6500 CR3: 000000017b1a9000 CR4: 00000000001407f0
> [15236.903696] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15236.905510] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15236.907358] Stack:
> [15236.908545]  ffffffff81c04640 000000006222166a 0000000088c820e8 0000000000004af9
> [15236.910401]  0000000000000000 ffff880229d03b40 ffffffff8130947f ffff880229d03b68
> [15236.912257]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 0000000000000000
> [15236.914110] Call Trace:
> [15236.915338]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15236.916863]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15236.918471]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15236.920043]  [<ffffffff811c7719>] ? inode_sb_list_add+0x19/0x50
> [15236.921668]  [<ffffffff811c7719>] inode_sb_list_add+0x19/0x50
> [15236.923262]  [<ffffffff811c9d59>] new_inode+0x29/0x30
> [15236.924770]  [<ffffffff8121eeaf>] proc_pid_make_inode+0x1f/0x250
> [15236.926386]  [<ffffffff8121f0fb>] proc_pid_instantiate+0x1b/0xd0
> [15236.928015]  [<ffffffff812209dc>] proc_pid_lookup+0x13c/0x200
> [15236.929599]  [<ffffffff8122092e>] ? proc_pid_lookup+0x8e/0x200
> [15236.931192]  [<ffffffff8121ae4f>] proc_root_lookup+0x2f/0x40
> [15236.932755]  [<ffffffff811b712d>] lookup_real+0x1d/0x50
> [15236.934265]  [<ffffffff811b7723>] __lookup_hash+0x33/0x40
> [15236.935795]  [<ffffffff816e2f52>] lookup_slow+0x44/0xa9
> [15236.937351]  [<ffffffff811b9da3>] link_path_walk+0x733/0x900
> [15236.938907]  [<ffffffff811bd054>] path_openat+0x94/0x530
> [15236.940422]  [<ffffffff8100a384>] ? native_sched_clock+0x24/0x80
> [15236.942021]  [<ffffffff81091985>] ? sched_clock_cpu+0xb5/0x100
> [15236.943597]  [<ffffffff81091985>] ? sched_clock_cpu+0xb5/0x100
> [15236.945164]  [<ffffffff811bdb78>] do_filp_open+0x38/0x80
> [15236.946694]  [<ffffffff816ec521>] ? _raw_spin_unlock+0x31/0x60
> [15236.948260]  [<ffffffff811cc6cf>] ? __alloc_fd+0xaf/0x200
> [15236.949777]  [<ffffffff811ac009>] do_sys_open+0xe9/0x1c0
> [15236.951291]  [<ffffffff811ac0fe>] SyS_open+0x1e/0x20
> [15236.952757]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15236.954222] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 31 77 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
> [15260.643263] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child0:17147]
> [15260.645155] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15260.658187] irq event stamp: 8234507
> [15260.659770] hardirqs last  enabled at (8234506): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15260.661955] hardirqs last disabled at (8234507): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15260.664223] softirqs last  enabled at (8233736): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15260.666386] softirqs last disabled at (8233739): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15260.668466] CPU: 3 PID: 17147 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 37.37 15.78 9.38 40/184 19207]
> [15260.673429] task: ffff88023c7ba520 ti: ffff88022b4c6000 task.ti: ffff88022b4c6000
> [15260.675400] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [15260.677506] RSP: 0000:ffff880244e03f08  EFLAGS: 00000206
> [15260.679237] RAX: ffff88023c7ba520 RBX: ffffffff816ed220 RCX: 0000000000000002
> [15260.681190] RDX: 0000000000000450 RSI: ffff88023c7bacd8 RDI: ffff88023c7ba520
> [15260.683131] RBP: ffff880244e03f70 R08: 0000000000000003 R09: 0000000000000000
> [15260.685049] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [15260.686941] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [15260.688835] FS:  00007f87fde40740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [15260.690851] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15260.692578] CR2: 0000000009647168 CR3: 0000000172dca000 CR4: 00000000001407e0
> [15260.694478] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15260.696376] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15260.698272] Stack:
> [15260.699565]  0000000a00406040 000000010016d72b ffff88022b4c7fd8 ffff88022b4c7fd8
> [15260.701657]  ffff88022b4c7fd8 ffff88023c7ba918 ffff88022b4c7fd8 ffffffff00000003
> [15260.703759]  ffff88023c7ba520 0000000000000000 ffffffff811da678 0000000000000246
> [15260.705863] Call Trace:
> [15260.707213]  <IRQ> 
> 
> [15260.708776]  [<ffffffff811da678>] ? sync_inodes_sb+0x198/0x2a0
> [15260.710389]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15260.712034]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [15260.713845]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [15260.715611]  <EOI> 
> 
> [15260.717116]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [15260.718717]  [<ffffffff810b9e90>] ? lock_release+0xb0/0x320
> [15260.720428]  [<ffffffff816ec50f>] _raw_spin_unlock+0x1f/0x60
> [15260.722152]  [<ffffffff811da678>] sync_inodes_sb+0x198/0x2a0
> [15260.723880]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15260.725659]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15260.727361]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15260.729125]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15260.730876]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15260.732588]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15260.734228]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15260.735870] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [15288.567669] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child2:19176]
> [15288.567672] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:18971]
> [15288.567694] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15288.567694] irq event stamp: 142242
> [15288.567700] hardirqs last  enabled at (142241): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15288.567703] hardirqs last disabled at (142242): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15288.567706] softirqs last  enabled at (142240): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15288.567708] softirqs last disabled at (142235): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15288.567711] CPU: 0 PID: 18971 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 41.18 18.72 10.56 37/176 19247]
> [15288.567713] task: ffff880227f5a520 ti: ffff880172e18000 task.ti: ffff880172e18000
> [15288.567716] RIP: 0010:[<ffffffff8130954f>]  [<ffffffff8130954f>] delay_tsc+0x2f/0xe0
> [15288.567717] RSP: 0018:ffff880172e19d50  EFLAGS: 00000202
> [15288.567718] RAX: 000000000d73e038 RBX: ffffffff816ed220 RCX: 000000000000b910
> [15288.567718] RDX: 0000000000001ffa RSI: 0000000000000001 RDI: 0000000000000001
> [15288.567719] RBP: ffff880172e19d78 R08: 0000000000000001 R09: 0000000000000000
> [15288.567719] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880172e19cc8
> [15288.567720] R13: 0000000000000046 R14: ffff880172e18000 R15: ffff880227f5a520
> [15288.567721] FS:  00007f1557d68740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> [15288.567721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15288.567722] CR2: 00007f8813f2a8e8 CR3: 000000023c414000 CR4: 00000000001407f0
> [15288.567722] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15288.567723] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15288.567723] Stack:
> [15288.567725]  ffffffff81c04640 000000002b4442bd 0000000088c820e8 0000000000000000
> [15288.567726]  ffffffff00000000 ffff880172e19d88 ffffffff8130947f ffff880172e19db0
> [15288.567728]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffff88023c4be8c0
> [15288.567728] Call Trace:
> [15288.567730]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15288.567733]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15288.567734]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15288.567737]  [<ffffffff811da654>] ? sync_inodes_sb+0x174/0x2a0
> [15288.567739]  [<ffffffff811da654>] sync_inodes_sb+0x174/0x2a0
> [15288.567741]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15288.567744]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15288.567745]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15288.567746]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15288.567749]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15288.567750]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15288.567752]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15288.567766] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 31 77 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
> [15288.597656] BUG: soft lockup - CPU#2 stuck for 22s! [trinity-child3:14411]
> [15288.597681] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15288.597681] irq event stamp: 1864048
> [15288.597685] hardirqs last  enabled at (1864047): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15288.597687] hardirqs last disabled at (1864048): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15288.597690] softirqs last  enabled at (1864046): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15288.597692] softirqs last disabled at (1864041): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15288.597695] CPU: 2 PID: 14411 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #15 [loadavg: 41.18 18.72 10.56 37/176 19247]
> [15288.597696] task: ffff8802270e0000 ti: ffff880176ef2000 task.ti: ffff880176ef2000
> [15288.597699] RIP: 0010:[<ffffffff81309593>]  [<ffffffff81309593>] delay_tsc+0x73/0xe0
> [15288.597700] RSP: 0018:ffff880176ef3d18  EFLAGS: 00000202
> [15288.597701] RAX: 00000000118e4c49 RBX: ffffffff816ed220 RCX: 000000000000b910
> [15288.597701] RDX: 0000000000001ffa RSI: 0000000000000001 RDI: 0000000000000001
> [15288.597702] RBP: ffff880176ef3d40 R08: 0000000000000001 R09: 0000000000000000
> [15288.597702] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880176ef3c88
> [15288.597703] R13: 0000000000000046 R14: ffff880176ef2000 R15: ffff8802270e0000
> [15288.597704] FS:  00007f87fde40740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
> [15288.597704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15288.597705] CR2: 0000000000000001 CR3: 0000000240d0a000 CR4: 00000000001407e0
> [15288.597705] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15288.597706] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15288.597706] Stack:
> [15288.597708]  ffffffff81c04640 000000002c0280c5 0000000088c820e8 ffffffff81814880
> [15288.597709]  ffff8802434ac520 ffff880176ef3d50 ffffffff8130947f ffff880176ef3d78
> [15288.597710]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffffffff81814880
> [15288.597711] Call Trace:
> [15288.597713]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15288.597715]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15288.597717]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15288.597719]  [<ffffffff811c89db>] ? evict+0x6b/0x1a0
> [15288.597720]  [<ffffffff811c89db>] evict+0x6b/0x1a0
> [15288.597721]  [<ffffffff811c93a5>] iput+0xf5/0x190
> [15288.597724]  [<ffffffff811c4a38>] dput+0x208/0x2f0
> [15288.597726]  [<ffffffff811ae6e8>] __fput+0x198/0x2d0
> [15288.597727]  [<ffffffff811ae8de>] ____fput+0xe/0x10
> [15288.597729]  [<ffffffff8107463c>] task_work_run+0xac/0xe0
> [15288.597731]  [<ffffffff8104f34b>] do_exit+0x2bb/0xcd0
> [15288.597733]  [<ffffffff810b72dd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> [15288.597735]  [<ffffffff810b73ad>] ? trace_hardirqs_on+0xd/0x10
> [15288.597736]  [<ffffffff8105114c>] do_group_exit+0x4c/0xc0
> [15288.597738]  [<ffffffff810511d4>] SyS_exit_group+0x14/0x20
> [15288.597739]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15288.597755] Code: 3e 00 49 8b 87 38 e0 ff ff a8 08 75 5a f3 90 bf 01 00 00 00 e8 ef 76 3e 00 e8 8a 9e 00 00 41 39 c5 75 4b 0f 1f 00 0f ae e8 0f 31 <48> c1 e2 20 89 c0 48 09 c2 41 89 d6 29 da 44 39 e2 72 ba bf 01 
> [15288.627643] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child0:17147]
> [15288.627665] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15288.627666] irq event stamp: 10406231
> [15288.627669] hardirqs last  enabled at (10406230): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15288.627671] hardirqs last disabled at (10406231): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15288.627673] softirqs last  enabled at (10405456): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15288.627675] softirqs last disabled at (10405459): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15288.627677] CPU: 3 PID: 17147 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 41.18 18.72 10.56 37/176 19247]
> [15288.627678] task: ffff88023c7ba520 ti: ffff88022b4c6000 task.ti: ffff88022b4c6000
> [15288.627681] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [15288.627681] RSP: 0018:ffff880244e03f08  EFLAGS: 00000202
> [15288.627682] RAX: ffff88023c7ba520 RBX: ffffffff816ed220 RCX: 0000000000000002
> [15288.627682] RDX: 00000000000031c0 RSI: ffff88023c7bad10 RDI: ffff88023c7ba520
> [15288.627683] RBP: ffff880244e03f70 R08: 0000000000000003 R09: 0000000000000000
> [15288.627683] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [15288.627684] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [15288.627685] FS:  00007f87fde40740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [15288.627685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15288.627686] CR2: 0000000000000008 CR3: 0000000172dca000 CR4: 00000000001407e0
> [15288.627687] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15288.627687] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15288.627687] Stack:
> [15288.627689]  0000000a00406040 000000010016e21b ffff88022b4c7fd8 ffff88022b4c7fd8
> [15288.627690]  ffff88022b4c7fd8 ffff88023c7ba918 ffff88022b4c7fd8 ffffffff00000003
> [15288.627692]  ffff88023c7ba520 0000000000000000 0000000000000000 0000000000000002
> [15288.627692] Call Trace:
> [15288.627693]  <IRQ> 
> [15288.627695]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15288.627697]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [15288.627698]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [15288.627699]  <EOI> 
> [15288.627701]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [15288.627703]  [<ffffffff810b9946>] ? lock_acquire+0xa6/0x1f0
> [15288.627705]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15288.627707]  [<ffffffff816ec190>] _raw_spin_lock+0x40/0x80
> [15288.627708]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15288.627710]  [<ffffffff811da6a2>] sync_inodes_sb+0x1c2/0x2a0
> [15288.627712]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15288.627714]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15288.627715]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15288.627717]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15288.627719]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15288.627720]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15288.627721]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15288.627736] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [15288.669173] NOHZ: local_softirq_pending 100
> [15288.834639] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15288.845739] irq event stamp: 68222
> [15288.847174] hardirqs last  enabled at (68221): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15288.849205] hardirqs last disabled at (68222): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15288.851330] softirqs last  enabled at (68220): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15288.853395] softirqs last disabled at (68215): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15288.855402] CPU: 1 PID: 19176 Comm: trinity-child2 Not tainted 3.10.0-rc6+ #15 [loadavg: 41.18 18.72 10.56 17/176 19247]
> [15288.860325] task: ffff880235662520 ti: ffff8801ad19a000 task.ti: ffff8801ad19a000
> [15288.862278] RIP: 0010:[<ffffffff81309593>]  [<ffffffff81309593>] delay_tsc+0x73/0xe0
> [15288.864273] RSP: 0018:ffff8801ad19bd50  EFLAGS: 00000202
> [15288.865948] RAX: 000000000d73e038 RBX: ffffffff816ed220 RCX: 000000000000b910
> [15288.867822] RDX: 0000000000001ffa RSI: 0000000000000001 RDI: 0000000000000001
> [15288.869677] RBP: ffff8801ad19bd78 R08: 0000000000000001 R09: 0000000000000000
> [15288.871504] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801ad19bcc8
> [15288.873310] R13: 0000000000000046 R14: ffff8801ad19a000 R15: ffff880235662520
> [15288.875117] FS:  00007f4c11586740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
> [15288.877039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15288.878701] CR2: 0000000003d52648 CR3: 000000021db18000 CR4: 00000000001407e0
> [15288.880523] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15288.882325] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15288.884108] Stack:
> [15288.885273]  ffffffff81c04640 000000002b4703f5 0000000088c820e8 0000000000000000
> [15288.887126]  ffffffff00000000 ffff8801ad19bd88 ffffffff8130947f ffff8801ad19bdb0
> [15288.888974]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffff88023c4be8c0
> [15288.890814] Call Trace:
> [15288.892029]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15288.893518]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15288.895124]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15288.896695]  [<ffffffff811da654>] ? sync_inodes_sb+0x174/0x2a0
> [15288.898297]  [<ffffffff811da654>] sync_inodes_sb+0x174/0x2a0
> [15288.899869]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15288.901507]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15288.903057]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15288.904669]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15288.906260]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15288.907842]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15288.909320]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15288.910793] Code: 3e 00 49 8b 87 38 e0 ff ff a8 08 75 5a f3 90 bf 01 00 00 00 e8 ef 76 3e 00 e8 8a 9e 00 00 41 39 c5 75 4b 0f 1f 00 0f ae e8 0f 31 <48> c1 e2 20 89 c0 48 09 c2 41 89 d6 29 da 44 39 e2 72 ba bf 01 
> [15336.600829] BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:18506]
> [15336.602729] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15336.615595] irq event stamp: 456216
> [15336.617196] hardirqs last  enabled at (456215): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15336.619412] hardirqs last disabled at (456216): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15336.621723] softirqs last  enabled at (456214): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15336.623987] softirqs last disabled at (456209): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15336.626179] CPU: 3 PID: 18506 Comm: trinity-child1 Not tainted 3.10.0-rc6+ #15 [loadavg: 38.73 20.95 11.68 37/176 19867]
> [15336.631485] task: ffff88023b8b0000 ti: ffff88022706c000 task.ti: ffff88022706c000
> [15336.633643] RIP: 0010:[<ffffffff8131342c>]  [<ffffffff8131342c>] debug_smp_processor_id+0x1c/0xf0
> [15336.636020] RSP: 0018:ffff88022706dd38  EFLAGS: 00000297
> [15336.637939] RAX: 0000000000000002 RBX: ffff88022706c000 RCX: 000000000000b910
> [15336.640076] RDX: 0000000000000c0b RSI: 0000000000000001 RDI: 0000000000000001
> [15336.642222] RBP: ffff88022706dd40 R08: 0000000000000001 R09: 0000000000000000
> [15336.644349] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [15336.646445] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> [15336.648537] FS:  00007f1557d68740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [15336.650717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15336.652600] CR2: 0000003850abc720 CR3: 0000000227df8000 CR4: 00000000001407e0
> [15336.654629] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15336.656631] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15336.658616] Stack:
> [15336.659980]  ffffffff81c04640 ffff88022706dd78 ffffffff81309544 ffffffff81c04640
> [15336.662177]  0000000028fb87d0 0000000088c820e8 0000000000000000 ffffffff00000000
> [15336.664330]  ffff88022706dd88 ffffffff8130947f ffff88022706ddb0 ffffffff81311a91
> [15336.666517] Call Trace:
> [15336.667965]  [<ffffffff81309544>] delay_tsc+0x24/0xe0
> [15336.669686]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15336.671357]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15336.673132]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15336.674864]  [<ffffffff811da654>] ? sync_inodes_sb+0x174/0x2a0
> [15336.676632]  [<ffffffff811da654>] sync_inodes_sb+0x174/0x2a0
> [15336.678380]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15336.680210]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15336.681954]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15336.683748]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15336.685519]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15336.687245]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15336.688896]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15336.690538] Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 66 90 55 48 89 e5 53 65 48 8b 04 25 f0 b9 00 00 8b 80 44 e0 ff ff 65 8b 1c 25 1c b0 00 00 <85> c0 74 05 89 d8 5b 5d c3 9c 58 f6 c4 02 74 f4 89 d8 8b 15 a4 
> [15340.538629] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:18971]
> [15340.538639] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child0:17147]
> [15340.538661] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15340.538661] irq event stamp: 14310743
> [15340.538664] hardirqs last  enabled at (14310742): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15340.538667] hardirqs last disabled at (14310743): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15340.538669] softirqs last  enabled at (14309968): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15340.538671] softirqs last disabled at (14309971): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15340.538674] CPU: 1 PID: 17147 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 39.63 21.43 11.89 39/176 19867]
> [15340.538675] task: ffff88023c7ba520 ti: ffff88022b4c6000 task.ti: ffff88022b4c6000
> [15340.538677] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [15340.538678] RSP: 0018:ffff880244a03f08  EFLAGS: 00000202
> [15340.538678] RAX: ffff88023c7ba520 RBX: ffffffff816ed220 RCX: 0000000000000002
> [15340.538679] RDX: 00000000000031c0 RSI: ffff88023c7bad10 RDI: ffff88023c7ba520
> [15340.538679] RBP: ffff880244a03f70 R08: 0000000000000003 R09: 0000000000000000
> [15340.538680] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244a03e78
> [15340.538680] R13: ffffffff816f5d2f R14: ffff880244a03f70 R15: 0000000000000000
> [15340.538681] FS:  00007f87fde40740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
> [15340.538682] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15340.538682] CR2: 0000000000000000 CR3: 0000000172dca000 CR4: 00000000001407e0
> [15340.538683] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15340.538683] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15340.538684] Stack:
> [15340.538685]  0000000a00406040 000000010016f665 ffff88022b4c7fd8 ffff88022b4c7fd8
> [15340.538687]  ffff88022b4c7fd8 ffff88023c7ba918 ffff88022b4c7fd8 ffffffff00000001
> [15340.538688]  ffff88023c7ba520 0000000000000000 ffff880241d60ba0 0000000000000246
> [15340.538689] Call Trace:
> [15340.538690]  <IRQ> 
> [15340.538691]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15340.538693]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [15340.538695]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [15340.538696]  <EOI> 
> [15340.538697]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [15340.538699]  [<ffffffff810b5fb5>] ? lock_acquired+0x105/0x3f0
> [15340.538701]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15340.538703]  [<ffffffff816ec1bc>] _raw_spin_lock+0x6c/0x80
> [15340.538704]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [15340.538706]  [<ffffffff811da6a2>] sync_inodes_sb+0x1c2/0x2a0
> [15340.538708]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15340.538710]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15340.538711]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15340.538712]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15340.538714]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15340.538716]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15340.538717]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15340.538732] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [15340.636008] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [15340.647482] irq event stamp: 407368
> [15340.649023] hardirqs last  enabled at (407367): [<ffffffff816ed220>] restore_args+0x0/0x30
> [15340.651157] hardirqs last disabled at (407368): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [15340.653378] softirqs last  enabled at (407366): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [15340.655540] softirqs last disabled at (407361): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [15340.657646] CPU: 0 PID: 18971 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #15 [loadavg: 39.63 21.43 11.89 21/176 19867]
> [15340.662750] task: ffff880227f5a520 ti: ffff880172e18000 task.ti: ffff880172e18000
> [15340.664794] RIP: 0010:[<ffffffff8130954f>]  [<ffffffff8130954f>] delay_tsc+0x2f/0xe0
> [15340.666882] RSP: 0018:ffff880172e19d50  EFLAGS: 00000202
> [15340.668677] RAX: 00000000d5af5ab1 RBX: ffffffff816ed220 RCX: 000000000000b910
> [15340.670670] RDX: 0000000000002015 RSI: 0000000000000001 RDI: 0000000000000001
> [15340.672641] RBP: ffff880172e19d78 R08: 0000000000000001 R09: 0000000000000000
> [15340.674583] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880172e19cc8
> [15340.676496] R13: 0000000000000046 R14: ffff880172e18000 R15: ffff880227f5a520
> [15340.678387] FS:  00007f1557d68740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> [15340.680390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15340.682128] CR2: 0000000000000000 CR3: 000000023c414000 CR4: 00000000001407f0
> [15340.684036] DR0: 0000000002ceeac0 DR1: 0000000000000000 DR2: 0000000000000000
> [15340.685935] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [15340.687825] Stack:
> [15340.689084]  ffffffff81c04640 000000002ff51e5c 0000000088c820e8 0000000000000000
> [15340.691024]  ffffffff00000000 ffff880172e19d88 ffffffff8130947f ffff880172e19db0
> [15340.692961]  ffffffff81311a91 ffffffff81c04640 ffffffff81c04658 ffff88023c4be8c0
> [15340.694885] Call Trace:
> [15340.696181]  [<ffffffff8130947f>] __delay+0xf/0x20
> [15340.697750]  [<ffffffff81311a91>] do_raw_spin_lock+0xe1/0x130
> [15340.699427]  [<ffffffff816ec1b0>] _raw_spin_lock+0x60/0x80
> [15340.701072]  [<ffffffff811da654>] ? sync_inodes_sb+0x174/0x2a0
> [15340.702758]  [<ffffffff811da654>] sync_inodes_sb+0x174/0x2a0
> [15340.704417]  [<ffffffff816e990f>] ? wait_for_completion+0xdf/0x110
> [15340.706130]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [15340.707761]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [15340.709448]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [15340.711115]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [15340.712748]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [15340.714303]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [15340.715855] Code: 00 55 48 89 e5 41 57 41 56 41 55 41 54 41 89 fc bf 01 00 00 00 53 e8 31 77 3e 00 e8 cc 9e 00 00 41 89 c5 0f 1f 00 0f ae e8 0f 31 <65> 4c 8b 3c 25 f0 b9 00 00 89 c3 eb 2f 0f 1f 40 00 bf 01 00 00 
> [16915.716746] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child3:27517]
> [16915.718657] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [16915.731584] irq event stamp: 9669609
> [16915.733194] hardirqs last  enabled at (9669608): [<ffffffff816ed220>] restore_args+0x0/0x30
> [16915.735433] hardirqs last disabled at (9669609): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [16915.737774] softirqs last  enabled at (9668852): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [16915.740063] softirqs last disabled at (9668855): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [16915.742271] CPU: 3 PID: 27517 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #15 [loadavg: 28.58 14.79 11.37 49/189 3213]
> [16915.747582] task: ffff8801f1000000 ti: ffff880233958000 task.ti: ffff880233958000
> [16915.749746] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [16915.752035] RSP: 0018:ffff880244e03f08  EFLAGS: 00000202
> [16915.753953] RAX: ffff8801f1000000 RBX: ffffffff816ed220 RCX: 0000000000000002
> [16915.756099] RDX: 00000000000031c0 RSI: ffff8801f10007f0 RDI: ffff8801f1000000
> [16915.758243] RBP: ffff880244e03f70 R08: 0000000000000003 R09: 0000000000000000
> [16915.760404] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [16915.762533] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [16915.764648] FS:  00007faecbd33740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [16915.766862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16915.768776] CR2: 0000000000000001 CR3: 00000002057de000 CR4: 00000000001407e0
> [16915.770835] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [16915.772855] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [16915.774855] Stack:
> [16915.776249]  0000000a00406040 0000000100195e0b ffff880233959fd8 ffff880233959fd8
> [16915.778399]  ffff880233959fd8 ffff8801f10003f8 ffff880233959fd8 ffffffff00000003
> [16915.780578]  ffff8801f1000000 0000000000000000 ffff8802221076e0 0000000000000246
> [16915.782777] Call Trace:
> [16915.784228]  <IRQ> 
> 
> [16915.785863]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [16915.787410]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [16915.789263]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [16915.791078]  <EOI> 
> 
> [16915.792628]  [<ffffffff810b5fb5>] ? lock_acquired+0x105/0x3f0
> [16915.794252]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [16915.796044]  [<ffffffff816ec1bc>] _raw_spin_lock+0x6c/0x80
> [16915.797789]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [16915.799577]  [<ffffffff811da6a2>] sync_inodes_sb+0x1c2/0x2a0
> [16915.801346]  [<ffffffff816e9866>] ? wait_for_completion+0x36/0x110
> [16915.803157]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [16915.804901]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [16915.806696]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [16915.808467]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [16915.810214]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [16915.811880]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [16915.813523] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [16939.703310] BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child3:27517]
> [16939.705133] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [16939.718151] irq event stamp: 11403791
> [16939.719810] hardirqs last  enabled at (11403790): [<ffffffff816ed220>] restore_args+0x0/0x30
> [16939.722081] hardirqs last disabled at (11403791): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [16939.724438] softirqs last  enabled at (11403034): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [16939.726746] softirqs last disabled at (11403037): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [16939.728991] CPU: 3 PID: 27517 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #15 [loadavg: 36.37 17.42 12.30 47/197 3394]
> [16939.734329] task: ffff8801f1000000 ti: ffff880233958000 task.ti: ffff880233958000
> [16939.736489] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [16939.738762] RSP: 0018:ffff880244e03f08  EFLAGS: 00000206
> [16939.740654] RAX: ffff8801f1000000 RBX: ffffffff816ed220 RCX: 0000000000000002
> [16939.742738] RDX: 00000000000031c0 RSI: ffff8801f10007f0 RDI: ffff8801f1000000
> [16939.744793] RBP: ffff880244e03f70 R08: 0000000000000003 R09: 0000000000000000
> [16939.746828] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244e03e78
> [16939.748837] R13: ffffffff816f5d2f R14: ffff880244e03f70 R15: 0000000000000000
> [16939.750832] FS:  00007faecbd33740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> [16939.752943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16939.754778] CR2: 0000000000000001 CR3: 00000002057de000 CR4: 00000000001407e0
> [16939.756790] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [16939.758794] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [16939.760769] Stack:
> [16939.762144]  0000000a00406040 000000010019676b ffff880233959fd8 ffff880233959fd8
> [16939.764307]  ffff880233959fd8 ffff8801f10003f8 ffff880233959fd8 ffffffff00000003
> [16939.766457]  ffff8801f1000000 0000000000000000 0000000000000000 0000000000000002
> [16939.768554] Call Trace:
> [16939.769940]  <IRQ> 
> 
> [16939.771528]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [16939.773062]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [16939.774909]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [16939.776719]  <EOI> 
> 
> [16939.778270]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [16939.779910]  [<ffffffff810b9946>] ? lock_acquire+0xa6/0x1f0
> [16939.781660]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [16939.783449]  [<ffffffff816ec190>] _raw_spin_lock+0x40/0x80
> [16939.785195]  [<ffffffff811da6a2>] ? sync_inodes_sb+0x1c2/0x2a0
> [16939.786966]  [<ffffffff811da6a2>] sync_inodes_sb+0x1c2/0x2a0
> [16939.788716]  [<ffffffff816e9866>] ? wait_for_completion+0x36/0x110
> [16939.790526]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [16939.792254]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [16939.794025]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [16939.795793]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [16939.797524]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [16939.799171]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [16939.800814] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> [17023.596399] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child3:27517]
> [17023.598334] Modules linked in: bridge 8021q garp stp tun fuse snd_seq_dummy rfcomm bnep nfnetlink hidp ipt_ULOG scsi_transport_iscsi can_bcm ipx p8023 p8022 x25 netrom nfc rose llc2 ax25 caif_socket irda caif pppoe pppox ppp_generic crc_ccitt slhc appletalk psnap can_raw llc can af_rxrpc atm af_key af_802154 rds phonet bluetooth rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel ghash_clmulni_intel microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer snd ptp pps_core soundcore xfs libcrc32c
> [17023.609860] irq event stamp: 17108275
> [17023.611452] hardirqs last  enabled at (17108274): [<ffffffff816ed220>] restore_args+0x0/0x30
> [17023.613641] hardirqs last disabled at (17108275): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
> [17023.615931] softirqs last  enabled at (17107514): [<ffffffff810542d4>] __do_softirq+0x194/0x440
> [17023.618152] softirqs last disabled at (17107517): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [17023.620318] CPU: 0 PID: 27517 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #15 [loadavg: 35.44 20.81 13.90 50/195 6575]
> [17023.625490] task: ffff8801f1000000 ti: ffff880233958000 task.ti: ffff880233958000
> [17023.627580] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
> [17023.629752] RSP: 0018:ffff880244803f08  EFLAGS: 00000202
> [17023.631555] RAX: ffff8801f1000000 RBX: ffffffff816ed220 RCX: 0000000000000002
> [17023.633561] RDX: 0000000000000450 RSI: ffff8801f10007b8 RDI: ffff8801f1000000
> [17023.635542] RBP: ffff880244803f70 R08: 0000000000000002 R09: 0000000000000000
> [17023.637501] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244803e78
> [17023.639441] R13: ffffffff816f5d2f R14: ffff880244803f70 R15: 0000000000000000
> [17023.641371] FS:  00007faecbd33740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> [17023.643428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [17023.645208] CR2: 0000000009cac000 CR3: 00000002057de000 CR4: 00000000001407f0
> [17023.647155] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [17023.649081] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> [17023.650982] Stack:
> [17023.652268]  0000000a00406040 0000000100198835 ffff880233959fd8 ffff880233959fd8
> [17023.654236]  ffff880233959fd8 ffff8801f10003f8 ffff880233959fd8 ffffffff00000000
> [17023.656194]  ffff8801f1000000 0000000000000000 ffff88023bc1b4e8 ffff88022948c4c0
> [17023.658158] Call Trace:
> [17023.659486]  <IRQ> 
> 
> [17023.660948]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
> [17023.662415]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
> [17023.664198]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
> [17023.665932]  <EOI> 
> 
> [17023.667378]  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
> [17023.668939]  [<ffffffff811da69a>] ? sync_inodes_sb+0x1ba/0x2a0
> [17023.670649]  [<ffffffff811da678>] ? sync_inodes_sb+0x198/0x2a0
> [17023.672361]  [<ffffffff816e9866>] ? wait_for_completion+0x36/0x110
> [17023.674109]  [<ffffffff8108ce2d>] ? get_parent_ip+0xd/0x50
> [17023.675764]  [<ffffffff811e0270>] ? generic_write_sync+0x70/0x70
> [17023.677478]  [<ffffffff811e0289>] sync_inodes_one_sb+0x19/0x20
> [17023.679162]  [<ffffffff811b0bc2>] iterate_supers+0xb2/0x110
> [17023.680810]  [<ffffffff811e04f5>] sys_sync+0x35/0x90
> [17023.682389]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
> [17023.683963] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
