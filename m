Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaILTCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:02:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46872 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaILTCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:02:43 -0400
Date: Fri, 12 Sep 2014 12:02:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shan Wei <davidshan@tencent.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org, bobby.prani@gmail.com,
        cl@linux.com
Subject: Re: [rcu] BUG: unable to handle kernel NULL pointer dereference at
 000000da
Message-ID: <20140912190238.GJ4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140901084403.GA18808@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140901084403.GA18808@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091219-3532-0000-0000-00000495A08E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:44:04PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit d860d40327dde251d508a234fa00bd0d90fbb656
> Author:     Shan Wei <davidshan@tencent.com>
> AuthorDate: Thu Jun 19 14:12:44 2014 -0700
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Wed Jul 9 09:15:21 2014 -0700

Hearing nothing from Shan or Pranith...

So, I am not seeing this failure in my testing, but my best guess is
that the problem is due to the fact that force_quiescent_state() is
sometimes invoked with preemption enabled, which breaks __this_cpu_read()
though perhaps with very low probability.  The common-case call (from
__call_rcu_core()) -does- have preemption disabled, in fact, it has
interrupts disabled.

So unless I hear otherwise, I will simply revert this commit.

							Thanx, Paul

>     rcu: Use __this_cpu_read() instead of per_cpu_ptr()
>     
>     The __this_cpu_read() function produces better code than does
>     per_cpu_ptr() on both ARM and x86.  For example, gcc (Ubuntu/Linaro
>     4.7.3-12ubuntu1) 4.7.3 produces the following:
>     
>     ARMv7 per_cpu_ptr():
>     
>     force_quiescent_state:
>         mov    r3, sp    @,
>         bic    r1, r3, #8128    @ tmp171,,
>         ldr    r2, .L98    @ tmp169,
>         bic    r1, r1, #63    @ tmp170, tmp171,
>         ldr    r3, [r0, #220]    @ __ptr, rsp_6(D)->rda
>         ldr    r1, [r1, #20]    @ D.35903_68->cpu, D.35903_68->cpu
>         mov    r6, r0    @ rsp, rsp
>         ldr    r2, [r2, r1, asl #2]    @ tmp173, __per_cpu_offset
>         add    r3, r3, r2    @ tmp175, __ptr, tmp173
>         ldr    r5, [r3, #12]    @ rnp_old, D.29162_13->mynode
>     
>     ARMv7 __this_cpu_read():
>     
>     force_quiescent_state:
>         ldr    r3, [r0, #220]    @ rsp_7(D)->rda, rsp_7(D)->rda
>         mov    r6, r0    @ rsp, rsp
>         add    r3, r3, #12    @ __ptr, rsp_7(D)->rda,
>         ldr    r5, [r2, r3]    @ rnp_old, *D.29176_13
>     
>     Using gcc 4.8.2:
>     
>     x86_64 per_cpu_ptr():
>     
>         movl %gs:cpu_number,%edx    # cpu_number, pscr_ret__
>         movslq    %edx, %rdx    # pscr_ret__, pscr_ret__
>         movq    __per_cpu_offset(,%rdx,8), %rdx    # __per_cpu_offset, tmp93
>         movq    %rdi, %r13    # rsp, rsp
>         movq    1000(%rdi), %rax    # rsp_9(D)->rda, __ptr
>         movq    24(%rdx,%rax), %r12    # _15->mynode, rnp_old
>     
>     x86_64 __this_cpu_read():
>     
>         movq    %rdi, %r13    # rsp, rsp
>         movq    1000(%rdi), %rax    # rsp_9(D)->rda, rsp_9(D)->rda
>         movq %gs:24(%rax),%r12    # _10->mynode, rnp_old
>     
>     Because this change produces significant benefits for these two very
>     diverse architectures, this commit makes this change.
>     
>     Signed-off-by: Shan Wei <davidshan@tencent.com>
>     Acked-by: Christoph Lameter <cl@linux.com>
>     Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>     Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> +---------------------------------------------------------------+------------+------------+------------+
> |                                                               | bc1dce514e | d860d40327 | 9687fd9101 |
> +---------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                                | 60         | 0          | 0          |
> | boot_failures                                                 | 0          | 20         | 586        |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference          | 0          | 20         |            |
> | Oops                                                          | 0          | 20         | 586        |
> | EIP_is_at_update_curr                                         | 0          | 20         |            |
> | Kernel_panic-not_syncing:Fatal_exception                      | 0          | 20         | 586        |
> | backtrace:register_tracer                                     | 0          | 20         | 586        |
> | backtrace:init_branch_tracer                                  | 0          | 20         | 586        |
> | backtrace:kernel_init_freeable                                | 0          | 20         | 586        |
> | WARNING:at_kernel/trace/ring_buffer.c:rb_reserve_next_event() | 0          | 0          | 10         |
> | BUG:spinlock_bad_magic_on_CPU                                 | 0          | 0          | 586        |
> | BUG:unable_to_handle_kernel_paging_request                    | 0          | 0          | 586        |
> | EIP_is_at_spin_dump                                           | 0          | 0          | 586        |
> | backtrace:init_irqsoff_tracer                                 | 0          | 0          | 10         |
> +---------------------------------------------------------------+------------+------------+------------+
> 
> [    0.317670] Testing tracer wakeup_dl: ret = 0
> [    0.420620] PASSED
> [    0.420978] Testing tracer branch: 
> [    0.421701] BUG: unable to handle kernel NULL pointer dereference at 000000da
> [    0.422857] IP: [<c1061074>] update_curr+0x1a3/0x2c3
> [    0.423639] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
> [    0.424000] Thread overran stack, or stack corrupted
> [    0.424000] Oops: 0000 [#1] PREEMPT 
> [    0.424000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc1-00015-gd860d40 #13
> [    0.424000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.424000] task: d2034000 ti: d2036000 task.ti: d2036000
> [    0.424000] EIP: 0060:[<c1061074>] EFLAGS: 00010046 CPU: 0
> [    0.424000] EIP is at update_curr+0x1a3/0x2c3
> [    0.424000] EAX: 00000002 EBX: 00000000 ECX: d2191000 EDX: c10a7570
> [    0.424000] ESI: d203402c EDI: c1a41714 EBP: d2037dac ESP: d2037d8c
> [    0.424000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.424000] CR0: 80050033 CR2: 000000da CR3: 01bb9000 CR4: 000406b0
> [    0.424000] Stack:
> [    0.424000]  c1959c60 0543a506 00000000 001833f6 00000000 c1a41714 d203402c 00000001
> [    0.424000]  d2037dd0 c10614ce d2191b98 d2037dc0 c106ae67 d2037dec d203402c c1a41714
> [    0.424000]  c1a416c0 d2037dec c10616df 00000001 00000001 c1a416c0 d2034000 c16bf6e0
> [    0.424000] Call Trace:
> [    0.424000]  [<c10614ce>] dequeue_entity+0x14/0x1fb
> [    0.424000]  [<c106ae67>] ? trace_hardirqs_off+0xb/0xd
> [    0.424000]  [<c10616df>] dequeue_task_fair+0x2a/0x94
> [    0.424000]  [<c105b7fc>] dequeue_task+0x9f/0xa7
> [    0.424000]  [<c105bd86>] deactivate_task+0x1c/0x1f
> [    0.424000]  [<c16ac296>] __schedule+0x1c0/0x8a1
> [    0.424000]  [<c106ad31>] ? trace_hardirqs_on+0xb/0xd
> [    0.424000]  [<c106ab81>] ? trace_hardirqs_on_caller+0x11/0x1b6
> [    0.424000]  [<c106ad31>] ? trace_hardirqs_on+0xb/0xd
> [    0.424000]  [<c16ac986>] schedule+0xf/0x11
> [    0.424000]  [<c16abd32>] schedule_timeout+0x17a/0x22e
> [    0.424000]  [<c103fc0a>] ? cascade+0x75/0x75
> [    0.424000]  [<c16abe26>] schedule_timeout_uninterruptible+0x14/0x16
> [    0.424000]  [<c1040f3f>] msleep+0x12/0x16
> [    0.424000]  [<c10a3849>] trace_selftest_startup_branch+0x34/0x72
> [    0.424000]  [<c10a3bcf>] register_tracer+0x113/0x204
> [    0.424000]  [<c1b437aa>] ? init_wakeup_tracer+0x2b/0x2b
> [    0.424000]  [<c1b437d7>] init_branch_tracer+0x2d/0x2f
> [    0.424000]  [<c1b2dc65>] do_one_initcall+0x188/0x197
> [    0.424000]  [<c1b2d400>] ? do_early_param+0x28/0x73
> [    0.424000]  [<c105159f>] ? parse_args+0x188/0x235
> [    0.424000]  [<c1b2dd4a>] kernel_init_freeable+0xd6/0x14e
> [    0.424000]  [<c1699f0c>] kernel_init+0x8/0xb8
> [    0.424000]  [<c16b0ea0>] ret_from_kernel_thread+0x20/0x30
> [    0.424000]  [<c1699f04>] ? rest_init+0x10c/0x10c
> [    0.424000] Code: ff 0d 5c 46 a3 c1 0f 84 df 00 00 00 31 db 31 c9 89 da b8 f0 b6 af c1 e8 ec 63 04 00 85 db 74 05 e8 92 75 fa ff 8b 86 d8 03 00 00 <83> b8 d8 00 00 00 00 89 45 e4 74 21 83 be dc 03 00 00 00 b8 dc
> [    0.424000] EIP: [<c1061074>] update_curr+0x1a3/0x2c3 SS:ESP 0068:d2037d8c
> [    0.424000] CR2: 00000000000000da
> [    0.424000] ---[ end trace a6f0f5be4ed0ab92 ]---
> [    0.424000] Kernel panic - not syncing: Fatal exception
> 
> git bisect start 9687fd9101afaa1c4b1de7ffd2f9d7e53f45b29f v3.16 --
> git bisect  bad ad0200f72d9875caa2023c59240ee677df66918e  # 12:13      0-     20  drivers/rtc/Kconfig: move DS2404 entry where it belongs
> git bisect  bad ed5c41d30ef2ce578fd6b6e2f7ec23f2a58b1eba  # 12:17      0-     57  x86: MCE: Add raw_lock conversion again
> git bisect  bad 19d402c1e75077e2bcfe17f7fe5bcfc8deb74991  # 12:22      0-     20  Merge branches 'x86-build-for-linus', 'x86-cleanups-for-linus' and 'x86-debug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good c7ed326fa7cafb83ced5a8b02517a61672fe9e90  # 12:37     20+     20  Merge tag 'ktest-v3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest
> git bisect good 489f50be56185fa3492690caedc099d507bf7c98  # 12:40     20+     20  Merge tag 'please-pull-misc-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
> git bisect  bad 8efb90cf1e80129fad197b916714e1d01ee183d2  # 12:45      0-     20  Merge branch 'locking-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good a45c657f28f82b056173d1afc2e7ed1f1f68829f  # 12:50     20+     20  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
> git bisect  bad 5bda4f638f36ef4c4e3b1397b02affc3db94356e  # 12:53      0-     20  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad b41d1b924d0bd41a225a17f39297b9de0dca93d9  # 12:56      0-     20  rcu: Fix a sparse warning in rcu_report_unblock_qs_rnp()
> git bisect good dfeb9765ce3c33cb3cbc5f16db423f1c58a4cc55  # 13:12     20+     20  rcu: Allow post-unlock reference for rt_mutex
> git bisect good bc1dce514e9b29b64df28a533015885862f47814  # 13:15     20+      0  rcu: Don't use NMIs to dump other CPUs' stacks
> git bisect  bad 11992c703a1c7d95f5d8759498d7617d4a504819  # 13:21      0-      3  rcu: Remove CONFIG_PROVE_RCU_DELAY
> git bisect  bad d860d40327dde251d508a234fa00bd0d90fbb656  # 13:24      0-      9  rcu: Use __this_cpu_read() instead of per_cpu_ptr()
> # first bad commit: [d860d40327dde251d508a234fa00bd0d90fbb656] rcu: Use __this_cpu_read() instead of per_cpu_ptr()
> git bisect good bc1dce514e9b29b64df28a533015885862f47814  # 13:29     60+      0  rcu: Don't use NMIs to dump other CPUs' stacks
> git bisect  bad d7cf2b3139909a354a71e2885c942e21a60ea062  # 13:29      0-     51  Add linux-next specific files for 20140829
> git bisect  bad 69e273c0b0a3c337a521d083374c918dc52c666f  # 13:29      0-     60  Linux 3.17-rc3
> git bisect  bad d7cf2b3139909a354a71e2885c942e21a60ea062  # 13:29      0-     51  Add linux-next specific files for 20140829
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64
> 	-enable-kvm
> 	-cpu Haswell,+smep,+smap
> 	-kernel $kernel
> 	-m 320
> 	-smp 2
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
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00015-gd860d40 (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #13 PREEMPT Mon Sep 1 13:22:09 CST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x1000000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
> [    0.000000]  [mem 0x12400000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
> [    0.000000]  [mem 0x10000000-0x123fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
> [    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x0238a000, 0x0238afff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x13FFFF40 000040
> [    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13ffe000
> [    0.000000]   low ram: 0 - 13ffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
> [    0.000000] BRK [0x0238b000, 0x0238bfff] PGTABLE
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000] free_area_init_node: node 0, pgdat c1af1000, node_mem_map d252b020
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 608 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1a3c480
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81180
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-x0-09010313/next:master:d860d40327dde251d508a234fa00bd0d90fbb656:bisect-linux-0/.vmlinuz-d860d40327dde251d508a234fa00bd0d90fbb656-20140901132224-2-kbuild branch=next/master BOOT_IMAGE=/kernel/i386-randconfig-x0-09010313/d860d40327dde251d508a234fa00bd0d90fbb656/vmlinuz-3.16.0-rc1-00015-gd860d40 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 279300K/327280K available (6856K kernel code, 1039K rwdata, 3540K rodata, 548K init, 7932K bss, 47980K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
> [    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
> [    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
> [    0.000000]       .init : 0xc1b2d000 - 0xc1bb6000   ( 548 kB)
> [    0.000000]       .data : 0xc16b255f - 0xc1b2bd60   (4582 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc16b255f   (6857 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] NR_IRQS:2304 nr_irqs:256 16
> [    0.000000] CPU 0 irqstacks, hard=d2002000 soft=d2004000
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 4911 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.452 MHz processor
> [    0.008000] Calibrating delay loop (skipped) preset value.. 5386.90 BogoMIPS (lpj=10773808)
> [    0.008000] pid_max: default: 4096 minimum: 301
> [    0.008000] ACPI: Core revision 20140424
> [    0.024020] ACPI: All ACPI Tables successfully acquired
> [    0.024822] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.025651] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.032062] Initializing cgroup subsys perf_event
> [    0.032780] Initializing cgroup subsys debug
> [    0.033561] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.033561] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.033561] tlb_flushall_shift: 6
> [    0.035291] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)
> [    0.043183] Performance Events: unsupported p6 CPU model 60 no PMU driver, software events only.
> [    0.045490] 
> [    0.045490] **********************************************************
> [    0.046475] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> [    0.048013] **                                                      **
> [    0.048847] ** trace_printk() being used. Allocating extra memory.  **
> [    0.049673] **                                                      **
> [    0.050475] ** This means that this is a DEBUG kernel and it is     **
> [    0.052033] ** unsafe for produciton use.                           **
> [    0.052963] **                                                      **
> [    0.053888] ** If you see this message and you are not debugging    **
> [    0.054811] ** the kernel, report this immediately to your vendor!  **
> [    0.056010] **                                                      **
> [    0.056804] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> [    0.057591] **********************************************************
> [    0.062073] Testing tracer nop: PASSED
> [    0.062756] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.064020] Getting VERSION: 1050014
> [    0.064543] Getting VERSION: 1050014
> [    0.065072] Getting ID: 0
> [    0.065464] Getting ID: f000000
> [    0.065938] Getting LVT0: 8700
> [    0.066383] Getting LVT1: 8400
> [    0.066936] enabled ExtINT on CPU#0
> [    0.069196] ENABLING IO-APIC IRQs
> [    0.069612] init IO_APIC IRQs
> [    0.069992]  apic 0 pin 0 not connected
> [    0.070489] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.072040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.073018] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.074008] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.076041] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.077170] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.078291] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.080033] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.081006] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.081962] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.084038] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.085023] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.085999] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.088040] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.089193] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.090338]  apic 0 pin 16 not connected
> [    0.090890]  apic 0 pin 17 not connected
> [    0.091452]  apic 0 pin 18 not connected
> [    0.092008]  apic 0 pin 19 not connected
> [    0.092480]  apic 0 pin 20 not connected
> [    0.092961]  apic 0 pin 21 not connected
> [    0.093429]  apic 0 pin 22 not connected
> [    0.093907]  apic 0 pin 23 not connected
> [    0.096000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.096051] TSC deadline timer enabled
> [    0.102926] Testing tracer irqsoff: PASSED
> [    0.107988] Testing tracer wakeup: ret = 0
> [    0.212168] ftrace-test (13) used greatest stack depth: 7244 bytes left
> [    0.213672] PASSED
> [    0.214679] Testing tracer wakeup_rt: ret = 0
> [    0.316593] PASSED
> [    0.317670] Testing tracer wakeup_dl: ret = 0
> [    0.420620] PASSED
> [    0.420978] Testing tracer branch: 
> [    0.421701] BUG: unable to handle kernel NULL pointer dereference at 000000da
> [    0.422857] IP: [<c1061074>] update_curr+0x1a3/0x2c3
> [    0.423639] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
> [    0.424000] Thread overran stack, or stack corrupted
> [    0.424000] Oops: 0000 [#1] PREEMPT 
> [    0.424000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc1-00015-gd860d40 #13
> [    0.424000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.424000] task: d2034000 ti: d2036000 task.ti: d2036000
> [    0.424000] EIP: 0060:[<c1061074>] EFLAGS: 00010046 CPU: 0
> [    0.424000] EIP is at update_curr+0x1a3/0x2c3
> [    0.424000] EAX: 00000002 EBX: 00000000 ECX: d2191000 EDX: c10a7570
> [    0.424000] ESI: d203402c EDI: c1a41714 EBP: d2037dac ESP: d2037d8c
> [    0.424000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.424000] CR0: 80050033 CR2: 000000da CR3: 01bb9000 CR4: 000406b0
> [    0.424000] Stack:
> [    0.424000]  c1959c60 0543a506 00000000 001833f6 00000000 c1a41714 d203402c 00000001
> [    0.424000]  d2037dd0 c10614ce d2191b98 d2037dc0 c106ae67 d2037dec d203402c c1a41714
> [    0.424000]  c1a416c0 d2037dec c10616df 00000001 00000001 c1a416c0 d2034000 c16bf6e0
> [    0.424000] Call Trace:
> [    0.424000]  [<c10614ce>] dequeue_entity+0x14/0x1fb
> [    0.424000]  [<c106ae67>] ? trace_hardirqs_off+0xb/0xd
> [    0.424000]  [<c10616df>] dequeue_task_fair+0x2a/0x94
> [    0.424000]  [<c105b7fc>] dequeue_task+0x9f/0xa7
> [    0.424000]  [<c105bd86>] deactivate_task+0x1c/0x1f
> [    0.424000]  [<c16ac296>] __schedule+0x1c0/0x8a1
> [    0.424000]  [<c106ad31>] ? trace_hardirqs_on+0xb/0xd
> [    0.424000]  [<c106ab81>] ? trace_hardirqs_on_caller+0x11/0x1b6
> [    0.424000]  [<c106ad31>] ? trace_hardirqs_on+0xb/0xd
> [    0.424000]  [<c16ac986>] schedule+0xf/0x11
> [    0.424000]  [<c16abd32>] schedule_timeout+0x17a/0x22e
> [    0.424000]  [<c103fc0a>] ? cascade+0x75/0x75
> [    0.424000]  [<c16abe26>] schedule_timeout_uninterruptible+0x14/0x16
> [    0.424000]  [<c1040f3f>] msleep+0x12/0x16
> [    0.424000]  [<c10a3849>] trace_selftest_startup_branch+0x34/0x72
> [    0.424000]  [<c10a3bcf>] register_tracer+0x113/0x204
> [    0.424000]  [<c1b437aa>] ? init_wakeup_tracer+0x2b/0x2b
> [    0.424000]  [<c1b437d7>] init_branch_tracer+0x2d/0x2f
> [    0.424000]  [<c1b2dc65>] do_one_initcall+0x188/0x197
> [    0.424000]  [<c1b2d400>] ? do_early_param+0x28/0x73
> [    0.424000]  [<c105159f>] ? parse_args+0x188/0x235
> [    0.424000]  [<c1b2dd4a>] kernel_init_freeable+0xd6/0x14e
> [    0.424000]  [<c1699f0c>] kernel_init+0x8/0xb8
> [    0.424000]  [<c16b0ea0>] ret_from_kernel_thread+0x20/0x30
> [    0.424000]  [<c1699f04>] ? rest_init+0x10c/0x10c
> [    0.424000] Code: ff 0d 5c 46 a3 c1 0f 84 df 00 00 00 31 db 31 c9 89 da b8 f0 b6 af c1 e8 ec 63 04 00 85 db 74 05 e8 92 75 fa ff 8b 86 d8 03 00 00 <83> b8 d8 00 00 00 00 89 45 e4 74 21 83 be dc 03 00 00 00 b8 dc
> [    0.424000] EIP: [<c1061074>] update_curr+0x1a3/0x2c3 SS:ESP 0068:d2037d8c
> [    0.424000] CR2: 00000000000000da
> [    0.424000] ---[ end trace a6f0f5be4ed0ab92 ]---
> [    0.424000] Kernel panic - not syncing: Fatal exception
> 
> Elapsed time: 15
> qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i386-randconfig-x0-09010313/d860d40327dde251d508a234fa00bd0d90fbb656/vmlinuz-3.16.0-rc1-00015-gd860d40 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-x0-09010313/next:master:d860d40327dde251d508a234fa00bd0d90fbb656:bisect-linux-0/.vmlinuz-d860d40327dde251d508a234fa00bd0d90fbb656-20140901132224-2-kbuild branch=next/master BOOT_IMAGE=/kernel/i386-randconfig-x0-09010313/d860d40327dde251d508a234fa00bd0d90fbb656/vmlinuz-3.16.0-rc1-00015-gd860d40 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-kbuild-8 -serial file:/dev/shm/kboot/serial-quantal-kbuild-8 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.16.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
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
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
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
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> # CONFIG_FHANDLE is not set
> CONFIG_USELIB=y
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_KTIME_SCALAR=y
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
> # CONFIG_NO_HZ is not set
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_TREE_RCU_TRACE=y
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=1
> CONFIG_RCU_BOOST_DELAY=500
> # CONFIG_RCU_NOCB_CPU is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> # CONFIG_CGROUP_DEVICE is not set
> # CONFIG_CPUSETS is not set
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_RESOURCE_COUNTERS is not set
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_CFS_BANDWIDTH=y
> # CONFIG_RT_GROUP_SCHED is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> # CONFIG_NAMESPACES is not set
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> CONFIG_SGETMASK_SYSCALL=y
> # CONFIG_SYSFS_SYSCALL is not set
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> # CONFIG_PCSPKR_PLATFORM is not set
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> # CONFIG_SIGNALFD is not set
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
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
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
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
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_CLK=y
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
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> CONFIG_CC_STACKPROTECTOR_REGULAR=y
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> # CONFIG_BLOCK is not set
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_USE_QUEUE_RWLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_X86_INTEL_LPSS=y
> CONFIG_X86_32_IRIS=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> CONFIG_MVIAC3_2=y
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> # CONFIG_CPU_SUP_AMD is not set
> # CONFIG_CPU_SUP_CENTAUR is not set
> # CONFIG_CPU_SUP_TRANSMETA_32 is not set
> CONFIG_CPU_SUP_UMC_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=1
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX32=y
> CONFIG_TOSHIBA=y
> CONFIG_I8K=y
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=y
> CONFIG_VMSPLIT_3G=y
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> # CONFIG_COMPACTION is not set
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> CONFIG_NEED_PER_CPU_KM=y
> CONFIG_CLEANCACHE=y
> # CONFIG_CMA is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_HIGHPTE is not set
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
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
> CONFIG_PM_AUTOSLEEP=y
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> # CONFIG_PM_WAKELOCKS_GC is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_ADVANCED_DEBUG is not set
> CONFIG_PM_TEST_SUSPEND=y
> CONFIG_PM_SLEEP_DEBUG=y
> # CONFIG_PM_TRACE_RTC is not set
> CONFIG_PM_CLK=y
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> # CONFIG_ACPI_THERMAL is not set
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_SBS=y
> CONFIG_ACPI_HED=y
> CONFIG_ACPI_CUSTOM_METHOD=y
> CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
> # CONFIG_ACPI_APEI is not set
> CONFIG_SFI=y
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=y
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> CONFIG_APM_DO_ENABLE=y
> # CONFIG_APM_CPU_IDLE is not set
> CONFIG_APM_DISPLAY_BLANK=y
> CONFIG_APM_ALLOW_INTS=y
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
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> # CONFIG_PCIEAER is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> # CONFIG_PCIEASPM_DEFAULT is not set
> CONFIG_PCIEASPM_POWERSAVE=y
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> CONFIG_SCx200=y
> CONFIG_SCx200HR_TIMER=y
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> # CONFIG_CARDBUS is not set
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_PCMCIA_PROBE=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> # CONFIG_BINFMT_MISC is not set
> # CONFIG_COREDUMP is not set
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_IOSF_MBI=y
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
> # CONFIG_NET_PTP_CLASSIFY is not set
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
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
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
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> # CONFIG_UEVENT_HELPER is not set
> # CONFIG_DEVTMPFS is not set
> # CONFIG_STANDALONE is not set
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
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=y
> # CONFIG_MTD_REDBOOT_PARTS is not set
> CONFIG_MTD_CMDLINE_PARTS=y
> CONFIG_MTD_AR7_PARTS=y
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_OOPS=y
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> CONFIG_MTD_CFI_ADV_OPTIONS=y
> # CONFIG_MTD_CFI_NOSWAP is not set
> # CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
> CONFIG_MTD_CFI_LE_BYTE_SWAP=y
> # CONFIG_MTD_CFI_GEOMETRY is not set
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
> # CONFIG_MTD_OTP is not set
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> # CONFIG_MTD_RAM is not set
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=y
> # CONFIG_MTD_PHYSMAP_COMPAT is not set
> CONFIG_MTD_SCx200_DOCFLASH=y
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> CONFIG_MTD_ESB2ROM=y
> CONFIG_MTD_CK804XROM=y
> CONFIG_MTD_SCB2_FLASH=y
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> CONFIG_MTD_INTEL_VR_NOR=y
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=y
> # CONFIG_MTD_PMC551_BUGFIX is not set
> CONFIG_MTD_PMC551_DEBUG=y
> CONFIG_MTD_SLRAM=y
> # CONFIG_MTD_PHRAM is not set
> # CONFIG_MTD_MTDRAM is not set
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=y
> # CONFIG_MTD_NAND_ECC_SMC is not set
> CONFIG_MTD_NAND=y
> # CONFIG_MTD_NAND_ECC_BCH is not set
> CONFIG_MTD_SM_COMMON=y
> CONFIG_MTD_NAND_DENALI=y
> CONFIG_MTD_NAND_DENALI_PCI=y
> CONFIG_MTD_NAND_DENALI_DT=y
> CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
> CONFIG_MTD_NAND_GPIO=y
> CONFIG_MTD_NAND_IDS=y
> CONFIG_MTD_NAND_RICOH=y
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> # CONFIG_MTD_NAND_DOCG4 is not set
> CONFIG_MTD_NAND_CAFE=y
> CONFIG_MTD_NAND_CS553X=y
> CONFIG_MTD_NAND_NANDSIM=y
> CONFIG_MTD_NAND_PLATFORM=y
> # CONFIG_MTD_ONENAND is not set
> 
> #
> # LPDDR & LPDDR2 PCM memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_SPI_NOR=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> # CONFIG_MTD_UBI_GLUEBI is not set
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_SERIAL=y
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
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> CONFIG_IBM_ASM=y
> # CONFIG_PHANTOM is not set
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> # CONFIG_TIFM_7XX1 is not set
> CONFIG_ICS932S401=y
> # CONFIG_ENCLOSURE_SERVICES is not set
> CONFIG_CS5535_MFGPT=y
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> CONFIG_CS5535_CLOCK_EVENT_SRC=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> # CONFIG_ISL29003 is not set
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> CONFIG_VMWARE_BALLOON=y
> # CONFIG_BMP085_I2C is not set
> CONFIG_PCH_PHUB=y
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
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
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_ECHO=y
> CONFIG_HAVE_IDE=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> CONFIG_FIREWIRE_NOSY=y
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> # CONFIG_NETDEVICES is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
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
> CONFIG_KEYBOARD_ADP5520=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> # CONFIG_KEYBOARD_QT2160 is not set
> CONFIG_KEYBOARD_LKKBD=y
> # CONFIG_KEYBOARD_GPIO is not set
> CONFIG_KEYBOARD_GPIO_POLLED=y
> CONFIG_KEYBOARD_TCA6416=y
> # CONFIG_KEYBOARD_TCA8418 is not set
> CONFIG_KEYBOARD_MATRIX=y
> # CONFIG_KEYBOARD_LM8323 is not set
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> CONFIG_KEYBOARD_MPR121=y
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=y
> # CONFIG_KEYBOARD_SAMSUNG is not set
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> CONFIG_KEYBOARD_TC3589X=y
> CONFIG_KEYBOARD_XTKBD=y
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> CONFIG_TABLET_USB_AIPTEK=y
> CONFIG_TABLET_USB_GTCO=y
> CONFIG_TABLET_USB_HANWANG=y
> CONFIG_TABLET_USB_KBTAB=y
> # CONFIG_TABLET_USB_WACOM is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_88PM860X=y
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> CONFIG_TOUCHSCREEN_ATMEL_MXT=y
> # CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
> CONFIG_TOUCHSCREEN_BU21013=y
> CONFIG_TOUCHSCREEN_CY8CTMG110=y
> CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
> # CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
> # CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
> CONFIG_TOUCHSCREEN_DYNAPRO=y
> CONFIG_TOUCHSCREEN_HAMPSHIRE=y
> # CONFIG_TOUCHSCREEN_EETI is not set
> CONFIG_TOUCHSCREEN_FUJITSU=y
> CONFIG_TOUCHSCREEN_ILI210X=y
> CONFIG_TOUCHSCREEN_GUNZE=y
> CONFIG_TOUCHSCREEN_ELO=y
> CONFIG_TOUCHSCREEN_WACOM_W8001=y
> # CONFIG_TOUCHSCREEN_WACOM_I2C is not set
> CONFIG_TOUCHSCREEN_MAX11801=y
> CONFIG_TOUCHSCREEN_MCS5000=y
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> # CONFIG_TOUCHSCREEN_MTOUCH is not set
> CONFIG_TOUCHSCREEN_INEXIO=y
> # CONFIG_TOUCHSCREEN_MK712 is not set
> # CONFIG_TOUCHSCREEN_HTCPEN is not set
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> CONFIG_TOUCHSCREEN_EDT_FT5X06=y
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> # CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
> CONFIG_TOUCHSCREEN_PIXCIR=y
> # CONFIG_TOUCHSCREEN_WM831X is not set
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> # CONFIG_TOUCHSCREEN_USB_ETURBO is not set
> # CONFIG_TOUCHSCREEN_USB_GUNZE is not set
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> # CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
> # CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> CONFIG_TOUCHSCREEN_USB_JASTEC=y
> # CONFIG_TOUCHSCREEN_USB_ELO is not set
> CONFIG_TOUCHSCREEN_USB_E2I=y
> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
> CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
> # CONFIG_TOUCHSCREEN_USB_NEXIO is not set
> CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> CONFIG_TOUCHSCREEN_ST1232=y
> CONFIG_TOUCHSCREEN_SUR40=y
> CONFIG_TOUCHSCREEN_TPS6507X=y
> CONFIG_TOUCHSCREEN_ZFORCE=y
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
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_HYPERV_KEYBOARD=y
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
> # CONFIG_SERIAL_NONSTANDARD is not set
> CONFIG_NOZOMI=y
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> # CONFIG_SERIAL_8250_PNP is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_FOURPORT is not set
> CONFIG_SERIAL_8250_ACCENT=y
> # CONFIG_SERIAL_8250_BOCA is not set
> CONFIG_SERIAL_8250_EXAR_ST16C554=y
> # CONFIG_SERIAL_8250_HUB6 is not set
> # CONFIG_SERIAL_8250_SHARE_IRQ is not set
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> # CONFIG_SERIAL_UARTLITE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> CONFIG_SERIAL_SCCNXP=y
> CONFIG_SERIAL_SCCNXP_CONSOLE=y
> CONFIG_SERIAL_SC16IS7XX=y
> CONFIG_SERIAL_TIMBERDALE=y
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> # CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
> CONFIG_SERIAL_PCH_UART=y
> CONFIG_SERIAL_PCH_UART_CONSOLE=y
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_SERIAL_FSL_LPUART=y
> CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
> CONFIG_TTY_PRINTK=y
> # CONFIG_PRINTER is not set
> # CONFIG_PPDEV is not set
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> CONFIG_DTLK=y
> CONFIG_R3964=y
> CONFIG_APPLICOM=y
> CONFIG_SONYPI=y
> CONFIG_MWAVE=y
> CONFIG_SCx200_GPIO=y
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
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
> CONFIG_I2C_MUX_PCA9541=y
> CONFIG_I2C_MUX_PCA954x=y
> CONFIG_I2C_MUX_PINCTRL=y
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> # CONFIG_I2C_AMD756 is not set
> CONFIG_I2C_AMD8111=y
> CONFIG_I2C_I801=y
> CONFIG_I2C_ISCH=y
> # CONFIG_I2C_ISMT is not set
> CONFIG_I2C_PIIX4=y
> # CONFIG_I2C_NFORCE2 is not set
> CONFIG_I2C_SIS5595=y
> CONFIG_I2C_SIS630=y
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=y
> CONFIG_I2C_VIAPRO=y
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=y
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_CBUS_GPIO is not set
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> CONFIG_I2C_DESIGNWARE_PCI=y
> CONFIG_I2C_EG20T=y
> CONFIG_I2C_GPIO=y
> # CONFIG_I2C_KEMPLD is not set
> CONFIG_I2C_OCORES=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> # CONFIG_I2C_VIPERBOARD is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_ELEKTOR=y
> # CONFIG_I2C_PCA_ISA is not set
> # CONFIG_SCx200_I2C is not set
> CONFIG_SCx200_ACB=y
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> CONFIG_SPMI=y
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI controllers
> #
> 
> #
> # HSI clients
> #
> # CONFIG_HSI_CHAR is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> # CONFIG_NTP_PPS is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> CONFIG_PPS_CLIENT_LDISC=y
> # CONFIG_PPS_CLIENT_PARPORT is not set
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_PINCTRL=y
> 
> #
> # Pin controllers
> #
> # CONFIG_PINMUX is not set
> # CONFIG_PINCONF is not set
> CONFIG_DEBUG_PINCTRL=y
> # CONFIG_PINCTRL_BAYTRAIL is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> CONFIG_GPIOLIB_IRQCHIP=y
> CONFIG_DEBUG_GPIO=y
> CONFIG_GPIO_SYSFS=y
> CONFIG_GPIO_GENERIC=y
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
> CONFIG_GPIO_LYNXPOINT=y
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> # CONFIG_GPIO_LP3943 is not set
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> # CONFIG_GPIO_PCA953X_IRQ is not set
> CONFIG_GPIO_PCF857X=y
> # CONFIG_GPIO_RC5T583 is not set
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TC3589X=y
> # CONFIG_GPIO_TPS65912 is not set
> CONFIG_GPIO_WM831X=y
> CONFIG_GPIO_WM8350=y
> CONFIG_GPIO_WM8994=y
> # CONFIG_GPIO_ADP5520 is not set
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=y
> # CONFIG_GPIO_BT8XX is not set
> CONFIG_GPIO_AMD8111=y
> # CONFIG_GPIO_INTEL_MID is not set
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=y
> # CONFIG_GPIO_TIMBERDALE is not set
> # CONFIG_GPIO_RDC321X is not set
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
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_GPIO_JANZ_TTL is not set
> # CONFIG_GPIO_TPS6586X is not set
> # CONFIG_GPIO_TPS65910 is not set
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_GPIO_VIPERBOARD is not set
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> CONFIG_W1_MASTER_DS1WM=y
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> CONFIG_W1_SLAVE_DS2408=y
> # CONFIG_W1_SLAVE_DS2408_READBACK is not set
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=y
> CONFIG_W1_SLAVE_DS2433_CRC=y
> # CONFIG_W1_SLAVE_DS2760 is not set
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> # CONFIG_WM831X_BACKUP is not set
> # CONFIG_WM831X_POWER is not set
> # CONFIG_WM8350_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_88PM860X is not set
> CONFIG_BATTERY_DS2780=y
> CONFIG_BATTERY_DS2781=y
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> # CONFIG_BATTERY_BQ27X00_I2C is not set
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> # CONFIG_BATTERY_MAX17040 is not set
> CONFIG_BATTERY_MAX17042=y
> CONFIG_CHARGER_PCF50633=y
> CONFIG_CHARGER_ISP1704=y
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_LP8727=y
> CONFIG_CHARGER_LP8788=y
> CONFIG_CHARGER_GPIO=y
> # CONFIG_CHARGER_MANAGER is not set
> CONFIG_CHARGER_MAX14577=y
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_BQ24190=y
> CONFIG_CHARGER_BQ24735=y
> # CONFIG_CHARGER_SMB347 is not set
> CONFIG_CHARGER_TPS65090=y
> CONFIG_POWER_RESET=y
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADM1021=y
> CONFIG_SENSORS_ADM1025=y
> CONFIG_SENSORS_ADM1026=y
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> # CONFIG_SENSORS_ADT7410 is not set
> CONFIG_SENSORS_ADT7411=y
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> CONFIG_SENSORS_ADT7475=y
> CONFIG_SENSORS_ASC7621=y
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> CONFIG_SENSORS_FAM15H_POWER=y
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=y
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=y
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHMD is not set
> CONFIG_SENSORS_GL518SM=y
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_IIO_HWMON=y
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_IT87=y
> CONFIG_SENSORS_JC42=y
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=y
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4222 is not set
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4260=y
> CONFIG_SENSORS_LTC4261=y
> # CONFIG_SENSORS_MAX16065 is not set
> CONFIG_SENSORS_MAX1619=y
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_LM63 is not set
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_NCT6683=y
> # CONFIG_SENSORS_NCT6775 is not set
> CONFIG_SENSORS_PCF8591=y
> CONFIG_PMBUS=y
> CONFIG_SENSORS_PMBUS=y
> # CONFIG_SENSORS_ADM1275 is not set
> # CONFIG_SENSORS_LM25066 is not set
> CONFIG_SENSORS_LTC2978=y
> CONFIG_SENSORS_MAX16064=y
> CONFIG_SENSORS_MAX34440=y
> CONFIG_SENSORS_MAX8688=y
> CONFIG_SENSORS_UCD9000=y
> CONFIG_SENSORS_UCD9200=y
> # CONFIG_SENSORS_ZL6100 is not set
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> CONFIG_SENSORS_SHTC1=y
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_DME1737=y
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_ADC128D818=y
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=y
> # CONFIG_SENSORS_TMP421 is not set
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=y
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> # CONFIG_SENSORS_WM8350 is not set
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=y
> CONFIG_SENSORS_ATK0110=y
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> CONFIG_THERMAL_EMULATION=y
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
> # CONFIG_INTEL_SOC_DTS_THERMAL is not set
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
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
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
> # CONFIG_BCMA_HOST_PCI is not set
> CONFIG_BCMA_HOST_SOC=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> # CONFIG_BCMA_DRIVER_GPIO is not set
> CONFIG_BCMA_DEBUG=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> CONFIG_MFD_BCM590XX=y
> CONFIG_MFD_AXP20X=y
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_MFD_DA9055 is not set
> CONFIG_MFD_DA9063=y
> # CONFIG_MFD_MC13XXX_I2C is not set
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_MFD_VIPERBOARD=y
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=y
> CONFIG_PCF50633_ADC=y
> # CONFIG_PCF50633_GPIO is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_RTSX_USB=y
> CONFIG_MFD_RC5T583=y
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=y
> # CONFIG_MFD_SM501 is not set
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> CONFIG_MFD_LP3943=y
> CONFIG_MFD_LP8788=y
> # CONFIG_MFD_PALMAS is not set
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> CONFIG_MFD_TPS65090=y
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS65218 is not set
> CONFIG_MFD_TPS6586X=y
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> CONFIG_MFD_TIMBERDALE=y
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_WM5102 is not set
> # CONFIG_MFD_WM5110 is not set
> # CONFIG_MFD_WM8997 is not set
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_88PM8607=y
> # CONFIG_REGULATOR_ACT8865 is not set
> CONFIG_REGULATOR_AD5398=y
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AXP20X=y
> # CONFIG_REGULATOR_BCM590XX is not set
> # CONFIG_REGULATOR_DA9063 is not set
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> # CONFIG_REGULATOR_LTC3589 is not set
> # CONFIG_REGULATOR_MAX14577 is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> # CONFIG_REGULATOR_MAX8998 is not set
> CONFIG_REGULATOR_PCF50633=y
> CONFIG_REGULATOR_PFUZE100=y
> # CONFIG_REGULATOR_RC5T583 is not set
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS6105X=y
> # CONFIG_REGULATOR_TPS62360 is not set
> # CONFIG_REGULATOR_TPS65023 is not set
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65090=y
> CONFIG_REGULATOR_TPS6586X=y
> CONFIG_REGULATOR_TPS65910=y
> # CONFIG_REGULATOR_TPS65912 is not set
> CONFIG_REGULATOR_WM831X=y
> CONFIG_REGULATOR_WM8350=y
> CONFIG_REGULATOR_WM8994=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_ALI=y
> CONFIG_AGP_ATI=y
> CONFIG_AGP_AMD=y
> # CONFIG_AGP_INTEL is not set
> # CONFIG_AGP_NVIDIA is not set
> CONFIG_AGP_SIS=y
> # CONFIG_AGP_SWORKS is not set
> CONFIG_AGP_VIA=y
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> CONFIG_VGA_SWITCHEROO=y
> 
> #
> # Direct Rendering Manager
> #
> CONFIG_DRM=y
> CONFIG_DRM_USB=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> CONFIG_DRM_I2C_SIL164=y
> CONFIG_DRM_I2C_NXP_TDA998X=y
> CONFIG_DRM_PTN3460=y
> CONFIG_DRM_TDFX=y
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_UMS=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> CONFIG_DRM_SIS=y
> CONFIG_DRM_VIA=y
> CONFIG_DRM_SAVAGE=y
> # CONFIG_DRM_VMWGFX is not set
> CONFIG_DRM_GMA500=y
> CONFIG_DRM_GMA600=y
> CONFIG_DRM_GMA3600=y
> CONFIG_DRM_UDL=y
> CONFIG_DRM_AST=y
> CONFIG_DRM_MGAG200=y
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> CONFIG_DRM_BOCHS=y
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
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
> CONFIG_FB_HECUBA=y
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
> # CONFIG_FB_PM2 is not set
> CONFIG_FB_CYBER2000=y
> # CONFIG_FB_CYBER2000_DDC is not set
> CONFIG_FB_ARC=y
> CONFIG_FB_ASILIANT=y
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_VESA=y
> CONFIG_FB_N411=y
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_OPENCORES is not set
> CONFIG_FB_S1D13XXX=y
> CONFIG_FB_NVIDIA=y
> # CONFIG_FB_NVIDIA_I2C is not set
> CONFIG_FB_NVIDIA_DEBUG=y
> # CONFIG_FB_NVIDIA_BACKLIGHT is not set
> CONFIG_FB_RIVA=y
> # CONFIG_FB_RIVA_I2C is not set
> CONFIG_FB_RIVA_DEBUG=y
> CONFIG_FB_RIVA_BACKLIGHT=y
> # CONFIG_FB_I740 is not set
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> # CONFIG_FB_MATROX_MYSTIQUE is not set
> # CONFIG_FB_MATROX_G is not set
> # CONFIG_FB_MATROX_I2C is not set
> CONFIG_FB_RADEON=y
> # CONFIG_FB_RADEON_I2C is not set
> CONFIG_FB_RADEON_BACKLIGHT=y
> CONFIG_FB_RADEON_DEBUG=y
> # CONFIG_FB_ATY128 is not set
> CONFIG_FB_ATY=y
> CONFIG_FB_ATY_CT=y
> CONFIG_FB_ATY_GENERIC_LCD=y
> CONFIG_FB_ATY_GX=y
> # CONFIG_FB_ATY_BACKLIGHT is not set
> CONFIG_FB_S3=y
> # CONFIG_FB_S3_DDC is not set
> # CONFIG_FB_SAVAGE is not set
> CONFIG_FB_SIS=y
> # CONFIG_FB_SIS_300 is not set
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=y
> CONFIG_FB_VIA_DIRECT_PROCFS=y
> # CONFIG_FB_VIA_X_COMPATIBILITY is not set
> CONFIG_FB_NEOMAGIC=y
> CONFIG_FB_KYRO=y
> CONFIG_FB_3DFX=y
> # CONFIG_FB_3DFX_ACCEL is not set
> CONFIG_FB_3DFX_I2C=y
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> CONFIG_FB_TRIDENT=y
> CONFIG_FB_ARK=y
> # CONFIG_FB_PM3 is not set
> CONFIG_FB_CARMINE=y
> CONFIG_FB_CARMINE_DRAM_EVAL=y
> # CONFIG_CARMINE_DRAM_CUSTOM is not set
> CONFIG_FB_GEODE=y
> # CONFIG_FB_GEODE_LX is not set
> # CONFIG_FB_GEODE_GX is not set
> # CONFIG_FB_GEODE_GX1 is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=y
> CONFIG_FB_AUO_K190X=y
> CONFIG_FB_AUO_K1900=y
> # CONFIG_FB_AUO_K1901 is not set
> CONFIG_FB_HYPERV=y
> CONFIG_FB_SIMPLE=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_PLATFORM=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> CONFIG_BACKLIGHT_CARILLO_RANCH=y
> CONFIG_BACKLIGHT_PWM=y
> CONFIG_BACKLIGHT_APPLE=y
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP5520=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_88PM860X is not set
> CONFIG_BACKLIGHT_PCF50633=y
> # CONFIG_BACKLIGHT_LM3630A is not set
> CONFIG_BACKLIGHT_LM3639=y
> CONFIG_BACKLIGHT_LP855X=y
> CONFIG_BACKLIGHT_LP8788=y
> CONFIG_BACKLIGHT_OT200=y
> # CONFIG_BACKLIGHT_GPIO is not set
> # CONFIG_BACKLIGHT_LV5207LP is not set
> CONFIG_BACKLIGHT_BD6107=y
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> # CONFIG_LOGO is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> CONFIG_UHID=y
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_APPLEIR=y
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CP2112=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> CONFIG_HID_ELO=y
> CONFIG_HID_EZKEY=y
> CONFIG_HID_HOLTEK=y
> # CONFIG_HOLTEK_FF is not set
> CONFIG_HID_HUION=y
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> # CONFIG_HID_GYRATION is not set
> CONFIG_HID_ICADE=y
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> # CONFIG_HID_LOGITECH_DJ is not set
> CONFIG_LOGITECH_FF=y
> CONFIG_LOGIRUMBLEPAD2_FF=y
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> # CONFIG_HID_MICROSOFT is not set
> # CONFIG_HID_MONTEREY is not set
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_NTRIG=y
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> # CONFIG_HID_PICOLCD_FB is not set
> # CONFIG_HID_PICOLCD_BACKLIGHT is not set
> CONFIG_HID_PICOLCD_LCD=y
> # CONFIG_HID_PICOLCD_LEDS is not set
> CONFIG_HID_PRIMAX=y
> CONFIG_HID_ROCCAT=y
> CONFIG_HID_SAITEK=y
> CONFIG_HID_SAMSUNG=y
> # CONFIG_HID_SONY is not set
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> # CONFIG_HID_RMI is not set
> CONFIG_HID_GREENASIA=y
> # CONFIG_GREENASIA_FF is not set
> # CONFIG_HID_HYPERV_MOUSE is not set
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THINGM is not set
> # CONFIG_HID_THRUSTMASTER is not set
> CONFIG_HID_WACOM=y
> CONFIG_HID_WIIMOTE=y
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> CONFIG_HID_PID=y
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> # CONFIG_USB_DEFAULT_PERSIST is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_OTG=y
> # CONFIG_USB_OTG_WHITELIST is not set
> CONFIG_USB_OTG_BLACKLIST_HUB=y
> CONFIG_USB_OTG_FSM=y
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB_CBAF=y
> CONFIG_USB_WUSB_CBAF_DEBUG=y
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> CONFIG_USB_OXU210HP_HCD=y
> CONFIG_USB_ISP116X_HCD=y
> CONFIG_USB_ISP1760_HCD=y
> CONFIG_USB_ISP1362_HCD=y
> CONFIG_USB_FUSBH200_HCD=y
> # CONFIG_USB_FOTG210_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> CONFIG_USB_HCD_BCMA=y
> # CONFIG_USB_HCD_SSB is not set
> # CONFIG_USB_HCD_TEST_MODE is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> CONFIG_USB_PRINTER=y
> CONFIG_USB_WDM=y
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_HOST=y
> # CONFIG_USB_MUSB_TUSB6010 is not set
> CONFIG_USB_MUSB_UX500=y
> CONFIG_USB_UX500_DMA=y
> # CONFIG_MUSB_PIO_ONLY is not set
> # CONFIG_USB_DWC3 is not set
> CONFIG_USB_DWC2=y
> CONFIG_USB_DWC2_HOST=y
> CONFIG_USB_DWC2_PLATFORM=y
> # CONFIG_USB_DWC2_PCI is not set
> 
> #
> # Gadget mode requires USB Gadget support to be enabled
> #
> # CONFIG_USB_DWC2_DEBUG is not set
> CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
> CONFIG_USB_CHIPIDEA=y
> CONFIG_USB_CHIPIDEA_HOST=y
> CONFIG_USB_CHIPIDEA_DEBUG=y
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_USS720 is not set
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> # CONFIG_USB_SERIAL_GENERIC is not set
> # CONFIG_USB_SERIAL_SIMPLE is not set
> CONFIG_USB_SERIAL_AIRCABLE=y
> CONFIG_USB_SERIAL_ARK3116=y
> CONFIG_USB_SERIAL_BELKIN=y
> CONFIG_USB_SERIAL_CH341=y
> CONFIG_USB_SERIAL_WHITEHEAT=y
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
> CONFIG_USB_SERIAL_CP210X=y
> CONFIG_USB_SERIAL_CYPRESS_M8=y
> CONFIG_USB_SERIAL_EMPEG=y
> CONFIG_USB_SERIAL_FTDI_SIO=y
> CONFIG_USB_SERIAL_VISOR=y
> # CONFIG_USB_SERIAL_IPAQ is not set
> # CONFIG_USB_SERIAL_IR is not set
> CONFIG_USB_SERIAL_EDGEPORT=y
> CONFIG_USB_SERIAL_EDGEPORT_TI=y
> # CONFIG_USB_SERIAL_F81232 is not set
> # CONFIG_USB_SERIAL_GARMIN is not set
> # CONFIG_USB_SERIAL_IPW is not set
> CONFIG_USB_SERIAL_IUU=y
> CONFIG_USB_SERIAL_KEYSPAN_PDA=y
> CONFIG_USB_SERIAL_KEYSPAN=y
> CONFIG_USB_SERIAL_KLSI=y
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> CONFIG_USB_SERIAL_MCT_U232=y
> CONFIG_USB_SERIAL_METRO=y
> CONFIG_USB_SERIAL_MOS7720=y
> # CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
> CONFIG_USB_SERIAL_MOS7840=y
> # CONFIG_USB_SERIAL_MXUPORT is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> CONFIG_USB_SERIAL_PL2303=y
> CONFIG_USB_SERIAL_OTI6858=y
> # CONFIG_USB_SERIAL_QCAUX is not set
> CONFIG_USB_SERIAL_QUALCOMM=y
> CONFIG_USB_SERIAL_SPCP8X5=y
> CONFIG_USB_SERIAL_SAFE=y
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> CONFIG_USB_SERIAL_SIERRAWIRELESS=y
> CONFIG_USB_SERIAL_SYMBOL=y
> # CONFIG_USB_SERIAL_TI is not set
> CONFIG_USB_SERIAL_CYBERJACK=y
> CONFIG_USB_SERIAL_XIRCOM=y
> CONFIG_USB_SERIAL_WWAN=y
> CONFIG_USB_SERIAL_OPTION=y
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_OPTICON is not set
> CONFIG_USB_SERIAL_XSENS_MT=y
> # CONFIG_USB_SERIAL_WISHBONE is not set
> # CONFIG_USB_SERIAL_ZTE is not set
> CONFIG_USB_SERIAL_SSU100=y
> CONFIG_USB_SERIAL_QT2=y
> # CONFIG_USB_SERIAL_DEBUG is not set
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=y
> CONFIG_USB_EMI26=y
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> CONFIG_USB_LEGOTOWER=y
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> CONFIG_USB_CYPRESS_CY7C63=y
> CONFIG_USB_CYTHERM=y
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> CONFIG_USB_LD=y
> # CONFIG_USB_TRANCEVIBRATOR is not set
> CONFIG_USB_IOWARRIOR=y
> CONFIG_USB_TEST=y
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> CONFIG_NOP_USB_XCEIV=y
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> CONFIG_USB_ISP1301=y
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_88PM860X=y
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_LM3642=y
> # CONFIG_LEDS_NET48XX is not set
> # CONFIG_LEDS_WRAP is not set
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> # CONFIG_LEDS_LP5521 is not set
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> CONFIG_LEDS_LP8501=y
> # CONFIG_LEDS_LP8788 is not set
> CONFIG_LEDS_CLEVO_MAIL=y
> CONFIG_LEDS_PCA955X=y
> # CONFIG_LEDS_PCA963X is not set
> # CONFIG_LEDS_WM831X_STATUS is not set
> CONFIG_LEDS_WM8350=y
> # CONFIG_LEDS_PWM is not set
> CONFIG_LEDS_REGULATOR=y
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_ADP5520=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_LM355x=y
> # CONFIG_LEDS_OT200 is not set
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_LEDS_TRIGGER_TRANSIENT is not set
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_AMD76X=y
> # CONFIG_EDAC_E7XXX is not set
> CONFIG_EDAC_E752X=y
> CONFIG_EDAC_I82875P=y
> CONFIG_EDAC_I82975X=y
> CONFIG_EDAC_I3000=y
> CONFIG_EDAC_I3200=y
> CONFIG_EDAC_X38=y
> CONFIG_EDAC_I5400=y
> CONFIG_EDAC_I82860=y
> CONFIG_EDAC_R82600=y
> CONFIG_EDAC_I5000=y
> # CONFIG_EDAC_I5100 is not set
> CONFIG_EDAC_I7300=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_SYSTOHC is not set
> CONFIG_RTC_DEBUG=y
> 
> #
> # RTC interfaces
> #
> # CONFIG_RTC_INTF_SYSFS is not set
> # CONFIG_RTC_INTF_PROC is not set
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_88PM860X=y
> # CONFIG_RTC_DRV_DS1307 is not set
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> CONFIG_RTC_DRV_DS3232=y
> # CONFIG_RTC_DRV_LP8788 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_MAX8998 is not set
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> # CONFIG_RTC_DRV_ISL12057 is not set
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> CONFIG_RTC_DRV_M41T80_WDT=y
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_TPS6586X=y
> CONFIG_RTC_DRV_TPS65910=y
> CONFIG_RTC_DRV_RC5T583=y
> CONFIG_RTC_DRV_S35390A=y
> CONFIG_RTC_DRV_FM3130=y
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> CONFIG_RTC_DRV_EM3027=y
> CONFIG_RTC_DRV_RV3029C2=y
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> CONFIG_RTC_DRV_DS1553=y
> # CONFIG_RTC_DRV_DS1742 is not set
> CONFIG_RTC_DRV_DA9063=y
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_MSM6242=y
> # CONFIG_RTC_DRV_BQ4802 is not set
> CONFIG_RTC_DRV_RP5C01=y
> CONFIG_RTC_DRV_V3020=y
> # CONFIG_RTC_DRV_DS2404 is not set
> CONFIG_RTC_DRV_WM831X=y
> CONFIG_RTC_DRV_WM8350=y
> CONFIG_RTC_DRV_PCF50633=y
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_MOXART is not set
> CONFIG_RTC_DRV_XGENE=y
> 
> #
> # HID Sensor RTC drivers
> #
> CONFIG_RTC_DRV_HID_SENSOR_TIME=y
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=y
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_HYPERV=y
> # CONFIG_HYPERV_BALLOON is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> CONFIG_ACER_WMI=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ALIENWARE_WMI is not set
> CONFIG_ASUS_LAPTOP=y
> CONFIG_DELL_LAPTOP=y
> CONFIG_DELL_WMI=y
> CONFIG_DELL_WMI_AIO=y
> # CONFIG_DELL_SMO8800 is not set
> CONFIG_FUJITSU_LAPTOP=y
> CONFIG_FUJITSU_LAPTOP_DEBUG=y
> CONFIG_FUJITSU_TABLET=y
> CONFIG_TC1100_WMI=y
> CONFIG_HP_ACCEL=y
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_SENSORS_HDAPS=y
> CONFIG_ACPI_WMI=y
> # CONFIG_MSI_WMI is not set
> CONFIG_TOPSTAR_LAPTOP=y
> CONFIG_ACPI_TOSHIBA=y
> CONFIG_TOSHIBA_BT_RFKILL=y
> # CONFIG_ACPI_CMPC is not set
> CONFIG_INTEL_IPS=y
> CONFIG_IBM_RTL=y
> CONFIG_SAMSUNG_LAPTOP=y
> CONFIG_MXM_WMI=y
> CONFIG_SAMSUNG_Q10=y
> CONFIG_APPLE_GMUX=y
> # CONFIG_INTEL_RST is not set
> CONFIG_INTEL_SMARTCONNECT=y
> CONFIG_PVPANIC=y
> CONFIG_CHROME_PLATFORMS=y
> # CONFIG_CHROMEOS_LAPTOP is not set
> CONFIG_CHROMEOS_PSTORE=y
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> CONFIG_CLKDEV_LOOKUP=y
> CONFIG_HAVE_CLK_PREPARE=y
> CONFIG_COMMON_CLK=y
> 
> #
> # Common Clock Framework
> #
> CONFIG_COMMON_CLK_WM831X=y
> CONFIG_COMMON_CLK_SI5351=y
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
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
> # CONFIG_STE_MODEM_RPROC is not set
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
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
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
> CONFIG_EXTCON_ADC_JACK=y
> # CONFIG_EXTCON_MAX14577 is not set
> # CONFIG_MEMORY is not set
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
> # CONFIG_BMA180 is not set
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_MMA8452=y
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD799X=y
> CONFIG_LP8788_ADC=y
> CONFIG_MAX1363=y
> CONFIG_MCP3422=y
> CONFIG_NAU7802=y
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> CONFIG_VIPERBOARD_ADC=y
> 
> #
> # Amplifiers
> #
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=y
> CONFIG_AD5380=y
> # CONFIG_AD5446 is not set
> # CONFIG_MAX517 is not set
> # CONFIG_MCP4725 is not set
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
> # CONFIG_HID_SENSOR_GYRO_3D is not set
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_ITG3200=y
> 
> #
> # Humidity sensors
> #
> # CONFIG_DHT11 is not set
> CONFIG_SI7005=y
> 
> #
> # Inertial measurement units
> #
> CONFIG_INV_MPU6050_IIO=y
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_APDS9300=y
> CONFIG_CM32181=y
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> # CONFIG_HID_SENSOR_ALS is not set
> CONFIG_HID_SENSOR_PROX=y
> # CONFIG_LTR501 is not set
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
> # CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Inclinometer sensors
> #
> # CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
> # CONFIG_HID_SENSOR_DEVICE_ROTATION is not set
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
> # CONFIG_HID_SENSOR_PRESS is not set
> CONFIG_MPL115=y
> CONFIG_MPL3115=y
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> 
> #
> # Lightning sensors
> #
> 
> #
> # Temperature sensors
> #
> CONFIG_MLX90614=y
> # CONFIG_TMP006 is not set
> # CONFIG_NTB is not set
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> # CONFIG_VME_CA91CX42 is not set
> CONFIG_VME_TSI148=y
> 
> #
> # VME Board Drivers
> #
> # CONFIG_VMIVME_7805 is not set
> 
> #
> # VME Device Drivers
> #
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> CONFIG_PWM_LP3943=y
> CONFIG_PWM_LPSS=y
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> CONFIG_FMC=y
> # CONFIG_FMC_FAKEDEV is not set
> # CONFIG_FMC_TRIVIAL is not set
> CONFIG_FMC_WRITE_EEPROM=y
> # CONFIG_FMC_CHARDEV is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_PHY_SAMSUNG_USB2=y
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> CONFIG_DCDBAS=y
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> CONFIG_ISCSI_IBFT_FIND=y
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
> # CONFIG_FS_POSIX_ACL is not set
> # CONFIG_FILE_LOCKING is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> # CONFIG_PROC_VMCORE is not set
> CONFIG_PROC_SYSCTL=y
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> # CONFIG_JFFS2_FS_WBUF_VERIFY is not set
> CONFIG_JFFS2_SUMMARY=y
> # CONFIG_JFFS2_FS_XATTR is not set
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> # CONFIG_JFFS2_ZLIB is not set
> CONFIG_JFFS2_LZO=y
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_JFFS2_CMODE_NONE is not set
> # CONFIG_JFFS2_CMODE_PRIORITY is not set
> # CONFIG_JFFS2_CMODE_SIZE is not set
> CONFIG_JFFS2_CMODE_FAVOURLZO=y
> CONFIG_UBIFS_FS=y
> CONFIG_UBIFS_FS_ADVANCED_COMPR=y
> # CONFIG_UBIFS_FS_LZO is not set
> # CONFIG_UBIFS_FS_ZLIB is not set
> # CONFIG_LOGFS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> # CONFIG_NLS_CODEPAGE_737 is not set
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> CONFIG_NLS_CODEPAGE_852=y
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> # CONFIG_NLS_CODEPAGE_862 is not set
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> # CONFIG_NLS_CODEPAGE_866 is not set
> CONFIG_NLS_CODEPAGE_869=y
> # CONFIG_NLS_CODEPAGE_936 is not set
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> # CONFIG_NLS_ISO8859_6 is not set
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=y
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> # CONFIG_NLS_MAC_ROMANIAN is not set
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
> CONFIG_BOOT_PRINTK_DELAY=y
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
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
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VM_VMACACHE=y
> CONFIG_DEBUG_VM_RB=y
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
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
> CONFIG_SCHEDSTATS=y
> # CONFIG_TIMER_STATS is not set
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_LOCK_TORTURE_TEST=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> CONFIG_DEBUG_CREDENTIALS=y
> 
> #
> # RCU Debugging
> #
> CONFIG_PROVE_RCU=y
> CONFIG_PROVE_RCU_REPEATEDLY=y
> # CONFIG_PROVE_RCU_DELAY is not set
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> CONFIG_RCU_CPU_STALL_INFO=y
> CONFIG_RCU_TRACE=y
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_PM_NOTIFIER_ERROR_INJECT=y
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAIL_PAGE_ALLOC=y
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> CONFIG_LATENCYTOP=y
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
> # CONFIG_FUNCTION_TRACER is not set
> CONFIG_IRQSOFF_TRACER=y
> # CONFIG_PREEMPT_TRACER is not set
> CONFIG_SCHED_TRACER=y
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> CONFIG_PROFILE_ANNOTATED_BRANCHES=y
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> # CONFIG_STACK_TRACER is not set
> # CONFIG_UPROBE_EVENT is not set
> # CONFIG_PROBE_EVENTS is not set
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y
> # CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> # CONFIG_EARLY_PRINTK is not set
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_DOUBLEFAULT is not set
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
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
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
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
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> # CONFIG_CRYPTO_MD5 is not set
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> CONFIG_CRYPTO_TEA=y
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> # CONFIG_CRYPTO_LZO is not set
> CONFIG_CRYPTO_LZ4=y
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_RATIONAL=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> # CONFIG_CRC_CCITT is not set
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
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> # CONFIG_XZ_DEC_IA64 is not set
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=y
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> # CONFIG_CORDIC is not set
> CONFIG_DDR=y

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

