Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaDEEaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 00:30:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:54194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaDEEaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 00:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,798,1389772800"; 
   d="scan'208";a="507418788"
Message-ID: <533F86D4.10007@intel.com>
Date: Sat, 05 Apr 2014 12:30:12 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list()
References: <20140404031928.GC11828@localhost> <CAKohponbGFFo+W7X24e4h3ub2L8Tkb89eP6_F17CRYELk0yeRQ@mail.gmail.com> <533E635F.9050803@intel.com> <CAKohpon+THY2NXEEOcWRbmrpfQUZYbHfO+Lw=D9TaJWk+_-J2g@mail.gmail.com>
In-Reply-To: <CAKohpon+THY2NXEEOcWRbmrpfQUZYbHfO+Lw=D9TaJWk+_-J2g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030604040509090702000602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030604040509090702000602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/04/2014 03:52 PM, Viresh Kumar wrote:
> On 4 April 2014 13:16, Jet Chen <jet.chen@intel.com> wrote:
>> Hi Viresh,
>>
>> I changed your print message as you suggested.
>>
>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index 6c3a371..193101d 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -1617,8 +1617,8 @@ static void migrate_timer_list(struct tvec_base
>> *new_base, struct list_head *hea
>>
>>                   /* Check if CPU still has pinned timers */
>>                   if (unlikely(WARN(is_pinned,
>> -                                 "%s: can't migrate pinned timer: %p,
>> deactivating it\n",
>> -                                 __func__, timer)))
>> +                                 "%s: can't migrate pinned timer: %p,
>> timer->function: %p,deactivating it\n",
>> +                                 __func__, timer, timer->function)))
>>                           continue;
>>
>> Then I reproduced the issue, and got the dmesg output,
>>
>> [   37.918406] migrate_timer_list: can't migrate pinned timer:
>> ffffffff81f06a60, timer->function: ffffffff810d7010,deactivating it
>>
>> We reproduced this issue for several times in our LKP system. The address of
>> timer ffffffff81f06a60 is very constant. So is timer->function, I believe.
>>
>> Hope this information will help you. Please feel free to tell me what else I
>> can do to help you.
>
> Hi Jet,
>
> Thanks a lot. Yes that's pretty helpful.. But I need some more help from you..
> I don't have any idea which function has this address in your kernel:
> ffffffff810d7010 :)
>
> Can you please debug that a bit more? You need to find which function
> this address belongs to. You can try that using objdump on your vmlinux.
>
> Some help can be found here: Documentation/BUG-HUNTING
>
> Thanks in Advance.
>
vmlinuz from our build system doesn't have debug information. It is hard 
to use objdump to identify which routine is timer->function.
But after several times trials, I get below dmesg messages.
It is clear to see address of "timer->function" is 0xffffffff810d7010.
In calling stack, " [<ffffffff810d7010>] ? 
clocksource_watchdog_kthread+0x40/0x40 ". So I guess timer->function is 
clocksource_watchdog_kthread.
I manually disable CONFIG_CLOCKSOURCE_WATCHDOG, then I never see this 
oops again (But see other oops for other reason :( )


[   37.918345] WARNING: CPU: 0 PID: 1932 at kernel/timer.c:1621 
migrate_timer_list+0xdb/0xf0()
[   37.918406] migrate_timer_list: can't migrate pinned timer: 
ffffffff81f06a60, timer->function: ffffffff810d7010,deactivating it
[   37.918406] Modules linked in:
[   37.918406] CPU: 0 PID: 1932 Comm: 01-cpu-hotplug Not tainted 
3.14.0-rc1-00088-gab3c4fd #4
[   37.918406] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   37.918406]  0000000000000009 ffff88001d407c38 ffffffff817237bd 
ffff88001d407c80
[   37.918406]  ffff88001d407c70 ffffffff8106a1dd 0000000000000010 
ffffffff81f06a60
[   37.918406]  ffff88001e04d040 ffffffff81e3d4c0 ffff88001e04d030 
ffff88001d407cd0
[   37.918406] Call Trace:
[   37.918406]  [<ffffffff817237bd>] dump_stack+0x4d/0x66
[   37.918406]  [<ffffffff8106a1dd>] warn_slowpath_common+0x7d/0xa0
[   37.918406]  [<ffffffff8106a24c>] warn_slowpath_fmt+0x4c/0x50
[   37.918406]  [<ffffffff810761c3>] ? __internal_add_timer+0x113/0x130
[   37.918406]  [<ffffffff810d7010>] ? 
clocksource_watchdog_kthread+0x40/0x40
[   37.918406]  [<ffffffff8107753b>] migrate_timer_list+0xdb/0xf0
[   37.918406]  [<ffffffff810782dc>] timer_cpu_notify+0xfc/0x1f0
[   37.918406]  [<ffffffff8173046c>] notifier_call_chain+0x4c/0x70
[   37.918406]  [<ffffffff8109340e>] __raw_notifier_call_chain+0xe/0x10
[   37.918406]  [<ffffffff8106a3f3>] cpu_notify+0x23/0x50
[   37.918406]  [<ffffffff8106a44e>] cpu_notify_nofail+0xe/0x20
[   37.918406]  [<ffffffff81712a5d>] _cpu_down+0x1ad/0x2e0
[   37.918406]  [<ffffffff81712bc4>] cpu_down+0x34/0x50
[   37.918406]  [<ffffffff813fec54>] cpu_subsys_offline+0x14/0x20
[   37.918406]  [<ffffffff813f9f65>] device_offline+0x95/0xc0
[   37.918406]  [<ffffffff813fa060>] online_store+0x40/0x90
[   37.918406]  [<ffffffff813f75d8>] dev_attr_store+0x18/0x30
[   37.918406]  [<ffffffff8123309d>] sysfs_kf_write+0x3d/0x50



--------------030604040509090702000602
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-nfsroot-lkp-ib04-40:20140404145220:x86_64-rhel:3.14.0-rc1-00088-gab3c4fd:4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-nfsroot-lkp-ib04-40:20140404145220:x86_64-rhel:3.14.0-";
 filename*1="rc1-00088-gab3c4fd:4"

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00088-gab3c4fd (kbuild@xian) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #4 SMP Fri Apr 4 14:46:57 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D=
2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal i=
p=3D::::nfsroot-lkp-ib04-40::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,=
v3,nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-rhel/tchen:vireshk_test/.vmlinuz-ab3c4fdd=
657432f23ac1ede2845392c4d4bdb947-20140404144932-2-lkp-ib04 branch=3Dtchen=
/vireshk_test BOOT_IMAGE=3D/kernel/x86_64-rhel/ab3c4fdd657432f23ac1ede284=
5392c4d4bdb947/vmlinuz-3.14.0-rc1-00088-gab3c4fd drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x1fffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fec000, 0x01fecfff] PGTABLE
[    0.000000] BRK [0x01fed000, 0x01fedfff] PGTABLE
[    0.000000] BRK [0x01fee000, 0x01feefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x01fef000, 0x01feffff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe490 0011A9 (v01   BXPC   BXDSDT 00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 000040
[    0.000000] ACPI: SSDT 000000001ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffff680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffff640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1ffd7000-0x1fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1ff57001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001ee00=
000-ffff88001f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130972
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88001fc00000 s87104 r81=
92 d23488 u1048576
[    0.000000] pcpu-alloc: s87104 r8192 d23488 u1048576 alloc=3D1*2097152=

[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:1ff57001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1fc0dfc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 128903
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal ip=3D::::nfsroot-lkp-ib04-40::dhcp nfsroot=3D192.168.1.1:/nfsroot/=
wfg,tcp,v3,nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-rhel/tchen:vireshk_test/.vmlinuz-=
ab3c4fdd657432f23ac1ede2845392c4d4bdb947-20140404144932-2-lkp-ib04 branch=
=3Dtchen/vireshk_test BOOT_IMAGE=3D/kernel/x86_64-rhel/ab3c4fdd657432f23a=
c1ede2845392c4d4bdb947/vmlinuz-3.14.0-rc1-00088-gab3c4fd drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 498140K/523888K available (7397K kernel code, 1473=
K rwdata, 3476K rodata, 1724K init, 2180K bss, 25748K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00088-gab3c4fd (kbuild@xian) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #4 SMP Fri Apr 4 14:46:57 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D=
2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal i=
p=3D::::nfsroot-lkp-ib04-40::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,=
v3,nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-rhel/tchen:vireshk_test/.vmlinuz-ab3c4fdd=
657432f23ac1ede2845392c4d4bdb947-20140404144932-2-lkp-ib04 branch=3Dtchen=
/vireshk_test BOOT_IMAGE=3D/kernel/x86_64-rhel/ab3c4fdd657432f23ac1ede284=
5392c4d4bdb947/vmlinuz-3.14.0-rc1-00088-gab3c4fd drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x1fffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fec000, 0x01fecfff] PGTABLE
[    0.000000] BRK [0x01fed000, 0x01fedfff] PGTABLE
[    0.000000] BRK [0x01fee000, 0x01feefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x01fef000, 0x01feffff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe490 0011A9 (v01   BXPC   BXDSDT 00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 000040
[    0.000000] ACPI: SSDT 000000001ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffff680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffff640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1ffd7000-0x1fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1ff57001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001ee00=
000-ffff88001f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130972
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88001fc00000 s87104 r81=
92 d23488 u1048576
[    0.000000] pcpu-alloc: s87104 r8192 d23488 u1048576 alloc=3D1*2097152=

[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:1ff57001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1fc0dfc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 128903
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal ip=3D::::nfsroot-lkp-ib04-40::dhcp nfsroot=3D192.168.1.1:/nfsroot/=
wfg,tcp,v3,nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=3D524288 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-rhel/tchen:vireshk_test/.vmlinuz-=
ab3c4fdd657432f23ac1ede2845392c4d4bdb947-20140404144932-2-lkp-ib04 branch=
=3Dtchen/vireshk_test BOOT_IMAGE=3D/kernel/x86_64-rhel/ab3c4fdd657432f23a=
c1ede2845392c4d4bdb947/vmlinuz-3.14.0-rc1-00088-gab3c4fd drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 498140K/523888K available (7397K kernel code, 1473=
K rwdata, 3476K rodata, 1724K init, 2180K bss, 25748K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 2097152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.918 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4987.83 Bo=
goMIPS (lpj=3D2493918)
[    0.003400] pid_max: default: 32768 minimum: 301
[    0.004024] Security Framework initialized
[    0.004827] SELinux:  Initializing.
[    0.005013] SELinux:  Starting in permissive mode
[    0.006066] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.008255] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.009265] Mount-cache hash table entries: 256
[    0.010340] Initializing cgroup subsys memory
[    0.011010] Initializing cgroup subsys devices
[    0.012004] Initializing cgroup subsys freezer
[    0.013006] Initializing cgroup subsys net_cls
[    0.014006] Initializing cgroup subsys blkio
[    0.015005] Initializing cgroup subsys perf_event
[    0.016007] Initializing cgroup subsys hugetlb
[    0.017025] mce: CPU supports 10 MCE banks
[    0.017870] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017870] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017870] tlb_flushall_shift: 6
[    0.018080] Freeing SMP alternatives memory: 28K (ffffffff81dc2000 - f=
fffffff81dc9000)
[    0.023818] ftrace: allocating 27839 entries in 109 pages
[    0.032071] Getting VERSION: 50014
[    0.032798] Getting VERSION: 50014
[    0.033005] Getting ID: 0
[    0.034009] Getting ID: ff000000
[    0.034704] Getting LVT0: 8700
[    0.035006] Getting LVT1: 8400
[    0.036024] enabled ExtINT on CPU#0
[    0.037696] ENABLING IO-APIC IRQs
[    0.038004] init IO_APIC IRQs
[    0.039005]  apic 0 pin 0 not connected
[    0.040008] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.041026] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.042018] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.043017] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.044017] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.045017] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.046017] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.047017] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.048017] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.049017] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.050017] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.051017] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.052017] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.053017] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.054018] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.055015]  apic 0 pin 16 not connected
[    0.055792]  apic 0 pin 17 not connected
[    0.056003]  apic 0 pin 18 not connected
[    0.057002]  apic 0 pin 19 not connected
[    0.058003]  apic 0 pin 20 not connected
[    0.059003]  apic 0 pin 21 not connected
[    0.059782]  apic 0 pin 22 not connected
[    0.060003]  apic 0 pin 23 not connected
[    0.061145] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.062003] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.064758] Using local APIC timer interrupts.
[    0.064758] calibrating APIC timer ...
[    0.066000] ... lapic delta =3D 6249716
[    0.066000] ... PM-Timer delta =3D 357916
[    0.066000] ... PM-Timer result ok
[    0.066000] ..... delta 6249716
[    0.066000] ..... mult: 268423258
[    0.066000] ..... calibration result: 999954
[    0.066000] ..... CPU clock speed is 2493.0505 MHz.
[    0.066000] ..... host bus clock speed is 999.0954 MHz.
[    0.073111] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.077039] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.078209] x86: Booting SMP configuration:
[    0.079003] .... node  #0, CPUs:      #1
[    0.076990] kvm-clock: cpu 1, msr 0:1ff57041, secondary cpu clock
[    0.076990] masked ExtINT on CPU#1
[    0.092032] x86: Booted up 1 node, 2 CPUs
[    0.092035] KVM setup async PF for cpu 1
[    0.092039] kvm-stealtime: cpu 1, msr 1fd0dfc0
[    0.093004] smpboot: Total of 2 processors activated (9975.67 BogoMIPS=
)
[    0.095271] devtmpfs: initialized
[    0.098337] EVM: security.selinux
[    0.099002] EVM: security.ima
[    0.099670] EVM: security.capability
[    0.101446] atomic64 test passed for x86-64 platform with CX8 and with=
 SSE
[    0.102064] NET: Registered protocol family 16
[    0.103198] cpuidle: using governor menu
[    0.104204] ACPI: bus type PCI registered
[    0.105004] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.106151] PCI: Using configuration type 1 for base access
[    0.109055] bio: create slab <bio-0> at 0
[    0.110064] ACPI: Added _OSI(Module Device)
[    0.110871] ACPI: Added _OSI(Processor Device)
[    0.111003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.112003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.115361] ACPI: Interpreter enabled
[    0.116007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20131218/hwxface-580)
[    0.117549] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20131218/hwxface-580)
[    0.119588] ACPI: (supports S0 S3 S4 S5)
[    0.120003] ACPI: Using IOAPIC for interrupt routing
[    0.121018] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.123216] ACPI: No dock devices found.
[    0.126806] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.127008] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments =
MSI]
[    0.128008] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.129094] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.130331] acpiphp: Slot [3] registered
[    0.131026] acpiphp: Slot [4] registered
[    0.131822] acpiphp: Slot [5] registered
[    0.132025] acpiphp: Slot [6] registered
[    0.133034] acpiphp: Slot [7] registered
[    0.134025] acpiphp: Slot [8] registered
[    0.135024] acpiphp: Slot [9] registered
[    0.135828] acpiphp: Slot [10] registered
[    0.136026] acpiphp: Slot [11] registered
[    0.137026] acpiphp: Slot [12] registered
[    0.138025] acpiphp: Slot [13] registered
[    0.139033] acpiphp: Slot [14] registered
[    0.139833] acpiphp: Slot [15] registered
[    0.140109] acpiphp: Slot [24] registered
[    0.141025] acpiphp: Slot [25] registered
[    0.142025] acpiphp: Slot [26] registered
[    0.143043] acpiphp: Slot [27] registered
[    0.144025] acpiphp: Slot [28] registered
[    0.144835] acpiphp: Slot [29] registered
[    0.145026] acpiphp: Slot [30] registered
[    0.146026] acpiphp: Slot [31] registered
[    0.147013] PCI host bridge to bus 0000:00
[    0.148004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.149004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.150004] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.151004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.152004] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.153037] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.154336] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.156275] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.159729] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.161660] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.163194] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.164013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.165192] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.168043] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.170595] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.177589] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.179373] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.181005] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.183009] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.188452] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.190013] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.191510] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.195849] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.197090] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.198702] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.200083] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.201449] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.202874] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.203274] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.204003] vgaarb: loaded
[    0.205002] vgaarb: bridge control possible 0000:00:02.0
[    0.206184] SCSI subsystem initialized
[    0.207074] ACPI: bus type USB registered
[    0.208044] usbcore: registered new interface driver usbfs
[    0.209020] usbcore: registered new interface driver hub
[    0.210150] usbcore: registered new device driver usb
[    0.211043] pps_core: LinuxPPS API ver. 1 registered
[    0.211909] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.212009] PTP clock support registered
[    0.213109] PCI: Using ACPI for IRQ routing
[    0.214009] PCI: pci_cache_line_size set to 64 bytes
[    0.215147] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.216007] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    0.217221] NetLabel: Initializing
[    0.218006] NetLabel:  domain hash size =3D 128
[    0.219001] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.219921] NetLabel:  unlabeled traffic allowed by default
[    0.221131] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.222025] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.223449] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.228074] Switched to clocksource kvm-clock
[    0.239748] pnp: PnP ACPI init
[    0.240435] ACPI: bus type PNP registered
[    0.241276] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:3)
[    0.242766] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.243862] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:3)
[    0.245359] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.246443] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:3)
[    0.247955] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.249051] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:3)
[    0.250524] pnp 00:03: [dma 2]
[    0.251196] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.252333] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:3)
[    0.253809] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.254945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:3)
[    0.256460] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.257571] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:3)
[    0.259075] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.260282] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.261457] pnp: PnP ACPI: found 8 devices
[    0.262227] ACPI: bus type PNP unregistered
[    0.271724] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.272707] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.273649] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.274712] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.275809] NET: Registered protocol family 2
[    0.276891] TCP established hash table entries: 4096 (order: 3, 32768 =
bytes)
[    0.278061] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    0.279198] TCP: Hash tables configured (established 4096 bind 4096)
[    0.280345] TCP: reno registered
[    0.281025] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.282025] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.283190] NET: Registered protocol family 1
[    0.284224] RPC: Registered named UNIX socket transport module.
[    0.285242] RPC: Registered udp transport module.
[    0.286105] RPC: Registered tcp transport module.
[    0.286975] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.288038] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.289065] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.290064] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.291127] pci 0000:00:02.0: Boot video device
[    0.291985] PCI: CLS 0 bytes, default 64
[    0.293805] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.294893] Initialise system trusted keyring
[    0.295758] audit: initializing netlink subsys (disabled)
[    0.296724] audit: type=3D2000 audit(1396594185.968:1): initialized
[    0.320177] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.322933] zbud: loaded
[    0.323786] VFS: Disk quotas dquot_6.5.2
[    0.324641] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.326149] 9p: Installing v9fs 9p2000 file system support
[    0.327171] msgmni has been set to 972
[    0.328023] Key type big_key registered
[    0.328800] SELinux:  Registering netfilter hooks
[    0.420858] alg: No test for stdrng (krng)
[    0.421709] NET: Registered protocol family 38
[    0.422590] Key type asymmetric registered
[    0.423395] Asymmetric key parser 'x509' registered
[    0.424361] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 250)
[    0.425848] io scheduler noop registered
[    0.426658] io scheduler deadline registered (default)
[    0.427634] io scheduler cfq registered
[    0.428520] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.429510] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.430742] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.432152] ACPI: Power Button [PWRF]
[    0.433113] GHES: HEST is not enabled!
[    0.434019] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.460454] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    0.462520] Non-volatile memory driver v1.3
[    0.463356] Linux agpgart interface v0.103
[    0.464340] rdac: device handler registered
[    0.465230] hp_sw: device handler registered
[    0.466056] emc: device handler registered
[    0.466843] alua: device handler registered
[    0.467685] libphy: Fixed MDIO Bus: probed
[    0.468509] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k=
8-NAPI
[    0.469652] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.470967] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.471968] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:3)
[    0.785642] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34=
:56
[    0.786815] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connect=
ion
[    0.787954] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.788948] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    0.789976] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.=
0.5-k
[    0.791109] igb: Copyright (c) 2007-2013 Intel Corporation.
[    0.792095] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - ve=
rsion 3.19.1-k
[    0.793547] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    0.794598] usbcore: registered new interface driver catc
[    0.795559] usbcore: registered new interface driver kaweth
[    0.796529] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ether=
net driver
[    0.797940] usbcore: registered new interface driver pegasus
[    0.798927] usbcore: registered new interface driver rtl8150
[    0.799922] usbcore: registered new interface driver asix
[    0.800879] usbcore: registered new interface driver cdc_ether
[    0.801881] usbcore: registered new interface driver r815x
[    0.802847] usbcore: registered new interface driver cdc_eem
[    0.803833] usbcore: registered new interface driver dm9601
[    0.804824] usbcore: registered new interface driver smsc75xx
[    0.805823] usbcore: registered new interface driver smsc95xx
[    0.806823] usbcore: registered new interface driver gl620a
[    0.807798] usbcore: registered new interface driver net1080
[    0.808786] usbcore: registered new interface driver plusb
[    0.809762] usbcore: registered new interface driver rndis_host
[    0.810779] usbcore: registered new interface driver cdc_subset
[    0.811794] usbcore: registered new interface driver zaurus
[    0.812776] usbcore: registered new interface driver MOSCHIP usb-ether=
net driver
[    0.814186] usbcore: registered new interface driver int51x1
[    0.815172] usbcore: registered new interface driver ipheth
[    0.816157] usbcore: registered new interface driver sierra_net
[    0.817216] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    0.818312] ehci-pci: EHCI PCI platform driver
[    0.819155] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.820204] ohci-pci: OHCI PCI platform driver
[    0.821056] uhci_hcd: USB Universal Host Controller Interface driver
[    0.822230] usbcore: registered new interface driver usbserial
[    0.823251] usbcore: registered new interface driver usbserial_generic=

[    0.824356] usbserial: USB Serial support registered for generic
[    0.825410] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    0.827574] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.828483] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.829526] mousedev: PS/2 mouse device common for all mice
[    0.830789] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    0.832667] rtc_cmos 00:00: RTC can wake from S4
[    0.834984] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.836143] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpe=
t irqs
[    0.837320] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    0.838452] i6300esb: initialized (0xffffc9000011c000). heartbeat=3D30=
 sec (nowayout=3D0)
[    0.839921] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    0.840899] iTCO_vendor_support: vendor-support=3D0
[    0.841848] hidraw: raw HID events driver (C) Jiri Kosina
[    0.842909] usbcore: registered new interface driver usbhid
[    0.843874] usbhid: USB HID core driver
[    0.844684] drop_monitor: Initializing network drop monitor service
[    0.845795] TCP: cubic registered
[    0.846505] Initializing XFRM netlink socket
[    0.847454] NET: Registered protocol family 10
[    0.848600] NET: Registered protocol family 17
[    0.849465] 9pnet: Installing 9P2000 support
[    0.850502]=20
[    0.850502] printing PIC contents
[    0.851607] ... PIC  IMR: ffff
[    0.852294] ... PIC  IRR: 1113
[    0.852991] ... PIC  ISR: 0000
[    0.853704] ... PIC ELCR: 0c00
[    0.854400] printing local APIC contents on CPU#0/0:
[    0.855353] ... APIC ID:      00000000 (0)
[    0.855395] ... APIC VERSION: 00050014
[    0.855395] ... APIC TASKPRI: 00000000 (00)
[    0.855395] ... APIC PROCPRI: 00000000
[    0.855395] ... APIC LDR: 01000000
[    0.855395] ... APIC DFR: ffffffff
[    0.855395] ... APIC SPIV: 000001ff
[    0.855395] ... APIC ISR field:
[    0.855395] 0000000000000000000000000000000000000000000000000000000000=
000000
[    0.855395] ... APIC TMR field:
[    0.855395] 0000000002000000000000000000000000000000000000000000000000=
000000
[    0.855395] ... APIC IRR field:
[    0.855395] 0000000000000000000000000000000000000000000000000000000000=
000000
[    0.855395] ... APIC ESR: 00000000
[    0.855395] ... APIC ICR: 000008fd
[    0.855395] ... APIC ICR2: 02000000
[    0.855395] ... APIC LVTT: 000000ef
[    0.855395] ... APIC LVTPC: 00010000
[    0.855395] ... APIC LVT0: 00010700
[    0.855395] ... APIC LVT1: 00000400
[    0.855395] ... APIC LVTERR: 000000fe
[    0.855395] ... APIC TMICT: 009eb96b
[    0.855395] ... APIC TMCCT: 00748af3
[    0.855395] ... APIC TDCR: 00000003
[    0.855395]=20
[    0.879733] number of MP IRQ sources: 15.
[    0.880517] number of IO-APIC #0 registers: 24.
[    0.881360] testing the IO APIC.......................
[    0.882284] IO APIC #0......
[    0.882917] .... register #00: 00000000
[    0.883672] .......    : physical APIC id: 00
[    0.884494] .......    : Delivery Type: 0
[    0.885273] .......    : LTS          : 0
[    0.886048] .... register #01: 00170011
[    0.886799] .......     : max redirection entries: 17
[    0.887698] .......     : PRQ implemented: 0
[    0.888510] .......     : IO APIC version: 11
[    0.889330] .... register #02: 00000000
[    0.890087] .......     : arbitration: 00
[    0.890859] .... IRQ redirection table:
[    0.891630] 1    0    0   0   0    0    0    00
[    0.892480] 0    0    0   0   0    1    1    31
[    0.893329] 0    0    0   0   0    1    1    30
[    0.894174] 0    0    0   0   0    1    1    33
[    0.895023] 1    0    0   0   0    1    1    34
[    0.895861] 1    1    0   0   0    1    1    35
[    0.896708] 0    0    0   0   0    1    1    36
[    0.897558] 0    0    0   0   0    1    1    37
[    0.898403] 0    0    0   0   0    1    1    38
[    0.899248] 0    1    0   0   0    1    1    39
[    0.900102] 1    1    0   0   0    1    1    3A
[    0.900944] 1    1    0   0   0    1    1    3B
[    0.901792] 0    0    0   0   0    1    1    3C
[    0.902644] 0    0    0   0   0    1    1    3D
[    0.903490] 0    0    0   0   0    1    1    3E
[    0.904340] 0    0    0   0   0    1    1    3F
[    0.905190] 1    0    0   0   0    0    0    00
[    0.906035] 1    0    0   0   0    0    0    00
[    0.906875] 1    0    0   0   0    0    0    00
[    0.907720] 1    0    0   0   0    0    0    00
[    0.908567] 1    0    0   0   0    0    0    00
[    0.909417] 1    0    0   0   0    0    0    00
[    0.910259] 1    0    0   0   0    0    0    00
[    0.911108] 1    0    0   0   0    0    0    00
[    0.911940] IRQ to pin mappings:
[    0.912625] IRQ0 -> 0:2
[    0.913385] IRQ1 -> 0:1
[    0.914132] IRQ3 -> 0:3
[    0.914876] IRQ4 -> 0:4
[    0.915629] IRQ5 -> 0:5
[    0.916381] IRQ6 -> 0:6
[    0.917128] IRQ7 -> 0:7
[    0.917873] IRQ8 -> 0:8
[    0.918631] IRQ9 -> 0:9
[    0.919389] IRQ10 -> 0:10
[    0.920155] IRQ11 -> 0:11
[    0.920921] IRQ12 -> 0:12
[    0.921697] IRQ13 -> 0:13
[    0.922470] IRQ14 -> 0:14
[    0.923236] IRQ15 -> 0:15
[    0.924010] .................................... done.
[    0.925047] Loading compiled-in X.509 certificates
[    0.926686] Loaded X.509 cert 'Magrathea: Glacier signing key: f30c669=
8d0c0279f20786f6db90c40ed1a37ff2c'
[    0.928372] registered taskstats version 1
[    0.929693] Key type trusted registered
[    0.930899] Key type encrypted registered
[    0.932078] IMA: No TPM chip found, activating TPM-bypass!
[    0.933354] rtc_cmos 00:00: setting system clock to 2014-04-04 14:49:4=
6 UTC (1396622986)
[    0.939108] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    1.294103] tsc: Refined TSC clocksource calibration: 2493.972 MHz
[    1.665251] input: ImExPS/2 Generic Explorer Mouse as /devices/platfor=
m/i8042/serio1/input/input3
[    2.944515] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX
[    2.946332] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    2.957024] Sending DHCP requests ., OK
[    2.961089] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10=
=2E0.2.15
[    2.962434] IP-Config: Complete:
[    2.963139]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D1=
0.0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    2.964803]      host=3Dnfsroot-lkp-ib04-40, domain=3D, nis-domain=3D(=
none)
[    2.965879]      bootserver=3D10.0.2.2, rootserver=3D192.168.1.1, root=
path=3D
[    2.966729]      nameserver0=3D10.0.2.3
[    2.967917] PM: Hibernation image not present or could not be loaded.
[    2.969679] md: Waiting for all devices to be available before autodet=
ect
[    2.971335] md: If you don't use raid, use raid=3Dnoautodetect
[    2.973191] md: Autodetecting RAID arrays.
[    2.974016] md: Scanned 0 and added 0 devices.
[    2.974842] md: autorun ...
[    2.975482] md: ... autorun DONE.
[    2.981685] VFS: Mounted root (nfs filesystem) on device 0:15.
[    2.982934] devtmpfs: mounted
[    2.985152] Freeing unused kernel memory: 1724K (ffffffff81c13000 - ff=
ffffff81dc2000)
[    3.326866] udevd[206]: starting version 175
[    3.916205] random: vgscan urandom read with 62 bits of entropy availa=
ble
[   34.774881] random: nonblocking pool is initialized
Kernel tests: Boot OK!
[   37.905471] Unregister pv shared memory for cpu 1
[   37.916619] smpboot: CPU 1 is now offline
[   37.917504] ------------[ cut here ]------------
[   37.918345] WARNING: CPU: 0 PID: 1932 at kernel/timer.c:1621 migrate_t=
imer_list+0xdb/0xf0()
[   37.918406] migrate_timer_list: can't migrate pinned timer: ffffffff81=
f06a60, timer->function: ffffffff810d7010,deactivating it
[   37.918406] Modules linked in:
[   37.918406] CPU: 0 PID: 1932 Comm: 01-cpu-hotplug Not tainted 3.14.0-r=
c1-00088-gab3c4fd #4
[   37.918406] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   37.918406]  0000000000000009 ffff88001d407c38 ffffffff817237bd ffff88=
001d407c80
[   37.918406]  ffff88001d407c70 ffffffff8106a1dd 0000000000000010 ffffff=
ff81f06a60
[   37.918406]  ffff88001e04d040 ffffffff81e3d4c0 ffff88001e04d030 ffff88=
001d407cd0
[   37.918406] Call Trace:
[   37.918406]  [<ffffffff817237bd>] dump_stack+0x4d/0x66
[   37.918406]  [<ffffffff8106a1dd>] warn_slowpath_common+0x7d/0xa0
[   37.918406]  [<ffffffff8106a24c>] warn_slowpath_fmt+0x4c/0x50
[   37.918406]  [<ffffffff810761c3>] ? __internal_add_timer+0x113/0x130
[   37.918406]  [<ffffffff810d7010>] ? clocksource_watchdog_kthread+0x40/=
0x40
[   37.918406]  [<ffffffff8107753b>] migrate_timer_list+0xdb/0xf0
[   37.918406]  [<ffffffff810782dc>] timer_cpu_notify+0xfc/0x1f0
[   37.918406]  [<ffffffff8173046c>] notifier_call_chain+0x4c/0x70
[   37.918406]  [<ffffffff8109340e>] __raw_notifier_call_chain+0xe/0x10
[   37.918406]  [<ffffffff8106a3f3>] cpu_notify+0x23/0x50
[   37.918406]  [<ffffffff8106a44e>] cpu_notify_nofail+0xe/0x20
[   37.918406]  [<ffffffff81712a5d>] _cpu_down+0x1ad/0x2e0
[   37.918406]  [<ffffffff81712bc4>] cpu_down+0x34/0x50
[   37.918406]  [<ffffffff813fec54>] cpu_subsys_offline+0x14/0x20
[   37.918406]  [<ffffffff813f9f65>] device_offline+0x95/0xc0
[   37.918406]  [<ffffffff813fa060>] online_store+0x40/0x90
[   37.918406]  [<ffffffff813f75d8>] dev_attr_store+0x18/0x30
[   37.918406]  [<ffffffff8123309d>] sysfs_kf_write+0x3d/0x50
[   37.918406]  [<ffffffff81236f12>] kernfs_fop_write+0xd2/0x140
[   37.918406]  [<ffffffff811be22a>] vfs_write+0xba/0x1e0
[   37.918406]  [<ffffffff811bec09>] SyS_write+0x49/0xa0
[   37.918406]  [<ffffffff81735129>] system_call_fastpath+0x16/0x1b
[   37.918406] ---[ end trace dd5b27a5f3b63783 ]---
[   38.067182] x86: Booting SMP configuration:
[   38.068041] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   38.065819] kvm-clock: cpu 1, msr 0:1ff57041, secondary cpu clock
[   38.065819] masked ExtINT on CPU#1
[   38.101844] KVM setup async PF for cpu 1
[   38.102827] kvm-stealtime: cpu 1, msr 1fd0dfc0
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (64bit:274 32bit:312) as to be dis=
abled.
Done parsing arguments.
## couldn't open logfile trinity.log
[   39.119376] Unregister pv shared memory for cpu 1
[   39.128411] smpboot: CPU 1 is now offline
[   49.133186] x86: Booting SMP configuration:
[   49.134061] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   49.132055] kvm-clock: cpu 1, msr 0:1ff57041, secondary cpu clock
[   49.132055] masked ExtINT on CPU#1
[   49.166893] KVM setup async PF for cpu 1
[   49.167682] kvm-stealtime: cpu 1, msr 1fd0dfc0
/etc/kernel-tests/99-trinity: line 17: kill: (1951) - No such process
run-parts: /etc/kernel-tests/99-trinity exited with return code 1
[  151.811051] Unregister pv shared memory for cpu 0
[  151.811939] Unregister pv shared memory for cpu 1
[  151.814601] reboot: Restarting system
[  151.815331] reboot: machine restart
Elapsed time: 155
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-rhel/ab3=
c4fdd657432f23ac1ede2845392c4d4bdb947/vmlinuz-3.14.0-rc1-00088-gab3c4fd -=
append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Ddebug=
 sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 sof=
tlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::nfsroot-lkp=
-ib04-40::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D=
600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-queu=
e/kvm/x86_64-rhel/tchen:vireshk_test/.vmlinuz-ab3c4fdd657432f23ac1ede2845=
392c4d4bdb947-20140404144932-2-lkp-ib04 branch=3Dtchen/vireshk_test BOOT_=
IMAGE=3D/kernel/x86_64-rhel/ab3c4fdd657432f23ac1ede2845392c4d4bdb947/vmli=
nuz-3.14.0-rc1-00088-gab3c4fd drbd.minor_count=3D8'  -m 512 -smp 2 -net n=
ic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::45334-:22 -bo=
ot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfil=
e /dev/shm/kboot/pid-nfsroot-lkp-ib04-40 -serial file:/dev/shm/kboot/seri=
al-nfsroot-lkp-ib04-40 -daemonize -display none -monitor null=20

--------------030604040509090702000602--
