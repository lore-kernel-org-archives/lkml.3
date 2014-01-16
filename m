Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaAPQd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:33:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49661 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAPQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:33:24 -0500
Date: Thu, 16 Jan 2014 17:33:22 +0100
From: Petr Janecek <janecek@ucw.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: BUG: sleeping function called from invalid context at
 block/blk-core.c:1690
Message-ID: <20140116163322.GA5862@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the crash happended ~11s after start of rsync from remote site (on a
slow link) to local xfs.  Before that, local backups (rsync ext4 -> xfs,
ext4 -> btrfs) had run.  The xfs is on lvm on md raid1 of two disks.
The only other thing running on this server were idle win7 in kvm.  The
system is current debian stable, only the kernel is vanilla 3.12.5.


[2110283.280635] BUG: sleeping function called from invalid context at block/blk-core.c:1690
[2110283.288905] BUG: unable to handle kernel paging request at 00000000ade1b4b0
[2110283.296124] IP: [<ffffffff810714e4>] cpuacct_charge+0x62/0xaa
[2110283.302100] PGD 0 
[2110283.304338] Oops: 0000 [#1] SMP 
[2110283.307818] Modules linked in: btrfs raid6_pq xor nls_cp437 vfat fat nls_utf8 isofs usb_storage vhost_net macvtap macvlan vhost tun ip6table_filter ip6_tables xt_multiport iptable_filter ip_tables x_tables cn fuse dummy bridge stp llc xfs libcrc32c ext3 jbd hwmon_vid loop firewire_sbp2 firewire_core crc_itu_t coretemp kvm_intel kvm crc32c_intel i2c_i801 iTCO_wdt iTCO_vendor_support psmouse i7core_edac microcode evdev i2c_core serio_raw edac_core lpc_ich mfd_core acpi_cpufreq processor thermal_sys button ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod sg sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ehci_pci ehci_hcd ahci libahci libata scsi_mod e1000e ptp pps_core usbcore usb_common
[2110283.371450] CPU: 1 PID: 12867 Comm: kworker/u16:3 Not tainted 3.12.5 #36
[2110283.378344] Hardware name: Supermicro X8SIL/X8SIL, BIOS 1.1 05/27/2010
[2110283.385068] Workqueue: writeback bdi_writeback_workfn (flush-253:3)
[2110283.391577] task: ffff880232c88fa0 ti: ffff8802258f2000 task.ti: ffff8802258f2000
[2110283.399262] RIP: 0010:[<ffffffff810714e4>]  [<ffffffff810714e4>] cpuacct_charge+0x62/0xaa
[2110283.407672] RSP: 0018:ffff88023fc43c28  EFLAGS: 00010096
[2110283.413173] RAX: 000000000000d250 RBX: ffff880232c88fa0 RCX: 0000000000000000
[2110283.420518] RDX: ffffffff816373e0 RSI: ffffffff81635040 RDI: ffff880232c88fa0
[2110283.427854] RBP: ffff88023fc43c58 R08: 0000000000026014 R09: 0000000000000001
[2110283.435191] R10: ffffffff81635040 R11: ffffffff81071482 R12: 0000000000a2b0c6
[2110283.442538] R13: 00000000258f2028 R14: 000124d6bff064e9 R15: ffff880232c88fa0
[2110283.449884] FS:  0000000000000000(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
[2110283.458181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[2110283.464123] CR2: 00000000ade1b4b0 CR3: 000000000160b000 CR4: 00000000000027e0
[2110283.471468] Stack:
[2110283.473677]  ffffffff81071482 0000000000000000 ffff88023fc43cb8 0000000000a2b0c6
[2110283.481367]  ffff880232c89008 ffff880232c88fa0 ffff88023fc43c88 ffffffff8106c3f8
[2110283.489059]  ffff88023fc53668 ffff880232c89008 0000000000000000 0000000000000001
[2110283.496750] Call Trace:
[2110283.499394]  <IRQ> 
[2110283.501498]  [<ffffffff81071482>] ? cpuacct_account_field+0xb2/0xb2
[2110283.508198]  [<ffffffff8106c3f8>] update_curr+0x11a/0x15f
[2110283.513793]  [<ffffffff8106c7fa>] entity_tick+0x1b/0xe7
[2110283.519214]  [<ffffffff8106c8ee>] task_tick_fair+0x28/0x46
[2110283.524898]  [<ffffffff81065c2d>] scheduler_tick+0x5d/0xc6
[2110283.530581]  [<ffffffff81045ebc>] update_process_times+0x5d/0x6d
[2110283.536781]  [<ffffffff810896cd>] tick_sched_handle+0x45/0x54
[2110283.542723]  [<ffffffff8108988e>] tick_sched_timer+0x58/0x78
[2110283.548579]  [<ffffffff8105c003>] __run_hrtimer+0xd5/0x17e
[2110283.554262]  [<ffffffff81089836>] ? tick_nohz_handler+0xab/0xab
[2110283.560377]  [<ffffffff8105c306>] hrtimer_interrupt+0xd6/0x1e4
[2110283.566406]  [<ffffffff8102ddb1>] hpet_interrupt_handler+0x25/0x2c
[2110283.572782]  [<ffffffff8107c790>] handle_irq_event_percpu+0x94/0x1d8
[2110283.579330]  [<ffffffff8107c910>] handle_irq_event+0x3c/0x5c
[2110283.585185]  [<ffffffff8107ebe4>] handle_edge_irq+0xa1/0xc6
[2110283.590952]  [<ffffffff81004577>] handle_irq+0x1f/0x28
[2110283.596289]  [<ffffffff8107abd1>] ? console_unlock+0x218/0x25e
[2110283.602317]  [<ffffffff81003cb3>] do_IRQ+0x48/0xaf
[2110283.607308]  [<ffffffff813bd96f>] common_interrupt+0x6f/0x6f
[2110283.613160]  <EOI> 
[2110283.615264]  [<ffffffff8108e7b5>] ? mark_held_locks+0x73/0x97
[2110283.621443]  [<ffffffff8107abd1>] ? console_unlock+0x218/0x25e
[2110283.627470]  [<ffffffff8107b1e4>] ? vprintk_emit+0x400/0x426
[2110283.633327]  [<ffffffff813b8ebc>] printk+0x48/0x4a
[2110283.638316]  [<ffffffff810638cb>] __might_sleep+0x87/0xf1
[2110283.643913]  [<ffffffff811d739f>] generic_make_request_checks+0x3e/0x2bf
[2110283.650807]  [<ffffffff811d7633>] generic_make_request+0x13/0xdf
[2110283.657015]  [<ffffffffa02d8d8c>] __map_bio+0xca/0x10a [dm_mod]
[2110283.663137]  [<ffffffffa02d90aa>] __clone_and_map_data_bio+0x17d/0x19b [dm_mod]
[2110283.670654]  [<ffffffffa02d9179>] __split_and_process_non_flush+0xb1/0x214 [dm_mod]
[2110283.678519]  [<ffffffffa02d94ae>] __split_and_process_bio+0x1d2/0x1f7 [dm_mod]
[2110283.685954]  [<ffffffffa02d6f20>] ? dm_suspend+0x189/0x189 [dm_mod]
[2110283.692422]  [<ffffffffa02d9653>] _dm_request+0x180/0x198 [dm_mod]
[2110283.698796]  [<ffffffffa02d9695>] dm_request+0x2a/0x2c [dm_mod]
[2110283.704910]  [<ffffffff811d76bc>] generic_make_request+0x9c/0xdf
[2110283.711114]  [<ffffffff811d780b>] submit_bio+0x10c/0x12b
[2110283.716622]  [<ffffffff810e35e1>] ? account_page_writeback+0xe/0x10
[2110283.723082]  [<ffffffff810e36d5>] ? test_set_page_writeback+0xf2/0x104
[2110283.729802]  [<ffffffff8110c422>] __swap_writepage+0x1df/0x1ef
[2110283.735855]  [<ffffffff8110c704>] ? end_swap_bio_read+0xb3/0xb3
[2110283.741973]  [<ffffffff813bd516>] ? _raw_spin_unlock+0x26/0x3a
[2110283.748003]  [<ffffffff8110d673>] ? page_swapcount+0x43/0x4b
[2110283.753857]  [<ffffffff8110c46a>] swap_writepage+0x38/0x3f
[2110283.759540]  [<ffffffff810ea7fa>] pageout+0x139/0x241
[2110283.764789]  [<ffffffff810eb51d>] shrink_page_list+0x44b/0x676
[2110283.770857]  [<ffffffff810ebdd3>] shrink_inactive_list+0x2a5/0x46a
[2110283.777229]  [<ffffffff8108eb01>] ? trace_hardirqs_on+0xd/0xf
[2110283.783170]  [<ffffffff810ec450>] shrink_lruvec+0x18f/0x34e
[2110283.788938]  [<ffffffff810ec65d>] shrink_zone+0x4e/0xf6
[2110283.794361]  [<ffffffff810ec86b>] shrink_zones+0x166/0x1ab
[2110283.800045]  [<ffffffff8114e3c0>] ? wakeup_flusher_threads+0xb4/0xd0
[2110283.806600]  [<ffffffff8114e32e>] ? wakeup_flusher_threads+0x22/0xd0
[2110283.813147]  [<ffffffff810ec921>] do_try_to_free_pages+0x71/0x2cf
[2110283.819436]  [<ffffffff810ecd6d>] try_to_free_pages+0x107/0x16e
[2110283.825552]  [<ffffffff810e1eb9>] ? get_page_from_freelist+0x631/0x68f
[2110283.832275]  [<ffffffff810e0f02>] __perform_reclaim+0x7f/0xc3
[2110283.838215]  [<ffffffff810e25a0>] __alloc_pages_slowpath+0x270/0x4d6
[2110283.844766]  [<ffffffff81067a47>] ? finish_task_switch+0x47/0xef
[2110283.850985]  [<ffffffff810e29a8>] __alloc_pages_nodemask+0x1a2/0x21d
[2110283.857533]  [<ffffffff81116a0a>] alloc_pages_current+0xef/0x110
[2110283.863735]  [<ffffffff8111d2dc>] alloc_slab_page+0x1d/0x4e
[2110283.869521]  [<ffffffff8111d35b>] allocate_slab+0x4e/0xf2
[2110283.875117]  [<ffffffff8111d57b>] new_slab+0x2b/0x144
[2110283.880366]  [<ffffffff8111ea9f>] __slab_alloc+0x17a/0x2bf
[2110283.886074]  [<ffffffffa0be0dad>] ? kmem_alloc+0x64/0xae [xfs]
[2110283.892102]  [<ffffffff8111f644>] ? __kmalloc+0xf2/0x12c
[2110283.897625]  [<ffffffffa0be0dad>] ? kmem_alloc+0x64/0xae [xfs]
[2110283.903649]  [<ffffffff8111f601>] __kmalloc+0xaf/0x12c
[2110283.908999]  [<ffffffffa0be0dad>] kmem_alloc+0x64/0xae [xfs]
[2110283.914878]  [<ffffffffa0be0e5f>] kmem_zalloc+0x11/0x2a [xfs]
[2110283.920852]  [<ffffffffa0c1a019>] xlog_cil_insert_format_items+0x11d/0x1ab [xfs]
[2110283.928473]  [<ffffffffa0c1a0e8>] xlog_cil_insert_items+0x41/0x190 [xfs]
[2110283.935386]  [<ffffffffa0c1a27e>] xfs_log_commit_cil+0x47/0x121 [xfs]
[2110283.942034]  [<ffffffffa0be03f9>] xfs_trans_commit+0x6a/0x1d8 [xfs]
[2110283.948504]  [<ffffffffa0bd6a43>] xfs_iomap_write_allocate+0x21b/0x2f5 [xfs]
[2110283.955776]  [<ffffffffa0bc6131>] xfs_map_blocks+0x141/0x21a [xfs]
[2110283.962161]  [<ffffffffa0bc64ce>] xfs_vm_writepage+0x2c4/0x4a6 [xfs]
[2110283.968726]  [<ffffffff810e33e6>] __writepage+0x15/0x34
[2110283.974148]  [<ffffffff810e481a>] write_cache_pages+0x284/0x3a6
[2110283.980264]  [<ffffffff810e33d1>] ? set_page_dirty+0x58/0x58
[2110283.986119]  [<ffffffff810e497f>] generic_writepages+0x43/0x5a
[2110283.992146]  [<ffffffff813bd516>] ? _raw_spin_unlock+0x26/0x3a
[2110283.998185]  [<ffffffffa0bc4f98>] xfs_vm_writepages+0x4b/0x56 [xfs]
[2110284.004646]  [<ffffffff810e49b4>] do_writepages+0x1e/0x27
[2110284.010242]  [<ffffffff8114db2e>] __writeback_single_inode+0x94/0x17b
[2110284.016876]  [<ffffffff8114e67b>] writeback_sb_inodes+0x29f/0x36f
[2110284.023167]  [<ffffffff813bd516>] ? _raw_spin_unlock+0x26/0x3a
[2110284.029195]  [<ffffffff8114e7be>] __writeback_inodes_wb+0x73/0xb4
[2110284.035482]  [<ffffffff8114ebe1>] wb_writeback+0x174/0x2a1
[2110284.041165]  [<ffffffff8103f6e2>] ? _local_bh_enable_ip+0xbc/0xc2
[2110284.047456]  [<ffffffff8114edad>] wb_do_writeback+0x9f/0x1d4
[2110284.053311]  [<ffffffff81051faa>] ? set_worker_desc+0x6a/0x77
[2110284.059251]  [<ffffffff8114ef4c>] bdi_writeback_workfn+0x6a/0x182
[2110284.065541]  [<ffffffff8108eabd>] ? trace_hardirqs_on_caller+0x151/0x188
[2110284.072435]  [<ffffffff810548c9>] process_one_work+0x294/0x429
[2110284.078464]  [<ffffffff8105480e>] ? process_one_work+0x1d9/0x429
[2110284.084666]  [<ffffffff81054bc7>] worker_thread+0x169/0x27e
[2110284.090434]  [<ffffffff81054a5e>] ? process_one_work+0x429/0x429
[2110284.096675]  [<ffffffff81058c3d>] kthread+0xd1/0xd9
[2110284.101750]  [<ffffffff81058b6c>] ? __init_kthread_worker+0x56/0x56
[2110284.108209]  [<ffffffff813be0bc>] ret_from_fork+0x7c/0xb0
[2110284.113805]  [<ffffffff81058b6c>] ? __init_kthread_worker+0x56/0x56
[2110284.120263] Code: 41 b8 01 00 00 00 b9 02 00 00 00 31 f6 48 c7 c7 40 50 63 81 e8 bd e7 01 00 48 8b 83 38 0e 00 00 48 8b 50 48 48 8b 82 a8 00 00 00 <4a> 03 04 ed 70 b3 68 81 4c 01 20 48 8b 52 40 48 85 d2 75 e5 48 
[2110284.140873] RIP  [<ffffffff810714e4>] cpuacct_charge+0x62/0xaa
[2110284.146924]  RSP <ffff88023fc43c28>
[2110284.150641] CR2: 00000000ade1b4b0
[2110284.154395] ---[ end trace 225de33a05f4e6b0 ]---
[2110284.164413] Kernel panic - not syncing: Fatal exception in interrupt


Regards,

Petr Janecek
