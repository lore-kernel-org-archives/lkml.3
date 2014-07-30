Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaG3R4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:56:14 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40551 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaG3R4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140730055333.GA29881@localhost>
References: <20140730040008.GF16537@localhost>
	<CABPqkBRcCVjohrYGCo0XuiAAaSGscLnjsgttvGB7EkdxgX1t5w@mail.gmail.com>
	<20140730055333.GA29881@localhost>
Date: Wed, 30 Jul 2014 19:56:11 +0200
Message-ID: <CABPqkBR-==vga4ZsaiLPB2SAGJvd4=BJ3ArkSuSDYexSQC+w+Q@mail.gmail.com>
Subject: Re: [perf/x86/RAPL] BUG: unable to handle kernel NULL pointer
 dereference at 00000028
From: Stephane Eranian <eranian@google.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 7:53 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Wed, Jul 30, 2014 at 06:45:58AM +0200, Stephane Eranian wrote:
>> On Wed, Jul 30, 2014 at 6:00 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > Greetings,
>> >
>> > 0day kernel testing robot got the below dmesg and the first bad commit is
>> >
>> Is this booting a guest kernel or native?
>
> It's a guest kernel.
>
>> What is the  host CPU?
>
> The host CPU is E5-2680, Sandy Bridge-EP.
>
I thought this problem had already be mentioned a while back.

See https://lkml.org/lkml/2014/3/6/685
And https://lkml.org/lkml/2014/4/23/512

So what you are telling here is that those two fixes never made it or
that you are
running an older kernel.


> Thanks,
> Fengguang
>
>> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> > commit 4788e5b4b2338f85fa42a712a182d8afd65d7c58
>> > Author:     Stephane Eranian <eranian@google.com>
>> > AuthorDate: Tue Nov 12 17:58:50 2013 +0100
>> > Commit:     Ingo Molnar <mingo@kernel.org>
>> > CommitDate: Wed Nov 27 11:16:40 2013 +0100
>> >
>> >     perf/x86: Add Intel RAPL PMU support
>> >
>> >     This patch adds a new uncore PMU to expose the Intel
>> >     RAPL energy consumption counters. Up to 3 counters,
>> >     each counting a particular RAPL event are exposed.
>> >
>> >     The RAPL counters are available on Intel SandyBridge,
>> >     IvyBridge, Haswell. The server skus add a 3rd counter.
>> >
>> >     The following events are available and exposed in sysfs:
>> >
>> >       - power/energy-cores: power consumption of all cores on socket
>> >       - power/energy-pkg: power consumption of all cores + LLc cache
>> >       - power/energy-dram: power consumption of DRAM (servers only)
>> >
>> >     For each event both the unit (Joules) and scale (2^-32 J)
>> >     is exposed in sysfs for use by perf stat and other tools.
>> >     The files are:
>> >
>> >         /sys/devices/power/events/energy-*.unit
>> >         /sys/devices/power/events/energy-*.scale
>> >
>> >     The RAPL PMU is uncore by nature and is implemented such
>> >     that it only works in system-wide mode. Measuring only
>> >     one CPU per socket is sufficient. The /sys/devices/power/cpumask
>> >     file can be used by tools to figure out which CPUs to monitor
>> >     by default. For instance, on a 2-socket system, 2 CPUs
>> >     (one on each socket) will be shown.
>> >
>> >     All the counters measure in the same unit (exposed via sysfs).
>> >     The perf_events API exposes all RAPL counters as 64-bit integers
>> >     counting in unit of 1/2^32 Joules (about 0.23 nJ). User level tools
>> >     must convert the counts by multiplying them by 2^-32 to obtain
>> >     Joules. The reason for this is that the kernel avoids
>> >     doing floating point math whenever possible because it is
>> >     expensive (user floating-point state must be saved). The method
>> >     used avoids kernel floating-point usage. There is no loss of
>> >     precision. Thanks to PeterZ for suggesting this approach.
>> >
>> >     To convert the raw count in Watt:
>> >        W = C * 2.3 / (1e10 * time)
>> >     or ldexp(C, -32).
>> >
>> >     RAPL PMU is a new standalone PMU which registers with the
>> >     perf_event core subsystem. The PMU type (attr->type) is
>> >     dynamically allocated and is available from /sys/device/power/type.
>> >
>> >     Sampling is not supported by the RAPL PMU. There is no
>> >     privilege level filtering either.
>> >
>> >     Signed-off-by: Stephane Eranian <eranian@google.com>
>> >     Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>> >     Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> >     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> >     Cc: acme@redhat.com
>> >     Cc: jolsa@redhat.com
>> >     Cc: zheng.z.yan@intel.com
>> >     Cc: bp@alien8.de
>> >     Link: http://lkml.kernel.org/r/1384275531-10892-4-git-send-email-eranian@google.com
>> >     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> >
>> > +-----------------------------------------------------------+------------+------------+---------------+
>> > |                                                           | 410136f5dd | 4788e5b4b2 | next-20140724 |
>> > +-----------------------------------------------------------+------------+------------+---------------+
>> > | boot_successes                                            | 1000       | 751        | 78            |
>> > | boot_failures                                             | 0          | 149        | 3             |
>> > | BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 0          | 132        | 2             |
>> > | Oops                                                      | 0          | 132        | 2             |
>> > | EIP_is_at_rapl_pmu_init                                   | 0          | 132        |               |
>> > | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 132        | 2             |
>> > | backtrace:rapl_pmu_init                                   | 0          | 132        |               |
>> > | backtrace:kernel_init_freeable                            | 0          | 132        | 2             |
>> > | BUG:kernel_boot_hang                                      | 0          | 17         | 1             |
>> > | EIP_is_at_validate_chain                                  | 0          | 0          | 2             |
>> > | backtrace:free_reserved_area                              | 0          | 0          | 2             |
>> > | backtrace:free_init_pages                                 | 0          | 0          | 2             |
>> > | backtrace:populate_rootfs                                 | 0          | 0          | 2             |
>> > +-----------------------------------------------------------+------------+------------+---------------+
>> >
>> > [    0.613305] PCI: CLS 0 bytes, default 64
>> > [    0.614699] Unpacking initramfs...
>> > [    0.732188] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
>> > [    0.733895] BUG: unable to handle kernel NULL pointer dereference at 00000028
>> > [    0.735603] IP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139
>> > [    0.736012] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
>> > [    0.736012] Oops: 0000 [#1] PREEMPT
>> > [    0.736012] Modules linked in:
>> > [    0.736012] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-05711-g4788e5b #11
>> > [    0.736012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> > [    0.736012] task: d244c020 ti: d244e000 task.ti: d244e000
>> > [    0.736012] EIP: 0060:[<c09b20cb>] EFLAGS: 00010202 CPU: 0
>> > [    0.736012] EIP is at rapl_pmu_init+0x11e/0x139
>> > [    0.736012] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
>> > [    0.736012] ESI: c09b1fad EDI: 000000cc EBP: d244ff00 ESP: d244fef0
>> > [    0.736012]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> > [    0.736012] CR0: 80050033 CR2: 00000028 CR3: 00a16000 CR4: 000406b0
>> > [    0.736012] Stack:
>> > [    0.736012]  c04ddabe 00000000 00000002 00000000 d244ff74 c0200477 c0251b16 d244ff2c
>> > [    0.736012]  c025467d d3ff63cb d244ff34 c02410cb d3ff63cb d244ff00 c09aa512 c080d71c
>> > [    0.736012]  000000cc d244ff74 c02412d5 c0829fe0 00000286 c023b6d8 00000246 00060006
>> > [    0.736012] Call Trace:
>> > [    0.736012]  [<c04ddabe>] ? register_syscore_ops+0x32/0x35
>> > [    0.736012]  [<c0200477>] do_one_initcall+0xdf/0x138
>> > [    0.736012]  [<c0251b16>] ? lock_release_holdtime.part.20+0x93/0xf8
>> > [    0.736012]  [<c025467d>] ? trace_hardirqs_on_caller+0xeb/0x1ad
>> > [    0.736012]  [<c02410cb>] ? parameq+0x13/0x5e
>> > [    0.736012]  [<c09aa512>] ? repair_env_string+0x12/0x51
>> > [    0.736012]  [<c02412d5>] ? parse_args+0x1bf/0x2f8
>> > [    0.736012]  [<c023b6d8>] ? __usermodehelper_set_disable_depth+0x3e/0x44
>> > [    0.736012]  [<c09aab46>] kernel_init_freeable+0xde/0x178
>> > [    0.736012]  [<c09aa500>] ? do_early_param+0x78/0x78
>> > [    0.736012]  [<c064bd10>] kernel_init+0xb/0xed
>> > [    0.736012]  [<c0249199>] ? schedule_tail+0xc/0x3a
>> > [    0.736012]  [<c0659637>] ret_from_kernel_thread+0x1b/0x28
>> > [    0.736012]  [<c064bd05>] ? rest_init+0xb5/0xb5
>> > [    0.736012] Code: 99 87 ff 89 5c 24 04 c7 04 24 90 bf 76 c0 e8 dd e9 c9 ff 83 c8 ff eb 28 a1 44 bc a1 c0 f3 0f b8 c0 90 89 44 24 08 a1 80 73 82 c0 <8b> 40 28 89 44 24 04 c7 04 24 d4 bf 76 c0 e8 b2 e9 c9 ff 31 c0
>> > [    0.736012] EIP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139 SS:ESP 0068:d244fef0
>> > [    0.736012] CR2: 0000000000000028
>> > [    0.736012] ---[ end trace 0a81712c9fb36a0a ]---
>> > [    0.736012] swapper (1) used greatest stack depth: 5800 bytes left
>> >
>> > git bisect start v3.14 v3.13 --
>> > git bisect  bad 09df7c4c8097ca4a11393b1edd4997d786daad52  # 16:18      0-      3  x86: Remove CONFIG_X86_OOSTORE
>> > git bisect  bad 15c81026204da897a05424c79263aea861a782cc  # 16:24      2-      5  Merge branch 'x86-x32-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > git bisect  bad a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8  # 16:33      0-     15  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > git bisect good edde1fb8c41d0db7c8ce17fb32886da2e389b0cc  # 17:48    900+      0  Merge tag 'localmodconfig-v3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig
>> > git bisect good a693c46e14c9fdadbcd68ddfa94a4f72495531a9  # 17:55    900+      0  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > git bisect good 2cc3f16cad1561c6fc551aefff559e53726efc8b  # 18:12    900+      0  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > git bisect  bad 9326657abe1a83ed4b4f396b923ca1217fd50cba  # 18:21      9-      2  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > git bisect  bad 7bb73553e2490ac6667387ee723e0faa61e9d999  # 18:38      0-      1  tools lib traceevent: Get rid of die() in reparent_op_arg()
>> > git bisect  bad 3d7c0144491bd8c21d53b43032274a85efdfe434  # 18:41     11-      4  perf tools: Add build and install plugins targets
>> > git bisect  bad ba1ddf42f3c3af111d3adee277534f73c1ef6a9b  # 18:43      0-     15  perf script: Print mmap[2] events also
>> > git bisect  bad a8b4c7014cadfdacd4e1f4c963128593be6f20de  # 18:49      0-      2  perf completion: Rename file to reflect zsh support
>> > git bisect  bad 4788e5b4b2338f85fa42a712a182d8afd65d7c58  # 18:53      0-      1  perf/x86: Add Intel RAPL PMU support
>> > git bisect good c912dae60ae6f659455f239298110adc67a5f3e9  # 19:33    900+     14  uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
>> > git bisect good 09897d78dbc3a544426f2272b5601c62922ccab9  # 19:44    900+      0  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
>> > git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:52    900+      0  tools/perf/stat: Add event unit and scale support
>> > # first bad commit: [4788e5b4b2338f85fa42a712a182d8afd65d7c58] perf/x86: Add Intel RAPL PMU support
>> > git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:56   1000+      0  tools/perf/stat: Add event unit and scale support
>> > git bisect  bad 1a58d9909611972fd1c081bb04a9f7dc2571e612  # 19:58      0-      3  Add linux-next specific files for 20140724
>> > git bisect  bad 82e13c71bc655b6dc7110da4e164079dadb44892  # 20:07    448-     10  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
>> > git bisect  bad 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 20:14      2-      6  Add linux-next specific files for 20140725
>> >
>> >
>> > This script may reproduce the error.
>> >
>> > ----------------------------------------------------------------------------
>> > #!/bin/bash
>> >
>> > kernel=$1
>> > initrd=yocto-minimal-i386.cgz
>> >
>> > wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>> >
>> > kvm=(
>> >         qemu-system-x86_64
>> >         -enable-kvm
>> >         -cpu Haswell,+smep,+smap
>> >         -kernel $kernel
>> >         -initrd $initrd
>> >         -m 320
>> >         -smp 1
>> >         -net nic,vlan=1,model=e1000
>> >         -net user,vlan=1
>> >         -boot order=nc
>> >         -no-reboot
>> >         -watchdog i6300esb
>> >         -rtc base=localtime
>> >         -serial stdio
>> >         -display none
>> >         -monitor null
>> > )
>> >
>> > append=(
>> >         hung_task_panic=1
>> >         earlyprintk=ttyS0,115200
>> >         debug
>> >         apic=debug
>> >         sysrq_always_enabled
>> >         rcupdate.rcu_cpu_stall_timeout=100
>> >         panic=10
>> >         softlockup_panic=1
>> >         nmi_watchdog=panic
>> >         prompt_ramdisk=0
>> >         console=ttyS0,115200
>> >         console=tty0
>> >         vga=normal
>> >         root=/dev/ram0
>> >         rw
>> >         drbd.minor_count=8
>> > )
>> >
>> > "${kvm[@]}" --append "${append[*]}"
>> > ----------------------------------------------------------------------------
>> >
>> > Thanks,
>> > Fengguang
>> >
>> > _______________________________________________
>> > LKP mailing list
>> > LKP@linux.intel.com
>> >
