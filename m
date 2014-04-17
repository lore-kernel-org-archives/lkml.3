Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaDQNd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:33:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45271 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaDQNdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:33:53 -0400
Date: Thu, 17 Apr 2014 06:33:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jet Chen <jet.chen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [ sched,rcu] BUG: using __this_cpu_add_return() in preemptible
 [00000000] code: swapper/0/1
Message-ID: <20140417133343.GH4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534F6861.9070504@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <534F6861.9070504@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041713-1542-0000-0000-000001278541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:36:33PM +0800, Jet Chen wrote:
> Hi Paul,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev.2014.04.14a
> commit b84c4e08143c98dad4b4d139f08db0b98b0d3ec4
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Sun Mar 16 21:36:25 2014 -0700
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Mon Apr 14 11:09:19 2014 -0700

Fixes are on the way.  This problem is due to added checking in the
per-CPU code, along with a bug in the per-CPU code.  The fix involves
this commit using a new raw_cpu_inc_return() function and a fix to
that function.  I expect to push a branch containing the fixes later
today.

							Thanx, Paul

>      sched,rcu: Make cond_resched() report RCU quiescent states
>          Given a CPU running a loop containing cond_resched(), with no
>      other tasks runnable on that CPU, RCU will eventually report RCU
>      CPU stall warnings due to lack of quiescent states.  Fortunately,
>      every call to cond_resched() is a perfectly good quiescent state.
>      Unfortunately, invoking rcu_note_context_switch() is a bit heavyweight
>      for cond_resched(), especially given the need to disable preemption,
>      and, for RCU-preempt, interrupts as well.
>          This commit therefore maintains a per-CPU counter that causes
>      cond_resched(), cond_resched_lock(), and cond_resched_softirq() to call
>      rcu_note_context_switch(), but only about once per 256 invocations.
>      This ratio was chosen in keeping with the relative time constants of
>      RCU grace periods.
>          Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> +-----------------------------------------------------------------+------------+------------+
> |                                                                 | ad86a04266 | b84c4e0814 |
> +-----------------------------------------------------------------+------------+------------+
> | boot_successes                                                  | 295        | 0          |
> | boot_failures                                                   | 22         | 20         |
> | BUG:kernel_boot_hang                                            | 21         |            |
> | BUG:kernel_test_crashed                                         | 1          |            |
> | BUG:using__this_cpu_add_return()in_preemptible_code:swapper     | 0          | 20         |
> | backtrace:do_execve                                             | 0          | 20         |
> | backtrace:run_init_process                                      | 0          | 20         |
> | BUG:using__this_cpu_add_return()in_preemptible_code:trinity     | 0          | 7          |
> | BUG:using__this_cpu_add_return()in_preemptible_code:rcu_preempt | 0          | 4          |
> | backtrace:_cond_resched                                         | 0          | 4          |
> | BUG:using__this_cpu_add_return()in_preemptible_code:init        | 0          | 4          |
> | backtrace:core_sys_select                                       | 0          | 4          |
> | backtrace:SyS_select                                            | 0          | 4          |
> | BUG:using__this_cpu_add_return()in_preemptible_code:rc          | 0          | 0          |
> | backtrace:do_fork                                               | 0          | 0          |
> | backtrace:SyS_clone                                             | 0          | 0          |
> | backtrace:SyS_execve                                            | 0          | 0          |
> +-----------------------------------------------------------------+------------+------------+
> 
> [    2.672306] Write protecting the kernel read-only data: 16384k
> [    2.677353] Freeing unused kernel memory: 964K (ffff880001b0f000 - ffff880001c00000)
> [    2.681745] Freeing unused kernel memory: 748K (ffff880001f45000 - ffff880002000000)
> [    2.683179] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.684683] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.685590] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.687134] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.688068]  0000000000000000 ffff880011471ca0 ffffffff81af1772 0000000000000001
> [    2.689738]  ffff880011471cc8 ffffffff81422eb9 ffff880011471da0 ffff880012e7fb00
> [    2.691394]  ffffffff81c173a0 ffff880011471cd8 ffffffff81422ef2 ffff880011471ce8
> [    2.693062] Call Trace:
> [    2.693689]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.694567]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.695581]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.696601]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.697565]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.698488]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.699389]  [<ffffffff8119735b>] path_openat+0x431/0x75c
> [    2.700287]  [<ffffffff81198e8c>] do_filp_open+0x3c/0xa6
> [    2.701190]  [<ffffffff813a66bf>] ? aa_dup_task_context+0x3e/0x48
> [    2.702159]  [<ffffffff813ad3bd>] ? apparmor_cred_prepare+0x3f/0x5b
> [    2.703147]  [<ffffffff8139a495>] ? security_prepare_creds+0x18/0x21
> [    2.704139]  [<ffffffff8118d58f>] do_open_exec+0x28/0x1ad
> [    2.705039]  [<ffffffff8118df6c>] do_execve_common.isra.30+0x289/0x804
> [    2.711803]  [<ffffffff8109d7c6>] ? preempt_count_add+0xcd/0xe7
> [    2.712866]  [<ffffffff81193630>] ? getname_kernel+0x46/0x9c
> [    2.713843]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.714809]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.715751]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.716745]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.717713]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.718643]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> 
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> 
> git bisect start e85454f12dcf05f366b5f4f41e27637dbd4d9cfe c9eaa447e77efe77b7fa4c953bd62de8297fd6c5 --
> git bisect good b888dc84d249e4fecd35f1038cc1e27ce924456f  # 20:57     20+      0  Merge 'socfpga-nex/for-next' into devel-hourly-2014041512
> git bisect good 266a677952566287e6c25e497da29d3d780ad0d3  # 20:57     20+      0  Merge 'asoc/topic/davinci' into devel-hourly-2014041512
> git bisect  bad 50ac0be0d367abf72f540045a674ba07a785b37c  # 20:57      0-     20  Merge 'kees/nak_devtmpfs-safe' into devel-hourly-2014041512
> git bisect good db710d86df4bb5e92eaa2589e9b10f9ad21d0705  # 20:57     20+      0  Merge 'stericsson/ux500-core' into devel-hourly-2014041512
> git bisect  bad 8bffb3ac073ee45338694a7d580dbf587e54f0dc  # 20:57      0-     20  Merge 'kees/nak_fw-relative' into devel-hourly-2014041512
> git bisect  bad fdd31f30392753e38d407fd05b8a17b09f5863c9  # 20:58      0-     20  Merge 'dynticks/core/threadgroup' into devel-hourly-2014041512
> git bisect  bad 7a3e2d770aca838245decbe7a69c104331732ef8  # 20:58      0-     20  Merge 'rcu/dev.2014.04.14a' into devel-hourly-2014041512
> git bisect good 44979a316b57116968bcd960f914d2410aa75910  # 20:58     20+      0  rcu: Update cpu_needs_another_gp() for futures from non-NOCB CPUs
> git bisect  bad 10cb7ccef834ae3afab56f201b67d7077767481c  # 20:58      0-     20  rcu: Merge rcu_sched_force_quiescent_state() with rcu_force_quiescent_state()
> git bisect  bad f0d4293e29bfa15ada0563d510175d5a25453a8a  # 20:58      0-     20  rcutorture: Make rcu_torture_reader() use cond_resched()
> git bisect good e0e7c2ec22bf52c54e1cc49954bcc82eb2968c62  # 20:58     20+      0  rcu: Export RCU grace-period kthread wait state to rcutorture
> git bisect good ad86a04266f9b49730424023f6b66fe45b66e509  # 21:00     20+      1  rcu: Protect uses of ->jiffies_stall with ACCESS_ONCE()
> git bisect  bad b84c4e08143c98dad4b4d139f08db0b98b0d3ec4  # 21:00      0-     20  sched,rcu: Make cond_resched() report RCU quiescent states
> # first bad commit: [b84c4e08143c98dad4b4d139f08db0b98b0d3ec4] sched,rcu: Make cond_resched() report RCU quiescent states
> git bisect good ad86a04266f9b49730424023f6b66fe45b66e509  # 21:03     60+      1  rcu: Protect uses of ->jiffies_stall with ACCESS_ONCE()
> git bisect  bad e85454f12dcf05f366b5f4f41e27637dbd4d9cfe  # 21:03      0-     23  0day head guard for 'devel-hourly-2014041512'
> git bisect good 10ec34fcb100412ab186c141a9c3557d1270effd  # 21:33     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect good 2db08cc65391d73dc8cbcaefdb55c42a774d9e1a  # 22:34     60+      9  Add linux-next specific files for 20140416
> 
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	-kernel $kernel
> 	-smp 2
> 	-m 256M
> 	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
> 	-net user,vlan=0
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-serial stdio
> 	-display none
> 	-monitor null
> )
> 
> append=(
> 	debug
> 	sched_debug
> 	apic=debug
> 	ignore_loglevel
> 	sysrq_always_enabled
> 	panic=10
> 	prompt_ramdisk=0
> 	earlyprintk=ttyS0,115200
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
> 
> Thanks,
> Jet
> 
> 

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00039-gb84c4e0 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #14 SMP PREEMPT Tue Apr 15 17:04:47 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:b84c4e08143c98dad4b4d139f08db0b98b0d3ec4:bisect-linux7/.vmlinuz-b84c4e08143c98dad4b4d139f08db0b98b0d3ec4-20140415170508-10-f2 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 drbd.minor_count=8
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
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
> [    0.000000]   mpc: fdad0-fdbec
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
> [    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
> [    0.000000] BRK [0x02b55000, 0x02b55fff] PGTABLE
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
> [    0.000000] BRK [0x02b56000, 0x02b56fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s74688 r8192 d23616 u1048576
> [    0.000000] pcpu-alloc: s74688 r8192 d23616 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1260cc80
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:b84c4e08143c98dad4b4d139f08db0b98b0d3ec4:bisect-linux7/.vmlinuz-b84c4e08143c98dad4b4d139f08db0b98b0d3ec4-20140415170508-10-f2 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 268776K/327280K available (11277K kernel code, 4783K rwdata, 3348K rodata, 996K init, 5788K bss, 58504K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00039-gb84c4e0 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #14 SMP PREEMPT Tue Apr 15 17:04:47 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:b84c4e08143c98dad4b4d139f08db0b98b0d3ec4:bisect-linux7/.vmlinuz-b84c4e08143c98dad4b4d139f08db0b98b0d3ec4-20140415170508-10-f2 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 drbd.minor_count=8
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
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
> [    0.000000]   mpc: fdad0-fdbec
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
> [    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
> [    0.000000] BRK [0x02b55000, 0x02b55fff] PGTABLE
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
> [    0.000000] BRK [0x02b56000, 0x02b56fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s74688 r8192 d23616 u1048576
> [    0.000000] pcpu-alloc: s74688 r8192 d23616 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1260cc80
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:b84c4e08143c98dad4b4d139f08db0b98b0d3ec4:bisect-linux7/.vmlinuz-b84c4e08143c98dad4b4d139f08db0b98b0d3ec4-20140415170508-10-f2 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 268776K/327280K available (11277K kernel code, 4783K rwdata, 3348K rodata, 996K init, 5788K bss, 58504K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] allocated 1572864 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.570 MHz processor
> [    0.003000] Calibrating delay loop (skipped) preset value.. 5387.14 BogoMIPS (lpj=2693570)
> [    0.003007] pid_max: default: 32768 minimum: 301
> [    0.003552] ACPI: Core revision 20140214
> [    0.005643] ACPI: All ACPI Tables successfully acquired
> [    0.006428] Security Framework initialized
> [    0.007019] AppArmor: AppArmor initialized
> [    0.008005] Yama: becoming mindful.
> [    0.009021] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.010007] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.011286] Initializing cgroup subsys debug
> [    0.012007] Initializing cgroup subsys memory
> [    0.013009] Initializing cgroup subsys devices
> [    0.014006] Initializing cgroup subsys net_cls
> [    0.015006] Initializing cgroup subsys blkio
> [    0.016006] Initializing cgroup subsys perf_event
> [    0.017007] Initializing cgroup subsys hugetlb
> [    0.018054] mce: CPU supports 10 MCE banks
> [    0.018886] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.018886] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.018886] tlb_flushall_shift: 6
> [    0.019073] Freeing SMP alternatives memory: 16K (ffffffff825a6000 - ffffffff825aa000)
> [    0.021049] Getting VERSION: 50014
> [    0.021782] Getting VERSION: 50014
> [    0.022006] Getting ID: 0
> [    0.023011] Getting ID: ff000000
> [    0.024009] Getting LVT0: 8700
> [    0.024714] Getting LVT1: 8400
> [    0.025021] enabled ExtINT on CPU#0
> [    0.026617] ENABLING IO-APIC IRQs
> [    0.027005] init IO_APIC IRQs
> [    0.028006]  apic 0 pin 0 not connected
> [    0.029009] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.030032] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.031017] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.032016] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.033016] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.034017] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.035016] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.036017] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.037016] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.038016] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.039016] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.040016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.041017] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.042016] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.043017] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.044015]  apic 0 pin 16 not connected
> [    0.045004]  apic 0 pin 17 not connected
> [    0.046004]  apic 0 pin 18 not connected
> [    0.047004]  apic 0 pin 19 not connected
> [    0.048004]  apic 0 pin 20 not connected
> [    0.048774]  apic 0 pin 21 not connected
> [    0.049004]  apic 0 pin 22 not connected
> [    0.050004]  apic 0 pin 23 not connected
> [    0.051142] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.052003] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.054003] Using local APIC timer interrupts.
> [    0.054003] calibrating APIC timer ...
> [    0.056000] ... lapic delta = 6249334
> [    0.056000] ... PM-Timer delta = 357931
> [    0.056000] ... PM-Timer result ok
> [    0.056000] ..... delta 6249334
> [    0.056000] ..... mult: 268406851
> [    0.056000] ..... calibration result: 999893
> [    0.056000] ..... CPU clock speed is 2691.0954 MHz.
> [    0.056000] ..... host bus clock speed is 999.0893 MHz.
> [    0.056046] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.063168] x86: Booting SMP configuration:
> [    0.064008] .... node  #0, CPUs:      #1
> [    0.003000] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
> [    0.003000] masked ExtINT on CPU#1
> [    0.077058] x86: Booted up 1 node, 2 CPUs
> [    0.077042] KVM setup async PF for cpu 1
> [    0.077042] kvm-stealtime: cpu 1, msr 1270cc80
> [    0.078006] smpboot: Total of 2 processors activated (10774.28 BogoMIPS)
> [    0.080344] devtmpfs: initialized
> [    0.081172] gcov: version magic: 0x3430382a
> [    0.082438] evm: security.SMACK64
> [    0.083012] evm: security.capability
> [    0.084304] xor: measuring software checksum speed
> [    0.095023]    prefetch64-sse:   160.000 MB/sec
> [    0.105026]    generic_sse:   156.000 MB/sec
> [    0.105778] xor: using function: prefetch64-sse (160.000 MB/sec)
> [    0.106073] regulator-dummy: no parameters
> [    0.107082] NET: Registered protocol family 16
> [    0.108299] cpuidle: using governor ladder
> [    0.109005] cpuidle: using governor menu
> [    0.110216] ACPI: bus type PCI registered
> [    0.111056] dca service started, version 1.12.1
> [    0.112029] PCI: Using configuration type 1 for base access
> [    0.132016] raid6: sse2x1    3750 MB/s
> [    0.149010] raid6: sse2x2    4367 MB/s
> [    0.166018] raid6: sse2x4    4523 MB/s
> [    0.166784] raid6: using algorithm sse2x4 (4523 MB/s)
> [    0.167005] raid6: using intx1 recovery algorithm
> [    0.168112] ACPI: Added _OSI(Module Device)
> [    0.169006] ACPI: Added _OSI(Processor Device)
> [    0.170003] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.171006] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.174376] ACPI: Interpreter enabled
> [    0.175009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
> [    0.176578] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
> [    0.178015] ACPI: (supports S0 S3 S4 S5)
> [    0.179003] ACPI: Using IOAPIC for interrupt routing
> [    0.180021] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.184300] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.185010] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
> [    0.186012] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.187158] PCI host bridge to bus 0000:00
> [    0.188007] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.189006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.189939] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.190006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.191006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    0.192037] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.194264] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.195404] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.198880] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
> [    0.200682] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    0.201006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    0.202006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    0.203005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    0.204148] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.206114] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    0.207014] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    0.208201] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.211049] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.213067] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    0.220055] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    0.221449] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    0.223428] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    0.225425] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.230424] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    0.231172] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
> [    0.233435] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
> [    0.235447] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
> [    0.241070] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    0.242899] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
> [    0.244457] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
> [    0.250296] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    0.252006] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
> [    0.254021] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
> [    0.259276] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    0.261437] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
> [    0.263006] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
> [    0.268720] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    0.270440] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
> [    0.272440] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
> [    0.278222] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    0.280006] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
> [    0.281443] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
> [    0.287260] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
> [    0.288462] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
> [    0.292697] pci_bus 0000:00: on NUMA node 0
> [    0.293356] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.295101] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.296533] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.297813] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.299057] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.300374] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.302109] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.303007] vgaarb: loaded
> [    0.304003] vgaarb: bridge control possible 0000:00:02.0
> [    0.305181] SCSI subsystem initialized
> [    0.306046] pps_core: LinuxPPS API ver. 1 registered
> [    0.306880] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.307036] PTP clock support registered
> [    0.308021] EDAC MC: Ver: 3.0.0
> [    0.309099] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    0.310160] PCI: Using ACPI for IRQ routing
> [    0.311011] PCI: pci_cache_line_size set to 64 bytes
> [    0.312169] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.313009] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    0.314315] irda_init()
> [    0.315055] NET: Registered protocol family 23
> [    0.316144] NetLabel: Initializing
> [    0.316860] cfg80211: Calling CRDA to update world regulatory domain
> [    0.317016] NetLabel:  domain hash size = 128
> [    0.318004] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.319037] NetLabel:  unlabeled traffic allowed by default
> [    0.320320] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.322080] Switched to clocksource kvm-clock
> [    0.322939] FS-Cache: Loaded
> [    0.323661] AppArmor: AppArmor Filesystem Enabled
> [    0.324525] pnp: PnP ACPI init
> [    0.325205] ACPI: bus type PNP registered
> [    0.326018] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    0.327472] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.328538] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    0.329995] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.331008] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    0.332483] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.333535] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    0.334964] pnp 00:03: [dma 2]
> [    0.335627] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.336657] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    0.338125] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.339190] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    0.340637] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.341679] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    0.343122] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.344238] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.345333] pnp: PnP ACPI: found 8 devices
> [    0.346086] ACPI: bus type PNP unregistered
> [    0.363737] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.364767] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.365787] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.366861] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    0.368005] NET: Registered protocol family 2
> [    0.369149] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.370283] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
> [    0.371388] TCP: Hash tables configured (established 4096 bind 4096)
> [    0.372483] TCP: reno registered
> [    0.373221] UDP hash table entries: 256 (order: 1, 8192 bytes)
> [    0.374227] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
> [    0.375357] NET: Registered protocol family 1
> [    0.376217] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    0.377226] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    0.378242] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    0.379256] pci 0000:00:02.0: Boot video device
> [    0.380163] PCI: CLS 0 bytes, default 64
> [    0.381090] Trying to unpack rootfs image as initramfs...
> [    0.865964] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    0.867992] Machine check injector initialized
> [    0.868902] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    0.870551] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    0.872521] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    0.873604] PCLMULQDQ-NI instructions are not detected.
> [    0.874499] AVX or AES-NI instructions are not detected.
> [    0.875399] AVX2 or AES-NI instructions are not detected.
> [    0.876675] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    0.877737] Initialise system trusted keyring
> [    0.878596] audit: initializing netlink subsys (disabled)
> [    0.879594] audit: type=2000 audit(1397552710.837:1): initialized
> [    1.181245] bounce pool size: 64 pages
> [    1.182034] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.186769] VFS: Disk quotas dquot_6.5.2
> [    1.187635] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.188956] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    1.190182] ntfs: driver 2.1.30 [Flags: R/O].
> [    1.191175] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> [    1.192109] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    1.193024] QNX6 filesystem 1.0.0 registered.
> [    1.194212] msgmni has been set to 570
> [    1.198016] alg: No test for lz4hc (lz4hc-generic)
> [    1.199071] alg: No test for stdrng (krng)
> [    1.200052] NET: Registered protocol family 38
> [    1.200896] Key type asymmetric registered
> [    1.201713] Asymmetric key parser 'x509' registered
> [    1.202696] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    1.204133] io scheduler noop registered
> [    1.204913] io scheduler deadline registered (default)
> [    1.205813] test_string_helpers: Running tests...
> [    1.219971] crc32: CRC_LE_BITS = 1, CRC_BE BITS = 1
> [    1.220828] crc32: self tests passed, processed 225944 bytes in 6552771 nsec
> [    1.228417] crc32c: CRC_LE_BITS = 1
> [    1.229127] crc32c: self tests passed, processed 225944 bytes in 3254282 nsec
> [    1.665842] crc32_combine: 8373 self tests passed
> [    1.869903] tsc: Refined TSC clocksource calibration: 2692.133 MHz
> [    2.102440] crc32c_combine: 8373 self tests passed
> [    2.103448] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    2.104416] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> [    2.105595] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    2.107022] ACPI: Power Button [PWRF]
> [    2.108029] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    2.119855] r3964: Philips r3964 Driver $Revision: 1.10 $
> [    2.120776] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    2.145178] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    2.147343] serial: Freescale lpuart driver
> [    2.148252] SyncLink GT
> [    2.148953] SyncLink GT, tty major#249
> [    2.149793] SyncLink GT no devices found
> [    2.150630] SyncLink MultiPort driver $Revision: 4.38 $
> [    2.154480] SyncLink MultiPort driver $Revision: 4.38 $, tty major#248
> [    2.155673] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
> [    2.156891] ac.o: No PCI boards found.
> [    2.157733] ac.o: For an ISA board you must supply memory and irq parameters.
> [    2.160320] brd: module loaded
> [    2.161770] loop: module loaded
> [    2.162640] skd:  v2.2.1-b0260 loaded
> [    2.163493] MM: desc_per_page = 128
> [    2.164400] nbd: registered device at major 43
> [    2.167823] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
> [    2.168934] drbd: built-in
> [    2.169626] drbd: registered as block device major 147
> [    2.170641] rbd: loaded
> [    2.171618]  nullb0: unknown partition table
> [    2.172722]  nullb1: unknown partition table
> [    2.173699] null: module loaded
> [    2.174485] Phantom Linux Driver, version n0.9.8, init OK
> [    2.175527] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    2.177321] Loading iSCSI transport class v2.0-870.
> [    2.178689] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
> [    2.179664] fnic: Successfully Initialized Trace Buffer
> [    2.180851] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec 11, 2013)
> [    2.188018] Adaptec aacraid driver 1.2-0[30300]-ms
> [    2.189057] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
> [    2.190242] DC390: clustering now enabled by default. If you get problems load
> [    2.191734]        with "disable_clustering=1" and report to maintainers
> [    2.192891] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [    2.193950] 3ware Storage Controller device driver for Linux v1.26.02.003.
> [    2.195071] RocketRAID 3xxx/4xxx Controller driver v1.8
> [    2.196018] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> [    2.197076] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
> [    2.198574] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
> [    2.199682] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
> [    2.200610] iscsi: registered transport (cxgb4i)
> [    2.201477] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2013)
> [    2.202598] iscsi: registered transport (bnx2i)
> [    2.203625] iscsi: registered transport (be2iscsi)
> [    2.204531] In beiscsi_module_init, tt=ffffffff8230ca20
> [    2.205535] SCSI Media Changer driver v0.25 
> [    2.206620] arcnet loaded.
> [    2.207334] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
> [    2.208776] arcnet: COM90xx chipset support
> [    2.510263] S3: No ARCnet cards found.
> [    2.511116] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March 14, 2014)
> [    2.512715] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.19-0 (2014/02/10)
> [    2.514827] vxge: Copyright(c) 2002-2010 Exar Corp.
> [    2.515745] vxge: Driver version: 2.5.3.22640-k
> [    2.522402] airo(): Probing for PCI adapters
> [    2.523266] airo(): Finished probing for PCI adapters
> [    2.524204] Loaded prism54 driver, version 1.2
> [    2.525332] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    2.527703] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.528697] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.530005] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    2.532071] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [    2.533249] pps pps0: new PPS source ktimer
> [    2.534123] pps pps0: ktimer PPS source registered
> [    2.535236] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    2.537022] CAPI 2.0 started up with major 68 (no middleware)
> [    2.538086] EDAC DEBUG: i5000_init: MC:
> [    2.539165] cs5535-clockevt: Could not allocate MFGPT timer
> [    2.540289] pktgen: Packet Generator for packet performance testing. Version: 2.74
> [    2.545854] NET: Registered protocol family 26
> [    2.546894] netem: version 1.3
> [    2.547685] Netfilter messages via NETLINK v0.30.
> [    2.548608] nf_conntrack version 0.5.0 (2281 buckets, 9124 max)
> [    2.549832] ctnetlink v0.93: registering with nfnetlink.
> [    2.550858] ip_set: protocol 6
> [    2.551609] IPVS: Registered protocols (SCTP, ESP)
> [    2.552583] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
> [    2.554177] IPVS: Creating netns size=1464 id=0
> [    2.555068] IPVS: ipvs loaded.
> [    2.555784] IPVS: [wrr] scheduler registered.
> [    2.556629] IPVS: [lc] scheduler registered.
> [    2.557521] IPVS: [sh] scheduler registered.
> [    2.558438] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    2.559429] TCP: htcp registered
> [    2.560176] Initializing XFRM netlink socket
> [    2.561243] NET: Registered protocol family 10
> [    2.562546] mip6: Mobile IPv6
> [    2.563263] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    2.564404] ip6_gre: GRE over IPv6 tunneling driver
> [    2.565494] Ebtables v2.0 registered
> [    2.566303] NET: Registered protocol family 5
> [    2.567234] NET: Registered protocol family 3
> [    2.568128] l2tp_core: L2TP core driver, V2.0
> [    2.568981] l2tp_netlink: L2TP netlink interface
> [    2.570151] DCCP: Activated CCID 2 (TCP-like)
> [    2.571291] 9pnet: Installing 9P2000 support
> [    2.572215] NET: Registered protocol family 36
> [    2.573102] Key type ceph registered
> [    2.574020] libceph: loaded (mon/osd proto 15/24)
> [    2.575039] batman_adv: B.A.T.M.A.N. advanced 2014.2.0 (compatibility version 15) loaded
> [    2.577069] 
> [    2.577069] printing PIC contents
> [    2.578366] ... PIC  IMR: ffff
> [    2.579102] ... PIC  IRR: 1013
> [    2.579861] ... PIC  ISR: 0000
> [    2.580592] ... PIC ELCR: 0c00
> [    2.581366] printing local APIC contents on CPU#0/0:
> [    2.582342] ... APIC ID:      00000000 (0)
> [    2.582358] ... APIC VERSION: 00050014
> [    2.582358] ... APIC TASKPRI: 00000000 (00)
> [    2.582358] ... APIC PROCPRI: 00000000
> [    2.582358] ... APIC LDR: 01000000
> [    2.582358] ... APIC DFR: ffffffff
> [    2.582358] ... APIC SPIV: 000001ff
> [    2.582358] ... APIC ISR field:
> [    2.582358] 0000000000000000000000000000000000000000000000000000000000000000
> [    2.582358] ... APIC TMR field:
> [    2.582358] 0000000002000000000000000000000000000000000000000000000000000000
> [    2.582358] ... APIC IRR field:
> [    2.582358] 0000000000000000000000000000000000000000000000000000000000008000
> [    2.582358] ... APIC ESR: 00000000
> [    2.582358] ... APIC ICR: 000008fd
> [    2.582358] ... APIC ICR2: 02000000
> [    2.582358] ... APIC LVTT: 000200ef
> [    2.582358] ... APIC LVTPC: 00010000
> [    2.582358] ... APIC LVT0: 00010700
> [    2.582358] ... APIC LVT1: 00000400
> [    2.582358] ... APIC LVTERR: 000000fe
> [    2.582358] ... APIC TMICT: 0000f41d
> [    2.582358] ... APIC TMCCT: 00006073
> [    2.582358] ... APIC TDCR: 00000003
> [    2.582358] 
> [    2.603969] number of MP IRQ sources: 15.
> [    2.604800] number of IO-APIC #0 registers: 24.
> [    2.605677] testing the IO APIC.......................
> [    2.606604] IO APIC #0......
> [    2.607343] .... register #00: 00000000
> [    2.608136] .......    : physical APIC id: 00
> [    2.608993] .......    : Delivery Type: 0
> [    2.609821] .......    : LTS          : 0
> [    2.610639] .... register #01: 00170011
> [    2.611421] .......     : max redirection entries: 17
> [    2.612351] .......     : PRQ implemented: 0
> [    2.613186] .......     : IO APIC version: 11
> [    2.614052] .... register #02: 00000000
> [    2.614882] .......     : arbitration: 00
> [    2.615771] .... IRQ redirection table:
> [    2.616674] 1    0    0   0   0    0    0    00
> [    2.617692] 0    0    0   0   0    1    1    31
> [    2.618702] 0    0    0   0   0    1    1    30
> [    2.619704] 0    0    0   0   0    1    1    33
> [    2.620699] 1    0    0   0   0    1    1    34
> [    2.621584] 1    1    0   0   0    1    1    35
> [    2.622544] 0    0    0   0   0    1    1    36
> [    2.623544] 0    0    0   0   0    1    1    37
> [    2.624451] 0    0    0   0   0    1    1    38
> [    2.625362] 0    1    0   0   0    1    1    39
> [    2.626255] 1    1    0   0   0    1    1    3A
> [    2.627207] 1    1    0   0   0    1    1    3B
> [    2.628136] 0    0    0   0   0    1    1    3C
> [    2.629047] 0    0    0   0   0    1    1    3D
> [    2.629962] 0    0    0   0   0    1    1    3E
> [    2.630889] 0    0    0   0   0    1    1    3F
> [    2.631829] 1    0    0   0   0    0    0    00
> [    2.632715] 1    0    0   0   0    0    0    00
> [    2.633552] 1    0    0   0   0    0    0    00
> [    2.634401] 1    0    0   0   0    0    0    00
> [    2.635242] 1    0    0   0   0    0    0    00
> [    2.636100] 1    0    0   0   0    0    0    00
> [    2.636984] 1    0    0   0   0    0    0    00
> [    2.637855] 1    0    0   0   0    0    0    00
> [    2.638706] IRQ to pin mappings:
> [    2.639402] IRQ0 -> 0:2
> [    2.640168] IRQ1 -> 0:1
> [    2.640947] IRQ3 -> 0:3
> [    2.641733] IRQ4 -> 0:4
> [    2.642492] IRQ5 -> 0:5
> [    2.643247] IRQ6 -> 0:6
> [    2.644069] IRQ7 -> 0:7
> [    2.644854] IRQ8 -> 0:8
> [    2.645634] IRQ9 -> 0:9
> [    2.646391] IRQ10 -> 0:10
> [    2.647212] IRQ11 -> 0:11
> [    2.648010] IRQ12 -> 0:12
> [    2.648809] IRQ13 -> 0:13
> [    2.649588] IRQ14 -> 0:14
> [    2.650375] IRQ15 -> 0:15
> [    2.651157] .................................... done.
> [    2.652156] Loading compiled-in X.509 certificates
> [    2.653894] Btrfs loaded, debug=on, integrity-checker=on
> [    2.655446] Key type encrypted registered
> [    2.657326] Unregister pv shared memory for cpu 0
> [    2.667078] bnx2fc: CPU 0 offline: Remove Rx thread
> [    2.667992] CPU 0 offline: Remove Rx thread
> [    2.668854] CPU 0 is now offline
> [    2.670856] Freeing unused kernel memory: 996K (ffffffff824ad000 - ffffffff825a6000)
> [    2.672306] Write protecting the kernel read-only data: 16384k
> [    2.677353] Freeing unused kernel memory: 964K (ffff880001b0f000 - ffff880001c00000)
> [    2.681745] Freeing unused kernel memory: 748K (ffff880001f45000 - ffff880002000000)
> [    2.683179] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.684683] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.685590] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.687134] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.688068]  0000000000000000 ffff880011471ca0 ffffffff81af1772 0000000000000001
> [    2.689738]  ffff880011471cc8 ffffffff81422eb9 ffff880011471da0 ffff880012e7fb00
> [    2.691394]  ffffffff81c173a0 ffff880011471cd8 ffffffff81422ef2 ffff880011471ce8
> [    2.693062] Call Trace:
> [    2.693689]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.694567]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.695581]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.696601]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.697565]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.698488]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.699389]  [<ffffffff8119735b>] path_openat+0x431/0x75c
> [    2.700287]  [<ffffffff81198e8c>] do_filp_open+0x3c/0xa6
> [    2.701190]  [<ffffffff813a66bf>] ? aa_dup_task_context+0x3e/0x48
> [    2.702159]  [<ffffffff813ad3bd>] ? apparmor_cred_prepare+0x3f/0x5b
> [    2.703147]  [<ffffffff8139a495>] ? security_prepare_creds+0x18/0x21
> [    2.704139]  [<ffffffff8118d58f>] do_open_exec+0x28/0x1ad
> [    2.705039]  [<ffffffff8118df6c>] do_execve_common.isra.30+0x289/0x804
> [    2.711803]  [<ffffffff8109d7c6>] ? preempt_count_add+0xcd/0xe7
> [    2.712866]  [<ffffffff81193630>] ? getname_kernel+0x46/0x9c
> [    2.713843]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.714809]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.715751]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.716745]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.717713]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.718643]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.719584] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.721119] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.722049] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.723528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.724498]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.726180]  ffff880011471e30 ffffffff81422eb9 0000000000000001 ffffffff8200ffe0
> [    2.727887]  ffff880012ee8000 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.729550] Call Trace:
> [    2.730158]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.731040]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.732057]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.733048]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.733990]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.734919]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.735818]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.736853]  [<ffffffff8118e194>] do_execve_common.isra.30+0x4b1/0x804
> [    2.737878]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.738761]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.739626]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.740545]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.741432]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.742325]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.743207] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.744686] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.745567] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.747017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.747950]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.749620]  ffff880011471e30 ffffffff81422eb9 0000000000000002 ffffffff8200ffe0
> [    2.751275]  ffff880012ee8000 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.752938] Call Trace:
> [    2.753545]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.754428]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.755447]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.756437]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.757422]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.758340]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.759241]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.760248]  [<ffffffff8118e194>] do_execve_common.isra.30+0x4b1/0x804
> [    2.761254]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.762135]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.763000]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.763926]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.764815]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.765715]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.766623] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.768118] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.769009] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.770433] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.771365]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.773034]  ffff880011471e30 ffffffff81422eb9 0000000000000001 ffffffff8200fed0
> [    2.774697]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.776352] Call Trace:
> [    2.777007]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.777890]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.778903]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.779892]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.780833]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.781757]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.782655]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.783665]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.784676]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.785559]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.786512]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.787520]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.788455]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.789421]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.790372] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.791920] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.792882] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.794395] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.795442]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.797260]  ffff880011471e30 ffffffff81422eb9 0000000000000002 ffffffff8200fed0
> [    2.799102]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.800862] Call Trace:
> [    2.801529]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.802463]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.803531]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.804577]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.805567]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.806554]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.807528]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.808586]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.809643]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.810580]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.811482]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.812452]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.813393]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.814331]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.815265] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.816807] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.817777] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.819233] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.820236]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.821956]  ffff880011471e30 ffffffff81422eb9 0000000000000003 ffffffff8200fed0
> [    2.823667]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.825377] Call Trace:
> [    2.826001]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.826949]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.827996]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.829016]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.830027]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.830978]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.831904]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.832939]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.833978]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.834888]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.835778]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.836753]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.837686]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.838613]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.839525] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.841043] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.841957] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.843418] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.844374]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.846088]  ffff880011471e30 ffffffff81422eb9 0000000000000004 ffffffff8200fed0
> [    2.847844]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.849566] Call Trace:
> [    2.850190]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.851088]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.852133]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.853151]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.854118]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.855073]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.856000]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.857076]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.858112]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.859019]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.859907]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.860854]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.861772]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.862700]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.863607] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.865125] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.866042] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.867541] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.868493]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.870201]  ffff880011471e30 ffffffff81422eb9 0000000000000005 ffffffff8200fed0
> [    2.877277]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.878996] Call Trace:
> [    2.879627]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.880539]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.881586]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.882608]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.883576]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.884531]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.885452]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.886501]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.887563]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.888468]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.889358]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.890311]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.891227]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.892153]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.893062] BUG: using __this_cpu_add_return() in preemptible [00000000] code: swapper/0/1
> [    2.894588] caller is __this_cpu_preempt_check+0x1a/0x23
> [    2.895507] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00039-gb84c4e0 #14
> [    2.896996] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.897952]  0000000000000000 ffff880011471e08 ffffffff81af1772 0000000000000001
> [    2.899717]  ffff880011471e30 ffffffff81422eb9 0000000000000006 ffffffff8200fed0
> [    2.901472]  ffffffff8200fe00 ffff880011471e40 ffffffff81422ef2 ffff880011471e50
> [    2.903180] Call Trace:
> [    2.903811]  [<ffffffff81af1772>] dump_stack+0xb0/0x10d
> [    2.904719]  [<ffffffff81422eb9>] check_preemption_disabled+0x18b/0x1aa
> [    2.905769]  [<ffffffff81422ef2>] __this_cpu_preempt_check+0x1a/0x23
> [    2.906828]  [<ffffffff81099b5b>] rcu_should_resched+0x17/0x38
> [    2.907795]  [<ffffffff8109a3b0>] rcu_cond_resched+0x10/0x30
> [    2.908746]  [<ffffffff81afab41>] _cond_resched+0x10/0x3f
> [    2.909670]  [<ffffffff8118d862>] count.isra.24.constprop.32+0xa5/0xda
> [    2.910709]  [<ffffffff8118e1c6>] do_execve_common.isra.30+0x4e3/0x804
> [    2.911747]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.912658]  [<ffffffff8118e501>] do_execve+0x1a/0x23
> [    2.913549]  [<ffffffff81000232>] run_init_process+0x34/0x3d
> [    2.914500]  [<ffffffff81ae101f>] kernel_init+0x69/0x175
> [    2.915409]  [<ffffffff81b0010c>] ret_from_fork+0x7c/0xb0
> [    2.916333]  [<ffffffff81ae0fb6>] ? rest_init+0xca/0xca
> [    2.920971] random: init urandom read with 5 bits of entropy available
> [    2.968860] init: Failed to create pty - disabling logging for job
> [    2.969937] init: Temporary process spawn error: No space left on device
> Kernel tests: Boot OK!
> [    6.276458] BUG: using __this_cpu_add_return() in preemptible [00000000] code: trinity/256
> [    7.279802] BUG: using __this_cpu_add_return() in preemptible [00000000] code: trinity/256
> [    8.282114] BUG: using __this_cpu_add_return() in preemptible [00000000] code: trinity/256
> [    9.284460] BUG: using __this_cpu_add_return() in preemptible [00000000] code: trinity/256
> [   10.287813] BUG: using __this_cpu_add_return() in preemptible [00000000] code: trinity/256
> 
> Elapsed time: 10
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:b84c4e08143c98dad4b4d139f08db0b98b0d3ec4:bisect-linux7/.vmlinuz-b84c4e08143c98dad4b4d139f08db0b98b0d3ec4-20140415170508-10-f2 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/b84c4e08143c98dad4b4d139f08db0b98b0d3ec4/vmlinuz-3.15.0-rc1-00039-gb84c4e0 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -drive file=/fs/vdisk/disk0-quantal-f2-63,media=disk,if=virtio -drive file=/fs/vdisk/disk1-quantal-f2-63,media=disk,if=virtio -drive file=/fs/vdisk/disk2-quantal-f2-63,media=disk,if=virtio -drive file=/fs/vdisk/disk3-quantal-f2-63,media=disk,if=virtio -drive file=/fs/vdisk/disk4-quantal-f2-63,media=disk,if=virtio -drive file=/fs/vdisk/disk5-quantal-f2-63,media=disk,if=virtio -pidfile /dev/shm/kboot/pid-quantal-f2-63 -serial file:/dev/shm/kboot/serial-quantal-f2-63 -daemonize -display none -monitor null 
> 
> 

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00038-gad86a04 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #13 SMP PREEMPT Tue Apr 15 16:59:09 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:ad86a04266f9b49730424023f6b66fe45b66e509:bisect-linux4/.vmlinuz-ad86a04266f9b49730424023f6b66fe45b66e509-20140416214640-3-brickland3 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
> [    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
> [    0.000000] BRK [0x02b55000, 0x02b55fff] PGTABLE
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
> [    0.000000] BRK [0x02b56000, 0x02b56fff] PGTABLE
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
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> [    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s74688 r8192 d23616 u1048576
> [    0.000000] pcpu-alloc: s74688 r8192 d23616 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:ad86a04266f9b49730424023f6b66fe45b66e509:bisect-linux4/.vmlinuz-ad86a04266f9b49730424023f6b66fe45b66e509-20140416214640-3-brickland3 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 268780K/327280K available (11276K kernel code, 4783K rwdata, 3348K rodata, 996K init, 5788K bss, 58500K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00038-gad86a04 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #13 SMP PREEMPT Tue Apr 15 16:59:09 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:ad86a04266f9b49730424023f6b66fe45b66e509:bisect-linux4/.vmlinuz-ad86a04266f9b49730424023f6b66fe45b66e509-20140416214640-3-brickland3 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
> [    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
> [    0.000000] BRK [0x02b55000, 0x02b55fff] PGTABLE
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
> [    0.000000] BRK [0x02b56000, 0x02b56fff] PGTABLE
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
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> [    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s74688 r8192 d23616 u1048576
> [    0.000000] pcpu-alloc: s74688 r8192 d23616 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:ad86a04266f9b49730424023f6b66fe45b66e509:bisect-linux4/.vmlinuz-ad86a04266f9b49730424023f6b66fe45b66e509-20140416214640-3-brickland3 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 268780K/327280K available (11276K kernel code, 4783K rwdata, 3348K rodata, 996K init, 5788K bss, 58500K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] allocated 1572864 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: using HPET reference calibration
> [    0.000000] tsc: Detected 2793.091 MHz processor
> [    0.707733] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.18 BogoMIPS (lpj=2793091)
> [    0.817000] pid_max: default: 32768 minimum: 301
> [    1.426000] ACPI: Core revision 20140214
> [    6.180343] ACPI: All ACPI Tables successfully acquired
> [    6.191479] Security Framework initialized
> [    6.202618] AppArmor: AppArmor initialized
> [    6.203116] Yama: becoming mindful.
> [    6.213579] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    6.215000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    6.272000] Initializing cgroup subsys debug
> [    6.273255] Initializing cgroup subsys memory
> [    6.277465] Initializing cgroup subsys devices
> [    6.281139] Initializing cgroup subsys net_cls
> [    6.282196] Initializing cgroup subsys blkio
> [    6.285149] Initializing cgroup subsys perf_event
> [    6.288444] Initializing cgroup subsys hugetlb
> [    6.307000] mce: CPU supports 10 MCE banks
> [    6.318458] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    6.318458] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    6.318458] tlb_flushall_shift: 6
> [    6.345000] Freeing SMP alternatives memory: 16K (ffffffff825a6000 - ffffffff825aa000)
> [    8.193000] random: nonblocking pool is initialized
> [    9.807844] Getting VERSION: 50011
> [    9.809240] Getting VERSION: 50011
> [    9.812198] Getting ID: 0
> [    9.814109] Getting ID: ff000000
> [    9.816191] Getting LVT0: 8700
> [    9.818236] Getting LVT1: 8400
> [    9.824223] enabled ExtINT on CPU#0
> [    9.830159] ENABLING IO-APIC IRQs
> [    9.832115] Synchronizing Arb IDs.
> [    9.834914] init IO_APIC IRQs
> [    9.838076]  apic 0 pin 0 not connected
> [    9.881000] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    9.894159] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    9.897188] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    9.898000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    9.898000]  apic 0 pin 16 not connected
> [    9.898000]  apic 0 pin 17 not connected
> [    9.898000]  apic 0 pin 18 not connected
> [    9.898000]  apic 0 pin 19 not connected
> [    9.898000]  apic 0 pin 20 not connected
> [    9.898000]  apic 0 pin 21 not connected
> [    9.898000]  apic 0 pin 22 not connected
> [    9.898000]  apic 0 pin 23 not connected
> [    9.899000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    9.911000] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)
> [    9.921142] Using local APIC timer interrupts.
> [    9.921142] calibrating APIC timer ...
> [    9.923000] ... lapic delta = 7762618
> [    9.923000] ... PM-Timer delta = 444566
> [    9.923000] APIC calibration not consistent with PM-Timer: 124ms instead of 100ms
> [    9.923000] APIC delta adjusted to PM-Timer: 6250275 (7762618)
> [    9.923000] TSC delta adjusted to PM-Timer: 279304805 (346886528)
> [    9.923000] ..... delta 6250275
> [    9.923000] ..... mult: 268447267
> [    9.923000] ..... calibration result: 1000044
> [    9.923000] ..... CPU clock speed is 2793.0048 MHz.
> [    9.923000] ..... host bus clock speed is 1000.0044 MHz.
> [   10.618262] Performance Events: unsupported p6 CPU model 60 no PMU driver, software events only.
> [   12.567362] x86: Booting SMP configuration:
> [   12.569372] .... node  #0, CPUs:      #1
> [    0.520000] masked ExtINT on CPU#1
> [    0.520000] calibrate_delay_direct() dropping max bogoMips estimate 4 = 45949599
> [    0.520000] calibrate_delay_direct() dropping min bogoMips estimate 1 = 25304616
> [    0.520000] calibrate_delay_direct() dropping min bogoMips estimate 3 = 28776510
> [   13.165193] x86: Booted up 1 node, 2 CPUs
> [   13.180208] smpboot: Total of 2 processors activated (80862.65 BogoMIPS)
> [   15.631594] devtmpfs: initialized
> [   16.151147] gcov: version magic: 0x3430382a
> [   17.264368] evm: security.SMACK64
> [   17.292517] evm: security.capability
> [   17.720573] xor: measuring software checksum speed
> [   17.875516]    prefetch64-sse:   256.000 MB/sec
> [   17.920000]    generic_sse:   116.000 MB/sec
> [   17.934437] xor: using function: prefetch64-sse (256.000 MB/sec)
> [   18.689423] regulator-dummy: no parameters
> [   19.583839] NET: Registered protocol family 16
> [   20.382123] cpuidle: using governor ladder
> [   20.456000] cpuidle: using governor menu
> [   20.666000] ACPI: bus type PCI registered
> [   20.726000] dca service started, version 1.12.1
> [   20.821000] PCI: Using configuration type 1 for base access
> [   28.974000] raid6: sse2x1      15 MB/s
> [   29.013000] raid6: sse2x2       7 MB/s
> [   29.042000] raid6: sse2x4       3 MB/s
> [   29.065000] raid6: using algorithm sse2x1 (15 MB/s)
> [   29.101606] raid6: using ssse3x2 recovery algorithm
> [   29.502000] ACPI: Added _OSI(Module Device)
> [   29.511000] ACPI: Added _OSI(Processor Device)
> [   29.526069] ACPI: Added _OSI(3.0 _SCP Extensions)
> [   29.541317] ACPI: Added _OSI(Processor Aggregator Device)
> [   35.513278] ACPI: Interpreter enabled
> [   35.514553] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
> [   35.519101] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
> [   35.527958] ACPI: (supports S0 S3 S4 S5)
> [   35.529291] ACPI: Using IOAPIC for interrupt routing
> [   35.534075] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [   40.559000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [   40.575604] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
> [   40.617000] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [   41.137000] PCI host bridge to bus 0000:00
> [   41.160000] pci_bus 0000:00: root bus resource [bus 00-ff]
> [   41.167000] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [   41.190000] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [   41.195000] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [   41.196000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [   41.229553] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [   41.608000] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [   42.022396] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [   42.177401] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [   42.189618] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [   42.190000] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [   42.190000] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [   42.190000] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [   42.372000] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [   42.385479] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [   42.388116] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [   42.593110] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [   42.636000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [   42.640440] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [   42.735392] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [   42.770969] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [   42.776379] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [   42.781984] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [   42.800448] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [   42.880592] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [   42.894916] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [   43.127000] pci_bus 0000:00: on NUMA node 0
> [   43.442472] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [   43.758000] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [   43.900406] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [   44.179000] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [   44.393000] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [   45.381000] ACPI: Enabled 16 GPEs in block 00 to 0F
> [   45.869000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [   45.900466] vgaarb: loaded
> [   45.930000] vgaarb: bridge control possible 0000:00:02.0
> [   46.058382] SCSI subsystem initialized
> [   46.188000] pps_core: LinuxPPS API ver. 1 registered
> [   46.211000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [   46.227428] PTP clock support registered
> [   46.267153] EDAC MC: Ver: 3.0.0
> [   46.363000] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [   46.593181] PCI: Using ACPI for IRQ routing
> [   46.615376] PCI: pci_cache_line_size set to 64 bytes
> [   46.693000] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [   46.716000] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [   47.009563] irda_init()
> [   47.101000] NET: Registered protocol family 23
> [   47.339000] NetLabel: Initializing
> [   47.367000] cfg80211: Calling CRDA to update world regulatory domain
> [   47.389348] NetLabel:  domain hash size = 128
> [   47.394102] NetLabel:  protocols = UNLABELED CIPSOv4
> [   47.488000] NetLabel:  unlabeled traffic allowed by default
> [   47.557000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [   47.733111] Switched to clocksource hpet
> [   47.998876] FS-Cache: Loaded
> [   48.133074] AppArmor: AppArmor Filesystem Enabled
> [   49.321037] pnp: PnP ACPI init
> [   49.321037] ACPI: bus type PNP registered
> [   50.080264] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [   50.443160] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [   51.336081] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [   53.357286] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [   53.488964] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [   53.545245] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [   53.550970] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [   53.575039] pnp 00:03: [dma 2]
> [   53.625881] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [   53.633850] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [   53.655645] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [   53.693257] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [   53.698047] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [   53.723915] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [   53.730581] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [   54.920095] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [   56.040907] pnp: PnP ACPI: found 8 devices
> [   56.065434] ACPI: bus type PNP unregistered
> [   59.459653] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [   59.478676] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [   59.494512] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [   59.515241] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [   59.604468] NET: Registered protocol family 2
> [   60.083545] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> [   60.130248] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
> [   60.177490] TCP: Hash tables configured (established 4096 bind 4096)
> [   60.294576] TCP: reno registered
> [   60.336951] UDP hash table entries: 256 (order: 1, 8192 bytes)
> [   60.411633] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
> [   60.684653] NET: Registered protocol family 1
> [   60.730582] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [   60.746818] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [   60.776832] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [   60.809782] pci 0000:00:02.0: Boot video device
> [   60.850147] PCI: CLS 0 bytes, default 64
> [   61.567537] Trying to unpack rootfs image as initramfs...
> [  397.963765] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [  398.264674] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Joules, 3 fixed counters 10737418240 ms ovfl timer
> [  398.280954] Machine check injector initialized
> [  399.569041] tsc: Refined TSC clocksource calibration: 2793.094 MHz
> [  399.611900] Switched to clocksource tsc
> [  400.003772] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
> [  400.524019] alg: No test for crc32 (crc32-pclmul)
> [  400.535903] AVX or AES-NI instructions are not detected.
> [  400.540745] AVX2 or AES-NI instructions are not detected.
> [  400.586669] futex hash table entries: 512 (order: 3, 32768 bytes)
> [  400.602971] Initialise system trusted keyring
> [  400.614949] audit: initializing netlink subsys (disabled)
> [  400.642098] audit: type=2000 audit(1397685211.632:1): initialized
> [  627.832917] bounce pool size: 64 pages
> [  627.836299] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [  628.404209] VFS: Disk quotas dquot_6.5.2
> [  628.413701] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [  628.464622] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [  628.594912] ntfs: driver 2.1.30 [Flags: R/O].
> [  628.913035] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> [  628.935579] ROMFS MTD (C) 2007 Red Hat, Inc.
> [  628.954884] QNX6 filesystem 1.0.0 registered.
> [  629.221218] msgmni has been set to 570
> [  631.754051] alg: No test for lz4hc (lz4hc-generic)
> [  631.762067] alg: No test for stdrng (krng)
> [  631.776893] NET: Registered protocol family 38
> [  631.780592] Key type asymmetric registered
> [  631.780880] Asymmetric key parser 'x509' registered
> [  631.797988] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [  631.811840] io scheduler noop registered
> [  631.869994] io scheduler deadline registered (default)
> [  631.887024] test_string_helpers: Running tests...
> [  633.150260] crc32: CRC_LE_BITS = 1, CRC_BE BITS = 1
> [  633.171904] crc32: self tests passed, processed 225944 bytes in 119908760 nsec
> [  633.321921] crc32c: CRC_LE_BITS = 1
> [  633.396986] crc32c: self tests passed, processed 225944 bytes in 54502828 nsec
> [  656.200981] crc32_combine: 8373 self tests passed
> [  669.150284] crc32c_combine: 8373 self tests passed
> [  669.166933] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [  669.173671] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> [  669.250857] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [  669.270976] ACPI: Power Button [PWRF]
> [  669.353839] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [  675.888104] r3964: Philips r3964 Driver $Revision: 1.10 $
> [  675.889942] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [  675.941242] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [  675.992934] serial: Freescale lpuart driver
> [  675.996044] SyncLink GT
> [  675.998068] SyncLink GT, tty major#249
> [  676.001041] SyncLink GT no devices found
> [  676.002247] SyncLink MultiPort driver $Revision: 4.38 $
> [  676.438277] SyncLink MultiPort driver $Revision: 4.38 $, tty major#248
> [  676.456960] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
> [  676.460232] ac.o: No PCI boards found.
> [  676.462110] ac.o: For an ISA board you must supply memory and irq parameters.
> [  677.302255] brd: module loaded
> [  678.073088] loop: module loaded
> [  678.118873] skd:  v2.2.1-b0260 loaded
> [  678.195254] MM: desc_per_page = 128
> [  678.213709] nbd: registered device at major 43
> [  681.686531] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
> [  681.694527] drbd: built-in
> [  681.698237] drbd: registered as block device major 147
> [  681.709271] rbd: loaded
> [  682.451785]  nullb0: unknown partition table
> [  682.826303]  nullb1: unknown partition table
> [  682.978715] null: module loaded
> [  682.986857] Phantom Linux Driver, version n0.9.8, init OK
> [  682.986857] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [  683.365292] Loading iSCSI transport class v2.0-870.
> [  683.506198] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
> [  683.513662] fnic: Successfully Initialized Trace Buffer
> [  683.654577] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.2 (Dec 11, 2013)
> [  683.795657] Adaptec aacraid driver 1.2-0[30300]-ms
> [  683.821324] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
> [  683.892278] DC390: clustering now enabled by default. If you get problems load
> [  683.899629]        with "disable_clustering=1" and report to maintainers
> [  683.924617] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [  683.949223] 3ware Storage Controller device driver for Linux v1.26.02.003.
> [  683.996178] RocketRAID 3xxx/4xxx Controller driver v1.8
> [  683.996178] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> [  684.029854] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
> [  684.063083] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
> [  684.113061] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
> [  684.260682] iscsi: registered transport (cxgb4i)
> [  684.324793] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2013)
> [  684.484624] iscsi: registered transport (bnx2i)
> [  684.666549] iscsi: registered transport (be2iscsi)
> [  684.679165] In beiscsi_module_init, tt=ffffffff8230c9a0
> [  684.779677] SCSI Media Changer driver v0.25 
> [  685.702579] arcnet loaded.
> [  685.716751] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
> [  685.737137] arcnet: COM90xx chipset support
> [  687.446289] S3: No ARCnet cards found.
> [  687.457733] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March 14, 2014)
> [  687.488261] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.19-0 (2014/02/10)
> [  687.848937] vxge: Copyright(c) 2002-2010 Exar Corp.
> [  687.873018] vxge: Driver version: 2.5.3.22640-k
> [  688.563972] airo(): Probing for PCI adapters
> [  688.576824] airo(): Finished probing for PCI adapters
> [  688.581888] Loaded prism54 driver, version 1.2
> [  688.668602] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [  688.773317] serio: i8042 KBD port at 0x60,0x64 irq 1
> [  688.790820] serio: i8042 AUX port at 0x60,0x64 irq 12
> [  689.068913] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [  689.126312] input: PC Speaker as /devices/platform/pcspkr/input/input2
> [  689.165698] pps pps0: new PPS source ktimer
> [  689.171162] pps pps0: ktimer PPS source registered
> [  689.293307] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [  689.303235] CAPI 2.0 started up with major 68 (no middleware)
> [  689.303235] EDAC DEBUG: i5000_init: MC:
> [  689.417955] cs5535-clockevt: Could not allocate MFGPT timer
> [  689.454592] pktgen: Packet Generator for packet performance testing. Version: 2.74
> [  689.489702] NET: Registered protocol family 26
> [  689.551859] netem: version 1.3
> [  689.578837] Netfilter messages via NETLINK v0.30.
> [  689.581826] nf_conntrack version 0.5.0 (2281 buckets, 9124 max)
> [  689.727303] ctnetlink v0.93: registering with nfnetlink.
> [  689.746570] ip_set: protocol 6
> [  689.752880] IPVS: Registered protocols (SCTP, ESP)
> [  689.758277] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
> [  689.773249] IPVS: Creating netns size=1464 id=0
> [  689.782784] IPVS: ipvs loaded.
> [  689.786631] IPVS: [wrr] scheduler registered.
> [  689.790882] IPVS: [lc] scheduler registered.
> [  689.797768] IPVS: [sh] scheduler registered.
> [  689.823919] ip_tables: (C) 2000-2006 Netfilter Core Team
> [  689.861256] TCP: htcp registered
> [  689.863763] Initializing XFRM netlink socket
> [  690.256761] NET: Registered protocol family 10
> [  690.899828] mip6: Mobile IPv6
> [  690.983996] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [  691.614917] ip6_gre: GRE over IPv6 tunneling driver
> [  691.702887] Ebtables v2.0 registered
> [  691.714311] NET: Registered protocol family 5
> [  691.722901] NET: Registered protocol family 3
> [  691.730810] l2tp_core: L2TP core driver, V2.0
> [  691.732957] l2tp_netlink: L2TP netlink interface
> [  691.753311] DCCP: Activated CCID 2 (TCP-like)
> [  691.815047] 9pnet: Installing 9P2000 support
> [  691.829777] NET: Registered protocol family 36
> [  691.832928] Key type ceph registered
> [  691.870803] libceph: loaded (mon/osd proto 15/24)
> [  691.879946] batman_adv: B.A.T.M.A.N. advanced 2014.2.0 (compatibility version 15) loaded
> [  691.949997] 
> [  691.949997] printing PIC contents
> [  691.955981] ... PIC  IMR: ffff
> [  691.956812] ... PIC  IRR: 1013
> [  691.969166] ... PIC  ISR: 0000
> [  691.975568] ... PIC ELCR: 0c00
> [  691.980007] printing local APIC contents on CPU#0/0:
> [  691.980708] ... APIC ID:      00000000 (0)
> [  691.980708] ... APIC VERSION: 00050011
> [  691.980708] ... APIC TASKPRI: 00000000 (00)
> [  691.980708] ... APIC ARBPRI: 00000000 (00)
> [  691.980708] ... APIC PROCPRI: 00000000
> [  691.980708] ... APIC LDR: 01000000
> [  691.980708] ... APIC DFR: f0000000
> [  691.980708] ... APIC SPIV: 000001ff
> [  691.980708] ... APIC ISR field:
> [  691.980708] 0000000000000000000000000000000000000000000000000000000000000000
> [  691.980708] ... APIC TMR field:
> [  691.980708] 0000000000000000000000000000000000000000000000000000000000000000
> [  691.980708] ... APIC IRR field:
> [  691.980708] 0000000000000000000000000000000000000000000000000000000000008000
> [  691.980708] ... APIC ESR: 00000000
> [  691.980708] ... APIC ICR: 000008fd
> [  691.980708] ... APIC ICR2: 02000000
> [  691.980708] ... APIC LVTT: 000200ef
> [  691.980708] ... APIC LVTPC: 00010000
> [  691.980708] ... APIC LVT0: 00010700
> [  691.980708] ... APIC LVT1: 00000400
> [  691.980708] ... APIC LVTERR: 000000fe
> [  691.980708] ... APIC TMICT: 0000f426
> [  691.980708] ... APIC TMCCT: 000055df
> [  691.980708] ... APIC TDCR: 00000003
> [  691.980708] 
> [  692.302755] number of MP IRQ sources: 15.
> [  692.312008] number of IO-APIC #0 registers: 24.
> [  692.332275] testing the IO APIC.......................
> [  692.355680] IO APIC #0......
> [  692.375953] .... register #00: 00000000
> [  692.391955] .......    : physical APIC id: 00
> [  692.401928] .......    : Delivery Type: 0
> [  692.409933] .......    : LTS          : 0
> [  692.428231] .... register #01: 00170011
> [  692.440060] .......     : max redirection entries: 17
> [  692.451796] .......     : PRQ implemented: 0
> [  692.462153] .......     : IO APIC version: 11
> [  692.476142] .... register #02: 00000000
> [  692.501047] .......     : arbitration: 00
> [  692.505970] .... IRQ redirection table:
> [  692.512916] 1    0    0   0   0    0    0    00
> [  692.521000] 0    0    0   0   0    1    1    31
> [  692.525830] 0    0    0   0   0    1    1    30
> [  692.529719] 0    0    0   0   0    1    1    33
> [  692.531307] 1    0    0   0   0    1    1    34
> [  692.535852] 1    1    0   0   0    1    1    35
> [  692.538811] 0    0    0   0   0    1    1    36
> [  692.545170] 0    0    0   0   0    1    1    37
> [  692.553274] 0    0    0   0   0    1    1    38
> [  692.569014] 0    1    0   0   0    1    1    39
> [  692.578237] 1    1    0   0   0    1    1    3A
> [  692.585033] 1    1    0   0   0    1    1    3B
> [  692.594896] 0    0    0   0   0    1    1    3C
> [  692.599906] 0    0    0   0   0    1    1    3D
> [  692.605047] 0    0    0   0   0    1    1    3E
> [  692.665089] 0    0    0   0   0    1    1    3F
> [  692.670965] 1    0    0   0   0    0    0    00
> [  692.703113] 1    0    0   0   0    0    0    00
> [  692.709751] 1    0    0   0   0    0    0    00
> [  692.710586] 1    0    0   0   0    0    0    00
> [  692.710586] 1    0    0   0   0    0    0    00
> [  692.710586] 1    0    0   0   0    0    0    00
> [  692.716731] 1    0    0   0   0    0    0    00
> [  692.717580] 1    0    0   0   0    0    0    00
> [  692.723008] IRQ to pin mappings:
> [  692.726923] IRQ0 -> 0:2
> [  692.731009] IRQ1 -> 0:1
> [  692.744129] IRQ3 -> 0:3
> [  692.746849] IRQ4 -> 0:4
> [  692.755310] IRQ5 -> 0:5
> [  692.759907] IRQ6 -> 0:6
> [  692.762839] IRQ7 -> 0:7
> [  692.764160] IRQ8 -> 0:8
> [  692.766043] IRQ9 -> 0:9
> [  692.768869] IRQ10 -> 0:10
> [  692.781013] IRQ11 -> 0:11
> [  692.787802] IRQ12 -> 0:12
> [  692.791863] IRQ13 -> 0:13
> [  692.796298] IRQ14 -> 0:14
> [  692.804963] IRQ15 -> 0:15
> [  692.813719] .................................... done.
> [  692.931068] Loading compiled-in X.509 certificates
> [  693.848041] Btrfs loaded, debug=on, integrity-checker=on
> [  694.183013] Key type encrypted registered
> [  695.034288] bnx2fc: CPU 0 offline: Remove Rx thread
> [  695.034288] CPU 0 offline: Remove Rx thread
> [  695.142150] CPU 0 is now offline
> [  696.469303] Freeing unused kernel memory: 996K (ffffffff824ad000 - ffffffff825a6000)
> [  696.469303] Write protecting the kernel read-only data: 16384k
> [  702.769871] Freeing unused kernel memory: 964K (ffff880001b0f000 - ffff880001c00000)
> [  706.070209] Freeing unused kernel memory: 748K (ffff880001f45000 - ffff880002000000)
> 
> BUG: kernel boot hang
> Elapsed time: 905
> qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04151432/linux-devel:devel-hourly-2014041512:ad86a04266f9b49730424023f6b66fe45b66e509:bisect-linux4/.vmlinuz-ad86a04266f9b49730424023f6b66fe45b66e509-20140416214640-3-brickland3 branch=linux-devel/devel-hourly-2014041512 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04151432/ad86a04266f9b49730424023f6b66fe45b66e509/vmlinuz-3.15.0-rc1-00038-gad86a04 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-brickland3-123 -serial file:/dev/shm/kboot/serial-quantal-brickland3-123 -daemonize -display none -monitor null 
> 
> 


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
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> CONFIG_KERNEL_LZO=y
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_FHANDLE=y
> # CONFIG_USELIB is not set
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> # CONFIG_AUDITSYSCALL is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
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
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> # CONFIG_TICK_CPU_ACCOUNTING is not set
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> CONFIG_IRQ_TIME_ACCOUNTING=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_RCU_USER_QS=y
> # CONFIG_CONTEXT_TRACKING_FORCE is not set
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_RCU_FAST_NO_HZ is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> CONFIG_RCU_NOCB_CPU_ZERO=y
> # CONFIG_RCU_NOCB_CPU_ALL is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> CONFIG_MEMCG=y
> # CONFIG_MEMCG_SWAP is not set
> CONFIG_MEMCG_KMEM=y
> CONFIG_CGROUP_HUGETLB=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> CONFIG_DEBUG_BLK_CGROUP=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> CONFIG_MM_OWNER=y
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_SYSFS_SYSCALL=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_SLUB_CPU_PARTIAL=y
> CONFIG_PROFILING=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
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
> CONFIG_GCOV_PROFILE_ALL=y
> # CONFIG_GCOV_FORMAT_AUTODETECT is not set
> # CONFIG_GCOV_FORMAT_3_4 is not set
> CONFIG_GCOV_FORMAT_4_7=y
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> CONFIG_MODULE_SRCVERSION_ALL=y
> # CONFIG_MODULE_SIG is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> # CONFIG_ACORN_PARTITION_CUMANA is not set
> CONFIG_ACORN_PARTITION_EESOX=y
> CONFIG_ACORN_PARTITION_ICS=y
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> # CONFIG_ACORN_PARTITION_RISCIX is not set
> # CONFIG_AIX_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> # CONFIG_MSDOS_PARTITION is not set
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_CMDLINE_PARTITION=y
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=m
> CONFIG_CFQ_GROUP_IOSCHED=y
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_MATOM is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_P6_NOP=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=8
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_INTEL is not set
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_I8K=m
> CONFIG_MICROCODE=m
> # CONFIG_MICROCODE_INTEL is not set
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_PROC_KCORE_TEXT=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> # CONFIG_SPARSEMEM_VMEMMAP is not set
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_MEMORY_FAILURE is not set
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_CLEANCACHE=y
> CONFIG_FRONTSWAP=y
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSWAP is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_KEXEC_JUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> CONFIG_DEBUG_HOTPLUG_CPU0=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> CONFIG_PM_WAKELOCKS_GC=y
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
> # CONFIG_ACPI_VIDEO is not set
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
> # CONFIG_ACPI_EXTLOG is not set
> CONFIG_SFI=y
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
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
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> # CONFIG_HT_IRQ is not set
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
> CONFIG_HOTPLUG_PCI_SHPC=m
> CONFIG_RAPIDIO=y
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> # CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
> # CONFIG_RAPIDIO_DMA_ENGINE is not set
> CONFIG_RAPIDIO_DEBUG=y
> CONFIG_RAPIDIO_ENUM_BASIC=m
> 
> #
> # RapidIO Switch drivers
> #
> CONFIG_RAPIDIO_TSI57X=m
> CONFIG_RAPIDIO_CPS_XX=m
> CONFIG_RAPIDIO_TSI568=y
> CONFIG_RAPIDIO_CPS_GEN2=m
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=m
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=m
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> CONFIG_COMPAT_NETLINK_MESSAGES=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=m
> CONFIG_PACKET_DIAG=m
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_ROUTE_CLASSID=y
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IP_TUNNEL=y
> # CONFIG_NET_IPGRE is not set
> CONFIG_IP_MROUTE=y
> # CONFIG_IP_PIMSM_V1 is not set
> # CONFIG_IP_PIMSM_V2 is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_INET_UDP_DIAG=m
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> # CONFIG_TCP_CONG_CUBIC is not set
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=y
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> # CONFIG_TCP_CONG_SCALABLE is not set
> # CONFIG_TCP_CONG_LP is not set
> # CONFIG_TCP_CONG_VENO is not set
> CONFIG_TCP_CONG_YEAH=m
> # CONFIG_TCP_CONG_ILLINOIS is not set
> CONFIG_DEFAULT_HTCP=y
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="htcp"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> # CONFIG_INET6_AH is not set
> # CONFIG_INET6_ESP is not set
> # CONFIG_INET6_IPCOMP is not set
> CONFIG_IPV6_MIP6=y
> # CONFIG_INET6_XFRM_TUNNEL is not set
> CONFIG_INET6_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> CONFIG_IPV6_VTI=m
> # CONFIG_IPV6_SIT is not set
> CONFIG_IPV6_TUNNEL=y
> CONFIG_IPV6_GRE=y
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> CONFIG_IPV6_MROUTE=y
> # CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
> CONFIG_IPV6_PIMSM_V2=y
> CONFIG_NETLABEL=y
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NET_PTP_CLASSIFY=y
> CONFIG_NETWORK_PHY_TIMESTAMPING=y
> CONFIG_NETFILTER=y
> CONFIG_NETFILTER_DEBUG=y
> # CONFIG_NETFILTER_ADVANCED is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=y
> # CONFIG_NF_CONNTRACK_PROCFS is not set
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_IRC=y
> # CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
> CONFIG_NF_CONNTRACK_SIP=y
> CONFIG_NF_CT_NETLINK=y
> CONFIG_NF_TABLES=m
> # CONFIG_NF_TABLES_INET is not set
> # CONFIG_NFT_EXTHDR is not set
> # CONFIG_NFT_META is not set
> # CONFIG_NFT_CT is not set
> CONFIG_NFT_RBTREE=m
> CONFIG_NFT_HASH=m
> # CONFIG_NFT_COUNTER is not set
> CONFIG_NFT_LOG=m
> CONFIG_NFT_LIMIT=m
> CONFIG_NFT_REJECT=m
> # CONFIG_NFT_COMPAT is not set
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=y
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_LOG=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> # CONFIG_NETFILTER_XT_MATCH_POLICY is not set
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_IP_SET=y
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=y
> CONFIG_IP_SET_HASH_IP=m
> # CONFIG_IP_SET_HASH_IPMARK is not set
> # CONFIG_IP_SET_HASH_IPPORT is not set
> # CONFIG_IP_SET_HASH_IPPORTIP is not set
> # CONFIG_IP_SET_HASH_IPPORTNET is not set
> CONFIG_IP_SET_HASH_NETPORTNET=m
> CONFIG_IP_SET_HASH_NET=m
> CONFIG_IP_SET_HASH_NETNET=m
> # CONFIG_IP_SET_HASH_NETPORT is not set
> # CONFIG_IP_SET_HASH_NETIFACE is not set
> # CONFIG_IP_SET_LIST_SET is not set
> CONFIG_IP_VS=y
> CONFIG_IP_VS_IPV6=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> # CONFIG_IP_VS_PROTO_TCP is not set
> # CONFIG_IP_VS_PROTO_UDP is not set
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> # CONFIG_IP_VS_PROTO_AH is not set
> CONFIG_IP_VS_PROTO_SCTP=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=y
> CONFIG_IP_VS_LC=y
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> # CONFIG_IP_VS_DH is not set
> CONFIG_IP_VS_SH=y
> # CONFIG_IP_VS_SED is not set
> CONFIG_IP_VS_NQ=m
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> # CONFIG_IP_VS_NFCT is not set
> 
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV4 is not set
> # CONFIG_NF_CONNTRACK_IPV4 is not set
> CONFIG_NF_TABLES_IPV4=m
> # CONFIG_NFT_CHAIN_ROUTE_IPV4 is not set
> CONFIG_NFT_REJECT_IPV4=m
> # CONFIG_NF_TABLES_ARP is not set
> CONFIG_IP_NF_IPTABLES=y
> # CONFIG_IP_NF_FILTER is not set
> CONFIG_IP_NF_TARGET_ULOG=m
> # CONFIG_IP_NF_MANGLE is not set
> CONFIG_IP_NF_RAW=y
> 
> #
> # IPv6: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV6 is not set
> # CONFIG_NF_CONNTRACK_IPV6 is not set
> # CONFIG_NF_TABLES_IPV6 is not set
> CONFIG_IP6_NF_IPTABLES=y
> # CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
> # CONFIG_IP6_NF_FILTER is not set
> # CONFIG_IP6_NF_MANGLE is not set
> CONFIG_IP6_NF_RAW=y
> CONFIG_NF_TABLES_BRIDGE=m
> CONFIG_BRIDGE_NF_EBTABLES=y
> CONFIG_BRIDGE_EBT_BROUTE=m
> # CONFIG_BRIDGE_EBT_T_FILTER is not set
> CONFIG_BRIDGE_EBT_T_NAT=y
> CONFIG_BRIDGE_EBT_802_3=m
> # CONFIG_BRIDGE_EBT_AMONG is not set
> CONFIG_BRIDGE_EBT_ARP=y
> # CONFIG_BRIDGE_EBT_IP is not set
> CONFIG_BRIDGE_EBT_IP6=m
> # CONFIG_BRIDGE_EBT_LIMIT is not set
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=y
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=y
> CONFIG_BRIDGE_EBT_ARPREPLY=y
> CONFIG_BRIDGE_EBT_DNAT=m
> # CONFIG_BRIDGE_EBT_MARK_T is not set
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> # CONFIG_BRIDGE_EBT_LOG is not set
> # CONFIG_BRIDGE_EBT_ULOG is not set
> CONFIG_BRIDGE_EBT_NFLOG=m
> CONFIG_IP_DCCP=y
> CONFIG_INET_DCCP_DIAG=m
> 
> #
> # DCCP CCIDs Configuration
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> # CONFIG_IP_DCCP_CCID3 is not set
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> CONFIG_TIPC=m
> CONFIG_TIPC_PORTS=8191
> # CONFIG_TIPC_MEDIA_IB is not set
> # CONFIG_ATM is not set
> CONFIG_L2TP=y
> # CONFIG_L2TP_DEBUGFS is not set
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=m
> # CONFIG_L2TP_ETH is not set
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> # CONFIG_BRIDGE_IGMP_SNOOPING is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> CONFIG_NET_DSA_TAG_EDSA=y
> CONFIG_NET_DSA_TAG_TRAILER=y
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=m
> CONFIG_IPX_INTERN=y
> CONFIG_ATALK=y
> # CONFIG_DEV_APPLETALK is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_PHONET=m
> CONFIG_IEEE802154=y
> # CONFIG_IEEE802154_6LOWPAN is not set
> # CONFIG_MAC802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> # CONFIG_NET_SCH_HTB is not set
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> CONFIG_NET_SCH_RED=m
> # CONFIG_NET_SCH_SFB is not set
> CONFIG_NET_SCH_SFQ=y
> CONFIG_NET_SCH_TEQL=y
> CONFIG_NET_SCH_TBF=m
> # CONFIG_NET_SCH_GRED is not set
> # CONFIG_NET_SCH_DSMARK is not set
> CONFIG_NET_SCH_NETEM=y
> # CONFIG_NET_SCH_DRR is not set
> # CONFIG_NET_SCH_MQPRIO is not set
> CONFIG_NET_SCH_CHOKE=y
> CONFIG_NET_SCH_QFQ=m
> # CONFIG_NET_SCH_CODEL is not set
> CONFIG_NET_SCH_FQ_CODEL=m
> CONFIG_NET_SCH_FQ=m
> CONFIG_NET_SCH_HHF=m
> CONFIG_NET_SCH_PIE=m
> CONFIG_NET_SCH_PLUG=y
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> # CONFIG_NET_CLS_BASIC is not set
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=y
> CONFIG_NET_CLS_RSVP6=y
> CONFIG_NET_CLS_FLOW=m
> # CONFIG_NET_CLS_CGROUP is not set
> # CONFIG_NET_CLS_BPF is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=y
> CONFIG_NET_EMATCH_CANID=y
> CONFIG_NET_EMATCH_IPSET=y
> # CONFIG_NET_CLS_ACT is not set
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=m
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_BLA is not set
> CONFIG_BATMAN_ADV_DAT=y
> CONFIG_BATMAN_ADV_NC=y
> # CONFIG_BATMAN_ADV_MCAST is not set
> CONFIG_BATMAN_ADV_DEBUG=y
> CONFIG_OPENVSWITCH=m
> CONFIG_OPENVSWITCH_GRE=y
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> CONFIG_NETLINK_DIAG=y
> # CONFIG_NET_MPLS_GSO is not set
> # CONFIG_HSR is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> CONFIG_CGROUP_NET_CLASSID=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> # CONFIG_BPF_JIT is not set
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=y
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=y
> CONFIG_AX25_DAMA_SLAVE=y
> # CONFIG_NETROM is not set
> # CONFIG_ROSE is not set
> 
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=m
> CONFIG_6PACK=m
> # CONFIG_BPQETHER is not set
> CONFIG_BAYCOM_SER_FDX=m
> CONFIG_BAYCOM_SER_HDX=m
> CONFIG_BAYCOM_PAR=m
> # CONFIG_YAM is not set
> CONFIG_CAN=m
> CONFIG_CAN_RAW=m
> CONFIG_CAN_BCM=m
> CONFIG_CAN_GW=m
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=m
> CONFIG_CAN_SLCAN=m
> # CONFIG_CAN_DEV is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> # CONFIG_IRCOMM is not set
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> CONFIG_IRDA_DEBUG=y
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=m
> 
> #
> # Dongle support
> #
> # CONFIG_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> CONFIG_NSC_FIR=m
> # CONFIG_WINBOND_FIR is not set
> CONFIG_SMC_IRCC_FIR=y
> # CONFIG_ALI_FIR is not set
> CONFIG_VLSI_FIR=y
> # CONFIG_VIA_FIR is not set
> CONFIG_BT=m
> # CONFIG_BT_6LOWPAN is not set
> CONFIG_BT_RFCOMM=m
> CONFIG_BT_RFCOMM_TTY=y
> # CONFIG_BT_BNEP is not set
> CONFIG_BT_CMTP=m
> CONFIG_BT_HIDP=m
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTSDIO=m
> CONFIG_BT_HCIUART=m
> # CONFIG_BT_HCIUART_H4 is not set
> CONFIG_BT_HCIUART_BCSP=y
> CONFIG_BT_HCIUART_ATH3K=y
> # CONFIG_BT_HCIUART_LL is not set
> # CONFIG_BT_HCIUART_3WIRE is not set
> CONFIG_BT_HCIVHCI=m
> # CONFIG_BT_MRVL is not set
> CONFIG_BT_WILINK=m
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_SPY=y
> CONFIG_WEXT_PRIV=y
> CONFIG_CFG80211=y
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> # CONFIG_CFG80211_DEFAULT_PS is not set
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> # CONFIG_CFG80211_WEXT is not set
> CONFIG_LIB80211=m
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=m
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> CONFIG_RFKILL_REGULATOR=m
> CONFIG_NET_9P=y
> CONFIG_NET_9P_VIRTIO=m
> CONFIG_NET_9P_RDMA=m
> CONFIG_NET_9P_DEBUG=y
> CONFIG_CAIF=m
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=m
> CONFIG_CAIF_USB=m
> CONFIG_CEPH_LIB=y
> CONFIG_CEPH_LIB_PRETTYDEBUG=y
> # CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
> CONFIG_NFC=m
> CONFIG_NFC_DIGITAL=m
> # CONFIG_NFC_NCI is not set
> CONFIG_NFC_HCI=m
> # CONFIG_NFC_SHDLC is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_SIM is not set
> CONFIG_NFC_PN544=m
> CONFIG_NFC_MICROREAD=m
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
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=m
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> # CONFIG_DMA_SHARED_BUFFER is not set
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=m
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=m
> # CONFIG_PARPORT_SERIAL is not set
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_PARIDE is not set
> CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
> CONFIG_BLK_CPQ_CISS_DA=m
> # CONFIG_CISS_SCSI_TAPE is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> CONFIG_BLK_DEV_UMEM=y
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> CONFIG_BLK_DEV_CRYPTOLOOP=y
> CONFIG_BLK_DEV_DRBD=y
> # CONFIG_DRBD_FAULT_INJECTION is not set
> CONFIG_BLK_DEV_NBD=y
> CONFIG_BLK_DEV_NVME=y
> CONFIG_BLK_DEV_SKD=y
> CONFIG_BLK_DEV_OSD=m
> CONFIG_BLK_DEV_SX8=y
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_XIP=y
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_VIRTIO_BLK=y
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RBD=y
> CONFIG_BLK_DEV_RSXX=m
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=m
> CONFIG_AD525X_DPOT=m
> # CONFIG_AD525X_DPOT_I2C is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=y
> # CONFIG_SGI_IOC4 is not set
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> # CONFIG_ICS932S401 is not set
> CONFIG_ATMEL_SSC=y
> CONFIG_ENCLOSURE_SERVICES=y
> CONFIG_CS5535_MFGPT=y
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> CONFIG_CS5535_CLOCK_EVENT_SRC=y
> CONFIG_HP_ILO=m
> CONFIG_APDS9802ALS=m
> CONFIG_ISL29003=m
> CONFIG_ISL29020=m
> CONFIG_SENSORS_TSL2550=m
> CONFIG_SENSORS_BH1780=m
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=m
> CONFIG_HMC6352=m
> # CONFIG_DS1682 is not set
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=m
> CONFIG_PCH_PHUB=y
> CONFIG_USB_SWITCH_FSA9480=m
> # CONFIG_SRAM is not set
> CONFIG_C2PORT=y
> # CONFIG_C2PORT_DURAMAR_2150 is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=m
> CONFIG_EEPROM_MAX6875=m
> CONFIG_EEPROM_93CX6=m
> CONFIG_CB710_CORE=m
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_TI_ST=m
> CONFIG_SENSORS_LIS3_I2C=m
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> CONFIG_VMWARE_VMCI=m
> 
> #
> # Intel MIC Host Driver
> #
> # CONFIG_INTEL_MIC_HOST is not set
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_INTEL_MIC_CARD is not set
> CONFIG_GENWQE=m
> CONFIG_ECHO=m
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=y
> CONFIG_SCSI_ENCLOSURE=m
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_FC_TGT_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=m
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> CONFIG_ISCSI_BOOT_SYSFS=y
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> CONFIG_SCSI_CXGB4_ISCSI=y
> CONFIG_SCSI_BNX2_ISCSI=y
> CONFIG_SCSI_BNX2X_FCOE=y
> CONFIG_BE2ISCSI=y
> CONFIG_BLK_DEV_3W_XXXX_RAID=y
> CONFIG_SCSI_HPSA=y
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_ACARD is not set
> CONFIG_SCSI_AACRAID=y
> CONFIG_SCSI_AIC7XXX=m
> CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
> CONFIG_AIC7XXX_RESET_DELAY_MS=5000
> CONFIG_AIC7XXX_DEBUG_ENABLE=y
> CONFIG_AIC7XXX_DEBUG_MASK=0
> # CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
> CONFIG_SCSI_AIC79XX=m
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=5000
> # CONFIG_AIC79XX_DEBUG_ENABLE is not set
> CONFIG_AIC79XX_DEBUG_MASK=0
> CONFIG_AIC79XX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC94XX=m
> # CONFIG_AIC94XX_DEBUG is not set
> CONFIG_SCSI_MVSAS=m
> CONFIG_SCSI_MVSAS_DEBUG=y
> CONFIG_SCSI_MVSAS_TASKLET=y
> # CONFIG_SCSI_MVUMI is not set
> CONFIG_SCSI_DPT_I2O=m
> CONFIG_SCSI_ADVANSYS=y
> # CONFIG_SCSI_ARCMSR is not set
> CONFIG_SCSI_ESAS2R=m
> CONFIG_MEGARAID_NEWGEN=y
> # CONFIG_MEGARAID_MM is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> CONFIG_SCSI_HPTIOP=y
> CONFIG_SCSI_BUSLOGIC=m
> CONFIG_SCSI_FLASHPOINT=y
> CONFIG_VMWARE_PVSCSI=m
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> # CONFIG_FCOE is not set
> CONFIG_FCOE_FNIC=y
> CONFIG_SCSI_DMX3191D=m
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> CONFIG_SCSI_GDTH=y
> CONFIG_SCSI_ISCI=y
> CONFIG_SCSI_IPS=y
> CONFIG_SCSI_INITIO=m
> CONFIG_SCSI_INIA100=m
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> CONFIG_SCSI_STEX=y
> CONFIG_SCSI_SYM53C8XX_2=m
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> # CONFIG_SCSI_SYM53C8XX_MMIO is not set
> CONFIG_SCSI_QLOGIC_1280=y
> CONFIG_SCSI_QLA_FC=m
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_DC395x=m
> CONFIG_SCSI_DC390T=y
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> CONFIG_SCSI_PM8001=y
> CONFIG_SCSI_SRP=y
> # CONFIG_SCSI_BFA_FC is not set
> CONFIG_SCSI_VIRTIO=y
> CONFIG_SCSI_CHELSIO_FCOE=m
> # CONFIG_SCSI_DH is not set
> CONFIG_SCSI_OSD_INITIATOR=m
> CONFIG_SCSI_OSD_ULD=m
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> # CONFIG_ATA is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> # CONFIG_MD_LINEAR is not set
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> # CONFIG_MD_MULTIPATH is not set
> CONFIG_MD_FAULTY=m
> CONFIG_BCACHE=m
> # CONFIG_BCACHE_DEBUG is not set
> # CONFIG_BCACHE_CLOSURES_DEBUG is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=m
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> # CONFIG_DM_THIN_PROVISIONING is not set
> # CONFIG_DM_CACHE is not set
> # CONFIG_DM_ERA is not set
> # CONFIG_DM_MIRROR is not set
> CONFIG_DM_RAID=m
> # CONFIG_DM_ZERO is not set
> # CONFIG_DM_MULTIPATH is not set
> CONFIG_DM_DELAY=m
> # CONFIG_DM_UEVENT is not set
> CONFIG_DM_FLAKEY=m
> CONFIG_DM_VERITY=m
> CONFIG_DM_SWITCH=y
> # CONFIG_TARGET_CORE is not set
> CONFIG_FUSION=y
> # CONFIG_FUSION_SPI is not set
> CONFIG_FUSION_FC=m
> # CONFIG_FUSION_SAS is not set
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=m
> # CONFIG_FUSION_LOGGING is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> # CONFIG_FIREWIRE_OHCI is not set
> CONFIG_FIREWIRE_SBP2=y
> CONFIG_FIREWIRE_NET=m
> CONFIG_FIREWIRE_NOSY=m
> CONFIG_I2O=m
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> # CONFIG_I2O_EXT_ADAPTEC is not set
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> # CONFIG_I2O_BUS is not set
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_MAC_EMUMOUSEBTN is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> # CONFIG_NET_CORE is not set
> CONFIG_ARCNET=y
> # CONFIG_ARCNET_1201 is not set
> CONFIG_ARCNET_1051=y
> # CONFIG_ARCNET_RAW is not set
> # CONFIG_ARCNET_CAP is not set
> CONFIG_ARCNET_COM90xx=y
> CONFIG_ARCNET_COM90xxIO=m
> # CONFIG_ARCNET_RIM_I is not set
> CONFIG_ARCNET_COM20020=y
> CONFIG_ARCNET_COM20020_PCI=m
> 
> #
> # CAIF transport drivers
> #
> CONFIG_CAIF_TTY=m
> # CONFIG_CAIF_SPI_SLAVE is not set
> # CONFIG_CAIF_HSI is not set
> CONFIG_CAIF_VIRTIO=m
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=y
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=m
> CONFIG_NET_DSA_MV88E6060=y
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=m
> CONFIG_NET_DSA_MV88E6123_61_65=m
> CONFIG_ETHERNET=y
> CONFIG_MDIO=y
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_NET_VENDOR_ALTEON=y
> CONFIG_ACENIC=y
> CONFIG_ACENIC_OMIT_TIGON_I=y
> CONFIG_ALTERA_TSE=y
> # CONFIG_NET_VENDOR_AMD is not set
> CONFIG_NET_VENDOR_ARC=y
> # CONFIG_NET_VENDOR_ATHEROS is not set
> # CONFIG_NET_CADENCE is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=m
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_BNX2=y
> CONFIG_CNIC=y
> CONFIG_TIGON3=m
> CONFIG_BNX2X=y
> # CONFIG_BNX2X_SRIOV is not set
> # CONFIG_NET_VENDOR_BROCADE is not set
> # CONFIG_NET_CALXEDA_XGMAC is not set
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> CONFIG_CHELSIO_T3=m
> CONFIG_CHELSIO_T4=y
> CONFIG_CHELSIO_T4VF=m
> CONFIG_NET_VENDOR_CISCO=y
> # CONFIG_ENIC is not set
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_NET_TULIP is not set
> # CONFIG_NET_VENDOR_DLINK is not set
> # CONFIG_NET_VENDOR_EMULEX is not set
> CONFIG_NET_VENDOR_EXAR=y
> CONFIG_S2IO=y
> CONFIG_VXGE=y
> # CONFIG_VXGE_DEBUG_TRACE_ALL is not set
> CONFIG_NET_VENDOR_HP=y
> CONFIG_HP100=y
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_IP1000 is not set
> CONFIG_JME=m
> CONFIG_NET_VENDOR_MARVELL=y
> CONFIG_MVMDIO=m
> CONFIG_SKGE=y
> # CONFIG_SKGE_DEBUG is not set
> # CONFIG_SKGE_GENESIS is not set
> CONFIG_SKY2=m
> # CONFIG_SKY2_DEBUG is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> CONFIG_MLX4_CORE=m
> CONFIG_MLX4_DEBUG=y
> CONFIG_MLX5_CORE=m
> # CONFIG_NET_VENDOR_MICREL is not set
> CONFIG_NET_VENDOR_MYRI=y
> CONFIG_MYRI10GE=m
> CONFIG_MYRI10GE_DCA=y
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> # CONFIG_NET_VENDOR_OKI is not set
> CONFIG_ETHOC=m
> CONFIG_NET_PACKET_ENGINE=y
> CONFIG_HAMACHI=m
> CONFIG_YELLOWFIN=m
> # CONFIG_NET_VENDOR_QLOGIC is not set
> # CONFIG_NET_VENDOR_REALTEK is not set
> CONFIG_SH_ETH=y
> # CONFIG_NET_VENDOR_RDC is not set
> # CONFIG_NET_VENDOR_SAMSUNG is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SILAN is not set
> # CONFIG_NET_VENDOR_SIS is not set
> CONFIG_SFC=m
> # CONFIG_SFC_MCDI_MON is not set
> # CONFIG_SFC_SRIOV is not set
> CONFIG_NET_VENDOR_SMSC=y
> CONFIG_EPIC100=m
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> CONFIG_SMSC9420=y
> CONFIG_NET_VENDOR_STMICRO=y
> CONFIG_STMMAC_ETH=m
> # CONFIG_STMMAC_PLATFORM is not set
> CONFIG_STMMAC_PCI=y
> CONFIG_STMMAC_DEBUG_FS=y
> CONFIG_STMMAC_DA=y
> CONFIG_NET_VENDOR_SUN=y
> CONFIG_HAPPYMEAL=y
> # CONFIG_SUNGEM is not set
> CONFIG_CASSINI=y
> CONFIG_NIU=y
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> CONFIG_NET_VENDOR_WIZNET=y
> CONFIG_WIZNET_W5100=y
> # CONFIG_WIZNET_W5300 is not set
> # CONFIG_WIZNET_BUS_DIRECT is not set
> CONFIG_WIZNET_BUS_INDIRECT=y
> # CONFIG_WIZNET_BUS_ANY is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=m
> # CONFIG_AMD_PHY is not set
> # CONFIG_MARVELL_PHY is not set
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=m
> CONFIG_LXT_PHY=m
> CONFIG_CICADA_PHY=y
> CONFIG_VITESSE_PHY=y
> CONFIG_SMSC_PHY=y
> # CONFIG_BROADCOM_PHY is not set
> CONFIG_BCM7XXX_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> # CONFIG_STE10XP is not set
> CONFIG_LSI_ET1011C_PHY=m
> CONFIG_MICREL_PHY=y
> # CONFIG_FIXED_PHY is not set
> CONFIG_MDIO_BITBANG=y
> CONFIG_MDIO_GPIO=m
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> CONFIG_SLIP=m
> CONFIG_SLHC=m
> CONFIG_SLIP_COMPRESSED=y
> # CONFIG_SLIP_SMART is not set
> CONFIG_SLIP_MODE_SLIP6=y
> CONFIG_WLAN=y
> CONFIG_LIBERTAS_THINFIRM=m
> CONFIG_LIBERTAS_THINFIRM_DEBUG=y
> CONFIG_AIRO=y
> CONFIG_ATMEL=m
> CONFIG_PCI_ATMEL=m
> CONFIG_PRISM54=y
> CONFIG_RTL8180=m
> CONFIG_ADM8211=m
> # CONFIG_MAC80211_HWSIM is not set
> CONFIG_MWL8K=m
> CONFIG_ATH_COMMON=m
> CONFIG_ATH_CARDS=m
> CONFIG_ATH_DEBUG=y
> CONFIG_ATH5K=m
> # CONFIG_ATH5K_DEBUG is not set
> CONFIG_ATH5K_PCI=y
> CONFIG_ATH9K_HW=m
> CONFIG_ATH9K_COMMON=m
> CONFIG_ATH9K_BTCOEX_SUPPORT=y
> CONFIG_ATH9K=m
> CONFIG_ATH9K_PCI=y
> CONFIG_ATH9K_AHB=y
> # CONFIG_ATH9K_DEBUGFS is not set
> # CONFIG_ATH9K_WOW is not set
> CONFIG_ATH6KL=m
> # CONFIG_ATH6KL_SDIO is not set
> # CONFIG_ATH6KL_DEBUG is not set
> # CONFIG_WIL6210 is not set
> CONFIG_ATH10K=m
> # CONFIG_ATH10K_PCI is not set
> # CONFIG_ATH10K_DEBUG is not set
> CONFIG_ATH10K_DEBUGFS=y
> CONFIG_WCN36XX=m
> # CONFIG_WCN36XX_DEBUGFS is not set
> # CONFIG_B43 is not set
> CONFIG_B43LEGACY=m
> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
> CONFIG_B43LEGACY_LEDS=y
> CONFIG_B43LEGACY_HWRNG=y
> CONFIG_B43LEGACY_DEBUG=y
> CONFIG_B43LEGACY_PIO=y
> # CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
> # CONFIG_B43LEGACY_DMA_MODE is not set
> CONFIG_B43LEGACY_PIO_MODE=y
> CONFIG_BRCMUTIL=m
> CONFIG_BRCMSMAC=m
> CONFIG_BRCMFMAC=m
> CONFIG_BRCMFMAC_SDIO=y
> # CONFIG_BRCM_TRACING is not set
> # CONFIG_BRCMDBG is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IWLWIFI is not set
> CONFIG_IWLEGACY=m
> CONFIG_IWL4965=m
> # CONFIG_IWL3945 is not set
> 
> #
> # iwl3945 / iwl4965 Debugging Options
> #
> CONFIG_IWLEGACY_DEBUG=y
> CONFIG_LIBERTAS=m
> CONFIG_LIBERTAS_SDIO=m
> # CONFIG_LIBERTAS_DEBUG is not set
> CONFIG_LIBERTAS_MESH=y
> CONFIG_P54_COMMON=m
> CONFIG_P54_PCI=m
> CONFIG_P54_LEDS=y
> CONFIG_RT2X00=m
> # CONFIG_RT2400PCI is not set
> # CONFIG_RT2500PCI is not set
> # CONFIG_RT61PCI is not set
> CONFIG_RT2800PCI=m
> CONFIG_RT2800PCI_RT33XX=y
> CONFIG_RT2800PCI_RT35XX=y
> CONFIG_RT2800PCI_RT53XX=y
> # CONFIG_RT2800PCI_RT3290 is not set
> CONFIG_RT2800_LIB=m
> CONFIG_RT2800_LIB_MMIO=m
> CONFIG_RT2X00_LIB_MMIO=m
> CONFIG_RT2X00_LIB_PCI=m
> CONFIG_RT2X00_LIB=m
> CONFIG_RT2X00_LIB_FIRMWARE=y
> CONFIG_RT2X00_LIB_CRYPTO=y
> CONFIG_RT2X00_LIB_LEDS=y
> CONFIG_RT2X00_DEBUG=y
> CONFIG_RTL_CARDS=m
> CONFIG_RTL8192CE=m
> # CONFIG_RTL8192SE is not set
> CONFIG_RTL8192DE=m
> # CONFIG_RTL8723AE is not set
> CONFIG_RTL8723BE=m
> CONFIG_RTL8188EE=m
> CONFIG_RTLWIFI=m
> CONFIG_RTLWIFI_PCI=m
> CONFIG_RTLWIFI_DEBUG=y
> CONFIG_RTL8192C_COMMON=m
> CONFIG_RTL8723_COMMON=m
> CONFIG_RTLBTCOEXIST=m
> CONFIG_WL_TI=y
> CONFIG_WL1251=m
> CONFIG_WL1251_SDIO=m
> CONFIG_WL12XX=m
> # CONFIG_WL18XX is not set
> CONFIG_WLCORE=m
> CONFIG_WLCORE_SDIO=m
> # CONFIG_WILINK_PLATFORM_DATA is not set
> # CONFIG_MWIFIEX is not set
> CONFIG_CW1200=m
> CONFIG_CW1200_WLAN_SDIO=m
> # CONFIG_RSI_91X is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> CONFIG_WAN=y
> CONFIG_LANMEDIA=m
> CONFIG_HDLC=m
> # CONFIG_HDLC_RAW is not set
> CONFIG_HDLC_RAW_ETH=m
> CONFIG_HDLC_CISCO=m
> CONFIG_HDLC_FR=m
> CONFIG_HDLC_PPP=m
> CONFIG_HDLC_X25=m
> # CONFIG_PCI200SYN is not set
> # CONFIG_WANXL is not set
> CONFIG_PC300TOO=m
> CONFIG_FARSYNC=m
> CONFIG_DSCC4=m
> CONFIG_DSCC4_PCISYNC=y
> # CONFIG_DSCC4_PCI_RST is not set
> CONFIG_DLCI=m
> CONFIG_DLCI_MAX=8
> CONFIG_SBNI=m
> CONFIG_SBNI_MULTILINE=y
> CONFIG_IEEE802154_DRIVERS=y
> # CONFIG_IEEE802154_FAKEHARD is not set
> # CONFIG_VMXNET3 is not set
> CONFIG_ISDN=y
> CONFIG_ISDN_I4L=m
> # CONFIG_ISDN_PPP is not set
> # CONFIG_ISDN_AUDIO is not set
> 
> #
> # ISDN feature submodules
> #
> CONFIG_ISDN_DIVERSION=m
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=m
> 
> #
> # D-channel protocol features
> #
> CONFIG_HISAX_EURO=y
> CONFIG_DE_AOC=y
> CONFIG_HISAX_NO_SENDCOMPLETE=y
> CONFIG_HISAX_NO_LLC=y
> CONFIG_HISAX_NO_KEYPAD=y
> CONFIG_HISAX_1TR6=y
> CONFIG_HISAX_NI1=y
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> CONFIG_HISAX_16_3=y
> # CONFIG_HISAX_TELESPCI is not set
> CONFIG_HISAX_S0BOX=y
> # CONFIG_HISAX_FRITZPCI is not set
> # CONFIG_HISAX_AVM_A1_PCMCIA is not set
> CONFIG_HISAX_ELSA=y
> # CONFIG_HISAX_DIEHLDIVA is not set
> # CONFIG_HISAX_SEDLBAUER is not set
> # CONFIG_HISAX_NETJET is not set
> # CONFIG_HISAX_NETJET_U is not set
> # CONFIG_HISAX_NICCY is not set
> # CONFIG_HISAX_BKM_A4T is not set
> # CONFIG_HISAX_SCT_QUADRO is not set
> CONFIG_HISAX_GAZEL=y
> CONFIG_HISAX_HFC_PCI=y
> CONFIG_HISAX_W6692=y
> # CONFIG_HISAX_HFC_SX is not set
> CONFIG_HISAX_DEBUG=y
> 
> #
> # HiSax PCMCIA card service modules
> #
> 
> #
> # HiSax sub driver modules
> #
> CONFIG_HISAX_HFC4S8S=m
> CONFIG_HISAX_FRITZ_PCIPNP=m
> 
> #
> # Active cards
> #
> CONFIG_ISDN_CAPI=y
> CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
> CONFIG_CAPI_TRACE=y
> CONFIG_ISDN_CAPI_CAPI20=y
> # CONFIG_ISDN_CAPI_MIDDLEWARE is not set
> CONFIG_ISDN_CAPI_CAPIDRV=m
> 
> #
> # CAPI hardware drivers
> #
> # CONFIG_CAPI_AVM is not set
> # CONFIG_CAPI_EICON is not set
> CONFIG_ISDN_DRV_GIGASET=m
> CONFIG_GIGASET_CAPI=y
> # CONFIG_GIGASET_I4L is not set
> # CONFIG_GIGASET_DUMMYLL is not set
> CONFIG_GIGASET_M101=m
> CONFIG_GIGASET_DEBUG=y
> CONFIG_HYSDN=m
> # CONFIG_HYSDN_CAPI is not set
> CONFIG_MISDN=m
> # CONFIG_MISDN_DSP is not set
> CONFIG_MISDN_L1OIP=m
> 
> #
> # mISDN hardware drivers
> #
> # CONFIG_MISDN_HFCPCI is not set
> CONFIG_MISDN_HFCMULTI=m
> CONFIG_MISDN_AVMFRITZ=m
> CONFIG_MISDN_SPEEDFAX=m
> CONFIG_MISDN_INFINEON=m
> CONFIG_MISDN_W6692=m
> CONFIG_MISDN_NETJET=m
> CONFIG_MISDN_IPAC=m
> CONFIG_MISDN_ISAR=m
> CONFIG_ISDN_HDLC=m
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> # CONFIG_INPUT_SPARSEKMAP is not set
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=m
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=m
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
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> # CONFIG_MOUSE_PS2 is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_CYAPA is not set
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> CONFIG_MOUSE_SYNAPTICS_I2C=m
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=y
> # CONFIG_JOYSTICK_A3D is not set
> CONFIG_JOYSTICK_ADI=y
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=y
> CONFIG_JOYSTICK_GRIP=y
> # CONFIG_JOYSTICK_GRIP_MP is not set
> # CONFIG_JOYSTICK_GUILLEMOT is not set
> # CONFIG_JOYSTICK_INTERACT is not set
> CONFIG_JOYSTICK_SIDEWINDER=m
> CONFIG_JOYSTICK_TMDC=y
> CONFIG_JOYSTICK_IFORCE=m
> # CONFIG_JOYSTICK_IFORCE_232 is not set
> CONFIG_JOYSTICK_WARRIOR=m
> CONFIG_JOYSTICK_MAGELLAN=m
> CONFIG_JOYSTICK_SPACEORB=y
> CONFIG_JOYSTICK_SPACEBALL=y
> CONFIG_JOYSTICK_STINGER=m
> CONFIG_JOYSTICK_TWIDJOY=m
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=m
> # CONFIG_JOYSTICK_GAMECON is not set
> CONFIG_JOYSTICK_TURBOGRAFX=m
> CONFIG_JOYSTICK_AS5011=m
> CONFIG_JOYSTICK_JOYDUMP=m
> # CONFIG_JOYSTICK_XPAD is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> CONFIG_INPUT_BMA150=m
> CONFIG_INPUT_PCSPKR=y
> CONFIG_INPUT_MMA8450=m
> CONFIG_INPUT_MPU3050=m
> # CONFIG_INPUT_APANEL is not set
> CONFIG_INPUT_GP2A=m
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=m
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF50633_PMU=m
> CONFIG_INPUT_PCF8574=m
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=m
> CONFIG_INPUT_CMA3000=y
> # CONFIG_INPUT_CMA3000_I2C is not set
> # CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PARKBD=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_SERIO_ALTERA_PS2=y
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_SERIO_ARC_PS2 is not set
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=y
> CONFIG_GAMEPORT_FM801=y
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_SERIAL_NONSTANDARD=y
> # CONFIG_ROCKETPORT is not set
> CONFIG_CYCLADES=m
> CONFIG_CYZ_INTR=y
> # CONFIG_MOXA_INTELLIO is not set
> # CONFIG_MOXA_SMARTIO is not set
> # CONFIG_SYNCLINK is not set
> CONFIG_SYNCLINKMP=y
> CONFIG_SYNCLINK_GT=y
> # CONFIG_NOZOMI is not set
> # CONFIG_ISI is not set
> CONFIG_N_HDLC=m
> CONFIG_N_GSM=m
> CONFIG_TRACE_ROUTER=m
> CONFIG_TRACE_SINK=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> CONFIG_SERIAL_ALTERA_JTAGUART=m
> CONFIG_SERIAL_ALTERA_UART=m
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_PCH_UART=y
> CONFIG_SERIAL_PCH_UART_CONSOLE=y
> CONFIG_SERIAL_ARC=m
> CONFIG_SERIAL_ARC_NR_PORTS=1
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_SERIAL_FSL_LPUART=y
> CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
> CONFIG_PRINTER=m
> CONFIG_LP_CONSOLE=y
> # CONFIG_PPDEV is not set
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=m
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=m
> CONFIG_HW_RANDOM_AMD=y
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_HW_RANDOM_VIRTIO=m
> CONFIG_HW_RANDOM_TPM=y
> # CONFIG_NVRAM is not set
> CONFIG_R3964=y
> CONFIG_APPLICOM=y
> # CONFIG_MWAVE is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=m
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=m
> # CONFIG_TCG_TIS_I2C_ATMEL is not set
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_TIS_I2C_NUVOTON=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> # CONFIG_TCG_INFINEON is not set
> # CONFIG_TCG_ST33_I2C is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=m
> CONFIG_I2C_ALGOBIT=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=m
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD756_S4882=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> # CONFIG_I2C_ISCH is not set
> CONFIG_I2C_ISMT=m
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=m
> # CONFIG_I2C_NFORCE2_S4985 is not set
> CONFIG_I2C_SIS5595=m
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=m
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_EG20T=m
> # CONFIG_I2C_GPIO is not set
> CONFIG_I2C_KEMPLD=m
> CONFIG_I2C_OCORES=m
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=m
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=m
> # CONFIG_I2C_PARPORT_LIGHT is not set
> CONFIG_I2C_TAOS_EVM=m
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_STUB=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> CONFIG_SPMI=y
> CONFIG_HSI=m
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=m
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
> CONFIG_PPS_CLIENT_LDISC=m
> CONFIG_PPS_CLIENT_PARPORT=m
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> CONFIG_DP83640_PHY=y
> CONFIG_PTP_1588_CLOCK_PCH=m
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> CONFIG_GPIO_IT8761E=y
> CONFIG_GPIO_F7188X=y
> CONFIG_GPIO_SCH311X=m
> # CONFIG_GPIO_SCH is not set
> CONFIG_GPIO_ICH=m
> CONFIG_GPIO_VX855=m
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=m
> # CONFIG_GPIO_LP3943 is not set
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=m
> CONFIG_GPIO_PCA953X=m
> CONFIG_GPIO_PCF857X=m
> CONFIG_GPIO_ADP5588=m
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=m
> CONFIG_GPIO_BT8XX=m
> CONFIG_GPIO_AMD8111=m
> # CONFIG_GPIO_INTEL_MID is not set
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=m
> CONFIG_GPIO_RDC321X=m
> 
> #
> # SPI GPIO expanders:
> #
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=m
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=m
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_PCF50633 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_BQ24190 is not set
> # CONFIG_CHARGER_BQ24735 is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=m
> CONFIG_SENSORS_ABITUGURU3=m
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7410=m
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> CONFIG_SENSORS_ADT7470=m
> CONFIG_SENSORS_ADT7475=m
> CONFIG_SENSORS_ASC7621=m
> # CONFIG_SENSORS_K8TEMP is not set
> CONFIG_SENSORS_K10TEMP=m
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_APPLESMC=m
> CONFIG_SENSORS_ASB100=m
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=m
> # CONFIG_SENSORS_DS1621 is not set
> CONFIG_SENSORS_I5K_AMB=m
> # CONFIG_SENSORS_F71805F is not set
> CONFIG_SENSORS_F71882FG=m
> # CONFIG_SENSORS_F75375S is not set
> CONFIG_SENSORS_FSCHMD=m
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> CONFIG_SENSORS_G760A=m
> CONFIG_SENSORS_G762=m
> # CONFIG_SENSORS_GPIO_FAN is not set
> CONFIG_SENSORS_HIH6130=m
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_IT87=m
> CONFIG_SENSORS_JC42=m
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=m
> CONFIG_SENSORS_LTC4151=m
> # CONFIG_SENSORS_LTC4215 is not set
> CONFIG_SENSORS_LTC4222=m
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4260=m
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> CONFIG_SENSORS_MAX6650=m
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_HTU21=m
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> # CONFIG_SENSORS_LM83 is not set
> CONFIG_SENSORS_LM85=m
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LM95234=m
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_NTC_THERMISTOR=m
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=m
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SIS5595=m
> CONFIG_SENSORS_DME1737=m
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=m
> # CONFIG_SENSORS_EMC6W201 is not set
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_SMM665=m
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=m
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_INA209=m
> CONFIG_SENSORS_INA2XX=m
> CONFIG_SENSORS_THMC50=m
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=m
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> CONFIG_SENSORS_VIA686A=m
> # CONFIG_SENSORS_VT1211 is not set
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> # CONFIG_SENSORS_W83791D is not set
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83795=m
> CONFIG_SENSORS_W83795_FANCTRL=y
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=m
> # CONFIG_SENSORS_W83627EHF is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> CONFIG_INTEL_POWERCLAMP=m
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
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> # CONFIG_SSB_SDIOHOST is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=m
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> # CONFIG_BCMA_HOST_PCI is not set
> # CONFIG_BCMA_HOST_SOC is not set
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> CONFIG_MFD_BCM590XX=m
> CONFIG_MFD_CROS_EC=m
> # CONFIG_MFD_CROS_EC_I2C is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> CONFIG_HTC_PASIC3=m
> CONFIG_LPC_ICH=m
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=m
> CONFIG_MFD_KEMPLD=m
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=m
> CONFIG_PCF50633_ADC=m
> CONFIG_PCF50633_GPIO=m
> CONFIG_MFD_RDC321X=m
> CONFIG_MFD_RTSX_PCI=y
> CONFIG_MFD_SI476X_CORE=m
> CONFIG_MFD_SM501=y
> # CONFIG_MFD_SM501_GPIO is not set
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_MFD_LP3943=m
> CONFIG_TPS6105X=m
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> CONFIG_MFD_TPS65217=m
> # CONFIG_MFD_TPS65218 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_WL1273_CORE=m
> CONFIG_MFD_LM3533=m
> # CONFIG_MFD_TIMBERDALE is not set
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=m
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=m
> CONFIG_MFD_WM5102=y
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
> CONFIG_REGULATOR_USERSPACE_CONSUMER=m
> # CONFIG_REGULATOR_ACT8865 is not set
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_BCM590XX=m
> CONFIG_REGULATOR_DA9210=m
> CONFIG_REGULATOR_FAN53555=m
> CONFIG_REGULATOR_GPIO=m
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_LP3971=m
> CONFIG_REGULATOR_LP3972=m
> CONFIG_REGULATOR_LP872X=m
> # CONFIG_REGULATOR_LP8755 is not set
> CONFIG_REGULATOR_MAX1586=m
> CONFIG_REGULATOR_MAX8649=m
> CONFIG_REGULATOR_MAX8660=m
> CONFIG_REGULATOR_MAX8952=m
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_PCF50633=m
> CONFIG_REGULATOR_PFUZE100=m
> CONFIG_REGULATOR_TPS51632=m
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=m
> CONFIG_REGULATOR_TPS65023=m
> # CONFIG_REGULATOR_TPS6507X is not set
> # CONFIG_REGULATOR_TPS65217 is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> CONFIG_VGASTATE=m
> CONFIG_FB=m
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> CONFIG_FB_FOREIGN_ENDIAN=y
> CONFIG_FB_BOTH_ENDIAN=y
> # CONFIG_FB_BIG_ENDIAN is not set
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=m
> CONFIG_FB_SVGALIB=m
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=m
> # CONFIG_FB_PM2 is not set
> CONFIG_FB_CYBER2000=m
> CONFIG_FB_CYBER2000_DDC=y
> CONFIG_FB_ARC=m
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_N411=m
> CONFIG_FB_HGA=m
> CONFIG_FB_OPENCORES=m
> CONFIG_FB_S1D13XXX=m
> CONFIG_FB_NVIDIA=m
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_I740=m
> CONFIG_FB_LE80578=m
> CONFIG_FB_CARILLO_RANCH=m
> CONFIG_FB_MATROX=m
> CONFIG_FB_MATROX_MILLENIUM=y
> # CONFIG_FB_MATROX_MYSTIQUE is not set
> # CONFIG_FB_MATROX_G is not set
> CONFIG_FB_MATROX_I2C=m
> CONFIG_FB_RADEON=m
> CONFIG_FB_RADEON_I2C=y
> CONFIG_FB_RADEON_BACKLIGHT=y
> CONFIG_FB_RADEON_DEBUG=y
> CONFIG_FB_ATY128=m
> # CONFIG_FB_ATY128_BACKLIGHT is not set
> CONFIG_FB_ATY=m
> CONFIG_FB_ATY_CT=y
> # CONFIG_FB_ATY_GENERIC_LCD is not set
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> CONFIG_FB_S3=m
> CONFIG_FB_S3_DDC=y
> # CONFIG_FB_SAVAGE is not set
> CONFIG_FB_SIS=m
> # CONFIG_FB_SIS_300 is not set
> # CONFIG_FB_SIS_315 is not set
> # CONFIG_FB_VIA is not set
> CONFIG_FB_NEOMAGIC=m
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> CONFIG_FB_VOODOO1=m
> CONFIG_FB_VT8623=m
> # CONFIG_FB_TRIDENT is not set
> CONFIG_FB_ARK=m
> CONFIG_FB_PM3=m
> CONFIG_FB_CARMINE=m
> CONFIG_FB_CARMINE_DRAM_EVAL=y
> # CONFIG_CARMINE_DRAM_CUSTOM is not set
> CONFIG_FB_TMIO=m
> # CONFIG_FB_TMIO_ACCELL is not set
> # CONFIG_FB_SM501 is not set
> CONFIG_FB_GOLDFISH=m
> CONFIG_FB_VIRTUAL=m
> CONFIG_FB_METRONOME=m
> CONFIG_FB_MB862XX=m
> CONFIG_FB_MB862XX_PCI_GDC=y
> CONFIG_FB_MB862XX_I2C=y
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_AUO_K190X=m
> CONFIG_FB_AUO_K1900=m
> # CONFIG_FB_AUO_K1901 is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_PLATFORM=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> CONFIG_BACKLIGHT_GENERIC=m
> CONFIG_BACKLIGHT_LM3533=m
> CONFIG_BACKLIGHT_CARILLO_RANCH=m
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=m
> CONFIG_BACKLIGHT_ADP8860=m
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_PCF50633=m
> CONFIG_BACKLIGHT_LM3630A=m
> CONFIG_BACKLIGHT_LM3639=m
> CONFIG_BACKLIGHT_LP855X=m
> CONFIG_BACKLIGHT_OT200=m
> CONFIG_BACKLIGHT_TPS65217=m
> # CONFIG_BACKLIGHT_GPIO is not set
> CONFIG_BACKLIGHT_LV5207LP=m
> CONFIG_BACKLIGHT_BD6107=m
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=m
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_LOGO is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=m
> # CONFIG_HIDRAW is not set
> CONFIG_UHID=m
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=m
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=m
> CONFIG_HID_AUREAL=m
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> CONFIG_HID_CYPRESS=m
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=m
> CONFIG_HID_ELECOM=m
> CONFIG_HID_EZKEY=m
> CONFIG_HID_KEYTOUCH=m
> CONFIG_HID_KYE=m
> # CONFIG_HID_UCLOGIC is not set
> CONFIG_HID_WALTOP=m
> CONFIG_HID_GYRATION=m
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> CONFIG_HID_LCPOWER=m
> CONFIG_HID_LENOVO_TPKBD=m
> CONFIG_HID_LOGITECH=m
> # CONFIG_LOGITECH_FF is not set
> CONFIG_LOGIRUMBLEPAD2_FF=y
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> CONFIG_HID_MAGICMOUSE=m
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> CONFIG_HID_MULTITOUCH=m
> CONFIG_HID_ORTEK=m
> CONFIG_HID_PANTHERLORD=m
> # CONFIG_PANTHERLORD_FF is not set
> # CONFIG_HID_PETALYNX is not set
> CONFIG_HID_PICOLCD=m
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LCD=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PRIMAX=m
> # CONFIG_HID_SAITEK is not set
> CONFIG_HID_SAMSUNG=m
> CONFIG_HID_SPEEDLINK=m
> CONFIG_HID_STEELSERIES=m
> CONFIG_HID_SUNPLUS=m
> CONFIG_HID_GREENASIA=m
> # CONFIG_GREENASIA_FF is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=m
> CONFIG_HID_THINGM=m
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_XINMO is not set
> CONFIG_HID_ZEROPLUS=m
> # CONFIG_ZEROPLUS_FF is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=m
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
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_CLKGATE=y
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=m
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_SDHCI_PCI=m
> CONFIG_MMC_RICOH_MMC=y
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=m
> # CONFIG_MMC_WBSD is not set
> CONFIG_MMC_TIFM_SD=m
> CONFIG_MMC_CB710=m
> CONFIG_MMC_VIA_SDMMC=m
> # CONFIG_MMC_REALTEK_PCI is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> CONFIG_MSPRO_BLOCK=y
> CONFIG_MS_BLOCK=m
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=m
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> CONFIG_MEMSTICK_R592=y
> CONFIG_MEMSTICK_REALTEK_PCI=m
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=m
> CONFIG_LEDS_LM3533=m
> CONFIG_LEDS_LM3642=m
> CONFIG_LEDS_PCA9532=m
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=m
> CONFIG_LEDS_LP55XX_COMMON=m
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=m
> CONFIG_LEDS_LP5562=m
> CONFIG_LEDS_LP8501=m
> # CONFIG_LEDS_CLEVO_MAIL is not set
> CONFIG_LEDS_PCA955X=m
> CONFIG_LEDS_PCA963X=m
> CONFIG_LEDS_PCA9685=m
> # CONFIG_LEDS_REGULATOR is not set
> CONFIG_LEDS_BD2802=m
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_LT3593=m
> CONFIG_LEDS_TCA6507=m
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_BLINKM=m
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_LEDS_TRIGGER_TRANSIENT is not set
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> CONFIG_INFINIBAND=m
> # CONFIG_INFINIBAND_USER_MAD is not set
> CONFIG_INFINIBAND_USER_ACCESS=m
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_INFINIBAND_MTHCA=m
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> CONFIG_INFINIBAND_QIB=m
> # CONFIG_INFINIBAND_QIB_DCA is not set
> # CONFIG_INFINIBAND_AMSO1100 is not set
> # CONFIG_INFINIBAND_CXGB3 is not set
> # CONFIG_INFINIBAND_CXGB4 is not set
> CONFIG_MLX4_INFINIBAND=m
> CONFIG_MLX5_INFINIBAND=m
> CONFIG_INFINIBAND_NES=m
> # CONFIG_INFINIBAND_NES_DEBUG is not set
> # CONFIG_INFINIBAND_OCRDMA is not set
> CONFIG_INFINIBAND_IPOIB=m
> # CONFIG_INFINIBAND_IPOIB_CM is not set
> CONFIG_INFINIBAND_IPOIB_DEBUG=y
> CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
> # CONFIG_INFINIBAND_SRP is not set
> CONFIG_INFINIBAND_ISER=m
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> CONFIG_EDAC_DEBUG=y
> CONFIG_EDAC_DECODE_MCE=m
> CONFIG_EDAC_MCE_INJ=m
> CONFIG_EDAC_MM_EDAC=y
> # CONFIG_EDAC_AMD64 is not set
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82975X is not set
> CONFIG_EDAC_I3000=m
> # CONFIG_EDAC_I3200 is not set
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> CONFIG_EDAC_I5000=y
> CONFIG_EDAC_I5100=y
> CONFIG_EDAC_I7300=m
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> CONFIG_INTEL_IOATDMA=y
> CONFIG_DW_DMAC_CORE=y
> CONFIG_DW_DMAC=y
> # CONFIG_DW_DMAC_PCI is not set
> CONFIG_TIMB_DMA=y
> CONFIG_PCH_DMA=y
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> CONFIG_DMA_ENGINE_RAID=y
> CONFIG_DCA=y
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> # CONFIG_UIO_PDRV_GENIRQ is not set
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> # CONFIG_UIO_SERCOS3 is not set
> CONFIG_UIO_PCI_GENERIC=m
> CONFIG_UIO_NETX=y
> CONFIG_UIO_MF624=y
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=m
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=m
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_SENSORS_HDAPS=m
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ACPI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> CONFIG_CHROME_PLATFORMS=y
> CONFIG_CHROMEOS_LAPTOP=m
> # CONFIG_CHROMEOS_PSTORE is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
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
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> CONFIG_MEMORY=y
> # CONFIG_IIO is not set
> CONFIG_NTB=m
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> CONFIG_VME_CA91CX42=m
> CONFIG_VME_TSI148=y
> 
> #
> # VME Board Drivers
> #
> CONFIG_VMIVME_7805=m
> 
> #
> # VME Device Drivers
> #
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_OMAP_CONTROL_PHY=m
> CONFIG_BCM_KONA_USB2_PHY=y
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=m
> CONFIG_MCB=m
> # CONFIG_MCB_PCI is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_DMI_SYSFS is not set
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> CONFIG_GOOGLE_MEMCONSOLE=y
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4_FS=m
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_EXT4_DEBUG=y
> CONFIG_FS_XIP=y
> CONFIG_JBD=m
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=m
> CONFIG_JBD2_DEBUG=y
> CONFIG_FS_MBCACHE=m
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=m
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> CONFIG_JFS_STATISTICS=y
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> CONFIG_BTRFS_DEBUG=y
> # CONFIG_BTRFS_ASSERT is not set
> CONFIG_NILFS2_FS=m
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> # CONFIG_PRINT_QUOTA_WARNING is not set
> CONFIG_QUOTA_DEBUG=y
> # CONFIG_QFMT_V1 is not set
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=m
> CONFIG_CUSE=m
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=m
> CONFIG_CACHEFILES_DEBUG=y
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> # CONFIG_JOLIET is not set
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> # CONFIG_VFAT_FS is not set
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=m
> # CONFIG_ADFS_FS_RW is not set
> # CONFIG_AFFS_FS is not set
> CONFIG_ECRYPT_FS=m
> CONFIG_ECRYPT_FS_MESSAGING=y
> CONFIG_HFS_FS=m
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_BEFS_FS=m
> # CONFIG_BEFS_DEBUG is not set
> CONFIG_BFS_FS=m
> CONFIG_EFS_FS=y
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> CONFIG_SQUASHFS=y
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> CONFIG_SQUASHFS_DECOMP_SINGLE=y
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
> # CONFIG_SQUASHFS_XATTR is not set
> # CONFIG_SQUASHFS_ZLIB is not set
> CONFIG_SQUASHFS_LZO=y
> # CONFIG_SQUASHFS_XZ is not set
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=y
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> CONFIG_QNX4FS_FS=m
> CONFIG_QNX6FS_FS=y
> # CONFIG_QNX6FS_DEBUG is not set
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> CONFIG_ROMFS_ON_BLOCK=y
> CONFIG_PSTORE=y
> CONFIG_PSTORE_CONSOLE=y
> CONFIG_PSTORE_RAM=m
> CONFIG_SYSV_FS=m
> CONFIG_UFS_FS=y
> CONFIG_UFS_FS_WRITE=y
> CONFIG_UFS_DEBUG=y
> CONFIG_EXOFS_FS=m
> # CONFIG_EXOFS_DEBUG is not set
> CONFIG_F2FS_FS=y
> # CONFIG_F2FS_STAT_FS is not set
> # CONFIG_F2FS_FS_XATTR is not set
> # CONFIG_F2FS_CHECK_FS is not set
> CONFIG_ORE=m
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=m
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> # CONFIG_NLS_CODEPAGE_861 is not set
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=m
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_MAC_ROMAN=y
> # CONFIG_NLS_MAC_CELTIC is not set
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=m
> CONFIG_NLS_MAC_GAELIC=m
> CONFIG_NLS_MAC_GREEK=m
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=m
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
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
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
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
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=m
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> CONFIG_ASYNC_RAID6_TEST=m
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_TEST_MODULE=m
> # CONFIG_TEST_USER_COPY is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_DEBUG_SET_MODULE_RONX is not set
> # CONFIG_DEBUG_NX_TEST is not set
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
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> # CONFIG_BIG_KEYS is not set
> CONFIG_TRUSTED_KEYS=m
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_PATH=y
> # CONFIG_SECURITY_SELINUX is not set
> CONFIG_SECURITY_SMACK=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> # CONFIG_SECURITY_APPARMOR_HASH is not set
> CONFIG_SECURITY_YAMA=y
> CONFIG_SECURITY_YAMA_STACKED=y
> CONFIG_INTEGRITY=y
> CONFIG_INTEGRITY_SIGNATURE=y
> # CONFIG_INTEGRITY_AUDIT is not set
> CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
> # CONFIG_IMA is not set
> CONFIG_EVM=y
> CONFIG_EVM_HMAC_VERSION=2
> # CONFIG_DEFAULT_SECURITY_SMACK is not set
> CONFIG_DEFAULT_SECURITY_APPARMOR=y
> # CONFIG_DEFAULT_SECURITY_YAMA is not set
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="apparmor"
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
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
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=m
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=m
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> # CONFIG_CRYPTO_CRC32 is not set
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_CRCT10DIF=y
> # CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> CONFIG_CRYPTO_SHA256_SSSE3=m
> # CONFIG_CRYPTO_SHA512_SSSE3 is not set
> CONFIG_CRYPTO_SHA256=y
> # CONFIG_CRYPTO_SHA512 is not set
> CONFIG_CRYPTO_TGR192=m
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=m
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
> CONFIG_CRYPTO_CAST_COMMON=m
> CONFIG_CRYPTO_CAST5=m
> # CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_CAST6_AVX_X86_64=m
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=m
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
> CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
> CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_ZLIB is not set
> CONFIG_CRYPTO_LZO=m
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HASH_INFO=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_BINARY_PRINTF is not set
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
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> CONFIG_CRC32_BIT=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=m
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> CONFIG_XZ_DEC_POWERPC=y
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=m
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_ENC8=y
> CONFIG_REED_SOLOMON_DEC8=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_LRU_CACHE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=y
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_SIGNATURE=y
> CONFIG_OID_REGISTRY=y
> CONFIG_FONT_SUPPORT=m
> CONFIG_FONTS=y
> # CONFIG_FONT_8x8 is not set
> CONFIG_FONT_8x16=y
> CONFIG_FONT_6x11=y
> CONFIG_FONT_7x14=y
> # CONFIG_FONT_PEARL_8x8 is not set
> CONFIG_FONT_ACORN_8x8=y
> CONFIG_FONT_MINI_4x6=y
> CONFIG_FONT_SUN8x16=y
> # CONFIG_FONT_SUN12x22 is not set
> CONFIG_FONT_10x18=y
> 
> 

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 
> 

