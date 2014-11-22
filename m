Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaKVSoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:44:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:58405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaKVSoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:44:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,438,1413270000"; 
   d="scan'208";a="612413277"
Date: Sat, 22 Nov 2014 10:43:49 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [ftrace/x86/extable] WARNING: CPU: 0 PID: 1 at init/main.c:803
 do_one_initcall()
Message-ID: <20141122184349.GB29361@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git rfc/seq-buf

commit 716c18f8e57c5eff4725f0b5acbdb2fead202d8c
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Tue Nov 18 21:14:11 2014 -0500
Commit:     Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue Nov 18 23:26:23 2014 -0500

    ftrace/x86/extable: Add is_ftrace_trampoline() function
    
    Stack traces that happen from function tracing check if the address
    on the stack is a __kernel_text_address(). That is, is the address
    kernel code. This calls core_kernel_text() which returns true
    if the address is part of the builtin kernel code. It also calls
    is_module_text_address() which returns true if the address belongs
    to module code.
    
    But what is missing is ftrace dynamically allocated trampolines.
    These trampolines are allocated for individual ftrace_ops that
    call the ftrace_ops callback functions directly. But if they do a
    stack trace, the code checking the stack wont detect them as they
    are neither core kernel code nor module address space.
    
    Adding another field to ftrace_ops that also stores the size of
    the trampoline assigned to it we can create a new function called
    is_ftrace_trampoline() that returns true if the address is a
    dynamically allocate ftrace trampoline. Note, it ignores trampolines
    that are not dynamically allocated as they will return true with
    the core_kernel_text() function.
    
    Link: http://lkml.kernel.org/r/20141119034829.497125839@goodmis.org
    
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

+-------------------------------------------------------------------------+------------+------------+------------+
|                                                                         | 766d21c795 | 716c18f8e5 | d165a751a0 |
+-------------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                          | 60         | 0          | 0          |
| boot_failures                                                           | 0          | 20         | 16         |
| WARNING:at_init/main.c:do_one_initcall()                                | 0          | 20         | 16         |
| initcall_init_kprobes_returned_with_preemption_imbalance                | 0          | 20         | 16         |
| BUG:scheduling_while_atomic                                             | 0          | 20         | 11         |
| BUG:workqueue_leaked_lock_or_atomic:kworker                             | 0          | 1          | 2          |
| backtrace:init_kprobes                                                  | 0          | 20         | 16         |
| backtrace:warn_slowpath_fmt                                             | 0          | 20         | 16         |
| backtrace:kernel_init_freeable                                          | 0          | 20         | 16         |
| backtrace:event_trace_self_tests                                        | 0          | 20         | 11         |
| backtrace:event_trace_self_tests_init                                   | 0          | 20         | 11         |
| backtrace:dump_stack                                                    | 0          | 1          | 2          |
| backtrace:test_work                                                     | 0          | 1          | 2          |
| initcall_event_trace_self_tests_init_returned_with_preemption_imbalance | 0          | 18         | 7          |
| backtrace:unregister_ftrace_function                                    | 0          | 18         | 7          |
| BUG:kernel_boot_hang                                                    | 0          | 0          | 2          |
+-------------------------------------------------------------------------+------------+------------+------------+

[    1.649109] Kprobe smoke test: passed successfully
[    1.649888] ------------[ cut here ]------------
[    1.649888] ------------[ cut here ]------------
[    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x1a9/0x200()
[    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x1a9/0x200()
[    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imbalance 
[    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imbalance 
[    1.653357] Modules linked in:
[    1.653357] Modules linked in:

[    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g716c18f #58
[    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g716c18f #58
[    1.655071]  0000000000000009
[    1.655071]  0000000000000009 ffff88001345fdf8 ffff88001345fdf8 ffffffff816356b2 ffffffff816356b2 ffff88001345fe38 ffff88001345fe38

[    1.656312]  ffffffff8108da6a
[    1.656312]  ffffffff8108da6a ffff88001345fe58 ffff88001345fe58 0000000000000000 0000000000000000 0000000000000001 0000000000000001

[    1.657542]  0000000000000001
[    1.657542]  0000000000000001 ffffffff81f09df6 ffffffff81f09df6 0000000000000000 0000000000000000 ffff88001345fe98 ffff88001345fe98

[    1.658800] Call Trace:
[    1.658800] Call Trace:
[    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
[    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
[    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
[    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
[    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
[    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
[    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
[    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
[    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.673365] ---[ end trace 660d24cf53fa6caf ]---
[    1.673365] ---[ end trace 660d24cf53fa6caf ]---

git bisect start d165a751a05de3cd926f1378b0df3de3b7cab051 fc14f9c1272f62c3e8d01300f52467c0d9af50f9 --
git bisect  bad 36e2c5fccd02b60b6e98f08aa61d33f43188fb08  # 16:03      0-     15  Merge 'jlayton/nfsd-3.20' into devel-lkp-ib04-smoke-201411191439
git bisect  bad 847d1c3e2f2d8703f63b73420eb7a46c26f54e9b  # 16:35      0-     17  Merge 'shawnguo/imx/soc' into devel-lkp-ib04-smoke-201411191439
git bisect  bad d4620f93d2a5011fe43d5de0ac8c8fd670b00705  # 17:19      0-     16  Merge 'pm/bleeding-edge' into devel-lkp-ib04-smoke-201411191439
git bisect good d5b06eebb3c327b5ae53d4a80aa4a8061a8ba125  # 17:41     20+      0  0day base guard for 'devel-lkp-ib04-smoke-201411191439'
git bisect  bad 5bc53bc9b7a94d183337b5233472a2480abbc655  # 18:36      0-     16  Merge 'trace/rfc/seq-buf' into devel-lkp-ib04-smoke-201411191439
git bisect  bad c965f1fce4bc52abaaea95113a50c97b183b311e  # 19:39      0-     17  blktrace/tracing: Use trace_seq_has_overflowed() helper function
git bisect good 8520dedbbf7578a397ecdfcf6ab83f775f914cfe  # 20:19     20+      0  tracing: kdb: Fix kernel livelock with empty buffers
git bisect good a9ce7c36aa4256019180c590d60e2fad7431c749  # 20:43     20+      0  tracing: Fix race of function probes counting
git bisect  bad f745f25c1f01464c376b7fe82e34db08ed22f321  # 21:06      0-      2  x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
git bisect  bad 716c18f8e57c5eff4725f0b5acbdb2fead202d8c  # 21:23      0-     20  ftrace/x86/extable: Add is_ftrace_trampoline() function
git bisect good 766d21c7953e3b02699183309d997b1c2cd9e0bb  # 22:32     20+      0  ftrace/x86: Add frames pointers to trampoline as necessary
# first bad commit: [716c18f8e57c5eff4725f0b5acbdb2fead202d8c] ftrace/x86/extable: Add is_ftrace_trampoline() function
git bisect good 766d21c7953e3b02699183309d997b1c2cd9e0bb  # 22:36     60+      0  ftrace/x86: Add frames pointers to trampoline as necessary
git bisect  bad d165a751a05de3cd926f1378b0df3de3b7cab051  # 22:36      0-     16  0day head guard for 'devel-lkp-ib04-smoke-201411191439'
git bisect good fc14f9c1272f62c3e8d01300f52467c0d9af50f9  # 22:39     60+      2  Linux 3.18-rc5
git bisect good fad15b648058ee5ea4b352888afa9030e0092f1b  # 23:18     60+      0  Add linux-next specific files for 20141118


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-client6-12:20141119212303:x86_64-randconfig-ib0-11191438:3.18.0-rc1-00020-g716c18f:58"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc1-00020-g716c18f (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #58 Wed Nov 19 21:08:58 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-11191438/linux-devel:devel-lkp-ib04-smoke-201411191439:716c18f8e57=
c5eff4725f0b5acbdb2fead202d8c:bisect-linux-8/.vmlinuz-716c18f8e57c5eff4725f=
0b5acbdb2fead202d8c-20141119212229-12-client6 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201411191439 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-111914=
38/716c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-00020-g716c1=
8f drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02d8b000, 0x02d8bfff] PGTABLE
[    0.000000] BRK [0x02d8c000, 0x02d8cfff] PGTABLE
[    0.000000] BRK [0x02d8d000, 0x02d8dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02d8e000, 0x02d8efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02d8f000, 0x02d8ffff] PGTABLE
[    0.000000] BRK [0x02d90000, 0x02d90fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13cce000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c39280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-11191438/linux-devel:devel-lkp-ib04-smoke-201411191439:716c=
18f8e57c5eff4725f0b5acbdb2fead202d8c:bisect-linux-8/.vmlinuz-716c18f8e57c5e=
ff4725f0b5acbdb2fead202d8c-20141119212229-12-client6 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201411191439 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-11191438/716c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-00020=
-g716c18f drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 286036K/327160K available (6399K kernel code, 3001K =
rwdata, 3340K rodata, 912K init, 14044K bss, 41124K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc1-00020-g716c18f (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #58 Wed Nov 19 21:08:58 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-11191438/linux-devel:devel-lkp-ib04-smoke-201411191439:716c18f8e57=
c5eff4725f0b5acbdb2fead202d8c:bisect-linux-8/.vmlinuz-716c18f8e57c5eff4725f=
0b5acbdb2fead202d8c-20141119212229-12-client6 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201411191439 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-111914=
38/716c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-00020-g716c1=
8f drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[ffff8800000f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02d8b000, 0x02d8bfff] PGTABLE
[    0.000000] BRK [0x02d8c000, 0x02d8cfff] PGTABLE
[    0.000000] BRK [0x02d8d000, 0x02d8dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x02d8e000, 0x02d8efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x02d8f000, 0x02d8ffff] PGTABLE
[    0.000000] BRK [0x02d90000, 0x02d90fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13cce000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c39280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-11191438/linux-devel:devel-lkp-ib04-smoke-201411191439:716c=
18f8e57c5eff4725f0b5acbdb2fead202d8c:bisect-linux-8/.vmlinuz-716c18f8e57c5e=
ff4725f0b5acbdb2fead202d8c-20141119212229-12-client6 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201411191439 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-11191438/716c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-00020=
-g716c18f drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 286036K/327160K available (6399K kernel code, 3001K =
rwdata, 3340K rodata, 912K init, 14044K bss, 41124K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value..=20
[    0.006666] Calibrating delay loop (skipped) preset value.. 5854.82 Bogo=
MIPS (lpj=3D9753326)
5854.82 BogoMIPS (lpj=3D9753326)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006688] ACPI: Core revision 20140828
[    0.006688] ACPI: Core revision 20140828
[    0.014056] ACPI:=20
[    0.014056] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.015050] Security Framework initialized
[    0.015050] Security Framework initialized
[    0.015848] AppArmor: AppArmor disabled by boot time parameter
[    0.015848] AppArmor: AppArmor disabled by boot time parameter
[    0.016670] Yama: becoming mindful.
[    0.016670] Yama: becoming mindful.
[    0.017289] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.017289] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.018433] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.018433] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.020651] Initializing cgroup subsys devices
[    0.020651] Initializing cgroup subsys devices
[    0.021456] Initializing cgroup subsys net_cls
[    0.021456] Initializing cgroup subsys net_cls
[    0.022255] Initializing cgroup subsys net_prio
[    0.022255] Initializing cgroup subsys net_prio
[    0.023133] mce: CPU supports 10 MCE banks
[    0.023133] mce: CPU supports 10 MCE banks
[    0.023371] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023371] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023371] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023371] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.025308] CPU:=20
[    0.025308] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.029107] ftrace: allocating 21762 entries in 86 pages
[    0.029107] ftrace: allocating 21762 entries in 86 pages
[    0.036986] Performance Events:=20
[    0.036986] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.041656] Testing tracer nop:=20
[    0.041656] Testing tracer nop: PASSED
PASSED
[    0.042482] Getting VERSION: 1050014
[    0.042482] Getting VERSION: 1050014
[    0.043341] Getting VERSION: 1050014
[    0.043341] Getting VERSION: 1050014
[    0.044016] Getting ID: 0
[    0.044016] Getting ID: 0
[    0.044464] Getting ID: ff000000
[    0.044464] Getting ID: ff000000
[    0.045017] Getting LVT0: 8700
[    0.045017] Getting LVT0: 8700
[    0.045543] Getting LVT1: 8400
[    0.045543] Getting LVT1: 8400
[    0.046115] enabled ExtINT on CPU#0
[    0.046115] enabled ExtINT on CPU#0
[    0.047362] ENABLING IO-APIC IRQs
[    0.047362] ENABLING IO-APIC IRQs
[    0.047936] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.047936] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.049112] init IO_APIC IRQs
[    0.049112] init IO_APIC IRQs
[    0.049618]  apic 0 pin 0 not connected
[    0.049618]  apic 0 pin 0 not connected
[    0.050046] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.050046] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.051470] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.051470] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053354] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053354] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.054708] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.054708] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056173] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.056173] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.056689] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.056689] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.058110] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.058110] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.060022] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060022] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.061384] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.061384] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.063355] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.063355] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.064733] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.064733] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.066234] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.066234] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.066691] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.066691] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068172] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.068172] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.070021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.070021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.071432] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.071432] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.073351]  apic 0 pin 16 not connected
[    0.073351]  apic 0 pin 16 not connected
[    0.074069]  apic 0 pin 17 not connected
[    0.074069]  apic 0 pin 17 not connected
[    0.074802]  apic 0 pin 18 not connected
[    0.074802]  apic 0 pin 18 not connected
[    0.075522]  apic 0 pin 19 not connected
[    0.075522]  apic 0 pin 19 not connected
[    0.076188]  apic 0 pin 20 not connected
[    0.076188]  apic 0 pin 20 not connected
[    0.076669]  apic 0 pin 21 not connected
[    0.076669]  apic 0 pin 21 not connected
[    0.077356]  apic 0 pin 22 not connected
[    0.077356]  apic 0 pin 22 not connected
[    0.078018]  apic 0 pin 23 not connected
[    0.078018]  apic 0 pin 23 not connected
[    0.078890] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.078890] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.080003] Using local APIC timer interrupts.
[    0.080003] calibrating APIC timer ...
[    0.080003] Using local APIC timer interrupts.
[    0.080003] calibrating APIC timer ...
[    0.083333] ... lapic delta =3D 6250127
[    0.083333] ... lapic delta =3D 6250127
[    0.083333] ... PM-Timer delta =3D 357968
[    0.083333] ... PM-Timer delta =3D 357968
[    0.083333] ... PM-Timer result ok
[    0.083333] ... PM-Timer result ok
[    0.083333] ..... delta 6250127
[    0.083333] ..... delta 6250127
[    0.083333] ..... mult: 268440937
[    0.083333] ..... mult: 268440937
[    0.083333] ..... calibration result: 3333401
[    0.083333] ..... calibration result: 3333401
[    0.083333] ..... CPU clock speed is 2926.1044 MHz.
[    0.083333] ..... CPU clock speed is 2926.1044 MHz.
[    0.083333] ..... host bus clock speed is 1000.0401 MHz.
[    0.083333] ..... host bus clock speed is 1000.0401 MHz.
[    0.084780] Testing tracer function:=20
[    0.084780] Testing tracer function: PASSED
PASSED
[    0.297490] Testing dynamic ftrace:=20
[    0.297490] Testing dynamic ftrace: PASSED
PASSED
[    0.516908] Testing dynamic ftrace ops #1:=20
[    0.516908] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 0 1 0 0) (1 1 =
2 0 0) (1 1 2 0 0) (2 1 3 0 20586) (2 1 3 0 20586) (2 2 4 0 20697) (2 2 4 0=
 20697) PASSED
PASSED
[    0.694241] Testing dynamic ftrace ops #2:=20
[    0.694241] Testing dynamic ftrace ops #2: (1 0 1 20557 0) (1 0 1 20557 =
0) (1 1 2 20668 0) (1 1 2 20668 0) (2 1 3 1 20547) (2 1 3 1 20547) (2 2 4 1=
12 20658) (2 2 4 112 20658) PASSED
PASSED
[    0.895814] Testing ftrace recursion:=20
[    0.895814] Testing ftrace recursion: PASSED
PASSED
[    0.909301] Testing ftrace recursion safe:=20
[    0.909301] Testing ftrace recursion safe: PASSED
PASSED
[    0.923025] Testing ftrace regs:=20
[    0.923025] Testing ftrace regs: PASSED
PASSED
[    0.937133] Testing tracer wakeup:=20
[    0.937133] Testing tracer wakeup: PASSED
PASSED
[    1.045713] Testing tracer wakeup_rt:=20
[    1.045713] Testing tracer wakeup_rt: PASSED
PASSED
[    1.135239] Testing tracer wakeup_dl:=20
[    1.135239] Testing tracer wakeup_dl: PASSED
PASSED
[    1.247699] prandom: seed boundary self test passed
[    1.247699] prandom: seed boundary self test passed
[    1.249784] prandom: 100 self tests passed
[    1.249784] prandom: 100 self tests passed
[    1.251062] regulator-dummy: no parameters
[    1.251062] regulator-dummy: no parameters
[    1.253362] NET: Registered protocol family 16
[    1.253362] NET: Registered protocol family 16
[    1.254688] cpuidle: using governor ladder
[    1.254688] cpuidle: using governor ladder
[    1.255371] cpuidle: using governor menu
[    1.255371] cpuidle: using governor menu
[    1.256204] ACPI: bus type PCI registered
[    1.256204] ACPI: bus type PCI registered
[    1.256730] PCI: Using configuration type 1 for base access
[    1.256730] PCI: Using configuration type 1 for base access
[    1.264145] Running resizable hashtable tests...
[    1.264145] Running resizable hashtable tests...
[    1.264917]   Adding 2048 keys
[    1.264917]   Adding 2048 keys
[    1.266673]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    1.266673]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    1.267889]   Table expansion iteration 0...
[    1.267889]   Table expansion iteration 0...
[    1.268822]   Verifying lookups...
[    1.268822]   Verifying lookups...
[    1.269490]   Table expansion iteration 1...
[    1.269490]   Table expansion iteration 1...
[    1.270343]   Verifying lookups...
[    1.270343]   Verifying lookups...
[    1.271005]   Table expansion iteration 2...
[    1.271005]   Table expansion iteration 2...
[    1.272169]   Verifying lookups...
[    1.272169]   Verifying lookups...
[    1.272823]   Table expansion iteration 3...
[    1.272823]   Table expansion iteration 3...
[    1.273993]   Verifying lookups...
[    1.273993]   Verifying lookups...
[    1.274647]   Table shrinkage iteration 0...
[    1.274647]   Table shrinkage iteration 0...
[    1.275484]   Verifying lookups...
[    1.275484]   Verifying lookups...
[    1.276143]   Table shrinkage iteration 1...
[    1.276143]   Table shrinkage iteration 1...
[    1.276755]   Verifying lookups...
[    1.276755]   Verifying lookups...
[    1.277410]   Table shrinkage iteration 2...
[    1.277410]   Table shrinkage iteration 2...
[    1.278146]   Verifying lookups...
[    1.278146]   Verifying lookups...
[    1.278836]   Table shrinkage iteration 3...
[    1.278836]   Table shrinkage iteration 3...
[    1.280047]   Verifying lookups...
[    1.280047]   Verifying lookups...
[    1.281119]   Deleting 2048 keys
[    1.281119]   Deleting 2048 keys
[    1.284383] ACPI: Added _OSI(Module Device)
[    1.284383] ACPI: Added _OSI(Module Device)
[    1.285456] ACPI: Added _OSI(Processor Device)
[    1.285456] ACPI: Added _OSI(Processor Device)
[    1.286578] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.286578] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.286672] ACPI: Added _OSI(Processor Aggregator Device)
[    1.286672] ACPI: Added _OSI(Processor Aggregator Device)
[    1.292953] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.292953] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.301592] ACPI: Interpreter enabled
[    1.301592] ACPI: Interpreter enabled
[    1.302605] ACPI: (supports S0 S5)
[    1.302605] ACPI: (supports S0 S5)
[    1.303337] ACPI: Using IOAPIC for interrupt routing
[    1.303337] ACPI: Using IOAPIC for interrupt routing
[    1.304550] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.304550] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.333151] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.333151] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.333347] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.333347] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.334464] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.334464] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.337373] PCI host bridge to bus 0000:00
[    1.337373] PCI host bridge to bus 0000:00
[    1.338092] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.338092] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.339006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.339006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.340005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.340005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.341044] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.341044] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.342050] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.342050] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.343340] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.343340] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.344399] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.344399] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.345526] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.345526] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.346784] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.346784] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.350193] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.350193] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.353090] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.353090] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.357894] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.357894] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.360640] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.360640] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.362459] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.362459] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.363338] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.363338] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.365127] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.365127] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.367537] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.367537] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.370523] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.370523] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.372372] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.372372] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.374296] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.374296] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.378080] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.378080] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.380667] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.380667] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.389270] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.389270] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.390932] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.390932] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.394596] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.394596] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.397303] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.397303] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.404489] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.404489] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.407466] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.407466] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.409343] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.409343] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.413609] pci_bus 0000:00: on NUMA node 0
[    1.413609] pci_bus 0000:00: on NUMA node 0
[    1.415678] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.415678] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.416997] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.416997] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.418803] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.418803] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.420054] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.420054] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.421204] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.421204] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.422836] ACPI:=20
[    1.422836] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.423824] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.423824] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.424732] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.424732] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.426053] vgaarb: loaded
[    1.426053] vgaarb: loaded
[    1.426673] vgaarb: bridge control possible 0000:00:02.0
[    1.426673] vgaarb: bridge control possible 0000:00:02.0
[    1.427663] ACPI: bus type USB registered
[    1.427663] ACPI: bus type USB registered
[    1.428436] usbcore: registered new interface driver usbfs
[    1.428436] usbcore: registered new interface driver usbfs
[    1.429364] usbcore: registered new interface driver hub
[    1.429364] usbcore: registered new interface driver hub
[    1.430071] usbcore: registered new device driver usb
[    1.430071] usbcore: registered new device driver usb
[    1.431115] pps_core: LinuxPPS API ver. 1 registered
[    1.431115] pps_core: LinuxPPS API ver. 1 registered
[    1.431945] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.431945] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.433358] PTP clock support registered
[    1.433358] PTP clock support registered
[    1.434184] PCI: Using ACPI for IRQ routing
[    1.434184] PCI: Using ACPI for IRQ routing
[    1.434865] PCI: pci_cache_line_size set to 64 bytes
[    1.434865] PCI: pci_cache_line_size set to 64 bytes
[    1.435749] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.435749] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.436682] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.436682] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.438494] irda_init()
[    1.438494] irda_init()
[    1.438942] NET: Registered protocol family 23
[    1.438942] NET: Registered protocol family 23
[    1.440068] Bluetooth: Core ver 2.19
[    1.440068] Bluetooth: Core ver 2.19
[    1.440667] NET: Registered protocol family 31
[    1.440667] NET: Registered protocol family 31
[    1.441372] Bluetooth: HCI device and connection manager initialized
[    1.441372] Bluetooth: HCI device and connection manager initialized
[    1.442406] Bluetooth: HCI socket layer initialized
[    1.442406] Bluetooth: HCI socket layer initialized
[    1.443346] Bluetooth: L2CAP socket layer initialized
[    1.443346] Bluetooth: L2CAP socket layer initialized
[    1.444199] Bluetooth: SCO socket layer initialized
[    1.444199] Bluetooth: SCO socket layer initialized
[    1.445247] Switched to clocksource kvm-clock
[    1.445247] Switched to clocksource kvm-clock
[    1.446390] Warning: could not register annotated branches stats
[    1.446390] Warning: could not register annotated branches stats
[    1.469046] pnp: PnP ACPI init
[    1.469046] pnp: PnP ACPI init
[    1.470101] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.470101] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.472333] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.472333] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.474088] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.474088] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.476253] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.476253] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.478035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.478035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.479480] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.479480] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.480628] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.480628] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.481899] pnp 00:03: [dma 2]
[    1.481899] pnp 00:03: [dma 2]
[    1.482491] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.482491] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.483628] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.483628] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.484998] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.484998] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.486132] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.486132] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.487461] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.487461] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.489234] pnp: PnP ACPI: found 6 devices
[    1.489234] pnp: PnP ACPI: found 6 devices
[    1.495390] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.495390] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.496270] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.496270] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.497142] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.497142] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.498021] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.498021] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.498893] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.498893] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.499769] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.499769] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.500754] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.500754] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.501783] NET: Registered protocol family 2
[    1.501783] NET: Registered protocol family 2
[    1.502855] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.502855] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.504033] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.504033] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.505299] TCP: Hash tables configured (established 4096 bind 4096)
[    1.505299] TCP: Hash tables configured (established 4096 bind 4096)
[    1.506336] TCP: reno registered
[    1.506336] TCP: reno registered
[    1.506860] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.506860] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.507839] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.507839] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.509052] NET: Registered protocol family 1
[    1.509052] NET: Registered protocol family 1
[    1.509765] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.509765] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.510712] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.510712] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.511646] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.511646] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.512877] pci 0000:00:02.0: Video device with shadowed ROM
[    1.512877] pci 0000:00:02.0: Video device with shadowed ROM
[    1.514210] PCI: CLS 0 bytes, default 64
[    1.514210] PCI: CLS 0 bytes, default 64
[    1.515580] Unpacking initramfs...
[    1.515580] Unpacking initramfs...
[    1.611562] debug: unmapping init [mem 0xffff880013cce000-0xffff880013fd=
7fff]
[    1.611562] debug: unmapping init [mem 0xffff880013cce000-0xffff880013fd=
7fff]
[    1.613090] Machine check injector initialized
[    1.613090] Machine check injector initialized
[    1.614164] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.614164] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.615658] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.615658] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.617307] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.617307] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.618893] PCLMULQDQ-NI instructions are not detected.
[    1.618893] PCLMULQDQ-NI instructions are not detected.
[    1.619779] AVX or AES-NI instructions are not detected.
[    1.619779] AVX or AES-NI instructions are not detected.
[    1.620640] AVX instructions are not detected.
[    1.620640] AVX instructions are not detected.
[    1.621366] AVX2 instructions are not detected.
[    1.621366] AVX2 instructions are not detected.
[    1.622970] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.622970] futex hash table entries: 16 (order: -2, 1536 bytes)
[    1.623977] Initialise system trusted keyring
[    1.623977] Initialise system trusted keyring
[    1.624809] audit: initializing netlink subsys (disabled)
[    1.624809] audit: initializing netlink subsys (disabled)
[    1.625786] audit: type=3D2000 audit(1416403361.678:1): initialized
[    1.625786] audit: type=3D2000 audit(1416403361.678:1): initialized
[    1.626915] Kprobe smoke test: started
[    1.626915] Kprobe smoke test: started
[    1.649109] Kprobe smoke test: passed successfully
[    1.649109] Kprobe smoke test: passed successfully
[    1.649888] ------------[ cut here ]------------
[    1.649888] ------------[ cut here ]------------
[    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x=
1a9/0x200()
[    1.650631] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x=
1a9/0x200()
[    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imb=
alance=20
[    1.652149] initcall init_kprobes+0x0/0x1d2 returned with preemption imb=
alance=20
[    1.653357] Modules linked in:
[    1.653357] Modules linked in:

[    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g71=
6c18f #58
[    1.653857] CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00020-g71=
6c18f #58
[    1.655071]  0000000000000009
[    1.655071]  0000000000000009 ffff88001345fdf8 ffff88001345fdf8 ffffffff=
816356b2 ffffffff816356b2 ffff88001345fe38 ffff88001345fe38

[    1.656312]  ffffffff8108da6a
[    1.656312]  ffffffff8108da6a ffff88001345fe58 ffff88001345fe58 00000000=
00000000 0000000000000000 0000000000000001 0000000000000001

[    1.657542]  0000000000000001
[    1.657542]  0000000000000001 ffffffff81f09df6 ffffffff81f09df6 00000000=
00000000 0000000000000000 ffff88001345fe98 ffff88001345fe98

[    1.658800] Call Trace:
[    1.658800] Call Trace:
[    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[    1.659200]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
[    1.660020]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
[    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.660991]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
[    1.661994]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
[    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
[    1.662900]  [<ffffffff81f09fbf>] ? init_kprobes+0x1c9/0x1d2
[    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.663810]  [<ffffffff81f09df6>] ? debugfs_kprobe_init+0xab/0xab
[    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
[    1.665184]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
[    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[    1.666615]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.668170]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[    1.669476]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[    1.670763]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.672123]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[    1.673365] ---[ end trace 660d24cf53fa6caf ]---
[    1.673365] ---[ end trace 660d24cf53fa6caf ]---
[    1.675070] zpool: loaded
[    1.675070] zpool: loaded
[    1.676153] Key type cifs.idmap registered
[    1.676153] Key type cifs.idmap registered
[    1.676877] msgmni has been set to 558
[    1.676877] msgmni has been set to 558
[    1.679599] NET: Registered protocol family 38
[    1.679599] NET: Registered protocol family 38
[    1.680364] Key type asymmetric registered
[    1.680364] Key type asymmetric registered
[    1.681060] Asymmetric key parser 'x509' registered
[    1.681060] Asymmetric key parser 'x509' registered
[    1.681880] start plist test
[    1.681880] start plist test
[    1.687802] end plist test
[    1.687802] end plist test
[    1.689054] test_string_helpers: Running tests...
[    1.689054] test_string_helpers: Running tests...
[    1.690695] ipmi message handler version 39.2
[    1.690695] ipmi message handler version 39.2
[    1.691546] IPMI System Interface driver.
[    1.691546] IPMI System Interface driver.
[    1.692343] ipmi_si: Adding default-specified kcs state machine
[    1.692343] ipmi_si: Adding default-specified kcs state machine

[    1.693305] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.693305] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.694939] ipmi_si: Interface detection failed
[    1.694939] ipmi_si: Interface detection failed
[    1.695689] ipmi_si: Adding default-specified smic state machine
[    1.695689] ipmi_si: Adding default-specified smic state machine

[    1.696669] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.696669] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.698363] ipmi_si: Interface detection failed
[    1.698363] ipmi_si: Interface detection failed
[    1.699078] ipmi_si: Adding default-specified bt state machine
[    1.699078] ipmi_si: Adding default-specified bt state machine

[    1.700028] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.700028] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.701674] ipmi_si: Interface detection failed
[    1.701674] ipmi_si: Interface detection failed
[    1.702573] ipmi_si: Unable to find any System Interface(s)
[    1.702573] ipmi_si: Unable to find any System Interface(s)
[    1.703921] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.703921] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.705206] ACPI: Power Button [PWRF]
[    1.705206] ACPI: Power Button [PWRF]
[    1.706460] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.706460] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.732565] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    1.732565] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    1.737319] dummy-irq: no IRQ given.  Use irq=3DN
[    1.737319] dummy-irq: no IRQ given.  Use irq=3DN
[    1.738588] HSI/SSI char device loaded
[    1.738588] HSI/SSI char device loaded
[    1.739485] w83977af_init()
[    1.739485] w83977af_init()
[    1.740140] w83977af_open()
[    1.740140] w83977af_open()
[    1.740801] w83977af_probe()
[    1.740801] w83977af_probe()
[    1.741582] w83977af_probe(), Wrong chip version
[    1.741582] w83977af_probe(), Wrong chip version

[    1.742685] w83977af_probe()
[    1.742685] w83977af_probe()
[    1.743508] w83977af_probe(), Wrong chip version
[    1.743508] w83977af_probe(), Wrong chip version

[    1.744682] usbcore: registered new interface driver mcs7780
[    1.744682] usbcore: registered new interface driver mcs7780
[    1.746141] usbcore: registered new interface driver ksdazzle-sir
[    1.746141] usbcore: registered new interface driver ksdazzle-sir
[    1.748206] usbcore: registered new interface driver appledisplay
[    1.748206] usbcore: registered new interface driver appledisplay
[    1.749751] usbcore: registered new interface driver idmouse
[    1.749751] usbcore: registered new interface driver idmouse
[    1.751176] usbcore: registered new interface driver usblcd
[    1.751176] usbcore: registered new interface driver usblcd
[    1.752560] usbcore: registered new interface driver usbled
[    1.752560] usbcore: registered new interface driver usbled
[    1.753976] usbcore: registered new interface driver usbtest
[    1.753976] usbcore: registered new interface driver usbtest
[    1.755393] usbcore: registered new interface driver usb_ehset_test
[    1.755393] usbcore: registered new interface driver usb_ehset_test
[    1.756936] usbcore: registered new interface driver trancevibrator
[    1.756936] usbcore: registered new interface driver trancevibrator
[    1.758734] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.758734] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.761659] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.761659] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.762979] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.762979] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.766320] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.766320] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.769075] usbcore: registered new interface driver gtco
[    1.769075] usbcore: registered new interface driver gtco
[    1.770447] usbcore: registered new interface driver usbtouchscreen
[    1.770447] usbcore: registered new interface driver usbtouchscreen
[    1.772446] usbcore: registered new interface driver sur40
[    1.772446] usbcore: registered new interface driver sur40
[    1.773930] IR RC5(x/sz) protocol handler initialized
[    1.773930] IR RC5(x/sz) protocol handler initialized
[    1.775126] IR SANYO protocol handler initialized
[    1.775126] IR SANYO protocol handler initialized
[    1.776289] usbcore: registered new interface driver redrat3
[    1.776289] usbcore: registered new interface driver redrat3
[    1.777637] usbcore: registered new interface driver iguanair
[    1.777637] usbcore: registered new interface driver iguanair
[    1.778934] Driver for 1-wire Dallas network protocol.
[    1.778934] Driver for 1-wire Dallas network protocol.
[    1.780244] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.780244] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.782712] usbcore: registered new interface driver pcwd_usb
[    1.782712] usbcore: registered new interface driver pcwd_usb
[    1.783969] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.783969] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.785924] acquirewdt: I/O address 0x0043 already in use
[    1.785924] acquirewdt: I/O address 0x0043 already in use
[    1.787440] acquirewdt: probe of acquirewdt failed with error -5
[    1.787440] acquirewdt: probe of acquirewdt failed with error -5
[    1.789603] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    1.789603] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    1.791332] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    1.791332] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    1.792423] it87_wdt: no device
[    1.792423] it87_wdt: no device
[    1.792935] sc1200wdt: build 20020303
[    1.792935] sc1200wdt: build 20020303
[    1.793574] sc1200wdt: io parameter must be specified
[    1.793574] sc1200wdt: io parameter must be specified
[    1.794451] cpu5wdt: misc_register failed
[    1.794451] cpu5wdt: misc_register failed
[    1.795180] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    1.795180] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    1.797577] smsc37b787_wdt: Unable to register miscdev on minor 130
[    1.797577] smsc37b787_wdt: Unable to register miscdev on minor 130
[    1.798685] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.798685] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.799914] machzwd: no ZF-Logic found
[    1.799914] machzwd: no ZF-Logic found
[    1.800801] Bluetooth: Virtual HCI driver ver 1.5
[    1.800801] Bluetooth: Virtual HCI driver ver 1.5
[    1.802207] usbcore: registered new interface driver bpa10x
[    1.802207] usbcore: registered new interface driver bpa10x
[    1.803639] usbcore: registered new interface driver btusb
[    1.803639] usbcore: registered new interface driver btusb
[    1.805255] hidraw: raw HID events driver (C) Jiri Kosina
[    1.805255] hidraw: raw HID events driver (C) Jiri Kosina
[    1.809304] panel: driver version 0.9.5 not yet registered
[    1.809304] panel: driver version 0.9.5 not yet registered
[    1.810602] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    1.810602] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    1.812105] Copyright 2010. Beceem Communications Inc
[    1.812105] Copyright 2010. Beceem Communications Inc
[    1.813437] usbcore: registered new interface driver usbbcm
[    1.813437] usbcore: registered new interface driver usbbcm
[    1.815324] ashmem: initialized
[    1.815324] ashmem: initialized
[    1.816188] usbcore: registered new interface driver gdm_wimax
[    1.816188] usbcore: registered new interface driver gdm_wimax
[    1.817573] FPGA DOWNLOAD --->
[    1.817573] FPGA DOWNLOAD --->
[    1.818312] FPGA image file name: xlinx_fpga_firmware.bit
[    1.818312] FPGA image file name: xlinx_fpga_firmware.bit
[    1.819753] GPIO INIT FAIL!!
[    1.819753] GPIO INIT FAIL!!
[    1.820938] oprofile: using NMI interrupt.
[    1.820938] oprofile: using NMI interrupt.
[    1.821958] drop_monitor: Initializing network drop monitor service
[    1.821958] drop_monitor: Initializing network drop monitor service
[    1.823539] NET: Registered protocol family 26
[    1.823539] NET: Registered protocol family 26
[    1.824652] u32 classifier
[    1.824652] u32 classifier
[    1.825310]     Performance counters on
[    1.825310]     Performance counters on
[    1.826240] Netfilter messages via NETLINK v0.30.
[    1.826240] Netfilter messages via NETLINK v0.30.
[    1.827539] TCP: cubic registered
[    1.827539] TCP: cubic registered
[    1.828373] NET: Registered protocol family 15
[    1.828373] NET: Registered protocol family 15
[    1.829504] Bluetooth: RFCOMM socket layer initialized
[    1.829504] Bluetooth: RFCOMM socket layer initialized
[    1.830775] Bluetooth: RFCOMM ver 1.11
[    1.830775] Bluetooth: RFCOMM ver 1.11
[    1.831713] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.831713] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.832963] Bluetooth: BNEP filters: protocol multicast
[    1.832963] Bluetooth: BNEP filters: protocol multicast
[    1.834195] Bluetooth: BNEP socket layer initialized
[    1.834195] Bluetooth: BNEP socket layer initialized
[    1.835378] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.835378] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.836914] Bluetooth: HIDP socket layer initialized
[    1.836914] Bluetooth: HIDP socket layer initialized
[    1.838136] NET: Registered protocol family 33
[    1.838136] NET: Registered protocol family 33
[    1.839176] Key type rxrpc registered
[    1.839176] Key type rxrpc registered
[    1.840036] Key type rxrpc_s registered
[    1.840036] Key type rxrpc_s registered
[    1.841588] RxRPC: Registered security type 2 'rxkad'
[    1.841588] RxRPC: Registered security type 2 'rxkad'
[    1.842845] l2tp_core: L2TP core driver, V2.0
[    1.842845] l2tp_core: L2TP core driver, V2.0
[    1.843881] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    1.843881] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    1.845214] l2tp_netlink: L2TP netlink interface
[    1.845214] l2tp_netlink: L2TP netlink interface
[    1.846379] l2tp_debugfs: L2TP debugfs support
[    1.846379] l2tp_debugfs: L2TP debugfs support
[    1.847435] tipc: Activated (version 2.0.0)
[    1.847435] tipc: Activated (version 2.0.0)
[    1.848578] NET: Registered protocol family 30
[    1.848578] NET: Registered protocol family 30
[    1.849809] tipc: Started in single node mode
[    1.849809] tipc: Started in single node mode
[    1.850846] Key type dns_resolver registered
[    1.850846] Key type dns_resolver registered
[    1.851880] openvswitch: Open vSwitch switching datapath
[    1.851880] openvswitch: Open vSwitch switching datapath
[    1.853391] mpls_gso: MPLS GSO support
[    1.853391] mpls_gso: MPLS GSO support
[    1.855183]=20
[    1.855183] printing PIC contents
[    1.855183]=20
[    1.855183] printing PIC contents
[    1.856460] ... PIC  IMR: ffff
[    1.856460] ... PIC  IMR: ffff
[    1.857285] ... PIC  IRR: 1013
[    1.857285] ... PIC  IRR: 1013
[    1.858131] ... PIC  ISR: 0000
[    1.858131] ... PIC  ISR: 0000
[    1.858949] ... PIC ELCR: 0c00
[    1.858949] ... PIC ELCR: 0c00
[    1.859766] printing local APIC contents on CPU#0/0:
[    1.859766] printing local APIC contents on CPU#0/0:
[    1.861083] ... APIC ID:      00000000 (0)
[    1.861083] ... APIC ID:      00000000 (0)
[    1.861460] ... APIC VERSION: 01050014
[    1.861460] ... APIC VERSION: 01050014
[    1.861460] ... APIC TASKPRI: 00000000 (00)
[    1.861460] ... APIC TASKPRI: 00000000 (00)
[    1.861460] ... APIC PROCPRI: 00000000
[    1.861460] ... APIC PROCPRI: 00000000
[    1.861460] ... APIC LDR: 01000000
[    1.861460] ... APIC LDR: 01000000
[    1.861460] ... APIC DFR: ffffffff
[    1.861460] ... APIC DFR: ffffffff
[    1.861460] ... APIC SPIV: 000001ff
[    1.861460] ... APIC SPIV: 000001ff
[    1.861460] ... APIC ISR field:
[    1.861460] ... APIC ISR field:
[    1.861460] 00000000
[    1.861460] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.861460] ... APIC TMR field:
[    1.861460] ... APIC TMR field:
[    1.861460] 00000000
[    1.861460] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.861460] ... APIC IRR field:
[    1.861460] ... APIC IRR field:
[    1.861460] 00000000
[    1.861460] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    1.861460] ... APIC ESR: 00000000
[    1.861460] ... APIC ESR: 00000000
[    1.861460] ... APIC ICR: 00000831
[    1.861460] ... APIC ICR: 00000831
[    1.861460] ... APIC ICR2: 01000000
[    1.861460] ... APIC ICR2: 01000000
[    1.861460] ... APIC LVTT: 000200ef
[    1.861460] ... APIC LVTT: 000200ef
[    1.861460] ... APIC LVTPC: 00010000
[    1.861460] ... APIC LVTPC: 00010000
[    1.861460] ... APIC LVT0: 00010700
[    1.861460] ... APIC LVT0: 00010700
[    1.861460] ... APIC LVT1: 00000400
[    1.861460] ... APIC LVT1: 00000400
[    1.861460] ... APIC LVTERR: 000000fe
[    1.861460] ... APIC LVTERR: 000000fe
[    1.861460] ... APIC TMICT: 00032dd1
[    1.861460] ... APIC TMICT: 00032dd1
[    1.861460] ... APIC TMCCT: 00007984
[    1.861460] ... APIC TMCCT: 00007984
[    1.861460] ... APIC TDCR: 00000003
[    1.861460] ... APIC TDCR: 00000003
[    1.861460]=20
[    1.861460]=20
[    1.878713] number of MP IRQ sources: 15.
[    1.878713] number of MP IRQ sources: 15.
[    1.879367] number of IO-APIC #0 registers: 24.
[    1.879367] number of IO-APIC #0 registers: 24.
[    1.880097] testing the IO APIC.......................
[    1.880097] testing the IO APIC.......................
[    1.880931] IO APIC #0......
[    1.880931] IO APIC #0......
[    1.881409] .... register #00: 00000000
[    1.881409] .... register #00: 00000000
[    1.882026] .......    : physical APIC id: 00
[    1.882026] .......    : physical APIC id: 00
[    1.882729] .......    : Delivery Type: 0
[    1.882729] .......    : Delivery Type: 0
[    1.883376] .......    : LTS          : 0
[    1.883376] .......    : LTS          : 0
[    1.884018] .... register #01: 00170011
[    1.884018] .... register #01: 00170011
[    1.884643] .......     : max redirection entries: 17
[    1.884643] .......     : max redirection entries: 17
[    1.885453] .......     : PRQ implemented: 0
[    1.885453] .......     : PRQ implemented: 0
[    1.886139] .......     : IO APIC version: 11
[    1.886139] .......     : IO APIC version: 11
[    1.886837] .... register #02: 00000000
[    1.886837] .... register #02: 00000000
[    1.887456] .......     : arbitration: 00
[    1.887456] .......     : arbitration: 00
[    1.888111] .... IRQ redirection table:
[    1.888111] .... IRQ redirection table:
[    1.888741] 1    0    0   0   0    0    0    00
[    1.888741] 1    0    0   0   0    0    0    00
[    1.889477] 0    0    0   0   0    1    1    31
[    1.889477] 0    0    0   0   0    1    1    31
[    1.890223] 0    0    0   0   0    1    1    30
[    1.890223] 0    0    0   0   0    1    1    30
[    1.890956] 0    0    0   0   0    1    1    33
[    1.890956] 0    0    0   0   0    1    1    33
[    1.891701] 1    0    0   0   0    1    1    34
[    1.891701] 1    0    0   0   0    1    1    34
[    1.892437] 1    1    0   0   0    1    1    35
[    1.892437] 1    1    0   0   0    1    1    35
[    1.893174] 0    0    0   0   0    1    1    36
[    1.893174] 0    0    0   0   0    1    1    36
[    1.893910] 0    0    0   0   0    1    1    37
[    1.893910] 0    0    0   0   0    1    1    37
[    1.894652] 0    0    0   0   0    1    1    38
[    1.894652] 0    0    0   0   0    1    1    38
[    1.895388] 0    1    0   0   0    1    1    39
[    1.895388] 0    1    0   0   0    1    1    39
[    1.896122] 1    1    0   0   0    1    1    3A
[    1.896122] 1    1    0   0   0    1    1    3A
[    1.896862] 1    1    0   0   0    1    1    3B
[    1.896862] 1    1    0   0   0    1    1    3B
[    1.897613] 0    0    0   0   0    1    1    3C
[    1.897613] 0    0    0   0   0    1    1    3C
[    1.898551] 0    0    0   0   0    1    1    3D
[    1.898551] 0    0    0   0   0    1    1    3D
[    1.899791] 0    0    0   0   0    1    1    3E
[    1.899791] 0    0    0   0   0    1    1    3E
[    1.901015] 0    0    0   0   0    1    1    3F
[    1.901015] 0    0    0   0   0    1    1    3F
[    1.902263] 1    0    0   0   0    0    0    00
[    1.902263] 1    0    0   0   0    0    0    00
[    1.903482] 1    0    0   0   0    0    0    00
[    1.903482] 1    0    0   0   0    0    0    00
[    1.904701] 1    0    0   0   0    0    0    00
[    1.904701] 1    0    0   0   0    0    0    00
[    1.905906] 1    0    0   0   0    0    0    00
[    1.905906] 1    0    0   0   0    0    0    00
[    1.907115] 1    0    0   0   0    0    0    00
[    1.907115] 1    0    0   0   0    0    0    00
[    1.908339] 1    0    0   0   0    0    0    00
[    1.908339] 1    0    0   0   0    0    0    00
[    1.909546] 1    0    0   0   0    0    0    00
[    1.909546] 1    0    0   0   0    0    0    00
[    1.910757] 1    0    0   0   0    0    0    00
[    1.910757] 1    0    0   0   0    0    0    00
[    1.911968] IRQ to pin mappings:
[    1.911968] IRQ to pin mappings:
[    1.912828] IRQ0=20
[    1.912828] IRQ0 -> 0:2-> 0:2

[    1.913522] IRQ1=20
[    1.913522] IRQ1 -> 0:1-> 0:1

[    1.914220] IRQ3=20
[    1.914220] IRQ3 -> 0:3-> 0:3

[    1.914920] IRQ4=20
[    1.914920] IRQ4 -> 0:4-> 0:4

[    1.915616] IRQ5=20
[    1.915616] IRQ5 -> 0:5-> 0:5

[    1.916314] IRQ6=20
[    1.916314] IRQ6 -> 0:6-> 0:6

[    1.917001] IRQ7=20
[    1.917001] IRQ7 -> 0:7-> 0:7

[    1.917699] IRQ8=20
[    1.917699] IRQ8 -> 0:8-> 0:8

[    1.918404] IRQ9=20
[    1.918404] IRQ9 -> 0:9-> 0:9

[    1.919100] IRQ10=20
[    1.919100] IRQ10 -> 0:10-> 0:10

[    1.919835] IRQ11=20
[    1.919835] IRQ11 -> 0:11-> 0:11

[    1.920578] IRQ12=20
[    1.920578] IRQ12 -> 0:12-> 0:12

[    1.921330] IRQ13=20
[    1.921330] IRQ13 -> 0:13-> 0:13

[    1.922072] IRQ14=20
[    1.922072] IRQ14 -> 0:14-> 0:14

[    1.922814] IRQ15=20
[    1.922814] IRQ15 -> 0:15-> 0:15

[    1.923397] .................................... done.
[    1.923397] .................................... done.
[    1.924596] bootconsole [earlyser0] disabled
[    1.924596] bootconsole [earlyser0] disabled
[    1.925423] Loading compiled-in X.509 certificates
[    1.926758] Loaded X.509 cert 'Magrathea: Glacier signing key: 644d074ed=
f4ec203c5a5016c38757f11889cf684'
[    1.927686] registered taskstats version 1
[    1.928066] Running ring buffer tests...
[    2.654593] tsc: Refined TSC clocksource calibration: 2925.995 MHz
[   11.931538] finished
[   11.932431] CPU 0:
[   11.932710]               events:    2999
[   11.933240]        dropped bytes:    0
[   11.933730]        alloced bytes:    233656
[   11.934278]        written bytes:    229216
[   11.934848]        biggest event:    131
[   11.935372]       smallest event:    0
[   11.938724]          read events:   2999
[   11.939252]          lost events:   0
[   11.939732]         total events:   2999
[   11.940251]   recorded len bytes:   233656
[   11.940799]  recorded size bytes:   229216
[   11.941374] Ring buffer PASSED!
[   11.942346] Running tests on trace events:
[   11.942887] Testing event thermal_apic_exit: OK
[   11.948183] Testing event thermal_apic_entry: OK
[   11.954860] Testing event threshold_apic_exit: OK
[   11.961520] Testing event threshold_apic_entry: OK
[   11.968182] Testing event call_function_single_exit: OK
[   11.974817] Testing event call_function_single_entry: OK
[   11.981478] Testing event call_function_exit: OK
[   11.988270] Testing event call_function_entry: OK
[   11.994901] Testing event irq_work_exit: OK
[   12.001575] Testing event irq_work_entry: OK
[   12.008246] Testing event x86_platform_ipi_exit: OK
[   12.014902] Testing event x86_platform_ipi_entry: OK
[   12.021565] Testing event error_apic_exit: OK
[   12.028530] Testing event error_apic_entry: OK
[   12.035330] Testing event spurious_apic_exit: OK
[   12.041518] Testing event spurious_apic_entry: OK
[   12.048202] Testing event reschedule_exit: OK
[   12.054836] Testing event reschedule_entry: OK
[   12.061574] Testing event local_timer_exit: OK
[   12.068247] Testing event local_timer_entry: OK
[   12.074902] Testing event nmi_handler: OK
[   12.081566] Testing event emulate_vsyscall: OK
[   12.088242] Testing event sys_exit: OK
[   12.094902] Testing event sys_enter: OK
[   12.101571] Testing event mce_record: OK
[   12.108245] Testing event tlb_flush: OK
[   12.114922] Testing event page_fault_kernel: OK
[   12.121569] Testing event page_fault_user: OK
[   12.128245] Testing event task_rename: OK
[   12.134901] Testing event task_newtask: OK
[   12.141568] Testing event softirq_raise: OK
[   12.148243] Testing event softirq_exit: OK
[   12.154901] Testing event softirq_entry: OK
[   12.161572] Testing event irq_handler_exit: OK
[   12.168251] Testing event irq_handler_entry: OK
[   12.174951] Testing event signal_deliver: OK
[   12.181541] Testing event signal_generate: OK
[   12.188225] Testing event workqueue_execute_end: OK
[   12.194888] Testing event workqueue_execute_start: OK
[   12.201525] Testing event workqueue_activate_work: OK
[   12.208226] Testing event workqueue_queue_work: OK
[   12.214851] Testing event sched_wake_idle_without_ipi: OK
[   12.221522] Testing event sched_swap_numa: OK
[   12.228181] Testing event sched_stick_numa: OK
[   12.234846] Testing event sched_move_numa: OK
[   12.241513] Testing event sched_pi_setprio: OK
[   12.248192] Testing event sched_stat_runtime: OK
[   12.254862] Testing event sched_stat_blocked: OK
[   12.261531] Testing event sched_stat_iowait: OK
[   12.268194] Testing event sched_stat_sleep: OK
[   12.274848] Testing event sched_stat_wait: OK
[   12.281537] Testing event sched_process_exec: OK
[   12.288223] Testing event sched_process_fork: OK
[   12.294868] Testing event sched_process_wait: OK
[   12.301535] Testing event sched_wait_task: OK
[   12.308204] Testing event sched_process_exit: OK
[   12.314871] Testing event sched_process_free: OK
[   12.321520] Testing event sched_migrate_task: OK
[   12.328211] Testing event sched_switch: OK
[   12.334850] Testing event sched_wakeup_new: OK
[   12.341517] Testing event sched_wakeup: OK
[   12.348189] Testing event sched_kthread_stop_ret: OK
[   12.354923] Testing event sched_kthread_stop: OK
[   12.361534] Testing event lock_acquired: OK
[   12.368221] Testing event lock_contended: OK
[   12.374871] Testing event lock_release: OK
[   12.381549] Testing event lock_acquire: OK
[   12.388217] Testing event console: OK
[   12.394860] Testing event rcu_barrier: OK
[   12.401510] Testing event rcu_torture_read: OK
[   12.408197] Testing event rcu_batch_end: OK
[   12.414868] Testing event rcu_invoke_kfree_callback: OK
[   12.422075] Testing event rcu_invoke_callback: OK
[   12.428352] Testing event rcu_batch_start: OK
[   12.435510] Testing event rcu_kfree_callback: OK
[   12.442136] Testing event rcu_callback: OK
[   12.448672] Testing event rcu_prep_idle: OK
[   12.455392] Testing event rcu_dyntick: OK
[   12.461992] Testing event rcu_utilization: OK
[   12.468619] Testing event itimer_expire: OK
[   12.474946] Testing event itimer_state: OK
[   12.481589] Testing event hrtimer_cancel: OK
[   12.488304] Testing event hrtimer_expire_exit: OK
[   12.494910] Testing event hrtimer_expire_entry: OK
[   12.501579] Testing event hrtimer_start: OK
[   12.508247] Testing event hrtimer_init: OK
[   12.514908] Testing event timer_cancel: OK
[   12.521597] Testing event timer_expire_exit: OK
[   12.528251] Testing event timer_expire_entry: OK
[   12.534910] Testing event timer_start: OK
[   12.541616] Testing event timer_init: OK
[   12.548343] Testing event module_request: OK
[   12.554911] Testing event module_free: OK
[   12.561577] Testing event module_load: OK
[   12.568252] Testing event ftrace_test_filter: OK
[   12.574897] Testing event dev_pm_qos_remove_request: OK
[   12.581577] Testing event dev_pm_qos_update_request: OK
[   12.588261] Testing event dev_pm_qos_add_request: OK
[   12.594871] Testing event pm_qos_update_flags: OK
[   12.601946] Testing event pm_qos_update_target: OK
[   12.608208] Testing event pm_qos_update_request_timeout: OK
[   12.614860] Testing event pm_qos_remove_request: OK
[   12.621526] Testing event pm_qos_update_request: OK
[   12.628210] Testing event pm_qos_add_request: OK
[   12.634887] Testing event power_domain_target: OK
[   12.641522] Testing event clock_set_rate: OK
[   12.648199] Testing event clock_disable: OK
[   12.654858] Testing event clock_enable: OK
[   12.661522] Testing event wakeup_source_deactivate: OK
[   12.668192] Testing event wakeup_source_activate: OK
[   12.674861] Testing event suspend_resume: OK
[   12.681536] Testing event device_pm_callback_end: OK
[   12.688195] Testing event device_pm_callback_start: OK
[   12.694895] Testing event cpu_frequency: OK
[   12.701536] Testing event pstate_sample: OK
[   12.708203] Testing event cpu_idle: OK
[   12.714919] Testing event rpm_return_int: OK
[   12.721560] Testing event rpm_idle: OK
[   12.728208] Testing event rpm_resume: OK
[   12.734859] Testing event rpm_suspend: OK
[   12.741533] Testing event mm_filemap_add_to_page_cache: OK
[   12.748206] Testing event mm_filemap_delete_from_page_cache: OK
[   12.754876] Testing event oom_score_adj_update: OK
[   12.761549] Testing event mm_lru_activate: OK
[   12.768198] Testing event mm_lru_insertion: OK
[   12.774866] Testing event mm_vmscan_lru_shrink_inactive: OK
[   12.781532] Testing event mm_vmscan_writepage: OK
[   12.788202] Testing event mm_vmscan_memcg_isolate: OK
[   12.794857] Testing event mm_vmscan_lru_isolate: OK
[   12.801541] Testing event mm_shrink_slab_end: OK
[   12.808213] Testing event mm_shrink_slab_start: OK
[   12.814866] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   12.821530] Testing event mm_vmscan_memcg_reclaim_end: OK
[   12.828196] Testing event mm_vmscan_direct_reclaim_end: OK
[   12.834872] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   12.841517] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   12.848189] Testing event mm_vmscan_direct_reclaim_begin: OK
[   12.854868] Testing event mm_vmscan_wakeup_kswapd: OK
[   12.861535] Testing event mm_vmscan_kswapd_wake: OK
[   12.868211] Testing event mm_vmscan_kswapd_sleep: OK
[   12.874869] Testing event mm_page_alloc_extfrag: OK
[   12.881529] Testing event mm_page_pcpu_drain: OK
[   12.888207] Testing event mm_page_alloc_zone_locked: OK
[   12.894885] Testing event mm_page_alloc: OK
[   12.901536] Testing event mm_page_free_batched: OK
[   12.908213] Testing event mm_page_free: OK
[   12.914869] Testing event kmem_cache_free: OK
[   12.921530] Testing event kfree: OK
[   12.928205] Testing event kmem_cache_alloc_node: OK
[   12.934883] Testing event kmalloc_node: OK
[   12.941570] Testing event kmem_cache_alloc: OK
[   12.948192] Testing event kmalloc: OK
[   12.954865] Testing event mm_compaction_end: OK
[   12.961537] Testing event mm_compaction_begin: OK
[   12.968208] Testing event mm_compaction_migratepages: OK
[   12.974877] Testing event mm_compaction_isolate_freepages: OK
[   12.981532] Testing event mm_compaction_isolate_migratepages: OK
[   12.988209] Testing event mm_numa_migrate_ratelimit: OK
[   12.994862] Testing event mm_migrate_pages: OK
[   13.001536] Testing event writeback_single_inode: OK
[   13.008209] Testing event writeback_single_inode_start: OK
[   13.014868] Testing event writeback_wait_iff_congested: OK
[   13.021539] Testing event writeback_congestion_wait: OK
[   13.028209] Testing event writeback_sb_inodes_requeue: OK
[   13.034869] Testing event balance_dirty_pages: OK
[   13.041553] Testing event bdi_dirty_ratelimit: OK
[   13.048204] Testing event global_dirty_state: OK
[   13.054866] Testing event writeback_queue_io: OK
[   13.061538] Testing event wbc_writepage: OK
[   13.068212] Testing event writeback_bdi_unregister: OK
[   13.074877] Testing event writeback_bdi_register: OK
[   13.081536] Testing event writeback_wake_background: OK
[   13.088225] Testing event writeback_nowork: OK
[   13.094862] Testing event writeback_pages_written: OK
[   13.101554] Testing event writeback_wait: OK
[   13.108212] Testing event writeback_written: OK
[   13.114874] Testing event writeback_start: OK
[   13.121954] Testing event writeback_exec: OK
[   13.128538] Testing event writeback_queue: OK
[   13.135304] Testing event writeback_write_inode: OK
[   13.141537] Testing event writeback_write_inode_start: OK
[   13.148206] Testing event writeback_dirty_inode: OK
[   13.154884] Testing event writeback_dirty_inode_start: OK
[   13.161536] Testing event writeback_dirty_page: OK
[   13.168252] Testing event swiotlb_bounced: OK
[   13.174871] Testing event gpio_value: OK
[   13.181566] Testing event gpio_direction: OK
[   13.188235] Testing event regulator_set_voltage_complete: OK
[   13.194941] Testing event regulator_set_voltage: OK
[   13.201572] Testing event regulator_disable_complete: OK
[   13.208251] Testing event regulator_disable: OK
[   13.214899] Testing event regulator_enable_complete: OK
[   13.221543] Testing event regulator_enable_delay: OK
[   13.228229] Testing event regulator_enable: OK
[   13.234878] Testing event urandom_read: OK
[   13.241539] Testing event random_read: OK
[   13.248226] Testing event extract_entropy_user: OK
[   13.254878] Testing event extract_entropy: OK
[   13.261533] Testing event get_random_bytes_arch: OK
[   13.268229] Testing event get_random_bytes: OK
[   13.274884] Testing event xfer_secondary_pool: OK
[   13.281548] Testing event add_disk_randomness: OK
[   13.288216] Testing event add_input_randomness: OK
[   13.294868] Testing event debit_entropy: OK
[   13.301539] Testing event push_to_pool: OK
[   13.308212] Testing event credit_entropy_bits: OK
[   13.314905] Testing event mix_pool_bytes_nolock: OK
[   13.321544] Testing event mix_pool_bytes: OK
[   13.328205] Testing event add_device_randomness: OK
[   13.334870] Testing event regcache_drop_region: OK
[   13.341537] Testing event regmap_async_complete_done: OK
[   13.348217] Testing event regmap_async_complete_start: OK
[   13.354876] Testing event regmap_async_io_complete: OK
[   13.361612] Testing event regmap_async_write_start: OK
[   13.368276] Testing event regmap_cache_bypass: OK
[   13.374936] Testing event regmap_cache_only: OK
[   13.381602] Testing event regcache_sync: OK
[   13.388287] Testing event regmap_hw_write_done: OK
[   13.394936] Testing event regmap_hw_write_start: OK
[   13.401601] Testing event regmap_hw_read_done: OK
[   13.408254] Testing event regmap_hw_read_start: OK
[   13.414915] Testing event regmap_reg_read_cache: OK
[   13.421600] Testing event regmap_reg_read: OK
[   13.428212] Testing event regmap_reg_write: OK
[   13.434922] Testing event spi_transfer_stop: OK
[   13.441813] Testing event spi_transfer_start: OK
[   13.448319] Testing event spi_message_done: OK
[   13.454980] Testing event spi_message_start: OK
[   13.461570] Testing event spi_message_submit: OK
[   13.468378] Testing event spi_master_busy: OK
[   13.474990] Testing event spi_master_idle: OK
[   13.481625] Testing event xhci_cmd_completion: OK
[   13.488358] Testing event xhci_address_ctx: OK
[   13.495031] Testing event xhci_dbg_ring_expansion: OK
[   13.501612] Testing event xhci_dbg_init: OK
[   13.508298] Testing event xhci_dbg_cancel_urb: OK
[   13.514920] Testing event xhci_dbg_reset_ep: OK
[   13.521573] Testing event xhci_dbg_quirks: OK
[   13.528298] Testing event xhci_dbg_context_change: OK
[   13.534960] Testing event xhci_dbg_address: OK
[   13.541962] Testing event binder_return: OK
[   13.548364] Testing event binder_command: OK
[   13.555062] Testing event binder_update_page_range: OK
[   13.568898] Testing event binder_transaction_failed_buffer_release: OK
[   13.574871] Testing event binder_transaction_buffer_release: OK
[   13.581558] Testing event binder_transaction_alloc_buf: OK
[   13.588240] Testing event binder_transaction_fd: OK
[   13.594894] Testing event binder_transaction_ref_to_ref: OK
[   13.601555] Testing event binder_transaction_ref_to_node: OK
[   13.608227] Testing event binder_transaction_node_to_ref: OK
[   13.614914] Testing event binder_transaction_received: OK
[   13.621602] Testing event binder_transaction: OK
[   13.628243] Testing event binder_wait_for_work: OK
[   13.634889] Testing event binder_read_done: OK
[   13.641571] Testing event binder_write_done: OK
[   13.648260] Testing event binder_ioctl_done: OK
[   13.654901] Testing event binder_unlock: OK
[   13.661630] Testing event binder_locked: OK
[   13.668338] Testing event binder_lock: OK
[   13.674992] Testing event binder_ioctl: OK
[   13.681560] Testing event udp_fail_queue_rcv_skb: OK
[   13.688233] Testing event sock_exceed_buf_limit: OK
[   13.694895] Testing event sock_rcvqueue_full: OK
[   13.701557] Testing event napi_poll: OK
[   13.708241] Testing event netif_rx_ni_entry: OK
[   13.714949] Testing event netif_rx_entry: OK
[   13.721565] Testing event netif_receive_skb_entry: OK
[   13.728220] Testing event napi_gro_receive_entry: OK
[   13.734877] Testing event napi_gro_frags_entry: OK
[   13.741545] Testing event netif_rx: OK
[   13.748224] Testing event netif_receive_skb: OK
[   13.754888] Testing event net_dev_queue: OK
[   13.761554] Testing event net_dev_xmit: OK
[   13.768228] Testing event net_dev_start_xmit: OK
[   13.774890] Testing event skb_copy_datagram_iovec: OK
[   13.781555] Testing event consume_skb: OK
[   13.788244] Testing event kfree_skb: OK
[   13.794900] Running tests on trace event systems:
[   13.795503] Testing event system skb: OK
[   13.801612] Testing event system net: OK
[   13.808361] Testing event system napi: OK
[   13.814916] Testing event system sock: OK
[   13.821575] Testing event system udp: OK
[   13.828253] Testing event system binder: OK
[   13.835394] Testing event system xhci-hcd: OK
[   13.841770] Testing event system spi: OK
[   13.848325] Testing event system regmap: OK
[   13.855188] Testing event system random: OK
[   13.861738] Testing event system regulator: OK
[   13.868306] Testing event system gpio: OK
[   13.874960] Testing event system swiotlb: OK
[   13.881566] Testing event system writeback: OK
[   13.888578] Testing event system migrate: OK
[   13.894902] Testing event system compaction: OK
[   13.901621] Testing event system kmem: OK
[   13.908432] Testing event system vmscan: OK
[   13.915040] Testing event system pagemap: OK
[   13.921607] Testing event system oom: OK
[   13.928270] Testing event system filemap: OK
[   13.934921] Testing event system rpm: OK
[   13.941643] Testing event system power: OK
[   13.948454] Testing event system test: OK
[   13.954909] Testing event system module: OK
[   13.961614] Testing event system timer: OK
[   13.968523] Testing event system rcu: OK
[   13.975078] Testing event system printk: OK
[   13.981577] Testing event system lock: OK
[   13.988356] Testing event system sched: OK
[   13.995065] Testing event system workqueue: OK
[   14.001637] Testing event system signal: OK
[   14.008301] Testing event system irq: OK
[   14.014998] Testing event system task: OK
[   14.021612] Testing event system exceptions: OK
[   14.028262] Testing event system tlb: OK
[   14.034920] Testing event system mce: OK
[   14.041566] Testing event system raw_syscalls: OK
[   14.048265] Testing event system vsyscall: OK
[   14.054928] Testing event system nmi: OK
[   14.061570] Testing event system irq_vectors: OK
[   14.068429] Running tests on all trace events:
[   14.068957] Testing all events: OK
[   14.153174] Running tests again, along with the function tracer
[   14.154149] Running tests on trace events:
[   14.154829] Testing event thermal_apic_exit: OK
[   14.161863] Testing event thermal_apic_entry: OK
[   14.168521] Testing event threshold_apic_exit: OK
[   14.175021] Testing event threshold_apic_entry: OK
[   14.181768] Testing event call_function_single_exit: OK
[   14.188395] Testing event call_function_single_entry: OK
[   14.195022] Testing event call_function_exit: OK
[   14.201831] Testing event call_function_entry: OK
[   14.208546] Testing event irq_work_exit: OK
[   14.215342] Testing event irq_work_entry: OK
[   14.222260] Testing event x86_platform_ipi_exit: OK
[   14.228556] Testing event x86_platform_ipi_entry: OK
[   14.235836] Testing event error_apic_exit: OK
[   14.241890] Testing event error_apic_entry: OK
[   14.248614] Testing event spurious_apic_exit: OK
[   14.255255] Testing event spurious_apic_entry: OK
[   14.261907] Testing event reschedule_exit: OK
[   14.268530] Testing event reschedule_entry: OK
[   14.275177] Testing event local_timer_exit: OK
[   14.281877] Testing event local_timer_entry: OK
[   14.288573] Testing event nmi_handler: OK
[   14.295228] Testing event emulate_vsyscall: OK
[   14.301903] Testing event sys_exit: OK
[   14.308670] Testing event sys_enter: OK
[   14.315240] Testing event mce_record: OK
[   14.321902] Testing event tlb_flush: OK
[   14.328652] Testing event page_fault_kernel: OK
[   14.335255] Testing event page_fault_user: OK
[   14.341912] Testing event task_rename: OK
[   14.348562] Testing event task_newtask: OK
[   14.355228] Testing event softirq_raise: OK
[   14.361876] Testing event softirq_exit: OK
[   14.368614] Testing event softirq_entry: OK
[   14.375249] Testing event irq_handler_exit: OK
[   14.381960] Testing event irq_handler_entry: OK
[   14.388734] Testing event signal_deliver: OK
[   14.395228] Testing event signal_generate: OK
[   14.401955] Testing event workqueue_execute_end: OK
[   14.408560] Testing event workqueue_execute_start: OK
[   14.415231] Testing event workqueue_activate_work: OK
[   14.421920] Testing event workqueue_queue_work: OK
[   14.428592] Testing event sched_wake_idle_without_ipi: OK
[   14.435185] Testing event sched_swap_numa: OK
[   14.442302] Testing event sched_stick_numa: OK
[   14.448548] Testing event sched_move_numa: OK
[   14.455213] Testing event sched_pi_setprio: OK
[   14.461901] Testing event sched_stat_runtime: OK
[   14.468590] Testing event sched_stat_blocked: OK
[   14.475219] Testing event sched_stat_iowait: OK
[   14.481879] Testing event sched_stat_sleep: OK
[   14.488544] Testing event sched_stat_wait: OK
[   14.495220] Testing event sched_process_exec: OK
[   14.502229] Testing event sched_process_fork: OK
[   14.508597] Testing event sched_process_wait: OK
[   14.515258] Testing event sched_wait_task: OK
[   14.521846] Testing event sched_process_exit: OK
[   14.528496] Testing event sched_process_free: OK
[   14.535150] Testing event sched_migrate_task: OK
[   14.541776] Testing event sched_switch: OK
[   14.548445] Testing event sched_wakeup_new: OK
[   14.555119] Testing event sched_wakeup: OK
[   14.562457] Testing event sched_kthread_stop_ret: OK
[   14.569155] Testing event sched_kthread_stop: OK
[   14.575503] Testing event lock_acquired: OK
[   14.581912] Testing event lock_contended: OK
[   14.588548] Testing event lock_release: OK
[   14.595238] Testing event lock_acquire: OK
[   14.601901] Testing event console: OK
[   14.608549] Testing event rcu_barrier: OK
[   14.615176] Testing event rcu_torture_read: OK
[   14.623203] Testing event rcu_batch_end: OK
[   14.628524] Testing event rcu_invoke_kfree_callback: OK
[   14.635250] Testing event rcu_invoke_callback: OK
[   14.641869] Testing event rcu_batch_start: OK
[   14.648437] Testing event rcu_kfree_callback: OK
[   14.655182] Testing event rcu_callback: OK
[   14.661942] Testing event rcu_prep_idle: OK
[   14.668550] Testing event rcu_dyntick: OK
[   14.675447] Testing event rcu_utilization: OK
[   14.681879] Testing event itimer_expire: OK
[   14.688621] Testing event itimer_state: OK
[   14.695262] Testing event hrtimer_cancel: OK
[   14.701995] Testing event hrtimer_expire_exit: OK
[   14.708777] Testing event hrtimer_expire_entry: OK
[   14.715222] Testing event hrtimer_start: OK
[   14.721886] Testing event hrtimer_init: OK
[   14.728935] Testing event timer_cancel: OK
[   14.735323] Testing event timer_expire_exit: OK
[   14.741915] Testing event timer_expire_entry: OK
[   14.748403] Testing event timer_start: OK
[   14.755147] Testing event timer_init: OK
[   14.761736] Testing event module_request: OK
[   14.768412] Testing event module_free: OK
[   14.775066] Testing event module_load: OK
[   14.781717] Testing event ftrace_test_filter: OK
[   14.788376] Testing event dev_pm_qos_remove_request: OK
[   14.795060] Testing event dev_pm_qos_update_request: OK
[   14.804241] Testing event dev_pm_qos_add_request: OK
[   14.811860] Testing event pm_qos_update_flags: OK
[   14.818521] Testing event pm_qos_update_target: OK
[   14.827680] Testing event pm_qos_update_request_timeout: OK
[   14.835244] Testing event pm_qos_remove_request: OK
[   14.841716] Testing event pm_qos_update_request: OK
[   14.848375] Testing event pm_qos_add_request: OK
[   14.855046] Testing event power_domain_target: OK
[   14.861678] Testing event clock_set_rate: OK
[   14.868380] Testing event clock_disable: OK
[   14.875238] Testing event clock_enable: OK
[   14.881708] Testing event wakeup_source_deactivate: OK
[   14.888383] Testing event wakeup_source_activate: OK
[   14.895023] Testing event suspend_resume: OK
[   14.901689] Testing event device_pm_callback_end: OK
[   14.908360] Testing event device_pm_callback_start: OK
[   14.915215] Testing event cpu_frequency: OK
[   14.921912] Testing event pstate_sample: OK
[   14.928510] Testing event cpu_idle: OK
[   14.935463] Testing event rpm_return_int: OK
[   14.942033] Testing event rpm_idle: OK
[   14.948607] Testing event rpm_resume: OK
[   14.955423] Testing event rpm_suspend: OK
[   14.961918] Testing event mm_filemap_add_to_page_cache: OK
[   14.968406] Testing event mm_filemap_delete_from_page_cache: OK
[   14.975055] Testing event oom_score_adj_update: OK
[   14.981757] Testing event mm_lru_activate: OK
[   14.988406] Testing event mm_lru_insertion: OK
[   14.995058] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.001855] Testing event mm_vmscan_writepage: OK
[   15.008409] Testing event mm_vmscan_memcg_isolate: OK
[   15.015039] Testing event mm_vmscan_lru_isolate: OK
[   15.021723] Testing event mm_shrink_slab_end: OK
[   15.028402] Testing event mm_shrink_slab_start: OK
[   15.035075] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.041703] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.048375] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.055061] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.061702] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.068378] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.075422] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.082194] Testing event mm_vmscan_kswapd_wake: OK
[   15.088522] Testing event mm_vmscan_kswapd_sleep: OK
[   15.095183] Testing event mm_page_alloc_extfrag: OK
[   15.101844] Testing event mm_page_pcpu_drain: OK
[   15.108541] Testing event mm_page_alloc_zone_locked: OK
[   15.115274] Testing event mm_page_alloc: OK
[   15.121918] Testing event mm_page_free_batched: OK
[   15.128570] Testing event mm_page_free: OK
[   15.135238] Testing event kmem_cache_free: OK
[   15.141899] Testing event kfree: OK
[   15.148569] Testing event kmem_cache_alloc_node: OK
[   15.155276] Testing event kmalloc_node: OK
[   15.162027] Testing event kmem_cache_alloc: OK
[   15.168543] Testing event kmalloc: OK
[   15.175257] Testing event mm_compaction_end: OK
[   15.181902] Testing event mm_compaction_begin: OK
[   15.188587] Testing event mm_compaction_migratepages: OK
[   15.195242] Testing event mm_compaction_isolate_freepages: OK
[   15.202217] Testing event mm_compaction_isolate_migratepages: OK
[   15.208976] Testing event mm_numa_migrate_ratelimit: OK
[   15.215221] Testing event mm_migrate_pages: OK
[   15.227128] Testing event writeback_single_inode: OK
[   15.245594] Testing event writeback_single_inode_start: OK
[   15.251852] Testing event writeback_wait_iff_congested: OK
[   15.258526] Testing event writeback_congestion_wait: OK
[   15.265197] Testing event writeback_sb_inodes_requeue: OK
[   15.271853] Testing event balance_dirty_pages: OK
[   15.278588] Testing event bdi_dirty_ratelimit: OK
[   15.285179] Testing event global_dirty_state: OK
[   15.291849] Testing event writeback_queue_io: OK
[   15.298532] Testing event wbc_writepage: OK
[   15.305180] Testing event writeback_bdi_unregister: OK
[   15.311858] Testing event writeback_bdi_register: OK
[   15.318512] Testing event writeback_wake_background: OK
[   15.325182] Testing event writeback_nowork: OK
[   15.331873] Testing event writeback_pages_written: OK
[   15.338575] Testing event writeback_wait: OK
[   15.345177] Testing event writeback_written: OK
[   15.351843] Testing event writeback_start: OK
[   15.358536] Testing event writeback_exec: OK
[   15.365267] Testing event writeback_queue: OK
[   15.371925] Testing event writeback_write_inode: OK
[   15.378618] Testing event writeback_write_inode_start: OK
[   15.385268] Testing event writeback_dirty_inode: OK
[   15.391914] Testing event writeback_dirty_inode_start: OK
[   15.398569] Testing event writeback_dirty_page: OK
[   15.405259] Testing event swiotlb_bounced: OK
[   15.411888] Testing event gpio_value: OK
[   15.418685] Testing event gpio_direction: OK
[   15.425397] Testing event regulator_set_voltage_complete: OK
[   15.431961] Testing event regulator_set_voltage: OK
[   15.438613] Testing event regulator_disable_complete: OK
[   15.449943] Testing event regulator_disable: OK
[   15.455262] Testing event regulator_enable_complete: OK
[   15.461920] Testing event regulator_enable_delay: OK
[   15.468619] Testing event regulator_enable: OK
[   15.475305] Testing event urandom_read: OK
[   15.482036] Testing event random_read: OK
[   15.488560] Testing event extract_entropy_user: OK
[   15.495550] Testing event extract_entropy: OK
[   15.501851] Testing event get_random_bytes_arch: OK
[   15.511814] Testing event get_random_bytes: OK
[   15.518587] Testing event xfer_secondary_pool: OK
[   15.525627] Testing event add_disk_randomness: OK
[   15.532250] Testing event add_input_randomness: OK
[   15.542632] Testing event debit_entropy: OK
[   15.548573] Testing event push_to_pool: OK
[   15.555245] Testing event credit_entropy_bits: OK
[   15.561916] Testing event mix_pool_bytes_nolock: OK
[   15.568562] Testing event mix_pool_bytes: OK
[   15.575233] Testing event add_device_randomness: OK
[   15.581916] Testing event regcache_drop_region: OK
[   15.588551] Testing event regmap_async_complete_done: OK
[   15.595223] Testing event regmap_async_complete_start: OK
[   15.601903] Testing event regmap_async_io_complete: OK
[   15.608705] Testing event regmap_async_write_start: OK
[   15.615241] Testing event regmap_cache_bypass: OK
[   15.621895] Testing event regmap_cache_only: OK
[   15.628456] Testing event regcache_sync: OK
[   15.635431] Testing event regmap_hw_write_done: OK
[   15.641746] Testing event regmap_hw_write_start: OK
[   15.648637] Testing event regmap_hw_read_done: OK
[   15.655493] Testing event regmap_hw_read_start: OK
[   15.661728] Testing event regmap_reg_read_cache: OK
[   15.668424] Testing event regmap_reg_read: OK
[   15.675902] Testing event regmap_reg_write: OK
[   15.682659] Testing event spi_transfer_stop: OK
[   15.688639] Testing event spi_transfer_start: OK
[   15.695250] Testing event spi_message_done: OK
[   15.701914] Testing event spi_message_start: OK
[   15.708627] Testing event spi_message_submit: OK
[   15.715245] Testing event spi_master_busy: OK
[   15.721918] Testing event spi_master_idle: OK
[   15.728592] Testing event xhci_cmd_completion: OK
[   15.735100] Testing event xhci_address_ctx: OK
[   15.741832] Testing event xhci_dbg_ring_expansion: OK
[   15.748441] Testing event xhci_dbg_init: OK
[   15.755091] Testing event xhci_dbg_cancel_urb: OK
[   15.761757] Testing event xhci_dbg_reset_ep: OK
[   15.768427] Testing event xhci_dbg_quirks: OK
[   15.775152] Testing event xhci_dbg_context_change: OK
[   15.781916] Testing event xhci_dbg_address: OK
[   15.788555] Testing event binder_return: OK
[   15.795233] Testing event binder_command: OK
[   15.802370] Testing event binder_update_page_range: OK
[   15.809713] Testing event binder_transaction_failed_buffer_release: OK
[   15.818592] Testing event binder_transaction_buffer_release: OK
[   15.825622] Testing event binder_transaction_alloc_buf: OK
[   15.831947] Testing event binder_transaction_fd: OK
[   15.838720] Testing event binder_transaction_ref_to_ref: OK
[   15.845243] Testing event binder_transaction_ref_to_node: OK
[   15.851917] Testing event binder_transaction_node_to_ref: OK
[   15.858762] Testing event binder_transaction_received: OK
[   15.865273] Testing event binder_transaction: OK
[   15.871927] Testing event binder_wait_for_work: OK
[   15.878576] Testing event binder_read_done: OK
[   15.885263] Testing event binder_write_done: OK
[   15.891933] Testing event binder_ioctl_done: OK
[   15.898610] Testing event binder_unlock: OK
[   15.905893] Testing event binder_locked: OK
[   15.912203] Testing event binder_lock: OK
[   15.918842] Testing event binder_ioctl: OK
[   15.925535] Testing event udp_fail_queue_rcv_skb: OK
[   15.931911] Testing event sock_exceed_buf_limit: OK
[   15.938547] Testing event sock_rcvqueue_full: OK
[   15.945237] Testing event napi_poll: OK
[   15.951879] Testing event netif_rx_ni_entry: OK
[   15.958571] Testing event netif_rx_entry: OK
[   15.965263] Testing event netif_receive_skb_entry: OK
[   15.971889] Testing event napi_gro_receive_entry: OK
[   15.978719] Testing event napi_gro_frags_entry: OK
[   15.985253] Testing event netif_rx: OK
[   15.991947] Testing event netif_receive_skb: OK
[   15.998557] Testing event net_dev_queue: OK
[   16.005239] Testing event net_dev_xmit: OK
[   16.011876] Testing event net_dev_start_xmit: OK
[   16.018547] Testing event skb_copy_datagram_iovec: OK
[   16.025216] Testing event consume_skb: OK
[   16.031999] Testing event kfree_skb: OK
[   16.038691] Running tests on trace event systems:
[   16.039494] Testing event system skb: OK
[   16.045465] Testing event system net: OK
[   16.052523] Testing event system napi: OK
[   16.058599] Testing event system sock: OK
[   16.065335] Testing event system udp: OK
[   16.071907] Testing event system binder: OK
[   16.083896] Testing event system xhci-hcd: OK
[   16.092710] Testing event system spi: OK
[   16.099040] Testing event system regmap: OK
[   16.106238] Testing event system random: OK
[   16.116080] Testing event system regulator: OK
[   16.122201] Testing event system gpio: OK
[   16.128825] Testing event system swiotlb: OK
[   16.136360] Testing event system writeback: OK
[   16.146874] Testing event system migrate: OK
[   16.157376] Testing event system compaction: OK
[   16.165753] Testing event system kmem: OK
[   16.181560] Testing event system vmscan: OK
[   16.189061] Testing event system pagemap: OK
[   16.195267] Testing event system oom: OK
[   16.201925] Testing event system filemap: OK
[   16.208630] Testing event system rpm: OK
[   16.215512] Testing event system power: OK
[   16.222811] Testing event system test: OK
[   16.228565] Testing event system module: OK
[   16.235357] Testing event system timer: OK
[   16.242927] Testing event system rcu: OK
[   16.252745] Testing event system printk: OK
[   16.258830] Testing event system lock: OK
[   16.265809] Testing event system sched: OK
[   16.272978] Testing event system workqueue: OK
[   16.278880] Testing event system signal: OK
[   16.288854] Testing event system irq: OK
[   16.298894] Testing event system task: OK
[   16.308637] Testing event system exceptions: OK
[   16.316193] Testing event system tlb: OK
[   16.321930] Testing event system mce: OK
[   16.328547] Testing event system raw_syscalls: OK
[   16.335261] Testing event system vsyscall: OK
[   16.341926] Testing event system nmi: OK
[   16.348627] Testing event system irq_vectors: OK
[   16.355884] Running tests on all trace events:
[   16.356644] Testing all events:=20
[   16.360343] BUG: scheduling while atomic: swapper/1/0x00200003
[   16.361570] 2 locks held by swapper/1:
[   16.362263]  #0:  (event_mutex){+.+.+.}, at: [<ffffffff8113082d>] __ftra=
ce_set_clr_event+0x2d/0x60
[   16.363863]  #1:  (tracepoints_mutex){+.+.+.}, at: [<ffffffff81115f2d>] =
tracepoint_probe_register+0x2d/0x2c0
[   16.367604] Modules linked in:
[   16.368292] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.369855]  0000000000000000 ffff88001345fab8 ffffffff816356b2 ffff8800=
1345fad8
[   16.371237]  ffffffff810b141f 0000000000000000 ffffffff81e14a00 ffff8800=
1345fbe8
[   16.374882]  ffffffff81636ed5 ffff880013458000 ffff88001345ffd8 ffff8800=
13458000
[   16.376302] Call Trace:
[   16.376762]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.377642]  [<ffffffff810b141f>] __schedule_bug+0x5f/0x80
[   16.380650]  [<ffffffff81636ed5>] __schedule+0xd5/0x8b0
[   16.381550]  [<ffffffff810062a0>] ? perf_trace_nmi_handler+0xd0/0xd0
[   16.382672]  [<ffffffffa000a06b>] ? 0xffffffffa000a06b
[   16.383535]  [<ffffffff81636e00>] ? __sched_text_start+0x8/0x8
[   16.384526]  [<ffffffff8163788f>] ? _cond_resched+0x3f/0x70
[   16.387542]  [<ffffffff81637850>] ? io_schedule+0x50/0x50
[   16.388557]  [<ffffffff81639904>] ? mutex_lock_nested+0x34/0x440
[   16.389631]  [<ffffffff81006200>] ? perf_trace_nmi_handler+0x30/0xd0
[   16.390724]  [<ffffffff8111cd41>] ? ftrace_ops_list_func+0x151/0x210
[   16.393785]  [<ffffffff810062a0>] ? perf_trace_nmi_handler+0xd0/0xd0
[   16.394855]  [<ffffffff8163788f>] _cond_resched+0x3f/0x70
[   16.395811]  [<ffffffffa000a06b>] ? 0xffffffffa000a06b
[   16.396647]  [<ffffffff81639904>] mutex_lock_nested+0x34/0x440
[   16.397616]  [<ffffffff811161a5>] ? tracepoint_probe_register+0x2a5/0x2c0
[   16.399525]  [<ffffffff810062a0>] ? perf_trace_nmi_handler+0xd0/0xd0
[   16.400591]  [<ffffffff81156ba6>] static_key_slow_inc+0xc6/0x140
[   16.401849]  [<ffffffff811161a5>] tracepoint_probe_register+0x2a5/0x2c0
[   16.402938]  [<ffffffff810062a0>] ? perf_trace_nmi_handler+0xd0/0xd0
[   16.403986]  [<ffffffff811302fc>] ftrace_event_reg+0x11c/0x150
[   16.404983]  [<ffffffff8113058e>] __ftrace_event_enable_disable+0x5e/0x1=
b0
[   16.407745]  [<ffffffff8113082d>] ? __ftrace_set_clr_event+0x2d/0x60
[   16.408771]  [<ffffffff811307b4>] __ftrace_set_clr_event_nolock+0xd4/0x1=
20
[   16.409929]  [<ffffffff81130842>] __ftrace_set_clr_event+0x42/0x60
[   16.410970]  [<ffffffff81f0c0bf>] event_trace_self_tests+0x2b4/0x51c
[   16.413899]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.414781]  [<ffffffff81f0c499>] event_trace_self_tests_init+0x8c/0xa2
[   16.415866]  [<ffffffff810002b0>] do_one_initcall+0x90/0x200
[   16.416824]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.417796]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.418687]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.420586]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.421518]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.444107] BUG: scheduling while atomic: swapper/1/0x0000000b
[   16.445090] no locks held by swapper/1.
[   16.445704] Modules linked in:
[   16.446236] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.447411]  0000000000000000 ffff88001345fa08 ffffffff816356b2 ffff8800=
1345fa28
[   16.448247]  ffffffff810b141f 0000000000000000 7fffffffffffff00 ffff8800=
1345fb38
[   16.449048]  ffffffff81636ed5 ffff880013458000 ffff88001345ffd8 ffff8800=
13458000
[   16.449862] Call Trace:
[   16.450133]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.450647]  [<ffffffff810b141f>] __schedule_bug+0x5f/0x80
[   16.451198]  [<ffffffff81636ed5>] __schedule+0xd5/0x8b0
[   16.451747]  [<ffffffffa000a06b>] ? 0xffffffffa000a06b
[   16.452267]  [<ffffffff81636e00>] ? __sched_text_start+0x8/0x8
[   16.452845]  [<ffffffff816376c9>] ? schedule+0x19/0x20
[   16.453363]  [<ffffffff8163bcb4>] ? schedule_timeout+0x1a4/0x210
[   16.453959]  [<ffffffff8113227a>] ? function_test_events_call+0xaa/0xb0
[   16.454655]  [<ffffffff816376c9>] schedule+0x19/0x20
[   16.455185]  [<ffffffff8163bcb4>] schedule_timeout+0x1a4/0x210
[   16.455765]  [<ffffffff8163bb10>] ? console_conditional_schedule+0x30/0x=
30
[   16.456447]  [<ffffffff81638287>] ? wait_for_common+0x117/0x1d0
[   16.457031]  [<ffffffff810b6455>] ? sched_clock_cpu+0x85/0x90
[   16.457609]  [<ffffffff8163ca90>] ? _raw_spin_unlock_irq+0x30/0x50
[   16.458253]  [<ffffffff81638287>] wait_for_common+0x117/0x1d0
[   16.458832]  [<ffffffff810b29e0>] ? wake_up_process+0x80/0x80
[   16.459412]  [<ffffffff81f0c327>] ? event_trace_self_tests+0x51c/0x51c
[   16.460060]  [<ffffffff816383fd>] wait_for_completion_killable+0x1d/0x40
[   16.460729]  [<ffffffff810aa91f>] kthread_create_on_node+0x16f/0x250
[   16.461362]  [<ffffffff810aa7b0>] ? __kthread_parkme+0x80/0x80
[   16.461972]  [<ffffffff816381b3>] ? wait_for_common+0x43/0x1d0
[   16.462576]  [<ffffffff81f0bdc8>] event_test_stuff+0x21/0x64
[   16.463145]  [<ffffffff81f0c264>] event_trace_self_tests+0x459/0x51c
[   16.463775]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.464337]  [<ffffffff81f0c499>] event_trace_self_tests_init+0x8c/0xa2
[   16.465015]  [<ffffffff810002b0>] do_one_initcall+0x90/0x200
[   16.465592]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.466207]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.466728]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.467277]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.467818]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.468535] BUG: scheduling while atomic: swapper/1/0x0000000c
[   16.469120] no locks held by swapper/1.
[   16.469503] Modules linked in:
[   16.469836] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.470707]  0000000000000000 ffff88001345fbd8 ffffffff816356b2 ffff8800=
1345fbf8
[   16.471543]  ffffffff810b141f 0000000000000000 ffffffff82d46e00 ffff8800=
1345fd08
[   16.472348]  ffffffff81636ed5 ffff880013458000 ffff88001345ffd8 ffff8800=
13458000
[   16.473153] Call Trace:
[   16.473414]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.473956]  [<ffffffff810b141f>] __schedule_bug+0x5f/0x80
[   16.474510]  [<ffffffff81636ed5>] __schedule+0xd5/0x8b0
[   16.475064]  [<ffffffffa000a06b>] ? 0xffffffffa000a06b
[   16.475584]  [<ffffffff81636e00>] ? __sched_text_start+0x8/0x8
[   16.476164]  [<ffffffff816376c9>] ? schedule+0x19/0x20
[   16.476676]  [<ffffffff8163bc27>] ? schedule_timeout+0x117/0x210
[   16.477305]  [<ffffffff810b6455>] ? sched_clock_cpu+0x85/0x90
[   16.477884]  [<ffffffff816376c9>] schedule+0x19/0x20
[   16.478408]  [<ffffffff8163bc27>] schedule_timeout+0x117/0x210
[   16.478988]  [<ffffffff8163bb10>] ? console_conditional_schedule+0x30/0x=
30
[   16.479674]  [<ffffffff810dd8b7>] ? msleep+0x37/0x50
[   16.480178]  [<ffffffff810dcdb0>] ? add_timer_on+0x100/0x100
[   16.480779]  [<ffffffff810dd8b7>] msleep+0x37/0x50
[   16.481266]  [<ffffffff81f0bdfe>] event_test_stuff+0x57/0x64
[   16.481854]  [<ffffffff81f0c264>] event_trace_self_tests+0x459/0x51c
[   16.482489]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.483009]  [<ffffffff81f0c499>] event_trace_self_tests_init+0x8c/0xa2
[   16.483697]  [<ffffffff810002b0>] do_one_initcall+0x90/0x200
[   16.484270]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.484900]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.485426]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.485935]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.486476]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.487112] BUG: scheduling while atomic: swapper/1/0x0000000d
[   16.487688] no locks held by swapper/1.
[   16.488100] Modules linked in:
[   16.488495] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.489360]  0000000000000000 ffff88001345fb28 ffffffff816356b2 ffff8800=
1345fb48
[   16.490170]  ffffffff810b141f 0000000000000000 7fffffffffffff00 ffff8800=
1345fc58
[   16.491005]  ffffffff81636ed5 ffff880013458000 ffff88001345ffd8 ffff8800=
13458000
[   16.491859] Call Trace:
[   16.492129]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.492643]  [<ffffffff810b141f>] __schedule_bug+0x5f/0x80
[   16.493194]  [<ffffffff81636ed5>] __schedule+0xd5/0x8b0
[   16.493754]  [<ffffffffa000a06b>] ? 0xffffffffa000a06b
[   16.494272]  [<ffffffff81636e00>] ? __sched_text_start+0x8/0x8
[   16.494874]  [<ffffffff816376c9>] ? schedule+0x19/0x20
[   16.495394]  [<ffffffff8163bcb4>] ? schedule_timeout+0x1a4/0x210
[   16.495988]  [<ffffffff8113227a>] ? function_test_events_call+0xaa/0xb0
[   16.496658]  [<ffffffff816376c9>] schedule+0x19/0x20
[   16.497192]  [<ffffffff8163bcb4>] schedule_timeout+0x1a4/0x210
[   16.497769]  [<ffffffff8163bb10>] ? console_conditional_schedule+0x30/0x=
30
[   16.498477]  [<ffffffff81638287>] ? wait_for_common+0x117/0x1d0
[   16.499062]  [<ffffffff810b6455>] ? sched_clock_cpu+0x85/0x90
[   16.499637]  [<ffffffff8163ca90>] ? _raw_spin_unlock_irq+0x30/0x50
[   16.500268]  [<ffffffff81638287>] wait_for_common+0x117/0x1d0
[   16.500868]  [<ffffffff810b29e0>] ? wake_up_process+0x80/0x80
[   16.501478]  [<ffffffff8163835d>] wait_for_completion+0x1d/0x20
[   16.502065]  [<ffffffff810aaa93>] kthread_stop+0x63/0x140
[   16.502612]  [<ffffffff81f0be06>] event_test_stuff+0x5f/0x64
[   16.503182]  [<ffffffff81f0c264>] event_trace_self_tests+0x459/0x51c
[   16.503847]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.504550]  [<ffffffff81f0c499>] event_trace_self_tests_init+0x8c/0xa2
[   16.505714]  [<ffffffff810002b0>] do_one_initcall+0x90/0x200
[   16.506662]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.507638]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.508513]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.509336]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.510198]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.523163] OK
[   16.570645] BUG: scheduling while atomic: swapper/1/0x0000000e
[   16.571176] 1 lock held by swapper/1:
[   16.571547]  #0:  (ftrace_lock){+.+.+.}, at: [<ffffffff8111b6da>] unregi=
ster_ftrace_function+0x1a/0x40
[   16.572379] Modules linked in:
[   16.572782] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.573957]  0000000000000000 ffff88001345fa48 ffffffff816356b2 ffff8800=
1345fa68
[   16.575030]  ffffffff810b141f 0000000000000000 7fffffffffffff00 ffff8800=
1345fb78
[   16.576119]  ffffffff81636ed5 ffff880013458000 ffff88001345ffd8 ffff8800=
13458000
[   16.576914] Call Trace:
[   16.577132]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.577591]  [<ffffffff810b141f>] __schedule_bug+0x5f/0x80
[   16.578039]  [<ffffffff81636ed5>] __schedule+0xd5/0x8b0
[   16.578493]  [<ffffffff81035c37>] ? kvm_clock_read+0x17/0x20
[   16.578964]  [<ffffffff8100bde9>] ? sched_clock+0x9/0x10
[   16.579600]  [<ffffffff810b6278>] ? sched_clock_local+0x38/0xb0
[   16.580561]  [<ffffffff81036c0f>] ? pvclock_clocksource_read+0x8f/0x140
[   16.581454]  [<ffffffff816376c9>] schedule+0x19/0x20
[   16.582143]  [<ffffffff8163bcb4>] schedule_timeout+0x1a4/0x210
[   16.582917]  [<ffffffff810c3bc9>] ? mark_held_locks+0x79/0xb0
[   16.583432]  [<ffffffff8163ca90>] ? _raw_spin_unlock_irq+0x30/0x50
[   16.583939]  [<ffffffff81638287>] wait_for_common+0x117/0x1d0
[   16.584449]  [<ffffffff810b29e0>] ? wake_up_process+0x80/0x80
[   16.584929]  [<ffffffff8163835d>] wait_for_completion+0x1d/0x20
[   16.585424]  [<ffffffff810a5ad5>] flush_work+0x1e5/0x2a0
[   16.585921]  [<ffffffff810a5b60>] ? flush_work+0x270/0x2a0
[   16.586678]  [<ffffffff810a15c0>] ? destroy_worker+0x1f0/0x1f0
[   16.587470]  [<ffffffff810c3bc9>] ? mark_held_locks+0x79/0xb0
[   16.588249]  [<ffffffff816381b3>] ? wait_for_common+0x43/0x1d0
[   16.589043]  [<ffffffff81116b20>] ? ftrace_pid_func+0x30/0x30
[   16.589780]  [<ffffffff810a6bd5>] schedule_on_each_cpu+0x75/0x90
[   16.590292]  [<ffffffff8111b443>] ftrace_shutdown+0x333/0x5b0
[   16.590891]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.591328]  [<ffffffff8111b6e2>] unregister_ftrace_function+0x22/0x40
[   16.591872]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.592310]  [<ffffffff81f0c4a5>] event_trace_self_tests_init+0x98/0xa2
[   16.593128]  [<ffffffff810002b0>] do_one_initcall+0x90/0x200
[   16.593904]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.594719]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.595466]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.596158]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.596654]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.597174] ------------[ cut here ]------------
[   16.597594] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x=
1a9/0x200()
[   16.598351] initcall event_trace_self_tests_init+0x0/0xa2 returned with =
preemption imbalance=20
[   16.599046] Modules linked in:
[   16.599454] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-=
rc1-00020-g716c18f #58
[   16.600618]  0000000000000009 ffff88001345fdf8 ffffffff816356b2 ffff8800=
1345fe38
[   16.601697]  ffffffff8108da6a ffff88001345fe18 0000000000000000 00000000=
00000001
[   16.602764]  0000000000000001 ffffffff81f0c40d 0000000000000000 ffff8800=
1345fe98
[   16.603493] Call Trace:
[   16.603703]  [<ffffffff816356b2>] dump_stack+0x19/0x1b
[   16.604162]  [<ffffffff8108da6a>] warn_slowpath_common+0x7a/0xa0
[   16.604655]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.605099]  [<ffffffff8108dad6>] warn_slowpath_fmt+0x46/0x50
[   16.605585]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.606207]  [<ffffffff81f0c40d>] ? test_work+0x64/0x64
[   16.606944]  [<ffffffff810003c9>] do_one_initcall+0x1a9/0x200
[   16.607716]  [<ffffffff81ef10f1>] kernel_init_freeable+0x102/0x185
[   16.608575]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.609319]  [<ffffffff81631e9e>] kernel_init+0xe/0xf0
[   16.609891]  [<ffffffff8163d77a>] ret_from_fork+0x7a/0xb0
[   16.610502]  [<ffffffff81631e90>] ? rest_init+0xd0/0xd0
[   16.611237] ---[ end trace 660d24cf53fa6cb1 ]---
[   16.611898] Testing ftrace filter: OK
[   16.615362] Testing kprobe tracing: OK
[   16.619321] kAFS: Red Hat AFS client v0.1 registering.
[   16.620871] Key type encrypted registered
[   16.622071] ima: No TPM chip found, activating TPM-bypass!
[   16.624058] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   16.624909] EDD information not available.
[   16.626641] debug: unmapping init [mem 0xffffffff81ef0000-0xffffffff81fd=
3fff]
[   16.627705] Write protecting the kernel read-only data: 12288k
[   16.629067] debug: unmapping init [mem 0xffff880001641000-0xffff8800017f=
ffff]
[   16.630234] debug: unmapping init [mem 0xffff880001b43000-0xffff880001bf=
ffff]
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
mount: mounting none on /dev failed: Invalid argument
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
udevd[745]: inotify_init failed: Function not implemented
error initializing inotify
udevd[745]: error initializing inotify
error sending message: Connection refused
udevadm[746]: error sending message: Connection refused
error sending message: Connection refused
udevadm[748]: error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
/etc/init.d/rc: eval: line 1: can't create /dev/tty0: No such device or add=
ress
Configuring network interfaces... done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.18.0-rc1-00020-g716c18f/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-ib0-11191438/716c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-0=
0020-g716c18f -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b0-11191438/linux-devel:devel-lkp-ib04-smoke-201411191439:716c18f8e57c5eff4=
725f0b5acbdb2fead202d8c:bisect-linux-8/.vmlinuz-716c18f8e57c5eff4725f0b5acb=
db2fead202d8c-20141119212229-12-client6 branch=3Dlinux-devel/devel-lkp-ib04=
-smoke-201411191439 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-11191438/716=
c18f8e57c5eff4725f0b5acbdb2fead202d8c/vmlinuz-3.18.0-rc1-00020-g716c18f drb=
d.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -=
m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-yocto-client6-12 -serial file:/dev/shm/kboot/serial-yocto-client=
6-12 -daemonize -display none -monitor null=20

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc1-00020-g716c18f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc1 Kernel Configuration
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
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_MODULE_COMPRESS=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
CONFIG_MODULE_COMPRESS_XZ=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=m
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=12
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
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

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

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
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
# CONFIG_NET_FOU is not set
# CONFIG_GENEVE is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_TABLES=m
# CONFIG_NFT_EXTHDR is not set
# CONFIG_NFT_META is not set
# CONFIG_NFT_RBTREE is not set
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
# CONFIG_NFT_REJECT is not set
# CONFIG_NETFILTER_XTABLES is not set
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
# CONFIG_IP_SET_HASH_IP is not set
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=m
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_MAC=m
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=y
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NF_REJECT_IPV4=m
# CONFIG_NFT_REJECT_IPV4 is not set
CONFIG_NF_TABLES_ARP=m
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=m
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=m
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=m
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=m
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_WILINK is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_RFKILL_GPIO is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DISABLE_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=m
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=y
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_LATTICE_ECP3_CONFIG=m
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=m
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_TOUCHSCREEN_PCAP is not set
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUR40=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
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
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_HMC_DRV=m
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=m
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=m
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_WM8994=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=m

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
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_MENF21BMC_WATCHDOG=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_MENF21BMC=m
CONFIG_EZX_PCAP=y
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=m
CONFIG_MFD_RN5T618=m
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8994=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_DA9211 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL9305=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_PWM is not set
CONFIG_REGULATOR_RN5T618=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_SHARP_DECODER is not set
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_HIX5HD2 is not set
# CONFIG_IR_IMON is not set
CONFIG_IR_MCEUSB=m
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
CONFIG_IR_REDRAT3=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
CONFIG_IR_TTUSBIR=m
CONFIG_IR_IMG=m
CONFIG_IR_IMG_RAW=y
CONFIG_IR_IMG_HW=y
# CONFIG_IR_IMG_NEC is not set
CONFIG_IR_IMG_JVC=y
# CONFIG_IR_IMG_SONY is not set
CONFIG_IR_IMG_SHARP=y
CONFIG_IR_IMG_SANYO=y
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_USB_SUPPORT=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

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

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_VGASTATE is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_MAX3421_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USBIP_CORE=m
# CONFIG_USBIP_VHCI_HCD is not set
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_DEBUG is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=m
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=m
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=m
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_SSU100=m
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_LINK_LAYER_TEST=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=m
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_FS=m
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_SERIAL=y
CONFIG_USB_CONFIGFS_ACM=y
CONFIG_USB_CONFIGFS_OBEX=y
CONFIG_USB_CONFIGFS_NCM=y
CONFIG_USB_CONFIGFS_ECM=y
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
CONFIG_USB_CONFIGFS_EEM=y
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_USB=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_MENF21BMC=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ACPI=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=m
CONFIG_LIS3L02DQ=m
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7780 is not set
CONFIG_AD7816=m
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
# CONFIG_AD7152 is not set
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD9832=m
CONFIG_AD9834=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1200=m
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_BCM_WIMAX=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=m
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
# CONFIG_ION is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_LTE_GDM724X=m
CONFIG_MTD_SPINAND_MT29F=m
# CONFIG_MTD_SPINAND_ONDIEECC is not set
CONFIG_LUSTRE_FS=m
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
# CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK is not set
CONFIG_LNET=m
CONFIG_LNET_MAX_PAYLOAD=1048576
CONFIG_LNET_SELFTEST=m
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_CRYPTO_THREEFISH is not set
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORUTIL=m
CONFIG_UNISYS_VISORCHANNEL=m
CONFIG_UNISYS_VISORCHIPSET=m
CONFIG_UNISYS_CHANNELSTUB=m
CONFIG_UNISYS_UISLIB=m
CONFIG_UNISYS_VIRTPCI=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_RT8973A=m
CONFIG_EXTCON_SM5502=m
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
CONFIG_BMA180=m
CONFIG_BMC150_ACCEL=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
CONFIG_KXSD9=m
CONFIG_MMA8452=m
CONFIG_KXCJK1013=m

#
# Analog to digital converters
#
# CONFIG_AD7266 is not set
CONFIG_AD7291=m
CONFIG_AD7298=m
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7887=m
CONFIG_AD7923=m
CONFIG_AD799X=m
CONFIG_MAX1027=m
# CONFIG_MAX1363 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=m
# CONFIG_TI_ADC128S052 is not set
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
CONFIG_AD5449=m
CONFIG_AD5504=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5686=m
CONFIG_AD5755=m
# CONFIG_AD5764 is not set
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set
CONFIG_MCP4922=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=m
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m
CONFIG_BMG160=m
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_AL3320A=m
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_ISL29125=m
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
# CONFIG_AK09911 is not set
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_MPL115 is not set
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m
CONFIG_T5403=m

#
# Lightning sensors
#
# CONFIG_AS3935 is not set

#
# Temperature sensors
#
CONFIG_MLX90614=m
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_LPSS is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_PHY_EXYNOS4210_USB2 is not set
# CONFIG_PHY_EXYNOS4X12_USB2 is not set
# CONFIG_PHY_EXYNOS5250_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_RING_BUFFER_STARTUP_TEST=y

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_RHASHTABLE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
CONFIG_TEST_UDELAY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH_SHA512=y
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha512"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
# CONFIG_CRYPTO_SHA1_MB is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

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
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_DRBG_MENU is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=m
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--qcHopEYAB45HaUaB--
