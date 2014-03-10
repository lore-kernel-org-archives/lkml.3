Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaCJCqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:46:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:2823 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbaCJCqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:46:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,621,1389772800"; 
   d="log'?scan'208";a="488917098"
Date: Mon, 10 Mar 2014 10:45:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Andy Honig <ahonig@google.com>,
        linux-kernel@vger.kernel.org
Subject: [x86, kaslr] INFO: possible circular locking dependency detected
Message-ID: <20140310024559.GC9322@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/kaslr
commit e2b32e6785138d92d2a40e0d0473575c8c7310a2
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue Feb 25 16:59:17 2014 -0800
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue Feb 25 17:07:26 2014 -0800

    x86, kaslr: randomize module base load address
    
+----------------------------------------------------+-----------+------------+---------------+
|                                                    | v3.14-rc4 | e2b32e6785 | next-20140307 |
+----------------------------------------------------+-----------+------------+---------------+
| boot_successes                                     | 86        | 9          | 5             |
| boot_failures                                      | 4         | 21         | 14            |
| BUG:kernel_boot_hang                               | 4         | 1          |               |
| INFO:possible_circular_locking_dependency_detected | 0         | 20         | 13            |
| backtrace:register_kprobe                          | 0         | 20         | 13            |
| backtrace:init_test_probes                         | 0         | 20         | 13            |
| backtrace:init_kprobes                             | 0         | 20         | 13            |
| backtrace:kernel_init_freeable                     | 0         | 20         | 13            |
| backtrace:kprobe_optimizer                         | 0         | 20         | 13            |
| BUG:kernel_test_crashed                            | 0         | 0          | 1             |
+----------------------------------------------------+-----------+------------+---------------+

[    0.489404] Kprobe smoke test started
[    0.514663] 
[    0.515287] ======================================================
[    0.515561] [ INFO: possible circular locking dependency detected ]
[    0.515561] 3.14.0-rc5-next-20140307-07129-g1b0a7e3 #1 Not tainted
[    0.515561] -------------------------------------------------------
[    0.515561] kworker/0:1/25 is trying to acquire lock:
[    0.515561]  (text_mutex){+.+.+.}, at: [<ffffffff855c2531>] kprobe_optimizer+0x121/0x23c
[    0.515561] 
[    0.515561] but task is already holding lock:
[    0.515561]  (module_mutex){+.+...}, at: [<ffffffff855c2435>] kprobe_optimizer+0x25/0x23c
[    0.515561] 
[    0.515561] which lock already depends on the new lock.
[    0.515561] 
[    0.515561] 
[    0.515561] the existing dependency chain (in reverse order) is:
[    0.515561] 
-> #2 (module_mutex){+.+...}:
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff8502f954>] module_alloc+0x42/0xb5
[    0.515561]        [<ffffffff850db8e5>] alloc_insn_page+0xe/0x10
[    0.515561]        [<ffffffff855c272c>] __get_insn_slot+0xe0/0x165
[    0.515561]        [<ffffffff855bfa73>] arch_prepare_kprobe+0x36/0xb7
[    0.515561]        [<ffffffff855c3401>] register_kprobe+0x330/0x490
[    0.515561]        [<ffffffff850d6ff2>] init_test_probes+0x4e/0x489
[    0.515561]        [<ffffffff85b7017c>] init_kprobes+0x17b/0x189
[    0.515561]        [<ffffffff850020fb>] do_one_initcall+0x9f/0x135
[    0.515561]        [<ffffffff85b54f65>] kernel_init_freeable+0x104/0x196
[    0.515561]        [<ffffffff855adbe9>] kernel_init+0x9/0xd5
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561] 
-> #1 (kprobe_insn_slots.mutex){+.+.+.}:
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff855c2668>] __get_insn_slot+0x1c/0x165
[    0.515561]        [<ffffffff855bfa73>] arch_prepare_kprobe+0x36/0xb7
[    0.515561]        [<ffffffff855c3401>] register_kprobe+0x330/0x490
[    0.515561]        [<ffffffff850d6ff2>] init_test_probes+0x4e/0x489
[    0.515561]        [<ffffffff85b7017c>] init_kprobes+0x17b/0x189
[    0.515561]        [<ffffffff850020fb>] do_one_initcall+0x9f/0x135
[    0.515561]        [<ffffffff85b54f65>] kernel_init_freeable+0x104/0x196
[    0.515561]        [<ffffffff855adbe9>] kernel_init+0x9/0xd5
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561] 
-> #0 (text_mutex){+.+.+.}:
[    0.515561]        [<ffffffff850b0e0f>] validate_chain.isra.20+0x8cf/0xf2e
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff855c2531>] kprobe_optimizer+0x121/0x23c
[    0.515561]        [<ffffffff8508dfc4>] process_one_work+0x237/0x3db
[    0.515561]        [<ffffffff8508edc2>] worker_thread+0x1cb/0x2c4
[    0.515561]        [<ffffffff8509498b>] kthread+0xf1/0xf9
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561] 
[    0.515561] other info that might help us debug this:
[    0.515561] 
[    0.515561] Chain exists of:
  text_mutex --> kprobe_insn_slots.mutex --> module_mutex

[    0.515561]  Possible unsafe locking scenario:
[    0.515561] 
[    0.515561]        CPU0                    CPU1
[    0.515561]        ----                    ----
[    0.515561]   lock(module_mutex);
[    0.515561]                                lock(kprobe_insn_slots.mutex);
[    0.515561]                                lock(module_mutex);
[    0.515561]   lock(text_mutex);
[    0.515561] 
[    0.515561]  *** DEADLOCK ***
[    0.515561] 
[    0.515561] 4 locks held by kworker/0:1/25:
[    0.515561]  #0:  ("events"){.+.+..}, at: [<ffffffff8508df5e>] process_one_work+0x1d1/0x3db
[    0.515561]  #1:  ((optimizing_work).work){+.+...}, at: [<ffffffff8508df5e>] process_one_work+0x1d1/0x3db
[    0.515561]  #2:  (kprobe_mutex){+.+.+.}, at: [<ffffffff855c2427>] kprobe_optimizer+0x17/0x23c
[    0.515561]  #3:  (module_mutex){+.+...}, at: [<ffffffff855c2435>] kprobe_optimizer+0x25/0x23c
[    0.515561] 
[    0.515561] stack backtrace:
[    0.515561] CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 3.14.0-rc5-next-20140307-07129-g1b0a7e3 #1
[    0.515561] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.515561] Workqueue: events kprobe_optimizer
[    0.515561]  0000000000000000 ffff8800137e3b60 ffffffff855b5b1d ffffffff86069110
[    0.515561]  ffff8800137e3ba0 ffffffff855b2850 ffff8800137e4650 ffff8800137e5318
[    0.515561]  ffff8800137e4650 ffff8800137e5318 0000000000000004 ffff8800137e52f0
[    0.515561] Call Trace:
[    0.515561]  [<ffffffff855b5b1d>] dump_stack+0x4d/0x66
[    0.515561]  [<ffffffff855b2850>] print_circular_bug+0x2b4/0x2c2
[    0.515561]  [<ffffffff850b0e0f>] validate_chain.isra.20+0x8cf/0xf2e
[    0.515561]  [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]  [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]  [<ffffffff855c2531>] ? kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]  [<ffffffff855c2531>] ? kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff850b1d8d>] ? trace_hardirqs_on+0xd/0xf
[    0.515561]  [<ffffffff855c2531>] kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff8508dfc4>] process_one_work+0x237/0x3db
[    0.515561]  [<ffffffff8508df5e>] ? process_one_work+0x1d1/0x3db
[    0.515561]  [<ffffffff8508edc2>] worker_thread+0x1cb/0x2c4
[    0.515561]  [<ffffffff8508ebf7>] ? rescuer_thread+0x29b/0x29b
[    0.515561]  [<ffffffff8509498b>] kthread+0xf1/0xf9
[    0.515561]  [<ffffffff8509489a>] ? kthread_stop+0x5a/0x5a
[    0.515561]  [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561]  [<ffffffff8509489a>] ? kthread_stop+0x5a/0x5a
[    0.679517] Kprobe smoke test passed successfully
[    0.681393] bounce pool size: 64 pages
[    0.682499] HugeTLB registered 2 MB page size, pre-allocated 0 pages

git bisect start 56032fc504c9ce9dd6fd697e4687441a7d0ea4a2 v3.13 --
git bisect good 7df4d0c9784117f7bbaec17e9ac7f6545049b56d  # 18:32     25+      2  Merge tag 'spi-v3.14-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect good b338b822eba2fdcbad7aa4149899fb734f9f16ec  # 18:45     25+      0  Merge remote-tracking branch 'input-current/for-linus'
git bisect good 992670b5cd97fdc97e9fe15c3f8c16c218749c96  # 18:58     25+      0  Merge remote-tracking branch 'net-next/master'
git bisect good 8b42ab5d6c5140cad34957a32fa6bdf43e7e0303  # 19:14     25+      0  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 25ec37d3e3bf1f9efec6f05d79fd976bff4624cd  # 19:33      2-      8  Merge remote-tracking branch 'staging/staging-next'
git bisect  bad d2d275f41085c59209725f813c243d318f185d36  # 19:55      0-      2  Merge remote-tracking branch 'workqueues/for-next'
git bisect  bad e88f8465cfcce042e48ff38e796b64df973c7048  # 20:07      0-      4  Merge remote-tracking branch 'ftrace/for-next'
git bisect  bad f4f48a2692f9de0d1ebbeee7ba192a99e86d1773  # 20:24      0-      1  Merge remote-tracking branch 'tip/auto-latest'
git bisect good c149ec107189eeaa818dff7d97e6fe74b0d61bc2  # 20:49     25+      2  Merge branch 'perf/core'
git bisect good d27c8438eeedb6e1367b592c101e3c87cca0b50f  # 21:17     25+      0  Merge branch 'timers/core' into sched/idle
git bisect good abb27428861a8e3fb90c063e2f2c3cdf8e20b1b7  # 21:31     25+      0  Merge branch 'x86/asmlinkage'
git bisect  bad 1a1985d4555edb30b8d807046c7c6f3ca9221217  # 21:41      0-      1  Merge branch 'x86/mm'
git bisect good 957d31ef264d0c8012dcb4a47543987bbdf2c184  # 21:50     25+      0  Merge branch 'x86/cpu'
git bisect good ea4b5c80da79debb2d29e8c27a19a7579d2867c3  # 22:09     25+      0  Merge branch 'x86/cpufeature'
git bisect  bad d6e451515a6167b63e79612c7c107d0916d7f2b2  # 22:18      1-      1  Merge branch 'x86/kaslr'
git bisect  bad e2b32e6785138d92d2a40e0d0473575c8c7310a2  # 22:25      1-      4  x86, kaslr: randomize module base load address
# first bad commit: [e2b32e6785138d92d2a40e0d0473575c8c7310a2] x86, kaslr: randomize module base load address
git bisect good cfbf8d4857c26a8a307fb7cd258074c9dcd8c691  # 22:55     90+      4  Linux 3.14-rc4
git bisect  bad 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 22:55      0-     14  Add linux-next specific files for 20140307
git bisect good ca62eec4e524591b82d9edf7a18e3ae6b691517d  # 23:39     90+      1  Merge branch 'for-3.14-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect  bad 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 23:39      0-     14  Add linux-next specific files for 20140307

Thanks,
Fengguang

--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivytown2-24:20140309134424:x86_64-randconfig-r5-03091328:3.14.0-rc5-next-20140307-07129-g1b0a7e3:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Linux version 3.14.0-rc5-next-20140307-07129-g1b0a7e3 (kbuil=
d@roam) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Mar 9 13:41:01 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r5-03091328/next:master/=
=2Evmlinuz-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-20140309134226-8-ivytow=
n2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r5-03091328/=
1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-next-20140307-0=
7129-g1b0a7e3
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x06691000, 0x06691fff] PGTABLE
[    0.000000] BRK [0x06692000, 0x06692fff] PGTABLE
[    0.000000] BRK [0x06693000, 0x06693fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x06694000, 0x06694fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x06695000, 0x06695fff] PGTABLE
[    0.000000] BRK [0x06696000, 0x06696fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79232 r8192=
 d23168 u1048576
[    0.000000] pcpu-alloc: s79232 r8192 d23168 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380dc40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r5-03091328/next:=
master/.vmlinuz-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-20140309134226-8-i=
vytown2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r5-0309=
1328/1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-next-20140=
307-07129-g1b0a7e3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 292616K/327280K available (5911K kernel code, 1272K =
rwdata, 3396K rodata, 1040K init, 10520K bss, 34664K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.14.0-rc5-next-20140307-07129-g1b0a7e3 (kbuil=
d@roam) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Mar 9 13:41:01 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r5-03091328/next:master/=
=2Evmlinuz-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-20140309134226-8-ivytow=
n2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r5-03091328/=
1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-next-20140307-0=
7129-g1b0a7e3
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x06691000, 0x06691fff] PGTABLE
[    0.000000] BRK [0x06692000, 0x06692fff] PGTABLE
[    0.000000] BRK [0x06693000, 0x06693fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x06694000, 0x06694fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x06695000, 0x06695fff] PGTABLE
[    0.000000] BRK [0x06696000, 0x06696fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13c66001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s79232 r8192=
 d23168 u1048576
[    0.000000] pcpu-alloc: s79232 r8192 d23168 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380dc40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r5-03091328/next:=
master/.vmlinuz-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-20140309134226-8-i=
vytown2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r5-0309=
1328/1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-next-20140=
307-07129-g1b0a7e3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 292616K/327280K available (5911K kernel code, 1272K =
rwdata, 3396K rodata, 1040K init, 10520K bss, 34664K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2494.168 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4988.33 Bogo=
MIPS (lpj=3D2494168)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004864] Security Framework initialized
[    0.005018] AppArmor: AppArmor initialized
[    0.006046] Mount-cache hash table entries: 256
[    0.008047] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008047] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.008047] tlb_flushall_shift: 6
[    0.009084] debug: unmapping init [mem 0xffffffff85c44000-0xffffffff85c4=
9fff]
[    0.013868] Getting VERSION: 50014
[    0.014035] Getting VERSION: 50014
[    0.015011] Getting ID: 0
[    0.016017] Getting ID: ff000000
[    0.017017] Getting LVT0: 8700
[    0.018011] Getting LVT1: 8400
[    0.019030] enabled ExtINT on CPU#0
[    0.022050] ENABLING IO-APIC IRQs
[    0.022974] init IO_APIC IRQs
[    0.023011]  apic 0 pin 0 not connected
[    0.024060] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.025042] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.026037] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.027036] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.028036] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.029036] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.030036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.031036] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.032040] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.033035] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.034046] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.035040] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.036044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.037036] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.038039] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.039030]  apic 0 pin 16 not connected
[    0.040008]  apic 0 pin 17 not connected
[    0.042019]  apic 0 pin 18 not connected
[    0.043008]  apic 0 pin 19 not connected
[    0.044008]  apic 0 pin 20 not connected
[    0.045009]  apic 0 pin 21 not connected
[    0.046008]  apic 0 pin 22 not connected
[    0.047008]  apic 0 pin 23 not connected
[    0.048167] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.049008] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.053008] Using local APIC timer interrupts.
[    0.053008] calibrating APIC timer ...
[    0.055000] ... lapic delta =3D 6249793
[    0.055000] ... PM-Timer delta =3D 357939
[    0.055000] ... PM-Timer result ok
[    0.055000] ..... delta 6249793
[    0.055000] ..... mult: 268426565
[    0.055000] ..... calibration result: 999966
[    0.055000] ..... CPU clock speed is 2492.0586 MHz.
[    0.055000] ..... host bus clock speed is 999.0966 MHz.
[    0.055077] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.060981] x86: Booting SMP configuration:
[    0.061009] .... node  #0, CPUs:      #1
[    0.060251] kvm-clock: cpu 1, msr 0:13c66041, secondary cpu clock
[    0.060251] masked ExtINT on CPU#1
[    0.075187] KVM setup async PF for cpu 1
[    0.075276] x86: Booted up 1 node, 2 CPUs
[    0.075284] ----------------
[    0.075285] | NMI testsuite:
[    0.075285] --------------------
[    0.075187]   remote IPI:
[    0.075187] kvm-stealtime: cpu 1, msr 1390dc40
[    0.083035]   ok  |
[    0.083824]    local IPI:  ok  |
[    0.090014] --------------------
[    0.090870] Good, all   2 testcases passed! |
[    0.091006] ---------------------------------
[    0.092008] smpboot: Total of 2 processors activated (9976.67 BogoMIPS)
[    0.095216] devtmpfs: initialized
[    0.097077] EVM: security.capability
[    0.098753] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.099658] regulator-dummy: no parameters
[    0.101258] NET: Registered protocol family 16
[    0.103159] cpuidle: using governor ladder
[    0.104009] cpuidle: using governor menu
[    0.106827] ACPI: bus type PCI registered
[    0.108034] PCI: Using configuration type 1 for base access
[    0.117521] ACPI: Added _OSI(Module Device)
[    0.118008] ACPI: Added _OSI(Processor Device)
[    0.119007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.120007] ACPI: Added _OSI(Processor Aggregator Device)
[    0.129723] ACPI: Interpreter enabled
[    0.130021] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.132673] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.135043] ACPI: (supports S0 S3)
[    0.136006] ACPI: Using IOAPIC for interrupt routing
[    0.137056] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.151695] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.152017] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.153067] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.155679] PCI host bridge to bus 0000:00
[    0.156011] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.157009] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.158009] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.159009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.160009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.161092] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.163629] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.165876] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.169009] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.171792] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.172490] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.173021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.175405] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.178052] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.180057] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.189048] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.191877] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.193008] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.195537] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.202009] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.204232] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.206009] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.211618] pci_bus 0000:00: on NUMA node 0
[    0.213927] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.216060] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.218108] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.220174] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.222103] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.224732] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.226396] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.227009] vgaarb: loaded
[    0.228006] vgaarb: bridge control possible 0000:00:02.0
[    0.230115] SCSI subsystem initialized
[    0.231783] PCI: Using ACPI for IRQ routing
[    0.232011] PCI: pci_cache_line_size set to 64 bytes
[    0.234136] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.235020] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.237628] irda_init()
[    0.238113] NET: Registered protocol family 23
[    0.239074] Bluetooth: Core ver 2.19
[    0.240042] NET: Registered protocol family 31
[    0.241006] Bluetooth: HCI device and connection manager initialized
[    0.242035] Bluetooth: HCI socket layer initialized
[    0.243014] Bluetooth: L2CAP socket layer initialized
[    0.244071] Bluetooth: SCO socket layer initialized
[    0.245027] NET: Registered protocol family 8
[    0.246007] NET: Registered protocol family 20
[    0.247102] nfc: nfc_init: NFC Core ver 0.1
[    0.248092] NET: Registered protocol family 39
[    0.250298] Switched to clocksource kvm-clock
[    0.252003] AppArmor: AppArmor Filesystem Enabled
[    0.253185] pnp: PnP ACPI init
[    0.254083] ACPI: bus type PNP registered
[    0.255157] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.257139] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.258596] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.270258] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.271705] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.273655] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.275121] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.276958] pnp 00:03: [dma 2]
[    0.277888] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.279351] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.281278] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.282816] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.284761] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.286671] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.288363] pnp: PnP ACPI: found 7 devices
[    0.289349] ACPI: bus type PNP unregistered
[    0.307078] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.308314] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.309545] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.310865] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.312269] NET: Registered protocol family 1
[    0.313338] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.314633] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.315926] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.317273] pci 0000:00:02.0: Boot video device
[    0.318371] PCI: CLS 0 bytes, default 64
[    0.319790] Unpacking initramfs...
[    0.427950] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    0.431246] Scanning for low memory corruption every 60 seconds
[    0.432875] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.435152] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.435267] cryptomgr_test (26) used greatest stack depth: 6552 bytes le=
ft
[    0.438664] AVX or AES-NI instructions are not detected.
[    0.439842] AVX instructions are not detected.
[    0.440873] AVX instructions are not detected.
[    0.441904] AVX instructions are not detected.
[    0.442939] AVX2 or AES-NI instructions are not detected.
[    0.444117] AVX2 instructions are not detected.
[    0.446879] Initializing RT-Tester: OK
[    0.447841] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.451052] spin_lock-torture: Creating torture_shuffle task
[    0.452457] spin_lock-torture: torture_shuffle task started
[    0.452469] spin_lock-torture: Creating torture_stutter task
[    0.452557] spin_lock-torture: Creating lock_torture_writer task
[    0.452659] spin_lock-torture: torture_stutter task started
[    0.457648] spin_lock-torture: Creating lock_torture_writer task
[    0.457720] spin_lock-torture: lock_torture_writer task started
[    0.457741] spin_lock-torture: Creating lock_torture_writer task
[    0.457810] spin_lock-torture: lock_torture_writer task started
[    0.457830] spin_lock-torture: Creating lock_torture_writer task
[    0.457914] spin_lock-torture: lock_torture_writer task started
[    0.457934] spin_lock-torture: Creating lock_torture_stats task
[    0.457995] spin_lock-torture: lock_torture_writer task started
[    0.458799] futex hash table entries: 512 (order: 4, 65536 bytes)
[    0.458918] Initialise system trusted keyring
[    0.459035] audit: initializing netlink subsys (disabled)
[    0.459178] audit: type=3D2000 audit(1394343786.846:1): initialized
[    0.476898] spin_lock-torture: lock_torture_stats task started
[    0.489404] Kprobe smoke test started
[    0.514663]=20
[    0.515287] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.515561] [ INFO: possible circular locking dependency detected ]
[    0.515561] 3.14.0-rc5-next-20140307-07129-g1b0a7e3 #1 Not tainted
[    0.515561] -------------------------------------------------------
[    0.515561] kworker/0:1/25 is trying to acquire lock:
[    0.515561]  (text_mutex){+.+.+.}, at: [<ffffffff855c2531>] kprobe_optim=
izer+0x121/0x23c
[    0.515561]=20
[    0.515561] but task is already holding lock:
[    0.515561]  (module_mutex){+.+...}, at: [<ffffffff855c2435>] kprobe_opt=
imizer+0x25/0x23c
[    0.515561]=20
[    0.515561] which lock already depends on the new lock.
[    0.515561]=20
[    0.515561]=20
[    0.515561] the existing dependency chain (in reverse order) is:
[    0.515561]=20
-> #2 (module_mutex){+.+...}:
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff8502f954>] module_alloc+0x42/0xb5
[    0.515561]        [<ffffffff850db8e5>] alloc_insn_page+0xe/0x10
[    0.515561]        [<ffffffff855c272c>] __get_insn_slot+0xe0/0x165
[    0.515561]        [<ffffffff855bfa73>] arch_prepare_kprobe+0x36/0xb7
[    0.515561]        [<ffffffff855c3401>] register_kprobe+0x330/0x490
[    0.515561]        [<ffffffff850d6ff2>] init_test_probes+0x4e/0x489
[    0.515561]        [<ffffffff85b7017c>] init_kprobes+0x17b/0x189
[    0.515561]        [<ffffffff850020fb>] do_one_initcall+0x9f/0x135
[    0.515561]        [<ffffffff85b54f65>] kernel_init_freeable+0x104/0x196
[    0.515561]        [<ffffffff855adbe9>] kernel_init+0x9/0xd5
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561]=20
-> #1 (kprobe_insn_slots.mutex){+.+.+.}:
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff855c2668>] __get_insn_slot+0x1c/0x165
[    0.515561]        [<ffffffff855bfa73>] arch_prepare_kprobe+0x36/0xb7
[    0.515561]        [<ffffffff855c3401>] register_kprobe+0x330/0x490
[    0.515561]        [<ffffffff850d6ff2>] init_test_probes+0x4e/0x489
[    0.515561]        [<ffffffff85b7017c>] init_kprobes+0x17b/0x189
[    0.515561]        [<ffffffff850020fb>] do_one_initcall+0x9f/0x135
[    0.515561]        [<ffffffff85b54f65>] kernel_init_freeable+0x104/0x196
[    0.515561]        [<ffffffff855adbe9>] kernel_init+0x9/0xd5
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561]=20
-> #0 (text_mutex){+.+.+.}:
[    0.515561]        [<ffffffff850b0e0f>] validate_chain.isra.20+0x8cf/0xf=
2e
[    0.515561]        [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]        [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]        [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]        [<ffffffff855c2531>] kprobe_optimizer+0x121/0x23c
[    0.515561]        [<ffffffff8508dfc4>] process_one_work+0x237/0x3db
[    0.515561]        [<ffffffff8508edc2>] worker_thread+0x1cb/0x2c4
[    0.515561]        [<ffffffff8509498b>] kthread+0xf1/0xf9
[    0.515561]        [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561]=20
[    0.515561] other info that might help us debug this:
[    0.515561]=20
[    0.515561] Chain exists of:
  text_mutex --> kprobe_insn_slots.mutex --> module_mutex

[    0.515561]  Possible unsafe locking scenario:
[    0.515561]=20
[    0.515561]        CPU0                    CPU1
[    0.515561]        ----                    ----
[    0.515561]   lock(module_mutex);
[    0.515561]                                lock(kprobe_insn_slots.mutex);
[    0.515561]                                lock(module_mutex);
[    0.515561]   lock(text_mutex);
[    0.515561]=20
[    0.515561]  *** DEADLOCK ***
[    0.515561]=20
[    0.515561] 4 locks held by kworker/0:1/25:
[    0.515561]  #0:  ("events"){.+.+..}, at: [<ffffffff8508df5e>] process_o=
ne_work+0x1d1/0x3db
[    0.515561]  #1:  ((optimizing_work).work){+.+...}, at: [<ffffffff8508df=
5e>] process_one_work+0x1d1/0x3db
[    0.515561]  #2:  (kprobe_mutex){+.+.+.}, at: [<ffffffff855c2427>] kprob=
e_optimizer+0x17/0x23c
[    0.515561]  #3:  (module_mutex){+.+...}, at: [<ffffffff855c2435>] kprob=
e_optimizer+0x25/0x23c
[    0.515561]=20
[    0.515561] stack backtrace:
[    0.515561] CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 3.14.0-rc5-next=
-20140307-07129-g1b0a7e3 #1
[    0.515561] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.515561] Workqueue: events kprobe_optimizer
[    0.515561]  0000000000000000 ffff8800137e3b60 ffffffff855b5b1d ffffffff=
86069110
[    0.515561]  ffff8800137e3ba0 ffffffff855b2850 ffff8800137e4650 ffff8800=
137e5318
[    0.515561]  ffff8800137e4650 ffff8800137e5318 0000000000000004 ffff8800=
137e52f0
[    0.515561] Call Trace:
[    0.515561]  [<ffffffff855b5b1d>] dump_stack+0x4d/0x66
[    0.515561]  [<ffffffff855b2850>] print_circular_bug+0x2b4/0x2c2
[    0.515561]  [<ffffffff850b0e0f>] validate_chain.isra.20+0x8cf/0xf2e
[    0.515561]  [<ffffffff850b3a65>] __lock_acquire+0x910/0xa03
[    0.515561]  [<ffffffff850b4043>] lock_acquire+0xa4/0xc4
[    0.515561]  [<ffffffff855c2531>] ? kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff855ba2fe>] mutex_lock_nested+0x65/0x34a
[    0.515561]  [<ffffffff855c2531>] ? kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff850b1d8d>] ? trace_hardirqs_on+0xd/0xf
[    0.515561]  [<ffffffff855c2531>] kprobe_optimizer+0x121/0x23c
[    0.515561]  [<ffffffff8508dfc4>] process_one_work+0x237/0x3db
[    0.515561]  [<ffffffff8508df5e>] ? process_one_work+0x1d1/0x3db
[    0.515561]  [<ffffffff8508edc2>] worker_thread+0x1cb/0x2c4
[    0.515561]  [<ffffffff8508ebf7>] ? rescuer_thread+0x29b/0x29b
[    0.515561]  [<ffffffff8509498b>] kthread+0xf1/0xf9
[    0.515561]  [<ffffffff8509489a>] ? kthread_stop+0x5a/0x5a
[    0.515561]  [<ffffffff855c3c8c>] ret_from_fork+0x7c/0xb0
[    0.515561]  [<ffffffff8509489a>] ? kthread_stop+0x5a/0x5a
[    0.679517] Kprobe smoke test passed successfully
[    0.681393] bounce pool size: 64 pages
[    0.682499] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.684990] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.687421] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.688594] NILFS version 2 loaded
[    0.689344] BeFS version: 0.9.3
[    0.691160] GFS2 installed
[    0.692017] msgmni has been set to 571
[    0.697561] Key type asymmetric registered
[    0.698730] Asymmetric key parser 'x509' registered
[    0.699914] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    0.701506] io scheduler noop registered (default)
[    0.702366] list_sort_test: start testing list_sort()
[    0.703791] test_string_helpers: Running tests...
[    0.705189] xz_dec_test: module loaded
[    0.706098] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    0.708539] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.709870] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.711398] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    0.713111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.714930] ACPI: Power Button [PWRF]
[    0.749820] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.773535] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.776727] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    0.778323] ac.o: No PCI boards found.
[    0.779326] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    0.780936] smapi::smapi_init, ERROR invalid usSmapiID
[    0.782122] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    0.784072] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    0.785708] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    0.786991] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.788899] Hangcheck: Using getrawmonotonic().
[    0.790084] lkdtm: No crash points registered, enable through debugfs
[    0.791419] Guest personality initialized and is inactive
[    0.792957] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    0.794531] Initialized host personality
[    0.797149] Uniform Multi-Platform E-IDE driver
[    0.798654] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    0.800440] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    0.802889]     ide0: BM-DMA at 0xc040-0xc047
[    0.804904]     ide1: BM-DMA at 0xc048-0xc04f
[    0.806406] Probing IDE interface ide0...
[    1.337183] Probing IDE interface ide1...
[    1.614891] tsc: Refined TSC clocksource calibration: 2492.686 MHz
[    2.009671] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    2.622360] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    2.623533] hdc: MWDMA2 mode selected
[    2.624474] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.625399] ide1 at 0x170-0x177,0x376 on irq 15
[    2.626610] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    2.628583] Loading iSCSI transport class v2.0-870.
[    2.629846] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.631172] slram: not enough parameters.
[    2.632036] HSI/SSI char device loaded
[    2.632943] CAN device driver interface
[    2.633760] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    2.634882] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    2.636332] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    2.637286] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    2.638297] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    2.639666] irda_register_dongle : registering dongle "JetEye PC ESI-968=
0 PC" (1).
[    2.640940] irda_register_dongle : registering dongle "Parallax LiteLink=
" (5).
[    2.642188] irda_register_dongle : registering dongle "Microchip MCP2120=
" (9).
[    2.643756] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[    2.645393] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.647575] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.648406] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.649459] mousedev: PS/2 mouse device common for all mice
[    2.650840] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.652811] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.654322] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    2.655612] I2O subsystem v1.325
[    2.656247] i2o: max drivers =3D 8
[    2.657429] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.658972] Driver for 1-wire Dallas network protocol.
[    2.724203] applesmc: supported laptop not found!
[    2.724998] applesmc: driver init failed (ret=3D-19)!
[    3.455114] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    4.462215] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    4.463728] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.465290] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    4.466689] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    4.468292] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    4.471195] smsc37b787_wdt: Unable to register miscdev on minor 130
[    4.472579] w83877f_wdt: I/O address 0x0443 already in use
[    4.473789] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    4.475260] Bluetooth: HCI UART driver ver 2.2
[    4.476329] Bluetooth: HCI H4 protocol initialized
[    4.477455] Bluetooth: HCILL protocol initialized
[    4.478535] Bluetooth: HCIATH3K protocol initialized
[    4.479662] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    4.485454] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/none/1.1.2.2
[    4.487443] t1pci: revision 1.1.2.2
[    4.488340] b1: revision 1.1.2.2
[    4.489181] b1dma: revision 1.1.2.3
[    7.175475]  (null): enodev DEV ADDR =3D 0xFF
[    7.176612] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    7.178571] hdaps: supported laptop not found!
[    7.179400] hdaps: driver init failed (ret=3D-19)!
[    7.180547] NET: Registered protocol family 17
[    7.181596] can: controller area network core (rev 20120528 abi 9)
[    7.182631] NET: Registered protocol family 29
[    7.183436] can: raw protocol (rev 20120528)
[    7.184394] can: netlink gateway (rev 20130117) max_hops=3D1
[    7.185542] NET: Registered protocol family 36
[    7.186491] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    7.188387]=20
[    7.188387] printing PIC contents
[    7.189475] ... PIC  IMR: ffff
[    7.190233] ... PIC  IRR: 1013
[    7.190929] ... PIC  ISR: 0000
[    7.191750] ... PIC ELCR: 0c00
[    7.192488] printing local APIC contents on CPU#0/0:
[    7.193274] ... APIC ID:      00000000 (0)
[    7.193274] ... APIC VERSION: 00050014
[    7.193274] ... APIC TASKPRI: 00000000 (00)
[    7.193274] ... APIC PROCPRI: 00000000
[    7.193274] ... APIC LDR: 01000000
[    7.193274] ... APIC DFR: ffffffff
[    7.193274] ... APIC SPIV: 000001ff
[    7.193274] ... APIC ISR field:
[    7.193274] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.193274] ... APIC TMR field:
[    7.193274] 000000000200000000000000000000000000000000000000000000000000=
0000
[    7.193274] ... APIC IRR field:
[    7.193274] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.193274] ... APIC ESR: 00000000
[    7.193274] ... APIC ICR: 000008fd
[    7.193274] ... APIC ICR2: 02000000
[    7.193274] ... APIC LVTT: 000200ef
[    7.193274] ... APIC LVTPC: 00010000
[    7.193274] ... APIC LVT0: 00010700
[    7.193274] ... APIC LVT1: 00000400
[    7.193274] ... APIC LVTERR: 000000fe
[    7.193274] ... APIC TMICT: 0000f421
[    7.193274] ... APIC TMCCT: 000079e0
[    7.193274] ... APIC TDCR: 00000003
[    7.193274]=20
[    7.230484] number of MP IRQ sources: 15.
[    7.231310] number of IO-APIC #0 registers: 24.
[    7.232188] testing the IO APIC.......................
[    7.233194] IO APIC #0......
[    7.233937] .... register #00: 00000000
[    7.234796] .......    : physical APIC id: 00
[    7.235638] .......    : Delivery Type: 0
[    7.236493] .......    : LTS          : 0
[    7.237394] .... register #01: 00170011
[    7.238260] .......     : max redirection entries: 17
[    7.239290] .......     : PRQ implemented: 0
[    7.240157] .......     : IO APIC version: 11
[    7.241181] .... register #02: 00000000
[    7.241983] .......     : arbitration: 00
[    7.242886] .... IRQ redirection table:
[    7.243685] 1    0    0   0   0    0    0    00
[    7.244543] 0    0    0   0   0    1    1    31
[    7.245499] 0    0    0   0   0    1    1    30
[    7.246430] 0    0    0   0   0    1    1    33
[    7.247387] 1    0    0   0   0    1    1    34
[    7.256029] 1    1    0   0   0    1    1    35
[    7.256877] 0    0    0   0   0    1    1    36
[    7.257880] 0    0    0   0   0    1    1    37
[    7.258725] 0    0    0   0   0    1    1    38
[    7.259588] 0    1    0   0   0    1    1    39
[    7.260486] 1    1    0   0   0    1    1    3A
[    7.261401] 1    1    0   0   0    1    1    3B
[    7.262394] 0    0    0   0   0    1    1    3C
[    7.263334] 0    0    0   0   0    1    1    3D
[    7.264481] 0    0    0   0   0    1    1    3E
[    7.265426] 0    0    0   0   0    1    1    3F
[    7.266343] 1    0    0   0   0    0    0    00
[    7.267253] 1    0    0   0   0    0    0    00
[    7.268135] 1    0    0   0   0    0    0    00
[    7.269090] 1    0    0   0   0    0    0    00
[    7.270011] 1    0    0   0   0    0    0    00
[    7.270996] 1    0    0   0   0    0    0    00
[    7.271920] 1    0    0   0   0    0    0    00
[    7.272852] 1    0    0   0   0    0    0    00
[    7.273663] IRQ to pin mappings:
[    7.274382] IRQ0 -> 0:2
[    7.275255] IRQ1 -> 0:1
[    7.275909] IRQ3 -> 0:3
[    7.276788] IRQ4 -> 0:4
[    7.277432] IRQ5 -> 0:5
[    7.278374] IRQ6 -> 0:6
[    7.279156] IRQ7 -> 0:7
[    7.279892] IRQ8 -> 0:8
[    7.280762] IRQ9 -> 0:9
[    7.281526] IRQ10 -> 0:10
[    7.282403] IRQ11 -> 0:11
[    7.283086] IRQ12 -> 0:12
[    7.283830] IRQ13 -> 0:13
[    7.284578] IRQ14 -> 0:14
[    7.285498] IRQ15 -> 0:15
[    7.286157] .................................... done.
[    7.287289] Loading compiled-in X.509 certificates
[    7.288956] Loaded X.509 cert 'Magrathea: Glacier signing key: 95edff3f7=
9cb97869f663866ce5f93d0c8f223ae'
[    7.290820] registered taskstats version 1
[    7.292076] kworker/u4:1 (91) used greatest stack depth: 6480 bytes left
[    7.292257] Key type encrypted registered
[    7.294440] cryptomgr_probe (93) used greatest stack depth: 6000 bytes l=
eft
[    7.296334] AppArmor: AppArmor sha1 policy hashing enabled
[    7.297920] console [netcon0] enabled
[    7.298712] netconsole: network logging started
[    7.299596] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    7.301237] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    7.302135] EDD information not available.
[    7.303136] debug: unmapping init [mem 0xffffffff85b40000-0xffffffff85c4=
3fff]
[    7.304484] Write protecting the kernel read-only data: 10240k
[    7.305790] debug: unmapping init [mem 0xffff8800055c7000-0xffff8800055f=
ffff]
[    7.307192] debug: unmapping init [mem 0xffff880005951000-0xffff8800059f=
ffff]
[    7.314266] mount (104) used greatest stack depth: 5848 bytes left
[    7.320541] S00fbsetup (106) used greatest stack depth: 5624 bytes left
[    7.348038] udev[120]: starting version 164
[    7.753170] GFS2: path_lookup on rootfs returned error -2
Kernel tests: Boot OK!
[   10.683698] udevd (123) used greatest stack depth: 5600 bytes left
[   10.685228] udevd (124) used greatest stack depth: 5576 bytes left
[   10.686703] udevd (125) used greatest stack depth: 5328 bytes left
[   60.848987] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[   76.104305] Unregister pv shared memory for cpu 0
[   76.105437] Unregister pv shared memory for cpu 1
[   76.106719] spin_lock-torture: Unscheduled system shutdown detected
[   76.108219] no ifx modem active;
[   76.109167] torture thread torture_stutter parking due to system shutdown
[   76.111202] torture thread torture_shuffle parking due to system shutdown
[   76.113369] reboot: Restarting system
[   76.114264] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-r5-03091328/1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-ne=
xt-20140307-07129-g1b0a7e3 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r5-03091328/next:=
master/.vmlinuz-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-20140309134226-8-i=
vytown2 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r5-0309=
1328/1b0a7e3263168a06d3858798e48c5a21d1c78d3c/vmlinuz-3.14.0-rc5-next-20140=
307-07129-g1b0a7e3'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz =
-m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3D=
tcp::24449-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dl=
ocaltime -pidfile /dev/shm/kboot/pid-yocto-ivytown2-24 -serial file:/dev/sh=
m/kboot/serial-yocto-ivytown2-24 -daemonize -display none -monitor null=20

--/WwmFnJnmDyWGHa4
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-r5-03091328-1b0a7e3263168a06d3858798e48c5a21d1c78d3c-INFO:-possible-circular-locking-dependency-detected-34643.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDU2MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFhN2QwZWE0YTIK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1
LTAzMDkxMzI4L25leHQ6bWFzdGVyOjU2MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFh
N2QwZWE0YTI6YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0xNzo1MzowNiA1NjAzMmZjNTA0Yzlj
ZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVhNGEyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4LTU2MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFhN2QwZWE0YTIKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzU2
MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFhN2QwZWE0YTIKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4LTU2MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFhN2QwZWE0YTIK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54
ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC01NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0
Njg3NDQxYTdkMGVhNGEyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyOC81NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVhNGEyL3ZtbGlu
dXotMy4xNC4wLXJjNS0wNjcyMS1nNTYwMzJmYwoKMjAxNC0wMy0wOS0xNzo1OTowNiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4JMiBURVNUIEZBSUxVUkUKWyAgICAxLjQ3OTUz
Nl0gS3Byb2JlIHNtb2tlIHRlc3Qgc3RhcnRlZApbICAgIDEuNTA3OTY0XSAKWyAgICAxLjUw
ODYzMF0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09ClsgICAgMS41MDk4MjhdIFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2lu
ZyBkZXBlbmRlbmN5IGRldGVjdGVkIF0KWyAgICAxLjUxMDgwOF0gMy4xNC4wLXJjNS0wNjcy
MS1nNTYwMzJmYyAjMSBOb3QgdGFpbnRlZApbICAgIDEuNTEwODA4XSAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMS41MTA4
MDhdIGt3b3JrZXIvMToxLzI1IGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMS41
MTA4MDhdICAodGV4dF9tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4Y2RiZmU3MT5d
IGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjUxMDgwOF0gClsgICAgMS41
MTA4MDhdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDEuNTEwODA4
XSAgKG1vZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4Y2RiZmQ3NT5dIGtw
cm9iZV9vcHRpbWl6ZXIrMHgyNS8weDIzYwpbICAgIDEuNTEwODA4XSAKWyAgICAxLjUxMDgw
OF0gd2hpY2ggbG9jayBhbHJlYWR5IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDEu
NTEwODA4XSAKWyAgICAxLjUxMDgwOF0gClsgICAgMS41MTA4MDhdIHRoZSBleGlzdGluZyBk
ZXBlbmRlbmN5IGNoYWluIChpbiByZXZlcnNlIG9yZGVyKSBpczoKWyAgICAxLjUxMDgwOF0g
Ci0+ICMyIChtb2R1bGVfbXV0ZXgpeysuKy4uLn06ClsgICAgMS41MTA4MDhdICAgICAgICBb
PGZmZmZmZmZmOGM4YjNjNDc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEu
NTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjOGI0MjFlPl0gbG9ja19hY3F1aXJlKzB4YTQv
MHhjNApbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGI3YzFlPl0gbXV0ZXhf
bG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZm
ZjhjODJmOTU0Pl0gbW9kdWxlX2FsbG9jKzB4NDIvMHhiNQpbICAgIDEuNTEwODA4XSAgICAg
ICAgWzxmZmZmZmZmZjhjOGRiODViPl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAg
MS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGNkYzAwNmM+XSBfX2dldF9pbnNuX3Nsb3Qr
MHhlMC8weDE2NQpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGJkM2IzPl0g
YXJjaF9wcmVwYXJlX2twcm9iZSsweDM2LzB4YjcKWyAgICAxLjUxMDgwOF0gICAgICAgIFs8
ZmZmZmZmZmY4Y2RjMGQ0MT5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDEu
NTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjOGQ2Zjk2Pl0gaW5pdF90ZXN0X3Byb2Jlcysw
eDRlLzB4NDg5ClsgICAgMS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGQzNmQxNTI+XSBp
bml0X2twcm9iZXMrMHgxN2IvMHgxODkKWyAgICAxLjUxMDgwOF0gICAgICAgIFs8ZmZmZmZm
ZmY4YzgwMjBmYj5dIGRvX29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMS41MTA4MDhd
ICAgICAgICBbPGZmZmZmZmZmOGQzNTFmNjU+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEw
NC8weDE5NgpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGFiNTk5Pl0ga2Vy
bmVsX2luaXQrMHg5LzB4ZDUKWyAgICAxLjUxMDgwOF0gICAgICAgIFs8ZmZmZmZmZmY4Y2Rj
MTVjYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMS41MTA4MDhdIAotPiAjMSAo
a3Byb2JlX2luc25fc2xvdHMubXV0ZXgpeysuKy4rLn06ClsgICAgMS41MTA4MDhdICAgICAg
ICBbPGZmZmZmZmZmOGM4YjNjNDc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAg
IDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjOGI0MjFlPl0gbG9ja19hY3F1aXJlKzB4
YTQvMHhjNApbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGI3YzFlPl0gbXV0
ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZm
ZmZmZjhjZGJmZmE4Pl0gX19nZXRfaW5zbl9zbG90KzB4MWMvMHgxNjUKWyAgICAxLjUxMDgw
OF0gICAgICAgIFs8ZmZmZmZmZmY4Y2RiZDNiMz5dIGFyY2hfcHJlcGFyZV9rcHJvYmUrMHgz
Ni8weGI3ClsgICAgMS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGNkYzBkNDE+XSByZWdp
c3Rlcl9rcHJvYmUrMHgzMzAvMHg0OTAKWyAgICAxLjUxMDgwOF0gICAgICAgIFs8ZmZmZmZm
ZmY4YzhkNmY5Nj5dIGluaXRfdGVzdF9wcm9iZXMrMHg0ZS8weDQ4OQpbICAgIDEuNTEwODA4
XSAgICAgICAgWzxmZmZmZmZmZjhkMzZkMTUyPl0gaW5pdF9rcHJvYmVzKzB4MTdiLzB4MTg5
ClsgICAgMS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGM4MDIwZmI+XSBkb19vbmVfaW5p
dGNhbGwrMHg5Zi8weDEzNQpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhkMzUx
ZjY1Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMDQvMHgxOTYKWyAgICAxLjUxMDgwOF0g
ICAgICAgIFs8ZmZmZmZmZmY4Y2RhYjU5OT5dIGtlcm5lbF9pbml0KzB4OS8weGQ1ClsgICAg
MS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGNkYzE1Y2M+XSByZXRfZnJvbV9mb3JrKzB4
N2MvMHhiMApbICAgIDEuNTEwODA4XSAKLT4gIzAgKHRleHRfbXV0ZXgpeysuKy4rLn06Clsg
ICAgMS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZmOGM4YjBmZmE+XSB2YWxpZGF0ZV9jaGFp
bi5pc3JhLjIwKzB4OGNmLzB4ZjJlClsgICAgMS41MTA4MDhdICAgICAgICBbPGZmZmZmZmZm
OGM4YjNjNDc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuNTEwODA4XSAg
ICAgICAgWzxmZmZmZmZmZjhjOGI0MjFlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAg
IDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGI3YzFlPl0gbXV0ZXhfbG9ja19uZXN0
ZWQrMHg2NS8weDM0YQpbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjZGJmZTcx
Pl0ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDEuNTEwODA4XSAgICAgICAg
WzxmZmZmZmZmZjhjODhkZjVlPl0gcHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAg
IDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjODhlZDVjPl0gd29ya2VyX3RocmVhZCsw
eDFjYi8weDJjNApbICAgIDEuNTEwODA4XSAgICAgICAgWzxmZmZmZmZmZjhjODk0OTNiPl0g
a3RocmVhZCsweGYxLzB4ZjkKWyAgICAxLjUxMDgwOF0gICAgICAgIFs8ZmZmZmZmZmY4Y2Rj
MTVjYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMS41MTA4MDhdIApbICAgIDEu
NTEwODA4XSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAg
IDEuNTEwODA4XSAKWyAgICAxLjUxMDgwOF0gQ2hhaW4gZXhpc3RzIG9mOgogIHRleHRfbXV0
ZXggLS0+IGtwcm9iZV9pbnNuX3Nsb3RzLm11dGV4IC0tPiBtb2R1bGVfbXV0ZXgKClsgICAg
MS41MTA4MDhdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAxLjUx
MDgwOF0gClsgICAgMS41MTA4MDhdICAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBD
UFUxClsgICAgMS41MTA4MDhdICAgICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0t
ClsgICAgMS41MTA4MDhdICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDEuNTEwODA4XSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jayhrcHJvYmVfaW5zbl9zbG90cy5t
dXRleCk7ClsgICAgMS41MTA4MDhdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBs
b2NrKG1vZHVsZV9tdXRleCk7ClsgICAgMS41MTA4MDhdICAgbG9jayh0ZXh0X211dGV4KTsK
WyAgICAxLjUxMDgwOF0gClsgICAgMS41MTA4MDhdICAqKiogREVBRExPQ0sgKioqClsgICAg
MS41MTA4MDhdIApbICAgIDEuNTEwODA4XSA0IGxvY2tzIGhlbGQgYnkga3dvcmtlci8xOjEv
MjU6ClsgICAgMS41MTA4MDhdICAjMDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZm
ZmZmZmY4Yzg4ZGVmOD5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAxLjUx
MDgwOF0gICMxOiAgKChvcHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZm
ZmZmZmZmOGM4OGRlZjg+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS41
MTA4MDhdICAjMjogIChrcHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGNk
YmZkNjc+XSBrcHJvYmVfb3B0aW1pemVyKzB4MTcvMHgyM2MKWyAgICAxLjUxMDgwOF0gICMz
OiAgKG1vZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4Y2RiZmQ3NT5dIGtw
cm9iZV9vcHRpbWl6ZXIrMHgyNS8weDIzYwpbICAgIDEuNTEwODA4XSAKWyAgICAxLjUxMDgw
OF0gc3RhY2sgYmFja3RyYWNlOgpbICAgIDEuNTEwODA4XSBDUFU6IDEgUElEOiAyNSBDb21t
OiBrd29ya2VyLzE6MSBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTA2NzIxLWc1NjAzMmZjICMx
ClsgICAgMS41MTA4MDhdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hz
IDAxLzAxLzIwMTEKWyAgICAxLjUxMDgwOF0gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29w
dGltaXplcgpbICAgIDEuNTEwODA4XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDA3MTJm
YjYwIGZmZmZmZmZmOGNkYjM0M2QgZmZmZmZmZmY4ZDg2NjExMApbICAgIDEuNTEwODA4XSAg
ZmZmZjg4MDAwNzEyZmJhMCBmZmZmZmZmZjhjZGIwMWViIGZmZmY4ODAwMDcxMzA2NTAgZmZm
Zjg4MDAwNzEzMTJmMApbICAgIDEuNTEwODA4XSAgZmZmZjg4MDAwNzEzMDY1MCBmZmZmODgw
MDA3MTMxMmYwIDAwMDAwMDAwMDAwMDAwMDQgZmZmZjg4MDAwNzEzMTJjOApbICAgIDEuNTEw
ODA4XSBDYWxsIFRyYWNlOgpbICAgIDEuNTEwODA4XSAgWzxmZmZmZmZmZjhjZGIzNDNkPl0g
ZHVtcF9zdGFjaysweDRkLzB4NjYKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4Y2RiMDFl
Yj5dIHByaW50X2NpcmN1bGFyX2J1ZysweDJiNC8weDJjMgpbICAgIDEuNTEwODA4XSAgWzxm
ZmZmZmZmZjhjOGIwZmZhPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4yMCsweDhjZi8weGYyZQpb
ICAgIDEuNTEwODA4XSAgWzxmZmZmZmZmZjhjOGIzYzQ3Pl0gX19sb2NrX2FjcXVpcmUrMHg5
MDcvMHg5ZmIKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4YzhiNDIxZT5dIGxvY2tfYWNx
dWlyZSsweGE0LzB4YzQKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4Y2RiZmU3MT5dID8g
a3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDEuNTEwODA4XSAgWzxmZmZmZmZm
ZjhjZGI3YzFlPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuNTEwODA4
XSAgWzxmZmZmZmZmZjhjZGJmZTcxPl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNj
ClsgICAgMS41MTA4MDhdICBbPGZmZmZmZmZmOGM4YjFmNzg+XSA/IHRyYWNlX2hhcmRpcnFz
X29uKzB4ZC8weGYKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4Y2RiZmU3MT5dIGtwcm9i
ZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4Yzg4
ZGY1ZT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyMzcvMHgzZGIKWyAgICAxLjUxMDgwOF0gIFs8
ZmZmZmZmZmY4Yzg4ZGVmOD5dID8gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAg
IDEuNTEwODA4XSAgWzxmZmZmZmZmZjhjODhlZDVjPl0gd29ya2VyX3RocmVhZCsweDFjYi8w
eDJjNApbICAgIDEuNTEwODA4XSAgWzxmZmZmZmZmZjhjODhlYjkxPl0gPyByZXNjdWVyX3Ro
cmVhZCsweDI5Yi8weDI5YgpbICAgIDEuNTEwODA4XSAgWzxmZmZmZmZmZjhjODk0OTNiPl0g
a3RocmVhZCsweGYxLzB4ZjkKWyAgICAxLjUxMDgwOF0gIFs8ZmZmZmZmZmY4Yzg5NDg0YT5d
ID8ga3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuNTEwODA4XSAgWzxmZmZmZmZmZjhj
ZGMxNWNjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAxLjUxMDgwOF0gIFs8ZmZm
ZmZmZmY4Yzg5NDg0YT5dID8ga3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuNjczOTQ3
XSBLcHJvYmUgc21va2UgdGVzdCBwYXNzZWQgc3VjY2Vzc2Z1bGx5ClsgICAgMS42NzU4MTdd
IGJvdW5jZSBwb29sIHNpemU6IDY0IHBhZ2VzClsgICAgMS42NzY4OTBdIEh1Z2VUTEIgcmVn
aXN0ZXJlZCAyIE1CIHBhZ2Ugc2l6ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvNTYwMzJmYzUwNGM5Y2U5ZGQ2ZmQ2OTdl
NDY4NzQ0MWE3ZDBlYTRhMi9kbWVzZy1xdWFudGFsLWlubi01OjIwMTQwMzA5MTgwMzQzOng4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC81NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVhNGEy
L2RtZXNnLXF1YW50YWwtcm9hbS00NjoyMDE0MDMwOTE4MDM0Mjp4ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LTA2NzIxLWc1NjAzMmZjOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC81NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3
NDQxYTdkMGVhNGEyL2RtZXNnLXF1YW50YWwtc25iLTE3OjIwMTQwMzA5MTgwMzQyOng4Nl82
NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
NS0wMzA5MTMyOC81NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVhNGEyL2Rt
ZXNnLXF1YW50YWwteGlhbi0xNjoyMDE0MDMwOTE4MDM0Njp4ODZfNjQtcmFuZGNvbmZpZy1y
NS0wMzA5MTMyODozLjE0LjAtcmM1LTA2NzIxLWc1NjAzMmZjOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yNS0wMzA5MTMyOC81NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3NDQx
YTdkMGVhNGEyL2RtZXNnLXlvY3RvLXhpYW4tMToyMDE0MDMwOTE4MDM0Nzp4ODZfNjQtcmFu
ZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LTA2NzIxLWc1NjAzMmZjOjEKMjo1OjUg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCA1NjAzMmZj
NTA0YzljZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVhNGEyCmdpdCBjaGVja291dCB2My4xMwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjUt
MDMwOTEzMjgvbmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEw
ZjBlNjRiZTpiaXNlY3QtdXNiCgoyMDE0LTAzLTA5LTE4OjA0OjE2IGQ4ZWMyNmQ3ZjgyODdm
NTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMw
OTEzMjgtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjUtMDMwOTEzMjgtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZl
ODgxNDIxMGYwZTY0YmUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvdm1saW51
ei0zLjEzLjAKCjIwMTQtMDMtMDktMTg6MTA6MTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgky
CTYJMTUJMTcJMTkJMjIuCTI1IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTMK
Z2l0IGJpc2VjdCBzdGFydCA1NjAzMmZjNTA0YzljZTlkZDZmZDY5N2U0Njg3NDQxYTdkMGVh
NGEyIHYzLjEzIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjU2
MDMyZmM1MDRjOWNlOWRkNmZkNjk3ZTQ2ODc0NDFhN2QwZWE0YTIiLCAiLWciLCAidjMuMTMi
LCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvaG9t
ZS93ZmcvdXNiL29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDE5NDI2IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNSBzdGVwcykKWzdkZjRkMGM5Nzg0MTE3
ZjdiYmFlYzE3ZTlhYzdmNjU0NTA0OWI1NmRdIE1lcmdlIHRhZyAnc3BpLXYzLjE0LXJjMicg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Jyb29u
aWUvc3BpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOjdk
ZjRkMGM5Nzg0MTE3ZjdiYmFlYzE3ZTlhYzdmNjU0NTA0OWI1NmQ6YmlzZWN0LXVzYgoKMjAx
NC0wMy0wOS0xODoxNDo1NCA3ZGY0ZDBjOTc4NDExN2Y3YmJhZWMxN2U5YWM3ZjY1NDUwNDli
NTZkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTdkZjRkMGM5Nzg0MTE3Zjdi
YmFlYzE3ZTlhYzdmNjU0NTA0OWI1NmQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzdkZjRkMGM5Nzg0MTE3ZjdiYmFlYzE3ZTlh
YzdmNjU0NTA0OWI1NmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTdkZjRkMGM5Nzg0
MTE3ZjdiYmFlYzE3ZTlhYzdmNjU0NTA0OWI1NmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyOC03ZGY0ZDBjOTc4NDExN2Y3YmJhZWMxN2U5YWM3ZjY1NDUwNDliNTZkCmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC83ZGY0ZDBjOTc4NDExN2Y3
YmJhZWMxN2U5YWM3ZjY1NDUwNDliNTZkL3ZtbGludXotMy4xNC4wLXJjMi0wMDI1Ni1nN2Rm
NGQwYwoKMjAxNC0wMy0wOS0xODoxOTo1NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQk0CTYu
CTcJOC4JOQkxMgkxNQkxNy4uLi4JMTgJMjIuCTIzLi4uLgkyNAkyNSBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDc1OTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEzIHN0ZXBzKQpbYjMzOGI4MjJlYmEyZmRjYmFkN2FhNDE0OTg5OWZiNzM0ZjlmMTZlY10g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnaW5wdXQtY3VycmVudC9mb3ItbGludXMn
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOmIzMzhiODIy
ZWJhMmZkY2JhZDdhYTQxNDk4OTlmYjczNGY5ZjE2ZWM6YmlzZWN0LXVzYgoKMjAxNC0wMy0w
OS0xODozMjoyNyBiMzM4YjgyMmViYTJmZGNiYWQ3YWE0MTQ5ODk5ZmI3MzRmOWYxNmVjIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWIzMzhiODIyZWJhMmZkY2JhZDdhYTQx
NDk4OTlmYjczNGY5ZjE2ZWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXI1LTAzMDkxMzI4L2IzMzhiODIyZWJhMmZkY2JhZDdhYTQxNDk4OTlmYjcz
NGY5ZjE2ZWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWIzMzhiODIyZWJhMmZkY2Jh
ZDdhYTQxNDk4OTlmYjczNGY5ZjE2ZWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1i
MzM4YjgyMmViYTJmZGNiYWQ3YWE0MTQ5ODk5ZmI3MzRmOWYxNmVjCmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9iMzM4YjgyMmViYTJmZGNiYWQ3YWE0
MTQ5ODk5ZmI3MzRmOWYxNmVjL3ZtbGludXotMy4xNC4wLXJjNS0wMDI0MS1nYjMzOGI4MgoK
MjAxNC0wMy0wOS0xODo0MjoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIJNAk5CTIzCTI1
IFNVQ0NFU1MKCkJpc2VjdGluZzogNjQ4MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls5OTI2NzBiNWNkOTdmZGM5N2U5ZmUxNWMzZjhj
MTZjMjE4NzQ5Yzk2XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICduZXQtbmV4dC9t
YXN0ZXInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOjk5
MjY3MGI1Y2Q5N2ZkYzk3ZTlmZTE1YzNmOGMxNmMyMTg3NDljOTY6YmlzZWN0LXVzYgoKMjAx
NC0wMy0wOS0xODo0NTozMCA5OTI2NzBiNWNkOTdmZGM5N2U5ZmUxNWMzZjhjMTZjMjE4NzQ5
Yzk2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTk5MjY3MGI1Y2Q5N2ZkYzk3
ZTlmZTE1YzNmOGMxNmMyMTg3NDljOTYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4Lzk5MjY3MGI1Y2Q5N2ZkYzk3ZTlmZTE1YzNm
OGMxNmMyMTg3NDljOTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTk5MjY3MGI1Y2Q5
N2ZkYzk3ZTlmZTE1YzNmOGMxNmMyMTg3NDljOTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyOC05OTI2NzBiNWNkOTdmZGM5N2U5ZmUxNWMzZjhjMTZjMjE4NzQ5Yzk2Cmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC85OTI2NzBiNWNkOTdmZGM5
N2U5ZmUxNWMzZjhjMTZjMjE4NzQ5Yzk2L3ZtbGludXotMy4xNC4wLXJjNS0wMjg3Ny1nOTky
NjcwYgoKMjAxNC0wMy0wOS0xODo1MzozMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxCTMJ
NQkxNS4JMTkJMjQJMjUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzODQ0IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzhiNDJhYjVkNmM1MTQw
Y2FkMzQ5NTdhMzJmYTZiZGY0M2U3ZTAzMDNdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFu
Y2ggJ3NwaS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvbmV4
dDptYXN0ZXI6OGI0MmFiNWQ2YzUxNDBjYWQzNDk1N2EzMmZhNmJkZjQzZTdlMDMwMzpiaXNl
Y3QtdXNiCgoyMDE0LTAzLTA5LTE4OjU4OjM0IDhiNDJhYjVkNmM1MTQwY2FkMzQ5NTdhMzJm
YTZiZGY0M2U3ZTAzMDMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtOGI0MmFi
NWQ2YzUxNDBjYWQzNDk1N2EzMmZhNmJkZjQzZTdlMDMwMwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvOGI0MmFiNWQ2YzUxNDBj
YWQzNDk1N2EzMmZhNmJkZjQzZTdlMDMwMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgt
OGI0MmFiNWQ2YzUxNDBjYWQzNDk1N2EzMmZhNmJkZjQzZTdlMDMwMwp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29u
ZmlnLXI1LTAzMDkxMzI4LThiNDJhYjVkNmM1MTQwY2FkMzQ5NTdhMzJmYTZiZGY0M2U3ZTAz
MDMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzhiNDJh
YjVkNmM1MTQwY2FkMzQ5NTdhMzJmYTZiZGY0M2U3ZTAzMDMvdm1saW51ei0zLjE0LjAtcmM1
LTA1MDY4LWc4YjQyYWI1CgoyMDE0LTAzLTA5LTE5OjEwOjM0IGRldGVjdGluZyBib290IHN0
YXRlIC4uCTMJOAkxMQkxNAkxNwkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE2NTMgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbMjVlYzM3
ZDNlM2JmMWY5ZWZlYzZmMDVkNzlmZDk3NmJmZjQ2MjRjZF0gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAnc3RhZ2luZy9zdGFnaW5nLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOjI1ZWMzN2QzZTNiZjFmOWVmZWM2ZjA1ZDc5ZmQ5
NzZiZmY0NjI0Y2Q6YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0xOToxNDozNyAyNWVjMzdkM2Uz
YmYxZjllZmVjNmYwNWQ3OWZkOTc2YmZmNDYyNGNkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1
LTAzMDkxMzI4LTI1ZWMzN2QzZTNiZjFmOWVmZWM2ZjA1ZDc5ZmQ5NzZiZmY0NjI0Y2QKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
LzI1ZWMzN2QzZTNiZjFmOWVmZWM2ZjA1ZDc5ZmQ5NzZiZmY0NjI0Y2QKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLXI1LTAzMDkxMzI4LTI1ZWMzN2QzZTNiZjFmOWVmZWM2ZjA1ZDc5ZmQ5NzZiZmY0NjI0
Y2QKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC0yNWVjMzdkM2UzYmYxZjllZmVjNmYw
NWQ3OWZkOTc2YmZmNDYyNGNkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
NS0wMzA5MTMyOC8yNWVjMzdkM2UzYmYxZjllZmVjNmYwNWQ3OWZkOTc2YmZmNDYyNGNkL3Zt
bGludXotMy4xNC4wLXJjNS0wNjM5NC1nMjVlYzM3ZAoKMjAxNC0wMy0wOS0xOTozMTozNyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMiBURVNUIEZBSUxVUkUKWyAgICAwLjk3MTUxNF0g
S3Byb2JlIHNtb2tlIHRlc3Qgc3RhcnRlZApbICAgIDAuOTk4OTIzXSAKWyAgICAwLjk5OTU2
Ml0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09ClsgICAgMC45OTk4NDBdIFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBk
ZXBlbmRlbmN5IGRldGVjdGVkIF0KWyAgICAwLjk5OTg0MF0gMy4xNC4wLXJjNS0wNjM5NC1n
MjVlYzM3ZCAjMSBOb3QgdGFpbnRlZApbICAgIDAuOTk5ODQwXSAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC45OTk4NDBd
IGt3b3JrZXIvMDoxLzI0IGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMC45OTk4
NDBdICAodGV4dF9tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4ZWRiY2IyNj5dIGtw
cm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAwLjk5OTg0MF0gClsgICAgMC45OTk4
NDBdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDAuOTk5ODQwXSAg
KG1vZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4ZWRiY2EyYT5dIGtwcm9i
ZV9vcHRpbWl6ZXIrMHgyNS8weDIzYwpbICAgIDAuOTk5ODQwXSAKWyAgICAwLjk5OTg0MF0g
d2hpY2ggbG9jayBhbHJlYWR5IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDAuOTk5
ODQwXSAKWyAgICAwLjk5OTg0MF0gClsgICAgMC45OTk4NDBdIHRoZSBleGlzdGluZyBkZXBl
bmRlbmN5IGNoYWluIChpbiByZXZlcnNlIG9yZGVyKSBpczoKWyAgICAwLjk5OTg0MF0gCi0+
ICMyIChtb2R1bGVfbXV0ZXgpeysuKy4uLn06ClsgICAgMC45OTk4NDBdICAgICAgICBbPGZm
ZmZmZmZmOGU4YjNiODc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDAuOTk5
ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlOGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhj
NApbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGI0OGZlPl0gbXV0ZXhfbG9j
a19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhl
ODJmOTU0Pl0gbW9kdWxlX2FsbG9jKzB4NDIvMHhiNQpbICAgIDAuOTk5ODQwXSAgICAgICAg
WzxmZmZmZmZmZjhlOGRiNzQ4Pl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAgMC45
OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGVkYmNkMjE+XSBfX2dldF9pbnNuX3Nsb3QrMHhl
MC8weDE2NQpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGJhMDcyPl0gYXJj
aF9wcmVwYXJlX2twcm9iZSsweDM2LzB4YjcKWyAgICAwLjk5OTg0MF0gICAgICAgIFs8ZmZm
ZmZmZmY4ZWRiZDlmMj5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDAuOTk5
ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlOGQ2ZTkxPl0gaW5pdF90ZXN0X3Byb2JlcysweDRl
LzB4NDg5ClsgICAgMC45OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGYzNmMxMzM+XSBpbml0
X2twcm9iZXMrMHgxN2IvMHgxODkKWyAgICAwLjk5OTg0MF0gICAgICAgIFs8ZmZmZmZmZmY4
ZTgwMjBmYj5dIGRvX29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMC45OTk4NDBdICAg
ICAgICBbPGZmZmZmZmZmOGYzNTBmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMy8w
eDE5NApbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGE4Mjk5Pl0ga2VybmVs
X2luaXQrMHg5LzB4ZDUKWyAgICAwLjk5OTg0MF0gICAgICAgIFs8ZmZmZmZmZmY4ZWRiZTI4
Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC45OTk4NDBdIAotPiAjMSAoa3By
b2JlX2luc25fc2xvdHMubXV0ZXgpeysuKy4rLn06ClsgICAgMC45OTk4NDBdICAgICAgICBb
PGZmZmZmZmZmOGU4YjNiODc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDAu
OTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlOGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQv
MHhjNApbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGI0OGZlPl0gbXV0ZXhf
bG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZm
ZjhlZGJjYzVkPl0gX19nZXRfaW5zbl9zbG90KzB4MWMvMHgxNjUKWyAgICAwLjk5OTg0MF0g
ICAgICAgIFs8ZmZmZmZmZmY4ZWRiYTA3Mj5dIGFyY2hfcHJlcGFyZV9rcHJvYmUrMHgzNi8w
eGI3ClsgICAgMC45OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGVkYmQ5ZjI+XSByZWdpc3Rl
cl9rcHJvYmUrMHgzMzAvMHg0OTAKWyAgICAwLjk5OTg0MF0gICAgICAgIFs8ZmZmZmZmZmY4
ZThkNmU5MT5dIGluaXRfdGVzdF9wcm9iZXMrMHg0ZS8weDQ4OQpbICAgIDAuOTk5ODQwXSAg
ICAgICAgWzxmZmZmZmZmZjhmMzZjMTMzPl0gaW5pdF9rcHJvYmVzKzB4MTdiLzB4MTg5Clsg
ICAgMC45OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGU4MDIwZmI+XSBkb19vbmVfaW5pdGNh
bGwrMHg5Zi8weDEzNQpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhmMzUwZjYz
Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMDMvMHgxOTQKWyAgICAwLjk5OTg0MF0gICAg
ICAgIFs8ZmZmZmZmZmY4ZWRhODI5OT5dIGtlcm5lbF9pbml0KzB4OS8weGQ1ClsgICAgMC45
OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGVkYmUyOGM+XSByZXRfZnJvbV9mb3JrKzB4N2Mv
MHhiMApbICAgIDAuOTk5ODQwXSAKLT4gIzAgKHRleHRfbXV0ZXgpeysuKy4rLn06ClsgICAg
MC45OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGU4YjBmM2M+XSB2YWxpZGF0ZV9jaGFpbi5p
c3JhLjIwKzB4OGNmLzB4ZjJlClsgICAgMC45OTk4NDBdICAgICAgICBbPGZmZmZmZmZmOGU4
YjNiODc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDAuOTk5ODQwXSAgICAg
ICAgWzxmZmZmZmZmZjhlOGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDAu
OTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGI0OGZlPl0gbXV0ZXhfbG9ja19uZXN0ZWQr
MHg2NS8weDM0YQpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlZGJjYjI2Pl0g
a3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDAuOTk5ODQwXSAgICAgICAgWzxm
ZmZmZmZmZjhlODhkZWY1Pl0gcHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAgIDAu
OTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlODhlY2VmPl0gd29ya2VyX3RocmVhZCsweDFj
Yi8weDJjNApbICAgIDAuOTk5ODQwXSAgICAgICAgWzxmZmZmZmZmZjhlODk0OGI5Pl0ga3Ro
cmVhZCsweGYxLzB4ZjkKWyAgICAwLjk5OTg0MF0gICAgICAgIFs8ZmZmZmZmZmY4ZWRiZTI4
Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC45OTk4NDBdIApbICAgIDAuOTk5
ODQwXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgIDAu
OTk5ODQwXSAKWyAgICAwLjk5OTg0MF0gQ2hhaW4gZXhpc3RzIG9mOgogIHRleHRfbXV0ZXgg
LS0+IGtwcm9iZV9pbnNuX3Nsb3RzLm11dGV4IC0tPiBtb2R1bGVfbXV0ZXgKClsgICAgMC45
OTk4NDBdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAwLjk5OTg0
MF0gClsgICAgMC45OTk4NDBdICAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUx
ClsgICAgMC45OTk4NDBdICAgICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tClsg
ICAgMC45OTk4NDBdICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDAuOTk5ODQwXSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jayhrcHJvYmVfaW5zbl9zbG90cy5tdXRl
eCk7ClsgICAgMC45OTk4NDBdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2Nr
KG1vZHVsZV9tdXRleCk7ClsgICAgMC45OTk4NDBdICAgbG9jayh0ZXh0X211dGV4KTsKWyAg
ICAwLjk5OTg0MF0gClsgICAgMC45OTk4NDBdICAqKiogREVBRExPQ0sgKioqClsgICAgMC45
OTk4NDBdIApbICAgIDAuOTk5ODQwXSA0IGxvY2tzIGhlbGQgYnkga3dvcmtlci8wOjEvMjQ6
ClsgICAgMC45OTk4NDBdICAjMDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZmZmZm
ZmY4ZTg4ZGU4Zj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAwLjk5OTg0
MF0gICMxOiAgKChvcHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZmZmZm
ZmZmOGU4OGRlOGY+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMC45OTk4
NDBdICAjMjogIChrcHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGVkYmNh
MWM+XSBrcHJvYmVfb3B0aW1pemVyKzB4MTcvMHgyM2MKWyAgICAwLjk5OTg0MF0gICMzOiAg
KG1vZHVsZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4ZWRiY2EyYT5dIGtwcm9i
ZV9vcHRpbWl6ZXIrMHgyNS8weDIzYwpbICAgIDAuOTk5ODQwXSAKWyAgICAwLjk5OTg0MF0g
c3RhY2sgYmFja3RyYWNlOgpbICAgIDAuOTk5ODQwXSBDUFU6IDAgUElEOiAyNCBDb21tOiBr
d29ya2VyLzA6MSBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTA2Mzk0LWcyNWVjMzdkICMxClsg
ICAgMC45OTk4NDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgICAwLjk5OTg0MF0gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29wdGlt
aXplcgpbICAgIDAuOTk5ODQwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyM2FmYjYw
IGZmZmZmZmZmOGVkYjAxMjYgZmZmZmZmZmY4Zjg2NTExMApbICAgIDAuOTk5ODQwXSAgZmZm
Zjg4MDAxMjNhZmJhMCBmZmZmZmZmZjhlZGFjZWRjIGZmZmY4ODAwMTIzYjA2MTAgZmZmZjg4
MDAxMjNiMTJiMApbICAgIDAuOTk5ODQwXSAgZmZmZjg4MDAxMjNiMDYxMCBmZmZmODgwMDEy
M2IxMmIwIDAwMDAwMDAwMDAwMDAwMDQgZmZmZjg4MDAxMjNiMTI4OApbICAgIDAuOTk5ODQw
XSBDYWxsIFRyYWNlOgpbICAgIDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhlZGIwMTI2Pl0gZHVt
cF9zdGFjaysweDRkLzB4NjYKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZWRhY2VkYz5d
IHByaW50X2NpcmN1bGFyX2J1ZysweDJiNC8weDJjMgpbICAgIDAuOTk5ODQwXSAgWzxmZmZm
ZmZmZjhlOGIwZjNjPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4yMCsweDhjZi8weGYyZQpbICAg
IDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhlOGIzYjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcv
MHg5ZmIKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZThiNDE1ZT5dIGxvY2tfYWNxdWly
ZSsweGE0LzB4YzQKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZWRiY2IyNj5dID8ga3By
b2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhl
ZGI0OGZlPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDAuOTk5ODQwXSAg
WzxmZmZmZmZmZjhlZGJjYjI2Pl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsg
ICAgMC45OTk4NDBdICBbPGZmZmZmZmZmOGU4YjFlYjg+XSA/IHRyYWNlX2hhcmRpcnFzX29u
KzB4ZC8weGYKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZWRiY2IyNj5dIGtwcm9iZV9v
cHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZTg4ZGVm
NT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyMzcvMHgzZGIKWyAgICAwLjk5OTg0MF0gIFs8ZmZm
ZmZmZmY4ZTg4ZGU4Zj5dID8gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDAu
OTk5ODQwXSAgWzxmZmZmZmZmZjhlODhlY2VmPl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJj
NApbICAgIDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhlODhlYjI0Pl0gPyByZXNjdWVyX3RocmVh
ZCsweDI5Yi8weDI5YgpbICAgIDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhlODk0OGI5Pl0ga3Ro
cmVhZCsweGYxLzB4ZjkKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZmZmY4ZTg5NDdjOD5dID8g
a3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDAuOTk5ODQwXSAgWzxmZmZmZmZmZjhlZGJl
MjhjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjk5OTg0MF0gIFs8ZmZmZmZm
ZmY4ZTg5NDdjOD5dID8ga3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuMTA0ODcxXSBL
cHJvYmUgc21va2UgdGVzdCBwYXNzZWQgc3VjY2Vzc2Z1bGx5ClsgICAgMS4xMDYxOTJdIGJv
dW5jZSBwb29sIHNpemU6IDY0IHBhZ2VzClsgICAgMS4xMDY5ODVdIEh1Z2VUTEIgcmVnaXN0
ZXJlZCAyIE1CIHBhZ2Ugc2l6ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMjVlYzM3ZDNlM2JmMWY5ZWZlYzZmMDVkNzlm
ZDk3NmJmZjQ2MjRjZC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE3OjIwMTQwMzA5MTkzMzAz
Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtMDYzOTQtZzI1ZWMz
N2Q6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzI1ZWMzN2QzZTNi
ZjFmOWVmZWM2ZjA1ZDc5ZmQ5NzZiZmY0NjI0Y2QvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0x
OToyMDE0MDMwOTE5MzMwNDp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAt
cmM1LTA2Mzk0LWcyNWVjMzdkOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyOC8yNWVjMzdkM2UzYmYxZjllZmVjNmYwNWQ3OWZkOTc2YmZmNDYyNGNkL2RtZXNnLXlv
Y3RvLWl2eXRvd24yLTIzOjIwMTQwMzA5MTkzMzA2Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4OjMuMTQuMC1yYzUtMDYzOTQtZzI1ZWMzN2Q6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXI1LTAzMDkxMzI4LzI1ZWMzN2QzZTNiZjFmOWVmZWM2ZjA1ZDc5ZmQ5NzZiZmY0
NjI0Y2QvZG1lc2cteW9jdG8taXZ5dG93bjItMjoyMDE0MDMwOTE5MzMxMDp4ODZfNjQtcmFu
ZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LTA2Mzk0LWcyNWVjMzdkOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC8yNWVjMzdkM2UzYmYxZjllZmVjNmYw
NWQ3OWZkOTc2YmZmNDYyNGNkL2RtZXNnLXlvY3RvLWl2eXRvd24yLTQ6MjAxNDAzMDkxOTMz
MTU6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS0wNjM5NC1nMjVl
YzM3ZDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMjVlYzM3ZDNl
M2JmMWY5ZWZlYzZmMDVkNzlmZDk3NmJmZjQ2MjRjZC9kbWVzZy15b2N0by1pdnl0b3duMi0y
NToyMDE0MDMwOTE5MzMyNTp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAt
cmM1LTA2Mzk0LWcyNWVjMzdkOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyOC8yNWVjMzdkM2UzYmYxZjllZmVjNmYwNWQ3OWZkOTc2YmZmNDYyNGNkL2RtZXNnLXlv
Y3RvLXhnd28tNjoyMDE0MDMwOTE5MzMyNDp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMy
ODozLjE0LjAtcmM1LTA2Mzk0LWcyNWVjMzdkOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC8yNWVjMzdkM2UzYmYxZjllZmVjNmYwNWQ3OWZkOTc2YmZmNDYyNGNk
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTMxOjIwMTQwMzA5MTkzMzMyOng4Nl82NC1yYW5kY29u
ZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtMDYzOTQtZzI1ZWMzN2Q6MQoyOjg6OCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAxMzI2IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2QyZDI3NWY0MTA4NWM1
OTIwOTcyNWY4MTNjMjQzZDMxOGYxODVkMzZdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFu
Y2ggJ3dvcmtxdWV1ZXMvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkx
MzI4L25leHQ6bWFzdGVyOmQyZDI3NWY0MTA4NWM1OTIwOTcyNWY4MTNjMjQzZDMxOGYxODVk
MzY6YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0xOTozMzo0MCBkMmQyNzVmNDEwODVjNTkyMDk3
MjVmODEzYzI0M2QzMThmMTg1ZDM2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
LWQyZDI3NWY0MTA4NWM1OTIwOTcyNWY4MTNjMjQzZDMxOGYxODVkMzYKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2QyZDI3NWY0
MTA4NWM1OTIwOTcyNWY4MTNjMjQzZDMxOGYxODVkMzYKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4LWQyZDI3NWY0MTA4NWM1OTIwOTcyNWY4MTNjMjQzZDMxOGYxODVkMzYKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQt
cmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1kMmQyNzVmNDEwODVjNTkyMDk3MjVmODEzYzI0M2Qz
MThmMTg1ZDM2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMy
OC9kMmQyNzVmNDEwODVjNTkyMDk3MjVmODEzYzI0M2QzMThmMTg1ZDM2L3ZtbGludXotMy4x
NC4wLXJjNS0wNTQ3OS1nZDJkMjc1ZgoKMjAxNC0wMy0wOS0xOTo1NDo0MCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUKWyAgICAxLjAxMDA1Nl0gS3Byb2JlIHNtb2tl
IHRlc3Qgc3RhcnRlZApbICAgIDEuMDM2NjQwXSAKWyAgICAxLjAzNzA4OF0gPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgMS4w
Mzc1ODFdIFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRl
dGVjdGVkIF0KWyAgICAxLjAzNzU4MV0gMy4xNC4wLXJjNS0wNTQ3OS1nZDJkMjc1ZiAjMSBO
b3QgdGFpbnRlZApbICAgIDEuMDM3NTgxXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMS4wMzc1ODFdIGt3b3JrZXIvMDox
LzI0IGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMS4wMzc1ODFdICAodGV4dF9t
dXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4NzViYmFlNj5dIGtwcm9iZV9vcHRpbWl6
ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjAzNzU4MV0gClsgICAgMS4wMzc1ODFdIGJ1dCB0YXNr
IGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDEuMDM3NTgxXSAgKG1vZHVsZV9tdXRl
eCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4NzViYjllYT5dIGtwcm9iZV9vcHRpbWl6ZXIr
MHgyNS8weDIzYwpbICAgIDEuMDM3NTgxXSAKWyAgICAxLjAzNzU4MV0gd2hpY2ggbG9jayBh
bHJlYWR5IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDEuMDM3NTgxXSAKWyAgICAx
LjAzNzU4MV0gClsgICAgMS4wMzc1ODFdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWlu
IChpbiByZXZlcnNlIG9yZGVyKSBpczoKWyAgICAxLjAzNzU4MV0gCi0+ICMyIChtb2R1bGVf
bXV0ZXgpeysuKy4uLn06ClsgICAgMS4wMzc1ODFdICAgICAgICBbPGZmZmZmZmZmODcwYjNi
ODc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM3NTgxXSAgICAgICAg
WzxmZmZmZmZmZjg3MGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMDM3
NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWIzOGM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2
NS8weDM0YQpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3MDJmOTU0Pl0gbW9k
dWxlX2FsbG9jKzB4NDIvMHhiNQpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3
MGRiNzQ4Pl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAgMS4wMzc1ODFdICAgICAg
ICBbPGZmZmZmZmZmODc1YmJjZTE+XSBfX2dldF9pbnNuX3Nsb3QrMHhlMC8weDE2NQpbICAg
IDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWI5MDMyPl0gYXJjaF9wcmVwYXJlX2tw
cm9iZSsweDM2LzB4YjcKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZmZmY4NzViYzli
Mj5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDEuMDM3NTgxXSAgICAgICAg
WzxmZmZmZmZmZjg3MGQ2ZTkxPl0gaW5pdF90ZXN0X3Byb2JlcysweDRlLzB4NDg5ClsgICAg
MS4wMzc1ODFdICAgICAgICBbPGZmZmZmZmZmODdiNmMxMzM+XSBpbml0X2twcm9iZXMrMHgx
N2IvMHgxODkKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZmZmY4NzAwMjBmYj5dIGRv
X29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMS4wMzc1ODFdICAgICAgICBbPGZmZmZm
ZmZmODdiNTBmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMy8weDE5NApbICAgIDEu
MDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWE3NDc5Pl0ga2VybmVsX2luaXQrMHg5LzB4
ZDUKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZmZmY4NzViZDI0Yz5dIHJldF9mcm9t
X2ZvcmsrMHg3Yy8weGIwClsgICAgMS4wMzc1ODFdIAotPiAjMSAoa3Byb2JlX2luc25fc2xv
dHMubXV0ZXgpeysuKy4rLn06ClsgICAgMS4wMzc1ODFdICAgICAgICBbPGZmZmZmZmZmODcw
YjNiODc+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM3NTgxXSAgICAg
ICAgWzxmZmZmZmZmZjg3MGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEu
MDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWIzOGM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQr
MHg2NS8weDM0YQpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWJiYzFkPl0g
X19nZXRfaW5zbl9zbG90KzB4MWMvMHgxNjUKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZm
ZmZmZmY4NzViOTAzMj5dIGFyY2hfcHJlcGFyZV9rcHJvYmUrMHgzNi8weGI3ClsgICAgMS4w
Mzc1ODFdICAgICAgICBbPGZmZmZmZmZmODc1YmM5YjI+XSByZWdpc3Rlcl9rcHJvYmUrMHgz
MzAvMHg0OTAKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZmZmY4NzBkNmU5MT5dIGlu
aXRfdGVzdF9wcm9iZXMrMHg0ZS8weDQ4OQpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZm
ZmZmZjg3YjZjMTMzPl0gaW5pdF9rcHJvYmVzKzB4MTdiLzB4MTg5ClsgICAgMS4wMzc1ODFd
ICAgICAgICBbPGZmZmZmZmZmODcwMDIwZmI+XSBkb19vbmVfaW5pdGNhbGwrMHg5Zi8weDEz
NQpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3YjUwZjYzPl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHgxMDMvMHgxOTQKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZm
ZmY4NzVhNzQ3OT5dIGtlcm5lbF9pbml0KzB4OS8weGQ1ClsgICAgMS4wMzc1ODFdICAgICAg
ICBbPGZmZmZmZmZmODc1YmQyNGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEu
MDM3NTgxXSAKLT4gIzAgKHRleHRfbXV0ZXgpeysuKy4rLn06ClsgICAgMS4wMzc1ODFdICAg
ICAgICBbPGZmZmZmZmZmODcwYjBmM2M+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjIwKzB4OGNm
LzB4ZjJlClsgICAgMS4wMzc1ODFdICAgICAgICBbPGZmZmZmZmZmODcwYjNiODc+XSBfX2xv
Y2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZm
Zjg3MGI0MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMDM3NTgxXSAgICAg
ICAgWzxmZmZmZmZmZjg3NWIzOGM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpb
ICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3NWJiYWU2Pl0ga3Byb2JlX29wdGlt
aXplcisweDEyMS8weDIzYwpbICAgIDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3MDhk
ZWY1Pl0gcHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAgIDEuMDM3NTgxXSAgICAg
ICAgWzxmZmZmZmZmZjg3MDhlY2VmPl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAg
IDEuMDM3NTgxXSAgICAgICAgWzxmZmZmZmZmZjg3MDk0OGI5Pl0ga3RocmVhZCsweGYxLzB4
ZjkKWyAgICAxLjAzNzU4MV0gICAgICAgIFs8ZmZmZmZmZmY4NzViZDI0Yz5dIHJldF9mcm9t
X2ZvcmsrMHg3Yy8weGIwClsgICAgMS4wMzc1ODFdIApbICAgIDEuMDM3NTgxXSBvdGhlciBp
bmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgIDEuMDM3NTgxXSAKWyAg
ICAxLjAzNzU4MV0gQ2hhaW4gZXhpc3RzIG9mOgogIHRleHRfbXV0ZXggLS0+IGtwcm9iZV9p
bnNuX3Nsb3RzLm11dGV4IC0tPiBtb2R1bGVfbXV0ZXgKClsgICAgMS4wMzc1ODFdICBQb3Nz
aWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAxLjAzNzU4MV0gClsgICAgMS4w
Mzc1ODFdICAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUxClsgICAgMS4wMzc1
ODFdICAgICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tClsgICAgMS4wMzc1ODFd
ICAgbG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDEuMDM3NTgxXSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbG9jayhrcHJvYmVfaW5zbl9zbG90cy5tdXRleCk7ClsgICAgMS4w
Mzc1ODFdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKG1vZHVsZV9tdXRl
eCk7ClsgICAgMS4wMzc1ODFdICAgbG9jayh0ZXh0X211dGV4KTsKWyAgICAxLjAzNzU4MV0g
ClsgICAgMS4wMzc1ODFdICAqKiogREVBRExPQ0sgKioqClsgICAgMS4wMzc1ODFdIApbICAg
IDEuMDM3NTgxXSA0IGxvY2tzIGhlbGQgYnkga3dvcmtlci8wOjEvMjQ6ClsgICAgMS4wMzc1
ODFdICAjMDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZmZmZmZmY4NzA4ZGU4Zj5d
IHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAxLjAzNzU4MV0gICMxOiAgKChv
cHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODcwOGRlOGY+
XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS4wMzc1ODFdICAjMjogIChr
cHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODc1YmI5ZGM+XSBrcHJvYmVf
b3B0aW1pemVyKzB4MTcvMHgyM2MKWyAgICAxLjAzNzU4MV0gICMzOiAgKG1vZHVsZV9tdXRl
eCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4NzViYjllYT5dIGtwcm9iZV9vcHRpbWl6ZXIr
MHgyNS8weDIzYwpbICAgIDEuMDM3NTgxXSAKWyAgICAxLjAzNzU4MV0gc3RhY2sgYmFja3Ry
YWNlOgpbICAgIDEuMDM3NTgxXSBDUFU6IDAgUElEOiAyNCBDb21tOiBrd29ya2VyLzA6MSBO
b3QgdGFpbnRlZCAzLjE0LjAtcmM1LTA1NDc5LWdkMmQyNzVmICMxClsgICAgMS4wMzc1ODFd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
ICAxLjAzNzU4MV0gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29wdGltaXplcgpbICAgIDEu
MDM3NTgxXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyM2FmYjYwIGZmZmZmZmZmODc1
YWYzMDYgZmZmZmZmZmY4ODA2NTExMApbICAgIDEuMDM3NTgxXSAgZmZmZjg4MDAxMjNhZmJh
MCBmZmZmZmZmZjg3NWFjMGJjIGZmZmY4ODAwMTIzYjA2MTAgZmZmZjg4MDAxMjNiMTJiMApb
ICAgIDEuMDM3NTgxXSAgZmZmZjg4MDAxMjNiMDYxMCBmZmZmODgwMDEyM2IxMmIwIDAwMDAw
MDAwMDAwMDAwMDQgZmZmZjg4MDAxMjNiMTI4OApbICAgIDEuMDM3NTgxXSBDYWxsIFRyYWNl
OgpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3NWFmMzA2Pl0gZHVtcF9zdGFjaysweDRk
LzB4NjYKWyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzVhYzBiYz5dIHByaW50X2NpcmN1
bGFyX2J1ZysweDJiNC8weDJjMgpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3MGIwZjNj
Pl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4yMCsweDhjZi8weGYyZQpbICAgIDEuMDM3NTgxXSAg
WzxmZmZmZmZmZjg3MGIzYjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAx
LjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzBiNDE1ZT5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQK
WyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzViYmFlNj5dID8ga3Byb2JlX29wdGltaXpl
cisweDEyMS8weDIzYwpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3NWIzOGM2Pl0gbXV0
ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3
NWJiYWU2Pl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS4wMzc1ODFd
ICBbPGZmZmZmZmZmODcwYjFlYjg+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4ZC8weGYKWyAg
ICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzViYmFlNj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgx
MjEvMHgyM2MKWyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzA4ZGVmNT5dIHByb2Nlc3Nf
b25lX3dvcmsrMHgyMzcvMHgzZGIKWyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzA4ZGU4
Zj5dID8gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDEuMDM3NTgxXSAgWzxm
ZmZmZmZmZjg3MDhlY2VmPl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuMDM3
NTgxXSAgWzxmZmZmZmZmZjg3MDhlYjI0Pl0gPyByZXNjdWVyX3RocmVhZCsweDI5Yi8weDI5
YgpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3MDk0OGI5Pl0ga3RocmVhZCsweGYxLzB4
ZjkKWyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzA5NDdjOD5dID8ga3RocmVhZF9zdG9w
KzB4NWEvMHg1YQpbICAgIDEuMDM3NTgxXSAgWzxmZmZmZmZmZjg3NWJkMjRjPl0gcmV0X2Zy
b21fZm9yaysweDdjLzB4YjAKWyAgICAxLjAzNzU4MV0gIFs8ZmZmZmZmZmY4NzA5NDdjOD5d
ID8ga3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuMTQyNjExXSBLcHJvYmUgc21va2Ug
dGVzdCBwYXNzZWQgc3VjY2Vzc2Z1bGx5ClsgICAgMS4xNDM4ODJdIGJvdW5jZSBwb29sIHNp
emU6IDY0IHBhZ2VzClsgICAgMS4xNDQ1OTBdIEh1Z2VUTEIgcmVnaXN0ZXJlZCAyIE1CIHBh
Z2Ugc2l6ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjgvZDJkMjc1ZjQxMDg1YzU5MjA5NzI1ZjgxM2MyNDNkMzE4ZjE4NWQz
Ni9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTI1OjIwMTQwMzA5MTk1NTIzOng4Nl82NC1yYW5k
Y29uZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtMDU0NzktZ2QyZDI3NWY6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2QyZDI3NWY0MTA4NWM1OTIwOTcyNWY4
MTNjMjQzZDMxOGYxODVkMzYvZG1lc2cteW9jdG8taXZ5dG93bjItMTg6MjAxNDAzMDkxOTU1
MzQ6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS0wNTQ3OS1nZDJk
Mjc1ZjoxCjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDQx
MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykK
W2U4OGY4NDY1Y2ZjY2UwNDJlNDhmZjM4ZTc5NmI2NGRmOTczYzcwNDhdIE1lcmdlIHJlbW90
ZS10cmFja2luZyBicmFuY2ggJ2Z0cmFjZS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjgvbmV4dDptYXN0ZXI6ZTg4Zjg0NjVjZmNjZTA0MmU0OGZmMzhlNzk2
YjY0ZGY5NzNjNzA0ODpiaXNlY3QtdXNiCgoyMDE0LTAzLTA5LTE5OjU1OjQzIGU4OGY4NDY1
Y2ZjY2UwNDJlNDhmZjM4ZTc5NmI2NGRmOTczYzcwNDggY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjUtMDMwOTEzMjgtZTg4Zjg0NjVjZmNjZTA0MmU0OGZmMzhlNzk2YjY0ZGY5NzNjNzA0OApD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEz
MjgvZTg4Zjg0NjVjZmNjZTA0MmU0OGZmMzhlNzk2YjY0ZGY5NzNjNzA0OAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctcjUtMDMwOTEzMjgtZTg4Zjg0NjVjZmNjZTA0MmU0OGZmMzhlNzk2YjY0ZGY5NzNj
NzA0OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWU4OGY4NDY1Y2ZjY2UwNDJlNDhm
ZjM4ZTc5NmI2NGRmOTczYzcwNDgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4L2U4OGY4NDY1Y2ZjY2UwNDJlNDhmZjM4ZTc5NmI2NGRmOTczYzcwNDgv
dm1saW51ei0zLjE0LjAtcmM1LTA1NDI0LWdlODhmODQ2CgoyMDE0LTAzLTA5LTIwOjA1OjQ0
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4gVEVTVCBGQUlMVVJFClsgICAgMS42NjM4NTdd
IEtwcm9iZSBzbW9rZSB0ZXN0IHN0YXJ0ZWQKWyAgICAxLjY4OTY5Nl0gClsgICAgMS42OTA1
MTNdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQpbICAgIDEuNjkwNjEwXSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcg
ZGVwZW5kZW5jeSBkZXRlY3RlZCBdClsgICAgMS42OTMzMDddIDMuMTQuMC1yYzUtMDU0MjQt
Z2U4OGY4NDYgIzEgTm90IHRhaW50ZWQKWyAgICAxLjY5MzMwN10gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDEuNjkzMzA3
XSBrd29ya2VyLzE6MS8yNSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDEuNjkz
MzA3XSAgKHRleHRfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODYxYmNiMjY+XSBr
cHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS42OTMzMDddIApbICAgIDEuNjkz
MzA3XSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICAxLjY5MzMwN10g
IChtb2R1bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODYxYmNhMmE+XSBrcHJv
YmVfb3B0aW1pemVyKzB4MjUvMHgyM2MKWyAgICAxLjY5MzMwN10gClsgICAgMS42OTMzMDdd
IHdoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgICAxLjY5
MzMwN10gClsgICAgMS42OTMzMDddIApbICAgIDEuNjkzMzA3XSB0aGUgZXhpc3RpbmcgZGVw
ZW5kZW5jeSBjaGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAgMS42OTMzMDddIAot
PiAjMiAobW9kdWxlX211dGV4KXsrLisuLi59OgpbICAgIDEuNjkzMzA3XSAgICAgICAgWzxm
ZmZmZmZmZjg1Y2I0Yjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAxLjY5
MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NWNiNTE1ZT5dIGxvY2tfYWNxdWlyZSsweGE0LzB4
YzQKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFiNDkwZT5dIG11dGV4X2xv
Y2tfbmVzdGVkKzB4NjUvMHgzNGEKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4
NWMzMDk1ND5dIG1vZHVsZV9hbGxvYysweDQyLzB4YjUKWyAgICAxLjY5MzMwN10gICAgICAg
IFs8ZmZmZmZmZmY4NWNkYzc0OD5dIGFsbG9jX2luc25fcGFnZSsweGUvMHgxMApbICAgIDEu
NjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg2MWJjZDIxPl0gX19nZXRfaW5zbl9zbG90KzB4
ZTAvMHgxNjUKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFiYTA3Mj5dIGFy
Y2hfcHJlcGFyZV9rcHJvYmUrMHgzNi8weGI3ClsgICAgMS42OTMzMDddICAgICAgICBbPGZm
ZmZmZmZmODYxYmQ5ZjI+XSByZWdpc3Rlcl9rcHJvYmUrMHgzMzAvMHg0OTAKWyAgICAxLjY5
MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NWNkN2U5MT5dIGluaXRfdGVzdF9wcm9iZXMrMHg0
ZS8weDQ4OQpbICAgIDEuNjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg2NzZjMDk2Pl0gaW5p
dF9rcHJvYmVzKzB4MTdiLzB4MTg5ClsgICAgMS42OTMzMDddICAgICAgICBbPGZmZmZmZmZm
ODVjMDIwZmI+XSBkb19vbmVfaW5pdGNhbGwrMHg5Zi8weDEzNQpbICAgIDEuNjkzMzA3XSAg
ICAgICAgWzxmZmZmZmZmZjg2NzUwZjYzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMDMv
MHgxOTQKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFhODUwOT5dIGtlcm5l
bF9pbml0KzB4OS8weGQ1ClsgICAgMS42OTMzMDddICAgICAgICBbPGZmZmZmZmZmODYxYmUy
OGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuNjkzMzA3XSAKLT4gIzEgKGtw
cm9iZV9pbnNuX3Nsb3RzLm11dGV4KXsrLisuKy59OgpbICAgIDEuNjkzMzA3XSAgICAgICAg
WzxmZmZmZmZmZjg1Y2I0Yjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAx
LjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NWNiNTE1ZT5dIGxvY2tfYWNxdWlyZSsweGE0
LzB4YzQKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFiNDkwZT5dIG11dGV4
X2xvY2tfbmVzdGVkKzB4NjUvMHgzNGEKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZm
ZmY4NjFiY2M1ZD5dIF9fZ2V0X2luc25fc2xvdCsweDFjLzB4MTY1ClsgICAgMS42OTMzMDdd
ICAgICAgICBbPGZmZmZmZmZmODYxYmEwNzI+XSBhcmNoX3ByZXBhcmVfa3Byb2JlKzB4MzYv
MHhiNwpbICAgIDEuNjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg2MWJkOWYyPl0gcmVnaXN0
ZXJfa3Byb2JlKzB4MzMwLzB4NDkwClsgICAgMS42OTMzMDddICAgICAgICBbPGZmZmZmZmZm
ODVjZDdlOTE+XSBpbml0X3Rlc3RfcHJvYmVzKzB4NGUvMHg0ODkKWyAgICAxLjY5MzMwN10g
ICAgICAgIFs8ZmZmZmZmZmY4Njc2YzA5Nj5dIGluaXRfa3Byb2JlcysweDE3Yi8weDE4OQpb
ICAgIDEuNjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg1YzAyMGZiPl0gZG9fb25lX2luaXRj
YWxsKzB4OWYvMHgxMzUKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4Njc1MGY2
Mz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTAzLzB4MTk0ClsgICAgMS42OTMzMDddICAg
ICAgICBbPGZmZmZmZmZmODYxYTg1MDk+XSBrZXJuZWxfaW5pdCsweDkvMHhkNQpbICAgIDEu
NjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg2MWJlMjhjPl0gcmV0X2Zyb21fZm9yaysweDdj
LzB4YjAKWyAgICAxLjY5MzMwN10gCi0+ICMwICh0ZXh0X211dGV4KXsrLisuKy59OgpbICAg
IDEuNjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg1Y2IxZjNjPl0gdmFsaWRhdGVfY2hhaW4u
aXNyYS4yMCsweDhjZi8weGYyZQpbICAgIDEuNjkzMzA3XSAgICAgICAgWzxmZmZmZmZmZjg1
Y2I0Yjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAxLjY5MzMwN10gICAg
ICAgIFs8ZmZmZmZmZmY4NWNiNTE1ZT5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAgICAx
LjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFiNDkwZT5dIG11dGV4X2xvY2tfbmVzdGVk
KzB4NjUvMHgzNGEKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NjFiY2IyNj5d
IGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjY5MzMwN10gICAgICAgIFs8
ZmZmZmZmZmY4NWM4ZWVmNT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyMzcvMHgzZGIKWyAgICAx
LjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NWM4ZmNlZj5dIHdvcmtlcl90aHJlYWQrMHgx
Y2IvMHgyYzQKWyAgICAxLjY5MzMwN10gICAgICAgIFs8ZmZmZmZmZmY4NWM5NThiOT5dIGt0
aHJlYWQrMHhmMS8weGY5ClsgICAgMS42OTMzMDddICAgICAgICBbPGZmZmZmZmZmODYxYmUy
OGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuNjkzMzA3XSAKWyAgICAxLjY5
MzMwN10gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgICAx
LjY5MzMwN10gClsgICAgMS42OTMzMDddIENoYWluIGV4aXN0cyBvZjoKICB0ZXh0X211dGV4
IC0tPiBrcHJvYmVfaW5zbl9zbG90cy5tdXRleCAtLT4gbW9kdWxlX211dGV4CgpbICAgIDEu
NjkzMzA3XSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86ClsgICAgMS42OTMz
MDddIApbICAgIDEuNjkzMzA3XSAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgQ1BV
MQpbICAgIDEuNjkzMzA3XSAgICAgICAgLS0tLSAgICAgICAgICAgICAgICAgICAgLS0tLQpb
ICAgIDEuNjkzMzA3XSAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAxLjY5MzMwN10gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soa3Byb2JlX2luc25fc2xvdHMubXV0
ZXgpOwpbICAgIDEuNjkzMzA3XSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9j
ayhtb2R1bGVfbXV0ZXgpOwpbICAgIDEuNjkzMzA3XSAgIGxvY2sodGV4dF9tdXRleCk7Clsg
ICAgMS42OTMzMDddIApbICAgIDEuNjkzMzA3XSAgKioqIERFQURMT0NLICoqKgpbICAgIDEu
NjkzMzA3XSAKWyAgICAxLjY5MzMwN10gNCBsb2NrcyBoZWxkIGJ5IGt3b3JrZXIvMToxLzI1
OgpbICAgIDEuNjkzMzA3XSAgIzA6ICAoImV2ZW50cyIpey4rLisuLn0sIGF0OiBbPGZmZmZm
ZmZmODVjOGVlOGY+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS42OTMz
MDddICAjMTogICgob3B0aW1pemluZ193b3JrKS53b3JrKXsrLisuLi59LCBhdDogWzxmZmZm
ZmZmZjg1YzhlZThmPl0gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDEuNjkz
MzA3XSAgIzI6ICAoa3Byb2JlX211dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjg2MWJj
YTFjPl0ga3Byb2JlX29wdGltaXplcisweDE3LzB4MjNjClsgICAgMS42OTMzMDddICAjMzog
IChtb2R1bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODYxYmNhMmE+XSBrcHJv
YmVfb3B0aW1pemVyKzB4MjUvMHgyM2MKWyAgICAxLjY5MzMwN10gClsgICAgMS42OTMzMDdd
IHN0YWNrIGJhY2t0cmFjZToKWyAgICAxLjY5MzMwN10gQ1BVOiAxIFBJRDogMjUgQ29tbTog
a3dvcmtlci8xOjEgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wNTQyNC1nZTg4Zjg0NiAjMQpb
ICAgIDEuNjkzMzA3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMS42OTMzMDddIFdvcmtxdWV1ZTogZXZlbnRzIGtwcm9iZV9vcHRp
bWl6ZXIKWyAgICAxLjY5MzMwN10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwODU0MWI2
MCBmZmZmZmZmZjg2MWIwMzUwIGZmZmZmZmZmODZjNjUwZDAKWyAgICAxLjY5MzMwN10gIGZm
ZmY4ODAwMDg1NDFiYTAgZmZmZmZmZmY4NjFhZDEwNiBmZmZmODgwMDA4NTNjNjUwIGZmZmY4
ODAwMDg1M2QyZjAKWyAgICAxLjY5MzMwN10gIGZmZmY4ODAwMDg1M2M2NTAgZmZmZjg4MDAw
ODUzZDJmMCAwMDAwMDAwMDAwMDAwMDA0IGZmZmY4ODAwMDg1M2QyYzgKWyAgICAxLjY5MzMw
N10gQ2FsbCBUcmFjZToKWyAgICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4NjFiMDM1MD5dIGR1
bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODYxYWQxMDY+
XSBwcmludF9jaXJjdWxhcl9idWcrMHgyYjQvMHgyYzIKWyAgICAxLjY5MzMwN10gIFs8ZmZm
ZmZmZmY4NWNiMWYzYz5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMjArMHg4Y2YvMHhmMmUKWyAg
ICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4NWNiNGI4Nz5dIF9fbG9ja19hY3F1aXJlKzB4OTA3
LzB4OWZiClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODVjYjUxNWU+XSBsb2NrX2FjcXVp
cmUrMHhhNC8weGM0ClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODYxYmNiMjY+XSA/IGtw
cm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4
NjFiNDkwZT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NjUvMHgzNGEKWyAgICAxLjY5MzMwN10g
IFs8ZmZmZmZmZmY4NjFiY2IyNj5dID8ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpb
ICAgIDEuNjkzMzA3XSAgWzxmZmZmZmZmZjg1Y2IyZWI4Pl0gPyB0cmFjZV9oYXJkaXJxc19v
bisweGQvMHhmClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODYxYmNiMjY+XSBrcHJvYmVf
b3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODVjOGVl
ZjU+XSBwcm9jZXNzX29uZV93b3JrKzB4MjM3LzB4M2RiClsgICAgMS42OTMzMDddICBbPGZm
ZmZmZmZmODVjOGVlOGY+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAx
LjY5MzMwN10gIFs8ZmZmZmZmZmY4NWM4ZmNlZj5dIHdvcmtlcl90aHJlYWQrMHgxY2IvMHgy
YzQKWyAgICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4NWM4ZmIyND5dID8gcmVzY3Vlcl90aHJl
YWQrMHgyOWIvMHgyOWIKWyAgICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4NWM5NThiOT5dIGt0
aHJlYWQrMHhmMS8weGY5ClsgICAgMS42OTMzMDddICBbPGZmZmZmZmZmODVjOTU3Yzg+XSA/
IGt0aHJlYWRfc3RvcCsweDVhLzB4NWEKWyAgICAxLjY5MzMwN10gIFs8ZmZmZmZmZmY4NjFi
ZTI4Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMS42OTMzMDddICBbPGZmZmZm
ZmZmODVjOTU3Yzg+XSA/IGt0aHJlYWRfc3RvcCsweDVhLzB4NWEKWyAgICAxLjg1MDIzNV0g
S3Byb2JlIHNtb2tlIHRlc3QgcGFzc2VkIHN1Y2Nlc3NmdWxseQpbICAgIDEuODUyNjM4XSBi
b3VuY2UgcG9vbCBzaXplOiA2NCBwYWdlcwpbICAgIDEuODUzODQ0XSBIdWdlVExCIHJlZ2lz
dGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxvY2F0ZWQgMCBwYWdlcwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2U4OGY4NDY1Y2ZjY2UwNDJlNDhmZjM4ZTc5
NmI2NGRmOTczYzcwNDgvZG1lc2ctcXVhbnRhbC1yb2FtLTQzOjIwMTQwMzA5MjAwNzE5Ong4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtMDU0MjQtZ2U4OGY4NDY6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2U4OGY4NDY1Y2ZjY2Uw
NDJlNDhmZjM4ZTc5NmI2NGRmOTczYzcwNDgvZG1lc2cteW9jdG8taXZ5dG93bjItMTY6MjAx
NDAzMDkyMDA3MzE6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS0w
NTQyNC1nZTg4Zjg0NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgv
ZTg4Zjg0NjVjZmNjZTA0MmU0OGZmMzhlNzk2YjY0ZGY5NzNjNzA0OC9kbWVzZy15b2N0by1p
dnl0b3duMi0zOjIwMTQwMzA5MjAwNzMzOng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
OjMuMTQuMC1yYzUtMDU0MjQtZ2U4OGY4NDY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4L2U4OGY4NDY1Y2ZjY2UwNDJlNDhmZjM4ZTc5NmI2NGRmOTczYzcwNDgv
ZG1lc2cteW9jdG8taXZ5dG93bjItMTA6MjAxNDAzMDkyMDA3Mzc6eDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS0wNTQyNC1nZTg4Zjg0NjoxCjA6NDo0IGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDM1NiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2Y0ZjQ4YTI2OTJmOWRlMGQx
ZWJiZWVlN2JhMTkyYTk5ZTg2ZDE3NzNdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J3RpcC9hdXRvLWxhdGVzdCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvbmV4
dDptYXN0ZXI6ZjRmNDhhMjY5MmY5ZGUwZDFlYmJlZWU3YmExOTJhOTllODZkMTc3MzpiaXNl
Y3QtdXNiCgoyMDE0LTAzLTA5LTIwOjA3OjQ4IGY0ZjQ4YTI2OTJmOWRlMGQxZWJiZWVlN2Jh
MTkyYTk5ZTg2ZDE3NzMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtZjRmNDhh
MjY5MmY5ZGUwZDFlYmJlZWU3YmExOTJhOTllODZkMTc3MwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvZjRmNDhhMjY5MmY5ZGUw
ZDFlYmJlZWU3YmExOTJhOTllODZkMTc3Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgt
ZjRmNDhhMjY5MmY5ZGUwZDFlYmJlZWU3YmExOTJhOTllODZkMTc3Mwp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29u
ZmlnLXI1LTAzMDkxMzI4LWY0ZjQ4YTI2OTJmOWRlMGQxZWJiZWVlN2JhMTkyYTk5ZTg2ZDE3
NzMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2Y0ZjQ4
YTI2OTJmOWRlMGQxZWJiZWVlN2JhMTkyYTk5ZTg2ZDE3NzMvdm1saW51ei0zLjE0LjAtcmM1
LTA1MzkwLWdmNGY0OGEyCgoyMDE0LTAzLTA5LTIwOjIyOjQ4IGRldGVjdGluZyBib290IHN0
YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAxLjEwODYxNF0gS3Byb2JlIHNtb2tlIHRlc3Qg
c3RhcnRlZApbICAgIDEuMTM2OTgwXSAKWyAgICAxLjEzNzYyNV0gPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgMS4xMzg4NDNd
IFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVk
IF0KWyAgICAxLjEzODg0M10gMy4xNC4wLXJjNS0wNTM5MC1nZjRmNDhhMiAjMiBOb3QgdGFp
bnRlZApbICAgIDEuMTM4ODQzXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMS4xMzg4NDNdIGt3b3JrZXIvMToxLzI1IGlz
IHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMS4xNDM4MjRdICAodGV4dF9tdXRleCl7
Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4YjViY2IyNj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgx
MjEvMHgyM2MKWyAgICAxLjE0MzgyNF0gClsgICAgMS4xNDM4MjRdIGJ1dCB0YXNrIGlzIGFs
cmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDEuMTQzODI0XSAgKG1vZHVsZV9tdXRleCl7Ky4r
Li4ufSwgYXQ6IFs8ZmZmZmZmZmY4YjViY2EyYT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgyNS8w
eDIzYwpbICAgIDEuMTQzODI0XSAKWyAgICAxLjE0MzgyNF0gd2hpY2ggbG9jayBhbHJlYWR5
IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDEuMTQzODI0XSAKWyAgICAxLjE0Mzgy
NF0gClsgICAgMS4xNDM4MjRdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiBy
ZXZlcnNlIG9yZGVyKSBpczoKWyAgICAxLjE0MzgyNF0gCi0+ICMyIChtb2R1bGVfbXV0ZXgp
eysuKy4uLn06ClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZmZmZmZmZmOGIwYjRiODc+XSBf
X2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZm
ZmZmZjhiMGI1MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMTQzODI0XSAg
ICAgICAgWzxmZmZmZmZmZjhiNWI0OTBlPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0
YQpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiMDMwOTU0Pl0gbW9kdWxlX2Fs
bG9jKzB4NDIvMHhiNQpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiMGRjNzQ4
Pl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZm
ZmZmZmZmOGI1YmNkMjE+XSBfX2dldF9pbnNuX3Nsb3QrMHhlMC8weDE2NQpbICAgIDEuMTQz
ODI0XSAgICAgICAgWzxmZmZmZmZmZjhiNWJhMDcyPl0gYXJjaF9wcmVwYXJlX2twcm9iZSsw
eDM2LzB4YjcKWyAgICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjViZDlmMj5dIHJl
Z2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZm
ZmZmZjhiMGQ3ZTkxPl0gaW5pdF90ZXN0X3Byb2JlcysweDRlLzB4NDg5ClsgICAgMS4xNDM4
MjRdICAgICAgICBbPGZmZmZmZmZmOGJiNmMwOTY+XSBpbml0X2twcm9iZXMrMHgxN2IvMHgx
ODkKWyAgICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjAwMjBmYj5dIGRvX29uZV9p
bml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZmZmZmZmZmOGJi
NTBmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMy8weDE5NApbICAgIDEuMTQzODI0
XSAgICAgICAgWzxmZmZmZmZmZjhiNWE4NTA5Pl0ga2VybmVsX2luaXQrMHg5LzB4ZDUKWyAg
ICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjViZTI4Yz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS4xNDM4MjRdIAotPiAjMSAoa3Byb2JlX2luc25fc2xvdHMubXV0
ZXgpeysuKy4rLn06ClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZmZmZmZmZmOGIwYjRiODc+
XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMTQzODI0XSAgICAgICAgWzxm
ZmZmZmZmZjhiMGI1MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMTQzODI0
XSAgICAgICAgWzxmZmZmZmZmZjhiNWI0OTBlPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8w
eDM0YQpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiNWJjYzVkPl0gX19nZXRf
aW5zbl9zbG90KzB4MWMvMHgxNjUKWyAgICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4
YjViYTA3Mj5dIGFyY2hfcHJlcGFyZV9rcHJvYmUrMHgzNi8weGI3ClsgICAgMS4xNDM4MjRd
ICAgICAgICBbPGZmZmZmZmZmOGI1YmQ5ZjI+XSByZWdpc3Rlcl9rcHJvYmUrMHgzMzAvMHg0
OTAKWyAgICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjBkN2U5MT5dIGluaXRfdGVz
dF9wcm9iZXMrMHg0ZS8weDQ4OQpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhi
YjZjMDk2Pl0gaW5pdF9rcHJvYmVzKzB4MTdiLzB4MTg5ClsgICAgMS4xNDM4MjRdICAgICAg
ICBbPGZmZmZmZmZmOGIwMDIwZmI+XSBkb19vbmVfaW5pdGNhbGwrMHg5Zi8weDEzNQpbICAg
IDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiYjUwZjYzPl0ga2VybmVsX2luaXRfZnJl
ZWFibGUrMHgxMDMvMHgxOTQKWyAgICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjVh
ODUwOT5dIGtlcm5lbF9pbml0KzB4OS8weGQ1ClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZm
ZmZmZmZmOGI1YmUyOGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuMTQzODI0
XSAKLT4gIzAgKHRleHRfbXV0ZXgpeysuKy4rLn06ClsgICAgMS4xNDM4MjRdICAgICAgICBb
PGZmZmZmZmZmOGIwYjFmM2M+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjIwKzB4OGNmLzB4ZjJl
ClsgICAgMS4xNDM4MjRdICAgICAgICBbPGZmZmZmZmZmOGIwYjRiODc+XSBfX2xvY2tfYWNx
dWlyZSsweDkwNy8weDlmYgpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiMGI1
MTVlPl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMTQzODI0XSAgICAgICAgWzxm
ZmZmZmZmZjhiNWI0OTBlPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEu
MTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiNWJjYjI2Pl0ga3Byb2JlX29wdGltaXplcisw
eDEyMS8weDIzYwpbICAgIDEuMTQzODI0XSAgICAgICAgWzxmZmZmZmZmZjhiMDhlZWY1Pl0g
cHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAgIDEuMTQzODI0XSAgICAgICAgWzxm
ZmZmZmZmZjhiMDhmY2VmPl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuMTQz
ODI0XSAgICAgICAgWzxmZmZmZmZmZjhiMDk1OGI5Pl0ga3RocmVhZCsweGYxLzB4ZjkKWyAg
ICAxLjE0MzgyNF0gICAgICAgIFs8ZmZmZmZmZmY4YjViZTI4Yz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS4xNDM4MjRdIApbICAgIDEuMTQzODI0XSBvdGhlciBpbmZvIHRo
YXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgIDEuMTQzODI0XSAKWyAgICAxLjE0
MzgyNF0gQ2hhaW4gZXhpc3RzIG9mOgogIHRleHRfbXV0ZXggLS0+IGtwcm9iZV9pbnNuX3Ns
b3RzLm11dGV4IC0tPiBtb2R1bGVfbXV0ZXgKClsgICAgMS4xNDM4MjRdICBQb3NzaWJsZSB1
bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAxLjE0MzgyNF0gClsgICAgMS4xNDM4MjRd
ICAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUxClsgICAgMS4xNDM4MjRdICAg
ICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tClsgICAgMS4xNDM4MjRdICAgbG9j
ayhtb2R1bGVfbXV0ZXgpOwpbICAgIDEuMTQzODI0XSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbG9jayhrcHJvYmVfaW5zbl9zbG90cy5tdXRleCk7ClsgICAgMS4xNDM4MjRd
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKG1vZHVsZV9tdXRleCk7Clsg
ICAgMS4xNDM4MjRdICAgbG9jayh0ZXh0X211dGV4KTsKWyAgICAxLjE0MzgyNF0gClsgICAg
MS4xNDM4MjRdICAqKiogREVBRExPQ0sgKioqClsgICAgMS4xNDM4MjRdIApbICAgIDEuMTQz
ODI0XSA0IGxvY2tzIGhlbGQgYnkga3dvcmtlci8xOjEvMjU6ClsgICAgMS4xNDM4MjRdICAj
MDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZmZmZmZmY4YjA4ZWU4Zj5dIHByb2Nl
c3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAxLjE0MzgyNF0gICMxOiAgKChvcHRpbWl6
aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmOGIwOGVlOGY+XSBwcm9j
ZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS4xNDM4MjRdICAjMjogIChrcHJvYmVf
bXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGI1YmNhMWM+XSBrcHJvYmVfb3B0aW1p
emVyKzB4MTcvMHgyM2MKWyAgICAxLjE0MzgyNF0gICMzOiAgKG1vZHVsZV9tdXRleCl7Ky4r
Li4ufSwgYXQ6IFs8ZmZmZmZmZmY4YjViY2EyYT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgyNS8w
eDIzYwpbICAgIDEuMTQzODI0XSAKWyAgICAxLjE0MzgyNF0gc3RhY2sgYmFja3RyYWNlOgpb
ICAgIDEuMTQzODI0XSBDUFU6IDEgUElEOiAyNSBDb21tOiBrd29ya2VyLzE6MSBOb3QgdGFp
bnRlZCAzLjE0LjAtcmM1LTA1MzkwLWdmNGY0OGEyICMyClsgICAgMS4xNDM4MjRdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjE0
MzgyNF0gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29wdGltaXplcgpbICAgIDEuMTQzODI0
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBhZDJmYjYwIGZmZmZmZmZmOGI1YjAzNTAg
ZmZmZmZmZmY4YzA2NTBkMApbICAgIDEuMTQzODI0XSAgZmZmZjg4MDAwYWQyZmJhMCBmZmZm
ZmZmZjhiNWFkMTA2IGZmZmY4ODAwMGFkMzA2NTAgZmZmZjg4MDAwYWQzMTJmMApbICAgIDEu
MTQzODI0XSAgZmZmZjg4MDAwYWQzMDY1MCBmZmZmODgwMDBhZDMxMmYwIDAwMDAwMDAwMDAw
MDAwMDQgZmZmZjg4MDAwYWQzMTJjOApbICAgIDEuMTQzODI0XSBDYWxsIFRyYWNlOgpbICAg
IDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiNWIwMzUwPl0gZHVtcF9zdGFjaysweDRkLzB4NjYK
WyAgICAxLjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjVhZDEwNj5dIHByaW50X2NpcmN1bGFyX2J1
ZysweDJiNC8weDJjMgpbICAgIDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiMGIxZjNjPl0gdmFs
aWRhdGVfY2hhaW4uaXNyYS4yMCsweDhjZi8weGYyZQpbICAgIDEuMTQzODI0XSAgWzxmZmZm
ZmZmZjhiMGI0Yjg3Pl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAxLjE0Mzgy
NF0gIFs8ZmZmZmZmZmY4YjBiNTE1ZT5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAgICAx
LjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjViY2IyNj5dID8ga3Byb2JlX29wdGltaXplcisweDEy
MS8weDIzYwpbICAgIDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiNWI0OTBlPl0gbXV0ZXhfbG9j
a19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiNWJjYjI2
Pl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS4xNDM4MjRdICBbPGZm
ZmZmZmZmOGIwYjJlYjg+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4ZC8weGYKWyAgICAxLjE0
MzgyNF0gIFs8ZmZmZmZmZmY4YjViY2IyNj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgy
M2MKWyAgICAxLjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjA4ZWVmNT5dIHByb2Nlc3Nfb25lX3dv
cmsrMHgyMzcvMHgzZGIKWyAgICAxLjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjA4ZWU4Zj5dID8g
cHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDEuMTQzODI0XSAgWzxmZmZmZmZm
ZjhiMDhmY2VmPl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuMTQzODI0XSAg
WzxmZmZmZmZmZjhiMDhmYjI0Pl0gPyByZXNjdWVyX3RocmVhZCsweDI5Yi8weDI5YgpbICAg
IDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiMDk1OGI5Pl0ga3RocmVhZCsweGYxLzB4ZjkKWyAg
ICAxLjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjA5NTdjOD5dID8ga3RocmVhZF9zdG9wKzB4NWEv
MHg1YQpbICAgIDEuMTQzODI0XSAgWzxmZmZmZmZmZjhiNWJlMjhjPl0gcmV0X2Zyb21fZm9y
aysweDdjLzB4YjAKWyAgICAxLjE0MzgyNF0gIFs8ZmZmZmZmZmY4YjA5NTdjOD5dID8ga3Ro
cmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuMjk4OTY0XSBLcHJvYmUgc21va2UgdGVzdCBw
YXNzZWQgc3VjY2Vzc2Z1bGx5ClsgICAgMS4zMDA2NDJdIGJvdW5jZSBwb29sIHNpemU6IDY0
IHBhZ2VzClsgICAgMS4zMDE2NDNdIEh1Z2VUTEIgcmVnaXN0ZXJlZCAyIE1CIHBhZ2Ugc2l6
ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUt
MDMwOTEzMjgvZjRmNDhhMjY5MmY5ZGUwZDFlYmJlZWU3YmExOTJhOTllODZkMTc3My9kbWVz
Zy1xdWFudGFsLWl2eXRvd24yLTI4OjIwMTQwMzA5MjAyMzQ5Ong4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtMDUzOTAtZ2Y0ZjQ4YTI6Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2Y0ZjQ4YTI2OTJmOWRlMGQxZWJiZWVlN2JhMTky
YTk5ZTg2ZDE3NzMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xOToyMDE0MDMwOTIwMjQxMDp4
ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LTA1MzkwLWdmNGY0OGEy
OjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9mNGY0OGEyNjkyZjlk
ZTBkMWViYmVlZTdiYTE5MmE5OWU4NmQxNzczL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjA6
MjAxNDAzMDkyMDI0MDc6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJj
NS0wNTM5MC1nZjRmNDhhMjoyCjM6MzoxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgps
aW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICd0aXAvYXV0by1sYXRlc3QnCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBi
aXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCBmNGY0OGEyNjkyZjlkZTBk
MWViYmVlZTdiYTE5MmE5OWU4NmQxNzczIDhiNDJhYjVkNmM1MTQwY2FkMzQ5NTdhMzJmYTZi
ZGY0M2U3ZTAzMDMgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjRmNDhhMi4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd0aXAvYXV0by1sYXRlc3QnCkhFQUQgaXMg
bm93IGF0IDZlNDY2NDUuLi4gTGludXggMy4xMQpCaXNlY3Rpbmc6IDE0MyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2MxNDllYzEwNzE4
OWVlYWE4MThkZmY3ZDk3ZTZmZTc0YjBkNjFiYzJdIE1lcmdlIGJyYW5jaCAncGVyZi9jb3Jl
JwpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9uZXh0Om1hc3RlcjpjMTQ5ZWMxMDcxODllZWFh
ODE4ZGZmN2Q5N2U2ZmU3NGIwZDYxYmMyOmJpc2VjdC11c2IKCjIwMTQtMDMtMDktMjA6MjQ6
NDQgYzE0OWVjMTA3MTg5ZWVhYTgxOGRmZjdkOTdlNmZlNzRiMGQ2MWJjMiBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1jMTQ5ZWMxMDcxODllZWFhODE4ZGZmN2Q5N2U2ZmU3
NGIwZDYxYmMyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC9jMTQ5ZWMxMDcxODllZWFhODE4ZGZmN2Q5N2U2ZmU3NGIwZDYxYmMy
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1jMTQ5ZWMxMDcxODllZWFhODE4ZGZmN2Q5
N2U2ZmU3NGIwZDYxYmMyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtYzE0OWVjMTA3
MTg5ZWVhYTgxOGRmZjdkOTdlNmZlNzRiMGQ2MWJjMgprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjUtMDMwOTEzMjgvYzE0OWVjMTA3MTg5ZWVhYTgxOGRmZjdkOTdlNmZl
NzRiMGQ2MWJjMi92bWxpbnV6LTMuMTQuMC1yYzUtMDAxODgtZ2MxNDllYzEKCjIwMTQtMDMt
MDktMjA6Mzc6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEJMgkzCTQJNgk5CTE0CTIy
CTIzLi4uLi4uCTI0Li4uLgkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDY2IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZDI3Yzg0MzhlZWVk
YjZlMTM2N2I1OTJjMTAxZTNjODdjY2EwYjUwZl0gTWVyZ2UgYnJhbmNoICd0aW1lcnMvY29y
ZScgaW50byBzY2hlZC9pZGxlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25l
eHQ6bWFzdGVyOmQyN2M4NDM4ZWVlZGI2ZTEzNjdiNTkyYzEwMWUzYzg3Y2NhMGI1MGY6Ymlz
ZWN0LXVzYgoKMjAxNC0wMy0wOS0yMDo0OTo0NSBkMjdjODQzOGVlZWRiNmUxMzY3YjU5MmMx
MDFlM2M4N2NjYTBiNTBmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWQyN2M4
NDM4ZWVlZGI2ZTEzNjdiNTkyYzEwMWUzYzg3Y2NhMGI1MGYKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2QyN2M4NDM4ZWVlZGI2
ZTEzNjdiNTkyYzEwMWUzYzg3Y2NhMGI1MGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
LWQyN2M4NDM4ZWVlZGI2ZTEzNjdiNTkyYzEwMWUzYzg3Y2NhMGI1MGYKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1yNS0wMzA5MTMyOC1kMjdjODQzOGVlZWRiNmUxMzY3YjU5MmMxMDFlM2M4N2NjYTBi
NTBmCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9kMjdj
ODQzOGVlZWRiNmUxMzY3YjU5MmMxMDFlM2M4N2NjYTBiNTBmL3ZtbGludXotMy4xNC4wLXJj
My0wMDI5Ni1nZDI3Yzg0MwoKMjAxNC0wMy0wOS0yMTowODo0NiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTMJNgk3CTgJOS4uCTEwCTE3CTE5LgkyMS4JMjIuCTI1IFNVQ0NFU1MKCkJpc2Vj
dGluZzogMzAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUg
c3RlcHMpClthYmIyNzQyODg2MWE4ZTNmYjkwYzA2M2UyZjJjM2NkZjhlMjBiMWI3XSBNZXJn
ZSBicmFuY2ggJ3g4Ni9hc21saW5rYWdlJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyOC9uZXh0Om1hc3RlcjphYmIyNzQyODg2MWE4ZTNmYjkwYzA2M2UyZjJjM2NkZjhlMjBi
MWI3OmJpc2VjdC11c2IKCjIwMTQtMDMtMDktMjE6MTc6MTcgYWJiMjc0Mjg4NjFhOGUzZmI5
MGMwNjNlMmYyYzNjZGY4ZTIwYjFiNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMy
OC1hYmIyNzQyODg2MWE4ZTNmYjkwYzA2M2UyZjJjM2NkZjhlMjBiMWI3CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9hYmIyNzQy
ODg2MWE4ZTNmYjkwYzA2M2UyZjJjM2NkZjhlMjBiMWI3CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyOC1hYmIyNzQyODg2MWE4ZTNmYjkwYzA2M2UyZjJjM2NkZjhlMjBiMWI3CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0
LXJhbmRjb25maWctcjUtMDMwOTEzMjgtYWJiMjc0Mjg4NjFhOGUzZmI5MGMwNjNlMmYyYzNj
ZGY4ZTIwYjFiNwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEz
MjgvYWJiMjc0Mjg4NjFhOGUzZmI5MGMwNjNlMmYyYzNjZGY4ZTIwYjFiNy92bWxpbnV6LTMu
MTQuMC1yYzUtMDAzMDUtZ2FiYjI3NDIKCjIwMTQtMDMtMDktMjE6Mjc6MTggZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMi4JNwkxMAkyMQkyNAkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpb
MWExOTg1ZDQ1NTVlZGIzMGI4ZDgwNzA0NmM3YzZmM2NhOTIyMTIxN10gTWVyZ2UgYnJhbmNo
ICd4ODYvbW0nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVy
OjFhMTk4NWQ0NTU1ZWRiMzBiOGQ4MDcwNDZjN2M2ZjNjYTkyMjEyMTc6YmlzZWN0LXVzYgoK
MjAxNC0wMy0wOS0yMTozMTo0OSAxYTE5ODVkNDU1NWVkYjMwYjhkODA3MDQ2YzdjNmYzY2E5
MjIxMjE3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTFhMTk4NWQ0NTU1ZWRi
MzBiOGQ4MDcwNDZjN2M2ZjNjYTkyMjEyMTcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFhMTk4NWQ0NTU1ZWRiMzBiOGQ4MDcw
NDZjN2M2ZjNjYTkyMjEyMTcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTFhMTk4NWQ0
NTU1ZWRiMzBiOGQ4MDcwNDZjN2M2ZjNjYTkyMjEyMTcKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyOC0xYTE5ODVkNDU1NWVkYjMwYjhkODA3MDQ2YzdjNmYzY2E5MjIxMjE3Cmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC8xYTE5ODVkNDU1NWVk
YjMwYjhkODA3MDQ2YzdjNmYzY2E5MjIxMjE3L3ZtbGludXotMy4xNC4wLXJjNS0wMDMyMS1n
MWExOTg1ZAoKMjAxNC0wMy0wOS0yMTozOTo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
IFRFU1QgRkFJTFVSRQpbICAgIDAuOTcwODI5XSBLcHJvYmUgc21va2UgdGVzdCBzdGFydGVk
ClsgICAgMC45OTUwNjddIApbICAgIDAuOTk1NDc5XSA9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgICAwLjk5NjAxMl0gWyBJTkZP
OiBwb3NzaWJsZSBjaXJjdWxhciBsb2NraW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQgXQpbICAg
IDAuOTk2MDEyXSAzLjE0LjAtcmM1LTAwMzIxLWcxYTE5ODVkICMxIE5vdCB0YWludGVkClsg
ICAgMC45OTYwMTJdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KWyAgICAwLjk5NjAxMl0ga3dvcmtlci8wOjEvMjQgaXMgdHJ5aW5n
IHRvIGFjcXVpcmUgbG9jazoKWyAgICAwLjk5NjAxMl0gICh0ZXh0X211dGV4KXsrLisuKy59
LCBhdDogWzxmZmZmZmZmZjg2OWI1MDY2Pl0ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIz
YwpbICAgIDAuOTk2MDEyXSAKWyAgICAwLjk5NjAxMl0gYnV0IHRhc2sgaXMgYWxyZWFkeSBo
b2xkaW5nIGxvY2s6ClsgICAgMC45OTYwMTJdICAobW9kdWxlX211dGV4KXsrLisuLi59LCBh
dDogWzxmZmZmZmZmZjg2OWI0ZjZhPl0ga3Byb2JlX29wdGltaXplcisweDI1LzB4MjNjClsg
ICAgMC45OTYwMTJdIApbICAgIDAuOTk2MDEyXSB3aGljaCBsb2NrIGFscmVhZHkgZGVwZW5k
cyBvbiB0aGUgbmV3IGxvY2suClsgICAgMC45OTYwMTJdIApbICAgIDAuOTk2MDEyXSAKWyAg
ICAwLjk5NjAxMl0gdGhlIGV4aXN0aW5nIGRlcGVuZGVuY3kgY2hhaW4gKGluIHJldmVyc2Ug
b3JkZXIpIGlzOgpbICAgIDAuOTk2MDEyXSAKLT4gIzIgKG1vZHVsZV9tdXRleCl7Ky4rLi4u
fToKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4NjRiNDc1MT5dIF9fbG9ja19h
Y3F1aXJlKzB4OTA3LzB4OWZiClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0
YjRkMjg+XSBsb2NrX2FjcXVpcmUrMHhhNC8weGM0ClsgICAgMC45OTYwMTJdICAgICAgICBb
PGZmZmZmZmZmODY5YWNlMzY+XSBtdXRleF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsgICAg
MC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0MzA5NTQ+XSBtb2R1bGVfYWxsb2MrMHg0
Mi8weGI1ClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0ZGMzYjM+XSBhbGxv
Y19pbnNuX3BhZ2UrMHhlLzB4MTAKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4
NjliNTI2MT5dIF9fZ2V0X2luc25fc2xvdCsweGUwLzB4MTY1ClsgICAgMC45OTYwMTJdICAg
ICAgICBbPGZmZmZmZmZmODY5YjI1YjI+XSBhcmNoX3ByZXBhcmVfa3Byb2JlKzB4MzYvMHhi
NwpbICAgIDAuOTk2MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2OWI1ZjMyPl0gcmVnaXN0ZXJf
a3Byb2JlKzB4MzMwLzB4NDkwClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0
ZDdhZmM+XSBpbml0X3Rlc3RfcHJvYmVzKzB4NGUvMHg0ODkKWyAgICAwLjk5NjAxMl0gICAg
ICAgIFs8ZmZmZmZmZmY4NmY2YWVjNz5dIGluaXRfa3Byb2JlcysweDE3Yi8weDE4OQpbICAg
IDAuOTk2MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2NDAyMGZiPl0gZG9fb25lX2luaXRjYWxs
KzB4OWYvMHgxMzUKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4NmY0ZmY2Mz5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTAzLzB4MTk0ClsgICAgMC45OTYwMTJdICAgICAg
ICBbPGZmZmZmZmZmODY5YTBkZDk+XSBrZXJuZWxfaW5pdCsweDkvMHhkNQpbICAgIDAuOTk2
MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2OWI2N2NjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4
YjAKWyAgICAwLjk5NjAxMl0gCi0+ICMxIChrcHJvYmVfaW5zbl9zbG90cy5tdXRleCl7Ky4r
LisufToKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4NjRiNDc1MT5dIF9fbG9j
a19hY3F1aXJlKzB4OTA3LzB4OWZiClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZm
ODY0YjRkMjg+XSBsb2NrX2FjcXVpcmUrMHhhNC8weGM0ClsgICAgMC45OTYwMTJdICAgICAg
ICBbPGZmZmZmZmZmODY5YWNlMzY+XSBtdXRleF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsg
ICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY5YjUxOWQ+XSBfX2dldF9pbnNuX3Ns
b3QrMHgxYy8weDE2NQpbICAgIDAuOTk2MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2OWIyNWIy
Pl0gYXJjaF9wcmVwYXJlX2twcm9iZSsweDM2LzB4YjcKWyAgICAwLjk5NjAxMl0gICAgICAg
IFs8ZmZmZmZmZmY4NjliNWYzMj5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAg
IDAuOTk2MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2NGQ3YWZjPl0gaW5pdF90ZXN0X3Byb2Jl
cysweDRlLzB4NDg5ClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODZmNmFlYzc+
XSBpbml0X2twcm9iZXMrMHgxN2IvMHgxODkKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZm
ZmZmZmY4NjQwMjBmYj5dIGRvX29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMC45OTYw
MTJdICAgICAgICBbPGZmZmZmZmZmODZmNGZmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eDEwMy8weDE5NApbICAgIDAuOTk2MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2OWEwZGQ5Pl0g
a2VybmVsX2luaXQrMHg5LzB4ZDUKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4
NjliNjdjYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC45OTYwMTJdIAotPiAj
MCAodGV4dF9tdXRleCl7Ky4rLisufToKWyAgICAwLjk5NjAxMl0gICAgICAgIFs8ZmZmZmZm
ZmY4NjRiMWIwNj5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMjArMHg4Y2YvMHhmMmUKWyAgICAw
Ljk5NjAxMl0gICAgICAgIFs8ZmZmZmZmZmY4NjRiNDc1MT5dIF9fbG9ja19hY3F1aXJlKzB4
OTA3LzB4OWZiClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0YjRkMjg+XSBs
b2NrX2FjcXVpcmUrMHhhNC8weGM0ClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZm
ODY5YWNlMzY+XSBtdXRleF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsgICAgMC45OTYwMTJd
ICAgICAgICBbPGZmZmZmZmZmODY5YjUwNjY+XSBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4
MjNjClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZmODY0OGVhYmY+XSBwcm9jZXNz
X29uZV93b3JrKzB4MjM3LzB4M2RiClsgICAgMC45OTYwMTJdICAgICAgICBbPGZmZmZmZmZm
ODY0OGY4Yjk+XSB3b3JrZXJfdGhyZWFkKzB4MWNiLzB4MmM0ClsgICAgMC45OTYwMTJdICAg
ICAgICBbPGZmZmZmZmZmODY0OTU0ODM+XSBrdGhyZWFkKzB4ZjEvMHhmOQpbICAgIDAuOTk2
MDEyXSAgICAgICAgWzxmZmZmZmZmZjg2OWI2N2NjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4
YjAKWyAgICAwLjk5NjAxMl0gClsgICAgMC45OTYwMTJdIG90aGVyIGluZm8gdGhhdCBtaWdo
dCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAgMC45OTYwMTJdIApbICAgIDAuOTk2MDEyXSBD
aGFpbiBleGlzdHMgb2Y6CiAgdGV4dF9tdXRleCAtLT4ga3Byb2JlX2luc25fc2xvdHMubXV0
ZXggLS0+IG1vZHVsZV9tdXRleAoKWyAgICAwLjk5NjAxMl0gIFBvc3NpYmxlIHVuc2FmZSBs
b2NraW5nIHNjZW5hcmlvOgpbICAgIDAuOTk2MDEyXSAKWyAgICAwLjk5NjAxMl0gICAgICAg
IENQVTAgICAgICAgICAgICAgICAgICAgIENQVTEKWyAgICAwLjk5NjAxMl0gICAgICAgIC0t
LS0gICAgICAgICAgICAgICAgICAgIC0tLS0KWyAgICAwLjk5NjAxMl0gICBsb2NrKG1vZHVs
ZV9tdXRleCk7ClsgICAgMC45OTYwMTJdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBsb2NrKGtwcm9iZV9pbnNuX3Nsb3RzLm11dGV4KTsKWyAgICAwLjk5NjAxMl0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAwLjk5
NjAxMl0gICBsb2NrKHRleHRfbXV0ZXgpOwpbICAgIDAuOTk2MDEyXSAKWyAgICAwLjk5NjAx
Ml0gICoqKiBERUFETE9DSyAqKioKWyAgICAwLjk5NjAxMl0gClsgICAgMC45OTYwMTJdIDQg
bG9ja3MgaGVsZCBieSBrd29ya2VyLzA6MS8yNDoKWyAgICAwLjk5NjAxMl0gICMwOiAgKCJl
dmVudHMiKXsuKy4rLi59LCBhdDogWzxmZmZmZmZmZjg2NDhlYTU5Pl0gcHJvY2Vzc19vbmVf
d29yaysweDFkMS8weDNkYgpbICAgIDAuOTk2MDEyXSAgIzE6ICAoKG9wdGltaXppbmdfd29y
aykud29yayl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4NjQ4ZWE1OT5dIHByb2Nlc3Nfb25l
X3dvcmsrMHgxZDEvMHgzZGIKWyAgICAwLjk5NjAxMl0gICMyOiAgKGtwcm9iZV9tdXRleCl7
Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4NjliNGY1Yz5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgx
Ny8weDIzYwpbICAgIDAuOTk2MDEyXSAgIzM6ICAobW9kdWxlX211dGV4KXsrLisuLi59LCBh
dDogWzxmZmZmZmZmZjg2OWI0ZjZhPl0ga3Byb2JlX29wdGltaXplcisweDI1LzB4MjNjClsg
ICAgMC45OTYwMTJdIApbICAgIDAuOTk2MDEyXSBzdGFjayBiYWNrdHJhY2U6ClsgICAgMC45
OTYwMTJdIENQVTogMCBQSUQ6IDI0IENvbW06IGt3b3JrZXIvMDoxIE5vdCB0YWludGVkIDMu
MTQuMC1yYzUtMDAzMjEtZzFhMTk4NWQgIzEKWyAgICAwLjk5NjAxMl0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuOTk2MDEyXSBX
b3JrcXVldWU6IGV2ZW50cyBrcHJvYmVfb3B0aW1pemVyClsgICAgMC45OTYwMTJdICAwMDAw
MDAwMDAwMDAwMDAwIGZmZmY4ODAwMTIzYTViNjAgZmZmZmZmZmY4NjlhOGMxMyBmZmZmZmZm
Zjg3NDYzMGQwClsgICAgMC45OTYwMTJdICBmZmZmODgwMDEyM2E1YmEwIGZmZmZmZmZmODY5
YTU5ZDYgZmZmZjg4MDAxMjNhMDYxMCBmZmZmODgwMDEyM2ExMmIwClsgICAgMC45OTYwMTJd
ICBmZmZmODgwMDEyM2EwNjEwIGZmZmY4ODAwMTIzYTEyYjAgMDAwMDAwMDAwMDAwMDAwNCBm
ZmZmODgwMDEyM2ExMjg4ClsgICAgMC45OTYwMTJdIENhbGwgVHJhY2U6ClsgICAgMC45OTYw
MTJdICBbPGZmZmZmZmZmODY5YThjMTM+XSBkdW1wX3N0YWNrKzB4NGQvMHg2NgpbICAgIDAu
OTk2MDEyXSAgWzxmZmZmZmZmZjg2OWE1OWQ2Pl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4MmI0
LzB4MmMyClsgICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY0YjFiMDY+XSB2YWxpZGF0ZV9j
aGFpbi5pc3JhLjIwKzB4OGNmLzB4ZjJlClsgICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY0
YjQ3NTE+XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDAuOTk2MDEyXSAgWzxm
ZmZmZmZmZjg2NGI0ZDI4Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDAuOTk2MDEy
XSAgWzxmZmZmZmZmZjg2OWI1MDY2Pl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNj
ClsgICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY5YWNlMzY+XSBtdXRleF9sb2NrX25lc3Rl
ZCsweDY1LzB4MzRhClsgICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY5YjUwNjY+XSA/IGtw
cm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAwLjk5NjAxMl0gIFs8ZmZmZmZmZmY4
NjRiMmE4Mj5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhkLzB4ZgpbICAgIDAuOTk2MDEyXSAg
WzxmZmZmZmZmZjg2OWI1MDY2Pl0ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAg
IDAuOTk2MDEyXSAgWzxmZmZmZmZmZjg2NDhlYWJmPl0gcHJvY2Vzc19vbmVfd29yaysweDIz
Ny8weDNkYgpbICAgIDAuOTk2MDEyXSAgWzxmZmZmZmZmZjg2NDhlYTU5Pl0gPyBwcm9jZXNz
X29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY0OGY4
Yjk+XSB3b3JrZXJfdGhyZWFkKzB4MWNiLzB4MmM0ClsgICAgMC45OTYwMTJdICBbPGZmZmZm
ZmZmODY0OGY2ZWU+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4MjliLzB4MjliClsgICAgMC45OTYw
MTJdICBbPGZmZmZmZmZmODY0OTU0ODM+XSBrdGhyZWFkKzB4ZjEvMHhmOQpbICAgIDAuOTk2
MDEyXSAgWzxmZmZmZmZmZjg2NDk1MzkyPl0gPyBrdGhyZWFkX3N0b3ArMHg1YS8weDVhClsg
ICAgMC45OTYwMTJdICBbPGZmZmZmZmZmODY5YjY3Y2M+XSByZXRfZnJvbV9mb3JrKzB4N2Mv
MHhiMApbICAgIDAuOTk2MDEyXSAgWzxmZmZmZmZmZjg2NDk1MzkyPl0gPyBrdGhyZWFkX3N0
b3ArMHg1YS8weDVhClsgICAgMS4wOTYwMzFdIEtwcm9iZSBzbW9rZSB0ZXN0IHBhc3NlZCBz
dWNjZXNzZnVsbHkKWyAgICAxLjA5NzIyOF0gYm91bmNlIHBvb2wgc2l6ZTogNjQgcGFnZXMK
WyAgICAxLjA5Nzg5MV0gSHVnZVRMQiByZWdpc3RlcmVkIDIgTUIgcGFnZSBzaXplLCBwcmUt
YWxsb2NhdGVkIDAgcGFnZXMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMy
OC8xYTE5ODVkNDU1NWVkYjMwYjhkODA3MDQ2YzdjNmYzY2E5MjIxMjE3L2RtZXNnLXF1YW50
YWwtaXZ5dG93bjItNjoyMDE0MDMwOTIxNDEyOTp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyODozLjE0LjAtcmM1LTAwMzIxLWcxYTE5ODVkOjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzk1N2QzMWVmMjY0ZDBjODAxMmRjYjRhNDc1NDM5
ODdiYmRmMmMxODRdIE1lcmdlIGJyYW5jaCAneDg2L2NwdScKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjgvbmV4dDptYXN0ZXI6OTU3ZDMxZWYyNjRkMGM4MDEyZGNiNGE0NzU0
Mzk4N2JiZGYyYzE4NDpiaXNlY3QtdXNiCgoyMDE0LTAzLTA5LTIxOjQxOjUzIDk1N2QzMWVm
MjY0ZDBjODAxMmRjYjRhNDc1NDM5ODdiYmRmMmMxODQgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjUtMDMwOTEzMjgtOTU3ZDMxZWYyNjRkMGM4MDEyZGNiNGE0NzU0Mzk4N2JiZGYyYzE4NApD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEz
MjgvOTU3ZDMxZWYyNjRkMGM4MDEyZGNiNGE0NzU0Mzk4N2JiZGYyYzE4NAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctcjUtMDMwOTEzMjgtOTU3ZDMxZWYyNjRkMGM4MDEyZGNiNGE0NzU0Mzk4N2JiZGYy
YzE4NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTk1N2QzMWVmMjY0ZDBjODAxMmRj
YjRhNDc1NDM5ODdiYmRmMmMxODQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4Lzk1N2QzMWVmMjY0ZDBjODAxMmRjYjRhNDc1NDM5ODdiYmRmMmMxODQv
dm1saW51ei0zLjE0LjAtcmM1LTAwMzE0LWc5NTdkMzFlCgoyMDE0LTAzLTA5LTIxOjQ2OjUz
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTcJMjAuCTI0CTI1IFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKW2VhNGI1YzgwZGE3OWRlYmIyZDI5ZThjMjdhMTlhNzU3OWQyODY3YzNdIE1lcmdlIGJy
YW5jaCAneDg2L2NwdWZlYXR1cmUnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
L25leHQ6bWFzdGVyOmVhNGI1YzgwZGE3OWRlYmIyZDI5ZThjMjdhMTlhNzU3OWQyODY3YzM6
YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0yMTo1MDoyNCBlYTRiNWM4MGRhNzlkZWJiMmQyOWU4
YzI3YTE5YTc1NzlkMjg2N2MzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWVh
NGI1YzgwZGE3OWRlYmIyZDI5ZThjMjdhMTlhNzU3OWQyODY3YzMKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2VhNGI1YzgwZGE3
OWRlYmIyZDI5ZThjMjdhMTlhNzU3OWQyODY3YzMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkx
MzI4LWVhNGI1YzgwZGE3OWRlYmIyZDI5ZThjMjdhMTlhNzU3OWQyODY3YzMKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFu
ZGNvbmZpZy1yNS0wMzA5MTMyOC1lYTRiNWM4MGRhNzlkZWJiMmQyOWU4YzI3YTE5YTc1Nzlk
Mjg2N2MzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9l
YTRiNWM4MGRhNzlkZWJiMmQyOWU4YzI3YTE5YTc1NzlkMjg2N2MzL3ZtbGludXotMy4xNC4w
LXJjNS0wMDMxNy1nZWE0YjVjOAoKMjAxNC0wMy0wOS0yMjowMjoyNCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLgkyCTMuCTcJMTMJMTgJMjAJMjIuLgkyMy4JMjUgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3Rl
cCkKW2Q2ZTQ1MTUxNWE2MTY3YjYzZTc5NjEyYzdjMTA3ZDA5MTZkN2YyYjJdIE1lcmdlIGJy
YW5jaCAneDg2L2thc2xyJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9uZXh0
Om1hc3RlcjpkNmU0NTE1MTVhNjE2N2I2M2U3OTYxMmM3YzEwN2QwOTE2ZDdmMmIyOmJpc2Vj
dC11c2IKCjIwMTQtMDMtMDktMjI6MDk6NTYgZDZlNDUxNTE1YTYxNjdiNjNlNzk2MTJjN2Mx
MDdkMDkxNmQ3ZjJiMiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1kNmU0NTE1
MTVhNjE2N2I2M2U3OTYxMmM3YzEwN2QwOTE2ZDdmMmIyCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC9kNmU0NTE1MTVhNjE2N2I2
M2U3OTYxMmM3YzEwN2QwOTE2ZDdmMmIyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1k
NmU0NTE1MTVhNjE2N2I2M2U3OTYxMmM3YzEwN2QwOTE2ZDdmMmIyCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjgtZDZlNDUxNTE1YTYxNjdiNjNlNzk2MTJjN2MxMDdkMDkxNmQ3ZjJi
MgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvZDZlNDUx
NTE1YTYxNjdiNjNlNzk2MTJjN2MxMDdkMDkxNmQ3ZjJiMi92bWxpbnV6LTMuMTQuMC1yYzUt
MDAzMTktZ2Q2ZTQ1MTUKCjIwMTQtMDMtMDktMjI6MTY6NTYgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4JMSBURVNUIEZBSUxVUkUKWyAgICAxLjAwODA1OF0gS3Byb2JlIHNtb2tlIHRlc3Qg
c3RhcnRlZApbICAgIDEuMDMyOTc5XSAKWyAgICAxLjAzMzYwM10gPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgMS4wMzM5MTBd
IFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVk
IF0KWyAgICAxLjAzNTc3OF0gMy4xNC4wLXJjNS0wMDMxOS1nZDZlNDUxNSAjMSBOb3QgdGFp
bnRlZApbICAgIDEuMDM1Nzc4XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMS4wMzU3NzhdIGt3b3JrZXIvMToxLzI1IGlz
IHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMS4wMzU3NzhdICAodGV4dF9tdXRleCl7
Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4YWRiNTA2Nj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgx
MjEvMHgyM2MKWyAgICAxLjAzNTc3OF0gClsgICAgMS4wMzU3NzhdIGJ1dCB0YXNrIGlzIGFs
cmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDEuMDM1Nzc4XSAgKG1vZHVsZV9tdXRleCl7Ky4r
Li4ufSwgYXQ6IFs8ZmZmZmZmZmY4YWRiNGY2YT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgyNS8w
eDIzYwpbICAgIDEuMDM1Nzc4XSAKWyAgICAxLjAzNTc3OF0gd2hpY2ggbG9jayBhbHJlYWR5
IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgIDEuMDM1Nzc4XSAKWyAgICAxLjAzNTc3
OF0gClsgICAgMS4wMzU3NzhdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiBy
ZXZlcnNlIG9yZGVyKSBpczoKWyAgICAxLjAzNTc3OF0gCi0+ICMyIChtb2R1bGVfbXV0ZXgp
eysuKy4uLn06ClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZmZmZmZmZmOGE4YjQ3NTE+XSBf
X2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZm
ZmZmZjhhOGI0ZDI4Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMDM1Nzc4XSAg
ICAgICAgWzxmZmZmZmZmZjhhZGFjZTM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0
YQpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhODMwOTU0Pl0gbW9kdWxlX2Fs
bG9jKzB4NDIvMHhiNQpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhOGRjM2Iz
Pl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZm
ZmZmZmZmOGFkYjUyNjE+XSBfX2dldF9pbnNuX3Nsb3QrMHhlMC8weDE2NQpbICAgIDEuMDM1
Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhZGIyNWIyPl0gYXJjaF9wcmVwYXJlX2twcm9iZSsw
eDM2LzB4YjcKWyAgICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YWRiNWYzMj5dIHJl
Z2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZm
ZmZmZjhhOGQ3YWZjPl0gaW5pdF90ZXN0X3Byb2JlcysweDRlLzB4NDg5ClsgICAgMS4wMzU3
NzhdICAgICAgICBbPGZmZmZmZmZmOGIzNmFlYzc+XSBpbml0X2twcm9iZXMrMHgxN2IvMHgx
ODkKWyAgICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YTgwMjBmYj5dIGRvX29uZV9p
bml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZmZmZmZmZmOGIz
NGZmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMy8weDE5NApbICAgIDEuMDM1Nzc4
XSAgICAgICAgWzxmZmZmZmZmZjhhZGEwZGQ5Pl0ga2VybmVsX2luaXQrMHg5LzB4ZDUKWyAg
ICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YWRiNjdjYz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS4wMzU3NzhdIAotPiAjMSAoa3Byb2JlX2luc25fc2xvdHMubXV0
ZXgpeysuKy4rLn06ClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZmZmZmZmZmOGE4YjQ3NTE+
XSBfX2xvY2tfYWNxdWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxm
ZmZmZmZmZjhhOGI0ZDI4Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMDM1Nzc4
XSAgICAgICAgWzxmZmZmZmZmZjhhZGFjZTM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8w
eDM0YQpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhZGI1MTlkPl0gX19nZXRf
aW5zbl9zbG90KzB4MWMvMHgxNjUKWyAgICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4
YWRiMjViMj5dIGFyY2hfcHJlcGFyZV9rcHJvYmUrMHgzNi8weGI3ClsgICAgMS4wMzU3Nzhd
ICAgICAgICBbPGZmZmZmZmZmOGFkYjVmMzI+XSByZWdpc3Rlcl9rcHJvYmUrMHgzMzAvMHg0
OTAKWyAgICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YThkN2FmYz5dIGluaXRfdGVz
dF9wcm9iZXMrMHg0ZS8weDQ4OQpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhi
MzZhZWM3Pl0gaW5pdF9rcHJvYmVzKzB4MTdiLzB4MTg5ClsgICAgMS4wMzU3NzhdICAgICAg
ICBbPGZmZmZmZmZmOGE4MDIwZmI+XSBkb19vbmVfaW5pdGNhbGwrMHg5Zi8weDEzNQpbICAg
IDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhiMzRmZjYzPl0ga2VybmVsX2luaXRfZnJl
ZWFibGUrMHgxMDMvMHgxOTQKWyAgICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YWRh
MGRkOT5dIGtlcm5lbF9pbml0KzB4OS8weGQ1ClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZm
ZmZmZmZmOGFkYjY3Y2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuMDM1Nzc4
XSAKLT4gIzAgKHRleHRfbXV0ZXgpeysuKy4rLn06ClsgICAgMS4wMzU3NzhdICAgICAgICBb
PGZmZmZmZmZmOGE4YjFiMDY+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjIwKzB4OGNmLzB4ZjJl
ClsgICAgMS4wMzU3NzhdICAgICAgICBbPGZmZmZmZmZmOGE4YjQ3NTE+XSBfX2xvY2tfYWNx
dWlyZSsweDkwNy8weDlmYgpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhOGI0
ZDI4Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxm
ZmZmZmZmZjhhZGFjZTM2Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEu
MDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhZGI1MDY2Pl0ga3Byb2JlX29wdGltaXplcisw
eDEyMS8weDIzYwpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhODhlYWJmPl0g
cHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAgIDEuMDM1Nzc4XSAgICAgICAgWzxm
ZmZmZmZmZjhhODhmOGI5Pl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuMDM1
Nzc4XSAgICAgICAgWzxmZmZmZmZmZjhhODk1NDgzPl0ga3RocmVhZCsweGYxLzB4ZjkKWyAg
ICAxLjAzNTc3OF0gICAgICAgIFs8ZmZmZmZmZmY4YWRiNjdjYz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS4wMzU3NzhdIApbICAgIDEuMDM1Nzc4XSBvdGhlciBpbmZvIHRo
YXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgIDEuMDM1Nzc4XSAKWyAgICAxLjAz
NTc3OF0gQ2hhaW4gZXhpc3RzIG9mOgogIHRleHRfbXV0ZXggLS0+IGtwcm9iZV9pbnNuX3Ns
b3RzLm11dGV4IC0tPiBtb2R1bGVfbXV0ZXgKClsgICAgMS4wMzU3NzhdICBQb3NzaWJsZSB1
bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICAxLjAzNTc3OF0gClsgICAgMS4wMzU3Nzhd
ICAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUxClsgICAgMS4wMzU3NzhdICAg
ICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tClsgICAgMS4wMzU3NzhdICAgbG9j
ayhtb2R1bGVfbXV0ZXgpOwpbICAgIDEuMDM1Nzc4XSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgbG9jayhrcHJvYmVfaW5zbl9zbG90cy5tdXRleCk7ClsgICAgMS4wMzU3Nzhd
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKG1vZHVsZV9tdXRleCk7Clsg
ICAgMS4wMzU3NzhdICAgbG9jayh0ZXh0X211dGV4KTsKWyAgICAxLjAzNTc3OF0gClsgICAg
MS4wMzU3NzhdICAqKiogREVBRExPQ0sgKioqClsgICAgMS4wMzU3NzhdIApbICAgIDEuMDM1
Nzc4XSA0IGxvY2tzIGhlbGQgYnkga3dvcmtlci8xOjEvMjU6ClsgICAgMS4wMzU3NzhdICAj
MDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZmZmZmZmY4YTg4ZWE1OT5dIHByb2Nl
c3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAxLjAzNTc3OF0gICMxOiAgKChvcHRpbWl6
aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmOGE4OGVhNTk+XSBwcm9j
ZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS4wMzU3NzhdICAjMjogIChrcHJvYmVf
bXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGFkYjRmNWM+XSBrcHJvYmVfb3B0aW1p
emVyKzB4MTcvMHgyM2MKWyAgICAxLjAzNTc3OF0gICMzOiAgKG1vZHVsZV9tdXRleCl7Ky4r
Li4ufSwgYXQ6IFs8ZmZmZmZmZmY4YWRiNGY2YT5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgyNS8w
eDIzYwpbICAgIDEuMDM1Nzc4XSAKWyAgICAxLjAzNTc3OF0gc3RhY2sgYmFja3RyYWNlOgpb
ICAgIDEuMDM1Nzc4XSBDUFU6IDEgUElEOiAyNSBDb21tOiBrd29ya2VyLzE6MSBOb3QgdGFp
bnRlZCAzLjE0LjAtcmM1LTAwMzE5LWdkNmU0NTE1ICMxClsgICAgMS4wMzU3NzhdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjAz
NTc3OF0gV29ya3F1ZXVlOiBldmVudHMga3Byb2JlX29wdGltaXplcgpbICAgIDEuMDM1Nzc4
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBjNTJmYjYwIGZmZmZmZmZmOGFkYThjMTMg
ZmZmZmZmZmY4Yjg2MzBkMApbICAgIDEuMDM1Nzc4XSAgZmZmZjg4MDAwYzUyZmJhMCBmZmZm
ZmZmZjhhZGE1OWQ2IGZmZmY4ODAwMGM1MzA2NTAgZmZmZjg4MDAwYzUzMTJmMApbICAgIDEu
MDM1Nzc4XSAgZmZmZjg4MDAwYzUzMDY1MCBmZmZmODgwMDBjNTMxMmYwIDAwMDAwMDAwMDAw
MDAwMDQgZmZmZjg4MDAwYzUzMTJjOApbICAgIDEuMDM1Nzc4XSBDYWxsIFRyYWNlOgpbICAg
IDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhZGE4YzEzPl0gZHVtcF9zdGFjaysweDRkLzB4NjYK
WyAgICAxLjAzNTc3OF0gIFs8ZmZmZmZmZmY4YWRhNTlkNj5dIHByaW50X2NpcmN1bGFyX2J1
ZysweDJiNC8weDJjMgpbICAgIDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhOGIxYjA2Pl0gdmFs
aWRhdGVfY2hhaW4uaXNyYS4yMCsweDhjZi8weGYyZQpbICAgIDEuMDM1Nzc4XSAgWzxmZmZm
ZmZmZjhhOGI0NzUxPl0gX19sb2NrX2FjcXVpcmUrMHg5MDcvMHg5ZmIKWyAgICAxLjAzNTc3
OF0gIFs8ZmZmZmZmZmY4YThiNGQyOD5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAgICAx
LjAzNTc3OF0gIFs8ZmZmZmZmZmY4YWRiNTA2Nj5dID8ga3Byb2JlX29wdGltaXplcisweDEy
MS8weDIzYwpbICAgIDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhZGFjZTM2Pl0gbXV0ZXhfbG9j
a19uZXN0ZWQrMHg2NS8weDM0YQpbICAgIDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhZGI1MDY2
Pl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS4wMzU3NzhdICBbPGZm
ZmZmZmZmOGE4YjJhODI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4ZC8weGYKWyAgICAxLjAz
NTc3OF0gIFs8ZmZmZmZmZmY4YWRiNTA2Nj5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgy
M2MKWyAgICAxLjAzNTc3OF0gIFs8ZmZmZmZmZmY4YTg4ZWFiZj5dIHByb2Nlc3Nfb25lX3dv
cmsrMHgyMzcvMHgzZGIKWyAgICAxLjAzNTc3OF0gIFs8ZmZmZmZmZmY4YTg4ZWE1OT5dID8g
cHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDEuMDM1Nzc4XSAgWzxmZmZmZmZm
ZjhhODhmOGI5Pl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuMDM1Nzc4XSAg
WzxmZmZmZmZmZjhhODhmNmVlPl0gPyByZXNjdWVyX3RocmVhZCsweDI5Yi8weDI5YgpbICAg
IDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhODk1NDgzPl0ga3RocmVhZCsweGYxLzB4ZjkKWyAg
ICAxLjAzNTc3OF0gIFs8ZmZmZmZmZmY4YTg5NTM5Mj5dID8ga3RocmVhZF9zdG9wKzB4NWEv
MHg1YQpbICAgIDEuMDM1Nzc4XSAgWzxmZmZmZmZmZjhhZGI2N2NjPl0gcmV0X2Zyb21fZm9y
aysweDdjLzB4YjAKWyAgICAxLjAzNTc3OF0gIFs8ZmZmZmZmZmY4YTg5NTM5Mj5dID8ga3Ro
cmVhZF9zdG9wKzB4NWEvMHg1YQpbICAgIDEuMTQ1OTI0XSBLcHJvYmUgc21va2UgdGVzdCBw
YXNzZWQgc3VjY2Vzc2Z1bGx5ClsgICAgMS4xNDcyNjVdIGJvdW5jZSBwb29sIHNpemU6IDY0
IHBhZ2VzClsgICAgMS4xNDc5MzZdIEh1Z2VUTEIgcmVnaXN0ZXJlZCAyIE1CIHBhZ2Ugc2l6
ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUt
MDMwOTEzMjgvZDZlNDUxNTE1YTYxNjdiNjNlNzk2MTJjN2MxMDdkMDkxNmQ3ZjJiMi9kbWVz
Zy1xdWFudGFsLWl2eXRvd24yLTQ6MjAxNDAzMDkyMjE4MDU6eDg2XzY0LXJhbmRjb25maWct
cjUtMDMwOTEzMjg6My4xNC4wLXJjNS0wMDMxOS1nZDZlNDUxNToxCjE6MToxIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA5IDIyOjE4OjI3IFJFUEVBVCBD
T1VOVDogMzAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6
IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMp
CltlMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEyXSB4ODYsIGthc2xy
OiByYW5kb21pemUgbW9kdWxlIGJhc2UgbG9hZCBhZGRyZXNzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOmUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0
NzM1NzVjOGM3MzEwYTI6YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0yMjoxODoyOCBlMmIzMmU2
Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEyIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4LWUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkx
MzI4L2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXI1LTAzMDkxMzI4LWUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3
MzEwYTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC1lMmIzMmU2Nzg1MTM4ZDkyZDJh
NDBlMGQwNDczNTc1YzhjNzMxMGEyCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC9lMmIzMmU2Nzg1MTM4ZDkyZDJhNDBlMGQwNDczNTc1YzhjNzMxMGEy
L3ZtbGludXotMy4xNC4wLXJjNC0wMDAwMS1nZTJiMzJlNgoKMjAxNC0wMy0wOS0yMjoyMzoy
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTEgVEVTVCBGQUlMVVJFClsgICAgMi43MDE1
MTJdIEtwcm9iZSBzbW9rZSB0ZXN0IHN0YXJ0ZWQKWyAgICAyLjcyNjgyMl0gClsgICAgMi43
Mjc1MjZdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQpbICAgIDIuNzI3Nzc0XSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tp
bmcgZGVwZW5kZW5jeSBkZXRlY3RlZCBdClsgICAgMi43Mjc3NzRdIDMuMTQuMC1yYzQtMDAw
MDEtZ2UyYjMyZTYgIzEgTm90IHRhaW50ZWQKWyAgICAyLjcyNzc3NF0gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDIuNzI3
Nzc0XSBrd29ya2VyLzE6MS8yNSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDIu
NzI3Nzc0XSAgKHRleHRfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODk5YjQ2MzM+
XSBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMi43Mjc3NzRdIApbICAgIDIu
NzI3Nzc0XSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICAyLjcyNzc3
NF0gIChtb2R1bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODk5YjQ1Mzc+XSBr
cHJvYmVfb3B0aW1pemVyKzB4MjUvMHgyM2MKWyAgICAyLjcyNzc3NF0gClsgICAgMi43Mjc3
NzRdIHdoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgICAy
LjcyNzc3NF0gClsgICAgMi43Mjc3NzRdIApbICAgIDIuNzI3Nzc0XSB0aGUgZXhpc3Rpbmcg
ZGVwZW5kZW5jeSBjaGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAgMi43Mjc3NzRd
IAotPiAjMiAobW9kdWxlX211dGV4KXsrLisuLi59OgpbICAgIDIuNzI3Nzc0XSAgICAgICAg
WzxmZmZmZmZmZjg5NGI1MGQ1Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDIuNzI3
Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5OWFjM2QwPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg2
NS8weDM0YQpbICAgIDIuNzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5NDMwOTVhPl0gbW9k
dWxlX2FsbG9jKzB4NDIvMHhiNQpbICAgIDIuNzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5
NGRjMjVhPl0gYWxsb2NfaW5zbl9wYWdlKzB4ZS8weDEwClsgICAgMi43Mjc3NzRdICAgICAg
ICBbPGZmZmZmZmZmODk5YjQ4MmU+XSBfX2dldF9pbnNuX3Nsb3QrMHhlMC8weDE2NQpbICAg
IDIuNzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5OWIxYjdjPl0gYXJjaF9wcmVwYXJlX2tw
cm9iZSsweDM2LzB4YjcKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTliNTRm
Zj5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDIuNzI3Nzc0XSAgICAgICAg
WzxmZmZmZmZmZjg5NGQ3OTkxPl0gaW5pdF90ZXN0X3Byb2JlcysweDRlLzB4NDg5ClsgICAg
Mi43Mjc3NzRdICAgICAgICBbPGZmZmZmZmZmODlmNjc5Yjg+XSBpbml0X2twcm9iZXMrMHgx
N2IvMHgxODkKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTQwMjBmYj5dIGRv
X29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMi43Mjc3NzRdICAgICAgICBbPGZmZmZm
ZmZmODlmNGNmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMy8weDE5NApbICAgIDIu
NzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5OWEwMzVjPl0ga2VybmVsX2luaXQrMHg5LzB4
ZDUKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTliNWQ4Yz5dIHJldF9mcm9t
X2ZvcmsrMHg3Yy8weGIwClsgICAgMi43Mjc3NzRdIAotPiAjMSAoa3Byb2JlX2luc25fc2xv
dHMubXV0ZXgpeysuKy4rLn06ClsgICAgMi43Mjc3NzRdICAgICAgICBbPGZmZmZmZmZmODk0
YjUwZDU+XSBsb2NrX2FjcXVpcmUrMHhhNC8weGM0ClsgICAgMi43Mjc3NzRdICAgICAgICBb
PGZmZmZmZmZmODk5YWMzZDA+XSBtdXRleF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsgICAg
Mi43Mjc3NzRdICAgICAgICBbPGZmZmZmZmZmODk5YjQ3NmE+XSBfX2dldF9pbnNuX3Nsb3Qr
MHgxYy8weDE2NQpbICAgIDIuNzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5OWIxYjdjPl0g
YXJjaF9wcmVwYXJlX2twcm9iZSsweDM2LzB4YjcKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8
ZmZmZmZmZmY4OTliNTRmZj5dIHJlZ2lzdGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDIu
NzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5NGQ3OTkxPl0gaW5pdF90ZXN0X3Byb2Jlcysw
eDRlLzB4NDg5ClsgICAgMi43Mjc3NzRdICAgICAgICBbPGZmZmZmZmZmODlmNjc5Yjg+XSBp
bml0X2twcm9iZXMrMHgxN2IvMHgxODkKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZm
ZmY4OTQwMjBmYj5dIGRvX29uZV9pbml0Y2FsbCsweDlmLzB4MTM1ClsgICAgMi43Mjc3NzRd
ICAgICAgICBbPGZmZmZmZmZmODlmNGNmNjM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEw
My8weDE5NApbICAgIDIuNzI3Nzc0XSAgICAgICAgWzxmZmZmZmZmZjg5OWEwMzVjPl0ga2Vy
bmVsX2luaXQrMHg5LzB4ZDUKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTli
NWQ4Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMi43Mjc3NzRdIAotPiAjMCAo
dGV4dF9tdXRleCl7Ky4rLisufToKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4
OTRiNDQ3NT5dIF9fbG9ja19hY3F1aXJlKzB4MTE5Ny8weDE5MTQKWyAgICAyLjcyNzc3NF0g
ICAgICAgIFs8ZmZmZmZmZmY4OTRiNTBkNT5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAg
ICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTlhYzNkMD5dIG11dGV4X2xvY2tfbmVz
dGVkKzB4NjUvMHgzNGEKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTliNDYz
Mz5dIGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAyLjcyNzc3NF0gICAgICAg
IFs8ZmZmZmZmZmY4OTQ4ZWFjNT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyMzcvMHgzZGIKWyAg
ICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTQ4ZjhiZj5dIHdvcmtlcl90aHJlYWQr
MHgxY2IvMHgyYzQKWyAgICAyLjcyNzc3NF0gICAgICAgIFs8ZmZmZmZmZmY4OTQ5NTRhMT5d
IGt0aHJlYWQrMHhmMS8weGY5ClsgICAgMi43Mjc3NzRdICAgICAgICBbPGZmZmZmZmZmODk5
YjVkOGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDIuNzI3Nzc0XSAKWyAgICAy
LjcyNzc3NF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAg
ICAyLjcyNzc3NF0gClsgICAgMi43Mjc3NzRdIENoYWluIGV4aXN0cyBvZjoKICB0ZXh0X211
dGV4IC0tPiBrcHJvYmVfaW5zbl9zbG90cy5tdXRleCAtLT4gbW9kdWxlX211dGV4CgpbICAg
IDIuNzI3Nzc0XSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86ClsgICAgMi43
Mjc3NzRdIApbICAgIDIuNzI3Nzc0XSAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAg
Q1BVMQpbICAgIDIuNzI3Nzc0XSAgICAgICAgLS0tLSAgICAgICAgICAgICAgICAgICAgLS0t
LQpbICAgIDIuNzI3Nzc0XSAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAyLjcyNzc3NF0g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soa3Byb2JlX2luc25fc2xvdHMu
bXV0ZXgpOwpbICAgIDIuNzI3Nzc0XSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bG9jayhtb2R1bGVfbXV0ZXgpOwpbICAgIDIuNzI3Nzc0XSAgIGxvY2sodGV4dF9tdXRleCk7
ClsgICAgMi43Mjc3NzRdIApbICAgIDIuNzI3Nzc0XSAgKioqIERFQURMT0NLICoqKgpbICAg
IDIuNzI3Nzc0XSAKWyAgICAyLjcyNzc3NF0gNCBsb2NrcyBoZWxkIGJ5IGt3b3JrZXIvMTox
LzI1OgpbICAgIDIuNzI3Nzc0XSAgIzA6ICAoImV2ZW50cyIpey4rLisuLn0sIGF0OiBbPGZm
ZmZmZmZmODk0OGVhNWY+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMi43
Mjc3NzRdICAjMTogICgob3B0aW1pemluZ193b3JrKS53b3JrKXsrLisuLi59LCBhdDogWzxm
ZmZmZmZmZjg5NDhlYTVmPl0gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDIu
NzI3Nzc0XSAgIzI6ICAoa3Byb2JlX211dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjg5
OWI0NTI5Pl0ga3Byb2JlX29wdGltaXplcisweDE3LzB4MjNjClsgICAgMi43Mjc3NzRdICAj
MzogIChtb2R1bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODk5YjQ1Mzc+XSBr
cHJvYmVfb3B0aW1pemVyKzB4MjUvMHgyM2MKWyAgICAyLjcyNzc3NF0gClsgICAgMi43Mjc3
NzRdIHN0YWNrIGJhY2t0cmFjZToKWyAgICAyLjcyNzc3NF0gQ1BVOiAxIFBJRDogMjUgQ29t
bToga3dvcmtlci8xOjEgTm90IHRhaW50ZWQgMy4xNC4wLXJjNC0wMDAwMS1nZTJiMzJlNiAj
MQpbICAgIDIuNzI3Nzc0XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMi43Mjc3NzRdIFdvcmtxdWV1ZTogZXZlbnRzIGtwcm9iZV9v
cHRpbWl6ZXIKWyAgICAyLjcyNzc3NF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZDgy
NWJiMCBmZmZmZmZmZjg5OWE4MTVjIGZmZmZmZmZmOGE0NjAwZDAKWyAgICAyLjcyNzc3NF0g
IGZmZmY4ODAwMGQ4MjViZjAgZmZmZmZmZmY4OTlhNGYxOSBmZmZmODgwMDBkODIwNjUwIGZm
ZmY4ODAwMGQ4MjEyZjAKWyAgICAyLjcyNzc3NF0gIDAwMDAwMDAwMDAwMDAwMDQgZmZmZjg4
MDAwZDgyMTJmMCBmZmZmODgwMDBkODIwNjUwIGZmZmY4ODAwMGQ4MjEyYzgKWyAgICAyLjcy
Nzc3NF0gQ2FsbCBUcmFjZToKWyAgICAyLjcyNzc3NF0gIFs8ZmZmZmZmZmY4OTlhODE1Yz5d
IGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk5YTRm
MTk+XSBwcmludF9jaXJjdWxhcl9idWcrMHgyYjQvMHgyYzIKWyAgICAyLjcyNzc3NF0gIFs8
ZmZmZmZmZmY4OTRiNDQ3NT5dIF9fbG9ja19hY3F1aXJlKzB4MTE5Ny8weDE5MTQKWyAgICAy
LjcyNzc3NF0gIFs8ZmZmZmZmZmY4OTlhZjNlNT5dID8gX3Jhd19zcGluX3VubG9ja19pcnEr
MHgyNy8weDM5ClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk0YjUwZDU+XSBsb2NrX2Fj
cXVpcmUrMHhhNC8weGM0ClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk5YjQ2MzM+XSA/
IGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAyLjcyNzc3NF0gIFs8ZmZmZmZm
ZmY4OTlhYzNkMD5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NjUvMHgzNGEKWyAgICAyLjcyNzc3
NF0gIFs8ZmZmZmZmZmY4OTliNDYzMz5dID8ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIz
YwpbICAgIDIuNzI3Nzc0XSAgWzxmZmZmZmZmZjg5NGIxZjE2Pl0gPyB0cmFjZV9oYXJkaXJx
c19vbisweGQvMHhmClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk5YjQ2MzM+XSBrcHJv
YmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk0
OGVhYzU+XSBwcm9jZXNzX29uZV93b3JrKzB4MjM3LzB4M2RiClsgICAgMi43Mjc3NzRdICBb
PGZmZmZmZmZmODk0OGVhNWY+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAg
ICAyLjcyNzc3NF0gIFs8ZmZmZmZmZmY4OTQ4ZjhiZj5dIHdvcmtlcl90aHJlYWQrMHgxY2Iv
MHgyYzQKWyAgICAyLjcyNzc3NF0gIFs8ZmZmZmZmZmY4OTQ4ZjZmND5dID8gcmVzY3Vlcl90
aHJlYWQrMHgyOWIvMHgyOWIKWyAgICAyLjcyNzc3NF0gIFs8ZmZmZmZmZmY4OTQ5NTRhMT5d
IGt0aHJlYWQrMHhmMS8weGY5ClsgICAgMi43Mjc3NzRdICBbPGZmZmZmZmZmODk0OTUzYjA+
XSA/IGt0aHJlYWRfc3RvcCsweDVhLzB4NWEKWyAgICAyLjcyNzc3NF0gIFs8ZmZmZmZmZmY4
OTliNWQ4Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMi43Mjc3NzRdICBbPGZm
ZmZmZmZmODk0OTUzYjA+XSA/IGt0aHJlYWRfc3RvcCsweDVhLzB4NWEKWyAgICAyLjg5Njc5
NV0gS3Byb2JlIHNtb2tlIHRlc3QgcGFzc2VkIHN1Y2Nlc3NmdWxseQpbICAgIDIuOTMwODUx
XSBib3VuY2UgcG9vbCBzaXplOiA2NCBwYWdlcwpbICAgIDIuOTM5MjgyXSBIdWdlVExCIHJl
Z2lzdGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxvY2F0ZWQgMCBwYWdlcwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUw
ZDA0NzM1NzVjOGM3MzEwYTIvZG1lc2ctcXVhbnRhbC14Z3dvLTQ6MjAxNDAzMDkyMjI1MzM6
eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNC0wMDAwMS1nZTJiMzJl
NjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvZTJiMzJlNjc4NTEz
OGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy15b2N0by1iZW5zLTU6MjAxNDAz
MDkyMjI1Mjg6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNC0wMDAw
MS1nZTJiMzJlNjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvZTJi
MzJlNjc4NTEzOGQ5MmQyYTQwZTBkMDQ3MzU3NWM4YzczMTBhMi9kbWVzZy1xdWFudGFsLXhw
cy03OjIwMTQwMzA5MjIyNTQwOng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQu
MC1yYzQtMDAwMDEtZ2UyYjMyZTY6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4L2UyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEwYTIvZG1lc2ct
eW9jdG8taXZ5dG93bjItNzoyMDE0MDMwOTIyMjU0Mjp4ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyODozLjE0LjAtcmM0LTAwMDAxLWdlMmIzMmU2OjEKMTo0OjQgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCmUyYjMyZTY3ODUxMzhkOTJkMmE0MGUwZDA0NzM1NzVjOGM3MzEw
YTIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGUyYjMyZTY3ODUxMzhkOTJkMmE0
MGUwZDA0NzM1NzVjOGM3MzEwYTIKQXV0aG9yOiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9t
aXVtLm9yZz4KRGF0ZTogICBUdWUgRmViIDI1IDE2OjU5OjE3IDIwMTQgLTA4MDAKCiAgICB4
ODYsIGthc2xyOiByYW5kb21pemUgbW9kdWxlIGJhc2UgbG9hZCBhZGRyZXNzCiAgICAKICAg
IFJhbmRvbWl6ZSB0aGUgbG9hZCBhZGRyZXNzIG9mIG1vZHVsZXMgaW4gdGhlIGtlcm5lbCB0
byBtYWtlIGtBU0xSCiAgICBlZmZlY3RpdmUgZm9yIG1vZHVsZXMuICBNb2R1bGVzIGNhbiBv
bmx5IGJlIGxvYWRlZCB3aXRoaW4gYSBwYXJ0aWN1bGFyCiAgICByYW5nZSBvZiB2aXJ0dWFs
IGFkZHJlc3Mgc3BhY2UuICBUaGlzIHBhdGNoIGFkZHMgMTAgYml0cyBvZiBlbnRyb3B5IHRv
CiAgICB0aGUgbG9hZCBhZGRyZXNzIGJ5IGFkZGluZyAxLTEwMjQgKiBQQUdFX1NJWkUgdG8g
dGhlIGJlZ2lubmluZyByYW5nZQogICAgd2hlcmUgbW9kdWxlcyBhcmUgbG9hZGVkLgogICAg
CiAgICBUaGUgc2luZ2xlIGJhc2Ugb2Zmc2V0IHdhcyBjaG9zZW4gYmVjYXVzZSByYW5kb21p
emluZyBlYWNoIG1vZHVsZQogICAgbG9hZCBlbmRzIHVwIHdhc3RpbmcvZnJhZ21lbnRpbmcg
bWVtb3J5IHRvbyBtdWNoLiBQcmlvciBhcHByb2FjaGVzIHRvCiAgICBtaW5pbWl6aW5nIGZy
YWdtZW50YXRpb24gd2hpbGUgZG9pbmcgcmFuZG9taXphdGlvbiB0ZW5kIHRvIHJlc3VsdCBp
bgogICAgd29yc2UgZW50cm9weSB0aGFuIGp1c3QgZG9pbmcgYSBzaW5nbGUgYmFzZSBhZGRy
ZXNzIG9mZnNldC4KICAgIAogICAgRXhhbXBsZSBrQVNMUiBib290IHdpdGhvdXQgdGhpcyBj
aGFuZ2UsIHdpdGggYSBzaW5nbGUgbW9kdWxlIGxvYWRlZDoKICAgIC0tLVsgTW9kdWxlcyBd
LS0tCiAgICAweGZmZmZmZmZmYzAwMDAwMDAtMHhmZmZmZmZmZmMwMDAxMDAwICAgICAgICAg
ICA0SyAgICAgcm8gICAgIEdMQiB4ICBwdGUKICAgIDB4ZmZmZmZmZmZjMDAwMTAwMC0weGZm
ZmZmZmZmYzAwMDIwMDAgICAgICAgICAgIDRLICAgICBybyAgICAgR0xCIE5YIHB0ZQogICAg
MHhmZmZmZmZmZmMwMDAyMDAwLTB4ZmZmZmZmZmZjMDAwNDAwMCAgICAgICAgICAgOEsgICAg
IFJXICAgICBHTEIgTlggcHRlCiAgICAweGZmZmZmZmZmYzAwMDQwMDAtMHhmZmZmZmZmZmMw
MjAwMDAwICAgICAgICAyMDMySyAgICAgICAgICAgICAgICAgICBwdGUKICAgIDB4ZmZmZmZm
ZmZjMDIwMDAwMC0weGZmZmZmZmZmZmYwMDAwMDAgICAgICAgIDEwMDZNICAgICAgICAgICAg
ICAgICAgIHBtZAogICAgLS0tWyBFbmQgTW9kdWxlcyBdLS0tCiAgICAKICAgIEV4YW1wbGUg
a0FTTFIgYm9vdCBhZnRlciB0aGlzIGNoYW5nZSwgc2FtZSBtb2R1bGUgbG9hZGVkOgogICAg
LS0tWyBNb2R1bGVzIF0tLS0KICAgIDB4ZmZmZmZmZmZjMDAwMDAwMC0weGZmZmZmZmZmYzAy
MDAwMDAgICAgICAgICAgIDJNICAgICAgICAgICAgICAgICAgIHBtZAogICAgMHhmZmZmZmZm
ZmMwMjAwMDAwLTB4ZmZmZmZmZmZjMDNiZjAwMCAgICAgICAgMTc4OEsgICAgICAgICAgICAg
ICAgICAgcHRlCiAgICAweGZmZmZmZmZmYzAzYmYwMDAtMHhmZmZmZmZmZmMwM2MwMDAwICAg
ICAgICAgICA0SyAgICAgcm8gICAgIEdMQiB4ICBwdGUKICAgIDB4ZmZmZmZmZmZjMDNjMDAw
MC0weGZmZmZmZmZmYzAzYzEwMDAgICAgICAgICAgIDRLICAgICBybyAgICAgR0xCIE5YIHB0
ZQogICAgMHhmZmZmZmZmZmMwM2MxMDAwLTB4ZmZmZmZmZmZjMDNjMzAwMCAgICAgICAgICAg
OEsgICAgIFJXICAgICBHTEIgTlggcHRlCiAgICAweGZmZmZmZmZmYzAzYzMwMDAtMHhmZmZm
ZmZmZmMwNDAwMDAwICAgICAgICAgMjQ0SyAgICAgICAgICAgICAgICAgICBwdGUKICAgIDB4
ZmZmZmZmZmZjMDQwMDAwMC0weGZmZmZmZmZmZmYwMDAwMDAgICAgICAgIDEwMDRNICAgICAg
ICAgICAgICAgICAgIHBtZAogICAgLS0tWyBFbmQgTW9kdWxlcyBdLS0tCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IEFuZHkgSG9uaWcgPGFob25pZ0Bnb29nbGUuY29tPgogICAgTGluazog
aHR0cDovL2xrbWwua2VybmVsLm9yZy9yLzIwMTQwMjI2MDA1OTE2LkdBMjcwODNAd3d3Lm91
dGZsdXgubmV0CiAgICBTaWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9t
aXVtLm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFudmluIDxocGFAbGludXgu
aW50ZWwuY29tPgoKOjA0MDAwMCAwNDAwMDAgOTg5NDRkNDMwZjA4NDk4ZDRjYWM4NjllZjQx
ZjkzZDE2YzY5ZWJlYiA5YWZlNzhhMzYyNGU0MzVlZWVkMDBjYmU3YWJkZjkzOWVlZGI3ODYy
IE0JRG9jdW1lbnRhdGlvbgo6MDQwMDAwIDA0MDAwMCA1NTJlOTdlZDJjYWM2NGUzZWYzOTM4
ZDRkNWE3MTVmMTdhNmYwOWY3IGJkZTU2ZDY0OGY2YzM5MWY2ODhhYjFiMDdkYzNhMDlmM2U0
Y2Q2YTAgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvbmV4dDptYXN0ZXI6
Y2ZiZjhkNDg1N2MyNmE4YTMwN2ZiN2NkMjU4MDc0YzlkY2Q4YzY5MTpiaXNlY3QtdXNiCgoy
MDE0LTAzLTA5LTIyOjI2OjAyIGNmYmY4ZDQ4NTdjMjZhOGEzMDdmYjdjZDI1ODA3NGM5ZGNk
OGM2OTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtY2ZiZjhkNDg1N2MyNmE4
YTMwN2ZiN2NkMjU4MDc0YzlkY2Q4YzY5MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvY2ZiZjhkNDg1N2MyNmE4YTMwN2ZiN2Nk
MjU4MDc0YzlkY2Q4YzY5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtY2ZiZjhkNDg1
N2MyNmE4YTMwN2ZiN2NkMjU4MDc0YzlkY2Q4YzY5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4LWNmYmY4ZDQ4NTdjMjZhOGEzMDdmYjdjZDI1ODA3NGM5ZGNkOGM2OTEKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2NmYmY4ZDQ4NTdjMjZh
OGEzMDdmYjdjZDI1ODA3NGM5ZGNkOGM2OTEvdm1saW51ei0zLjE0LjAtcmM0CgoyMDE0LTAz
LTA5LTIyOjI5OjAyIGRldGVjdGluZyBib290IHN0YXRlIC4JMQk3CTEwCTEyCTEzCTE0Li4J
MTgJMjEJMjcJMzAJMzMJMzgJNDYJNDguCTUxCTUzCTU0CTU1Li4uCTU3CTU5CTY0CTY1CTY2
CTY3CTY4CTc1CTgwCTgyCTg2CTg5Li4uLi4uLi4uLi4uLi4JOTAgU1VDQ0VTUwoKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkx
MzI4L25leHQ6bWFzdGVyOjFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhk
M2M6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMS42OTgxMTZdIEtwcm9iZSBzbW9r
ZSB0ZXN0IHN0YXJ0ZWQKWyAgICAxLjcyNjgzNV0gClsgICAgMS43Mjc1OTldID09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAgIDEu
NzI3NjMzXSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVwZW5kZW5jeSBk
ZXRlY3RlZCBdClsgICAgMS43Mjc2MzNdIDMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEy
OS1nMWIwYTdlMyAjMSBOb3QgdGFpbnRlZApbICAgIDEuNzI3NjMzXSAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMS43Mjc2
MzNdIGt3b3JrZXIvMDowLzQgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAgICAxLjcy
NzYzM10gICh0ZXh0X211dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjhkMWMyNTMxPl0g
a3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDEuNzI3NjMzXSAKWyAgICAxLjcy
NzYzM10gYnV0IHRhc2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAgMS43Mjc2MzNd
ICAobW9kdWxlX211dGV4KXsrLisuLi59LCBhdDogWzxmZmZmZmZmZjhkMWMyNDM1Pl0ga3By
b2JlX29wdGltaXplcisweDI1LzB4MjNjClsgICAgMS43Mjc2MzNdIApbICAgIDEuNzI3NjMz
XSB3aGljaCBsb2NrIGFscmVhZHkgZGVwZW5kcyBvbiB0aGUgbmV3IGxvY2suClsgICAgMS43
Mjc2MzNdIApbICAgIDEuNzI3NjMzXSAKWyAgICAxLjcyNzYzM10gdGhlIGV4aXN0aW5nIGRl
cGVuZGVuY3kgY2hhaW4gKGluIHJldmVyc2Ugb3JkZXIpIGlzOgpbICAgIDEuNzI3NjMzXSAK
LT4gIzIgKG1vZHVsZV9tdXRleCl7Ky4rLi4ufToKWyAgICAxLjcyNzYzM10gICAgICAgIFs8
ZmZmZmZmZmY4Y2NiM2E2NT5dIF9fbG9ja19hY3F1aXJlKzB4OTEwLzB4YTAzClsgICAgMS43
Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjYjQwNDM+XSBsb2NrX2FjcXVpcmUrMHhhNC8w
eGM0ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYmEyZmU+XSBtdXRleF9s
b2NrX25lc3RlZCsweDY1LzB4MzRhClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZm
OGNjMmY5NTQ+XSBtb2R1bGVfYWxsb2MrMHg0Mi8weGI1ClsgICAgMS43Mjc2MzNdICAgICAg
ICBbPGZmZmZmZmZmOGNjZGI4ZTU+XSBhbGxvY19pbnNuX3BhZ2UrMHhlLzB4MTAKWyAgICAx
LjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFjMjcyYz5dIF9fZ2V0X2luc25fc2xvdCsw
eGUwLzB4MTY1ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYmZhNzM+XSBh
cmNoX3ByZXBhcmVfa3Byb2JlKzB4MzYvMHhiNwpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxm
ZmZmZmZmZjhkMWMzNDAxPl0gcmVnaXN0ZXJfa3Byb2JlKzB4MzMwLzB4NDkwClsgICAgMS43
Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjZDZmZjI+XSBpbml0X3Rlc3RfcHJvYmVzKzB4
NGUvMHg0ODkKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDc3MDE3Yz5dIGlu
aXRfa3Byb2JlcysweDE3Yi8weDE4OQpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZm
ZjhjYzAyMGZiPl0gZG9fb25lX2luaXRjYWxsKzB4OWYvMHgxMzUKWyAgICAxLjcyNzYzM10g
ICAgICAgIFs8ZmZmZmZmZmY4ZDc1NGY2NT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTA0
LzB4MTk2ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYWRiZTk+XSBrZXJu
ZWxfaW5pdCsweDkvMHhkNQpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhkMWMz
YzhjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAxLjcyNzYzM10gCi0+ICMxIChr
cHJvYmVfaW5zbl9zbG90cy5tdXRleCl7Ky4rLisufToKWyAgICAxLjcyNzYzM10gICAgICAg
IFs8ZmZmZmZmZmY4Y2NiM2E2NT5dIF9fbG9ja19hY3F1aXJlKzB4OTEwLzB4YTAzClsgICAg
MS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjYjQwNDM+XSBsb2NrX2FjcXVpcmUrMHhh
NC8weGM0ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYmEyZmU+XSBtdXRl
eF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZm
ZmZmOGQxYzI2Njg+XSBfX2dldF9pbnNuX3Nsb3QrMHgxYy8weDE2NQpbICAgIDEuNzI3NjMz
XSAgICAgICAgWzxmZmZmZmZmZjhkMWJmYTczPl0gYXJjaF9wcmVwYXJlX2twcm9iZSsweDM2
LzB4YjcKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFjMzQwMT5dIHJlZ2lz
dGVyX2twcm9iZSsweDMzMC8weDQ5MApbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZm
ZjhjY2Q2ZmYyPl0gaW5pdF90ZXN0X3Byb2JlcysweDRlLzB4NDg5ClsgICAgMS43Mjc2MzNd
ICAgICAgICBbPGZmZmZmZmZmOGQ3NzAxN2M+XSBpbml0X2twcm9iZXMrMHgxN2IvMHgxODkK
WyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4Y2MwMjBmYj5dIGRvX29uZV9pbml0
Y2FsbCsweDlmLzB4MTM1ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQ3NTRm
NjU+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwNC8weDE5NgpbICAgIDEuNzI3NjMzXSAg
ICAgICAgWzxmZmZmZmZmZjhkMWFkYmU5Pl0ga2VybmVsX2luaXQrMHg5LzB4ZDUKWyAgICAx
LjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFjM2M4Yz5dIHJldF9mcm9tX2ZvcmsrMHg3
Yy8weGIwClsgICAgMS43Mjc2MzNdIAotPiAjMCAodGV4dF9tdXRleCl7Ky4rLisufToKWyAg
ICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4Y2NiMGUwZj5dIHZhbGlkYXRlX2NoYWlu
LmlzcmEuMjArMHg4Y2YvMHhmMmUKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4
Y2NiM2E2NT5dIF9fbG9ja19hY3F1aXJlKzB4OTEwLzB4YTAzClsgICAgMS43Mjc2MzNdICAg
ICAgICBbPGZmZmZmZmZmOGNjYjQwNDM+XSBsb2NrX2FjcXVpcmUrMHhhNC8weGM0ClsgICAg
MS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYmEyZmU+XSBtdXRleF9sb2NrX25lc3Rl
ZCsweDY1LzB4MzRhClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYzI1MzE+
XSBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS43Mjc2MzNdICAgICAgICBb
PGZmZmZmZmZmOGNjOGRmYzQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MjM3LzB4M2RiClsgICAg
MS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjOGVkYzI+XSB3b3JrZXJfdGhyZWFkKzB4
MWNiLzB4MmM0ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjOTQ5OGI+XSBr
dGhyZWFkKzB4ZjEvMHhmOQpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhkMWMz
YzhjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAxLjcyNzYzM10gClsgICAgMS43
Mjc2MzNdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAg
MS43Mjc2MzNdIApbICAgIDEuNzI3NjMzXSBDaGFpbiBleGlzdHMgb2Y6CiAgdGV4dF9tdXRl
eCAtLT4ga3Byb2JlX2luc25fc2xvdHMubXV0ZXggLS0+IG1vZHVsZV9tdXRleAoKWyAgICAx
LjcyNzYzM10gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpbICAgIDEuNzI3
NjMzXSAKWyAgICAxLjcyNzYzM10gICAgICAgIENQVTAgICAgICAgICAgICAgICAgICAgIENQ
VTEKWyAgICAxLjcyNzYzM10gICAgICAgIC0tLS0gICAgICAgICAgICAgICAgICAgIC0tLS0K
WyAgICAxLjcyNzYzM10gICBsb2NrKG1vZHVsZV9tdXRleCk7ClsgICAgMS43Mjc2MzNdICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKGtwcm9iZV9pbnNuX3Nsb3RzLm11
dGV4KTsKWyAgICAxLjcyNzYzM10gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxv
Y2sobW9kdWxlX211dGV4KTsKWyAgICAxLjcyNzYzM10gICBsb2NrKHRleHRfbXV0ZXgpOwpb
ICAgIDEuNzI3NjMzXSAKWyAgICAxLjcyNzYzM10gICoqKiBERUFETE9DSyAqKioKWyAgICAx
LjcyNzYzM10gClsgICAgMS43Mjc2MzNdIDQgbG9ja3MgaGVsZCBieSBrd29ya2VyLzA6MC80
OgpbICAgIDEuNzI3NjMzXSAgIzA6ICAoImV2ZW50cyIpey4rLisuLn0sIGF0OiBbPGZmZmZm
ZmZmOGNjOGRmNWU+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS43Mjc2
MzNdICAjMTogICgob3B0aW1pemluZ193b3JrKS53b3JrKXsrLisuLi59LCBhdDogWzxmZmZm
ZmZmZjhjYzhkZjVlPl0gcHJvY2Vzc19vbmVfd29yaysweDFkMS8weDNkYgpbICAgIDEuNzI3
NjMzXSAgIzI6ICAoa3Byb2JlX211dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjhkMWMy
NDI3Pl0ga3Byb2JlX29wdGltaXplcisweDE3LzB4MjNjClsgICAgMS43Mjc2MzNdICAjMzog
IChtb2R1bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmOGQxYzI0MzU+XSBrcHJv
YmVfb3B0aW1pemVyKzB4MjUvMHgyM2MKWyAgICAxLjcyNzYzM10gClsgICAgMS43Mjc2MzNd
IHN0YWNrIGJhY2t0cmFjZToKWyAgICAxLjcyNzYzM10gQ1BVOiAwIFBJRDogNCBDb21tOiBr
d29ya2VyLzA6MCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjkt
ZzFiMGE3ZTMgIzEKWyAgICAxLjcyNzYzM10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNzI3NjMzXSBXb3JrcXVldWU6IGV2ZW50
cyBrcHJvYmVfb3B0aW1pemVyClsgICAgMS43Mjc2MzNdICAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAwMGM4ZTdiNjAgZmZmZmZmZmY4ZDFiNWIxZCBmZmZmZmZmZjhkYzY5MTEwClsgICAg
MS43Mjc2MzNdICBmZmZmODgwMDBjOGU3YmEwIGZmZmZmZmZmOGQxYjI4NTAgZmZmZjg4MDAw
YzhlODBkMCBmZmZmODgwMDBjOGU4ZDk4ClsgICAgMS43Mjc2MzNdICBmZmZmODgwMDBjOGU4
MGQwIGZmZmY4ODAwMGM4ZThkOTggMDAwMDAwMDAwMDAwMDAwNCBmZmZmODgwMDBjOGU4ZDcw
ClsgICAgMS43Mjc2MzNdIENhbGwgVHJhY2U6ClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZm
OGQxYjViMWQ+XSBkdW1wX3N0YWNrKzB4NGQvMHg2NgpbICAgIDEuNzI3NjMzXSAgWzxmZmZm
ZmZmZjhkMWIyODUwPl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4MmI0LzB4MmMyClsgICAgMS43
Mjc2MzNdICBbPGZmZmZmZmZmOGNjYjBlMGY+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjIwKzB4
OGNmLzB4ZjJlClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGNjYjNhNjU+XSBfX2xvY2tf
YWNxdWlyZSsweDkxMC8weGEwMwpbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhjY2I0MDQz
Pl0gbG9ja19hY3F1aXJlKzB4YTQvMHhjNApbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhk
MWMyNTMxPl0gPyBrcHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS43Mjc2MzNd
ICBbPGZmZmZmZmZmOGQxYmEyZmU+XSBtdXRleF9sb2NrX25lc3RlZCsweDY1LzB4MzRhClsg
ICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGQxYzI1MzE+XSA/IGtwcm9iZV9vcHRpbWl6ZXIr
MHgxMjEvMHgyM2MKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4Y2NiMWQ4ZD5dID8gdHJh
Y2VfaGFyZGlycXNfb24rMHhkLzB4ZgpbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhkMWMy
NTMxPl0ga3Byb2JlX29wdGltaXplcisweDEyMS8weDIzYwpbICAgIDEuNzI3NjMzXSAgWzxm
ZmZmZmZmZjhjYzhkZmM0Pl0gcHJvY2Vzc19vbmVfd29yaysweDIzNy8weDNkYgpbICAgIDEu
NzI3NjMzXSAgWzxmZmZmZmZmZjhjYzhkZjVlPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MWQx
LzB4M2RiClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGQxYmJlMDA+XSA/IF9fbXV0ZXhf
dW5sb2NrX3Nsb3dwYXRoKzB4YTEvMHgxNDgKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4
Y2M4ZWRjMj5dIHdvcmtlcl90aHJlYWQrMHgxY2IvMHgyYzQKWyAgICAxLjcyNzYzM10gIFs8
ZmZmZmZmZmY4Y2M4ZWJmNz5dID8gcmVzY3Vlcl90aHJlYWQrMHgyOWIvMHgyOWIKWyAgICAx
LjcyNzYzM10gIFs8ZmZmZmZmZmY4Y2M5NDk4Yj5dIGt0aHJlYWQrMHhmMS8weGY5ClsgICAg
MS43Mjc2MzNdICBbPGZmZmZmZmZmOGNjOTQ4OWE+XSA/IGt0aHJlYWRfc3RvcCsweDVhLzB4
NWEKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4ZDFjM2M4Yz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGNjOTQ4OWE+XSA/IGt0aHJl
YWRfc3RvcCsweDVhLzB4NWEKWyAgICAxLjkxNDY0NF0gS3Byb2JlIHNtb2tlIHRlc3QgcGFz
c2VkIHN1Y2Nlc3NmdWxseQpbICAgIDEuOTE2ODcwXSBib3VuY2UgcG9vbCBzaXplOiA2NCBw
YWdlcwpbICAgIDEuOTE4MTIyXSBIdWdlVExCIHJlZ2lzdGVyZWQgMiBNQiBwYWdlIHNpemUs
IHByZS1hbGxvY2F0ZWQgMCBwYWdlcwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkxMzI4LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ct
eW9jdG8taXZ5dG93bjItMjQ6MjAxNDAzMDkxMzQ0MjQ6eDg2XzY0LXJhbmRjb25maWctcjUt
MDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4
NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTE6MjAxNDAz
MDkxMzQ0MjQ6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0
LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
NS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2Rt
ZXNnLXlvY3RvLW5obTQtMjoyMDE0MDMwOTE3NTIwMzp4ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjktZzFiMGE3ZTM6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFiMGE3ZTMyNjMxNjhhMDZkMzg1
ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8taXZ5dG93bjItMTI6MjAxNDAzMDkx
NzUyNTk6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0LTIw
MTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0w
MzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNn
LXlvY3RvLXNuYi0zNjoyMDE0MDMwOTE3NTMwNjp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5
MTMyODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2
MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy15b2N0by1pdnl0b3duMi0y
OjIwMTQwMzA5MTc1MTM0Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1y
YzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3
OGQzYy9kbWVzZy15b2N0by1pdnl0b3duMi0zMDoyMDE0MDMwOTEzNDQxMTp4ODZfNjQtcmFu
ZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjktZzFi
MGE3ZTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFiMGE3ZTMy
NjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC14Z3dvLTM6
MjAxNDAzMDkxMzQ0MDE6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yNS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4
ZDNjL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTY6MjAxNDAzMDkxMzQzNTc6eDg2XzY0LXJh
bmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3LTA3MTI5LWcx
YjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC8xYjBhN2Uz
MjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXF1YW50YWwtYXRoZW5z
LTM3OjIwMTQwMzA5MTc1MTQ1Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFk
MWM3OGQzYy9kbWVzZy1xdWFudGFsLXhnd28tNDoyMDE0MDMwOTEzNDQxMTp4ODZfNjQtcmFu
ZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjktZzFi
MGE3ZTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFiMGE3ZTMy
NjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC1zdG9ha2xl
eS00OjIwMTQwMzA5MTc1MTM4Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFk
MWM3OGQzYy9kbWVzZy15b2N0by1pdnl0b3duMi0zOjIwMTQwMzA5MTM0NDEzOng4Nl82NC1y
YW5kY29uZmlnLXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1n
MWIwYTdlMzoxCjU6MTM6MTQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hl
ZCBIRUFEIDg2MTAxMDVdIFJldmVydCAieDg2LCBrYXNscjogcmFuZG9taXplIG1vZHVsZSBi
YXNlIGxvYWQgYWRkcmVzcyIKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0
MiBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L25leHQ6bWFzdGVyOjg2MTAxMDVhZjNmNzhhNmU4
NmVhZWUxMTAyMzA2MDYwODA1NjFhZjk6YmlzZWN0LXVzYgoKMjAxNC0wMy0wOS0yMjo1NTox
MyA4NjEwMTA1YWYzZjc4YTZlODZlYWVlMTEwMjMwNjA2MDgwNTYxYWY5IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLXI1LTAzMDkxMzI4LTg2MTAxMDVhZjNmNzhhNmU4NmVhZWUxMTAyMzA2MDYw
ODA1NjFhZjkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4Lzg2MTAxMDVhZjNmNzhhNmU4NmVhZWUxMTAyMzA2MDYwODA1NjFhZjkK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTg2MTAxMDVhZjNmNzhhNmU4NmVhZWUxMTAy
MzA2MDYwODA1NjFhZjkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAz
MDkyMjQyLzlkZGVkYzBkNWRjM2IxZDU5NTNlNDg1NzJmNGQ1ZmE1Yjg0NTZhZTAvdm1saW51
ei0zLjE0LjAtcmM1LXdsLWF0aC0wMjI3NC1nOWRkZWRjMApzdGF0dXM6IEZBSUw6IG5vIGNv
bW1pdCA4NjEwMTA1YWYzZjc4YTZlODZlYWVlMTEwMjMwNjA2MDgwNTYxYWY5IGZvciBidWls
ZCB0YXNrIHg4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LTg2MTAxMDVhZjNmNzhhNmU4
NmVhZWUxMTAyMzA2MDYwODA1NjFhZjkKMjAxNC0wMy0wOS0yMjo1OToxMyA4NjEwMTA1YWYz
Zjc4YTZlODZlYWVlMTEwMjMwNjA2MDgwNTYxYWY5IFNLSVAgQlJPS0VOIEJVSUxECk5vIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4Lzg2MTAxMDVh
ZjNmNzhhNmU4NmVhZWUxMTAyMzA2MDYwODA1NjFhZjkKCj09PT09PT09PSB1cHN0cmVhbSA9
PT09PT09PT0KV2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90
IGNvbm5lY3RlZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgODYxMDEwNSBSZXZlcnQg
Ing4Niwga2FzbHI6IHJhbmRvbWl6ZSBtb2R1bGUgYmFzZSBsb2FkIGFkZHJlc3MiCgpJZiB5
b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1h
eSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5j
aF9uYW1lIDg2MTAxMDUKCkhFQUQgaXMgbm93IGF0IGNhNjJlZWMuLi4gTWVyZ2UgYnJhbmNo
ICdmb3ItMy4xNC1maXhlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RqL2Nncm91cApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvbmV4dDptYXN0ZXI6Y2E2MmVlYzRl
NTI0NTkxYjgyZDllZGY3YTE4ZTNhZTZiNjkxNTE3ZDpiaXNlY3QtdXNiCgoyMDE0LTAzLTA5
LTIyOjU5OjE2IGNhNjJlZWM0ZTUyNDU5MWI4MmQ5ZWRmN2ExOGUzYWU2YjY5MTUxN2QgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtY2E2MmVlYzRlNTI0NTkxYjgyZDllZGY3
YTE4ZTNhZTZiNjkxNTE3ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjUtMDMwOTEzMjgvY2E2MmVlYzRlNTI0NTkxYjgyZDllZGY3YTE4ZTNhZTZi
NjkxNTE3ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgtY2E2MmVlYzRlNTI0NTkxYjgy
ZDllZGY3YTE4ZTNhZTZiNjkxNTE3ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LWNh
NjJlZWM0ZTUyNDU5MWI4MmQ5ZWRmN2ExOGUzYWU2YjY5MTUxN2QKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4L2NhNjJlZWM0ZTUyNDU5MWI4MmQ5ZWRm
N2ExOGUzYWU2YjY5MTUxN2Qvdm1saW51ei0zLjE0LjAtcmM1LTAwMjg3LWdjYTYyZWVjCgoy
MDE0LTAzLTA5LTIzOjA1OjE2IGRldGVjdGluZyBib290IHN0YXRlIC4uLgk0CTcJOAk5CTEz
CTE0Li4JMTYJMTcuLgkyMQkyMy4uCTI0CTMxCTM3CTQzCTQ0CTQ2CTQ3Lgk0OS4uCTUwCTUz
CTYxCTY2CTY3Lgk2OS4uLi4JNzAuCTcyCTc0CTc3Li4uCTc4CTc5Li4uCTgyCTgzLi4uLi4J
ODUuCTg2CTg3Lgk4OAk4OQk5MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09
PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGNhNjJlZWMuLi4gTWVyZ2UgYnJh
bmNoICdmb3ItMy4xNC1maXhlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RqL2Nncm91cApIRUFEIGlzIG5vdyBhdCAxYjBhN2UzLi4uIEFk
ZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMwNwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvbmV4
dDptYXN0ZXI6MWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYzpiaXNl
Y3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAxLjY5ODExNl0gS3Byb2JlIHNtb2tlIHRlc3Qg
c3RhcnRlZApbICAgIDEuNzI2ODM1XSAKWyAgICAxLjcyNzU5OV0gPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgMS43Mjc2MzNd
IFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVk
IF0KWyAgICAxLjcyNzYzM10gMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBh
N2UzICMxIE5vdCB0YWludGVkClsgICAgMS43Mjc2MzNdIC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgICAxLjcyNzYzM10ga3dv
cmtlci8wOjAvNCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDEuNzI3NjMzXSAg
KHRleHRfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGQxYzI1MzE+XSBrcHJvYmVf
b3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS43Mjc2MzNdIApbICAgIDEuNzI3NjMzXSBi
dXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICAxLjcyNzYzM10gIChtb2R1
bGVfbXV0ZXgpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmOGQxYzI0MzU+XSBrcHJvYmVfb3B0
aW1pemVyKzB4MjUvMHgyM2MKWyAgICAxLjcyNzYzM10gClsgICAgMS43Mjc2MzNdIHdoaWNo
IGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgICAxLjcyNzYzM10g
ClsgICAgMS43Mjc2MzNdIApbICAgIDEuNzI3NjMzXSB0aGUgZXhpc3RpbmcgZGVwZW5kZW5j
eSBjaGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAgMS43Mjc2MzNdIAotPiAjMiAo
bW9kdWxlX211dGV4KXsrLisuLi59OgpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZm
ZjhjY2IzYTY1Pl0gX19sb2NrX2FjcXVpcmUrMHg5MTAvMHhhMDMKWyAgICAxLjcyNzYzM10g
ICAgICAgIFs8ZmZmZmZmZmY4Y2NiNDA0Mz5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAg
ICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFiYTJmZT5dIG11dGV4X2xvY2tfbmVz
dGVkKzB4NjUvMHgzNGEKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4Y2MyZjk1
ND5dIG1vZHVsZV9hbGxvYysweDQyLzB4YjUKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZm
ZmZmZmY4Y2NkYjhlNT5dIGFsbG9jX2luc25fcGFnZSsweGUvMHgxMApbICAgIDEuNzI3NjMz
XSAgICAgICAgWzxmZmZmZmZmZjhkMWMyNzJjPl0gX19nZXRfaW5zbl9zbG90KzB4ZTAvMHgx
NjUKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFiZmE3Mz5dIGFyY2hfcHJl
cGFyZV9rcHJvYmUrMHgzNi8weGI3ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZm
OGQxYzM0MDE+XSByZWdpc3Rlcl9rcHJvYmUrMHgzMzAvMHg0OTAKWyAgICAxLjcyNzYzM10g
ICAgICAgIFs8ZmZmZmZmZmY4Y2NkNmZmMj5dIGluaXRfdGVzdF9wcm9iZXMrMHg0ZS8weDQ4
OQpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhkNzcwMTdjPl0gaW5pdF9rcHJv
YmVzKzB4MTdiLzB4MTg5ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjMDIw
ZmI+XSBkb19vbmVfaW5pdGNhbGwrMHg5Zi8weDEzNQpbICAgIDEuNzI3NjMzXSAgICAgICAg
WzxmZmZmZmZmZjhkNzU0ZjY1Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMDQvMHgxOTYK
WyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFhZGJlOT5dIGtlcm5lbF9pbml0
KzB4OS8weGQ1ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYzNjOGM+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuNzI3NjMzXSAKLT4gIzEgKGtwcm9iZV9p
bnNuX3Nsb3RzLm11dGV4KXsrLisuKy59OgpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZm
ZmZmZjhjY2IzYTY1Pl0gX19sb2NrX2FjcXVpcmUrMHg5MTAvMHhhMDMKWyAgICAxLjcyNzYz
M10gICAgICAgIFs8ZmZmZmZmZmY4Y2NiNDA0Mz5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQK
WyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFiYTJmZT5dIG11dGV4X2xvY2tf
bmVzdGVkKzB4NjUvMHgzNGEKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFj
MjY2OD5dIF9fZ2V0X2luc25fc2xvdCsweDFjLzB4MTY1ClsgICAgMS43Mjc2MzNdICAgICAg
ICBbPGZmZmZmZmZmOGQxYmZhNzM+XSBhcmNoX3ByZXBhcmVfa3Byb2JlKzB4MzYvMHhiNwpb
ICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhkMWMzNDAxPl0gcmVnaXN0ZXJfa3By
b2JlKzB4MzMwLzB4NDkwClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGNjZDZm
ZjI+XSBpbml0X3Rlc3RfcHJvYmVzKzB4NGUvMHg0ODkKWyAgICAxLjcyNzYzM10gICAgICAg
IFs8ZmZmZmZmZmY4ZDc3MDE3Yz5dIGluaXRfa3Byb2JlcysweDE3Yi8weDE4OQpbICAgIDEu
NzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhjYzAyMGZiPl0gZG9fb25lX2luaXRjYWxsKzB4
OWYvMHgxMzUKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDc1NGY2NT5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4MTA0LzB4MTk2ClsgICAgMS43Mjc2MzNdICAgICAgICBb
PGZmZmZmZmZmOGQxYWRiZTk+XSBrZXJuZWxfaW5pdCsweDkvMHhkNQpbICAgIDEuNzI3NjMz
XSAgICAgICAgWzxmZmZmZmZmZjhkMWMzYzhjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAK
WyAgICAxLjcyNzYzM10gCi0+ICMwICh0ZXh0X211dGV4KXsrLisuKy59OgpbICAgIDEuNzI3
NjMzXSAgICAgICAgWzxmZmZmZmZmZjhjY2IwZTBmPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4y
MCsweDhjZi8weGYyZQpbICAgIDEuNzI3NjMzXSAgICAgICAgWzxmZmZmZmZmZjhjY2IzYTY1
Pl0gX19sb2NrX2FjcXVpcmUrMHg5MTAvMHhhMDMKWyAgICAxLjcyNzYzM10gICAgICAgIFs8
ZmZmZmZmZmY4Y2NiNDA0Mz5dIGxvY2tfYWNxdWlyZSsweGE0LzB4YzQKWyAgICAxLjcyNzYz
M10gICAgICAgIFs8ZmZmZmZmZmY4ZDFiYTJmZT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NjUv
MHgzNGEKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4ZDFjMjUzMT5dIGtwcm9i
ZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZm
ZmY4Y2M4ZGZjND5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyMzcvMHgzZGIKWyAgICAxLjcyNzYz
M10gICAgICAgIFs8ZmZmZmZmZmY4Y2M4ZWRjMj5dIHdvcmtlcl90aHJlYWQrMHgxY2IvMHgy
YzQKWyAgICAxLjcyNzYzM10gICAgICAgIFs8ZmZmZmZmZmY4Y2M5NDk4Yj5dIGt0aHJlYWQr
MHhmMS8weGY5ClsgICAgMS43Mjc2MzNdICAgICAgICBbPGZmZmZmZmZmOGQxYzNjOGM+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDEuNzI3NjMzXSAKWyAgICAxLjcyNzYzM10g
b3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgICAxLjcyNzYz
M10gClsgICAgMS43Mjc2MzNdIENoYWluIGV4aXN0cyBvZjoKICB0ZXh0X211dGV4IC0tPiBr
cHJvYmVfaW5zbl9zbG90cy5tdXRleCAtLT4gbW9kdWxlX211dGV4CgpbICAgIDEuNzI3NjMz
XSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86ClsgICAgMS43Mjc2MzNdIApb
ICAgIDEuNzI3NjMzXSAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgQ1BVMQpbICAg
IDEuNzI3NjMzXSAgICAgICAgLS0tLSAgICAgICAgICAgICAgICAgICAgLS0tLQpbICAgIDEu
NzI3NjMzXSAgIGxvY2sobW9kdWxlX211dGV4KTsKWyAgICAxLjcyNzYzM10gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGxvY2soa3Byb2JlX2luc25fc2xvdHMubXV0ZXgpOwpb
ICAgIDEuNzI3NjMzXSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jayhtb2R1
bGVfbXV0ZXgpOwpbICAgIDEuNzI3NjMzXSAgIGxvY2sodGV4dF9tdXRleCk7ClsgICAgMS43
Mjc2MzNdIApbICAgIDEuNzI3NjMzXSAgKioqIERFQURMT0NLICoqKgpbICAgIDEuNzI3NjMz
XSAKWyAgICAxLjcyNzYzM10gNCBsb2NrcyBoZWxkIGJ5IGt3b3JrZXIvMDowLzQ6ClsgICAg
MS43Mjc2MzNdICAjMDogICgiZXZlbnRzIil7LisuKy4ufSwgYXQ6IFs8ZmZmZmZmZmY4Y2M4
ZGY1ZT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIKWyAgICAxLjcyNzYzM10gICMx
OiAgKChvcHRpbWl6aW5nX3dvcmspLndvcmspeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmOGNj
OGRmNWU+XSBwcm9jZXNzX29uZV93b3JrKzB4MWQxLzB4M2RiClsgICAgMS43Mjc2MzNdICAj
MjogIChrcHJvYmVfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmOGQxYzI0Mjc+XSBr
cHJvYmVfb3B0aW1pemVyKzB4MTcvMHgyM2MKWyAgICAxLjcyNzYzM10gICMzOiAgKG1vZHVs
ZV9tdXRleCl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4ZDFjMjQzNT5dIGtwcm9iZV9vcHRp
bWl6ZXIrMHgyNS8weDIzYwpbICAgIDEuNzI3NjMzXSAKWyAgICAxLjcyNzYzM10gc3RhY2sg
YmFja3RyYWNlOgpbICAgIDEuNzI3NjMzXSBDUFU6IDAgUElEOiA0IENvbW06IGt3b3JrZXIv
MDowIE5vdCB0YWludGVkIDMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdl
MyAjMQpbICAgIDEuNzI3NjMzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAgMS43Mjc2MzNdIFdvcmtxdWV1ZTogZXZlbnRzIGtwcm9i
ZV9vcHRpbWl6ZXIKWyAgICAxLjcyNzYzM10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAw
YzhlN2I2MCBmZmZmZmZmZjhkMWI1YjFkIGZmZmZmZmZmOGRjNjkxMTAKWyAgICAxLjcyNzYz
M10gIGZmZmY4ODAwMGM4ZTdiYTAgZmZmZmZmZmY4ZDFiMjg1MCBmZmZmODgwMDBjOGU4MGQw
IGZmZmY4ODAwMGM4ZThkOTgKWyAgICAxLjcyNzYzM10gIGZmZmY4ODAwMGM4ZTgwZDAgZmZm
Zjg4MDAwYzhlOGQ5OCAwMDAwMDAwMDAwMDAwMDA0IGZmZmY4ODAwMGM4ZThkNzAKWyAgICAx
LjcyNzYzM10gQ2FsbCBUcmFjZToKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4ZDFiNWIx
ZD5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGQx
YjI4NTA+XSBwcmludF9jaXJjdWxhcl9idWcrMHgyYjQvMHgyYzIKWyAgICAxLjcyNzYzM10g
IFs8ZmZmZmZmZmY4Y2NiMGUwZj5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMjArMHg4Y2YvMHhm
MmUKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4Y2NiM2E2NT5dIF9fbG9ja19hY3F1aXJl
KzB4OTEwLzB4YTAzClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGNjYjQwNDM+XSBsb2Nr
X2FjcXVpcmUrMHhhNC8weGM0ClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGQxYzI1MzE+
XSA/IGtwcm9iZV9vcHRpbWl6ZXIrMHgxMjEvMHgyM2MKWyAgICAxLjcyNzYzM10gIFs8ZmZm
ZmZmZmY4ZDFiYTJmZT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NjUvMHgzNGEKWyAgICAxLjcy
NzYzM10gIFs8ZmZmZmZmZmY4ZDFjMjUzMT5dID8ga3Byb2JlX29wdGltaXplcisweDEyMS8w
eDIzYwpbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhjY2IxZDhkPl0gPyB0cmFjZV9oYXJk
aXJxc19vbisweGQvMHhmClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZmOGQxYzI1MzE+XSBr
cHJvYmVfb3B0aW1pemVyKzB4MTIxLzB4MjNjClsgICAgMS43Mjc2MzNdICBbPGZmZmZmZmZm
OGNjOGRmYzQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MjM3LzB4M2RiClsgICAgMS43Mjc2MzNd
ICBbPGZmZmZmZmZmOGNjOGRmNWU+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxZDEvMHgzZGIK
WyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4ZDFiYmUwMD5dID8gX19tdXRleF91bmxvY2tf
c2xvd3BhdGgrMHhhMS8weDE0OApbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhjYzhlZGMy
Pl0gd29ya2VyX3RocmVhZCsweDFjYi8weDJjNApbICAgIDEuNzI3NjMzXSAgWzxmZmZmZmZm
ZjhjYzhlYmY3Pl0gPyByZXNjdWVyX3RocmVhZCsweDI5Yi8weDI5YgpbICAgIDEuNzI3NjMz
XSAgWzxmZmZmZmZmZjhjYzk0OThiPl0ga3RocmVhZCsweGYxLzB4ZjkKWyAgICAxLjcyNzYz
M10gIFs8ZmZmZmZmZmY4Y2M5NDg5YT5dID8ga3RocmVhZF9zdG9wKzB4NWEvMHg1YQpbICAg
IDEuNzI3NjMzXSAgWzxmZmZmZmZmZjhkMWMzYzhjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4
YjAKWyAgICAxLjcyNzYzM10gIFs8ZmZmZmZmZmY4Y2M5NDg5YT5dID8ga3RocmVhZF9zdG9w
KzB4NWEvMHg1YQpbICAgIDEuOTE0NjQ0XSBLcHJvYmUgc21va2UgdGVzdCBwYXNzZWQgc3Vj
Y2Vzc2Z1bGx5ClsgICAgMS45MTY4NzBdIGJvdW5jZSBwb29sIHNpemU6IDY0IHBhZ2VzClsg
ICAgMS45MTgxMjJdIEh1Z2VUTEIgcmVnaXN0ZXJlZCAyIE1CIHBhZ2Ugc2l6ZSwgcHJlLWFs
bG9jYXRlZCAwIHBhZ2VzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgv
MWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy15b2N0by1p
dnl0b3duMi0yNDoyMDE0MDMwOTEzNDQyNDp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMy
ODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjktZzFiMGE3ZTM6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0
OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xMToyMDE0MDMwOTEzNDQy
NDp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAz
MDctMDcxMjktZzFiMGE3ZTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkx
MzI4LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9j
dG8tbmhtNC0yOjIwMTQwMzA5MTc1MjAzOng4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEwNmQzODU4Nzk4ZTQ4
YzVhMjFkMWM3OGQzYy9kbWVzZy15b2N0by1pdnl0b3duMi0xMjoyMDE0MDMwOTE3NTI1OTp4
ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDct
MDcxMjktZzFiMGE3ZTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4
LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2cteW9jdG8t
c25iLTM2OjIwMTQwMzA5MTc1MzA2Ong4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2
ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXlvY3RvLWl2eXRvd24yLTI6MjAxNDAz
MDkxNzUxMzQ6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0
LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
NS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTMwOjIwMTQwMzA5MTM0NDExOng4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEw
NmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy1xdWFudGFsLXhnd28tMzoyMDE0MDMw
OTEzNDQwMTp4ODZfNjQtcmFuZGNvbmZpZy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQt
MjAxNDAzMDctMDcxMjktZzFiMGE3ZTM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1
LTAzMDkxMzI4LzFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1l
c2ctcXVhbnRhbC1pdnl0b3duMi0xNjoyMDE0MDMwOTEzNDM1Nzp4ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyODozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDctMDcxMjktZzFiMGE3ZTM6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXI1LTAzMDkxMzI4LzFiMGE3ZTMyNjMxNjhh
MDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzc6MjAx
NDAzMDkxNzUxNDU6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1u
ZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNj
L2RtZXNnLXF1YW50YWwteGd3by00OjIwMTQwMzA5MTM0NDExOng4Nl82NC1yYW5kY29uZmln
LXI1LTAzMDkxMzI4OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNy0wNzEyOS1nMWIwYTdlMzox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjgvMWIwYTdlMzI2MzE2OGEw
NmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy1xdWFudGFsLXN0b2FrbGV5LTQ6MjAx
NDAzMDkxNzUxMzg6eDg2XzY0LXJhbmRjb25maWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1u
ZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2UzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yNS0wMzA5MTMyOC8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNj
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTM6MjAxNDAzMDkxMzQ0MTM6eDg2XzY0LXJhbmRjb25m
aWctcjUtMDMwOTEzMjg6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3LTA3MTI5LWcxYjBhN2Uz
OjEKNToxMzoxNCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-next-20140307-07129-g1b0a7e3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc5 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
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
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
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
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
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
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=m
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_JANZ_ICAN3 is not set
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
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
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=m
# CONFIG_TEKRAM_DONGLE is not set
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=m
# CONFIG_ACT200L_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_WILINK=m
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_SPI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=m
CONFIG_NFC_MEI_PHY=m
CONFIG_NFC_SIM=y
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_MEI=m
CONFIG_NFC_MICROREAD=m
# CONFIG_NFC_MICROREAD_MEI is not set
CONFIG_NFC_MRVL=m
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=m
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_INTEL_VR_NOR=m
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
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
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=m
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=m
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
# CONFIG_MACVTAP is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_NTB_NETDEV is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=y
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_NET_VENDOR_ARC=y
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=m
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=m
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851=y
CONFIG_KS8851_MLL=m
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2K_PCI=y
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
# CONFIG_YELLOWFIN is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=m
CONFIG_MICREL_KS8995MA=m
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_3 is not set
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
# CONFIG_HISAX_ENTERNOW_PCI is not set
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
# CONFIG_ISDN_CAPI_CAPI20 is not set
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_HYSDN=m
# CONFIG_HYSDN_CAPI is not set
CONFIG_MISDN=m
# CONFIG_MISDN_DSP is not set
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
# CONFIG_MISDN_W6692 is not set
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

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
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=m
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
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
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
# CONFIG_SERIAL_CLPS711X_CONSOLE is not set
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=m
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_SPI_ALTERA=m
# CONFIG_SPI_ATMEL is not set
CONFIG_SPI_BCM2835=y
# CONFIG_SPI_BCM63XX_HSSPI is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_EP93XX=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX=m
CONFIG_SPI_FSL_DSPI=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_TI_QSPI=y
# CONFIG_SPI_OMAP_100K is not set
CONFIG_SPI_ORION=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_SH is not set
# CONFIG_SPI_SH_HSPI is not set
# CONFIG_SPI_SUN4I is not set
CONFIG_SPI_SUN6I=m
CONFIG_SPI_TEGRA114=m
# CONFIG_SPI_TEGRA20_SFLASH is not set
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=m
CONFIG_SPI_XCOMM=m
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=m
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

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
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_MXC is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=m
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set

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
# CONFIG_RCAR_THERMAL is not set
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
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=m
CONFIG_XILINX_WATCHDOG=m
CONFIG_DW_WATCHDOG=m
CONFIG_RETU_WATCHDOG=y
CONFIG_TEGRA_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=m
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
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
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=m
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_MAX14577 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

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
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
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
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_GOLDFISH=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_PCA9685=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
CONFIG_RTC_DRV_88PM80X=m
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_MAX8997=m
CONFIG_RTC_DRV_MAX77686=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=m
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=m
CONFIG_RTC_DRV_RX4581=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SCRUB_PAGES is not set
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
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
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD7266=y
CONFIG_AD7298=m
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7887=m
# CONFIG_AD7923 is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=m
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
# CONFIG_XILINX_XADC is not set

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=m
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5504=m
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=m
CONFIG_AD5755=m
CONFIG_AD5764=y
CONFIG_AD5791=m
# CONFIG_AD7303 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
CONFIG_ADXRS450=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=m

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=m
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
CONFIG_MCB=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
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

--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/WwmFnJnmDyWGHa4--
