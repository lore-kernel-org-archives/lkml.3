Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936825Ab3DJUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935970Ab3DJUyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:54:43 -0400
Date: Wed, 10 Apr 2013 16:54:40 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: NULL pointer due to malformed bcache bio
Message-ID: <20130410205439.GA18092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

So DM core clearly needs to be more defensive about the possibility for
a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).

Seems bcache should be using bio_get_nr_vecs() or something else?

But by using a bcache bucket size of 2MB, with the bcache staged in
Jens' for-next, I've caused bcache to issue bios with nr_iovecs=512:

make-bcache --cache_replacement_policy=fifo -b 2048k --writeback --discard -B /dev/mapper/test-dev-353562 -C /dev/mapper/test-dev-447882

D, [2013-04-09T15:58:11.616445 #5093] DEBUG -- : executing: 'echo /dev/mapper/test-dev-353562 > /sys/fs/bcache/register'
D, [2013-04-09T15:58:11.678636 #5093] DEBUG -- : executing: 'echo /dev/mapper/test-dev-447882 > /sys/fs/bcache/register'
D, [2013-04-09T15:58:16.749473 #5093] DEBUG -- : command failed with '9': echo /dev/mapper/test-dev-447882 > /sys/fs/bcache/register

BUG: unable to handle kernel paging request at ffffffffffffffe8
IP: [<ffffffffa084a570>] alloc_tio+0x40/0x70 [dm_mod]
PGD 1a0d067 PUD 1a0f067 PMD 0 
Oops: 0002 [#1] SMP 
Modules linked in: dm_fake_discard dm_cache_cleaner dm_cache_mq dm_cache dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio libcrc32c dm_mod bcache ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe libfc 8021q garp scsi_transport_fc stp scsi_tgt llc sunrpc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support acpi_cpufreq freq_table mperf kvm_intel kvm microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core iomemory_vsl(O) skd(O) ixgbe dca ptp pps_core mdio ses enclosure sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas [last unloaded: dm_cache_mq]
CPU 2 
Pid: 5159, comm: sh Tainted: G        W  O 3.9.0-rc5.thin_dev+ #59 FUJITSU                          PRIMERGY RX300 S6             /D2619
RIP: 0010:[<ffffffffa084a570>]  [<ffffffffa084a570>] alloc_tio+0x40/0x70 [dm_mod]
RSP: 0018:ffff88030e7857c8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88030e7858f8 RCX: ffff88030e767948
RDX: ffffffffffffffe0 RSI: ffff88033fc4d820 RDI: 0000000000000286
RBP: ffff88030e7857e8 R08: ffff88032d8bdeb8 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000000 R12: ffffc9000934e040
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc9000934e040
FS:  00007f4a5826b700(0000) GS:ffff88033fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffe8 CR3: 00000003313a7000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 5159, threadinfo ffff88030e784000, task ffff88032db54a90)
Stack:
 ffff88030e7857f8 ffff880330918020 000000000007b000 0000000000000000
 ffff88030e785868 ffffffffa084ac98 ffff88030e785848 0001ffff8115ce53
 0000020000000000 0000000000005000 000000013ffd7d80 ffffc9000934e040
Call Trace:
 [<ffffffffa084ac98>] __clone_and_map_data_bio+0x158/0x1e0 [dm_mod]
 [<ffffffffa084af93>] __split_and_process_non_flush+0x273/0x2d0 [dm_mod]
 [<ffffffffa084b6bb>] ? dm_get_live_table+0x4b/0x60 [dm_mod]
 [<ffffffffa084bff7>] __split_and_process_bio+0x197/0x1b0 [dm_mod]
 [<ffffffffa084be27>] ? dm_merge_bvec+0xc7/0x100 [dm_mod]
 [<ffffffffa084c119>] _dm_request+0x109/0x160 [dm_mod]
 [<ffffffffa084c195>] dm_request+0x25/0x40 [dm_mod]
 [<ffffffff81237c2a>] generic_make_request+0xca/0x100
 [<ffffffffa0817216>] bch_generic_make_request_hack+0xa6/0xb0 [bcache]
 [<ffffffffa0817268>] bch_generic_make_request+0x48/0x100 [bcache]
 [<ffffffffa0817398>] __bch_submit_bbio+0x78/0x80 [bcache]
 [<ffffffffa08173d5>] bch_submit_bbio+0x35/0x40 [bcache]
 [<ffffffffa080e63a>] do_btree_write+0x2ba/0x3f0 [bcache]
 [<ffffffff810609c9>] ? try_to_grab_pending+0x119/0x180
 [<ffffffffa080e80c>] __btree_write+0x9c/0x1f0 [bcache]
 [<ffffffff81055498>] ? add_timer+0x18/0x30
 [<ffffffff810618b2>] ? __queue_delayed_work+0x92/0x1a0
 [<ffffffffa080eb7f>] bch_btree_write+0x1bf/0x250 [bcache]
 [<ffffffffa0822e39>] run_cache_set+0x599/0x620 [bcache]
 [<ffffffffa082363d>] register_cache_set+0x23d/0x310 [bcache]
 [<ffffffffa0823e19>] register_cache+0xb9/0x180 [bcache]
 [<ffffffffa082109e>] ? kzalloc.clone.1+0xe/0x10 [bcache]
 [<ffffffffa0824093>] register_bcache+0x1b3/0x220 [bcache]
 [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
 [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
 [<ffffffff8116c964>] vfs_write+0xb4/0x130
 [<ffffffff8116d12f>] sys_write+0x5f/0xa0
 [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
Code: 66 66 66 90 48 8b 07 49 89 f4 89 d6 48 89 fb bf 10 00 00 00 41 89 cd 48 8b 90 20 01 00 00 e8 18 95 95 e0 48 8b 4b 18 48 8d 50 e0 <4c> 89 60 e8 48 c7 40 f0 00 00 00 00 44 89 68 f8 48 89 48 e0 48 
RIP  [<ffffffffa084a570>] alloc_tio+0x40/0x70 [dm_mod]
 RSP <ffff88030e7857c8>
CR2: ffffffffffffffe8
---[ end trace e43b448c504cc112 ]---
