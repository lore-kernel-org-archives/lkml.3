Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaDKORr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:17:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:5859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbaDKORd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:17:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,842,1389772800"; 
   d="scan'208";a="511497307"
Date: Fri, 11 Apr 2014 22:17:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jet Chen <jet.chen@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, smap]  general protection fault: fff2 [#1] PREEMPT
 DEBUG_PAGEALLOC
Message-ID: <20140411141727.GA14997@localhost>
References: <53477D33.8030809@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53477D33.8030809@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, but I suspect this commit may well be innocent and merely
_discloses_ an existing bug.

Because dmesgs for the parent commit all(*) stop here, long before being able
to emit the "reboot: machine restart" and the general protection fault.

(*) "all" means all the machines that run qemu "-cpu Haswell,+smep,+smap".

[  562.353714] Failed to execute /init (error -14)
[  562.400008] Starting init: /sbin/init exists but couldn't execute it (error -14)
[  562.400008] Starting init: /etc/init exists but couldn't execute it (error -13)
[  562.422116] Starting init: /bin/sh exists but couldn't execute it (error -14)
[  562.450049] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
[  562.450049] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc1-00171-g03bbd59 #1
[  562.450049]  0000000000000000 ffff880012035ec0 ffffffff81380af6 ffff880012035f38
[  562.450049]  ffffffff8137e608 ffffffff00000008 ffff880012035f48 ffff880012035ee8
[  562.450049]  0000000000000000 ffffffff81067fcf 0000000000000001 0000000000000000
[  562.450049] Call Trace:
[  562.450049]  [<ffffffff81380af6>] dump_stack+0x19/0x1b
[  562.450049]  [<ffffffff8137e608>] panic+0xcb/0x1ca
[  562.450049]  [<ffffffff81067fcf>] ? console_unlock+0x319/0x336
[  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
[  562.450049]  [<ffffffff8137785e>] kernel_init+0xd1/0xd5
[  562.450049]  [<ffffffff81386d3a>] ret_from_fork+0x7a/0xb0
[  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
[  562.450049] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Fengguang

On Fri, Apr 11, 2014 at 01:27:15PM +0800, Jet Chen wrote:
> Hi Peter,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 4640c7ee9b8953237d05a61ea3ea93981d1bc961
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Thu Feb 13 07:46:04 2014 -0800
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu Feb 13 08:40:52 2014 -0800
> 
>      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off
>          If CONFIG_X86_SMAP is disabled, smap_violation() tests for conditions
>      which are incorrect (as the AC flag doesn't matter), causing spurious
>      faults.
>          The dynamic disabling of SMAP (nosmap on the command line) is fine
>      because it disables X86_FEATURE_SMAP, therefore causing the
>      static_cpu_has() to return false.
>          Found by Fengguang Wu's test system.
>          [ v3: move all predicates into smap_violation() ]
>      [ v2: use IS_ENABLED() instead of #ifdef ]
>          Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>      Link: http://lkml.kernel.org/r/20140213124550.GA30497@localhost
>      Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>      Cc: <stable@vger.kernel.org> # v3.7+
> 
> 
> +------------------------------------------------+------------+------------+
> |                                                | 03bbd596ac | 4640c7ee9b |
> +------------------------------------------------+------------+------------+
> | boot_successes                                 | 920        | 282        |
> | boot_failures                                  | 280        | 18         |
> | Kernel_panic-not_syncing:No_working_init_found | 248        |            |
> | backtrace:panic                                | 248        |            |
> | BUG:soft_lockup-CPU_stuck_for_s                | 31         |            |
> | RIP:arch_local_irq_enable                      | 31         |            |
> | Kernel_panic-not_syncing:softlockup:hung_tasks | 31         |            |
> | backtrace:setup_IO_APIC                        | 31         |            |
> | backtrace:APIC_init_uniprocessor               | 31         |            |
> | backtrace:kernel_init_freeable                 | 31         |            |
> | BUG:kernel_boot_hang                           | 1          | 0          |
> | general_protection_fault:fff2                  | 0          | 18         |
> | RIP:arch_local_irq_restore                     | 0          | 18         |
> | Kernel_panic-not_syncing:Fatal_exception       | 0          | 18         |
> | backtrace:SYSC_reboot                          | 0          | 18         |
> | backtrace:SyS_reboot                           | 0          | 18         |
> +------------------------------------------------+------------+------------+
> 
> Rebooting... [  371.058724] reboot: Restarting system
> [  371.058724] reboot: machine restart
> [  371.380921] general protection fault: fff2 [#1] PREEMPT DEBUG_PAGEALLOC
> [  371.380921] Modules linked in:
> [  371.380921] CPU: 0 PID: 230 Comm: reboot Not tainted 3.14.0-rc1-00186-g4640c7e #1
> [  371.380921] task: ffff880011f54000 ti: ffff880011f66000 task.ti: ffff880011f66000
> [  371.380921] RIP: 0010:[<ffffffff81016663>]  [<ffffffff81016663>] arch_local_irq_restore+0x6/0xd
> [  371.380921] RSP: 0018:ffff880011f67dc8  EFLAGS: 00000202
> [  371.380921] RAX: ffffffff8160a550 RBX: 0000000000000202 RCX: 0000005677d85f2c
> [  371.380921] RDX: 0000000000010000 RSI: 000000000000000f RDI: 0000000000000202
> [  371.380921] RBP: ffff880011f67dc8 R08: 0000000000000001 R09: 0000000000000000
> [  371.380921] R10: 00000000000092dc R11: 0000000000000000 R12: 0000000028121969
> [  371.380921] R13: 00007fffb011e210 R14: 00000000fee1dead R15: 0000000000000001
> [  371.380921] FS:  00007f7d26ef9700(0000) GS:ffffffff81603000(0000) knlGS:0000000000000000
> [  371.380921] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  371.380921] CR2: 00007f7d26a1f999 CR3: 0000000011f5b000 CR4: 00000000001006b0
> [  371.380921] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  371.380921] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [  371.380921] Stack:
> [  371.380921]  ffff880011f67de0 ffffffff81017036 0000000000000000 ffff880011f67df0
> [  371.380921]  ffffffff8101632f ffff880011f67e00 ffffffff8101656c ffff880011f67e10
> [  371.380921]  ffffffff810165d3 ffff880011f67e20 ffffffff8101660f ffff880011f67e38
> [  371.380921] Call Trace:
> [  371.380921]  [<ffffffff81017036>] lapic_shutdown+0x46/0x49
> [  371.380921]  [<ffffffff8101632f>] native_machine_shutdown+0x13/0x20
> [  371.380921]  [<ffffffff8101656c>] machine_shutdown+0xf/0x11
> [  371.380921]  [<ffffffff810165d3>] native_machine_restart+0x25/0x37
> [  371.380921]  [<ffffffff8101660f>] machine_restart+0xf/0x11
> [  371.380921]  [<ffffffff81057e4d>] kernel_restart+0x54/0x57
> [  371.380921]  [<ffffffff81057fe7>] SYSC_reboot+0xbb/0x168
> [  371.380921]  [<ffffffff810ae16f>] ? __free_pages+0x27/0x48
> [  371.380921]  [<ffffffff810ae1cd>] ? free_pages+0x3d/0x41
> [  371.380921]  [<ffffffff810d2f19>] ? slob_free_pages+0x36/0x38
> [  371.380921]  [<ffffffff810d39fb>] ? __kmem_cache_free+0x30/0x32
> [  371.380921]  [<ffffffff810d3a54>] ? kmem_cache_free+0x3a/0x7d
> [  371.380921]  [<ffffffff810e1ffb>] ? final_putname+0x34/0x37
> [  371.380921]  [<ffffffff810d84ed>] ? do_sys_open+0xed/0xff
> [  371.380921]  [<ffffffff8123ea26>] ? lockdep_sys_exit_thunk+0x35/0x67
> [  371.380921]  [<ffffffff81058125>] SyS_reboot+0xe/0x10
> [  371.380921]  [<ffffffff81386deb>] system_call_fastpath+0x1a/0x1f
> [  371.380921] Code: ff b9 50 00 00 00 48 89 e5 e8 fe 7f 32 00 0f b6 c4 c1 e0 19 48 98 5d c3 55 48 89 e5 e8 6a 23 ff ff 66 90 5d c3 55 48 89 e5 57 9d <66> 66 90 66 90 5d c3 55 48 89 e5 fa 66 66 90 66 66 90 5d c3 55 [  371.380921] RIP  [<ffffffff81016663>] arch_local_irq_restore+0x6/0xd
> [  371.380921]  RSP <ffff880011f67dc8>
> [  371.380921] ---[ end trace 345c675a0d78fd90 ]---
> [  371.380921] Kernel panic - not syncing: Fatal exception
> 
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> 
> git bisect start v3.14 v3.13 --
> git bisect good 494479038d97f1b9f76fc633a360a681acdf035c  # 21:34    300+     80  Merge tag 'pinctrl-v3.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
> git bisect  bad 751a03c3728ed393287374078b98c3094a0b3bd2  # 21:53    229-      3  Merge tag 'pm+acpi-3.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect  bad 87eeff7974ae665f6d4d74c2f97c04d4b180b5d6  # 22:18    252-     11  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
> git bisect  bad 161aa772f972ec75b292f25d65816a6f1cd285cf  # 22:51    281-      1  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 641f832c73babf0405c7afb41c8bfed999ebbad7  # 23:25    300+    121  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
> git bisect good 85643586677c877f28891200e0cb9514547af589  # 23:51    300+     70  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
> git bisect good 5e57dc81106b942786f5db8e7ab8788bb9319933  # 00:28    300+     84  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
> git bisect good 3bd354abe17f2c8aa426ef84b78f14e505f0a920  # 00:58    300+     86  Merge tag 'edac_for_3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
> git bisect good eef445eedcd80aa4f3646cecf285cf934d264eb6  # 01:52    300+     92  Merge tag 'pm+acpi-3.14-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect good a9f180345f5378ac87d80ed0bea55ba421d83859  # 02:36    300+     90  compiler/gcc4: Make quirk for asm_volatile_goto() unconditional
> git bisect  bad 4640c7ee9b8953237d05a61ea3ea93981d1bc961  # 02:49    240-      1  x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off
> git bisect good 03bbd596ac04fef47ce93a730b8f086d797c3021  # 03:03    300+     94  x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
> # first bad commit: [4640c7ee9b8953237d05a61ea3ea93981d1bc961] x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off
> git bisect good 03bbd596ac04fef47ce93a730b8f086d797c3021  # 03:17    900+    280  x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
> git bisect  bad 21d162b9c6aef0e9bea24f97fe2edefb5965e95c  # 03:17      0-      4  0day head guard for 'devel-hourly-2014040912'
> git bisect  bad 4ba85265790ba3681deeaf73f018c0eb829a7341  # 03:37    756-     27  Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86
> git bisect  bad 53101f8be33d9dab12a5994b154c2029fadaaab4  # 03:46    215-     19  Add linux-next specific files for 20140410
> 
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64 -cpu Haswell,+smep,+smap 	-kernel $kernel
> 	-initrd $initrd
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
> [    0.000000] Linux version 3.14.0-rc1-00186-g4640c7e (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 PREEMPT Fri Apr 11 02:43:45 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:4640c7ee9b8953237d05a61ea3ea93981d1bc961:bisect-linux7/.vmlinuz-4640c7ee9b8953237d05a61ea3ea93981d1bc961-20140411024505-184-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/4640c7ee9b8953237d05a61ea3ea93981d1bc961/vmlinuz-3.14.0-rc1-00186-g4640c7e drbd.minor_count=8
> [    0.000000] KERNEL supported cpus:
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
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
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02237000, 0x02237fff] PGTABLE
> [    0.000000] BRK [0x02238000, 0x02238fff] PGTABLE
> [    0.000000] BRK [0x02239000, 0x02239fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
> [    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
> [    0.000000] BRK [0x0223a000, 0x0223afff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
> [    0.000000]  [mem 0x10000000-0x139fffff] page 4k
> [    0.000000] BRK [0x0223b000, 0x0223bfff] PGTABLE
> [    0.000000] BRK [0x0223c000, 0x0223cfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
> [    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
> [    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0000000013ffff40 000040
> [    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
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
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:4640c7ee9b8953237d05a61ea3ea93981d1bc961:bisect-linux7/.vmlinuz-4640c7ee9b8953237d05a61ea3ea93981d1bc961-20140411024505-184-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/4640c7ee9b8953237d05a61ea3ea93981d1bc961/vmlinuz-3.14.0-rc1-00186-g4640c7e drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 297100K/327280K available (3623K kernel code, 2426K rwdata, 2388K rodata, 640K init, 9560K bss, 30180K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] NR_IRQS:4352 nr_irqs:256 16
> [    0.000000] ACPI: Core revision 20131218
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |failed|
> [    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
> [    0.000000]             mixed read-write-lock:             |failed|             |failed|
> [    0.000000]             mixed write-read-lock:             |failed|             |failed|
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:failed|  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:failed|  ok  |  ok  |
> [    0.000000]                               try:failed|  ok  |failed|
> [    0.000000]                             block:failed|  ok  |failed|
> [    0.000000]                          spinlock:failed|  ok  |failed|
> [    0.000000] --------------------------------------------------------
> [    0.000000] 141 out of 253 testcases failed, as expected. |
> [    0.000000] ----------------------------------------------------
> [    0.000000] ODEBUG: 2 of 2 active objects replaced
> [    0.000000] ODEBUG: selftest passed
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: using HPET reference calibration
> [    0.000000] tsc: Detected 2793.060 MHz processor
> [    0.015000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.12 BogoMIPS (lpj=2793060)
> [    0.017733] pid_max: default: 32768 minimum: 301
> [    0.023258] Mount-cache hash table entries: 256
> [    0.066246] mce: CPU supports 10 MCE banks
> [    0.067222] mce: unknown CPU type - not enabling MCE support
> [    0.068562] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.068562] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.068562] tlb_flushall_shift: -1
> [    0.069107] CPU: GenuineIntel Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)
> [    0.116302] Performance Events: no PMU driver, software events only.
> [    0.193322] ftrace: Allocated trace_printk buffers
> [    0.318799] Getting VERSION: 50011
> [    0.319424] Getting VERSION: 50011
> [    0.320182] Getting ID: 0
> [    0.320682] Getting ID: ff000000
> [    0.321129] Getting LVT0: 8700
> [    0.324230] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.326441] Getting LVT1: 8400
> [    0.328628] enabled ExtINT on CPU#0
> [    0.336334] ENABLING IO-APIC IRQs
> [    0.337183] Synchronizing Arb IDs.
> [    0.337713] init IO_APIC IRQs
> [    0.338484]  apic 0 pin 0 not connected
> [    0.341153] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.343259] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.344515] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.345000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.345000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.345000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.345000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.345000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.345531] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.346000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.346000]  apic 0 pin 16 not connected
> [    0.346000]  apic 0 pin 17 not connected
> [    0.346000]  apic 0 pin 18 not connected
> [    0.346000]  apic 0 pin 19 not connected
> [    0.346000]  apic 0 pin 20 not connected
> [    0.346000]  apic 0 pin 21 not connected
> [    0.346000]  apic 0 pin 22 not connected
> [    0.346000]  apic 0 pin 23 not connected
> [    0.346000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.357604] Using local APIC timer interrupts.
> [    0.357604] calibrating APIC timer ...
> [    0.359000] ... lapic delta = 6248619
> [    0.359000] ... PM-Timer delta = 357874
> [    0.359000] ... PM-Timer result ok
> [    0.359000] ..... delta 6248619
> [    0.359000] ..... mult: 268376142
> [    0.359000] ..... calibration result: 999779
> [    0.359000] ..... CPU clock speed is 2792.0457 MHz.
> [    0.359000] ..... host bus clock speed is 999.0779 MHz.
> [    0.582588] prandom: seed boundary self test passed
> [    0.598177] prandom: 100 self tests passed
> [    0.631740] regulator-dummy: no parameters
> [    0.650684] NET: Registered protocol family 16
> [    0.676184] cpuidle: using governor ladder
> [    0.677527] cpuidle: using governor menu
> [    0.688709] ACPI: bus type PCI registered
> [    0.694422] PCI: Using configuration type 1 for base access
> [    1.213866] bio: create slab <bio-0> at 0
> [    1.238154] ACPI: Added _OSI(Module Device)
> [    1.238736] ACPI: Added _OSI(Processor Device)
> [    1.239088] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.240087] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.150136] ACPI: Interpreter enabled
> [    2.152369] ACPI: (supports S0 S5)
> [    2.153103] ACPI: Using IOAPIC for interrupt routing
> [    2.162192] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    3.419000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    3.421460] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    3.425096] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    3.478360] PCI host bridge to bus 0000:00
> [    3.479178] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    3.480291] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    3.481105] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    3.482129] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    3.484108] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    3.488398] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    3.525433] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    3.565467] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    3.577131] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    3.609700] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    3.614495] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    3.615526] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    3.660676] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    3.663133] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    3.667113] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    3.683117] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    3.709713] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    3.713115] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    3.717113] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    3.733118] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    3.770106] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    3.772754] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    3.814744] pci_bus 0000:00: on NUMA node 0
> [    3.883413] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    3.901768] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    3.928073] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    3.969755] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    3.986114] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    4.061000] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    4.105000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    4.106142] vgaarb: loaded
> [    4.106807] vgaarb: bridge control possible 0000:00:02.0
> [    4.141204] pps_core: LinuxPPS API ver. 1 registered
> [    4.143079] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    4.147542] PTP clock support registered
> [    4.184647] PCI: Using ACPI for IRQ routing
> [    4.185753] PCI: pci_cache_line_size set to 64 bytes
> [    4.189804] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    4.191922] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    4.287000] Switched to clocksource hpet
> [    7.958609] pnp: PnP ACPI init
> [    7.961491] ACPI: bus type PNP registered
> [    7.972616] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    7.983523] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    7.988627] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    7.994754] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    8.000919] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    8.007783] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    8.017681] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    8.019760] pnp 00:03: [dma 2]
> [    8.025790] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    8.034772] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    8.040614] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    8.048524] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    8.054733] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    8.062706] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    8.068555] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    8.111738] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    8.149548] pnp: PnP ACPI: found 8 devices
> [    8.150530] ACPI: bus type PNP unregistered
> [    8.227546] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    8.228599] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    8.229715] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    8.231549] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    8.234530] NET: Registered protocol family 1
> [    8.235663] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    8.237587] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    8.239580] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    8.241535] pci 0000:00:02.0: Boot video device
> [    8.242719] PCI: CLS 0 bytes, default 64
> [    8.318643] Unpacking initramfs...
> [   19.436638] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013feffff]
> [   19.465338] Scanning for low memory corruption every 60 seconds
> [   19.542734] cryptomgr_test (22) used greatest stack depth: 6400 bytes left
> [   19.726969] cryptomgr_test (23) used greatest stack depth: 5216 bytes left
> [   19.795909] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
> [   19.928896] AVX or AES-NI instructions are not detected.
> [   19.930048] AVX instructions are not detected.
> [   20.128914] futex hash table entries: 256 (order: 2, 22528 bytes)
> [   20.387911] bounce pool size: 64 pages
> [   20.390025] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [   20.418577] VFS: Disk quotas dquot_6.5.2
> [   20.421025] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [   20.456941] NTFS driver 2.1.30 [Flags: R/O].
> [   20.459015] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> [   20.481479] QNX4 filesystem 0.2.3 registered.
> [   20.482830] fuse init (API version 7.22)
> [   20.496984] NILFS version 2 loaded
> [   20.528819] GFS2 installed
> [   20.708923] tsc: Refined TSC clocksource calibration: 2793.092 MHz
> [   20.712879] Switched to clocksource tsc
> [   20.838514] alg: No test for crc32 (crc32-table)
> [   20.873744] alg: No test for lz4 (lz4-generic)
> [   20.889039] alg: No test for stdrng (krng)
> [   20.898035] io scheduler noop registered (default)
> [   20.935999] list_sort_test: start testing list_sort()
> [   21.039443] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> [   21.040036] crc32: self tests passed, processed 225944 bytes in 2881788 nsec
> [   21.045015] crc32c: CRC_LE_BITS = 32
> [   21.045903] crc32c: self tests passed, processed 225944 bytes in 1188162 nsec
> [   25.693802] crc32_combine: 8373 self tests passed
> [   31.595763] crc32c_combine: 8373 self tests passed
> [   31.611807] hgafb: HGA card not detected.
> [   31.617623] hgafb: probe of hgafb.0 failed with error -22
> [   31.630576] ipmi message handler version 39.2
> [   31.642784] IPMI System Interface driver.
> [   31.655696] ipmi_si: Adding default-specified kcs state machine
> [   31.670502] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [   31.692514] ipmi_si: Interface detection failed
> [   31.706575] ipmi_si: Adding default-specified smic state machine
> [   31.708830] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [   31.724543] ipmi_si: Interface detection failed
> [   31.724935] ipmi_si: Adding default-specified bt state machine
> [   31.724935] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [   31.728524] ipmi_si: Interface detection failed
> [   31.782730] ipmi_si: Unable to find any System Interface(s)
> [   31.889725] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [   31.913721] ACPI: Power Button [PWRF]
> [   46.444976] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [   46.601982] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [   47.189865] lkdtm: No crash points registered, enable through debugfs
> [   47.353646] SSFDC read-only Flash Translation layer
> [   47.398979] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   47.535874] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   47.597036] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   48.563334] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [   48.832012] pps pps0: new PPS source ktimer
> [   48.857303] pps pps0: ktimer PPS source registered
> [   48.920638] Driver for 1-wire Dallas network protocol.
> [   49.452855] applesmc: supported laptop not found!
> [   49.452855] applesmc: driver init failed (ret=-19)!
> [   49.577023] acquirewdt: WDT driver for Acquire single board computer initialising
> [   49.710871] acquirewdt: I/O address 0x0043 already in use
> [   49.713947] acquirewdt: probe of acquirewdt failed with error -5
> [   49.790933] sbc8360: Timeout set at 60000 ms
> [   49.801943] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
> [   49.841960] smsc37b787_wdt: Unable to register miscdev on minor 130
> [   49.865818] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
> [   49.890982] ledtrig-cpu: registered to indicate activity on CPUs
> [   50.016926] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [   50.068678] oprofile: using timer interrupt.
> [   50.102836] 
> [   50.102836] printing PIC contents
> [   50.102836] ... PIC  IMR: ffff
> [   50.102836] ... PIC  IRR: 1013
> [   50.102836] ... PIC  ISR: 0000
> [   50.102836] ... PIC ELCR: 0c00
> [   50.110853] printing local APIC contents on CPU#0/0:
> [   50.110856] ... APIC ID:      00000000 (0)
> [   50.110856] ... APIC VERSION: 00050011
> [   50.110856] ... APIC TASKPRI: 00000000 (00)
> [   50.110856] ... APIC ARBPRI: 00000000 (00)
> [   50.110856] ... APIC PROCPRI: 00000000
> [   50.110856] ... APIC LDR: 01000000
> [   50.110856] ... APIC DFR: f0000000
> [   50.110856] ... APIC SPIV: 000001ff
> [   50.110856] ... APIC ISR field:
> [   50.110856] 0000000000000000000000000000000000000000000000000000000000000000
> [   50.110856] ... APIC TMR field:
> [   50.110856] 0000000000000000000000000000000000000000000000000000000000000000
> [   50.110856] ... APIC IRR field:
> [   50.110856] 0000000000000000000000000000000000000000000000000000000000008000
> [   50.110856] ... APIC ESR: 00000000
> [   50.110856] ... APIC ICR: 00000831
> [   50.110856] ... APIC ICR2: 01000000
> [   50.110856] ... APIC LVTT: 000200ef
> [   50.110856] ... APIC LVTPC: 00010000
> [   50.110856] ... APIC LVT0: 00010700
> [   50.110856] ... APIC LVT1: 00000400
> [   50.110856] ... APIC LVTERR: 000000fe
> [   50.110856] ... APIC TMICT: 0000f416
> [   50.110856] ... APIC TMCCT: 0000651d
> [   50.110856] ... APIC TDCR: 00000003
> [   50.110856] 
> [   50.518649] number of MP IRQ sources: 15.
> [   50.529734] number of IO-APIC #0 registers: 24.
> [   50.530388] testing the IO APIC.......................
> [   50.530388] IO APIC #0......
> [   50.530388] .... register #00: 00000000
> [   50.550674] .......    : physical APIC id: 00
> [   50.550824] .......    : Delivery Type: 0
> [   50.550824] .......    : LTS          : 0
> [   50.550824] .... register #01: 00170011
> [   50.550824] .......     : max redirection entries: 17
> [   50.719811] .......     : PRQ implemented: 0
> [   50.720489] .......     : IO APIC version: 11
> [   50.720489] .... register #02: 00000000
> [   50.720489] .......     : arbitration: 00
> [   50.720489] .... IRQ redirection table:
> [   50.720489] 1    0    0   0   0    0    0    00
> [   50.720489] 0    0    0   0   0    1    1    31
> [   50.720489] 0    0    0   0   0    1    1    30
> [   50.720489] 0    0    0   0   0    1    1    33
> [   50.720489] 1    0    0   0   0    1    1    34
> [   50.720489] 1    1    0   0   0    1    1    35
> [   50.720489] 0    0    0   0   0    1    1    36
> [   50.720489] 0    0    0   0   0    1    1    37
> [   50.720489] 0    0    0   0   0    1    1    38
> [   50.720489] 0    1    0   0   0    1    1    39
> [   50.735659] 1    1    0   0   0    1    1    3A
> [   50.735842] 1    1    0   0   0    1    1    3B
> [   50.758848] 0    0    0   0   0    1    1    3C
> [   50.774566] 0    0    0   0   0    1    1    3D
> [   50.774891] 0    0    0   0   0    1    1    3E
> [   50.777900] 0    0    0   0   0    1    1    3F
> [   50.789662] 1    0    0   0   0    0    0    00
> [   50.789997] 1    0    0   0   0    0    0    00
> [   50.796418] 1    0    0   0   0    0    0    00
> [   50.796952] 1    0    0   0   0    0    0    00
> [   50.796952] 1    0    0   0   0    0    0    00
> [   50.796952] 1    0    0   0   0    0    0    00
> [   50.796952] 1    0    0   0   0    0    0    00
> [   50.796952] 1    0    0   0   0    0    0    00
> [   50.796952] IRQ to pin mappings:
> [   50.839693] IRQ0 -> 0:2
> [   50.840953] IRQ1 -> 0:1
> [   50.852792] IRQ3 -> 0:3
> [   50.852949] IRQ4 -> 0:4
> [   50.852949] IRQ5 -> 0:5
> [   50.852949] IRQ6 -> 0:6
> [   50.852949] IRQ7 -> 0:7
> [   50.852949] IRQ8 -> 0:8
> [   50.852949] IRQ9 -> 0:9
> [   50.884000] IRQ10 -> 0:10
> [   50.884587] IRQ11 -> 0:11
> [   50.884587] IRQ12 -> 0:12
> [   50.884587] IRQ13 -> 0:13
> [   50.884587] IRQ14 -> 0:14
> [   50.884587] IRQ15 -> 0:15
> [   50.884587] .................................... done.
> [   51.796440] debug: unmapping init [mem 0xffffffff81841000-0xffffffff818e0fff]
> mount: mounting proc on /proc failed: No such device
> /etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found
> 
> Please wait: booting...
> mount: mounting proc on /proc failed: No such device
> grep: /proc/filesystems: No such file or directory
> Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file or directory
> bootlogd.
> mount: can't read '/proc/mounts': No such file or directory
> /etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /proc/cmdline: no such file
> grep: /proc/filesystems: No such file or directory
> Configuring network interfaces... ifconfig: socket: Address family not supported by protocol
> done.
> hwclock: can't open '/dev/misc/rtc': No such file or directory
> Running postinst /etc/rpm-postinsts/100...
> mount: no /proc/mounts
> wfg: skip syslogd
> Kernel tests: Boot OK!
> Kernel tests: Boot OK!
> mount: mounting proc on /proc failed: No such device
> /etc/rc5.d/S99-rc.local: line 19: can't create /proc/152/oom_score_adj: nonexistent directory
> sed: /lib/modules/3.14.0-rc1-00186-g4640c7e/modules.dep: No such file or directory
> xargs: modprobe: No such file or directory
> run-parts: /etc/kernel-tests/01-modprobe exited with code 127
> grep: /proc/cmdline: No such file or directory
> grep: /proc/cmdline: No such file or directory
> /etc/kernel-tests/90-trinity: line 15: /trinity: not found
> /etc/kernel-tests/90-trinity: line 16: /trinity: not found
> /etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
> /etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
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
> mount: no /proc/mounts
> wfg: skip syslogd
> sed: /proc/mounts: No such file or directory
> sed: /proc/mounts: No such file or directory
> sed: /proc/mounts: No such file or directory
> Deconfiguring network interfaces... ifconfig: socket: Address family not supported by protocol
> done.
> Sending all processes the TERM signal...
> mount: mounting proc on /proc failed: No such device
> Sending all processes the KILL signal...
> mount: mounting proc on /proc failed: No such device
> Unmounting remote filesystems...
> Deactivating swap...
> Unmounting local filesystems...
> grep: /proc/mounts: No such file or directory
> mount: can't read '/proc/mounts': No such file or directory
> Rebooting... 
> [  371.058724] reboot: Restarting system
> [  371.058724] reboot: machine restart
> [  371.380921] general protection fault: fff2 [#1] PREEMPT DEBUG_PAGEALLOC
> [  371.380921] Modules linked in:
> [  371.380921] CPU: 0 PID: 230 Comm: reboot Not tainted 3.14.0-rc1-00186-g4640c7e #1
> [  371.380921] task: ffff880011f54000 ti: ffff880011f66000 task.ti: ffff880011f66000
> [  371.380921] RIP: 0010:[<ffffffff81016663>]  [<ffffffff81016663>] arch_local_irq_restore+0x6/0xd
> [  371.380921] RSP: 0018:ffff880011f67dc8  EFLAGS: 00000202
> [  371.380921] RAX: ffffffff8160a550 RBX: 0000000000000202 RCX: 0000005677d85f2c
> [  371.380921] RDX: 0000000000010000 RSI: 000000000000000f RDI: 0000000000000202
> [  371.380921] RBP: ffff880011f67dc8 R08: 0000000000000001 R09: 0000000000000000
> [  371.380921] R10: 00000000000092dc R11: 0000000000000000 R12: 0000000028121969
> [  371.380921] R13: 00007fffb011e210 R14: 00000000fee1dead R15: 0000000000000001
> [  371.380921] FS:  00007f7d26ef9700(0000) GS:ffffffff81603000(0000) knlGS:0000000000000000
> [  371.380921] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  371.380921] CR2: 00007f7d26a1f999 CR3: 0000000011f5b000 CR4: 00000000001006b0
> [  371.380921] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  371.380921] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [  371.380921] Stack:
> [  371.380921]  ffff880011f67de0 ffffffff81017036 0000000000000000 ffff880011f67df0
> [  371.380921]  ffffffff8101632f ffff880011f67e00 ffffffff8101656c ffff880011f67e10
> [  371.380921]  ffffffff810165d3 ffff880011f67e20 ffffffff8101660f ffff880011f67e38
> [  371.380921] Call Trace:
> [  371.380921]  [<ffffffff81017036>] lapic_shutdown+0x46/0x49
> [  371.380921]  [<ffffffff8101632f>] native_machine_shutdown+0x13/0x20
> [  371.380921]  [<ffffffff8101656c>] machine_shutdown+0xf/0x11
> [  371.380921]  [<ffffffff810165d3>] native_machine_restart+0x25/0x37
> [  371.380921]  [<ffffffff8101660f>] machine_restart+0xf/0x11
> [  371.380921]  [<ffffffff81057e4d>] kernel_restart+0x54/0x57
> [  371.380921]  [<ffffffff81057fe7>] SYSC_reboot+0xbb/0x168
> [  371.380921]  [<ffffffff810ae16f>] ? __free_pages+0x27/0x48
> [  371.380921]  [<ffffffff810ae1cd>] ? free_pages+0x3d/0x41
> [  371.380921]  [<ffffffff810d2f19>] ? slob_free_pages+0x36/0x38
> [  371.380921]  [<ffffffff810d39fb>] ? __kmem_cache_free+0x30/0x32
> [  371.380921]  [<ffffffff810d3a54>] ? kmem_cache_free+0x3a/0x7d
> [  371.380921]  [<ffffffff810e1ffb>] ? final_putname+0x34/0x37
> [  371.380921]  [<ffffffff810d84ed>] ? do_sys_open+0xed/0xff
> [  371.380921]  [<ffffffff8123ea26>] ? lockdep_sys_exit_thunk+0x35/0x67
> [  371.380921]  [<ffffffff81058125>] SyS_reboot+0xe/0x10
> [  371.380921]  [<ffffffff81386deb>] system_call_fastpath+0x1a/0x1f
> [  371.380921] Code: ff b9 50 00 00 00 48 89 e5 e8 fe 7f 32 00 0f b6 c4 c1 e0 19 48 98 5d c3 55 48 89 e5 e8 6a 23 ff ff 66 90 5d c3 55 48 89 e5 57 9d <66> 66 90 66 90 5d c3 55 48 89 e5 fa 66 66 90 66 66 90 5d c3 55 
> [  371.380921] RIP  [<ffffffff81016663>] arch_local_irq_restore+0x6/0xd
> [  371.380921]  RSP <ffff880011f67dc8>
> [  371.380921] ---[ end trace 345c675a0d78fd90 ]---
> [  371.380921] Kernel panic - not syncing: Fatal exception
> [  371.380921] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [  371.380921] Rebooting in 10 seconds..
> Elapsed time: 375
> qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconfig-i0-04091721/4640c7ee9b8953237d05a61ea3ea93981d1bc961/vmlinuz-3.14.0-rc1-00186-g4640c7e -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:4640c7ee9b8953237d05a61ea3ea93981d1bc961:bisect-linux7/.vmlinuz-4640c7ee9b8953237d05a61ea3ea93981d1bc961-20140411024505-184-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/4640c7ee9b8953237d05a61ea3ea93981d1bc961/vmlinuz-3.14.0-rc1-00186-g4640c7e drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-yocto-brickland3-173 -serial file:/dev/shm/kboot/serial-yocto-brickland3-173 -daemonize -display none -monitor null 
> 
> 

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> [    0.000000] Linux version 3.14.0-rc1-00171-g03bbd59 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 PREEMPT Fri Apr 11 02:54:57 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:03bbd596ac04fef47ce93a730b8f086d797c3021:bisect-linux7/.vmlinuz-03bbd596ac04fef47ce93a730b8f086d797c3021-20140411030343-500-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/03bbd596ac04fef47ce93a730b8f086d797c3021/vmlinuz-3.14.0-rc1-00171-g03bbd59 drbd.minor_count=8
> [    0.000000] KERNEL supported cpus:
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
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
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02237000, 0x02237fff] PGTABLE
> [    0.000000] BRK [0x02238000, 0x02238fff] PGTABLE
> [    0.000000] BRK [0x02239000, 0x02239fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 4k
> [    0.000000] BRK [0x0223a000, 0x0223afff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 4k
> [    0.000000] BRK [0x0223b000, 0x0223bfff] PGTABLE
> [    0.000000] BRK [0x0223c000, 0x0223cfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0000000013ffff40 000040
> [    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
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
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
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
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80519
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:03bbd596ac04fef47ce93a730b8f086d797c3021:bisect-linux7/.vmlinuz-03bbd596ac04fef47ce93a730b8f086d797c3021-20140411030343-500-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/03bbd596ac04fef47ce93a730b8f086d797c3021/vmlinuz-3.14.0-rc1-00171-g03bbd59 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 276968K/327280K available (3623K kernel code, 2422K rwdata, 2392K rodata, 640K init, 9560K bss, 50312K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] NR_IRQS:4352 nr_irqs:256 16
> [    0.000000] ACPI: Core revision 20131218
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |failed|
> [    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
> [    0.000000]             mixed read-write-lock:             |failed|             |failed|
> [    0.000000]             mixed write-read-lock:             |failed|             |failed|
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:failed|  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:failed|  ok  |  ok  |
> [    0.000000]                               try:failed|  ok  |failed|
> [    0.000000]                             block:failed|  ok  |failed|
> [    0.000000]                          spinlock:failed|  ok  |failed|
> [    0.000000] --------------------------------------------------------
> [    0.000000] 141 out of 253 testcases failed, as expected. |
> [    0.000000] ----------------------------------------------------
> [    0.000000] ODEBUG: 2 of 2 active objects replaced
> [    0.000000] ODEBUG: selftest passed
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: using HPET reference calibration
> [    0.000000] tsc: Detected 2793.055 MHz processor
> [    0.012000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.11 BogoMIPS (lpj=2793055)
> [    0.017179] pid_max: default: 32768 minimum: 301
> [    0.030000] Mount-cache hash table entries: 256
> [    0.055000] mce: CPU supports 10 MCE banks
> [    0.055000] mce: unknown CPU type - not enabling MCE support
> [    0.057973] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.057973] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.057973] tlb_flushall_shift: -1
> [    0.059165] CPU: GenuineIntel Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)
> [    0.079000] Performance Events: no PMU driver, software events only.
> [    0.131000] ftrace: Allocated trace_printk buffers
> [    0.236000] Getting VERSION: 50011
> [    0.236000] Getting VERSION: 50011
> [    0.236000] Getting ID: 0
> [    0.236000] Getting ID: ff000000
> [    0.236000] Getting LVT0: 8700
> [    0.237321] Getting LVT1: 8400
> [    0.238000] enabled ExtINT on CPU#0
> [    0.244000] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.247000] ENABLING IO-APIC IRQs
> [    0.247000] Synchronizing Arb IDs.
> [    0.247000] init IO_APIC IRQs
> [    0.247000]  apic 0 pin 0 not connected
> [    0.249000] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.249000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.250609] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.251000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.251000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.251000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.251000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.252754] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.253000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.253000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.253000]  apic 0 pin 16 not connected
> [    0.253000]  apic 0 pin 17 not connected
> [    0.253000]  apic 0 pin 18 not connected
> [    0.253000]  apic 0 pin 19 not connected
> [    0.253000]  apic 0 pin 20 not connected
> [    0.253000]  apic 0 pin 21 not connected
> [    0.253000]  apic 0 pin 22 not connected
> [    0.253000]  apic 0 pin 23 not connected
> [    0.253000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.259000] Using local APIC timer interrupts.
> [    0.259000] calibrating APIC timer ...
> [    0.262000] ... lapic delta = 55259362
> [    0.262000] ... PM-Timer delta = 3165033
> [    0.262000] APIC calibration not consistent with PM-Timer: 884ms instead of 100ms
> [    0.262000] APIC delta adjusted to PM-Timer: 6249637 (55259362)
> [    0.262000] TSC delta adjusted to PM-Timer: 279317813 (2469731015)
> [    0.262000] ..... delta 6249637
> [    0.262000] ..... mult: 268419865
> [    0.262000] ..... calibration result: 999941
> [    0.262000] ..... CPU clock speed is 2793.0178 MHz.
> [    0.262000] ..... host bus clock speed is 999.0941 MHz.
> [    0.481000] prandom: seed boundary self test passed
> [    0.496000] prandom: 100 self tests passed
> [    0.534000] regulator-dummy: no parameters
> [    0.565098] NET: Registered protocol family 16
> [    0.604000] cpuidle: using governor ladder
> [    0.604000] cpuidle: using governor menu
> [    0.624650] ACPI: bus type PCI registered
> [    0.627000] PCI: Using configuration type 1 for base access
> [    1.016000] bio: create slab <bio-0> at 0
> [    1.083000] ACPI: Added _OSI(Module Device)
> [    1.083000] ACPI: Added _OSI(Processor Device)
> [    1.083000] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.083000] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.935000] ACPI: Interpreter enabled
> [    1.935000] ACPI: (supports S0 S5)
> [    1.935000] ACPI: Using IOAPIC for interrupt routing
> [    1.940000] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    3.031000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    3.032000] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    3.037000] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    3.091000] PCI host bridge to bus 0000:00
> [    3.092000] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    3.097000] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    3.098381] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    3.099000] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    3.104000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    3.108000] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    3.140000] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    3.181000] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    3.184000] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    3.202000] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    3.212000] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    3.212000] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    3.237000] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    3.245000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    3.245000] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    3.254000] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    3.284000] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    3.285000] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    3.288000] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    3.303000] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    3.331000] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    3.331000] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    3.365000] pci_bus 0000:00: on NUMA node 0
> [    3.417984] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    3.441525] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    3.450000] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    3.464000] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    3.466000] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    3.548000] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    3.583000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    3.584916] vgaarb: loaded
> [    3.585766] vgaarb: bridge control possible 0000:00:02.0
> [    3.599000] pps_core: LinuxPPS API ver. 1 registered
> [    3.599000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    3.599000] PTP clock support registered
> [    3.615000] PCI: Using ACPI for IRQ routing
> [    3.615000] PCI: pci_cache_line_size set to 64 bytes
> [    3.618000] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    3.618000] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    3.688000] Switched to clocksource hpet
> [   20.044842] pnp: PnP ACPI init
> [   20.109672] ACPI: bus type PNP registered
> [   20.232117] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [   20.354061] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [   20.354061] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [   20.377219] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [   20.397707] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [   20.440712] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [   20.462835] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [   20.481989] pnp 00:03: [dma 2]
> [   20.579116] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [   20.809013] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [   20.877919] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [   20.903315] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [   20.973840] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [   21.085087] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [   21.145178] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [   21.603136] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [   21.911660] pnp: PnP ACPI: found 8 devices
> [   21.916124] ACPI: bus type PNP unregistered
> [   22.504827] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [   22.504827] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [   22.504827] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [   22.540995] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [   22.541067] NET: Registered protocol family 1
> [   22.541067] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [   22.568714] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [   22.625743] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [   22.636322] pci 0000:00:02.0: Boot video device
> [   22.684168] PCI: CLS 0 bytes, default 64
> [   23.031316] Unpacking initramfs...
> [  473.621128] debug: unmapping init [mem 0xffff88001293d000-0xffff880013feffff]
> [  473.947136] Scanning for low memory corruption every 60 seconds
> [  474.295597] cryptomgr_test (22) used greatest stack depth: 6400 bytes left
> [  474.645116] cryptomgr_test (23) used greatest stack depth: 5024 bytes left
> [  474.865120] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
> [  475.405348] AVX or AES-NI instructions are not detected.
> [  475.430129] AVX instructions are not detected.
> [  475.804630] futex hash table entries: 256 (order: 2, 22528 bytes)
> [  476.841997] tsc: Refined TSC clocksource calibration: 2793.092 MHz
> [  476.841997] Switched to clocksource tsc
> [  477.327706] bounce pool size: 64 pages
> [  477.327706] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [  477.478007] VFS: Disk quotas dquot_6.5.2
> [  477.478007] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [  477.686862] NTFS driver 2.1.30 [Flags: R/O].
> [  477.686862] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
> [  477.785109] QNX4 filesystem 0.2.3 registered.
> [  477.785109] fuse init (API version 7.22)
> [  477.865098] NILFS version 2 loaded
> [  478.953523] GFS2 installed
> [  482.527895] alg: No test for crc32 (crc32-table)
> [  482.655262] alg: No test for lz4 (lz4-generic)
> [  482.826231] alg: No test for stdrng (krng)
> [  483.254034] io scheduler noop registered (default)
> [  484.554097] list_sort_test: start testing list_sort()
> [  485.122686] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> [  485.122686] crc32: self tests passed, processed 225944 bytes in 1162687 nsec
> [  485.122686] crc32c: CRC_LE_BITS = 32
> [  485.137082] crc32c: self tests passed, processed 225944 bytes in 1238960 nsec
> [  496.692002] crc32_combine: 8373 self tests passed
> [  508.470224] crc32c_combine: 8373 self tests passed
> [  508.596905] hgafb: HGA card not detected.
> [  508.626830] hgafb: probe of hgafb.0 failed with error -22
> [  508.740275] ipmi message handler version 39.2
> [  508.777250] IPMI System Interface driver.
> [  508.896868] ipmi_si: Adding default-specified kcs state machine
> [  508.906936] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [  508.920143] ipmi_si: Interface detection failed
> [  508.932938] ipmi_si: Adding default-specified smic state machine
> [  508.933713] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [  508.958833] ipmi_si: Interface detection failed
> [  508.958833] ipmi_si: Adding default-specified bt state machine
> [  508.970965] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [  508.979656] ipmi_si: Interface detection failed
> [  509.057675] ipmi_si: Unable to find any System Interface(s)
> [  509.186772] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [  509.250767] ACPI: Power Button [PWRF]
> [  547.444189] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [  548.091190] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [  549.483150] lkdtm: No crash points registered, enable through debugfs
> [  549.792256] SSFDC read-only Flash Translation layer
> [  549.862948] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [  549.969715] serio: i8042 KBD port at 0x60,0x64 irq 1
> [  550.050791] serio: i8042 AUX port at 0x60,0x64 irq 12
> [  551.122287] pps pps0: new PPS source ktimer
> [  551.205248] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [  551.227787] pps pps0: ktimer PPS source registered
> [  551.287212] Driver for 1-wire Dallas network protocol.
> [  553.754285] applesmc: supported laptop not found!
> [  553.754285] applesmc: driver init failed (ret=-19)!
> [  554.111732] acquirewdt: WDT driver for Acquire single board computer initialising
> [  554.290518] acquirewdt: I/O address 0x0043 already in use
> [  554.290518] acquirewdt: probe of acquirewdt failed with error -5
> [  554.344623] sbc8360: Timeout set at 60000 ms
> [  554.354121] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
> [  554.421221] smsc37b787_wdt: Unable to register miscdev on minor 130
> [  554.431185] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
> [  554.628984] ledtrig-cpu: registered to indicate activity on CPUs
> [  554.713755] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [  554.914217] oprofile: using timer interrupt.
> [  556.048068] 
> [  556.048068] printing PIC contents
> [  556.048068] ... PIC  IMR: ffff
> [  556.048068] ... PIC  IRR: 1013
> [  556.048068] ... PIC  ISR: 0000
> [  556.048068] ... PIC ELCR: 0c00
> [  556.048068] printing local APIC contents on CPU#0/0:
> [  556.048068] ... APIC ID:      00000000 (0)
> [  556.048068] ... APIC VERSION: 00050011
> [  556.048068] ... APIC TASKPRI: 00000000 (00)
> [  556.048068] ... APIC ARBPRI: 00000000 (00)
> [  556.048068] ... APIC PROCPRI: 00000000
> [  556.048068] ... APIC LDR: 01000000
> [  556.048068] ... APIC DFR: f0000000
> [  556.048068] ... APIC SPIV: 000001ff
> [  556.048068] ... APIC ISR field:
> [  556.048068] 0000000000000000000000000000000000000000000000000000000000000000
> [  556.048068] ... APIC TMR field:
> [  556.048068] 0000000000000000000000000000000000000000000000000000000000000000
> [  556.048068] ... APIC IRR field:
> [  556.048068] 0000000000000000000000000000000000000000000000000000000000008000
> [  556.048068] ... APIC ESR: 00000000
> [  556.048068] ... APIC ICR: 00000831
> [  556.048068] ... APIC ICR2: 01000000
> [  556.048068] ... APIC LVTT: 000200ef
> [  556.048068] ... APIC LVTPC: 00010000
> [  556.048068] ... APIC LVT0: 00010700
> [  556.048068] ... APIC LVT1: 00000400
> [  556.048068] ... APIC LVTERR: 000000fe
> [  556.048068] ... APIC TMICT: 0000f420
> [  556.048068] ... APIC TMCCT: 00001199
> [  556.048068] ... APIC TDCR: 00000003
> [  556.048068] 
> [  556.328261] number of MP IRQ sources: 15.
> [  556.328698] number of IO-APIC #0 registers: 24.
> [  556.328698] testing the IO APIC.......................
> [  556.328698] IO APIC #0......
> [  556.328698] .... register #00: 00000000
> [  556.328698] .......    : physical APIC id: 00
> [  556.372734] .......    : Delivery Type: 0
> [  556.415660] .......    : LTS          : 0
> [  556.415679] .... register #01: 00170011
> [  556.415679] .......     : max redirection entries: 17
> [  556.415679] .......     : PRQ implemented: 0
> [  556.415679] .......     : IO APIC version: 11
> [  556.415679] .... register #02: 00000000
> [  556.415679] .......     : arbitration: 00
> [  556.415679] .... IRQ redirection table:
> [  556.446706] 1    0    0   0   0    0    0    00
> [  556.446706] 0    0    0   0   0    1    1    31
> [  556.446706] 0    0    0   0   0    1    1    30
> [  556.446706] 0    0    0   0   0    1    1    33
> [  556.446706] 1    0    0   0   0    1    1    34
> [  556.471704] 1    1    0   0   0    1    1    35
> [  556.472205] 0    0    0   0   0    1    1    36
> [  556.472205] 0    0    0   0   0    1    1    37
> [  556.472205] 0    0    0   0   0    1    1    38
> [  556.486593] 0    1    0   0   0    1    1    39
> [  556.517612] 1    1    0   0   0    1    1    3A
> [  556.605249] 1    1    0   0   0    1    1    3B
> [  556.805597] 0    0    0   0   0    1    1    3C
> [  556.835538] 0    0    0   0   0    1    1    3D
> [  556.835538] 0    0    0   0   0    1    1    3E
> [  556.835538] 0    0    0   0   0    1    1    3F
> [  556.835538] 1    0    0   0   0    0    0    00
> [  556.835538] 1    0    0   0   0    0    0    00
> [  556.835538] 1    0    0   0   0    0    0    00
> [  556.835538] 1    0    0   0   0    0    0    00
> [  556.869587] 1    0    0   0   0    0    0    00
> [  556.869587] 1    0    0   0   0    0    0    00
> [  557.185244] 1    0    0   0   0    0    0    00
> [  557.216703] 1    0    0   0   0    0    0    00
> [  557.223659] IRQ to pin mappings:
> [  557.237969] IRQ0 -> 0:2
> [  557.249097] IRQ1 -> 0:1
> [  557.258131] IRQ3 -> 0:3
> [  557.263106] IRQ4 -> 0:4
> [  557.280774] IRQ5 -> 0:5
> [  557.280774] IRQ6 -> 0:6
> [  557.280774] IRQ7 -> 0:7
> [  557.280774] IRQ8 -> 0:8
> [  557.280774] IRQ9 -> 0:9
> [  557.280774] IRQ10 -> 0:10
> [  557.280774] IRQ11 -> 0:11
> [  557.280774] IRQ12 -> 0:12
> [  557.280774] IRQ13 -> 0:13
> [  557.280774] IRQ14 -> 0:14
> [  557.280774] IRQ15 -> 0:15
> [  557.362926] .................................... done.
> [  562.143710] debug: unmapping init [mem 0xffffffff81841000-0xffffffff818e0fff]
> [  562.353714] Failed to execute /init (error -14)
> [  562.400008] Starting init: /sbin/init exists but couldn't execute it (error -14)
> [  562.400008] Starting init: /etc/init exists but couldn't execute it (error -13)
> [  562.422116] Starting init: /bin/sh exists but couldn't execute it (error -14)
> [  562.450049] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
> [  562.450049] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc1-00171-g03bbd59 #1
> [  562.450049]  0000000000000000 ffff880012035ec0 ffffffff81380af6 ffff880012035f38
> [  562.450049]  ffffffff8137e608 ffffffff00000008 ffff880012035f48 ffff880012035ee8
> [  562.450049]  0000000000000000 ffffffff81067fcf 0000000000000001 0000000000000000
> [  562.450049] Call Trace:
> [  562.450049]  [<ffffffff81380af6>] dump_stack+0x19/0x1b
> [  562.450049]  [<ffffffff8137e608>] panic+0xcb/0x1ca
> [  562.450049]  [<ffffffff81067fcf>] ? console_unlock+0x319/0x336
> [  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
> [  562.450049]  [<ffffffff8137785e>] kernel_init+0xd1/0xd5
> [  562.450049]  [<ffffffff81386d3a>] ret_from_fork+0x7a/0xb0
> [  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
> [  562.450049] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> 
> Elapsed time: 610
> qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconfig-i0-04091721/03bbd596ac04fef47ce93a730b8f086d797c3021/vmlinuz-3.14.0-rc1-00171-g03bbd59 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-i0-04091721/linux-devel:devel-hourly-2014040912:03bbd596ac04fef47ce93a730b8f086d797c3021:bisect-linux7/.vmlinuz-03bbd596ac04fef47ce93a730b8f086d797c3021-20140411030343-500-brickland3 branch=linux-devel/devel-hourly-2014040912 BOOT_IMAGE=/kernel/x86_64-randconfig-i0-04091721/03bbd596ac04fef47ce93a730b8f086d797c3021/vmlinuz-3.14.0-rc1-00171-g03bbd59 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-brickland3-102 -serial file:/dev/shm/kboot/serial-quantal-brickland3-102 -daemonize -display none -monitor null 
> 
> 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.14.0-rc1 Kernel Configuration
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
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_COMPILE_TEST=y
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
> # CONFIG_KERNEL_LZO is not set
> CONFIG_KERNEL_LZ4=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_AUDIT is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
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
> # CONFIG_CGROUPS is not set
> CONFIG_CHECKPOINT_RESTORE=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
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
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> CONFIG_SIGNALFD=y
> # CONFIG_TIMERFD is not set
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=y
> CONFIG_OPROFILE_EVENT_MULTIPLEX=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
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
> # CONFIG_GCOV_PROFILE_ALL is not set
> # CONFIG_GCOV_FORMAT_AUTODETECT is not set
> CONFIG_GCOV_FORMAT_3_4=y
> # CONFIG_GCOV_FORMAT_4_7 is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> # CONFIG_MODULE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> CONFIG_MODULE_SRCVERSION_ALL=y
> # CONFIG_MODULE_SIG is not set
> CONFIG_BLOCK=y
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_BSGLIB is not set
> CONFIG_BLK_DEV_INTEGRITY=y
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
> # CONFIG_IOSCHED_DEADLINE is not set
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_XEN is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
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
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> # CONFIG_CPU_SUP_INTEL is not set
> # CONFIG_CPU_SUP_AMD is not set
> # CONFIG_CPU_SUP_CENTAUR is not set
> CONFIG_HPET_TIMER=y
> # CONFIG_DMI is not set
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_NR_CPUS=1
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
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_I8K=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_DIRECT_GBPAGES is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_MEMORY_PROBE=y
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
> CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> CONFIG_MEMORY_HOTREMOVE=y
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
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_ZBUD is not set
> CONFIG_ZSMALLOC=y
> # CONFIG_PGTABLE_MAPPING is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_ARCH_RANDOM is not set
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> # CONFIG_SCHED_HRTICK is not set
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_HOTPLUG_MEMORY is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
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
> 
> #
> # Memory power savings
> #
> # CONFIG_I7300_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> # CONFIG_ISA_DMA_API is not set
> CONFIG_PCCARD=m
> CONFIG_PCMCIA=m
> # CONFIG_PCMCIA_LOAD_CIS is not set
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
> # CONFIG_BINFMT_MISC is not set
> # CONFIG_COREDUMP is not set
> CONFIG_IA32_EMULATION=y
> # CONFIG_IA32_AOUT is not set
> CONFIG_X86_X32=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_NET_MPLS_GSO is not set
> # CONFIG_HSR is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> # CONFIG_BPF_JIT is not set
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_NFC is not set
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
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=m
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
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
> CONFIG_MTD=y
> CONFIG_MTD_TESTS=m
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
> CONFIG_MTD_CMDLINE_PARTS=y
> CONFIG_MTD_AR7_PARTS=y
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=m
> CONFIG_MTD_BLOCK_RO=y
> # CONFIG_FTL is not set
> CONFIG_NFTL=m
> CONFIG_NFTL_RW=y
> CONFIG_INFTL=y
> # CONFIG_RFD_FTL is not set
> CONFIG_SSFDC=y
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=m
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> # CONFIG_MTD_CFI is not set
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
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=m
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=m
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> # CONFIG_MTD_TS5500 is not set
> CONFIG_MTD_AMD76XROM=y
> # CONFIG_MTD_ICHXROM is not set
> # CONFIG_MTD_ESB2ROM is not set
> # CONFIG_MTD_CK804XROM is not set
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> # CONFIG_MTD_L440GX is not set
> # CONFIG_MTD_INTEL_VR_NOR is not set
> CONFIG_MTD_PLATRAM=m
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_SLRAM is not set
> CONFIG_MTD_PHRAM=y
> CONFIG_MTD_MTDRAM=m
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTD_BLOCK2MTD=m
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=m
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> CONFIG_MTD_NAND_ECC=m
> CONFIG_MTD_NAND_ECC_SMC=y
> CONFIG_MTD_NAND=m
> CONFIG_MTD_NAND_BCH=m
> CONFIG_MTD_NAND_ECC_BCH=y
> # CONFIG_MTD_SM_COMMON is not set
> CONFIG_MTD_NAND_DENALI=m
> # CONFIG_MTD_NAND_DENALI_PCI is not set
> CONFIG_MTD_NAND_IDS=m
> # CONFIG_MTD_NAND_RICOH is not set
> CONFIG_MTD_NAND_DISKONCHIP=m
> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
> # CONFIG_MTD_NAND_DOCG4 is not set
> # CONFIG_MTD_NAND_CAFE is not set
> CONFIG_MTD_NAND_NANDSIM=m
> # CONFIG_MTD_NAND_PLATFORM is not set
> CONFIG_MTD_NAND_SH_FLCTL=m
> CONFIG_MTD_ONENAND=m
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=m
> CONFIG_MTD_ONENAND_OTP=y
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> 
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> # CONFIG_MTD_UBI is not set
> CONFIG_PARPORT=m
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=m
> # CONFIG_PARPORT_SERIAL is not set
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=m
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=m
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
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_ZRAM is not set
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
> CONFIG_SENSORS_LIS3LV02D=m
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=m
> CONFIG_ATMEL_SSC=m
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=m
> CONFIG_ISL29003=m
> CONFIG_ISL29020=m
> CONFIG_SENSORS_TSL2550=m
> # CONFIG_SENSORS_BH1780 is not set
> CONFIG_SENSORS_BH1770=m
> CONFIG_SENSORS_APDS990X=m
> CONFIG_HMC6352=m
> CONFIG_DS1682=m
> # CONFIG_VMWARE_BALLOON is not set
> # CONFIG_BMP085_I2C is not set
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=m
> # CONFIG_SRAM is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> CONFIG_EEPROM_LEGACY=m
> CONFIG_EEPROM_MAX6875=m
> CONFIG_EEPROM_93CX6=m
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_SENSORS_LIS3_I2C=m
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Host Driver
> #
> # CONFIG_INTEL_MIC_HOST is not set
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_INTEL_MIC_CARD=m
> # CONFIG_GENWQE is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=m
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_BLK_DEV_IDE_SATA=y
> # CONFIG_IDE_GD is not set
> CONFIG_BLK_DEV_IDECS=m
> # CONFIG_BLK_DEV_DELKIN is not set
> # CONFIG_BLK_DEV_IDECD is not set
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> CONFIG_IDE_TASK_IOCTL=y
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=m
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> 
> #
> # PCI IDE chipsets support
> #
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=m
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> # CONFIG_NETDEVICES is not set
> # CONFIG_VHOST_NET is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=m
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
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
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_SH_KEYSC is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> # CONFIG_MOUSE_PS2 is not set
> CONFIG_MOUSE_SERIAL=m
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=m
> CONFIG_MOUSE_VSXXXAA=y
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> # CONFIG_JOYSTICK_ANALOG is not set
> CONFIG_JOYSTICK_A3D=y
> CONFIG_JOYSTICK_ADI=y
> # CONFIG_JOYSTICK_COBRA is not set
> CONFIG_JOYSTICK_GF2K=m
> CONFIG_JOYSTICK_GRIP=y
> # CONFIG_JOYSTICK_GRIP_MP is not set
> CONFIG_JOYSTICK_GUILLEMOT=y
> CONFIG_JOYSTICK_INTERACT=m
> CONFIG_JOYSTICK_SIDEWINDER=m
> CONFIG_JOYSTICK_TMDC=m
> # CONFIG_JOYSTICK_IFORCE is not set
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> # CONFIG_JOYSTICK_SPACEORB is not set
> # CONFIG_JOYSTICK_SPACEBALL is not set
> CONFIG_JOYSTICK_STINGER=m
> # CONFIG_JOYSTICK_TWIDJOY is not set
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=m
> CONFIG_JOYSTICK_GAMECON=m
> CONFIG_JOYSTICK_TURBOGRAFX=m
> # CONFIG_JOYSTICK_AS5011 is not set
> CONFIG_JOYSTICK_JOYDUMP=m
> # CONFIG_JOYSTICK_XPAD is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> # CONFIG_SERIO_ALTERA_PS2 is not set
> CONFIG_SERIO_PS2MULT=m
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> # CONFIG_GAMEPORT_L4 is not set
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
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
> # CONFIG_SERIAL_8250_CS is not set
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_CLPS711X is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_ST_ASC is not set
> # CONFIG_TTY_PRINTK is not set
> # CONFIG_PRINTER is not set
> # CONFIG_PPDEV is not set
> # CONFIG_VIRTIO_CONSOLE is not set
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=m
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=m
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> 
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> CONFIG_CARDMAN_4000=m
> CONFIG_CARDMAN_4040=m
> # CONFIG_MWAVE is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> # CONFIG_TCG_TIS is not set
> # CONFIG_TCG_TIS_I2C_ATMEL is not set
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_TIS_I2C_NUVOTON=m
> CONFIG_TCG_NSC=y
> # CONFIG_TCG_ATMEL is not set
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TELCLOCK=m
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_MUX=m
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_PCA9541=m
> # CONFIG_I2C_MUX_PCA954x is not set
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
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
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
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> CONFIG_I2C_OCORES=m
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_RIIC is not set
> # CONFIG_I2C_SH_MOBILE is not set
> CONFIG_I2C_SIMTEC=m
> CONFIG_I2C_XILINX=m
> CONFIG_I2C_RCAR=m
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT is not set
> CONFIG_I2C_PARPORT_LIGHT=m
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
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
> # CONFIG_PPS_CLIENT_PARPORT is not set
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
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2482=m
> # CONFIG_W1_MASTER_DS1WM is not set
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> # CONFIG_W1_SLAVE_SMEM is not set
> CONFIG_W1_SLAVE_DS2408=y
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=m
> CONFIG_W1_SLAVE_DS2433_CRC=y
> # CONFIG_W1_SLAVE_DS2760 is not set
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=m
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> # CONFIG_GENERIC_ADC_BATTERY is not set
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_DS2780=y
> CONFIG_BATTERY_DS2781=y
> # CONFIG_BATTERY_DS2782 is not set
> CONFIG_BATTERY_SBS=m
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> CONFIG_CHARGER_MAX8903=m
> # CONFIG_CHARGER_LP8727 is not set
> CONFIG_CHARGER_BQ2415X=m
> CONFIG_CHARGER_SMB347=m
> CONFIG_BATTERY_GOLDFISH=m
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7410=m
> CONFIG_SENSORS_ADT7411=m
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=m
> # CONFIG_SENSORS_ADT7475 is not set
> CONFIG_SENSORS_ASC7621=m
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=m
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> CONFIG_SENSORS_F71805F=y
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> CONFIG_SENSORS_FSCHMD=m
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_G762 is not set
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_HTU21=m
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IBMAEM=y
> CONFIG_SENSORS_IBMPEX=m
> CONFIG_SENSORS_IIO_HWMON=m
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LM63=m
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> # CONFIG_SENSORS_LM85 is not set
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_LM95234=m
> CONFIG_SENSORS_LM95241=m
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_MAX16065=m
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX1668 is not set
> CONFIG_SENSORS_MAX197=m
> CONFIG_SENSORS_MAX6639=m
> CONFIG_SENSORS_MAX6642=m
> CONFIG_SENSORS_MAX6650=m
> # CONFIG_SENSORS_MAX6697 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_NCT6775=y
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> # CONFIG_SENSORS_PCF8591 is not set
> CONFIG_PMBUS=m
> CONFIG_SENSORS_PMBUS=m
> # CONFIG_SENSORS_ADM1275 is not set
> # CONFIG_SENSORS_LM25066 is not set
> CONFIG_SENSORS_LTC2978=m
> # CONFIG_SENSORS_MAX16064 is not set
> CONFIG_SENSORS_MAX34440=m
> CONFIG_SENSORS_MAX8688=m
> # CONFIG_SENSORS_UCD9000 is not set
> CONFIG_SENSORS_UCD9200=m
> CONFIG_SENSORS_ZL6100=m
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_SMM665=m
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_EMC1403=m
> CONFIG_SENSORS_EMC2103=m
> CONFIG_SENSORS_EMC6W201=m
> # CONFIG_SENSORS_SMSC47M1 is not set
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=m
> CONFIG_SENSORS_SCH5636=y
> CONFIG_SENSORS_ADS1015=m
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_AMC6821=m
> CONFIG_SENSORS_INA209=m
> CONFIG_SENSORS_INA2XX=m
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> CONFIG_SENSORS_VIA_CPUTEMP=m
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> # CONFIG_SENSORS_W83795 is not set
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_MC13783_ADC=m
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_RCAR_THERMAL is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> CONFIG_DW_WATCHDOG=m
> CONFIG_RETU_WATCHDOG=m
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=m
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> CONFIG_F71808E_WDT=m
> # CONFIG_SP5100_TCO is not set
> # CONFIG_SC520_WDT is not set
> CONFIG_SBC_FITPC2_WATCHDOG=y
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=m
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_IE6XX_WDT is not set
> # CONFIG_ITCO_WDT is not set
> CONFIG_IT8712F_WDT=y
> CONFIG_IT87_WDT=m
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=m
> CONFIG_PC87413_WDT=m
> # CONFIG_NV_TCO is not set
> CONFIG_60XX_WDT=m
> CONFIG_SBC8360_WDT=y
> # CONFIG_CPU5_WDT is not set
> CONFIG_SMSC_SCH311X_WDT=m
> CONFIG_SMSC37B787_WDT=y
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=m
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> CONFIG_W83977F_WDT=m
> # CONFIG_MACHZ_WDT is not set
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
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
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> CONFIG_MFD_CROS_EC=y
> # CONFIG_MFD_CROS_EC_I2C is not set
> CONFIG_MFD_MC13XXX=m
> CONFIG_MFD_MC13XXX_I2C=m
> CONFIG_HTC_PASIC3=y
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> CONFIG_MFD_RETU=m
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_SI476X_CORE=m
> CONFIG_MFD_SM501=y
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_MFD_LP3943=m
> CONFIG_TPS6105X=m
> CONFIG_TPS6507X=m
> CONFIG_MFD_TPS65217=m
> CONFIG_MFD_WL1273_CORE=m
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_ACT8865=m
> # CONFIG_REGULATOR_AD5398 is not set
> CONFIG_REGULATOR_ANATOP=m
> CONFIG_REGULATOR_DA9210=m
> CONFIG_REGULATOR_FAN53555=m
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_LP3971 is not set
> CONFIG_REGULATOR_LP3972=m
> CONFIG_REGULATOR_LP872X=m
> CONFIG_REGULATOR_LP8755=m
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=m
> CONFIG_REGULATOR_MAX8952=m
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_MC13XXX_CORE=m
> # CONFIG_REGULATOR_MC13783 is not set
> CONFIG_REGULATOR_MC13892=m
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_TPS51632=m
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=m
> CONFIG_REGULATOR_TPS65023=m
> CONFIG_REGULATOR_TPS6507X=m
> CONFIG_REGULATOR_TPS65217=m
> CONFIG_MEDIA_SUPPORT=m
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> CONFIG_MEDIA_RC_SUPPORT=y
> CONFIG_VIDEO_ADV_DEBUG=y
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_DVB_CORE=m
> # CONFIG_TTPCI_EEPROM is not set
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=m
> # CONFIG_RC_MAP is not set
> # CONFIG_RC_DECODERS is not set
> # CONFIG_RC_DEVICES is not set
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> CONFIG_SMS_SDIO_DRV=m
> CONFIG_MEDIA_COMMON_OPTIONS=y
> 
> #
> # common driver options
> #
> CONFIG_SMS_SIANO_MDTV=m
> CONFIG_SMS_SIANO_RC=y
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
> CONFIG_MEDIA_ATTACH=y
> 
> #
> # Customize TV tuners
> #
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2063=m
> # CONFIG_MEDIA_TUNER_MT2266 is not set
> # CONFIG_MEDIA_TUNER_MT2131 is not set
> CONFIG_MEDIA_TUNER_QT1010=m
> CONFIG_MEDIA_TUNER_XC2028=m
> # CONFIG_MEDIA_TUNER_XC5000 is not set
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> CONFIG_MEDIA_TUNER_MXL5007T=m
> # CONFIG_MEDIA_TUNER_MC44S803 is not set
> CONFIG_MEDIA_TUNER_MAX2165=m
> CONFIG_MEDIA_TUNER_TDA18218=m
> CONFIG_MEDIA_TUNER_FC0011=m
> # CONFIG_MEDIA_TUNER_FC0012 is not set
> CONFIG_MEDIA_TUNER_FC0013=m
> CONFIG_MEDIA_TUNER_TDA18212=m
> CONFIG_MEDIA_TUNER_E4000=m
> CONFIG_MEDIA_TUNER_FC2580=m
> CONFIG_MEDIA_TUNER_M88TS2022=m
> CONFIG_MEDIA_TUNER_TUA9001=m
> CONFIG_MEDIA_TUNER_IT913X=m
> CONFIG_MEDIA_TUNER_R820T=m
> 
> #
> # Customise DVB Frontends
> #
> 
> #
> # Multistandard (satellite) frontends
> #
> CONFIG_DVB_STB0899=m
> # CONFIG_DVB_STB6100 is not set
> # CONFIG_DVB_STV090x is not set
> CONFIG_DVB_STV6110x=m
> CONFIG_DVB_M88DS3103=m
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> # CONFIG_DVB_DRXK is not set
> # CONFIG_DVB_TDA18271C2DD is not set
> 
> #
> # DVB-S (satellite) frontends
> #
> # CONFIG_DVB_CX24110 is not set
> CONFIG_DVB_CX24123=m
> CONFIG_DVB_MT312=m
> CONFIG_DVB_ZL10036=m
> CONFIG_DVB_ZL10039=m
> # CONFIG_DVB_S5H1420 is not set
> CONFIG_DVB_STV0288=m
> CONFIG_DVB_STB6000=m
> CONFIG_DVB_STV0299=m
> CONFIG_DVB_STV6110=m
> CONFIG_DVB_STV0900=m
> # CONFIG_DVB_TDA8083 is not set
> CONFIG_DVB_TDA10086=m
> CONFIG_DVB_TDA8261=m
> CONFIG_DVB_VES1X93=m
> # CONFIG_DVB_TUNER_ITD1000 is not set
> # CONFIG_DVB_TUNER_CX24113 is not set
> CONFIG_DVB_TDA826X=m
> CONFIG_DVB_TUA6100=m
> CONFIG_DVB_CX24116=m
> # CONFIG_DVB_CX24117 is not set
> CONFIG_DVB_SI21XX=m
> CONFIG_DVB_TS2020=m
> CONFIG_DVB_DS3000=m
> CONFIG_DVB_MB86A16=m
> CONFIG_DVB_TDA10071=m
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=m
> # CONFIG_DVB_SP887X is not set
> CONFIG_DVB_CX22700=m
> CONFIG_DVB_CX22702=m
> CONFIG_DVB_S5H1432=m
> # CONFIG_DVB_DRXD is not set
> CONFIG_DVB_L64781=m
> CONFIG_DVB_TDA1004X=m
> CONFIG_DVB_NXT6000=m
> CONFIG_DVB_MT352=m
> # CONFIG_DVB_ZL10353 is not set
> CONFIG_DVB_DIB3000MB=m
> CONFIG_DVB_DIB3000MC=m
> # CONFIG_DVB_DIB7000M is not set
> # CONFIG_DVB_DIB7000P is not set
> # CONFIG_DVB_DIB9000 is not set
> CONFIG_DVB_TDA10048=m
> # CONFIG_DVB_AF9013 is not set
> # CONFIG_DVB_EC100 is not set
> CONFIG_DVB_HD29L2=m
> # CONFIG_DVB_STV0367 is not set
> CONFIG_DVB_CXD2820R=m
> # CONFIG_DVB_RTL2830 is not set
> # CONFIG_DVB_RTL2832 is not set
> 
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=m
> CONFIG_DVB_TDA10021=m
> # CONFIG_DVB_TDA10023 is not set
> # CONFIG_DVB_STV0297 is not set
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> # CONFIG_DVB_NXT200X is not set
> CONFIG_DVB_OR51211=m
> CONFIG_DVB_OR51132=m
> CONFIG_DVB_BCM3510=m
> CONFIG_DVB_LGDT330X=m
> CONFIG_DVB_LGDT3305=m
> CONFIG_DVB_LG2160=m
> # CONFIG_DVB_S5H1409 is not set
> # CONFIG_DVB_AU8522_DTV is not set
> CONFIG_DVB_S5H1411=m
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_S921=m
> # CONFIG_DVB_DIB8000 is not set
> CONFIG_DVB_MB86A20S=m
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=m
> CONFIG_DVB_TUNER_DIB0070=m
> # CONFIG_DVB_TUNER_DIB0090 is not set
> 
> #
> # SEC control devices for DVB-S
> #
> CONFIG_DVB_LNBP21=m
> # CONFIG_DVB_LNBP22 is not set
> CONFIG_DVB_ISL6405=m
> # CONFIG_DVB_ISL6421 is not set
> CONFIG_DVB_ISL6423=m
> CONFIG_DVB_A8293=m
> # CONFIG_DVB_LGS8GL5 is not set
> CONFIG_DVB_LGS8GXX=m
> CONFIG_DVB_ATBM8830=m
> # CONFIG_DVB_TDA665x is not set
> CONFIG_DVB_IX2505V=m
> CONFIG_DVB_IT913X_FE=m
> # CONFIG_DVB_M88RS2000 is not set
> # CONFIG_DVB_AF9033 is not set
> 
> #
> # Tools to develop new frontends
> #
> CONFIG_DVB_DUMMY_FE=m
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> # CONFIG_FB_BOTH_ENDIAN is not set
> CONFIG_FB_BIG_ENDIAN=y
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> # CONFIG_FB_MODE_HELPERS is not set
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=m
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> CONFIG_FB_OPENCORES=m
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SM501 is not set
> CONFIG_FB_GOLDFISH=y
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_AUO_K190X=y
> # CONFIG_FB_AUO_K1900 is not set
> CONFIG_FB_AUO_K1901=m
> # CONFIG_FB_SIMPLE is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_PLATFORM=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> CONFIG_BACKLIGHT_ADP8860=m
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_LM3630A is not set
> CONFIG_BACKLIGHT_LM3639=m
> # CONFIG_BACKLIGHT_LP855X is not set
> CONFIG_BACKLIGHT_TPS65217=m
> CONFIG_BACKLIGHT_LV5207LP=m
> CONFIG_BACKLIGHT_BD6107=m
> # CONFIG_LOGO is not set
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> # CONFIG_SND_PCM_OSS is not set
> # CONFIG_SND_SEQUENCER_OSS is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> # CONFIG_SND_DRIVERS is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_PCMCIA is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> 
> #
> # HID support
> #
> CONFIG_HID=m
> CONFIG_HIDRAW=y
> CONFIG_UHID=m
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=m
> CONFIG_HID_ACRUX=m
> CONFIG_HID_ACRUX_FF=y
> CONFIG_HID_APPLE=m
> CONFIG_HID_AUREAL=m
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> # CONFIG_HID_CHICONY is not set
> CONFIG_HID_PRODIKEYS=m
> CONFIG_HID_CYPRESS=m
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=m
> CONFIG_HID_ELECOM=m
> CONFIG_HID_EZKEY=m
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=m
> CONFIG_HID_UCLOGIC=m
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LENOVO_TPKBD=m
> # CONFIG_HID_LOGITECH is not set
> CONFIG_HID_MAGICMOUSE=m
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> CONFIG_HID_MULTITOUCH=m
> CONFIG_HID_ORTEK=m
> CONFIG_HID_PANTHERLORD=m
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=m
> CONFIG_HID_PICOLCD=m
> CONFIG_HID_PICOLCD_FB=y
> # CONFIG_HID_PICOLCD_BACKLIGHT is not set
> # CONFIG_HID_PICOLCD_LCD is not set
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PICOLCD_CIR=y
> CONFIG_HID_PRIMAX=m
> CONFIG_HID_SAITEK=m
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEELSERIES is not set
> CONFIG_HID_SUNPLUS=m
> CONFIG_HID_GREENASIA=m
> # CONFIG_GREENASIA_FF is not set
> CONFIG_HID_SMARTJOYPLUS=m
> # CONFIG_SMARTJOYPLUS_FF is not set
> CONFIG_HID_TIVO=m
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THINGM is not set
> CONFIG_HID_THRUSTMASTER=m
> CONFIG_THRUSTMASTER_FF=y
> # CONFIG_HID_WACOM is not set
> CONFIG_HID_WIIMOTE=m
> CONFIG_HID_XINMO=m
> CONFIG_HID_ZEROPLUS=m
> # CONFIG_ZEROPLUS_FF is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=m
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=m
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
> # CONFIG_KEYSTONE_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_OMAP_CONTROL_USB is not set
> # CONFIG_OMAP_USB3 is not set
> # CONFIG_AM335X_PHY_USB is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_TAHVO_USB is not set
> # CONFIG_USB_RCAR_GEN2_PHY is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> # CONFIG_MMC_BLOCK_BOUNCE is not set
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=m
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> # CONFIG_MMC_SDHCI_PCI is not set
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=m
> # CONFIG_MMC_OMAP_HS is not set
> # CONFIG_MMC_TIFM_SD is not set
> # CONFIG_MMC_SDRICOH_CS is not set
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> # CONFIG_MMC_SH_MMCIF is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=m
> CONFIG_LEDS_LM3642=m
> CONFIG_LEDS_PCA9532=m
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=m
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=m
> CONFIG_LEDS_LP5562=m
> CONFIG_LEDS_LP8501=m
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_PCA963X=m
> CONFIG_LEDS_PCA9685=m
> CONFIG_LEDS_REGULATOR=m
> CONFIG_LEDS_BD2802=m
> # CONFIG_LEDS_MC13783 is not set
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_OT200=y
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> CONFIG_LEDS_TRIGGER_CPU=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=m
> CONFIG_LEDS_TRIGGER_CAMERA=m
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> # CONFIG_EDAC_MM_EDAC is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> # CONFIG_INTEL_IOATDMA is not set
> CONFIG_DW_DMAC_CORE=m
> CONFIG_DW_DMAC=m
> # CONFIG_DW_DMAC_PCI is not set
> CONFIG_TIMB_DMA=m
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> CONFIG_ASYNC_TX_DMA=y
> CONFIG_DMATEST=y
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=m
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=m
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> CONFIG_STAGING=y
> # CONFIG_SLICOSS is not set
> # CONFIG_ECHO is not set
> CONFIG_COMEDI=m
> CONFIG_COMEDI_DEBUG=y
> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
> # CONFIG_COMEDI_MISC_DRIVERS is not set
> # CONFIG_COMEDI_ISA_DRIVERS is not set
> # CONFIG_COMEDI_PCI_DRIVERS is not set
> CONFIG_COMEDI_PCMCIA_DRIVERS=y
> # CONFIG_COMEDI_CB_DAS16_CS is not set
> CONFIG_COMEDI_DAS08_CS=m
> CONFIG_COMEDI_NI_DAQ_700_CS=m
> # CONFIG_COMEDI_NI_DAQ_DIO24_CS is not set
> CONFIG_COMEDI_NI_LABPC_CS=m
> # CONFIG_COMEDI_NI_MIO_CS is not set
> CONFIG_COMEDI_QUATECH_DAQP_CS=m
> CONFIG_COMEDI_8255=m
> CONFIG_COMEDI_FC=m
> CONFIG_COMEDI_DAS08=m
> CONFIG_COMEDI_NI_LABPC=m
> # CONFIG_PANEL is not set
> # CONFIG_DX_SEP is not set
> 
> #
> # IIO staging drivers
> #
> 
> #
> # Accelerometers
> #
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD7291=m
> # CONFIG_AD799X is not set
> CONFIG_LPC32XX_ADC=m
> CONFIG_MXS_LRADC=m
> # CONFIG_SPEAR_ADC is not set
> 
> #
> # Analog digital bi-direction converters
> #
> 
> #
> # Capacitance to digital converters
> #
> CONFIG_AD7150=m
> # CONFIG_AD7152 is not set
> # CONFIG_AD7746 is not set
> 
> #
> # Direct Digital Synthesis
> #
> 
> #
> # Digital gyroscope sensors
> #
> 
> #
> # Network Analyzer, Impedance Converters
> #
> # CONFIG_AD5933 is not set
> 
> #
> # Light sensors
> #
> # CONFIG_SENSORS_ISL29018 is not set
> CONFIG_SENSORS_ISL29028=m
> CONFIG_TSL2583=m
> CONFIG_TSL2x7x=m
> 
> #
> # Magnetometer sensors
> #
> CONFIG_SENSORS_HMC5843=m
> 
> #
> # Active energy metering IC
> #
> # CONFIG_ADE7854 is not set
> 
> #
> # Resolver to digital converters
> #
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_DUMMY_EVGEN=m
> CONFIG_IIO_SIMPLE_DUMMY=m
> CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
> # CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
> # CONFIG_FB_SM7XX is not set
> # CONFIG_CRYSTALHD is not set
> # CONFIG_FB_XGI is not set
> # CONFIG_ACPI_QUICKSTART is not set
> # CONFIG_FT1000 is not set
> 
> #
> # Speakup console speech
> #
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # CONFIG_WIMAX_GDM72XX is not set
> # CONFIG_DGRP is not set
> # CONFIG_XILLYBUS is not set
> # CONFIG_DGNC is not set
> # CONFIG_DGAP is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
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
> # CONFIG_CHROMEOS_PSTORE is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_MAILBOX=y
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=m
> CONFIG_STE_MODEM_RPROC=m
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
> CONFIG_DEVFREQ_GOV_PERFORMANCE=m
> CONFIG_DEVFREQ_GOV_POWERSAVE=m
> CONFIG_DEVFREQ_GOV_USERSPACE=m
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=m
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_ADC_JACK=m
> # CONFIG_MEMORY is not set
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=m
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> # CONFIG_BMA180 is not set
> # CONFIG_HID_SENSOR_ACCEL_3D is not set
> CONFIG_IIO_ST_ACCEL_3AXIS=m
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
> 
> #
> # Analog to digital converters
> #
> CONFIG_MAX1363=m
> CONFIG_MCP3422=m
> # CONFIG_NAU7802 is not set
> CONFIG_TI_ADC081C=m
> 
> #
> # Amplifiers
> #
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=m
> CONFIG_HID_SENSOR_IIO_TRIGGER=m
> CONFIG_IIO_ST_SENSORS_I2C=m
> CONFIG_IIO_ST_SENSORS_CORE=m
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=m
> # CONFIG_AD5380 is not set
> # CONFIG_AD5446 is not set
> CONFIG_MAX517=m
> CONFIG_MCP4725=m
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_HID_SENSOR_GYRO_3D=m
> CONFIG_IIO_ST_GYRO_3AXIS=m
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
> CONFIG_ITG3200=m
> 
> #
> # Humidity sensors
> #
> 
> #
> # Inertial measurement units
> #
> # CONFIG_INV_MPU6050_IIO is not set
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=m
> CONFIG_APDS9300=m
> CONFIG_CM32181=m
> CONFIG_CM36651=m
> CONFIG_GP2AP020A00F=m
> CONFIG_HID_SENSOR_ALS=m
> CONFIG_TCS3472=m
> CONFIG_SENSORS_TSL2563=m
> CONFIG_TSL4531=m
> CONFIG_VCNL4000=m
> 
> #
> # Magnetometer sensors
> #
> # CONFIG_MAG3110 is not set
> # CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Inclinometer sensors
> #
> CONFIG_HID_SENSOR_INCLINOMETER_3D=m
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=m
> 
> #
> # Pressure sensors
> #
> CONFIG_MPL3115=m
> CONFIG_IIO_ST_PRESS=m
> CONFIG_IIO_ST_PRESS_I2C=m
> 
> #
> # Temperature sensors
> #
> # CONFIG_TMP006 is not set
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> CONFIG_FMC=y
> CONFIG_FMC_FAKEDEV=m
> CONFIG_FMC_TRIVIAL=m
> # CONFIG_FMC_WRITE_EEPROM is not set
> # CONFIG_FMC_CHARDEV is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_POWERCAP=y
> # CONFIG_INTEL_RAPL is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> # CONFIG_FIRMWARE_MEMMAP is not set
> CONFIG_DELL_RBU=m
> CONFIG_DCDBAS=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> # CONFIG_EXT2_FS_SECURITY is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=m
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=m
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_FS_XATTR is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> CONFIG_GFS2_FS=y
> # CONFIG_OCFS2_FS is not set
> CONFIG_BTRFS_FS=m
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> CONFIG_BTRFS_DEBUG=y
> # CONFIG_BTRFS_ASSERT is not set
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> # CONFIG_FILE_LOCKING is not set
> CONFIG_FSNOTIFY=y
> # CONFIG_DNOTIFY is not set
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QFMT_V1=y
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> CONFIG_ADFS_FS_RW=y
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> CONFIG_BFS_FS=y
> CONFIG_EFS_FS=y
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> CONFIG_JFFS2_FS_WBUF_VERIFY=y
> # CONFIG_JFFS2_SUMMARY is not set
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
> CONFIG_JFFS2_ZLIB=y
> # CONFIG_JFFS2_LZO is not set
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> CONFIG_SQUASHFS=m
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> CONFIG_SQUASHFS_DECOMP_MULTI=y
> # CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
> # CONFIG_SQUASHFS_XATTR is not set
> CONFIG_SQUASHFS_ZLIB=y
> CONFIG_SQUASHFS_LZO=y
> # CONFIG_SQUASHFS_XZ is not set
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=m
> CONFIG_HPFS_FS=y
> CONFIG_QNX4FS_FS=y
> CONFIG_QNX6FS_FS=m
> CONFIG_QNX6FS_DEBUG=y
> CONFIG_ROMFS_FS=m
> # CONFIG_ROMFS_BACKED_BY_BLOCK is not set
> CONFIG_ROMFS_BACKED_BY_MTD=y
> # CONFIG_ROMFS_BACKED_BY_BOTH is not set
> CONFIG_ROMFS_ON_MTD=y
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=m
> # CONFIG_UFS_FS_WRITE is not set
> CONFIG_UFS_DEBUG=y
> CONFIG_F2FS_FS=m
> CONFIG_F2FS_STAT_FS=y
> # CONFIG_F2FS_FS_XATTR is not set
> # CONFIG_F2FS_CHECK_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=y
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=m
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_MAC_ROMAN=m
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=m
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> # CONFIG_NLS_MAC_ROMANIAN is not set
> CONFIG_NLS_MAC_TURKISH=m
> CONFIG_NLS_UTF8=m
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
> CONFIG_DYNAMIC_DEBUG=y
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=2048
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_SELFTEST=y
> # CONFIG_DEBUG_OBJECTS_FREE is not set
> # CONFIG_DEBUG_OBJECTS_TIMERS is not set
> CONFIG_DEBUG_OBJECTS_WORK=y
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_WRITECOUNT=y
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
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> CONFIG_RCU_CPU_STALL_INFO=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAIL_PAGE_ALLOC=y
> CONFIG_FAIL_MAKE_REQUEST=y
> CONFIG_FAIL_IO_TIMEOUT=y
> CONFIG_FAIL_MMC_REQUEST=y
> CONFIG_FAULT_INJECTION_DEBUG_FS=y
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
> # CONFIG_FUNCTION_GRAPH_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_PREEMPT_TRACER=y
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_STACK_TRACER=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_DYNAMIC_FTRACE is not set
> CONFIG_FUNCTION_PROFILER=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> CONFIG_TEST_LIST_SORT=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=m
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> CONFIG_BUILD_DOCSRC=y
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_TEST_MODULE=m
> CONFIG_TEST_USER_COPY=m
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> # CONFIG_EARLY_PRINTK is not set
> CONFIG_X86_PTDUMP=y
> # CONFIG_DEBUG_RODATA is not set
> CONFIG_DEBUG_SET_MODULE_RONX=y
> CONFIG_DEBUG_NX_TEST=m
> CONFIG_DOUBLEFAULT=y
> CONFIG_DEBUG_TLBFLUSH=y
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
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=m
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
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=m
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> # CONFIG_CRYPTO_HMAC is not set
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=m
> CONFIG_CRYPTO_CRCT10DIF=m
> CONFIG_CRYPTO_GHASH=m
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=m
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA1_SSSE3 is not set
> CONFIG_CRYPTO_SHA256_SSSE3=y
> # CONFIG_CRYPTO_SHA512_SSSE3 is not set
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=m
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_X86_64=m
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> # CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
> CONFIG_CRYPTO_CAST_COMMON=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST5_AVX_X86_64=m
> CONFIG_CRYPTO_CAST6=m
> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
> # CONFIG_CRYPTO_DES is not set
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=y
> # CONFIG_CRYPTO_SALSA20 is not set
> CONFIG_CRYPTO_SALSA20_X86_64=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
> CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=y
> CONFIG_CRYPTO_LZ4=y
> # CONFIG_CRYPTO_LZ4HC is not set
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=m
> CONFIG_CRYPTO_DEV_PADLOCK_AES=m
> # CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_STMP_DEVICE=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> CONFIG_CRC32_SLICEBY4=y
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=m
> # CONFIG_LIBCRC32C is not set
> CONFIG_CRC8=m
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> # CONFIG_XZ_DEC_POWERPC is not set
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_BCH=m
> CONFIG_BCH_CONST_PARAMS=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CORDIC=y
> CONFIG_DDR=y
> 
> 

