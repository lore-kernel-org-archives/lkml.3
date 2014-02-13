Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaBMAH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBMAHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:07:55 -0500
Date: Wed, 12 Feb 2014 19:07:49 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: skd: disable discard support
Message-ID: <20140213000749.GA5414@redhat.com>
References: <20140212221835.GA4265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212221835.GA4265@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12 2014 at  5:18pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> The skd driver has never handled discards reliably.
> 
> The kernel will BUG as a result of issuing discards to the skd device.
> Disable the skd driver's discard support until it is proven reliable.
> 
> The device-mapper-test-suite test that exposed this bug just issues a
> discard that covers a portion of the skd device that was previously
> written through a dm-thin device.  The discard spans the entire 1GB thin
> device (logical sector 0 through 2097152).
> 
> dmtest run --profile stec --suite thin-provisioning -n /discard_fully_provisioned_device/

I retested after applying these linux-block.git commits ontop of
3.14-rc1:

5cb8850c9c4a block: Explicitly handle discard/write same segments
8423ae3d7a3c block: Fix cloning of discard/write same bios

And got this:

request botched: dev skd0: type=1, flags=12248081
  sector 8390784, nr/cnr 0/128
  bio ffff88033169cba0, biotail ffff88032e42bb60, buffer           (null), len 0                                                                                       
------------[ cut here ]------------                                                                                                                                   
kernel BUG at block/blk-core.c:2693!                                                                                                                                   
invalid opcode: 0000 [#1] SMP                                                                                                                                          
Modules linked in: dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio libcrc32c ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock t
arget_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe 8021q libfc garp stp llc scsi_transport_fc scsi_tgt sunrpc cpufreq_ondemand ipt_REJECT n
f_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio i
pv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan vhost tun kvm_int
el kvm iTCO_wdt iTCO_vendor_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_core mdio ses enclosure sg ac
pi_cpufreq dm_mod ext4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix skd sd_mod crc_t10dif crct10dif_common megaraid_sas                                    
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.14.0-rc1.snitm+ #5                                                                                              
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011                                 
task: ffff88033299e150 ti: ffff8803329a4000 task.ti: ffff8803329a4000                                                                                                  
RIP: 0010:[<ffffffff81252f1a>]  [<ffffffff81252f1a>] __blk_end_request_all+0x2a/0x40                                                                                   
RSP: 0018:ffff88033fc43cf8  EFLAGS: 00010002                                                                                                                           
RAX: 0000000000000001 RBX: ffff88032e636ac8 RCX: 0000000000000006                                                                                                      
RDX: 0000000000000001 RSI: ffff88033169cba0 RDI: ffff88032ec755c0                                                                                                      
RBP: ffff88033fc43cf8 R08: 0000000000000002 R09: 0000000000000000                                                                                                      
R10: 00000000000006f3 R11: 0000000000000001 R12: 0000000000000000                                                                                                      
R13: ffff88033195faa8 R14: ffff8800ba396000 R15: 0000000000000001                                                                                                      
FS:  0000000000000000(0000) GS:ffff88033fc40000(0000) knlGS:0000000000000000                                                                                           
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                      
CR2: 0000003bfea13000 CR3: 000000032fbdc000 CR4: 00000000000007e0                                                                                                      
Stack:                                                                                                                                                                 
 ffff88033fc43d58 ffffffffa0037b85 ffff88033fc43d48 ffffffff8129ca09                                                                                    
 ffff88033fc43d28 ffff88032e636ac8 ffff8800ba396000 ffff88032e650080
 ffff8800ba396000 ffff88032e650080 ffff88032e636ac8 0000000000003c17
Call Trace:
 <IRQ>
 [<ffffffffa0037b85>] skd_end_request+0x55/0x160 [skd]
 [<ffffffff8129ca09>] ? swiotlb_unmap_sg_attrs+0x69/0x80
 [<ffffffffa003c513>] skd_isr_completion_posted+0x1e3/0x5d0 [skd]
 [<ffffffff810930a3>] ? __wake_up+0x53/0x70
 [<ffffffffa003d1b2>] skd_isr+0x122/0x280 [skd]
 [<ffffffff810a73ed>] handle_irq_event_percpu+0x6d/0x200
 [<ffffffff810a75c2>] handle_irq_event+0x42/0x70
 [<ffffffff810aad19>] handle_edge_irq+0x69/0x120
 [<ffffffff81005aec>] handle_irq+0x5c/0x150
 [<ffffffff815470f2>] ? __atomic_notifier_call_chain+0x12/0x20
 [<ffffffff81547116>] ? atomic_notifier_call_chain+0x16/0x20
 [<ffffffff8154d91e>] do_IRQ+0x5e/0x110
 [<ffffffff8154366a>] common_interrupt+0x6a/0x6a
 <EOI>
 [<ffffffff8144d5e3>] ? cpuidle_enter_state+0x53/0xd0
 [<ffffffff8144d5df>] ? cpuidle_enter_state+0x4f/0xd0
 [<ffffffff8144d7a7>] cpuidle_idle_call+0xc7/0x160
 [<ffffffff8100cf5e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810a696a>] cpu_idle_loop+0x9a/0x240
 [<ffffffff810b9e64>] ? clockevents_register_device+0xc4/0x130
 [<ffffffff810a6b33>] cpu_startup_entry+0x23/0x30
 [<ffffffff81032d5a>] start_secondary+0x7a/0x80
Code: 00 55 48 89 e5 66 66 66 66 90 48 8b 87 78 01 00 00 48 85 c0 75 10 31 c9 8b 57 64 e8 91 ff ff ff 84 c0 75 07 c9 c3 8b 48 64 eb ed <0f> 0b 0f 1f 40 00 eb fa 66 66
66 66 66 2e 0f 1f 84 00 00 00 00
RIP  [<ffffffff81252f1a>] __blk_end_request_all+0x2a/0x40
 RSP <ffff88033fc43cf8>
---[ end trace 494de22d0f0be0f8 ]---
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.394 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.402 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.405 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.410 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.414 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.417 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.421 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.424 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.428 msecs
INFO: NMI handler (ghes_notify_nmi) took too long to run: 2.431 msecs
Kernel panic - not syncing: Fatal exception in interrupt
Shutting down cpus with NMI
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
