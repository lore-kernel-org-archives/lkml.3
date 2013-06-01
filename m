Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3FAK1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:27:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:12722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3FAK05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:26:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,783,1363158000"; 
   d="log'?scan'208";a="343383391"
Date: Sat, 1 Jun 2013 18:26:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ying Xue <ying.xue@windriver.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [TIPC] BUG: unable to handle kernel NULL pointer dereference at
 00000014
Message-ID: <20130601102645.GA6556@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 0fb0040ed697d2b0fbd484042cdebbe76d29a840
Author: Ying Xue <ying.xue@windriver.com>
Date:   Mon May 6 23:57:18 2013 -0400

    tipc: convert configuration server to use new server facility
    
    As the new socket-based TIPC server infrastructure has been
    introduced, we can now convert the configuration server to use
    it.  Then we can take future steps to simplify the configuration
    server locking policy.
    
    Some minor reordering of initialization is done, due to the
    dependency on having tipc_socket_init completed.
    
    Signed-off-by: Ying Xue <ying.xue@windriver.com>
    Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

[    7.054175]  c1589e09 00000000 ffffffff 00010000 742efec0 c160b2e4 000000f5 00000000
[    7.054179]  c003ff3c c10851e1 00000000 00002000 00000000 00000000 c003ff60 c13e52f0
[    7.054187] Call Trace:
[    7.054232]  [<c1416d45>] dump_stack+0x16/0x18
[    7.054257]  [<c1085063>] kmem_cache_create_memcg+0xf0/0x257
[    7.054261]  [<c10851e1>] kmem_cache_create+0x17/0x19
[    7.054272]  [<c13e52f0>] tipc_server_start+0x41/0x1e1
[    7.054280]  [<c13da859>] tipc_cfg_init+0xd/0xf
[    7.054288]  [<c1637f6a>] tipc_init+0xb2/0xd6
[    7.054292]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
[    7.054317]  [<c1000192>] do_one_initcall+0x6b/0xf1
[    7.054322]  [<c160ca39>] kernel_init_freeable+0xec/0x171
[    7.054329]  [<c1407fdc>] kernel_init+0x8/0xaf
[    7.054333]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
[    7.054336]  [<c1407fd4>] ? rest_init+0x70/0x70
[    7.054443] BUG: unable to handle kernel NULL pointer dereference at 00000014
[    7.054447] IP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e
[    7.054449] *pde = 00000000 
[    7.054452] Oops: 0002 [#1] PREEMPT SMP 
[    7.054464] Modules linked in:
[    7.054467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00247-ged75b21 #32
[    7.054468] task: c0040000 ti: c003e000 task.ti: c003e000
[    7.054475] EIP: 0060:[<c1419748>] EFLAGS: 00010046 CPU: 0
[    7.054478] EIP is at __mutex_lock_common.isra.3+0x7d/0x32e
[    7.054480] EAX: 00000100 EBX: 00000010 ECX: c003e000 EDX: 00000000
[    7.054482] ESI: 00000246 EDI: c0040000 EBP: c003feec ESP: c003feac
[    7.054483]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    7.054485] CR0: 8005003b CR2: 00000014 CR3: 01660000 CR4: 000006d0
[    7.054494] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    7.054498] DR6: ffff0ff0 DR7: 00000400
[    7.054499] Stack:
[    7.054505]  c003feb8 c141af97 c003fec0 00000002 00000014 c003ff18 c141619c 0010000d
[    7.054510]  00000000 000da5a0 0010000e 00000246 00000246 00000010 c160b30c 00000000
[    7.054515]  c003fef4 c1419b8c c003ff00 c1419bac 00000000 c003ff24 c103f010 c003ff18
[    7.054516] Call Trace:
[    7.054520]  [<c141af97>] ? _raw_spin_unlock_irqrestore+0x28/0x34
[    7.054523]  [<c141619c>] ? __slab_free+0x126/0x2b6
[    7.054526]  [<c1419b8c>] __mutex_lock_slowpath+0xd/0xf
[    7.054529]  [<c1419bac>] mutex_lock+0x1e/0x2a
[    7.054540]  [<c103f010>] drain_workqueue+0x16/0xea
[    7.054543]  [<c103f119>] destroy_workqueue+0xe/0x155
[    7.054546]  [<c13e54f3>] tipc_server_stop+0x63/0x84
[    7.054553]  [<c1031202>] ? put_online_cpus+0x59/0x5b
[    7.054556]  [<c13da890>] tipc_cfg_stop+0xd/0x11
[    7.054559]  [<c1418843>] tipc_core_stop+0x12/0x28
[    7.054562]  [<c1637f75>] tipc_init+0xbd/0xd6
[    7.054564]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
[    7.054566]  [<c1000192>] do_one_initcall+0x6b/0xf1
[    7.054569]  [<c160ca39>] kernel_init_freeable+0xec/0x171
[    7.054572]  [<c1407fdc>] kernel_init+0x8/0xaf
[    7.054575]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
[    7.054578]  [<c1407fd4>] ? rest_init+0x70/0x70
[    7.054601] Code: 51 c1 68 55 01 00 00 68 74 be 51 c1 e8 8c 53 c1 ff 83 c4 10 e8 fe bb c2 ff 89 c6 e8 0d bc c2 ff 8d 43 04 89 45 d0 b8 00 01 00 00 <f0> 66 0f c1 43 04 88 c2 0f b6 c4 38 c2 74 07 f3 90 8a 53 04 eb
[    7.054605] EIP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e SS:ESP 0068:c003feac
[    7.054606] CR2: 0000000000000014
[    7.054611] ---[ end trace 730db1884308edf4 ]---

git bisect start ed75b2108d86fdd218fd0a89b0cc46a39ed6d724 v3.9 --
git bisect good 73287a43cc79ca06629a88d1a199cd283f42456a  #    11  2013-05-31 10:52:17  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good d7ab7302f970a254997687a1cdede421a5635c68  #    13  2013-05-31 14:30:29  Merge tag 'mfd-3.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next
git bisect good 07e074503eba3ee657ab50a8c9497ddf90039e7e  #    10  2013-05-31 14:58:02  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 3c6a279ffccd0c414ecd1d5eb4670ed70072c526  #    10  2013-05-31 19:53:12  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good eb3d33900aa953bcdfe132a71bb03ee592ebbb47  #    11  2013-05-31 20:10:55  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 1fa65447bc7b3bf4fa6d1cfe9a88dcbfe804df28  #     0  2013-05-31 20:30:31  tipc: rename tipc_createport_raw to tipc_createport
git bisect good 84b6f7456e8b88507dd85f988a9d350eb5af0e46  #    10  2013-05-31 21:23:34  bnx2x: Enable `set_phys_id' for all functions
git bisect good eeb65cedd78ebd375608d71d703e6b0b9296efbd  #    10  2013-06-01 02:19:33  be2net: cleanup be_get_drvinfo()
git bisect good 351638e7deeed2ec8ce451b53d33921b3da68f83  #    10  2013-06-01 06:22:06  net: pass info struct via netdevice notifier
git bisect good 31fec5aa21d166cf81702a669c1398784b513b8a  #    10  2013-06-01 07:25:07  vxlan: use unsigned int instead of unsigned
git bisect good 978e1115feb12672cf014697dfeffff2c4d5a2da  #    19  2013-06-01 10:56:29  tipc: Add "max_ports" configuration parameter
git bisect good 37f8edf101359fc267ce8d28b2bcc65376ccf14d  #    13  2013-06-01 11:04:26  tipc: convert topology server to use new server facility
git bisect  bad 62f71bc6f702fbd5e6f0f260b982580ea2111862  #     0  2013-06-01 11:42:24  tipc: delete code orphaned by new server infrastructure
git bisect  bad 0fb0040ed697d2b0fbd484042cdebbe76d29a840  #     0  2013-06-01 12:08:04  tipc: convert configuration server to use new server facility
git bisect good 37f8edf101359fc267ce8d28b2bcc65376ccf14d  #    30  2013-06-01 12:21:46  tipc: convert topology server to use new server facility
git bisect  bad ed75b2108d86fdd218fd0a89b0cc46a39ed6d724  #     0  2013-06-01 17:18:01  Merge remote-tracking branch 'paulg/tipc_net-next' into devel-xian-i386-2013-05-31-04-08
git bisect good 14d35d014bd806884801d32259ecdaf857ef276b  #    30  2013-06-01 17:53:32  Add linux-next specific files for 20130531

Thanks,
Fengguang

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-athens-15558-2013-05-31-08-04-41-3.10.0-rc3-00247-ged75b21-32"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.10.0-rc3-00247-ged75b21 (kbuild@xian) (gcc v=
ersion 4.7.2 (Debian 4.7.2-4) ) #32 SMP PREEMPT Fri May 31 04:57:43 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x016cf000, 0x016cffff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128736(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x016d0000, 0x016d0fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat c1606800, node_mem_map cd=
d3f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65424 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 00000000000=
94000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @cdd27000 s26368 r0 d22784 u49=
152
[    0.000000] pcpu-alloc: s26368 r0 d22784 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd29700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64912
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dlinux-devel/devel-xian-i386-2013-05-31-04-08 log_=
buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk =
sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 =
console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-q=
ueue/kvm/i386-randconfig-x28-0530/ed75b2108d86fdd218fd0a89b0cc46a39ed6d724/=
=2Evmlinuz-2013-05-31-05-01-46-devel-xian-i386-2013-05-31-04-08:ed75b2108d8=
6fdd218fd0a89b0cc46a39ed6d724-ed75b2108d86fdd218fd0a89b0cc46a39ed6d724-i386=
-randconfig-x28-0530-7-vp-retry-athens  BOOT_IMAGE=3D/kernel/i386-randconfi=
g-x28-0530/ed75b2108d86fdd218fd0a89b0cc46a39ed6d724/vmlinuz-3.10.0-rc3-0024=
7-ged75b21
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 218792k/262136k available (4209k kernel code, 42904k=
 reserved, 1979k data, 312k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc160c000 - 0xc165a000   ( 312 kB)
[    0.000000]       .data : 0xc141c7da - 0xc160b440   (1979 kB)
[    0.000000]       .text : 0xc1000000 - 0xc141c7da   (4209 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0080000 soft=3Dc0082000
[    0.000000] console [ttyS0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |failed|  ok =
 |failed|failed|
[    0.000000]                   initialize held:failed|failed|failed|faile=
d|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 142 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.97 Bogo=
MIPS (lpj=3D28929880)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020489] mce: CPU supports 10 MCE banks
[    0.022291] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022291] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022291] tlb_flushall_shift: 6
[    0.028107] Freeing SMP alternatives: 12k freed
[    0.031232] ACPI: Core revision 20130328
[    0.047866] ACPI: All ACPI Tables successfully acquired
[    0.050302] Getting VERSION: 50014
[    0.051662] Getting VERSION: 50014
[    0.053047] Getting ID: 0
[    0.054070] Getting ID: f000000
[    0.055302] Getting LVT0: 8700
[    0.056501] Getting LVT1: 8400
[    0.057686] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.060030] enabled ExtINT on CPU#0
[    0.063187] ENABLING IO-APIC IRQs
[    0.064516] init IO_APIC IRQs
[    0.065771]  apic 2 pin 0 not connected
[    0.067326] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.070049] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.073217] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.076293] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.079382] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.080043] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.083122] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.086147] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.090046] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.093038] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.096136] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.100043] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.103005] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.106002] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.110046] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.113270]  apic 2 pin 16 not connected
[    0.114826]  apic 2 pin 17 not connected
[    0.116410]  apic 2 pin 18 not connected
[    0.117865]  apic 2 pin 19 not connected
[    0.120009]  apic 2 pin 20 not connected
[    0.121577]  apic 2 pin 21 not connected
[    0.123232]  apic 2 pin 22 not connected
[    0.124868]  apic 2 pin 23 not connected
[    0.126701] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.129281] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.133380] Using local APIC timer interrupts.
[    0.133380] calibrating APIC timer ...
[    0.140000] ... lapic delta =3D 6250157
[    0.140000] ... PM-Timer delta =3D 357969
[    0.140000] ... PM-Timer result ok
[    0.140000] ..... delta 6250157
[    0.140000] ..... mult: 268442199
[    0.140000] ..... calibration result: 10000251
[    0.140000] ..... CPU clock speed is 2893.1684 MHz.
[    0.140000] ..... host bus clock speed is 1000.0251 MHz.
[    0.140187] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.220209] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.240334] CPU 1 irqstacks, hard=3Dc0120000 soft=3Dc0122000
[    0.245631] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.303382] Brought up 2 CPUs
[    0.303339] KVM setup async PF for cpu 1
[    0.303339] kvm-stealtime: cpu 1, msr dd35700
[    0.307549] smpboot: Total of 2 processors activated (11571.95 BogoMIPS)
[    0.311457] devtmpfs: initialized
[    0.312840] device: 'platform': device_add
[    0.314614] PM: Adding info for No Bus:platform
[    0.316390] bus: 'platform': registered
[    0.317866] bus: 'cpu': registered
[    0.319200] device: 'cpu': device_add
[    0.320045] PM: Adding info for No Bus:cpu
[    0.322151] bus: 'workqueue': registered
[    0.323907] device: 'workqueue': device_add
[    0.325624] PM: Adding info for No Bus:workqueue
[    0.327457] device class 'regulator': registering
[    0.329333] Registering platform device 'reg-dummy'. Parent at platform
[    0.330013] device: 'reg-dummy': device_add
[    0.331621] bus: 'platform': add device reg-dummy
[    0.333315] PM: Adding info for platform:reg-dummy
[    0.335096] bus: 'platform': add driver reg-dummy
[    0.336843] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    0.340007] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    0.343111] device: 'regulator.0': device_add
[    0.344759] PM: Adding info for No Bus:regulator.0
[    0.346541] regulator-dummy: no parameters
[    0.350097] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    0.352769] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    0.355923] NET: Registered protocol family 16
[    0.357870] device class 'bdi': registering
[    0.359437] device class 'gpio': registering
[    0.360050] device class 'pci_bus': registering
[    0.361815] bus: 'pci': registered
[    0.362965] device class 'tty': registering
[    0.364866] ACPI: bus type PCI registered
[    0.366497] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.370007] PCI: Using configuration type 1 for base access
[    0.372262] device: 'cpu0': device_add
[    0.373707] bus: 'cpu': add device cpu0
[    0.375209] PM: Adding info for cpu:cpu0
[    0.376744] device: 'cpu1': device_add
[    0.378166] bus: 'cpu': add device cpu1
[    0.379598] PM: Adding info for cpu:cpu1
[    0.390196] device: 'writeback': device_add
[    0.391760] bus: 'workqueue': add device writeback
[    0.393487] PM: Adding info for workqueue:writeback
[    0.395420] device: 'default': device_add
[    0.400085] PM: Adding info for No Bus:default
[    0.420231] bio: create slab <bio-0> at 0
[    0.422201] device class 'block': registering
[    0.424231] ACPI: Added _OSI(Module Device)
[    0.425774] ACPI: Added _OSI(Processor Device)
[    0.430010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.431710] ACPI: Added _OSI(Processor Aggregator Device)
[    0.435187] ACPI: EC: Look up EC in DSDT
[    0.456656] ACPI: Interpreter enabled
[    0.458086] ACPI: (supports S0 S4 S5)
[    0.459444] ACPI: Using IOAPIC for interrupt routing
[    0.460111] bus: 'acpi': registered
[    0.461413] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.465025] device: 'LNXSYSTM:00': device_add
[    0.470026] bus: 'acpi': add device LNXSYSTM:00
[    0.471794] PM: Adding info for acpi:LNXSYSTM:00
[    0.474052] device: 'device:00': device_add
[    0.475608] bus: 'acpi': add device device:00
[    0.477257] PM: Adding info for acpi:device:00
[    0.480477] device: 'PNP0A03:00': device_add
[    0.481985] bus: 'acpi': add device PNP0A03:00
[    0.483800] PM: Adding info for acpi:PNP0A03:00
[    0.486722] device: 'device:01': device_add
[    0.488371] bus: 'acpi': add device device:01
[    0.490028] PM: Adding info for acpi:device:01
[    0.491933] device: 'device:02': device_add
[    0.493556] bus: 'acpi': add device device:02
[    0.495145] PM: Adding info for acpi:device:02
[    0.497027] device: 'PNP0B00:00': device_add
[    0.498511] bus: 'acpi': add device PNP0B00:00
[    0.500023] PM: Adding info for acpi:PNP0B00:00
[    0.502348] device: 'PNP0303:00': device_add
[    0.504002] bus: 'acpi': add device PNP0303:00
[    0.505708] PM: Adding info for acpi:PNP0303:00
[    0.507762] device: 'PNP0F13:00': device_add
[    0.510022] bus: 'acpi': add device PNP0F13:00
[    0.511578] PM: Adding info for acpi:PNP0F13:00
[    0.513755] device: 'PNP0700:00': device_add
[    0.515287] bus: 'acpi': add device PNP0700:00
[    0.516942] PM: Adding info for acpi:PNP0700:00
[    0.520301] device: 'PNP0400:00': device_add
[    0.521863] bus: 'acpi': add device PNP0400:00
[    0.523520] PM: Adding info for acpi:PNP0400:00
[    0.526615] device: 'PNP0501:00': device_add
[    0.528171] bus: 'acpi': add device PNP0501:00
[    0.529724] PM: Adding info for acpi:PNP0501:00
[    0.531346] device: 'device:03': device_add
[    0.533009] bus: 'acpi': add device device:03
[    0.534674] PM: Adding info for acpi:device:03
[    0.536823] device: 'device:04': device_add
[    0.538340] bus: 'acpi': add device device:04
[    0.540032] PM: Adding info for acpi:device:04
[    0.542164] device: 'device:05': device_add
[    0.543625] bus: 'acpi': add device device:05
[    0.545168] PM: Adding info for acpi:device:05
[    0.547330] device: 'device:06': device_add
[    0.550020] bus: 'acpi': add device device:06
[    0.551559] PM: Adding info for acpi:device:06
[    0.553927] device: 'device:07': device_add
[    0.555511] bus: 'acpi': add device device:07
[    0.557071] PM: Adding info for acpi:device:07
[    0.559357] device: 'device:08': device_add
[    0.560023] bus: 'acpi': add device device:08
[    0.561674] PM: Adding info for acpi:device:08
[    0.564155] device: 'device:09': device_add
[    0.565803] bus: 'acpi': add device device:09
[    0.567573] PM: Adding info for acpi:device:09
[    0.570600] device: 'device:0a': device_add
[    0.572202] bus: 'acpi': add device device:0a
[    0.573908] PM: Adding info for acpi:device:0a
[    0.576103] device: 'device:0b': device_add
[    0.577732] bus: 'acpi': add device device:0b
[    0.579360] PM: Adding info for acpi:device:0b
[    0.580608] device: 'device:0c': device_add
[    0.582225] bus: 'acpi': add device device:0c
[    0.583725] PM: Adding info for acpi:device:0c
[    0.585879] device: 'device:0d': device_add
[    0.587503] bus: 'acpi': add device device:0d
[    0.590028] PM: Adding info for acpi:device:0d
[    0.592177] device: 'device:0e': device_add
[    0.595901] bus: 'acpi': add device device:0e
[    0.597607] PM: Adding info for acpi:device:0e
[    0.600604] device: 'device:0f': device_add
[    0.602179] bus: 'acpi': add device device:0f
[    0.603905] PM: Adding info for acpi:device:0f
[    0.606301] device: 'device:10': device_add
[    0.607859] bus: 'acpi': add device device:10
[    0.609628] PM: Adding info for acpi:device:10
[    0.610573] device: 'device:11': device_add
[    0.612302] bus: 'acpi': add device device:11
[    0.614109] PM: Adding info for acpi:device:11
[    0.617245] device: 'device:12': device_add
[    0.620026] bus: 'acpi': add device device:12
[    0.621750] PM: Adding info for acpi:device:12
[    0.624098] device: 'device:13': device_add
[    0.625673] bus: 'acpi': add device device:13
[    0.630045] PM: Adding info for acpi:device:13
[    0.632498] device: 'device:14': device_add
[    0.634150] bus: 'acpi': add device device:14
[    0.635740] PM: Adding info for acpi:device:14
[    0.637947] device: 'device:15': device_add
[    0.640025] bus: 'acpi': add device device:15
[    0.641786] PM: Adding info for acpi:device:15
[    0.644147] device: 'device:16': device_add
[    0.645771] bus: 'acpi': add device device:16
[    0.647433] PM: Adding info for acpi:device:16
[    0.649619] device: 'device:17': device_add
[    0.650035] bus: 'acpi': add device device:17
[    0.651744] PM: Adding info for acpi:device:17
[    0.654117] device: 'device:18': device_add
[    0.655838] bus: 'acpi': add device device:18
[    0.660035] PM: Adding info for acpi:device:18
[    0.663487] device: 'device:19': device_add
[    0.665042] bus: 'acpi': add device device:19
[    0.666733] PM: Adding info for acpi:device:19
[    0.670554] device: 'device:1a': device_add
[    0.673293] bus: 'acpi': add device device:1a
[    0.674821] PM: Adding info for acpi:device:1a
[    0.680079] device: 'device:1b': device_add
[    0.681684] bus: 'acpi': add device device:1b
[    0.683391] PM: Adding info for acpi:device:1b
[    0.685570] device: 'device:1c': device_add
[    0.687169] bus: 'acpi': add device device:1c
[    0.688890] PM: Adding info for acpi:device:1c
[    0.690647] device: 'device:1d': device_add
[    0.692188] bus: 'acpi': add device device:1d
[    0.693775] PM: Adding info for acpi:device:1d
[    0.695995] device: 'device:1e': device_add
[    0.700021] bus: 'acpi': add device device:1e
[    0.701669] PM: Adding info for acpi:device:1e
[    0.705965] device: 'device:1f': device_add
[    0.707627] bus: 'acpi': add device device:1f
[    0.709341] PM: Adding info for acpi:device:1f
[    0.710532] device: 'device:20': device_add
[    0.712261] bus: 'acpi': add device device:20
[    0.714049] PM: Adding info for acpi:device:20
[    0.720060] device: 'device:21': device_add
[    0.721802] bus: 'acpi': add device device:21
[    0.723591] PM: Adding info for acpi:device:21
[    0.725742] device: 'device:22': device_add
[    0.727253] bus: 'acpi': add device device:22
[    0.728976] PM: Adding info for acpi:device:22
[    0.732175] device: 'PNP0103:00': device_add
[    0.740042] bus: 'acpi': add device PNP0103:00
[    0.741777] PM: Adding info for acpi:PNP0103:00
[    0.744820] device: 'PNP0C0F:00': device_add
[    0.746483] bus: 'acpi': add device PNP0C0F:00
[    0.748205] PM: Adding info for acpi:PNP0C0F:00
[    0.753318] device: 'PNP0C0F:01': device_add
[    0.755039] bus: 'acpi': add device PNP0C0F:01
[    0.756847] PM: Adding info for acpi:PNP0C0F:01
[    0.760613] device: 'PNP0C0F:02': device_add
[    0.762374] bus: 'acpi': add device PNP0C0F:02
[    0.764166] PM: Adding info for acpi:PNP0C0F:02
[    0.770097] device: 'PNP0C0F:03': device_add
[    0.771657] bus: 'acpi': add device PNP0C0F:03
[    0.773423] PM: Adding info for acpi:PNP0C0F:03
[    0.776332] device: 'PNP0C0F:04': device_add
[    0.780029] bus: 'acpi': add device PNP0C0F:04
[    0.781681] PM: Adding info for acpi:PNP0C0F:04
[    0.783972] device: 'LNXCPU:00': device_add
[    0.785540] bus: 'acpi': add device LNXCPU:00
[    0.790037] PM: Adding info for acpi:LNXCPU:00
[    0.792088] device: 'LNXCPU:01': device_add
[    0.793756] bus: 'acpi': add device LNXCPU:01
[    0.795422] PM: Adding info for acpi:LNXCPU:01
[    0.799403] device: 'device:23': device_add
[    0.800031] bus: 'acpi': add device device:23
[    0.801636] PM: Adding info for acpi:device:23
[    0.803587] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.810038] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.814407] device: 'pci0000:00': device_add
[    0.816065] PM: Adding info for No Bus:pci0000:00
[    0.817848] device: '0000:00': device_add
[    0.819468] PM: Adding info for No Bus:0000:00
[    0.820040] PCI host bridge to bus 0000:00
[    0.822677] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.824776] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.830021] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.832581] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.835315] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.838196] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.840600] device: '0000:00:00.0': device_add
[    0.844901] bus: 'pci': add device 0000:00:00.0
[    0.846669] PM: Adding info for pci:0000:00:00.0
[    0.850150] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.853460] device: '0000:00:01.0': device_add
[    0.855316] bus: 'pci': add device 0000:00:01.0
[    0.859233] PM: Adding info for pci:0000:00:01.0
[    0.860150] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.865469] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.871008] device: '0000:00:01.1': device_add
[    0.873010] bus: 'pci': add device 0000:00:01.1
[    0.874725] PM: Adding info for pci:0000:00:01.1
[    0.876467] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.880769] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.884416] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.887000] device: '0000:00:01.3': device_add
[    0.890104] bus: 'pci': add device 0000:00:01.3
[    0.891777] PM: Adding info for pci:0000:00:01.3
[    0.893740] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.898245] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.901559] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.916475] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.919262] device: '0000:00:02.0': device_add
[    0.920300] bus: 'pci': add device 0000:00:02.0
[    0.922319] PM: Adding info for pci:0000:00:02.0
[    0.924325] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.931164] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.934327] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.942757] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.945632] device: '0000:00:03.0': device_add
[    0.947425] bus: 'pci': add device 0000:00:03.0
[    0.950104] PM: Adding info for pci:0000:00:03.0
[    0.953208] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.956709] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.961115] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.968357] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.970131] device: '0000:00:04.0': device_add
[    0.974135] bus: 'pci': add device 0000:00:04.0
[    0.975841] PM: Adding info for pci:0000:00:04.0
[    0.980140] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.983753] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.986985] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.995553] device: '0000:00:05.0': device_add
[    0.997456] bus: 'pci': add device 0000:00:05.0
[    1.000080] PM: Adding info for pci:0000:00:05.0
[    1.001959] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.005522] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.008610] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    1.015538] device: '0000:00:06.0': device_add
[    1.017332] bus: 'pci': add device 0000:00:06.0
[    1.020096] PM: Adding info for pci:0000:00:06.0
[    1.021908] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.025282] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.028279] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    1.035610] device: '0000:00:07.0': device_add
[    1.037651] bus: 'pci': add device 0000:00:07.0
[    1.040098] PM: Adding info for pci:0000:00:07.0
[    1.042614] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.049069] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.051060] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    1.060041] device: '0000:00:08.0': device_add
[    1.061959] bus: 'pci': add device 0000:00:08.0
[    1.063768] PM: Adding info for pci:0000:00:08.0
[    1.065566] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.068814] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.071100] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    1.080145] device: '0000:00:09.0': device_add
[    1.082158] bus: 'pci': add device 0000:00:09.0
[    1.084008] PM: Adding info for pci:0000:00:09.0
[    1.085838] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.089137] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.091085] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    1.102368] device: '0000:00:0a.0': device_add
[    1.104430] bus: 'pci': add device 0000:00:0a.0
[    1.106059] PM: Adding info for pci:0000:00:0a.0
[    1.107782] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.110651] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    1.116231] device: '0000:00:0b.0': device_add
[    1.118226] bus: 'pci': add device 0000:00:0b.0
[    1.120075] PM: Adding info for pci:0000:00:0b.0
[    1.124182] pci_bus 0000:00: on NUMA node 0
[    1.125654] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    1.131771] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.135021] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.138160] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.144501] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.147505] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.152003] device: 'LNXPWRBN:00': device_add
[    1.153638] bus: 'acpi': add device LNXPWRBN:00
[    1.155188] PM: Adding info for acpi:LNXPWRBN:00
[    1.157368] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.159174] acpi root: \_SB_.PCI0 notify handler is installed
[    1.160060] Found 1 acpi root devices
[    1.161421] bus: 'acpi': add driver ec
[    1.163181] bus: 'pnp': registered
[    1.164331] bus: 'platform': add driver gpio-regulator
[    1.166094] device class 'misc': registering
[    1.167498] device: 'vga_arbiter': device_add
[    1.170372] PM: Adding info for No Bus:vga_arbiter
[    1.171976] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.174555] vgaarb: loaded
[    1.175480] vgaarb: bridge control possible 0000:00:02.0
[    1.180092] device class 'mdio_bus': registering
[    1.181763] bus: 'mdio_bus': registered
[    1.183225] bus: 'mdio_bus': add driver Generic PHY
[    1.184998] ACPI: bus type USB registered
[    1.186550] bus: 'usb': registered
[    1.187685] bus: 'usb': add driver usbfs
[    1.189163] usbcore: registered new interface driver usbfs
[    1.190029] bus: 'usb': add driver hub
[    1.191351] usbcore: registered new interface driver hub
[    1.204022] bus: 'usb': add driver usb
[    1.205403] usbcore: registered new device driver usb
[    1.210101] bus: 'serio': registered
[    1.211358] device class 'input': registering
[    1.212994] device class 'dvb': registering
[    1.214488] device class 'pps': registering
[    1.216112] pps_core: LinuxPPS API ver. 1 registered
[    1.217824] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.220026] device class 'ptp': registering
[    1.221517] PTP clock support registered
[    1.222958] device class 'power_supply': registering
[    1.224986] bus: 'mmc': registered
[    1.226174] device class 'mmc_host': registering
[    1.227940] bus: 'sdio': registered
[    1.230019] device class 'leds': registering
[    1.231593] PCI: Using ACPI for IRQ routing
[    1.233056] PCI: pci_cache_line_size set to 64 bytes
[    1.235265] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.237350] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.240047] device class 'net': registering
[    1.241689] device: 'lo': device_add
[    1.243235] PM: Adding info for No Bus:lo
[    1.244924] irda_init()
[    1.245902] NET: Registered protocol family 23
[    1.250066] device class 'ieee80211': registering
[    1.251922] Registering platform device 'regulatory.0'. Parent at platfo=
rm
[    1.254228] device: 'regulatory.0': device_add
[    1.255753] bus: 'platform': add device regulatory.0
[    1.257431] PM: Adding info for platform:regulatory.0
[    1.262711] cfg80211: Calling CRDA to update world regulatory domain
[    1.264955] nfc: nfc_init: NFC Core ver 0.1
[    1.266364] device class 'nfc': registering
[    1.267855] NET: Registered protocol family 39
[    1.270274] Switching to clocksource kvm-clock
[    1.272087] bus: 'pnp': add driver system
[    1.273549] pnp: PnP ACPI init
[    1.274640] device: 'pnp0': device_add
[    1.275954] PM: Adding info for No Bus:pnp0
[    1.277471] ACPI: bus type PNP registered
[    1.279157] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.280247] device: '00:00': device_add
[    1.281812] bus: 'pnp': add device 00:00
[    1.283364] PM: Adding info for pnp:00:00
[    1.284927] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.287710] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.290846] device: '00:01': device_add
[    1.292432] bus: 'pnp': add device 00:01
[    1.293870] PM: Adding info for pnp:00:01
[    1.295203] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.297811] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.300674] device: '00:02': device_add
[    1.301988] bus: 'pnp': add device 00:02
[    1.303459] PM: Adding info for pnp:00:02
[    1.305054] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.307716] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.310803] pnp 00:03: [dma 2]
[    1.312093] device: '00:03': device_add
[    1.313204] bus: 'pnp': add device 00:03
[    1.314735] PM: Adding info for pnp:00:03
[    1.316199] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.319107] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.322155] device: '00:04': device_add
[    1.323579] bus: 'pnp': add device 00:04
[    1.325012] PM: Adding info for pnp:00:04
[    1.326567] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.329442] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.332435] device: '00:05': device_add
[    1.333894] bus: 'pnp': add device 00:05
[    1.335163] PM: Adding info for pnp:00:05
[    1.336518] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.340040] device: '00:06': device_add
[    1.341523] bus: 'pnp': add device 00:06
[    1.342967] PM: Adding info for pnp:00:06
[    1.344591] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.348449] pnp: PnP ACPI: found 7 devices
[    1.349857] ACPI: bus type PNP unregistered
[    1.351429] PnPBIOS: Disabled
[    1.352515] device class 'mem': registering
[    1.354003] device: 'mem': device_add
[    1.355566] PM: Adding info for No Bus:mem
[    1.356896] device: 'kmem': device_add
[    1.358277] PM: Adding info for No Bus:kmem
[    1.359813] device: 'null': device_add
[    1.361172] PM: Adding info for No Bus:null
[    1.362637] device: 'port': device_add
[    1.364015] PM: Adding info for No Bus:port
[    1.365516] device: 'zero': device_add
[    1.366891] PM: Adding info for No Bus:zero
[    1.368375] device: 'full': device_add
[    1.369702] PM: Adding info for No Bus:full
[    1.371037] device: 'random': device_add
[    1.372544] PM: Adding info for No Bus:random
[    1.373902] device: 'urandom': device_add
[    1.375398] PM: Adding info for No Bus:urandom
[    1.377030] device: 'kmsg': device_add
[    1.378646] PM: Adding info for No Bus:kmsg
[    1.380180] device: 'oldmem': device_add
[    1.381956] PM: Adding info for No Bus:oldmem
[    1.383719] device: 'tty': device_add
[    1.385312] PM: Adding info for No Bus:tty
[    1.386909] device: 'console': device_add
[    1.388520] PM: Adding info for No Bus:console
[    1.390054] device class 'thermal': registering
[    1.428298] PM-Timer running at invalid rate: 105% of normal - aborting.
[    1.430633] bus: 'ssb': registered
[    1.432025] bus: 'pci': add driver b43-pci-bridge
[    1.433784] bus: 'bcma': registered
[    1.435199] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.437190] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.439213] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.441655] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.444132] NET: Registered protocol family 2
[    1.448767] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.451170] TCP bind hash table entries: 2048 (order: 3, 40960 bytes)
[    1.453406] TCP: Hash tables configured (established 2048 bind 2048)
[    1.455501] TCP: reno registered
[    1.456515] UDP hash table entries: 256 (order: 1, 12288 bytes)
[    1.458408] UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
[    1.461116] NET: Registered protocol family 1
[    1.464183] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.466390] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.468561] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.470886] pci 0000:00:02.0: Boot video device
[    1.472840] PCI: CLS 0 bytes, default 64
[    1.474754] Unpacking initramfs...
[    4.367092] Freeing initrd memory: 25284k freed
[    4.548630] DMA-API: preallocated 65536 debug entries
[    4.550399] DMA-API: debugging enabled by kernel config
[    4.552783] Machine check injector initialized
[    4.554058] device class 'cpuid': registering
[    4.558335] device: 'cpu0': device_add
[    4.561368] PM: Adding info for No Bus:cpu0
[    4.562672] device: 'cpu1': device_add
[    4.564021] PM: Adding info for No Bus:cpu1
[    4.565206] apm: BIOS not found.
[    4.566111] Registering platform device 'pcspkr'. Parent at platform
[    4.570208] device: 'pcspkr': device_add
[    4.573575] bus: 'platform': add device pcspkr
[    4.574856] PM: Adding info for platform:pcspkr
[    4.583520] cryptomgr_test (33) used greatest stack depth: 7400 bytes le=
ft
[    4.593375] cryptomgr_test (37) used greatest stack depth: 7396 bytes le=
ft
[    4.602286] modprobe (42) used greatest stack depth: 6972 bytes left
[    4.624782] cryptomgr_test (39) used greatest stack depth: 6424 bytes le=
ft
[    4.634464] Registering platform device 'goldfish_pdev_bus'. Parent at p=
latform
[    4.637035] device: 'goldfish_pdev_bus': device_add
[    4.638808] bus: 'platform': add device goldfish_pdev_bus
[    4.640696] PM: Adding info for platform:goldfish_pdev_bus
[    4.644940] device: 'snapshot': device_add
[    4.646701] PM: Adding info for No Bus:snapshot
[    4.648544] bus: 'clocksource': registered
[    4.650028] device: 'clocksource': device_add
[    4.657763] PM: Adding info for No Bus:clocksource
[    4.659492] device: 'clocksource0': device_add
[    4.661065] bus: 'clocksource': add device clocksource0
[    4.668983] PM: Adding info for clocksource:clocksource0
[    4.670629] bus: 'platform': add driver alarmtimer
[    4.672354] Registering platform device 'alarmtimer'. Parent at platform
[    4.674567] device: 'alarmtimer': device_add
[    4.678854] bus: 'platform': add device alarmtimer
[    4.680368] PM: Adding info for platform:alarmtimer
[    4.682225] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    4.688326] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    4.690834] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    4.693247] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    4.698964] bus: 'rttest': registered
[    4.700224] device: 'rttest': device_add
[    4.701526] PM: Adding info for No Bus:rttest
[    4.705322] device: 'rttest0': device_add
[    4.706539] bus: 'rttest': add device rttest0
[    4.707991] PM: Adding info for rttest:rttest0
[    4.709582] device: 'rttest1': device_add
[    4.710931] bus: 'rttest': add device rttest1
[    4.715372] PM: Adding info for rttest:rttest1
[    4.716900] device: 'rttest2': device_add
[    4.718333] bus: 'rttest': add device rttest2
[    4.719796] PM: Adding info for rttest:rttest2
[    4.728327] device: 'rttest3': device_add
[    4.729604] bus: 'rttest': add device rttest3
[    4.730888] PM: Adding info for rttest:rttest3
[    4.738328] device: 'rttest4': device_add
[    4.739721] bus: 'rttest': add device rttest4
[    4.741109] PM: Adding info for rttest:rttest4
[    4.746323] device: 'rttest5': device_add
[    4.747571] bus: 'rttest': add device rttest5
[    4.749045] PM: Adding info for rttest:rttest5
[    4.754320] device: 'rttest6': device_add
[    4.755574] bus: 'rttest': add device rttest6
[    4.757092] PM: Adding info for rttest:rttest6
[    4.758843] device: 'rttest7': device_add
[    4.760346] bus: 'rttest': add device rttest7
[    4.764706] PM: Adding info for rttest:rttest7
[    4.766057] Initializing RT-Tester: OK
[    4.767259] Initialise module verification
[    4.768808] bus: 'event_source': registered
[    4.770177] device: 'breakpoint': device_add
[    4.772631] bus: 'event_source': add device breakpoint
[    4.774152] PM: Adding info for event_source:breakpoint
[    4.778819] device: 'software': device_add
[    4.780116] bus: 'event_source': add device software
[    4.781696] PM: Adding info for event_source:software
[    4.804563] VFS: Disk quotas dquot_6.5.2
[    4.805968] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.808181] device class 'coda': registering
[    4.812690] device: 'cfs0': device_add
[    4.813950] PM: Adding info for No Bus:cfs0
[    4.815248] device: 'cfs1': device_add
[    4.816702] PM: Adding info for No Bus:cfs1
[    4.818378] device: 'cfs2': device_add
[    4.819607] PM: Adding info for No Bus:cfs2
[    4.820924] device: 'cfs3': device_add
[    4.825309] PM: Adding info for No Bus:cfs3
[    4.826920] device: 'cfs4': device_add
[    4.831552] PM: Adding info for No Bus:cfs4
[    4.838035] QNX6 filesystem 1.0.0 registered.
[    4.839421] 9p: Installing v9fs 9p2000 file system support
[    4.841223] BeFS version: 0.9.3
[    4.842986] ceph: loaded (mds proto 32)
[    4.844409] msgmni has been set to 476
[    4.887935] alg: No test for stdrng (krng)
[    4.899482] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.907997] NET: Registered protocol family 38
[    4.909746] Key type asymmetric registered
[    4.911073] Asymmetric key parser 'x509' registered
[    4.915753] device class 'bsg': registering
[    4.917055] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    4.919338] io scheduler noop registered (default)
[    4.943432] list_sort_test: start testing list_sort()
[    4.950064] xz_dec_test: module loaded
[    4.953460] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    4.956416] bus: 'platform': add driver arizona-gpio
[    4.960177] bus: 'platform': add driver ts5500-dio
[    4.981464] bus: 'platform': add driver ipmi
[    4.982927] ipmi message handler version 39.2
[    4.984321] IPMI Watchdog: driver initialized
[    4.991957] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    4.994671] bus: 'acpi': add driver ac
[    4.996123] bus: 'acpi': add driver button
[    4.997580] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[    5.000553] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[    5.023509] device: 'input0': device_add
[    5.025003] PM: Adding info for No Bus:input0
[    5.026778] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.029380] ACPI: Power Button [PWRF]
[    5.030772] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    5.040290] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[    5.042861] bus: 'acpi': add driver fan
[    5.044268] bus: 'cpu': add driver processor
[    5.045827] bus: 'cpu': driver_probe_device: matched device cpu0 with dr=
iver processor
[    5.048566] bus: 'cpu': really_probe: probing driver processor with devi=
ce cpu0
[    5.055365] device: 'cooling_device0': device_add
[    5.056872] PM: Adding info for No Bus:cooling_device0
[    5.058531] driver: 'cpu0': driver_bound: bound to device 'processor'
[    5.060377] bus: 'cpu': really_probe: bound device cpu0 to driver proces=
sor
[    5.090331] bus: 'cpu': driver_probe_device: matched device cpu1 with dr=
iver processor
[    5.092836] bus: 'cpu': really_probe: probing driver processor with devi=
ce cpu1
[    5.095048] device: 'cooling_device1': device_add
[    5.098617] PM: Adding info for No Bus:cooling_device1
[    5.100178] driver: 'cpu1': driver_bound: bound to device 'processor'
[    5.106262] bus: 'cpu': really_probe: bound device cpu1 to driver proces=
sor
[    5.108442] bus: 'acpi': add driver thermal
[    5.133518] bus: 'acpi': add driver battery
[    5.134968] bus: 'platform': add driver reg-userspace-consumer
[    5.136847] HDLC line discipline maxframe=3D4096
[    5.138215] N_HDLC line discipline registered.
[    5.144730] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.146627] bus: 'pnp': add driver serial
[    5.152042] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river serial
[    5.154322] bus: 'pnp': really_probe: probing driver serial with device =
00:05
[    5.204994] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.206762] device: 'ttyS0': device_add
[    5.208071] PM: Adding info for No Bus:ttyS0
[    5.209495] driver: '00:05': driver_bound: bound to device 'serial'
[    5.214323] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[    5.216379] Registering platform device 'serial8250'. Parent at platform
[    5.218407] device: 'serial8250': device_add
[    5.219760] bus: 'platform': add device serial8250
[    5.227446] PM: Adding info for platform:serial8250
[    5.229175] device: 'ttyS1': device_add
[    5.230558] PM: Adding info for No Bus:ttyS1
[    5.232202] device: 'ttyS2': device_add
[    5.233661] PM: Adding info for No Bus:ttyS2
[    5.235149] device: 'ttyS3': device_add
[    5.240632] PM: Adding info for No Bus:ttyS3
[    5.242203] bus: 'platform': add driver serial8250
[    5.243685] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    5.250593] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    5.255184] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    5.257222] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    5.264040] bus: 'pci': add driver serial
[    5.271542] Registering platform device 'serial8250.3'. Parent at platfo=
rm
[    5.273482] device: 'serial8250.3': device_add
[    5.274741] bus: 'platform': add device serial8250.3
[    5.280331] PM: Adding info for platform:serial8250.3
[    5.283934] bus: 'platform': driver_probe_device: matched device serial8=
250.3 with driver serial8250
[    5.286665] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250.3
[    5.295362] device: 'ttyS1': device_unregister
[    5.296928] PM: Removing info for No Bus:ttyS1
[    5.310473] device: 'ttyS1': device_add
[    5.311953] PM: Adding info for No Bus:ttyS1
[    5.313561] device: 'ttyS1': device_unregister
[    5.315161] PM: Removing info for No Bus:ttyS1
[    5.320718] device: 'ttyS1': device_add
[    5.329446] PM: Adding info for No Bus:ttyS1
[    5.330873] device: 'ttyS1': device_unregister
[    5.332485] PM: Removing info for No Bus:ttyS1
[    5.334117] device: 'ttyS1': device_add
[    5.337503] PM: Adding info for No Bus:ttyS1
[    5.338819] device: 'ttyS1': device_unregister
[    5.340201] PM: Removing info for No Bus:ttyS1
[    5.344751] device: 'ttyS1': device_add
[    5.346074] PM: Adding info for No Bus:ttyS1
[    5.347486] device: 'ttyS1': device_unregister
[    5.355230] PM: Removing info for No Bus:ttyS1
[    5.357176] device: 'ttyS1': device_add
[    5.360543] PM: Adding info for No Bus:ttyS1
[    5.365023] device: 'ttyS1': device_unregister
[    5.366439] PM: Removing info for No Bus:ttyS1
[    5.367878] device: 'ttyS1': device_add
[    5.374358] PM: Adding info for No Bus:ttyS1
[    5.375766] device: 'ttyS1': device_unregister
[    5.377265] PM: Removing info for No Bus:ttyS1
[    5.380779] device: 'ttyS1': device_add
[    5.389380] PM: Adding info for No Bus:ttyS1
[    5.390808] device: 'ttyS1': device_unregister
[    5.392537] PM: Removing info for No Bus:ttyS1
[    5.394336] device: 'ttyS1': device_add
[    5.395830] PM: Adding info for No Bus:ttyS1
[    5.399270] driver: 'serial8250.3': driver_bound: bound to device 'seria=
l8250'
[    5.404520] bus: 'platform': really_probe: bound device serial8250.3 to =
driver serial8250
[    5.406904] Registering platform device 'serial8250.5'. Parent at platfo=
rm
[    5.415070] device: 'serial8250.5': device_add
[    5.416439] bus: 'platform': add device serial8250.5
[    5.417961] PM: Adding info for platform:serial8250.5
[    5.424746] bus: 'platform': driver_probe_device: matched device serial8=
250.5 with driver serial8250
[    5.427738] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250.5
[    5.435442] device: 'ttyS1': device_unregister
[    5.436912] PM: Removing info for No Bus:ttyS1
[    5.440402] device: 'ttyS1': device_add
[    5.444968] PM: Adding info for No Bus:ttyS1
[    5.446684] device: 'ttyS1': device_unregister
[    5.448255] PM: Removing info for No Bus:ttyS1
[    5.451955] device: 'ttyS1': device_add
[    5.453608] PM: Adding info for No Bus:ttyS1
[    5.455170] device: 'ttyS1': device_unregister
[    5.460723] PM: Removing info for No Bus:ttyS1
[    5.465577] device: 'ttyS1': device_add
[    5.467107] PM: Adding info for No Bus:ttyS1
[    5.471704] device: 'ttyS1': device_unregister
[    5.473439] PM: Removing info for No Bus:ttyS1
[    5.475019] device: 'ttyS1': device_add
[    5.480335] PM: Adding info for No Bus:ttyS1
[    5.484759] device: 'ttyS1': device_unregister
[    5.486225] PM: Removing info for No Bus:ttyS1
[    5.487656] device: 'ttyS1': device_add
[    5.492107] PM: Adding info for No Bus:ttyS1
[    5.493672] device: 'ttyS1': device_unregister
[    5.499531] PM: Removing info for No Bus:ttyS1
[    5.500989] device: 'ttyS1': device_add
[    5.505420] PM: Adding info for No Bus:ttyS1
[    5.506896] device: 'ttyS1': device_unregister
[    5.511522] PM: Removing info for No Bus:ttyS1
[    5.513416] device: 'ttyS1': device_add
[    5.514936] PM: Adding info for No Bus:ttyS1
[    5.519368] device: 'ttyS1': device_unregister
[    5.520910] PM: Removing info for No Bus:ttyS1
[    5.528554] device: 'ttyS1': device_add
[    5.529813] PM: Adding info for No Bus:ttyS1
[    5.531083] device: 'ttyS1': device_unregister
[    5.535631] PM: Removing info for No Bus:ttyS1
[    5.537150] device: 'ttyS1': device_add
[    5.541686] PM: Adding info for No Bus:ttyS1
[    5.543260] device: 'ttyS1': device_unregister
[    5.544977] PM: Removing info for No Bus:ttyS1
[    5.549654] device: 'ttyS1': device_add
[    5.550961] PM: Adding info for No Bus:ttyS1
[    5.558531] device: 'ttyS1': device_unregister
[    5.560165] PM: Removing info for No Bus:ttyS1
[    5.564960] device: 'ttyS1': device_add
[    5.566401] PM: Adding info for No Bus:ttyS1
[    5.567787] device: 'ttyS1': device_unregister
[    5.569492] PM: Removing info for No Bus:ttyS1
[    5.571122] device: 'ttyS1': device_add
[    5.578722] PM: Adding info for No Bus:ttyS1
[    5.580188] device: 'ttyS1': device_unregister
[    5.584839] PM: Removing info for No Bus:ttyS1
[    5.586320] device: 'ttyS1': device_add
[    5.587628] PM: Adding info for No Bus:ttyS1
[    5.592249] device: 'ttyS1': device_unregister
[    5.593828] PM: Removing info for No Bus:ttyS1
[    5.598692] device: 'ttyS1': device_add
[    5.600249] PM: Adding info for No Bus:ttyS1
[    5.601862] device: 'ttyS1': device_unregister
[    5.603239] PM: Removing info for No Bus:ttyS1
[    5.604603] device: 'ttyS1': device_add
[    5.608924] PM: Adding info for No Bus:ttyS1
[    5.610319] device: 'ttyS1': device_unregister
[    5.614928] PM: Removing info for No Bus:ttyS1
[    5.616724] device: 'ttyS1': device_add
[    5.618055] PM: Adding info for No Bus:ttyS1
[    5.622633] driver: 'serial8250.5': driver_bound: bound to device 'seria=
l8250'
[    5.625184] bus: 'platform': really_probe: bound device serial8250.5 to =
driver serial8250
[    5.630739] Registering platform device 'serial8250.7'. Parent at platfo=
rm
[    5.635912] device: 'serial8250.7': device_add
[    5.637331] bus: 'platform': add device serial8250.7
[    5.639106] PM: Adding info for platform:serial8250.7
[    5.641147] bus: 'platform': driver_probe_device: matched device serial8=
250.7 with driver serial8250
[    5.650180] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250.7
[    5.653123] device: 'ttyS1': device_unregister
[    5.654918] PM: Removing info for No Bus:ttyS1
[    5.659453] device: 'ttyS1': device_add
[    5.660729] PM: Adding info for No Bus:ttyS1
[    5.665254] device: 'ttyS1': device_unregister
[    5.666913] PM: Removing info for No Bus:ttyS1
[    5.671706] device: 'ttyS1': device_add
[    5.673366] PM: Adding info for No Bus:ttyS1
[    5.675005] device: 'ttyS1': device_unregister
[    5.679565] PM: Removing info for No Bus:ttyS1
[    5.681035] device: 'ttyS1': device_add
[    5.685459] PM: Adding info for No Bus:ttyS1
[    5.686763] device: 'ttyS1': device_unregister
[    5.688168] PM: Removing info for No Bus:ttyS1
[    5.693069] device: 'ttyS1': device_add
[    5.694616] PM: Adding info for No Bus:ttyS1
[    5.699148] device: 'ttyS1': device_unregister
[    5.700612] PM: Removing info for No Bus:ttyS1
[    5.705228] device: 'ttyS1': device_add
[    5.706626] PM: Adding info for No Bus:ttyS1
[    5.708021] device: 'ttyS1': device_unregister
[    5.712850] PM: Removing info for No Bus:ttyS1
[    5.714570] device: 'ttyS1': device_add
[    5.718925] PM: Adding info for No Bus:ttyS1
[    5.720264] device: 'ttyS1': device_unregister
[    5.724883] PM: Removing info for No Bus:ttyS1
[    5.726585] device: 'ttyS1': device_add
[    5.728147] PM: Adding info for No Bus:ttyS1
[    5.732749] device: 'ttyS1': device_unregister
[    5.734441] PM: Removing info for No Bus:ttyS1
[    5.738993] device: 'ttyS1': device_add
[    5.740319] PM: Adding info for No Bus:ttyS1
[    5.744823] device: 'ttyS1': device_unregister
[    5.746545] PM: Removing info for No Bus:ttyS1
[    5.748071] device: 'ttyS1': device_add
[    5.752720] PM: Adding info for No Bus:ttyS1
[    5.754375] device: 'ttyS1': device_unregister
[    5.760919] PM: Removing info for No Bus:ttyS1
[    5.762773] device: 'ttyS1': device_add
[    5.764160] PM: Adding info for No Bus:ttyS1
[    5.771682] device: 'ttyS1': device_unregister
[    5.773396] PM: Removing info for No Bus:ttyS1
[    5.775107] device: 'ttyS1': device_add
[    5.780644] PM: Adding info for No Bus:ttyS1
[    5.786169] device: 'ttyS1': device_unregister
[    5.787645] PM: Removing info for No Bus:ttyS1
[    5.789186] device: 'ttyS1': device_add
[    5.797604] PM: Adding info for No Bus:ttyS1
[    5.799082] driver: 'serial8250.7': driver_bound: bound to device 'seria=
l8250'
[    5.804569] bus: 'platform': really_probe: bound device serial8250.7 to =
driver serial8250
[    5.806982] bus: 'platform': add driver uart-sccnxp
[    5.814652] bus: 'platform': add driver altera_uart
[    5.816465] bus: 'platform': add driver timb-uart
[    5.822379] bus: 'platform': add driver arc-uart
[    5.823958] device: 'ttyprintk': device_add
[    5.831445] PM: Adding info for No Bus:ttyprintk
[    5.833357] DoubleTalk PC - not found
[    5.834768] toshiba: not a supported Toshiba laptop
[    5.861391] Registering platform device 'pc8736x_gpio.0'. Parent at plat=
form
[    5.864030] device: 'pc8736x_gpio.0': device_add
[    5.865813] bus: 'platform': add device pc8736x_gpio.0
[    5.867859] PM: Adding info for platform:pc8736x_gpio.0
[    5.878969] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.888663] platform pc8736x_gpio.0: no device found
[    5.890503] bus: 'platform': remove device pc8736x_gpio.0
[    5.895440] PM: Removing info for platform:pc8736x_gpio.0
[    5.897421] nsc_gpio initializing
[    5.901723] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.903768] bus: 'isa': registered
[    5.904999] device: 'isa': device_add
[    5.906309] PM: Adding info for No Bus:isa
[    5.908017] device class 'pktcdvd': registering
[    5.919979] device: 'pktcdvd': device_add
[    5.928842] PM: Adding info for No Bus:pktcdvd
[    5.951520] nbd: registered device at major 43
[    5.953250] device: '43:0': device_add
[    5.954758] PM: Adding info for No Bus:43:0
[    5.956540] device: 'nbd0': device_add
[    5.958253] PM: Adding info for No Bus:nbd0
[    5.960069] device: '43:1': device_add
[    5.977681] PM: Adding info for No Bus:43:1
[    5.979384] device: 'nbd1': device_add
[    5.980828] PM: Adding info for No Bus:nbd1
[    5.990732] device: '43:2': device_add
[    5.992248] PM: Adding info for No Bus:43:2
[    5.993986] device: 'nbd2': device_add
[    5.995658] PM: Adding info for No Bus:nbd2
[    5.997492] device: '43:3': device_add
[    5.998971] PM: Adding info for No Bus:43:3
[    6.015810] device: 'nbd3': device_add
[    6.017482] PM: Adding info for No Bus:nbd3
[    6.019319] device: '43:4': device_add
[    6.020805] PM: Adding info for No Bus:43:4
[    6.032688] device: 'nbd4': device_add
[    6.034279] PM: Adding info for No Bus:nbd4
[    6.036135] device: '43:5': device_add
[    6.037667] PM: Adding info for No Bus:43:5
[    6.039447] device: 'nbd5': device_add
[    6.041041] PM: Adding info for No Bus:nbd5
[    6.053024] device: '43:6': device_add
[    6.054516] PM: Adding info for No Bus:43:6
[    6.056215] device: 'nbd6': device_add
[    6.057852] PM: Adding info for No Bus:nbd6
[    6.059641] device: '43:7': device_add
[    6.061090] PM: Adding info for No Bus:43:7
[    6.072945] device: 'nbd7': device_add
[    6.074606] PM: Adding info for No Bus:nbd7
[    6.076396] device: '43:8': device_add
[    6.077760] PM: Adding info for No Bus:43:8
[    6.079397] device: 'nbd8': device_add
[    6.080910] PM: Adding info for No Bus:nbd8
[    6.095976] device: '43:9': device_add
[    6.097505] PM: Adding info for No Bus:43:9
[    6.099254] device: 'nbd9': device_add
[    6.100812] PM: Adding info for No Bus:nbd9
[    6.112803] device: '43:10': device_add
[    6.114403] PM: Adding info for No Bus:43:10
[    6.116103] device: 'nbd10': device_add
[    6.117608] PM: Adding info for No Bus:nbd10
[    6.119480] device: '43:11': device_add
[    6.121049] PM: Adding info for No Bus:43:11
[    6.141932] device: 'nbd11': device_add
[    6.143638] PM: Adding info for No Bus:nbd11
[    6.145589] device: '43:12': device_add
[    6.147080] PM: Adding info for No Bus:43:12
[    6.148794] device: 'nbd12': device_add
[    6.150432] PM: Adding info for No Bus:nbd12
[    6.162438] device: '43:13': device_add
[    6.164010] PM: Adding info for No Bus:43:13
[    6.165692] device: 'nbd13': device_add
[    6.167118] PM: Adding info for No Bus:nbd13
[    6.168952] device: '43:14': device_add
[    6.170528] PM: Adding info for No Bus:43:14
[    6.192415] device: 'nbd14': device_add
[    6.194019] PM: Adding info for No Bus:nbd14
[    6.195756] device: '43:15': device_add
[    6.197195] PM: Adding info for No Bus:43:15
[    6.198868] device: 'nbd15': device_add
[    6.200428] PM: Adding info for No Bus:nbd15
[    6.212344] device class 'enclosure': registering
[    6.214176] Uniform Multi-Platform E-IDE driver
[    6.215944] bus: 'ide': registered
[    6.217168] device class 'ide_port': registering
[    6.219747] bus: 'platform': add driver pata_platform
[    6.234609] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    6.247050] device: 'bond0': device_add
[    6.248735] PM: Adding info for No Bus:bond0
[    6.251735] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    6.254904] device: 'eql': device_add
[    6.256375] PM: Adding info for No Bus:eql
[    6.258871] bus: 'mdio_bus': add driver Cicada Cis8201
[    6.260612] bus: 'mdio_bus': add driver Cicada Cis8204
[    6.270623] bus: 'mdio_bus': add driver LXT970
[    6.282350] bus: 'mdio_bus': add driver LXT971
[    6.283930] bus: 'mdio_bus': add driver LXT973-A2
[    6.285604] bus: 'mdio_bus': add driver LXT973
[    6.287237] bus: 'mdio_bus': add driver Broadcom BCM5411
[    6.289167] bus: 'mdio_bus': add driver Broadcom BCM5421
[    6.291103] bus: 'mdio_bus': add driver Broadcom BCM5461
[    6.306328] bus: 'mdio_bus': add driver Broadcom BCM5464
[    6.308363] bus: 'mdio_bus': add driver Broadcom BCM5481
[    6.310349] bus: 'mdio_bus': add driver Broadcom BCM5482
[    6.322422] bus: 'mdio_bus': add driver Broadcom BCM50610
[    6.324512] bus: 'mdio_bus': add driver Broadcom BCM50610M
[    6.326567] bus: 'mdio_bus': add driver Broadcom BCM57780
[    6.328671] bus: 'mdio_bus': add driver Broadcom BCMAC131
[    6.330760] bus: 'mdio_bus': add driver Broadcom BCM5241
[    6.339877] bus: 'mdio_bus': add driver RTL8211B Gigabit Ethernet
[    6.342173] bus: 'mdio_bus': add driver RTL8211E Gigabit Ethernet
[    6.344420] Registering platform device 'Fixed MDIO bus.0'. Parent at pl=
atform
[    6.346940] device: 'Fixed MDIO bus.0': device_add
[    6.348694] bus: 'platform': add device Fixed MDIO bus.0
[    6.350729] PM: Adding info for platform:Fixed MDIO bus.0
[    6.362803] device: 'fixed-0': device_add
[    6.364131] PM: Adding info for No Bus:fixed-0
[    6.365669] libphy: Fixed MDIO Bus: probed
[    6.367179] bus: 'mdio_bus': add driver STe101p
[    6.368909] bus: 'mdio_bus': add driver STe100p
[    6.382768] bus: 'platform': add driver mdio-mux-gpio
[    6.384631] arcnet loaded.
[    6.385704] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    6.388457] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    6.390879] E-mail me if you actually test this driver, please!
[    6.413101]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    6.415935] vcan: Virtual CAN interface driver
[    6.417634] bus: 'platform': add driver ks8851_mll
[    6.419445] AX.25: Z8530 SCC driver version 3.0.dl1bke
[    6.429392] device: 'scc0': device_add
[    6.430804] PM: Adding info for No Bus:scc0
[    6.432550] AX.25: bpqether driver version 004
[    6.434212] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.434212] baycom_ser_hdx: version 0.10
[    6.438048] device: 'bcsh0': device_add
[    6.439664] PM: Adding info for No Bus:bcsh0
[    6.451650] device: 'bcsh1': device_add
[    6.453306] PM: Adding info for No Bus:bcsh1
[    6.455125] device: 'bcsh2': device_add
[    6.456778] PM: Adding info for No Bus:bcsh2
[    6.458533] device: 'bcsh3': device_add
[    6.460080] PM: Adding info for No Bus:bcsh3
[    6.472049] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.474103] hdlcdrv: version 0.8
[    6.475291] bus: 'usb': add driver stir4200
[    6.476891] usbcore: registered new interface driver stir4200
[    6.478971] w83977af_init()
[    6.480026] w83977af_open()
[    6.481102] w83977af_probe()
[    6.502562] w83977af_probe(), Wrong chip version
[    6.504231] w83977af_probe()
[    6.505621] w83977af_probe(), Wrong chip version
[    6.509499] irda_register_dongle : registering dongle "Old Belkin SmartB=
eam" (7).
[    6.512245] bus: 'usb': add driver ksdazzle-sir
[    6.513878] usbcore: registered new interface driver ksdazzle-sir
[    6.522269] bus: 'usb': add driver ks959-sir
[    6.524012] usbcore: registered new interface driver ks959-sir
[    6.526206] PPP generic driver version 2.4.2
[    6.528174] device class 'ppp': registering
[    6.529569] device: 'ppp': device_add
[    6.530878] PM: Adding info for No Bus:ppp
[    6.532492] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    6.535963] bus: 'ssb': add driver b43legacy
[    6.537353] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[    6.539267] zd1211rw usb_init()
[    6.551680] bus: 'usb': add driver zd1211rw
[    6.553542] usbcore: registered new interface driver zd1211rw
[    6.558048] zd1211rw initialized
[    6.559202] bus: 'usb': add driver rndis_wlan
[    6.560887] usbcore: registered new interface driver rndis_wlan
[    6.563032] bus: 'usb': add driver zd1201
[    6.564604] usbcore: registered new interface driver zd1201
[    6.566466] bus: 'usb': add driver brcmfmac
[    6.570440] usbcore: registered new interface driver brcmfmac
[    6.572609] bus: 'usb': add driver catc
[    6.574159] usbcore: registered new interface driver catc
[    6.578501] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    6.581144] bus: 'usb': add driver pegasus
[    6.582699] usbcore: registered new interface driver pegasus
[    6.584597] bus: 'usb': add driver r8152
[    6.586623] usbcore: registered new interface driver r8152
[    6.588630] bus: 'usb': add driver asix
[    6.590039] usbcore: registered new interface driver asix
[    6.592417] bus: 'usb': add driver ax88179_178a
[    6.594100] usbcore: registered new interface driver ax88179_178a
[    6.596106] bus: 'usb': add driver cdc_ether
[    6.597633] usbcore: registered new interface driver cdc_ether
[    6.604691] bus: 'usb': add driver dm9601
[    6.606017] usbcore: registered new interface driver dm9601
[    6.607750] bus: 'usb': add driver smsc95xx
[    6.612327] usbcore: registered new interface driver smsc95xx
[    6.614137] bus: 'usb': add driver rndis_host
[    6.618706] usbcore: registered new interface driver rndis_host
[    6.620620] bus: 'usb': add driver cdc_subset
[    6.625137] usbcore: registered new interface driver cdc_subset
[    6.627036] bus: 'usb': add driver int51x1
[    6.631551] usbcore: registered new interface driver int51x1
[    6.633380] bus: 'usb': add driver ipheth
[    6.634766] usbcore: registered new interface driver ipheth
[    6.640771] bus: 'usb': add driver cx82310_eth
[    6.647441] usbcore: registered new interface driver cx82310_eth
[    6.649602] bus: 'platform': add driver isp1362-hcd
[    6.654384] bus: 'platform': add driver r8a66597_hcd
[    6.656238] bus: 'usb': add driver usbtmc
[    6.657653] usbcore: registered new interface driver usbtmc
[    6.659653] bus: 'usb': add driver mdc800
[    6.661108] usbcore: registered new interface driver mdc800
[    6.667154] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    6.669742] bus: 'usb': add driver idmouse
[    6.671183] usbcore: registered new interface driver idmouse
[    6.673193] bus: 'usb': add driver isight_firmware
[    6.674942] usbcore: registered new interface driver isight_firmware
[    6.680400] bus: 'usb': add driver usblcd
[    6.681956] usbcore: registered new interface driver usblcd
[    6.683768] bus: 'usb': add driver ldusb
[    6.685142] usbcore: registered new interface driver ldusb
[    6.690073] bus: 'usb': add driver trancevibrator
[    6.694820] usbcore: registered new interface driver trancevibrator
[    6.696953] bus: 'usb': add driver usbsevseg
[    6.701605] usbcore: registered new interface driver usbsevseg
[    6.703500] bus: 'usb': add driver yurex
[    6.704832] usbcore: registered new interface driver yurex
[    6.706749] bus: 'platform': add driver samsung-usb2phy
[    6.711725] bus: 'platform': add driver gpio-vbus
[    6.713348] bus: 'platform': remove driver gpio-vbus
[    6.714970] driver: 'gpio-vbus': driver_release
[    6.716404] bus: 'pnp': add driver i8042 kbd
[    6.719958] bus: 'pnp': driver_probe_device: matched device 00:01 with d=
river i8042 kbd
[    6.722801] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:01
[    6.725271] driver: '00:01': driver_bound: bound to device 'i8042 kbd'
[    6.730650] bus: 'pnp': really_probe: bound device 00:01 to driver i8042=
 kbd
[    6.737161] bus: 'pnp': add driver i8042 aux
[    6.738767] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 aux
[    6.741413] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:02
[    6.743799] driver: '00:02': driver_bound: bound to device 'i8042 aux'
[    6.745894] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 aux
[    6.750290] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.756969] Registering platform device 'i8042'. Parent at platform
[    6.759233] device: 'i8042': device_add
[    6.760524] bus: 'platform': add device i8042
[    6.762099] PM: Adding info for platform:i8042
[    6.763770] bus: 'platform': add driver i8042
[    6.765254] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    6.769975] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    6.791496] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.793197] device: 'serio0': device_add
[    6.794528] bus: 'serio': add device serio0
[    6.795913] PM: Adding info for serio:serio0
[    6.797327] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.799287] device: 'serio1': device_add
[    6.812077] driver: 'i8042': driver_bound: bound to device 'i8042'
[    6.813932] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    6.816237] bus: 'serio': add driver serio_raw
[    6.822000] bus: 'serio': add device serio1
[    6.823534] PM: Adding info for serio:serio1
[    6.825123] bus: 'platform': add driver altera_ps2
[    6.826833] bus: 'serio': add driver atkbd
[    6.828242] smssdio: Siano SMS1xxx SDIO driver
[    6.861421] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    6.863904] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    6.867359] smssdio: Copyright Pierre Ossman
[    6.867377] bus: 'sdio': add driver smssdio
[    6.867449] bus: 'pci': add driver ptp_pch
[    6.867548] Driver for 1-wire Dallas network protocol.
[    6.867636] bus: 'w1': registered
[    6.867638] bus: 'w1': add driver w1_master_driver
[    6.867683] bus: 'w1': add driver w1_slave_driver
[    6.867739] bus: 'platform': add driver pda-power
[    6.867788] bus: 'platform': add driver ds2780-battery
[    6.867830] bus: 'platform': add driver goldfish-battery
[    6.867872] bus: 'platform': add driver isp1704_charger
[    6.877944] cpuidle: using governor ladder
[    6.877948] bus: 'mmc': add driver mmc_test
[    6.877992] sdhci: Secure Digital Host Controller Interface driver
[    6.877992] sdhci: Copyright(c) Pierre Ossman
[    6.878197] bus: 'memstick': registered
[    6.878199] device class 'memstick_host': registering
[    6.878253] bus: 'memstick': add driver mspro_block
[    6.878339] bus: 'platform': add driver leds-lt3593
[    6.878401] ledtrig-cpu: registered to indicate activity on CPUs
[    6.878407] bus: 'platform': add driver dcdbas
[    6.878460] Registering platform device 'dcdbas'. Parent at platform
[    6.878464] device: 'dcdbas': device_add
[    6.878478] bus: 'platform': add device dcdbas
[    6.878500] PM: Adding info for platform:dcdbas
[    6.878538] bus: 'platform': driver_probe_device: matched device dcdbas =
with driver dcdbas
[    6.878540] bus: 'platform': really_probe: probing driver dcdbas with de=
vice dcdbas
[    6.878573] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.878575] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    6.878577] bus: 'platform': really_probe: bound device dcdbas to driver=
 dcdbas
[    6.878581] bus: 'platform': add driver ssbi
[    6.878626] bus: 'platform': add driver olpc-ec
[    6.878669] bus: 'platform': add driver goldfish_pdev_bus
[    6.878695] bus: 'platform': driver_probe_device: matched device goldfis=
h_pdev_bus with driver goldfish_pdev_bus
[    6.878697] bus: 'platform': really_probe: probing driver goldfish_pdev_=
bus with device goldfish_pdev_bus
[    6.878726] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    6.878738] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    6.878944] NET: Registered protocol family 26
[    6.878987] TCP: scalable registered
[    6.878988] TCP: lp registered
[    6.878989] Initializing XFRM netlink socket
[    6.879003] bus: 'platform': add driver dsa
[    6.879178] NET: Registered protocol family 4
[    6.879214] NET: Registered protocol family 5
[    6.879229] NET: Registered protocol family 3
[    6.879237] can: controller area network core (rev 20120528 abi 9)
[    6.879442] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    6.879443] NET: Registered protocol family 29
[    6.879446] can: netlink gateway (rev 20130117) max_hops=3D1
[    6.879903] NET: Registered protocol family 33
[    6.879905] Key type rxrpc registered
[    6.879906] Key type rxrpc_s registered
[    6.879963] l2tp_core: L2TP core driver, V2.0
[    7.038949] device: 'input1': device_add
[    7.040397] PM: Adding info for No Bus:input1
[    7.042092] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    7.045208] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    7.047415] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    7.049760] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    7.052734] DCCP: Activated CCID 2 (TCP-like)
[    7.052987] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    7.053458] lib80211: common routines for IEEE802.11 drivers
[    7.053466] lib80211_crypt: registered algorithm 'NULL'
[    7.053474] lib80211_crypt: registered algorithm 'WEP'
[    7.053478] lib80211_crypt: registered algorithm 'CCMP'
[    7.053482] lib80211_crypt: registered algorithm 'TKIP'
[    7.053483] tipc: Activated (version 2.0.0)
[    7.053895] NET: Registered protocol family 30
[    7.054160] kmem_cache_sanity_check (tipc_rcvbuf): Cache name already ex=
ists.
[    7.054163] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00247-g=
ed75b21 #32
[    7.054170]  00000000 c1589e09 c003fef4 c1416d45 c003ff24 c1085063 c1521=
55f c1427330
[    7.054175]  c1589e09 00000000 ffffffff 00010000 742efec0 c160b2e4 00000=
0f5 00000000
[    7.054179]  c003ff3c c10851e1 00000000 00002000 00000000 00000000 c003f=
f60 c13e52f0
[    7.054187] Call Trace:
[    7.054232]  [<c1416d45>] dump_stack+0x16/0x18
[    7.054257]  [<c1085063>] kmem_cache_create_memcg+0xf0/0x257
[    7.054261]  [<c10851e1>] kmem_cache_create+0x17/0x19
[    7.054272]  [<c13e52f0>] tipc_server_start+0x41/0x1e1
[    7.054280]  [<c13da859>] tipc_cfg_init+0xd/0xf
[    7.054288]  [<c1637f6a>] tipc_init+0xb2/0xd6
[    7.054292]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
[    7.054317]  [<c1000192>] do_one_initcall+0x6b/0xf1
[    7.054322]  [<c160ca39>] kernel_init_freeable+0xec/0x171
[    7.054329]  [<c1407fdc>] kernel_init+0x8/0xaf
[    7.054333]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
[    7.054336]  [<c1407fd4>] ? rest_init+0x70/0x70
[    7.054443] BUG: unable to handle kernel NULL pointer dereference at 000=
00014
[    7.054447] IP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e
[    7.054449] *pde =3D 00000000=20
[    7.054452] Oops: 0002 [#1] PREEMPT SMP=20
[    7.054464] Modules linked in:
[    7.054467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00247-g=
ed75b21 #32
[    7.054468] task: c0040000 ti: c003e000 task.ti: c003e000
[    7.054475] EIP: 0060:[<c1419748>] EFLAGS: 00010046 CPU: 0
[    7.054478] EIP is at __mutex_lock_common.isra.3+0x7d/0x32e
[    7.054480] EAX: 00000100 EBX: 00000010 ECX: c003e000 EDX: 00000000
[    7.054482] ESI: 00000246 EDI: c0040000 EBP: c003feec ESP: c003feac
[    7.054483]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    7.054485] CR0: 8005003b CR2: 00000014 CR3: 01660000 CR4: 000006d0
[    7.054494] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    7.054498] DR6: ffff0ff0 DR7: 00000400
[    7.054499] Stack:
[    7.054505]  c003feb8 c141af97 c003fec0 00000002 00000014 c003ff18 c1416=
19c 0010000d
[    7.054510]  00000000 000da5a0 0010000e 00000246 00000246 00000010 c160b=
30c 00000000
[    7.054515]  c003fef4 c1419b8c c003ff00 c1419bac 00000000 c003ff24 c103f=
010 c003ff18
[    7.054516] Call Trace:
[    7.054520]  [<c141af97>] ? _raw_spin_unlock_irqrestore+0x28/0x34
[    7.054523]  [<c141619c>] ? __slab_free+0x126/0x2b6
[    7.054526]  [<c1419b8c>] __mutex_lock_slowpath+0xd/0xf
[    7.054529]  [<c1419bac>] mutex_lock+0x1e/0x2a
[    7.054540]  [<c103f010>] drain_workqueue+0x16/0xea
[    7.054543]  [<c103f119>] destroy_workqueue+0xe/0x155
[    7.054546]  [<c13e54f3>] tipc_server_stop+0x63/0x84
[    7.054553]  [<c1031202>] ? put_online_cpus+0x59/0x5b
[    7.054556]  [<c13da890>] tipc_cfg_stop+0xd/0x11
[    7.054559]  [<c1418843>] tipc_core_stop+0x12/0x28
[    7.054562]  [<c1637f75>] tipc_init+0xbd/0xd6
[    7.054564]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
[    7.054566]  [<c1000192>] do_one_initcall+0x6b/0xf1
[    7.054569]  [<c160ca39>] kernel_init_freeable+0xec/0x171
[    7.054572]  [<c1407fdc>] kernel_init+0x8/0xaf
[    7.054575]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
[    7.054578]  [<c1407fd4>] ? rest_init+0x70/0x70
[    7.054601] Code: 51 c1 68 55 01 00 00 68 74 be 51 c1 e8 8c 53 c1 ff 83 =
c4 10 e8 fe bb c2 ff 89 c6 e8 0d bc c2 ff 8d 43 04 89 45 d0 b8 00 01 00 00 =
<f0> 66 0f c1 43 04 88 c2 0f b6 c4 38 c2 74 07 f3 90 8a 53 04 eb
[    7.054605] EIP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e SS:E=
SP 0068:c003feac
[    7.054606] CR2: 0000000000000014
[    7.054611] ---[ end trace 730db1884308edf4 ]---
[    7.054623] note: swapper/0[1] exited with preempt_count 1
[    7.054655] swapper/0 (1) used greatest stack depth: 6268 bytes left
[    7.054660] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    7.054660]=20
[    7.061436] Rebooting in 10 seconds..
--UlVJffcvxoiEqYs2
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="ed75b2108d86fdd218fd0a89b0cc46a39ed6d724-bisect.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIGRjZGJlMzNhZGQ1NmNiNjU5ZWJmMjFmYjliNjU3NzUwN2UyMWQ5NTI6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBlZDc1YjIxLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J3BhdWxnL3RpcGNfbmV0LW5leHQnIGludG8gZGV2ZWwteGlhbi1pMzg2LTIwMTMtMDUtMzEt
MDQtMDgKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKCjIwMTMtMDUtMzEt
MTA6MzM6MjAgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMSByZXVz
ZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC9jMWJlNWE1YjFiMzU1ZDQwZTZj
Zjc5Y2M5NzllYjY2ZGFmYTI0YWQxL3ZtbGludXotMy45LjAtcGFnZW91dAoKMjAxMy0wNS0z
MS0xMDozMzozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAgIzE2IAkxLi4JNAk5CTEwIAkxMCBT
VUNDRVNTCnJtOiBjYW5ub3QgcmVtb3ZlIGAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14Mjgt
MDUzMC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYVByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIGMxYmU1YTUuLi4gTGludXggMy45CkhFQUQgaXMgbm93IGF0IDUyMWNi
NDAuLi4gTGludXggMi42LjM4CkJpc2VjdGluZzogNjY3MSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls3MzI4N2E0M2NjNzljYTA2NjI5
YTg4ZDFhMTk5Y2QyODNmNDI0NTZhXSBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0LW5leHQKZ2l0IGJpc2VjdCBydW4gL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmot
YmlzZWN0CgoyMDEzLTA1LTMxLTEwOjM3OjE0IDczMjg3YTQzY2M3OWNhMDY2MjlhODhkMWEx
OTljZDI4M2Y0MjQ1NmEgY29tcGlsaW5nCnJtOiBjYW5ub3QgcmVtb3ZlIGAvdG1wL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDI4LTA1MzAvNzMyODdhNDNjYzc5Y2EwNjYyOWE4OGQ0NTQg
cmVhbCAgMTg0NyB1c2VyICAxNjkgc3lzICA0NDQuMTElIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXgyOC0wNTMwCgoyMDEzLTA1LTMxLTEwOjQ0OjQ3IGRldGVjdGluZyBib290IHN0YXRlIDMu
OS4wLXBhZ2VvdXQtMDcxNjgtZzczMjg3YTQgIzMxIAkwLi4uLi4uLi4JMwk1Lgk2CTkJMTEg
U1VDQ0VTUwpybTogY2Fubm90IHJlbW92ZSBgL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDI4
LTA1MzAvNzMyODdhNDNjYzc5Y2EwNjYyOWE4OGQxYTE5OWNkMjgzZjQyNDU2YS8ucGlkJzog
Tm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpCaXNlY3Rpbmc6IDMzMjEgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbZDdhYjczMDJmOTcw
YTI1NDk5NzY4N2ExY2RlZGU0MjFhNTYzNWM2OF0gTWVyZ2UgdGFnICdtZmQtMy4xMC0xJyBv
ZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc2FtZW8v
bWZkLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIG9iai1iaXNlY3QKCjIwMTMtMDUtMzEtMTA6NTI6MTkgZDdhYjczMDJmOTcwYTI1
NDk5NzY4N2ExY2RlZGU0MjFhNTYzNWM2OCBjb21waWxpbmcKMzg0IHJlYWwgIDE4NDUgdXNl
ciAgMTcwIHN5cyAgNTI0Ljg1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MjgtMDUzMAobWzE7
MzVtL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDI4LTA1MzAvZDdhYjczMDJmOTcwYTI1NDk5
NzY4N2ExY2RlZGU0MjFhNTYzNWM2OC92bWxpbnV6LTMuOS4wLWJpc2VjdC0xMDUxOC1nZDdh
YjczMCBhbHJlYWR5IGV4aXN0czogZHVwbGljYXRlIGNvbXBpbGF0aW9uPxtbMG0KCjIwMTMt
MDUtMzEtMTA6NTk6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcGFnZW91dC0xMDUx
OC1nZDdhYjczMCAjMzIgCTAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTEuLi4uCTQuLi4uCTUuCTcuLi4JOC4uLi4uLi4u
Li4JOS4uLi4uLi4JMTMgU1VDQ0VTUwpybTogY2Fubm90IHJlbW92ZSBgL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDI4LTA1MzAvZDdhYjczMDJCaXNlY3Rpbmc6IDE2NjAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBCaXNlY3Rpbmc6IDE2
NjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBz
KQpbMDdlMDc0NTAzZWJhM2VlNjU3YWI1MGE4Yzk0OTdkZGY5MDAzOWU3ZV0gTWVyZ2UgYnJh
bmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC92aXJvL3ZmMjAxMy0wNS0zMS0xNDozMDozMyAwN2UwNzQ1MDNlYmEzZWU2
NTdhYjUwYThjOTQ5N2RkZjkwMDM5ZTdlIGNvbXBpbGluZwo0MjQgcmVhbCAgMTgzMSB1c2Vy
ICAxNjcgc3lzICA0NzAuODIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTM0NDYgcmVh
bCAgMTgzNyB1c2VyICAxNjcgc3lzICA0NDkuMTklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgy
OC0wNTMwChtbMTszNW0vCTAuLi4uCTEuLi4JMi4uLi4JMwk0Lgk1Li4uLi4uLgk3Lgk4Li4u
Li4JOS4JMTAgU1VDQ0VTUwpybTogY2Fubm90IHJlbW92ZSBgL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDI4LTA1MzAvMDdlMDc0NTAzZWJhM2VlNjU3YWI1MGE4Yzk0OTdkZGY5MDAzOWU3
ZS8ucGlkJzogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpCaXNlY3Rpbmc6IDgyNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClszYzZh
Mjc5ZmZjY2QwYzQxNGVjZDFkNWViNDY3MGVkNzAwNzJjNTI2XSBNZXJnZSBicmFuY2ggJ3Vw
c3RyZWFtJyBvZiBnaXQ6Ly9naXQubGludXgtbWlwcy5vcmcvcHViL3NjbS9yYWxmL3Vwc3Ry
ZWFtLWxpbnVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTMxLTE0OjU4OjEyIDNjNmEyNzlmZmNjZDBj
NDE0ZWNkMWQ1ZWI0NjcwZWQ3MDA3MmM1MjYgY29tcGlsaW5nCjM3MiByZWFsICAxODQ3IHVz
ZXIgIDE3MCBzeXMgIDU0MS4zMiUgY3B1IAlpMzg2LXJhbmRjb25maWcteDI4LTA1MzAKG1sx
OzM1bS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzNjNmEyNzlmZmNjZDBjNDE0
ZWNkMWQ1ZWI0NjcwZWQ3MDA3MmM1MjYvdm1saW51ei0zLjEwLjAtcmMxLXBhZ2VvdXQtMDAy
OTktZzNjNmEyNzkgYWxyZWFkeSBleGlzdHM6IGR1cGxpY2F0ZSBjb21waWxhdGlvbj8bWzBt
CgoyMDEzLTA1LTMxLTE1OgkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTEuLi4uCTIuLgkzLi4uLi4uLgk1Li4uLi4uLi4uLi4uLi4uLi4JNi4JNy4uLi4uLi4uLi4u
Li4JOC4JOQkxMCBTVUNDRVNTCnJtOiBjYW5ub3QgcmVtb3ZlIGAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14MjgtMDUzMC8zYzZhMjc5ZmZjY2QwYzQxNGVjZDFkNWViNDY3MGVkNzAwNzJj
NTI2Ly5waWQnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CkJpc2VjdGluZzogNDA4IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZWIz
ZDMzOTAwYWE5NTNiY2RmZTEzMmE3MWJiMDNlZTU5MmViYmI0N10gTWVyZ2UgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2Vj
dAoKMjAxMy0wNS00MjkgcmVhbCAgMTgzMyB1c2VyICAxNzEgc3lzICA0NjYuNTQlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLXgyOC00MTQgcgoyMDEzLTA1LTMxLTIwOjAwOjQwIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTAuMC1yYzItYmlzZWN0LTAwMzE0LWdlYjNkMzM5ICMyMSAJMC4u
Li4uLi4uLgkxCTMuCTQJNS4JNgk3CTgJOQkxMSBTVUNDRVNTCnJtOiBjYW5ub3QgcmVtb3Zl
IGAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC9lYjNkMzM5MDBhYTk1M2JjZGZl
MTMyYTcxYmIwM2VlNTkyZWJiYjQ3Ly5waWQnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5
CkJpc2VjdGluZzogMjA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA4IHN0ZXBzKQpbMWZhNjU0NDdiYzdiM2JmNGZhNmQxY2ZlOWE4OGRjYmZlODA0ZGYy
OF0gdGlwYzogcmVuYW1lIHRpcGNfY3JlYXRlcG9ydF9yYXcgdG8gdGlwY19jcmVhdGVwb3J0
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBv
YmotYmlzZWN0CgoyMDEzLTA1LTMxLTIwOjExOjE0IDFmYTY1NDQ3YmM3YjNiZjRmYTZkMWNm
ZTlhODhkY2JmZTgwNGRmMjggY29tcGlsaW5nCnJtOiBjYW5ub3QgcmVtb3ZlIGAvdG1wL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDI4LTA1MzAvMWZhNjU0NDdiYzdiM2JmNGZhNmQxY2Zl
OWE4OGRjYmZlODA0ZGYyOC9idWkzNDAgcmVhbCAgMTgyNSB1c2VyICAxNzAgc3lzICA1ODcu
MDAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwCgoyMDEzLTA1LTMxLTIwOjE3OjAx
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzItcGFnZW91dC0wMDUxOC1nMWZhNjU0
NDcgIzM2IAkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFCnJtOiBj
YW5ub3QgcmVtb3ZlIGAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC8xZmE2NTQ0
N2JjN2IzYmY0ZmE2ZDFjZmU5YTg4ZGNiZmU4MDRkZjI4Ly5waWQnOiBObyBzdWNoIGZpbGUg
b3IgZGlyZWN0b3J5CkJpc2VjdGluZzogMTAxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbODRiNmY3NDU2ZThiODg1MDdkZDg1Zjk4OGE5
ZDM1MGViNWFmMGU0Nl0gYm54Mng6IEVuYWJsZSBgc2V0X3BoeXNfaWQnIGZvciBhbGwgZnVu
Y3Rpb25zCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTMxLTIwOjMwOjMzIDg0YjZmNzQ1NmU4Yjg4NTA3
ZGQ4NWY5ODhhOWQzNTBlYjVhZjBlNDYgY29tcGlsaW5nCjM3MCByZWFsICAxODQ4IHVzZXIg
IDE2OSBzeXMgIDU0NC4wNCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDI4LTA1MzAKG1sxOzM1
bS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzg0YjZmNzQ1NmU4Yjg4NTA3ZGQ4
NWY5ODhhOWQzNTBlYjVhZjBlNDYvdm1saW51ei0zLjEwLjAtcmMxLWJpc2VjdC0wMDE4MS1n
ODRiNmY3NCBhbHJlYWR5IGV4aXN0czogZHVwbGljYXRlIGNvbXBpbGF0aW9uPxtbMG0KCjIw
MTMtMDUtMzEtMjA6Mzc6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMS1wYWdl
b3V0LTAwMTgxLWc4NGI2Zjc0ICMzNyAJMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTEuLi4uLi4uLi4uLi4uLi4uLi4uCTIuLgkzLi4uLi4uLi4uLi4uLi4uLi4u
Li4JNAk1CTYuLgk3CTgJOQkxMCBTVUNDRVNTCnJtOiBjYW5ub3QgcmVtb3ZlIGAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC84NGI2Zjc0NTZlOGI4ODUwN2RkODVmOTg4YTlk
MzUwZWI1YWYwZTQ2Ly5waWQnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CkJpc2VjdGlu
ZzogNTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3Rl
cHMpCltlZWI2NWNlZGQ3OGViZDM3NTYwOGQ3MWQ3MDNlNmIwYjkyOTZlZmJkXSBiZTJuZXQ6
IGNsZWFudXAgYmVfZ2V0X2RydmluZm8oKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUzOTMgcmVhbCAgMTg2NyB1c2VyICAxNzAgc3lzICA1MTgu
MDclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwCgoyMDEzLTA1LTMxLTIxOjMwOjI0
MDYgcmVhbCAgMTg1OCB1c2VyICAxNzIgc3lzICA0OTkuMzklIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXgJMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyCTUuCTYJNy4uCTkuLi4uCTEwIFNV
Q0NFU1MKQmlzZWN0aW5nOiAyNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNSBzdGVwcykKWzM1MTYzOGU3ZGVlZWQyZWM4Y2U0NTFiNTNkMzM5MjFiM2Rh
NjhmODNdIG5ldDogcGFzcyBpbmZvIHN0cnVjdCB2aWEgbmV0ZGV2aWNlIG5vdGlmaWVyCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmot
YmlzZWN0CgoyMDEzLTA2LTAxLTAyOjE5OjMzIDM1MTYzOGU3ZGVlZWQyZXJtOiBjYW5ub3Qg
cmVtb3ZlIGAva2VybmVsL2kzODYtcmFuZDQyNSByZWFsICAxODI2IHVzZXIgIDE2OSBzeXMg
IDQ2OS4zOCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDI4LTA1MzAKCjIwMTMtMDYtMDEtMDI6
Mjc6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMi1iaXNlY3QtMDA0OTItZzM1
MTYzOGUgIzI1IAkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTMuCTUuCTcJOQkx
MCBTVUNDRVNTCnJtOiBjYW5ub3QgcmVtb3ZlIGAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MjgtMDUzMC8zNTE2MzhlN2RlZWVkMmVjOGNlNDUxYjUzZDMzOTIxYjNkYTY4ZjgzLy5waWQn
OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CkJpc2VjdGluZzogMTIgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClszMWZlYzVhYTIxZDE2
NmNmODE3MDJhNjY5YzEzOTg3ODRiNTEzYjhhXSB2eGxhbjogdXNlIHVuc2lnbmVkIGludCBp
bnN0ZWFkIG9mIHVuc2lnbmVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA2LTAxLTA2OjIyOjEyIDMxZmVj
NWFhMjFkMTY2Y2Y4MTcwMmE2NjljMTM5ODc4NGI1MTNiOGEgY29tcGlsaW5nCjQyNCByZWFs
ICAxODIxIHVzZXIgIDE2OCBzeXMgIDQ2OC45NSUgY3B1IAlpMzg2LXJhbmRjb25maWcteDI4
LTA1MzAKG1sxOzM1bS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzMxZmVjNWFh
MjFkMTY2Y2Y4MTcwMmE2NjljMTM5ODc4NGI1MTNiOGEvdm1saW51ei0zLjEwLjAtcmMyLXBh
Z2VvdXQtMDA1MDUtZzMxZmVjNWEgYWxyZWFkeSBleGlzdHM6IGR1cGxpY2F0ZSBjb21waWxh
dGlvbj8bWzBtCgoyMDEzLTA2LTAxLTA2OjI5OjQ3IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTAuMC1yYzItYmlzZWN0LTAwNTA1LWczMWZlYzVhICMyNiAJMC4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTEuLi4uLi4uCTIuLi4uLi4uLi4uLi4uLi4JMwk0
Lgk1Li4JNi4uLi4uLi4uCTcJOAk5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMCBTVUND
RVNTCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMyBzdGVwcykKWzk3OGUxMTE1ZmViMTI2NzJjZjAxNDY5N2RmZWZmZmYyYzRkNWEy
ZGFdIHRpcGM6IEFkZCAibWF4X3BvcnRzIiBjb25maWd1cmF0aW9uIHBhcmFtZXRlcgpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJp
c2VjdAoKMjAxMy0wNi0wMS0wNzoyNDo0OSA5NzhlMTExNWZlYjEyNjcyY2YwMTQ2OTdkZmVm
ZmZmMmM0ZDVhMmRhIGNvbXBpbGluZwozMzIgcmVhbCAgMTgxNCB1c2VyICAxNjQgc3lzICA1
OTQuODglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwCgoyMDEzLTA2LTAxLTA3OjMw
OjQzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzItYmlzZWN0LTAwNTExLWc5Nzhl
MTExICMyNyAJMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTggU1VDQ0VTUwpC
aXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDIgc3RlcHMpClszN2Y4ZWRmMTAxMzU5ZmMyNjdjZThkMjhiMmJjYzY1Mzc2Y2NmMTRkXSB0
aXBjOiBjb252ZXJ0IHRvcG9sb2d5IHNlcnZlciB0byB1c2UgbmV3IHNlcnZlciBmYWNpbGl0
eQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
b2JqLWJpc2VjdAoKMjAxMy0wNi0wMS0xMDo1NjoxNyAzN2Y4ZWRmMTAxMzU5ZmMyNjdjZThk
MjhiMmJjYzY1Mzc2Y2NmMTRkIGNvbXBpbGluZwozNjUgcmVhbCAgMTgyOSB1c2VyICAxNjYg
c3lzICA1NDYuMjIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwCgoyMDEzLTA2LTAx
LTExOjAyOjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzItYmlzZWN0LTAwNTE0
LWczN2Y4ZWRmICMyOCAJMC4JMTIgU1VDQ0VTUwpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNjJmNzFiYzZmNzAyZmJk
NWU2ZjBmMjYwYjk4MjU4MGVhMjExMTg2Ml0gdGlwYzogZGVsZXRlIGNvZGUgb3JwaGFuZWQg
YnkgbmV3IHNlcnZlciBpbmZyYXN0cnVjdHVyZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNi0wMS0xMTow
NDoxNyA2MmY3MWJjNmY3MDJmYmQ1ZTZmMGYyNjBiOTgyNTgwZWEyMTExODYyIGNvbXBpbGlu
ZwoxNTU2IHJlYWwgIDE4MTkgdXNlciAgMTY0IHN5cyAgMTI3LjQ1JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy14MjgtMDUzMAoKMjAxMy0wNi0wMS0xMTozMDozOSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEwLjAtcmMyLWJpc2VjdC0wMDUxNi1nNjJmNzFiYyAjMjkgCTAuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClswZmIwMDQwZWQ2OTdkMmIw
ZmJkNDg0MDQyY2RlYmJlNzZkMjlhODQwXSB0aXBjOiBjb252ZXJ0IGNvbmZpZ3VyYXRpb24g
c2VydmVyIHRvIHVzZSBuZXcgc2VydmVyIGZhY2lsaXR5CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA2LTAx
LTExOjQyOjEyIDBmYjAwNDBlZDY5N2QyYjBmYmQ0ODQwNDJjZGViYmU3NmQyOWE4NDAgY29t
cGlsaW5nCjg2MyByZWFsICAxODQyIHVzZXIgIDE2NyBzeXMgIDIzMi45MCUgY3B1IAlpMzg2
LXJhbmRjb25maWcteDI4LTA1MzAKCjIwMTMtMDYtMDEtMTE6NTg6MDMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMC4wLXJjMi1iaXNlY3QtMDA1MTUtZzBmYjAwNDAgIzMwIAkwLi4uLi4u
Li4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKMGZiMDA0MGVkNjk3ZDJiMGZiZDQ4NDA0MmNk
ZWJiZTc2ZDI5YTg0MCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgMGZiMDA0MGVk
Njk3ZDJiMGZiZDQ4NDA0MmNkZWJiZTc2ZDI5YTg0MApBdXRob3I6IFlpbmcgWHVlIDx5aW5n
Lnh1ZUB3aW5kcml2ZXIuY29tPgpEYXRlOiAgIE1vbiBNYXkgNiAyMzo1NzoxOCAyMDEzIC0w
NDAwCgogICAgdGlwYzogY29udmVydCBjb25maWd1cmF0aW9uIHNlcnZlciB0byB1c2UgbmV3
IHNlcnZlciBmYWNpbGl0eQogICAgCiAgICBBcyB0aGUgbmV3IHNvY2tldC1iYXNlZCBUSVBD
IHNlcnZlciBpbmZyYXN0cnVjdHVyZSBoYXMgYmVlbgogICAgaW50cm9kdWNlZCwgd2UgY2Fu
IG5vdyBjb252ZXJ0IHRoZSBjb25maWd1cmF0aW9uIHNlcnZlciB0byB1c2UKICAgIGl0LiAg
VGhlbiB3ZSBjYW4gdGFrZSBmdXR1cmUgc3RlcHMgdG8gc2ltcGxpZnkgdGhlIGNvbmZpZ3Vy
YXRpb24KICAgIHNlcnZlciBsb2NraW5nIHBvbGljeS4KICAgIAogICAgU29tZSBtaW5vciBy
ZW9yZGVyaW5nIG9mIGluaXRpYWxpemF0aW9uIGlzIGRvbmUsIGR1ZSB0byB0aGUKICAgIGRl
cGVuZGVuY3kgb24gaGF2aW5nIHRpcGNfc29ja2V0X2luaXQgY29tcGxldGVkLgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBZaW5nIFh1ZSA8eWluZy54dWVAd2luZHJpdmVyLmNvbT4KICAg
IFNpZ25lZC1vZmYtYnk6IEpvbiBNYWxveSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT4KICAg
IFNpZ25lZC1vZmYtYnk6IFBhdWwgR29ydG1ha2VyIDxwYXVsLmdvcnRtYWtlckB3aW5kcml2
ZXIuY29tPgoKOjA0MDAwMCAwNDAwMDAgYWIxMWExYjg3MDU3NzE0NTFjNDk3ZGUyZGZhMmQ1
ZmFkYWI3MmExMyBhODEwNTdlMTBiNDA2ZDM4MjliNmE0OGQ2ZGQ2ODc4NWYxNjAyOGIxIE0J
bmV0CmJpc2VjdCBydW4gc3VjY2VzcwoKMjAxMy0wNi0wMS0xMjowODowNSAzN2Y4ZWRmMTAx
MzU5ZmMyNjdjZThkMjhiMmJjYzY1Mzc2Y2NmMTRkIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgyOC0wNTMwLzM3ZjhlZGYxMDEzNTlmYzI2N2NlOGQyOGIyYmNjNjUzNzZjY2Yx
NGQvdm1saW51ei0zLjEwLjAtcmMyLXBhZ2VvdXQtMDA1MTQtZzM3ZjhlZGYKCjIwMTMtMDYt
MDEtMTI6MDg6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgICMzMCAJMC4uLgkxCTQJNQk2CTku
CTEyCTEzLgkxNgkxNy4JMjAJMjEuCTI0CTI1LgkyNgkyOS4uCTMwIFNVQ0NFU1MKCjIwMTMt
MDYtMDEtMTI6MjE6NDcgZWQ3NWIyMTA4ZDg2ZmRkMjE4ZmQwYTg5YjBjYzQ2YTM5ZWQ2ZDcy
NCByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC9lZDc1YjIxMDhkODZm
ZGQyMThmZDBhODliMGNjNDZhMzllZDZkNzI0L3ZtbGludXotMy4xMC4wLXJjMy0wMDI0Ny1n
ZWQ3NWIyMQoKMjAxMy0wNi0wMS0xMjoyMTo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAgIzMw
IAkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
IFRFU1QgRkFJTFVSRQpFUlJPUiMgMTogL2Mva2VybmVsLXRlc3RzL2Jpc2VjdDo1OTogbWFp
bjogJEJJU0VDVF9URVNUICRLQlVJTERfT1VUUFVUCkhFQUQgaXMgbm93IGF0IGVkNzViMjEg
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAncGF1bGcvdGlwY19uZXQtbmV4dCcgaW50
byBkZXZlbC14aWFuLWkzODYtMjAxMy0wNS0zMS0wNC0wOAoKPT09PT09PT09IGxpbnV4LW5l
eHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKCjIwMTMtMDYtMDEtMTc6MjQ6MDAgMTRkMzVk
MDE0YmQ4MDY4ODQ4MDFkMzIyNTllY2RhZjg1N2VmMjc2YiBjb21waWxpbmcKG1sxOzM1bS9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzE0ZDM1ZDAxNGJkODA2ODg0ODAxZDMy
MjU5ZWNkYWY4NTdlZjI3NmIvdm1saW51ei0zLjEwLjAtcmMzLXBhZ2VvdXQtbmV4dC0yMDEz
MDUzMSBhbHJlYWR5IGV4aXN0czogZHVwbGljYXRlIGNvbXBpbGF0aW9uPxtbMG0KCjIwMTMt
MDYtMDEtMTc6NDI6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMy1iaXNlY3Qt
bmV4dC0yMDEzMDUzMSAjMzEgCTAuLgk2Li4uLgk3CTguCTkuLgkxMQkxNAkxOQkyNAkyNy4J
Mjl0byB1c2UgbmV3IHNlcnZlciBmYWNpbGl0eQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNi0wMS0xMDo1
NjozMSAzN2Y4ZWRmMTAxMzU5ZmMyNjdjZThkMjhiMmJjYzY1Mzc2Y2NmMTRkIGNvbXBpbGlu
ZwpybTogY2Fubm90IHJlbW92ZSBgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0w
NTMwLzM3ZjhlZGYxMDEzNTlmYzI2N2NlOGQyOGIyYmNjNjUzNzZjY2YxNGQvYnVpbGQtZXJy
b3InOiBEaXJlY3Rvcnkgbm90IGVtcHR5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9y
eSBgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzM3ZjhlZGYxMDEzNTlm
YzI2N2NlOGQyOGIyYmNjNjUzNzZjY2YxNGQvYnVpbGQtZXJyb3InOiBGaWxlIGV4aXN0cwoy
NTkgcmVhbCAgMTgzNSB1c2VyICAxNjggc3lzICA3NzIuODYlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXgyOC0wNTMwChtbMTszNW0va2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC8z
N2Y4ZWRmMTAxMzU5ZmMyNjdjZThkMjhiMmJjYzY1Mzc2Y2NmMTRkL3ZtbGludXotMy4xMC4w
LXJjMi1iaXNlY3QtMDA1MTQtZzM3ZjhlZGYgYWxyZWFkeSBleGlzdHM6IGR1cGxpY2F0ZSBj
b21waWxhdGlvbj8bWzBtCgoyMDEzLTA2LTAxLTExOjAzOjI2IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC1yYzItcGFnZW91dC0wMDUxNC1nMzdmOGVkZiAjNDIgCTAJMTMgU1VDQ0VT
UwpybTogY2Fubm90IHJlbW92ZSBgL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDI4LTA1MzAv
MzdmOGVkZjEwMTM1OWZjMjY3Y2U4ZDI4YjJiY2M2NTM3NmNjZjE0ZC8ucGlkJzogTm8gc3Vj
aCBmaWxlIG9yIGRpcmVjdG9yeQpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNjJmNzFiYzZmNzAyZmJkNWU2ZjBmMjYw
Yjk4MjU4MGVhMjExMTg2Ml0gdGlwYzogZGVsZXRlIGNvZGUgb3JwaGFuZWQgYnkgbmV3IHNl
cnZlciBpbmZyYXN0cnVjdHVyZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNi0wMS0xMTowNDoyNiA2MmY3
MWJjNmY3MDJmYmQ1ZTZmMGYyNjBiOTgyNTgwZWEyMTExODYyIGNvbXBpbGluZwpybTogY2Fu
bm90IHJlbW92ZSBgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzYyZjcx
YmM2ZjcwMmZiZDVlNmYwZjI2MGI5ODI1ODBlYTIxMTE4NjIvYnVpbGQtZXJyb3InOiBEaXJl
Y3Rvcnkgbm90IGVtcHR5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSBgL3RtcC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwLzYyZjcxYmM2ZjcwMmZiZDVlNmYwZjI2
MGI5ODI1ODBlYTIxMTE4NjIvYnVpbGQtZXJyb3InOiBGaWxlIGV4aXN0cwoxNTM5IHJlYWwg
IDE4MDggdXNlciAgMTY4IHN5cyAgMTI4LjQyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14Mjgt
MDUzMAobWzE7MzVtL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDI4LTA1MzAvNjJmNzFiYzZm
NzAyZmJkNWU2ZjBmMjYwYjk4MjU4MGVhMjExMTg2Mi92bWxpbnV6LTMuMTAuMC1yYzItYmlz
ZWN0LTAwNTE2LWc2MmY3MWJjIGFscmVhZHkgZXhpc3RzOiBkdXBsaWNhdGUgY29tcGlsYXRp
b24/G1swbQoKMjAxMy0wNi0wMS0xMTozMDo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEw
LjAtcmMyLXBhZ2VvdXQtMDA1MTYtZzYyZjcxYmMgIzQzIAkwLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLiBURVNUIEZBSUxVUkUKcm06IGNhbm5vdCByZW1vdmUgYC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgyOC0wNTMwLzYyZjcxYmM2ZjcwMmZiZDVlNmYwZjI2MGI5ODI1ODBlYTIxMTE4
NjIvLnBpZCc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKQmlzZWN0aW5nOiAwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbMGZiMDA0
MGVkNjk3ZDJiMGZiZDQ4NDA0MmNkZWJiZTc2ZDI5YTg0MF0gdGlwYzogY29udmVydCBjb25m
aWd1cmF0aW9uIHNlcnZlciB0byB1c2UgbmV3IHNlcnZlciBmYWNpbGl0eQpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoK
MjAxMy0wNi0wMS0xMTo0MjoyNSAwZmIwMDQwZWQ2OTdkMmIwZmJkNDg0MDQyY2RlYmJlNzZk
MjlhODQwIGNvbXBpbGluZwo4NjQgcmVhbCAgMTg0NiB1c2VyICAxNjcgc3lzICAyMzMuMDgl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgyOC0wNTMwCgoyMDEzLTA2LTAxLTExOjU4OjA0IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzItcGFnZW91dC0wMDUxNS1nMGZiMDA0MCAj
NDQgCTAuLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQovYmluL3JtOiBjYW5ub3Qg
cmVtb3ZlIGAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC8wZmIwMDQwZWQ2OTdk
MmIwZmJkNDg0MDQyY2RlYmJlNzZkMjlhODQwLy5waWQnOiBObyBzdWNoIGZpbGUgb3IgZGly
ZWN0b3J5CjBmYjAwNDBlZDY5N2QyYjBmYmQ0ODQwNDJjZGViYmU3NmQyOWE4NDAgaXMgdGhl
IGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDBmYjAwNDBlZDY5N2QyYjBmYmQ0ODQwNDJjZGVi
YmU3NmQyOWE4NDAKQXV0aG9yOiBZaW5nIFh1ZSA8eWluZy54dWVAd2luZHJpdmVyLmNvbT4K
RGF0ZTogICBNb24gTWF5IDYgMjM6NTc6MTggMjAxMyAtMDQwMAoKICAgIHRpcGM6IGNvbnZl
cnQgY29uZmlndXJhdGlvbiBzZXJ2ZXIgdG8gdXNlIG5ldyBzZXJ2ZXIgZmFjaWxpdHkKICAg
IAogICAgQXMgdGhlIG5ldyBzb2NrZXQtYmFzZWQgVElQQyBzZXJ2ZXIgaW5mcmFzdHJ1Y3R1
cmUgaGFzIGJlZW4KICAgIGludHJvZHVjZWQsIHdlIGNhbiBub3cgY29udmVydCB0aGUgY29u
ZmlndXJhdGlvbiBzZXJ2ZXIgdG8gdXNlCiAgICBpdC4gIFRoZW4gd2UgY2FuIHRha2UgZnV0
dXJlIHN0ZXBzIHRvIHNpbXBsaWZ5IHRoZSBjb25maWd1cmF0aW9uCiAgICBzZXJ2ZXIgbG9j
a2luZyBwb2xpY3kuCiAgICAKICAgIFNvbWUgbWlub3IgcmVvcmRlcmluZyBvZiBpbml0aWFs
aXphdGlvbiBpcyBkb25lLCBkdWUgdG8gdGhlCiAgICBkZXBlbmRlbmN5IG9uIGhhdmluZyB0
aXBjX3NvY2tldF9pbml0IGNvbXBsZXRlZC4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogWWlu
ZyBYdWUgPHlpbmcueHVlQHdpbmRyaXZlci5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBKb24g
TWFsb3kgPGpvbi5tYWxveUBlcmljc3Nvbi5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBQYXVs
IEdvcnRtYWtlciA8cGF1bC5nb3J0bWFrZXJAd2luZHJpdmVyLmNvbT4KCjowNDAwMDAgMDQw
MDAwIGFiMTFhMWI4NzA1NzcxNDUxYzQ5N2RlMmRmYTJkNWZhZGFiNzJhMTMgYTgxMDU3ZTEw
YjQwNmQzODI5YjZhNDhkNmRkNjg3ODVmMTYwMjhiMSBNCW5ldApiaXNlY3QgcnVuIHN1Y2Nl
c3MKCjIwMTMtMDYtMDEtMTI6MDg6MDYgMzdmOGVkZjEwMTM1OWZjMjY3Y2U4ZDI4YjJiY2M2
NTM3NmNjZjE0ZCByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MjgtMDUzMC8zN2Y4
ZWRmMTAxMzU5ZmMyNjdjZThkMjhiMmJjYzY1Mzc2Y2NmMTRkL3ZtbGludXotMy4xMC4wLXJj
Mi1wYWdlb3V0LTAwNTE0LWczN2Y4ZWRmCgoyMDEzLTA2LTAxLTEyOjA4OjE2IGRldGVjdGlu
ZyBib290IHN0YXRlICAjNDQgCTAuLi4JMQk0CTUJNgk5LgkxMgkxMy4JMTYJMTcuCTIxLi4J
MjQJMjUuCTI2CTI5Li4JMzAgU1VDQ0VTUwoKMjAxMy0wNi0wMS0xMjoyMTo0NyBlZDc1YjIx
MDhkODZmZGQyMThmZDBhODliMGNjNDZhMzllZDZkNzI0IHJldXNlIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgyOC0wNTMwL2VkNzViMjEwOGQ4NmZkZDIxOGZkMGE4OWIwY2M0NmEzOWVk
NmQ3MjQvdm1saW51ei0zLjEwLjAtcmMzLTAwMjQ3LWdlZDc1YjIxCgoyMDEzLTA2LTAxLTEy
OjIxOjU3IGRldGVjdGluZyBib290IHN0YXRlICAjNDQgCTAuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFCkVSUk9SIyAx
OiAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0OjU5OiBtYWluOiAkQklTRUNUX1RFU1QgJEtCVUlM
RF9PVVRQVVQKSEVBRCBpcyBub3cgYXQgZWQ3NWIyMSBNZXJnZSByZW1vdGUtdHJhY2tpbmcg
YnJhbmNoICdwYXVsZy90aXBjX25ldC1uZXh0JyBpbnRvIGRldmVsLXhpYW4taTM4Ni0yMDEz
LTA1LTMxLTA0LTA4Cgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcg
bmV4dAoKMjAxMy0wNi0wMS0xNzoxODowOCAxNGQzNWQwMTRiZDgwNjg4NDgwMWQzMjI1OWVj
ZGFmODU3ZWYyNzZiIGNvbXBpbGluZwoKMjAxMy0wNi0wMS0xNzozOTozMSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEwLjAtcmMzLXBhZ2VvdXQtbmV4dC0yMDEzMDUzMSAjNDUgCTAuLi4J
NAkwLi4uCTUJNi4uLgk3CTguCTkuLi4JMTMJMTkJMjQJMjcuCTI5CTMwIFNVQ0NFU1MK

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=m
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=m
CONFIG_BPQETHER=y
CONFIG_SCC=y
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
# CONFIG_TEKRAM_DONGLE is not set
# CONFIG_TOIM3232_DONGLE is not set
# CONFIG_LITELINK_DONGLE is not set
# CONFIG_MA600_DONGLE is not set
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=m
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=m
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_MPL_DEBUG is not set
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_PN544=m
CONFIG_NFC_MICROREAD=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_SCx200_DOCFLASH is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=m
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=m
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=m
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
CONFIG_PNPBIOS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=m
CONFIG_BLK_DEV_UMC8672=m
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_EDEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=m
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_ISA=m
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ARCNET_COM20020_CS=m
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_LANCE=y
# CONFIG_PCNET32 is not set
CONFIG_PCMCIA_NMCLAN=m
# CONFIG_NI65 is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CIRRUS=y
CONFIG_CS89x0=m
CONFIG_CS89x0_PLATFORM=y
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC9194=y
CONFIG_PCMCIA_SMC91C92=m
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=m
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MDIO_BUS_MUX_MMIOREG=m
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPTP is not set
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_LIBERTAS_THINFIRM_USB=m
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
# CONFIG_PCMCIA_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
# CONFIG_BRCMSMAC is not set
CONFIG_BRCMFMAC=y
# CONFIG_BRCMFMAC_SDIO is not set
CONFIG_BRCMFMAC_USB=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=m
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_CS is not set
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=m
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCMCIA_HERMES is not set
CONFIG_PCMCIA_SPECTRUM=m
# CONFIG_ORINOCO_USB is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTLWIFI=m
# CONFIG_RTLWIFI_DEBUG is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
CONFIG_RTL8192CU=m
CONFIG_RTL8192C_COMMON=m
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
CONFIG_WL12XX=m
# CONFIG_WL18XX is not set
CONFIG_WLCORE=m
CONFIG_WLCORE_SDIO=m
# CONFIG_WILINK_PLATFORM_DATA is not set
CONFIG_ZD1211RW=y
CONFIG_ZD1211RW_DEBUG=y
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_GOLDFISH_EVENTS=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_EGALAX=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_HTCPEN is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
# CONFIG_TOUCHSCREEN_USB_E2I is not set
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_APBPS2 is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=m
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
CONFIG_SERIAL_8250_ACCENT=m
CONFIG_SERIAL_8250_BOCA=y
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
CONFIG_SERIAL_8250_HUB6=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=m
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_ADP5588=m
CONFIG_GPIO_ADNP=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_OLPC=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_FB_SSD1307 is not set
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=m
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_PS3REMOTE=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_DSPS=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=m
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_OMAP_CONTROL_USB=m
CONFIG_OMAP_USB3=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_R8A66597=m
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=m
CONFIG_USB_GADGET_MUSB_HDRC=m
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
# CONFIG_USB_G_MULTI_RNDIS is not set
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
CONFIG_USB_G_WEBCAM=m
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=m
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_GOLDFISH_PIPE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
CONFIG_EXYNOS_ADC=y
CONFIG_MAX1363=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_SENSORS_LM3533=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_VCNL4000 is not set
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--UlVJffcvxoiEqYs2--
