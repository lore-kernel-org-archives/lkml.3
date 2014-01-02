Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaABFb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 00:31:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:3722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaABFbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 00:31:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,589,1384329600"; 
   d="scan'208";a="452575702"
Date: Thu, 2 Jan 2014 13:31:01 +0800
From: fengguang.wu@intel.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140102053101.GA29352@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

We hit the below bug when doing write tests to btrfs.
Other filesystems (ext4, xfs) works fine. 2 full dmesgs are attached.

196d38bccfcfa32faed8c561868336fdfa0fe8e4 is the first bad commit
commit 196d38bccfcfa32faed8c561868336fdfa0fe8e4
Author:     Kent Overstreet <kmo@daterainc.com>
AuthorDate: Sat Nov 23 18:34:15 2013 -0800
Commit:     Kent Overstreet <kmo@daterainc.com>
CommitDate: Sat Nov 23 22:33:56 2013 -0800

    block: Generic bio chaining
    
    This adds a generic mechanism for chaining bio completions. This is
    going to be used for a bio_split() replacement, and it turns out to be
    very useful in a fair amount of driver code - a fair number of drivers
    were implementing this in their own roundabout ways, often painfully.
    
    Note that this means it's no longer to call bio_endio() more than once
    on the same bio! This can cause problems for drivers that save/restore
    bi_end_io. Arguably they shouldn't be saving/restoring bi_end_io at all
    - in all but the simplest cases they'd be better off just cloning the
    bio, and immutable biovecs is making bio cloning cheaper. But for now,
    we add a bio_endio_nodec() for these cases.
    
    Signed-off-by: Kent Overstreet <kmo@daterainc.com>
    Cc: Jens Axboe <axboe@kernel.dk>

 drivers/md/bcache/io.c       |  2 +-
 drivers/md/dm-cache-target.c |  6 ++++
 drivers/md/dm-snap.c         |  1 +
 drivers/md/dm-thin.c         |  8 +++--
 drivers/md/dm-verity.c       |  2 +-
 fs/bio-integrity.c           |  2 +-
 fs/bio.c                     | 76 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/bio.h          |  2 ++
 include/linux/blk_types.h    |  2 ++
 9 files changed, 90 insertions(+), 11 deletions(-)

[   35.466413] random: nonblocking pool is initialized
[  196.918039] ------------[ cut here ]------------
[  196.919770] kernel BUG at fs/bio.c:1748!
[  196.921505] invalid opcode: 0000 [#1] SMP
[  196.921788] Modules linked in: microcode processor
[  196.921788] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc6-01897-g2b48961 #1
[  196.921788] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  196.921788] task: ffff8804094acad0 ti: ffff8804094e8000 task.ti: ffff8804094e8000
[  196.921788] RIP: 0010:[<ffffffff811ef01e>]  [<ffffffff811ef01e>] bio_endio+0x1e/0x6a
[  196.921788] RSP: 0018:ffff88041fc83da8  EFLAGS: 00010046
[  196.921788] RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 00000001802a0002
[  196.921788] RDX: 00000001802a0003 RSI: 0000000000000000 RDI: ffff8800299ff9e8
[  196.921788] RBP: ffff88041fc83dc0 R08: ffffea00096cc980 R09: ffff8804097f5100
[  196.921788] R10: ffffea000aeb8280 R11: ffffffff8143841e R12: ffff88025b326780
[  196.921788] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000003000
[  196.921788] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:0000000000000000
[  196.921788] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  196.921788] CR2: 00007f16e7a1948f CR3: 000000007f85e000 CR4: 00000000000006e0
[  196.921788] Stack:
[  196.921788]  ffff8800299ff9e8 ffff8800299ff9e8 ffff88025b326780 ffff88041fc83de8
[  196.921788]  ffffffff81438429 00000000fffffffb ffff8803d36e6c00 0000000000000000
[  196.921788]  ffff88041fc83e10 ffffffff811ef063 ffff8802bae0a1e8 ffff8802bae0a1e8
[  196.921788] Call Trace:
[  196.921788]  <IRQ>
[  196.921788]  [<ffffffff81438429>] btrfs_end_bio+0x116/0x11d
[  196.921788]  [<ffffffff811ef063>] bio_endio+0x63/0x6a
[  196.921788]  [<ffffffff814cb712>] blk_mq_complete_request+0x89/0xfe
[  196.921788]  [<ffffffff814cb79d>] __blk_mq_end_io+0x16/0x18
[  196.921788]  [<ffffffff814cb7bf>] blk_mq_end_io+0x20/0xb1
[  196.921788]  [<ffffffff815a1ba9>] virtblk_done+0xa4/0xf6
[  196.921788]  [<ffffffff8155c463>] vring_interrupt+0x7c/0x8a
[  196.921788]  [<ffffffff81107427>] handle_irq_event_percpu+0x4a/0x1bc
[  196.921788]  [<ffffffff811075de>] handle_irq_event+0x45/0x61
[  196.921788]  [<ffffffff81109f40>] handle_edge_irq+0xd9/0xfb
[  196.921788]  [<ffffffff81039f56>] handle_irq+0x21/0x2a
[  196.921788]  [<ffffffff81a0c3fd>] do_IRQ+0x4d/0xb4
[  196.921788]  [<ffffffff81a034f2>] common_interrupt+0x72/0x72
[  196.921788]  <EOI>
[  196.921788]  [<ffffffff81065bfa>] ? native_safe_halt+0x6/0x8
[  196.921788]  [<ffffffff8103f5d8>] default_idle+0x38/0xc1
[  196.921788]  [<ffffffff8103fd04>] arch_cpu_idle+0x18/0x28
[  196.921788]  [<ffffffff81106b6b>] cpu_startup_entry+0x178/0x269
[  196.921788]  [<ffffffff81116954>] ? clockevents_register_device+0x112/0x117
[  196.921788]  [<ffffffff8105ba60>] start_secondary+0x277/0x279
[  196.921788] Code: ff ff eb bb 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 53 bb fb ff ff ff 48 85 ff 74 4c 8b 47 44 85 c0 7f 02 <0f> 0b 85 f6 74 07 f0 80 67 10 fe eb 09 48 8b 47 10 a8 01 0f 44
[  196.921788] RIP  [<ffffffff811ef01e>] bio_endio+0x1e/0x6a
[  196.921788]  RSP <ffff88041fc83da8>
[  196.921788] ---[ end trace 0ec0fc28f7931a30 ]---
[  196.921788] Kernel panic - not syncing: Fatal exception in interrupt
[  196.921788] Rebooting in 10 seconds..

Thanks,
Fengguang


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-dd

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc5-next-20131224-06549-g1ba337c (kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 SMP Tue Dec 24 14:39:32 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x02660000, 0x02660fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x743a0000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02  A M I)
[    0.000000] ACPI: XSDT 00000000bf421e18 00008C (v01  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bf41fd98 0000F4 (v04  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20131115/tbfadt-395)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT - 0xBF420F40/0x00000000BF420E40, using 32 (20131115/tbfadt-522)
[    0.000000] ACPI: DSDT 00000000bf418018 00601B (v01  A M I   ALASKA 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf420f40 000040
[    0.000000] ACPI: APIC 00000000bf41fc18 000130 (v02  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000bf415798 0006EE (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf422f18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf414c98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 00000000bf422e98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 00000000bf422e18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 00000000bf422d98 000040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 00000000bf41fa98 000130 (v01    AMI AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 00000000bf414a18 000210 (v01  AMIER AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 00000000bf414f18 0000A8 (v01    AMI AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 00000000bf422d18 000030 (v01    AMI AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bf415f18 0000D4 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s80960 r8192 d21440 u131072
[    0.000000] pcpu-alloc: s80960 r8192 d21440 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 01 02 03 04 05 06 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/reconfirm_dd-write-11HDD-RAID5-cfq-btrfs-1dd-x86_64-lkp-1ba337ca6cd05ea33029692dc837a43c05108cb7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/vmlinuz-3.13.0-rc5-next-20131224-06549-g1ba337c kconfig=x86_64-lkp commit=1ba337ca6cd05ea33029692dc837a43c05108cb7 modules_initrd=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16218204K/16765248K available (10428K kernel code, 1242K rwdata, 4148K rodata, 1436K init, 1732K bss, 547044K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc5-next-20131224-06549-g1ba337c (kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 SMP Tue Dec 24 14:39:32 CST 2013
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-ws02/reconfirm_dd-write-11HDD-RAID5-cfq-btrfs-1dd-x86_64-lkp-1ba337ca6cd05ea33029692dc837a43c05108cb7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/vmlinuz-3.13.0-rc5-next-20131224-06549-g1ba337c kconfig=x86_64-lkp commit=1ba337ca6cd05ea33029692dc837a43c05108cb7 modules_initrd=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x02660000, 0x02660fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x743a0000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02  A M I)
[    0.000000] ACPI: XSDT 00000000bf421e18 00008C (v01  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bf41fd98 0000F4 (v04  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20131115/tbfadt-395)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT - 0xBF420F40/0x00000000BF420E40, using 32 (20131115/tbfadt-522)
[    0.000000] ACPI: DSDT 00000000bf418018 00601B (v01  A M I   ALASKA 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf420f40 000040
[    0.000000] ACPI: APIC 00000000bf41fc18 000130 (v02  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000bf415798 0006EE (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf422f18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf414c98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 00000000bf422e98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 00000000bf422e18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 00000000bf422d98 000040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 00000000bf41fa98 000130 (v01    AMI AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 00000000bf414a18 000210 (v01  AMIER AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 00000000bf414f18 0000A8 (v01    AMI AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 00000000bf422d18 000030 (v01    AMI AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bf415f18 0000D4 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s80960 r8192 d21440 u131072
[    0.000000] pcpu-alloc: s80960 r8192 d21440 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 01 02 03 04 05 06 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/reconfirm_dd-write-11HDD-RAID5-cfq-btrfs-1dd-x86_64-lkp-1ba337ca6cd05ea33029692dc837a43c05108cb7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/vmlinuz-3.13.0-rc5-next-20131224-06549-g1ba337c kconfig=x86_64-lkp commit=1ba337ca6cd05ea33029692dc837a43c05108cb7 modules_initrd=/kernel/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16218204K/16765248K available (10428K kernel code, 1242K rwdata, 4148K rodata, 1436K init, 1732K bss, 547044K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2800.059 MHz processor
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.11 BogoMIPS (lpj=11200236)
[    0.010825] pid_max: default: 32768 minimum: 301
[    0.016622] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.027181] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.035761] Mount-cache hash table entries: 256
[    0.040578] Initializing cgroup subsys memory
[    0.045005] Initializing cgroup subsys devices
[    0.049710] Initializing cgroup subsys freezer
[    0.054420] Initializing cgroup subsys blkio
[    0.058956] Initializing cgroup subsys perf_event
[    0.063928] Initializing cgroup subsys hugetlb
[    0.068670] CPU: Physical Processor ID: 1
[    0.072946] CPU: Processor Core ID: 0
[    0.076875] mce: CPU supports 9 MCE banks
[    0.081157] CPU0: Thermal LVT vector (0xfa) already installed
[    0.087178] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.087178] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.087178] tlb_flushall_shift: 6
[    0.102404] Freeing SMP alternatives memory: 44K (ffffffff8249f000 - ffffffff824aa000)
[    0.112102] ACPI: Core revision 20131115
[    0.119433] ACPI: All ACPI Tables successfully acquired
[    0.125057] ftrace: allocating 39790 entries in 156 pages
[    0.147423] Getting VERSION: 1060015
[    0.151262] Getting VERSION: 1060015
[    0.155104] Getting ID: 20000000
[    0.158599] Getting ID: 20000000
[    0.162087] Switched APIC routing to physical flat.
[    0.167231] masked ExtINT on CPU#0
[    0.171428] ENABLING IO-APIC IRQs
[    0.175011] init IO_APIC IRQs
[    0.178246]  apic 0 pin 0 not connected
[    0.182352] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:32)
[    0.190843] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:32)
[    0.199327] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:32)
[    0.207825] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:32)
[    0.216310] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:32)
[    0.224793] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:32)
[    0.233284] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:32)
[    0.241767] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:32)
[    0.250252] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:32)
[    0.258742] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:32)
[    0.267399] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:32)
[    0.276064] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:32)
[    0.284720] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:32)
[    0.293384] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:32)
[    0.302051] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:32)
[    0.310705]  apic 0 pin 16 not connected
[    0.314892]  apic 0 pin 17 not connected
[    0.319083]  apic 0 pin 18 not connected
[    0.323271]  apic 0 pin 19 not connected
[    0.327460]  apic 0 pin 20 not connected
[    0.331650]  apic 0 pin 21 not connected
[    0.335840]  apic 0 pin 22 not connected
[    0.340030]  apic 0 pin 23 not connected
[    0.344219]  apic 2 pin 0 not connected
[    0.348320]  apic 2 pin 1 not connected
[    0.352425]  apic 2 pin 2 not connected
[    0.356527]  apic 2 pin 3 not connected
[    0.360629]  apic 2 pin 4 not connected
[    0.364732]  apic 2 pin 5 not connected
[    0.368835]  apic 2 pin 6 not connected
[    0.372937]  apic 2 pin 7 not connected
[    0.377041]  apic 2 pin 8 not connected
[    0.381143]  apic 2 pin 9 not connected
[    0.385246]  apic 2 pin 10 not connected
[    0.389434]  apic 2 pin 11 not connected
[    0.393624]  apic 2 pin 12 not connected
[    0.397815]  apic 2 pin 13 not connected
[    0.402003]  apic 2 pin 14 not connected
[    0.406193]  apic 2 pin 15 not connected
[    0.410382]  apic 2 pin 16 not connected
[    0.414573]  apic 2 pin 17 not connected
[    0.418761]  apic 2 pin 18 not connected
[    0.422951]  apic 2 pin 19 not connected
[    0.427140]  apic 2 pin 20 not connected
[    0.431330]  apic 2 pin 21 not connected
[    0.435519]  apic 2 pin 22 not connected
[    0.439707]  apic 2 pin 23 not connected
[    0.443897]  apic 3 pin 0 not connected
[    0.447999]  apic 3 pin 1 not connected
[    0.452103]  apic 3 pin 2 not connected
[    0.456205]  apic 3 pin 3 not connected
[    0.460308]  apic 3 pin 4 not connected
[    0.464411]  apic 3 pin 5 not connected
[    0.468514]  apic 3 pin 6 not connected
[    0.472616]  apic 3 pin 7 not connected
[    0.476718]  apic 3 pin 8 not connected
[    0.480821]  apic 3 pin 9 not connected
[    0.484924]  apic 3 pin 10 not connected
[    0.489114]  apic 3 pin 11 not connected
[    0.493303]  apic 3 pin 12 not connected
[    0.497493]  apic 3 pin 13 not connected
[    0.501683]  apic 3 pin 14 not connected
[    0.505872]  apic 3 pin 15 not connected
[    0.510062]  apic 3 pin 16 not connected
[    0.514249]  apic 3 pin 17 not connected
[    0.518440]  apic 3 pin 18 not connected
[    0.522628]  apic 3 pin 19 not connected
[    0.526819]  apic 3 pin 20 not connected
[    0.531008]  apic 3 pin 21 not connected
[    0.535198]  apic 3 pin 22 not connected
[    0.539388]  apic 3 pin 23 not connected
[    0.543575]  apic 4 pin 0 not connected
[    0.547678]  apic 4 pin 1 not connected
[    0.551783]  apic 4 pin 2 not connected
[    0.555885]  apic 4 pin 3 not connected
[    0.559988]  apic 4 pin 4 not connected
[    0.564090]  apic 4 pin 5 not connected
[    0.568191]  apic 4 pin 6 not connected
[    0.572296]  apic 4 pin 7 not connected
[    0.576399]  apic 4 pin 8 not connected
[    0.580501]  apic 4 pin 9 not connected
[    0.584603]  apic 4 pin 10 not connected
[    0.588791]  apic 4 pin 11 not connected
[    0.592973]  apic 4 pin 12 not connected
[    0.597162]  apic 4 pin 13 not connected
[    0.601351]  apic 4 pin 14 not connected
[    0.605542]  apic 4 pin 15 not connected
[    0.609731]  apic 4 pin 16 not connected
[    0.613921]  apic 4 pin 17 not connected
[    0.618109]  apic 4 pin 18 not connected
[    0.622299]  apic 4 pin 19 not connected
[    0.626488]  apic 4 pin 20 not connected
[    0.630677]  apic 4 pin 21 not connected
[    0.634867]  apic 4 pin 22 not connected
[    0.639057]  apic 4 pin 23 not connected
[    0.643375] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.689363] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (fam: 06, model: 2c, stepping: 01)
[    0.699946] Using local APIC timer interrupts.
[    0.699946] calibrating APIC timer ...
[    0.814342] ... lapic delta = 833352
[    0.818177] ... PM-Timer delta = 357949
[    0.822280] ... PM-Timer result ok
[    0.825949] ..... delta 833352
[    0.829270] ..... mult: 35792195
[    0.832758] ..... calibration result: 533345
[    0.837293] ..... CPU clock speed is 2800.0224 MHz.
[    0.842436] ..... host bus clock speed is 133.1345 MHz.
[    0.847939] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.857036] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.864175] ... version:                3
[    0.868451] ... bit width:              48
[    0.872813] ... generic registers:      4
[    0.877091] ... value mask:             0000ffffffffffff
[    0.882666] ... max period:             000000007fffffff
[    0.888245] ... fixed-purpose events:   3
[    0.892520] ... event mask:             000000070000000f
[    0.899781] x86: Booting SMP configuration:
[    0.904233] .... node  #0, CPUs:        #1
[    0.919354] masked ExtINT on CPU#1
[    0.922785] CPU1: Thermal LVT vector (0xfa) already installed
  #2
[    1.039648] masked ExtINT on CPU#2
[    1.043084] CPU2: Thermal LVT vector (0xfa) already installed
  #3
[    1.062415] masked ExtINT on CPU#3
[    1.065844] CPU3: Thermal LVT vector (0xfa) already installed
  #4
[    1.085184] masked ExtINT on CPU#4
[    1.088613] CPU4: Thermal LVT vector (0xfa) already installed
  #5
[    1.107954] masked ExtINT on CPU#5
[    1.111388] CPU5: Thermal LVT vector (0xfa) already installed
  #6
[    1.130712] masked ExtINT on CPU#6
[    1.134139] CPU6: Thermal LVT vector (0xfa) already installed

[    1.142505] .... node  #1, CPUs:    #7
[    1.157221] masked ExtINT on CPU#7
[    1.160656] CPU7: Thermal LVT vector (0xfa) already installed
  #8
[    1.180034] masked ExtINT on CPU#8
[    1.183473] CPU8: Thermal LVT vector (0xfa) already installed
  #9
[    1.202848] masked ExtINT on CPU#9
[    1.206282] CPU9: Thermal LVT vector (0xfa) already installed
 #10
[    1.225667] masked ExtINT on CPU#10
[    1.229189] CPU10: Thermal LVT vector (0xfa) already installed
 #11
[    1.248687] masked ExtINT on CPU#11
[    1.252210] CPU11: Thermal LVT vector (0xfa) already installed

[    1.260721] .... node  #0, CPUs:   #12
[    1.275436] masked ExtINT on CPU#12
[    1.278957] CPU12: Thermal LVT vector (0xfa) already installed
 #13
[    1.298411] masked ExtINT on CPU#13
[    1.301934] CPU13: Thermal LVT vector (0xfa) already installed
 #14
[    1.321379] masked ExtINT on CPU#14
[    1.324899] CPU14: Thermal LVT vector (0xfa) already installed
 #15
[    1.344357] masked ExtINT on CPU#15
[    1.347879] CPU15: Thermal LVT vector (0xfa) already installed
 #16
[    1.367323] masked ExtINT on CPU#16
[    1.370835] CPU16: Thermal LVT vector (0xfa) already installed
 #17
[    1.390293] masked ExtINT on CPU#17
[    1.393811] CPU17: Thermal LVT vector (0xfa) already installed

[    1.402275] .... node  #1, CPUs:   #18
[    1.416999] masked ExtINT on CPU#18
[    1.420523] CPU18: Thermal LVT vector (0xfa) already installed
 #19
[    1.440029] masked ExtINT on CPU#19
[    1.443550] CPU19: Thermal LVT vector (0xfa) already installed
 #20
[    1.463050] masked ExtINT on CPU#20
[    1.466574] CPU20: Thermal LVT vector (0xfa) already installed
 #21
[    1.486062] masked ExtINT on CPU#21
[    1.489584] CPU21: Thermal LVT vector (0xfa) already installed
 #22
[    1.509090] masked ExtINT on CPU#22
[    1.512614] CPU22: Thermal LVT vector (0xfa) already installed
 #23
[    1.532109] masked ExtINT on CPU#23
[    1.535635] CPU23: Thermal LVT vector (0xfa) already installed

[    1.543600] x86: Booted up 2 nodes, 24 CPUs
[    1.548509] smpboot: Total of 24 processors activated (134404.46 BogoMIPS)
[    1.583938] devtmpfs: initialized
[    1.592228] PM: Registering ACPI NVS region [mem 0xbf30b000-0xbf38afff] (524288 bytes)
[    1.600644] PM: Registering ACPI NVS region [mem 0xbf3a1000-0xbf3a1fff] (4096 bytes)
[    1.608874] PM: Registering ACPI NVS region [mem 0xbf3b3000-0xbf3b5fff] (12288 bytes)
[    1.617187] PM: Registering ACPI NVS region [mem 0xbf3de000-0xbf3defff] (4096 bytes)
[    1.625410] PM: Registering ACPI NVS region [mem 0xbf416000-0xbf417fff] (8192 bytes)
[    1.633634] PM: Registering ACPI NVS region [mem 0xbf420000-0xbf420fff] (4096 bytes)
[    1.641855] PM: Registering ACPI NVS region [mem 0xbf423000-0xbf42afff] (32768 bytes)
[    1.656601] PM: Registering ACPI NVS region [mem 0xbf454000-0xbf656fff] (2109440 bytes)
[    1.666510] xor: measuring software checksum speed
[    1.708623]    prefetch64-sse: 11587.000 MB/sec
[    1.752659]    generic_sse: 10189.000 MB/sec
[    1.757200] xor: using function: prefetch64-sse (11587.000 MB/sec)
[    1.763659] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.770877] NET: Registered protocol family 16
[    1.776235] cpuidle: using governor ladder
[    1.780603] cpuidle: using governor menu
[    1.785186] ACPI: bus type PCI registered
[    1.789466] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.796264] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.806060] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.829583] PCI: Using configuration type 1 for base access
[    1.846275] bio: create slab <bio-0> at 0
[    1.916793] raid6: sse2x1    6727 MB/s
[    1.988850] raid6: sse2x2    7990 MB/s
[    2.060907] raid6: sse2x4    8839 MB/s
[    2.064926] raid6: using algorithm sse2x4 (8839 MB/s)
[    2.070242] raid6: using ssse3x2 recovery algorithm
[    2.075465] ACPI: Added _OSI(Module Device)
[    2.079918] ACPI: Added _OSI(Processor Device)
[    2.084623] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.089593] ACPI: Added _OSI(Processor Aggregator Device)
[    2.097202] ACPI: Executed 1 blocks of module-level executable AML code
[    2.106384] \_SB_:_OSC evaluation returned wrong type
[    2.111704] _OSC request data:1 17 
[    2.124994] ACPI: SSDT 00000000bf416018 001494 (v01    AMI      IST 00000001 MSFT 03000001)
[    2.134581] ACPI: Dynamic OEM Table Load:
[    2.138988] ACPI: SSDT           (null) 001494 (v01    AMI      IST 00000001 MSFT 03000001)
[    2.150454] ACPI: Interpreter enabled
[    2.154395] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    2.164230] ACPI: (supports S0 S1 S3 S4 S5)
[    2.168681] ACPI: Using IOAPIC for interrupt routing
[    2.174027] HEST: Table parsing has been initialized.
[    2.179353] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.189066] ACPI: No dock devices found.
[    2.194416] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.208847] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.215300] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.224160] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    2.232952] PCI host bridge to bus 0000:00
[    2.237320] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.243078] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.249530] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.255975] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.263121] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    2.270272] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    2.276601] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.283069] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    2.289395] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.295868] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    2.302193] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.308661] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    2.314987] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    2.321456] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    2.327782] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.334249] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    2.340577] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.347044] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    2.353331] pci 0000:00:13.0: reg 0x10: [mem 0xfbe24000-0xfbe24fff]
[    2.359909] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    2.366368] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    2.372776] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    2.379183] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    2.385579] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    2.391976] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    2.398261] pci 0000:00:16.0: reg 0x10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    2.405454] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    2.411738] pci 0000:00:16.1: reg 0x10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    2.418936] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    2.425219] pci 0000:00:16.2: reg 0x10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    2.432413] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    2.438696] pci 0000:00:16.3: reg 0x10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    2.445892] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    2.452177] pci 0000:00:16.4: reg 0x10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    2.459370] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    2.465656] pci 0000:00:16.5: reg 0x10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    2.472849] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    2.479136] pci 0000:00:16.6: reg 0x10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    2.486330] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    2.492615] pci 0000:00:16.7: reg 0x10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    2.499811] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    2.506130] pci 0000:00:1a.0: reg 0x20: [io  0xf0c0-0xf0df]
[    2.512059] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.518055] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    2.524369] pci 0000:00:1a.2: reg 0x20: [io  0xf0a0-0xf0bf]
[    2.530299] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    2.536299] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    2.542591] pci 0000:00:1a.7: reg 0x10: [mem 0xfbe23000-0xfbe233ff]
[    2.549209] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.555623] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    2.561615] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    2.567957] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.574366] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.580362] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    2.586701] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.593109] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    2.599106] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    2.605417] pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
[    2.611345] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.617334] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    2.623650] pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
[    2.629577] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    2.635569] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    2.641881] pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
[    2.647810] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    2.653811] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    2.660104] pci 0000:00:1d.7: reg 0x10: [mem 0xfbe22000-0xfbe223ff]
[    2.666722] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.673132] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    2.679124] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    2.685488] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    2.691479] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    2.697827] pci 0000:00:1f.0: address space collision: [io  0x0400-0x047f] conflicts with ACPI CPU throttle [??? 0x00000410-0x00000415 flags 0x80000000]
[    2.711964] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    2.719370] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    2.727419] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    2.735470] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    2.743527] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    2.751707] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    2.758000] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    2.763846] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    2.769690] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    2.775537] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    2.781384] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    2.787231] pci 0000:00:1f.2: reg 0x24: [mem 0xfbe21000-0xfbe217ff]
[    2.793803] pci 0000:00:1f.2: PME# supported from D3hot
[    2.799404] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    2.805694] pci 0000:00:1f.3: reg 0x10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    2.812767] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    2.818783] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[    2.825070] pci 0000:01:00.0: reg 0x10: [mem 0xfbaa0000-0xfbabffff]
[    2.831615] pci 0000:01:00.0: reg 0x14: [mem 0xfba80000-0xfba9ffff]
[    2.838163] pci 0000:01:00.0: reg 0x18: [io  0xe020-0xe03f]
[    2.844010] pci 0000:01:00.0: reg 0x1c: [mem 0xfbb44000-0xfbb47fff]
[    2.850562] pci 0000:01:00.0: reg 0x30: [mem 0xfba60000-0xfba7ffff pref]
[    2.857584] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.863977] pci 0000:01:00.0: reg 0x184: [mem 0xfbb20000-0xfbb23fff 64bit]
[    2.871139] pci 0000:01:00.0: reg 0x190: [mem 0xfbb00000-0xfbb03fff 64bit]
[    2.878366] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[    2.884650] pci 0000:01:00.1: reg 0x10: [mem 0xfba40000-0xfba5ffff]
[    2.891195] pci 0000:01:00.1: reg 0x14: [mem 0xfba20000-0xfba3ffff]
[    2.897735] pci 0000:01:00.1: reg 0x18: [io  0xe000-0xe01f]
[    2.903581] pci 0000:01:00.1: reg 0x1c: [mem 0xfbb40000-0xfbb43fff]
[    2.910134] pci 0000:01:00.1: reg 0x30: [mem 0xfba00000-0xfba1ffff pref]
[    2.917155] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    2.923543] pci 0000:01:00.1: reg 0x184: [mem 0xfbae0000-0xfbae3fff 64bit]
[    2.930703] pci 0000:01:00.1: reg 0x190: [mem 0xfbac0000-0xfbac3fff 64bit]
[    2.945624] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.951124] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.957492] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    2.964621] pci 0000:00:03.0: PCI bridge to [bus 03]
[    2.969919] pci 0000:00:05.0: PCI bridge to [bus 04]
[    2.975220] pci 0000:00:07.0: PCI bridge to [bus 05]
[    2.980541] pci 0000:06:00.0: [8086:0329] type 01 class 0x060400
[    2.986832] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    2.994019] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    3.000464] pci 0000:06:00.2: [8086:032a] type 01 class 0x060400
[    3.006753] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    3.013947] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    3.020391] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.030886] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    3.036379] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    3.042738] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.056320] pci 0000:06:00.0: PCI bridge to [bus 07]
[    3.061648] pci 0000:08:01.0: [8086:1229] type 00 class 0x020000
[    3.067940] pci 0000:08:01.0: reg 0x10: [mem 0xfb900000-0xfb900fff]
[    3.074479] pci 0000:08:01.0: reg 0x14: [io  0xd000-0xd03f]
[    3.080325] pci 0000:08:01.0: reg 0x18: [mem 0xfb800000-0xfb8fffff]
[    3.086886] pci 0000:08:01.0: reg 0x30: [mem 0xfb700000-0xfb7fffff pref]
[    3.093880] pci 0000:08:01.0: supports D1 D2
[    3.098421] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.105416] pci 0000:06:00.2: PCI bridge to [bus 08]
[    3.110653] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    3.117019] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.124174] pci 0000:09:00.0: [1000:0058] type 00 class 0x010000
[    3.130465] pci 0000:09:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    3.136322] pci 0000:09:00.0: reg 0x14: [mem 0xfb610000-0xfb613fff 64bit]
[    3.143391] pci 0000:09:00.0: reg 0x1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    3.150464] pci 0000:09:00.0: reg 0x30: [mem 0xfb400000-0xfb5fffff pref]
[    3.157491] pci 0000:09:00.0: supports D1 D2
[    3.162089] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.172579] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    3.177813] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    3.184180] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    3.191242] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    3.199557] pci 0000:0a:00.0: [197b:2368] type 00 class 0x010185
[    3.205855] pci 0000:0a:00.0: reg 0x10: [io  0xb040-0xb047]
[    3.211703] pci 0000:0a:00.0: reg 0x14: [io  0xb030-0xb033]
[    3.217557] pci 0000:0a:00.0: reg 0x18: [io  0xb020-0xb027]
[    3.223412] pci 0000:0a:00.0: reg 0x1c: [io  0xb010-0xb013]
[    3.229266] pci 0000:0a:00.0: reg 0x20: [io  0xb000-0xb00f]
[    3.235134] pci 0000:0a:00.0: reg 0x30: [mem 0xfbd00000-0xfbd0ffff pref]
[    3.242233] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.252727] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    3.257958] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    3.264325] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    3.271387] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.279688] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    3.285981] pci 0000:0b:01.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
[    3.292963] pci 0000:0b:01.0: reg 0x14: [io  0xa000-0xa0ff]
[    3.298809] pci 0000:0b:01.0: reg 0x18: [mem 0xfbc20000-0xfbc2ffff]
[    3.305371] pci 0000:0b:01.0: reg 0x30: [mem 0xfbc00000-0xfbc1ffff pref]
[    3.312365] pci 0000:0b:01.0: supports D1 D2
[    3.316992] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive decode)
[    3.324052] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    3.330419] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    3.337481] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    3.345709] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    3.354114] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    3.362519] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.371619] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    3.381205] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.390302] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.399396] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.408486] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    3.417568] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.426892] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.436217] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.445542] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.454651] ACPI: Enabled 2 GPEs in block 00 to 3F
[    3.459986] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    3.468565] vgaarb: loaded
[    3.471539] vgaarb: bridge control possible 0000:0b:01.0
[    3.477230] SCSI subsystem initialized
[    3.481367] libata version 3.00 loaded.
[    3.485564] ACPI: bus type USB registered
[    3.489900] usbcore: registered new interface driver usbfs
[    3.495685] usbcore: registered new interface driver hub
[    3.501312] usbcore: registered new device driver usb
[    3.506720] pps_core: LinuxPPS API ver. 1 registered
[    3.511951] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.521589] PTP clock support registered
[    3.525958] EDAC MC: Ver: 3.0.0
[    3.529576] PCI: Using ACPI for IRQ routing
[    3.539360] PCI: Discovered peer bus fe
[    3.543462] PCI: root bus fe: using default resources
[    3.548782] PCI: Probing PCI hardware (bus fe)
[    3.553546] PCI host bridge to bus 0000:fe
[    3.557916] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    3.564367] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    3.571688] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    3.580096] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[    3.586436] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[    3.592779] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[    3.599120] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[    3.605456] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[    3.611797] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[    3.618135] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[    3.624484] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[    3.630829] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[    3.637169] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[    3.643508] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[    3.649852] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[    3.656189] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[    3.662531] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[    3.668871] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[    3.675212] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[    3.681551] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[    3.687893] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[    3.694234] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[    3.700578] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[    3.706914] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[    3.713252] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[    3.719594] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[    3.725935] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[    3.732286] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    3.739172] PCI: Discovered peer bus ff
[    3.743270] PCI: root bus ff: using default resources
[    3.748586] PCI: Probing PCI hardware (bus ff)
[    3.753346] PCI host bridge to bus 0000:ff
[    3.757712] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    3.764165] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    3.771477] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    3.779886] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    3.786227] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    3.792578] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    3.798919] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    3.805265] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    3.811607] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    3.817968] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    3.824309] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    3.830661] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    3.837003] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    3.843349] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    3.849696] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    3.856048] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    3.862411] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    3.868756] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    3.875100] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    3.881454] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    3.887798] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    3.894143] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    3.900488] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    3.906836] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    3.913178] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    3.919524] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    3.925871] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    3.932237] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    3.938867] PCI: pci_cache_line_size set to 64 bytes
[    3.944212] e820: reserve RAM buffer [mem 0x0009c800-0x0009ffff]
[    3.950488] e820: reserve RAM buffer [mem 0xbf30b000-0xbfffffff]
[    3.956757] e820: reserve RAM buffer [mem 0xbf3de000-0xbfffffff]
[    3.963028] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    3.969868] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.975594] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.983742] Switched to clocksource hpet
[    3.997719] pnp: PnP ACPI init
[    4.001063] ACPI: bus type PNP registered
[    4.005453] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    4.012341] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    4.019227] system 00:00: [mem 0xfe000000-0xfe9fffff] has been reserved
[    4.026115] system 00:00: [mem 0xfea00000-0xfea0001f] has been reserved
[    4.033001] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
[    4.039888] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    4.047123] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
[    4.054010] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.061260] system 00:01: [io  0x0290-0x029f] has been reserved
[    4.067455] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.074542] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:32)
[    4.083101] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    4.097280] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:32)
[    4.105998] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    4.113963] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:32)
[    4.122459] pnp 00:04: [dma 0 disabled]
[    4.126648] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.133638] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:32)
[    4.142130] pnp 00:05: [dma 0 disabled]
[    4.146327] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.153218] pnp 00:06: [dma 4]
[    4.156595] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.163405] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:32)
[    4.171948] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.178810] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.185705] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    4.191897] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.198964] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:32)
[    4.207679] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.214695] system 00:0b: [io  0x0400-0x047f] could not be reserved
[    4.221232] system 00:0b: [io  0x1180-0x119f] has been reserved
[    4.227424] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    4.233963] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    4.240849] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
[    4.248083] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    4.254972] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.262164] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.269097] pnp: PnP ACPI: found 13 devices
[    4.273552] ACPI: bus type PNP unregistered
[    4.287214] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alignment
[    4.294622] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    4.300118] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    4.306488] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    4.313548] pci 0000:00:03.0: PCI bridge to [bus 03]
[    4.318790] pci 0000:00:05.0: PCI bridge to [bus 04]
[    4.324030] pci 0000:00:07.0: PCI bridge to [bus 05]
[    4.329267] pci 0000:06:00.0: PCI bridge to [bus 07]
[    4.334507] pci 0000:06:00.2: PCI bridge to [bus 08]
[    4.339740] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    4.346108] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.353170] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    4.358667] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    4.365033] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.372097] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    4.377333] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    4.383700] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    4.390761] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.398994] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    4.404231] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    4.410598] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    4.417659] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.425890] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    4.431127] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    4.437495] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    4.444555] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.452789] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.458629] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.464467] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.471008] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    4.477548] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.483394] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    4.489933] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.495771] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.502313] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    4.508157] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.514690] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    4.520535] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    4.527076] pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.534785] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    4.540624] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    4.547163] pci_bus 0000:0a: resource 2 [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.554865] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    4.560703] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    4.567244] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.574946] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    4.580783] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    4.586628] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    4.593162] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    4.599702] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    4.605547] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    4.612261] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    4.618106] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    4.624857] NET: Registered protocol family 2
[    4.629699] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    4.637849] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.644993] TCP: Hash tables configured (established 131072 bind 65536)
[    4.651937] TCP: reno registered
[    4.655457] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    4.661883] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    4.668839] NET: Registered protocol family 1
[    4.673596] RPC: Registered named UNIX socket transport module.
[    4.679786] RPC: Registered udp transport module.
[    4.684754] RPC: Registered tcp transport module.
[    4.689726] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.696604] IOAPIC[0]: Set routing entry (0-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:32)
[    4.705481] IOAPIC[0]: Set routing entry (0-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:32)
[    4.714351] IOAPIC[0]: Set routing entry (0-18 -> 0x61 -> IRQ 18 Mode:1 Active:1 Dest:32)
[    4.723231] IOAPIC[0]: Set routing entry (0-23 -> 0x71 -> IRQ 23 Mode:1 Active:1 Dest:32)
[    4.732618] pci 0000:06:00.0: rerouting interrupts for [8086:0329]
[    4.739073] pci 0000:06:00.2: rerouting interrupts for [8086:032a]
[    4.745541] pci 0000:0b:01.0: Boot video device
[    4.750385] PCI: CLS 64 bytes, default 64
[    4.754704] Trying to unpack rootfs image as initramfs...
[    8.246251] Freeing initrd memory: 192844K (ffff8800743a0000 - ffff88007fff3000)
[    8.254147] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.260862] software IO TLB [mem 0xbb30b000-0xbf30b000] (64MB) mapped at [ffff8800bb30b000-ffff8800bf30afff]
[    8.271787] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    8.281897] Scanning for low memory corruption every 60 seconds
[    8.289099] SSE version of gcm_enc/dec engaged.
[    8.294512] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    8.301035] AVX or AES-NI instructions are not detected.
[    8.306611] AVX instructions are not detected.
[    8.311323] AVX instructions are not detected.
[    8.316032] AVX instructions are not detected.
[    8.320742] AVX instructions are not detected.
[    8.348913] bounce pool size: 64 pages
[    8.352933] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.363345] VFS: Disk quotas dquot_6.5.2
[    8.367621] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.375859] NFS: Registering the id_resolver key type
[    8.381198] Key type id_resolver registered
[    8.385646] Key type id_legacy registered
[    8.389927] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    8.396898] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    8.403909] ROMFS MTD (C) 2007 Red Hat, Inc.
[    8.408570] fuse init (API version 7.22)
[    8.412990] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    8.424076] bio: create slab <bio-1> at 1
[    8.428727] Btrfs loaded
[    8.431540] msgmni has been set to 32052
[    8.437848] NET: Registered protocol family 38
[    8.442566] Key type asymmetric registered
[    8.447018] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    8.454979] io scheduler noop registered
[    8.459175] io scheduler deadline registered
[    8.463717] io scheduler cfq registered (default)
[    8.469035] IOAPIC[3]: Set routing entry (4-4 -> 0x81 -> IRQ 76 Mode:1 Active:1 Dest:32)
[    8.477648] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    8.483455] IOAPIC[3]: Set routing entry (4-0 -> 0xa1 -> IRQ 72 Mode:1 Active:1 Dest:32)
[    8.492055] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    8.497850] IOAPIC[3]: Set routing entry (4-2 -> 0xc1 -> IRQ 74 Mode:1 Active:1 Dest:32)
[    8.506452] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    8.512245] IOAPIC[3]: Set routing entry (4-6 -> 0xe1 -> IRQ 78 Mode:1 Active:1 Dest:32)
[    8.520842] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    8.526644] IOAPIC[3]: Set routing entry (4-8 -> 0x42 -> IRQ 80 Mode:1 Active:1 Dest:32)
[    8.535240] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    8.541037] IOAPIC[0]: Set routing entry (0-17 -> 0x62 -> IRQ 17 Mode:1 Active:1 Dest:32)
[    8.549726] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    8.555593] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    8.561414] aer 0000:00:01.0:pcie02: service driver aer loaded
[    8.567541] aer 0000:00:03.0:pcie02: service driver aer loaded
[    8.573668] aer 0000:00:05.0:pcie02: service driver aer loaded
[    8.579794] aer 0000:00:07.0:pcie02: service driver aer loaded
[    8.585917] aer 0000:00:09.0:pcie02: service driver aer loaded
[    8.598494] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    8.605728] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    8.612526] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    8.619327] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    8.626307] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    8.633545] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    8.640532] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    8.647769] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    8.654748] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    8.661986] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    8.668964] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    8.676192] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    8.682993] pci 0000:06:00.2: Signaling PME through PCIe PME interrupt
[    8.689791] pci 0000:08:01.0: Signaling PME through PCIe PME interrupt
[    8.696594] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    8.703580] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    8.710818] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    8.717619] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    8.724606] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    8.731842] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[    8.738645] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    8.745654] ioapic: probe of 0000:00:13.0 failed with error -22
[    8.751879] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.757803] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    8.768979] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    8.775611] pciehp 0000:00:1c.4:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    8.786783] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    8.793437] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.800324] intel_idle: MWAIT substates: 0x1120
[    8.805117] intel_idle: v0.4 model 0x2C
[    8.809222] intel_idle: lapic_timer_reliable_states 0xffffffff
[    8.816260] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    8.824922] ACPI: Sleep Button [SLPB]
[    8.828919] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    8.837577] ACPI: Power Button [PWRB]
[    8.841576] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    8.849458] ACPI: Power Button [PWRF]
[    8.853568] ERST: Can not request [mem 0xbf3b303f-0xbf3b503e] for ERST.
[    8.891826] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
[    8.901198] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
[    8.909862] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
[    8.918787] ghes_edac: If you find incorrect reports, please contact your hardware vendor
[    8.927452] ghes_edac: to correct its BIOS.
[    8.931902] ghes_edac: This system has 18 DIMM sockets.
[    8.937826] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    8.947912] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    8.957881] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
[    8.967677] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    8.974238] EINJ: Error INJection is initialized.
[    8.979409] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.006331] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    9.034562] 00:05: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    9.043129] Non-volatile memory driver v1.3
[    9.050382] brd: module loaded
[    9.055021] loop: module loaded
[    9.058530] lkdtm: No crash points registered, enable through debugfs
[    9.065846] Loading iSCSI transport class v2.0-870.
[    9.071611] Adaptec aacraid driver 1.2-0[30200]-ms
[    9.076738] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    9.083982] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.06.00.12-k.
[    9.092844] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    9.100772] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    9.108111] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    9.114961] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.121426] RocketRAID 3xxx/4xxx Controller driver v1.8
[    9.127388] ahci 0000:00:1f.2: version 3.0
[    9.131892] ahci 0000:00:1f.2: irq 119 for MSI/MSI-X
[    9.137193] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    9.145860] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs 
[    9.193670] scsi0 : ahci
[    9.196659] scsi1 : ahci
[    9.199619] scsi2 : ahci
[    9.202677] scsi3 : ahci
[    9.205802] scsi4 : ahci
[    9.208956] scsi5 : ahci
[    9.211930] ata1: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21100 irq 119
[    9.219899] ata2: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21180 irq 119
[    9.227869] ata3: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21200 irq 119
[    9.235840] ata4: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21280 irq 119
[    9.243811] ata5: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21300 irq 119
[    9.251774] ata6: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21380 irq 119
[    9.260665] tun: Universal TUN/TAP device driver, 1.6
[    9.265990] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    9.272686] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    9.279913] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.280078] tsc: Refined TSC clocksource calibration: 2800.096 MHz
[    9.292026] Copyright (c) 2007 Atheros Corporation.
[    9.297656] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    9.304731] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    9.304731]   http://www.scyld.com/network/drivers.html
[    9.317745] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    9.325008] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    9.331370] e100: Copyright(c) 1999-2006 Intel Corporation
[    9.337169] e100 0000:08:01.0: PCI IRQ 48 -> rerouted to legacy IRQ 16
[    9.368249] e100 0000:08:01.0 eth0: addr 0xfb900000, irq 16, MAC addr 00:0e:0c:7f:c7:3e
[    9.376836] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    9.384160] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.390259] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    9.396365] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    9.402655] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    9.409888] igb: Copyright (c) 2007-2013 Intel Corporation.
[    9.416073] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    9.421228] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    9.426379] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    9.431531] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    9.436684] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    9.441834] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    9.446987] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    9.452140] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    9.457291] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[    9.462496] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    9.467648] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    9.472801] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    9.477952] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    9.483105] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    9.488257] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    9.493410] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    9.498561] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    9.503713] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[    9.576328] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    9.582795] ata4: SATA link down (SStatus 0 SControl 300)
[    9.588477] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    9.594937] ata3: SATA link down (SStatus 0 SControl 300)
[    9.600621] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.607097] ata5: SATA link down (SStatus 0 SControl 300)
[    9.612782] ata6.00: ATAPI: Slimtype DVD A  DS8A2S, 6P5D, max UDMA/100
[    9.619589] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
[    9.626658] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    9.636395] ata1.00: configured for UDMA/133
[    9.640953] ata6.00: configured for UDMA/100
[    9.641053] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
[    9.641781] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.642074] sd 0:0:0:0: [sda] Write Protect is off
[    9.642076] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.642196] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.642205] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.683135]  sda: sda1 sda2 sda3
[    9.684512] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.696057] ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    9.701998] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.710607] igb 0000:01:00.0: added PHC on eth1
[    9.715412] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    9.722558] igb 0000:01:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[    9.729966] igb 0000:01:00.0: eth1: PBA No: Unknown
[    9.735108] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    9.743287] IOAPIC[3]: Set routing entry (4-16 -> 0x44 -> IRQ 88 Mode:1 Active:1 Dest:32)
[    9.743960] ata2.00: configured for UDMA/133
[    9.744208] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    9.745167] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    9.745438] sd 1:0:0:0: [sdb] Write Protect is off
[    9.745440] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    9.745445] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    9.745608] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.748736] scsi 5:0:0:0: CD-ROM            Slimtype DVD A  DS8A2S    6P5D PQ: 0 ANSI: 5
[    9.749560] scsi 5:0:0:0: Attached scsi generic sg2 type 5
[    9.783650]  sdb: sdb1 sdb2
[    9.784655] sd 1:0:0:0: [sdb] Attached SCSI disk
[    9.827414] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[    9.832562] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[    9.837716] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[    9.842866] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[    9.848018] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[    9.853170] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[    9.858322] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[    9.863474] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[    9.868632] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[    9.873829] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[    9.878980] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[    9.884129] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[    9.889280] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[    9.894431] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[    9.899582] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[    9.904734] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[    9.909887] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[    9.915041] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   10.111250] igb 0000:01:00.1: added PHC on eth2
[   10.116056] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   10.123247] igb 0000:01:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[   10.130705] igb 0000:01:00.1: eth2: PBA No: Unknown
[   10.135897] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.144100] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.15.1-k
[   10.152343] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   10.158453] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   10.165905] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   10.172099] sky2: driver version 1.30
[   10.176777] usbcore: registered new interface driver catc
[   10.182494] usbcore: registered new interface driver kaweth
[   10.188338] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   10.196249] usbcore: registered new interface driver pegasus
[   10.202286] usbcore: registered new interface driver rtl8150
[   10.208334] usbcore: registered new interface driver asix
[   10.214110] usbcore: registered new interface driver ax88179_178a
[   10.220740] usbcore: registered new interface driver cdc_ether
[   10.227115] usbcore: registered new interface driver r815x
[   10.233100] usbcore: registered new interface driver cdc_eem
[   10.239132] usbcore: registered new interface driver dm9601
[   10.245145] usbcore: registered new interface driver smsc75xx
[   10.251267] usbcore: registered new interface driver smsc95xx
[   10.257420] usbcore: registered new interface driver gl620a
[   10.263359] usbcore: registered new interface driver net1080
[   10.269422] usbcore: registered new interface driver plusb
[   10.275280] usbcore: registered new interface driver rndis_host
[   10.281480] Switched to clocksource tsc
[   10.281536] usbcore: registered new interface driver cdc_subset
[   10.281767] usbcore: registered new interface driver zaurus
[   10.282031] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   10.282287] usbcore: registered new interface driver int51x1
[   10.282550] usbcore: registered new interface driver ipheth
[   10.282637] usbcore: registered new interface driver sierra_net
[   10.282686] usbcore: registered new interface driver cdc_ncm
[   10.282687] Fusion MPT base driver 3.04.20
[   10.282687] Copyright (c) 1999-2008 LSI Corporation
[   10.282696] Fusion MPT SPI Host driver 3.04.20
[   10.282825] Fusion MPT FC Host driver 3.04.20
[   10.282975] Fusion MPT SAS Host driver 3.04.20
[   10.283296] mptbase: ioc0: Initiating bringup
[   10.985456] ioc0: LSISAS1068E B2: Capabilities={Initiator}
[   30.497517] scsi6 : ioc0: LSISAS1068E B2, FwRev=01120000h, Ports=1, MaxQ=511, IRQ=16
[   30.538180] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x5000155d25e3423f)
[   30.642389] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 36, phy 0, sas_addr 0x5000155d25e34200
[   30.656922] scsi 6:0:0:0: Direct-Access     ATA      ST31000528AS     CC35 PQ: 0 ANSI: 5
[   30.667896] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   30.667928] sd 6:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   30.683049] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 1, sas_addr 0x5000c500022c41a5
[   30.695027] scsi 6:0:1:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   30.706775] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   30.728279] sd 6:0:0:0: [sdc] Write Protect is off
[   30.733355] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   30.733388] sd 6:0:1:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   30.746733] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 2, sas_addr 0x5000c50013005f59
[   30.748225] sd 6:0:1:0: [sdd] Write Protect is off
[   30.748228] sd 6:0:1:0: [sdd] Mode Sense: b3 00 10 08
[   30.749011] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.749933] sd 6:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   30.794637] scsi 6:0:2:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   30.806563] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   30.806588] sd 6:0:2:0: [sde] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   30.822072] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 3, sas_addr 0x5000c500130fe681
[   30.822117] sd 6:0:2:0: [sde] Write Protect is off
[   30.822121] sd 6:0:2:0: [sde] Mode Sense: b3 00 10 08
[   30.842690]  sdd: sdd1 sdd2
[   30.843473] sd 6:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   30.865176] scsi 6:0:3:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   30.889537] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   30.889683] sd 6:0:3:0: [sdf] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   30.891465] sd 6:0:3:0: [sdf] Write Protect is off
[   30.891468] sd 6:0:3:0: [sdf] Mode Sense: b3 00 10 08
[   30.891926] sd 6:0:1:0: [sdd] Attached SCSI disk
[   30.892947] sd 6:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   30.914598]  sde: sde1 sde2
[   30.914619] random: nonblocking pool is initialized
[   30.914643]  sdc: sdc1 sdc2 sdc3
[   30.920303] sd 6:0:2:0: [sde] Attached SCSI disk
[   30.929448]  sdf: sdf1 sdf2
[   30.935248] sd 6:0:3:0: [sdf] Attached SCSI disk
[   30.953894] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 15, phy 4, sas_addr 0x5000c500022d25dd
[   30.965876] scsi 6:0:4:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   30.976816] sd 6:0:0:0: [sdc] Attached SCSI disk
[   30.978156] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   30.999836] sd 6:0:4:0: [sdg] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.000462] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 14, phy 5, sas_addr 0x5000c500022d09b5
[   31.002289] scsi 6:0:5:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   31.005759] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   31.027663] sd 6:0:5:0: [sdh] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.028287] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 6, sas_addr 0x5000c500022c3f65
[   31.030071] scsi 6:0:6:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   31.030213] sd 6:0:5:0: [sdh] Write Protect is off
[   31.030215] sd 6:0:5:0: [sdh] Mode Sense: b3 00 10 08
[   31.033033] sd 6:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.033312] sd 6:0:6:0: Attached scsi generic sg9 type 0
[   31.076153] sd 6:0:6:0: [sdi] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.076789] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 17, phy 7, sas_addr 0x5000c500022d2a0d
[   31.098734] scsi 6:0:7:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   31.099623] sd 6:0:6:0: [sdi] Write Protect is off
[   31.099625] sd 6:0:6:0: [sdi] Mode Sense: b3 00 10 08
[   31.101762] sd 6:0:6:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.101915] sd 6:0:7:0: Attached scsi generic sg10 type 0
[   31.144371] sd 6:0:7:0: [sdj] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.145578] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 16, phy 8, sas_addr 0x5000c500022d0f35
[   31.167368] sd 6:0:4:0: [sdg] Write Protect is off
[   31.167389]  sdh: sdh1 sdh2
[   31.175545] sd 6:0:4:0: [sdg] Mode Sense: b3 00 10 08
[   31.175575] scsi 6:0:8:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   31.197105] sd 6:0:7:0: [sdj] Write Protect is off
[   31.198370] sd 6:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.199263] sd 6:0:8:0: Attached scsi generic sg11 type 0
[   31.223366] sd 6:0:7:0: [sdj] Mode Sense: b3 00 10 08
[   31.240068] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 33, phy 9, sas_addr 0x5000c500130e21cd
[   31.250726] sd 6:0:8:0: [sdk] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.258797] sd 6:0:7:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.301634] scsi 6:0:9:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   31.302040] sd 6:0:5:0: [sdh] Attached SCSI disk
[   31.302624] sd 6:0:8:0: [sdk] Write Protect is off
[   31.302627] sd 6:0:8:0: [sdk] Mode Sense: b3 00 10 08
[   31.323997]  sdi: sdi1 sdi2
[   31.324620] sd 6:0:8:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.348621] sd 6:0:9:0: Attached scsi generic sg12 type 0
[   31.369800] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 10, sas_addr 0x5000c500130f4f4d
[   31.391029] sd 6:0:9:0: [sdl] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.391035]  sdg: sdg1 sdg2
[   31.414231]  sdj: sdj1 sdj2
[   31.414738] scsi 6:0:10:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   31.415565] sd 6:0:9:0: [sdl] Write Protect is off
[   31.415567] sd 6:0:9:0: [sdl] Mode Sense: b3 00 10 08
[   31.415593] sd 6:0:6:0: [sdi] Attached SCSI disk
[   31.417698] sd 6:0:9:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.418112] sd 6:0:10:0: Attached scsi generic sg13 type 0
[   31.439399] sd 6:0:10:0: [sdm] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.439404]  sdk: sdk1 sdk2
[   31.439946] sd 6:0:4:0: [sdg] Attached SCSI disk
[   31.440582] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 35, phy 11, sas_addr 0x5000c50017cc2595
[   31.462737] sd 6:0:10:0: [sdm] Write Protect is off
[   31.462739] sd 6:0:10:0: [sdm] Mode Sense: b3 00 10 08
[   31.463027] scsi 6:0:11:0: Direct-Access     SEAGATE  ST3300657SS      0006 PQ: 0 ANSI: 5
[   31.464339] sd 6:0:10:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   31.466033] sd 6:0:11:0: Attached scsi generic sg14 type 0
[   31.487152] sd 6:0:11:0: [sdn] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   31.487782] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 34, phy 24, sas_addr 0x5000155d25e3423e
[   31.489196] sd 6:0:8:0: [sdk] Attached SCSI disk
[   31.489218] sd 6:0:11:0: [sdn] Write Protect is off
[   31.489220] sd 6:0:11:0: [sdn] Mode Sense: bb 00 10 08
[   31.490653] sd 6:0:11:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   31.491760] scsi 6:0:12:0: Enclosure         PROMISE  2U-SAS-12-S BP   0301 PQ: 0 ANSI: 5
[   31.513841]  sdl: sdl1 sdl2
[   31.515812] scsi 6:0:12:0: Attached scsi generic sg15 type 13
[   31.517203]  sdm: sdm1 sdm2
[   31.519260] Fusion MPT misc device (ioctl) driver 3.04.20
[   31.519446] mptctl: Registered with Fusion MPT base driver
[   31.519448] mptctl: /dev/mptctl @ (major,minor=10,220)
[   31.519894] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   31.519898] ehci-pci: EHCI PCI platform driver
[   31.520062] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   31.520222] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   31.520241] ehci-pci 0000:00:1a.7: debug port 1
[   31.520390] sd 6:0:9:0: [sdl] Attached SCSI disk
[   31.523258] sd 6:0:10:0: [sdm] Attached SCSI disk
[   31.523538]  sdn: sdn1 sdn2
[   31.524148] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   31.524164] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbe23000
[   31.528697] sd 6:0:11:0: [sdn] Attached SCSI disk
[   31.534246] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   31.534703] hub 1-0:1.0: USB hub found
[   31.534713] hub 1-0:1.0: 6 ports detected
[   31.535013] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   31.535144] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   31.535161] ehci-pci 0000:00:1d.7: debug port 1
[   31.539081] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   31.539095] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   31.550220] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   31.550876] hub 2-0:1.0: USB hub found
[   31.550886] hub 2-0:1.0: 6 ports detected
[   31.551270] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   31.551274] ohci-pci: OHCI PCI platform driver
[   31.551540] uhci_hcd: USB Universal Host Controller Interface driver
[   31.551682] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   31.552007] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   31.552015] uhci_hcd 0000:00:1a.0: detected 2 ports
[   31.552039] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   31.552606] hub 3-0:1.0: USB hub found
[   31.552615] hub 3-0:1.0: 2 ports detected
[   31.552838] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   31.553043] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   31.553050] uhci_hcd 0000:00:1a.2: detected 2 ports
[   31.553081] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   31.553551] hub 4-0:1.0: USB hub found
[   31.553560] hub 4-0:1.0: 2 ports detected
[   31.553778] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   31.553966] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   31.553973] uhci_hcd 0000:00:1d.0: detected 2 ports
[   31.553994] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   31.554518] hub 5-0:1.0: USB hub found
[   31.554526] hub 5-0:1.0: 2 ports detected
[   31.554745] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   31.554926] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   31.554933] uhci_hcd 0000:00:1d.1: detected 2 ports
[   31.554954] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   31.555381] hub 6-0:1.0: USB hub found
[   31.555390] hub 6-0:1.0: 2 ports detected
[   31.555613] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   31.555803] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   31.555810] uhci_hcd 0000:00:1d.2: detected 2 ports
[   31.555830] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   31.556251] hub 7-0:1.0: USB hub found
[   31.556259] hub 7-0:1.0: 2 ports detected
[   31.556684] usbcore: registered new interface driver usb-storage
[   31.556841] usbcore: registered new interface driver ums-alauda
[   31.557006] usbcore: registered new interface driver ums-datafab
[   31.557169] usbcore: registered new interface driver ums-freecom
[   31.557268] usbcore: registered new interface driver ums-isd200
[   31.557367] usbcore: registered new interface driver ums-jumpshot
[   31.557464] usbcore: registered new interface driver ums-sddr09
[   31.557563] usbcore: registered new interface driver ums-sddr55
[   31.557661] usbcore: registered new interface driver ums-usbat
[   31.557770] usbcore: registered new interface driver usbtest
[   31.557852] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   31.560128] serio: i8042 KBD port at 0x60,0x64 irq 1
[   31.560140] serio: i8042 AUX port at 0x60,0x64 irq 12
[   31.560719] mousedev: PS/2 mouse device common for all mice
[   31.561443] rtc_cmos 00:07: RTC can wake from S4
[   31.561624] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   31.561653] rtc_cmos 00:07: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   31.561796] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   31.561819] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   31.561975] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   31.562006] iTCO_vendor_support: vendor-support=0
[   31.562060] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   31.562062] md: linear personality registered for level -1
[   31.562062] md: raid0 personality registered for level 0
[   31.562063] md: raid1 personality registered for level 1
[   31.562064] md: raid10 personality registered for level 10
[   31.562263] md: raid6 personality registered for level 6
[   31.562264] md: raid5 personality registered for level 5
[   31.562264] md: raid4 personality registered for level 4
[   31.562265] md: multipath personality registered for level -4
[   31.562266] md: faulty personality registered for level -5
[   31.563453] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   31.564294] device-mapper: multipath: version 1.6.0 loaded
[   31.564295] device-mapper: multipath round-robin: version 1.0.0 loaded
[   31.564311] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   31.564312] device-mapper: cache cleaner: version 1.0.0 loaded
[   31.564530] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   31.565469] usbcore: registered new interface driver usbhid
[   31.565470] usbhid: USB HID core driver
[   31.565614] TCP: bic registered
[   31.565615] Initializing XFRM netlink socket
[   31.565861] NET: Registered protocol family 10
[   31.566140] sit: IPv6 over IPv4 tunneling driver
[   31.566366] NET: Registered protocol family 17
[   31.566383] 8021q: 802.1Q VLAN Support v1.8
[   31.566690] sctp: Hash tables configured (established 65536 bind 65536)
[   31.566865] Key type dns_resolver registered
[   31.568587] 
[   31.568587] printing PIC contents
[   31.568590] ... PIC  IMR: ffff
[   31.568593] ... PIC  IRR: 0c20
[   31.568602] ... PIC  ISR: 0000
[   31.568605] ... PIC ELCR: 0e20
[   31.568638] printing local APIC contents on CPU#0/32:
[   31.568639] ... APIC ID:      20000000 (20)
[   31.568639] ... APIC VERSION: 01060015
[   31.568640] ... APIC TASKPRI: 00000000 (00)
[   31.568640] ... APIC PROCPRI: 00000000
[   31.568641] ... APIC LDR: 01000000
[   31.568641] ... APIC DFR: ffffffff
[   31.568641] ... APIC SPIV: 000001ff
[   31.568642] ... APIC ISR field:
[   31.568644] 0000000000000000000000000000000000000000000000000000000000000000
[   31.568645] ... APIC TMR field:
[   31.568647] 0000000000000000000000020002000000000000000000000000000000000000
[   31.568647] ... APIC IRR field:
[   31.568649] 0000000000000000000000000000000000000000000000000000000000000000
[   31.568649] ... APIC ESR: 00000000
[   31.568649] ... APIC ICR: 000000fd
[   31.568650] ... APIC ICR2: 04000000
[   31.568650] ... APIC LVTT: 000000ef
[   31.568651] ... APIC LVTPC: 00000400
[   31.568651] ... APIC LVT0: 00010700
[   31.568651] ... APIC LVT1: 00000400
[   31.568652] ... APIC LVTERR: 000000fe
[   31.568652] ... APIC TMICT: 000259a7
[   31.568652] ... APIC TMCCT: 0001b9c7
[   31.568653] ... APIC TDCR: 00000003
[   31.568653] 
[   31.568654] number of MP IRQ sources: 15.
[   31.568655] number of IO-APIC #0 registers: 24.
[   31.568655] number of IO-APIC #2 registers: 24.
[   31.568656] number of IO-APIC #3 registers: 24.
[   31.568656] number of IO-APIC #4 registers: 24.
[   31.568657] testing the IO APIC.......................
[   31.568663] IO APIC #0......
[   31.568664] .... register #00: 00000000
[   31.568664] .......    : physical APIC id: 00
[   31.568664] .......    : Delivery Type: 0
[   31.568665] .......    : LTS          : 0
[   31.568665] .... register #01: 00170020
[   31.568666] .......     : max redirection entries: 17
[   31.568666] .......     : PRQ implemented: 0
[   31.568666] .......     : IO APIC version: 20
[   31.568667] .... IRQ redirection table:
[   31.568671] 1    0    0   0   0    0    0    00
[   31.568675] 0    0    0   0   0    0    0    C5
[   31.568679] 0    0    0   0   0    0    0    30
[   31.568682] 0    0    0   0   0    0    0    33
[   31.568687] 0    0    0   0   0    0    0    34
[   31.568691] 0    0    0   0   0    0    0    35
[   31.568695] 0    0    0   0   0    0    0    36
[   31.568699] 0    0    0   0   0    0    0    37
[   31.568703] 0    0    0   0   0    0    0    D5
[   31.568707] 0    1    0   0   0    0    0    31
[   31.568710] 0    0    0   0   0    0    0    3A
[   31.568715] 0    0    0   0   0    0    0    3B
[   31.568718] 0    0    0   0   0    0    0    B5
[   31.568723] 0    0    0   0   0    0    0    3D
[   31.568727] 0    0    0   0   0    0    0    3E
[   31.568731] 0    0    0   0   0    0    0    3F
[   31.568734] 0    1    0   1   0    0    0    41
[   31.568739] 1    1    0   1   0    0    0    62
[   31.568742] 0    1    0   1   0    0    0    61
[   31.568747] 0    1    0   1   0    0    0    51
[   31.568751] 1    0    0   0   0    0    0    00
[   31.568755] 1    0    0   0   0    0    2    F2
[   31.568759] 1    0    0   0   0    0    0    00
[   31.568763] 0    1    0   1   0    0    0    71
[   31.568766] IO APIC #2......
[   31.568766] .... register #00: 02000000
[   31.568766] .......    : physical APIC id: 02
[   31.568767] .......    : Delivery Type: 0
[   31.568767] .......    : LTS          : 0
[   31.568768] .... register #01: 00178020
[   31.568768] .......     : max redirection entries: 17
[   31.568768] .......     : PRQ implemented: 1
[   31.568769] .......     : IO APIC version: 20
[   31.568769] .... register #02: 02000000
[   31.568769] .......     : arbitration: 02
[   31.568770] .... register #03: 00000001
[   31.568770] .......     : Boot DT    : 1
[   31.568770] .... IRQ redirection table:
[   31.568772] 1    0    0   0   0    0    0    00
[   31.568775] 1    0    0   0   0    0    0    00
[   31.568777] 1    0    0   0   0    0    0    00
[   31.568779] 1    0    0   0   0    0    0    00
[   31.568781] 1    0    0   0   0    0    0    00
[   31.568783] 1    0    0   0   0    0    0    00
[   31.568785] 1    0    0   0   0    0    0    00
[   31.568787] 1    0    0   0   0    0    0    00
[   31.568789] 1    0    0   0   0    0    0    00
[   31.568791] 1    0    0   0   0    0    0    00
[   31.568793] 1    0    0   0   0    0    0    00
[   31.568795] 1    0    0   0   0    0    0    00
[   31.568797] 1    0    0   0   0    0    0    00
[   31.568799] 1    0    0   0   0    0    0    00
[   31.568801] 1    0    0   0   0    0    0    00
[   31.568803] 1    0    0   0   0    0    0    00
[   31.568805] 1    0    0   0   0    0    0    00
[   31.568807] 1    0    0   0   0    0    0    00
[   31.568809] 1    0    0   0   0    0    0    00
[   31.568811] 1    0    0   0   0    0    0    00
[   31.568813] 1    0    0   0   0    0    0    00
[   31.568815] 1    0    0   0   0    0    0    00
[   31.568817] 1    0    0   0   0    0    0    00
[   31.568819] 1    0    0   0   0    0    0    00
[   31.568822] IO APIC #3......
[   31.568822] .... register #00: 03000000
[   31.568822] .......    : physical APIC id: 03
[   31.568823] .......    : Delivery Type: 0
[   31.568823] .......    : LTS          : 0
[   31.568824] .... register #01: 00178020
[   31.568824] .......     : max redirection entries: 17
[   31.568824] .......     : PRQ implemented: 1
[   31.568825] .......     : IO APIC version: 20
[   31.568825] .... register #02: 03000000
[   31.568825] .......     : arbitration: 03
[   31.568826] .... register #03: 00000001
[   31.568826] .......     : Boot DT    : 1
[   31.568826] .... IRQ redirection table:
[   31.568828] 1    0    0   0   0    0    0    00
[   31.568830] 1    0    0   0   0    0    0    00
[   31.568832] 1    0    0   0   0    0    0    00
[   31.568834] 1    0    0   0   0    0    0    00
[   31.568836] 1    0    0   0   0    0    0    00
[   31.568838] 1    0    0   0   0    0    0    00
[   31.568840] 1    0    0   0   0    0    0    00
[   31.568843] 1    0    0   0   0    0    0    00
[   31.568845] 1    0    0   0   0    0    0    00
[   31.568847] 1    0    0   0   0    0    0    00
[   31.568849] 1    0    0   0   0    0    0    00
[   31.568851] 1    0    0   0   0    0    0    00
[   31.568853] 1    0    0   0   0    0    0    00
[   31.568855] 1    0    0   0   0    0    0    00
[   31.568857] 1    0    0   0   0    0    0    00
[   31.568859] 1    0    0   0   0    0    0    00
[   31.568861] 1    0    0   0   0    0    0    00
[   31.568863] 1    0    0   0   0    0    0    00
[   31.568865] 1    0    0   0   0    0    0    00
[   31.568867] 1    0    0   0   0    0    0    00
[   31.568869] 1    0    0   0   0    0    0    00
[   31.568871] 1    0    0   0   0    0    0    00
[   31.568873] 1    0    0   0   0    0    0    00
[   31.568875] 1    0    0   0   0    0    0    00
[   31.568878] IO APIC #4......
[   31.568879] .... register #00: 04000000
[   31.568879] .......    : physical APIC id: 04
[   31.568879] .......    : Delivery Type: 0
[   31.568880] .......    : LTS          : 0
[   31.568880] .... register #01: 00170020
[   31.568880] .......     : max redirection entries: 17
[   31.568881] .......     : PRQ implemented: 0
[   31.568881] .......     : IO APIC version: 20
[   31.568881] .... register #02: 00000000
[   31.568882] .......     : arbitration: 00
[   31.568882] .... register #03: 00000001
[   31.568883] .......     : Boot DT    : 1
[   31.568883] .... IRQ redirection table:
[   31.568885] 1    1    0   1   0    0    0    A1
[   31.568888] 1    0    0   0   0    0    0    00
[   31.568890] 1    1    0   1   0    0    0    C1
[   31.568892] 1    0    0   0   0    0    0    00
[   31.568895] 1    1    0   1   0    0    0    81
[   31.568897] 1    0    0   0   0    0    0    00
[   31.568900] 1    1    0   1   0    0    0    E1
[   31.568902] 1    0    0   0   0    0    0    00
[   31.568904] 1    1    0   1   0    0    0    42
[   31.568907] 1    0    0   0   0    0    0    00
[   31.568909] 1    0    0   0   0    0    0    00
[   31.568912] 1    0    0   0   0    0    0    00
[   31.568914] 1    0    0   0   0    0    0    00
[   31.568917] 1    0    0   0   0    0    0    00
[   31.568919] 1    0    0   0   0    0    0    00
[   31.568921] 1    0    0   0   0    0    0    00
[   31.568924] 1    1    0   1   0    0    0    44
[   31.568926] 1    0    0   0   0    0    0    00
[   31.568929] 1    0    0   0   0    0    0    00
[   31.568931] 1    0    0   0   0    0    0    00
[   31.568933] 1    0    0   0   0    0    0    00
[   31.568936] 1    0    0   0   0    0    0    00
[   31.568938] 1    0    0   0   0    0    0    00
[   31.568941] 1    0    0   0   0    0    0    00
[   31.568941] IRQ to pin mappings:
[   31.568942] IRQ0 -> 0:2
[   31.568943] IRQ1 -> 0:1
[   31.568944] IRQ3 -> 0:3
[   31.568945] IRQ4 -> 0:4
[   31.568946] IRQ5 -> 0:5
[   31.568947] IRQ6 -> 0:6
[   31.568948] IRQ7 -> 0:7
[   31.568948] IRQ8 -> 0:8
[   31.568949] IRQ9 -> 0:9
[   31.568950] IRQ10 -> 0:10
[   31.568951] IRQ11 -> 0:11
[   31.568952] IRQ12 -> 0:12
[   31.568953] IRQ13 -> 0:13
[   31.568953] IRQ14 -> 0:14
[   31.568954] IRQ15 -> 0:15
[   31.568955] IRQ16 -> 0:16
[   31.568956] IRQ17 -> 0:17
[   31.568957] IRQ18 -> 0:18
[   31.568958] IRQ19 -> 0:19
[   31.568958] IRQ23 -> 0:23
[   31.568960] IRQ72 -> 3:0
[   31.568961] IRQ74 -> 3:2
[   31.568961] IRQ76 -> 3:4
[   31.568963] IRQ78 -> 3:6
[   31.568963] IRQ80 -> 3:8
[   31.568965] IRQ88 -> 3:16
[   31.568967] .................................... done.
[   31.569131] registered taskstats version 1
[   32.250895] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[   32.403033] hub 5-2:1.0: USB hub found
[   32.404774] hub 5-2:1.0: 4 ports detected
[   32.685005] usb 5-2.1: new low-speed USB device number 3 using uhci_hcd
[   32.908828] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.0/0003:0557:2261.0001/input/input4
[   32.910862] hid-generic 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input0
[   32.947464] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.1/0003:0557:2261.0002/input/input5
[   32.947783] hid-generic 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input1
[   32.969745] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.2/0003:0557:2261.0003/input/input6
[   32.970309] hid-generic 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input2
[   33.227324] rtc_cmos 00:07: setting system clock to 2013-12-28 14:13:34 UTC (1388240014)
[   33.235916] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   33.242200] EDD information not available.
[   33.255037] sd 6:0:7:0: [sdj] Attached SCSI disk
[   33.275740] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   33.392119] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   33.398219] 8021q: adding VLAN 0 to HW filter on device eth1
[   33.516236] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   33.522341] 8021q: adding VLAN 0 to HW filter on device eth2
[   41.695010] igb: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   41.702827] igb 0000:01:00.0 eth1: Link Speed was downgraded by SmartSpeed
[   41.711246] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   41.726578] Sending DHCP requests ., OK
[   42.359096] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.67
[   42.551778] IP-Config: Complete:
[   42.555359]      device=eth1, hwaddr=00:30:48:cf:17:26, ipaddr=192.168.1.67, mask=255.255.255.0, gw=192.168.1.1
[   42.565974]      host=lkp-ws02, domain=lkp.intel.com, nis-domain=(none)
[   42.572891]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   42.579689]      nameserver0=192.168.1.1
[   42.584435] PM: Hibernation image not present or could not be loaded.
[   42.595200] Freeing unused kernel memory: 1436K (ffffffff82338000 - ffffffff8249f000)
[   42.603521] Write protecting the kernel read-only data: 18432k
[   42.618196] Freeing unused kernel memory: 1848K (ffff880001a32000 - ffff880001c00000)
[   42.632331] Freeing unused kernel memory: 1996K (ffff88000200d000 - ffff880002200000)
[   42.858788] ipmi message handler version 39.2
[   42.864819] IPMI System Interface driver.
[   42.869195] ipmi_si: probing via SMBIOS
[   42.873269] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   42.873273] ipmi_si: Adding SMBIOS-specified kcs state machine
[   42.873275] ipmi_si: probing via SPMI
[   42.873276] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   42.873278] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[   42.873279] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   42.873286] ipmi_si: Interface detection failed
[   42.920414] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[   42.926481] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[   42.926563] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[   42.926653] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[   42.926668] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[   42.926713] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[   42.926786] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[   42.926829] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[   42.926845] microcode: CPU8 sig=0x206c1, pf=0x1, revision=0x3
[   42.926864] microcode: CPU9 sig=0x206c1, pf=0x1, revision=0x3
[   42.926903] microcode: CPU10 sig=0x206c1, pf=0x1, revision=0x3
[   42.926931] microcode: CPU11 sig=0x206c1, pf=0x1, revision=0x3
[   42.926945] microcode: CPU12 sig=0x206c1, pf=0x1, revision=0x3
[   42.926979] microcode: CPU13 sig=0x206c1, pf=0x1, revision=0x3
[   42.927032] microcode: CPU14 sig=0x206c1, pf=0x1, revision=0x3
[   42.927084] microcode: CPU15 sig=0x206c1, pf=0x1, revision=0x3
[   42.927124] microcode: CPU16 sig=0x206c1, pf=0x1, revision=0x3
[   42.927197] microcode: CPU17 sig=0x206c1, pf=0x1, revision=0x3
[   42.927212] microcode: CPU18 sig=0x206c1, pf=0x1, revision=0x3
[   42.927227] microcode: CPU19 sig=0x206c1, pf=0x1, revision=0x3
[   42.927238] microcode: CPU20 sig=0x206c1, pf=0x1, revision=0x3
[   42.932494] microcode: CPU21 sig=0x206c1, pf=0x1, revision=0x3
[   42.932540] microcode: CPU22 sig=0x206c1, pf=0x1, revision=0x3
[   42.932582] microcode: CPU23 sig=0x206c1, pf=0x1, revision=0x3
[   42.932682] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   43.083565] btrfs: device fsid f3082e2d-7b16-4b16-8027-d9ef0ff805ff devid 1 transid 44 /dev/sdc1

==> /tmp/run_log <==
Kernel tests: Boot OK!
PATH=/sbin:/usr/sbin:/bin:/usr/bin

==> /tmp/err_log <==

==> /tmp/run_log <==
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=/lkp/lkp/src
RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/1ba337ca6cd05ea33029692dc837a43c05108cb7/1
job=/lkp/scheduled/lkp-ws02/reconfirm_dd-write-11HDD-RAID5-cfq-btrfs-1dd-x86_64-lkp-1ba337ca6cd05ea33029692dc837a43c05108cb7-0.yaml
Stopping watchdog daemon...2013-12-28 14:13:55 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/lkp-ws02/reconfirm_dd-write-11HDD-RAID5-cfq-btrfs-1dd-x86_64-lkp-1ba337ca6cd05ea33029692dc837a43c05108cb7-0.yaml
run: /lkp/lkp/src/setup/disk{"nr_hdd"=>"11"}
run: /lkp/lkp/src/setup/md{"raid_level"=>"raid5"}
run: /lkp/lkp/src/monitors/event/wait pre-test{}
run: /lkp/lkp/src/monitors/wrapper perf-stat{}
run: /lkp/lkp/src/monitors/wrapper ftrace{"events"=>"balance_dirty_pages bdi_dirty_ratelimit global_dirty_state writeback_single_inode"}
2013-12-28 14:13:55 mdadm -q --create /dev/md0 --chunk=256 --level=raid5 --raid-devices=11 --force --assume-clean /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1
[   53.172496] md: bind<sdd1>
[   53.175767] md: bind<sde1>
[   53.179044] md: bind<sdf1>
[   53.182331] md: bind<sdg1>
[   53.185584] md: bind<sdh1>
[   53.188815] md: bind<sdi1>
[   53.192058] md: bind<sdj1>
[   53.195299] md: bind<sdk1>
[   53.198558] md: bind<sdl1>
[   53.201810] md: bind<sdm1>
[   53.205032] md: bind<sdn1>
[   53.209619] md/raid:md0: device sdn1 operational as raid disk 10
[   53.215910] md/raid:md0: device sdm1 operational as raid disk 9
[   53.222108] md/raid:md0: device sdl1 operational as raid disk 8
[   53.228301] md/raid:md0: device sdk1 operational as raid disk 7
[   53.234502] md/raid:md0: device sdj1 operational as raid disk 6
[   53.240703] md/raid:md0: device sdi1 operational as raid disk 5
[   53.246896] md/raid:md0: device sdh1 operational as raid disk 4
[   53.253090] md/raid:md0: device sdg1 operational as raid disk 3
[   53.259289] md/raid:md0: device sdf1 operational as raid disk 2
[   53.265483] md/raid:md0: device sde1 operational as raid disk 1
[   53.271676] md/raid:md0: device sdd1 operational as raid disk 0
[   53.278512] md/raid:md0: allocated 0kB
[   53.282669] md/raid:md0: raid level 5 active with 11 out of 11 devices, algorithm 2
[   53.297275] RAID conf printout:
[   53.300691]  --- level:5 rd:11 wd:11
[   53.304542]  disk 0, o:1, dev:sdd1
[   53.308218]  disk 1, o:1, dev:sde1
[   53.311894]  disk 2, o:1, dev:sdf1
[   53.315575]  disk 3, o:1, dev:sdg1
[   53.319252]  disk 4, o:1, dev:sdh1
[   53.322931]  disk 5, o:1, dev:sdi1
[   53.326606]  disk 6, o:1, dev:sdj1
[   53.330285]  disk 7, o:1, dev:sdk1
[   53.333962]  disk 8, o:1, dev:sdl1
[   53.337633]  disk 9, o:1, dev:sdm1
[   53.341311]  disk 10, o:1, dev:sdn1
[   53.345108] md0: detected capacity change from 0 to 1998633041920
run: /lkp/lkp/src/setup/iosched{"scheduler"=>"cfq"}
run: /lkp/lkp/src/setup/fs{"fs"
[   53.362164]  md0: unknown partition table
=>"btrfs"}
2013-12-28 14:13:55 mkfs -t btrfs /dev/md0
[   53.509189] btrfs: device fsid 86e02182-98a1-4732-9bef-d2e4e513b1a2 devid 1 transid 4 /dev/md0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kern
[   53.545889] btrfs: device fsid 86e02182-98a1-4732-9bef-d2e4e513b1a2 el.org before usdevid 1 transid 4 /dev/md0
ing

fs create
[   53.558326] btrfs: disk space caching is enabled
d label (null) on /dev/md0
nodesize 4096 leafs
[   53.566685] btrfs: creating UUID tree
ize 4096 sectorsize 4096 size 1.82TiB
Btrfs v0.20-rc1-566-gd1570a0
2013-12-28 14:13:56 mount -t btrfs /dev/md0 /fs/md0
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime{}
run: /lkp/lkp/src/monitors/wrapper iostat{}
run: /lkp/lkp/src/monitors/wrapper vmstat{}
[   53.648946] btrfs: device fsid 86e02182-98a1-4732-9bef-d2e4e513b1a2 run: /lkp/lkp/src/monitors/wrappdevid 1 transid 5 /dev/md0
er numa-numastat{}
run: /lkp/lkp/src/monitors/wrapper numa-vmstat{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo{}
run: /lkp/lkp/src/monitors/wrapper proc-vmstat{}
run: /lkp/lkp/src/monitors/wrapper meminfo{}
run: /lkp/lkp/src/monitors/wrapper slabinfo{}
run: /lkp/lkp/src/monitors/wrapper buddyinfo{}
run: /lkp/lkp/src/monitors/wrapper pagetypeinfo{}
run: /lkp/lkp/src/monitors/wrapper interrupts{}
run: /lkp/lkp/src/monitors/wrapper lock_stat{}
run: /lkp/lkp/src/monitors/wrapper softirqs{}
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping{}
run: /lkp/lkp/src/monitors/wrapper pmeter{}
run: /lkp/lkp/src/monitors/wrapper diskstats{}
run: /lkp/lkp/src/monitors/wrapper zoneinfo{}
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/micro/wrapper dd{"nr_dd"=>"1"}
.
Starting watchdog keepalive daemon....
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
[   88.690467] ------------[ cut here ]------------
[   88.695353] kernel BUG at fs/bio.c:1748!
[   88.701623] invalid opcode: 0000 [#1] SMP 
[   88.706107] Modules linked in: microcode ipmi_si ipmi_msghandler acpi_cpufreq processor
[   88.714966] CPU: 0 PID: 3956 Comm: md0_raid5 Not tainted 3.13.0-rc5-next-20131224-06549-g1ba337c #2
[   88.724496] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[   88.731463] task: ffff880217772180 ti: ffff880217cfa000 task.ti: ffff880217cfa000
[   88.739423] RIP: 0010:[<ffffffff8120c246>]  [<ffffffff8120c246>] bio_endio+0x1e/0x6a
[   88.747716] RSP: 0018:ffff880217cfbb68  EFLAGS: 00010246
[   88.753293] RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 0000000000015d00
[   88.760692] RDX: ffffea000e75f600 RSI: 0000000000000000 RDI: ffff88039ebebbe8
[   88.768090] RBP: ffff880217cfbb80 R08: ffffea0008662ac0 R09: ffff880237824a00
[   88.775490] R10: ffffea000e7afa80 R11: ffffffff8145b12d R12: ffff8802198ab780
[   88.782897] R13: 0000000000000000 R14: ffff8804169f8000 R15: 0000000000000000
[   88.790297] FS:  0000000000000000(0000) GS:ffff88043fc00000(0000) knlGS:0000000000000000
[   88.798866] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   88.804875] CR2: 0000000000ba3d64 CR3: 000000000220c000 CR4: 00000000000007f0
[   88.812275] Stack:
[   88.814548]  ffff88039ebebbe8 ffff88039ebebbe8 ffff8802198ab780 ffff880217cfbba8
[   88.822673]  ffffffff8145b138 00000000fffffffb ffff8804163f6000 ffff88039ebeb0a8
[   88.830801]  ffff880217cfbbd0 ffffffff8120c28b ffff88039ebeb0a8 ffff88039ebeb0a8
[   88.838928] Call Trace:
[   88.841640]  [<ffffffff8145b138>] btrfs_end_bio+0x116/0x11d
[   88.847474]  [<ffffffff8120c28b>] bio_endio+0x63/0x6a
[   88.852793]  [<ffffffff8187bd80>] return_io+0x5c/0x97
[   88.858110]  [<ffffffff81883ffc>] handle_stripe+0x1dc6/0x1f49
[   88.864130]  [<ffffffff8117aeb3>] ? __perf_sw_event+0x146/0x15a
[   88.870314]  [<ffffffff8110ab79>] ? update_curr+0x77/0x116
[   88.876072]  [<ffffffff8188445f>] handle_active_stripes.isra.24+0x2e0/0x360
[   88.883304]  [<ffffffff818849d4>] raid5d+0x3e2/0x4f2
[   88.888538]  [<ffffffff81a1edcf>] ? schedule_timeout+0x2f/0x1bf
[   88.894729]  [<ffffffff81a2266f>] ? _raw_spin_lock_irqsave+0x19/0x56
[   88.901348]  [<ffffffff818a4eac>] md_thread+0x10f/0x125
[   88.906839]  [<ffffffff8111309c>] ? __wake_up_sync+0x12/0x12
[   88.912761]  [<ffffffff818a4d9d>] ? md_register_thread+0xd5/0xd5
[   88.919035]  [<ffffffff810fab08>] kthread+0xdb/0xe3
[   88.924176]  [<ffffffff810faa2d>] ? kthread_create_on_node+0x16f/0x16f
[   88.930969]  [<ffffffff81a29cbc>] ret_from_fork+0x7c/0xb0
[   88.936633]  [<ffffffff810faa2d>] ? kthread_create_on_node+0x16f/0x16f
[   88.943430] Code: ff ff eb bb 5b 41 5c 41 5d 41 5e 5d c3 66 66 66 66 90 55 48 89 e5 41 54 53 53 bb fb ff ff ff 48 85 ff 74 4c 8b 47 44 85 c0 7f 02 <0f> 0b 85 f6 74 07 f0 80 67 10 fe eb 09 48 8b 47 10 a8 01 0f 44 
[   88.966917] RIP  [<ffffffff8120c246>] bio_endio+0x1e/0x6a
[   88.972643]  RSP <ffff880217cfbb68>
[   88.976579] ---[ end trace c016a3f58dc3f7a0 ]---
[   88.981555] Kernel panic - not syncing: Fatal exception
[   88.987494] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   88.998144] Rebooting in 10 seconds..
[   98.980144] ACPI MEMORY or I/O RESET_REG.

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-fileio
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-01897-g2b48961 (kbuild@ant) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Wed Jan 1 01:27:51 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-1/cycl=
ic_fileio-600s-100%-1HDD-btrfs-64G-1024-rndrw-sync-HEAD.yaml ARCH=3Dx86_64 =
BOOT_IMAGE=3D/kernel/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/vm=
linuz-3.13.0-rc6-01897-g2b48961 kconfig=3Dx86_64-lkp commit=3D2b48961067b05=
9a9260e0378cd4d83a0c959f6ec modules_initrd=3D/kernel/x86_64-lkp/2b48961067b=
059a9260e0378cd4d83a0c959f6ec/modules.cgz max_uptime=3D3803 RESULT_ROOT=3D/=
lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-rndrw-sync=
/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0 initrd=3D/kernel-tes=
ts/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-1::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02659000, 0x02659fff] PGTABLE
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x743aa000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41ffed000-0x41fff1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040f60000=
0-ffff88041f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 41fc0d040
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-1/cyclic_fileio-600s-100%-1HDD-btrfs-64G-1024-rndrw-sync-HEAD.yaml ARCH=3D=
x86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959=
f6ec/vmlinuz-3.13.0-rc6-01897-g2b48961 kconfig=3Dx86_64-lkp commit=3D2b4896=
1067b059a9260e0378cd4d83a0c959f6ec modules_initrd=3D/kernel/x86_64-lkp/2b48=
961067b059a9260e0378cd4d83a0c959f6ec/modules.cgz max_uptime=3D3803 RESULT_R=
OOT=3D/lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-rnd=
rw-sync/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0 initrd=3D/ker=
nel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16231976K/16776816K available (10302K kernel code, 1=
232K rwdata, 4144K rodata, 1428K init, 1732K bss, 544840K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-01897-g2b48961 (kbuild@ant) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Wed Jan 1 01:27:51 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-1/cycl=
ic_fileio-600s-100%-1HDD-btrfs-64G-1024-rndrw-sync-HEAD.yaml ARCH=3Dx86_64 =
BOOT_IMAGE=3D/kernel/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/vm=
linuz-3.13.0-rc6-01897-g2b48961 kconfig=3Dx86_64-lkp commit=3D2b48961067b05=
9a9260e0378cd4d83a0c959f6ec modules_initrd=3D/kernel/x86_64-lkp/2b48961067b=
059a9260e0378cd4d83a0c959f6ec/modules.cgz max_uptime=3D3803 RESULT_ROOT=3D/=
lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-rndrw-sync=
/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0 initrd=3D/kernel-tes=
ts/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-1::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02659000, 0x02659fff] PGTABLE
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x743aa000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41ffed000-0x41fff1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040f60000=
0-ffff88041f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 41fc0d040
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-1/cyclic_fileio-600s-100%-1HDD-btrfs-64G-1024-rndrw-sync-HEAD.yaml ARCH=3D=
x86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959=
f6ec/vmlinuz-3.13.0-rc6-01897-g2b48961 kconfig=3Dx86_64-lkp commit=3D2b4896=
1067b059a9260e0378cd4d83a0c959f6ec modules_initrd=3D/kernel/x86_64-lkp/2b48=
961067b059a9260e0378cd4d83a0c959f6ec/modules.cgz max_uptime=3D3803 RESULT_R=
OOT=3D/lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-rnd=
rw-sync/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0 initrd=3D/ker=
nel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16231976K/16776816K available (10302K kernel code, 1=
232K rwdata, 4144K rodata, 1428K init, 1732K bss, 544840K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.544 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.08 Bogo=
MIPS (lpj=3D10774176)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.009006] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.023733] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.031251] Mount-cache hash table entries: 256
[    0.032304] Initializing cgroup subsys memory
[    0.033218] Initializing cgroup subsys devices
[    0.034119] Initializing cgroup subsys freezer
[    0.035012] Initializing cgroup subsys blkio
[    0.036005] Initializing cgroup subsys perf_event
[    0.036937] Initializing cgroup subsys hugetlb
[    0.037901] mce: CPU supports 10 MCE banks
[    0.038802] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038802] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038802] tlb_flushall_shift: 6
[    0.040082] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - fff=
fffff824a6000)
[    0.047632] ACPI: Core revision 20131115
[    0.048701] ACPI: All ACPI Tables successfully acquired
[    0.049803] ftrace: allocating 39670 entries in 155 pages
[    0.060170] Getting VERSION: 50014
[    0.061018] Getting VERSION: 50014
[    0.061834] Getting ID: 0
[    0.062560] Getting ID: ff000000
[    0.064012] Getting LVT0: 8700
[    0.064774] Getting LVT1: 8400
[    0.065601] enabled ExtINT on CPU#0
[    0.067154] ENABLING IO-APIC IRQs
[    0.068007] init IO_APIC IRQs
[    0.068762]  apic 0 pin 0 not connected
[    0.069623] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.071397] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.072018] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.073697] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.076017] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.077692] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.080016] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.081619] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.083241] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.084016] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.085653] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.088016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.089647] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.091276] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.092016] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.093675]  apic 0 pin 16 not connected
[    0.094478]  apic 0 pin 17 not connected
[    0.096003]  apic 0 pin 18 not connected
[    0.096827]  apic 0 pin 19 not connected
[    0.097629]  apic 0 pin 20 not connected
[    0.098439]  apic 0 pin 21 not connected
[    0.100003]  apic 0 pin 22 not connected
[    0.100794]  apic 0 pin 23 not connected
[    0.101788] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.102955] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.104935] Using local APIC timer interrupts.
[    0.104935] calibrating APIC timer ...
[    0.108000] ... lapic delta =3D 6250191
[    0.108000] ... PM-Timer delta =3D 358009
[    0.108000] ... PM-Timer result ok
[    0.108000] ..... delta 6250191
[    0.108000] ..... mult: 268443659
[    0.108000] ..... calibration result: 4000122
[    0.108000] ..... CPU clock speed is 2693.3693 MHz.
[    0.108000] ..... host bus clock speed is 1000.0122 MHz.
[    0.108056] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.111842] x86: Booting SMP configuration:
[    0.112003] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 4:1ffe5041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.128033] KVM setup async PF for cpu 1
 #2
[    0.129465] kvm-stealtime: cpu 1, msr 41fc8d040
[    0.008000] kvm-clock: cpu 2, msr 4:1ffe5081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.144036] KVM setup async PF for cpu 2
 #3
[    0.145360] kvm-stealtime: cpu 2, msr 41fd0d040
[    0.008000] kvm-clock: cpu 3, msr 4:1ffe50c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.160068] x86: Booted up 1 node, 4 CPUs
[    0.160046] KVM setup async PF for cpu 3
[    0.160046] kvm-stealtime: cpu 3, msr 41fd8d040
[    0.164005] smpboot: Total of 4 processors activated (21548.35 BogoMIPS)
[    0.165781] devtmpfs: initialized
[    0.172982] xor: measuring software checksum speed
[    0.212035]    prefetch64-sse:   181.000 MB/sec
[    0.252013]    generic_sse:   159.000 MB/sec
[    0.252920] xor: using function: prefetch64-sse (181.000 MB/sec)
[    0.254040] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.255264] NET: Registered protocol family 16
[    0.256571] cpuidle: using governor ladder
[    0.256993] cpuidle: using governor menu
[    0.260221] ACPI: bus type PCI registered
[    0.261208] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.263114] PCI: Using configuration type 1 for base access
[    0.312097] bio: create slab <bio-0> at 0
[    0.378885] raid6: sse2x1    7594 MB/s
[    0.446887] raid6: sse2x2    9857 MB/s
[    0.514884] raid6: sse2x4   12038 MB/s
[    0.515952] raid6: using algorithm sse2x4 (12038 MB/s)
[    0.516015] raid6: using intx1 recovery algorithm
[    0.517521] ACPI: Added _OSI(Module Device)
[    0.520005] ACPI: Added _OSI(Processor Device)
[    0.520907] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.521823] ACPI: Added _OSI(Processor Aggregator Device)
[    0.526631] ACPI: Interpreter enabled
[    0.527377] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[    0.528602] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[    0.530365] ACPI: (supports S0 S3 S4 S5)
[    0.531122] ACPI: Using IOAPIC for interrupt routing
[    0.532048] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.533906] ACPI: No dock devices found.
[    0.540176] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.541164] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.544023] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.545243] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.548364] acpiphp: Slot [3] registered
[    0.549007] acpiphp: Slot [4] registered
[    0.549007] acpiphp: Slot [5] registered
[    0.549007] acpiphp: Slot [6] registered
[    0.552093] acpiphp: Slot [7] registered
[    0.553195] acpiphp: Slot [8] registered
[    0.553203] acpiphp: Slot [9] registered
[    0.556044] acpiphp: Slot [10] registered
[    0.556897] acpiphp: Slot [11] registered
[    0.556897] acpiphp: Slot [12] registered
[    0.556897] acpiphp: Slot [13] registered
[    0.560055] acpiphp: Slot [14] registered
[    0.560901] acpiphp: Slot [15] registered
[    0.560901] acpiphp: Slot [16] registered
[    0.560901] acpiphp: Slot [17] registered
[    0.560901] acpiphp: Slot [18] registered
[    0.564046] acpiphp: Slot [19] registered
[    0.564905] acpiphp: Slot [20] registered
[    0.564905] acpiphp: Slot [21] registered
[    0.564905] acpiphp: Slot [22] registered
[    0.568067] acpiphp: Slot [23] registered
[    0.568881] acpiphp: Slot [24] registered
[    0.568881] acpiphp: Slot [25] registered
[    0.568881] acpiphp: Slot [26] registered
[    0.568881] acpiphp: Slot [27] registered
[    0.572051] acpiphp: Slot [28] registered
[    0.572867] acpiphp: Slot [29] registered
[    0.572867] acpiphp: Slot [30] registered
[    0.572867] acpiphp: Slot [31] registered
[    0.576028] PCI host bridge to bus 0000:00
[    0.577586] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.579220] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.580007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.581568] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.584005] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.585932] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.588087] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.590209] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.594746] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.597199] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.597417] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.600022] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.601344] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.608042] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.610507] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.618094] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.620531] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.622185] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.624997] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.632503] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.633818] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.636016] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.638091] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.644857] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.646210] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.649004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.656279] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.658168] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.660505] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.666813] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.669068] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.671106] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.677348] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.678078] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.681031] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.688075] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.690184] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.692004] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.698228] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.700279] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.704453] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.705871] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.707258] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.708964] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.710379] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.712200] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.713350] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.713679] vgaarb: loaded
[    0.714434] vgaarb: bridge control possible 0000:00:02.0
[    0.716202] SCSI subsystem initialized
[    0.716917] libata version 3.00 loaded.
[    0.720034] ACPI: bus type USB registered
[    0.720905] usbcore: registered new interface driver usbfs
[    0.721059] usbcore: registered new interface driver hub
[    0.724078] usbcore: registered new device driver usb
[    0.724078] pps_core: LinuxPPS API ver. 1 registered
[    0.725797] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.728097] PTP clock support registered
[    0.732106] EDAC MC: Ver: 3.0.0
[    0.733061] PCI: Using ACPI for IRQ routing
[    0.733061] PCI: pci_cache_line_size set to 64 bytes
[    0.734072] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.735167] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.736612] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.737838] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.739080] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.744096] Switched to clocksource kvm-clock
[    0.758657] pnp: PnP ACPI init
[    0.759447] ACPI: bus type PNP registered
[    0.760409] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.762193] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.763373] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.765190] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.766354] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.768103] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.769263] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.770916] pnp 00:03: [dma 2]
[    0.771809] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.773047] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.774831] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.775994] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.777982] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.779747] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.781341] pnp: PnP ACPI: found 7 devices
[    0.782259] ACPI: bus type PNP unregistered
[    0.801131] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.802446] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.803507] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.804893] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.806278] NET: Registered protocol family 2
[    0.807540] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.809831] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.811684] TCP: Hash tables configured (established 131072 bind 65536)
[    0.813155] TCP: reno registered
[    0.813939] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.815209] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.816683] NET: Registered protocol family 1
[    0.817939] RPC: Registered named UNIX socket transport module.
[    0.818996] RPC: Registered udp transport module.
[    0.819911] RPC: Registered tcp transport module.
[    0.820852] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.821969] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.823043] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.824141] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.825249] pci 0000:00:02.0: Boot video device
[    0.826217] PCI: CLS 0 bytes, default 64
[    0.827144] Trying to unpack rootfs image as initramfs...
[    4.698459] Freeing initrd memory: 192856K (ffff8800743aa000 - ffff88008=
0000000)
[    4.699977] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.701070] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    4.703225] kvm: no hardware support
[    4.706041] Scanning for low memory corruption every 60 seconds
[    4.707482] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.709717] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    4.711626] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.715238] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.716801] PCLMULQDQ-NI instructions are not detected.
[    4.718642] AVX or AES-NI instructions are not detected.
[    4.720228] AVX instructions are not detected.
[    4.721655] AVX instructions are not detected.
[    4.722924] AVX instructions are not detected.
[    4.723805] AVX instructions are not detected.
[    4.756490] bounce pool size: 64 pages
[    4.757346] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.766836] VFS: Disk quotas dquot_6.5.2
[    4.767766] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.771543] NFS: Registering the id_resolver key type
[    4.772502] Key type id_resolver registered
[    4.773319] Key type id_legacy registered
[    4.774185] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.775270] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.777282] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.778579] fuse init (API version 7.22)
[    4.779972] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    4.783212] bio: create slab <bio-1> at 1
[    4.784703] Btrfs loaded
[    4.785407] msgmni has been set to 32079
[    4.789658] NET: Registered protocol family 38
[    4.790554] Key type asymmetric registered
[    4.791689] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.793472] io scheduler noop registered
[    4.794330] io scheduler deadline registered
[    4.795207] io scheduler cfq registered (default)
[    4.797203] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.799361] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.800955] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.803020] ACPI: Power Button [PWRF]
[    4.804430] GHES: HEST is not enabled!
[    4.806611] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.807669] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    4.810981] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.812086] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    4.815592] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.818516] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.826862] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.849431] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.853644] Non-volatile memory driver v1.3
[    4.858593] brd: module loaded
[    4.861551] loop: module loaded
[    4.862466] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.863820] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.865414] blk-mq: CPU -> queue map
[    4.866443]   CPU 0 -> Queue 0
[    4.867171]   CPU 1 -> Queue 0
[    4.867892]   CPU 2 -> Queue 0
[    4.868611]   CPU 3 -> Queue 0
[    4.870640]  vda: unknown partition table
[    4.874591] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.875613] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.876830] blk-mq: CPU -> queue map
[    4.877631]   CPU 0 -> Queue 0
[    4.878361]   CPU 1 -> Queue 0
[    4.879100]   CPU 2 -> Queue 0
[    4.879834]   CPU 3 -> Queue 0
[    4.881512]  vdb: unknown partition table
[    4.884855] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.885840] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.886992] blk-mq: CPU -> queue map
[    4.893035]   CPU 0 -> Queue 0
[    4.893786]   CPU 1 -> Queue 0
[    4.894474]   CPU 2 -> Queue 0
[    4.895165]   CPU 3 -> Queue 0
[    4.896887]  vdc: unknown partition table
[    4.899406] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.901737] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.903440] blk-mq: CPU -> queue map
[    4.904223]   CPU 0 -> Queue 0
[    4.904954]   CPU 1 -> Queue 0
[    4.905672]   CPU 2 -> Queue 0
[    4.906389]   CPU 3 -> Queue 0
[    4.908120]  vdd: unknown partition table
[    4.912956] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.914270] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    4.915722] blk-mq: CPU -> queue map
[    4.916765]   CPU 0 -> Queue 0
[    4.917577]   CPU 1 -> Queue 0
[    4.918438]   CPU 2 -> Queue 0
[    4.919382]   CPU 3 -> Queue 0
[    4.921412]  vde: unknown partition table
[    4.924704] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    4.925663] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    4.926778] blk-mq: CPU -> queue map
[    4.927559]   CPU 0 -> Queue 0
[    4.928274]   CPU 1 -> Queue 0
[    4.929011]   CPU 2 -> Queue 0
[    4.929709]   CPU 3 -> Queue 0
[    4.931400]  vdf: unknown partition table
[    4.934199] lkdtm: No crash points registered, enable through debugfs
[    4.936564] Loading iSCSI transport class v2.0-870.
[    4.938839] Adaptec aacraid driver 1.2-0[30200]-ms
[    4.939927] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.941289] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    4.943239] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.945189] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.946717] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    4.947972] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.949145] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.950689] ata_piix 0000:00:01.1: version 2.13
[    4.954086] scsi0 : ata_piix
[    4.955086] scsi1 : ata_piix
[    4.955961] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    4.957140] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    4.959389] tun: Universal TUN/TAP device driver, 1.6
[    4.960399] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.961865] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    4.963346] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.964597] Copyright (c) 2007 Atheros Corporation.
[    4.965919] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    4.967387] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    4.967387]   http://www.scyld.com/network/drivers.html
[    4.970083] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    4.971681] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.972951] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.974064] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    4.975266] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.112677] ata2.01: NODEV after polling detection
[    5.114826] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    5.116377] ata2.00: configured for MWDMA2
[    5.118241] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    5.121213] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[    5.313493] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    5.314954] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.316595] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.318335] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    5.319729] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    5.321197] igb: Copyright (c) 2007-2013 Intel Corporation.
[    5.322683] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    5.326153] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    5.328828] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    5.331631] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.333514] sky2: driver version 1.30
[    5.337267] usbcore: registered new interface driver catc
[    5.338500] usbcore: registered new interface driver kaweth
[    5.339552] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    5.341356] usbcore: registered new interface driver pegasus
[    5.342689] usbcore: registered new interface driver rtl8150
[    5.343946] usbcore: registered new interface driver asix
[    5.345242] usbcore: registered new interface driver ax88179_178a
[    5.346466] usbcore: registered new interface driver cdc_ether
[    5.347660] usbcore: registered new interface driver r815x
[    5.348811] usbcore: registered new interface driver cdc_eem
[    5.349982] usbcore: registered new interface driver dm9601
[    5.351127] usbcore: registered new interface driver smsc75xx
[    5.352337] usbcore: registered new interface driver smsc95xx
[    5.353474] usbcore: registered new interface driver gl620a
[    5.354586] usbcore: registered new interface driver net1080
[    5.355737] usbcore: registered new interface driver plusb
[    5.356889] usbcore: registered new interface driver rndis_host
[    5.358057] usbcore: registered new interface driver cdc_subset
[    5.359245] usbcore: registered new interface driver zaurus
[    5.360424] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    5.362140] usbcore: registered new interface driver int51x1
[    5.363282] usbcore: registered new interface driver ipheth
[    5.364413] usbcore: registered new interface driver sierra_net
[    5.365569] usbcore: registered new interface driver cdc_ncm
[    5.366615] Fusion MPT base driver 3.04.20
[    5.367467] Copyright (c) 1999-2008 LSI Corporation
[    5.368440] Fusion MPT SPI Host driver 3.04.20
[    5.369528] Fusion MPT FC Host driver 3.04.20
[    5.370526] Fusion MPT SAS Host driver 3.04.20
[    5.371554] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.372708] mptctl: Registered with Fusion MPT base driver
[    5.373762] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    5.375025] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.376168] ehci-pci: EHCI PCI platform driver
[    5.377142] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.378228] ohci-pci: OHCI PCI platform driver
[    5.379187] uhci_hcd: USB Universal Host Controller Interface driver
[    5.380470] usbcore: registered new interface driver usb-storage
[    5.381609] usbcore: registered new interface driver ums-alauda
[    5.382798] usbcore: registered new interface driver ums-datafab
[    5.383930] usbcore: registered new interface driver ums-freecom
[    5.385103] usbcore: registered new interface driver ums-isd200
[    5.386220] usbcore: registered new interface driver ums-jumpshot
[    5.387365] usbcore: registered new interface driver ums-sddr09
[    5.388509] usbcore: registered new interface driver ums-sddr55
[    5.389640] usbcore: registered new interface driver ums-usbat
[    5.390775] usbcore: registered new interface driver usbtest
[    5.391969] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.394351] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.395371] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.396724] mousedev: PS/2 mouse device common for all mice
[    5.398541] rtc_cmos 00:00: RTC can wake from S4
[    5.399674] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.401640] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.403513] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.405246] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.407517] i6300esb: initialized (0xffffc90001ac2000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    5.410409] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.411849] iTCO_vendor_support: vendor-support=3D0
[    5.413001] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.414932] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    5.417135] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    5.419573] md: linear personality registered for level -1
[    5.420757] md: raid0 personality registered for level 0
[    5.421990] md: raid1 personality registered for level 1
[    5.423173] md: raid10 personality registered for level 10
[    5.424513] md: raid6 personality registered for level 6
[    5.425668] md: raid5 personality registered for level 5
[    5.426947] md: raid4 personality registered for level 4
[    5.428117] md: multipath personality registered for level -4
[    5.429326] md: faulty personality registered for level -5
[    5.431532] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.433751] device-mapper: multipath: version 1.6.0 loaded
[    5.435017] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.436353] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    5.437495] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.439115] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.443797] usbcore: registered new interface driver usbhid
[    5.444885] usbhid: USB HID core driver
[    5.446060] TCP: bic registered
[    5.446912] Initializing XFRM netlink socket
[    5.448333] NET: Registered protocol family 10
[    5.449589] sit: IPv6 over IPv4 tunneling driver
[    5.451027] NET: Registered protocol family 17
[    5.452031] 8021q: 802.1Q VLAN Support v1.8
[    5.454483] sctp: Hash tables configured (established 65536 bind 65536)
[    5.456106] Key type dns_resolver registered
[    5.458305]=20
[    5.458305] printing PIC contents
[    5.459829] ... PIC  IMR: ffff
[    5.460881] ... PIC  IRR: 9113
[    5.461962] ... PIC  ISR: 0000
[    5.463564] ... PIC ELCR: 0c00
[    5.474771] printing local APIC contents on CPU#0/0:
[    5.476321] ... APIC ID:      00000000 (0)
[    5.478006] ... APIC VERSION: 00050014
[    5.478757] ... APIC TASKPRI: 00000000 (00)
[    5.478757] ... APIC PROCPRI: 00000000
[    5.478757] ... APIC LDR: 01000000
[    5.478757] ... APIC DFR: ffffffff
[    5.478757] ... APIC SPIV: 000001ff
[    5.478757] ... APIC ISR field:
[    5.478757] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.478757] ... APIC TMR field:
[    5.478757] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.478757] ... APIC IRR field:
[    5.478757] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.478757] ... APIC ESR: 00000000
[    5.478757] ... APIC ICR: 000400f6
[    5.478757] ... APIC ICR2: 02000000
[    5.478757] ... APIC LVTT: 000000ef
[    5.478757] ... APIC LVTPC: 00010000
[    5.478757] ... APIC LVT0: 00010700
[    5.478757] ... APIC LVT1: 00000400
[    5.478757] ... APIC LVTERR: 000000fe
[    5.478757] ... APIC TMICT: 0003cabb
[    5.478757] ... APIC TMCCT: 00000000
[    5.478757] ... APIC TDCR: 00000003
[    5.478757]=20
[    5.506809] number of MP IRQ sources: 15.
[    5.507832] number of IO-APIC #0 registers: 24.
[    5.508915] testing the IO APIC.......................
[    5.510073] IO APIC #0......
[    5.510929] .... register #00: 00000000
[    5.511899] .......    : physical APIC id: 00
[    5.512966] .......    : Delivery Type: 0
[    5.513962] .......    : LTS          : 0
[    5.514961] .... register #01: 00170011
[    5.515944] .......     : max redirection entries: 17
[    5.517096] .......     : PRQ implemented: 0
[    5.518126] .......     : IO APIC version: 11
[    5.519170] .... register #02: 00000000
[    5.520159] .......     : arbitration: 00
[    5.521158] .... IRQ redirection table:
[    5.522144] 1    0    0   0   0    0    0    00
[    5.523232] 0    0    0   0   0    1    1    31
[    5.524322] 0    0    0   0   0    1    1    30
[    5.525399] 0    0    0   0   0    1    1    33
[    5.526474] 1    0    0   0   0    1    1    34
[    5.527549] 1    1    0   0   0    1    1    35
[    5.529018] 0    0    0   0   0    1    1    36
[    5.530363] 0    0    0   0   0    1    1    37
[    5.531438] 0    0    0   0   0    1    1    38
[    5.532816] 0    1    0   0   0    1    1    39
[    5.533893] 1    1    0   0   0    1    1    3A
[    5.534972] 1    1    0   0   0    1    1    3B
[    5.536066] 0    0    0   0   0    1    1    3C
[    5.537143] 0    0    0   0   0    1    1    3D
[    5.538485] 0    0    0   0   0    1    1    3E
[    5.539570] 0    0    0   0   0    1    1    3F
[    5.540669] 1    0    0   0   0    0    0    00
[    5.542095] 1    0    0   0   0    0    0    00
[    5.543202] 1    0    0   0   0    0    0    00
[    5.544294] 1    0    0   0   0    0    0    00
[    5.545369] 1    0    0   0   0    0    0    00
[    5.546444] 1    0    0   0   0    0    0    00
[    5.547517] 1    0    0   0   0    0    0    00
[    5.548611] 1    0    0   0   0    0    0    00
[    5.549676] IRQ to pin mappings:
[    5.550568] IRQ0 -> 0:2
[    5.551528] IRQ1 -> 0:1
[    5.552502] IRQ3 -> 0:3
[    5.553476] IRQ4 -> 0:4
[    5.554433] IRQ5 -> 0:5
[    5.555393] IRQ6 -> 0:6
[    5.556369] IRQ7 -> 0:7
[    5.557332] IRQ8 -> 0:8
[    5.558294] IRQ9 -> 0:9
[    5.559251] IRQ10 -> 0:10
[    5.560245] IRQ11 -> 0:11
[    5.561234] IRQ12 -> 0:12
[    5.562219] IRQ13 -> 0:13
[    5.563205] IRQ14 -> 0:14
[    5.564200] IRQ15 -> 0:15
[    5.565188] .................................... done.
[    5.567474] registered taskstats version 1
[    5.569933] rtc_cmos 00:00: setting system clock to 2014-01-01 01:40:50 =
UTC (1388540450)
[    5.571893] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    5.578898] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.580167] 8021q: adding VLAN 0 to HW filter on device eth0
[    5.704090] tsc: Refined TSC clocksource calibration: 2693.502 MHz
[    6.027178] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.584524] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    7.588065] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.604052] Sending DHCP requests ., OK
[    7.664056] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    7.666284] IP-Config: Complete:
[    7.667935]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.673247]      host=3Dkbuildx-1, domain=3D, nis-domain=3D(none)
[    7.674893]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    7.676434]      nameserver0=3D10.0.2.3
[    7.678717] PM: Hibernation image not present or could not be loaded.
[    7.682720] Freeing unused kernel memory: 1428K (ffffffff82336000 - ffff=
ffff8249b000)
[    7.684857] Write protecting the kernel read-only data: 18432k
[    7.694035] Freeing unused kernel memory: 1972K (ffff880001a13000 - ffff=
880001c00000)
[    7.701348] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff=
880002200000)
[    8.014945] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.021651] platform microcode: Direct firmware load failed with error -2
[    8.023340] platform microcode: Falling back to user helper
[    8.059021] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.060704] platform microcode: Direct firmware load failed with error -2
[    8.062061] platform microcode: Falling back to user helper
[    8.067301] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.068548] platform microcode: Direct firmware load failed with error -2
[    8.069917] platform microcode: Falling back to user helper
[    8.074719] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.075982] platform microcode: Direct firmware load failed with error -2
[    8.077384] platform microcode: Falling back to user helper
[    8.082609] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    8.543642] random: vgscan urandom read with 21 bits of entropy available

=3D=3D> /tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /tmp/err_log <=3D=3D

=3D=3D> /tmp/run_log <=3D=3D
downloading latest lkp src code
Files /etc/init.d/nfsroot and /lkp/lkp/src/rootfs/addon/etc/init.d/nfsroot =
differ
find a new version of this script, reloading...
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
RESULT_ROOT=3D/lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-=
1024-rndrw-sync/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0
job=3D/lkp/scheduled/kbuildx-1/cyclic_fileio-600s-100%-1HDD-btrfs-64G-1024-=
rndrw-sync-HEAD.yaml
2014-01-01 01:41:11 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/kbuildx-1/cyclic_fileio-600s-100%-1HDD-btrfs-64G-102=
4-rndrw-sync-HEAD.yaml
run: /lkp/lkp/src/setup/runtime 600s
run: /lkp/lkp/src/setup/nr_threads 100%
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/fs
2014-01-01 01:41:12 mkfs -t btrfs /dev/vdb
run: /lkp/lkp/src/monitors/event/wait pre-test
[   23.951722] btrfs: device fsid bd8e28ba-1b7a-4950-8545-072c1c32e60b=20
WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdb

Btrfs v0.20-rc1-566-gd1570a0
devid 1 transid 4 /dev/vdb
2014-01-01 01:41:12 mount -t btrfs /dev/vdb /fs/vdb
[   23.969393] btrfs: device fsid bd8e28ba-1b7a-4950-8545-072c1c32e60b devi=
d 1 transid 4 /dev/vdb
[   23.975019] btrfs: disk space caching is enabled
[   23.981152] btrfs: creating UUID tree
run: /lkp/lkp/src/setup/size 64G
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper buddyinfo
run: /lkp/lkp/src/monitors/wrapper pagetypeinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /lkp/lkp/src/monitors/wrapper pmeter
run: /lkp/lkp/src/monitors/wrapper diskstats
run: /lkp/lkp/src/monitors/wrapper zoneinfo
run: /lkp/lkp/src/monitors/wrapper energy
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/sysbench/wrapper file=
io
[   35.466413] random: nonblocking pool is initialized
[  196.918039] ------------[ cut here ]------------
[  196.919770] kernel BUG at fs/bio.c:1748!
[  196.921505] invalid opcode: 0000 [#1] SMP=20
[  196.921788] Modules linked in: microcode processor
[  196.921788] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc6-01897-g=
2b48961 #1
[  196.921788] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  196.921788] task: ffff8804094acad0 ti: ffff8804094e8000 task.ti: ffff880=
4094e8000
[  196.921788] RIP: 0010:[<ffffffff811ef01e>]  [<ffffffff811ef01e>] bio_end=
io+0x1e/0x6a
[  196.921788] RSP: 0018:ffff88041fc83da8  EFLAGS: 00010046
[  196.921788] RAX: 0000000000000000 RBX: 00000000fffffffb RCX: 00000001802=
a0002
[  196.921788] RDX: 00000001802a0003 RSI: 0000000000000000 RDI: ffff8800299=
ff9e8
[  196.921788] RBP: ffff88041fc83dc0 R08: ffffea00096cc980 R09: ffff8804097=
f5100
[  196.921788] R10: ffffea000aeb8280 R11: ffffffff8143841e R12: ffff88025b3=
26780
[  196.921788] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
03000
[  196.921788] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:=
0000000000000000
[  196.921788] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  196.921788] CR2: 00007f16e7a1948f CR3: 000000007f85e000 CR4: 00000000000=
006e0
[  196.921788] Stack:
[  196.921788]  ffff8800299ff9e8 ffff8800299ff9e8 ffff88025b326780 ffff8804=
1fc83de8
[  196.921788]  ffffffff81438429 00000000fffffffb ffff8803d36e6c00 00000000=
00000000
[  196.921788]  ffff88041fc83e10 ffffffff811ef063 ffff8802bae0a1e8 ffff8802=
bae0a1e8
[  196.921788] Call Trace:
[  196.921788]  <IRQ>=20
[  196.921788]  [<ffffffff81438429>] btrfs_end_bio+0x116/0x11d
[  196.921788]  [<ffffffff811ef063>] bio_endio+0x63/0x6a
[  196.921788]  [<ffffffff814cb712>] blk_mq_complete_request+0x89/0xfe
[  196.921788]  [<ffffffff814cb79d>] __blk_mq_end_io+0x16/0x18
[  196.921788]  [<ffffffff814cb7bf>] blk_mq_end_io+0x20/0xb1
[  196.921788]  [<ffffffff815a1ba9>] virtblk_done+0xa4/0xf6
[  196.921788]  [<ffffffff8155c463>] vring_interrupt+0x7c/0x8a
[  196.921788]  [<ffffffff81107427>] handle_irq_event_percpu+0x4a/0x1bc
[  196.921788]  [<ffffffff811075de>] handle_irq_event+0x45/0x61
[  196.921788]  [<ffffffff81109f40>] handle_edge_irq+0xd9/0xfb
[  196.921788]  [<ffffffff81039f56>] handle_irq+0x21/0x2a
[  196.921788]  [<ffffffff81a0c3fd>] do_IRQ+0x4d/0xb4
[  196.921788]  [<ffffffff81a034f2>] common_interrupt+0x72/0x72
[  196.921788]  <EOI>=20
[  196.921788]  [<ffffffff81065bfa>] ? native_safe_halt+0x6/0x8
[  196.921788]  [<ffffffff8103f5d8>] default_idle+0x38/0xc1
[  196.921788]  [<ffffffff8103fd04>] arch_cpu_idle+0x18/0x28
[  196.921788]  [<ffffffff81106b6b>] cpu_startup_entry+0x178/0x269
[  196.921788]  [<ffffffff81116954>] ? clockevents_register_device+0x112/0x=
117
[  196.921788]  [<ffffffff8105ba60>] start_secondary+0x277/0x279
[  196.921788] Code: ff ff eb bb 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 44 00 00 =
55 48 89 e5 41 54 53 53 bb fb ff ff ff 48 85 ff 74 4c 8b 47 44 85 c0 7f 02 =
<0f> 0b 85 f6 74 07 f0 80 67 10 fe eb 09 48 8b 47 10 a8 01 0f 44=20
[  196.921788] RIP  [<ffffffff811ef01e>] bio_endio+0x1e/0x6a
[  196.921788]  RSP <ffff88041fc83da8>
[  196.921788] ---[ end trace 0ec0fc28f7931a30 ]---
[  196.921788] Kernel panic - not syncing: Fatal exception in interrupt
[  196.921788] Rebooting in 10 seconds..
Elapsed time: 210
numactl --preferred=3D0 --physcpubind=3D4-7 qemu-system-x86_64 -cpu kvm64 -=
enable-kvm -kernel /kernel/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f=
6ec/vmlinuz-3.13.0-rc6-01897-g2b48961 -append 'user=3Dlkp job=3D/lkp/schedu=
led/kbuildx-1/cyclic_fileio-600s-100%-1HDD-btrfs-64G-1024-rndrw-sync-HEAD.y=
aml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/2b48961067b059a9260e0378c=
d4d83a0c959f6ec/vmlinuz-3.13.0-rc6-01897-g2b48961 kconfig=3Dx86_64-lkp comm=
it=3D2b48961067b059a9260e0378cd4d83a0c959f6ec modules_initrd=3D/kernel/x86_=
64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/modules.cgz max_uptime=3D38=
03 RESULT_ROOT=3D/lkp/result/kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-6=
4G-1024-rndrw-sync/x86_64-lkp/2b48961067b059a9260e0378cd4d83a0c959f6ec/0 in=
itrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuild=
x-1::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_=
always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3Dtty=
S0,115200 console=3Dtty0 vga=3Dnormal'  -initrd /fs/sda1/initrd-kbuildx-1 -=
m 16G -smp 4 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dt=
cp::9556-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloc=
altime -drive file=3D/fs/sda1/disk0-kbuildx-1,media=3Ddisk,if=3Dvirtio -dri=
ve file=3D/fs/sda1/disk1-kbuildx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/sda1/disk2-kbuildx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda1/dis=
k3-kbuildx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda1/disk4-kbuildx-=
1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda1/disk5-kbuildx-1,media=3Dd=
isk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-kbuildx-1 -serial file:/dev/shm=
/kboot/serial-kbuildx-1 -daemonize -display none -monitor null=20

--5mCyUwZo2JvN/JJP--
