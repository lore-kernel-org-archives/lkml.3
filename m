Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaEZTos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaEZTop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:44:45 -0400
Date: Mon, 26 May 2014 21:43:47 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: axboe@kernel.dk
Cc: jet.chen@intel.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [jet.chen@intel.com: [bio] kernel BUG at
 drivers/block/virtio_blk.c:166!]
Message-ID: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jens,

looks like that commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
introduces a regression, as reported by Jet Chan.

Do you have any idea about the possible problem with this patch?

it is the one that performs a recount of the segments in case of failure in __bio_add_page()

http://www.spinics.net/lists/mm-commits/msg103684.html

I would not be surprised if the bug was introduced by fceb38f36f, because it
contained a mystake that commit 3979ef4dcf supposedly fixed.
But learning that commit 3979ef4dcf is introducing a regression leaves
me quite puzzled.

Thanks,
Maurizio Lombardi

--X1bOJ3K7DJ5YkBrT
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: jet.chen@intel.com
Received: from zmta03.collab.prod.int.phx2.redhat.com (LHLO
 zmta03.collab.prod.int.phx2.redhat.com) (10.5.81.10) by
 zmail22.collab.prod.int.phx2.redhat.com with LMTP; Mon, 26 May 2014
 14:55:22 -0400 (EDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 1FFBB41173
	for <mlombard@mail.corp.redhat.com>; Mon, 26 May 2014 14:55:22 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx14.extmail.prod.ext.phx2.redhat.com [10.5.110.19])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4QItLqu014014
	for <mlombard@redhat.com>; Mon, 26 May 2014 14:55:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4QItGfn008381
	for <mlombard@redhat.com>; Mon, 26 May 2014 14:55:16 -0400
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP; 26 May 2014 11:55:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545155101"
Received: from hcai5-mobl.ccr.corp.intel.com (HELO [192.168.142.128]) ([10.255.27.111])
  by fmsmga002.fm.intel.com with ESMTP; 26 May 2014 11:55:09 -0700
Message-ID: <53838E0B.1020206@intel.com>
Date: Tue, 27 May 2014 02:55:07 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maurizio Lombardi <mlombard@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [bio] kernel BUG at drivers/block/virtio_blk.c:166!
Content-Type: multipart/mixed;
 boundary="------------090702090402070501040304"
X-RedHat-Spam-Score: -7.951  (BAYES_00,DCC_REPUT_00_12,RCVD_IN_DNSWL_HI,RP_MATCHES_RCVD,SPF_PASS,URIBL_BLOCKED)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.12
X-Scanned-By: MIMEDefang 2.68 on 10.5.110.19

This is a multi-part message in MIME format.
--------------090702090402070501040304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Maurizio,

FYI, we noticed the below changes on

commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")

+------------------------------------------+------------+------------+
|                                          | fceb38f36f | 3979ef4dcf |
+------------------------------------------+------------+------------+
| boot_successes                           | 25         | 10         |
| boot_failures                            | 0          | 6          |
| kernel_BUG_at_drivers/block/virtio_blk.c | 0          | 6          |
| invalid_opcode                           | 0          | 6          |
| RIP:virtio_queue_rq                      | 0          | 6          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 6          |
| backtrace:blk_mq_work_fn                 | 0          | 6          |
| kernel_BUG_at_arch/x86/mm/pageattr.c     | 0          | 3          |
| RIP:change_page_attr_set_clr             | 0          | 3          |
+------------------------------------------+------------+------------+


[  725.907416] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  728.625269] EXT4-fs (vdd): mounted filesystem without journal. Opts: acl,user_xattr,noload
[  729.053064] ------------[ cut here ]------------
[  729.053181] kernel BUG at drivers/block/virtio_blk.c:166!
[  729.053181] invalid opcode: 0000 [#1] SMP [  729.053181] Modules linked in: ext4 mbcache jbd2 dm_mod fuse sg sr_mod cdrom ata_generic pata_acpi floppy parport_pc snd_pcm parport snd_timer cirrus syscopyarea sysfillrect snd sysimgblt ttm drm_kms_helper soundcore drm pcspkr ata_piix libata i2c_piix4
[  729.053181] CPU: 0 PID: 1645 Comm: kworker/0:1H Not tainted 3.15.0-rc5-next-20140521 #1
[  729.053181] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  729.053181] task: ffff880119add880 ti: ffff880103264000 task.ti: ffff880103264000
[  729.053181] RIP: 0010:[<ffffffff81425b27>]  [<ffffffff81425b27>] virtio_queue_rq+0x217/0x220
[  729.053181] RSP: 0018:ffff880103265d58  EFLAGS: 00010202
[  729.053181] RAX: 0000000000000081 RBX: ffff880116164900 RCX: dead000000200200
[  729.053181] RDX: 0000000000007530 RSI: ffff8800a16c4800 RDI: ffff8800a1693400
[  729.053181] RBP: ffff880103265d98 R08: ffff8800a16c4800 R09: ffff880103265dc8
[  729.053181] R10: dffd025bd0493448 R11: 0000000000001000 R12: ffff8800a16c4800
[  729.053181] R13: ffff880103265dc8 R14: 0000000110000001 R15: ffff8800a1693400
[  729.053181] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  729.053181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  729.053181] CR2: 000000000225a000 CR3: 000000008fc00000 CR4: 00000000000006f0
[  729.053181] Stack:
[  729.053181]  ffff880103265d80 ffffffff810a7295 ffff8800a16c4970 ffff8800a1559680
[  729.053181]  ffff8800a1693400 ffff880103265dc8 ffff8800a16c4800 ffff8800a14e1280
[  729.053181]  ffff880103265e00 ffffffff812e0335 ffff8800a1693408 ffff8800a1559680
[  729.053181] Call Trace:
[  729.053181]  [<ffffffff810a7295>] ? set_next_entity+0x95/0xb0
[  729.053181]  [<ffffffff812e0335>] __blk_mq_run_hw_queue+0x245/0x410
[  729.053181]  [<ffffffff812e0772>] blk_mq_run_work_fn+0x12/0x20
[  729.053181]  [<ffffffff810893b3>] process_one_work+0x183/0x490
[  729.053181]  [<ffffffff81089b7d>] worker_thread+0x11d/0x5c0
[  729.053181]  [<ffffffff81089a60>] ? rescuer_thread+0x3a0/0x3a0
[  729.053181]  [<ffffffff81090832>] kthread+0xd2/0xf0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180
[  729.053181]  [<ffffffff8175e47c>] ret_from_fork+0x7c/0xb0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180
[  729.053181] Code: 00 00 00 00 0f b7 86 f4 00 00 00 c7 86 78 01 00 00 02 00 00 00 48 c7 86 80 01 00 00 00 00 00 00 89 86 7c 01 00 00 e9 6f fe ff ff <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 [  729.053181] RIP  [<ffffffff81425b27>] virtio_queue_rq+0x217/0x220
[  729.053181]  RSP <ffff880103265d58>
[  729.053181] ------------[ cut here ]------------


Full dmesg and reproduce script attached.

Thanks,
Jet


--------------090702090402070501040304
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce"

mkfs -t ext4 -q /dev/vdc
mkfs -t ext4 -q /dev/vdb
mkfs -t ext4 -q /dev/vda
mkfs -t ext4 -q /dev/vdd
mount -t ext4 /dev/vda /fs/vda
mount -t ext4 /dev/vdb /fs/vdb
mount -t ext4 /dev/vdc /fs/vdc
mount -t ext4 /dev/vdd /fs/vdd
export TEST_DIR=/fs/vda
export TEST_DEV=/dev/vda
export SCRATCH_MNT=/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV=/dev/vdd
./check ext4/271 ext4/301 ext4/305


--------------090702090402070501040304
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg"

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-next-20140521 (kbuild@ivytown2) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Wed May 21 16:15:30 CST 2014=

[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-6/cyclic=
_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e072998c67e985aaa643ca1af3e6a0dc133b=
71.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/18e072998c67e985aa=
a643ca1af3e6a0dc133b71/vmlinuz-3.15.0-rc5-next-20140521 kconfig=3Dx86_64-=
rhel commit=3D18e072998c67e985aaa643ca1af3e6a0dc133b71 initrd=3D/kernel-t=
ests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/x=
fstests.cgz modules_initrd=3D/kernel/x86_64-rhel/18e072998c67e985aaa643ca=
1af3e6a0dc133b71/modules.cgz max_uptime=3D3288 RESULT_ROOT=3D/result/vpx/=
xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c67e985aaa643ca1af3e6a0dc133=
b71/0 ip=3D::::vpx-6::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped a=
t [ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02035000, 0x02035fff] PGTABLE
[    0.000000] BRK [0x02036000, 0x02036fff] PGTABLE
[    0.000000] BRK [0x02037000, 0x02037fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02038000, 0x02038fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x710cc000-0x7fffffff]
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011ffffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b600=
000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s86848 r81=
92 d23744 u524288
[    0.000000] pcpu-alloc: s86848 r8192 d23744 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-6=
/cyclic_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e072998c67e985aaa643ca1af3e6a=
0dc133b71.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/18e072998c6=
7e985aaa643ca1af3e6a0dc133b71/vmlinuz-3.15.0-rc5-next-20140521 kconfig=3D=
x86_64-rhel commit=3D18e072998c67e985aaa643ca1af3e6a0dc133b71 initrd=3D/k=
ernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/bench=
marks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/18e072998c67e985a=
aa643ca1af3e6a0dc133b71/modules.cgz max_uptime=3D3288 RESULT_ROOT=3D/resu=
lt/vpx/xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c67e985aaa643ca1af3e6=
a0dc133b71/0 ip=3D::::vpx-6::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2=
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3799264K/4193904K available (7565K kernel code, 15=
07K rwdata, 3552K rodata, 1728K init, 2188K bss, 394640K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-next-20140521 (kbuild@ivytown2) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Wed May 21 16:15:30 CST 2014=

[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-6/cyclic=
_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e072998c67e985aaa643ca1af3e6a0dc133b=
71.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/18e072998c67e985aa=
a643ca1af3e6a0dc133b71/vmlinuz-3.15.0-rc5-next-20140521 kconfig=3Dx86_64-=
rhel commit=3D18e072998c67e985aaa643ca1af3e6a0dc133b71 initrd=3D/kernel-t=
ests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/benchmarks/x=
fstests.cgz modules_initrd=3D/kernel/x86_64-rhel/18e072998c67e985aaa643ca=
1af3e6a0dc133b71/modules.cgz max_uptime=3D3288 RESULT_ROOT=3D/result/vpx/=
xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c67e985aaa643ca1af3e6a0dc133=
b71/0 ip=3D::::vpx-6::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped a=
t [ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02035000, 0x02035fff] PGTABLE
[    0.000000] BRK [0x02036000, 0x02036fff] PGTABLE
[    0.000000] BRK [0x02037000, 0x02037fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02038000, 0x02038fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x710cc000-0x7fffffff]
[    0.000000] ACPI: RSDP 0x00000000000FD880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000DFFFE380 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000DFFFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000DFFFE3C0 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000DFFFFF40 000040
[    0.000000] ACPI: SSDT 0x00000000DFFFF6E0 000858 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000DFFFF5B0 000090 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000DFFFF570 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011ffffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11ffd5000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ff55001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b600=
000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fc00000 s86848 r81=
92 d23744 u524288
[    0.000000] pcpu-alloc: s86848 r8192 d23744 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0e000
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-6=
/cyclic_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e072998c67e985aaa643ca1af3e6a=
0dc133b71.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/18e072998c6=
7e985aaa643ca1af3e6a0dc133b71/vmlinuz-3.15.0-rc5-next-20140521 kconfig=3D=
x86_64-rhel commit=3D18e072998c67e985aaa643ca1af3e6a0dc133b71 initrd=3D/k=
ernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_initrd=3D/lkp/bench=
marks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/18e072998c67e985a=
aa643ca1af3e6a0dc133b71/modules.cgz max_uptime=3D3288 RESULT_ROOT=3D/resu=
lt/vpx/xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c67e985aaa643ca1af3e6=
a0dc133b71/0 ip=3D::::vpx-6::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2=
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3799264K/4193904K available (7565K kernel code, 15=
07K rwdata, 3552K rodata, 1728K init, 2188K bss, 394640K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.474 MHz processor
[    0.002000] Calibrating delay loop (skipped) preset value.. 5386.94 Bo=
goMIPS (lpj=3D2693474)
[    0.002333] pid_max: default: 32768 minimum: 301
[    0.003016] ACPI: Core revision 20140424
[    0.004851] ACPI: All ACPI Tables successfully acquired
[    0.005687] Security Framework initialized
[    0.006009] SELinux:  Initializing.
[    0.007010] SELinux:  Starting in permissive mode
[    0.008160] Dentry cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    0.012084] Inode-cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
[    0.014375] Mount-cache hash table entries: 8192 (order: 4, 65536 byte=
s)
[    0.015010] Mountpoint-cache hash table entries: 8192 (order: 4, 65536=
 bytes)
[    0.016357] Initializing cgroup subsys memory
[    0.017028] Initializing cgroup subsys devices
[    0.018010] Initializing cgroup subsys freezer
[    0.018681] Initializing cgroup subsys net_cls
[    0.019007] Initializing cgroup subsys blkio
[    0.020008] Initializing cgroup subsys perf_event
[    0.020707] Initializing cgroup subsys hugetlb
[    0.021056] mce: CPU supports 10 MCE banks
[    0.022041] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022041] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.022041] tlb_flushall_shift: 6
[    0.023110] Freeing SMP alternatives memory: 32K (ffffffff81e08000 - f=
fffffff81e10000)
[    0.027361] ftrace: allocating 28488 entries in 112 pages
[    0.034151] Getting VERSION: 50014
[    0.035008] Getting VERSION: 50014
[    0.035581] Getting ID: 0
[    0.036011] Getting ID: ff000000
[    0.036578] Getting LVT0: 8700
[    0.037005] Getting LVT1: 8400
[    0.037592] enabled ExtINT on CPU#0
[    0.039115] ENABLING IO-APIC IRQs
[    0.039681] init IO_APIC IRQs
[    0.040004]  apic 0 pin 0 not connected
[    0.040628] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.041015] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.042015] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.043014] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.044018] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.046002] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.047013] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.048014] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.049014] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.050013] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.051013] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.052014] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.053014] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.054013] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.055014] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.056012]  apic 0 pin 16 not connected
[    0.056622]  apic 0 pin 17 not connected
[    0.057002]  apic 0 pin 18 not connected
[    0.058002]  apic 0 pin 19 not connected
[    0.058613]  apic 0 pin 20 not connected
[    0.059002]  apic 0 pin 21 not connected
[    0.060002]  apic 0 pin 22 not connected
[    0.060606]  apic 0 pin 23 not connected
[    0.061151] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.062002] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.064004] Using local APIC timer interrupts.
[    0.064004] calibrating APIC timer ...
[    0.066000] ... lapic delta =3D 6251428
[    0.066000] ... PM-Timer delta =3D 358092
[    0.066000] ... PM-Timer result ok
[    0.066000] ..... delta 6251428
[    0.066000] ..... mult: 268496788
[    0.066000] ..... calibration result: 1000228
[    0.066000] ..... CPU clock speed is 2694.0928 MHz.
[    0.066000] ..... host bus clock speed is 1000.0228 MHz.
[    0.066086] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.069515] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.070191] x86: Booting SMP configuration:
[    0.071003] .... node  #0, CPUs:      #1
[    0.069488] kvm-clock: cpu 1, msr 1:1ff55041, secondary cpu clock
[    0.069488] masked ExtINT on CPU#1
[    0.084054] KVM setup async PF for cpu 1
[    0.085000]  #2
[    0.085000] kvm-stealtime: cpu 1, msr 11fc8e000
[    0.084053] kvm-clock: cpu 2, msr 1:1ff55081, secondary cpu clock
[    0.084053] masked ExtINT on CPU#2
[    0.097011] KVM setup async PF for cpu 2
[    0.097788]  #3
[    0.097788] kvm-stealtime: cpu 2, msr 11fd0e000
[    0.097024] kvm-clock: cpu 3, msr 1:1ff550c1, secondary cpu clock
[    0.097024] masked ExtINT on CPU#3
[    0.110028] x86: Booted up 1 node, 4 CPUs
[    0.110011] KVM setup async PF for cpu 3
[    0.110015] kvm-stealtime: cpu 3, msr 11fd8e000
[    0.112003] smpboot: Total of 4 processors activated (21547.79 BogoMIP=
S)
[    0.114314] devtmpfs: initialized
[    0.117366] evm: security.selinux
[    0.117983] evm: security.ima
[    0.118002] evm: security.capability
[    0.120231] atomic64 test passed for x86-64 platform with CX8 and with=
 SSE
[    0.121080] NET: Registered protocol family 16
[    0.122229] cpuidle: using governor menu
[    0.123192] ACPI: bus type PCI registered
[    0.123877] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.124114] PCI: Using configuration type 1 for base access
[    0.129129] ACPI: Added _OSI(Module Device)
[    0.130003] ACPI: Added _OSI(Processor Device)
[    0.131002] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.131751] ACPI: Added _OSI(Processor Aggregator Device)
[    0.134315] ACPI: Interpreter enabled
[    0.134971] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20140424/hwxface-580)
[    0.136500] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.138010] ACPI: (supports S0 S3 S4 S5)
[    0.138678] ACPI: Using IOAPIC for interrupt routing
[    0.139015] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.143052] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.143965] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments =
MSI]
[    0.144007] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.146005] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.147268] acpiphp: Slot [3] registered
[    0.148022] acpiphp: Slot [4] registered
[    0.149021] acpiphp: Slot [5] registered
[    0.150021] acpiphp: Slot [6] registered
[    0.150711] acpiphp: Slot [7] registered
[    0.151033] acpiphp: Slot [8] registered
[    0.152021] acpiphp: Slot [9] registered
[    0.152708] acpiphp: Slot [10] registered
[    0.153021] acpiphp: Slot [11] registered
[    0.154023] acpiphp: Slot [12] registered
[    0.154718] acpiphp: Slot [13] registered
[    0.155020] acpiphp: Slot [14] registered
[    0.156028] acpiphp: Slot [15] registered
[    0.157091] acpiphp: Slot [24] registered
[    0.157788] acpiphp: Slot [25] registered
[    0.158020] acpiphp: Slot [26] registered
[    0.159029] acpiphp: Slot [27] registered
[    0.159740] acpiphp: Slot [28] registered
[    0.160021] acpiphp: Slot [29] registered
[    0.161027] acpiphp: Slot [30] registered
[    0.162021] acpiphp: Slot [31] registered
[    0.162701] PCI host bridge to bus 0000:00
[    0.163004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.164003] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.165003] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.166003] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.167003] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebff=
fff]
[    0.168032] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.169256] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.170394] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.174003] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.175793] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.176003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.177003] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.178002] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.179131] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.181165] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.182010] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.183185] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.185618] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.188031] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.195036] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.196385] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.198501] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.200013] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.206003] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.207184] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.209003] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.211003] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.217116] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.219003] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.221507] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.227267] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.229503] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.231003] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.237264] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.239003] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.241003] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.247247] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.249003] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.250980] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.257084] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.258977] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.260500] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.266744] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.268262] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.272509] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.273710] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.275074] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.276429] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.277593] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.278852] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.280195] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.281003] vgaarb: loaded
[    0.282002] vgaarb: bridge control possible 0000:00:02.0
[    0.283192] SCSI subsystem initialized
[    0.283902] ACPI: bus type USB registered
[    0.284042] usbcore: registered new interface driver usbfs
[    0.285018] usbcore: registered new interface driver hub
[    0.286107] usbcore: registered new device driver usb
[    0.287041] pps_core: LinuxPPS API ver. 1 registered
[    0.288002] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.289008] PTP clock support registered
[    0.290119] PCI: Using ACPI for IRQ routing
[    0.291005] PCI: pci_cache_line_size set to 64 bytes
[    0.291939] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.292006] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.293196] NetLabel: Initializing
[    0.294005] NetLabel:  domain hash size =3D 128
[    0.295001] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.296020] NetLabel:  unlabeled traffic allowed by default
[    0.297124] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.298020] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.299003] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.303079] Switched to clocksource kvm-clock
[    0.313800] pnp: PnP ACPI init
[    0.314416] ACPI: bus type PNP registered
[    0.315157] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:15)
[    0.316490] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.317466] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:15)
[    0.318811] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.319797] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:15)
[    0.321146] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.322126] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:15)
[    0.323439] pnp 00:03: [dma 2]
[    0.324057] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.324992] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:15)
[    0.326248] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.327169] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:15)
[    0.328414] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.329343] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:15)
[    0.330597] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.331577] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.332544] pnp: PnP ACPI: found 8 devices
[    0.333239] ACPI: bus type PNP unregistered
[    0.343998] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.344858] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.345704] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.346613] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.347566] NET: Registered protocol family 2
[    0.348520] TCP established hash table entries: 32768 (order: 6, 26214=
4 bytes)
[    0.350127] TCP bind hash table entries: 32768 (order: 7, 524288 bytes=
)
[    0.351418] TCP: Hash tables configured (established 32768 bind 32768)=

[    0.352455] TCP: reno registered
[    0.353069] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.354013] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.355086] NET: Registered protocol family 1
[    0.355999] RPC: Registered named UNIX socket transport module.
[    0.356846] RPC: Registered udp transport module.
[    0.357560] RPC: Registered tcp transport module.
[    0.358274] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.359162] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.359995] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.360840] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.361731] pci 0000:00:02.0: Boot video device
[    0.362486] PCI: CLS 0 bytes, default 64
[    0.363234] Unpacking initramfs...
[    4.686967] Freeing initrd memory: 244944K (ffff8800710cc000 - ffff880=
080000000)
[    4.688281] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.689225] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped =
at [ffff8800dbffe000-ffff8800dfffdfff]
[    4.692144] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    4.693412] Initialise system trusted keyring
[    4.694431] audit: initializing netlink subsys (disabled)
[    4.695580] audit: type=3D2000 audit(1400663208.226:1): initialized
[    4.697654] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.701137] zbud: loaded
[    4.702195] VFS: Disk quotas dquot_6.5.2
[    4.703169] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.705073] 9p: Installing v9fs 9p2000 file system support
[    4.706280] msgmni has been set to 7898
[    4.707395] Key type big_key registered
[    4.708321] SELinux:  Registering netfilter hooks
[    4.712872] alg: No test for stdrng (krng)
[    4.713619] NET: Registered protocol family 38
[    4.714748] Key type asymmetric registered
[    4.715800] Asymmetric key parser 'x509' registered
[    4.717019] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 250)
[    4.718993] io scheduler noop registered
[    4.720000] io scheduler deadline registered (default)
[    4.721269] io scheduler cfq registered
[    4.722402] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.723665] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    4.725224] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    4.727107] ACPI: Power Button [PWRF]
[    4.728510] GHES: HEST is not enabled!
[    4.729955] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.731256] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:15)
[    4.735259] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.736592] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:15)
[    4.740623] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.744308] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.754489] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.780451] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    4.783287] Non-volatile memory driver v1.3
[    4.784379] Linux agpgart interface v0.103
[    4.785881] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.787192] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.789840]  vda: unknown partition table
[    4.792757] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.794021] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.796459]  vdb: unknown partition table
[    4.799235] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.800505] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.802956]  vdc: unknown partition table
[    4.805693] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.806984] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.809438]  vdd: unknown partition table
[    4.812159] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.813395] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    4.816076]  vde: unknown partition table
[    4.819073] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    4.820486] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    4.822864]  vdf: unknown partition table
[    4.825623] rdac: device handler registered
[    4.827034] hp_sw: device handler registered
[    4.828414] emc: device handler registered
[    4.829610] alua: device handler registered
[    4.830879] libphy: Fixed MDIO Bus: probed
[    4.832131] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k=
8-NAPI
[    4.833857] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.156973] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34=
:56
[    5.157931] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connect=
ion
[    5.158879] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.159685] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    5.160514] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.=
0.5-k
[    5.161416] igb: Copyright (c) 2007-2014 Intel Corporation.
[    5.162209] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - ve=
rsion 3.19.1-k
[    5.163359] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    5.164219] usbcore: registered new interface driver catc
[    5.164981] usbcore: registered new interface driver kaweth
[    5.165760] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ether=
net driver
[    5.166898] usbcore: registered new interface driver pegasus
[    5.170120] usbcore: registered new interface driver rtl8150
[    5.170905] usbcore: registered new interface driver asix
[    5.171664] usbcore: registered new interface driver cdc_ether
[    5.172470] usbcore: registered new interface driver cdc_eem
[    5.173266] usbcore: registered new interface driver dm9601
[    5.174052] usbcore: registered new interface driver smsc75xx
[    5.174841] usbcore: registered new interface driver smsc95xx
[    5.175638] usbcore: registered new interface driver gl620a
[    5.176423] usbcore: registered new interface driver net1080
[    5.177236] usbcore: registered new interface driver plusb
[    5.178021] usbcore: registered new interface driver rndis_host
[    5.178827] usbcore: registered new interface driver cdc_subset
[    5.179637] usbcore: registered new interface driver zaurus
[    5.180417] usbcore: registered new interface driver MOSCHIP usb-ether=
net driver
[    5.181557] usbcore: registered new interface driver int51x1
[    5.182348] usbcore: registered new interface driver ipheth
[    5.183133] usbcore: registered new interface driver sierra_net
[    5.183986] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    5.184874] ehci-pci: EHCI PCI platform driver
[    5.185558] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.186394] ohci-pci: OHCI PCI platform driver
[    5.187073] uhci_hcd: USB Universal Host Controller Interface driver
[    5.187970] usbcore: registered new interface driver usbserial
[    5.188787] usbcore: registered new interface driver usbserial_generic=

[    5.189658] usbserial: USB Serial support registered for generic
[    5.190509] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    5.192376] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.193201] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.194070] mousedev: PS/2 mouse device common for all mice
[    5.195315] rtc_cmos 00:00: RTC can wake from S4
[    5.196383] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    5.198089] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.199271] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpe=
t irqs
[    5.200384] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.201553] i6300esb: initialized (0xffffc90000764000). heartbeat=3D30=
 sec (nowayout=3D0)
[    5.202944] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    5.203843] iTCO_vendor_support: vendor-support=3D0
[    5.204761] hidraw: raw HID events driver (C) Jiri Kosina
[    5.205851] usbcore: registered new interface driver usbhid
[    5.206751] usbhid: USB HID core driver
[    5.207503] drop_monitor: Initializing network drop monitor service
[    5.208600] TCP: cubic registered
[    5.209336] Initializing XFRM netlink socket
[    5.210325] NET: Registered protocol family 10
[    5.211430] NET: Registered protocol family 17
[    5.212219] 9pnet: Installing 9P2000 support
[    5.213279]=20
[    5.213279] printing PIC contents
[    5.214273] ... PIC  IMR: ffff
[    5.214889] ... PIC  IRR: 1113
[    5.215519] ... PIC  ISR: 0000
[    5.216152] ... PIC ELCR: 0c00
[    5.216788] printing local APIC contents on CPU#0/0:
[    5.217578] ... APIC ID:      00000000 (0)
[    5.217776] ... APIC VERSION: 00050014
[    5.217776] ... APIC TASKPRI: 00000000 (00)
[    5.217776] ... APIC PROCPRI: 00000000
[    5.217776] ... APIC LDR: 01000000
[    5.217776] ... APIC DFR: ffffffff
[    5.217776] ... APIC SPIV: 000001ff
[    5.217776] ... APIC ISR field:
[    5.217776] 0000000000000000000000000000000000000000000000000000000000=
000000
[    5.217776] ... APIC TMR field:
[    5.217776] 0000000002000000000000000000000000000000000000000000000000=
000000
[    5.217776] ... APIC IRR field:
[    5.217776] 0000000000000000000000000000000000000000000000000000000000=
000000
[    5.217776] ... APIC ESR: 00000000
[    5.217776] ... APIC ICR: 000008fd
[    5.217776] ... APIC ICR2: 02000000
[    5.217776] ... APIC LVTT: 000000ef
[    5.217776] ... APIC LVTPC: 00010000
[    5.217776] ... APIC LVT0: 00010700
[    5.217776] ... APIC LVT1: 00000400
[    5.217776] ... APIC LVTERR: 000000fe
[    5.217776] ... APIC TMICT: 01c9982d
[    5.217776] ... APIC TMCCT: 01b3ccc3
[    5.217776] ... APIC TDCR: 00000003
[    5.217776]=20
[    5.235812] number of MP IRQ sources: 15.
[    5.236477] number of IO-APIC #0 registers: 24.
[    5.237179] testing the IO APIC.......................
[    5.237941] IO APIC #0......
[    5.238481] .... register #00: 00000000
[    5.239115] .......    : physical APIC id: 00
[    5.239789] .......    : Delivery Type: 0
[    5.240435] .......    : LTS          : 0
[    5.241083] .... register #01: 00170011
[    5.241702] .......     : max redirection entries: 17
[    5.242456] .......     : PRQ implemented: 0
[    5.243132] .......     : IO APIC version: 11
[    5.243808] .... register #02: 00000000
[    5.244438] .......     : arbitration: 00
[    5.245092] .... IRQ redirection table:
[    5.245723] 1    0    0   0   0    0    0    00
[    5.246428] 0    0    0   0   0    1    1    31
[    5.247139] 0    0    0   0   0    1    1    30
[    5.247834] 0    0    0   0   0    1    1    33
[    5.248543] 1    0    0   0   0    1    1    34
[    5.249313] 1    1    0   0   0    1    1    35
[    5.250022] 0    0    0   0   0    1    1    36
[    5.250716] 0    0    0   0   0    1    1    37
[    5.251422] 0    0    0   0   0    1    1    38
[    5.252131] 0    1    0   0   0    1    1    39
[    5.252828] 1    1    0   0   0    1    1    3A
[    5.253524] 1    1    0   0   0    1    1    3B
[    5.254223] 0    0    0   0   0    1    1    3C
[    5.254901] 0    0    0   0   0    1    1    3D
[    5.255591] 0    0    0   0   0    1    1    3E
[    5.256277] 0    0    0   0   0    1    1    3F
[    5.256958] 1    0    0   0   0    0    0    00
[    5.257642] 1    0    0   0   0    0    0    00
[    5.258332] 1    0    0   0   0    0    0    00
[    5.259016] 1    0    0   0   0    0    0    00
[    5.259689] 1    0    0   0   0    0    0    00
[    5.260384] 1    0    0   0   0    0    0    00
[    5.261070] 1    0    0   0   0    0    0    00
[    5.261746] 1    0    0   0   0    0    0    00
[    5.262420] IRQ to pin mappings:
[    5.262970] IRQ0 -> 0:2
[    5.263578] IRQ1 -> 0:1
[    5.264185] IRQ3 -> 0:3
[    5.264783] IRQ4 -> 0:4
[    5.265391] IRQ5 -> 0:5
[    5.265990] IRQ6 -> 0:6
[    5.266592] IRQ7 -> 0:7
[    5.267197] IRQ8 -> 0:8
[    5.267794] IRQ9 -> 0:9
[    5.268397] IRQ10 -> 0:10
[    5.269029] IRQ11 -> 0:11
[    5.269639] IRQ12 -> 0:12
[    5.270260] IRQ13 -> 0:13
[    5.270882] IRQ14 -> 0:14
[    5.271499] IRQ15 -> 0:15
[    5.272123] .................................... done.
[    5.273062] Loading compiled-in X.509 certificates
[    5.274498] Loaded X.509 cert 'Magrathea: Glacier signing key: 9636e5a=
da1c9890bf04ae4b43152ea2863600d80'
[    5.275923] registered taskstats version 1
[    5.279501] Key type trusted registered
[    5.282392] Key type encrypted registered
[    5.284937] ima: No TPM chip found, activating TPM-bypass!
[    5.286378] rtc_cmos 00:00: setting system clock to 2014-05-21 17:06:4=
8 UTC (1400692008)
[    5.290682] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.691205] tsc: Refined TSC clocksource calibration: 2693.508 MHz
[    6.045804] input: ImExPS/2 Generic Explorer Mouse as /devices/platfor=
m/i8042/serio1/input/input3
[    7.295543] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[    7.297139] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.307077] Sending DHCP requests ., OK
[    7.312084] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10=
=2E0.2.15
[    7.313245] IP-Config: Complete:
[    7.313855]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D1=
0.0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.315328]      host=3Dvpx-6, domain=3D, nis-domain=3D(none)
[    7.316138]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpat=
h=3D
[    7.316831]      nameserver0=3D10.0.2.3
[    7.317834] PM: Hibernation image not present or could not be loaded.
[    7.320210] Freeing unused kernel memory: 1728K (ffffffff81c58000 - ff=
ffffff81e08000)
[    7.449056] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100,=
 revision 0
[    7.454434] libata version 3.00 loaded.
[    7.456754] ata_piix 0000:00:01.1: version 2.13
[    7.466426] input: PC Speaker as /devices/platform/pcspkr/input/input4=

[    7.467430] scsi0 : ata_piix
[    7.471296] scsi1 : ata_piix
[    7.473016] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq=
 14
[    7.474086] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq=
 15
[    7.476639] [drm] Initialized drm 1.1.0 20060810
[    7.490298] [TTM] Zone  kernel: Available graphics memory: 2022984 kiB=

[    7.491356] [TTM] Initializing pool allocator
[    7.491407] [TTM] Initializing DMA pool allocator
[    7.491712] [drm] fb mappable at 0xFC000000
[    7.491713] [drm] vram aper at 0xFC000000
[    7.491715] [drm] size 4194304
[    7.491715] [drm] fb depth is 24
[    7.491715] [drm]    pitch is 3072
[    7.496997] fbcon: cirrusdrmfb (fb0) is primary device
[    7.501841] parport_pc 00:04: reported by Plug and Play ACPI
[    7.501950] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    7.502877] Error: Driver 'pcspkr' is already registered, aborting...
[    7.503464] Floppy drive(s): fd0 is 1.44M
[    7.512629] Console: switching to colour frame buffer device 128x48
[    7.514408] FDC 0 is a S82078B
[    7.525574] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    7.525575] cirrus 0000:00:02.0: registered panic notifier
[    7.537168] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 o=
n minor 0
[    7.626380] ata2.01: NODEV after polling detection
[    7.626996] ata2.00: ATAPI: QEMU DVD-ROM, 1.7.1, max UDMA/100
[    7.627828] ata2.00: configured for MWDMA2
[    7.628778] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     =
1.7. PQ: 0 ANSI: 5
[    7.648783] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    7.649276] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.649823] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.653288] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    7.786457] fuse init (API version 7.23)
[    8.043756] device-mapper: uevent: version 1.0.3
[    8.045415] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[    8.049449] random: vgscan urandom read with 49 bits of entropy availa=
ble

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/lkp/src/tmp/err_log <=3D=3D

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/result/vpx/xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c6=
7e985aaa643ca1af3e6a0dc133b71/0
job=3D/lkp/scheduled/vpx-6/cyclic_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e07=
2998c67e985aaa643ca1af3e6a0dc133b71.yaml
run-job /lkp/scheduled/vpx-6/cyclic_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e=
072998c67e985aaa643ca1af3e6a0dc133b71.yaml
2014-05-21 17:23:24 mkfs -t ext4 -q /dev/vdc
2014-05-21 17:23:24 mkfs -t ext4 -q /dev/vdb
2014-05-21 17:23:24 mkfs -t ext4 -q /dev/vda
2014-05-21 17:23:24 mkfs -t ext4 -q /dev/vdd
[   46.936443] random: nonblocking pool is initialized
2014-05-21 17:34:51 mount -t ext4 /dev/vda /fs/vda
[  718.720436] EXT4-fs (vda): mounted filesystem with ordered data mode. =
Opts: (null)
2014-05-21 17:34:51 mount -t ext4 /dev/vdb /fs/vdb
[  718.740056] EXT4-fs (vdb): mounted filesystem with ordered data mode. =
Opts: (null)
2014-05-21 17:34:51 mount -t ext4 /dev/vdc /fs/vdc
[  718.757160] EXT4-fs (vdc): mounted filesystem with ordered data mode. =
Opts: (null)
2014-05-21 17:34:51 mount -t ext4 /dev/vdd /fs/vdd
[  718.773281] EXT4-fs (vdd): mounted filesystem with ordered data mode. =
Opts: (null)
run: pre-test
[  720.524136] EXT4-fs (vda): mounted filesystem with ordered data mode. =
Opts: (null)
[  724.032155] EXT4-fs (vdd): mounted filesystem with ordered data mode. =
Opts: acl,user_xattr
[  725.907416] EXT4-fs (vda): mounted filesystem with ordered data mode. =
Opts: acl,user_xattr
[  728.625269] EXT4-fs (vdd): mounted filesystem without journal. Opts: a=
cl,user_xattr,noload
[  729.053064] ------------[ cut here ]------------
[  729.053181] kernel BUG at drivers/block/virtio_blk.c:166!
[  729.053181] invalid opcode: 0000 [#1] SMP=20
[  729.053181] Modules linked in: ext4 mbcache jbd2 dm_mod fuse sg sr_mod=
 cdrom ata_generic pata_acpi floppy parport_pc snd_pcm parport snd_timer =
cirrus syscopyarea sysfillrect snd sysimgblt ttm drm_kms_helper soundcore=
 drm pcspkr ata_piix libata i2c_piix4
[  729.053181] CPU: 0 PID: 1645 Comm: kworker/0:1H Not tainted 3.15.0-rc5=
-next-20140521 #1
[  729.053181] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  729.053181] task: ffff880119add880 ti: ffff880103264000 task.ti: ffff8=
80103264000
[  729.053181] RIP: 0010:[<ffffffff81425b27>]  [<ffffffff81425b27>] virti=
o_queue_rq+0x217/0x220
[  729.053181] RSP: 0018:ffff880103265d58  EFLAGS: 00010202
[  729.053181] RAX: 0000000000000081 RBX: ffff880116164900 RCX: dead00000=
0200200
[  729.053181] RDX: 0000000000007530 RSI: ffff8800a16c4800 RDI: ffff8800a=
1693400
[  729.053181] RBP: ffff880103265d98 R08: ffff8800a16c4800 R09: ffff88010=
3265dc8
[  729.053181] R10: dffd025bd0493448 R11: 0000000000001000 R12: ffff8800a=
16c4800
[  729.053181] R13: ffff880103265dc8 R14: 0000000110000001 R15: ffff8800a=
1693400
[  729.053181] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlG=
S:0000000000000000
[  729.053181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  729.053181] CR2: 000000000225a000 CR3: 000000008fc00000 CR4: 000000000=
00006f0
[  729.053181] Stack:
[  729.053181]  ffff880103265d80 ffffffff810a7295 ffff8800a16c4970 ffff88=
00a1559680
[  729.053181]  ffff8800a1693400 ffff880103265dc8 ffff8800a16c4800 ffff88=
00a14e1280
[  729.053181]  ffff880103265e00 ffffffff812e0335 ffff8800a1693408 ffff88=
00a1559680
[  729.053181] Call Trace:
[  729.053181]  [<ffffffff810a7295>] ? set_next_entity+0x95/0xb0
[  729.053181]  [<ffffffff812e0335>] __blk_mq_run_hw_queue+0x245/0x410
[  729.053181]  [<ffffffff812e0772>] blk_mq_run_work_fn+0x12/0x20
[  729.053181]  [<ffffffff810893b3>] process_one_work+0x183/0x490
[  729.053181]  [<ffffffff81089b7d>] worker_thread+0x11d/0x5c0
[  729.053181]  [<ffffffff81089a60>] ? rescuer_thread+0x3a0/0x3a0
[  729.053181]  [<ffffffff81090832>] kthread+0xd2/0xf0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180=

[  729.053181]  [<ffffffff8175e47c>] ret_from_fork+0x7c/0xb0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180=

[  729.053181] Code: 00 00 00 00 0f b7 86 f4 00 00 00 c7 86 78 01 00 00 0=
2 00 00 00 48 c7 86 80 01 00 00 00 00 00 00 89 86 7c 01 00 00 e9 6f fe ff=
 ff <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 41=20
[  729.053181] RIP  [<ffffffff81425b27>] virtio_queue_rq+0x217/0x220
[  729.053181]  RSP <ffff880103265d58>
[  729.053181] ------------[ cut here ]------------
[  729.053181] kernel BUG at arch/x86/mm/pageattr.c:216!
[  729.053181] invalid opcode: 0000 [#2] SMP=20
[  729.053181] Modules linked in: ext4 mbcache jbd2 dm_mod fuse sg sr_mod=
 cdrom ata_generic pata_acpi floppy parport_pc snd_pcm parport snd_timer =
cirrus syscopyarea sysfillrect snd sysimgblt ttm drm_kms_helper soundcore=
 drm pcspkr ata_piix libata i2c_piix4
[  729.053181] CPU: 0 PID: 1645 Comm: kworker/0:1H Not tainted 3.15.0-rc5=
-next-20140521 #1
[  729.053181] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  729.053181] task: ffff880119add880 ti: ffff880103264000 task.ti: ffff8=
80103264000
[  729.053181] RIP: 0010:[<ffffffff8105bb63>]  [<ffffffff8105bb63>] chang=
e_page_attr_set_clr+0x433/0x440
[  729.053181] RSP: 0018:ffff880103265188  EFLAGS: 00010046
[  729.053181] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 000000000=
0000010
[  729.053181] RDX: 0000000000002200 RSI: 0000000000000000 RDI: 000000008=
0000000
[  729.053181] RBP: ffff880103265218 R08: 8000000071505163 R09: 000000000=
0071505
[  729.053181] R10: ffffea0001fd3000 R11: ffffffff812ff239 R12: 000000000=
0000000
[  729.053181] R13: 0000000000000010 R14: 0000000000000004 R15: 000000000=
0000005
[  729.053181] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlG=
S:0000000000000000
[  729.053181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  729.053181] CR2: 000000000225a000 CR3: 0000000001aec000 CR4: 000000000=
00006f0
[  729.053181] Stack:
[  729.053181]  ffff8801032651c8 0000000000000000 0000000000000000 000000=
0000000200
[  729.053181]  0000000000000008 0000000000000000 0000000000000000 000000=
0000000010
[  729.053181]  0000000000000000 0000000500000001 0000000000071505 000002=
0000000000
[  729.053181] Call Trace:
[  729.053181]  [<ffffffff8105beb6>] _set_pages_array+0xe6/0x130
[  729.053181]  [<ffffffff8105bf33>] set_pages_array_wc+0x13/0x20
[  729.053181]  [<ffffffffa00c512f>] ttm_set_pages_caching+0x2f/0x70 [ttm=
]
[  729.053181]  [<ffffffffa00c5274>] ttm_alloc_new_pages.isra.6+0xb4/0x18=
0 [ttm]
[  729.053181]  [<ffffffffa00c5b63>] ttm_pool_populate+0x3c3/0x4d0 [ttm]
[  729.053181]  [<ffffffffa010b20e>] cirrus_ttm_tt_populate+0xe/0x10 [cir=
rus]
[  729.053181]  [<ffffffffa00c2681>] ttm_bo_move_memcpy+0x5d1/0x680 [ttm]=

[  729.053181]  [<ffffffff8118ba7e>] ? map_vm_area+0x2e/0x40
[  729.053181]  [<ffffffffa00be289>] ? ttm_tt_init+0x69/0xb0 [ttm]
[  729.053181]  [<ffffffffa010b1b8>] cirrus_bo_move+0x18/0x20 [cirrus]
[  729.053181]  [<ffffffffa00bfe15>] ttm_bo_handle_move_mem+0x265/0x5b0 [=
ttm]
[  729.053181]  [<ffffffffa00c0776>] ? ttm_bo_mem_space+0x116/0x340 [ttm]=

[  729.053181]  [<ffffffffa00c0e3f>] ttm_bo_validate+0x21f/0x230 [ttm]
[  729.053181]  [<ffffffffa010b9a2>] cirrus_bo_push_sysram+0x82/0xe0 [cir=
rus]
[  729.053181]  [<ffffffffa0109be5>] cirrus_crtc_do_set_base.isra.8.const=
prop.10+0x75/0x400 [cirrus]
[  729.053181]  [<ffffffffa010a3b9>] cirrus_crtc_mode_set+0x449/0x4d0 [ci=
rrus]
[  729.053181]  [<ffffffffa00da8b9>] drm_crtc_helper_set_mode+0x2b9/0x500=
 [drm_kms_helper]
[  729.053181]  [<ffffffffa00db63f>] drm_crtc_helper_set_config+0x87f/0xa=
e0 [drm_kms_helper]
[  729.053181]  [<ffffffffa007ff31>] drm_mode_set_config_internal+0x61/0x=
e0 [drm]
[  729.053181]  [<ffffffffa00ddd54>] drm_fb_helper_pan_display+0x94/0xf0 =
[drm_kms_helper]
[  729.053181]  [<ffffffff81362c29>] fb_pan_display+0xc9/0x190
[  729.053181]  [<ffffffff8135ce80>] bit_update_start+0x20/0x50
[  729.053181]  [<ffffffff8135c932>] fbcon_switch+0x3a2/0x550
[  729.053181]  [<ffffffff813d3fe9>] redraw_screen+0x189/0x240
[  729.053181]  [<ffffffff81362f9e>] ? fb_blank+0x9e/0xc0
[  729.053181]  [<ffffffff81359eda>] fbcon_blank+0x20a/0x2d0
[  729.053181]  [<ffffffff810c846c>] ? wake_up_klogd+0x3c/0x50
[  729.053181]  [<ffffffff810c8678>] ? console_unlock+0x1f8/0x440
[  729.053181]  [<ffffffff810c8c80>] ? vprintk_emit+0x3c0/0x570
[  729.053181]  [<ffffffff81078fb3>] ? __internal_add_timer+0x113/0x130
[  729.053181]  [<ffffffff81078fff>] ? internal_add_timer+0x2f/0x70
[  729.053181]  [<ffffffff8107b032>] ? mod_timer+0x142/0x1f0
[  729.053181]  [<ffffffff813d4b08>] do_unblank_screen+0xb8/0x200
[  729.053181]  [<ffffffff813d4c60>] unblank_screen+0x10/0x20
[  729.053181]  [<ffffffff8130dea9>] bust_spinlocks+0x19/0x40
[  729.053181]  [<ffffffff81017ac8>] oops_end+0x38/0x150
[  729.053181]  [<ffffffff81017eeb>] die+0x4b/0x70
[  729.053181]  [<ffffffff81013f48>] do_trap+0xa8/0x170
[  729.053181]  [<ffffffff81014a52>] do_invalid_op+0xa2/0x100
[  729.053181]  [<ffffffff81425b27>] ? virtio_queue_rq+0x217/0x220
[  729.053181]  [<ffffffff8175feee>] invalid_op+0x1e/0x30
[  729.053181]  [<ffffffff81425b27>] ? virtio_queue_rq+0x217/0x220
[  729.053181]  [<ffffffff810a7295>] ? set_next_entity+0x95/0xb0
[  729.053181]  [<ffffffff812e0335>] __blk_mq_run_hw_queue+0x245/0x410
[  729.053181]  [<ffffffff812e0772>] blk_mq_run_work_fn+0x12/0x20
[  729.053181]  [<ffffffff810893b3>] process_one_work+0x183/0x490
[  729.053181]  [<ffffffff81089b7d>] worker_thread+0x11d/0x5c0
[  729.053181]  [<ffffffff81089a60>] ? rescuer_thread+0x3a0/0x3a0
[  729.053181]  [<ffffffff81090832>] kthread+0xd2/0xf0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180=

[  729.053181]  [<ffffffff8175e47c>] ret_from_fork+0x7c/0xb0
[  729.053181]  [<ffffffff81090760>] ? kthread_create_on_node+0x180/0x180=

[  729.053181] Code: ff ff 48 8b 4d 80 e9 9f fc ff ff 0f 0b 0f 0b be ba 0=
0 00 00 48 c7 c7 c8 a8 9d 81 89 4d 80 e8 a5 15 01 00 8b 4d 80 e9 04 ff ff=
 ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89=20
[  729.053181] RIP  [<ffffffff8105bb63>] change_page_attr_set_clr+0x433/0=
x440
[  729.053181]  RSP <ffff880103265188>
[  729.053181] ---[ end trace b06dd3eed1344db5 ]---
[  729.053181] Kernel panic - not syncing: Fatal exception
[  729.053181] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation ran=
ge: 0xffffffff80000000-0xffffffff9fffffff)
[  729.053181] drm_kms_helper: panic occurred, switching back to text con=
sole
[  729.053181] Rebooting in 10 seconds..
Elapsed time: 735
numactl --preferred=3D5 --physcpubind=3D24-27 qemu-system-x86_64 -cpu kvm=
64 -enable-kvm -kernel /kernel/x86_64-rhel/18e072998c67e985aaa643ca1af3e6=
a0dc133b71/vmlinuz-3.15.0-rc5-next-20140521 -append 'user=3Dlkp job=3D/lk=
p/scheduled/vpx-6/cyclic_xfstests-ext4-4HDD-ext4-ext4-HEAD-18e072998c67e9=
85aaa643ca1af3e6a0dc133b71.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64=
-rhel/18e072998c67e985aaa643ca1af3e6a0dc133b71/vmlinuz-3.15.0-rc5-next-20=
140521 kconfig=3Dx86_64-rhel commit=3D18e072998c67e985aaa643ca1af3e6a0dc1=
33b71 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 bm_in=
itrd=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-rhel/=
18e072998c67e985aaa643ca1af3e6a0dc133b71/modules.cgz max_uptime=3D3288 RE=
SULT_ROOT=3D/result/vpx/xfstests/4HDD-ext4-ext4/x86_64-rhel/18e072998c67e=
985aaa643ca1af3e6a0dc133b71/0 ip=3D::::vpx-6::dhcp oops=3Dpanic earlyprin=
tk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cp=
u_stall_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpani=
c load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtt=
y0 vga=3Dnormal'  -initrd /fs/sdg1/initrd-vpx-6 -m 4096 -smp 4 -net nic,v=
lan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdg1/disk0-vpx-6,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdg1/disk1-vpx-6,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/sdg1/disk2-vpx-6,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/sdg1/disk3-vpx-6,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/sdg1/disk4-vpx-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdg1/disk5=
-vpx-6,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-6 -serial=
 file:/dev/shm/kboot/serial-vpx-6 -daemonize -display none -monitor null =


--------------090702090402070501040304--

--X1bOJ3K7DJ5YkBrT--
