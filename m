Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaIPFW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:22:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51021 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaIPFWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:22:18 -0400
Date: Mon, 15 Sep 2014 13:27:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [torture] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140915202710.GG4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140913122412.GA10984@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140913122412.GA10984@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091605-0928-0000-0000-000004DC3724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 08:24:12PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> commit 945fa9c631b04febe295a3a2a00c7e4a3cfb97db
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Fri Mar 7 14:15:28 2014 -0800
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Wed May 14 09:46:07 2014 -0700
> 
>     torture: Dump ftrace buffer when the RCU grace period stalls
>     
>     This commit adds a call to rcutorture_trace_dump() to dump the ftrace
>     buffer when the RCU grace period stalls in order to help debug the
>     stall.  Note that this is different than the RCU CPU stall warning,
>     as it is rcutorture detecting the stall rather than the underlying RCU
>     implementation.
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Odd.  If the code added in this commit actually affected anything, I would
expect to have seen an RCU CPU stall warning.  And looking at the dmesg,
ftrace_dump() was in fact invoked elsewhere, namely from rcutorture.
Which means that some other problem exists, but it is hard to imagine
addition of code that was not executed being the root cause.  And there
is a big gap in the dmesg between 60 and 120 seconds after boot.

Feels like we are chasing a ghost here.

Does reverting this commit make the bad-commit problems go away?

(Note that this commit is not hugely valuable, so I am OK with a
guily-till-proven-innocent reversion, if that helps.)

								Thanx, Paul

> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> It does look like an unrelated warning.
> 
> +------------------------------------------------------+------------+------------+------------+
> |                                                      | 499c632dce | 945fa9c631 | 0e980234c9 |
> +------------------------------------------------------+------------+------------+------------+
> | boot_successes                                       | 131        | 0          | 0          |
> | boot_failures                                        | 9          | 20         | 40         |
> | WARNING:at_kernel/events/core.c:perf_swevent_add()   | 9          |            |            |
> | BUG:unable_to_handle_kernel                          | 0          | 20         | 20         |
> | Oops                                                 | 0          | 20         | 40         |
> | RIP:print_trace_line                                 | 0          | 20         | 40         |
> | Kernel_panic-not_syncing:Fatal_exception             | 0          | 20         | 40         |
> | backtrace:rcu_torture_stats                          | 0          | 20         | 40         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 0          | 20         |
> +------------------------------------------------------+------------+------------+------------+
> 
> mount: mounting proc on /proc failed: No such device
> [  121.930088] Dumping ftrace buffer:
> [  121.930453] ---------------------------------
> [  121.930865] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  121.931644] IP: [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.932194] PGD 10876067 PUD 10892067 PMD 0 
> [  121.932613] Oops: 0000 [#1] PREEMPT SMP 
> [  121.933069] CPU: 0 PID: 47 Comm: rcu_torture_sta Not tainted 3.15.0-rc1-00026-g945fa9c #24
> [  121.933837] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [  121.934716] task: ffff880012388000 ti: ffff88001238a000 task.ti: ffff88001238a000
> [  121.935348] RIP: 0010:[<ffffffff8959b074>]  [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.936092] RSP: 0018:ffff88001238bca8  EFLAGS: 00010097
> [  121.936547] RAX: 0000000000000000 RBX: ffffffff8d12e600 RCX: 0000000000000000
> [  121.937159] RDX: 0000000000000001 RSI: ffffffff8ad13f33 RDI: 0000000000000000
> [  121.937770] RBP: ffff88001238bcd8 R08: 0000000000000009 R09: 00000000fffffff4
> [  121.938375] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000003bd1201
> [  121.938983] R13: ffff880012a82014 R14: ffffffff8d12f6fc R15: 0000000000000000
> [  121.939649] FS:  0000000000000000(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
> [  121.940013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  121.940013] CR2: 0000000000000000 CR3: 0000000010994000 CR4: 00000000000006b0
> [  121.940013] Stack:
> [  121.940013]  00000000018c2d94 0000000000000286 0000000000000001 0000000000000000
> [  121.940013]  ffffffff8d12f6fc 0000000000000000 ffff88001238bd08 ffffffff8959d169
> [  121.940013]  ffff88001099814c ffffffff8d118d8c 00000000ffffffff ffff88001238bec8
> [  121.940013] Call Trace:
> [  121.940013]  [<ffffffff8959d169>] ftrace_dump+0x180/0x21e
> [  121.940013]  [<ffffffff89562d51>] rcutorture_trace_dump+0x5a/0x5c
> [  121.940013]  [<ffffffff8956371d>] rcu_torture_printk+0x49d/0x4b8
> [  121.940013]  [<ffffffff8956379d>] rcu_torture_stats_print+0x65/0x83
> [  121.940013]  [<ffffffff895637bb>] ? rcu_torture_stats_print+0x83/0x83
> [  121.940013]  [<ffffffff89563807>] rcu_torture_stats+0x4c/0x71
> [  121.940013]  [<ffffffff8952745a>] kthread+0xf9/0x101
> [  121.940013]  [<ffffffff89527361>] ? __kthread_parkme+0x86/0x86
> [  121.940013]  [<ffffffff8a375c4c>] ret_from_fork+0x7c/0xb0
> [  121.940013]  [<ffffffff89527361>] ? __kthread_parkme+0x86/0x86
> [  121.940013] Code: e9 e2 00 00 00 41 f7 c4 00 10 00 00 74 7d f6 83 d8 00 00 00 02 74 74 8b bb 20 21 00 00 4c 8b bb f0 10 00 00 e8 6d b8 ff ff 89 c0 <49> 0f a3 07 19 c0 85 c0 75 56 48 63 93 20 21 00 00 48 8b 43 10 
> [  121.940013] RIP  [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.940013]  RSP <ffff88001238bca8>
> [  121.940013] CR2: 0000000000000000
> [  121.940013] ---[ end trace 605ab88dfe93d9f3 ]---
> [  121.940013] Kernel panic - not syncing: Fatal exception
> 
> git bisect start 0e980234c97f98be6619b9281d83777f725b94ff v3.2 --
> git bisect good f741656d646f7a5b56ba86765205b954237e7956  # 14:01     20+     14  Merge tag 'stable/for-linus-3.8-rc7-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
> git bisect good 9538e10086bd1301fe915683b1ba0a1de66d7483  # 14:23     20+      4  Merge git://www.linux-watchdog.org/linux-watchdog
> git bisect good 83660b734bbbae4f15c1a9b14d0514d74f79dfd4  # 14:44     20+      4  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good 1f8c538ed6a3323b06c2459e9ca36e0ae8bb0ebc  # 15:09     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> git bisect good 3f583bc21977a608908b83d03ee2250426a5695c  # 15:23     20+      2  Merge tag 'iommu-updates-v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu
> git bisect good 3e8072d48b2dd0898e99698018b2045f8cd49965  # 15:44     20+      1  Merge git://git.infradead.org/users/willy/linux-nvme
> git bisect good 9352ad13391d8948fa919b97ed5ad68c96378f92  # 16:03     20+      2  torture: Add batch headers "--dryrun sched"
> git bisect good 97dc0afed12b371f450d04cb406a8664437ec843  # 16:16     20+      3  torture: Make config-fragment filtering RCU-independent
> git bisect good fff35c4e9fbb0982aef6230cbf713c2492925eca  # 16:33     20+      2  torture: Report diagnostics from qemu
> git bisect good f189cc8c9451aa88bc718c57aa0228d2a7555956  # 16:49     20+      1  torture: Choose bzImage location based on architecture
> git bisect  bad 945fa9c631b04febe295a3a2a00c7e4a3cfb97db  # 17:04      0-      6  torture: Dump ftrace buffer when the RCU grace period stalls
> git bisect good 499c632dce47e95280f8b99540c5db294053c94c  # 17:27     20+      4  torture: Add tracing-enabled variant of TREE02
> # first bad commit: [945fa9c631b04febe295a3a2a00c7e4a3cfb97db] torture: Dump ftrace buffer when the RCU grace period stalls
> git bisect good 499c632dce47e95280f8b99540c5db294053c94c  # 17:34     60+      7  torture: Add tracing-enabled variant of TREE02
> git bisect good 499c632dce47e95280f8b99540c5db294053c94c  # 17:40     60+      9  torture: Add tracing-enabled variant of TREE02
> git bisect  bad fc486b03cae382601b366ab460b05e1a01bf69cd  # 17:56      0-     10  Merge tag 'stable/for-linus-3.17-b-rc4-arm-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
> git bisect  bad fcc8fd7117b3960d50439f2c4247f80d74974c95  # 18:07      2-      5  Add linux-next specific files for 20140912
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 1
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> KASLR using RDTSC...
> 
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00026-g945fa9c (kbuild@jaketown) (gcc version 4.9.1 (Debian 4.9.1-11) ) #24 SMP PREEMPT Sat Sep 13 17:00:24 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:945fa9c631b04febe295a3a2a00c7e4a3cfb97db:bisect-linux-8/.vmlinuz-945fa9c631b04febe295a3a2a00c7e4a3cfb97db-20140913170207-9-ivb41 branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.8 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13fe0 max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at [ffff8800000f0ed0]
> [    0.000000]   mpc: f0ee0-f0fb0
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0d23e000, 0x0d23efff] PGTABLE
> [    0.000000] BRK [0x0d23f000, 0x0d23ffff] PGTABLE
> [    0.000000] BRK [0x0d240000, 0x0d240fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
> [    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
> [    0.000000]  [mem 0x10000000-0x139fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
> [    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
> [    0.000000] BRK [0x0d241000, 0x0d241fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x13cd6000-0x13fdffff]
> [    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x0000000013FE0000 000040
> [    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13c56001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e00000-ffff8800133fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
> [    0.000000] On node 0 totalpages: 81790
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880013a00000 s1920320 r0 d21184 u2097152
> [    0.000000] pcpu-alloc: s1920320 r0 d21184 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 13a0dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80649
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:945fa9c631b04febe295a3a2a00c7e4a3cfb97db:bisect-linux-8/.vmlinuz-945fa9c631b04febe295a3a2a00c7e4a3cfb97db-20140913170207-9-ivb41 branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 250788K/327160K available (15846K kernel code, 22756K rwdata, 10552K rodata, 3116K init, 9168K bss, 76372K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> [    0.000000] NR_IRQS:524544 nr_irqs:256 16
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00026-g945fa9c (kbuild@jaketown) (gcc version 4.9.1 (Debian 4.9.1-11) ) #24 SMP PREEMPT Sat Sep 13 17:00:24 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:945fa9c631b04febe295a3a2a00c7e4a3cfb97db:bisect-linux-8/.vmlinuz-945fa9c631b04febe295a3a2a00c7e4a3cfb97db-20140913170207-9-ivb41 branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.8 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13fe0 max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at [ffff8800000f0ed0]
> [    0.000000]   mpc: f0ee0-f0fb0
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0d23e000, 0x0d23efff] PGTABLE
> [    0.000000] BRK [0x0d23f000, 0x0d23ffff] PGTABLE
> [    0.000000] BRK [0x0d240000, 0x0d240fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
> [    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
> [    0.000000]  [mem 0x10000000-0x139fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
> [    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
> [    0.000000] BRK [0x0d241000, 0x0d241fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x13cd6000-0x13fdffff]
> [    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x0000000013FE0000 000040
> [    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13c56001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e00000-ffff8800133fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
> [    0.000000] On node 0 totalpages: 81790
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880013a00000 s1920320 r0 d21184 u2097152
> [    0.000000] pcpu-alloc: s1920320 r0 d21184 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 13a0dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80649
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:945fa9c631b04febe295a3a2a00c7e4a3cfb97db:bisect-linux-8/.vmlinuz-945fa9c631b04febe295a3a2a00c7e4a3cfb97db-20140913170207-9-ivb41 branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 250788K/327160K available (15846K kernel code, 22756K rwdata, 10552K rodata, 3116K init, 9168K bss, 76372K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> [    0.000000] NR_IRQS:524544 nr_irqs:256 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.508 MHz processor
> [    0.000000] tsc: Detected 2693.508 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=26935080)
> 5387.01 BogoMIPS (lpj=26935080)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] ACPI: Core revision 20140214
> [    0.020000] ACPI: Core revision 20140214
> [    0.032652] ACPI: 
> [    0.032652] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables successfully acquired
> 
> [    0.034043] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.034043] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.035483] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.035483] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.037753] Initializing cgroup subsys debug
> [    0.037753] Initializing cgroup subsys debug
> [    0.038751] Initializing cgroup subsys devices
> [    0.038751] Initializing cgroup subsys devices
> [    0.040024] Initializing cgroup subsys blkio
> [    0.040024] Initializing cgroup subsys blkio
> [    0.040837] Initializing cgroup subsys perf_event
> [    0.040837] Initializing cgroup subsys perf_event
> [    0.042016] Initializing cgroup subsys hugetlb
> [    0.042016] Initializing cgroup subsys hugetlb
> [    0.043085] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.043085] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.043085] tlb_flushall_shift: 6
> [    0.043085] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.043085] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.043085] tlb_flushall_shift: 6
> [    0.055837] Freeing SMP alternatives memory: 16K (ffffffff8c945000 - ffffffff8c949000)
> [    0.055837] Freeing SMP alternatives memory: 16K (ffffffff8c945000 - ffffffff8c949000)
> [    0.058950] Getting VERSION: 1050014
> [    0.058950] Getting VERSION: 1050014
> [    0.059942] Getting VERSION: 1050014
> [    0.059942] Getting VERSION: 1050014
> [    0.060023] Getting ID: 0
> [    0.060023] Getting ID: 0
> [    0.060676] Getting ID: ff000000
> [    0.060676] Getting ID: ff000000
> [    0.061488] Getting LVT0: 8700
> [    0.061488] Getting LVT0: 8700
> [    0.062201] Getting LVT1: 8400
> [    0.062201] Getting LVT1: 8400
> [    0.062748] enabled ExtINT on CPU#0
> [    0.062748] enabled ExtINT on CPU#0
> [    0.064354] ENABLING IO-APIC IRQs
> [    0.064354] ENABLING IO-APIC IRQs
> [    0.065055] init IO_APIC IRQs
> [    0.065055] init IO_APIC IRQs
> [    0.065613]  apic 0 pin 0 not connected
> [    0.065613]  apic 0 pin 0 not connected
> [    0.066499] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.066499] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.068143] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.068143] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.070036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.070036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.071783] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.071783] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.073351] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.073351] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.075090] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.075090] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.076659] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.076659] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.078310] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.078310] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.080040] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.080040] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.081660] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.081660] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.083197] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.083197] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.084865] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.084865] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.086427] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.086427] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.088086] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.088086] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.089627] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.089627] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.090041]  apic 0 pin 16 not connected
> [    0.090041]  apic 0 pin 16 not connected
> [    0.090863]  apic 0 pin 17 not connected
> [    0.090863]  apic 0 pin 17 not connected
> [    0.091601]  apic 0 pin 18 not connected
> [    0.091601]  apic 0 pin 18 not connected
> [    0.092375]  apic 0 pin 19 not connected
> [    0.092375]  apic 0 pin 19 not connected
> [    0.093154]  apic 0 pin 20 not connected
> [    0.093154]  apic 0 pin 20 not connected
> [    0.093824]  apic 0 pin 21 not connected
> [    0.093824]  apic 0 pin 21 not connected
> [    0.094580]  apic 0 pin 22 not connected
> [    0.094580]  apic 0 pin 22 not connected
> [    0.095320]  apic 0 pin 23 not connected
> [    0.095320]  apic 0 pin 23 not connected
> [    0.096261] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.096261] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.097357] smpboot: CPU0: 
> [    0.097357] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
> , stepping: 01)
> [    0.100265] Using local APIC timer interrupts.
> [    0.100265] calibrating APIC timer ...
> [    0.100265] Using local APIC timer interrupts.
> [    0.100265] calibrating APIC timer ...
> [    0.110000] ... lapic delta = 6249666
> [    0.110000] ... lapic delta = 6249666
> [    0.110000] ... PM-Timer delta = 357918
> [    0.110000] ... PM-Timer delta = 357918
> [    0.110000] ... PM-Timer result ok
> [    0.110000] ... PM-Timer result ok
> [    0.110000] ..... delta 6249666
> [    0.110000] ..... delta 6249666
> [    0.110000] ..... mult: 268421110
> [    0.110000] ..... mult: 268421110
> [    0.110000] ..... calibration result: 9999465
> [    0.110000] ..... calibration result: 9999465
> [    0.110000] ..... CPU clock speed is 2693.2324 MHz.
> [    0.110000] ..... CPU clock speed is 2693.2324 MHz.
> [    0.110000] ..... host bus clock speed is 999.9465 MHz.
> [    0.110000] ..... host bus clock speed is 999.9465 MHz.
> [    0.110000] Performance Events: 
> [    0.110000] Performance Events: unsupported Netburst CPU model 6 unsupported Netburst CPU model 6 no PMU driver, software events only.
> no PMU driver, software events only.
> [    0.140069] ftrace: Allocated trace_printk buffers
> [    0.140069] ftrace: Allocated trace_printk buffers
> [    0.142018] Testing tracer nop: 
> [    0.142018] Testing tracer nop: PASSED
> PASSED
> [    0.142767] x86: Booted up 1 node, 1 CPUs
> [    0.142767] x86: Booted up 1 node, 1 CPUs
> [    0.143453] smpboot: Total of 1 processors activated (5387.01 BogoMIPS)
> [    0.143453] smpboot: Total of 1 processors activated (5387.01 BogoMIPS)
> [    0.145642] devtmpfs: initialized
> [    0.145642] devtmpfs: initialized
> [    0.148580] Testing tracer function: 
> [    0.148580] Testing tracer function: PASSED
> PASSED
> [    0.272178] Testing ftrace regs(no arch support): 
> [    0.272178] Testing ftrace regs(no arch support): PASSED
> PASSED
> [    0.275664] Testing tracer preemptoff: 
> [    0.275664] Testing tracer preemptoff: PASSED
> PASSED
> [    0.277695] Testing tracer function_graph: 
> [    0.277695] Testing tracer function_graph: PASSED
> PASSED
> [    0.380443] Testing tracer branch: 
> [    0.380443] Testing tracer branch: PASSED
> PASSED
> [    0.502815] xor: measuring software checksum speed
> [    0.502815] xor: measuring software checksum speed
> [    0.600014]    prefetch64-sse:  8458.400 MB/sec
> [    0.600014]    prefetch64-sse:  8458.400 MB/sec
> [    0.700017]    generic_sse: 10109.200 MB/sec
> [    0.700017]    generic_sse: 10109.200 MB/sec
> [    0.701287] xor: using function: generic_sse (10109.200 MB/sec)
> [    0.701287] xor: using function: generic_sse (10109.200 MB/sec)
> [    0.702984] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.702984] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.705261] regulator-dummy: no parameters
> [    0.705261] regulator-dummy: no parameters
> [    0.706587] NET: Registered protocol family 16
> [    0.706587] NET: Registered protocol family 16
> [    0.708710] cpuidle: using governor ladder
> [    0.708710] cpuidle: using governor ladder
> [    0.709470] cpuidle: using governor menu
> [    0.709470] cpuidle: using governor menu
> [    0.740691] ACPI: bus type PCI registered
> [    0.740691] ACPI: bus type PCI registered
> [    0.741558] PCI: Using configuration type 1 for base access
> [    0.741558] PCI: Using configuration type 1 for base access
> [    0.940058] raid6: sse2x1    5331 MB/s
> [    0.940058] raid6: sse2x1    5331 MB/s
> [    1.110020] raid6: sse2x2    6375 MB/s
> [    1.110020] raid6: sse2x2    6375 MB/s
> [    1.280025] raid6: sse2x4    6787 MB/s
> [    1.280025] raid6: sse2x4    6787 MB/s
> [    1.281003] raid6: using algorithm sse2x4 (6787 MB/s)
> [    1.281003] raid6: using algorithm sse2x4 (6787 MB/s)
> [    1.282275] raid6: using intx1 recovery algorithm
> [    1.282275] raid6: using intx1 recovery algorithm
> [    1.284347] ACPI: Added _OSI(Module Device)
> [    1.284347] ACPI: Added _OSI(Module Device)
> [    1.285414] ACPI: Added _OSI(Processor Device)
> [    1.285414] ACPI: Added _OSI(Processor Device)
> [    1.286539] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.286539] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.287721] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.287721] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.307850] ACPI: Interpreter enabled
> [    1.307850] ACPI: Interpreter enabled
> [    1.308804] ACPI Exception: AE_NOT_FOUND, 
> [    1.308804] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.310582] ACPI Exception: AE_NOT_FOUND, 
> [    1.310582] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.312991] ACPI: (supports S0 S3 S5)
> [    1.312991] ACPI: (supports S0 S3 S5)
> [    1.313926] ACPI: Using IOAPIC for interrupt routing
> [    1.313926] ACPI: Using IOAPIC for interrupt routing
> [    1.315311] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.315311] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.354613] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.354613] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.356208] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.356208] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.357978] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.357978] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.360912] PCI host bridge to bus 0000:00
> [    1.360912] PCI host bridge to bus 0000:00
> [    1.361963] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.361963] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.363346] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.363346] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.364903] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
> [    1.364903] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
> [    1.366461] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
> [    1.366461] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
> [    1.368009] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
> [    1.368009] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
> [    1.369562] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
> [    1.369562] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
> [    1.370013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.370013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.371727] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebfffff]
> [    1.371727] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebfffff]
> [    1.373539] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.373539] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.376455] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.376455] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.380731] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.380731] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.385688] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    1.385688] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    1.388352] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    1.388352] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    1.390011] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    1.390011] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    1.391637] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    1.391637] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    1.393418] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    1.393418] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    1.396095] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.396095] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.398144] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
> [    1.398144] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
> [    1.400024] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
> [    1.400024] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
> [    1.403018] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.403018] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.406169] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    1.406169] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    1.409335] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    1.409335] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    1.417183] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    1.417183] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    1.421234] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    1.421234] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    1.423921] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
> [    1.423921] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
> [    1.426604] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    1.426604] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    1.433339] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
> [    1.433339] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
> [    1.436210] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    1.436210] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    1.438355] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    1.438355] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    1.444935] pci_bus 0000:00: on NUMA node 0
> [    1.444935] pci_bus 0000:00: on NUMA node 0
> [    1.449384] ACPI: PCI Interrupt Link [LNKA] (IRQs
> [    1.449384] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))
> 
> [    1.451187] ACPI: PCI Interrupt Link [LNKB] (IRQs
> [    1.451187] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))
> 
> [    1.453566] ACPI: PCI Interrupt Link [LNKC] (IRQs
> [    1.453566] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))
> 
> [    1.455949] ACPI: PCI Interrupt Link [LNKD] (IRQs
> [    1.455949] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))
> 
> [    1.457910] ACPI: PCI Interrupt Link [LNKS] (IRQs
> [    1.457910] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))
> 
> [    1.461842] ACPI: 
> [    1.461842] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in block 00 to 0F
> 
> [    1.469280] SCSI subsystem initialized
> [    1.469280] SCSI subsystem initialized
> [    1.470538] pps_core: LinuxPPS API ver. 1 registered
> [    1.470538] pps_core: LinuxPPS API ver. 1 registered
> [    1.472703] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.472703] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.476335] PTP clock support registered
> [    1.476335] PTP clock support registered
> [    1.477336] EDAC MC: Ver: 3.0.0
> [    1.477336] EDAC MC: Ver: 3.0.0
> [    1.478349] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    1.478349] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    1.480548] wmi: Mapper loaded
> [    1.480548] wmi: Mapper loaded
> [    1.481358] Advanced Linux Sound Architecture Driver Initialized.
> [    1.481358] Advanced Linux Sound Architecture Driver Initialized.
> [    1.482660] PCI: Using ACPI for IRQ routing
> [    1.482660] PCI: Using ACPI for IRQ routing
> [    1.483626] PCI: pci_cache_line_size set to 64 bytes
> [    1.483626] PCI: pci_cache_line_size set to 64 bytes
> [    1.485086] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.485086] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.486600] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
> [    1.486600] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
> [    1.488597] NET: Registered protocol family 23
> [    1.488597] NET: Registered protocol family 23
> [    1.489723] Bluetooth: Core ver 2.19
> [    1.489723] Bluetooth: Core ver 2.19
> [    1.490091] NET: Registered protocol family 31
> [    1.490091] NET: Registered protocol family 31
> [    1.490883] Bluetooth: HCI device and connection manager initialized
> [    1.490883] Bluetooth: HCI device and connection manager initialized
> [    1.492257] Bluetooth: HCI socket layer initialized
> [    1.492257] Bluetooth: HCI socket layer initialized
> [    1.493541] Bluetooth: L2CAP socket layer initialized
> [    1.493541] Bluetooth: L2CAP socket layer initialized
> [    1.494743] Bluetooth: SCO socket layer initialized
> [    1.494743] Bluetooth: SCO socket layer initialized
> [    1.496085] NET: Registered protocol family 8
> [    1.496085] NET: Registered protocol family 8
> [    1.496883] NET: Registered protocol family 20
> [    1.496883] NET: Registered protocol family 20
> [    1.498049] nfc: nfc_init: NFC Core ver 0.1
> [    1.498049] nfc: nfc_init: NFC Core ver 0.1
> [    1.499031] NET: Registered protocol family 39
> [    1.499031] NET: Registered protocol family 39
> [    1.500562] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    1.500562] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    1.502032] Switched to clocksource kvm-clock
> [    1.502032] Switched to clocksource kvm-clock
> [    1.504150] Warning: could not register all branches stats
> [    1.504150] Warning: could not register all branches stats
> [    1.505502] Warning: could not register annotated branches stats
> [    1.505502] Warning: could not register annotated branches stats
> [    1.651965] FS-Cache: Loaded
> [    1.651965] FS-Cache: Loaded
> [    1.652994] CacheFiles: Loaded
> [    1.652994] CacheFiles: Loaded
> [    1.653988] pnp: PnP ACPI init
> [    1.653988] pnp: PnP ACPI init
> [    1.654908] ACPI: bus type PNP registered
> [    1.654908] ACPI: bus type PNP registered
> [    1.656202] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    1.656202] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    1.658608] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.658608] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.660609] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    1.660609] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    1.662983] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.662983] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.664828] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    1.664828] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    1.667126] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.667126] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.669021] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    1.669021] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    1.671106] pnp 00:03: [dma 2]
> [    1.671106] pnp 00:03: [dma 2]
> [    1.672104] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    1.672104] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    1.674105] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    1.674105] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    1.676495] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    1.676495] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    1.678511] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    1.678511] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    1.680916] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.680916] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.684775] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.684775] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.687350] pnp: PnP ACPI: found 7 devices
> [    1.687350] pnp: PnP ACPI: found 7 devices
> [    1.688415] ACPI: bus type PNP unregistered
> [    1.688415] ACPI: bus type PNP unregistered
> [    1.697207] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.697207] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.698733] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
> [    1.698733] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
> [    1.700260] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
> [    1.700260] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
> [    1.701774] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
> [    1.701774] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
> [    1.703253] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
> [    1.703253] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
> [    1.704686] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
> [    1.704686] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
> [    1.706280] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
> [    1.706280] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
> [    1.707946] NET: Registered protocol family 1
> [    1.707946] NET: Registered protocol family 1
> [    1.709077] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.709077] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.710639] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.710639] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.712139] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.712139] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.713812] pci 0000:00:02.0: Boot video device
> [    1.713812] pci 0000:00:02.0: Boot video device
> [    1.715075] PCI: CLS 0 bytes, default 64
> [    1.715075] PCI: CLS 0 bytes, default 64
> [    1.716640] Unpacking initramfs...
> [    1.716640] Unpacking initramfs...
> [    1.869653] Freeing initrd memory: 3112K (ffff880013cd6000 - ffff880013fe0000)
> [    1.869653] Freeing initrd memory: 3112K (ffff880013cd6000 - ffff880013fe0000)
> [    1.873917] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    1.873917] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    1.876380] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    1.876380] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    1.878987] cryptomgr_test (27) used greatest stack depth: 6472 bytes left
> [    1.878987] cryptomgr_test (27) used greatest stack depth: 6472 bytes left
> [    1.881031] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    1.881031] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    1.885729] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    1.885729] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    1.887519] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    1.887519] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    1.889145] AVX or AES-NI instructions are not detected.
> [    1.889145] AVX or AES-NI instructions are not detected.
> [    1.890696] AVX instructions are not detected.
> [    1.890696] AVX instructions are not detected.
> [    1.891850] AVX instructions are not detected.
> [    1.891850] AVX instructions are not detected.
> [    1.893005] AVX instructions are not detected.
> [    1.893005] AVX instructions are not detected.
> [    1.894202] AVX2 or AES-NI instructions are not detected.
> [    1.894202] AVX2 or AES-NI instructions are not detected.
> [    1.895743] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    1.895743] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    1.904255] rcu-torture: Creating rcu_torture_writer task
> [    1.904255] rcu-torture: Creating rcu_torture_writer task
> [    1.905795] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.905795] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.907330] rcu-torture: rcu_torture_writer task started
> [    1.907330] rcu-torture: rcu_torture_writer task started
> [    1.908738] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.908738] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.910392] rcu-torture: rcu_torture_fakewriter task started
> [    1.910392] rcu-torture: rcu_torture_fakewriter task started
> [    1.911899] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.911899] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.913481] rcu-torture: rcu_torture_fakewriter task started
> [    1.913481] rcu-torture: rcu_torture_fakewriter task started
> [    1.915058] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.915058] rcu-torture: Creating rcu_torture_fakewriter task
> [    1.916680] rcu-torture: rcu_torture_fakewriter task started
> [    1.916680] rcu-torture: rcu_torture_fakewriter task started
> [    1.918249] rcu-torture: Creating rcu_torture_reader task
> [    1.918249] rcu-torture: Creating rcu_torture_reader task
> [    1.919775] rcu-torture: rcu_torture_fakewriter task started
> [    1.919775] rcu-torture: rcu_torture_fakewriter task started
> [    1.922283] rcu-torture: Creating rcu_torture_reader task
> [    1.922283] rcu-torture: Creating rcu_torture_reader task
> [    1.923790] rcu-torture: rcu_torture_reader task started
> [    1.923790] rcu-torture: rcu_torture_reader task started
> [    1.925201] rcu-torture: Creating rcu_torture_stats task
> [    1.925201] rcu-torture: Creating rcu_torture_stats task
> [    1.926639] rcu-torture: rcu_torture_reader task started
> [    1.926639] rcu-torture: rcu_torture_reader task started
> [    1.928056] rcu-torture: Creating torture_shuffle task
> [    1.928056] rcu-torture: Creating torture_shuffle task
> [    1.929439] rcu-torture: rcu_torture_stats task started
> [    1.929439] rcu-torture: rcu_torture_stats task started
> [    1.930912] rcu-torture: Creating torture_stutter task
> [    1.930912] rcu-torture: Creating torture_stutter task
> [    1.932304] rcu-torture: torture_shuffle task started
> [    1.932304] rcu-torture: torture_shuffle task started
> [    1.934831] futex hash table entries: 256 (order: 3, 32768 bytes)
> [    1.934831] futex hash table entries: 256 (order: 3, 32768 bytes)
> [    1.936507] Initialise system trusted keyring
> [    1.936507] Initialise system trusted keyring
> [    1.939050] rcu-torture: torture_stutter task started
> [    1.939050] rcu-torture: torture_stutter task started
> [    1.941356] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.941356] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.949671] VFS: Disk quotas dquot_6.5.2
> [    1.949671] VFS: Disk quotas dquot_6.5.2
> [    1.950775] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.950775] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.953270] fuse init (API version 7.23)
> [    1.953270] fuse init (API version 7.23)
> [    1.954755] JFS: nTxBlock = 1983, nTxLock = 15869
> [    1.954755] JFS: nTxBlock = 1983, nTxLock = 15869
> [    1.957555] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    1.957555] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    1.960549] NILFS version 2 loaded
> [    1.960549] NILFS version 2 loaded
> [    1.961748] ocfs2 stack glue: unable to register sysctl
> [    1.961748] ocfs2 stack glue: unable to register sysctl
> [    1.963158] ocfs2: Registered cluster interface o2cb
> [    1.963158] ocfs2: Registered cluster interface o2cb
> [    1.964622] OCFS2 User DLM kernel interface loaded
> [    1.964622] OCFS2 User DLM kernel interface loaded
> [    1.967454] gfs2: GFS2 installed
> [    1.967454] gfs2: GFS2 installed
> [    1.968424] Key type big_key registered
> [    1.968424] Key type big_key registered
> [    1.986047] NET: Registered protocol family 38
> [    1.986047] NET: Registered protocol family 38
> [    1.987325] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    1.987325] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    1.989235] io scheduler noop registered
> [    1.989235] io scheduler noop registered
> [    1.990661] io scheduler deadline registered (default)
> [    1.990661] io scheduler deadline registered (default)
> [    1.992003] io scheduler cfq registered
> [    1.992003] io scheduler cfq registered
> [    1.993002] test_string_helpers: Running tests...
> [    1.993002] test_string_helpers: Running tests...
> [    1.998690] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    1.998690] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    2.001685] vmlfb: initializing
> [    2.001685] vmlfb: initializing
> [    2.002708] Could not find Carillo Ranch MCH device.
> [    2.002708] Could not find Carillo Ranch MCH device.
> [    2.005266] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    2.005266] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    2.007169] ACPI: Power Button [PWRF]
> [    2.007169] ACPI: Power Button [PWRF]
> [    2.120097] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    2.120097] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    2.146154] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    2.146154] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    2.153349] Cyclades driver 2.6
> [    2.153349] Cyclades driver 2.6
> [    2.154672] MOXA Intellio family driver version 6.0k
> [    2.154672] MOXA Intellio family driver version 6.0k
> [    2.156081] MOXA Smartio/Industio family driver version 2.0.5
> [    2.156081] MOXA Smartio/Industio family driver version 2.0.5
> [    2.157670] RocketPort device driver module, version 2.09, 12-June-2003
> [    2.157670] RocketPort device driver module, version 2.09, 12-June-2003
> [    2.159417] No rocketport ports found; unloading driver
> [    2.159417] No rocketport ports found; unloading driver
> [    2.160906] SyncLink serial driver $Revision: 4.38 $
> [    2.160906] SyncLink serial driver $Revision: 4.38 $
> [    2.192613] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    2.192613] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    2.194810] lp: driver loaded but no devices found
> [    2.194810] lp: driver loaded but no devices found
> [    2.196101] ppdev: user-space parallel port driver
> [    2.196101] ppdev: user-space parallel port driver
> [    2.197364] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    2.197364] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    2.198712] smapi::smapi_init, ERROR invalid usSmapiID
> [    2.198712] smapi::smapi_init, ERROR invalid usSmapiID
> [    2.200079] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    2.200079] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    2.202614] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    2.202614] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    2.204693] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    2.204693] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    2.206527] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    2.206527] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    2.208258] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    2.208258] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    2.210717] Hangcheck: Using getrawmonotonic().
> [    2.210717] Hangcheck: Using getrawmonotonic().
> [    2.212793] [drm] Initialized drm 1.1.0 20060810
> [    2.212793] [drm] Initialized drm 1.1.0 20060810
> [    2.214670] [drm] radeon kernel modesetting enabled.
> [    2.214670] [drm] radeon kernel modesetting enabled.
> [    2.217989] [TTM] Zone  kernel: Available graphics memory: 126958 kiB
> [    2.217989] [TTM] Zone  kernel: Available graphics memory: 126958 kiB
> [    2.219656] [TTM] Initializing pool allocator
> [    2.219656] [TTM] Initializing pool allocator
> [    2.220975] [TTM] Initializing DMA pool allocator
> [    2.220975] [TTM] Initializing DMA pool allocator
> [    2.223779] [drm] fb mappable at 0xFC000000
> [    2.223779] [drm] fb mappable at 0xFC000000
> [    2.224928] [drm] vram aper at 0xFC000000
> [    2.224928] [drm] vram aper at 0xFC000000
> [    2.226014] [drm] size 4194304
> [    2.226014] [drm] size 4194304
> [    2.226847] [drm] fb depth is 24
> [    2.226847] [drm] fb depth is 24
> [    2.227731] [drm]    pitch is 3072
> [    2.227731] [drm]    pitch is 3072
> [    2.229378] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    2.229378] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    2.231176] cirrus 0000:00:02.0: registered panic notifier
> [    2.231176] cirrus 0000:00:02.0: registered panic notifier
> [    2.232676] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    2.232676] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    2.235680] parport_pc 00:04: reported by Plug and Play ACPI
> [    2.235680] parport_pc 00:04: reported by Plug and Play ACPI
> [    2.237228] parport0: PC-style at 0x378
> [    2.237228] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,...)(,...)]
> ]
> [    2.239583] lp0: using parport0 (interrupt-driven).
> [    2.239583] lp0: using parport0 (interrupt-driven).
> [    2.240901] lp0: console ready
> [    2.240901] lp0: console ready
> [    2.244009] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    2.244009] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    2.246066] dummy-irq: no IRQ given.  Use irq=N
> [    2.246066] dummy-irq: no IRQ given.  Use irq=N
> [    2.247483] lkdtm: No crash points registered, enable through debugfs
> [    2.247483] lkdtm: No crash points registered, enable through debugfs
> [    2.249378] Phantom Linux Driver, version n0.9.8, init OK
> [    2.249378] Phantom Linux Driver, version n0.9.8, init OK
> [    2.260729] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    2.260729] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    2.263237] c2port c2port0: C2 port uc added
> [    2.263237] c2port c2port0: C2 port uc added
> [    2.264451] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    2.264451] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    2.269911] Uniform Multi-Platform E-IDE driver
> [    2.269911] Uniform Multi-Platform E-IDE driver
> [    2.271499] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    2.271499] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    2.273516] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    2.273516] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    2.275959]     ide0: BM-DMA at 0xc040-0xc047
> [    2.275959]     ide0: BM-DMA at 0xc040-0xc047
> [    2.277244]     ide1: BM-DMA at 0xc048-0xc04f
> [    2.277244]     ide1: BM-DMA at 0xc048-0xc04f
> [    2.278490] Probing IDE interface ide0...
> [    2.278490] Probing IDE interface ide0...
> [    2.870168] tsc: Refined TSC clocksource calibration: 2693.503 MHz
> [    2.870168] tsc: Refined TSC clocksource calibration: 2693.503 MHz
> [    2.880308] Probing IDE interface ide1...
> [    2.880308] Probing IDE interface ide1...
> [    3.680115] hdc: QEMU DVD-ROM, ATAPI 
> [    3.680115] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
>  drive
> [    4.400362] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    4.400362] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    4.402110] hdc: MWDMA2 mode selected
> [    4.402110] hdc: MWDMA2 mode selected
> [    4.403293] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    4.403293] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> 
> [    4.404530] ide1 at 0x170-0x177,0x376 on irq 15
> [    4.404530] ide1 at 0x170-0x177,0x376 on irq 15
> 
> [    4.409306] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    4.409306] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    4.420042] ide-cd driver 5.00
> [    4.420042] ide-cd driver 5.00
> [    4.421346] ide-cd: hdc: ATAPI
> [    4.421346] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB Cache
> , 512kB Cache
> [    4.422880] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    4.422880] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    4.427731] rdac: device handler registered
> [    4.427731] rdac: device handler registered
> [    4.428963] hp_sw: device handler registered
> [    4.428963] hp_sw: device handler registered
> [    4.430205] emc: device handler registered
> [    4.430205] emc: device handler registered
> [    4.431256] alua: device handler registered
> [    4.431256] alua: device handler registered
> [    4.432312] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    4.432312] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    4.434161] osst :I: Tape driver with OnStream support version 0.99.4
> [    4.434161] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    4.434161] osst :I: Tape driver with OnStream support version 0.99.4
> [    4.434161] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    4.437922] SCSI Media Changer driver v0.25 
> [    4.437922] SCSI Media Changer driver v0.25 
> [    4.439328] osd: LOADED open-osd 0.2.1
> [    4.439328] osd: LOADED open-osd 0.2.1
> [    4.440869] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    4.440869] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    4.446160] SSFDC read-only Flash Translation layer
> [    4.446160] SSFDC read-only Flash Translation layer
> [    4.447609] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    4.447609] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    4.450221] slram: not enough parameters.
> [    4.450221] slram: not enough parameters.
> [    4.590847] parport0: AVR Butterfly
> [    4.590847] parport0: AVR Butterfly
> [    4.592033] parport0: cannot grant exclusive access for device spi-lm70llp
> [    4.592033] parport0: cannot grant exclusive access for device spi-lm70llp
> [    4.593740] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    4.593740] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    4.595671] vcan: Virtual CAN interface driver
> [    4.595671] vcan: Virtual CAN interface driver
> [    4.596781] slcan: serial line CAN interface driver
> [    4.596781] slcan: serial line CAN interface driver
> [    4.597981] slcan: 10 dynamic interface channels.
> [    4.597981] slcan: 10 dynamic interface channels.
> [    4.599153] CAN device driver interface
> [    4.599153] CAN device driver interface
> [    4.600176] sja1000 CAN netdevice driver
> [    4.600176] sja1000 CAN netdevice driver
> [    4.601161] sja1000_isa: insufficient parameters supplied
> [    4.601161] sja1000_isa: insufficient parameters supplied
> [    4.603367] cc770: CAN netdevice driver
> [    4.603367] cc770: CAN netdevice driver
> [    4.604323] cc770_isa: insufficient parameters supplied
> [    4.604323] cc770_isa: insufficient parameters supplied
> [    4.609419] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    4.609419] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    4.612760] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.612760] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.614271] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    4.614271] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    4.615820] parport0: cannot grant exclusive access for device parkbd
> [    4.615820] parport0: cannot grant exclusive access for device parkbd
> [    4.618370] mousedev: PS/2 mouse device common for all mice
> [    4.618370] mousedev: PS/2 mouse device common for all mice
> [    4.621557] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    4.621557] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    4.626439] ideapad_slidebar: DMI does not match
> [    4.626439] ideapad_slidebar: DMI does not match
> [    4.627610] I2O subsystem v1.325
> [    4.627610] I2O subsystem v1.325
> [    4.628411] i2o: max drivers = 8
> [    4.628411] i2o: max drivers = 8
> [    4.631878] I2O Configuration OSM v1.323
> [    4.631878] I2O Configuration OSM v1.323
> [    4.633224] I2O Bus Adapter OSM v1.317
> [    4.633224] I2O Bus Adapter OSM v1.317
> [    4.634261] I2O SCSI Peripheral OSM v1.316
> [    4.634261] I2O SCSI Peripheral OSM v1.316
> [    4.639683] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    4.639683] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    4.641990] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    4.641990] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    4.644044] i2c /dev entries driver
> [    4.644044] i2c /dev entries driver
> [    4.646682] i2c-parport: adapter type unspecified
> [    4.646682] i2c-parport: adapter type unspecified
> [    4.647855] i2c-parport-light: adapter type unspecified
> [    4.647855] i2c-parport-light: adapter type unspecified
> [    4.650061] pps pps0: new PPS source ktimer
> [    4.650061] pps pps0: new PPS source ktimer
> [    4.651127] pps pps0: ktimer PPS source registered
> [    4.651127] pps pps0: ktimer PPS source registered
> [    4.652322] pps_parport: parallel port PPS client
> [    4.652322] pps_parport: parallel port PPS client
> [    4.653503] parport0: cannot grant exclusive access for device pps_parport
> [    4.653503] parport0: cannot grant exclusive access for device pps_parport
> [    4.655207] pps_parport: couldn't register with parport0
> [    4.655207] pps_parport: couldn't register with parport0
> [    4.657334] power_supply test_ac: uevent
> [    4.657334] power_supply test_ac: uevent
> [    4.658358] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    4.658358] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    4.659764] power_supply test_ac: prop ONLINE=1
> [    4.659764] power_supply test_ac: prop ONLINE=1
> [    4.661045] power_supply test_ac: power_supply_changed
> [    4.661045] power_supply test_ac: power_supply_changed
> [    4.662408] power_supply test_ac: power_supply_changed_work
> [    4.662408] power_supply test_ac: power_supply_changed_work
> [    4.663844] power_supply test_ac: uevent
> [    4.663844] power_supply test_ac: uevent
> [    4.664846] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    4.664846] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    4.666246] power_supply test_ac: prop ONLINE=1
> [    4.666246] power_supply test_ac: prop ONLINE=1
> [    4.668031] power_supply test_battery: uevent
> [    4.668031] power_supply test_battery: uevent
> [    4.669188] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    4.669188] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    4.670888] power_supply test_battery: prop STATUS=Discharging
> [    4.670888] power_supply test_battery: prop STATUS=Discharging
> [    4.672347] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    4.672347] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    4.673770] power_supply test_battery: prop HEALTH=Good
> [    4.673770] power_supply test_battery: prop HEALTH=Good
> [    4.675073] power_supply test_battery: prop PRESENT=1
> [    4.675073] power_supply test_battery: prop PRESENT=1
> [    4.676348] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    4.676348] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    4.677789] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    4.677789] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    4.679388] power_supply test_battery: prop CHARGE_FULL=100
> [    4.679388] power_supply test_battery: prop CHARGE_FULL=100
> [    4.680869] power_supply test_battery: prop CHARGE_NOW=50
> [    4.680869] power_supply test_battery: prop CHARGE_NOW=50
> [    4.682224] power_supply test_battery: prop CAPACITY=50
> [    4.682224] power_supply test_battery: prop CAPACITY=50
> [    4.683529] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    4.683529] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    4.685055] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    4.685055] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    4.686602] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    4.686602] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    4.688163] power_supply test_battery: prop MODEL_NAME=Test battery
> [    4.688163] power_supply test_battery: prop MODEL_NAME=Test battery
> [    4.689735] power_supply test_battery: prop MANUFACTURER=Linux
> [    4.689735] power_supply test_battery: prop MANUFACTURER=Linux
> [    4.691236] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00026-g945fa9c
> [    4.691236] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00026-g945fa9c
> [    4.693146] power_supply test_battery: prop TEMP=26
> [    4.693146] power_supply test_battery: prop TEMP=26
> [    4.694357] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    4.694357] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    4.696508] power_supply test_battery: power_supply_changed
> [    4.696508] power_supply test_battery: power_supply_changed
> [    4.697949] power_supply test_battery: power_supply_changed_work
> [    4.697949] power_supply test_battery: power_supply_changed_work
> [    4.699467] power_supply test_battery: uevent
> [    4.699467] power_supply test_battery: uevent
> [    4.700603] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    4.700603] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    4.702315] power_supply test_battery: prop STATUS=Discharging
> [    4.702315] power_supply test_battery: prop STATUS=Discharging
> [    4.703787] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    4.703787] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    4.705208] power_supply test_battery: prop HEALTH=Good
> [    4.705208] power_supply test_battery: prop HEALTH=Good
> [    4.706520] power_supply test_battery: prop PRESENT=1
> [    4.706520] power_supply test_battery: prop PRESENT=1
> [    4.707796] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    4.707796] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    4.709228] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    4.709228] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    4.711220] power_supply test_usb: uevent
> [    4.711220] power_supply test_usb: uevent
> [    4.712234] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    4.712234] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    4.713668] power_supply test_usb: prop ONLINE=1
> [    4.713668] power_supply test_usb: prop ONLINE=1
> [    4.714835] power_supply test_usb: power_supply_changed
> [    4.714835] power_supply test_usb: power_supply_changed
> [    4.719256] applesmc: supported laptop not found!
> [    4.719256] applesmc: supported laptop not found!
> [    4.720483] applesmc: driver init failed (ret=-19)!
> [    4.720483] applesmc: driver init failed (ret=-19)!
> [    4.722399] f71882fg: Not a Fintek device
> [    4.722399] f71882fg: Not a Fintek device
> [    4.723436] f71882fg: Not a Fintek device
> [    4.723436] f71882fg: Not a Fintek device
> [    4.729944] Bluetooth: Virtual HCI driver ver 1.4
> [    4.729944] Bluetooth: Virtual HCI driver ver 1.4
> [    4.731276] power_supply test_battery: prop CHARGE_FULL=100
> [    4.731276] power_supply test_battery: prop CHARGE_FULL=100
> [    4.732694] power_supply test_battery: prop CHARGE_NOW=50
> [    4.732694] power_supply test_battery: prop CHARGE_NOW=50
> [    4.734056] power_supply test_battery: prop CAPACITY=50
> [    4.734056] power_supply test_battery: prop CAPACITY=50
> [    4.735369] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    4.735369] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    4.736916] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    4.736916] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    4.738471] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    4.738471] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    4.740048] power_supply test_battery: prop MODEL_NAME=Test battery
> [    4.740048] power_supply test_battery: prop MODEL_NAME=Test battery
> [    4.741641] power_supply test_battery: prop MANUFACTURER=Linux
> [    4.741641] power_supply test_battery: prop MANUFACTURER=Linux
> [    4.743108] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00026-g945fa9c
> [    4.743108] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00026-g945fa9c
> [    4.745022] power_supply test_battery: prop TEMP=26
> [    4.745022] power_supply test_battery: prop TEMP=26
> [    4.746251] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    4.746251] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    4.747705] power_supply test_usb: power_supply_changed_work
> [    4.747705] power_supply test_usb: power_supply_changed_work
> [    4.749163] power_supply test_usb: uevent
> [    4.749163] power_supply test_usb: uevent
> [    4.750859] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    4.750859] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    4.752610] EDAC DEBUG: i5000_init: MC:
> [    4.752610] EDAC DEBUG: i5000_init: MC:
> [    4.753717] EDAC DEBUG: i7300_init: 
> [    4.753717] EDAC DEBUG: i7300_init: 
> [    4.755059] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    4.755059] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    4.756898] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    4.756898] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    4.758585] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    4.758585] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    4.760068] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    4.760068] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    4.761492] power_supply test_usb: prop ONLINE=1
> [    4.761492] power_supply test_usb: prop ONLINE=1
> [    4.762889] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    4.762889] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    4.764350] wbsd: Copyright(c) Pierre Ossman
> [    4.764350] wbsd: Copyright(c) Pierre Ossman
> [    4.768262] leds_ss4200: no LED devices found
> [    4.768262] leds_ss4200: no LED devices found
> [    4.771881] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    4.771881] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    4.773958] hidraw: raw HID events driver (C) Jiri Kosina
> [    4.773958] hidraw: raw HID events driver (C) Jiri Kosina
> [    4.787002] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.787002] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.788806] I/O, IRQ, DMA and type are mandatory
> [    4.788806] I/O, IRQ, DMA and type are mandatory
> [    4.789946] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.789946] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.791823] ad1848: No ISAPnP cards found, trying standard ones...
> [    4.791823] ad1848: No ISAPnP cards found, trying standard ones...
> [    4.793340] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.793340] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    4.795168] I/O, IRQ, DMA and type are mandatory
> [    4.795168] I/O, IRQ, DMA and type are mandatory
> [    4.796304] sb: Init: Starting Probe...
> [    4.796304] sb: Init: Starting Probe...
> [    4.797415] sb: Init: Done
> [    4.797415] sb: Init: Done
> [    4.798160] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    4.798160] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    4.800197] uart6850: irq and io must be set.
> [    4.800197] uart6850: irq and io must be set.
> [    4.801284] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    4.801284] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    4.803303] MIDI Loopback device driver
> [    4.803303] MIDI Loopback device driver
> [    4.808282] NET: Registered protocol family 17
> [    4.808282] NET: Registered protocol family 17
> [    4.820212] NET: Registered protocol family 15
> [    4.820212] NET: Registered protocol family 15
> [    4.821435] NET: Registered protocol family 4
> [    4.821435] NET: Registered protocol family 4
> [    4.822564] NET: Registered protocol family 9
> [    4.822564] NET: Registered protocol family 9
> [    4.823674] X25: Linux Version 0.2
> [    4.823674] X25: Linux Version 0.2
> [    4.824526] can: controller area network core (rev 20120528 abi 9)
> [    4.824526] can: controller area network core (rev 20120528 abi 9)
> [    4.826080] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    4.826080] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    4.827779] NET: Registered protocol family 29
> [    4.827779] NET: Registered protocol family 29
> [    4.828886] can: raw protocol (rev 20120528)
> [    4.828886] can: raw protocol (rev 20120528)
> [    4.829964] can: broadcast manager protocol (rev 20120528 t)
> [    4.829964] can: broadcast manager protocol (rev 20120528 t)
> [    4.840065] IrCOMM protocol (Dag Brattli)
> [    4.840065] IrCOMM protocol (Dag Brattli)
> [    4.848616] Bluetooth: RFCOMM TTY layer initialized
> [    4.848616] Bluetooth: RFCOMM TTY layer initialized
> [    4.849832] Bluetooth: RFCOMM socket layer initialized
> [    4.849832] Bluetooth: RFCOMM socket layer initialized
> [    4.851156] Bluetooth: RFCOMM ver 1.11
> [    4.851156] Bluetooth: RFCOMM ver 1.11
> [    4.852109] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    4.852109] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    4.853421] Bluetooth: BNEP filters: protocol multicast
> [    4.853421] Bluetooth: BNEP filters: protocol multicast
> [    4.854727] Bluetooth: BNEP socket layer initialized
> [    4.854727] Bluetooth: BNEP socket layer initialized
> [    4.855952] 8021q: 802.1Q VLAN Support v1.8
> [    4.855952] 8021q: 802.1Q VLAN Support v1.8
> [    4.857275] 9pnet: Installing 9P2000 support
> [    4.857275] 9pnet: Installing 9P2000 support
> [    4.858397] NET: Registered protocol family 37
> [    4.858397] NET: Registered protocol family 37
> [    4.859564] Key type dns_resolver registered
> [    4.859564] Key type dns_resolver registered
> [    4.860789] openvswitch: Open vSwitch switching datapath
> [    4.860789] openvswitch: Open vSwitch switching datapath
> [    4.862278] mpls_gso: MPLS GSO support
> [    4.862278] mpls_gso: MPLS GSO support
> [    4.863970] 
> [    4.863970] printing PIC contents
> [    4.863970] 
> [    4.863970] printing PIC contents
> [    4.865160] ... PIC  IMR: ffff
> [    4.865160] ... PIC  IMR: ffff
> [    4.865921] ... PIC  IRR: 9013
> [    4.865921] ... PIC  IRR: 9013
> [    4.866691] ... PIC  ISR: 0000
> [    4.866691] ... PIC  ISR: 0000
> [    4.867447] ... PIC ELCR: 0c00
> [    4.867447] ... PIC ELCR: 0c00
> [    4.868210] printing local APIC contents on CPU#0/0:
> [    4.868210] printing local APIC contents on CPU#0/0:
> [    4.869431] ... APIC ID:      00000000 (0)
> [    4.869431] ... APIC ID:      00000000 (0)
> [    4.870450] ... APIC VERSION: 01050014
> [    4.870450] ... APIC VERSION: 01050014
> [    4.870649] ... APIC TASKPRI: 00000000 (00)
> [    4.870649] ... APIC TASKPRI: 00000000 (00)
> [    4.870649] ... APIC PROCPRI: 00000000
> [    4.870649] ... APIC PROCPRI: 00000000
> [    4.870649] ... APIC LDR: 01000000
> [    4.870649] ... APIC LDR: 01000000
> [    4.870649] ... APIC DFR: ffffffff
> [    4.870649] ... APIC DFR: ffffffff
> [    4.870649] ... APIC SPIV: 000001ff
> [    4.870649] ... APIC SPIV: 000001ff
> [    4.870649] ... APIC ISR field:
> [    4.870649] ... APIC ISR field:
> [    4.870649] 00000000
> [    4.870649] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    4.870649] ... APIC TMR field:
> [    4.870649] ... APIC TMR field:
> [    4.870649] 00000000
> [    4.870649] 000000000e2000000e200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    4.870649] ... APIC IRR field:
> [    4.870649] ... APIC IRR field:
> [    4.870649] 00000000
> [    4.870649] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000
> 
> [    4.870649] ... APIC ESR: 00000000
> [    4.870649] ... APIC ESR: 00000000
> [    4.870649] ... APIC ICR: 000400f6
> [    4.870649] ... APIC ICR: 000400f6
> [    4.870649] ... APIC ICR2: 01000000
> [    4.870649] ... APIC ICR2: 01000000
> [    4.870649] ... APIC LVTT: 000000ef
> [    4.870649] ... APIC LVTT: 000000ef
> [    4.870649] ... APIC LVTPC: 00010000
> [    4.870649] ... APIC LVTPC: 00010000
> [    4.870649] ... APIC LVT0: 00010700
> [    4.870649] ... APIC LVT0: 00010700
> [    4.870649] ... APIC LVT1: 00000400
> [    4.870649] ... APIC LVT1: 00000400
> [    4.870649] ... APIC LVTERR: 000000fe
> [    4.870649] ... APIC LVTERR: 000000fe
> [    4.870649] ... APIC TMICT: 0008e945
> [    4.870649] ... APIC TMICT: 0008e945
> [    4.870649] ... APIC TMCCT: 00000000
> [    4.870649] ... APIC TMCCT: 00000000
> [    4.870649] ... APIC TDCR: 00000003
> [    4.870649] ... APIC TDCR: 00000003
> [    4.870649] 
> [    4.870649] 
> [    4.894289] number of MP IRQ sources: 15.
> [    4.894289] number of MP IRQ sources: 15.
> [    4.895301] number of IO-APIC #0 registers: 24.
> [    4.895301] number of IO-APIC #0 registers: 24.
> [    4.896427] testing the IO APIC.......................
> [    4.896427] testing the IO APIC.......................
> [    4.897721] IO APIC #0......
> [    4.897721] IO APIC #0......
> [    4.898438] .... register #00: 00000000
> [    4.898438] .... register #00: 00000000
> [    4.899403] .......    : physical APIC id: 00
> [    4.899403] .......    : physical APIC id: 00
> [    4.900522] .......    : Delivery Type: 0
> [    4.900522] .......    : Delivery Type: 0
> [    4.901527] .......    : LTS          : 0
> [    4.901527] .......    : LTS          : 0
> [    4.902536] .... register #01: 00170011
> [    4.902536] .... register #01: 00170011
> [    4.903497] .......     : max redirection entries: 17
> [    4.903497] .......     : max redirection entries: 17
> [    4.904757] .......     : PRQ implemented: 0
> [    4.904757] .......     : PRQ implemented: 0
> [    4.905811] .......     : IO APIC version: 11
> [    4.905811] .......     : IO APIC version: 11
> [    4.906894] .... register #02: 00000000
> [    4.906894] .... register #02: 00000000
> [    4.907852] .......     : arbitration: 00
> [    4.907852] .......     : arbitration: 00
> [    4.908863] .... IRQ redirection table:
> [    4.908863] .... IRQ redirection table:
> [    4.909914] 1    0    0   0   0    0    0    00
> [    4.909914] 1    0    0   0   0    0    0    00
> [    4.911093] 0    0    0   0   0    1    1    31
> [    4.911093] 0    0    0   0   0    1    1    31
> [    4.912242] 0    0    0   0   0    1    1    30
> [    4.912242] 0    0    0   0   0    1    1    30
> [    4.913383] 0    0    0   0   0    1    1    33
> [    4.913383] 0    0    0   0   0    1    1    33
> [    4.914518] 1    0    0   0   0    1    1    34
> [    4.914518] 1    0    0   0   0    1    1    34
> [    4.915669] 1    1    0   0   0    1    1    35
> [    4.915669] 1    1    0   0   0    1    1    35
> [    4.916811] 0    0    0   0   0    1    1    36
> [    4.916811] 0    0    0   0   0    1    1    36
> [    4.917962] 0    0    0   0   0    1    1    37
> [    4.917962] 0    0    0   0   0    1    1    37
> [    4.919120] 0    0    0   0   0    1    1    38
> [    4.919120] 0    0    0   0   0    1    1    38
> [    4.920298] 0    1    0   0   0    1    1    39
> [    4.920298] 0    1    0   0   0    1    1    39
> [    4.921442] 1    1    0   0   0    1    1    3A
> [    4.921442] 1    1    0   0   0    1    1    3A
> [    4.922581] 1    1    0   0   0    1    1    3B
> [    4.922581] 1    1    0   0   0    1    1    3B
> [    4.923729] 0    0    0   0   0    1    1    3C
> [    4.923729] 0    0    0   0   0    1    1    3C
> [    4.924878] 0    0    0   0   0    1    1    3D
> [    4.924878] 0    0    0   0   0    1    1    3D
> [    4.926021] 0    0    0   0   0    1    1    3E
> [    4.926021] 0    0    0   0   0    1    1    3E
> [    4.927163] 0    0    0   0   0    1    1    3F
> [    4.927163] 0    0    0   0   0    1    1    3F
> [    4.928310] 1    0    0   0   0    0    0    00
> [    4.928310] 1    0    0   0   0    0    0    00
> [    4.929463] 1    0    0   0   0    0    0    00
> [    4.929463] 1    0    0   0   0    0    0    00
> [    4.930690] 1    0    0   0   0    0    0    00
> [    4.930690] 1    0    0   0   0    0    0    00
> [    4.931837] 1    0    0   0   0    0    0    00
> [    4.931837] 1    0    0   0   0    0    0    00
> [    4.932981] 1    0    0   0   0    0    0    00
> [    4.932981] 1    0    0   0   0    0    0    00
> [    4.934126] 1    0    0   0   0    0    0    00
> [    4.934126] 1    0    0   0   0    0    0    00
> [    4.935278] 1    0    0   0   0    0    0    00
> [    4.935278] 1    0    0   0   0    0    0    00
> [    4.936425] 1    0    0   0   0    0    0    00
> [    4.936425] 1    0    0   0   0    0    0    00
> [    4.937561] IRQ to pin mappings:
> [    4.937561] IRQ to pin mappings:
> [    4.938384] IRQ0 
> [    4.938384] IRQ0 -> 0:2-> 0:2
> 
> [    4.939055] IRQ1 
> [    4.939055] IRQ1 -> 0:1-> 0:1
> 
> [    4.939739] IRQ3 
> [    4.939739] IRQ3 -> 0:3-> 0:3
> 
> [    4.940506] IRQ4 
> [    4.940506] IRQ4 -> 0:4-> 0:4
> 
> [    4.941177] IRQ5 
> [    4.941177] IRQ5 -> 0:5-> 0:5
> 
> [    4.941845] IRQ6 
> [    4.941845] IRQ6 -> 0:6-> 0:6
> 
> [    4.942497] IRQ7 
> [    4.942497] IRQ7 -> 0:7-> 0:7
> 
> [    4.943168] IRQ8 
> [    4.943168] IRQ8 -> 0:8-> 0:8
> 
> [    4.943834] IRQ9 
> [    4.943834] IRQ9 -> 0:9-> 0:9
> 
> [    4.944494] IRQ10 
> [    4.944494] IRQ10 -> 0:10-> 0:10
> 
> [    4.945207] IRQ11 
> [    4.945207] IRQ11 -> 0:11-> 0:11
> 
> [    4.945910] IRQ12 
> [    4.945910] IRQ12 -> 0:12-> 0:12
> 
> [    4.946611] IRQ13 
> [    4.946611] IRQ13 -> 0:13-> 0:13
> 
> [    4.947317] IRQ14 
> [    4.947317] IRQ14 -> 0:14-> 0:14
> 
> [    4.948028] IRQ15 
> [    4.948028] IRQ15 -> 0:15-> 0:15
> 
> [    4.948737] .................................... done.
> [    4.948737] .................................... done.
> [    4.950913] bootconsole [earlyser0] disabled
> [    4.950913] bootconsole [earlyser0] disabled
> [    4.952086] Loading compiled-in X.509 certificates
> [    4.952738] registered taskstats version 1
> [    4.953272] Running tests on trace events:
> [    4.953817] Testing event kvm_async_pf_completed: 
> [    4.970155] test-events (139) used greatest stack depth: 6248 bytes left
> [    4.971164] OK
> [    4.971396] Testing event kvm_async_pf_ready: OK
> [    5.000362] Testing event kvm_async_pf_not_present: 
> [    5.031887] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [    5.033378] OK
> [    5.033621] Testing event kvm_async_pf_doublefault: OK
> [    5.060294] Testing event kvm_try_async_get_page: OK
> [    5.090263] Testing event kvm_age_page: OK
> [    5.120319] Testing event kvm_fpu: OK
> [    5.150289] Testing event kvm_mmio: OK
> [    5.180316] Testing event kvm_ack_irq: OK
> [    5.210250] Testing event kvm_msi_set_irq: OK
> [    5.240328] Testing event kvm_ioapic_set_irq: OK
> [    5.270295] Testing event kvm_set_irq: OK
> [    5.300316] Testing event kvm_userspace_exit: OK
> [    5.330272] Testing event kvm_track_tsc: OK
> [    5.360570] Testing event kvm_update_master_clock: OK
> [    5.390273] Testing event kvm_write_tsc_offset: OK
> [    5.420343] Testing event vcpu_match_mmio: OK
> [    5.450302] Testing event kvm_emulate_insn: OK
> [    5.480348] Testing event kvm_skinit: OK
> [    5.510283] Testing event kvm_invlpga: OK
> [    5.554997] Testing event kvm_nested_intr_vmexit: OK
> [    5.580288] Testing event kvm_nested_vmexit_inject: OK
> [    5.610877] Testing event kvm_nested_vmexit: OK
> [    5.640274] Testing event kvm_nested_intercepts: OK
> [    5.670318] Testing event kvm_nested_vmrun: OK
> [    5.700281] Testing event kvm_pv_eoi: OK
> [    5.730339] Testing event kvm_eoi: OK
> [    5.760273] Testing event kvm_apic_accept_irq: OK
> [    5.790332] Testing event kvm_apic_ipi: OK
> [    5.820283] Testing event kvm_pic_set_irq: OK
> [    5.850337] Testing event kvm_cr: OK
> [    5.880275] Testing event kvm_msr: OK
> [    5.910409] Testing event kvm_page_fault: OK
> [    5.940324] Testing event kvm_inj_exception: OK
> [    5.970357] Testing event kvm_inj_virq: OK
> [    6.000298] Testing event kvm_exit: OK
> [    6.030358] Testing event kvm_apic: OK
> [    6.060297] Testing event kvm_cpuid: OK
> [    6.090337] Testing event kvm_pio: OK
> [    6.120289] Testing event kvm_hv_hypercall: OK
> [    6.150804] Testing event kvm_hypercall: OK
> [    6.180273] Testing event kvm_entry: OK
> [    6.210320] Testing event check_mmio_spte: OK
> [    6.240287] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [    6.270326] Testing event fast_page_fault: OK
> [    6.300267] Testing event handle_mmio_page_fault: OK
> [    6.330347] Testing event mark_mmio_spte: OK
> [    6.360283] Testing event kvm_mmu_prepare_zap_page: OK
> [    6.390322] Testing event kvm_mmu_unsync_page: OK
> [    6.420279] Testing event kvm_mmu_sync_page: OK
> [    6.450344] Testing event kvm_mmu_get_page: OK
> [    6.480276] Testing event kvm_mmu_walker_error: OK
> [    6.510321] Testing event kvm_mmu_set_dirty_bit: OK
> [    6.540286] Testing event kvm_mmu_set_accessed_bit: OK
> [    6.570305] Testing event kvm_mmu_paging_element: OK
> [    6.600297] Testing event kvm_mmu_pagetable_walk: OK
> [    6.630322] Testing event thermal_apic_exit: OK
> [    6.660280] Testing event thermal_apic_entry: OK
> [    6.690356] Testing event threshold_apic_exit: OK
> [    6.720289] Testing event threshold_apic_entry: OK
> [    6.750331] Testing event call_function_single_exit: OK
> [    6.780286] Testing event call_function_single_entry: OK
> [    6.810323] Testing event call_function_exit: OK
> [    6.840289] Testing event call_function_entry: OK
> [    6.870385] Testing event irq_work_exit: OK
> [    6.900278] Testing event irq_work_entry: OK
> [    6.930347] Testing event x86_platform_ipi_exit: OK
> [    6.960285] Testing event x86_platform_ipi_entry: OK
> [    6.990338] Testing event error_apic_exit: OK
> [    7.020272] Testing event error_apic_entry: OK
> [    7.050373] Testing event spurious_apic_exit: OK
> [    7.080331] Testing event spurious_apic_entry: OK
> [    7.110364] Testing event reschedule_exit: OK
> [    7.140327] Testing event reschedule_entry: OK
> [    7.170380] Testing event local_timer_exit: OK
> [    7.200340] Testing event local_timer_entry: OK
> [    7.230392] Testing event nmi_handler: OK
> [    7.260321] Testing event emulate_vsyscall: OK
> [    7.290387] Testing event sys_exit: OK
> [    7.320378] Testing event sys_enter: OK
> [    7.350395] Testing event page_fault_kernel: OK
> [    7.380378] Testing event page_fault_user: OK
> [    7.410393] Testing event task_rename: OK
> [    7.440344] Testing event task_newtask: OK
> [    7.470383] Testing event softirq_raise: OK
> [    7.500376] Testing event softirq_exit: OK
> [    7.530410] Testing event softirq_entry: OK
> [    7.560345] Testing event irq_handler_exit: OK
> [    7.590398] Testing event irq_handler_entry: OK
> [    7.620355] Testing event itimer_expire: OK
> [    7.650406] Testing event itimer_state: OK
> [    7.680348] Testing event hrtimer_cancel: OK
> [    7.710780] Testing event hrtimer_expire_exit: OK
> [    7.740344] Testing event hrtimer_expire_entry: OK
> [    7.770402] Testing event hrtimer_start: OK
> [    7.800343] Testing event hrtimer_init: OK
> [    7.830408] Testing event timer_cancel: OK
> [    7.860372] Testing event timer_expire_exit: OK
> [    7.890412] Testing event timer_expire_entry: OK
> [    7.920970] Testing event timer_start: OK
> [    7.950445] Testing event timer_init: OK
> [    7.980373] Testing event signal_deliver: OK
> [    8.010435] Testing event signal_generate: OK
> [    8.040415] Testing event workqueue_execute_end: OK
> [    8.070429] Testing event workqueue_execute_start: OK
> [    8.100385] Testing event workqueue_activate_work: OK
> [    8.130433] Testing event workqueue_queue_work: OK
> [    8.160384] Testing event sched_swap_numa: OK
> [    8.190421] Testing event sched_stick_numa: OK
> [    8.220527] Testing event sched_move_numa: OK
> [    8.250398] Testing event sched_process_hang: OK
> [    8.280333] Testing event sched_pi_setprio: OK
> [    8.310400] Testing event sched_stat_runtime: 
> [    8.340314] test-events (251) used greatest stack depth: 6008 bytes left
> [    8.341277] OK
> [    8.341510] Testing event sched_stat_blocked: OK
> [    8.370445] Testing event sched_stat_iowait: OK
> [    8.400384] Testing event sched_stat_sleep: OK
> [    8.430449] Testing event sched_stat_wait: OK
> [    8.460359] Testing event sched_process_exec: OK
> [    8.490450] Testing event sched_process_fork: OK
> [    8.520370] Testing event sched_process_wait: OK
> [    8.550441] Testing event sched_wait_task: OK
> [    8.580371] Testing event sched_process_exit: OK
> [    8.610444] Testing event sched_process_free: OK
> [    8.640398] Testing event sched_migrate_task: OK
> [    8.670412] Testing event sched_switch: OK
> [    8.700409] Testing event sched_wakeup_new: OK
> [    8.730444] Testing event sched_wakeup: OK
> [    8.760408] Testing event sched_kthread_stop_ret: OK
> [    8.790457] Testing event sched_kthread_stop: OK
> [    8.820338] Testing event lock_acquired: OK
> [    8.850537] Testing event lock_contended: OK
> [    8.880358] Testing event lock_release: OK
> [    8.910538] Testing event lock_acquire: OK
> [    8.940411] Testing event console: OK
> [    8.970441] Testing event rcu_utilization: OK
> [    9.000384] Testing event ftrace_test_filter: OK
> [    9.030446] Testing event dev_pm_qos_remove_request: OK
> [    9.060372] Testing event dev_pm_qos_update_request: OK
> [    9.090417] Testing event dev_pm_qos_add_request: OK
> [    9.120359] Testing event pm_qos_update_flags: OK
> [    9.150409] Testing event pm_qos_update_target: OK
> [    9.180359] Testing event pm_qos_update_request_timeout: OK
> [    9.210426] Testing event pm_qos_remove_request: OK
> [    9.240365] Testing event pm_qos_update_request: OK
> [    9.270407] Testing event pm_qos_add_request: OK
> [    9.300351] Testing event power_domain_target: OK
> [    9.330414] Testing event clock_set_rate: OK
> [    9.360367] Testing event clock_disable: OK
> [    9.390460] Testing event clock_enable: OK
> [    9.420335] Testing event wakeup_source_deactivate: OK
> [    9.450444] Testing event wakeup_source_activate: OK
> [    9.480355] Testing event device_pm_report_time: OK
> [    9.510416] Testing event machine_suspend: OK
> [    9.540349] Testing event cpu_frequency: OK
> [    9.570425] Testing event pstate_sample: OK
> [    9.600834] Testing event cpu_idle: OK
> [    9.630405] Testing event user_exit: OK
> [    9.660359] Testing event user_enter: OK
> [    9.690426] Testing event mm_filemap_add_to_page_cache: OK
> [    9.720350] Testing event mm_filemap_delete_from_page_cache: OK
> [    9.750400] Testing event oom_score_adj_update: OK
> [    9.780325] Testing event mm_lru_activate: OK
> [    9.810394] Testing event mm_lru_insertion: OK
> [    9.840342] Testing event mm_vmscan_lru_shrink_inactive: OK
> [    9.870398] Testing event mm_vmscan_writepage: OK
> [    9.900329] Testing event mm_vmscan_memcg_isolate: OK
> [    9.930387] Testing event mm_vmscan_lru_isolate: OK
> [    9.960312] Testing event mm_shrink_slab_end: OK
> [    9.990373] Testing event mm_shrink_slab_start: OK
> [   10.020328] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   10.050394] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   10.080362] Testing event mm_vmscan_direct_reclaim_end: OK
> [   10.110407] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   10.140367] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   10.170395] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   10.200337] Testing event mm_vmscan_wakeup_kswapd: OK
> [   10.230425] Testing event mm_vmscan_kswapd_wake: OK
> [   10.260323] Testing event mm_vmscan_kswapd_sleep: OK
> [   10.290392] Testing event mm_page_alloc_extfrag: OK
> [   10.320325] Testing event mm_page_pcpu_drain: OK
> [   10.350372] Testing event mm_page_alloc_zone_locked: OK
> [   10.380315] Testing event mm_page_alloc: OK
> [   10.410358] Testing event mm_page_free_batched: OK
> [   10.440308] Testing event mm_page_free: OK
> [   10.470349] Testing event kmem_cache_free: OK
> [   10.500310] Testing event kfree: OK
> [   10.530388] Testing event kmem_cache_alloc_node: OK
> [   10.560309] Testing event kmalloc_node: OK
> [   10.590379] Testing event kmem_cache_alloc: OK
> [   10.620330] Testing event kmalloc: OK
> [   10.650382] Testing event mm_compaction_end: OK
> [   10.680320] Testing event mm_compaction_begin: OK
> [   10.710361] Testing event mm_compaction_migratepages: OK
> [   10.740312] Testing event mm_compaction_isolate_freepages: OK
> [   10.770364] Testing event mm_compaction_isolate_migratepages: OK
> [   10.800303] Testing event mm_numa_migrate_ratelimit: OK
> [   10.830393] Testing event mm_migrate_pages: OK
> [   10.860308] Testing event writeback_single_inode: OK
> [   10.890357] Testing event writeback_single_inode_start: OK
> [   10.920309] Testing event writeback_wait_iff_congested: OK
> [   10.950365] Testing event writeback_congestion_wait: OK
> [   10.980333] Testing event writeback_sb_inodes_requeue: OK
> [   11.010395] Testing event balance_dirty_pages: OK
> [   11.040369] Testing event bdi_dirty_ratelimit: OK
> [   11.070402] Testing event global_dirty_state: OK
> [   11.100371] Testing event writeback_queue_io: OK
> [   11.130379] Testing event wbc_writepage: OK
> [   11.160317] Testing event writeback_bdi_unregister: OK
> [   11.190389] Testing event writeback_bdi_register: OK
> [   11.220296] Testing event writeback_wake_background: OK
> [   11.250331] Testing event writeback_nowork: OK
> [   11.270381] Testing event writeback_pages_written: OK
> [   11.290304] Testing event writeback_wait: OK
> [   11.310287] Testing event writeback_written: OK
> [   11.330321] Testing event writeback_start: OK
> [   11.350303] Testing event writeback_exec: OK
> [   11.370356] Testing event writeback_queue: OK
> [   11.390311] Testing event writeback_write_inode: OK
> [   11.410300] Testing event writeback_write_inode_start: OK
> [   11.430293] Testing event writeback_dirty_inode: OK
> [   11.450339] Testing event writeback_dirty_inode_start: OK
> [   11.470321] Testing event writeback_dirty_page: OK
> [   11.490310] Testing event jbd2_lock_buffer_stall: OK
> [   11.510313] Testing event jbd2_write_superblock: OK
> [   11.530305] Testing event jbd2_update_log_tail: OK
> [   11.550297] Testing event jbd2_checkpoint_stats: OK
> [   11.570301] Testing event jbd2_run_stats: OK
> [   11.590319] Testing event jbd2_handle_stats: OK
> [   11.610309] Testing event jbd2_handle_extend: OK
> [   11.630271] Testing event jbd2_handle_start: OK
> [   11.650235] Testing event jbd2_submit_inode_data: OK
> [   11.670259] Testing event jbd2_end_commit: OK
> [   11.690257] Testing event jbd2_drop_transaction: OK
> [   11.710212] Testing event jbd2_commit_logging: OK
> [   11.730276] Testing event jbd2_commit_flushing: OK
> [   11.750237] Testing event jbd2_commit_locking: OK
> [   11.770470] Testing event jbd2_start_commit: OK
> [   11.790304] Testing event jbd2_checkpoint: OK
> [   11.810336] Testing event xfs_discard_busy: OK
> [   11.831817] Testing event xfs_discard_exclude: OK
> [   11.850435] Testing event xfs_discard_toosmall: OK
> [   11.870319] Testing event xfs_discard_extent: OK
> [   11.890304] Testing event xfs_log_recover_inode_skip: OK
> [   11.910296] Testing event xfs_log_recover_inode_cancel: OK
> [   11.930342] Testing event xfs_log_recover_inode_recover: OK
> [   11.950313] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   11.970263] Testing event xfs_log_recover_buf_reg_buf: OK
> [   11.990525] Testing event xfs_log_recover_buf_inode_buf: OK
> [   12.010278] Testing event xfs_log_recover_buf_recover: OK
> [   12.030388] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   12.050266] Testing event xfs_log_recover_buf_cancel_add: OK
> [   12.070322] Testing event xfs_log_recover_buf_cancel: OK
> [   12.090246] Testing event xfs_log_recover_buf_not_cancel: OK
> [   12.110307] Testing event xfs_log_recover_item_recover: OK
> [   12.133690] Testing event xfs_log_recover_item_reorder_tail: OK
> [   12.150302] Testing event xfs_log_recover_item_reorder_head: OK
> [   12.170264] Testing event xfs_log_recover_item_add_cont: OK
> [   12.190322] Testing event xfs_log_recover_item_add: OK
> [   12.210247] Testing event xfs_swap_extent_after: OK
> [   12.230316] Testing event xfs_swap_extent_before: OK
> [   12.250262] Testing event xfs_dir2_leafn_moveents: OK
> [   12.270345] Testing event xfs_dir2_shrink_inode: OK
> [   12.290265] Testing event xfs_dir2_grow_inode: OK
> [   12.310307] Testing event xfs_dir2_leafn_remove: OK
> [   12.330289] Testing event xfs_dir2_leafn_add: OK
> [   12.350365] Testing event xfs_da_path_shift: OK
> [   12.370312] Testing event xfs_da_fixhashpath: OK
> [   12.390303] Testing event xfs_da_shrink_inode: OK
> [   12.410287] Testing event xfs_da_grow_inode: OK
> [   12.430289] Testing event xfs_da_swap_lastblock: OK
> [   12.450264] Testing event xfs_da_node_toosmall: OK
> [   12.470273] Testing event xfs_da_node_unbalance: OK
> [   12.490206] Testing event xfs_da_node_rebalance: OK
> [   12.510342] Testing event xfs_da_node_remove: OK
> [   12.530193] Testing event xfs_da_node_split: OK
> [   12.550233] Testing event xfs_da_node_create: OK
> [   12.570352] Testing event xfs_da_node_add: OK
> [   12.590236] Testing event xfs_da_root_join: OK
> [   12.610246] Testing event xfs_da_root_split: OK
> [   12.630263] Testing event xfs_da_unlink_forward: OK
> [   12.650262] Testing event xfs_da_unlink_back: OK
> [   12.670292] Testing event xfs_da_link_after: OK
> [   12.690318] Testing event xfs_da_link_before: OK
> [   12.710274] Testing event xfs_da_join: OK
> [   12.730325] Testing event xfs_da_split: OK
> [   12.750305] Testing event xfs_attr_rmtval_remove: OK
> [   12.770307] Testing event xfs_attr_rmtval_set: OK
> [   12.790400] Testing event xfs_attr_rmtval_get: OK
> [   12.810330] Testing event xfs_attr_refillstate: OK
> [   12.830355] Testing event xfs_attr_fillstate: OK
> [   12.850247] Testing event xfs_attr_node_removename: OK
> [   12.870398] Testing event xfs_attr_node_replace: OK
> [   12.890312] Testing event xfs_attr_node_lookup: OK
> [   12.910612] Testing event xfs_attr_node_get: OK
> [   12.930509] Testing event xfs_attr_node_addname: OK
> [   12.950571] Testing event xfs_attr_leaf_toosmall: OK
> [   12.970342] Testing event xfs_attr_leaf_unbalance: OK
> [   12.990345] Testing event xfs_attr_leaf_rebalance: OK
> [   13.010363] Testing event xfs_attr_leaf_to_node: OK
> [   13.030398] Testing event xfs_attr_leaf_to_sf: OK
> [   13.050331] Testing event xfs_attr_leaf_flipflags: OK
> [   13.070374] Testing event xfs_attr_leaf_setflag: OK
> [   13.090327] Testing event xfs_attr_leaf_clearflag: OK
> [   13.110477] Testing event xfs_attr_leaf_split_after: OK
> [   13.130277] Testing event xfs_attr_leaf_split_before: OK
> [   13.150359] Testing event xfs_attr_leaf_split: OK
> [   13.170291] Testing event xfs_attr_leaf_removename: OK
> [   13.190498] Testing event xfs_attr_leaf_remove: OK
> [   13.210297] Testing event xfs_attr_leaf_replace: OK
> [   13.230566] Testing event xfs_attr_leaf_lookup: OK
> [   13.250400] Testing event xfs_attr_leaf_get: OK
> [   13.270436] Testing event xfs_attr_leaf_compact: OK
> [   13.290356] Testing event xfs_attr_leaf_create: OK
> [   13.310469] Testing event xfs_attr_leaf_addname: OK
> [   13.330397] Testing event xfs_attr_leaf_add_work: OK
> [   13.350337] Testing event xfs_attr_leaf_add_new: OK
> [   13.370292] Testing event xfs_attr_leaf_add_old: OK
> [   13.390376] Testing event xfs_attr_leaf_add: OK
> [   13.410316] Testing event xfs_attr_sf_to_leaf: OK
> [   13.430341] Testing event xfs_attr_sf_removename: OK
> [   13.450322] Testing event xfs_attr_sf_remove: OK
> [   13.470431] Testing event xfs_attr_sf_lookup: OK
> [   13.490313] Testing event xfs_attr_sf_create: OK
> [   13.510362] Testing event xfs_attr_sf_addname: OK
> [   13.530294] Testing event xfs_attr_sf_add: OK
> [   13.550391] Testing event xfs_dir2_node_to_leaf: OK
> [   13.570327] Testing event xfs_dir2_node_removename: OK
> [   13.590347] Testing event xfs_dir2_node_replace: OK
> [   13.610284] Testing event xfs_dir2_node_lookup: OK
> [   13.630364] Testing event xfs_dir2_node_addname: OK
> [   13.650339] Testing event xfs_dir2_leaf_to_node: OK
> [   13.670331] Testing event xfs_dir2_leaf_to_block: OK
> [   13.690310] Testing event xfs_dir2_leaf_removename: OK
> [   13.710363] Testing event xfs_dir2_leaf_replace: OK
> [   13.730339] Testing event xfs_dir2_leaf_lookup: OK
> [   13.750408] Testing event xfs_dir2_leaf_addname: OK
> [   13.770327] Testing event xfs_dir2_block_to_leaf: OK
> [   13.790362] Testing event xfs_dir2_block_to_sf: OK
> [   13.810310] Testing event xfs_dir2_block_removename: OK
> [   13.830330] Testing event xfs_dir2_block_replace: OK
> [   13.850323] Testing event xfs_dir2_block_lookup: OK
> [   13.870426] Testing event xfs_dir2_block_addname: OK
> [   13.890375] Testing event xfs_dir2_sf_to_block: OK
> [   13.910357] Testing event xfs_dir2_sf_toino8: OK
> [   13.930303] Testing event xfs_dir2_sf_toino4: OK
> [   13.950388] Testing event xfs_dir2_sf_removename: OK
> [   13.970246] Testing event xfs_dir2_sf_replace: OK
> [   13.990315] Testing event xfs_dir2_sf_lookup: OK
> [   14.010280] Testing event xfs_dir2_sf_create: OK
> [   14.030310] Testing event xfs_dir2_sf_addname: OK
> [   14.050238] Testing event xfs_alloc_vextent_allfailed: OK
> [   14.070247] Testing event xfs_alloc_vextent_loopfailed: OK
> [   14.090194] Testing event xfs_alloc_vextent_noagbp: OK
> [   14.110228] Testing event xfs_alloc_vextent_nofix: OK
> [   14.130255] Testing event xfs_alloc_vextent_badargs: OK
> [   14.150248] Testing event xfs_alloc_small_error: OK
> [   14.170254] Testing event xfs_alloc_small_done: OK
> [   14.190335] Testing event xfs_alloc_small_notenough: OK
> [   14.210302] Testing event xfs_alloc_small_freelist: OK
> [   14.230237] Testing event xfs_alloc_size_busy: OK
> [   14.250329] Testing event xfs_alloc_size_error: OK
> [   14.270326] Testing event xfs_alloc_size_done: OK
> [   14.290274] Testing event xfs_alloc_size_nominleft: OK
> [   14.310330] Testing event xfs_alloc_size_noentry: OK
> [   14.330213] Testing event xfs_alloc_size_neither: OK
> [   14.350371] Testing event xfs_alloc_near_busy: OK
> [   14.370351] Testing event xfs_alloc_near_noentry: OK
> [   14.390478] Testing event xfs_alloc_near_error: OK
> [   14.410348] Testing event xfs_alloc_near_lesser: OK
> [   14.430349] Testing event xfs_alloc_near_greater: OK
> [   14.450335] Testing event xfs_alloc_near_first: OK
> [   14.470475] Testing event xfs_alloc_near_nominleft: OK
> [   14.490337] Testing event xfs_alloc_exact_error: OK
> [   14.510336] Testing event xfs_alloc_exact_notfound: OK
> [   14.530282] Testing event xfs_alloc_exact_done: OK
> [   14.550384] Testing event xfs_free_extent: OK
> [   14.570239] Testing event xfs_agf: OK
> [   14.590222] Testing event xfs_trans_commit_lsn: OK
> [   14.610263] Testing event xfs_extent_busy_trim: OK
> [   14.630368] Testing event xfs_extent_busy_clear: OK
> [   14.650192] Testing event xfs_extent_busy_reuse: OK
> [   14.670240] Testing event xfs_extent_busy_force: OK
> [   14.690243] Testing event xfs_extent_busy_enomem: OK
> [   14.710272] Testing event xfs_extent_busy: OK
> [   14.730320] Testing event xfs_bunmap: OK
> [   14.750288] Testing event xfs_pagecache_inval: OK
> [   14.770286] Testing event xfs_itruncate_extents_end: OK
> [   14.790241] Testing event xfs_itruncate_extents_start: OK
> [   14.810278] Testing event xfs_setfilesize: OK
> [   14.830231] Testing event xfs_get_blocks_notfound: OK
> [   14.850205] Testing event xfs_unwritten_convert: OK
> [   14.870305] Testing event xfs_delalloc_enospc: OK
> [   14.890284] Testing event xfs_get_blocks_alloc: OK
> [   14.910372] Testing event xfs_get_blocks_found: OK
> [   14.930261] Testing event xfs_map_blocks_alloc: OK
> [   14.950291] Testing event xfs_map_blocks_found: OK
> [   14.970259] Testing event xfs_invalidatepage: OK
> [   14.990366] Testing event xfs_releasepage: OK
> [   15.010257] Testing event xfs_writepage: OK
> [   15.030576] Testing event xfs_file_splice_write: OK
> [   15.050209] Testing event xfs_file_splice_read: OK
> [   15.070336] Testing event xfs_file_direct_write: OK
> [   15.090173] Testing event xfs_file_buffered_write: OK
> [   15.110255] Testing event xfs_file_read: OK
> [   15.130277] Testing event xfs_log_assign_tail_lsn: OK
> [   15.150228] Testing event xfs_ail_delete: OK
> [   15.170234] Testing event xfs_ail_move: OK
> [   15.190347] Testing event xfs_ail_insert: OK
> [   15.210263] Testing event xfs_ail_flushing: OK
> [   15.230282] Testing event xfs_ail_locked: OK
> [   15.250259] Testing event xfs_ail_pinned: OK
> [   15.270430] Testing event xfs_ail_push: OK
> [   15.290292] Testing event xfs_log_force: OK
> [   15.310330] Testing event xfs_log_ungrant_sub: OK
> [   15.330274] Testing event xfs_log_ungrant_exit: OK
> [   15.350334] Testing event xfs_log_ungrant_enter: OK
> [   15.370197] Testing event xfs_log_regrant_reserve_sub: OK
> [   15.390300] Testing event xfs_log_regrant_reserve_exit: OK
> [   15.410262] Testing event xfs_log_regrant_reserve_enter: OK
> [   15.430276] Testing event xfs_log_regrant_exit: OK
> [   15.450214] Testing event xfs_log_regrant: OK
> [   15.470258] Testing event xfs_log_reserve_exit: OK
> [   15.490221] Testing event xfs_log_reserve: OK
> [   15.510240] Testing event xfs_log_grant_wake_up: OK
> [   15.530262] Testing event xfs_log_grant_wake: OK
> [   15.550403] Testing event xfs_log_grant_sleep: OK
> [   15.570249] Testing event xfs_log_umount_write: OK
> [   15.590337] Testing event xfs_log_done_perm: OK
> [   15.610277] Testing event xfs_log_done_nonperm: OK
> [   15.630357] Testing event xfs_dqflush_done: OK
> [   15.650307] Testing event xfs_dqflush_force: OK
> [   15.670257] Testing event xfs_dqflush: OK
> [   15.690268] Testing event xfs_dqrele: OK
> [   15.710357] Testing event xfs_dqput_free: OK
> [   15.730253] Testing event xfs_dqput_wait: OK
> [   15.750325] Testing event xfs_dqput: OK
> [   15.770295] Testing event xfs_dqget_dup: OK
> [   15.790290] Testing event xfs_dqget_freeing: OK
> [   15.810242] Testing event xfs_dqget_miss: OK
> [   15.830358] Testing event xfs_dqget_hit: OK
> [   15.850282] Testing event xfs_dqread_fail: OK
> [   15.870306] Testing event xfs_dqread: OK
> [   15.890257] Testing event xfs_dqtobp_read: OK
> [   15.910348] Testing event xfs_dqalloc: OK
> [   15.930294] Testing event xfs_dqattach_get: OK
> [   15.950327] Testing event xfs_dqattach_found: OK
> [   15.970315] Testing event xfs_dqreclaim_done: OK
> [   15.990374] Testing event xfs_dqreclaim_busy: OK
> [   16.010312] Testing event xfs_dqreclaim_dirty: OK
> [   16.030341] Testing event xfs_dqreclaim_want: OK
> [   16.050315] Testing event xfs_dqadjust: OK
> [   16.070376] Testing event xfs_rename: OK
> [   16.090242] Testing event xfs_symlink: OK
> [   16.110272] Testing event xfs_create: OK
> [   16.130253] Testing event xfs_lookup: OK
> [   16.150288] Testing event xfs_link: OK
> [   16.170218] Testing event xfs_remove: OK
> [   16.190356] Testing event xfs_inode_unpin_nowait: OK
> [   16.210231] Testing event xfs_inode_unpin: OK
> [   16.230287] Testing event xfs_inode_pin: OK
> [   16.250255] Testing event xfs_irele: OK
> [   16.270293] Testing event xfs_ihold: OK
> [   16.290298] Testing event xfs_iomap_prealloc_size: OK
> [   16.310391] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   16.330254] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   16.350262] Testing event xfs_inode_set_eofblocks_tag: OK
> [   16.370263] Testing event xfs_dquot_dqdetach: OK
> [   16.390364] Testing event xfs_dquot_dqalloc: OK
> [   16.410263] Testing event xfs_update_time: OK
> [   16.430330] Testing event xfs_evict_inode: OK
> [   16.450339] Testing event xfs_destroy_inode: OK
> [   16.470337] Testing event xfs_file_fsync: OK
> [   16.490314] Testing event xfs_dir_fsync: OK
> [   16.510440] Testing event xfs_ioctl_setattr: OK
> [   16.530396] Testing event xfs_file_compat_ioctl: OK
> [   16.550263] Testing event xfs_file_ioctl: OK
> [   16.570241] Testing event xfs_vm_bmap: OK
> [   16.590330] Testing event xfs_readdir: OK
> [   16.610235] Testing event xfs_collapse_file_space: OK
> [   16.630339] Testing event xfs_free_file_space: OK
> [   16.650258] Testing event xfs_alloc_file_space: OK
> [   16.670335] Testing event xfs_inactive_symlink: OK
> [   16.690250] Testing event xfs_readlink: OK
> [   16.710305] Testing event xfs_setattr: OK
> [   16.730292] Testing event xfs_getattr: OK
> [   16.750320] Testing event xfs_iget_miss: OK
> [   16.770404] Testing event xfs_iget_hit: OK
> [   16.790472] Testing event xfs_iget_reclaim_fail: OK
> [   16.810318] Testing event xfs_iget_reclaim: OK
> [   16.830326] Testing event xfs_iget_skip: OK
> [   16.850331] Testing event xfs_iunlock: OK
> [   16.870394] Testing event xfs_ilock_demote: OK
> [   16.890258] Testing event xfs_ilock_nowait: OK
> [   16.910277] Testing event xfs_ilock: OK
> [   16.930264] Testing event xfs_trans_buf_ordered: OK
> [   16.950334] Testing event xfs_trans_binval: OK
> [   16.970281] Testing event xfs_trans_bhold_release: OK
> [   16.990297] Testing event xfs_trans_bhold: OK
> [   17.010298] Testing event xfs_trans_bjoin: OK
> [   17.030359] Testing event xfs_trans_brelse: OK
> [   17.050393] Testing event xfs_trans_log_buf: OK
> [   17.070333] Testing event xfs_trans_read_buf_recur: OK
> [   17.090307] Testing event xfs_trans_read_buf: OK
> [   17.110326] Testing event xfs_trans_getsb_recur: OK
> [   17.130317] Testing event xfs_trans_getsb: OK
> [   17.150312] Testing event xfs_trans_get_buf_recur: OK
> [   17.170339] Testing event xfs_trans_get_buf: OK
> [   17.190326] Testing event xfs_buf_item_push: OK
> [   17.210346] Testing event xfs_buf_item_committed: OK
> [   17.230353] Testing event xfs_buf_item_unlock_stale: OK
> [   17.250356] Testing event xfs_buf_item_unlock: OK
> [   17.270362] Testing event xfs_buf_item_unpin_stale: OK
> [   17.290352] Testing event xfs_buf_item_unpin: OK
> [   17.310383] Testing event xfs_buf_item_pin: OK
> [   17.330331] Testing event xfs_buf_item_ordered: OK
> [   17.350372] Testing event xfs_buf_item_format_stale: OK
> [   17.370416] Testing event xfs_buf_item_format_ordered: OK
> [   17.390384] Testing event xfs_buf_item_format: OK
> [   17.410374] Testing event xfs_buf_item_size_stale: OK
> [   17.430392] Testing event xfs_buf_item_size_ordered: OK
> [   17.450498] Testing event xfs_buf_item_size: OK
> [   17.470371] Testing event xfs_buf_ioerror: OK
> [   17.490350] Testing event xfs_buf_read: OK
> [   17.510384] Testing event xfs_buf_get: OK
> [   17.530410] Testing event xfs_buf_find: OK
> [   17.550424] Testing event xfs_inode_item_push: OK
> [   17.570339] Testing event xfs_reset_dqcounts: OK
> [   17.590357] Testing event xfs_da_btree_corrupt: OK
> [   17.610380] Testing event xfs_btree_corrupt: OK
> [   17.630310] Testing event xfs_trans_read_buf_shut: OK
> [   17.650370] Testing event xfs_trans_read_buf_io: OK
> [   17.670388] Testing event xfs_buf_wait_buftarg: OK
> [   17.690305] Testing event xfs_buf_error_relse: OK
> [   17.710363] Testing event xfs_buf_item_iodone_async: OK
> [   17.730294] Testing event xfs_buf_item_iodone: OK
> [   17.750271] Testing event xfs_buf_item_relse: OK
> [   17.770377] Testing event xfs_bdstrat_shut: OK
> [   17.790339] Testing event xfs_buf_get_uncached: OK
> [   17.810424] Testing event xfs_buf_delwri_split: OK
> [   17.830383] Testing event xfs_buf_delwri_queued: OK
> [   17.850375] Testing event xfs_buf_delwri_queue: OK
> [   17.870374] Testing event xfs_buf_iowait_done: OK
> [   17.890418] Testing event xfs_buf_iowait: OK
> [   17.910360] Testing event xfs_buf_unlock: OK
> [   17.930350] Testing event xfs_buf_trylock: OK
> [   17.950378] Testing event xfs_buf_lock_done: OK
> [   17.970383] Testing event xfs_buf_lock: OK
> [   17.990379] Testing event xfs_buf_bawrite: OK
> [   18.010377] Testing event xfs_buf_iorequest: OK
> [   18.030357] Testing event xfs_buf_iodone: OK
> [   18.050349] Testing event xfs_buf_rele: OK
> [   18.070344] Testing event xfs_buf_hold: OK
> [   18.090266] Testing event xfs_buf_free: OK
> [   18.110321] Testing event xfs_buf_init: OK
> [   18.130466] Testing event xfs_extlist: OK
> [   18.150272] Testing event xfs_bmap_post_update: OK
> [   18.170380] Testing event xfs_bmap_pre_update: OK
> [   18.190328] Testing event xfs_iext_remove: OK
> [   18.210314] Testing event xfs_iext_insert: OK
> [   18.230464] Testing event xfs_attr_list_node_descend: OK
> [   18.256120] Testing event xfs_ialloc_read_agi: OK
> [   18.270364] Testing event xfs_read_agi: OK
> [   18.290370] Testing event xfs_alloc_read_agf: OK
> [   18.310296] Testing event xfs_read_agf: OK
> [   18.330298] Testing event xfs_perag_clear_eofblocks: OK
> [   18.350257] Testing event xfs_perag_set_eofblocks: OK
> [   18.370264] Testing event xfs_perag_clear_reclaim: OK
> [   18.390230] Testing event xfs_perag_set_reclaim: OK
> [   18.410327] Testing event xfs_perag_put: OK
> [   18.430364] Testing event xfs_perag_get_tag: OK
> [   18.450255] Testing event xfs_perag_get: OK
> [   18.470280] Testing event xfs_attr_node_list: OK
> [   18.490333] Testing event xfs_attr_leaf_list: OK
> [   18.510329] Testing event xfs_attr_list_notfound: OK
> [   18.530404] Testing event xfs_attr_list_wrong_blk: OK
> [   18.550281] Testing event xfs_attr_list_add: OK
> [   18.570302] Testing event xfs_attr_list_full: OK
> [   18.590251] Testing event xfs_attr_list_leaf_end: OK
> [   18.610239] Testing event xfs_attr_list_leaf: OK
> [   18.630218] Testing event xfs_attr_list_sf_all: OK
> [   18.650274] Testing event xfs_attr_list_sf: OK
> [   18.670362] Testing event ocfs2_remove_block_from_cache: OK
> [   18.690295] Testing event ocfs2_remove_metadata_tree: OK
> [   18.710371] Testing event ocfs2_remove_metadata_array: OK
> [   18.730282] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   18.750288] Testing event ocfs2_set_buffer_uptodate: OK
> [   18.770281] Testing event ocfs2_expand_cache: OK
> [   18.790273] Testing event ocfs2_insert_cache_tree: OK
> [   18.810236] Testing event ocfs2_append_cache_array: OK
> [   18.830209] Testing event ocfs2_buffer_cached_end: OK
> [   18.850222] Testing event ocfs2_buffer_cached_begin: OK
> [   18.870231] Testing event ocfs2_metadata_cache_purge: OK
> [   18.890336] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   18.910220] Testing event ocfs2_read_blocks_begin: OK
> [   18.930322] Testing event ocfs2_write_block: OK
> [   18.950216] Testing event ocfs2_read_blocks_end: OK
> [   18.970222] Testing event ocfs2_read_blocks_bh: OK
> [   18.990252] Testing event ocfs2_read_blocks_from_disk: OK
> [   19.010269] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   19.030230] Testing event ocfs2_read_blocks_sync: OK
> [   19.050241] Testing event ocfs2_wait_on_mount: OK
> [   19.070225] Testing event ocfs2_recover_orphans_iput: OK
> [   19.090247] Testing event ocfs2_recover_orphans: OK
> [   19.110235] Testing event ocfs2_orphan_filldir: OK
> [   19.130234] Testing event ocfs2_queue_orphan_scan_end: OK
> [   19.150294] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   19.170242] Testing event ocfs2_mark_dead_nodes: OK
> [   19.190321] Testing event ocfs2_recover_node_skip: OK
> [   19.210267] Testing event ocfs2_recover_node: OK
> [   19.230252] Testing event ocfs2_replay_journal_skip: OK
> [   19.250349] Testing event ocfs2_replay_journal_lock_err: OK
> [   19.270373] Testing event ocfs2_replay_journal_recovered: OK
> [   19.290311] Testing event ocfs2_recovery_thread: OK
> [   19.310211] Testing event ocfs2_recovery_thread_end: OK
> [   19.330240] Testing event ocfs2_recovery_thread_node: OK
> [   19.350222] Testing event ocfs2_complete_recovery_slot: OK
> [   19.370334] Testing event ocfs2_complete_recovery_end: OK
> [   19.390359] Testing event ocfs2_complete_recovery: OK
> [   19.410349] Testing event ocfs2_journal_shutdown_wait: OK
> [   19.430255] Testing event ocfs2_journal_shutdown: OK
> [   19.450243] Testing event ocfs2_journal_init_maxlen: OK
> [   19.470253] Testing event ocfs2_journal_init: OK
> [   19.490244] Testing event ocfs2_journal_dirty: OK
> [   19.510235] Testing event ocfs2_journal_access: OK
> [   19.530221] Testing event ocfs2_allocate_extend_trans: OK
> [   19.550301] Testing event ocfs2_extend_trans_restart: OK
> [   19.570230] Testing event ocfs2_extend_trans: OK
> [   19.590317] Testing event ocfs2_commit_cache_end: OK
> [   19.610353] Testing event ocfs2_commit_cache_begin: OK
> [   19.630401] Testing event ocfs2_encode_fh_type: OK
> [   19.650297] Testing event ocfs2_encode_fh_parent: OK
> [   19.670318] Testing event ocfs2_encode_fh_self: OK
> [   19.690278] Testing event ocfs2_encode_fh_begin: OK
> [   19.710360] Testing event ocfs2_get_parent_end: OK
> [   19.730355] Testing event ocfs2_get_parent: OK
> [   19.750327] Testing event ocfs2_get_dentry_end: OK
> [   19.770348] Testing event ocfs2_get_dentry_generation: OK
> [   19.790374] Testing event ocfs2_get_dentry_stale: OK
> [   19.810389] Testing event ocfs2_get_dentry_test_bit: OK
> [   19.830341] Testing event ocfs2_get_dentry_begin: OK
> [   19.850363] Testing event ocfs2_dentry_attach_lock_found: OK
> [   19.870360] Testing event ocfs2_dentry_attach_lock: OK
> [   19.890531] Testing event ocfs2_find_local_alias: OK
> [   19.910395] Testing event ocfs2_dentry_revalidate_ret: OK
> [   19.930389] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   19.950309] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   19.970322] Testing event ocfs2_dentry_revalidate_delete: OK
> [   19.990316] Testing event ocfs2_dentry_revalidate_negative: OK
> [   20.010348] Testing event ocfs2_dentry_revalidate: OK
> [   20.030385] Testing event ocfs2_orphan_del: OK
> [   20.050407] Testing event ocfs2_orphan_add_end: OK
> [   20.070305] Testing event ocfs2_orphan_add_begin: OK
> [   20.090350] Testing event ocfs2_blkno_stringify: OK
> [   20.110358] Testing event ocfs2_symlink_begin: OK
> [   20.130390] Testing event ocfs2_create_symlink_data: OK
> [   20.150324] Testing event ocfs2_rename_over_existing: OK
> [   20.170375] Testing event ocfs2_rename_disagree: OK
> [   20.190365] Testing event ocfs2_rename_target_exists: OK
> [   20.210368] Testing event ocfs2_rename: OK
> [   20.230390] Testing event ocfs2_double_lock_end: OK
> [   20.250376] Testing event ocfs2_double_lock: OK
> [   20.270385] Testing event ocfs2_unlink_noent: OK
> [   20.290373] Testing event ocfs2_link: OK
> [   20.310400] Testing event ocfs2_mknod: OK
> [   20.330381] Testing event ocfs2_lookup_ret: OK
> [   20.350382] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   20.370386] Testing event ocfs2_symlink_create: OK
> [   20.390389] Testing event ocfs2_unlink: OK
> [   20.410371] Testing event ocfs2_create: OK
> [   20.430383] Testing event ocfs2_mkdir: OK
> [   20.450354] Testing event ocfs2_lookup: OK
> [   20.470359] Testing event ocfs2_prepare_dir_for_insert: OK
> [   20.490386] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   20.510635] Testing event ocfs2_dx_dir_rebalance: OK
> [   20.530323] Testing event ocfs2_extend_dir: OK
> [   20.550324] Testing event ocfs2_dx_dir_index_root_block: OK
> [   20.570308] Testing event ocfs2_dx_dir_format_cluster: OK
> [   20.590271] Testing event ocfs2_dx_dir_attach_index: OK
> [   20.610322] Testing event ocfs2_check_dir_for_entry: OK
> [   20.630345] Testing event ocfs2_find_files_on_disk: OK
> [   20.651055] Testing event ocfs2_readdir: OK
> [   20.670365] Testing event ocfs2_delete_entry_dx: OK
> [   20.690309] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   20.710421] Testing event ocfs2_dx_dir_search: OK
> [   20.730370] Testing event ocfs2_find_entry_el: OK
> [   20.750374] Testing event ocfs2_validate_dir_block: OK
> [   20.770329] Testing event ocfs2_search_dirblock: OK
> [   20.790282] Testing event ocfs2_mark_dquot_dirty: OK
> [   20.810253] Testing event ocfs2_acquire_dquot: OK
> [   20.830362] Testing event ocfs2_release_dquot: OK
> [   20.850327] Testing event ocfs2_write_dquot: OK
> [   20.870323] Testing event ocfs2_sync_dquot_helper: OK
> [   20.890314] Testing event ocfs2_sync_dquot: OK
> [   20.910317] Testing event ocfs2_validate_quota_block: OK
> [   20.930300] Testing event olq_set_dquot: OK
> [   20.950415] Testing event ocfs2_finish_quota_recovery: OK
> [   20.970325] Testing event ocfs2_recover_local_quota_file: OK
> [   20.990310] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   21.010359] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   21.030335] Testing event ocfs2_resmap_resv_bits: OK
> [   21.050348] Testing event ocfs2_cannibalize_resv_end: OK
> [   21.070377] Testing event ocfs2_cannibalize_resv_begin: OK
> [   21.090324] Testing event ocfs2_resv_find_window_next: OK
> [   21.110334] Testing event ocfs2_resv_find_window_prev: OK
> [   21.130317] Testing event ocfs2_resv_find_window_begin: OK
> [   21.150303] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   21.170299] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   21.190315] Testing event ocfs2_resv_insert: OK
> [   21.210298] Testing event ocfs2_reflink_xattr_rec: OK
> [   21.230304] Testing event ocfs2_reflink_xattr_buckets: OK
> [   21.250363] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   21.271522] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   21.291432] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   21.311426] Testing event ocfs2_create_empty_xattr_block: OK
> [   21.331458] Testing event ocfs2_reflink_xattr_header: OK
> [   21.351456] Testing event ocfs2_rm_xattr_cluster: OK
> [   21.371488] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   21.391442] Testing event ocfs2_add_new_xattr_bucket: OK
> [   21.411804] Testing event ocfs2_extend_xattr_bucket: OK
> [   21.431424] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   21.451438] Testing event ocfs2_add_new_xattr_cluster: OK
> [   21.471416] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   21.491411] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   21.511419] Testing event ocfs2_mv_xattr_buckets: OK
> [   21.531438] Testing event ocfs2_cp_xattr_bucket: OK
> [   21.551414] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   21.571366] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   21.591387] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   21.611439] Testing event ocfs2_defrag_xattr_bucket: OK
> [   21.631434] Testing event ocfs2_xattr_create_index_block: OK
> [   21.651440] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   21.671416] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   21.691468] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   21.711431] Testing event ocfs2_iterate_xattr_bucket: OK
> [   21.731435] Testing event ocfs2_iterate_xattr_buckets: OK
> [   21.751436] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   21.771438] Testing event ocfs2_xattr_index_block_find: OK
> [   21.791417] Testing event ocfs2_xattr_bucket_find: OK
> [   21.811426] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   21.831432] Testing event ocfs2_xattr_extend_allocation: OK
> [   21.851434] Testing event ocfs2_validate_xattr_block: OK
> [   21.871437] Testing event ocfs2_initialize_super: OK
> [   21.891437] Testing event ocfs2_dismount_volume: OK
> [   21.911473] Testing event ocfs2_statfs: OK
> [   21.931437] Testing event ocfs2_put_super: OK
> [   21.951354] Testing event ocfs2_parse_options: OK
> [   21.971374] Testing event ocfs2_fill_super: OK
> [   21.991377] Testing event ocfs2_remount: OK
> [   22.011380] Testing event ocfs2_do_node_down: OK
> [   22.031375] Testing event ocfs2_find_slot: OK
> [   22.051351] Testing event ocfs2_map_slot_buffers_block: OK
> [   22.071375] Testing event ocfs2_map_slot_buffers: OK
> [   22.091378] Testing event ocfs2_refresh_slot_info: OK
> [   22.111373] Testing event ocfs2_read_virt_blocks: OK
> [   22.131384] Testing event ocfs2_mark_inode_dirty: OK
> [   22.151368] Testing event ocfs2_inode_revalidate: OK
> [   22.171379] Testing event ocfs2_drop_inode: OK
> [   22.191386] Testing event ocfs2_clear_inode: OK
> [   22.211372] Testing event ocfs2_delete_inode: OK
> [   22.231374] Testing event ocfs2_cleanup_delete_inode: OK
> [   22.251372] Testing event ocfs2_query_inode_wipe_end: OK
> [   22.271379] Testing event ocfs2_query_inode_wipe_succ: OK
> [   22.291403] Testing event ocfs2_query_inode_wipe_begin: OK
> [   22.311380] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   22.331390] Testing event ocfs2_validate_inode_block: OK
> [   22.351392] Testing event ocfs2_check_orphan_recovery_state: OK
> [   22.371407] Testing event ocfs2_read_locked_inode: OK
> [   22.391394] Testing event ocfs2_populate_inode: OK
> [   22.411374] Testing event ocfs2_find_actor: OK
> [   22.431400] Testing event ocfs2_iget_end: OK
> [   22.451355] Testing event ocfs2_iget5_locked: OK
> [   22.471377] Testing event ocfs2_iget_begin: OK
> [   22.491335] Testing event generic_file_aio_read_ret: OK
> [   22.511392] Testing event ocfs2_prepare_inode_for_write: OK
> [   22.531410] Testing event ocfs2_remove_inode_range: OK
> [   22.551399] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   22.571383] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   22.591382] Testing event ocfs2_zero_partial_clusters: OK
> [   22.611371] Testing event ocfs2_write_remove_suid: OK
> [   22.631341] Testing event ocfs2_setattr: OK
> [   22.651370] Testing event ocfs2_zero_extend: OK
> [   22.671360] Testing event ocfs2_zero_extend_range: OK
> [   22.691350] Testing event ocfs2_write_zero_page: OK
> [   22.711370] Testing event ocfs2_extend_allocation_end: OK
> [   22.731354] Testing event ocfs2_extend_allocation: OK
> [   22.751373] Testing event ocfs2_truncate_file_error: OK
> [   22.771384] Testing event ocfs2_truncate_file: OK
> [   22.791355] Testing event ocfs2_file_aio_read: OK
> [   22.811385] Testing event ocfs2_file_splice_read: OK
> [   22.831373] Testing event ocfs2_file_splice_write: OK
> [   22.851362] Testing event ocfs2_file_aio_write: OK
> [   22.871348] Testing event ocfs2_sync_file: OK
> [   22.891340] Testing event ocfs2_file_release: OK
> [   22.911378] Testing event ocfs2_file_open: OK
> [   22.931375] Testing event ocfs2_fault: OK
> [   22.951377] Testing event ocfs2_write_end_inline: OK
> [   22.971382] Testing event ocfs2_write_begin_nolock: OK
> [   22.991425] Testing event ocfs2_try_to_write_inline_data: OK
> [   23.011064] Testing event ocfs2_bmap: OK
> [   23.031222] Testing event ocfs2_writepage: OK
> [   23.051202] Testing event ocfs2_readpage: OK
> [   23.071310] Testing event ocfs2_get_block_end: OK
> [   23.091829] Testing event ocfs2_get_block: OK
> [   23.111418] Testing event ocfs2_symlink_get_block: OK
> [   23.131605] Testing event ocfs2_refcount_cow_hunk: OK
> [   23.151368] Testing event ocfs2_make_clusters_writable: OK
> [   23.171618] Testing event ocfs2_replace_clusters: OK
> [   23.191815] Testing event ocfs2_clear_ext_refcount: OK
> [   23.211395] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   23.231328] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   23.251333] Testing event ocfs2_lock_refcount_allocators: OK
> [   23.271253] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   23.291250] Testing event ocfs2_add_refcount_flag: OK
> [   23.311231] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   23.331211] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   23.351372] Testing event ocfs2_mark_extent_refcounted: OK
> [   23.371397] Testing event ocfs2_decrease_refcount: OK
> [   23.391373] Testing event ocfs2_decrease_refcount_rec: OK
> [   23.411402] Testing event ocfs2_restore_refcount_block: OK
> [   23.431412] Testing event ocfs2_remove_refcount_extent: OK
> [   23.451444] Testing event ocfs2_increase_refcount_split: OK
> [   23.471413] Testing event ocfs2_increase_refcount_insert: OK
> [   23.491476] Testing event ocfs2_increase_refcount_change: OK
> [   23.511773] Testing event ocfs2_increase_refcount_begin: OK
> [   23.531371] Testing event ocfs2_split_refcount_rec_insert: OK
> [   23.551675] Testing event ocfs2_split_refcount_rec: OK
> [   23.571556] Testing event ocfs2_insert_refcount_rec: OK
> [   23.591414] Testing event ocfs2_new_leaf_refcount_block: OK
> [   23.611405] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   23.631638] Testing event ocfs2_expand_inline_ref_root: OK
> [   23.651432] Testing event ocfs2_change_refcount_rec: OK
> [   23.671359] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   23.691403] Testing event ocfs2_create_refcount_tree: OK
> [   23.711366] Testing event ocfs2_purge_refcount_trees: OK
> [   23.731345] Testing event ocfs2_validate_refcount_block: OK
> [   23.751313] Testing event ocfs2_test_inode_bit: OK
> [   23.771297] Testing event ocfs2_test_suballoc_bit: OK
> [   23.791340] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   23.811616] Testing event ocfs2_free_clusters: OK
> [   23.831323] Testing event ocfs2_free_suballoc_bits: OK
> [   23.851599] Testing event ocfs2_block_group_clear_bits: OK
> [   23.871464] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   23.891422] Testing event ocfs2_claim_suballoc_bits: OK
> [   23.911450] Testing event ocfs2_search_chain_end: OK
> [   23.931442] Testing event ocfs2_search_chain_succ: OK
> [   23.951408] Testing event ocfs2_search_chain_begin: OK
> [   23.971421] Testing event ocfs2_block_group_search_max_block: OK
> [   23.991434] Testing event ocfs2_cluster_group_search_max_block: OK
> [   24.011448] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   24.031419] Testing event ocfs2_relink_block_group: OK
> [   24.051376] Testing event ocfs2_block_group_set_bits: OK
> [   24.071111] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   24.091294] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   24.111287] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   24.131442] Testing event ocfs2_block_group_alloc: OK
> [   24.151639] Testing event ocfs2_block_group_alloc_discontig: OK
> [   24.171554] Testing event ocfs2_block_group_alloc_contig: OK
> [   24.192118] Testing event ocfs2_validate_group_descriptor: OK
> [   24.211759] Testing event ocfs2_group_add: OK
> [   24.231583] Testing event ocfs2_group_extend: OK
> [   24.251414] Testing event ocfs2_update_last_group_and_inode: OK
> [   24.271465] Testing event ocfs2_local_alloc_new_window_result: OK
> [   24.291547] Testing event ocfs2_local_alloc_new_window: OK
> [   24.311597] Testing event ocfs2_sync_local_to_main_free: OK
> [   24.331415] Testing event ocfs2_sync_local_to_main: OK
> [   24.351359] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   24.371407] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   24.391518] Testing event ocfs2_local_alloc_count_bits: OK
> [   24.411335] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   24.431345] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   24.451419] Testing event ocfs2_load_local_alloc: OK
> [   24.471884] Testing event ocfs2_alloc_should_use_local: OK
> [   24.491381] Testing event ocfs2_la_set_sizes: OK
> [   24.511360] Testing event ocfs2_trim_fs: OK
> [   24.531393] Testing event ocfs2_trim_group: OK
> [   24.551748] Testing event ocfs2_trim_extent: OK
> [   24.571273] Testing event ocfs2_cache_block_dealloc: OK
> [   24.591346] Testing event ocfs2_run_deallocs: OK
> [   24.611306] Testing event ocfs2_cache_cluster_dealloc: OK
> [   24.631302] Testing event ocfs2_free_cached_blocks: OK
> [   24.651713] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   24.671290] Testing event ocfs2_truncate_log_recovery_num: OK
> [   24.691311] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   24.711360] Testing event ocfs2_flush_truncate_log: OK
> [   24.731362] Testing event ocfs2_replay_truncate_records: OK
> [   24.751421] Testing event ocfs2_truncate_log_append: OK
> [   24.771365] Testing event ocfs2_mark_extent_written: OK
> [   24.791730] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   24.811415] Testing event ocfs2_rotate_leaf: OK
> [   24.831354] Testing event ocfs2_validate_extent_block: OK
> [   24.851372] Testing event ocfs2_commit_truncate: OK
> [   24.871369] Testing event ocfs2_remove_extent: OK
> [   24.891713] Testing event ocfs2_split_extent: OK
> [   24.911403] Testing event ocfs2_insert_extent: OK
> [   24.931336] Testing event ocfs2_rotate_subtree: OK
> [   24.951241] Testing event ocfs2_grow_tree: OK
> [   24.971250] Testing event ocfs2_complete_edge_insert: OK
> [   24.991274] Testing event ocfs2_num_free_extents: OK
> [   25.011261] Testing event ocfs2_add_clusters_in_btree: OK
> [   25.031282] Testing event ocfs2_insert_extent_start: OK
> [   25.051265] Testing event ocfs2_append_rec_to_path: OK
> [   25.071276] Testing event ocfs2_rotate_tree_right: OK
> [   25.091290] Testing event ocfs2_adjust_rightmost_branch: OK
> [   25.111230] Testing event btrfs_workqueue_destroy: OK
> [   25.131230] Testing event btrfs_workqueue_alloc: OK
> [   25.151270] Testing event btrfs_ordered_sched: OK
> [   25.171312] Testing event btrfs_all_work_done: OK
> [   25.191342] Testing event btrfs_normal_work_done: OK
> [   25.211346] Testing event btrfs_work_sched: OK
> [   25.231328] Testing event btrfs_work_queued: OK
> [   25.251533] Testing event free_extent_state: OK
> [   25.271645] Testing event alloc_extent_state: OK
> [   25.291705] Testing event btrfs_setup_cluster: OK
> [   25.311716] Testing event btrfs_failed_cluster_setup: OK
> [   25.331875] Testing event btrfs_find_cluster: OK
> [   25.351382] Testing event btrfs_reserve_extent_cluster: OK
> [   25.371396] Testing event btrfs_reserve_extent: OK
> [   25.391367] Testing event find_free_extent: OK
> [   25.411364] Testing event btrfs_reserved_extent_free: OK
> [   25.431388] Testing event btrfs_reserved_extent_alloc: OK
> [   25.451336] Testing event btrfs_space_reservation: OK
> [   25.471817] Testing event btrfs_cow_block: OK
> [   25.491760] Testing event btrfs_chunk_free: OK
> [   25.511222] Testing event btrfs_chunk_alloc: OK
> [   25.531272] Testing event run_delayed_ref_head: OK
> [   25.551264] Testing event add_delayed_ref_head: OK
> [   25.571254] Testing event run_delayed_data_ref: OK
> [   25.591271] Testing event add_delayed_data_ref: OK
> [   25.611240] Testing event run_delayed_tree_ref: OK
> [   25.631254] Testing event add_delayed_tree_ref: OK
> [   25.651245] Testing event btrfs_sync_fs: OK
> [   25.671243] Testing event btrfs_sync_file: OK
> [   25.691290] Testing event btrfs_writepage_end_io_hook: OK
> [   25.711834] Testing event __extent_writepage: OK
> [   25.731373] Testing event btrfs_ordered_extent_put: OK
> [   25.751367] Testing event btrfs_ordered_extent_start: OK
> [   25.771367] Testing event btrfs_ordered_extent_remove: OK
> [   25.791380] Testing event btrfs_ordered_extent_add: OK
> [   25.811344] Testing event btrfs_get_extent: OK
> [   25.831341] Testing event btrfs_inode_evict: OK
> [   25.851362] Testing event btrfs_inode_request: OK
> [   25.871302] Testing event btrfs_inode_new: OK
> [   25.891481] Testing event btrfs_transaction_commit: OK
> [   25.911308] Testing event gfs2_rs: OK
> [   25.931543] Testing event gfs2_block_alloc: OK
> [   25.951336] Testing event gfs2_bmap: OK
> [   25.971562] Testing event gfs2_ail_flush: OK
> [   25.991338] Testing event gfs2_log_blocks: OK
> [   26.011834] Testing event gfs2_log_flush: OK
> [   26.031810] Testing event gfs2_pin: OK
> [   26.051619] Testing event gfs2_glock_lock_time: OK
> [   26.071563] Testing event gfs2_glock_queue: OK
> [   26.091561] Testing event gfs2_promote: OK
> [   26.111147] Testing event gfs2_demote_rq: OK
> [   26.131252] Testing event gfs2_glock_put: OK
> [   26.151321] Testing event gfs2_glock_state_change: OK
> [   26.171386] Testing event block_rq_remap: OK
> [   26.191343] Testing event block_bio_remap: OK
> [   26.211544] Testing event block_split: OK
> [   26.231761] Testing event block_unplug: OK
> [   26.251328] Testing event block_plug: OK
> [   26.271732] Testing event block_sleeprq: OK
> [   26.291355] Testing event block_getrq: OK
> [   26.311408] Testing event block_bio_queue: OK
> [   26.331311] Testing event block_bio_frontmerge: OK
> [   26.351452] Testing event block_bio_backmerge: OK
> [   26.371281] Testing event block_bio_complete: OK
> [   26.391356] Testing event block_bio_bounce: OK
> [   26.411321] Testing event block_rq_issue: OK
> [   26.431317] Testing event block_rq_insert: OK
> [   26.451324] Testing event block_rq_complete: OK
> [   26.471309] Testing event block_rq_requeue: OK
> [   26.491327] Testing event block_rq_abort: OK
> [   26.511330] Testing event block_dirty_buffer: OK
> [   26.531103] Testing event block_touch_buffer: OK
> [   26.551347] Testing event swiotlb_bounced: OK
> [   26.571350] Testing event gpio_value: OK
> [   26.591204] Testing event gpio_direction: OK
> [   26.611407] Testing event aer_event: OK
> [   26.631676] Testing event regulator_set_voltage_complete: OK
> [   26.651506] Testing event regulator_set_voltage: OK
> [   26.671313] Testing event regulator_disable_complete: OK
> [   26.691531] Testing event regulator_disable: OK
> [   26.711349] Testing event regulator_enable_complete: OK
> [   26.731299] Testing event regulator_enable_delay: OK
> [   26.751325] Testing event regulator_enable: OK
> [   26.771424] Testing event urandom_read: OK
> [   26.791350] Testing event random_read: OK
> [   26.811763] Testing event extract_entropy_user: OK
> [   26.831527] Testing event extract_entropy: OK
> [   26.851477] Testing event get_random_bytes_arch: OK
> [   26.871619] Testing event get_random_bytes: OK
> [   26.891467] Testing event xfer_secondary_pool: OK
> [   26.911452] Testing event add_disk_randomness: OK
> [   26.931441] Testing event add_input_randomness: OK
> [   26.951640] Testing event debit_entropy: OK
> [   26.971689] Testing event push_to_pool: OK
> [   26.991771] Testing event credit_entropy_bits: OK
> [   27.011280] Testing event mix_pool_bytes_nolock: OK
> [   27.031311] Testing event mix_pool_bytes: OK
> [   27.051349] Testing event add_device_randomness: OK
> [   27.071850] Testing event drm_vblank_event_delivered: OK
> [   27.091552] Testing event drm_vblank_event_queued: OK
> [   27.111501] Testing event drm_vblank_event: OK
> [   27.131466] Testing event radeon_semaphore_wait: OK
> [   27.151538] Testing event radeon_semaphore_signale: OK
> [   27.171763] Testing event radeon_fence_wait_end: OK
> [   27.191548] Testing event radeon_fence_wait_begin: OK
> [   27.211514] Testing event radeon_fence_emit: OK
> [   27.231664] Testing event radeon_vm_set_page: OK
> [   27.251518] Testing event radeon_vm_bo_update: OK
> [   27.271478] Testing event radeon_vm_grab_id: OK
> [   27.291487] Testing event radeon_cs: OK
> [   27.311478] Testing event radeon_bo_create: OK
> [   27.331502] Testing event regcache_drop_region: OK
> [   27.351527] Testing event regmap_async_complete_done: OK
> [   27.371521] Testing event regmap_async_complete_start: OK
> [   27.391499] Testing event regmap_async_io_complete: OK
> [   27.411413] Testing event regmap_async_write_start: OK
> [   27.431442] Testing event regmap_cache_bypass: OK
> [   27.451477] Testing event regmap_cache_only: OK
> [   27.471442] Testing event regcache_sync: OK
> [   27.491470] Testing event regmap_hw_write_done: OK
> [   27.511468] Testing event regmap_hw_write_start: OK
> [   27.531477] Testing event regmap_hw_read_done: OK
> [   27.551484] Testing event regmap_hw_read_start: OK
> [   27.571438] Testing event regmap_reg_read_cache: OK
> [   27.591487] Testing event regmap_reg_read: OK
> [   27.611480] Testing event regmap_reg_write: OK
> [   27.631510] Testing event scsi_eh_wakeup: OK
> [   27.651458] Testing event scsi_dispatch_cmd_timeout: OK
> [   27.671464] Testing event scsi_dispatch_cmd_done: OK
> [   27.691401] Testing event scsi_dispatch_cmd_error: OK
> [   27.711501] Testing event scsi_dispatch_cmd_start: OK
> [   27.731391] Testing event target_cmd_complete: OK
> [   27.751433] Testing event target_sequencer_start: OK
> [   27.771465] Testing event spi_transfer_stop: OK
> [   27.791466] Testing event spi_transfer_start: OK
> [   27.811401] Testing event spi_message_done: OK
> [   27.831481] Testing event spi_message_start: OK
> [   27.851498] Testing event spi_message_submit: OK
> [   27.871516] Testing event spi_master_busy: OK
> [   27.891862] Testing event spi_master_idle: OK
> [   27.911447] Testing event smbus_result: OK
> [   27.931471] Testing event smbus_reply: OK
> [   27.951452] Testing event smbus_read: OK
> [   27.971492] Testing event smbus_write: OK
> [   27.991448] Testing event i2c_result: OK
> [   28.011492] Testing event i2c_reply: OK
> [   28.031497] Testing event i2c_read: OK
> [   28.051476] Testing event i2c_write: OK
> [   28.071453] Testing event mc_event: OK
> [   28.091497] Testing event snd_soc_cache_sync: OK
> [   28.111488] Testing event snd_soc_jack_notify: OK
> [   28.131432] Testing event snd_soc_jack_report: OK
> [   28.151455] Testing event snd_soc_jack_irq: OK
> [   28.171467] Testing event snd_soc_dapm_connected: OK
> [   28.191463] Testing event snd_soc_dapm_input_path: OK
> [   28.211498] Testing event snd_soc_dapm_output_path: OK
> [   28.231509] Testing event snd_soc_dapm_walk_done: OK
> [   28.251469] Testing event snd_soc_dapm_widget_event_done: OK
> [   28.271464] Testing event snd_soc_dapm_widget_event_start: OK
> [   28.291471] Testing event snd_soc_dapm_widget_power: OK
> [   28.311484] Testing event snd_soc_dapm_done: OK
> [   28.331467] Testing event snd_soc_dapm_start: OK
> [   28.351411] Testing event snd_soc_bias_level_done: OK
> [   28.371484] Testing event snd_soc_bias_level_start: OK
> [   28.391490] Testing event snd_soc_preg_read: OK
> [   28.411503] Testing event snd_soc_preg_write: OK
> [   28.431420] Testing event snd_soc_reg_read: OK
> [   28.451471] Testing event snd_soc_reg_write: OK
> [   28.471482] Testing event sst_ipc_outbox_write: OK
> [   28.491322] Testing event sst_ipc_outbox_read: OK
> [   28.511448] Testing event sst_ipc_inbox_write: OK
> [   28.531465] Testing event sst_ipc_inbox_read: OK
> [   28.551495] Testing event sst_ipc_outbox_wdata: OK
> [   28.571521] Testing event sst_ipc_outbox_rdata: OK
> [   28.591492] Testing event sst_ipc_inbox_wdata: OK
> [   28.611497] Testing event sst_ipc_inbox_rdata: OK
> [   28.631499] Testing event sst_ipc_msg_rx: OK
> [   28.651500] Testing event sst_ipc_msg_tx: OK
> [   28.671490] Testing event udp_fail_queue_rcv_skb: OK
> [   28.691514] Testing event sock_exceed_buf_limit: OK
> [   28.711476] Testing event sock_rcvqueue_full: OK
> [   28.731508] Testing event napi_poll: OK
> [   28.751464] Testing event netif_rx_ni_entry: OK
> [   28.771504] Testing event netif_rx_entry: OK
> [   28.791501] Testing event netif_receive_skb_entry: OK
> [   28.811506] Testing event napi_gro_receive_entry: OK
> [   28.831487] Testing event napi_gro_frags_entry: OK
> [   28.851475] Testing event netif_rx: OK
> [   28.871486] Testing event netif_receive_skb: OK
> [   28.891490] Testing event net_dev_queue: OK
> [   28.911477] Testing event net_dev_xmit: OK
> [   28.931523] Testing event net_dev_start_xmit: OK
> [   28.951483] Testing event skb_copy_datagram_iovec: OK
> [   28.971518] Testing event consume_skb: OK
> [   28.991530] Testing event kfree_skb: OK
> [   29.011497] Testing event 9p_protocol_dump: OK
> [   29.031482] Testing event 9p_client_res: OK
> [   29.051478] Testing event 9p_client_req: OK
> [   29.071477] Running tests on trace event systems:
> [   29.072130] Testing event system 9p: OK
> [   29.091563] Testing event system skb: OK
> [   29.111553] Testing event system net: OK
> [   29.131561] Testing event system napi: OK
> [   29.151513] Testing event system sock: OK
> [   29.171552] Testing event system udp: OK
> [   29.191545] Testing event system intel-sst: OK
> [   29.211554] Testing event system asoc: OK
> [   29.231573] Testing event system i2c: OK
> [   29.251537] Testing event system spi: OK
> [   29.271581] Testing event system target: OK
> [   29.291544] Testing event system scsi: OK
> [   29.311530] Testing event system regmap: OK
> [   29.331529] Testing event system radeon: OK
> [   29.351553] Testing event system drm: OK
> [   29.371597] Testing event system random: OK
> [   29.391628] Testing event system regulator: OK
> [   29.411538] Testing event system ras: OK
> [   29.431495] Testing event system gpio: OK
> [   29.451528] Testing event system swiotlb: OK
> [   29.471606] Testing event system block: OK
> [   29.491606] Testing event system gfs2: OK
> [   29.511552] Testing event system btrfs: OK
> [   29.531639] Testing event system ocfs2: OK
> [   29.552426] Testing event system xfs: OK
> [   29.572361] Testing event system jbd2: OK
> [   29.591561] Testing event system writeback: OK
> [   29.611577] Testing event system migrate: OK
> [   29.631500] Testing event system compaction: OK
> [   29.651520] Testing event system kmem: OK
> [   29.671648] Testing event system vmscan: OK
> [   29.691547] Testing event system pagemap: OK
> [   29.711527] Testing event system oom: OK
> [   29.731560] Testing event system filemap: OK
> [   29.751555] Testing event system context_tracking: OK
> [   29.771602] Testing event system power: OK
> [   29.791596] Testing event system test: OK
> [   29.811508] Testing event system rcu: OK
> [   29.831511] Testing event system printk: OK
> [   29.851512] Testing event system lock: OK
> [   29.871808] Testing event system sched: OK
> [   29.891643] Testing event system workqueue: OK
> [   29.911549] Testing event system signal: OK
> [   29.931529] Testing event system timer: OK
> [   29.951547] Testing event system irq: OK
> [   29.971583] Testing event system task: OK
> [   29.991538] Testing event system exceptions: OK
> [   30.011470] Testing event system raw_syscalls: OK
> [   30.031526] Testing event system vsyscall: OK
> [   30.051537] Testing event system nmi: OK
> [   30.071572] Testing event system irq_vectors: OK
> [   30.091652] Testing event system kvmmmu: OK
> [   30.111570] Testing event system kvm: OK
> [   30.131613] Running tests on all trace events:
> [   30.132224] Testing all events: OK
> [   30.165270] Running tests again, along with the function tracer
> [   30.166237] Running tests on trace events:
> [   30.166921] Testing event kvm_async_pf_completed: 
> [   30.180728] test-events (1294) used greatest stack depth: 5880 bytes left
> [   30.181950] OK
> [   30.182252] Testing event kvm_async_pf_ready: OK
> [   30.203062] Testing event kvm_async_pf_not_present: OK
> [   30.222936] Testing event kvm_async_pf_doublefault: OK
> [   30.242492] Testing event kvm_try_async_get_page: OK
> [   30.262600] Testing event kvm_age_page: OK
> [   30.282487] Testing event kvm_fpu: OK
> [   30.302525] Testing event kvm_mmio: OK
> [   30.322493] Testing event kvm_ack_irq: 
> [   30.342328] test-events (1302) used greatest stack depth: 5872 bytes left
> [   30.343158] OK
> [   30.343351] Testing event kvm_msi_set_irq: 
> [   30.362413] test-events (1303) used greatest stack depth: 5856 bytes left
> [   30.363244] OK
> [   30.363437] Testing event kvm_ioapic_set_irq: OK
> [   30.382529] Testing event kvm_set_irq: OK
> [   30.402504] Testing event kvm_userspace_exit: OK
> [   30.422495] Testing event kvm_track_tsc: OK
> [   30.442750] Testing event kvm_update_master_clock: OK
> [   30.462528] Testing event kvm_write_tsc_offset: OK
> [   30.482460] Testing event vcpu_match_mmio: OK
> [   30.502656] Testing event kvm_emulate_insn: OK
> [   30.522826] Testing event kvm_skinit: OK
> [   30.542912] Testing event kvm_invlpga: OK
> [   30.562836] Testing event kvm_nested_intr_vmexit: OK
> [   30.581995] Testing event kvm_nested_vmexit_inject: 
> [   30.602323] test-events (1315) used greatest stack depth: 5792 bytes left
> [   30.603152] OK
> [   30.603346] Testing event kvm_nested_vmexit: OK
> [   30.622519] Testing event kvm_nested_intercepts: OK
> [   30.642593] Testing event kvm_nested_vmrun: OK
> [   30.662500] Testing event kvm_pv_eoi: OK
> [   30.682482] Testing event kvm_eoi: OK
> [   30.702403] Testing event kvm_apic_accept_irq: OK
> [   30.722520] Testing event kvm_apic_ipi: OK
> [   30.742490] Testing event kvm_pic_set_irq: OK
> [   30.762518] Testing event kvm_cr: OK
> [   30.782358] Testing event kvm_msr: OK
> [   30.802499] Testing event kvm_page_fault: OK
> [   30.822548] Testing event kvm_inj_exception: OK
> [   30.842489] Testing event kvm_inj_virq: OK
> [   30.862423] Testing event kvm_exit: OK
> [   30.882643] Testing event kvm_apic: OK
> [   30.902599] Testing event kvm_cpuid: OK
> [   30.922475] Testing event kvm_pio: OK
> [   30.942380] Testing event kvm_hv_hypercall: OK
> [   30.964507] Testing event kvm_hypercall: OK
> [   30.982727] Testing event kvm_entry: OK
> [   31.002754] Testing event check_mmio_spte: OK
> [   31.022731] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [   31.042799] Testing event fast_page_fault: OK
> [   31.062818] Testing event handle_mmio_page_fault: OK
> [   31.083052] Testing event mark_mmio_spte: OK
> [   31.103632] Testing event kvm_mmu_prepare_zap_page: OK
> [   31.122546] Testing event kvm_mmu_unsync_page: OK
> [   31.142466] Testing event kvm_mmu_sync_page: OK
> [   31.162489] Testing event kvm_mmu_get_page: OK
> [   31.182918] Testing event kvm_mmu_walker_error: OK
> [   31.200923] Testing event kvm_mmu_set_dirty_bit: OK
> [   31.220982] Testing event kvm_mmu_set_accessed_bit: OK
> [   31.241105] Testing event kvm_mmu_paging_element: 
> [   31.260872] test-events (1348) used greatest stack depth: 5712 bytes left
> [   31.262084] OK
> [   31.262383] Testing event kvm_mmu_pagetable_walk: OK
> [   31.282687] Testing event thermal_apic_exit: OK
> [   31.301038] Testing event thermal_apic_entry: OK
> [   31.321025] Testing event threshold_apic_exit: OK
> [   31.340998] Testing event threshold_apic_entry: OK
> [   31.360916] Testing event call_function_single_exit: OK
> [   31.381182] Testing event call_function_single_entry: OK
> [   31.401099] Testing event call_function_exit: OK
> [   31.421069] Testing event call_function_entry: OK
> [   31.440885] Testing event irq_work_exit: OK
> [   31.461140] Testing event irq_work_entry: OK
> [   31.480930] Testing event x86_platform_ipi_exit: OK
> [   31.500966] Testing event x86_platform_ipi_entry: OK
> [   31.520760] Testing event error_apic_exit: OK
> [   31.541167] Testing event error_apic_entry: OK
> [   31.561129] Testing event spurious_apic_exit: OK
> [   31.580990] Testing event spurious_apic_entry: OK
> [   31.600744] Testing event reschedule_exit: OK
> [   31.621114] Testing event reschedule_entry: OK
> [   31.641079] Testing event local_timer_exit: OK
> [   31.661041] Testing event local_timer_entry: OK
> [   31.680857] Testing event nmi_handler: OK
> [   31.700703] Testing event emulate_vsyscall: OK
> [   31.720987] Testing event sys_exit: OK
> [   31.741089] Testing event sys_enter: OK
> [   31.760931] Testing event page_fault_kernel: OK
> [   31.781643] Testing event page_fault_user: OK
> [   31.801098] Testing event task_rename: OK
> [   31.821083] Testing event task_newtask: OK
> [   31.840693] Testing event softirq_raise: OK
> [   31.860852] Testing event softirq_exit: OK
> [   31.881508] Testing event softirq_entry: OK
> [   31.901510] Testing event irq_handler_exit: OK
> [   31.921214] Testing event irq_handler_entry: OK
> [   31.941156] Testing event itimer_expire: OK
> [   31.960661] Testing event itimer_state: OK
> [   31.980807] Testing event hrtimer_cancel: OK
> [   32.000730] Testing event hrtimer_expire_exit: OK
> [   32.020978] Testing event hrtimer_expire_entry: OK
> [   32.040527] Testing event hrtimer_start: OK
> [   32.060576] Testing event hrtimer_init: OK
> [   32.080569] Testing event timer_cancel: OK
> [   32.100885] Testing event timer_expire_exit: OK
> [   32.120631] Testing event timer_expire_entry: OK
> [   32.140740] Testing event timer_start: OK
> [   32.160509] Testing event timer_init: OK
> [   32.180736] Testing event signal_deliver: OK
> [   32.200607] Testing event signal_generate: OK
> [   32.220736] Testing event workqueue_execute_end: OK
> [   32.240439] Testing event workqueue_execute_start: OK
> [   32.260804] Testing event workqueue_activate_work: OK
> [   32.280638] Testing event workqueue_queue_work: OK
> [   32.300687] Testing event sched_swap_numa: OK
> [   32.320536] Testing event sched_stick_numa: OK
> [   32.340643] Testing event sched_move_numa: OK
> [   32.360514] Testing event sched_process_hang: OK
> [   32.380610] Testing event sched_pi_setprio: OK
> [   32.400431] Testing event sched_stat_runtime: OK
> [   32.420690] Testing event sched_stat_blocked: OK
> [   32.440377] Testing event sched_stat_iowait: OK
> [   32.460608] Testing event sched_stat_sleep: OK
> [   32.480399] Testing event sched_stat_wait: OK
> [   32.500654] Testing event sched_process_exec: OK
> [   32.520540] Testing event sched_process_fork: OK
> [   32.540534] Testing event sched_process_wait: OK
> [   32.560572] Testing event sched_wait_task: OK
> [   32.580603] Testing event sched_process_exit: OK
> [   32.600511] Testing event sched_process_free: OK
> [   32.620493] Testing event sched_migrate_task: OK
> [   32.640700] Testing event sched_switch: OK
> [   32.660968] Testing event sched_wakeup_new: OK
> [   32.680470] Testing event sched_wakeup: OK
> [   32.701250] Testing event sched_kthread_stop_ret: OK
> [   32.720512] Testing event sched_kthread_stop: OK
> [   32.740721] Testing event lock_acquired: OK
> [   32.760485] Testing event lock_contended: OK
> [   32.780731] Testing event lock_release: OK
> [   32.800680] Testing event lock_acquire: OK
> [   32.820965] Testing event console: OK
> [   32.840531] Testing event rcu_utilization: OK
> [   32.860602] Testing event ftrace_test_filter: OK
> [   32.880427] Testing event dev_pm_qos_remove_request: OK
> [   32.900637] Testing event dev_pm_qos_update_request: OK
> [   32.920487] Testing event dev_pm_qos_add_request: OK
> [   32.940723] Testing event pm_qos_update_flags: OK
> [   32.960652] Testing event pm_qos_update_target: OK
> [   32.980756] Testing event pm_qos_update_request_timeout: OK
> [   33.000686] Testing event pm_qos_remove_request: OK
> [   33.020919] Testing event pm_qos_update_request: OK
> [   33.041095] Testing event pm_qos_add_request: OK
> [   33.060762] Testing event power_domain_target: OK
> [   33.080682] Testing event clock_set_rate: OK
> [   33.100923] Testing event clock_disable: OK
> [   33.120691] Testing event clock_enable: OK
> [   33.140559] Testing event wakeup_source_deactivate: OK
> [   33.160474] Testing event wakeup_source_activate: OK
> [   33.180598] Testing event device_pm_report_time: OK
> [   33.200742] Testing event machine_suspend: OK
> [   33.221190] Testing event cpu_frequency: OK
> [   33.240984] Testing event pstate_sample: OK
> [   33.260835] Testing event cpu_idle: OK
> [   33.280715] Testing event user_exit: OK
> [   33.300960] Testing event user_enter: OK
> [   33.320697] Testing event mm_filemap_add_to_page_cache: OK
> [   33.340845] Testing event mm_filemap_delete_from_page_cache: OK
> [   33.360693] Testing event oom_score_adj_update: OK
> [   33.381332] Testing event mm_lru_activate: OK
> [   33.400510] Testing event mm_lru_insertion: OK
> [   33.420815] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   33.440470] Testing event mm_vmscan_writepage: OK
> [   33.460720] Testing event mm_vmscan_memcg_isolate: OK
> [   33.480703] Testing event mm_vmscan_lru_isolate: OK
> [   33.500582] Testing event mm_shrink_slab_end: OK
> [   33.520430] Testing event mm_shrink_slab_start: OK
> [   33.540506] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   33.560571] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   33.580906] Testing event mm_vmscan_direct_reclaim_end: OK
> [   33.600793] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   33.620522] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   33.640595] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   33.660683] Testing event mm_vmscan_wakeup_kswapd: OK
> [   33.680470] Testing event mm_vmscan_kswapd_wake: OK
> [   33.700711] Testing event mm_vmscan_kswapd_sleep: OK
> [   33.720670] Testing event mm_page_alloc_extfrag: OK
> [   33.740919] Testing event mm_page_pcpu_drain: OK
> [   33.760641] Testing event mm_page_alloc_zone_locked: OK
> [   33.780728] Testing event mm_page_alloc: OK
> [   33.800657] Testing event mm_page_free_batched: OK
> [   33.820751] Testing event mm_page_free: OK
> [   33.840671] Testing event kmem_cache_free: OK
> [   33.860949] Testing event kfree: OK
> [   33.880678] Testing event kmem_cache_alloc_node: OK
> [   33.900845] Testing event kmalloc_node: OK
> [   33.920470] Testing event kmem_cache_alloc: OK
> [   33.940910] Testing event kmalloc: OK
> [   33.960501] Testing event mm_compaction_end: OK
> [   33.980808] Testing event mm_compaction_begin: OK
> [   34.000615] Testing event mm_compaction_migratepages: OK
> [   34.020805] Testing event mm_compaction_isolate_freepages: OK
> [   34.041082] Testing event mm_compaction_isolate_migratepages: OK
> [   34.060519] Testing event mm_numa_migrate_ratelimit: OK
> [   34.080510] Testing event mm_migrate_pages: OK
> [   34.100713] Testing event writeback_single_inode: OK
> [   34.120790] Testing event writeback_single_inode_start: OK
> [   34.140843] Testing event writeback_wait_iff_congested: OK
> [   34.160770] Testing event writeback_congestion_wait: OK
> [   34.181009] Testing event writeback_sb_inodes_requeue: OK
> [   34.200706] Testing event balance_dirty_pages: OK
> [   34.220739] Testing event bdi_dirty_ratelimit: OK
> [   34.240460] Testing event global_dirty_state: OK
> [   34.260537] Testing event writeback_queue_io: OK
> [   34.280376] Testing event wbc_writepage: OK
> [   34.300600] Testing event writeback_bdi_unregister: OK
> [   34.320473] Testing event writeback_bdi_register: OK
> [   34.340757] Testing event writeback_wake_background: OK
> [   34.360437] Testing event writeback_nowork: OK
> [   34.380637] Testing event writeback_pages_written: OK
> [   34.400505] Testing event writeback_wait: OK
> [   34.420536] Testing event writeback_written: OK
> [   34.440415] Testing event writeback_start: OK
> [   34.460459] Testing event writeback_exec: OK
> [   34.480429] Testing event writeback_queue: OK
> [   34.500766] Testing event writeback_write_inode: OK
> [   34.520646] Testing event writeback_write_inode_start: OK
> [   34.540560] Testing event writeback_dirty_inode: OK
> [   34.560714] Testing event writeback_dirty_inode_start: OK
> [   34.580728] Testing event writeback_dirty_page: OK
> [   34.600631] Testing event jbd2_lock_buffer_stall: OK
> [   34.622216] Testing event jbd2_write_superblock: OK
> [   34.640514] Testing event jbd2_update_log_tail: OK
> [   34.660513] Testing event jbd2_checkpoint_stats: OK
> [   34.680357] Testing event jbd2_run_stats: OK
> [   34.700559] Testing event jbd2_handle_stats: OK
> [   34.720428] Testing event jbd2_handle_extend: OK
> [   34.740638] Testing event jbd2_handle_start: OK
> [   34.760460] Testing event jbd2_submit_inode_data: OK
> [   34.780561] Testing event jbd2_end_commit: OK
> [   34.800428] Testing event jbd2_drop_transaction: OK
> [   34.820616] Testing event jbd2_commit_logging: OK
> [   34.840452] Testing event jbd2_commit_flushing: OK
> [   34.860627] Testing event jbd2_commit_locking: OK
> [   34.880438] Testing event jbd2_start_commit: OK
> [   34.900757] Testing event jbd2_checkpoint: OK
> [   34.923516] Testing event xfs_discard_busy: OK
> [   34.940822] Testing event xfs_discard_exclude: OK
> [   34.960549] Testing event xfs_discard_toosmall: OK
> [   34.980523] Testing event xfs_discard_extent: OK
> [   35.000485] Testing event xfs_log_recover_inode_skip: OK
> [   35.020429] Testing event xfs_log_recover_inode_cancel: OK
> [   35.040744] Testing event xfs_log_recover_inode_recover: OK
> [   35.060528] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   35.080498] Testing event xfs_log_recover_buf_reg_buf: OK
> [   35.100789] Testing event xfs_log_recover_buf_inode_buf: OK
> [   35.120547] Testing event xfs_log_recover_buf_recover: OK
> [   35.140580] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   35.160539] Testing event xfs_log_recover_buf_cancel_add: OK
> [   35.180546] Testing event xfs_log_recover_buf_cancel: OK
> [   35.200536] Testing event xfs_log_recover_buf_not_cancel: OK
> [   35.220570] Testing event xfs_log_recover_item_recover: OK
> [   35.240499] Testing event xfs_log_recover_item_reorder_tail: OK
> [   35.260523] Testing event xfs_log_recover_item_reorder_head: OK
> [   35.280486] Testing event xfs_log_recover_item_add_cont: OK
> [   35.300546] Testing event xfs_log_recover_item_add: OK
> [   35.320643] Testing event xfs_swap_extent_after: OK
> [   35.340638] Testing event xfs_swap_extent_before: OK
> [   35.360665] Testing event xfs_dir2_leafn_moveents: OK
> [   35.380577] Testing event xfs_dir2_shrink_inode: OK
> [   35.400626] Testing event xfs_dir2_grow_inode: OK
> [   35.420628] Testing event xfs_dir2_leafn_remove: OK
> [   35.440794] Testing event xfs_dir2_leafn_add: OK
> [   35.460642] Testing event xfs_da_path_shift: OK
> [   35.480523] Testing event xfs_da_fixhashpath: OK
> [   35.500568] Testing event xfs_da_shrink_inode: OK
> [   35.520680] Testing event xfs_da_grow_inode: OK
> [   35.540557] Testing event xfs_da_swap_lastblock: OK
> [   35.560818] Testing event xfs_da_node_toosmall: OK
> [   35.580844] Testing event xfs_da_node_unbalance: OK
> [   35.600896] Testing event xfs_da_node_rebalance: OK
> [   35.620910] Testing event xfs_da_node_remove: OK
> [   35.640574] Testing event xfs_da_node_split: OK
> [   35.660888] Testing event xfs_da_node_create: OK
> [   35.681253] Testing event xfs_da_node_add: OK
> [   35.700905] Testing event xfs_da_root_join: OK
> [   35.720792] Testing event xfs_da_root_split: OK
> [   35.740776] Testing event xfs_da_unlink_forward: OK
> [   35.760789] Testing event xfs_da_unlink_back: OK
> [   35.780801] Testing event xfs_da_link_after: OK
> [   35.800751] Testing event xfs_da_link_before: OK
> [   35.820796] Testing event xfs_da_join: OK
> [   35.840858] Testing event xfs_da_split: OK
> [   35.860800] Testing event xfs_attr_rmtval_remove: OK
> [   35.880783] Testing event xfs_attr_rmtval_set: OK
> [   35.900814] Testing event xfs_attr_rmtval_get: OK
> [   35.920849] Testing event xfs_attr_refillstate: OK
> [   35.940852] Testing event xfs_attr_fillstate: OK
> [   35.960749] Testing event xfs_attr_node_removename: OK
> [   35.980758] Testing event xfs_attr_node_replace: OK
> [   36.000760] Testing event xfs_attr_node_lookup: OK
> [   36.020784] Testing event xfs_attr_node_get: OK
> [   36.041197] Testing event xfs_attr_node_addname: OK
> [   36.060569] Testing event xfs_attr_leaf_toosmall: OK
> [   36.080829] Testing event xfs_attr_leaf_unbalance: OK
> [   36.100742] Testing event xfs_attr_leaf_rebalance: OK
> [   36.120821] Testing event xfs_attr_leaf_to_node: OK
> [   36.140833] Testing event xfs_attr_leaf_to_sf: OK
> [   36.160798] Testing event xfs_attr_leaf_flipflags: OK
> [   36.180544] Testing event xfs_attr_leaf_setflag: OK
> [   36.200637] Testing event xfs_attr_leaf_clearflag: OK
> [   36.220530] Testing event xfs_attr_leaf_split_after: OK
> [   36.240531] Testing event xfs_attr_leaf_split_before: OK
> [   36.260422] Testing event xfs_attr_leaf_split: OK
> [   36.280455] Testing event xfs_attr_leaf_removename: OK
> [   36.300521] Testing event xfs_attr_leaf_remove: OK
> [   36.320858] Testing event xfs_attr_leaf_replace: OK
> [   36.340806] Testing event xfs_attr_leaf_lookup: OK
> [   36.360878] Testing event xfs_attr_leaf_get: OK
> [   36.380852] Testing event xfs_attr_leaf_compact: OK
> [   36.400835] Testing event xfs_attr_leaf_create: OK
> [   36.420495] Testing event xfs_attr_leaf_addname: OK
> [   36.440510] Testing event xfs_attr_leaf_add_work: OK
> [   36.460547] Testing event xfs_attr_leaf_add_new: OK
> [   36.480578] Testing event xfs_attr_leaf_add_old: OK
> [   36.500527] Testing event xfs_attr_leaf_add: OK
> [   36.520486] Testing event xfs_attr_sf_to_leaf: OK
> [   36.540512] Testing event xfs_attr_sf_removename: OK
> [   36.560456] Testing event xfs_attr_sf_remove: OK
> [   36.580463] Testing event xfs_attr_sf_lookup: OK
> [   36.600443] Testing event xfs_attr_sf_create: OK
> [   36.620429] Testing event xfs_attr_sf_addname: OK
> [   36.640503] Testing event xfs_attr_sf_add: OK
> [   36.660441] Testing event xfs_dir2_node_to_leaf: OK
> [   36.680492] Testing event xfs_dir2_node_removename: OK
> [   36.700494] Testing event xfs_dir2_node_replace: OK
> [   36.720519] Testing event xfs_dir2_node_lookup: OK
> [   36.740439] Testing event xfs_dir2_node_addname: OK
> [   36.760439] Testing event xfs_dir2_leaf_to_node: OK
> [   36.780423] Testing event xfs_dir2_leaf_to_block: OK
> [   36.800458] Testing event xfs_dir2_leaf_removename: OK
> [   36.820431] Testing event xfs_dir2_leaf_replace: OK
> [   36.840474] Testing event xfs_dir2_leaf_lookup: OK
> [   36.860472] Testing event xfs_dir2_leaf_addname: OK
> [   36.880490] Testing event xfs_dir2_block_to_leaf: OK
> [   36.900548] Testing event xfs_dir2_block_to_sf: OK
> [   36.920505] Testing event xfs_dir2_block_removename: OK
> [   36.940463] Testing event xfs_dir2_block_replace: OK
> [   36.960430] Testing event xfs_dir2_block_lookup: OK
> [   36.980582] Testing event xfs_dir2_block_addname: OK
> [   37.000571] Testing event xfs_dir2_sf_to_block: OK
> [   37.020509] Testing event xfs_dir2_sf_toino8: OK
> [   37.040872] Testing event xfs_dir2_sf_toino4: OK
> [   37.060808] Testing event xfs_dir2_sf_removename: OK
> [   37.080572] Testing event xfs_dir2_sf_replace: OK
> [   37.100660] Testing event xfs_dir2_sf_lookup: OK
> [   37.120643] Testing event xfs_dir2_sf_create: OK
> [   37.140824] Testing event xfs_dir2_sf_addname: OK
> [   37.160864] Testing event xfs_alloc_vextent_allfailed: OK
> [   37.180901] Testing event xfs_alloc_vextent_loopfailed: OK
> [   37.200867] Testing event xfs_alloc_vextent_noagbp: OK
> [   37.221047] Testing event xfs_alloc_vextent_nofix: OK
> [   37.240820] Testing event xfs_alloc_vextent_badargs: OK
> [   37.260867] Testing event xfs_alloc_small_error: OK
> [   37.280656] Testing event xfs_alloc_small_done: OK
> [   37.300761] Testing event xfs_alloc_small_notenough: OK
> [   37.320743] Testing event xfs_alloc_small_freelist: OK
> [   37.340693] Testing event xfs_alloc_size_busy: OK
> [   37.360918] Testing event xfs_alloc_size_error: OK
> [   37.380615] Testing event xfs_alloc_size_done: OK
> [   37.400875] Testing event xfs_alloc_size_nominleft: OK
> [   37.420737] Testing event xfs_alloc_size_noentry: OK
> [   37.440691] Testing event xfs_alloc_size_neither: OK
> [   37.460483] Testing event xfs_alloc_near_busy: OK
> [   37.480805] Testing event xfs_alloc_near_noentry: OK
> [   37.500979] Testing event xfs_alloc_near_error: OK
> [   37.520870] Testing event xfs_alloc_near_lesser: OK
> [   37.541269] Testing event xfs_alloc_near_greater: OK
> [   37.561117] Testing event xfs_alloc_near_first: OK
> [   37.581382] Testing event xfs_alloc_near_nominleft: OK
> [   37.601425] Testing event xfs_alloc_exact_error: OK
> [   37.621211] Testing event xfs_alloc_exact_notfound: OK
> [   37.641104] Testing event xfs_alloc_exact_done: OK
> [   37.661017] Testing event xfs_free_extent: OK
> [   37.680779] Testing event xfs_agf: OK
> [   37.701214] Testing event xfs_trans_commit_lsn: OK
> [   37.721045] Testing event xfs_extent_busy_trim: OK
> [   37.740713] Testing event xfs_extent_busy_clear: OK
> [   37.760523] Testing event xfs_extent_busy_reuse: OK
> [   37.780934] Testing event xfs_extent_busy_force: OK
> [   37.801126] Testing event xfs_extent_busy_enomem: OK
> [   37.821098] Testing event xfs_extent_busy: OK
> [   37.841174] Testing event xfs_bunmap: OK
> [   37.861258] Testing event xfs_pagecache_inval: OK
> [   37.881188] Testing event xfs_itruncate_extents_end: OK
> [   37.902687] Testing event xfs_itruncate_extents_start: OK
> [   37.920890] Testing event xfs_setfilesize: OK
> [   37.941052] Testing event xfs_get_blocks_notfound: OK
> [   37.960667] Testing event xfs_unwritten_convert: OK
> [   37.980693] Testing event xfs_delalloc_enospc: OK
> [   38.000724] Testing event xfs_get_blocks_alloc: OK
> [   38.020949] Testing event xfs_get_blocks_found: OK
> [   38.040918] Testing event xfs_map_blocks_alloc: OK
> [   38.060848] Testing event xfs_map_blocks_found: OK
> [   38.080659] Testing event xfs_invalidatepage: OK
> [   38.100940] Testing event xfs_releasepage: OK
> [   38.120643] Testing event xfs_writepage: OK
> [   38.140941] Testing event xfs_file_splice_write: OK
> [   38.160649] Testing event xfs_file_splice_read: OK
> [   38.181065] Testing event xfs_file_direct_write: OK
> [   38.200732] Testing event xfs_file_buffered_write: OK
> [   38.220715] Testing event xfs_file_read: OK
> [   38.240534] Testing event xfs_log_assign_tail_lsn: OK
> [   38.260626] Testing event xfs_ail_delete: OK
> [   38.280625] Testing event xfs_ail_move: OK
> [   38.300959] Testing event xfs_ail_insert: OK
> [   38.320891] Testing event xfs_ail_flushing: OK
> [   38.341158] Testing event xfs_ail_locked: OK
> [   38.361056] Testing event xfs_ail_pinned: OK
> [   38.380954] Testing event xfs_ail_push: OK
> [   38.400714] Testing event xfs_log_force: OK
> [   38.421073] Testing event xfs_log_ungrant_sub: OK
> [   38.441175] Testing event xfs_log_ungrant_exit: OK
> [   38.460993] Testing event xfs_log_ungrant_enter: OK
> [   38.480763] Testing event xfs_log_regrant_reserve_sub: OK
> [   38.501228] Testing event xfs_log_regrant_reserve_exit: OK
> [   38.521132] Testing event xfs_log_regrant_reserve_enter: OK
> [   38.541162] Testing event xfs_log_regrant_exit: OK
> [   38.560835] Testing event xfs_log_regrant: OK
> [   38.581209] Testing event xfs_log_reserve_exit: OK
> [   38.601158] Testing event xfs_log_reserve: OK
> [   38.620977] Testing event xfs_log_grant_wake_up: OK
> [   38.640805] Testing event xfs_log_grant_wake: OK
> [   38.661177] Testing event xfs_log_grant_sleep: OK
> [   38.681083] Testing event xfs_log_umount_write: OK
> [   38.701070] Testing event xfs_log_done_perm: OK
> [   38.720846] Testing event xfs_log_done_nonperm: OK
> [   38.741118] Testing event xfs_dqflush_done: OK
> [   38.761142] Testing event xfs_dqflush_force: OK
> [   38.781094] Testing event xfs_dqflush: OK
> [   38.800827] Testing event xfs_dqrele: OK
> [   38.821314] Testing event xfs_dqput_free: OK
> [   38.841164] Testing event xfs_dqput_wait: OK
> [   38.861073] Testing event xfs_dqput: OK
> [   38.880834] Testing event xfs_dqget_dup: OK
> [   38.901166] Testing event xfs_dqget_freeing: OK
> [   38.920848] Testing event xfs_dqget_miss: OK
> [   38.940606] Testing event xfs_dqget_hit: OK
> [   38.960694] Testing event xfs_dqread_fail: OK
> [   38.980801] Testing event xfs_dqread: OK
> [   39.000684] Testing event xfs_dqtobp_read: OK
> [   39.020622] Testing event xfs_dqalloc: OK
> [   39.040646] Testing event xfs_dqattach_get: OK
> [   39.060805] Testing event xfs_dqattach_found: OK
> [   39.080603] Testing event xfs_dqreclaim_done: OK
> [   39.100675] Testing event xfs_dqreclaim_busy: OK
> [   39.120579] Testing event xfs_dqreclaim_dirty: OK
> [   39.140878] Testing event xfs_dqreclaim_want: OK
> [   39.160599] Testing event xfs_dqadjust: OK
> [   39.180707] Testing event xfs_rename: OK
> [   39.200994] Testing event xfs_symlink: OK
> [   39.221202] Testing event xfs_create: OK
> [   39.241239] Testing event xfs_lookup: OK
> [   39.260732] Testing event xfs_link: OK
> [   39.281194] Testing event xfs_remove: OK
> [   39.301257] Testing event xfs_inode_unpin_nowait: OK
> [   39.321081] Testing event xfs_inode_unpin: OK
> [   39.341107] Testing event xfs_inode_pin: OK
> [   39.361068] Testing event xfs_irele: OK
> [   39.381071] Testing event xfs_ihold: OK
> [   39.400891] Testing event xfs_iomap_prealloc_size: OK
> [   39.420715] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   39.440975] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   39.460701] Testing event xfs_inode_set_eofblocks_tag: OK
> [   39.480724] Testing event xfs_dquot_dqdetach: OK
> [   39.500552] Testing event xfs_dquot_dqalloc: OK
> [   39.520922] Testing event xfs_update_time: OK
> [   39.541067] Testing event xfs_evict_inode: OK
> [   39.561369] Testing event xfs_destroy_inode: OK
> [   39.581147] Testing event xfs_file_fsync: OK
> [   39.601143] Testing event xfs_dir_fsync: OK
> [   39.621798] Testing event xfs_ioctl_setattr: OK
> [   39.641096] Testing event xfs_file_compat_ioctl: OK
> [   39.661061] Testing event xfs_file_ioctl: OK
> [   39.680646] Testing event xfs_vm_bmap: OK
> [   39.700793] Testing event xfs_readdir: OK
> [   39.721058] Testing event xfs_collapse_file_space: OK
> [   39.740818] Testing event xfs_free_file_space: OK
> [   39.760675] Testing event xfs_alloc_file_space: OK
> [   39.780817] Testing event xfs_inactive_symlink: OK
> [   39.800585] Testing event xfs_readlink: OK
> [   39.820711] Testing event xfs_setattr: OK
> [   39.840547] Testing event xfs_getattr: OK
> [   39.860885] Testing event xfs_iget_miss: OK
> [   39.881225] Testing event xfs_iget_hit: OK
> [   39.900697] Testing event xfs_iget_reclaim_fail: OK
> [   39.920758] Testing event xfs_iget_reclaim: OK
> [   39.940921] Testing event xfs_iget_skip: OK
> [   39.960918] Testing event xfs_iunlock: OK
> [   39.981039] Testing event xfs_ilock_demote: OK
> [   40.001098] Testing event xfs_ilock_nowait: OK
> [   40.020828] Testing event xfs_ilock: OK
> [   40.040882] Testing event xfs_trans_buf_ordered: OK
> [   40.060994] Testing event xfs_trans_binval: OK
> [   40.081117] Testing event xfs_trans_bhold_release: OK
> [   40.100709] Testing event xfs_trans_bhold: OK
> [   40.120841] Testing event xfs_trans_bjoin: OK
> [   40.140873] Testing event xfs_trans_brelse: OK
> [   40.163847] Testing event xfs_trans_log_buf: OK
> [   40.180827] Testing event xfs_trans_read_buf_recur: OK
> [   40.200782] Testing event xfs_trans_read_buf: OK
> [   40.221195] Testing event xfs_trans_getsb_recur: OK
> [   40.240700] Testing event xfs_trans_getsb: OK
> [   40.261070] Testing event xfs_trans_get_buf_recur: OK
> [   40.280915] Testing event xfs_trans_get_buf: OK
> [   40.300732] Testing event xfs_buf_item_push: OK
> [   40.320563] Testing event xfs_buf_item_committed: OK
> [   40.341086] Testing event xfs_buf_item_unlock_stale: OK
> [   40.361352] Testing event xfs_buf_item_unlock: OK
> [   40.381169] Testing event xfs_buf_item_unpin_stale: OK
> [   40.401147] Testing event xfs_buf_item_unpin: OK
> [   40.421021] Testing event xfs_buf_item_pin: OK
> [   40.440597] Testing event xfs_buf_item_ordered: OK
> [   40.461079] Testing event xfs_buf_item_format_stale: OK
> [   40.480999] Testing event xfs_buf_item_format_ordered: OK
> [   40.500796] Testing event xfs_buf_item_format: OK
> [   40.521125] Testing event xfs_buf_item_size_stale: OK
> [   40.541115] Testing event xfs_buf_item_size_ordered: OK
> [   40.561091] Testing event xfs_buf_item_size: OK
> [   40.581122] Testing event xfs_buf_ioerror: OK
> [   40.601124] Testing event xfs_buf_read: OK
> [   40.621075] Testing event xfs_buf_get: OK
> [   40.641071] Testing event xfs_buf_find: OK
> [   40.661093] Testing event xfs_inode_item_push: OK
> [   40.681097] Testing event xfs_reset_dqcounts: OK
> [   40.701138] Testing event xfs_da_btree_corrupt: OK
> [   40.721107] Testing event xfs_btree_corrupt: OK
> [   40.741082] Testing event xfs_trans_read_buf_shut: OK
> [   40.761130] Testing event xfs_trans_read_buf_io: OK
> [   40.781112] Testing event xfs_buf_wait_buftarg: OK
> [   40.801124] Testing event xfs_buf_error_relse: OK
> [   40.821111] Testing event xfs_buf_item_iodone_async: OK
> [   40.841113] Testing event xfs_buf_item_iodone: OK
> [   40.861096] Testing event xfs_buf_item_relse: OK
> [   40.881129] Testing event xfs_bdstrat_shut: OK
> [   40.901121] Testing event xfs_buf_get_uncached: OK
> [   40.921115] Testing event xfs_buf_delwri_split: OK
> [   40.941176] Testing event xfs_buf_delwri_queued: OK
> [   40.961085] Testing event xfs_buf_delwri_queue: OK
> [   40.981028] Testing event xfs_buf_iowait_done: OK
> [   41.000872] Testing event xfs_buf_iowait: OK
> [   41.021148] Testing event xfs_buf_unlock: OK
> [   41.041177] Testing event xfs_buf_trylock: OK
> [   41.061019] Testing event xfs_buf_lock_done: OK
> [   41.080769] Testing event xfs_buf_lock: OK
> [   41.101218] Testing event xfs_buf_bawrite: OK
> [   41.120689] Testing event xfs_buf_iorequest: OK
> [   41.140836] Testing event xfs_buf_iodone: OK
> [   41.160656] Testing event xfs_buf_rele: OK
> [   41.180956] Testing event xfs_buf_hold: OK
> [   41.200881] Testing event xfs_buf_free: OK
> [   41.220898] Testing event xfs_buf_init: OK
> [   41.241034] Testing event xfs_extlist: OK
> [   41.270779] Testing event xfs_bmap_post_update: OK
> [   41.300778] Testing event xfs_bmap_pre_update: OK
> [   41.330721] Testing event xfs_iext_remove: OK
> [   41.360887] Testing event xfs_iext_insert: OK
> [   41.390947] Testing event xfs_attr_list_node_descend: OK
> [   41.420890] Testing event xfs_ialloc_read_agi: OK
> [   41.450717] Testing event xfs_read_agi: OK
> [   41.481227] Testing event xfs_alloc_read_agf: OK
> [   41.510904] Testing event xfs_read_agf: OK
> [   41.541130] Testing event xfs_perag_clear_eofblocks: OK
> [   41.570874] Testing event xfs_perag_set_eofblocks: OK
> [   41.601107] Testing event xfs_perag_clear_reclaim: OK
> [   41.630944] Testing event xfs_perag_set_reclaim: OK
> [   41.661087] Testing event xfs_perag_put: OK
> [   41.690891] Testing event xfs_perag_get_tag: OK
> [   41.720940] Testing event xfs_perag_get: OK
> [   41.750967] Testing event xfs_attr_node_list: OK
> [   41.781036] Testing event xfs_attr_leaf_list: OK
> [   41.810886] Testing event xfs_attr_list_notfound: OK
> [   41.841073] Testing event xfs_attr_list_wrong_blk: OK
> [   41.870925] Testing event xfs_attr_list_add: OK
> [   41.901108] Testing event xfs_attr_list_full: OK
> [   41.930975] Testing event xfs_attr_list_leaf_end: OK
> [   41.960822] Testing event xfs_attr_list_leaf: OK
> [   41.990634] Testing event xfs_attr_list_sf_all: OK
> [   42.020793] Testing event xfs_attr_list_sf: OK
> [   42.050571] Testing event ocfs2_remove_block_from_cache: OK
> [   42.080784] Testing event ocfs2_remove_metadata_tree: OK
> [   42.110575] Testing event ocfs2_remove_metadata_array: OK
> [   42.140860] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   42.170572] Testing event ocfs2_set_buffer_uptodate: OK
> [   42.200815] Testing event ocfs2_expand_cache: OK
> [   42.230624] Testing event ocfs2_insert_cache_tree: OK
> [   42.260836] Testing event ocfs2_append_cache_array: OK
> [   42.290610] Testing event ocfs2_buffer_cached_end: OK
> [   42.320789] Testing event ocfs2_buffer_cached_begin: OK
> [   42.350578] Testing event ocfs2_metadata_cache_purge: OK
> [   42.380800] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   42.410615] Testing event ocfs2_read_blocks_begin: OK
> [   42.440822] Testing event ocfs2_write_block: OK
> [   42.470564] Testing event ocfs2_read_blocks_end: OK
> [   42.500800] Testing event ocfs2_read_blocks_bh: OK
> [   42.530577] Testing event ocfs2_read_blocks_from_disk: OK
> [   42.560701] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   42.590582] Testing event ocfs2_read_blocks_sync: OK
> [   42.620793] Testing event ocfs2_wait_on_mount: OK
> [   42.650636] Testing event ocfs2_recover_orphans_iput: OK
> [   42.680848] Testing event ocfs2_recover_orphans: OK
> [   42.710567] Testing event ocfs2_orphan_filldir: OK
> [   42.740847] Testing event ocfs2_queue_orphan_scan_end: OK
> [   42.770568] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   42.800805] Testing event ocfs2_mark_dead_nodes: OK
> [   42.830505] Testing event ocfs2_recover_node_skip: OK
> [   42.860786] Testing event ocfs2_recover_node: OK
> [   42.890635] Testing event ocfs2_replay_journal_skip: OK
> [   42.920774] Testing event ocfs2_replay_journal_lock_err: OK
> [   42.950581] Testing event ocfs2_replay_journal_recovered: OK
> [   42.980843] Testing event ocfs2_recovery_thread: OK
> [   43.010574] Testing event ocfs2_recovery_thread_end: OK
> [   43.041140] Testing event ocfs2_recovery_thread_node: OK
> [   43.070624] Testing event ocfs2_complete_recovery_slot: OK
> [   43.100828] Testing event ocfs2_complete_recovery_end: OK
> [   43.130579] Testing event ocfs2_complete_recovery: OK
> [   43.160684] Testing event ocfs2_journal_shutdown_wait: OK
> [   43.190601] Testing event ocfs2_journal_shutdown: OK
> [   43.220779] Testing event ocfs2_journal_init_maxlen: OK
> [   43.250643] Testing event ocfs2_journal_init: OK
> [   43.280800] Testing event ocfs2_journal_dirty: OK
> [   43.310609] Testing event ocfs2_journal_access: OK
> [   43.340817] Testing event ocfs2_allocate_extend_trans: OK
> [   43.370605] Testing event ocfs2_extend_trans_restart: OK
> [   43.400829] Testing event ocfs2_extend_trans: OK
> [   43.430597] Testing event ocfs2_commit_cache_end: OK
> [   43.460699] Testing event ocfs2_commit_cache_begin: OK
> [   43.490596] Testing event ocfs2_encode_fh_type: OK
> [   43.520789] Testing event ocfs2_encode_fh_parent: OK
> [   43.550598] Testing event ocfs2_encode_fh_self: OK
> [   43.580876] Testing event ocfs2_encode_fh_begin: OK
> [   43.610610] Testing event ocfs2_get_parent_end: OK
> [   43.640862] Testing event ocfs2_get_parent: OK
> [   43.670585] Testing event ocfs2_get_dentry_end: OK
> [   43.700851] Testing event ocfs2_get_dentry_generation: OK
> [   43.730611] Testing event ocfs2_get_dentry_stale: OK
> [   43.761515] Testing event ocfs2_get_dentry_test_bit: OK
> [   43.790583] Testing event ocfs2_get_dentry_begin: OK
> [   43.820780] Testing event ocfs2_dentry_attach_lock_found: OK
> [   43.850566] Testing event ocfs2_dentry_attach_lock: OK
> [   43.880701] Testing event ocfs2_find_local_alias: OK
> [   43.910620] Testing event ocfs2_dentry_revalidate_ret: OK
> [   43.940816] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   43.970654] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   44.000795] Testing event ocfs2_dentry_revalidate_delete: OK
> [   44.030612] Testing event ocfs2_dentry_revalidate_negative: OK
> [   44.060822] Testing event ocfs2_dentry_revalidate: OK
> [   44.090599] Testing event ocfs2_orphan_del: OK
> [   44.120815] Testing event ocfs2_orphan_add_end: OK
> [   44.150619] Testing event ocfs2_orphan_add_begin: OK
> [   44.180800] Testing event ocfs2_blkno_stringify: OK
> [   44.210665] Testing event ocfs2_symlink_begin: OK
> [   44.240803] Testing event ocfs2_create_symlink_data: OK
> [   44.270584] Testing event ocfs2_rename_over_existing: OK
> [   44.300790] Testing event ocfs2_rename_disagree: OK
> [   44.330522] Testing event ocfs2_rename_target_exists: OK
> [   44.360784] Testing event ocfs2_rename: OK
> [   44.390580] Testing event ocfs2_double_lock_end: OK
> [   44.420728] Testing event ocfs2_double_lock: OK
> [   44.450577] Testing event ocfs2_unlink_noent: OK
> [   44.480791] Testing event ocfs2_link: OK
> [   44.511197] Testing event ocfs2_mknod: OK
> [   44.540874] Testing event ocfs2_lookup_ret: OK
> [   44.570627] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   44.600782] Testing event ocfs2_symlink_create: OK
> [   44.630605] Testing event ocfs2_unlink: OK
> [   44.660713] Testing event ocfs2_create: OK
> [   44.690606] Testing event ocfs2_mkdir: OK
> [   44.720720] Testing event ocfs2_lookup: OK
> [   44.750622] Testing event ocfs2_prepare_dir_for_insert: OK
> [   44.780834] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   44.810606] Testing event ocfs2_dx_dir_rebalance: OK
> [   44.840780] Testing event ocfs2_extend_dir: OK
> [   44.870630] Testing event ocfs2_dx_dir_index_root_block: OK
> [   44.900795] Testing event ocfs2_dx_dir_format_cluster: OK
> [   44.930663] Testing event ocfs2_dx_dir_attach_index: OK
> [   44.960839] Testing event ocfs2_check_dir_for_entry: OK
> [   44.990608] Testing event ocfs2_find_files_on_disk: OK
> [   45.020748] Testing event ocfs2_readdir: OK
> [   45.051032] Testing event ocfs2_delete_entry_dx: OK
> [   45.080775] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   45.110631] Testing event ocfs2_dx_dir_search: OK
> [   45.140792] Testing event ocfs2_find_entry_el: OK
> [   45.170600] Testing event ocfs2_validate_dir_block: OK
> [   45.200821] Testing event ocfs2_search_dirblock: OK
> [   45.230560] Testing event ocfs2_mark_dquot_dirty: OK
> [   45.260782] Testing event ocfs2_acquire_dquot: OK
> [   45.290614] Testing event ocfs2_release_dquot: OK
> [   45.320774] Testing event ocfs2_write_dquot: OK
> [   45.350579] Testing event ocfs2_sync_dquot_helper: OK
> [   45.380826] Testing event ocfs2_sync_dquot: OK
> [   45.410565] Testing event ocfs2_validate_quota_block: OK
> [   45.440781] Testing event olq_set_dquot: OK
> [   45.470668] Testing event ocfs2_finish_quota_recovery: OK
> [   45.500842] Testing event ocfs2_recover_local_quota_file: OK
> [   45.530614] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   45.560730] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   45.590606] Testing event ocfs2_resmap_resv_bits: OK
> [   45.620818] Testing event ocfs2_cannibalize_resv_end: OK
> [   45.650743] Testing event ocfs2_cannibalize_resv_begin: OK
> [   45.680883] Testing event ocfs2_resv_find_window_next: OK
> [   45.710691] Testing event ocfs2_resv_find_window_prev: OK
> [   45.740880] Testing event ocfs2_resv_find_window_begin: OK
> [   45.770700] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   45.800898] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   45.830690] Testing event ocfs2_resv_insert: OK
> [   45.860896] Testing event ocfs2_reflink_xattr_rec: OK
> [   45.890695] Testing event ocfs2_reflink_xattr_buckets: OK
> [   45.920885] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   45.950718] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   45.980909] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   46.010702] Testing event ocfs2_create_empty_xattr_block: OK
> [   46.041291] Testing event ocfs2_reflink_xattr_header: OK
> [   46.070619] Testing event ocfs2_rm_xattr_cluster: OK
> [   46.100894] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   46.130711] Testing event ocfs2_add_new_xattr_bucket: OK
> [   46.160998] Testing event ocfs2_extend_xattr_bucket: OK
> [   46.190702] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   46.220949] Testing event ocfs2_add_new_xattr_cluster: OK
> [   46.250709] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   46.280969] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   46.310707] Testing event ocfs2_mv_xattr_buckets: OK
> [   46.340956] Testing event ocfs2_cp_xattr_bucket: OK
> [   46.370605] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   46.401168] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   46.430668] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   46.461140] Testing event ocfs2_defrag_xattr_bucket: OK
> [   46.490686] Testing event ocfs2_xattr_create_index_block: OK
> [   46.528184] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   46.563012] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   46.593256] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   46.621714] Testing event ocfs2_iterate_xattr_bucket: OK
> [   46.650852] Testing event ocfs2_iterate_xattr_buckets: OK
> [   46.680540] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   46.710826] Testing event ocfs2_xattr_index_block_find: OK
> [   46.740551] Testing event ocfs2_xattr_bucket_find: OK
> [   46.770834] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   46.800615] Testing event ocfs2_xattr_extend_allocation: OK
> [   46.830812] Testing event ocfs2_validate_xattr_block: OK
> [   46.860636] Testing event ocfs2_initialize_super: OK
> [   46.890836] Testing event ocfs2_dismount_volume: OK
> [   46.920633] Testing event ocfs2_statfs: OK
> [   46.950806] Testing event ocfs2_put_super: OK
> [   46.980600] Testing event ocfs2_parse_options: OK
> [   47.010720] Testing event ocfs2_fill_super: OK
> [   47.040979] Testing event ocfs2_remount: OK
> [   47.071132] Testing event ocfs2_do_node_down: OK
> [   47.100919] Testing event ocfs2_find_slot: OK
> [   47.131108] Testing event ocfs2_map_slot_buffers_block: OK
> [   47.160890] Testing event ocfs2_map_slot_buffers: OK
> [   47.191087] Testing event ocfs2_refresh_slot_info: OK
> [   47.220569] Testing event ocfs2_read_virt_blocks: OK
> [   47.250693] Testing event ocfs2_mark_inode_dirty: OK
> [   47.280909] Testing event ocfs2_inode_revalidate: OK
> [   47.311097] Testing event ocfs2_drop_inode: OK
> [   47.340550] Testing event ocfs2_clear_inode: OK
> [   47.370682] Testing event ocfs2_delete_inode: OK
> [   47.400564] Testing event ocfs2_cleanup_delete_inode: OK
> [   47.430788] Testing event ocfs2_query_inode_wipe_end: OK
> [   47.460741] Testing event ocfs2_query_inode_wipe_succ: OK
> [   47.490791] Testing event ocfs2_query_inode_wipe_begin: OK
> [   47.520611] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   47.550689] Testing event ocfs2_validate_inode_block: OK
> [   47.580593] Testing event ocfs2_check_orphan_recovery_state: OK
> [   47.610890] Testing event ocfs2_read_locked_inode: OK
> [   47.640676] Testing event ocfs2_populate_inode: OK
> [   47.670865] Testing event ocfs2_find_actor: OK
> [   47.700988] Testing event ocfs2_iget_end: OK
> [   47.730669] Testing event ocfs2_iget5_locked: OK
> [   47.760533] Testing event ocfs2_iget_begin: OK
> [   47.791075] Testing event generic_file_aio_read_ret: OK
> [   47.820679] Testing event ocfs2_prepare_inode_for_write: OK
> [   47.850718] Testing event ocfs2_remove_inode_range: OK
> [   47.880567] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   47.911206] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   47.940469] Testing event ocfs2_zero_partial_clusters: OK
> [   47.970704] Testing event ocfs2_write_remove_suid: OK
> [   48.000704] Testing event ocfs2_setattr: OK
> [   48.031047] Testing event ocfs2_zero_extend: OK
> [   48.060734] Testing event ocfs2_zero_extend_range: OK
> [   48.090768] Testing event ocfs2_write_zero_page: OK
> [   48.120564] Testing event ocfs2_extend_allocation_end: OK
> [   48.151145] Testing event ocfs2_extend_allocation: OK
> [   48.180682] Testing event ocfs2_truncate_file_error: OK
> [   48.211168] Testing event ocfs2_truncate_file: OK
> [   48.240890] Testing event ocfs2_file_aio_read: OK
> [   48.271094] Testing event ocfs2_file_splice_read: OK
> [   48.300898] Testing event ocfs2_file_splice_write: OK
> [   48.331148] Testing event ocfs2_file_aio_write: OK
> [   48.360910] Testing event ocfs2_sync_file: OK
> [   48.391127] Testing event ocfs2_file_release: OK
> [   48.420900] Testing event ocfs2_file_open: OK
> [   48.451182] Testing event ocfs2_fault: OK
> [   48.480937] Testing event ocfs2_write_end_inline: OK
> [   48.512057] Testing event ocfs2_write_begin_nolock: OK
> [   48.540935] Testing event ocfs2_try_to_write_inline_data: OK
> [   48.571168] Testing event ocfs2_bmap: OK
> [   48.600992] Testing event ocfs2_writepage: OK
> [   48.631149] Testing event ocfs2_readpage: OK
> [   48.660960] Testing event ocfs2_get_block_end: OK
> [   48.691149] Testing event ocfs2_get_block: OK
> [   48.720817] Testing event ocfs2_symlink_get_block: OK
> [   48.751174] Testing event ocfs2_refcount_cow_hunk: OK
> [   48.780959] Testing event ocfs2_make_clusters_writable: OK
> [   48.811163] Testing event ocfs2_replace_clusters: OK
> [   48.840938] Testing event ocfs2_clear_ext_refcount: OK
> [   48.871170] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   48.900946] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   48.931177] Testing event ocfs2_lock_refcount_allocators: OK
> [   48.960972] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   48.991177] Testing event ocfs2_add_refcount_flag: OK
> [   49.020977] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   49.051189] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   49.080982] Testing event ocfs2_mark_extent_refcounted: OK
> [   49.111197] Testing event ocfs2_decrease_refcount: OK
> [   49.140953] Testing event ocfs2_decrease_refcount_rec: OK
> [   49.170992] Testing event ocfs2_restore_refcount_block: OK
> [   49.200974] Testing event ocfs2_remove_refcount_extent: OK
> [   49.231211] Testing event ocfs2_increase_refcount_split: OK
> [   49.260980] Testing event ocfs2_increase_refcount_insert: OK
> [   49.294608] Testing event ocfs2_increase_refcount_change: OK
> [   49.330995] Testing event ocfs2_increase_refcount_begin: OK
> [   49.361021] Testing event ocfs2_split_refcount_rec_insert: OK
> [   49.390962] Testing event ocfs2_split_refcount_rec: OK
> [   49.421185] Testing event ocfs2_insert_refcount_rec: OK
> [   49.450978] Testing event ocfs2_new_leaf_refcount_block: OK
> [   49.481180] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   49.510970] Testing event ocfs2_expand_inline_ref_root: OK
> [   49.541170] Testing event ocfs2_change_refcount_rec: OK
> [   49.570959] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   49.601177] Testing event ocfs2_create_refcount_tree: OK
> [   49.630972] Testing event ocfs2_purge_refcount_trees: OK
> [   49.661018] Testing event ocfs2_validate_refcount_block: OK
> [   49.690747] Testing event ocfs2_test_inode_bit: OK
> [   49.721007] Testing event ocfs2_test_suballoc_bit: OK
> [   49.750745] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   49.781183] Testing event ocfs2_free_clusters: OK
> [   49.810801] Testing event ocfs2_free_suballoc_bits: OK
> [   49.841139] Testing event ocfs2_block_group_clear_bits: OK
> [   49.870970] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   49.901161] Testing event ocfs2_claim_suballoc_bits: OK
> [   49.931001] Testing event ocfs2_search_chain_end: OK
> [   49.961189] Testing event ocfs2_search_chain_succ: OK
> [   49.990946] Testing event ocfs2_search_chain_begin: OK
> [   50.021184] Testing event ocfs2_block_group_search_max_block: OK
> [   50.050948] Testing event ocfs2_cluster_group_search_max_block: OK
> [   50.081174] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   50.110941] Testing event ocfs2_relink_block_group: OK
> [   50.141142] Testing event ocfs2_block_group_set_bits: OK
> [   50.170803] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   50.201153] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   50.230924] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   50.261120] Testing event ocfs2_block_group_alloc: OK
> [   50.290934] Testing event ocfs2_block_group_alloc_discontig: OK
> [   50.321141] Testing event ocfs2_block_group_alloc_contig: OK
> [   50.350910] Testing event ocfs2_validate_group_descriptor: OK
> [   50.381126] Testing event ocfs2_group_add: OK
> [   50.410943] Testing event ocfs2_group_extend: OK
> [   50.441141] Testing event ocfs2_update_last_group_and_inode: OK
> [   50.470750] Testing event ocfs2_local_alloc_new_window_result: OK
> [   50.500890] Testing event ocfs2_local_alloc_new_window: OK
> [   50.530645] Testing event ocfs2_sync_local_to_main_free: OK
> [   50.561083] Testing event ocfs2_sync_local_to_main: OK
> [   50.590559] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   50.620699] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   50.650933] Testing event ocfs2_local_alloc_count_bits: OK
> [   50.680792] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   50.710553] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   50.740740] Testing event ocfs2_load_local_alloc: OK
> [   50.770570] Testing event ocfs2_alloc_should_use_local: OK
> [   50.801174] Testing event ocfs2_la_set_sizes: OK
> [   50.831018] Testing event ocfs2_trim_fs: OK
> [   50.861036] Testing event ocfs2_trim_group: OK
> [   50.891000] Testing event ocfs2_trim_extent: OK
> [   50.921178] Testing event ocfs2_cache_block_dealloc: OK
> [   50.950640] Testing event ocfs2_run_deallocs: OK
> [   50.980683] Testing event ocfs2_cache_cluster_dealloc: OK
> [   51.010573] Testing event ocfs2_free_cached_blocks: OK
> [   51.040786] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   51.071003] Testing event ocfs2_truncate_log_recovery_num: OK
> [   51.100732] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   51.130498] Testing event ocfs2_flush_truncate_log: OK
> [   51.160872] Testing event ocfs2_replay_truncate_records: OK
> [   51.190487] Testing event ocfs2_truncate_log_append: OK
> [   51.220562] Testing event ocfs2_mark_extent_written: OK
> [   51.240575] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   51.260579] Testing event ocfs2_rotate_leaf: OK
> [   51.280567] Testing event ocfs2_validate_extent_block: OK
> [   51.300569] Testing event ocfs2_commit_truncate: OK
> [   51.320569] Testing event ocfs2_remove_extent: OK
> [   51.340621] Testing event ocfs2_split_extent: OK
> [   51.360804] Testing event ocfs2_insert_extent: OK
> [   51.380601] Testing event ocfs2_rotate_subtree: OK
> [   51.400677] Testing event ocfs2_grow_tree: OK
> [   51.420840] Testing event ocfs2_complete_edge_insert: OK
> [   51.440739] Testing event ocfs2_num_free_extents: OK
> [   51.460700] Testing event ocfs2_add_clusters_in_btree: OK
> [   51.480723] Testing event ocfs2_insert_extent_start: OK
> [   51.500647] Testing event ocfs2_append_rec_to_path: OK
> [   51.520664] Testing event ocfs2_rotate_tree_right: OK
> [   51.540857] Testing event ocfs2_adjust_rightmost_branch: OK
> [   51.560932] Testing event btrfs_workqueue_destroy: OK
> [   51.580841] Testing event btrfs_workqueue_alloc: OK
> [   51.601488] Testing event btrfs_ordered_sched: OK
> [   51.620670] Testing event btrfs_all_work_done: OK
> [   51.640665] Testing event btrfs_normal_work_done: OK
> [   51.660540] Testing event btrfs_work_sched: OK
> [   51.680827] Testing event btrfs_work_queued: OK
> [   51.701024] Testing event free_extent_state: OK
> [   51.720705] Testing event alloc_extent_state: OK
> [   51.740557] Testing event btrfs_setup_cluster: OK
> [   51.761113] Testing event btrfs_failed_cluster_setup: OK
> [   51.780584] Testing event btrfs_find_cluster: OK
> [   51.800710] Testing event btrfs_reserve_extent_cluster: OK
> [   51.820751] Testing event btrfs_reserve_extent: OK
> [   51.840688] Testing event find_free_extent: OK
> [   51.860947] Testing event btrfs_reserved_extent_free: OK
> [   51.881058] Testing event btrfs_reserved_extent_alloc: OK
> [   51.900784] Testing event btrfs_space_reservation: OK
> [   51.922720] Testing event btrfs_cow_block: OK
> [   51.941055] Testing event btrfs_chunk_free: OK
> [   51.960800] Testing event btrfs_chunk_alloc: OK
> [   51.980726] Testing event run_delayed_ref_head: OK
> [   52.000945] Testing event add_delayed_ref_head: OK
> [   52.020705] Testing event run_delayed_data_ref: OK
> [   52.041142] Testing event add_delayed_data_ref: OK
> [   52.060732] Testing event run_delayed_tree_ref: OK
> [   52.080923] Testing event add_delayed_tree_ref: OK
> [   52.100658] Testing event btrfs_sync_fs: OK
> [   52.120746] Testing event btrfs_sync_file: OK
> [   52.140670] Testing event btrfs_writepage_end_io_hook: OK
> [   52.160959] Testing event __extent_writepage: OK
> [   52.180656] Testing event btrfs_ordered_extent_put: OK
> [   52.200756] Testing event btrfs_ordered_extent_start: OK
> [   52.220706] Testing event btrfs_ordered_extent_remove: OK
> [   52.240950] Testing event btrfs_ordered_extent_add: OK
> [   52.260698] Testing event btrfs_get_extent: OK
> [   52.280764] Testing event btrfs_inode_evict: OK
> [   52.300691] Testing event btrfs_inode_request: OK
> [   52.320945] Testing event btrfs_inode_new: OK
> [   52.340675] Testing event btrfs_transaction_commit: OK
> [   52.360734] Testing event gfs2_rs: OK
> [   52.380673] Testing event gfs2_block_alloc: OK
> [   52.400784] Testing event gfs2_bmap: OK
> [   52.420675] Testing event gfs2_ail_flush: OK
> [   52.440926] Testing event gfs2_log_blocks: OK
> [   52.460653] Testing event gfs2_log_flush: OK
> [   52.480718] Testing event gfs2_pin: OK
> [   52.500666] Testing event gfs2_glock_lock_time: OK
> [   52.521032] Testing event gfs2_glock_queue: OK
> [   52.540698] Testing event gfs2_promote: OK
> [   52.560768] Testing event gfs2_demote_rq: OK
> [   52.580672] Testing event gfs2_glock_put: OK
> [   52.601005] Testing event gfs2_glock_state_change: OK
> [   52.620715] Testing event block_rq_remap: OK
> [   52.640775] Testing event block_bio_remap: OK
> [   52.660692] Testing event block_split: OK
> [   52.680943] Testing event block_unplug: OK
> [   52.700693] Testing event block_plug: OK
> [   52.720772] Testing event block_sleeprq: OK
> [   52.740686] Testing event block_getrq: OK
> [   52.760757] Testing event block_bio_queue: OK
> [   52.780697] Testing event block_bio_frontmerge: OK
> [   52.800962] Testing event block_bio_backmerge: OK
> [   52.820686] Testing event block_bio_complete: OK
> [   52.840975] Testing event block_bio_bounce: OK
> [   52.860690] Testing event block_rq_issue: OK
> [   52.880972] Testing event block_rq_insert: OK
> [   52.900697] Testing event block_rq_complete: OK
> [   52.920623] Testing event block_rq_requeue: OK
> [   52.940462] Testing event block_rq_abort: OK
> [   52.960631] Testing event block_dirty_buffer: OK
> [   52.980415] Testing event block_touch_buffer: OK
> [   53.000677] Testing event swiotlb_bounced: OK
> [   53.020501] Testing event gpio_value: OK
> [   53.040854] Testing event gpio_direction: OK
> [   53.060521] Testing event aer_event: OK
> [   53.080708] Testing event regulator_set_voltage_complete: OK
> [   53.100743] Testing event regulator_set_voltage: OK
> [   53.120562] Testing event regulator_disable_complete: OK
> [   53.140538] Testing event regulator_disable: OK
> [   53.160825] Testing event regulator_enable_complete: OK
> [   53.181000] Testing event regulator_enable_delay: OK
> [   53.200675] Testing event regulator_enable: OK
> [   53.220433] Testing event urandom_read: OK
> [   53.240608] Testing event random_read: OK
> [   53.260576] Testing event extract_entropy_user: OK
> [   53.280512] Testing event extract_entropy: OK
> [   53.300427] Testing event get_random_bytes_arch: OK
> [   53.320522] Testing event get_random_bytes: OK
> [   53.340455] Testing event xfer_secondary_pool: OK
> [   53.360505] Testing event add_disk_randomness: OK
> [   53.380439] Testing event add_input_randomness: OK
> [   53.400649] Testing event debit_entropy: OK
> [   53.420411] Testing event push_to_pool: OK
> [   53.440469] Testing event credit_entropy_bits: OK
> [   53.460541] Testing event mix_pool_bytes_nolock: OK
> [   53.480686] Testing event mix_pool_bytes: OK
> [   53.500504] Testing event add_device_randomness: OK
> [   53.520481] Testing event drm_vblank_event_delivered: OK
> [   53.540355] Testing event drm_vblank_event_queued: OK
> [   53.560761] Testing event drm_vblank_event: OK
> [   53.580396] Testing event radeon_semaphore_wait: OK
> [   53.600529] Testing event radeon_semaphore_signale: OK
> [   53.620426] Testing event radeon_fence_wait_end: OK
> [   53.640581] Testing event radeon_fence_wait_begin: OK
> [   53.660417] Testing event radeon_fence_emit: OK
> [   53.680584] Testing event radeon_vm_set_page: OK
> [   53.700443] Testing event radeon_vm_bo_update: OK
> [   53.720856] Testing event radeon_vm_grab_id: OK
> [   53.740448] Testing event radeon_cs: OK
> [   53.760621] Testing event radeon_bo_create: OK
> [   53.780469] Testing event regcache_drop_region: OK
> [   53.800544] Testing event regmap_async_complete_done: OK
> [   53.820468] Testing event regmap_async_complete_start: OK
> [   53.840740] Testing event regmap_async_io_complete: OK
> [   53.860435] Testing event regmap_async_write_start: OK
> [   53.880442] Testing event regmap_cache_bypass: OK
> [   53.900396] Testing event regmap_cache_only: OK
> [   53.920612] Testing event regcache_sync: OK
> [   53.940411] Testing event regmap_hw_write_done: OK
> [   53.960689] Testing event regmap_hw_write_start: OK
> [   53.980421] Testing event regmap_hw_read_done: OK
> [   54.000485] Testing event regmap_hw_read_start: OK
> [   54.020410] Testing event regmap_reg_read_cache: OK
> [   54.040813] Testing event regmap_reg_read: OK
> [   54.060404] Testing event regmap_reg_write: OK
> [   54.080668] Testing event scsi_eh_wakeup: OK
> [   54.100539] Testing event scsi_dispatch_cmd_timeout: OK
> [   54.120850] Testing event scsi_dispatch_cmd_done: OK
> [   54.140543] Testing event scsi_dispatch_cmd_error: OK
> [   54.160464] Testing event scsi_dispatch_cmd_start: OK
> [   54.180449] Testing event target_cmd_complete: OK
> [   54.200566] Testing event target_sequencer_start: OK
> [   54.220410] Testing event spi_transfer_stop: OK
> [   54.240426] Testing event spi_transfer_start: OK
> [   54.260367] Testing event spi_message_done: OK
> [   54.280539] Testing event spi_message_start: OK
> [   54.300390] Testing event spi_message_submit: OK
> [   54.320553] Testing event spi_master_busy: OK
> [   54.340443] Testing event spi_master_idle: OK
> [   54.360535] Testing event smbus_result: OK
> [   54.380512] Testing event smbus_reply: OK
> [   54.400602] Testing event smbus_read: OK
> [   54.420754] Testing event smbus_write: OK
> [   54.440524] Testing event i2c_result: OK
> [   54.460875] Testing event i2c_reply: OK
> [   54.480847] Testing event i2c_read: OK
> [   54.500449] Testing event i2c_write: OK
> [   54.520919] Testing event mc_event: OK
> [   54.540693] Testing event snd_soc_cache_sync: OK
> [   54.560779] Testing event snd_soc_jack_notify: OK
> [   54.580667] Testing event snd_soc_jack_report: OK
> [   54.600916] Testing event snd_soc_jack_irq: OK
> [   54.620719] Testing event snd_soc_dapm_connected: OK
> [   54.640821] Testing event snd_soc_dapm_input_path: OK
> [   54.660675] Testing event snd_soc_dapm_output_path: OK
> [   54.681599] Testing event snd_soc_dapm_walk_done: OK
> [   54.700758] Testing event snd_soc_dapm_widget_event_done: OK
> [   54.720972] Testing event snd_soc_dapm_widget_event_start: OK
> [   54.740860] Testing event snd_soc_dapm_widget_power: OK
> [   54.761126] Testing event snd_soc_dapm_done: OK
> [   54.780676] Testing event snd_soc_dapm_start: OK
> [   54.800774] Testing event snd_soc_bias_level_done: OK
> [   54.820660] Testing event snd_soc_bias_level_start: OK
> [   54.840954] Testing event snd_soc_preg_read: OK
> [   54.860606] Testing event snd_soc_preg_write: OK
> [   54.880649] Testing event snd_soc_reg_read: OK
> [   54.900629] Testing event snd_soc_reg_write: OK
> [   54.920843] Testing event sst_ipc_outbox_write: OK
> [   54.940602] Testing event sst_ipc_outbox_read: OK
> [   54.960667] Testing event sst_ipc_inbox_write: OK
> [   54.980613] Testing event sst_ipc_inbox_read: OK
> [   55.000806] Testing event sst_ipc_outbox_wdata: OK
> [   55.020582] Testing event sst_ipc_outbox_rdata: OK
> [   55.041043] Testing event sst_ipc_inbox_wdata: OK
> [   55.060618] Testing event sst_ipc_inbox_rdata: OK
> [   55.080689] Testing event sst_ipc_msg_rx: OK
> [   55.100626] Testing event sst_ipc_msg_tx: OK
> [   55.120839] Testing event udp_fail_queue_rcv_skb: OK
> [   55.140827] Testing event sock_exceed_buf_limit: OK
> [   55.160937] Testing event sock_rcvqueue_full: OK
> [   55.180747] Testing event napi_poll: OK
> [   55.201515] Testing event netif_rx_ni_entry: OK
> [   55.220708] Testing event netif_rx_entry: OK
> [   55.240869] Testing event netif_receive_skb_entry: OK
> [   55.260710] Testing event napi_gro_receive_entry: OK
> [   55.280805] Testing event napi_gro_frags_entry: OK
> [   55.300656] Testing event netif_rx: OK
> [   55.320853] Testing event netif_receive_skb: OK
> [   55.340605] Testing event net_dev_queue: OK
> [   55.360750] Testing event net_dev_xmit: OK
> [   55.380645] Testing event net_dev_start_xmit: OK
> [   55.400626] Testing event skb_copy_datagram_iovec: OK
> [   55.420579] Testing event consume_skb: OK
> [   55.440852] Testing event kfree_skb: OK
> [   55.460611] Testing event 9p_protocol_dump: OK
> [   55.480682] Testing event 9p_client_res: OK
> [   55.500675] Testing event 9p_client_req: OK
> [   55.520833] Running tests on trace event systems:
> [   55.521582] Testing event system 9p: OK
> [   55.540747] Testing event system skb: OK
> [   55.560780] Testing event system net: OK
> [   55.580769] Testing event system napi: OK
> [   55.601011] Testing event system sock: OK
> [   55.620715] Testing event system udp: OK
> [   55.640828] Testing event system intel-sst: OK
> [   55.660805] Testing event system asoc: OK
> [   55.681073] Testing event system i2c: OK
> [   55.700845] Testing event system spi: OK
> [   55.720889] Testing event system target: OK
> [   55.741482] Testing event system scsi: OK
> [   55.761779] Testing event system regmap: OK
> [   55.780913] Testing event system radeon: OK
> [   55.801111] Testing event system drm: OK
> [   55.820684] Testing event system random: OK
> [   55.843261] Testing event system regulator: OK
> [   55.860750] Testing event system ras: OK
> [   55.880891] Testing event system gpio: OK
> [   55.900757] Testing event system swiotlb: OK
> [   55.920973] Testing event system block: OK
> [   55.940918] Testing event system gfs2: OK
> [   55.960894] Testing event system btrfs: OK
> [   55.981079] Testing event system ocfs2: OK
> [   56.013493] Testing event system xfs: OK
> [   56.053416] Testing event system jbd2: OK
> [   56.070940] Testing event system writeback: OK
> [   56.090919] Testing event system migrate: OK
> [   56.110931] Testing event system compaction: OK
> [   56.130731] Testing event system kmem: OK
> [   56.150824] Testing event system vmscan: OK
> [   56.170766] Testing event system pagemap: OK
> [   56.190852] Testing event system oom: OK
> [   56.210581] Testing event system filemap: OK
> [   56.230770] Testing event system context_tracking: OK
> [   56.251130] Testing event system power: OK
> [   56.271092] Testing event system test: OK
> [   56.290742] Testing event system rcu: OK
> [   56.310801] Testing event system printk: OK
> [   56.330631] Testing event system lock: OK
> [   56.350955] Testing event system sched: OK
> [   56.370875] Testing event system workqueue: OK
> [   56.390863] Testing event system signal: OK
> [   56.410700] Testing event system timer: OK
> [   56.431023] Testing event system irq: OK
> [   56.450712] Testing event system task: OK
> [   56.470777] Testing event system exceptions: OK
> [   56.490651] Testing event system raw_syscalls: OK
> [   56.510997] Testing event system vsyscall: OK
> [   56.530710] Testing event system nmi: OK
> [   56.550673] Testing event system irq_vectors: OK
> [   56.570907] Testing event system kvmmmu: OK
> [   56.590911] Testing event system kvm: OK
> [   56.610927] Running tests on all trace events:
> [   56.611643] Testing all events: OK
> [   56.690892] Testing ftrace filter: OK
> [   56.697147] Btrfs loaded, assert=on
> [   56.698153] Key type encrypted registered
> [   56.702956] rtc-test rtc-test.0: setting system clock to 2014-09-13 09:03:11 UTC (1410598991)
> [   56.704384] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [   56.705177] EDD information not available.
> [   56.706334] ALSA device list:
> [   56.706751]   No soundcards found.
> [   56.734167] Freeing unused kernel memory: 3116K (ffffffff8c63a000 - ffffffff8c945000)
> [   56.735325] Write protecting the kernel read-only data: 28672k
> [   56.749506] Freeing unused kernel memory: 528K (ffff88000a37c000 - ffff88000a400000)
> [   56.783899] Freeing unused kernel memory: 1736K (ffff88000ae4e000 - ffff88000b000000)
> mount: mounting proc on /proc failed: No such device
> /etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found
> [   56.809011] S00fbsetup (2460) used greatest stack depth: 5600 bytes left
> 
> Please wait: booting...
> mount: mounting proc on /proc failed: No such device
> grep: /proc/filesystems: No such file or directory
> Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file or directory
> bootlogd.
> mount: can't read '/proc/mounts': No such file or directory
> /etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /proc/cmdline: no such file
> grep: /proc/filesystems: No such file or directory
> Configuring network interfaces... 
> [   56.856636] nfsroot (2489) used greatest stack depth: 5408 bytes left
> ifconfig: socket: Address family not supported by protocol
> ifup: can't open '/var/run/ifstate': No such file or directory
> done.
> hwclock: can't open '/dev/misc/rtc': No such file or directory
> Running postinst /etc/rpm-postinsts/100...
> mount: no /proc/mounts
> wfg: skip syslogd
> Kernel tests: Boot OK!
> Kernel tests: Boot OK!
> mount: mounting proc on /proc failed: No such device
> /etc/rc5.d/S99-rc.local: line 19: can't create /proc/2530/oom_score_adj: nonexistent directory
> sed: /lib/modules/3.15.0-rc1-00026-g945fa9c/modules.dep: No such file or directory
> xargs: modprobe: No such file or directory
> run-parts: /etc/kernel-tests/01-modprobe exited with code 127
> grep: /proc/cmdline: No such file or directory
> grep: /proc/cmdline: No such file or directory
> /etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
> /etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
> /etc/kernel-tests/90-trinity: line 16: /trinity: not found
> /etc/kernel-tests/90-trinity: line 15: /trinity: not found
> [   61.931250] rcu-torture: rtc: ffffffff8d118dc0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [   61.931250] rcu-torture: Reader Pipe:  4 0 0 0 0 0 0 0 0 0 0
> [   61.931250] rcu-torture: Reader Batch:  4 0 0 0 0 0 0 0 0 0 0
> [   61.931250] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> lsmod: can't open '/proc/modules': No such file or directory
> BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.
> 
> Usage: rmmod [-wfa] [MODULE]...
> 
> lsmod: can't open '/proc/modules': No such file or directory
> BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.
> 
> Usage: rmmod [-wfa] [MODULE]...
> 
> lsmod: can't open '/proc/modules': No such file or directory
> BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.
> 
> Usage: rmmod [-wfa] [MODULE]...
> 
> run-parts: /etc/kernel-tests/99-rmmod exited with code 123
> shutdown: warning: cannot open /var/run/shutdown.pid
> mount: no /proc/mounts
> wfg: skip syslogd
> sed: /proc/mounts: No such file or directory
> sed: /proc/mounts: No such file or directory
> sed: /proc/mounts: No such file or directory
> Deconfiguring network interfaces... ifdown: interface lo not configured
> done.
> Sending all processes the TERM signal...
> mount: mounting proc on /proc failed: No such device
> [  121.930088] Dumping ftrace buffer:
> [  121.930453] ---------------------------------
> [  121.930865] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  121.931644] IP: [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.932194] PGD 10876067 PUD 10892067 PMD 0 
> [  121.932613] Oops: 0000 [#1] PREEMPT SMP 
> [  121.933069] CPU: 0 PID: 47 Comm: rcu_torture_sta Not tainted 3.15.0-rc1-00026-g945fa9c #24
> [  121.933837] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [  121.934716] task: ffff880012388000 ti: ffff88001238a000 task.ti: ffff88001238a000
> [  121.935348] RIP: 0010:[<ffffffff8959b074>]  [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.936092] RSP: 0018:ffff88001238bca8  EFLAGS: 00010097
> [  121.936547] RAX: 0000000000000000 RBX: ffffffff8d12e600 RCX: 0000000000000000
> [  121.937159] RDX: 0000000000000001 RSI: ffffffff8ad13f33 RDI: 0000000000000000
> [  121.937770] RBP: ffff88001238bcd8 R08: 0000000000000009 R09: 00000000fffffff4
> [  121.938375] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000003bd1201
> [  121.938983] R13: ffff880012a82014 R14: ffffffff8d12f6fc R15: 0000000000000000
> [  121.939649] FS:  0000000000000000(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
> [  121.940013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  121.940013] CR2: 0000000000000000 CR3: 0000000010994000 CR4: 00000000000006b0
> [  121.940013] Stack:
> [  121.940013]  00000000018c2d94 0000000000000286 0000000000000001 0000000000000000
> [  121.940013]  ffffffff8d12f6fc 0000000000000000 ffff88001238bd08 ffffffff8959d169
> [  121.940013]  ffff88001099814c ffffffff8d118d8c 00000000ffffffff ffff88001238bec8
> [  121.940013] Call Trace:
> [  121.940013]  [<ffffffff8959d169>] ftrace_dump+0x180/0x21e
> [  121.940013]  [<ffffffff89562d51>] rcutorture_trace_dump+0x5a/0x5c
> [  121.940013]  [<ffffffff8956371d>] rcu_torture_printk+0x49d/0x4b8
> [  121.940013]  [<ffffffff8956379d>] rcu_torture_stats_print+0x65/0x83
> [  121.940013]  [<ffffffff895637bb>] ? rcu_torture_stats_print+0x83/0x83
> [  121.940013]  [<ffffffff89563807>] rcu_torture_stats+0x4c/0x71
> [  121.940013]  [<ffffffff8952745a>] kthread+0xf9/0x101
> [  121.940013]  [<ffffffff89527361>] ? __kthread_parkme+0x86/0x86
> [  121.940013]  [<ffffffff8a375c4c>] ret_from_fork+0x7c/0xb0
> [  121.940013]  [<ffffffff89527361>] ? __kthread_parkme+0x86/0x86
> [  121.940013] Code: e9 e2 00 00 00 41 f7 c4 00 10 00 00 74 7d f6 83 d8 00 00 00 02 74 74 8b bb 20 21 00 00 4c 8b bb f0 10 00 00 e8 6d b8 ff ff 89 c0 <49> 0f a3 07 19 c0 85 c0 75 56 48 63 93 20 21 00 00 48 8b 43 10 
> [  121.940013] RIP  [<ffffffff8959b074>] print_trace_line+0x2b0/0x38a
> [  121.940013]  RSP <ffff88001238bca8>
> [  121.940013] CR2: 0000000000000000
> [  121.940013] ---[ end trace 605ab88dfe93d9f3 ]---
> [  121.940013] Kernel panic - not syncing: Fatal exception
> [  121.940013] Kernel Offset: 0x8400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Elapsed time: 125
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:945fa9c631b04febe295a3a2a00c7e4a3cfb97db:bisect-linux-8/.vmlinuz-945fa9c631b04febe295a3a2a00c7e4a3cfb97db-20140913170207-9-ivb41 branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/945fa9c631b04febe295a3a2a00c7e4a3cfb97db/vmlinuz-3.15.0-rc1-00026-g945fa9c drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-yocto-ivb41-68 -serial file:/dev/shm/kboot/serial-yocto-ivb41-68 -daemonize -display none -monitor null 

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> KASLR using RDTSC...
> 
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00025-g499c632 (kbuild@jaketown) (gcc version 4.9.1 (Debian 4.9.1-11) ) #25 SMP PREEMPT Sat Sep 13 17:20:47 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:499c632dce47e95280f8b99540c5db294053c94c:bisect-linux-8/.vmlinuz-499c632dce47e95280f8b99540c5db294053c94c-20140913172231-14-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0e63e000, 0x0e63efff] PGTABLE
> [    0.000000] BRK [0x0e63f000, 0x0e63ffff] PGTABLE
> [    0.000000] BRK [0x0e640000, 0x0e640fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x0e641000, 0x0e641fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1920320 r0 d21184 u2097152
> [    0.000000] pcpu-alloc: s1920320 r0 d21184 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:499c632dce47e95280f8b99540c5db294053c94c:bisect-linux-8/.vmlinuz-499c632dce47e95280f8b99540c5db294053c94c-20140913172231-14-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Memory: 228884K/327280K available (15846K kernel code, 22756K rwdata, 10552K rodata, 3116K init, 9168K bss, 98396K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00025-g499c632 (kbuild@jaketown) (gcc version 4.9.1 (Debian 4.9.1-11) ) #25 SMP PREEMPT Sat Sep 13 17:20:47 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:499c632dce47e95280f8b99540c5db294053c94c:bisect-linux-8/.vmlinuz-499c632dce47e95280f8b99540c5db294053c94c-20140913172231-14-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0e63e000, 0x0e63efff] PGTABLE
> [    0.000000] BRK [0x0e63f000, 0x0e63ffff] PGTABLE
> [    0.000000] BRK [0x0e640000, 0x0e640fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x0e641000, 0x0e641fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1920320 r0 d21184 u2097152
> [    0.000000] pcpu-alloc: s1920320 r0 d21184 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:499c632dce47e95280f8b99540c5db294053c94c:bisect-linux-8/.vmlinuz-499c632dce47e95280f8b99540c5db294053c94c-20140913172231-14-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Memory: 228884K/327280K available (15846K kernel code, 22756K rwdata, 10552K rodata, 3116K init, 9168K bss, 98396K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.452 MHz processor
> [    0.000000] tsc: Detected 2693.452 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.90 BogoMIPS (lpj=26934520)
> 5386.90 BogoMIPS (lpj=26934520)
> [    0.027778] pid_max: default: 32768 minimum: 301
> [    0.027778] pid_max: default: 32768 minimum: 301
> [    0.030061] ACPI: Core revision 20140214
> [    0.030061] ACPI: Core revision 20140214
> [    0.091180] ACPI: 
> [    0.091180] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables successfully acquired
> 
> [    0.093201] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.093201] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.095283] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.095283] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.098313] Initializing cgroup subsys debug
> [    0.098313] Initializing cgroup subsys debug
> [    0.100061] Initializing cgroup subsys devices
> [    0.100061] Initializing cgroup subsys devices
> [    0.101472] Initializing cgroup subsys blkio
> [    0.101472] Initializing cgroup subsys blkio
> [    0.102798] Initializing cgroup subsys perf_event
> [    0.102798] Initializing cgroup subsys perf_event
> [    0.104181] Initializing cgroup subsys hugetlb
> [    0.104181] Initializing cgroup subsys hugetlb
> [    0.105695] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.105695] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.105695] tlb_flushall_shift: 6
> [    0.105695] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.105695] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.105695] tlb_flushall_shift: 6
> [    0.110672] Freeing SMP alternatives memory: 16K (ffffffff8dd45000 - ffffffff8dd49000)
> [    0.110672] Freeing SMP alternatives memory: 16K (ffffffff8dd45000 - ffffffff8dd49000)
> [    0.121895] Getting VERSION: 1050014
> [    0.121895] Getting VERSION: 1050014
> [    0.123059] Getting VERSION: 1050014
> [    0.123059] Getting VERSION: 1050014
> [    0.124210] Getting ID: 0
> [    0.124210] Getting ID: 0
> [    0.125134] Getting ID: ff000000
> [    0.125134] Getting ID: ff000000
> [    0.126167] Getting LVT0: 8700
> [    0.126167] Getting LVT0: 8700
> [    0.127192] Getting LVT1: 8400
> [    0.127192] Getting LVT1: 8400
> [    0.130114] enabled ExtINT on CPU#0
> [    0.130114] enabled ExtINT on CPU#0
> [    0.141431] ENABLING IO-APIC IRQs
> [    0.141431] ENABLING IO-APIC IRQs
> [    0.142519] init IO_APIC IRQs
> [    0.142519] init IO_APIC IRQs
> [    0.143469]  apic 0 pin 0 not connected
> [    0.143469]  apic 0 pin 0 not connected
> [    0.144744] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.144744] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.147318] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.147318] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.150085] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.150085] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.152694] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.152694] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.155276] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.155276] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.157847] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.157847] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.160081] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.160081] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.162562] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.162562] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.165111] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.165111] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.170083] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.170083] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.180049] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.180049] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.182613] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.182613] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.185223] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.185223] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.190080] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.190080] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.192705] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.192705] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.195237]  apic 0 pin 16 not connected
> [    0.195237]  apic 0 pin 16 not connected
> [    0.196495]  apic 0 pin 17 not connected
> [    0.196495]  apic 0 pin 17 not connected
> [    0.200026]  apic 0 pin 18 not connected
> [    0.200026]  apic 0 pin 18 not connected
> [    0.210011]  apic 0 pin 19 not connected
> [    0.210011]  apic 0 pin 19 not connected
> [    0.211285]  apic 0 pin 20 not connected
> [    0.211285]  apic 0 pin 20 not connected
> [    0.220022]  apic 0 pin 21 not connected
> [    0.220022]  apic 0 pin 21 not connected
> [    0.221205]  apic 0 pin 22 not connected
> [    0.221205]  apic 0 pin 22 not connected
> [    0.222286]  apic 0 pin 23 not connected
> [    0.222286]  apic 0 pin 23 not connected
> [    0.223647] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.223647] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.225743] smpboot: CPU0: 
> [    0.225743] smpboot: CPU0: Intel Core Processor (Haswell)Intel Core Processor (Haswell) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
> , stepping: 01)
> [    0.230065] TSC deadline timer enabled
> [    0.230065] TSC deadline timer enabled
> [    0.231536] Performance Events: 
> [    0.231536] Performance Events: unsupported p6 CPU model 60 unsupported p6 CPU model 60 no PMU driver, software events only.
> no PMU driver, software events only.
> [    0.270130] ftrace: Allocated trace_printk buffers
> [    0.270130] ftrace: Allocated trace_printk buffers
> [    0.274104] Testing tracer nop: 
> [    0.274104] Testing tracer nop: PASSED
> PASSED
> [    0.291209] x86: Booting SMP configuration:
> [    0.291209] x86: Booting SMP configuration:
> [    0.292828] .... node  #0, CPUs:  
> [    0.292828] .... node  #0, CPUs:         #1 #1
> [    0.020000] kvm-clock: cpu 1, msr 0:128bd041, secondary cpu clock
> [    0.020000] masked ExtINT on CPU#1
> [    0.326041] x86: Booted up 1 node, 2 CPUs
> [    0.326041] x86: Booted up 1 node, 2 CPUs
> [    0.325975] KVM setup async PF for cpu 1
> [    0.325975] KVM setup async PF for cpu 1
> [    0.325975] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.325975] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.329661] smpboot: Total of 2 processors activated (10773.80 BogoMIPS)
> [    0.329661] smpboot: Total of 2 processors activated (10773.80 BogoMIPS)
> [    0.340642] devtmpfs: initialized
> [    0.340642] devtmpfs: initialized
> [    0.380216] Testing tracer function: 
> [    0.380216] Testing tracer function: PASSED
> PASSED
> [    0.544583] Testing ftrace regs(no arch support): 
> [    0.544583] Testing ftrace regs(no arch support): PASSED
> PASSED
> [    0.614371] Testing tracer preemptoff: 
> [    0.614371] Testing tracer preemptoff: PASSED
> PASSED
> [    0.740224] Testing tracer function_graph: 
> [    0.740224] Testing tracer function_graph: PASSED
> PASSED
> [    0.960057] Testing tracer branch: 
> [    0.960057] Testing tracer branch: PASSED
> PASSED
> [    1.160065] xor: automatically using best checksumming function:
> [    1.160065] xor: automatically using best checksumming function:
> [    1.320990]    avx       :  8517.600 MB/sec
> [    1.320990]    avx       :  8517.600 MB/sec
> [    1.322216] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    1.322216] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    1.325073] regulator-dummy: no parameters
> [    1.325073] regulator-dummy: no parameters
> [    1.326727] NET: Registered protocol family 16
> [    1.326727] NET: Registered protocol family 16
> [    1.329855] cpuidle: using governor ladder
> [    1.329855] cpuidle: using governor ladder
> [    1.350030] cpuidle: using governor menu
> [    1.350030] cpuidle: using governor menu
> [    1.390160] ACPI: bus type PCI registered
> [    1.390160] ACPI: bus type PCI registered
> [    1.391373] PCI: Using configuration type 1 for base access
> [    1.391373] PCI: Using configuration type 1 for base access
> [    1.710057] raid6: sse2x1    1428 MB/s
> [    1.710057] raid6: sse2x1    1428 MB/s
> [    1.880038] raid6: sse2x2    1956 MB/s
> [    1.880038] raid6: sse2x2    1956 MB/s
> [    2.070042] raid6: sse2x4    2036 MB/s
> [    2.070042] raid6: sse2x4    2036 MB/s
> [    2.072402] raid6: using algorithm sse2x4 (2036 MB/s)
> [    2.072402] raid6: using algorithm sse2x4 (2036 MB/s)
> [    2.073959] raid6: using ssse3x2 recovery algorithm
> [    2.073959] raid6: using ssse3x2 recovery algorithm
> [    2.086192] ACPI: Added _OSI(Module Device)
> [    2.086192] ACPI: Added _OSI(Module Device)
> [    2.086192] ACPI: Added _OSI(Processor Device)
> [    2.086192] ACPI: Added _OSI(Processor Device)
> [    2.086192] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    2.086192] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    2.086192] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.086192] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.170838] ACPI: Interpreter enabled
> [    2.170838] ACPI: Interpreter enabled
> [    2.171934] ACPI Exception: AE_NOT_FOUND, 
> [    2.171934] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    2.174920] ACPI Exception: AE_NOT_FOUND, 
> [    2.174920] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    2.177947] ACPI: (supports S0 S3 S5)
> [    2.177947] ACPI: (supports S0 S3 S5)
> [    2.179111] ACPI: Using IOAPIC for interrupt routing
> [    2.179111] ACPI: Using IOAPIC for interrupt routing
> [    2.190243] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    2.190243] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    2.293218] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    2.293218] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    2.295269] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    2.295269] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    2.297600] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    2.297600] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    2.322339] PCI host bridge to bus 0000:00
> [    2.322339] PCI host bridge to bus 0000:00
> [    2.323719] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.323719] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.325456] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    2.325456] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    2.327444] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    2.327444] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    2.329382] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    2.329382] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    2.350039] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    2.350039] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    2.352400] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    2.352400] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    2.356117] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    2.356117] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    2.381901] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    2.381901] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    2.400996] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    2.400996] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    2.411337] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    2.411337] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    2.413567] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    2.413567] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    2.415613] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    2.415613] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    2.417855] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    2.417855] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    2.431370] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    2.431370] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    2.433993] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    2.433993] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    2.436302] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    2.436302] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    2.461476] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    2.461476] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    2.490140] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    2.490140] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    2.494150] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    2.494150] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    2.525044] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    2.525044] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    2.540102] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    2.540102] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    2.543247] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    2.543247] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    2.546339] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    2.546339] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    2.573382] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    2.573382] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    2.599665] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    2.599665] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    2.600690] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    2.600690] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    2.621472] pci_bus 0000:00: on NUMA node 0
> [    2.621472] pci_bus 0000:00: on NUMA node 0
> [    2.626208] ACPI: PCI Interrupt Link [LNKA] (IRQs
> [    2.626208] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))
> 
> [    2.628956] ACPI: PCI Interrupt Link [LNKB] (IRQs
> [    2.628956] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))
> 
> [    2.651295] ACPI: PCI Interrupt Link [LNKC] (IRQs
> [    2.651295] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))
> 
> [    2.653670] ACPI: PCI Interrupt Link [LNKD] (IRQs
> [    2.653670] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))
> 
> [    2.655650] ACPI: PCI Interrupt Link [LNKS] (IRQs
> [    2.655650] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))
> 
> [    2.680436] ACPI: 
> [    2.680436] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in block 00 to 0F
> 
> [    2.700273] SCSI subsystem initialized
> [    2.700273] SCSI subsystem initialized
> [    2.700273] pps_core: LinuxPPS API ver. 1 registered
> [    2.700273] pps_core: LinuxPPS API ver. 1 registered
> [    2.710063] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    2.710063] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    2.712668] PTP clock support registered
> [    2.712668] PTP clock support registered
> [    2.713902] EDAC MC: Ver: 3.0.0
> [    2.713902] EDAC MC: Ver: 3.0.0
> [    2.715417] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    2.715417] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    2.740197] wmi: Mapper loaded
> [    2.740197] wmi: Mapper loaded
> [    2.742469] Advanced Linux Sound Architecture Driver Initialized.
> [    2.742469] Advanced Linux Sound Architecture Driver Initialized.
> [    2.742469] PCI: Using ACPI for IRQ routing
> [    2.742469] PCI: Using ACPI for IRQ routing
> [    2.742469] PCI: pci_cache_line_size set to 64 bytes
> [    2.742469] PCI: pci_cache_line_size set to 64 bytes
> [    2.742469] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    2.742469] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    2.742469] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    2.742469] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    2.750000] NET: Registered protocol family 23
> [    2.750000] NET: Registered protocol family 23
> [    2.750000] Bluetooth: Core ver 2.19
> [    2.750000] Bluetooth: Core ver 2.19
> [    2.750000] NET: Registered protocol family 31
> [    2.750000] NET: Registered protocol family 31
> [    2.750000] Bluetooth: HCI device and connection manager initialized
> [    2.750000] Bluetooth: HCI device and connection manager initialized
> [    2.780129] Bluetooth: HCI socket layer initialized
> [    2.780129] Bluetooth: HCI socket layer initialized
> [    2.781725] Bluetooth: L2CAP socket layer initialized
> [    2.781725] Bluetooth: L2CAP socket layer initialized
> [    2.783438] Bluetooth: SCO socket layer initialized
> [    2.783438] Bluetooth: SCO socket layer initialized
> [    2.785057] NET: Registered protocol family 8
> [    2.785057] NET: Registered protocol family 8
> [    2.786423] NET: Registered protocol family 20
> [    2.786423] NET: Registered protocol family 20
> [    2.788566] nfc: nfc_init: NFC Core ver 0.1
> [    2.788566] nfc: nfc_init: NFC Core ver 0.1
> [    2.810261] NET: Registered protocol family 39
> [    2.810261] NET: Registered protocol family 39
> [    2.812776] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    2.812776] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    2.842735] Switched to clocksource kvm-clock
> [    2.842735] Switched to clocksource kvm-clock
> [    2.845966] Warning: could not register all branches stats
> [    2.845966] Warning: could not register all branches stats
> [    2.847829] Warning: could not register annotated branches stats
> [    2.847829] Warning: could not register annotated branches stats
> [    3.360820] FS-Cache: Loaded
> [    3.360820] FS-Cache: Loaded
> [    3.382228] CacheFiles: Loaded
> [    3.382228] CacheFiles: Loaded
> [    3.383340] pnp: PnP ACPI init
> [    3.383340] pnp: PnP ACPI init
> [    3.384552] ACPI: bus type PNP registered
> [    3.384552] ACPI: bus type PNP registered
> [    3.386174] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    3.386174] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    3.388996] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    3.388996] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    3.391167] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    3.391167] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    3.413931] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    3.413931] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    3.415924] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    3.415924] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    3.418413] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    3.418413] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    3.420641] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    3.420641] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    3.442282] pnp 00:03: [dma 2]
> [    3.442282] pnp 00:03: [dma 2]
> [    3.443627] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    3.443627] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    3.446024] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    3.446024] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    3.448794] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    3.448794] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    3.451136] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    3.451136] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    3.473819] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    3.473819] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    3.475938] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    3.475938] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    3.478391] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    3.478391] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    3.482006] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    3.482006] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    3.503198] pnp: PnP ACPI: found 8 devices
> [    3.503198] pnp: PnP ACPI: found 8 devices
> [    3.504350] ACPI: bus type PNP unregistered
> [    3.504350] ACPI: bus type PNP unregistered
> [    3.534037] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    3.534037] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    3.535801] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    3.535801] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    3.537341] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    3.537341] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    3.539137] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    3.539137] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    3.541137] NET: Registered protocol family 1
> [    3.541137] NET: Registered protocol family 1
> [    3.542547] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    3.542547] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    3.554379] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    3.554379] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    3.556016] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    3.556016] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    3.557768] pci 0000:00:02.0: Boot video device
> [    3.557768] pci 0000:00:02.0: Boot video device
> [    3.559084] PCI: CLS 0 bytes, default 64
> [    3.559084] PCI: CLS 0 bytes, default 64
> [    3.560921] Unpacking initramfs...
> [    3.560921] Unpacking initramfs...
> [    7.128427] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    7.128427] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    7.182821] RAPL PMU detected, hw unit 2^-4 Joules, API unit is 2^-32 Joules, 3 fixed counters 671088640 ms ovfl timer
> [    7.182821] RAPL PMU detected, hw unit 2^-4 Joules, API unit is 2^-32 Joules, 3 fixed counters 671088640 ms ovfl timer
> [    7.193470] cryptomgr_test (35) used greatest stack depth: 6472 bytes left
> [    7.193470] cryptomgr_test (35) used greatest stack depth: 6472 bytes left
> [    7.211796] AVX version of gcm_enc/dec engaged.
> [    7.211796] AVX version of gcm_enc/dec engaged.
> [    7.218600] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    7.218600] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    7.243018] sha512_ssse3: Using AVX optimized SHA-512 implementation
> [    7.243018] sha512_ssse3: Using AVX optimized SHA-512 implementation
> [    7.258623] AVX2 or AES-NI instructions are not detected.
> [    7.258623] AVX2 or AES-NI instructions are not detected.
> [    7.271832] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    7.271832] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    7.281033] rcu-torture: Creating rcu_torture_writer task
> [    7.281033] rcu-torture: Creating rcu_torture_writer task
> [    7.284537] rcu-torture: rcu_torture_writer task started
> [    7.284537] rcu-torture: rcu_torture_writer task started
> [    7.292817] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.292817] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.295100] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.295100] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.296873] rcu-torture: rcu_torture_fakewriter task started
> [    7.296873] rcu-torture: rcu_torture_fakewriter task started
> [    7.298622] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.298622] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.300295] rcu-torture: rcu_torture_fakewriter task started
> [    7.300295] rcu-torture: rcu_torture_fakewriter task started
> [    7.304753] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.304753] rcu-torture: Creating rcu_torture_fakewriter task
> [    7.306700] rcu-torture: rcu_torture_fakewriter task started
> [    7.306700] rcu-torture: rcu_torture_fakewriter task started
> [    7.323760] rcu-torture: rcu_torture_fakewriter task started
> [    7.323760] rcu-torture: rcu_torture_fakewriter task started
> [    7.325672] rcu-torture: Creating rcu_torture_reader task
> [    7.325672] rcu-torture: Creating rcu_torture_reader task
> [    7.332942] rcu-torture: Creating rcu_torture_reader task
> [    7.332942] rcu-torture: Creating rcu_torture_reader task
> [    7.334818] rcu-torture: rcu_torture_reader task started
> [    7.334818] rcu-torture: rcu_torture_reader task started
> [    7.336708] rcu-torture: Creating rcu_torture_reader task
> [    7.336708] rcu-torture: Creating rcu_torture_reader task
> [    7.339454] rcu-torture: rcu_torture_reader task started
> [    7.339454] rcu-torture: rcu_torture_reader task started
> [    7.348037] rcu-torture: rcu_torture_reader task started
> [    7.348037] rcu-torture: rcu_torture_reader task started
> [    7.350325] rcu-torture: Creating rcu_torture_reader task
> [    7.350325] rcu-torture: Creating rcu_torture_reader task
> [    7.352383] rcu-torture: Creating rcu_torture_stats task
> [    7.352383] rcu-torture: Creating rcu_torture_stats task
> [    7.354085] rcu-torture: rcu_torture_reader task started
> [    7.354085] rcu-torture: rcu_torture_reader task started
> [    7.355922] rcu-torture: Creating torture_shuffle task
> [    7.355922] rcu-torture: Creating torture_shuffle task
> [    7.357744] rcu-torture: torture_shuffle task started
> [    7.357744] rcu-torture: torture_shuffle task started
> [    7.359306] rcu-torture: Creating torture_stutter task
> [    7.359306] rcu-torture: Creating torture_stutter task
> [    7.361915] rcu-torture: rcu_torture_stats task started
> [    7.361915] rcu-torture: rcu_torture_stats task started
> [    7.365284] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    7.365284] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    7.367297] Initialise system trusted keyring
> [    7.367297] Initialise system trusted keyring
> [    7.371003] rcu-torture: torture_stutter task started
> [    7.371003] rcu-torture: torture_stutter task started
> [    7.392931] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    7.392931] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    7.423488] VFS: Disk quotas dquot_6.5.2
> [    7.423488] VFS: Disk quotas dquot_6.5.2
> [    7.424915] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    7.424915] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    7.427781] fuse init (API version 7.23)
> [    7.427781] fuse init (API version 7.23)
> [    7.429279] JFS: nTxBlock = 1969, nTxLock = 15759
> [    7.429279] JFS: nTxBlock = 1969, nTxLock = 15759
> [    7.433056] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    7.433056] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    7.480169] NILFS version 2 loaded
> [    7.480169] NILFS version 2 loaded
> [    7.492893] ocfs2 stack glue: unable to register sysctl
> [    7.492893] ocfs2 stack glue: unable to register sysctl
> [    7.494587] ocfs2: Registered cluster interface o2cb
> [    7.494587] ocfs2: Registered cluster interface o2cb
> [    7.512808] OCFS2 User DLM kernel interface loaded
> [    7.512808] OCFS2 User DLM kernel interface loaded
> [    7.572998] gfs2: GFS2 installed
> [    7.572998] gfs2: GFS2 installed
> [    7.574314] Key type big_key registered
> [    7.574314] Key type big_key registered
> [    8.152884] tsc: Refined TSC clocksource calibration: 2693.505 MHz
> [    8.152884] tsc: Refined TSC clocksource calibration: 2693.505 MHz
> [    8.232898] NET: Registered protocol family 38
> [    8.232898] NET: Registered protocol family 38
> [    8.234456] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    8.234456] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    8.236604] io scheduler noop registered
> [    8.236604] io scheduler noop registered
> [    8.237955] io scheduler deadline registered (default)
> [    8.237955] io scheduler deadline registered (default)
> [    8.239498] io scheduler cfq registered
> [    8.239498] io scheduler cfq registered
> [    8.240741] test_string_helpers: Running tests...
> [    8.240741] test_string_helpers: Running tests...
> [    8.274537] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    8.274537] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    8.277314] vmlfb: initializing
> [    8.277314] vmlfb: initializing
> [    8.278405] Could not find Carillo Ranch MCH device.
> [    8.278405] Could not find Carillo Ranch MCH device.
> [    8.281306] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    8.281306] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    8.293600] ACPI: Power Button [PWRF]
> [    8.293600] ACPI: Power Button [PWRF]
> [    8.556142] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    8.556142] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    8.613261] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    8.613261] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    8.621558] Cyclades driver 2.6
> [    8.621558] Cyclades driver 2.6
> [    8.623475] MOXA Intellio family driver version 6.0k
> [    8.623475] MOXA Intellio family driver version 6.0k
> [    8.625387] MOXA Smartio/Industio family driver version 2.0.5
> [    8.625387] MOXA Smartio/Industio family driver version 2.0.5
> [    8.627325] RocketPort device driver module, version 2.09, 12-June-2003
> [    8.627325] RocketPort device driver module, version 2.09, 12-June-2003
> [    8.629425] No rocketport ports found; unloading driver
> [    8.629425] No rocketport ports found; unloading driver
> [    8.631228] SyncLink serial driver $Revision: 4.38 $
> [    8.631228] SyncLink serial driver $Revision: 4.38 $
> [    8.711680] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    8.711680] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    8.724340] lp: driver loaded but no devices found
> [    8.724340] lp: driver loaded but no devices found
> [    8.726028] ppdev: user-space parallel port driver
> [    8.726028] ppdev: user-space parallel port driver
> [    8.727573] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    8.727573] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    8.729184] smapi::smapi_init, ERROR invalid usSmapiID
> [    8.729184] smapi::smapi_init, ERROR invalid usSmapiID
> [    8.730839] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    8.730839] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    8.733516] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    8.733516] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    8.735803] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    8.735803] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    8.737793] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    8.737793] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    8.739648] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    8.739648] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    8.742447] Hangcheck: Using getrawmonotonic().
> [    8.742447] Hangcheck: Using getrawmonotonic().
> [    8.755006] [drm] Initialized drm 1.1.0 20060810
> [    8.755006] [drm] Initialized drm 1.1.0 20060810
> [    8.756890] [drm] radeon kernel modesetting enabled.
> [    8.756890] [drm] radeon kernel modesetting enabled.
> [    8.773087] [TTM] Zone  kernel: Available graphics memory: 126072 kiB
> [    8.773087] [TTM] Zone  kernel: Available graphics memory: 126072 kiB
> [    8.775123] [TTM] Initializing pool allocator
> [    8.775123] [TTM] Initializing pool allocator
> [    8.776617] [TTM] Initializing DMA pool allocator
> [    8.776617] [TTM] Initializing DMA pool allocator
> [    8.779534] [drm] fb mappable at 0xFC000000
> [    8.779534] [drm] fb mappable at 0xFC000000
> [    8.792773] [drm] vram aper at 0xFC000000
> [    8.792773] [drm] vram aper at 0xFC000000
> [    8.794173] [drm] size 4194304
> [    8.794173] [drm] size 4194304
> [    8.795052] [drm] fb depth is 24
> [    8.795052] [drm] fb depth is 24
> [    8.796022] [drm]    pitch is 3072
> [    8.796022] [drm]    pitch is 3072
> [    8.798093] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    8.798093] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    8.799953] cirrus 0000:00:02.0: registered panic notifier
> [    8.799953] cirrus 0000:00:02.0: registered panic notifier
> [    8.801765] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    8.801765] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    8.816458] parport_pc 00:04: reported by Plug and Play ACPI
> [    8.816458] parport_pc 00:04: reported by Plug and Play ACPI
> [    8.818234] parport0: PC-style at 0x378
> [    8.818234] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,...)(,...)]
> ]
> [    8.821057] lp0: using parport0 (interrupt-driven).
> [    8.821057] lp0: using parport0 (interrupt-driven).
> [    8.822487] lp0: console ready
> [    8.822487] lp0: console ready
> [    8.837333] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    8.837333] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    8.839554] dummy-irq: no IRQ given.  Use irq=N
> [    8.839554] dummy-irq: no IRQ given.  Use irq=N
> [    8.841260] lkdtm: No crash points registered, enable through debugfs
> [    8.841260] lkdtm: No crash points registered, enable through debugfs
> [    8.843513] Phantom Linux Driver, version n0.9.8, init OK
> [    8.843513] Phantom Linux Driver, version n0.9.8, init OK
> [    8.846107] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    8.846107] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    8.848948] c2port c2port0: C2 port uc added
> [    8.848948] c2port c2port0: C2 port uc added
> [    8.850268] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    8.850268] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    8.865972] Uniform Multi-Platform E-IDE driver
> [    8.865972] Uniform Multi-Platform E-IDE driver
> [    8.867766] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    8.867766] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    8.869905] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    8.869905] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    8.872662]     ide0: BM-DMA at 0xc040-0xc047
> [    8.872662]     ide0: BM-DMA at 0xc040-0xc047
> [    8.874053]     ide1: BM-DMA at 0xc048-0xc04f
> [    8.874053]     ide1: BM-DMA at 0xc048-0xc04f
> [    8.875360] Probing IDE interface ide0...
> [    8.875360] Probing IDE interface ide0...
> [    9.503181] Probing IDE interface ide1...
> [    9.503181] Probing IDE interface ide1...
> [   10.346940] hdc: QEMU DVD-ROM, ATAPI 
> [   10.346940] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
>  drive
> [   11.082414] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [   11.082414] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [   11.084459] hdc: MWDMA2 mode selected
> [   11.084459] hdc: MWDMA2 mode selected
> [   11.085762] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [   11.085762] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> 
> [   11.087260] ide1 at 0x170-0x177,0x376 on irq 15
> [   11.087260] ide1 at 0x170-0x177,0x376 on irq 15
> 
> [   11.112963] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [   11.112963] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [   11.115768] ide-cd driver 5.00
> [   11.115768] ide-cd driver 5.00
> [   11.117454] ide-cd: hdc: ATAPI
> [   11.117454] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB Cache
> , 512kB Cache
> [   11.119217] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   11.119217] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   11.174722] rdac: device handler registered
> [   11.174722] rdac: device handler registered
> [   11.202054] hp_sw: device handler registered
> [   11.202054] hp_sw: device handler registered
> [   11.203384] emc: device handler registered
> [   11.203384] emc: device handler registered
> [   11.204612] alua: device handler registered
> [   11.204612] alua: device handler registered
> [   11.205852] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [   11.205852] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [   11.208110] osst :I: Tape driver with OnStream support version 0.99.4
> [   11.208110] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [   11.208110] osst :I: Tape driver with OnStream support version 0.99.4
> [   11.208110] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [   11.241084] SCSI Media Changer driver v0.25 
> [   11.241084] SCSI Media Changer driver v0.25 
> [   11.263227] osd: LOADED open-osd 0.2.1
> [   11.263227] osd: LOADED open-osd 0.2.1
> [   11.292335] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [   11.292335] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [   11.596438] SSFDC read-only Flash Translation layer
> [   11.596438] SSFDC read-only Flash Translation layer
> [   11.622028] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [   11.622028] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [   11.625289] slram: not enough parameters.
> [   11.625289] slram: not enough parameters.
> [   11.793631] parport0: AVR Butterfly
> [   11.793631] parport0: AVR Butterfly
> [   11.795023] parport0: cannot grant exclusive access for device spi-lm70llp
> [   11.795023] parport0: cannot grant exclusive access for device spi-lm70llp
> [   11.797239] spi-lm70llp: spi_lm70llp probe fail, status -12
> [   11.797239] spi-lm70llp: spi_lm70llp probe fail, status -12
> [   11.842554] vcan: Virtual CAN interface driver
> [   11.842554] vcan: Virtual CAN interface driver
> [   11.844082] slcan: serial line CAN interface driver
> [   11.844082] slcan: serial line CAN interface driver
> [   11.845618] slcan: 10 dynamic interface channels.
> [   11.845618] slcan: 10 dynamic interface channels.
> [   11.847110] CAN device driver interface
> [   11.847110] CAN device driver interface
> [   11.848342] sja1000 CAN netdevice driver
> [   11.848342] sja1000 CAN netdevice driver
> [   11.849630] sja1000_isa: insufficient parameters supplied
> [   11.849630] sja1000_isa: insufficient parameters supplied
> [   11.872584] cc770: CAN netdevice driver
> [   11.872584] cc770: CAN netdevice driver
> [   11.873863] cc770_isa: insufficient parameters supplied
> [   11.873863] cc770_isa: insufficient parameters supplied
> [   11.964587] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   11.964587] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   11.992358] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   11.992358] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   12.000050] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   12.000050] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   12.022183] parport0: cannot grant exclusive access for device parkbd
> [   12.022183] parport0: cannot grant exclusive access for device parkbd
> [   12.025714] mousedev: PS/2 mouse device common for all mice
> [   12.025714] mousedev: PS/2 mouse device common for all mice
> [   12.055059] ideapad_slidebar: DMI does not match
> [   12.055059] ideapad_slidebar: DMI does not match
> [   12.056539] I2O subsystem v1.325
> [   12.056539] I2O subsystem v1.325
> [   12.057567] i2o: max drivers = 8
> [   12.057567] i2o: max drivers = 8
> [   12.082483] I2O Configuration OSM v1.323
> [   12.082483] I2O Configuration OSM v1.323
> [   12.084227] I2O Bus Adapter OSM v1.317
> [   12.084227] I2O Bus Adapter OSM v1.317
> [   12.085618] I2O SCSI Peripheral OSM v1.316
> [   12.085618] I2O SCSI Peripheral OSM v1.316
> [   12.113530] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [   12.113530] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [   12.116370] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [   12.116370] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [   12.119101] i2c /dev entries driver
> [   12.119101] i2c /dev entries driver
> [   12.143131] i2c-parport: adapter type unspecified
> [   12.143131] i2c-parport: adapter type unspecified
> [   12.144646] i2c-parport-light: adapter type unspecified
> [   12.144646] i2c-parport-light: adapter type unspecified
> [   12.147343] pps pps0: new PPS source ktimer
> [   12.147343] pps pps0: new PPS source ktimer
> [   12.148666] pps pps0: ktimer PPS source registered
> [   12.148666] pps pps0: ktimer PPS source registered
> [   12.150199] pps_parport: parallel port PPS client
> [   12.150199] pps_parport: parallel port PPS client
> [   12.151688] parport0: cannot grant exclusive access for device pps_parport
> [   12.151688] parport0: cannot grant exclusive access for device pps_parport
> [   12.174210] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> [   12.174210] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> [   12.177238] pps_parport: couldn't register with parport0
> [   12.177238] pps_parport: couldn't register with parport0
> [   12.180231] power_supply test_ac: uevent
> [   12.180231] power_supply test_ac: uevent
> [   12.181476] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [   12.181476] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [   12.203783] power_supply test_ac: prop ONLINE=1
> [   12.203783] power_supply test_ac: prop ONLINE=1
> [   12.205262] power_supply test_ac: power_supply_changed
> [   12.205262] power_supply test_ac: power_supply_changed
> [   12.207053] power_supply test_ac: power_supply_changed_work
> [   12.207053] power_supply test_ac: power_supply_changed_work
> [   12.208932] power_supply test_ac: uevent
> [   12.208932] power_supply test_ac: uevent
> [   12.210194] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [   12.210194] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [   12.233481] power_supply test_battery: uevent
> [   12.233481] power_supply test_battery: uevent
> [   12.234879] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [   12.234879] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [   12.236906] power_supply test_battery: prop STATUS=Discharging
> [   12.236906] power_supply test_battery: prop STATUS=Discharging
> [   12.238720] power_supply test_battery: prop CHARGE_TYPE=Fast
> [   12.238720] power_supply test_battery: prop CHARGE_TYPE=Fast
> [   12.240560] power_supply test_ac: prop ONLINE=1
> [   12.240560] power_supply test_ac: prop ONLINE=1
> [   12.262263] power_supply test_battery: prop HEALTH=Good
> [   12.262263] power_supply test_battery: prop HEALTH=Good
> [   12.263931] power_supply test_battery: prop PRESENT=1
> [   12.263931] power_supply test_battery: prop PRESENT=1
> [   12.265558] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [   12.265558] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [   12.267382] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [   12.267382] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [   12.269357] power_supply test_battery: prop CHARGE_FULL=100
> [   12.269357] power_supply test_battery: prop CHARGE_FULL=100
> [   12.271243] power_supply test_battery: prop CHARGE_NOW=50
> [   12.271243] power_supply test_battery: prop CHARGE_NOW=50
> [   12.293311] power_supply test_battery: prop CAPACITY=50
> [   12.293311] power_supply test_battery: prop CAPACITY=50
> [   12.295026] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [   12.295026] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [   12.296985] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [   12.296985] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [   12.298995] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [   12.298995] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [   12.301005] power_supply test_battery: prop MODEL_NAME=Test battery
> [   12.301005] power_supply test_battery: prop MODEL_NAME=Test battery
> [   12.323349] power_supply test_battery: prop MANUFACTURER=Linux
> [   12.323349] power_supply test_battery: prop MANUFACTURER=Linux
> [   12.325200] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00025-g499c632
> [   12.325200] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00025-g499c632
> [   12.327632] power_supply test_battery: prop TEMP=26
> [   12.327632] power_supply test_battery: prop TEMP=26
> [   12.329158] power_supply test_battery: prop VOLTAGE_NOW=3300
> [   12.329158] power_supply test_battery: prop VOLTAGE_NOW=3300
> [   12.352346] power_supply test_battery: power_supply_changed
> [   12.352346] power_supply test_battery: power_supply_changed
> [   12.354457] power_supply test_battery: power_supply_changed_work
> [   12.354457] power_supply test_battery: power_supply_changed_work
> [   12.356446] power_supply test_battery: uevent
> [   12.356446] power_supply test_battery: uevent
> [   12.357876] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [   12.357876] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [   12.359978] power_supply test_battery: prop STATUS=Discharging
> [   12.359978] power_supply test_battery: prop STATUS=Discharging
> [   12.383694] power_supply test_usb: uevent
> [   12.383694] power_supply test_usb: uevent
> [   12.385024] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [   12.385024] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [   12.386886] power_supply test_usb: prop ONLINE=1
> [   12.386886] power_supply test_usb: prop ONLINE=1
> [   12.388407] power_supply test_usb: power_supply_changed
> [   12.388407] power_supply test_usb: power_supply_changed
> [   12.390156] power_supply test_battery: prop CHARGE_TYPE=Fast
> [   12.390156] power_supply test_battery: prop CHARGE_TYPE=Fast
> [   12.416163] applesmc: supported laptop not found!
> [   12.416163] applesmc: supported laptop not found!
> [   12.417518] applesmc: driver init failed (ret=-19)!
> [   12.417518] applesmc: driver init failed (ret=-19)!
> [   12.420060] f71882fg: Not a Fintek device
> [   12.420060] f71882fg: Not a Fintek device
> [   12.421371] f71882fg: Not a Fintek device
> [   12.421371] f71882fg: Not a Fintek device
> [   12.442940] power_supply test_battery: prop HEALTH=Good
> [   12.442940] power_supply test_battery: prop HEALTH=Good
> [   12.444541] power_supply test_battery: prop PRESENT=1
> [   12.444541] power_supply test_battery: prop PRESENT=1
> [   12.446005] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [   12.446005] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [   12.447701] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [   12.447701] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [   12.449489] power_supply test_battery: prop CHARGE_FULL=100
> [   12.449489] power_supply test_battery: prop CHARGE_FULL=100
> [   12.470076] power_supply test_battery: prop CHARGE_NOW=50
> [   12.470076] power_supply test_battery: prop CHARGE_NOW=50
> [   12.471795] power_supply test_battery: prop CAPACITY=50
> [   12.471795] power_supply test_battery: prop CAPACITY=50
> [   12.492904] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [   12.492904] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [   12.494891] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [   12.494891] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [   12.496827] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [   12.496827] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [   12.498751] power_supply test_battery: prop MODEL_NAME=Test battery
> [   12.498751] power_supply test_battery: prop MODEL_NAME=Test battery
> [   12.529476] Bluetooth: Virtual HCI driver ver 1.4
> [   12.529476] Bluetooth: Virtual HCI driver ver 1.4
> [   12.553111] power_supply test_battery: prop MANUFACTURER=Linux
> [   12.553111] power_supply test_battery: prop MANUFACTURER=Linux
> [   12.554895] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00025-g499c632
> [   12.554895] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00025-g499c632
> [   12.557208] power_supply test_battery: prop TEMP=26
> [   12.557208] power_supply test_battery: prop TEMP=26
> [   12.558690] power_supply test_battery: prop VOLTAGE_NOW=3300
> [   12.558690] power_supply test_battery: prop VOLTAGE_NOW=3300
> [   12.560716] power_supply test_usb: power_supply_changed_work
> [   12.560716] power_supply test_usb: power_supply_changed_work
> [   12.585426] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [   12.585426] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [   12.587536] EDAC DEBUG: i5000_init: MC:
> [   12.587536] EDAC DEBUG: i5000_init: MC:
> [   12.588853] EDAC DEBUG: i7300_init: 
> [   12.588853] EDAC DEBUG: i7300_init: 
> [   12.590532] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [   12.590532] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [   12.601533] power_supply test_usb: uevent
> [   12.601533] power_supply test_usb: uevent
> [   12.603768] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [   12.603768] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [   12.605634] power_supply test_usb: prop ONLINE=1
> [   12.605634] power_supply test_usb: prop ONLINE=1
> [   12.607617] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [   12.607617] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [   12.609732] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [   12.609732] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [   12.624109] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [   12.624109] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [   12.626027] wbsd: Copyright(c) Pierre Ossman
> [   12.626027] wbsd: Copyright(c) Pierre Ossman
> [   12.656157] leds_ss4200: no LED devices found
> [   12.656157] leds_ss4200: no LED devices found
> [   12.711674] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [   12.711674] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [   12.721706] hidraw: raw HID events driver (C) Jiri Kosina
> [   12.721706] hidraw: raw HID events driver (C) Jiri Kosina
> [   12.786884] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.786884] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.789219] I/O, IRQ, DMA and type are mandatory
> [   12.789219] I/O, IRQ, DMA and type are mandatory
> [   12.812959] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.812959] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.815348] ad1848: No ISAPnP cards found, trying standard ones...
> [   12.815348] ad1848: No ISAPnP cards found, trying standard ones...
> [   12.817290] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.817290] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [   12.819706] I/O, IRQ, DMA and type are mandatory
> [   12.819706] I/O, IRQ, DMA and type are mandatory
> [   12.821094] sb: Init: Starting Probe...
> [   12.821094] sb: Init: Starting Probe...
> [   12.842980] sb: Init: Done
> [   12.842980] sb: Init: Done
> [   12.844004] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [   12.844004] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [   12.846559] uart6850: irq and io must be set.
> [   12.846559] uart6850: irq and io must be set.
> [   12.847941] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [   12.847941] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [   12.872738] MIDI Loopback device driver
> [   12.872738] MIDI Loopback device driver
> [   12.880742] NET: Registered protocol family 17
> [   12.880742] NET: Registered protocol family 17
> [   12.963181] NET: Registered protocol family 15
> [   12.963181] NET: Registered protocol family 15
> [   12.964637] NET: Registered protocol family 4
> [   12.964637] NET: Registered protocol family 4
> [   12.965964] NET: Registered protocol family 9
> [   12.965964] NET: Registered protocol family 9
> [   12.967230] X25: Linux Version 0.2
> [   12.967230] X25: Linux Version 0.2
> [   12.968219] can: controller area network core (rev 20120528 abi 9)
> [   12.968219] can: controller area network core (rev 20120528 abi 9)
> [   13.012925] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [   13.012925] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [   13.015055] NET: Registered protocol family 29
> [   13.015055] NET: Registered protocol family 29
> [   13.016491] can: raw protocol (rev 20120528)
> [   13.016491] can: raw protocol (rev 20120528)
> [   13.017929] can: broadcast manager protocol (rev 20120528 t)
> [   13.017929] can: broadcast manager protocol (rev 20120528 t)
> [   13.019677] IrCOMM protocol (Dag Brattli)
> [   13.019677] IrCOMM protocol (Dag Brattli)
> [   13.120038] Bluetooth: RFCOMM TTY layer initialized
> [   13.120038] Bluetooth: RFCOMM TTY layer initialized
> [   13.121396] Bluetooth: RFCOMM socket layer initialized
> [   13.121396] Bluetooth: RFCOMM socket layer initialized
> [   13.130451] Bluetooth: RFCOMM ver 1.11
> [   13.130451] Bluetooth: RFCOMM ver 1.11
> [   13.131827] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   13.131827] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   13.143494] Bluetooth: BNEP filters: protocol multicast
> [   13.143494] Bluetooth: BNEP filters: protocol multicast
> [   13.144931] Bluetooth: BNEP socket layer initialized
> [   13.144931] Bluetooth: BNEP socket layer initialized
> [   13.146263] 8021q: 802.1Q VLAN Support v1.8
> [   13.146263] 8021q: 802.1Q VLAN Support v1.8
> [   13.147952] 9pnet: Installing 9P2000 support
> [   13.147952] 9pnet: Installing 9P2000 support
> [   13.149208] NET: Registered protocol family 37
> [   13.149208] NET: Registered protocol family 37
> [   13.180281] Key type dns_resolver registered
> [   13.180281] Key type dns_resolver registered
> [   13.181588] openvswitch: Open vSwitch switching datapath
> [   13.181588] openvswitch: Open vSwitch switching datapath
> [   13.183397] mpls_gso: MPLS GSO support
> [   13.183397] mpls_gso: MPLS GSO support
> [   13.185370] 
> [   13.185370] printing PIC contents
> [   13.185370] 
> [   13.185370] printing PIC contents
> [   13.210205] ... PIC  IMR: ffff
> [   13.210205] ... PIC  IMR: ffff
> [   13.211053] ... PIC  IRR: 9013
> [   13.211053] ... PIC  IRR: 9013
> [   13.211932] ... PIC  ISR: 0000
> [   13.211932] ... PIC  ISR: 0000
> [   13.220387] ... PIC ELCR: 0c00
> [   13.220387] ... PIC ELCR: 0c00
> [   13.221450] printing local APIC contents on CPU#0/0:
> [   13.221450] printing local APIC contents on CPU#0/0:
> [   13.230024] ... APIC ID:      00000000 (0)
> [   13.230024] ... APIC ID:      00000000 (0)
> [   13.230024] ... APIC VERSION: 01050014
> [   13.230024] ... APIC VERSION: 01050014
> [   13.230024] ... APIC TASKPRI: 00000000 (00)
> [   13.230024] ... APIC TASKPRI: 00000000 (00)
> [   13.230024] ... APIC PROCPRI: 00000000
> [   13.230024] ... APIC PROCPRI: 00000000
> [   13.230024] ... APIC LDR: 01000000
> [   13.230024] ... APIC LDR: 01000000
> [   13.230024] ... APIC DFR: ffffffff
> [   13.230024] ... APIC DFR: ffffffff
> [   13.230024] ... APIC SPIV: 000001ff
> [   13.230024] ... APIC SPIV: 000001ff
> [   13.230024] ... APIC ISR field:
> [   13.230024] ... APIC ISR field:
> [   13.230024] 00000000
> [   13.230024] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [   13.230024] ... APIC TMR field:
> [   13.230024] ... APIC TMR field:
> [   13.230024] 00000000
> [   13.230024] 000000000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [   13.230024] ... APIC IRR field:
> [   13.230024] ... APIC IRR field:
> [   13.230024] 00000000
> [   13.230024] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000
> 
> [   13.230024] ... APIC ESR: 00000000
> [   13.230024] ... APIC ESR: 00000000
> [   13.230024] ... APIC ICR: 000008fd
> [   13.230024] ... APIC ICR: 000008fd
> [   13.230024] ... APIC ICR2: 02000000
> [   13.230024] ... APIC ICR2: 02000000
> [   13.230024] ... APIC LVTT: 000400ef
> [   13.230024] ... APIC LVTT: 000400ef
> [   13.230024] ... APIC LVTPC: 00010000
> [   13.230024] ... APIC LVTPC: 00010000
> [   13.230024] ... APIC LVT0: 00010700
> [   13.230024] ... APIC LVT0: 00010700
> [   13.230024] ... APIC LVT1: 00000400
> [   13.230024] ... APIC LVT1: 00000400
> [   13.230024] ... APIC LVTERR: 000000fe
> [   13.230024] ... APIC LVTERR: 000000fe
> [   13.230024] ... APIC TMICT: 00000000
> [   13.230024] ... APIC TMICT: 00000000
> [   13.230024] ... APIC TMCCT: 00000000
> [   13.230024] ... APIC TMCCT: 00000000
> [   13.230024] ... APIC TDCR: 00000000
> [   13.230024] ... APIC TDCR: 00000000
> [   13.230024] 
> [   13.230024] 
> [   13.373211] number of MP IRQ sources: 15.
> [   13.373211] number of MP IRQ sources: 15.
> [   13.374454] number of IO-APIC #0 registers: 24.
> [   13.374454] number of IO-APIC #0 registers: 24.
> [   13.375827] testing the IO APIC.......................
> [   13.375827] testing the IO APIC.......................
> [   13.377394] IO APIC #0......
> [   13.377394] IO APIC #0......
> [   13.378275] .... register #00: 00000000
> [   13.378275] .... register #00: 00000000
> [   13.379431] .......    : physical APIC id: 00
> [   13.379431] .......    : physical APIC id: 00
> [   13.380980] .......    : Delivery Type: 0
> [   13.380980] .......    : Delivery Type: 0
> [   13.402319] .......    : LTS          : 0
> [   13.402319] .......    : LTS          : 0
> [   13.403603] .... register #01: 00170011
> [   13.403603] .... register #01: 00170011
> [   13.404760] .......     : max redirection entries: 17
> [   13.404760] .......     : max redirection entries: 17
> [   13.406278] .......     : PRQ implemented: 0
> [   13.406278] .......     : PRQ implemented: 0
> [   13.407556] .......     : IO APIC version: 11
> [   13.407556] .......     : IO APIC version: 11
> [   13.408875] .... register #02: 00000000
> [   13.408875] .... register #02: 00000000
> [   13.410151] .......     : arbitration: 00
> [   13.410151] .......     : arbitration: 00
> [   13.411475] .... IRQ redirection table:
> [   13.411475] .... IRQ redirection table:
> [   13.432771] 1    0    0   0   0    0    0    00
> [   13.432771] 1    0    0   0   0    0    0    00
> [   13.434155] 0    0    0   0   0    1    1    31
> [   13.434155] 0    0    0   0   0    1    1    31
> [   13.435516] 0    0    0   0   0    1    1    30
> [   13.435516] 0    0    0   0   0    1    1    30
> [   13.436856] 0    0    0   0   0    1    1    33
> [   13.436856] 0    0    0   0   0    1    1    33
> [   13.438202] 1    0    0   0   0    1    1    34
> [   13.438202] 1    0    0   0   0    1    1    34
> [   13.439558] 1    1    0   0   0    1    1    35
> [   13.439558] 1    1    0   0   0    1    1    35
> [   13.441147] 0    0    0   0   0    1    1    36
> [   13.441147] 0    0    0   0   0    1    1    36
> [   13.462623] 0    0    0   0   0    1    1    37
> [   13.462623] 0    0    0   0   0    1    1    37
> [   13.464084] 0    0    0   0   0    1    1    38
> [   13.464084] 0    0    0   0   0    1    1    38
> [   13.465578] 0    1    0   0   0    1    1    39
> [   13.465578] 0    1    0   0   0    1    1    39
> [   13.467080] 1    1    0   0   0    1    1    3A
> [   13.467080] 1    1    0   0   0    1    1    3A
> [   13.468566] 1    1    0   0   0    1    1    3B
> [   13.468566] 1    1    0   0   0    1    1    3B
> [   13.470079] 0    0    0   0   0    1    1    3C
> [   13.470079] 0    0    0   0   0    1    1    3C
> [   13.471461] 0    0    0   0   0    1    1    3D
> [   13.471461] 0    0    0   0   0    1    1    3D
> [   13.493053] 0    0    0   0   0    1    1    3E
> [   13.493053] 0    0    0   0   0    1    1    3E
> [   13.494509] 0    0    0   0   0    1    1    3F
> [   13.494509] 0    0    0   0   0    1    1    3F
> [   13.496022] 1    0    0   0   0    0    0    00
> [   13.496022] 1    0    0   0   0    0    0    00
> [   13.497451] 1    0    0   0   0    0    0    00
> [   13.497451] 1    0    0   0   0    0    0    00
> [   13.498872] 1    0    0   0   0    0    0    00
> [   13.498872] 1    0    0   0   0    0    0    00
> [   13.500281] 1    0    0   0   0    0    0    00
> [   13.500281] 1    0    0   0   0    0    0    00
> [   13.501637] 1    0    0   0   0    0    0    00
> [   13.501637] 1    0    0   0   0    0    0    00
> [   13.523330] 1    0    0   0   0    0    0    00
> [   13.523330] 1    0    0   0   0    0    0    00
> [   13.524867] 1    0    0   0   0    0    0    00
> [   13.524867] 1    0    0   0   0    0    0    00
> [   13.526392] 1    0    0   0   0    0    0    00
> [   13.526392] 1    0    0   0   0    0    0    00
> [   13.527909] IRQ to pin mappings:
> [   13.527909] IRQ to pin mappings:
> [   13.529687] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
> [   13.529687] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
> [   13.552569] IRQ0 
> [   13.552569] IRQ0 -> 0:2-> 0:2
> 
> [   13.553369] IRQ1 
> [   13.553369] IRQ1 -> 0:1-> 0:1
> 
> [   13.554172] IRQ3 
> [   13.554172] IRQ3 -> 0:3-> 0:3
> 
> [   13.554919] IRQ4 
> [   13.554919] IRQ4 -> 0:4-> 0:4
> 
> [   13.555712] IRQ5 
> [   13.555712] IRQ5 -> 0:5-> 0:5
> 
> [   13.556525] IRQ6 
> [   13.556525] IRQ6 -> 0:6-> 0:6
> 
> [   13.557319] IRQ7 
> [   13.557319] IRQ7 -> 0:7-> 0:7
> 
> [   13.558085] IRQ8 
> [   13.558085] IRQ8 -> 0:8-> 0:8
> 
> [   13.558851] IRQ9 
> [   13.558851] IRQ9 -> 0:9-> 0:9
> 
> [   13.559614] IRQ10 
> [   13.559614] IRQ10 -> 0:10-> 0:10
> 
> [   13.560624] IRQ11 
> [   13.560624] IRQ11 -> 0:11-> 0:11
> 
> [   13.561520] IRQ12 
> [   13.561520] IRQ12 -> 0:12-> 0:12
> 
> [   13.591330] IRQ13 
> [   13.591330] IRQ13 -> 0:13-> 0:13
> 
> [   13.592252] IRQ14 
> [   13.592252] IRQ14 -> 0:14-> 0:14
> 
> [   13.603235] IRQ15 
> [   13.603235] IRQ15 -> 0:15-> 0:15
> 
> [   13.604164] .................................... done.
> [   13.604164] .................................... done.
> [   13.607070] bootconsole [earlyser0] disabled
> [   13.607070] bootconsole [earlyser0] disabled
> [   13.608490] Loading compiled-in X.509 certificates
> [   13.609301] registered taskstats version 1
> [   13.640167] Running tests on trace events:
> [   13.640761] Testing event kvm_async_pf_completed: 
> [   13.740054] test-events (221) used greatest stack depth: 6248 bytes left
> [   13.751970] OK
> [   13.752282] Testing event kvm_async_pf_ready: OK
> [   13.833104] Testing event kvm_async_pf_not_present: OK
> [   13.940104] Testing event kvm_async_pf_doublefault: OK
> [   14.030106] Testing event kvm_try_async_get_page: OK
> [   14.152120] Testing event kvm_age_page: OK
> [   14.243127] Testing event kvm_fpu: OK
> [   14.290517] Testing event kvm_mmio: OK
> [   14.360460] Testing event kvm_ack_irq: OK
> [   14.415604] Testing event kvm_msi_set_irq: OK
> [   14.460666] Testing event kvm_ioapic_set_irq: OK
> [   14.522868] Testing event kvm_set_irq: OK
> [   14.570499] Testing event kvm_userspace_exit: OK
> [   14.610575] Testing event kvm_track_tsc: OK
> [   14.662508] Testing event kvm_update_master_clock: OK
> [   14.703873] Testing event kvm_write_tsc_offset: OK
> [   14.756011] Testing event vcpu_match_mmio: OK
> [   14.800508] Testing event kvm_emulate_insn: OK
> [   14.860301] Testing event kvm_skinit: OK
> [   14.900377] Testing event kvm_invlpga: OK
> [   14.954107] Testing event kvm_nested_intr_vmexit: OK
> [   15.010411] Testing event kvm_nested_vmexit_inject: OK
> [   15.063339] Testing event kvm_nested_vmexit: OK
> [   15.135962] Testing event kvm_nested_intercepts: OK
> [   15.172912] Testing event kvm_nested_vmrun: OK
> [   15.233156] Testing event kvm_pv_eoi: OK
> [   15.295969] Testing event kvm_eoi: OK
> [   15.355483] Testing event kvm_apic_accept_irq: OK
> [   15.413177] Testing event kvm_apic_ipi: OK
> [   15.476319] Testing event kvm_pic_set_irq: OK
> [   15.520549] Testing event kvm_cr: OK
> [   15.560352] Testing event kvm_msr: OK
> [   15.613200] Testing event kvm_page_fault: OK
> [   15.677591] Testing event kvm_inj_exception: OK
> [   15.713044] Testing event kvm_inj_virq: OK
> [   15.750340] Testing event kvm_exit: OK
> [   15.800394] Testing event kvm_apic: OK
> [   15.840365] Testing event kvm_cpuid: OK
> [   15.910358] Testing event kvm_pio: OK
> [   15.960387] Testing event kvm_hv_hypercall: OK
> [   16.006319] Testing event kvm_hypercall: OK
> [   16.055594] Testing event kvm_entry: OK
> [   16.106431] Testing event check_mmio_spte: OK
> [   16.165937] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [   16.216021] Testing event fast_page_fault: OK
> [   16.255565] Testing event handle_mmio_page_fault: OK
> [   16.305998] Testing event mark_mmio_spte: OK
> [   16.360414] Testing event kvm_mmu_prepare_zap_page: OK
> [   16.420359] Testing event kvm_mmu_unsync_page: OK
> [   16.474066] Testing event kvm_mmu_sync_page: OK
> [   16.520326] Testing event kvm_mmu_get_page: OK
> [   16.572773] Testing event kvm_mmu_walker_error: OK
> [   16.613235] Testing event kvm_mmu_set_dirty_bit: OK
> [   16.667418] Testing event kvm_mmu_set_accessed_bit: OK
> [   16.713223] Testing event kvm_mmu_paging_element: OK
> [   16.760893] Testing event kvm_mmu_pagetable_walk: OK
> [   16.813210] Testing event thermal_apic_exit: OK
> [   16.853248] Testing event thermal_apic_entry: OK
> [   16.893212] Testing event threshold_apic_exit: OK
> [   16.933228] Testing event threshold_apic_entry: OK
> [   16.973295] Testing event call_function_single_exit: OK
> [   17.013269] Testing event call_function_single_entry: OK
> [   17.050564] Testing event call_function_exit: 
> [   17.100371] test-events (284) used greatest stack depth: 5832 bytes left
> [   17.100375] OK
> [   17.150342] Testing event call_function_entry: OK
> [   17.151076] Testing event irq_work_exit: OK
> [   17.190498] Testing event irq_work_entry: OK
> [   17.230565] Testing event x86_platform_ipi_exit: OK
> [   17.270600] Testing event x86_platform_ipi_entry: OK
> [   17.310559] Testing event error_apic_exit: OK
> [   17.350566] Testing event error_apic_entry: OK
> [   17.400530] Testing event spurious_apic_exit: OK
> [   17.440514] Testing event spurious_apic_entry: OK
> [   17.480483] Testing event reschedule_exit: OK
> [   17.520390] Testing event reschedule_entry: OK
> [   17.560423] Testing event local_timer_exit: OK
> [   17.600432] Testing event local_timer_entry: OK
> [   17.640482] Testing event nmi_handler: OK
> [   17.680426] Testing event emulate_vsyscall: OK
> [   17.720414] Testing event sys_exit: OK
> [   17.760466] Testing event sys_enter: OK
> [   17.800449] Testing event page_fault_kernel: OK
> [   17.840354] Testing event page_fault_user: OK
> [   17.880382] Testing event task_rename: OK
> [   17.920370] Testing event task_newtask: OK
> [   17.960368] Testing event softirq_raise: OK
> [   18.000408] Testing event softirq_exit: OK
> [   18.040533] Testing event softirq_entry: OK
> [   18.080438] Testing event irq_handler_exit: OK
> [   18.120394] Testing event irq_handler_entry: OK
> [   18.160405] Testing event itimer_expire: OK
> [   18.200444] Testing event itimer_state: OK
> [   18.240402] Testing event hrtimer_cancel: OK
> [   18.280385] Testing event hrtimer_expire_exit: OK
> [   18.320451] Testing event hrtimer_expire_entry: OK
> [   18.360485] Testing event hrtimer_start: OK
> [   18.400434] Testing event hrtimer_init: OK
> [   18.440429] Testing event timer_cancel: OK
> [   18.480424] Testing event timer_expire_exit: OK
> [   18.520496] Testing event timer_expire_entry: OK
> [   18.560410] Testing event timer_start: OK
> [   18.600417] Testing event timer_init: OK
> [   18.650429] Testing event signal_deliver: OK
> [   18.690419] Testing event signal_generate: OK
> [   18.730438] Testing event workqueue_execute_end: OK
> [   18.770409] Testing event workqueue_execute_start: OK
> [   18.810405] Testing event workqueue_activate_work: OK
> [   18.850384] Testing event workqueue_queue_work: OK
> [   18.891463] Testing event sched_swap_numa: OK
> [   18.930450] Testing event sched_stick_numa: OK
> [   18.970438] Testing event sched_move_numa: OK
> [   19.010468] Testing event sched_process_hang: OK
> [   19.050436] Testing event sched_pi_setprio: OK
> [   19.090415] Testing event sched_stat_runtime: OK
> [   19.130488] Testing event sched_stat_blocked: OK
> [   19.170472] Testing event sched_stat_iowait: OK
> [   19.210394] Testing event sched_stat_sleep: OK
> [   19.250450] Testing event sched_stat_wait: OK
> [   19.290420] Testing event sched_process_exec: OK
> [   19.330432] Testing event sched_process_fork: OK
> [   19.370463] Testing event sched_process_wait: OK
> [   19.410409] Testing event sched_wait_task: OK
> [   19.450416] Testing event sched_process_exit: OK
> [   19.490443] Testing event sched_process_free: OK
> [   19.530400] Testing event sched_migrate_task: OK
> [   19.570518] Testing event sched_switch: OK
> [   19.610492] Testing event sched_wakeup_new: OK
> [   19.650669] Testing event sched_wakeup: OK
> [   19.690546] Testing event sched_kthread_stop_ret: OK
> [   19.730601] Testing event sched_kthread_stop: OK
> [   19.770515] Testing event lock_acquired: OK
> [   19.810645] Testing event lock_contended: OK
> [   19.850422] Testing event lock_release: OK
> [   19.890568] Testing event lock_acquire: OK
> [   19.930502] Testing event console: OK
> [   19.980595] Testing event rcu_utilization: OK
> [   20.020610] Testing event ftrace_test_filter: OK
> [   20.060590] Testing event dev_pm_qos_remove_request: OK
> [   20.100470] Testing event dev_pm_qos_update_request: OK
> [   20.140572] Testing event dev_pm_qos_add_request: OK
> [   20.180471] Testing event pm_qos_update_flags: OK
> [   20.220542] Testing event pm_qos_update_target: OK
> [   20.260458] Testing event pm_qos_update_request_timeout: OK
> [   20.300545] Testing event pm_qos_remove_request: OK
> [   20.340423] Testing event pm_qos_update_request: OK
> [   20.380511] Testing event pm_qos_add_request: OK
> [   20.420392] Testing event power_domain_target: OK
> [   20.460509] Testing event clock_set_rate: OK
> [   20.500457] Testing event clock_disable: OK
> [   20.540340] Testing event clock_enable: OK
> [   20.580325] Testing event wakeup_source_deactivate: OK
> [   20.620368] Testing event wakeup_source_activate: OK
> [   20.660392] Testing event device_pm_report_time: OK
> [   20.700381] Testing event machine_suspend: OK
> [   20.740401] Testing event cpu_frequency: OK
> [   20.780384] Testing event pstate_sample: OK
> [   20.820414] Testing event cpu_idle: OK
> [   20.860391] Testing event user_exit: OK
> [   20.900404] Testing event user_enter: OK
> [   20.940378] Testing event mm_filemap_add_to_page_cache: OK
> [   20.980412] Testing event mm_filemap_delete_from_page_cache: OK
> [   21.020377] Testing event oom_score_adj_update: OK
> [   21.060401] Testing event mm_lru_activate: OK
> [   21.110501] Testing event mm_lru_insertion: OK
> [   21.150442] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   21.190328] Testing event mm_vmscan_writepage: OK
> [   21.230354] Testing event mm_vmscan_memcg_isolate: OK
> [   21.270319] Testing event mm_vmscan_lru_isolate: OK
> [   21.310332] Testing event mm_shrink_slab_end: OK
> [   21.350417] Testing event mm_shrink_slab_start: OK
> [   21.390355] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   21.430409] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   21.470527] Testing event mm_vmscan_direct_reclaim_end: OK
> [   21.510526] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   21.550448] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   21.590616] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   21.630408] Testing event mm_vmscan_wakeup_kswapd: OK
> [   21.670559] Testing event mm_vmscan_kswapd_wake: OK
> [   21.710381] Testing event mm_vmscan_kswapd_sleep: OK
> [   21.750570] Testing event mm_page_alloc_extfrag: OK
> [   21.790417] Testing event mm_page_pcpu_drain: OK
> [   21.830580] Testing event mm_page_alloc_zone_locked: OK
> [   21.870412] Testing event mm_page_alloc: OK
> [   21.910569] Testing event mm_page_free_batched: OK
> [   21.950383] Testing event mm_page_free: OK
> [   21.990532] Testing event kmem_cache_free: OK
> [   22.030407] Testing event kfree: OK
> [   22.070551] Testing event kmem_cache_alloc_node: OK
> [   22.110412] Testing event kmalloc_node: OK
> [   22.160906] Testing event kmem_cache_alloc: OK
> [   22.200443] Testing event kmalloc: OK
> [   22.250528] Testing event mm_compaction_end: OK
> [   22.290415] Testing event mm_compaction_begin: OK
> [   22.330547] Testing event mm_compaction_migratepages: OK
> [   22.370411] Testing event mm_compaction_isolate_freepages: OK
> [   22.420526] Testing event mm_compaction_isolate_migratepages: OK
> [   22.460445] Testing event mm_numa_migrate_ratelimit: OK
> [   22.500547] Testing event mm_migrate_pages: OK
> [   22.540433] Testing event writeback_single_inode: OK
> [   22.580515] Testing event writeback_single_inode_start: OK
> [   22.620436] Testing event writeback_wait_iff_congested: OK
> [   22.660511] Testing event writeback_congestion_wait: OK
> [   22.700447] Testing event writeback_sb_inodes_requeue: OK
> [   22.740535] Testing event balance_dirty_pages: OK
> [   22.780412] Testing event bdi_dirty_ratelimit: OK
> [   22.820548] Testing event global_dirty_state: OK
> [   22.860450] Testing event writeback_queue_io: OK
> [   22.900566] Testing event wbc_writepage: OK
> [   22.940446] Testing event writeback_bdi_unregister: OK
> [   22.980575] Testing event writeback_bdi_register: OK
> [   23.020549] Testing event writeback_wake_background: OK
> [   23.060705] Testing event writeback_nowork: OK
> [   23.100517] Testing event writeback_pages_written: OK
> [   23.140702] Testing event writeback_wait: OK
> [   23.190587] Testing event writeback_written: OK
> [   23.230645] Testing event writeback_start: OK
> [   23.280525] Testing event writeback_exec: OK
> [   23.320629] Testing event writeback_queue: OK
> [   23.360501] Testing event writeback_write_inode: OK
> [   23.410620] Testing event writeback_write_inode_start: OK
> [   23.450556] Testing event writeback_dirty_inode: OK
> [   23.490614] Testing event writeback_dirty_inode_start: OK
> [   23.530493] Testing event writeback_dirty_page: OK
> [   23.570708] Testing event jbd2_lock_buffer_stall: OK
> [   23.610469] Testing event jbd2_write_superblock: OK
> [   23.660668] Testing event jbd2_update_log_tail: OK
> [   23.700507] Testing event jbd2_checkpoint_stats: OK
> [   23.740730] Testing event jbd2_run_stats: OK
> [   23.780593] Testing event jbd2_handle_stats: OK
> [   23.820690] Testing event jbd2_handle_extend: OK
> [   23.860490] Testing event jbd2_handle_start: OK
> [   23.900597] Testing event jbd2_submit_inode_data: OK
> [   23.940568] Testing event jbd2_end_commit: OK
> [   23.980622] Testing event jbd2_drop_transaction: OK
> [   24.020561] Testing event jbd2_commit_logging: OK
> [   24.060635] Testing event jbd2_commit_flushing: OK
> [   24.100483] Testing event jbd2_commit_locking: OK
> [   24.150604] Testing event jbd2_start_commit: OK
> [   24.190548] Testing event jbd2_checkpoint: OK
> [   24.230700] Testing event xfs_discard_busy: OK
> [   24.270582] Testing event xfs_discard_exclude: OK
> [   24.320610] Testing event xfs_discard_toosmall: OK
> [   24.360562] Testing event xfs_discard_extent: OK
> [   24.410718] Testing event xfs_log_recover_inode_skip: OK
> [   24.450535] Testing event xfs_log_recover_inode_cancel: OK
> [   24.500671] Testing event xfs_log_recover_inode_recover: OK
> [   24.540582] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   24.590667] Testing event xfs_log_recover_buf_reg_buf: OK
> [   24.630531] Testing event xfs_log_recover_buf_inode_buf: OK
> [   24.670659] Testing event xfs_log_recover_buf_recover: OK
> [   24.710525] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   24.750652] Testing event xfs_log_recover_buf_cancel_add: OK
> [   24.790534] Testing event xfs_log_recover_buf_cancel: OK
> [   24.830656] Testing event xfs_log_recover_buf_not_cancel: OK
> [   24.870538] Testing event xfs_log_recover_item_recover: OK
> [   24.920684] Testing event xfs_log_recover_item_reorder_tail: OK
> [   24.960541] Testing event xfs_log_recover_item_reorder_head: OK
> [   25.000644] Testing event xfs_log_recover_item_add_cont: OK
> [   25.040549] Testing event xfs_log_recover_item_add: OK
> [   25.080385] Testing event xfs_swap_extent_after: OK
> [   25.120461] Testing event xfs_swap_extent_before: OK
> [   25.160406] Testing event xfs_dir2_leafn_moveents: OK
> [   25.200407] Testing event xfs_dir2_shrink_inode: OK
> [   25.240411] Testing event xfs_dir2_grow_inode: OK
> [   25.280451] Testing event xfs_dir2_leafn_remove: OK
> [   25.320418] Testing event xfs_dir2_leafn_add: OK
> [   25.360410] Testing event xfs_da_path_shift: OK
> [   25.400405] Testing event xfs_da_fixhashpath: OK
> [   25.440444] Testing event xfs_da_shrink_inode: OK
> [   25.480400] Testing event xfs_da_grow_inode: OK
> [   25.520396] Testing event xfs_da_swap_lastblock: OK
> [   25.560392] Testing event xfs_da_node_toosmall: OK
> [   25.600401] Testing event xfs_da_node_unbalance: OK
> [   25.640409] Testing event xfs_da_node_rebalance: OK
> [   25.680393] Testing event xfs_da_node_remove: OK
> [   25.720415] Testing event xfs_da_node_split: OK
> [   25.760421] Testing event xfs_da_node_create: OK
> [   25.800404] Testing event xfs_da_node_add: OK
> [   25.840403] Testing event xfs_da_root_join: OK
> [   25.880402] Testing event xfs_da_root_split: OK
> [   25.920397] Testing event xfs_da_unlink_forward: OK
> [   25.960397] Testing event xfs_da_unlink_back: OK
> [   26.000397] Testing event xfs_da_link_after: OK
> [   26.040446] Testing event xfs_da_link_before: OK
> [   26.080423] Testing event xfs_da_join: OK
> [   26.120460] Testing event xfs_da_split: OK
> [   26.160675] Testing event xfs_attr_rmtval_remove: OK
> [   26.200612] Testing event xfs_attr_rmtval_set: OK
> [   26.240685] Testing event xfs_attr_rmtval_get: OK
> [   26.280610] Testing event xfs_attr_refillstate: OK
> [   26.320684] Testing event xfs_attr_fillstate: OK
> [   26.360620] Testing event xfs_attr_node_removename: OK
> [   26.400637] Testing event xfs_attr_node_replace: OK
> [   26.440600] Testing event xfs_attr_node_lookup: OK
> [   26.480660] Testing event xfs_attr_node_get: OK
> [   26.520564] Testing event xfs_attr_node_addname: OK
> [   26.560653] Testing event xfs_attr_leaf_toosmall: OK
> [   26.600576] Testing event xfs_attr_leaf_unbalance: OK
> [   26.640672] Testing event xfs_attr_leaf_rebalance: OK
> [   26.680635] Testing event xfs_attr_leaf_to_node: OK
> [   26.720730] Testing event xfs_attr_leaf_to_sf: OK
> [   26.760620] Testing event xfs_attr_leaf_flipflags: OK
> [   26.800777] Testing event xfs_attr_leaf_setflag: OK
> [   26.840689] Testing event xfs_attr_leaf_clearflag: OK
> [   26.880662] Testing event xfs_attr_leaf_split_after: OK
> [   26.920575] Testing event xfs_attr_leaf_split_before: OK
> [   26.960647] Testing event xfs_attr_leaf_split: OK
> [   27.000943] Testing event xfs_attr_leaf_removename: OK
> [   27.041141] Testing event xfs_attr_leaf_remove: OK
> [   27.086080] Testing event xfs_attr_leaf_replace: OK
> [   27.143743] Testing event xfs_attr_leaf_lookup: OK
> [   27.203449] Testing event xfs_attr_leaf_get: OK
> [   27.243504] Testing event xfs_attr_leaf_compact: OK
> [   27.332519] Testing event xfs_attr_leaf_create: OK
> [   27.393581] Testing event xfs_attr_leaf_addname: OK
> [   27.460397] Testing event xfs_attr_leaf_add_work: OK
> [   27.500355] Testing event xfs_attr_leaf_add_new: OK
> [   27.540372] Testing event xfs_attr_leaf_add_old: OK
> [   27.600458] Testing event xfs_attr_leaf_add: OK
> [   27.640582] Testing event xfs_attr_sf_to_leaf: OK
> [   27.680373] Testing event xfs_attr_sf_removename: OK
> [   27.720800] Testing event xfs_attr_sf_remove: OK
> [   27.760352] Testing event xfs_attr_sf_lookup: OK
> [   27.800365] Testing event xfs_attr_sf_create: OK
> [   27.840355] Testing event xfs_attr_sf_addname: OK
> [   27.910760] Testing event xfs_attr_sf_add: OK
> [   27.950826] Testing event xfs_dir2_node_to_leaf: OK
> [   28.002240] Testing event xfs_dir2_node_removename: OK
> [   28.060523] Testing event xfs_dir2_node_replace: OK
> [   28.120575] Testing event xfs_dir2_node_lookup: OK
> [   28.162103] Testing event xfs_dir2_node_addname: OK
> [   28.202207] Testing event xfs_dir2_leaf_to_node: OK
> [   28.242644] Testing event xfs_dir2_leaf_to_block: OK
> [   28.302552] Testing event xfs_dir2_leaf_removename: OK
> [   28.370372] Testing event xfs_dir2_leaf_replace: OK
> [   28.473353] Testing event xfs_dir2_leaf_lookup: OK
> [   28.574620] Testing event xfs_dir2_leaf_addname: OK
> [   28.635388] Testing event xfs_dir2_block_to_leaf: OK
> [   28.735138] Testing event xfs_dir2_block_to_sf: OK
> [   28.813371] Testing event xfs_dir2_block_removename: OK
> [   28.893390] Testing event xfs_dir2_block_replace: OK
> [   28.973381] Testing event xfs_dir2_block_lookup: OK
> [   29.053398] Testing event xfs_dir2_block_addname: OK
> [   29.155016] Testing event xfs_dir2_sf_to_block: OK
> [   29.217394] Testing event xfs_dir2_sf_toino8: OK
> [   29.260376] Testing event xfs_dir2_sf_toino4: OK
> [   29.323589] Testing event xfs_dir2_sf_removename: OK
> [   29.383494] Testing event xfs_dir2_sf_replace: OK
> [   29.462956] Testing event xfs_dir2_sf_lookup: OK
> [   29.531404] Testing event xfs_dir2_sf_create: OK
> [   29.610365] Testing event xfs_dir2_sf_addname: OK
> [   29.693411] Testing event xfs_alloc_vextent_allfailed: OK
> [   29.782367] Testing event xfs_alloc_vextent_loopfailed: OK
> [   29.904879] Testing event xfs_alloc_vextent_noagbp: OK
> [   29.983441] Testing event xfs_alloc_vextent_nofix: OK
> [   30.070599] Testing event xfs_alloc_vextent_badargs: OK
> [   30.140361] Testing event xfs_alloc_small_error: OK
> [   30.243291] Testing event xfs_alloc_small_done: OK
> [   30.302530] Testing event xfs_alloc_small_notenough: OK
> [   30.380469] Testing event xfs_alloc_small_freelist: OK
> [   30.493412] Testing event xfs_alloc_size_busy: OK
> [   30.590426] Testing event xfs_alloc_size_error: OK
> [   30.693437] Testing event xfs_alloc_size_done: OK
> [   30.783366] Testing event xfs_alloc_size_nominleft: OK
> [   30.873436] Testing event xfs_alloc_size_noentry: OK
> [   30.960328] Testing event xfs_alloc_size_neither: OK
> [   31.010481] Testing event xfs_alloc_near_busy: OK
> [   31.070371] Testing event xfs_alloc_near_noentry: OK
> [   31.130479] Testing event xfs_alloc_near_error: OK
> [   31.180587] Testing event xfs_alloc_near_lesser: OK
> [   31.260513] Testing event xfs_alloc_near_greater: OK
> [   31.310499] Testing event xfs_alloc_near_first: OK
> [   31.350481] Testing event xfs_alloc_near_nominleft: OK
> [   31.411493] Testing event xfs_alloc_exact_error: OK
> [   31.452727] Testing event xfs_alloc_exact_notfound: OK
> [   31.520262] Testing event xfs_alloc_exact_done: OK
> [   31.560412] Testing event xfs_free_extent: OK
> [   31.622536] Testing event xfs_agf: OK
> [   31.682554] Testing event xfs_trans_commit_lsn: OK
> [   31.833393] Testing event xfs_extent_busy_trim: OK
> [   31.992462] Testing event xfs_extent_busy_clear: OK
> [   32.092408] Testing event xfs_extent_busy_reuse: OK
> [   32.220439] Testing event xfs_extent_busy_force: OK
> [   32.313345] Testing event xfs_extent_busy_enomem: OK
> [   32.343423] Testing event xfs_extent_busy: OK
> [   32.433344] Testing event xfs_bunmap: OK
> [   32.502489] Testing event xfs_pagecache_inval: OK
> [   32.612386] Testing event xfs_itruncate_extents_end: OK
> [   32.723395] Testing event xfs_itruncate_extents_start: OK
> [   32.843501] Testing event xfs_setfilesize: OK
> [   32.902700] Testing event xfs_get_blocks_notfound: OK
> [   32.983462] Testing event xfs_unwritten_convert: OK
> [   33.123599] Testing event xfs_delalloc_enospc: OK
> [   33.172571] Testing event xfs_get_blocks_alloc: OK
> [   33.304609] Testing event xfs_get_blocks_found: OK
> [   33.362682] Testing event xfs_map_blocks_alloc: OK
> [   33.422502] Testing event xfs_map_blocks_found: OK
> [   33.482510] Testing event xfs_invalidatepage: OK
> [   33.542475] Testing event xfs_releasepage: OK
> [   33.593615] Testing event xfs_writepage: OK
> [   33.663374] Testing event xfs_file_splice_write: OK
> [   33.703435] Testing event xfs_file_splice_read: OK
> [   33.743406] Testing event xfs_file_direct_write: OK
> [   33.827359] Testing event xfs_file_buffered_write: OK
> [   33.912501] Testing event xfs_file_read: OK
> [   34.025420] Testing event xfs_log_assign_tail_lsn: OK
> [   34.083783] Testing event xfs_ail_delete: OK
> [   34.151444] Testing event xfs_ail_move: OK
> [   34.303637] Testing event xfs_ail_insert: OK
> [   34.402477] Testing event xfs_ail_flushing: OK
> [   34.522592] Testing event xfs_ail_locked: OK
> [   34.617552] Testing event xfs_ail_pinned: OK
> [   34.676810] Testing event xfs_ail_push: OK
> [   34.737435] Testing event xfs_log_force: OK
> [   34.797365] Testing event xfs_log_ungrant_sub: OK
> [   34.850875] Testing event xfs_log_ungrant_exit: OK
> [   34.932646] Testing event xfs_log_ungrant_enter: OK
> [   35.013648] Testing event xfs_log_regrant_reserve_sub: OK
> [   35.108402] Testing event xfs_log_regrant_reserve_exit: OK
> [   35.163395] Testing event xfs_log_regrant_reserve_enter: OK
> [   35.220310] Testing event xfs_log_regrant_exit: OK
> [   35.298798] Testing event xfs_log_regrant: OK
> [   35.368773] Testing event xfs_log_reserve_exit: OK
> [   35.442323] Testing event xfs_log_reserve: OK
> [   35.518762] Testing event xfs_log_grant_wake_up: OK
> [   35.588781] Testing event xfs_log_grant_wake: OK
> [   35.659194] Testing event xfs_log_grant_sleep: OK
> [   35.738807] Testing event xfs_log_umount_write: OK
> [   35.793233] Testing event xfs_log_done_perm: OK
> [   35.832499] Testing event xfs_log_done_nonperm: OK
> [   35.895740] Testing event xfs_dqflush_done: OK
> [   35.955433] Testing event xfs_dqflush_force: OK
> [   36.022275] Testing event xfs_dqflush: OK
> [   36.088502] Testing event xfs_dqrele: OK
> [   36.158853] Testing event xfs_dqput_free: OK
> [   36.214798] Testing event xfs_dqput_wait: OK
> [   36.260577] Testing event xfs_dqput: OK
> [   36.301273] Testing event xfs_dqget_dup: OK
> [   36.340486] Testing event xfs_dqget_freeing: OK
> [   36.380465] Testing event xfs_dqget_miss: OK
> [   36.428900] Testing event xfs_dqget_hit: OK
> [   36.461006] Testing event xfs_dqread_fail: OK
> [   36.522935] Testing event xfs_dqread: OK
> [   36.560425] Testing event xfs_dqtobp_read: OK
> [   36.633593] Testing event xfs_dqalloc: OK
> [   36.718333] Testing event xfs_dqattach_get: OK
> [   36.787809] Testing event xfs_dqattach_found: OK
> [   36.831213] Testing event xfs_dqreclaim_done: OK
> [   36.881325] Testing event xfs_dqreclaim_busy: OK
> [   36.921118] Testing event xfs_dqreclaim_dirty: OK
> [   36.961134] Testing event xfs_dqreclaim_want: OK
> [   37.001137] Testing event xfs_dqadjust: OK
> [   37.041206] Testing event xfs_rename: OK
> [   37.081407] Testing event xfs_symlink: OK
> [   37.130681] Testing event xfs_create: OK
> [   37.170621] Testing event xfs_lookup: OK
> [   37.210714] Testing event xfs_link: OK
> [   37.250636] Testing event xfs_remove: OK
> [   37.290685] Testing event xfs_inode_unpin_nowait: OK
> [   37.330676] Testing event xfs_inode_unpin: OK
> [   37.370657] Testing event xfs_inode_pin: OK
> [   37.410417] Testing event xfs_irele: OK
> [   37.450935] Testing event xfs_ihold: OK
> [   37.490632] Testing event xfs_iomap_prealloc_size: OK
> [   37.531253] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   37.571156] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   37.610718] Testing event xfs_inode_set_eofblocks_tag: OK
> [   37.651110] Testing event xfs_dquot_dqdetach: OK
> [   37.690997] Testing event xfs_dquot_dqalloc: OK
> [   37.731139] Testing event xfs_update_time: OK
> [   37.772021] Testing event xfs_evict_inode: OK
> [   37.810676] Testing event xfs_destroy_inode: OK
> [   37.851212] Testing event xfs_file_fsync: OK
> [   37.890659] Testing event xfs_dir_fsync: OK
> [   37.930736] Testing event xfs_ioctl_setattr: OK
> [   37.972930] Testing event xfs_file_compat_ioctl: OK
> [   38.020639] Testing event xfs_file_ioctl: OK
> [   38.071693] Testing event xfs_vm_bmap: OK
> [   38.120376] Testing event xfs_readdir: OK
> [   38.160386] Testing event xfs_collapse_file_space: OK
> [   38.210376] Testing event xfs_free_file_space: OK
> [   38.250398] Testing event xfs_alloc_file_space: OK
> [   38.290404] Testing event xfs_inactive_symlink: OK
> [   38.340660] Testing event xfs_readlink: OK
> [   38.390400] Testing event xfs_setattr: OK
> [   38.430395] Testing event xfs_getattr: OK
> [   38.480387] Testing event xfs_iget_miss: OK
> [   38.520713] Testing event xfs_iget_hit: OK
> [   38.570370] Testing event xfs_iget_reclaim_fail: OK
> [   38.610972] Testing event xfs_iget_reclaim: OK
> [   38.651335] Testing event xfs_iget_skip: OK
> [   38.690820] Testing event xfs_iunlock: OK
> [   38.730545] Testing event xfs_ilock_demote: OK
> [   38.770411] Testing event xfs_ilock_nowait: OK
> [   38.810653] Testing event xfs_ilock: OK
> [   38.850847] Testing event xfs_trans_buf_ordered: OK
> [   38.890849] Testing event xfs_trans_binval: OK
> [   38.930962] Testing event xfs_trans_bhold_release: OK
> [   38.970414] Testing event xfs_trans_bhold: OK
> [   39.010648] Testing event xfs_trans_bjoin: OK
> [   39.050435] Testing event xfs_trans_brelse: OK
> [   39.090422] Testing event xfs_trans_log_buf: OK
> [   39.130548] Testing event xfs_trans_read_buf_recur: OK
> [   39.170911] Testing event xfs_trans_read_buf: OK
> [   39.210996] Testing event xfs_trans_getsb_recur: OK
> [   39.260485] Testing event xfs_trans_getsb: OK
> [   39.300940] Testing event xfs_trans_get_buf_recur: OK
> [   39.341101] Testing event xfs_trans_get_buf: OK
> [   39.380794] Testing event xfs_buf_item_push: OK
> [   39.420515] Testing event xfs_buf_item_committed: OK
> [   39.460407] Testing event xfs_buf_item_unlock_stale: OK
> [   39.500407] Testing event xfs_buf_item_unlock: OK
> [   39.550608] Testing event xfs_buf_item_unpin_stale: OK
> [   39.590466] Testing event xfs_buf_item_unpin: OK
> [   39.630502] Testing event xfs_buf_item_pin: OK
> [   39.670391] Testing event xfs_buf_item_ordered: OK
> [   39.710474] Testing event xfs_buf_item_format_stale: OK
> [   39.750533] Testing event xfs_buf_item_format_ordered: OK
> [   39.790444] Testing event xfs_buf_item_format: OK
> [   39.830557] Testing event xfs_buf_item_size_stale: OK
> [   39.870392] Testing event xfs_buf_item_size_ordered: OK
> [   39.910430] Testing event xfs_buf_item_size: OK
> [   39.950370] Testing event xfs_buf_ioerror: OK
> [   39.990357] Testing event xfs_buf_read: OK
> [   40.040419] Testing event xfs_buf_get: OK
> [   40.080435] Testing event xfs_buf_find: OK
> [   40.120343] Testing event xfs_inode_item_push: OK
> [   40.160441] Testing event xfs_reset_dqcounts: OK
> [   40.210400] Testing event xfs_da_btree_corrupt: OK
> [   40.250419] Testing event xfs_btree_corrupt: OK
> [   40.290538] Testing event xfs_trans_read_buf_shut: OK
> [   40.340440] Testing event xfs_trans_read_buf_io: OK
> [   40.390540] Testing event xfs_buf_wait_buftarg: OK
> [   40.430415] Testing event xfs_buf_error_relse: OK
> [   40.470527] Testing event xfs_buf_item_iodone_async: OK
> [   40.510440] Testing event xfs_buf_item_iodone: OK
> [   40.560522] Testing event xfs_buf_item_relse: OK
> [   40.600418] Testing event xfs_bdstrat_shut: OK
> [   40.640579] Testing event xfs_buf_get_uncached: OK
> [   40.680405] Testing event xfs_buf_delwri_split: OK
> [   40.720524] Testing event xfs_buf_delwri_queued: OK
> [   40.760447] Testing event xfs_buf_delwri_queue: OK
> [   40.810582] Testing event xfs_buf_iowait_done: OK
> [   40.850457] Testing event xfs_buf_iowait: OK
> [   40.890572] Testing event xfs_buf_unlock: OK
> [   40.930452] Testing event xfs_buf_trylock: OK
> [   40.980518] Testing event xfs_buf_lock_done: OK
> [   41.020534] Testing event xfs_buf_lock: OK
> [   41.060488] Testing event xfs_buf_bawrite: OK
> [   41.100445] Testing event xfs_buf_iorequest: OK
> [   41.140500] Testing event xfs_buf_iodone: OK
> [   41.180451] Testing event xfs_buf_rele: OK
> [   41.220562] Testing event xfs_buf_hold: OK
> [   41.270450] Testing event xfs_buf_free: OK
> [   41.310556] Testing event xfs_buf_init: OK
> [   41.350422] Testing event xfs_extlist: OK
> [   41.400530] Testing event xfs_bmap_post_update: OK
> [   41.450429] Testing event xfs_bmap_pre_update: OK
> [   41.490545] Testing event xfs_iext_remove: OK
> [   41.530441] Testing event xfs_iext_insert: OK
> [   41.570554] Testing event xfs_attr_list_node_descend: OK
> [   41.610464] Testing event xfs_ialloc_read_agi: OK
> [   41.650550] Testing event xfs_read_agi: OK
> [   41.690431] Testing event xfs_alloc_read_agf: OK
> [   41.740530] Testing event xfs_read_agf: OK
> [   41.780448] Testing event xfs_perag_clear_eofblocks: OK
> [   41.830563] Testing event xfs_perag_set_eofblocks: OK
> [   41.870459] Testing event xfs_perag_clear_reclaim: OK
> [   41.910547] Testing event xfs_perag_set_reclaim: OK
> [   41.950447] Testing event xfs_perag_put: OK
> [   41.990538] Testing event xfs_perag_get_tag: OK
> [   42.030448] Testing event xfs_perag_get: OK
> [   42.070569] Testing event xfs_attr_node_list: OK
> [   42.110466] Testing event xfs_attr_leaf_list: OK
> [   42.160576] Testing event xfs_attr_list_notfound: OK
> [   42.210464] Testing event xfs_attr_list_wrong_blk: OK
> [   42.250586] Testing event xfs_attr_list_add: OK
> [   42.290444] Testing event xfs_attr_list_full: OK
> [   42.330571] Testing event xfs_attr_list_leaf_end: OK
> [   42.370445] Testing event xfs_attr_list_leaf: OK
> [   42.410575] Testing event xfs_attr_list_sf_all: OK
> [   42.450433] Testing event xfs_attr_list_sf: OK
> [   42.490569] Testing event ocfs2_remove_block_from_cache: OK
> [   42.530453] Testing event ocfs2_remove_metadata_tree: OK
> [   42.570575] Testing event ocfs2_remove_metadata_array: OK
> [   42.610448] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   42.650564] Testing event ocfs2_set_buffer_uptodate: OK
> [   42.690430] Testing event ocfs2_expand_cache: OK
> [   42.730550] Testing event ocfs2_insert_cache_tree: OK
> [   42.770438] Testing event ocfs2_append_cache_array: OK
> [   42.810562] Testing event ocfs2_buffer_cached_end: OK
> [   42.850441] Testing event ocfs2_buffer_cached_begin: OK
> [   42.900532] Testing event ocfs2_metadata_cache_purge: OK
> [   42.940405] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   42.980567] Testing event ocfs2_read_blocks_begin: OK
> [   43.020451] Testing event ocfs2_write_block: OK
> [   43.060415] Testing event ocfs2_read_blocks_end: OK
> [   43.100381] Testing event ocfs2_read_blocks_bh: OK
> [   43.140424] Testing event ocfs2_read_blocks_from_disk: OK
> [   43.180369] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   43.220348] Testing event ocfs2_read_blocks_sync: OK
> [   43.260349] Testing event ocfs2_wait_on_mount: OK
> [   43.300364] Testing event ocfs2_recover_orphans_iput: OK
> [   43.340387] Testing event ocfs2_recover_orphans: OK
> [   43.380438] Testing event ocfs2_orphan_filldir: OK
> [   43.420374] Testing event ocfs2_queue_orphan_scan_end: OK
> [   43.460424] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   43.511884] Testing event ocfs2_mark_dead_nodes: OK
> [   43.551758] Testing event ocfs2_recover_node_skip: OK
> [   43.591351] Testing event ocfs2_recover_node: OK
> [   43.631590] Testing event ocfs2_replay_journal_skip: OK
> [   43.671762] Testing event ocfs2_replay_journal_lock_err: OK
> [   43.711434] Testing event ocfs2_replay_journal_recovered: OK
> [   43.751722] Testing event ocfs2_recovery_thread: OK
> [   43.791177] Testing event ocfs2_recovery_thread_end: OK
> [   43.840689] Testing event ocfs2_recovery_thread_node: OK
> [   43.880563] Testing event ocfs2_complete_recovery_slot: OK
> [   43.931393] Testing event ocfs2_complete_recovery_end: OK
> [   43.971628] Testing event ocfs2_complete_recovery: OK
> [   44.011598] Testing event ocfs2_journal_shutdown_wait: OK
> [   44.051491] Testing event ocfs2_journal_shutdown: OK
> [   44.091610] Testing event ocfs2_journal_init_maxlen: OK
> [   44.131186] Testing event ocfs2_journal_init: OK
> [   44.171393] Testing event ocfs2_journal_dirty: OK
> [   44.211352] Testing event ocfs2_journal_access: OK
> [   44.251346] Testing event ocfs2_allocate_extend_trans: OK
> [   44.291832] Testing event ocfs2_extend_trans_restart: OK
> [   44.331445] Testing event ocfs2_extend_trans: OK
> [   44.371462] Testing event ocfs2_commit_cache_end: OK
> [   44.411384] Testing event ocfs2_commit_cache_begin: OK
> [   44.451276] Testing event ocfs2_encode_fh_type: OK
> [   44.491261] Testing event ocfs2_encode_fh_parent: OK
> [   44.531252] Testing event ocfs2_encode_fh_self: OK
> [   44.571704] Testing event ocfs2_encode_fh_begin: OK
> [   44.611810] Testing event ocfs2_get_parent_end: OK
> [   44.651578] Testing event ocfs2_get_parent: OK
> [   44.692079] Testing event ocfs2_get_dentry_end: OK
> [   44.731573] Testing event ocfs2_get_dentry_generation: OK
> [   44.771309] Testing event ocfs2_get_dentry_stale: OK
> [   44.811659] Testing event ocfs2_get_dentry_test_bit: OK
> [   44.851465] Testing event ocfs2_get_dentry_begin: OK
> [   44.891609] Testing event ocfs2_dentry_attach_lock_found: OK
> [   44.931649] Testing event ocfs2_dentry_attach_lock: OK
> [   44.972225] Testing event ocfs2_find_local_alias: OK
> [   45.011425] Testing event ocfs2_dentry_revalidate_ret: OK
> [   45.051647] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   45.100469] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   45.140724] Testing event ocfs2_dentry_revalidate_delete: OK
> [   45.180460] Testing event ocfs2_dentry_revalidate_negative: OK
> [   45.220431] Testing event ocfs2_dentry_revalidate: OK
> [   45.260441] Testing event ocfs2_orphan_del: OK
> [   45.300429] Testing event ocfs2_orphan_add_end: OK
> [   45.340449] Testing event ocfs2_orphan_add_begin: OK
> [   45.380434] Testing event ocfs2_blkno_stringify: OK
> [   45.420453] Testing event ocfs2_symlink_begin: OK
> [   45.460420] Testing event ocfs2_create_symlink_data: OK
> [   45.500437] Testing event ocfs2_rename_over_existing: OK
> [   45.540427] Testing event ocfs2_rename_disagree: OK
> [   45.580449] Testing event ocfs2_rename_target_exists: OK
> [   45.620434] Testing event ocfs2_rename: OK
> [   45.660456] Testing event ocfs2_double_lock_end: OK
> [   45.700423] Testing event ocfs2_double_lock: OK
> [   45.740453] Testing event ocfs2_unlink_noent: OK
> [   45.780434] Testing event ocfs2_link: OK
> [   45.820437] Testing event ocfs2_mknod: OK
> [   45.860433] Testing event ocfs2_lookup_ret: OK
> [   45.900435] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   45.940418] Testing event ocfs2_symlink_create: OK
> [   45.980456] Testing event ocfs2_unlink: OK
> [   46.020414] Testing event ocfs2_create: OK
> [   46.070608] Testing event ocfs2_mkdir: OK
> [   46.110831] Testing event ocfs2_lookup: OK
> [   46.150686] Testing event ocfs2_prepare_dir_for_insert: OK
> [   46.190826] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   46.230693] Testing event ocfs2_dx_dir_rebalance: OK
> [   46.270820] Testing event ocfs2_extend_dir: OK
> [   46.310681] Testing event ocfs2_dx_dir_index_root_block: OK
> [   46.350838] Testing event ocfs2_dx_dir_format_cluster: OK
> [   46.390676] Testing event ocfs2_dx_dir_attach_index: OK
> [   46.430853] Testing event ocfs2_check_dir_for_entry: OK
> [   46.470655] Testing event ocfs2_find_files_on_disk: OK
> [   46.510722] Testing event ocfs2_readdir: OK
> [   46.550648] Testing event ocfs2_delete_entry_dx: OK
> [   46.590717] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   46.630593] Testing event ocfs2_dx_dir_search: OK
> [   46.670721] Testing event ocfs2_find_entry_el: OK
> [   46.710530] Testing event ocfs2_validate_dir_block: OK
> [   46.750722] Testing event ocfs2_search_dirblock: OK
> [   46.790635] Testing event ocfs2_mark_dquot_dirty: OK
> [   46.843756] Testing event ocfs2_acquire_dquot: OK
> [   46.900415] Testing event ocfs2_release_dquot: OK
> [   46.972824] Testing event ocfs2_write_dquot: OK
> [   47.050137] Testing event ocfs2_sync_dquot_helper: OK
> [   47.091599] Testing event ocfs2_sync_dquot: OK
> [   47.163710] Testing event ocfs2_validate_quota_block: OK
> [   47.203195] Testing event olq_set_dquot: OK
> [   47.243230] Testing event ocfs2_finish_quota_recovery: OK
> [   47.282693] Testing event ocfs2_recover_local_quota_file: OK
> [   47.321073] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   47.360487] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   47.413688] Testing event ocfs2_resmap_resv_bits: OK
> [   47.451630] Testing event ocfs2_cannibalize_resv_end: OK
> [   47.503184] Testing event ocfs2_cannibalize_resv_begin: OK
> [   47.542701] Testing event ocfs2_resv_find_window_next: OK
> [   47.590406] Testing event ocfs2_resv_find_window_prev: OK
> [   47.633955] Testing event ocfs2_resv_find_window_begin: OK
> [   47.670367] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   47.712800] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   47.750369] Testing event ocfs2_resv_insert: OK
> [   47.790500] Testing event ocfs2_reflink_xattr_rec: OK
> [   47.833397] Testing event ocfs2_reflink_xattr_buckets: OK
> [   47.870372] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   47.910394] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   47.953317] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   48.002724] Testing event ocfs2_create_empty_xattr_block: OK
> [   48.046355] Testing event ocfs2_reflink_xattr_header: OK
> [   48.090355] Testing event ocfs2_rm_xattr_cluster: OK
> [   48.130460] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   48.170362] Testing event ocfs2_add_new_xattr_bucket: OK
> [   48.210389] Testing event ocfs2_extend_xattr_bucket: OK
> [   48.253347] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   48.290605] Testing event ocfs2_add_new_xattr_cluster: OK
> [   48.332433] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   48.370614] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   48.410508] Testing event ocfs2_mv_xattr_buckets: OK
> [   48.450363] Testing event ocfs2_cp_xattr_bucket: OK
> [   48.492770] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   48.530377] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   48.570366] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   48.610393] Testing event ocfs2_defrag_xattr_bucket: OK
> [   48.650369] Testing event ocfs2_xattr_create_index_block: OK
> [   48.690390] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   48.749352] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   48.802293] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   48.852831] Testing event ocfs2_iterate_xattr_bucket: OK
> [   48.890382] Testing event ocfs2_iterate_xattr_buckets: OK
> [   48.949353] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   49.000345] Testing event ocfs2_xattr_index_block_find: OK
> [   49.053583] Testing event ocfs2_xattr_bucket_find: OK
> [   49.109793] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   49.156010] Testing event ocfs2_xattr_extend_allocation: OK
> [   49.203488] Testing event ocfs2_validate_xattr_block: OK
> [   49.256009] Testing event ocfs2_initialize_super: OK
> [   49.323725] Testing event ocfs2_dismount_volume: OK
> [   49.390183] Testing event ocfs2_statfs: OK
> [   49.493873] Testing event ocfs2_put_super: OK
> [   49.563766] Testing event ocfs2_parse_options: OK
> [   49.630165] Testing event ocfs2_fill_super: OK
> [   49.703912] Testing event ocfs2_remount: OK
> [   49.772904] Testing event ocfs2_do_node_down: OK
> [   49.850239] Testing event ocfs2_find_slot: OK
> [   49.900327] Testing event ocfs2_map_slot_buffers_block: OK
> [   49.952861] Testing event ocfs2_map_slot_buffers: OK
> [   50.050222] Testing event ocfs2_refresh_slot_info: OK
> [   50.112732] Testing event ocfs2_read_virt_blocks: OK
> [   50.172895] Testing event ocfs2_mark_inode_dirty: OK
> [   50.255159] Testing event ocfs2_inode_revalidate: OK
> [   50.293908] Testing event ocfs2_drop_inode: OK
> [   50.352755] Testing event ocfs2_clear_inode: OK
> [   50.452791] Testing event ocfs2_delete_inode: OK
> [   50.513889] Testing event ocfs2_cleanup_delete_inode: OK
> [   50.560358] Testing event ocfs2_query_inode_wipe_end: OK
> [   50.610360] Testing event ocfs2_query_inode_wipe_succ: OK
> [   50.662862] Testing event ocfs2_query_inode_wipe_begin: OK
> [   50.753439] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   50.803882] Testing event ocfs2_validate_inode_block: OK
> [   50.863911] Testing event ocfs2_check_orphan_recovery_state: OK
> [   50.922937] Testing event ocfs2_read_locked_inode: OK
> [   51.023890] Testing event ocfs2_populate_inode: OK
> [   51.082845] Testing event ocfs2_find_actor: OK
> [   51.193880] Testing event ocfs2_iget_end: OK
> [   51.257696] Testing event ocfs2_iget5_locked: OK
> [   51.313883] Testing event ocfs2_iget_begin: OK
> [   51.403838] Testing event generic_file_aio_read_ret: OK
> [   51.462978] Testing event ocfs2_prepare_inode_for_write: OK
> [   51.542886] Testing event ocfs2_remove_inode_range: OK
> [   51.620336] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   51.682765] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   51.772930] Testing event ocfs2_zero_partial_clusters: OK
> [   51.853969] Testing event ocfs2_write_remove_suid: OK
> [   51.950380] Testing event ocfs2_setattr: OK
> [   52.022837] Testing event ocfs2_zero_extend: OK
> [   52.142880] Testing event ocfs2_zero_extend_range: OK
> [   52.260375] Testing event ocfs2_write_zero_page: OK
> [   52.313079] Testing event ocfs2_extend_allocation_end: OK
> [   52.410344] Testing event ocfs2_extend_allocation: OK
> [   52.483823] Testing event ocfs2_truncate_file_error: OK
> [   52.550377] Testing event ocfs2_truncate_file: OK
> [   52.623767] Testing event ocfs2_file_aio_read: OK
> [   52.683923] Testing event ocfs2_file_splice_read: OK
> [   52.723752] Testing event ocfs2_file_splice_write: OK
> [   52.803834] Testing event ocfs2_file_aio_write: OK
> [   52.903948] Testing event ocfs2_sync_file: OK
> [   52.962567] Testing event ocfs2_file_release: OK
> [   53.020402] Testing event ocfs2_file_open: OK
> [   53.080448] Testing event ocfs2_fault: OK
> [   53.140390] Testing event ocfs2_write_end_inline: OK
> [   53.193979] Testing event ocfs2_write_begin_nolock: OK
> [   53.254042] Testing event ocfs2_try_to_write_inline_data: OK
> [   53.327676] Testing event ocfs2_bmap: OK
> [   53.370468] Testing event ocfs2_writepage: OK
> [   53.434054] Testing event ocfs2_readpage: OK
> [   53.483996] Testing event ocfs2_get_block_end: OK
> [   53.543840] Testing event ocfs2_get_block: OK
> [   53.649824] Testing event ocfs2_symlink_get_block: OK
> [   53.713779] Testing event ocfs2_refcount_cow_hunk: OK
> [   53.803815] Testing event ocfs2_make_clusters_writable: OK
> [   53.854023] Testing event ocfs2_replace_clusters: OK
> [   53.900397] Testing event ocfs2_clear_ext_refcount: OK
> [   53.973831] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   54.068612] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   54.105859] Testing event ocfs2_lock_refcount_allocators: OK
> [   54.163821] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   54.244088] Testing event ocfs2_add_refcount_flag: OK
> [   54.343954] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   54.390429] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   54.440497] Testing event ocfs2_mark_extent_refcounted: OK
> [   54.480465] Testing event ocfs2_decrease_refcount: OK
> [   54.527228] Testing event ocfs2_decrease_refcount_rec: OK
> [   54.570450] Testing event ocfs2_restore_refcount_block: OK
> [   54.643892] Testing event ocfs2_remove_refcount_extent: OK
> [   54.720398] Testing event ocfs2_increase_refcount_split: OK
> [   54.775830] Testing event ocfs2_increase_refcount_insert: OK
> [   54.824194] Testing event ocfs2_increase_refcount_change: OK
> [   54.870408] Testing event ocfs2_increase_refcount_begin: OK
> [   54.910500] Testing event ocfs2_split_refcount_rec_insert: OK
> [   54.950474] Testing event ocfs2_split_refcount_rec: OK
> [   54.990441] Testing event ocfs2_insert_refcount_rec: OK
> [   55.053872] Testing event ocfs2_new_leaf_refcount_block: OK
> [   55.133938] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   55.170443] Testing event ocfs2_expand_inline_ref_root: OK
> [   55.213923] Testing event ocfs2_change_refcount_rec: OK
> [   55.260541] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   55.300439] Testing event ocfs2_create_refcount_tree: OK
> [   55.344132] Testing event ocfs2_purge_refcount_trees: OK
> [   55.380484] Testing event ocfs2_validate_refcount_block: OK
> [   55.420487] Testing event ocfs2_test_inode_bit: OK
> [   55.460462] Testing event ocfs2_test_suballoc_bit: OK
> [   55.500581] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   55.540610] Testing event ocfs2_free_clusters: OK
> [   55.580492] Testing event ocfs2_free_suballoc_bits: OK
> [   55.620365] Testing event ocfs2_block_group_clear_bits: OK
> [   55.680376] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   55.730787] Testing event ocfs2_claim_suballoc_bits: OK
> [   55.770779] Testing event ocfs2_search_chain_end: OK
> [   55.811153] Testing event ocfs2_search_chain_succ: OK
> [   55.850816] Testing event ocfs2_search_chain_begin: OK
> [   55.890507] Testing event ocfs2_block_group_search_max_block: OK
> [   55.930380] Testing event ocfs2_cluster_group_search_max_block: OK
> [   55.983956] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   56.020571] Testing event ocfs2_relink_block_group: OK
> [   56.063401] Testing event ocfs2_block_group_set_bits: OK
> [   56.110522] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   56.155780] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   56.203931] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   56.274163] Testing event ocfs2_block_group_alloc: OK
> [   56.314201] Testing event ocfs2_block_group_alloc_discontig: OK
> [   56.353958] Testing event ocfs2_block_group_alloc_contig: OK
> [   56.392545] Testing event ocfs2_validate_group_descriptor: OK
> [   56.431439] Testing event ocfs2_group_add: OK
> [   56.470378] Testing event ocfs2_group_extend: OK
> [   56.522905] Testing event ocfs2_update_last_group_and_inode: OK
> [   56.560460] Testing event ocfs2_local_alloc_new_window_result: OK
> [   56.603210] Testing event ocfs2_local_alloc_new_window: OK
> [   56.660377] Testing event ocfs2_sync_local_to_main_free: OK
> [   56.720335] Testing event ocfs2_sync_local_to_main: OK
> [   56.780367] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   56.820469] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   56.860558] Testing event ocfs2_local_alloc_count_bits: OK
> [   56.900557] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   56.940520] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   56.993992] Testing event ocfs2_load_local_alloc: OK
> [   57.040671] Testing event ocfs2_alloc_should_use_local: OK
> [   57.083942] Testing event ocfs2_la_set_sizes: OK
> [   57.120471] Testing event ocfs2_trim_fs: OK
> [   57.160490] Testing event ocfs2_trim_group: OK
> [   57.200420] Testing event ocfs2_trim_extent: OK
> [   57.240499] Testing event ocfs2_cache_block_dealloc: OK
> [   57.280548] Testing event ocfs2_run_deallocs: OK
> [   57.320475] Testing event ocfs2_cache_cluster_dealloc: OK
> [   57.360502] Testing event ocfs2_free_cached_blocks: OK
> [   57.400475] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   57.440497] Testing event ocfs2_truncate_log_recovery_num: OK
> [   57.480416] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   57.520389] Testing event ocfs2_flush_truncate_log: OK
> [   57.560416] Testing event ocfs2_replay_truncate_records: OK
> [   57.600411] Testing event ocfs2_truncate_log_append: OK
> [   57.650594] Testing event ocfs2_mark_extent_written: OK
> [   57.690458] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   57.730570] Testing event ocfs2_rotate_leaf: OK
> [   57.770451] Testing event ocfs2_validate_extent_block: OK
> [   57.810591] Testing event ocfs2_commit_truncate: OK
> [   57.850466] Testing event ocfs2_remove_extent: OK
> [   57.890557] Testing event ocfs2_split_extent: OK
> [   57.930452] Testing event ocfs2_insert_extent: OK
> [   57.970526] Testing event ocfs2_rotate_subtree: OK
> [   58.010472] Testing event ocfs2_grow_tree: OK
> [   58.050581] Testing event ocfs2_complete_edge_insert: OK
> [   58.090447] Testing event ocfs2_num_free_extents: OK
> [   58.130539] Testing event ocfs2_add_clusters_in_btree: OK
> [   58.170452] Testing event ocfs2_insert_extent_start: OK
> [   58.210548] Testing event ocfs2_append_rec_to_path: OK
> [   58.250421] Testing event ocfs2_rotate_tree_right: OK
> [   58.290519] Testing event ocfs2_adjust_rightmost_branch: OK
> [   58.330468] Testing event btrfs_workqueue_destroy: OK
> [   58.370534] Testing event btrfs_workqueue_alloc: OK
> [   58.410423] Testing event btrfs_ordered_sched: OK
> [   58.450545] Testing event btrfs_all_work_done: OK
> [   58.490496] Testing event btrfs_normal_work_done: OK
> [   58.530416] Testing event btrfs_work_sched: OK
> [   58.570575] Testing event btrfs_work_queued: OK
> [   58.610413] Testing event free_extent_state: OK
> [   58.650556] Testing event alloc_extent_state: OK
> [   58.690445] Testing event btrfs_setup_cluster: OK
> [   58.730522] Testing event btrfs_failed_cluster_setup: OK
> [   58.770430] Testing event btrfs_find_cluster: OK
> [   58.810587] Testing event btrfs_reserve_extent_cluster: OK
> [   58.850425] Testing event btrfs_reserve_extent: OK
> [   58.890551] Testing event find_free_extent: OK
> [   58.930404] Testing event btrfs_reserved_extent_free: OK
> [   58.970558] Testing event btrfs_reserved_extent_alloc: OK
> [   59.010509] Testing event btrfs_space_reservation: OK
> [   59.050519] Testing event btrfs_cow_block: OK
> [   59.090960] Testing event btrfs_chunk_free: OK
> [   59.130521] Testing event btrfs_chunk_alloc: OK
> [   59.170406] Testing event run_delayed_ref_head: OK
> [   59.210508] Testing event add_delayed_ref_head: OK
> [   59.250408] Testing event run_delayed_data_ref: OK
> [   59.290564] Testing event add_delayed_data_ref: OK
> [   59.330405] Testing event run_delayed_tree_ref: OK
> [   59.370508] Testing event add_delayed_tree_ref: OK
> [   59.410394] Testing event btrfs_sync_fs: OK
> [   59.450489] Testing event btrfs_sync_file: OK
> [   59.490431] Testing event btrfs_writepage_end_io_hook: OK
> [   59.530488] Testing event __extent_writepage: OK
> [   59.570450] Testing event btrfs_ordered_extent_put: OK
> [   59.610502] Testing event btrfs_ordered_extent_start: OK
> [   59.650448] Testing event btrfs_ordered_extent_remove: OK
> [   59.690528] Testing event btrfs_ordered_extent_add: OK
> [   59.730379] Testing event btrfs_get_extent: OK
> [   59.770488] Testing event btrfs_inode_evict: OK
> [   59.810383] Testing event btrfs_inode_request: OK
> [   59.850547] Testing event btrfs_inode_new: OK
> [   59.890376] Testing event btrfs_transaction_commit: OK
> [   59.930534] Testing event gfs2_rs: OK
> [   59.970415] Testing event gfs2_block_alloc: OK
> [   60.010523] Testing event gfs2_bmap: OK
> [   60.050436] Testing event gfs2_ail_flush: OK
> [   60.090545] Testing event gfs2_log_blocks: OK
> [   60.130449] Testing event gfs2_log_flush: OK
> [   60.170530] Testing event gfs2_pin: OK
> [   60.210442] Testing event gfs2_glock_lock_time: OK
> [   60.250538] Testing event gfs2_glock_queue: OK
> [   60.290433] Testing event gfs2_promote: OK
> [   60.330497] Testing event gfs2_demote_rq: OK
> [   60.370407] Testing event gfs2_glock_put: OK
> [   60.410503] Testing event gfs2_glock_state_change: OK
> [   60.450423] Testing event block_rq_remap: OK
> [   60.490565] Testing event block_bio_remap: OK
> [   60.530405] Testing event block_split: OK
> [   60.570497] Testing event block_unplug: OK
> [   60.610437] Testing event block_plug: OK
> [   60.650539] Testing event block_sleeprq: OK
> [   60.690418] Testing event block_getrq: OK
> [   60.730495] Testing event block_bio_queue: OK
> [   60.770404] Testing event block_bio_frontmerge: OK
> [   60.810536] Testing event block_bio_backmerge: OK
> [   60.850417] Testing event block_bio_complete: OK
> [   60.890510] Testing event block_bio_bounce: OK
> [   60.930384] Testing event block_rq_issue: OK
> [   60.970554] Testing event block_rq_insert: OK
> [   61.010440] Testing event block_rq_complete: OK
> [   61.060492] Testing event block_rq_requeue: OK
> [   61.100436] Testing event block_rq_abort: OK
> [   61.150571] Testing event block_dirty_buffer: OK
> [   61.190393] Testing event block_touch_buffer: OK
> [   61.230455] Testing event swiotlb_bounced: OK
> [   61.270376] Testing event gpio_value: OK
> [   61.320551] Testing event gpio_direction: OK
> [   61.360435] Testing event aer_event: OK
> [   61.400515] Testing event regulator_set_voltage_complete: OK
> [   61.440430] Testing event regulator_set_voltage: OK
> [   61.480556] Testing event regulator_disable_complete: OK
> [   61.520398] Testing event regulator_disable: OK
> [   61.560487] Testing event regulator_enable_complete: OK
> [   61.600381] Testing event regulator_enable_delay: OK
> [   61.640471] Testing event regulator_enable: OK
> [   61.680371] Testing event urandom_read: OK
> [   61.730479] Testing event random_read: OK
> [   61.770380] Testing event extract_entropy_user: OK
> [   61.810475] Testing event extract_entropy: OK
> [   61.850402] Testing event get_random_bytes_arch: OK
> [   61.890554] Testing event get_random_bytes: OK
> [   61.930443] Testing event xfer_secondary_pool: OK
> [   61.970572] Testing event add_disk_randomness: OK
> [   62.010467] Testing event add_input_randomness: OK
> [   62.050569] Testing event debit_entropy: OK
> [   62.090444] Testing event push_to_pool: OK
> [   62.130490] Testing event credit_entropy_bits: OK
> [   62.170449] Testing event mix_pool_bytes_nolock: OK
> [   62.210471] Testing event mix_pool_bytes: OK
> [   62.250447] Testing event add_device_randomness: OK
> [   62.300553] Testing event drm_vblank_event_delivered: OK
> [   62.340399] Testing event drm_vblank_event_queued: OK
> [   62.390547] Testing event drm_vblank_event: OK
> [   62.440475] Testing event radeon_semaphore_wait: OK
> [   62.480615] Testing event radeon_semaphore_signale: OK
> [   62.520461] Testing event radeon_fence_wait_end: OK
> [   62.570495] Testing event radeon_fence_wait_begin: OK
> [   62.610394] Testing event radeon_fence_emit: OK
> [   62.650479] Testing event radeon_vm_set_page: OK
> [   62.690409] Testing event radeon_vm_bo_update: OK
> [   62.740499] Testing event radeon_vm_grab_id: OK
> [   62.780427] Testing event radeon_cs: OK
> [   62.830500] Testing event radeon_bo_create: OK
> [   62.880365] Testing event regcache_drop_region: OK
> [   62.930466] Testing event regmap_async_complete_done: OK
> [   62.970363] Testing event regmap_async_complete_start: OK
> [   63.010518] Testing event regmap_async_io_complete: OK
> [   63.050578] Testing event regmap_async_write_start: OK
> [   63.090589] Testing event regmap_cache_bypass: OK
> [   63.130500] Testing event regmap_cache_only: OK
> [   63.180610] Testing event regcache_sync: OK
> [   63.220518] Testing event regmap_hw_write_done: OK
> [   63.260528] Testing event regmap_hw_write_start: OK
> [   63.300596] Testing event regmap_hw_read_done: OK
> [   63.340676] Testing event regmap_hw_read_start: OK
> [   63.380552] Testing event regmap_reg_read_cache: OK
> [   63.420615] Testing event regmap_reg_read: OK
> [   63.460617] Testing event regmap_reg_write: OK
> [   63.500692] Testing event scsi_eh_wakeup: OK
> [   63.540666] Testing event scsi_dispatch_cmd_timeout: OK
> [   63.580738] Testing event scsi_dispatch_cmd_done: OK
> [   63.620557] Testing event scsi_dispatch_cmd_error: OK
> [   63.660614] Testing event scsi_dispatch_cmd_start: OK
> [   63.700664] Testing event target_cmd_complete: OK
> [   63.740574] Testing event target_sequencer_start: OK
> [   63.780569] Testing event spi_transfer_stop: OK
> [   63.820641] Testing event spi_transfer_start: OK
> [   63.860623] Testing event spi_message_done: OK
> [   63.900627] Testing event spi_message_start: OK
> [   63.940569] Testing event spi_message_submit: OK
> [   63.980750] Testing event spi_master_busy: OK
> [   64.021286] Testing event spi_master_idle: OK
> [   64.060782] Testing event smbus_result: OK
> [   64.100645] Testing event smbus_reply: OK
> [   64.140822] Testing event smbus_read: OK
> [   64.180620] Testing event smbus_write: OK
> [   64.220719] Testing event i2c_result: OK
> [   64.260670] Testing event i2c_reply: OK
> [   64.300752] Testing event i2c_read: OK
> [   64.340599] Testing event i2c_write: OK
> [   64.380797] Testing event mc_event: OK
> [   64.420717] Testing event snd_soc_cache_sync: OK
> [   64.460759] Testing event snd_soc_jack_notify: OK
> [   64.500676] Testing event snd_soc_jack_report: OK
> [   64.540867] Testing event snd_soc_jack_irq: OK
> [   64.580655] Testing event snd_soc_dapm_connected: OK
> [   64.620830] Testing event snd_soc_dapm_input_path: OK
> [   64.660671] Testing event snd_soc_dapm_output_path: OK
> [   64.700862] Testing event snd_soc_dapm_walk_done: OK
> [   64.740692] Testing event snd_soc_dapm_widget_event_done: OK
> [   64.780744] Testing event snd_soc_dapm_widget_event_start: OK
> [   64.820610] Testing event snd_soc_dapm_widget_power: OK
> [   64.860759] Testing event snd_soc_dapm_done: OK
> [   64.900927] Testing event snd_soc_dapm_start: OK
> [   64.940701] Testing event snd_soc_bias_level_done: OK
> [   64.980651] Testing event snd_soc_bias_level_start: OK
> [   65.020725] Testing event snd_soc_preg_read: OK
> [   65.060709] Testing event snd_soc_preg_write: OK
> [   65.101275] Testing event snd_soc_reg_read: OK
> [   65.140902] Testing event snd_soc_reg_write: OK
> [   65.181252] Testing event sst_ipc_outbox_write: OK
> [   65.221096] Testing event sst_ipc_outbox_read: OK
> [   65.260804] Testing event sst_ipc_inbox_write: OK
> [   65.301257] Testing event sst_ipc_inbox_read: OK
> [   65.340798] Testing event sst_ipc_outbox_wdata: OK
> [   65.380731] Testing event sst_ipc_outbox_rdata: OK
> [   65.420797] Testing event sst_ipc_inbox_wdata: OK
> [   65.460689] Testing event sst_ipc_inbox_rdata: OK
> [   65.500772] Testing event sst_ipc_msg_rx: OK
> [   65.540702] Testing event sst_ipc_msg_tx: OK
> [   65.580944] Testing event udp_fail_queue_rcv_skb: OK
> [   65.620741] Testing event sock_exceed_buf_limit: OK
> [   65.660836] Testing event sock_rcvqueue_full: OK
> [   65.700749] Testing event napi_poll: OK
> [   65.740749] Testing event netif_rx_ni_entry: OK
> [   65.780700] Testing event netif_rx_entry: OK
> [   65.820808] Testing event netif_receive_skb_entry: OK
> [   65.861132] Testing event napi_gro_receive_entry: OK
> [   65.900789] Testing event napi_gro_frags_entry: OK
> [   65.941046] Testing event netif_rx: OK
> [   65.980768] Testing event netif_receive_skb: OK
> [   66.020715] Testing event net_dev_queue: OK
> [   66.061492] Testing event net_dev_xmit: OK
> [   66.100744] Testing event net_dev_start_xmit: OK
> [   66.140886] Testing event skb_copy_datagram_iovec: OK
> [   66.180696] Testing event consume_skb: OK
> [   66.221418] Testing event kfree_skb: OK
> [   66.260703] Testing event 9p_protocol_dump: OK
> [   66.300736] Testing event 9p_client_res: OK
> [   66.340623] Testing event 9p_client_req: OK
> [   66.381180] Running tests on trace event systems:
> [   66.381859] Testing event system 9p: OK
> [   66.421198] Testing event system skb: OK
> [   66.460814] Testing event system net: OK
> [   66.500716] Testing event system napi: OK
> [   66.540830] Testing event system sock: OK
> [   66.580997] Testing event system udp: OK
> [   66.621188] Testing event system intel-sst: OK
> [   66.661197] Testing event system asoc: OK
> [   66.701775] Testing event system i2c: OK
> [   66.740714] Testing event system spi: OK
> [   66.781241] Testing event system target: OK
> [   66.820657] Testing event system scsi: OK
> [   66.861016] Testing event system regmap: OK
> [   66.901592] Testing event system radeon: OK
> [   66.940724] Testing event system drm: OK
> [   66.980695] Testing event system random: OK
> [   67.021204] Testing event system regulator: OK
> [   67.060936] Testing event system ras: OK
> [   67.101095] Testing event system gpio: OK
> [   67.143474] Testing event system swiotlb: OK
> [   67.200592] Testing event system block: OK
> [   67.254667] Testing event system gfs2: OK
> [   67.290596] Testing event system btrfs: OK
> [   67.362921] Testing event system ocfs2: 
> [   67.366541] rcu-torture: rtc: ffffffff8e518dc0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [   67.366541] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
> [   67.366541] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
> [   67.366541] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> [   67.457092] OK
> [   67.457379] Testing event system xfs: OK
> [   67.527578] Testing event system jbd2: OK
> [   67.589890] Testing event system writeback: OK
> [   67.633661] Testing event system migrate: OK
> [   67.681620] Testing event system compaction: OK
> [   67.756070] Testing event system kmem: OK
> [   67.846446] Testing event system vmscan: OK
> [   67.936042] Testing event system pagemap: OK
> [   68.056034] Testing event system oom: OK
> [   68.110508] Testing event system filemap: OK
> [   68.169808] Testing event system context_tracking: OK
> [   68.229796] Testing event system power: OK
> [   68.289866] Testing event system test: OK
> [   68.347944] Testing event system rcu: OK
> [   68.409797] Testing event system printk: OK
> [   68.469782] Testing event system lock: OK
> [   68.529893] Testing event system sched: OK
> [   68.589889] Testing event system workqueue: OK
> [   68.659696] Testing event system signal: OK
> [   68.719662] Testing event system timer: OK
> [   68.779693] Testing event system irq: OK
> [   68.841974] Testing event system task: OK
> [   68.900427] Testing event system exceptions: OK
> [   68.941846] Testing event system raw_syscalls: OK
> [   68.980490] Testing event system vsyscall: OK
> [   69.032866] Testing event system nmi: OK
> [   69.094461] Testing event system irq_vectors: OK
> [   69.149790] Testing event system kvmmmu: OK
> [   69.209712] Testing event system kvm: OK
> [   69.313351] Running tests on all trace events:
> [   69.320813] Testing all events: OK
> [   69.425158] Running tests again, along with the function tracer
> [   69.426225] Running tests on trace events:
> [   69.427218] Testing event kvm_async_pf_completed: OK
> [   69.481107] Testing event kvm_async_pf_ready: OK
> [   69.570441] Testing event kvm_async_pf_not_present: OK
> [   69.666448] Testing event kvm_async_pf_doublefault: OK
> [   69.747751] Testing event kvm_try_async_get_page: OK
> [   69.827358] Testing event kvm_age_page: 
> [   69.828261] test-events (1381) used greatest stack depth: 5712 bytes left
> [   69.882365] OK
> [   69.882731] Testing event kvm_fpu: OK
> [   69.964272] Testing event kvm_mmio: OK
> [   70.053613] Testing event kvm_ack_irq: OK
> [   70.114527] Testing event kvm_msi_set_irq: OK
> [   70.243343] Testing event kvm_ioapic_set_irq: OK
> [   70.343328] Testing event kvm_set_irq: OK
> [   70.434422] Testing event kvm_userspace_exit: OK
> [   70.514467] Testing event kvm_track_tsc: OK
> [   70.594478] Testing event kvm_update_master_clock: OK
> [   70.673618] Testing event kvm_write_tsc_offset: OK
> [   70.801277] Testing event vcpu_match_mmio: OK
> [   70.913421] Testing event kvm_emulate_insn: OK
> [   71.014407] Testing event kvm_skinit: OK
> [   71.103054] Testing event kvm_invlpga: OK
> [   71.174578] Testing event kvm_nested_intr_vmexit: OK
> [   71.232292] Testing event kvm_nested_vmexit_inject: OK
> [   71.278966] Testing event kvm_nested_vmexit: OK
> [   71.384531] Testing event kvm_nested_intercepts: OK
> [   71.464389] Testing event kvm_nested_vmrun: OK
> [   71.514442] Testing event kvm_pv_eoi: OK
> [   71.583600] Testing event kvm_eoi: OK
> [   71.704367] Testing event kvm_apic_accept_irq: OK
> [   71.784420] Testing event kvm_apic_ipi: OK
> [   71.873874] Testing event kvm_pic_set_irq: OK
> [   71.974396] Testing event kvm_cr: OK
> [   72.030145] Testing event kvm_msr: OK
> [   72.090479] Testing event kvm_page_fault: OK
> [   72.203353] Testing event kvm_inj_exception: OK
> [   72.324373] Testing event kvm_inj_virq: OK
> [   72.413876] Testing event kvm_exit: OK
> [   72.493609] Testing event kvm_apic: OK
> [   72.582626] Testing event kvm_cpuid: OK
> [   72.669502] Testing event kvm_pio: OK
> [   72.734443] Testing event kvm_hv_hypercall: OK
> [   72.823580] Testing event kvm_hypercall: OK
> [   72.933424] Testing event kvm_entry: OK
> [   73.024417] Testing event check_mmio_spte: 
> [   73.025395] test-events (1418) used greatest stack depth: 5280 bytes left
> [   73.123545] OK
> [   73.123927] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [   73.201952] Testing event fast_page_fault: OK
> [   73.302610] Testing event handle_mmio_page_fault: OK
> [   73.375091] Testing event mark_mmio_spte: OK
> [   73.453627] Testing event kvm_mmu_prepare_zap_page: OK
> [   73.538519] Testing event kvm_mmu_unsync_page: OK
> [   73.596540] Testing event kvm_mmu_sync_page: OK
> [   73.661512] Testing event kvm_mmu_get_page: OK
> [   73.734523] Testing event kvm_mmu_walker_error: OK
> [   73.784612] Testing event kvm_mmu_set_dirty_bit: OK
> [   73.844741] Testing event kvm_mmu_set_accessed_bit: OK
> [   73.904492] Testing event kvm_mmu_paging_element: OK
> [   73.984272] Testing event kvm_mmu_pagetable_walk: OK
> [   74.031137] Testing event thermal_apic_exit: OK
> [   74.133730] Testing event thermal_apic_entry: OK
> [   74.234410] Testing event threshold_apic_exit: OK
> [   74.343685] Testing event threshold_apic_entry: OK
> [   74.444528] Testing event call_function_single_exit: OK
> [   74.524663] Testing event call_function_single_entry: OK
> [   74.653573] Testing event call_function_exit: OK
> [   74.749219] Testing event call_function_entry: OK
> [   74.791254] Testing event irq_work_exit: OK
> [   74.831233] Testing event irq_work_entry: OK
> [   74.871343] Testing event x86_platform_ipi_exit: OK
> [   74.925061] Testing event x86_platform_ipi_entry: OK
> [   74.975252] Testing event error_apic_exit: OK
> [   75.011021] Testing event error_apic_entry: OK
> [   75.065194] Testing event spurious_apic_exit: OK
> [   75.111481] Testing event spurious_apic_entry: OK
> [   75.151202] Testing event reschedule_exit: OK
> [   75.191397] Testing event reschedule_entry: OK
> [   75.245860] Testing event local_timer_exit: OK
> [   75.284990] Testing event local_timer_entry: OK
> [   75.364638] Testing event nmi_handler: OK
> [   75.444512] Testing event emulate_vsyscall: OK
> [   75.522473] Testing event sys_exit: OK
> [   75.596537] Testing event sys_enter: OK
> [   75.666768] Testing event page_fault_kernel: OK
> [   75.712458] Testing event page_fault_user: OK
> [   75.751128] Testing event task_rename: OK
> [   75.791132] Testing event task_newtask: OK
> [   75.830925] Testing event softirq_raise: OK
> [   75.870909] Testing event softirq_exit: OK
> [   75.910906] Testing event softirq_entry: OK
> [   75.951012] Testing event irq_handler_exit: OK
> [   76.017350] Testing event irq_handler_entry: OK
> [   76.070998] Testing event itimer_expire: OK
> [   76.111120] Testing event itimer_state: OK
> [   76.151008] Testing event hrtimer_cancel: OK
> [   76.210859] Testing event hrtimer_expire_exit: OK
> [   76.304696] Testing event hrtimer_expire_entry: OK
> [   76.394522] Testing event hrtimer_start: OK
> [   76.462682] Testing event hrtimer_init: OK
> [   76.534530] Testing event timer_cancel: OK
> [   76.648678] Testing event timer_expire_exit: OK
> [   76.705227] Testing event timer_expire_entry: OK
> [   76.775356] Testing event timer_start: OK
> [   76.831748] Testing event timer_init: OK
> [   76.871781] Testing event signal_deliver: OK
> [   76.911714] Testing event signal_generate: OK
> [   76.951806] Testing event workqueue_execute_end: OK
> [   76.991731] Testing event workqueue_execute_start: OK
> [   77.031776] Testing event workqueue_activate_work: OK
> [   77.082088] Testing event workqueue_queue_work: OK
> [   77.121757] Testing event sched_swap_numa: OK
> [   77.161710] Testing event sched_stick_numa: OK
> [   77.200904] Testing event sched_move_numa: OK
> [   77.240918] Testing event sched_process_hang: OK
> [   77.280953] Testing event sched_pi_setprio: OK
> [   77.321103] Testing event sched_stat_runtime: OK
> [   77.360684] Testing event sched_stat_blocked: OK
> [   77.400915] Testing event sched_stat_iowait: OK
> [   77.440873] Testing event sched_stat_sleep: OK
> [   77.481003] Testing event sched_stat_wait: OK
> [   77.520715] Testing event sched_process_exec: OK
> [   77.560727] Testing event sched_process_fork: OK
> [   77.600880] Testing event sched_process_wait: OK
> [   77.640698] Testing event sched_wait_task: OK
> [   77.680688] Testing event sched_process_exit: OK
> [   77.720762] Testing event sched_process_free: OK
> [   77.760706] Testing event sched_migrate_task: OK
> [   77.800832] Testing event sched_switch: OK
> [   77.840750] Testing event sched_wakeup_new: OK
> [   77.880726] Testing event sched_wakeup: OK
> [   77.920812] Testing event sched_kthread_stop_ret: OK
> [   77.960753] Testing event sched_kthread_stop: OK
> [   78.000863] Testing event lock_acquired: OK
> [   78.040885] Testing event lock_contended: OK
> [   78.080953] Testing event lock_release: OK
> [   78.120713] Testing event lock_acquire: OK
> [   78.160664] Testing event console: OK
> [   78.200708] Testing event rcu_utilization: OK
> [   78.241157] Testing event ftrace_test_filter: OK
> [   78.281018] Testing event dev_pm_qos_remove_request: OK
> [   78.330925] Testing event dev_pm_qos_update_request: OK
> [   78.371139] Testing event dev_pm_qos_add_request: OK
> [   78.411126] Testing event pm_qos_update_flags: OK
> [   78.451177] Testing event pm_qos_update_target: 
> [   78.452240] test-events (1516) used greatest stack depth: 5184 bytes left
> [   78.491060] OK
> [   78.491436] Testing event pm_qos_update_request_timeout: OK
> [   78.530714] Testing event pm_qos_remove_request: OK
> [   78.570696] Testing event pm_qos_update_request: OK
> [   78.611023] Testing event pm_qos_add_request: OK
> [   78.661279] Testing event power_domain_target: OK
> [   78.700817] Testing event clock_set_rate: OK
> [   78.741094] Testing event clock_disable: OK
> [   78.780916] Testing event clock_enable: OK
> [   78.821251] Testing event wakeup_source_deactivate: OK
> [   78.860894] Testing event wakeup_source_activate: OK
> [   78.901208] Testing event device_pm_report_time: OK
> [   78.940889] Testing event machine_suspend: OK
> [   78.981218] Testing event cpu_frequency: OK
> [   79.020902] Testing event pstate_sample: OK
> [   79.061090] Testing event cpu_idle: OK
> [   79.100805] Testing event user_exit: OK
> [   79.141083] Testing event user_enter: OK
> [   79.180790] Testing event mm_filemap_add_to_page_cache: OK
> [   79.231199] Testing event mm_filemap_delete_from_page_cache: OK
> [   79.270883] Testing event oom_score_adj_update: OK
> [   79.311205] Testing event mm_lru_activate: OK
> [   79.350876] Testing event mm_lru_insertion: OK
> [   79.391218] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   79.430740] Testing event mm_vmscan_writepage: OK
> [   79.470702] Testing event mm_vmscan_memcg_isolate: OK
> [   79.510752] Testing event mm_vmscan_lru_isolate: OK
> [   79.550819] Testing event mm_shrink_slab_end: OK
> [   79.590665] Testing event mm_shrink_slab_start: OK
> [   79.630884] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   79.670667] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   79.710770] Testing event mm_vmscan_direct_reclaim_end: OK
> [   79.750688] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   79.790723] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   79.830667] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   79.870731] Testing event mm_vmscan_wakeup_kswapd: OK
> [   79.910657] Testing event mm_vmscan_kswapd_wake: OK
> [   79.950697] Testing event mm_vmscan_kswapd_sleep: OK
> [   79.990696] Testing event mm_page_alloc_extfrag: OK
> [   80.030734] Testing event mm_page_pcpu_drain: OK
> [   80.070742] Testing event mm_page_alloc_zone_locked: OK
> [   80.110667] Testing event mm_page_alloc: OK
> [   80.150778] Testing event mm_page_free_batched: OK
> [   80.190866] Testing event mm_page_free: OK
> [   80.230748] Testing event kmem_cache_free: OK
> [   80.270739] Testing event kfree: OK
> [   80.310712] Testing event kmem_cache_alloc_node: OK
> [   80.350745] Testing event kmalloc_node: OK
> [   80.390722] Testing event kmem_cache_alloc: OK
> [   80.430686] Testing event kmalloc: OK
> [   80.470723] Testing event mm_compaction_end: OK
> [   80.510736] Testing event mm_compaction_begin: OK
> [   80.550690] Testing event mm_compaction_migratepages: OK
> [   80.590680] Testing event mm_compaction_isolate_freepages: OK
> [   80.640694] Testing event mm_compaction_isolate_migratepages: OK
> [   80.680707] Testing event mm_numa_migrate_ratelimit: OK
> [   80.720848] Testing event mm_migrate_pages: OK
> [   80.760825] Testing event writeback_single_inode: OK
> [   80.800824] Testing event writeback_single_inode_start: OK
> [   80.840784] Testing event writeback_wait_iff_congested: OK
> [   80.880675] Testing event writeback_congestion_wait: OK
> [   80.920682] Testing event writeback_sb_inodes_requeue: OK
> [   80.960832] Testing event balance_dirty_pages: OK
> [   81.000673] Testing event bdi_dirty_ratelimit: OK
> [   81.041449] Testing event global_dirty_state: OK
> [   81.080736] Testing event writeback_queue_io: OK
> [   81.120668] Testing event wbc_writepage: OK
> [   81.160702] Testing event writeback_bdi_unregister: OK
> [   81.200734] Testing event writeback_bdi_register: OK
> [   81.240893] Testing event writeback_wake_background: OK
> [   81.290659] Testing event writeback_nowork: OK
> [   81.330645] Testing event writeback_pages_written: OK
> [   81.370665] Testing event writeback_wait: OK
> [   81.410661] Testing event writeback_written: OK
> [   81.460673] Testing event writeback_start: OK
> [   81.502564] Testing event writeback_exec: OK
> [   81.540796] Testing event writeback_queue: OK
> [   81.591212] Testing event writeback_write_inode: OK
> [   81.630938] Testing event writeback_write_inode_start: OK
> [   81.671220] Testing event writeback_dirty_inode: OK
> [   81.710948] Testing event writeback_dirty_inode_start: OK
> [   81.751322] Testing event writeback_dirty_page: OK
> [   81.790944] Testing event jbd2_lock_buffer_stall: OK
> [   81.831276] Testing event jbd2_write_superblock: OK
> [   81.870957] Testing event jbd2_update_log_tail: OK
> [   81.911264] Testing event jbd2_checkpoint_stats: OK
> [   81.950816] Testing event jbd2_run_stats: OK
> [   81.991127] Testing event jbd2_handle_stats: OK
> [   82.030828] Testing event jbd2_handle_extend: OK
> [   82.071143] Testing event jbd2_handle_start: OK
> [   82.110827] Testing event jbd2_submit_inode_data: OK
> [   82.151187] Testing event jbd2_end_commit: OK
> [   82.190854] Testing event jbd2_drop_transaction: OK
> [   82.241123] Testing event jbd2_commit_logging: OK
> [   82.280947] Testing event jbd2_commit_flushing: OK
> [   82.321277] Testing event jbd2_commit_locking: OK
> [   82.360953] Testing event jbd2_start_commit: OK
> [   82.411241] Testing event jbd2_checkpoint: OK
> [   82.450824] Testing event xfs_discard_busy: OK
> [   82.501255] Testing event xfs_discard_exclude: OK
> [   82.550975] Testing event xfs_discard_toosmall: OK
> [   82.601198] Testing event xfs_discard_extent: OK
> [   82.640823] Testing event xfs_log_recover_inode_skip: OK
> [   82.681082] Testing event xfs_log_recover_inode_cancel: OK
> [   82.720658] Testing event xfs_log_recover_inode_recover: OK
> [   82.760696] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   82.800764] Testing event xfs_log_recover_buf_reg_buf: OK
> [   82.840740] Testing event xfs_log_recover_buf_inode_buf: OK
> [   82.880708] Testing event xfs_log_recover_buf_recover: OK
> [   82.920832] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   82.960683] Testing event xfs_log_recover_buf_cancel_add: OK
> [   83.000737] Testing event xfs_log_recover_buf_cancel: OK
> [   83.041086] Testing event xfs_log_recover_buf_not_cancel: OK
> [   83.091828] Testing event xfs_log_recover_item_recover: OK
> [   83.141240] Testing event xfs_log_recover_item_reorder_tail: OK
> [   83.181640] Testing event xfs_log_recover_item_reorder_head: OK
> [   83.221381] Testing event xfs_log_recover_item_add_cont: OK
> [   83.271537] Testing event xfs_log_recover_item_add: OK
> [   83.311549] Testing event xfs_swap_extent_after: OK
> [   83.351077] Testing event xfs_swap_extent_before: OK
> [   83.391045] Testing event xfs_dir2_leafn_moveents: OK
> [   83.431058] Testing event xfs_dir2_shrink_inode: OK
> [   83.470979] Testing event xfs_dir2_grow_inode: OK
> [   83.511171] Testing event xfs_dir2_leafn_remove: OK
> [   83.551007] Testing event xfs_dir2_leafn_add: OK
> [   83.590991] Testing event xfs_da_path_shift: OK
> [   83.631044] Testing event xfs_da_fixhashpath: OK
> [   83.671464] Testing event xfs_da_shrink_inode: OK
> [   83.711813] Testing event xfs_da_grow_inode: OK
> [   83.751693] Testing event xfs_da_swap_lastblock: OK
> [   83.791771] Testing event xfs_da_node_toosmall: OK
> [   83.841584] Testing event xfs_da_node_unbalance: OK
> [   83.881808] Testing event xfs_da_node_rebalance: OK
> [   83.921701] Testing event xfs_da_node_remove: OK
> [   83.971276] Testing event xfs_da_node_split: OK
> [   84.011736] Testing event xfs_da_node_create: OK
> [   84.051567] Testing event xfs_da_node_add: OK
> [   84.092072] Testing event xfs_da_root_join: OK
> [   84.131822] Testing event xfs_da_root_split: OK
> [   84.171680] Testing event xfs_da_unlink_forward: OK
> [   84.211864] Testing event xfs_da_unlink_back: OK
> [   84.261528] Testing event xfs_da_link_after: OK
> [   84.301508] Testing event xfs_da_link_before: OK
> [   84.341510] Testing event xfs_da_join: OK
> [   84.391265] Testing event xfs_da_split: OK
> [   84.431505] Testing event xfs_attr_rmtval_remove: OK
> [   84.481292] Testing event xfs_attr_rmtval_set: OK
> [   84.521088] Testing event xfs_attr_rmtval_get: OK
> [   84.560885] Testing event xfs_attr_refillstate: OK
> [   84.601030] Testing event xfs_attr_fillstate: OK
> [   84.641119] Testing event xfs_attr_node_removename: OK
> [   84.681189] Testing event xfs_attr_node_replace: OK
> [   84.721654] Testing event xfs_attr_node_lookup: OK
> [   84.761202] Testing event xfs_attr_node_get: OK
> [   84.801144] Testing event xfs_attr_node_addname: OK
> [   84.840896] Testing event xfs_attr_leaf_toosmall: OK
> [   84.882369] Testing event xfs_attr_leaf_unbalance: OK
> [   84.921056] Testing event xfs_attr_leaf_rebalance: OK
> [   84.961046] Testing event xfs_attr_leaf_to_node: OK
> [   85.001061] Testing event xfs_attr_leaf_to_sf: OK
> [   85.041151] Testing event xfs_attr_leaf_flipflags: OK
> [   85.091237] Testing event xfs_attr_leaf_setflag: OK
> [   85.130950] Testing event xfs_attr_leaf_clearflag: OK
> [   85.170969] Testing event xfs_attr_leaf_split_after: OK
> [   85.211186] Testing event xfs_attr_leaf_split_before: OK
> [   85.251104] Testing event xfs_attr_leaf_split: OK
> [   85.291051] Testing event xfs_attr_leaf_removename: OK
> [   85.331305] Testing event xfs_attr_leaf_remove: OK
> [   85.381687] Testing event xfs_attr_leaf_replace: OK
> [   85.421281] Testing event xfs_attr_leaf_lookup: OK
> [   85.461515] Testing event xfs_attr_leaf_get: OK
> [   85.501271] Testing event xfs_attr_leaf_compact: OK
> [   85.541107] Testing event xfs_attr_leaf_create: OK
> [   85.580860] Testing event xfs_attr_leaf_addname: OK
> [   85.631052] Testing event xfs_attr_leaf_add_work: OK
> [   85.671099] Testing event xfs_attr_leaf_add_new: OK
> [   85.711556] Testing event xfs_attr_leaf_add_old: OK
> [   85.750931] Testing event xfs_attr_leaf_add: OK
> [   85.791119] Testing event xfs_attr_sf_to_leaf: OK
> [   85.831024] Testing event xfs_attr_sf_removename: OK
> [   85.870973] Testing event xfs_attr_sf_remove: OK
> [   85.911562] Testing event xfs_attr_sf_lookup: OK
> [   85.951883] Testing event xfs_attr_sf_create: OK
> [   86.002170] Testing event xfs_attr_sf_addname: OK
> [   86.051619] Testing event xfs_attr_sf_add: OK
> [   86.101289] Testing event xfs_dir2_node_to_leaf: OK
> [   86.141784] Testing event xfs_dir2_node_removename: OK
> [   86.181390] Testing event xfs_dir2_node_replace: OK
> [   86.221790] Testing event xfs_dir2_node_lookup: OK
> [   86.271867] Testing event xfs_dir2_node_addname: OK
> [   86.311589] Testing event xfs_dir2_leaf_to_node: OK
> [   86.350923] Testing event xfs_dir2_leaf_to_block: OK
> [   86.390907] Testing event xfs_dir2_leaf_removename: OK
> [   86.430721] Testing event xfs_dir2_leaf_replace: OK
> [   86.481157] Testing event xfs_dir2_leaf_lookup: OK
> [   86.520952] Testing event xfs_dir2_leaf_addname: OK
> [   86.561199] Testing event xfs_dir2_block_to_leaf: OK
> [   86.601463] Testing event xfs_dir2_block_to_sf: OK
> [   86.642031] Testing event xfs_dir2_block_removename: OK
> [   86.682430] Testing event xfs_dir2_block_replace: OK
> [   86.722233] Testing event xfs_dir2_block_lookup: OK
> [   86.761966] Testing event xfs_dir2_block_addname: OK
> [   86.802053] Testing event xfs_dir2_sf_to_block: OK
> [   86.846894] Testing event xfs_dir2_sf_toino8: OK
> [   86.893726] Testing event xfs_dir2_sf_toino4: OK
> [   86.960943] Testing event xfs_dir2_sf_removename: OK
> [   87.010874] Testing event xfs_dir2_sf_replace: OK
> [   87.071534] Testing event xfs_dir2_sf_lookup: OK
> [   87.123114] Testing event xfs_dir2_sf_create: OK
> [   87.164455] Testing event xfs_dir2_sf_addname: OK
> [   87.202223] Testing event xfs_alloc_vextent_allfailed: OK
> [   87.274681] Testing event xfs_alloc_vextent_loopfailed: OK
> [   87.321868] Testing event xfs_alloc_vextent_noagbp: OK
> [   87.360946] Testing event xfs_alloc_vextent_nofix: OK
> [   87.401804] Testing event xfs_alloc_vextent_badargs: OK
> [   87.453712] Testing event xfs_alloc_small_error: OK
> [   87.492017] Testing event xfs_alloc_small_done: OK
> [   87.542797] Testing event xfs_alloc_small_notenough: OK
> [   87.592739] Testing event xfs_alloc_small_freelist: OK
> [   87.640955] Testing event xfs_alloc_size_busy: OK
> [   87.692273] Testing event xfs_alloc_size_error: OK
> [   87.742759] Testing event xfs_alloc_size_done: OK
> [   87.780824] Testing event xfs_alloc_size_nominleft: OK
> [   87.842749] Testing event xfs_alloc_size_noentry: OK
> [   87.890735] Testing event xfs_alloc_size_neither: OK
> [   87.940772] Testing event xfs_alloc_near_busy: OK
> [   87.997026] Testing event xfs_alloc_near_noentry: OK
> [   88.047689] Testing event xfs_alloc_near_error: OK
> [   88.107476] Testing event xfs_alloc_near_lesser: OK
> [   88.157029] Testing event xfs_alloc_near_greater: OK
> [   88.204156] Testing event xfs_alloc_near_first: OK
> [   88.246675] Testing event xfs_alloc_near_nominleft: OK
> [   88.291039] Testing event xfs_alloc_exact_error: OK
> [   88.352877] Testing event xfs_alloc_exact_notfound: OK
> [   88.400617] Testing event xfs_alloc_exact_done: OK
> [   88.447701] Testing event xfs_free_extent: OK
> [   88.514328] Testing event xfs_agf: OK
> [   88.564556] Testing event xfs_trans_commit_lsn: OK
> [   88.610998] Testing event xfs_extent_busy_trim: OK
> [   88.662915] Testing event xfs_extent_busy_clear: OK
> [   88.714744] Testing event xfs_extent_busy_reuse: OK
> [   88.773808] Testing event xfs_extent_busy_force: OK
> [   88.820842] Testing event xfs_extent_busy_enomem: OK
> [   88.867158] Testing event xfs_extent_busy: OK
> [   88.910533] Testing event xfs_bunmap: OK
> [   88.971098] Testing event xfs_pagecache_inval: OK
> [   89.014606] Testing event xfs_itruncate_extents_end: OK
> [   89.085470] Testing event xfs_itruncate_extents_start: OK
> [   89.136848] Testing event xfs_setfilesize: OK
> [   89.199136] Testing event xfs_get_blocks_notfound: OK
> [   89.252771] Testing event xfs_unwritten_convert: OK
> [   89.297265] Testing event xfs_delalloc_enospc: OK
> [   89.345225] Testing event xfs_get_blocks_alloc: OK
> [   89.423482] Testing event xfs_get_blocks_found: OK
> [   89.483472] Testing event xfs_map_blocks_alloc: OK
> [   89.541135] Testing event xfs_map_blocks_found: OK
> [   89.615641] Testing event xfs_invalidatepage: OK
> [   89.675541] Testing event xfs_releasepage: OK
> [   89.743207] Testing event xfs_writepage: OK
> [   89.863375] Testing event xfs_file_splice_write: OK
> [   89.963385] Testing event xfs_file_splice_read: OK
> [   90.057654] Testing event xfs_file_direct_write: OK
> [   90.134597] Testing event xfs_file_buffered_write: OK
> [   90.214524] Testing event xfs_file_read: OK
> [   90.294729] Testing event xfs_log_assign_tail_lsn: OK
> [   90.445384] Testing event xfs_ail_delete: OK
> [   90.491596] Testing event xfs_ail_move: OK
> [   90.583925] Testing event xfs_ail_insert: OK
> [   90.680829] Testing event xfs_ail_flushing: OK
> [   90.721159] Testing event xfs_ail_locked: OK
> [   90.809233] Testing event xfs_ail_pinned: OK
> [   90.875617] Testing event xfs_ail_push: OK
> [   90.934701] Testing event xfs_log_force: OK
> [   91.010176] Testing event xfs_log_ungrant_sub: OK
> [   91.083766] Testing event xfs_log_ungrant_exit: OK
> [   91.151193] Testing event xfs_log_ungrant_enter: OK
> [   91.211610] Testing event xfs_log_regrant_reserve_sub: OK
> [   91.251687] Testing event xfs_log_regrant_reserve_exit: OK
> [   91.365258] Testing event xfs_log_regrant_reserve_enter: OK
> [   91.424736] Testing event xfs_log_regrant_exit: OK
> [   91.513840] Testing event xfs_log_regrant: OK
> [   91.570388] Testing event xfs_log_reserve_exit: OK
> [   91.714785] Testing event xfs_log_reserve: OK
> [   91.833778] Testing event xfs_log_grant_wake_up: OK
> [   91.943742] Testing event xfs_log_grant_wake: OK
> [   92.043972] Testing event xfs_log_grant_sleep: OK
> [   92.105428] Testing event xfs_log_umount_write: OK
> [   92.167029] Testing event xfs_log_done_perm: OK
> [   92.235896] Testing event xfs_log_done_nonperm: OK
> [   92.315489] Testing event xfs_dqflush_done: OK
> [   92.395259] Testing event xfs_dqflush_force: OK
> [   92.484327] Testing event xfs_dqflush: OK
> [   92.593993] Testing event xfs_dqrele: OK
> [   92.691070] Testing event xfs_dqput_free: OK
> [   92.781506] Testing event xfs_dqput_wait: OK
> [   92.844471] Testing event xfs_dqput: OK
> [   92.933795] Testing event xfs_dqget_dup: OK
> [   93.063880] Testing event xfs_dqget_freeing: OK
> [   93.144073] Testing event xfs_dqget_miss: OK
> [   93.224737] Testing event xfs_dqget_hit: OK
> [   93.282174] Testing event xfs_dqread_fail: OK
> [   93.365612] Testing event xfs_dqread: OK
> [   93.434154] Testing event xfs_dqtobp_read: OK
> [   93.541767] Testing event xfs_dqalloc: OK
> [   93.615725] Testing event xfs_dqattach_get: OK
> [   93.684771] Testing event xfs_dqattach_found: OK
> [   93.741980] Testing event xfs_dqreclaim_done: OK
> [   93.818919] Testing event xfs_dqreclaim_busy: OK
> [   93.884502] Testing event xfs_dqreclaim_dirty: OK
> [   93.991920] Testing event xfs_dqreclaim_want: OK
> [   94.076876] Testing event xfs_dqadjust: OK
> [   94.126359] Testing event xfs_rename: OK
> [   94.210317] Testing event xfs_symlink: OK
> [   94.280419] Testing event xfs_create: OK
> [   94.380930] Testing event xfs_lookup: OK
> [   94.485705] Testing event xfs_link: OK
> [   94.536457] Testing event xfs_remove: OK
> [   94.591924] Testing event xfs_inode_unpin_nowait: OK
> [   94.657814] Testing event xfs_inode_unpin: OK
> [   94.741551] Testing event xfs_inode_pin: OK
> [   94.823873] Testing event xfs_irele: OK
> [   94.877459] Testing event xfs_ihold: OK
> [   94.921065] Testing event xfs_iomap_prealloc_size: OK
> [   94.973425] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   95.028910] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   95.071709] Testing event xfs_inode_set_eofblocks_tag: OK
> [   95.124315] Testing event xfs_dquot_dqdetach: OK
> [   95.176442] Testing event xfs_dquot_dqalloc: OK
> [   95.227237] Testing event xfs_update_time: OK
> [   95.270421] Testing event xfs_evict_inode: OK
> [   95.321261] Testing event xfs_destroy_inode: OK
> [   95.377551] Testing event xfs_file_fsync: OK
> [   95.434092] Testing event xfs_dir_fsync: OK
> [   95.491128] Testing event xfs_ioctl_setattr: OK
> [   95.536574] Testing event xfs_file_compat_ioctl: OK
> [   95.589984] Testing event xfs_file_ioctl: OK
> [   95.634458] Testing event xfs_vm_bmap: OK
> [   95.691873] Testing event xfs_readdir: OK
> [   95.748017] Testing event xfs_collapse_file_space: OK
> [   95.806806] Testing event xfs_free_file_space: OK
> [   95.865284] Testing event xfs_alloc_file_space: OK
> [   95.925317] Testing event xfs_inactive_symlink: OK
> [   95.981957] Testing event xfs_readlink: OK
> [   96.034235] Testing event xfs_setattr: OK
> [   96.097612] Testing event xfs_getattr: OK
> [   96.150209] Testing event xfs_iget_miss: OK
> [   96.201368] Testing event xfs_iget_hit: OK
> [   96.254710] Testing event xfs_iget_reclaim_fail: OK
> [   96.314375] Testing event xfs_iget_reclaim: OK
> [   96.361147] Testing event xfs_iget_skip: OK
> [   96.411210] Testing event xfs_iunlock: OK
> [   96.457350] Testing event xfs_ilock_demote: OK
> [   96.511425] Testing event xfs_ilock_nowait: OK
> [   96.571930] Testing event xfs_ilock: OK
> [   96.626997] Testing event xfs_trans_buf_ordered: OK
> [   96.687119] Testing event xfs_trans_binval: OK
> [   96.767098] Testing event xfs_trans_bhold_release: OK
> [   96.823574] Testing event xfs_trans_bhold: OK
> [   96.864641] Testing event xfs_trans_bjoin: OK
> [   96.903340] Testing event xfs_trans_brelse: OK
> [   96.941769] Testing event xfs_trans_log_buf: OK
> [   96.981582] Testing event xfs_trans_read_buf_recur: OK
> [   97.023150] Testing event xfs_trans_read_buf: OK
> [   97.061542] Testing event xfs_trans_getsb_recur: OK
> [   97.103052] Testing event xfs_trans_getsb: OK
> [   97.142055] Testing event xfs_trans_get_buf_recur: OK
> [   97.182141] Testing event xfs_trans_get_buf: OK
> [   97.221199] Testing event xfs_buf_item_push: OK
> [   97.261275] Testing event xfs_buf_item_committed: OK
> [   97.301078] Testing event xfs_buf_item_unlock_stale: OK
> [   97.343947] Testing event xfs_buf_item_unlock: OK
> [   97.382019] Testing event xfs_buf_item_unpin_stale: OK
> [   97.432121] Testing event xfs_buf_item_unpin: OK
> [   97.482848] Testing event xfs_buf_item_pin: OK
> [   97.596833] Testing event xfs_buf_item_ordered: OK
> [   97.669357] Testing event xfs_buf_item_format_stale: OK
> [   97.733610] Testing event xfs_buf_item_format_ordered: OK
> [   97.773635] Testing event xfs_buf_item_format: OK
> [   97.822766] Testing event xfs_buf_item_size_stale: OK
> [   97.874850] Testing event xfs_buf_item_size_ordered: OK
> [   97.944808] Testing event xfs_buf_item_size: OK
> [   97.992459] Testing event xfs_buf_ioerror: OK
> [   98.044884] Testing event xfs_buf_read: OK
> [   98.093449] Testing event xfs_buf_get: OK
> [   98.146740] Testing event xfs_buf_find: OK
> [   98.185134] Testing event xfs_inode_item_push: OK
> [   98.220836] Testing event xfs_reset_dqcounts: OK
> [   98.263308] Testing event xfs_da_btree_corrupt: OK
> [   98.303349] Testing event xfs_btree_corrupt: OK
> [   98.340837] Testing event xfs_trans_read_buf_shut: OK
> [   98.380874] Testing event xfs_trans_read_buf_io: OK
> [   98.453833] Testing event xfs_buf_wait_buftarg: OK
> [   98.503934] Testing event xfs_buf_error_relse: OK
> [   98.540839] Testing event xfs_buf_item_iodone_async: OK
> [   98.600911] Testing event xfs_buf_item_iodone: OK
> [   98.641146] Testing event xfs_buf_item_relse: OK
> [   98.680781] Testing event xfs_bdstrat_shut: OK
> [   98.720990] Testing event xfs_buf_get_uncached: OK
> [   98.760766] Testing event xfs_buf_delwri_split: OK
> [   98.801025] Testing event xfs_buf_delwri_queued: OK
> [   98.850809] Testing event xfs_buf_delwri_queue: OK
> [   98.891028] Testing event xfs_buf_iowait_done: OK
> [   98.930797] Testing event xfs_buf_iowait: OK
> [   98.971040] Testing event xfs_buf_unlock: OK
> [   99.011316] Testing event xfs_buf_trylock: OK
> [   99.051121] Testing event xfs_buf_lock_done: OK
> [   99.100872] Testing event xfs_buf_lock: OK
> [   99.141134] Testing event xfs_buf_bawrite: OK
> [   99.190925] Testing event xfs_buf_iorequest: OK
> [   99.231140] Testing event xfs_buf_iodone: OK
> [   99.270876] Testing event xfs_buf_rele: OK
> [   99.311117] Testing event xfs_buf_hold: OK
> [   99.350849] Testing event xfs_buf_free: OK
> [   99.391122] Testing event xfs_buf_init: OK
> [   99.430853] Testing event xfs_extlist: OK
> [   99.471199] Testing event xfs_bmap_post_update: OK
> [   99.510791] Testing event xfs_bmap_pre_update: OK
> [   99.551140] Testing event xfs_iext_remove: OK
> [   99.590727] Testing event xfs_iext_insert: OK
> [   99.630949] Testing event xfs_attr_list_node_descend: OK
> [   99.670713] Testing event xfs_ialloc_read_agi: OK
> [   99.721105] Testing event xfs_read_agi: OK
> [   99.760625] Testing event xfs_alloc_read_agf: OK
> [   99.800820] Testing event xfs_read_agf: OK
> [   99.840669] Testing event xfs_perag_clear_eofblocks: OK
> [   99.880714] Testing event xfs_perag_set_eofblocks: OK
> [   99.920731] Testing event xfs_perag_clear_reclaim: OK
> [   99.960890] Testing event xfs_perag_set_reclaim: OK
> [  100.000704] Testing event xfs_perag_put: OK
> [  100.040758] Testing event xfs_perag_get_tag: OK
> [  100.080842] Testing event xfs_perag_get: OK
> [  100.120716] Testing event xfs_attr_node_list: OK
> [  100.160755] Testing event xfs_attr_leaf_list: OK
> [  100.200841] Testing event xfs_attr_list_notfound: OK
> [  100.240764] Testing event xfs_attr_list_wrong_blk: OK
> [  100.280859] Testing event xfs_attr_list_add: OK
> [  100.320956] Testing event xfs_attr_list_full: OK
> [  100.360765] Testing event xfs_attr_list_leaf_end: OK
> [  100.400805] Testing event xfs_attr_list_leaf: OK
> [  100.440805] Testing event xfs_attr_list_sf_all: OK
> [  100.480776] Testing event xfs_attr_list_sf: OK
> [  100.520859] Testing event ocfs2_remove_block_from_cache: OK
> [  100.561039] Testing event ocfs2_remove_metadata_tree: OK
> [  100.600761] Testing event ocfs2_remove_metadata_array: OK
> [  100.640720] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [  100.680914] Testing event ocfs2_set_buffer_uptodate: OK
> [  100.720749] Testing event ocfs2_expand_cache: OK
> [  100.760835] Testing event ocfs2_insert_cache_tree: OK
> [  100.810726] Testing event ocfs2_append_cache_array: OK
> [  100.850713] Testing event ocfs2_buffer_cached_end: OK
> [  100.890743] Testing event ocfs2_buffer_cached_begin: OK
> [  100.930728] Testing event ocfs2_metadata_cache_purge: OK
> [  100.971001] Testing event ocfs2_purge_copied_metadata_tree: OK
> [  101.011437] Testing event ocfs2_read_blocks_begin: OK
> [  101.050972] Testing event ocfs2_write_block: OK
> [  101.090762] Testing event ocfs2_read_blocks_end: OK
> [  101.131000] Testing event ocfs2_read_blocks_bh: OK
> [  101.170865] Testing event ocfs2_read_blocks_from_disk: OK
> [  101.211149] Testing event ocfs2_read_blocks_sync_jbd: OK
> [  101.250757] Testing event ocfs2_read_blocks_sync: OK
> [  101.291097] Testing event ocfs2_wait_on_mount: OK
> [  101.330747] Testing event ocfs2_recover_orphans_iput: OK
> [  101.371012] Testing event ocfs2_recover_orphans: OK
> [  101.420760] Testing event ocfs2_orphan_filldir: OK
> [  101.460985] Testing event ocfs2_queue_orphan_scan_end: OK
> [  101.510768] Testing event ocfs2_queue_orphan_scan_begin: OK
> [  101.550993] Testing event ocfs2_mark_dead_nodes: OK
> [  101.590764] Testing event ocfs2_recover_node_skip: OK
> [  101.641008] Testing event ocfs2_recover_node: OK
> [  101.680751] Testing event ocfs2_replay_journal_skip: OK
> [  101.721018] Testing event ocfs2_replay_journal_lock_err: OK
> [  101.760863] Testing event ocfs2_replay_journal_recovered: OK
> [  101.801011] Testing event ocfs2_recovery_thread: OK
> [  101.840762] Testing event ocfs2_recovery_thread_end: OK
> [  101.881002] Testing event ocfs2_recovery_thread_node: OK
> [  101.920772] Testing event ocfs2_complete_recovery_slot: OK
> [  101.960994] Testing event ocfs2_complete_recovery_end: OK
> [  102.000731] Testing event ocfs2_complete_recovery: OK
> [  102.041059] Testing event ocfs2_journal_shutdown_wait: OK
> [  102.090867] Testing event ocfs2_journal_shutdown: OK
> [  102.131049] Testing event ocfs2_journal_init_maxlen: OK
> [  102.170868] Testing event ocfs2_journal_init: OK
> [  102.221145] Testing event ocfs2_journal_dirty: OK
> [  102.270855] Testing event ocfs2_journal_access: OK
> [  102.311142] Testing event ocfs2_allocate_extend_trans: OK
> [  102.350894] Testing event ocfs2_extend_trans_restart: OK
> [  102.390995] Testing event ocfs2_extend_trans: OK
> [  102.430745] Testing event ocfs2_commit_cache_end: OK
> [  102.470969] Testing event ocfs2_commit_cache_begin: OK
> [  102.520773] Testing event ocfs2_encode_fh_type: OK
> [  102.561135] Testing event ocfs2_encode_fh_parent: OK
> [  102.600940] Testing event ocfs2_encode_fh_self: OK
> [  102.641130] Testing event ocfs2_encode_fh_begin: OK
> [  102.680783] Testing event ocfs2_get_parent_end: OK
> [  102.721035] Testing event ocfs2_get_parent: OK
> [  102.770891] Testing event ocfs2_get_dentry_end: OK
> [  102.811143] Testing event ocfs2_get_dentry_generation: OK
> [  102.850825] Testing event ocfs2_get_dentry_stale: OK
> [  102.891111] Testing event ocfs2_get_dentry_test_bit: OK
> [  102.930856] Testing event ocfs2_get_dentry_begin: OK
> [  102.971416] Testing event ocfs2_dentry_attach_lock_found: OK
> [  103.011455] Testing event ocfs2_dentry_attach_lock: OK
> [  103.051483] Testing event ocfs2_find_local_alias: OK
> [  103.091337] Testing event ocfs2_dentry_revalidate_ret: OK
> [  103.131110] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [  103.181220] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [  103.221463] Testing event ocfs2_dentry_revalidate_delete: OK
> [  103.261316] Testing event ocfs2_dentry_revalidate_negative: OK
> [  103.301412] Testing event ocfs2_dentry_revalidate: OK
> [  103.341217] Testing event ocfs2_orphan_del: OK
> [  103.381400] Testing event ocfs2_orphan_add_end: OK
> [  103.421323] Testing event ocfs2_orphan_add_begin: OK
> [  103.461423] Testing event ocfs2_blkno_stringify: OK
> [  103.501169] Testing event ocfs2_symlink_begin: OK
> [  103.541454] Testing event ocfs2_create_symlink_data: OK
> [  103.581110] Testing event ocfs2_rename_over_existing: OK
> [  103.621421] Testing event ocfs2_rename_disagree: OK
> [  103.661462] Testing event ocfs2_rename_target_exists: OK
> [  103.711490] Testing event ocfs2_rename: OK
> [  103.751483] Testing event ocfs2_double_lock_end: OK
> [  103.791385] Testing event ocfs2_double_lock: OK
> [  103.841413] Testing event ocfs2_unlink_noent: OK
> [  103.881503] Testing event ocfs2_link: OK
> [  103.921436] Testing event ocfs2_mknod: OK
> [  103.961062] Testing event ocfs2_lookup_ret: OK
> [  104.000634] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [  104.051641] Testing event ocfs2_symlink_create: OK
> [  104.091516] Testing event ocfs2_unlink: OK
> [  104.132114] Testing event ocfs2_create: OK
> [  104.171348] Testing event ocfs2_mkdir: OK
> [  104.212005] Testing event ocfs2_lookup: OK
> [  104.251329] Testing event ocfs2_prepare_dir_for_insert: OK
> [  104.292006] Testing event ocfs2_dx_dir_rebalance_split: OK
> [  104.331479] Testing event ocfs2_dx_dir_rebalance: OK
> [  104.372017] Testing event ocfs2_extend_dir: OK
> [  104.411318] Testing event ocfs2_dx_dir_index_root_block: OK
> [  104.452038] Testing event ocfs2_dx_dir_format_cluster: OK
> [  104.491599] Testing event ocfs2_dx_dir_attach_index: OK
> [  104.531824] Testing event ocfs2_check_dir_for_entry: OK
> [  104.571650] Testing event ocfs2_find_files_on_disk: OK
> [  104.612116] Testing event ocfs2_readdir: OK
> [  104.651431] Testing event ocfs2_delete_entry_dx: OK
> [  104.691841] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [  104.731150] Testing event ocfs2_dx_dir_search: OK
> [  104.771017] Testing event ocfs2_find_entry_el: OK
> [  104.820975] Testing event ocfs2_validate_dir_block: OK
> [  104.861197] Testing event ocfs2_search_dirblock: OK
> [  104.900945] Testing event ocfs2_mark_dquot_dirty: OK
> [  104.951774] Testing event ocfs2_acquire_dquot: OK
> [  104.991424] Testing event ocfs2_release_dquot: OK
> [  105.041662] Testing event ocfs2_write_dquot: OK
> [  105.091334] Testing event ocfs2_sync_dquot_helper: OK
> [  105.131659] Testing event ocfs2_sync_dquot: OK
> [  105.171317] Testing event ocfs2_validate_quota_block: OK
> [  105.211692] Testing event olq_set_dquot: OK
> [  105.251351] Testing event ocfs2_finish_quota_recovery: OK
> [  105.291690] Testing event ocfs2_recover_local_quota_file: OK
> [  105.331485] Testing event ocfs2_resmap_claimed_bits_end: OK
> [  105.371834] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [  105.410731] Testing event ocfs2_resmap_resv_bits: OK
> [  105.451002] Testing event ocfs2_cannibalize_resv_end: OK
> [  105.500673] Testing event ocfs2_cannibalize_resv_begin: OK
> [  105.541259] Testing event ocfs2_resv_find_window_next: OK
> [  105.581502] Testing event ocfs2_resv_find_window_prev: OK
> [  105.620996] Testing event ocfs2_resv_find_window_begin: OK
> [  105.660992] Testing event ocfs2_resmap_find_free_bits_end: OK
> [  105.701198] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [  105.750686] Testing event ocfs2_resv_insert: OK
> [  105.800656] Testing event ocfs2_reflink_xattr_rec: OK
> [  105.840939] Testing event ocfs2_reflink_xattr_buckets: OK
> [  105.891066] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [  105.931003] Testing event ocfs2_xattr_set_entry_index_block: OK
> [  105.980675] Testing event ocfs2_xattr_set_entry_bucket: OK
> [  106.021020] Testing event ocfs2_create_empty_xattr_block: OK
> [  106.060981] Testing event ocfs2_reflink_xattr_header: OK
> [  106.100995] Testing event ocfs2_rm_xattr_cluster: OK
> [  106.150909] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [  106.200949] Testing event ocfs2_add_new_xattr_bucket: OK
> [  106.240804] Testing event ocfs2_extend_xattr_bucket: OK
> [  106.281002] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [  106.321065] Testing event ocfs2_add_new_xattr_cluster: OK
> [  106.360933] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [  106.401100] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [  106.442530] Testing event ocfs2_mv_xattr_buckets: OK
> [  106.492310] Testing event ocfs2_cp_xattr_bucket: OK
> [  106.541245] Testing event ocfs2_divide_xattr_bucket_move: OK
> [  106.581726] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [  106.621406] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [  106.661781] Testing event ocfs2_defrag_xattr_bucket: OK
> [  106.701451] Testing event ocfs2_xattr_create_index_block: OK
> [  106.741844] Testing event ocfs2_xattr_create_index_block_begin: OK
> [  106.781382] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [  106.821808] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [  106.861288] Testing event ocfs2_iterate_xattr_bucket: OK
> [  106.901606] Testing event ocfs2_iterate_xattr_buckets: OK
> [  106.941322] Testing event ocfs2_xattr_index_block_find_rec: OK
> [  106.981577] Testing event ocfs2_xattr_index_block_find: OK
> [  107.021417] Testing event ocfs2_xattr_bucket_find: OK
> [  107.061568] Testing event ocfs2_init_xattr_set_ctxt: OK
> [  107.101213] Testing event ocfs2_xattr_extend_allocation: OK
> [  107.150893] Testing event ocfs2_validate_xattr_block: OK
> [  107.191070] Testing event ocfs2_initialize_super: OK
> [  107.231119] Testing event ocfs2_dismount_volume: OK
> [  107.270987] Testing event ocfs2_statfs: OK
> [  107.311010] Testing event ocfs2_put_super: OK
> [  107.351294] Testing event ocfs2_parse_options: OK
> [  107.390846] Testing event ocfs2_fill_super: OK
> [  107.431185] Testing event ocfs2_remount: OK
> [  107.471106] Testing event ocfs2_do_node_down: OK
> [  107.510901] Testing event ocfs2_find_slot: OK
> [  107.551029] Testing event ocfs2_map_slot_buffers_block: OK
> [  107.591089] Testing event ocfs2_map_slot_buffers: OK
> [  107.630697] Testing event ocfs2_refresh_slot_info: OK
> [  107.670899] Testing event ocfs2_read_virt_blocks: OK
> [  107.710698] Testing event ocfs2_mark_inode_dirty: OK
> [  107.750813] Testing event ocfs2_inode_revalidate: OK
> [  107.791148] Testing event ocfs2_drop_inode: OK
> [  107.840857] Testing event ocfs2_clear_inode: OK
> [  107.881094] Testing event ocfs2_delete_inode: OK
> [  107.921109] Testing event ocfs2_cleanup_delete_inode: OK
> [  107.961112] Testing event ocfs2_query_inode_wipe_end: OK
> [  108.001242] Testing event ocfs2_query_inode_wipe_succ: OK
> [  108.041284] Testing event ocfs2_query_inode_wipe_begin: OK
> [  108.081100] Testing event ocfs2_inode_is_valid_to_delete: OK
> [  108.121159] Testing event ocfs2_validate_inode_block: OK
> [  108.161194] Testing event ocfs2_check_orphan_recovery_state: OK
> [  108.201197] Testing event ocfs2_read_locked_inode: OK
> [  108.241113] Testing event ocfs2_populate_inode: OK
> [  108.281092] Testing event ocfs2_find_actor: OK
> [  108.321094] Testing event ocfs2_iget_end: OK
> [  108.361084] Testing event ocfs2_iget5_locked: OK
> [  108.401145] Testing event ocfs2_iget_begin: OK
> [  108.441104] Testing event generic_file_aio_read_ret: OK
> [  108.491103] Testing event ocfs2_prepare_inode_for_write: OK
> [  108.531153] Testing event ocfs2_remove_inode_range: OK
> [  108.571282] Testing event ocfs2_zero_partial_clusters_range2: OK
> [  108.611290] Testing event ocfs2_zero_partial_clusters_range1: OK
> [  108.695210] Testing event ocfs2_zero_partial_clusters: OK
> [  108.740699] Testing event ocfs2_write_remove_suid: OK
> [  108.790597] Testing event ocfs2_setattr: OK
> [  108.833157] Testing event ocfs2_zero_extend: OK
> [  108.870844] Testing event ocfs2_zero_extend_range: OK
> [  108.933485] Testing event ocfs2_write_zero_page: OK
> [  108.989375] Testing event ocfs2_extend_allocation_end: OK
> [  109.049499] Testing event ocfs2_extend_allocation: OK
> [  109.110689] Testing event ocfs2_truncate_file_error: OK
> [  109.152979] Testing event ocfs2_truncate_file: OK
> [  109.190909] Testing event ocfs2_file_aio_read: OK
> [  109.254889] Testing event ocfs2_file_splice_read: OK
> [  109.305323] Testing event ocfs2_file_splice_write: OK
> [  109.365267] Testing event ocfs2_file_aio_write: OK
> [  109.420658] Testing event ocfs2_sync_file: OK
> [  109.462312] Testing event ocfs2_file_release: OK
> [  109.501570] Testing event ocfs2_file_open: OK
> [  109.555102] Testing event ocfs2_fault: OK
> [  109.622367] Testing event ocfs2_write_end_inline: OK
> [  109.662119] Testing event ocfs2_write_begin_nolock: OK
> [  109.725251] Testing event ocfs2_try_to_write_inline_data: OK
> [  109.808599] Testing event ocfs2_bmap: OK
> [  109.865451] Testing event ocfs2_writepage: OK
> [  109.905485] Testing event ocfs2_readpage: OK
> [  109.960766] Testing event ocfs2_get_block_end: OK
> [  110.004104] Testing event ocfs2_get_block: OK
> [  110.055828] Testing event ocfs2_symlink_get_block: OK
> [  110.114597] Testing event ocfs2_refcount_cow_hunk: OK
> [  110.160711] Testing event ocfs2_make_clusters_writable: OK
> [  110.200732] Testing event ocfs2_replace_clusters: OK
> [  110.253441] Testing event ocfs2_clear_ext_refcount: OK
> [  110.352048] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [  110.394890] Testing event ocfs2_duplicate_clusters_by_page: OK
> [  110.430774] Testing event ocfs2_lock_refcount_allocators: OK
> [  110.484602] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [  110.534956] Testing event ocfs2_add_refcount_flag: OK
> [  110.594411] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [  110.654512] Testing event ocfs2_calc_refcount_meta_credits: OK
> [  110.714484] Testing event ocfs2_mark_extent_refcounted: OK
> [  110.775287] Testing event ocfs2_decrease_refcount: OK
> [  110.835310] Testing event ocfs2_decrease_refcount_rec: OK
> [  110.875451] Testing event ocfs2_restore_refcount_block: OK
> [  110.934346] Testing event ocfs2_remove_refcount_extent: OK
> [  111.004498] Testing event ocfs2_increase_refcount_split: OK
> [  111.045216] Testing event ocfs2_increase_refcount_insert: OK
> [  111.104489] Testing event ocfs2_increase_refcount_change: OK
> [  111.164410] Testing event ocfs2_increase_refcount_begin: OK
> [  111.224268] Testing event ocfs2_split_refcount_rec_insert: OK
> [  111.284270] Testing event ocfs2_split_refcount_rec: OK
> [  111.344407] Testing event ocfs2_insert_refcount_rec: OK
> [  111.423697] Testing event ocfs2_new_leaf_refcount_block: OK
> [  111.473920] Testing event ocfs2_divide_leaf_refcount_block: OK
> [  111.564218] Testing event ocfs2_expand_inline_ref_root: OK
> [  111.658985] Testing event ocfs2_change_refcount_rec: OK
> [  111.706323] Testing event ocfs2_create_refcount_tree_blkno: OK
> [  111.734328] Testing event ocfs2_create_refcount_tree: OK
> [  111.795516] Testing event ocfs2_purge_refcount_trees: OK
> [  111.884247] Testing event ocfs2_validate_refcount_block: OK
> [  111.995128] Testing event ocfs2_test_inode_bit: OK
> [  112.086761] Testing event ocfs2_test_suballoc_bit: OK
> [  112.145250] Testing event ocfs2_get_suballoc_slot_bit: OK
> [  112.225190] Testing event ocfs2_free_clusters: OK
> [  112.289249] Testing event ocfs2_free_suballoc_bits: OK
> [  112.364260] Testing event ocfs2_block_group_clear_bits: OK
> [  112.405246] Testing event ocfs2_claim_new_inode_at_loc: OK
> [  112.485406] Testing event ocfs2_claim_suballoc_bits: OK
> [  112.524968] Testing event ocfs2_search_chain_end: OK
> [  112.612271] Testing event ocfs2_search_chain_succ: OK
> [  112.702294] Testing event ocfs2_search_chain_begin: OK
> [  112.775182] Testing event ocfs2_block_group_search_max_block: OK
> [  112.825231] Testing event ocfs2_cluster_group_search_max_block: OK
> [  112.885254] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [  112.954219] Testing event ocfs2_relink_block_group: OK
> [  113.058702] Testing event ocfs2_block_group_set_bits: OK
> [  113.123543] Testing event ocfs2_reserve_new_inode_new_group: OK
> [  113.205926] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [  113.298455] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [  113.351544] Testing event ocfs2_block_group_alloc: OK
> [  113.411009] Testing event ocfs2_block_group_alloc_discontig: OK
> [  113.494492] Testing event ocfs2_block_group_alloc_contig: OK
> [  113.585001] Testing event ocfs2_validate_group_descriptor: OK
> [  113.664542] Testing event ocfs2_group_add: OK
> [  113.754490] Testing event ocfs2_group_extend: OK
> [  113.825455] Testing event ocfs2_update_last_group_and_inode: OK
> [  113.905886] Testing event ocfs2_local_alloc_new_window_result: OK
> [  114.017936] Testing event ocfs2_local_alloc_new_window: OK
> [  114.063589] Testing event ocfs2_sync_local_to_main_free: OK
> [  114.144852] Testing event ocfs2_sync_local_to_main: OK
> [  114.212751] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [  114.299093] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [  114.383658] Testing event ocfs2_local_alloc_count_bits: OK
> [  114.440609] Testing event ocfs2_reserve_local_alloc_bits: OK
> [  114.529454] Testing event ocfs2_begin_local_alloc_recovery: OK
> [  114.585369] Testing event ocfs2_load_local_alloc: OK
> [  114.651111] Testing event ocfs2_alloc_should_use_local: OK
> [  114.708606] Testing event ocfs2_la_set_sizes: OK
> [  114.782716] Testing event ocfs2_trim_fs: OK
> [  114.845272] Testing event ocfs2_trim_group: OK
> [  114.889521] Testing event ocfs2_trim_extent: OK
> [  114.942543] Testing event ocfs2_cache_block_dealloc: OK
> [  114.996137] Testing event ocfs2_run_deallocs: OK
> [  115.059362] Testing event ocfs2_cache_cluster_dealloc: OK
> [  115.118999] Testing event ocfs2_free_cached_blocks: OK
> [  115.169564] Testing event ocfs2_complete_truncate_log_recovery: OK
> [  115.219432] Testing event ocfs2_truncate_log_recovery_num: OK
> [  115.268560] Testing event ocfs2_begin_truncate_log_recovery: OK
> [  115.325291] Testing event ocfs2_flush_truncate_log: OK
> [  115.365053] Testing event ocfs2_replay_truncate_records: OK
> [  115.415716] Testing event ocfs2_truncate_log_append: OK
> [  115.452797] Testing event ocfs2_mark_extent_written: OK
> [  115.528716] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [  115.593493] Testing event ocfs2_rotate_leaf: OK
> [  115.642960] Testing event ocfs2_validate_extent_block: OK
> [  115.692999] Testing event ocfs2_commit_truncate: OK
> [  115.735282] Testing event ocfs2_remove_extent: OK
> [  115.781871] Testing event ocfs2_split_extent: OK
> [  115.821468] Testing event ocfs2_insert_extent: OK
> [  115.873044] Testing event ocfs2_rotate_subtree: OK
> [  115.935463] Testing event ocfs2_grow_tree: OK
> [  115.971070] Testing event ocfs2_complete_edge_insert: OK
> [  116.011180] Testing event ocfs2_num_free_extents: OK
> [  116.052397] Testing event ocfs2_add_clusters_in_btree: OK
> [  116.102451] Testing event ocfs2_insert_extent_start: OK
> [  116.142317] Testing event ocfs2_append_rec_to_path: OK
> [  116.202529] Testing event ocfs2_rotate_tree_right: OK
> [  116.264036] Testing event ocfs2_adjust_rightmost_branch: OK
> [  116.326365] Testing event btrfs_workqueue_destroy: OK
> [  116.397091] Testing event btrfs_workqueue_alloc: OK
> [  116.466216] Testing event btrfs_ordered_sched: OK
> [  116.525935] Testing event btrfs_all_work_done: OK
> [  116.597260] Testing event btrfs_normal_work_done: OK
> [  116.672534] Testing event btrfs_work_sched: OK
> [  116.731078] Testing event btrfs_work_queued: OK
> [  116.774812] Testing event free_extent_state: OK
> [  116.812715] Testing event alloc_extent_state: OK
> [  116.853319] Testing event btrfs_setup_cluster: OK
> [  116.891258] Testing event btrfs_failed_cluster_setup: OK
> [  116.955769] Testing event btrfs_find_cluster: OK
> [  116.996172] Testing event btrfs_reserve_extent_cluster: OK
> [  117.030967] Testing event btrfs_reserve_extent: OK
> [  117.076000] Testing event find_free_extent: OK
> [  117.110903] Testing event btrfs_reserved_extent_free: OK
> [  117.167738] Testing event btrfs_reserved_extent_alloc: OK
> [  117.213888] Testing event btrfs_space_reservation: OK
> [  117.251222] Testing event btrfs_cow_block: OK
> [  117.311442] Testing event btrfs_chunk_free: OK
> [  117.362199] Testing event btrfs_chunk_alloc: OK
> [  117.402066] Testing event run_delayed_ref_head: OK
> [  117.445312] Testing event add_delayed_ref_head: OK
> [  117.485044] Testing event run_delayed_data_ref: OK
> [  117.528035] Testing event add_delayed_data_ref: OK
> [  117.571893] Testing event run_delayed_tree_ref: OK
> [  117.614100] Testing event add_delayed_tree_ref: OK
> [  117.651192] Testing event btrfs_sync_fs: OK
> [  117.691418] Testing event btrfs_sync_file: OK
> [  117.742098] Testing event btrfs_writepage_end_io_hook: OK
> [  117.782941] Testing event __extent_writepage: OK
> [  117.820669] Testing event btrfs_ordered_extent_put: OK
> [  117.860706] Testing event btrfs_ordered_extent_start: OK
> [  117.900686] Testing event btrfs_ordered_extent_remove: OK
> [  117.940713] Testing event btrfs_ordered_extent_add: OK
> [  117.980598] Testing event btrfs_get_extent: OK
> [  118.020876] Testing event btrfs_inode_evict: OK
> [  118.061990] Testing event btrfs_inode_request: OK
> [  118.110717] Testing event btrfs_inode_new: OK
> [  118.162273] Testing event btrfs_transaction_commit: OK
> [  118.201702] Testing event gfs2_rs: OK
> [  118.241708] Testing event gfs2_block_alloc: OK
> [  118.281646] Testing event gfs2_bmap: OK
> [  118.321269] Testing event gfs2_ail_flush: OK
> [  118.372475] Testing event gfs2_log_blocks: OK
> [  118.411170] Testing event gfs2_log_flush: OK
> [  118.451110] Testing event gfs2_pin: OK
> [  118.490796] Testing event gfs2_glock_lock_time: OK
> [  118.531125] Testing event gfs2_glock_queue: OK
> [  118.570848] Testing event gfs2_promote: OK
> [  118.621073] Testing event gfs2_demote_rq: OK
> [  118.660835] Testing event gfs2_glock_put: OK
> [  118.701071] Testing event gfs2_glock_state_change: OK
> [  118.741176] Testing event block_rq_remap: OK
> [  118.791149] Testing event block_bio_remap: OK
> [  118.830839] Testing event block_split: OK
> [  118.871244] Testing event block_unplug: OK
> [  118.910834] Testing event block_plug: OK
> [  118.951183] Testing event block_sleeprq: OK
> [  118.990855] Testing event block_getrq: OK
> [  119.041742] Testing event block_bio_queue: OK
> [  119.080863] Testing event block_bio_frontmerge: OK
> [  119.131084] Testing event block_bio_backmerge: OK
> [  119.170889] Testing event block_bio_complete: OK
> [  119.221161] Testing event block_bio_bounce: OK
> [  119.260821] Testing event block_rq_issue: OK
> [  119.301117] Testing event block_rq_insert: OK
> [  119.340819] Testing event block_rq_complete: OK
> [  119.391119] Testing event block_rq_requeue: OK
> [  119.430808] Testing event block_rq_abort: OK
> [  119.471083] Testing event block_dirty_buffer: OK
> [  119.510738] Testing event block_touch_buffer: OK
> [  119.551157] Testing event swiotlb_bounced: OK
> [  119.590839] Testing event gpio_value: OK
> [  119.631148] Testing event gpio_direction: OK
> [  119.680817] Testing event aer_event: OK
> [  119.721151] Testing event regulator_set_voltage_complete: OK
> [  119.760718] Testing event regulator_set_voltage: OK
> [  119.800973] Testing event regulator_disable_complete: OK
> [  119.840742] Testing event regulator_disable: OK
> [  119.891117] Testing event regulator_enable_complete: OK
> [  119.930932] Testing event regulator_enable_delay: OK
> [  119.971005] Testing event regulator_enable: OK
> [  120.011611] Testing event urandom_read: OK
> [  120.061188] Testing event random_read: OK
> [  120.100898] Testing event extract_entropy_user: OK
> [  120.151005] Testing event extract_entropy: OK
> [  120.190880] Testing event get_random_bytes_arch: OK
> [  120.230993] Testing event get_random_bytes: OK
> [  120.270740] Testing event xfer_secondary_pool: OK
> [  120.311091] Testing event add_disk_randomness: OK
> [  120.350716] Testing event add_input_randomness: OK
> [  120.391151] Testing event debit_entropy: OK
> [  120.430806] Testing event push_to_pool: OK
> [  120.481052] Testing event credit_entropy_bits: OK
> [  120.520894] Testing event mix_pool_bytes_nolock: OK
> [  120.561100] Testing event mix_pool_bytes: OK
> [  120.610872] Testing event add_device_randomness: OK
> [  120.651074] Testing event drm_vblank_event_delivered: OK
> [  120.690944] Testing event drm_vblank_event_queued: OK
> [  120.731036] Testing event drm_vblank_event: OK
> [  120.770845] Testing event radeon_semaphore_wait: OK
> [  120.811218] Testing event radeon_semaphore_signale: OK
> [  120.850775] Testing event radeon_fence_wait_end: OK
> [  120.891210] Testing event radeon_fence_wait_begin: OK
> [  120.930782] Testing event radeon_fence_emit: OK
> [  120.971022] Testing event radeon_vm_set_page: OK
> [  121.011348] Testing event radeon_vm_bo_update: OK
> [  121.051174] Testing event radeon_vm_grab_id: OK
> [  121.090773] Testing event radeon_cs: OK
> [  121.141023] Testing event radeon_bo_create: OK
> [  121.180765] Testing event regcache_drop_region: OK
> [  121.221015] Testing event regmap_async_complete_done: OK
> [  121.270732] Testing event regmap_async_complete_start: OK
> [  121.311018] Testing event regmap_async_io_complete: OK
> [  121.350911] Testing event regmap_async_write_start: OK
> [  121.391316] Testing event regmap_cache_bypass: OK
> [  121.430787] Testing event regmap_cache_only: OK
> [  121.471132] Testing event regcache_sync: OK
> [  121.510843] Testing event regmap_hw_write_done: OK
> [  121.561044] Testing event regmap_hw_write_start: OK
> [  121.601023] Testing event regmap_hw_read_done: OK
> [  121.640751] Testing event regmap_hw_read_start: OK
> [  121.681136] Testing event regmap_reg_read_cache: OK
> [  121.720737] Testing event regmap_reg_read: OK
> [  121.761202] Testing event regmap_reg_write: OK
> [  121.800833] Testing event scsi_eh_wakeup: OK
> [  121.841109] Testing event scsi_dispatch_cmd_timeout: OK
> [  121.880738] Testing event scsi_dispatch_cmd_done: OK
> [  121.921197] Testing event scsi_dispatch_cmd_error: OK
> [  121.960747] Testing event scsi_dispatch_cmd_start: OK
> [  122.001135] Testing event target_cmd_complete: OK
> [  122.050749] Testing event target_sequencer_start: OK
> [  122.090996] Testing event spi_transfer_stop: OK
> [  122.130712] Testing event spi_transfer_start: OK
> [  122.171151] Testing event spi_message_done: OK
> [  122.210903] Testing event spi_message_start: OK
> [  122.250970] Testing event spi_message_submit: OK
> [  122.290905] Testing event spi_master_busy: OK
> [  122.331209] Testing event spi_master_idle: OK
> [  122.380795] Testing event smbus_result: OK
> [  122.420982] Testing event smbus_reply: OK
> [  122.460914] Testing event smbus_read: OK
> [  122.500973] Testing event smbus_write: OK
> [  122.540784] Testing event i2c_result: OK
> [  122.580988] Testing event i2c_reply: OK
> [  122.620941] Testing event i2c_read: OK
> [  122.661010] Testing event i2c_write: OK
> [  122.700738] Testing event mc_event: OK
> [  122.750954] Testing event snd_soc_cache_sync: OK
> [  122.800847] Testing event snd_soc_jack_notify: OK
> [  122.841135] Testing event snd_soc_jack_report: OK
> [  122.880860] Testing event snd_soc_jack_irq: OK
> [  122.921114] Testing event snd_soc_dapm_connected: OK
> [  122.960868] Testing event snd_soc_dapm_input_path: OK
> [  123.011532] Testing event snd_soc_dapm_output_path: OK
> [  123.051206] Testing event snd_soc_dapm_walk_done: OK
> [  123.091835] Testing event snd_soc_dapm_widget_event_done: OK
> [  123.131190] Testing event snd_soc_dapm_widget_event_start: OK
> [  123.171869] Testing event snd_soc_dapm_widget_power: OK
> [  123.211235] Testing event snd_soc_dapm_done: OK
> [  123.261668] Testing event snd_soc_dapm_start: OK
> [  123.301278] Testing event snd_soc_bias_level_done: OK
> [  123.341864] Testing event snd_soc_bias_level_start: OK
> [  123.381225] Testing event snd_soc_preg_read: OK
> [  123.421547] Testing event snd_soc_preg_write: OK
> [  123.471470] Testing event snd_soc_reg_read: OK
> [  123.521487] Testing event snd_soc_reg_write: OK
> [  123.561409] Testing event sst_ipc_outbox_write: OK
> [  123.601481] Testing event sst_ipc_outbox_read: OK
> [  123.641556] Testing event sst_ipc_inbox_write: OK
> [  123.681823] Testing event sst_ipc_inbox_read: OK
> [  123.721185] Testing event sst_ipc_outbox_wdata: OK
> [  123.761889] Testing event sst_ipc_outbox_rdata: OK
> [  123.801440] Testing event sst_ipc_inbox_wdata: OK
> [  123.841719] Testing event sst_ipc_inbox_rdata: OK
> [  123.891417] Testing event sst_ipc_msg_rx: OK
> [  123.941552] Testing event sst_ipc_msg_tx: OK
> [  123.981178] Testing event udp_fail_queue_rcv_skb: OK
> [  124.021833] Testing event sock_exceed_buf_limit: OK
> [  124.061385] Testing event sock_rcvqueue_full: OK
> [  124.111724] Testing event napi_poll: OK
> [  124.161275] Testing event netif_rx_ni_entry: OK
> [  124.201783] Testing event netif_rx_entry: OK
> [  124.241422] Testing event netif_receive_skb_entry: OK
> [  124.281766] Testing event napi_gro_receive_entry: OK
> [  124.321402] Testing event napi_gro_frags_entry: OK
> [  124.361772] Testing event netif_rx: OK
> [  124.401486] Testing event netif_receive_skb: OK
> [  124.441788] Testing event net_dev_queue: OK
> [  124.481528] Testing event net_dev_xmit: OK
> [  124.531966] Testing event net_dev_start_xmit: OK
> [  124.571505] Testing event skb_copy_datagram_iovec: OK
> [  124.611861] Testing event consume_skb: OK
> [  124.651463] Testing event kfree_skb: OK
> [  124.691786] Testing event 9p_protocol_dump: OK
> [  124.731595] Testing event 9p_client_res: OK
> [  124.771849] Testing event 9p_client_req: OK
> [  124.811484] Running tests on trace event systems:
> [  124.812387] Testing event system 9p: OK
> [  124.851735] Testing event system skb: OK
> [  124.891475] Testing event system net: OK
> [  124.931819] Testing event system napi: OK
> [  124.971564] Testing event system sock: OK
> [  125.011818] Testing event system udp: OK
> [  125.051472] Testing event system intel-sst: OK
> [  125.091920] Testing event system asoc: OK
> [  125.131544] Testing event system i2c: OK
> [  125.171937] Testing event system spi: OK
> [  125.211486] Testing event system target: OK
> [  125.251720] Testing event system scsi: OK
> [  125.291465] Testing event system regmap: OK
> [  125.331830] Testing event system radeon: OK
> [  125.371452] Testing event system drm: OK
> [  125.411743] Testing event system random: OK
> [  125.451574] Testing event system regulator: OK
> [  125.501770] Testing event system ras: OK
> [  125.541421] Testing event system gpio: OK
> [  125.591585] Testing event system swiotlb: OK
> [  125.641320] Testing event system block: OK
> [  125.681845] Testing event system gfs2: OK
> [  125.721551] Testing event system btrfs: OK
> [  125.762089] Testing event system ocfs2: OK
> [  125.834319] Testing event system xfs: OK
> [  125.984990] Testing event system jbd2: OK
> [  126.031637] Testing event system writeback: OK
> [  126.082085] Testing event system migrate: OK
> [  126.121323] Testing event system compaction: OK
> [  126.161396] Testing event system kmem: OK
> [  126.201404] Testing event system vmscan: OK
> [  126.241498] Testing event system pagemap: OK
> [  126.281387] Testing event system oom: OK
> [  126.321109] Testing event system filemap: OK
> [  126.361219] Testing event system context_tracking: OK
> [  126.400846] Testing event system power: OK
> [  126.441473] Testing event system test: OK
> [  126.481443] Testing event system rcu: OK
> [  126.521202] Testing event system printk: OK
> [  126.561268] Testing event system lock: OK
> [  126.601484] Testing event system sched: OK
> [  126.641587] Testing event system workqueue: OK
> [  126.681427] Testing event system signal: OK
> [  126.721235] Testing event system timer: OK
> [  126.761333] Testing event system irq: OK
> [  126.801365] Testing event system task: OK
> [  126.841177] Testing event system exceptions: OK
> [  126.881122] Testing event system raw_syscalls: OK
> [  126.931130] Testing event system vsyscall: OK
> [  126.971324] Testing event system nmi: OK
> [  127.011286] Testing event system irq_vectors: OK
> [  127.051495] Testing event system kvmmmu: OK
> [  127.091535] Testing event system kvm: OK
> [  127.131945] Running tests on all trace events:
> [  127.132802] Testing all events: OK
> [  127.345075] Testing ftrace filter: OK
> [  127.365801] Btrfs loaded, assert=on
> [  127.367436] Key type encrypted registered
> [  127.370774] rcu-torture: rtc: ffffffff8e518dc0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [  127.370774] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
> [  127.370774] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
> [  127.370774] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> [  127.370774] ??? Writer stall state 5 g4430 c4429 f0x0
> [  127.377308] rtc-test rtc-test.0: setting system clock to 2014-09-13 09:23:17 UTC (1410600197)
> [  127.385500] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [  127.386972] EDD information not available.
> [  127.388544] Unregister pv shared memory for cpu 0
> [  127.463624] CPU 0 is now offline
> [  127.464185] ALSA device list:
> [  127.464626]   No soundcards found.
> [  127.524726] Freeing unused kernel memory: 3116K (ffffffff8da3a000 - ffffffff8dd45000)
> [  127.536231] Write protecting the kernel read-only data: 28672k
> [  127.579722] Freeing unused kernel memory: 528K (ffff88000b77c000 - ffff88000b800000)
> [  127.655282] Freeing unused kernel memory: 1736K (ffff88000c24e000 - ffff88000c400000)
> [  127.683966] random: init urandom read with 86 bits of entropy available
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> [  138.124899] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> [  138.145317] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [  138.248843] sock: sock_set_timeout: `trinity-main' (pid 2561) tries to set negative timeout
> [  138.294371] sock: sock_set_timeout: `trinity-main' (pid 2561) tries to set negative timeout
> [  138.311235] sock: sock_set_timeout: `trinity-main' (pid 2561) tries to set negative timeout
> [  138.330723] sock: sock_set_timeout: `trinity-main' (pid 2561) tries to set negative timeout
> [  138.441674] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [  187.371763] rcu-torture: rtc: ffffffff8e518dc0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [  187.371763] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
> [  187.371763] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
> [  187.371763] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> [  187.371763] ??? Writer stall state 5 g4524 c4524 f0x0
> [  187.941641] random: nonblocking pool is initialized
> plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
> /etc/lsb-base-logging.sh: line 5:  2580 Aborted                 plymouth --ping > /dev/null 2>&1
> /etc/lsb-base-logging.sh: line 5:  2585 Aborted                 plymouth --ping > /dev/null 2>&1
> mount: proc has wrong device number or fs type proc not supported
> /etc/lsb-base-logging.sh: line 5:  2601 Aborted                 plymouth --ping > /dev/null 2>&1
> /etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> umount: /var/run: not mounted
> umount: /var/lock: not mounted
> umount: /dev/shm: not mounted
> mount: / is busy
>  * Will now restart
> [  194.805716] Unregister pv shared memory for cpu 1
> [  194.806632] rcu-torture: Unscheduled system shutdown detected
> [  194.807593] no ifx modem active;
> [  194.810165] torture thread rcu_torture_reader parking due to system shutdown
> [  194.811326] torture thread rcu_torture_fakewriter parking due to system shutdown
> [  194.812429] torture thread rcu_torture_fakewriter parking due to system shutdown
> [  194.813642] torture thread rcu_torture_fakewriter parking due to system shutdown
> [  194.814820] torture thread rcu_torture_reader parking due to system shutdown
> [  194.815969] torture thread rcu_torture_fakewriter parking due to system shutdown
> [  194.818240] torture thread rcu_torture_reader parking due to system shutdown
> [  194.819543] torture thread rcu_torture_writer parking due to system shutdown
> [  194.820838] torture thread rcu_torture_reader parking due to system shutdown
> [  194.822220] ------------[ cut here ]------------
> [  194.823103] WARNING: CPU: 1 PID: 2561 at kernel/events/core.c:5657 perf_swevent_add+0x11f/0x1b4()
> [  194.824813] CPU: 1 PID: 2561 Comm: trinity-main Not tainted 3.15.0-rc1-00025-g499c632 #25
> [  194.826192] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  194.827225]  0000000000000001 ffff880012281b48 ffffffff8b76173a 0000000000000000
> [  194.828530]  0000000000000009 ffff880012281b80 ffffffff8a8fe96f ffffffff8a9b7dbd
> [  194.829751]  ffff880012cc1a78 0000000000000000 0000000000000001 ffff880012d41c01
> [  194.830757] Call Trace:
> [  194.830757]  [<ffffffff8b76173a>] dump_stack+0x84/0xf8
> [  194.830757]  [<ffffffff8a8fe96f>] warn_slowpath_common+0x91/0xaa
> [  194.830757]  [<ffffffff8a9b7dbd>] ? perf_swevent_add+0x11f/0x1b4
> [  194.830757]  [<ffffffff8a8fea5a>] warn_slowpath_null+0x1a/0x1c
> [  194.830757]  [<ffffffff8a9b7dbd>] perf_swevent_add+0x11f/0x1b4
> [  194.830757]  [<ffffffff8a9b4667>] event_sched_in+0xbb/0x201
> [  194.830757]  [<ffffffff8a9b4812>] group_sched_in+0x65/0x1d9
> [  194.830757]  [<ffffffff8a9b4b0e>] ctx_sched_in+0x188/0x2e7
> [  194.830757]  [<ffffffff8a9b53cb>] perf_event_sched_in+0x59/0x9b
> [  194.830757]  [<ffffffff8a9b54af>] perf_event_context_sched_in+0xa2/0xca
> [  194.830757]  [<ffffffff8a9b5536>] __perf_event_task_sched_in+0x5f/0x1fc
> [  194.830757]  [<ffffffff8a934730>] finish_task_switch+0x8b/0x191
> [  194.830757]  [<ffffffff8b76d0b1>] __schedule+0x78a/0x9d2
> [  194.830757]  [<ffffffff8b76d550>] preempt_schedule_irq+0x9d/0x10d
> [  194.830757]  [<ffffffff8b7754e0>] retint_kernel+0x20/0x30
> [  194.830757]  [<ffffffff8a9c05ac>] ? arch_local_irq_restore+0x44/0x50
> [  194.830757]  [<ffffffff8a9c0a08>] context_tracking_user_exit+0x15b/0x162
> [  194.830757]  [<ffffffff8a850e71>] user_exit+0x1d/0x1f
> [  194.830757]  [<ffffffff8a8526ea>] syscall_trace_enter+0x1a/0x219
> [  194.830757]  [<ffffffff8b775e2b>] tracesys+0x71/0xd5
> [  194.830757] ---[ end trace 937bd687e3823e78 ]---
> [  194.853307] reboot: Restarting system
> [  194.853921] reboot: machine restart
> Elapsed time: 205
> qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:499c632dce47e95280f8b99540c5db294053c94c:bisect-linux-8/.vmlinuz-499c632dce47e95280f8b99540c5db294053c94c-20140913172231-14-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/499c632dce47e95280f8b99540c5db294053c94c/vmlinuz-3.15.0-rc1-00025-g499c632 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-kbuild-18 -serial file:/dev/shm/kboot/serial-quantal-kbuild-18 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.15.0-rc1 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> CONFIG_POSIX_MQUEUE=y
> # CONFIG_FHANDLE is not set
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> # CONFIG_TASK_IO_ACCOUNTING is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_RCU_USER_QS=y
> CONFIG_CONTEXT_TRACKING_FORCE=y
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_IKCONFIG=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> CONFIG_CGROUP_DEVICE=y
> # CONFIG_CPUSETS is not set
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> CONFIG_CGROUP_HUGETLB=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> # CONFIG_FAIR_GROUP_SCHED is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_CHECKPOINT_RESTORE=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> # CONFIG_SYSFS_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> # CONFIG_ELF_CORE is not set
> # CONFIG_PCSPKR_PLATFORM is not set
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> # CONFIG_SIGNALFD is not set
> # CONFIG_TIMERFD is not set
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> # CONFIG_AIO is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> # CONFIG_VM_EVENT_COUNTERS is not set
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_COMPAT_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> # CONFIG_GCOV_PROFILE_ALL is not set
> CONFIG_GCOV_FORMAT_AUTODETECT=y
> # CONFIG_GCOV_FORMAT_3_4 is not set
> # CONFIG_GCOV_FORMAT_4_7 is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> # CONFIG_MODULES is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_CFQ_GROUP_IOSCHED is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_VSMP=y
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_DEBUG=y
> CONFIG_PARAVIRT_SPINLOCKS=y
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=12
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> # CONFIG_PROCESSOR_SELECT is not set
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> CONFIG_CALGARY_IOMMU=y
> # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_MAXSMP=y
> CONFIG_NR_CPUS=8192
> # CONFIG_SCHED_SMT is not set
> # CONFIG_SCHED_MC is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> # CONFIG_I8K is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> # CONFIG_X86_MSR is not set
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_DIRECT_GBPAGES is not set
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_CLEANCACHE=y
> # CONFIG_CMA is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> CONFIG_DEBUG_HOTPLUG_CPU0=y
> CONFIG_COMPAT_VDSO=y
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_P4_CLOCKMOD=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Memory power savings
> #
> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
> CONFIG_I7300_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> CONFIG_PCIE_ECRC=y
> CONFIG_PCIEAER_INJECT=y
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> # CONFIG_PCIEASPM_DEFAULT is not set
> CONFIG_PCIEASPM_POWERSAVE=y
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> # CONFIG_HT_IRQ is not set
> CONFIG_PCI_ATS=y
> # CONFIG_PCI_IOV is not set
> CONFIG_PCI_PRI=y
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> # CONFIG_PD6729 is not set
> # CONFIG_I82092 is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=y
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NET_PTP_CLASSIFY=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_ATM=y
> # CONFIG_ATM_LANE is not set
> CONFIG_STP=y
> CONFIG_GARP=y
> CONFIG_MRP=y
> CONFIG_BRIDGE=y
> # CONFIG_BRIDGE_VLAN_FILTERING is not set
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> # CONFIG_ATALK is not set
> CONFIG_X25=y
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> CONFIG_OPENVSWITCH=y
> # CONFIG_VSOCKETS is not set
> CONFIG_NETLINK_MMAP=y
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> CONFIG_HSR=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=y
> # CONFIG_CAN_GW is not set
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> CONFIG_CAN_SLCAN=y
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> # CONFIG_CAN_LEDS is not set
> # CONFIG_CAN_MCP251X is not set
> CONFIG_CAN_JANZ_ICAN3=y
> # CONFIG_PCH_CAN is not set
> CONFIG_CAN_SJA1000=y
> CONFIG_CAN_SJA1000_ISA=y
> CONFIG_CAN_SJA1000_PLATFORM=y
> # CONFIG_CAN_EMS_PCMCIA is not set
> CONFIG_CAN_EMS_PCI=y
> CONFIG_CAN_PEAK_PCMCIA=y
> CONFIG_CAN_PEAK_PCI=y
> # CONFIG_CAN_PEAK_PCIEC is not set
> # CONFIG_CAN_KVASER_PCI is not set
> CONFIG_CAN_PLX_PCI=y
> CONFIG_CAN_C_CAN=y
> CONFIG_CAN_C_CAN_PLATFORM=y
> CONFIG_CAN_C_CAN_PCI=y
> CONFIG_CAN_CC770=y
> CONFIG_CAN_CC770_ISA=y
> CONFIG_CAN_CC770_PLATFORM=y
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> # CONFIG_IRLAN is not set
> CONFIG_IRCOMM=y
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=y
> 
> #
> # Dongle support
> #
> # CONFIG_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> CONFIG_NSC_FIR=y
> # CONFIG_WINBOND_FIR is not set
> CONFIG_SMC_IRCC_FIR=y
> CONFIG_ALI_FIR=y
> CONFIG_VLSI_FIR=y
> CONFIG_VIA_FIR=y
> CONFIG_BT=y
> CONFIG_BT_RFCOMM=y
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> # CONFIG_BT_HIDP is not set
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTSDIO=y
> # CONFIG_BT_HCIUART is not set
> CONFIG_BT_HCIDTL1=y
> CONFIG_BT_HCIBT3C=y
> # CONFIG_BT_HCIBLUECARD is not set
> # CONFIG_BT_HCIBTUART is not set
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> CONFIG_BT_MRVL_SDIO=y
> CONFIG_BT_WILINK=y
> # CONFIG_WIRELESS is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_REGULATOR=y
> CONFIG_RFKILL_GPIO=y
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_VIRTIO is not set
> # CONFIG_NET_9P_DEBUG is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=y
> CONFIG_CAIF_USB=y
> CONFIG_NFC=y
> # CONFIG_NFC_DIGITAL is not set
> # CONFIG_NFC_NCI is not set
> CONFIG_NFC_HCI=y
> # CONFIG_NFC_SHDLC is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_SIM is not set
> CONFIG_NFC_PN544=y
> CONFIG_NFC_MICROREAD=y
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=y
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
> CONFIG_MTD_CMDLINE_PARTS=y
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> CONFIG_FTL=y
> CONFIG_NFTL=y
> # CONFIG_NFTL_RW is not set
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> CONFIG_SSFDC=y
> CONFIG_SM_FTL=y
> # CONFIG_MTD_OOPS is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> # CONFIG_MTD_CFI_INTELEXT is not set
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> # CONFIG_MTD_ROM is not set
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> CONFIG_MTD_PHYSMAP=y
> # CONFIG_MTD_PHYSMAP_COMPAT is not set
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> CONFIG_MTD_CK804XROM=y
> CONFIG_MTD_SCB2_FLASH=y
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> CONFIG_MTD_PCI=y
> # CONFIG_MTD_PCMCIA is not set
> CONFIG_MTD_GPIO_ADDR=y
> CONFIG_MTD_INTEL_VR_NOR=y
> # CONFIG_MTD_PLATRAM is not set
> # CONFIG_MTD_LATCH_ADDR is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_DATAFLASH is not set
> CONFIG_MTD_M25P80=y
> # CONFIG_MTD_SST25L is not set
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> # CONFIG_MTD_MTDRAM is not set
> CONFIG_MTD_BLOCK2MTD=y
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=y
> # CONFIG_MTD_NAND_ECC_SMC is not set
> # CONFIG_MTD_NAND is not set
> CONFIG_MTD_ONENAND=y
> # CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
> # CONFIG_MTD_ONENAND_GENERIC is not set
> # CONFIG_MTD_ONENAND_OTP is not set
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> 
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> CONFIG_MTD_UBI_GLUEBI=y
> CONFIG_MTD_UBI_BLOCK=y
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_SERIAL=y
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SKD is not set
> # CONFIG_BLK_DEV_OSD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> # CONFIG_AD525X_DPOT_SPI is not set
> CONFIG_DUMMY_IRQ=y
> CONFIG_IBM_ASM=y
> CONFIG_PHANTOM=y
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> # CONFIG_TIFM_7XX1 is not set
> CONFIG_ICS932S401=y
> # CONFIG_ATMEL_SSC is not set
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> # CONFIG_SENSORS_BH1780 is not set
> CONFIG_SENSORS_BH1770=y
> # CONFIG_SENSORS_APDS990X is not set
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> # CONFIG_TI_DAC7512 is not set
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> # CONFIG_BMP085_I2C is not set
> CONFIG_BMP085_SPI=y
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=y
> CONFIG_LATTICE_ECP3_CONFIG=y
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=y
> CONFIG_CB710_CORE=y
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_TI_ST=y
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Host Driver
> #
> CONFIG_INTEL_MIC_HOST=y
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_INTEL_MIC_CARD is not set
> CONFIG_GENWQE=y
> CONFIG_ECHO=y
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_IDE_GD is not set
> CONFIG_BLK_DEV_IDECS=y
> # CONFIG_BLK_DEV_DELKIN is not set
> CONFIG_BLK_DEV_IDECD=y
> # CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> CONFIG_IDE_TASK_IOCTL=y
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=y
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> CONFIG_BLK_DEV_OFFBOARD=y
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_RZ1000=y
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_AEC62XX=y
> # CONFIG_BLK_DEV_ALI15X3 is not set
> CONFIG_BLK_DEV_AMD74XX=y
> CONFIG_BLK_DEV_ATIIXP=y
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> CONFIG_BLK_DEV_HPT366=y
> CONFIG_BLK_DEV_JMICRON=y
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=y
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> CONFIG_BLK_DEV_IT821X=y
> # CONFIG_BLK_DEV_NS87415 is not set
> CONFIG_BLK_DEV_PDC202XX_OLD=y
> CONFIG_BLK_DEV_PDC202XX_NEW=y
> CONFIG_BLK_DEV_SVWKS=y
> CONFIG_BLK_DEV_SIIMAGE=y
> CONFIG_BLK_DEV_SIS5513=y
> CONFIG_BLK_DEV_SLC90E66=y
> # CONFIG_BLK_DEV_TRM290 is not set
> CONFIG_BLK_DEV_VIA82CXXX=y
> CONFIG_BLK_DEV_TC86C001=y
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> CONFIG_CHR_DEV_OSST=y
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> # CONFIG_SCSI_ENCLOSURE is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=y
> CONFIG_SCSI_OSD_ULD=y
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> CONFIG_ISCSI_TARGET=y
> # CONFIG_SBP_TARGET is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> CONFIG_FIREWIRE_SBP2=y
> CONFIG_FIREWIRE_NOSY=y
> CONFIG_I2O=y
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=y
> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
> CONFIG_I2O_CONFIG=y
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=y
> # CONFIG_I2O_BLOCK is not set
> CONFIG_I2O_SCSI=y
> # CONFIG_I2O_PROC is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_NETDEVICES is not set
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=y
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> # CONFIG_MOUSE_PS2_ALPS is not set
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> # CONFIG_MOUSE_PS2_TRACKPOINT is not set
> CONFIG_MOUSE_PS2_ELANTECH=y
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> CONFIG_MOUSE_PS2_TOUCHKIT=y
> CONFIG_MOUSE_SERIAL=y
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_AD714X=y
> CONFIG_INPUT_AD714X_I2C=y
> CONFIG_INPUT_AD714X_SPI=y
> CONFIG_INPUT_ARIZONA_HAPTICS=y
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_MAX8925_ONKEY=y
> CONFIG_INPUT_MC13783_PWRBUTTON=y
> CONFIG_INPUT_MMA8450=y
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> CONFIG_INPUT_GP2A=y
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=y
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=y
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF8574=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> CONFIG_INPUT_DA9052_ONKEY=y
> CONFIG_INPUT_WM831X_ON=y
> CONFIG_INPUT_PCAP=y
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=y
> # CONFIG_INPUT_ADXL34X_SPI is not set
> # CONFIG_INPUT_CMA3000 is not set
> CONFIG_INPUT_IDEAPAD_SLIDEBAR=y
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> # CONFIG_UNIX98_PTYS is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> CONFIG_CYZ_INTR=y
> CONFIG_MOXA_INTELLIO=y
> CONFIG_MOXA_SMARTIO=y
> CONFIG_SYNCLINK=y
> # CONFIG_SYNCLINKMP is not set
> # CONFIG_SYNCLINK_GT is not set
> # CONFIG_NOZOMI is not set
> CONFIG_ISI=y
> # CONFIG_N_HDLC is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_ROUTER is not set
> CONFIG_TRACE_SINK=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_CS=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> CONFIG_SERIAL_MAX310X=y
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> CONFIG_SERIAL_SCCNXP=y
> # CONFIG_SERIAL_SCCNXP_CONSOLE is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> CONFIG_SERIAL_IFX6X60=y
> # CONFIG_SERIAL_PCH_UART is not set
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=y
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> CONFIG_MWAVE=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> # CONFIG_TCG_TIS is not set
> CONFIG_TCG_TIS_I2C_ATMEL=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> # CONFIG_TCG_TIS_I2C_NUVOTON is not set
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TCG_ST33_I2C=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=y
> # CONFIG_I2C_MUX_PCA9541 is not set
> # CONFIG_I2C_MUX_PCA954x is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=y
> CONFIG_I2C_AMD756_S4882=y
> CONFIG_I2C_AMD8111=y
> CONFIG_I2C_I801=y
> # CONFIG_I2C_ISCH is not set
> CONFIG_I2C_ISMT=y
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=y
> # CONFIG_I2C_NFORCE2_S4985 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> CONFIG_I2C_VIA=y
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=y
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> CONFIG_I2C_DESIGNWARE_PCI=y
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_GPIO is not set
> CONFIG_I2C_KEMPLD=y
> CONFIG_I2C_OCORES=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> CONFIG_I2C_TAOS_EVM=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=y
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> CONFIG_SPI_GPIO=y
> CONFIG_SPI_LM70_LLP=y
> CONFIG_SPI_OC_TINY=y
> CONFIG_SPI_PXA2XX_DMA=y
> CONFIG_SPI_PXA2XX=y
> CONFIG_SPI_PXA2XX_PCI=y
> CONFIG_SPI_SC18IS602=y
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_XCOMM=y
> # CONFIG_SPI_XILINX is not set
> CONFIG_SPI_DESIGNWARE=y
> # CONFIG_SPI_DW_PCI is not set
> CONFIG_SPI_DW_MMIO=y
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> CONFIG_SPI_TLE62X0=y
> CONFIG_SPMI=y
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_PARPORT=y
> # CONFIG_PPS_CLIENT_GPIO is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_DA9052=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_F7188X is not set
> CONFIG_GPIO_SCH311X=y
> CONFIG_GPIO_SCH=y
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_ARIZONA is not set
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> CONFIG_GPIO_PCF857X=y
> CONFIG_GPIO_RC5T583=y
> # CONFIG_GPIO_SX150X is not set
> # CONFIG_GPIO_TC3589X is not set
> CONFIG_GPIO_TPS65912=y
> # CONFIG_GPIO_WM831X is not set
> # CONFIG_GPIO_WM8350 is not set
> CONFIG_GPIO_ADP5588=y
> # CONFIG_GPIO_ADP5588_IRQ is not set
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_BT8XX=y
> CONFIG_GPIO_AMD8111=y
> CONFIG_GPIO_INTEL_MID=y
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MC33880 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=y
> CONFIG_GPIO_PALMAS=y
> CONFIG_GPIO_TPS6586X=y
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> CONFIG_MAX8925_POWER=y
> # CONFIG_WM831X_BACKUP is not set
> CONFIG_WM831X_POWER=y
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=y
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> # CONFIG_BATTERY_BQ27X00_I2C is not set
> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_LP8727=y
> CONFIG_CHARGER_GPIO=y
> CONFIG_CHARGER_MANAGER=y
> CONFIG_CHARGER_MAX14577=y
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_BQ24190=y
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> # CONFIG_SENSORS_ABITUGURU3 is not set
> CONFIG_SENSORS_AD7314=y
> CONFIG_SENSORS_AD7414=y
> # CONFIG_SENSORS_AD7418 is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> CONFIG_SENSORS_ADT7410=y
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_APPLESMC=y
> # CONFIG_SENSORS_ASB100 is not set
> CONFIG_SENSORS_ATXP1=y
> # CONFIG_SENSORS_DS620 is not set
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9052_ADC=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=y
> CONFIG_SENSORS_F75375S=y
> # CONFIG_SENSORS_MC13783_ADC is not set
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IIO_HWMON=y
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4222=y
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4260=y
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_MAX1111 is not set
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> CONFIG_SENSORS_MAX6697=y
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_ADCXX=y
> # CONFIG_SENSORS_LM63 is not set
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> # CONFIG_SENSORS_PC87360 is not set
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_NCT6775 is not set
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=y
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_SMM665=y
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> # CONFIG_SENSORS_W83L785TS is not set
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> CONFIG_SENSORS_WM8350=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> # CONFIG_SSB_PCMCIAHOST is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> # CONFIG_SSB_SDIOHOST is not set
> CONFIG_SSB_SILENT=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_AAT2870_CORE=y
> CONFIG_MFD_BCM590XX=y
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> # CONFIG_MFD_DA9052_SPI is not set
> CONFIG_MFD_DA9052_I2C=y
> # CONFIG_MFD_DA9055 is not set
> # CONFIG_MFD_DA9063 is not set
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_SPI=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> # CONFIG_MFD_88PM860X is not set
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77686 is not set
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_EZX_PCAP=y
> CONFIG_MFD_RETU=y
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> CONFIG_MFD_RTSX_PCI=y
> CONFIG_MFD_RC5T583=y
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP3943 is not set
> CONFIG_MFD_LP8788=y
> CONFIG_MFD_PALMAS=y
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> CONFIG_MFD_TPS65218=y
> CONFIG_MFD_TPS6586X=y
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> CONFIG_MFD_TPS65912_SPI=y
> CONFIG_MFD_TPS80031=y
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_ARIZONA_SPI=y
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM831X_SPI=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_ACT8865=y
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AAT2870=y
> CONFIG_REGULATOR_ARIZONA=y
> # CONFIG_REGULATOR_BCM590XX is not set
> CONFIG_REGULATOR_DA903X=y
> CONFIG_REGULATOR_DA9052=y
> CONFIG_REGULATOR_DA9210=y
> # CONFIG_REGULATOR_FAN53555 is not set
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_LP3971 is not set
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=y
> # CONFIG_REGULATOR_LP8788 is not set
> # CONFIG_REGULATOR_MAX14577 is not set
> CONFIG_REGULATOR_MAX1586=y
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> # CONFIG_REGULATOR_MAX8998 is not set
> # CONFIG_REGULATOR_MAX77693 is not set
> CONFIG_REGULATOR_MC13XXX_CORE=y
> # CONFIG_REGULATOR_MC13783 is not set
> CONFIG_REGULATOR_MC13892=y
> # CONFIG_REGULATOR_PALMAS is not set
> CONFIG_REGULATOR_PCAP=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_RC5T583=y
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS6524X=y
> # CONFIG_REGULATOR_TPS6586X is not set
> CONFIG_REGULATOR_TPS65912=y
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_WM831X=y
> # CONFIG_REGULATOR_WM8350 is not set
> CONFIG_REGULATOR_WM8400=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> # CONFIG_VGA_ARB is not set
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_UMS=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> CONFIG_DRM_VIA=y
> # CONFIG_DRM_SAVAGE is not set
> CONFIG_DRM_VMWGFX=y
> CONFIG_DRM_VMWGFX_FBCON=y
> CONFIG_DRM_GMA500=y
> CONFIG_DRM_GMA600=y
> # CONFIG_DRM_GMA3600 is not set
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_AST=y
> # CONFIG_DRM_MGAG200 is not set
> CONFIG_DRM_CIRRUS_QEMU=y
> CONFIG_DRM_QXL=y
> # CONFIG_DRM_BOCHS is not set
> CONFIG_DRM_PTN3460=y
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> CONFIG_FB_PM2=y
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=y
> CONFIG_FB_ASILIANT=y
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_VESA=y
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> CONFIG_FB_OPENCORES=y
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_I740=y
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> CONFIG_FB_ATY=y
> CONFIG_FB_ATY_CT=y
> CONFIG_FB_ATY_GENERIC_LCD=y
> # CONFIG_FB_ATY_GX is not set
> CONFIG_FB_ATY_BACKLIGHT=y
> # CONFIG_FB_S3 is not set
> CONFIG_FB_SAVAGE=y
> # CONFIG_FB_SAVAGE_I2C is not set
> # CONFIG_FB_SAVAGE_ACCEL is not set
> CONFIG_FB_SIS=y
> # CONFIG_FB_SIS_300 is not set
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=y
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> # CONFIG_FB_VIA_X_COMPATIBILITY is not set
> # CONFIG_FB_NEOMAGIC is not set
> CONFIG_FB_KYRO=y
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> CONFIG_FB_VT8623=y
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> CONFIG_FB_PM3=y
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_GOLDFISH is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=y
> # CONFIG_FB_AUO_K190X is not set
> CONFIG_FB_SIMPLE=y
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_L4F00242T03=y
> CONFIG_LCD_LMS283GF05=y
> CONFIG_LCD_LTV350QV=y
> # CONFIG_LCD_ILI922X is not set
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=y
> CONFIG_LCD_S6E63M0=y
> CONFIG_LCD_LD9040=y
> CONFIG_LCD_AMS369FG06=y
> CONFIG_LCD_LMS501KF03=y
> # CONFIG_LCD_HX8357 is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> CONFIG_BACKLIGHT_LM3533=y
> # CONFIG_BACKLIGHT_CARILLO_RANCH is not set
> # CONFIG_BACKLIGHT_DA903X is not set
> CONFIG_BACKLIGHT_DA9052=y
> CONFIG_BACKLIGHT_MAX8925=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_AAT2870 is not set
> # CONFIG_BACKLIGHT_LM3630A is not set
> CONFIG_BACKLIGHT_LM3639=y
> # CONFIG_BACKLIGHT_LP855X is not set
> # CONFIG_BACKLIGHT_LP8788 is not set
> CONFIG_BACKLIGHT_TPS65217=y
> CONFIG_BACKLIGHT_GPIO=y
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_COMPRESS_OFFLOAD=y
> CONFIG_SND_JACK=y
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_HRTIMER=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> CONFIG_SND_DEBUG=y
> # CONFIG_SND_DEBUG_VERBOSE is not set
> CONFIG_SND_DMA_SGBUF=y
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> # CONFIG_SND_DRIVERS is not set
> # CONFIG_SND_PCI is not set
> 
> #
> # HD-Audio
> #
> # CONFIG_SND_SPI is not set
> CONFIG_SND_FIREWIRE=y
> CONFIG_SND_FIREWIRE_LIB=y
> # CONFIG_SND_DICE is not set
> CONFIG_SND_FIREWIRE_SPEAKERS=y
> # CONFIG_SND_ISIGHT is not set
> # CONFIG_SND_SCS1X is not set
> # CONFIG_SND_PCMCIA is not set
> CONFIG_SND_SOC=y
> CONFIG_SND_ATMEL_SOC=y
> CONFIG_SND_SOC_INTEL_SST=y
> CONFIG_SND_SOC_INTEL_SST_ACPI=y
> CONFIG_SND_SOC_I2C_AND_SPI=y
> 
> #
> # CODEC drivers
> #
> # CONFIG_SND_SOC_ADAU1701 is not set
> CONFIG_SND_SOC_AK4104=y
> CONFIG_SND_SOC_AK4554=y
> # CONFIG_SND_SOC_AK4642 is not set
> CONFIG_SND_SOC_AK5386=y
> CONFIG_SND_SOC_CS42L52=y
> CONFIG_SND_SOC_CS42L73=y
> CONFIG_SND_SOC_CS4270=y
> CONFIG_SND_SOC_CS4271=y
> CONFIG_SND_SOC_CS42XX8=y
> CONFIG_SND_SOC_CS42XX8_I2C=y
> # CONFIG_SND_SOC_HDMI_CODEC is not set
> CONFIG_SND_SOC_PCM1681=y
> # CONFIG_SND_SOC_PCM1792A is not set
> CONFIG_SND_SOC_PCM512x=y
> CONFIG_SND_SOC_PCM512x_I2C=y
> CONFIG_SND_SOC_PCM512x_SPI=y
> # CONFIG_SND_SOC_SGTL5000 is not set
> # CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
> CONFIG_SND_SOC_SPDIF=y
> # CONFIG_SND_SOC_TAS5086 is not set
> # CONFIG_SND_SOC_TLV320AIC3X is not set
> CONFIG_SND_SOC_WM8510=y
> # CONFIG_SND_SOC_WM8523 is not set
> # CONFIG_SND_SOC_WM8580 is not set
> CONFIG_SND_SOC_WM8711=y
> CONFIG_SND_SOC_WM8728=y
> CONFIG_SND_SOC_WM8731=y
> CONFIG_SND_SOC_WM8737=y
> CONFIG_SND_SOC_WM8741=y
> CONFIG_SND_SOC_WM8750=y
> CONFIG_SND_SOC_WM8753=y
> # CONFIG_SND_SOC_WM8770 is not set
> # CONFIG_SND_SOC_WM8776 is not set
> # CONFIG_SND_SOC_WM8804 is not set
> # CONFIG_SND_SOC_WM8903 is not set
> CONFIG_SND_SOC_WM8962=y
> CONFIG_SND_SOC_TPA6130A2=y
> # CONFIG_SND_SIMPLE_CARD is not set
> CONFIG_SOUND_PRIME=y
> CONFIG_SOUND_OSS=y
> CONFIG_SOUND_TRACEINIT=y
> CONFIG_SOUND_DMAP=y
> CONFIG_SOUND_VMIDI=y
> CONFIG_SOUND_TRIX=y
> CONFIG_SOUND_MSS=y
> # CONFIG_SOUND_MPU401 is not set
> CONFIG_SOUND_PAS=y
> # CONFIG_PAS_JOYSTICK is not set
> # CONFIG_SOUND_PSS is not set
> CONFIG_SOUND_SB=y
> CONFIG_SOUND_YM3812=y
> CONFIG_SOUND_UART6850=y
> # CONFIG_SOUND_AEDSP16 is not set
> CONFIG_SOUND_KAHLUA=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> CONFIG_UHID=y
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> CONFIG_HID_CHICONY=y
> CONFIG_HID_PRODIKEYS=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EMS_FF=y
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KEYTOUCH=y
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> # CONFIG_HID_WALTOP is not set
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> CONFIG_LOGIWHEELS_FF=y
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_ORTEK=y
> # CONFIG_HID_PANTHERLORD is not set
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> # CONFIG_HID_PICOLCD_LCD is not set
> # CONFIG_HID_PICOLCD_LEDS is not set
> CONFIG_HID_PRIMAX=y
> CONFIG_HID_SAITEK=y
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> CONFIG_HID_XINMO=y
> CONFIG_HID_ZEROPLUS=y
> CONFIG_ZEROPLUS_FF=y
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> 
> #
> # USB port drivers
> #
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_TAHVO_USB is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=y
> CONFIG_UWB_WHCI=y
> CONFIG_MMC=y
> CONFIG_MMC_DEBUG=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> # CONFIG_MMC_BLOCK is not set
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=y
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> CONFIG_MMC_WBSD=y
> CONFIG_MMC_TIFM_SD=y
> CONFIG_MMC_SPI=y
> # CONFIG_MMC_SDRICOH_CS is not set
> CONFIG_MMC_CB710=y
> CONFIG_MMC_VIA_SDMMC=y
> CONFIG_MMC_REALTEK_PCI=y
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=y
> CONFIG_MS_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=y
> CONFIG_MEMSTICK_JMICRON_38X=y
> CONFIG_MEMSTICK_R592=y
> CONFIG_MEMSTICK_REALTEK_PCI=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_LM3533=y
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8501 is not set
> CONFIG_LEDS_LP8788=y
> CONFIG_LEDS_CLEVO_MAIL=y
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_PCA963X=y
> # CONFIG_LEDS_PCA9685 is not set
> # CONFIG_LEDS_WM831X_STATUS is not set
> CONFIG_LEDS_WM8350=y
> CONFIG_LEDS_DA903X=y
> CONFIG_LEDS_DA9052=y
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_INTEL_SS4200=y
> CONFIG_LEDS_LT3593=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> CONFIG_LEDS_MC13783=y
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGERS is not set
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> CONFIG_EDAC_DEBUG=y
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_E752X=y
> CONFIG_EDAC_I82975X=y
> CONFIG_EDAC_I3000=y
> CONFIG_EDAC_I3200=y
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> CONFIG_EDAC_I5000=y
> # CONFIG_EDAC_I5100 is not set
> CONFIG_EDAC_I7300=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> # CONFIG_RTC_SYSTOHC is not set
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> # CONFIG_RTC_INTF_DEV is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_LP8788 is not set
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_MAX8925=y
> CONFIG_RTC_DRV_MAX8998=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> CONFIG_RTC_DRV_ISL12057=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PALMAS=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_TPS6586X=y
> CONFIG_RTC_DRV_TPS80031=y
> CONFIG_RTC_DRV_RC5T583=y
> CONFIG_RTC_DRV_S35390A=y
> # CONFIG_RTC_DRV_FM3130 is not set
> CONFIG_RTC_DRV_RX8581=y
> CONFIG_RTC_DRV_RX8025=y
> CONFIG_RTC_DRV_EM3027=y
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_DRV_M41T93=y
> # CONFIG_RTC_DRV_M41T94 is not set
> CONFIG_RTC_DRV_DS1305=y
> # CONFIG_RTC_DRV_DS1347 is not set
> CONFIG_RTC_DRV_DS1390=y
> CONFIG_RTC_DRV_MAX6902=y
> # CONFIG_RTC_DRV_R9701 is not set
> CONFIG_RTC_DRV_RS5C348=y
> CONFIG_RTC_DRV_DS3234=y
> CONFIG_RTC_DRV_PCF2123=y
> CONFIG_RTC_DRV_RX4581=y
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> CONFIG_RTC_DRV_DA9052=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> # CONFIG_RTC_DRV_M48T35 is not set
> CONFIG_RTC_DRV_M48T59=y
> # CONFIG_RTC_DRV_MSM6242 is not set
> CONFIG_RTC_DRV_BQ4802=y
> CONFIG_RTC_DRV_RP5C01=y
> # CONFIG_RTC_DRV_V3020 is not set
> CONFIG_RTC_DRV_DS2404=y
> # CONFIG_RTC_DRV_WM831X is not set
> CONFIG_RTC_DRV_WM8350=y
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_PCAP is not set
> # CONFIG_RTC_DRV_MC13XXX is not set
> # CONFIG_RTC_DRV_MOXART is not set
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> CONFIG_UIO_CIF=y
> # CONFIG_UIO_PDRV_GENIRQ is not set
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> # CONFIG_UIO_NETX is not set
> CONFIG_UIO_MF624=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ALIENWARE_WMI is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> CONFIG_AMILO_RFKILL=y
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_ACPI_WMI=y
> # CONFIG_MSI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> CONFIG_MXM_WMI=y
> # CONFIG_INTEL_OAKTRAIL is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> CONFIG_DEVFREQ_GOV_USERSPACE=y
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> # CONFIG_EXTCON_GPIO is not set
> # CONFIG_EXTCON_ADC_JACK is not set
> # CONFIG_EXTCON_MAX14577 is not set
> CONFIG_EXTCON_MAX77693=y
> CONFIG_EXTCON_ARIZONA=y
> # CONFIG_EXTCON_PALMAS is not set
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
> CONFIG_KXSD9=y
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> CONFIG_AD7266=y
> CONFIG_AD7298=y
> CONFIG_AD7476=y
> CONFIG_AD7791=y
> # CONFIG_AD7793 is not set
> # CONFIG_AD7887 is not set
> CONFIG_AD7923=y
> # CONFIG_LP8788_ADC is not set
> # CONFIG_MAX1363 is not set
> CONFIG_MCP320X=y
> CONFIG_MCP3422=y
> # CONFIG_NAU7802 is not set
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> 
> #
> # Amplifiers
> #
> CONFIG_AD8366=y
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> # CONFIG_AD5064 is not set
> # CONFIG_AD5360 is not set
> CONFIG_AD5380=y
> CONFIG_AD5421=y
> CONFIG_AD5446=y
> CONFIG_AD5449=y
> CONFIG_AD5504=y
> CONFIG_AD5624R_SPI=y
> CONFIG_AD5686=y
> # CONFIG_AD5755 is not set
> CONFIG_AD5764=y
> CONFIG_AD5791=y
> CONFIG_AD7303=y
> # CONFIG_MAX517 is not set
> CONFIG_MCP4725=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=y
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> # CONFIG_ADF4350 is not set
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16080=y
> # CONFIG_ADIS16130 is not set
> # CONFIG_ADIS16136 is not set
> CONFIG_ADIS16260=y
> CONFIG_ADXRS450=y
> # CONFIG_HID_SENSOR_GYRO_3D is not set
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
> # CONFIG_ITG3200 is not set
> 
> #
> # Humidity sensors
> #
> CONFIG_DHT11=y
> CONFIG_SI7005=y
> 
> #
> # Inertial measurement units
> #
> # CONFIG_ADIS16400 is not set
> # CONFIG_ADIS16480 is not set
> # CONFIG_INV_MPU6050_IIO is not set
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_APDS9300=y
> # CONFIG_CM32181 is not set
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> # CONFIG_HID_SENSOR_ALS is not set
> # CONFIG_HID_SENSOR_PROX is not set
> CONFIG_SENSORS_LM3533=y
> CONFIG_LTR501=y
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> CONFIG_TSL4531=y
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> CONFIG_MAG3110=y
> CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Inclinometer sensors
> #
> # CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_HID_SENSOR_PRESS=y
> CONFIG_MPL3115=y
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_IIO_ST_PRESS_SPI=y
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> CONFIG_NTB=y
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> CONFIG_SERIAL_IPOCTAL=y
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_OMAP_CONTROL_PHY is not set
> CONFIG_BCM_KONA_USB2_PHY=y
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_DMIID is not set
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> # CONFIG_REISERFS_FS is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_WARN is not set
> # CONFIG_XFS_DEBUG is not set
> CONFIG_GFS2_FS=y
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> # CONFIG_CUSE is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_CACHEFILES=y
> CONFIG_CACHEFILES_DEBUG=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=2048
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_MEMORY_INIT is not set
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> # CONFIG_DEBUG_PREEMPT is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_DEBUG_CREDENTIALS=y
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_PREEMPT_TRACER=y
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_PROFILE_ALL_BRANCHES=y
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_DYNAMIC_FTRACE is not set
> # CONFIG_FUNCTION_PROFILER is not set
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y
> # CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> CONFIG_BUILD_DOCSRC=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> CONFIG_BIG_KEYS=y
> # CONFIG_TRUSTED_KEYS is not set
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> # CONFIG_CRYPTO_SHA256_SSSE3 is not set
> CONFIG_CRYPTO_SHA512_SSSE3=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST5_AVX_X86_64=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_CAST6_AVX_X86_64=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_X86_64=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
> # CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> # CONFIG_CRYPTO_HW is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM_VFIO=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> # CONFIG_KVM_INTEL is not set
> # CONFIG_KVM_AMD is not set
> CONFIG_KVM_MMU_AUDIT=y
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CORDIC=y
> # CONFIG_DDR is not set

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

