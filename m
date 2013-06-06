Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3FFCT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:19:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:61063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3FFCT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,810,1363158000"; 
   d="log'?scan'208";a="345534758"
Date: Thu, 6 Jun 2013 10:19:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Johannes Berg <johannes.berg@intel.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Pitt <martin.pitt@ubuntu.com>
Subject: [init_mac80211_hwsim] WARNING: at include/linux/kref.h:47
 kobject_get()
Message-ID: <20130606021941.GB17354@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below WARNING in linux-next and the first bad commit is

commit c07fe5ae0667f1077d671f62a093261223f918af
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Wed Apr 24 00:40:05 2013 -0400

    mac80211_hwsim: correctly register the platform driver
    
    Not registering a platform_driver would make us access garbage
    when the platform callbacks under driver_register() kicks in.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Tested-By: Martin Pitt <martin.pitt@ubuntu.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

[    5.303593] mac80211_hwsim: ieee80211_register_hw failed (-2)
[    5.314335] ------------[ cut here ]------------
[    5.317010] WARNING: at /c/kernel-tests/src/tip/include/linux/kref.h:47 kobject_get+0x73/0xb0()
[    5.333165] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-03384-g9f6f34a #31
[    5.337226]  0000000000000009 ffff88000d833d18 ffffffff826a10c3 ffff88000d833d58
[    5.345049]  ffffffff81094cde 0000000000000000 ffff880006f9e880 ffff88000d833fd8
[    5.353556]  ffffffff8377fa68 ffff88000d833fd8 ffffffff8299a900 ffff88000d833d68
[    5.362443] Call Trace:
[    5.363637]  [<ffffffff826a10c3>] dump_stack+0x27/0x30
[    5.368814]  [<ffffffff81094cde>] warn_slowpath_common+0x8e/0xd0
[    5.377018]  [<ffffffff81094e45>] warn_slowpath_null+0x25/0x30
[    5.384096]  [<ffffffff8160e413>] kobject_get+0x73/0xb0
[    5.386997]  [<ffffffff81923d82>] get_device+0x22/0x40
[    5.398294]  [<ffffffff819293c8>] driver_detach+0x98/0x1b0
[    5.408033]  [<ffffffff81927a9d>] bus_remove_driver+0xcd/0x160
[    5.411274]  [<ffffffff81929f20>] driver_unregister+0x90/0x100
[    5.414411]  [<ffffffff8192c115>] platform_driver_unregister+0x15/0x20
[    5.424777]  [<ffffffff839b5cc4>] init_mac80211_hwsim+0xe9b/0xeb3
[    5.433369]  [<ffffffff839b4e00>] ? ath9k_cmn_init+0xf/0xf
[    5.436394]  [<ffffffff839b4e29>] ? wil6210_driver_init+0x29/0x29
[    5.442718]  [<ffffffff8396f569>] do_one_initcall+0xb5/0x196
[    5.445681]  [<ffffffff8396f7fe>] kernel_init_freeable+0x1b4/0x2b7
[    5.448927]  [<ffffffff8396e9a6>] ? loglevel+0x46/0x46
[    5.456523]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.462635]  [<ffffffff82690411>] kernel_init+0x11/0x1b0
[    5.465539]  [<ffffffff826ba5fa>] ret_from_fork+0x7a/0xb0
[    5.473758]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.484169] ---[ end trace 01247b2b64952ffd ]---

Note: the parent commit suffers from a NULL pointer dereference BUG (2nd attached dmesg)
in the same init_mac80211_hwsim(). So it's not necessarily the problem
introduced by c07fe5ae0667. Anyway I'm reporting it to you in the hope that
you are (or can find) the most relevant people for looking into this problem.

git bisect start 9f6f34aebccbfb7de857e371e1fa9a0196c7be8e 246b3eda7e38835fad07c327b336f44f2e16b450 --
git bisect good 251df49db3327c64bf917bfdba94491fde2b4ee0  #    10  2013-06-05 21:56:19  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good 6eabb3301b1facee669d9938f7c5a0295c21d71d  #    10  2013-06-05 22:24:55  ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value
git bisect good 4de13d7aa8f4d02f4dc99d4609575659f92b3c5a  #    10  2013-06-05 22:41:34  Merge branch 'for-3.10/core' of git://git.kernel.dk/linux-block
git bisect good aef2ea912e0ee39fbca74fed0ab8e612ac2c3ba2  #    10  2013-06-05 23:06:54  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 5cc0c03823ca18c490f8223f85ed40f2a9d936c4  #    10  2013-06-05 23:26:35  Merge tag 'char-misc-3.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect  bad 27a24cfa04c6f041c0191847d047f25e5627cd63  #     0  2013-06-05 23:36:58  Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma
git bisect  bad eb3d33900aa953bcdfe132a71bb03ee592ebbb47  #     0  2013-06-06 00:03:44  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 326017c757e387007c6629797d7ae22fd33c1317  #     0  2013-06-06 00:43:50  perf: net_dropmonitor: Do not assume ordering of dictionaries
git bisect good 98962baad72fd6d393bf39dbb7c2076532c363c6  #    10  2013-06-06 00:54:10  8139cp: reset BQL when ring tx ring cleared
git bisect  bad d4988d4c733ba0b61cb372edd3d1992d26dd10d3  #     0  2013-06-06 01:10:37  bcma: add more core IDs
git bisect  bad 2b9ccd4e4308272e5aec614b77c5385e7ec2ec90  #     0  2013-06-06 01:19:36  mac80211: fix AP-mode frame matching
git bisect  bad b8360ab8d2caf8a4d0d95bc03f0ba6956459505f  #     0  2013-06-06 01:27:25  mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
git bisect  bad c07fe5ae0667f1077d671f62a093261223f918af  #     0  2013-06-06 01:35:52  mac80211_hwsim: correctly register the platform driver
git bisect good 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df  #    10  2013-06-06 03:04:01  cfg80211: fix wiphy_register error path
git bisect good 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df  #    30  2013-06-06 04:05:33  cfg80211: fix wiphy_register error path
git bisect  bad 9f6f34aebccbfb7de857e371e1fa9a0196c7be8e  #     0  2013-06-06 04:05:35  Merge remote-tracking branch 'stable/master'
git bisect good 10af2cd3c3c1cd8376126e3ffb6699c36032c7d0  #    30  2013-06-06 04:20:31  Revert "mac80211_hwsim: correctly register the platform driver"
git bisect  bad f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec  #     0  2013-06-06 04:24:57  Add linux-next specific files for 20130605

Thanks,
Fengguang

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-3711-20130605211017-3.10.0-rc3-03384-g9f6f34a-31"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.10.0-rc3-03384-g9f6f34a (kbuild@athens) (gcc=
 version 4.7.2 (Debian 4.7.2-4) ) #31 Wed Jun 5 19:37:22 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master/.=
vmlinuz-9f6f34aebccbfb7de857e371e1fa9a0196c7be8e-20130605193741-1-inn branc=
h=3Dsound-unstable/master  BOOT_IMAGE=3D/kernel/x86_64-randconfig-a00-0605/=
9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/vmlinuz-3.10.0-rc3-03384-g9f6f34a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04200000, 0x04200fff] PGTABLE
[    0.000000] BRK [0x04201000, 0x04201fff] PGTABLE
[    0.000000] BRK [0x04202000, 0x04202fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x04203000, 0x04203fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x04204000, 0x04204fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128276(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000=
001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3243f80
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:ma=
ster/.vmlinuz-9f6f34aebccbfb7de857e371e1fa9a0196c7be8e-20130605193741-1-inn=
 branch=3Dsound-unstable/master  BOOT_IMAGE=3D/kernel/x86_64-randconfig-a00=
-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/vmlinuz-3.10.0-rc3-03384-g9f=
6f34a
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 173376k/262136k available (23279k kernel code, 440k =
absent, 88320k reserved, 19111k data, 1100k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.456 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.91 Bogo=
MIPS (lpj=3D10773824)
[    0.009221] pid_max: default: 32768 minimum: 301
[    0.012198] Security Framework initialized
[    0.013599] Mount-cache hash table entries: 256
[    0.016251] mce: CPU supports 10 MCE banks
[    0.020018] mce: unknown CPU type - not enabling MCE support
[    0.024015] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.024015] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.024015] tlb_flushall_shift: -1
[    0.028014] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.080285] ACPI: Core revision 20130328
[    0.084024] ACPI: All ACPI Tables successfully acquired
[    0.092154] Performance Events: Getting VERSION: 50014
[    0.097149] Getting VERSION: 50014
[    0.099227] Getting ID: 0
[    0.100025] Getting ID: ff000000
[    0.101435] Getting LVT0: 8700
[    0.103045] Getting LVT1: 8400
[    0.104116] enabled ExtINT on CPU#0
[    0.109698] ENABLING IO-APIC IRQs
[    0.112119] init IO_APIC IRQs
[    0.116011]  apic 2 pin 0 not connected
[    0.117475] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.120047] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.124043] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.128045] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.132049] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.136035] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.139073] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.140041] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.144000] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.144051] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.148039] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.152000] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.152060] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.156043] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.160042] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.164041]  apic 2 pin 16 not connected
[    0.165383]  apic 2 pin 17 not connected
[    0.168008]  apic 2 pin 18 not connected
[    0.169384]  apic 2 pin 19 not connected
[    0.170876]  apic 2 pin 20 not connected
[    0.172010]  apic 2 pin 21 not connected
[    0.176014]  apic 2 pin 22 not connected
[    0.177603]  apic 2 pin 23 not connected
[    0.180226] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.184014] Using local APIC timer interrupts.
[    0.184014] calibrating APIC timer ...
[    0.192000] ... lapic delta =3D 6249565
[    0.192000] ... PM-Timer delta =3D 357938
[    0.192000] ... PM-Timer result ok
[    0.192000] ..... delta 6249565
[    0.192000] ..... mult: 268416772
[    0.192000] ..... calibration result: 3999721
[    0.192000] ..... CPU clock speed is 2693.1635 MHz.
[    0.192000] ..... host bus clock speed is 999.3721 MHz.
[    0.192190] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.198074] EVM: security.capability
[    0.200611] xor: measuring software checksum speed
[    0.244013]    prefetch64-sse:  8512.000 MB/sec
[    0.284013]    generic_sse:  7096.000 MB/sec
[    0.288013] xor: using function: prefetch64-sse (8512.000 MB/sec)
[    0.292181] regulator-dummy: no parameters
[    0.296095] NET: Registered protocol family 16
[    0.300863] ACPI: bus type PCI registered
[    0.304058] dca service started, version 1.12.1
[    0.308099] PCI: Using configuration type 1 for base access
[    0.331907] bio: create slab <bio-0> at 0
[    0.400424] raid6: sse2x1    1003 MB/s
[    0.472024] raid6: sse2x2    1269 MB/s
[    0.544036] raid6: sse2x4     962 MB/s
[    0.546386] raid6: using algorithm sse2x2 (1269 MB/s)
[    0.548013] raid6: using intx1 recovery algorithm
[    0.552000] ACPI: Added _OSI(Module Device)
[    0.552010] ACPI: Added _OSI(Processor Device)
[    0.553931] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.556017] ACPI: Added _OSI(Processor Aggregator Device)
[    0.560188] ACPI: EC: Look up EC in DSDT
[    0.573474] ACPI: Interpreter enabled
[    0.576018] ACPI: (supports S0 S5)
[    0.580014] ACPI: Using IOAPIC for interrupt routing
[    0.584067] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.607395] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.608133] PCI host bridge to bus 0000:00
[    0.612022] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.615885] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.616022] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.620020] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.624017] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.628000] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.632090] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.636698] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.648297] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.655800] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.660159] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.664049] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.668437] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.680114] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.689714] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.710291] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.717011] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.720992] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.728427] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.737278] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.744979] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.749004] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.752962] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.760000] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.760117] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.768659] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.776019] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.794109] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.797098] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.804527] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.820470] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.825110] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.828956] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.836320] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.841683] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.844000] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.844116] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.850096] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.853003] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.872574] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.880489] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.885642] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.892155] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.896944] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.904554] pci_bus 0000:00: on NUMA node 0
[    0.912029] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.920009] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.928344] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.940183] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.944658] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.952416] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.960097] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.966589] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.968026] acpi root: \_SB_.PCI0 notify handler is installed
[    0.972059] Found 1 acpi root devices
[    0.981544] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.984016] vgaarb: loaded
[    0.985536] vgaarb: bridge control possible 0000:00:02.0
[    0.996346] tps65010: version 2 May 2005
[    1.036126] tps65010: no chip?
[    1.038574] SCSI subsystem initialized
[    1.040049] ACPI: bus type ATA registered
[    1.044214] libata version 3.00 loaded.
[    1.048258] pps_core: LinuxPPS API ver. 1 registered
[    1.052017] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.056070] PTP clock support registered
[    1.064096] EDAC MC: Ver: 3.0.0
[    1.068751] PCI: Using ACPI for IRQ routing
[    1.071262] PCI: pci_cache_line_size set to 64 bytes
[    1.080310] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.083765] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.092090] irda_init()
[    1.096166] NET: Registered protocol family 23
[    1.102624] cfg80211: Calling CRDA to update world regulatory domain
[    1.104208] nfc: nfc_init: NFC Core ver 0.1
[    1.108119] NET: Registered protocol family 39
[    1.117032] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.120063] Switching to clocksource kvm-clock
[    1.124259] FS-Cache: Loaded
[    1.125553] CacheFiles: Loaded
[    1.132719] pnp: PnP ACPI init
[    1.135767] ACPI: bus type PNP registered
[    1.138432] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.151337] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.155067] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.163823] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.167709] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.179920] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.184989] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.194684] pnp 00:03: [dma 2]
[    1.196873] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.203642] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.211551] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.215541] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.221317] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.225644] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.243425] pnp: PnP ACPI: found 7 devices
[    1.250495] ACPI: bus type PNP unregistered
[    1.258105] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    1.276675] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.285456] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.305349] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.316640] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.326249] NET: Registered protocol family 1
[    1.333604] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.352967] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.359889] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.374047] pci 0000:00:02.0: Boot video device
[    1.379835] PCI: CLS 0 bytes, default 64
[    1.385749] Unpacking initramfs...
[    3.973054] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    4.134232] DMA-API: preallocated 65536 debug entries
[    4.139993] DMA-API: debugging enabled by kernel config
[    4.146376] Machine check injector initialized
[    4.155082] cryptomgr_test (21) used greatest stack depth: 6608 bytes le=
ft
[    4.161408] cryptomgr_test (23) used greatest stack depth: 5760 bytes le=
ft
[    4.182377] cryptomgr_test (43) used greatest stack depth: 5696 bytes le=
ft
[    4.187959] PCLMULQDQ-NI instructions are not detected.
[    4.197699] AVX instructions are not detected.
[    4.204295] AVX instructions are not detected.
[    4.206679] AVX instructions are not detected.
[    4.213970] AVX instructions are not detected.
[    4.216454] AVX2 instructions are not detected.
[    4.220220] AVX2 instructions are not detected.
[    4.223940] AVX2 instructions are not detected.
[    4.233380] audit: initializing netlink socket (disabled)
[    4.236072] type=3D2000 audit(1370437794.236:1): initialized
[    4.239556] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    4.276172] bounce pool size: 64 pages
[    4.282472] VFS: Disk quotas dquot_6.5.2
[    4.293479] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.298867] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    4.307647] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    4.314572] jffs2: version 2.2. (NAND) (SUMMARY) =20
[    4.320818] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.327587] QNX4 filesystem 0.2.3 registered.
[    4.333980] QNX6 filesystem 1.0.0 registered.
[    4.336110] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    4.347941] NILFS version 2 loaded
[    4.354895] BeFS version: 0.9.3
[    4.356622] OCFS2 1.5.0
[    4.359694] ocfs2 stack glue: unable to register sysctl
[    4.362426] ocfs2: Registered cluster interface o2cb
[    4.365053] OCFS2 DLMFS 1.5.0
[    4.366807] OCFS2 User DLM kernel interface loaded
[    4.375604] OCFS2 Node Manager 1.5.0
[    4.378307] OCFS2 DLM 1.5.0
[    4.387670] alg: No test for crc32 (crc32-table)
[    4.390582] alg: No test for stdrng (krng)
[    4.400967] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.404118] NET: Registered protocol family 38
[    4.406538] async_tx: api initialized (async)
[    4.409019] Key type asymmetric registered
[    4.414368] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    4.418543] io scheduler noop registered
[    4.420645] io scheduler cfq registered (default)
[    4.423119] test_string_helpers: Running tests...
[    4.426160] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    4.428819] crc32: self tests passed, processed 225944 bytes in 190068 n=
sec
[    4.435970] crc32c: CRC_LE_BITS =3D 64
[    4.437827] crc32c: self tests passed, processed 225944 bytes in 89429 n=
sec
[    4.445084] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.447911] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.455420] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.462893] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.466909] vmlfb: initializing
[    4.468713] no IO addresses supplied
[    4.473517] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.477439] ACPI: Power Button [PWRF]
[    4.484354] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.514760] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.571221] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.575120] lp: driver loaded but no devices found
[    4.584094] ppdev: user-space parallel port driver
[    4.586729] Linux agpgart interface v0.103
[    4.593749] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.598196] Hangcheck: Using getrawmonotonic().
[    4.604645] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    4.608517] parport_pc 00:04: reported by Plug and Play ACPI
[    4.616072] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    4.624078] lp0: using parport0 (interrupt-driven).
[    4.626644] lp0: console ready
[    4.628861] dummy-irq: no IRQ given.  Use irq=3DN
[    4.633531] Phantom Linux Driver, version n0.9.8, init OK
[    4.637385] Driver for timberdale has been successfully registered.
[    4.646358] Loading iSCSI transport class v2.0-870.
[    4.654013] rdac: device handler registered
[    4.656609] emc: device handler registered
[    4.658865] alua: device handler registered
[    4.665839] fnic: Cisco FCoE HBA Driver, ver 1.5.0.22
[    4.668851] fnic: Successfully Initialized Trace Buffer
[    4.676079] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.678985] Detecting Adaptec I2O RAID controllers...
[    4.683921] Adaptec aacraid driver 1.2-0[30200]-ms
[    4.686869] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.694066] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    4.703894] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.05.00.03-k.
[    4.708777] iscsi: registered transport (qla4xxx)
[    4.715562] QLogic iSCSI HBA Driver
[    4.717531] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[    4.725234] DC390: clustering now enabled by default. If you get problem=
s load
[    4.733238]        with "disable_clustering=3D1" and report to maintaine=
rs
[    4.737315] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.742859] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    4.746463] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    4.755542] ppa: Version 2.07 (for Linux 2.4.x)
[    4.763600] imm: Version 2.05 (for Linux 2.4.0)
[    4.767196] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    4.774963] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.777663] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    4.786957] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[    4.793182] iscsi: registered transport (bnx2i)
[    4.795734] iscsi: registered transport (be2iscsi)
[    4.798355] In beiscsi_module_init, tt=3Dffffffff83621240
[    4.804684] VMware PVSCSI driver - version 1.0.2.0-k
[    4.807356] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.816765] osst :I: Tape driver with OnStream support version 0.99.4
[    4.816765] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.826118] osd: LOADED open-osd 0.2.1
[    4.835235] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.843954] SSFDC read-only Flash Translation layer
[    4.848777] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    4.856837] device id =3D 2440
[    4.858360] device id =3D 2480
[    4.861716] device id =3D 24c0
[    4.865415] device id =3D 24d0
[    4.867100] device id =3D 25a1
[    4.870291] device id =3D 2670
[    4.874166] platform physmap-flash.0: failed to claim resource 0
[    4.883317] Could not find PAR responsible for SC520CDP Flash Bank #0
[    4.886731] Trying default address 0x8400000
[    4.894275] Could not find PAR responsible for SC520CDP Flash Bank #1
[    4.897804] Trying default address 0x8c00000
[    4.905029] Could not find PAR responsible for SC520CDP DIL Flash
[    4.908273] Trying default address 0x9400000
[    4.914888] SC520 CDP flash device: 0x800000 at 0x8400000
[    4.917604] Failed to ioremap_nocache
[    4.924665] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.928142] slram: not enough parameters.
[    4.934679] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    4.943758] pmc551: not detected
[    4.948373] ftl_cs: FTL header not found.
[    4.976606] libphy: Fixed MDIO Bus: probed
[    4.989011] tun: Universal TUN/TAP device driver, 1.6
[    4.996669] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.005543] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    5.020604] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05=
, 2012)
[    5.024994] vxge: Copyright(c) 2002-2010 Exar Corp.
[    5.043558] vxge: Driver version: 2.5.3.22640-k
[    5.046409] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.056320] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.064585] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.067818] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    5.073525] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    5.085589] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    5.089048] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.13.10-k
[    5.097292] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    5.105065] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.7.12-k
[    5.115387] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    5.124109] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    5.136037] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[    5.143046] Solarflare NET driver v3.2
[    5.148472] tlan: ThunderLAN driver v1.17
[    5.155220] tlan: 0 devices installed, PCI: 0  EISA: 0
[    5.166322] w83977af_init()
[    5.167967] w83977af_open()
[    5.171890] w83977af_probe()
[    5.173755] w83977af_probe(), Wrong chip version
[    5.179099] w83977af_probe()
[    5.187978] w83977af_probe(), Wrong chip version
[    5.193893] PPP generic driver version 2.4.2
[    5.196846] PPP BSD Compression module registered
[    5.216486] PPP Deflate Compression module registered
[    5.222934] PPP MPPE Compression module registered
[    5.225512] NET: Registered protocol family 24
[    5.234605] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    5.238492] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    5.248036] libipw: Unable to create ieee80211 proc directory
[    5.253864] Broadcom 43xx driver loaded [ Features: PL ]
[    5.266167] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    5.275216] mac80211_hwsim: Initializing radio 0
[    5.286559] ieee80211 phy0: Failed to select rate control algorithm
[    5.294314] ieee80211 phy0: Failed to initialize rate control algorithm
[    5.303593] mac80211_hwsim: ieee80211_register_hw failed (-2)
[    5.314335] ------------[ cut here ]------------
[    5.317010] WARNING: at /c/kernel-tests/src/tip/include/linux/kref.h:47 =
kobject_get+0x73/0xb0()
[    5.333165] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-03384-g9f=
6f34a #31
[    5.337226]  0000000000000009 ffff88000d833d18 ffffffff826a10c3 ffff8800=
0d833d58
[    5.345049]  ffffffff81094cde 0000000000000000 ffff880006f9e880 ffff8800=
0d833fd8
[    5.353556]  ffffffff8377fa68 ffff88000d833fd8 ffffffff8299a900 ffff8800=
0d833d68
[    5.362443] Call Trace:
[    5.363637]  [<ffffffff826a10c3>] dump_stack+0x27/0x30
[    5.368814]  [<ffffffff81094cde>] warn_slowpath_common+0x8e/0xd0
[    5.377018]  [<ffffffff81094e45>] warn_slowpath_null+0x25/0x30
[    5.384096]  [<ffffffff8160e413>] kobject_get+0x73/0xb0
[    5.386997]  [<ffffffff81923d82>] get_device+0x22/0x40
[    5.398294]  [<ffffffff819293c8>] driver_detach+0x98/0x1b0
[    5.408033]  [<ffffffff81927a9d>] bus_remove_driver+0xcd/0x160
[    5.411274]  [<ffffffff81929f20>] driver_unregister+0x90/0x100
[    5.414411]  [<ffffffff8192c115>] platform_driver_unregister+0x15/0x20
[    5.424777]  [<ffffffff839b5cc4>] init_mac80211_hwsim+0xe9b/0xeb3
[    5.433369]  [<ffffffff839b4e00>] ? ath9k_cmn_init+0xf/0xf
[    5.436394]  [<ffffffff839b4e29>] ? wil6210_driver_init+0x29/0x29
[    5.442718]  [<ffffffff8396f569>] do_one_initcall+0xb5/0x196
[    5.445681]  [<ffffffff8396f7fe>] kernel_init_freeable+0x1b4/0x2b7
[    5.448927]  [<ffffffff8396e9a6>] ? loglevel+0x46/0x46
[    5.456523]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.462635]  [<ffffffff82690411>] kernel_init+0x11/0x1b0
[    5.465539]  [<ffffffff826ba5fa>] ret_from_fork+0x7a/0xb0
[    5.473758]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.484169] ---[ end trace 01247b2b64952ffd ]---
[    5.487075] ------------[ cut here ]------------
[    5.491788] WARNING: at /c/kernel-tests/src/tip/fs/sysfs/inode.c:324 sys=
fs_hash_and_remove+0x44/0x100()
[    5.497589] sysfs: can not remove 'driver', no directory
[    5.505841] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.10.0-rc=
3-03384-g9f6f34a #31
[    5.512624]  0000000000000009 ffff88000d833c68 ffffffff826a10c3 ffff8800=
0d833ca8
[    5.516572]  ffffffff81094cde ffff88000d833ca8 0000000000000000 ffffffff=
8310389c
[    5.525407]  ffffffff8377fa68 ffff88000d833fd8 ffff880006f9e8e0 ffff8800=
0d833d08
[    5.531560] Call Trace:
[    5.532882]  [<ffffffff826a10c3>] dump_stack+0x27/0x30
[    5.535695]  [<ffffffff81094cde>] warn_slowpath_common+0x8e/0xd0
[    5.544434]  [<ffffffff81094db1>] warn_slowpath_fmt+0x51/0x60
[    5.552785]  [<ffffffff811e4874>] sysfs_hash_and_remove+0x44/0x100
[    5.556214]  [<ffffffff811e89b1>] sysfs_remove_link+0x31/0x40
[    5.566268]  [<ffffffff819289fd>] driver_sysfs_remove+0x4d/0x60
[    5.573841]  [<ffffffff8192921f>] __device_release_driver+0x2f/0x140
[    5.577239]  [<ffffffff81929457>] driver_detach+0x127/0x1b0
[    5.583313]  [<ffffffff81927a9d>] bus_remove_driver+0xcd/0x160
[    5.587306]  [<ffffffff81929f20>] driver_unregister+0x90/0x100
[    5.590510]  [<ffffffff8192c115>] platform_driver_unregister+0x15/0x20
[    5.603724]  [<ffffffff839b5cc4>] init_mac80211_hwsim+0xe9b/0xeb3
[    5.606896]  [<ffffffff839b4e00>] ? ath9k_cmn_init+0xf/0xf
[    5.614650]  [<ffffffff839b4e29>] ? wil6210_driver_init+0x29/0x29
[    5.617786]  [<ffffffff8396f569>] do_one_initcall+0xb5/0x196
[    5.625014]  [<ffffffff8396f7fe>] kernel_init_freeable+0x1b4/0x2b7
[    5.628385]  [<ffffffff8396e9a6>] ? loglevel+0x46/0x46
[    5.631353]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.639704]  [<ffffffff82690411>] kernel_init+0x11/0x1b0
[    5.646668]  [<ffffffff826ba5fa>] ret_from_fork+0x7a/0xb0
[    5.653214]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.656207] ---[ end trace 01247b2b64952ffe ]---
[    5.663475] BUG: unable to handle kernel paging request at ffff880006fab=
4a0
[    5.666803] IP: [<ffffffff81162328>] slob_page_alloc+0x38/0x3c0
[    5.666803] PGD 4200067 PUD 4201067 PMD e7b7067 PTE 8000000006fab060
[    5.666803] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    5.666803] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.10.0-rc=
3-03384-g9f6f34a #31
[    5.666803] task: ffff88000d826810 ti: ffff88000d832000 task.ti: ffff880=
00d832000
[    5.666803] RIP: 0010:[<ffffffff81162328>]  [<ffffffff81162328>] slob_pa=
ge_alloc+0x38/0x3c0
[    5.666803] RSP: 0000:ffff88000d833938  EFLAGS: 00010002
[    5.666803] RAX: ffff880006fab4a0 RBX: ffff88000d541840 RCX: ffff880006f=
ab4a0
[    5.666803] RDX: 0000000000000008 RSI: 0000000000000038 RDI: fffffffffff=
ffff8
[    5.666803] RBP: ffff88000d833978 R08: ffff880006fa1868 R09: ffff880006f=
a1000
[    5.666803] R10: 0000000000000038 R11: 0000000000000000 R12: 00000000000=
00007
[    5.666803] R13: 0000000000000038 R14: ffff880006fa1868 R15: 00000000000=
00001
[    5.666803] FS:  0000000000000000(0000) GS:ffffffff8322d000(0000) knlGS:=
0000000000000000
[    5.666803] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.666803] CR2: ffff880006fab4a0 CR3: 0000000003212000 CR4: 00000000000=
006b0
[    5.666803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    5.666803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    5.666803] Stack:
[    5.666803]  0000000000000007 000000000000000d ffff88000d8339a8 ffff8800=
0d541840
[    5.666803]  ffffffff832bae20 ffffffff832bae20 0000000000000038 00000000=
00000070
[    5.666803]  ffff88000d8339d8 ffffffff81162797 00000000000000d0 00000000=
00000005
[    5.666803] Call Trace:
[    5.666803]  [<ffffffff81162797>] slob_alloc.isra.16+0xe7/0x440
[    5.666803]  [<ffffffff8116353f>] kmem_cache_alloc_node+0x2f/0xb0
[    5.666803]  [<ffffffff811e6fc6>] sysfs_new_dirent+0x86/0x1e0
[    5.666803]  [<ffffffff8160d43c>] ? ida_get_new_above+0x27c/0x3b0
[    5.666803]  [<ffffffff811e76a6>] create_dir+0x46/0x140
[    5.666803]  [<ffffffff811e7c7a>] sysfs_create_dir+0x15a/0x190
[    5.666803]  [<ffffffff8160eca4>] kobject_add_internal+0x1a4/0x3a0
[    5.666803]  [<ffffffff8160ef0d>] kobject_add_varg+0x6d/0x90
[    5.666803]  [<ffffffff8160ef93>] kobject_init_and_add+0x63/0x80
[    5.666803]  [<ffffffff824ec612>] netdev_queue_update_kobjects+0x72/0x1a0
[    5.666803]  [<ffffffff824ec8fc>] netdev_register_kobject+0x13c/0x1b0
[    5.666803]  [<ffffffff824d0cc0>] register_netdevice+0x4d0/0x500
[    5.666803]  [<ffffffff824d0d19>] register_netdev+0x29/0x50
[    5.666803]  [<ffffffff821fa86a>] ieee802154fake_probe+0x14a/0x1b0
[    5.666803]  [<ffffffff8192b1ca>] platform_drv_probe+0x1a/0x30
[    5.666803]  [<ffffffff819296c6>] driver_probe_device+0x166/0x340
[    5.666803]  [<ffffffff8192996a>] __driver_attach+0xca/0x140
[    5.666803]  [<ffffffff819298a0>] ? driver_probe_device+0x340/0x340
[    5.666803]  [<ffffffff81926939>] bus_for_each_dev+0x99/0xf0
[    5.666803]  [<ffffffff81929141>] driver_attach+0x21/0x30
[    5.666803]  [<ffffffff81927728>] bus_add_driver+0x128/0x3d0
[    5.666803]  [<ffffffff839b5cdc>] ? init_mac80211_hwsim+0xeb3/0xeb3
[    5.666803]  [<ffffffff8192a128>] driver_register+0x128/0x250
[    5.666803]  [<ffffffff8192bbf9>] ? platform_device_add+0x239/0x310
[    5.666803]  [<ffffffff839b5cdc>] ? init_mac80211_hwsim+0xeb3/0xeb3
[    5.666803]  [<ffffffff8192c0f1>] platform_driver_register+0x61/0x70
[    5.666803]  [<ffffffff839b5d46>] fake_init+0x6a/0x73
[    5.666803]  [<ffffffff821f52f0>] ? mwifiex_pcie_cleanup+0x100/0x100
[    5.666803]  [<ffffffff8396f569>] do_one_initcall+0xb5/0x196
[    5.666803]  [<ffffffff8396f7fe>] kernel_init_freeable+0x1b4/0x2b7
[    5.666803]  [<ffffffff8396e9a6>] ? loglevel+0x46/0x46
[    5.666803]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.666803]  [<ffffffff82690411>] kernel_init+0x11/0x1b0
[    5.666803]  [<ffffffff826ba5fa>] ret_from_fork+0x7a/0xb0
[    5.666803]  [<ffffffff82690400>] ? rest_init+0xd0/0xd0
[    5.666803] Code: 56 45 31 f6 41 55 4c 8d 6e 01 41 54 49 d1 ed 44 89 ee =
53 48 89 fb 48 83 ec 18 48 8b 47 10 48 63 fa 4c 8d 67 ff 48 f7 df 0f 1f 00 =
<0f> b7 08 66 85 c9 7e 18 48 83 05 28 eb 9e 02 01 44 0f bf c9 41=20
[    5.666803] RIP  [<ffffffff81162328>] slob_page_alloc+0x38/0x3c0
[    5.666803]  RSP <ffff88000d833938>
[    5.666803] CR2: ffff880006fab4a0
[    5.666803] ---[ end trace 01247b2b64952fff ]---
[    5.666803] Kernel panic - not syncing: Fatal exception
[    5.666803] Rebooting in 10 seconds..
--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="9f6f34aebccbfb7de857e371e1fa9a0196c7be8e-bisect.log"

git checkout 246b3eda7e38835fad07c327b336f44f2e16b450
Previous HEAD position was 9f6f34a... Merge remote-tracking branch 'stable/master'
HEAD is now at 246b3ed... Reverted the test/hda-hp-mic branch
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:246b3eda7e38835fad07c327b336f44f2e16b450:bisect-linux-drm

2013-06-05-21:16:41 246b3eda7e38835fad07c327b336f44f2e16b450 compiling
270 real  2105 user  162 sys  838.69% cpu 	x86_64-randconfig-a00-0605

2013-06-05-21:21:42 detecting boot state 3.9.0-rc1-03189-g246b3ed...............	1.	2	3.	4.	5..	6.........	7	10 SUCCESS

bisect: good commit 246b3eda7e38835fad07c327b336f44f2e16b450
git bisect start 9f6f34aebccbfb7de857e371e1fa9a0196c7be8e 246b3eda7e38835fad07c327b336f44f2e16b450 --
Previous HEAD position was 246b3ed... Reverted the test/hda-hp-mic branch
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 8468 revisions left to test after this (roughly 13 steps)
[251df49db3327c64bf917bfdba94491fde2b4ee0] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:251df49db3327c64bf917bfdba94491fde2b4ee0:bisect-linux-drm

2013-06-05-21:40:20 251df49db3327c64bf917bfdba94491fde2b4ee0 compiling
281 real  2157 user  156 sys  821.32% cpu 	x86_64-randconfig-a00-0605

2013-06-05-21:45:19 detecting boot state 3.9.0-05355-g251df49..	3	4	6	8..............	9	10 SUCCESS

Bisecting: 4348 revisions left to test after this (roughly 12 steps)
[6eabb3301b1facee669d9938f7c5a0295c21d71d] ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:6eabb3301b1facee669d9938f7c5a0295c21d71d:bisect-linux-drm

2013-06-05-21:56:22 6eabb3301b1facee669d9938f7c5a0295c21d71d compiling
259 real  2203 user  168 sys  914.63% cpu 	x86_64-randconfig-a00-0605

2013-06-05-22:00:55 detecting boot state 3.9.0-09478-g6eabb33.	1.............	2...	3.	4.............	5	6.	7	8..	9....	10 SUCCESS

Bisecting: 2205 revisions left to test after this (roughly 11 steps)
[4de13d7aa8f4d02f4dc99d4609575659f92b3c5a] Merge branch 'for-3.10/core' of git://git.kernel.dk/linux-block
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:4de13d7aa8f4d02f4dc99d4609575659f92b3c5a:bisect-linux-drm

2013-06-05-22:24:58 4de13d7aa8f4d02f4dc99d4609575659f92b3c5a compiling
258 real  2205 user  169 sys  917.96% cpu 	x86_64-randconfig-a00-0605

2013-06-05-22:29:33 detecting boot state 3.9.0-11615-g4de13d7.	1	2.	3..	5....	6.....	7	8	9..	10 SUCCESS

Bisecting: 1102 revisions left to test after this (roughly 10 steps)
[aef2ea912e0ee39fbca74fed0ab8e612ac2c3ba2] Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:aef2ea912e0ee39fbca74fed0ab8e612ac2c3ba2:bisect-linux-drm

2013-06-05-22:41:36 aef2ea912e0ee39fbca74fed0ab8e612ac2c3ba2 compiling
275 real  2280 user  171 sys  889.48% cpu 	x86_64-randconfig-a00-0605

2013-06-05-22:46:23 detecting boot state 3.10.0-rc1-00003-gaef2ea9.	2..........	3....	4.	5	6.	7.....	9...........	10 SUCCESS

Bisecting: 550 revisions left to test after this (roughly 9 steps)
[5cc0c03823ca18c490f8223f85ed40f2a9d936c4] Merge tag 'char-misc-3.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:5cc0c03823ca18c490f8223f85ed40f2a9d936c4:bisect-linux-drm

2013-06-05-23:06:56 5cc0c03823ca18c490f8223f85ed40f2a9d936c4 compiling
266 real  2265 user  178 sys  918.05% cpu 	x86_64-randconfig-a00-0605

2013-06-05-23:11:34 detecting boot state 3.10.0-rc2-00159-g5cc0c03...	2.........	4...	5	7.	8......	9.	10 SUCCESS

Bisecting: 276 revisions left to test after this (roughly 8 steps)
[27a24cfa04c6f041c0191847d047f25e5627cd63] Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:27a24cfa04c6f041c0191847d047f25e5627cd63:bisect-linux-drm

2013-06-05-23:26:37 27a24cfa04c6f041c0191847d047f25e5627cd63 compiling
278 real  2262 user  179 sys  876.22% cpu 	x86_64-randconfig-a00-0605

2013-06-05-23:31:28 detecting boot state 3.10.0-rc2-00433-g27a24cf........... TEST FAILURE
dmesg-kvm-waimea-3900-20130605233948-3.10.0-rc2-00433-g27a24cf-26

Bisecting: 118 revisions left to test after this (roughly 7 steps)
[eb3d33900aa953bcdfe132a71bb03ee592ebbb47] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:eb3d33900aa953bcdfe132a71bb03ee592ebbb47:bisect-linux-drm

2013-06-05-23:36:59 eb3d33900aa953bcdfe132a71bb03ee592ebbb47 compiling
274 real  2278 user  178 sys  895.10% cpu 	x86_64-randconfig-a00-0605

2013-06-05-23:41:44 detecting boot state 3.10.0-rc2-00314-geb3d339............................................ TEST FAILURE
dmesg-kvm-snb-45298-20130606000634-3.10.0-rc2-00314-geb3d339-27

Bisecting: 77 revisions left to test after this (roughly 6 steps)
[326017c757e387007c6629797d7ae22fd33c1317] perf: net_dropmonitor: Do not assume ordering of dictionaries
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:326017c757e387007c6629797d7ae22fd33c1317:bisect-linux-drm

2013-06-06-00:03:45 326017c757e387007c6629797d7ae22fd33c1317 compiling
264 real  2260 user  181 sys  923.20% cpu 	x86_64-randconfig-a00-0605

2013-06-06-00:08:20 detecting boot state 3.10.0-rc1-00156-g326017c....................................................................... TEST FAILURE
dmesg-kvm-vp-33623-20130606004539-3.10.0-rc1-00156-g326017c-28

Bisecting: 38 revisions left to test after this (roughly 5 steps)
[98962baad72fd6d393bf39dbb7c2076532c363c6] 8139cp: reset BQL when ring tx ring cleared
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:98962baad72fd6d393bf39dbb7c2076532c363c6:bisect-linux-drm

2013-06-06-00:43:52 98962baad72fd6d393bf39dbb7c2076532c363c6 compiling
299 real  2271 user  181 sys  820.38% cpu 	x86_64-randconfig-a00-0605

2013-06-06-00:49:10 detecting boot state 3.10.0-rc1-00117-g98962ba.	1	2	3..	4	6	7	10 SUCCESS

Bisecting: 19 revisions left to test after this (roughly 4 steps)
[d4988d4c733ba0b61cb372edd3d1992d26dd10d3] bcma: add more core IDs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:d4988d4c733ba0b61cb372edd3d1992d26dd10d3:bisect-linux-drm

2013-06-06-00:54:11 d4988d4c733ba0b61cb372edd3d1992d26dd10d3 compiling
302 real  2280 user  184 sys  815.50% cpu 	x86_64-randconfig-a00-0605

2013-06-06-00:59:37 detecting boot state 3.9.0-12346-gd4988d4...................... TEST FAILURE
dmesg-kvm-vp-32733-20130606011245-3.9.0-12346-gd4988d4-30

Bisecting: 9 revisions left to test after this (roughly 3 steps)
[2b9ccd4e4308272e5aec614b77c5385e7ec2ec90] mac80211: fix AP-mode frame matching
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:2b9ccd4e4308272e5aec614b77c5385e7ec2ec90:bisect-linux-drm

2013-06-06-01:10:39 2b9ccd4e4308272e5aec614b77c5385e7ec2ec90 compiling
256 real  2230 user  185 sys  941.89% cpu 	x86_64-randconfig-a00-0605

2013-06-06-01:15:06 detecting boot state 3.9.0-12336-g2b9ccd4......... TEST FAILURE
dmesg-kvm-xian-50350-20130606012013-3.9.0-12336-g2b9ccd4-31

Bisecting: 4 revisions left to test after this (roughly 2 steps)
[b8360ab8d2caf8a4d0d95bc03f0ba6956459505f] mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:b8360ab8d2caf8a4d0d95bc03f0ba6956459505f:bisect-linux-drm

2013-06-06-01:19:37 b8360ab8d2caf8a4d0d95bc03f0ba6956459505f compiling
308 real  2266 user  184 sys  794.72% cpu 	x86_64-randconfig-a00-0605

2013-06-06-01:24:55 detecting boot state 3.9.0-12331-gb8360ab..... TEST FAILURE
dmesg-kvm-athens-25089-20130606012734-3.9.0-12331-gb8360ab-32
dmesg-kvm-roam-23533-20130606012742-3.9.0-12331-gb8360ab-32
dmesg-kvm-waimea-3671-20130606013015-3.9.0-12331-gb8360ab-32

Bisecting: 1 revision left to test after this (roughly 1 step)
[c07fe5ae0667f1077d671f62a093261223f918af] mac80211_hwsim: correctly register the platform driver
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:c07fe5ae0667f1077d671f62a093261223f918af:bisect-linux-drm

2013-06-06-01:27:26 c07fe5ae0667f1077d671f62a093261223f918af compiling
256 real  2260 user  183 sys  952.32% cpu 	x86_64-randconfig-a00-0605

2013-06-06-01:31:52 detecting boot state 3.9.0-12329-gc07fe5a........ TEST FAILURE
dmesg-kvm-roam-30629-20130606013555-3.9.0-12329-gc07fe5a-33

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[03cd7e4e1ea16cd151c799a33b5ca1fd41a464df] cfg80211: fix wiphy_register error path
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:03cd7e4e1ea16cd151c799a33b5ca1fd41a464df:bisect-linux-drm

2013-06-06-01:35:54 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df compiling
259 real  2231 user  188 sys  932.22% cpu 	x86_64-randconfig-a00-0605

2013-06-06-01:40:24 detecting boot state 3.9.0-12328-g03cd7e4.	1	2......................................................................	3...	4...............	5......................................................	6..........	9......	10 SUCCESS

c07fe5ae0667f1077d671f62a093261223f918af is the first bad commit
commit c07fe5ae0667f1077d671f62a093261223f918af
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Wed Apr 24 00:40:05 2013 -0400

    mac80211_hwsim: correctly register the platform driver
    
    Not registering a platform_driver would make us access garbage
    when the platform callbacks under driver_register() kicks in.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Tested-By: Martin Pitt <martin.pitt@ubuntu.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

:040000 040000 27b16a8b5460932ce3811a171c62b051b31313dd 50b965d5fc981b52183e65669615f60741eb7691 M	drivers
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:03cd7e4e1ea16cd151c799a33b5ca1fd41a464df:bisect-linux-drm

2013-06-06-03:04:03 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df reuse /kernel/x86_64-randconfig-a00-0605/03cd7e4e1ea16cd151c799a33b5ca1fd41a464df/vmlinuz-3.9.0-12328-g03cd7e4

2013-06-06-03:04:03 detecting boot state .............	1.........................	2.............	3.............................	4..	5.............	6........	8.	9	11	12	13.	14	17.	18	21	27	30 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:9f6f34aebccbfb7de857e371e1fa9a0196c7be8e:bisect-linux-drm
 TEST FAILURE
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-athens-28071-20130605213251-3.10.0-rc3-03384-g9f6f34a-31
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-athens-40194-20130605213655-3.10.0-rc3-03384-g9f6f34a-31
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-inn-3711-20130605211017-3.10.0-rc3-03384-g9f6f34a-31
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-roam-12274-20130605212842-3.10.0-rc3-03384-g9f6f34a-31
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-roam-31717-20130605214027-3.10.0-rc3-03384-g9f6f34a-31
/kernel/x86_64-randconfig-a00-0605/9f6f34aebccbfb7de857e371e1fa9a0196c7be8e/dmesg-kvm-vp-30907-20130605213617-3.10.0-rc3-03384-g9f6f34a-31

[detached HEAD 10af2cd] Revert "mac80211_hwsim: correctly register the platform driver"
 1 file changed, 9 insertions(+), 9 deletions(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:10af2cd3c3c1cd8376126e3ffb6699c36032c7d0:bisect-linux-drm

2013-06-06-04:05:38 10af2cd3c3c1cd8376126e3ffb6699c36032c7d0 compiling

2013-06-06-04:11:30 detecting boot state 3.10.0-rc3-03403-g10af2cd	3	7	10	15	23	25	28..	29.......	30 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec:bisect-linux-drm
 TEST FAILURE
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-inn-41473-20130605140204-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-inn-47998-20130605140157-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-inn-52209-20130605140156-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-kbuild-34988-20130605135749-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-roam-28220-20130605140427-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-roam-34541-20130605140429-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-vp-31768-20130605140632-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-waimea-26529-20130605140702-3.10.0-rc4-next-20130605-14
/kernel/x86_64-randconfig-a00-0605/f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec/dmesg-kvm-waimea-3900-20130605140700-3.10.0-rc4-next-20130605-14


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
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
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_EDEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
CONFIG_SBP_TARGET=y
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_RANDOM is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IGB is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
# CONFIG_IXGBE_DCA is not set
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBEVF=y
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=y
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH5K_PCI=y
# CONFIG_ATH5K_TEST_CHANNELS is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
# CONFIG_ATH9K_DFS_CERTIFIED is not set
# CONFIG_ATH9K_RATE_CONTROL is not set
CONFIG_ATH6KL=y
# CONFIG_ATH6KL_DEBUG is not set
CONFIG_ATH6KL_REGDOMAIN=y
CONFIG_WIL6210=y
# CONFIG_WIL6210_ISR_COR is not set
CONFIG_B43=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
# CONFIG_B43_PHY_LP is not set
CONFIG_B43_LEDS=y
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=y
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
# CONFIG_RT2800PCI_RT35XX is not set
# CONFIG_RT2800PCI_RT53XX is not set
CONFIG_RT2800PCI_RT3290=y
CONFIG_RT2800_LIB=y
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTLWIFI=y
# CONFIG_RTLWIFI_DEBUG is not set
# CONFIG_RTL8192CE is not set
CONFIG_RTL8192SE=y
CONFIG_RTL8192DE=y
CONFIG_RTL8723AE=y
CONFIG_RTL8188EE=y
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_PCIE=y

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

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
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_OT200=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_QIB is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_SRPT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_TWOFISH_AVX2_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
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
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
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
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ISDN_DRV_LOOP is not set

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-athens-16566-20130606030049-3.9.0-12328-g03cd7e4-34"

[    0.000000] Linux version 3.9.0-12328-g03cd7e4 (wfg@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #34 Thu Jun 6 01:39:48 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:03cd7e4e1ea16cd151c799a33b5ca1fd41a464df:bisect-linux-drm/.vmlinuz-03cd7e4e1ea16cd151c799a33b5ca1fd41a464df-20130606014022-7-athens branch=sound-unstable/master  BOOT_IMAGE=/kernel/x86_64-randconfig-a00-0605/03cd7e4e1ea16cd151c799a33b5ca1fd41a464df/vmlinuz-3.9.0-12328-g03cd7e4
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x041f6000, 0x041f6fff] PGTABLE
[    0.000000] BRK [0x041f7000, 0x041f7fff] PGTABLE
[    0.000000] BRK [0x041f8000, 0x041f8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x041f9000, 0x041f9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x041fa000, 0x041fafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128232(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3243f80
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-a00-0605/sound-unstable:master:03cd7e4e1ea16cd151c799a33b5ca1fd41a464df:bisect-linux-drm/.vmlinuz-03cd7e4e1ea16cd151c799a33b5ca1fd41a464df-20130606014022-7-athens branch=sound-unstable/master  BOOT_IMAGE=/kernel/x86_64-randconfig-a00-0605/03cd7e4e1ea16cd151c799a33b5ca1fd41a464df/vmlinuz-3.9.0-12328-g03cd7e4
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Memory: 173416k/262136k available (23205k kernel code, 440k absent, 88280k reserved, 19173k data, 1096k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5785.97 BogoMIPS (lpj=11571952)
[    0.012009] pid_max: default: 32768 minimum: 301
[    0.013310] Security Framework initialized
[    0.014554] Mount-cache hash table entries: 256
[    0.016000] mce: CPU supports 10 MCE banks
[    0.016019] mce: unknown CPU type - not enabling MCE support
[    0.017630] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017630] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017630] tlb_flushall_shift: -1
[    0.020017] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.067596] ACPI: Core revision 20130328
[    0.073012] ACPI: All ACPI Tables successfully acquired
[    0.080232] Performance Events: Getting VERSION: 50014
[    0.084029] Getting VERSION: 50014
[    0.088017] Getting ID: 0
[    0.088891] Getting ID: ff000000
[    0.089932] Getting LVT0: 8700
[    0.090811] Getting LVT1: 8400
[    0.092108] enabled ExtINT on CPU#0
[    0.097419] ENABLING IO-APIC IRQs
[    0.098445] init IO_APIC IRQs
[    0.099318]  apic 2 pin 0 not connected
[    0.100027] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.104048] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.108053] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.112044] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.116048] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.120055] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.124046] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.128045] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.132050] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.136037] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.140047] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.144045] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.148030] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.152047] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.154189] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.156041]  apic 2 pin 16 not connected
[    0.157247]  apic 2 pin 17 not connected
[    0.158323]  apic 2 pin 18 not connected
[    0.159471]  apic 2 pin 19 not connected
[    0.160016]  apic 2 pin 20 not connected
[    0.164006]  apic 2 pin 21 not connected
[    0.165151]  apic 2 pin 22 not connected
[    0.166270]  apic 2 pin 23 not connected
[    0.168332] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.172013] Using local APIC timer interrupts.
[    0.172013] calibrating APIC timer ...
[    0.180000] ... lapic delta = 15352351
[    0.180000] ... PM-Timer delta = 879263
[    0.180000] APIC calibration not consistent with PM-Timer: 245ms instead of 100ms
[    0.180000] APIC delta adjusted to PM-Timer: 6250047 (15352351)
[    0.180000] TSC delta adjusted to PM-Timer: 289305756 (710638370)
[    0.180000] ..... delta 6250047
[    0.180000] ..... mult: 268437474
[    0.180000] ..... calibration result: 4000030
[    0.180000] ..... CPU clock speed is 2893.0230 MHz.
[    0.180000] ..... host bus clock speed is 1000.0030 MHz.
[    0.180274] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.189393] EVM: security.capability
[    0.196455] xor: measuring software checksum speed
[    0.244023]    prefetch64-sse:  7659.000 MB/sec
[    0.288015]    generic_sse:  6589.000 MB/sec
[    0.292016] xor: using function: prefetch64-sse (7659.000 MB/sec)
[    0.296173] regulator-dummy: no parameters
[    0.300144] NET: Registered protocol family 16
[    0.312718] ACPI: bus type PCI registered
[    0.316056] dca service started, version 1.12.1
[    0.320117] PCI: Using configuration type 1 for base access
[    0.340157] bio: create slab <bio-0> at 0
[    0.412031] raid6: sse2x1     651 MB/s
[    0.480035] raid6: sse2x2    1175 MB/s
[    0.552009] raid6: sse2x4     936 MB/s
[    0.553813] raid6: using algorithm sse2x2 (1175 MB/s)
[    0.556009] raid6: using intx1 recovery algorithm
[    0.558389] ACPI: Added _OSI(Module Device)
[    0.560010] ACPI: Added _OSI(Processor Device)
[    0.564018] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.568008] ACPI: Added _OSI(Processor Aggregator Device)
[    0.576483] ACPI: EC: Look up EC in DSDT
[    0.584053] ACPI: Interpreter enabled
[    0.585711] ACPI: (supports S0 S5)
[    0.588009] ACPI: Using IOAPIC for interrupt routing
[    0.596037] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.612062] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.615026] PCI host bridge to bus 0000:00
[    0.616019] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.620021] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.624018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.628014] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.632019] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.636000] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.636000] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.636187] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.642316] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.645343] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.648766] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.652043] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.656000] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.656681] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.664696] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.673742] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.680924] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.684996] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.688899] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.704028] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.712297] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.724014] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.728880] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.736880] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.744108] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.753037] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.756939] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.764385] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.772000] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.772000] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.776166] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.781049] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.784000] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.788273] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.793053] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.796000] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.800181] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.805031] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.808955] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.816214] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.821078] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.824915] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.845524] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.852530] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.864301] pci_bus 0000:00: on NUMA node 0
[    0.866428] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.872010] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.880701] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.889246] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.896813] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.904974] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.912813] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.921352] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.928008] acpi root: \_SB_.PCI0 notify handler is installed
[    0.932057] Found 1 acpi root devices
[    0.937146] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.940019] vgaarb: loaded
[    0.944000] vgaarb: bridge control possible 0000:00:02.0
[    0.944640] tps65010: version 2 May 2005
[    0.980078] tps65010: no chip?
[    0.988940] SCSI subsystem initialized
[    0.992047] ACPI: bus type ATA registered
[    0.994041] libata version 3.00 loaded.
[    1.000235] pps_core: LinuxPPS API ver. 1 registered
[    1.004012] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.008066] PTP clock support registered
[    1.012197] EDAC MC: Ver: 3.0.0
[    1.020689] PCI: Using ACPI for IRQ routing
[    1.028026] PCI: pci_cache_line_size set to 64 bytes
[    1.036434] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.044013] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.052572] irda_init()
[    1.060113] NET: Registered protocol family 23
[    1.068516] nfc: nfc_init: NFC Core ver 0.1
[    1.076096] NET: Registered protocol family 39
[    1.084160] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.092093] cfg80211: Calling CRDA to update world regulatory domain
[    1.100066] Switching to clocksource kvm-clock
[    1.104266] FS-Cache: Loaded
[    1.112843] CacheFiles: Loaded
[    1.114441] pnp: PnP ACPI init
[    1.121304] ACPI: bus type PNP registered
[    1.132129] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    1.141555] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.151683] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    1.161676] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.171371] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    1.181581] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.184682] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    1.194783] pnp 00:03: [dma 2]
[    1.202610] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.212313] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    1.216217] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.219597] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    1.223534] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.227371] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.231030] pnp: PnP ACPI: found 7 devices
[    1.233102] ACPI: bus type PNP unregistered
[    1.235170] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    1.245474] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.248297] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.251047] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.254072] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.257239] NET: Registered protocol family 1
[    1.259379] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.262337] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.265207] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.271613] pci 0000:00:02.0: Boot video device
[    1.273927] PCI: CLS 0 bytes, default 64
[    1.283804] Unpacking initramfs...
[    5.376463] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    5.512637] DMA-API: preallocated 65536 debug entries
[    5.515356] DMA-API: debugging enabled by kernel config
[    5.546390] Machine check injector initialized
[    5.556242] cryptomgr_test (21) used greatest stack depth: 6608 bytes left
[    5.577056] cryptomgr_test (23) used greatest stack depth: 5760 bytes left
[    5.592773] cryptomgr_test (43) used greatest stack depth: 5552 bytes left
[    5.625381] PCLMULQDQ-NI instructions are not detected.
[    5.638641] AVX instructions are not detected.
[    5.642124] AVX instructions are not detected.
[    5.654296] AVX instructions are not detected.
[    5.664918] AVX instructions are not detected.
[    5.667187] AVX2 instructions are not detected.
[    5.680020] AVX2 instructions are not detected.
[    5.701889] AVX2 instructions are not detected.
[    5.708420] audit: initializing netlink socket (disabled)
[    5.715357] type=2000 audit(1370458814.712:1): initialized
[    5.728474] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    5.766275] bounce pool size: 64 pages
[    5.775637] VFS: Disk quotas dquot_6.5.2
[    5.783987] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.788599] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    5.799218] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.805853] jffs2: version 2.2. (NAND) (SUMMARY)  
[    5.812046] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.821586] QNX4 filesystem 0.2.3 registered.
[    5.828032] QNX6 filesystem 1.0.0 registered.
[    5.833022] SGI XFS with security attributes, realtime, large block/inode numbers, debug enabled
[    5.846670] NILFS version 2 loaded
[    5.848596] BeFS version: 0.9.3
[    5.857431] OCFS2 1.5.0
[    5.858927] ocfs2 stack glue: unable to register sysctl
[    5.864803] ocfs2: Registered cluster interface o2cb
[    5.869927] OCFS2 DLMFS 1.5.0
[    5.871782] OCFS2 User DLM kernel interface loaded
[    5.887717] OCFS2 Node Manager 1.5.0
[    5.889913] OCFS2 DLM 1.5.0
[    5.906471] alg: No test for crc32 (crc32-table)
[    5.909641] alg: No test for stdrng (krng)
[    5.935950] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    5.952083] NET: Registered protocol family 38
[    5.976178] async_tx: api initialized (async)
[    5.978625] Key type asymmetric registered
[    5.985064] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    5.996580] io scheduler noop registered
[    6.002323] io scheduler cfq registered (default)
[    6.005069] test_string_helpers: Running tests...
[    6.014789] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    6.030068] crc32: self tests passed, processed 225944 bytes in 169849 nsec
[    6.042130] crc32c: CRC_LE_BITS = 64
[    6.053463] crc32c: self tests passed, processed 225944 bytes in 85533 nsec
[    6.068830] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.072157] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.096261] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.107770] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    6.121150] vmlfb: initializing
[    6.135156] no IO addresses supplied
[    6.140976] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.153430] ACPI: Power Button [PWRF]
[    6.160492] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    6.232961] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.373189] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.386406] lp: driver loaded but no devices found
[    6.404219] ppdev: user-space parallel port driver
[    6.413297] Linux agpgart interface v0.103
[    6.420805] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    6.452335] Hangcheck: Using getrawmonotonic().
[    6.460773] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    6.464603] parport_pc 00:04: reported by Plug and Play ACPI
[    6.485954] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    6.499883] lp0: using parport0 (interrupt-driven).
[    6.501794] lp0: console ready
[    6.503776] genirq: Flags mismatch irq 0. 00000080 (dummy_irq) vs. 00015a20 (timer)
[    6.524682] dummy-irq: cannot register IRQ 0
[    6.526913] Phantom Linux Driver, version n0.9.8, init OK
[    6.541151] Driver for timberdale has been successfully registered.
[    6.561758] Loading iSCSI transport class v2.0-870.
[    6.572247] tsc: Refined TSC clocksource calibration: 2893.025 MHz
[    6.576495] rdac: device handler registered
[    6.580944] emc: device handler registered
[    6.583840] alua: device handler registered
[    6.599785] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
[    6.604300] fnic: Successfully Initialized Trace Buffer
[    6.615074] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    6.622190] Detecting Adaptec I2O RAID controllers...
[    6.634647] Adaptec aacraid driver 1.2-0[30200]-ms
[    6.647947] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    6.673030] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    6.676652] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.05.00.03-k.
[    6.685522] iscsi: registered transport (qla4xxx)
[    6.692954] QLogic iSCSI HBA Driver
[    6.694598] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[    6.703090] DC390: clustering now enabled by default. If you get problems load
[    6.711630]        with "disable_clustering=1" and report to maintainers
[    6.714587] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.722530] 3ware Storage Controller device driver for Linux v1.26.02.003.
[    6.725187] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
[    6.733413] ppa: Version 2.07 (for Linux 2.4.x)
[    6.746587] imm: Version 2.05 (for Linux 2.4.0)
[    6.749703] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (November 16, 2012)
[    6.758905] RocketRAID 3xxx/4xxx Controller driver v1.8
[    6.765925] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    6.773096] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[    6.784028] iscsi: registered transport (bnx2i)
[    6.786659] iscsi: registered transport (be2iscsi)
[    6.788990] In beiscsi_module_init, tt=ffffffff8361e340
[    6.791636] VMware PVSCSI driver - version 1.0.2.0-k
[    6.815924] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.825786] osst :I: Tape driver with OnStream support version 0.99.4
[    6.825786] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.841659] osd: LOADED open-osd 0.2.1
[    6.844245] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    6.855254] SSFDC read-only Flash Translation layer
[    6.861768] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
[    6.865361] device id = 2440
[    6.871915] device id = 2480
[    6.873295] device id = 24c0
[    6.874640] device id = 24d0
[    6.876065] device id = 25a1
[    6.882760] device id = 2670
[    6.884229] platform physmap-flash.0: failed to claim resource 0
[    6.887049] Could not find PAR responsible for SC520CDP Flash Bank #0
[    6.894168] Trying default address 0x8400000
[    6.896141] Could not find PAR responsible for SC520CDP Flash Bank #1
[    6.909751] Trying default address 0x8c00000
[    6.911720] Could not find PAR responsible for SC520CDP DIL Flash
[    6.914492] Trying default address 0x9400000
[    6.923230] SC520 CDP flash device: 0x800000 at 0x8400000
[    6.925731] Failed to ioremap_nocache
[    6.927509] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    6.942496] slram: not enough parameters.
[    6.944468] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    6.955864] pmc551: not detected
[    6.963612] ftl_cs: FTL header not found.
[    6.995075] libphy: Fixed MDIO Bus: probed
[    6.997427] tun: Universal TUN/TAP device driver, 1.6
[    6.999818] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.006851] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.017641] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[    7.021387] vxge: Copyright(c) 2002-2010 Exar Corp.
[    7.030249] vxge: Driver version: 2.5.3.22640-k
[    7.032471] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.044268] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.056643] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    7.059484] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    7.064887] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[    7.069246] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.072213] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.13.10-k
[    7.076258] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    7.092899] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
[    7.102148] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.105096] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    7.114430] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
[    7.124053] Solarflare NET driver v3.2
[    7.126145] tlan: ThunderLAN driver v1.17
[    7.133099] tlan: 0 devices installed, PCI: 0  EISA: 0
[    7.135740] w83977af_init()
[    7.143116] w83977af_open()
[    7.144495] w83977af_probe()
[    7.146135] w83977af_probe(), Wrong chip version
[    7.153397] w83977af_probe()
[    7.155226] w83977af_probe(), Wrong chip version
[    7.165110] PPP generic driver version 2.4.2
[    7.171625] PPP BSD Compression module registered
[    7.173889] PPP Deflate Compression module registered
[    7.183280] PPP MPPE Compression module registered
[    7.190929] NET: Registered protocol family 24
[    7.193903] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    7.202940] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    7.209474] libipw: Unable to create ieee80211 proc directory
[    7.212489] Broadcom 43xx driver loaded [ Features: PL ]
[    7.215987] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[    7.216349] IP: [<ffffffff81929966>] platform_match+0x76/0x110
[    7.216349] PGD 0 
[    7.216349] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    7.216349] CPU: 0 PID: 1 Comm: swapper Not tainted 3.9.0-12328-g03cd7e4 #34
[    7.216349] task: ffff88000d826810 ti: ffff88000d832000 task.ti: ffff88000d832000
[    7.216349] RIP: 0010:[<ffffffff81929966>]  [<ffffffff81929966>] platform_match+0x76/0x110
[    7.216349] RSP: 0000:ffff88000d833d18  EFLAGS: 00010202
[    7.216349] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81927e40
[    7.216349] RDX: 0000000000000001 RSI: ffff88000d821428 RDI: 0000000000000000
[    7.216349] RBP: ffff88000d833d38 R08: ffff88000d857628 R09: 0000000000000000
[    7.216349] R10: 0000000000001a40 R11: 0000000000000000 R12: 0000000000000049
[    7.216349] R13: ffff88000d821428 R14: 0000000000000000 R15: ffffffff8351eec0
[    7.216349] FS:  0000000000000000(0000) GS:ffffffff8322d000(0000) knlGS:0000000000000000
[    7.216349] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.216349] CR2: 0000000000000001 CR3: 0000000003212000 CR4: 00000000000006b0
[    7.216349] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.216349] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.216349] Stack:
[    7.216349]  ffffffff832baba0 ffff88000d821428 ffffffff8377c7c0 ffffffff81927e40
[    7.216349]  ffff88000d833d68 ffffffff81927e79 0000000000000000 0000000000000000
[    7.216349]  ffffffff8377c7c0 ffffffff81927e40 ffff88000d833da8 ffffffff81924ed9
[    7.216349] Call Trace:
[    7.216349]  [<ffffffff81927e40>] ? driver_probe_device+0x340/0x340
[    7.216349]  [<ffffffff81927e79>] __driver_attach+0x39/0x140
[    7.216349]  [<ffffffff81927e40>] ? driver_probe_device+0x340/0x340
[    7.216349]  [<ffffffff81924ed9>] bus_for_each_dev+0x99/0xf0
[    7.216349]  [<ffffffff819276e1>] driver_attach+0x21/0x30
[    7.216349]  [<ffffffff81925cc8>] bus_add_driver+0x128/0x3d0
[    7.216349]  [<ffffffff839b2043>] ? wil6210_driver_init+0x29/0x29
[    7.216349]  [<ffffffff819286c8>] driver_register+0x128/0x250
[    7.216349]  [<ffffffff819283e2>] ? driver_create_file+0x22/0x40
[    7.216349]  [<ffffffff839b2043>] ? wil6210_driver_init+0x29/0x29
[    7.216349]  [<ffffffff839b213b>] init_mac80211_hwsim+0xf8/0xeb3
[    7.216349]  [<ffffffff819287cf>] ? driver_register+0x22f/0x250
[    7.216349]  [<ffffffff839b1fba>] ? ath5k_pci_driver_init+0x29/0x29
[    7.216349]  [<ffffffff839b201a>] ? ath9k_cmn_init+0xf/0xf
[    7.216349]  [<ffffffff839b2043>] ? wil6210_driver_init+0x29/0x29
[    7.216349]  [<ffffffff8396c569>] do_one_initcall+0xb5/0x196
[    7.216349]  [<ffffffff8396c7fe>] kernel_init_freeable+0x1b4/0x2b7
[    7.216349]  [<ffffffff8396b9a6>] ? loglevel+0x46/0x46
[    7.216349]  [<ffffffff8267da00>] ? rest_init+0xd0/0xd0
[    7.216349]  [<ffffffff8267da11>] kernel_init+0x11/0x1b0
[    7.216349]  [<ffffffff826a7aba>] ret_from_fork+0x7a/0xb0
[    7.216349]  [<ffffffff8267da00>] ? rest_init+0xd0/0xd0
[    7.216349] Code: 00 00 49 8b 5c 24 78 48 85 db 0f 84 85 00 00 00 4c 8b 25 2e 7c 4d 02 48 83 05 d6 7b 4d 02 01 48 83 05 0e 7c 4d 02 01 49 83 c4 01 <80> 3b 00 75 0d 0f 1f 44 00 00 31 d2 eb 4c 0f 1f 40 00 4c 89 25 
[    7.216349] RIP  [<ffffffff81929966>] platform_match+0x76/0x110
[    7.216349]  RSP <ffff88000d833d18>
[    7.216349] CR2: 0000000000000001
[    7.734420] ---[ end trace a0976ad5b9f04bdf ]---
[    7.736556] Kernel panic - not syncing: Fatal exception
[    7.740540] Rebooting in 10 seconds..
--gKMricLos+KVdGMg--
