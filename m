Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaBLWTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:19:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbaBLWTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:19:43 -0500
Date: Wed, 12 Feb 2014 17:19:40 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: skd: disable discard support
Message-ID: <20140212221940.GB4265@redhat.com>
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

Here is the first BUG I recently saw:

------------[ cut here ]------------
Uhhuh. NMI received for unknown reason 21 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
kernel BUG at include/linux/scatterlist.h:65!
invalid opcode: 0000 [#1] SMP
Modules linked in: dm_thin_pool(O) dm_bio_prison(O) dm_persistent_data(O) dm_bufio(O) dm_mod(O) libcrc32c ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe libfc 8021q scsi_transport_fc garp scsi_tgt stp llc sunrpc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_core mdio ses enclosure sg acpi_cpufreq ext4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix skd sd_mod crc_t10dif crct10dif_common megaraid_sas [last unloaded: dm_mod]
CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W  O 3.14.0-rc1.snitm+ #4
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
task: ffff8803329aef20 ti: ffff8803329b0000 task.ti: ffff8803329b0000
RIP: 0010:[<ffffffff8125a481>]  [<ffffffff8125a481>] blk_rq_map_sg+0x241/0x3f0
RSP: 0018:ffff88033fca3c38  EFLAGS: 00010002
RAX: ffffea000b2984f0 RBX: 0000000000010000 RCX: ffff8803286f6020
RDX: ffffea000b2984f0 RSI: 0000000000000000 RDI: ffff8803286f6000
RBP: ffff88033fca3cc8 R08: ffff8803290233c0 R09: 53538ec752528dc6
R10: ffff88032826f8e0 R11: 00000000555590c9 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000010000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88033fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003bfd2f5170 CR3: 0000000001a0b000 CR4: 00000000000007e0
Stack:
 0000000000000002 0000000000000000 ffff88033fca3cf8 ffffffff8112f67e
 ffff88033ffd7d80 ffff88032826f8e0 ffff8802555590c9 53538ec752528dc6
 ffff8802b66bbb28 ffff8803286f6000 ffff8803290233c0 0000000101fd8b08
Call Trace:
 <IRQ>
 [<ffffffff8112f67e>] ? __alloc_pages_nodemask+0x12e/0x250
 [<ffffffffa0071146>] skd_preop_sg_list+0x46/0x270 [skd]
 [<ffffffff811703f2>] ? alloc_pages_current+0xb2/0x170
 [<ffffffffa0072997>] skd_request_fn+0x287/0x900 [skd]
 [<ffffffffa007551e>] ? skd_isr_completion_posted+0x1ee/0x5d0 [skd]
 [<ffffffffa0076233>] skd_isr+0x1a3/0x280 [skd]
 [<ffffffff810a73ed>] handle_irq_event_percpu+0x6d/0x200
 [<ffffffff810a75c2>] handle_irq_event+0x42/0x70
 [<ffffffff810aad19>] handle_edge_irq+0x69/0x120
 [<ffffffff81005aec>] handle_irq+0x5c/0x150
 [<ffffffff815471f2>] ? __atomic_notifier_call_chain+0x12/0x20
 [<ffffffff81547216>] ? atomic_notifier_call_chain+0x16/0x20
 [<ffffffff8154da1e>] do_IRQ+0x5e/0x110
 [<ffffffff8154376a>] common_interrupt+0x6a/0x6a
 <EOI>
 [<ffffffff8144d6c3>] ? cpuidle_enter_state+0x53/0xd0
 [<ffffffff8144d6bf>] ? cpuidle_enter_state+0x4f/0xd0
 [<ffffffff8144d887>] cpuidle_idle_call+0xc7/0x160
 [<ffffffff8100cf5e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810a696a>] cpu_idle_loop+0x9a/0x240
 [<ffffffff810b9e64>] ? clockevents_register_device+0xc4/0x130
 [<ffffffff810a6b33>] cpu_startup_entry+0x23/0x30
 [<ffffffff81032d5a>] start_secondary+0x7a/0x80
Code: 41 5f c9 c3 66 0f 1f 44 00 00 44 29 f3 44 89 f2 44 89 de 4c 89 c8 eb 93 66 90 48 8b 4d b8 41 f6 c1 03 48 8b 01 0f 84 03 ff ff ff <0f> 0b eb fe 0f 1f 00 48 8b 45 c0 4c 8b 85 78 ff ff ff 48 8b b0
RIP  [<ffffffff8125a481>] blk_rq_map_sg+0x241/0x3f0
 RSP <ffff88033fca3c38>
---[ end trace 61da6cb864bf7eb8 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Shutting down cpus with NMI
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
