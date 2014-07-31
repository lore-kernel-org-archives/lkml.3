Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaGaCc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:32:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:63474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaGaCc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:32:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="569750503"
Date: Thu, 31 Jul 2014 10:32:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [perf/x86/RAPL] BUG: unable to handle kernel NULL pointer
 dereference at 00000028
Message-ID: <20140731023233.GA1259@localhost>
References: <20140730040008.GF16537@localhost>
 <CABPqkBRcCVjohrYGCo0XuiAAaSGscLnjsgttvGB7EkdxgX1t5w@mail.gmail.com>
 <20140730055333.GA29881@localhost>
 <CABPqkBR-==vga4ZsaiLPB2SAGJvd4=BJ3ArkSuSDYexSQC+w+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <CABPqkBR-==vga4ZsaiLPB2SAGJvd4=BJ3ArkSuSDYexSQC+w+Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stephane,

On Wed, Jul 30, 2014 at 07:56:11PM +0200, Stephane Eranian wrote:
> On Wed, Jul 30, 2014 at 7:53 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Wed, Jul 30, 2014 at 06:45:58AM +0200, Stephane Eranian wrote:
> >> On Wed, Jul 30, 2014 at 6:00 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> > Greetings,
> >> >
> >> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >> >
> >> Is this booting a guest kernel or native?
> >
> > It's a guest kernel.
> >
> >> What is the  host CPU?
> >
> > The host CPU is E5-2680, Sandy Bridge-EP.
> >
> I thought this problem had already be mentioned a while back.
> 
> See https://lkml.org/lkml/2014/3/6/685
> And https://lkml.org/lkml/2014/4/23/512
> 
> So what you are telling here is that those two fixes never made it or
> that you are
> running an older kernel.

I just checked linux-next and find that the bug in rapl_pmu_init() has
been fixed. linux-next happen to have the same "BUG: unable to handle
kernel NULL pointer dereference" message but at another function
validate_chain().. Attached is the dmesg in linux-next.

Sorry for the noise! 

Thanks,
Fengguang

> >> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> >> > commit 4788e5b4b2338f85fa42a712a182d8afd65d7c58
> >> > Author:     Stephane Eranian <eranian@google.com>
> >> > AuthorDate: Tue Nov 12 17:58:50 2013 +0100
> >> > Commit:     Ingo Molnar <mingo@kernel.org>
> >> > CommitDate: Wed Nov 27 11:16:40 2013 +0100
> >> >
> >> >     perf/x86: Add Intel RAPL PMU support
> >> >
> >> >     This patch adds a new uncore PMU to expose the Intel
> >> >     RAPL energy consumption counters. Up to 3 counters,
> >> >     each counting a particular RAPL event are exposed.
> >> >
> >> >     The RAPL counters are available on Intel SandyBridge,
> >> >     IvyBridge, Haswell. The server skus add a 3rd counter.
> >> >
> >> >     The following events are available and exposed in sysfs:
> >> >
> >> >       - power/energy-cores: power consumption of all cores on socket
> >> >       - power/energy-pkg: power consumption of all cores + LLc cache
> >> >       - power/energy-dram: power consumption of DRAM (servers only)
> >> >
> >> >     For each event both the unit (Joules) and scale (2^-32 J)
> >> >     is exposed in sysfs for use by perf stat and other tools.
> >> >     The files are:
> >> >
> >> >         /sys/devices/power/events/energy-*.unit
> >> >         /sys/devices/power/events/energy-*.scale
> >> >
> >> >     The RAPL PMU is uncore by nature and is implemented such
> >> >     that it only works in system-wide mode. Measuring only
> >> >     one CPU per socket is sufficient. The /sys/devices/power/cpumask
> >> >     file can be used by tools to figure out which CPUs to monitor
> >> >     by default. For instance, on a 2-socket system, 2 CPUs
> >> >     (one on each socket) will be shown.
> >> >
> >> >     All the counters measure in the same unit (exposed via sysfs).
> >> >     The perf_events API exposes all RAPL counters as 64-bit integers
> >> >     counting in unit of 1/2^32 Joules (about 0.23 nJ). User level tools
> >> >     must convert the counts by multiplying them by 2^-32 to obtain
> >> >     Joules. The reason for this is that the kernel avoids
> >> >     doing floating point math whenever possible because it is
> >> >     expensive (user floating-point state must be saved). The method
> >> >     used avoids kernel floating-point usage. There is no loss of
> >> >     precision. Thanks to PeterZ for suggesting this approach.
> >> >
> >> >     To convert the raw count in Watt:
> >> >        W = C * 2.3 / (1e10 * time)
> >> >     or ldexp(C, -32).
> >> >
> >> >     RAPL PMU is a new standalone PMU which registers with the
> >> >     perf_event core subsystem. The PMU type (attr->type) is
> >> >     dynamically allocated and is available from /sys/device/power/type.
> >> >
> >> >     Sampling is not supported by the RAPL PMU. There is no
> >> >     privilege level filtering either.
> >> >
> >> >     Signed-off-by: Stephane Eranian <eranian@google.com>
> >> >     Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> >> >     Reviewed-by: Andi Kleen <ak@linux.intel.com>
> >> >     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >> >     Cc: acme@redhat.com
> >> >     Cc: jolsa@redhat.com
> >> >     Cc: zheng.z.yan@intel.com
> >> >     Cc: bp@alien8.de
> >> >     Link: http://lkml.kernel.org/r/1384275531-10892-4-git-send-email-eranian@google.com
> >> >     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> >> >
> >> > +-----------------------------------------------------------+------------+------------+---------------+
> >> > |                                                           | 410136f5dd | 4788e5b4b2 | next-20140724 |
> >> > +-----------------------------------------------------------+------------+------------+---------------+
> >> > | boot_successes                                            | 1000       | 751        | 78            |
> >> > | boot_failures                                             | 0          | 149        | 3             |
> >> > | BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 0          | 132        | 2             |
> >> > | Oops                                                      | 0          | 132        | 2             |
> >> > | EIP_is_at_rapl_pmu_init                                   | 0          | 132        |               |
> >> > | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 132        | 2             |
> >> > | backtrace:rapl_pmu_init                                   | 0          | 132        |               |
> >> > | backtrace:kernel_init_freeable                            | 0          | 132        | 2             |
> >> > | BUG:kernel_boot_hang                                      | 0          | 17         | 1             |
> >> > | EIP_is_at_validate_chain                                  | 0          | 0          | 2             |
> >> > | backtrace:free_reserved_area                              | 0          | 0          | 2             |
> >> > | backtrace:free_init_pages                                 | 0          | 0          | 2             |
> >> > | backtrace:populate_rootfs                                 | 0          | 0          | 2             |
> >> > +-----------------------------------------------------------+------------+------------+---------------+
> >> >
> >> > [    0.613305] PCI: CLS 0 bytes, default 64
> >> > [    0.614699] Unpacking initramfs...
> >> > [    0.732188] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
> >> > [    0.733895] BUG: unable to handle kernel NULL pointer dereference at 00000028
> >> > [    0.735603] IP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139
> >> > [    0.736012] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> >> > [    0.736012] Oops: 0000 [#1] PREEMPT
> >> > [    0.736012] Modules linked in:
> >> > [    0.736012] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-05711-g4788e5b #11
> >> > [    0.736012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >> > [    0.736012] task: d244c020 ti: d244e000 task.ti: d244e000
> >> > [    0.736012] EIP: 0060:[<c09b20cb>] EFLAGS: 00010202 CPU: 0
> >> > [    0.736012] EIP is at rapl_pmu_init+0x11e/0x139
> >> > [    0.736012] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
> >> > [    0.736012] ESI: c09b1fad EDI: 000000cc EBP: d244ff00 ESP: d244fef0
> >> > [    0.736012]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> >> > [    0.736012] CR0: 80050033 CR2: 00000028 CR3: 00a16000 CR4: 000406b0
> >> > [    0.736012] Stack:
> >> > [    0.736012]  c04ddabe 00000000 00000002 00000000 d244ff74 c0200477 c0251b16 d244ff2c
> >> > [    0.736012]  c025467d d3ff63cb d244ff34 c02410cb d3ff63cb d244ff00 c09aa512 c080d71c
> >> > [    0.736012]  000000cc d244ff74 c02412d5 c0829fe0 00000286 c023b6d8 00000246 00060006
> >> > [    0.736012] Call Trace:
> >> > [    0.736012]  [<c04ddabe>] ? register_syscore_ops+0x32/0x35
> >> > [    0.736012]  [<c0200477>] do_one_initcall+0xdf/0x138
> >> > [    0.736012]  [<c0251b16>] ? lock_release_holdtime.part.20+0x93/0xf8
> >> > [    0.736012]  [<c025467d>] ? trace_hardirqs_on_caller+0xeb/0x1ad
> >> > [    0.736012]  [<c02410cb>] ? parameq+0x13/0x5e
> >> > [    0.736012]  [<c09aa512>] ? repair_env_string+0x12/0x51
> >> > [    0.736012]  [<c02412d5>] ? parse_args+0x1bf/0x2f8
> >> > [    0.736012]  [<c023b6d8>] ? __usermodehelper_set_disable_depth+0x3e/0x44
> >> > [    0.736012]  [<c09aab46>] kernel_init_freeable+0xde/0x178
> >> > [    0.736012]  [<c09aa500>] ? do_early_param+0x78/0x78
> >> > [    0.736012]  [<c064bd10>] kernel_init+0xb/0xed
> >> > [    0.736012]  [<c0249199>] ? schedule_tail+0xc/0x3a
> >> > [    0.736012]  [<c0659637>] ret_from_kernel_thread+0x1b/0x28
> >> > [    0.736012]  [<c064bd05>] ? rest_init+0xb5/0xb5
> >> > [    0.736012] Code: 99 87 ff 89 5c 24 04 c7 04 24 90 bf 76 c0 e8 dd e9 c9 ff 83 c8 ff eb 28 a1 44 bc a1 c0 f3 0f b8 c0 90 89 44 24 08 a1 80 73 82 c0 <8b> 40 28 89 44 24 04 c7 04 24 d4 bf 76 c0 e8 b2 e9 c9 ff 31 c0
> >> > [    0.736012] EIP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139 SS:ESP 0068:d244fef0
> >> > [    0.736012] CR2: 0000000000000028
> >> > [    0.736012] ---[ end trace 0a81712c9fb36a0a ]---
> >> > [    0.736012] swapper (1) used greatest stack depth: 5800 bytes left
> >> >
> >> > git bisect start v3.14 v3.13 --
> >> > git bisect  bad 09df7c4c8097ca4a11393b1edd4997d786daad52  # 16:18      0-      3  x86: Remove CONFIG_X86_OOSTORE
> >> > git bisect  bad 15c81026204da897a05424c79263aea861a782cc  # 16:24      2-      5  Merge branch 'x86-x32-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> > git bisect  bad a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8  # 16:33      0-     15  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> > git bisect good edde1fb8c41d0db7c8ce17fb32886da2e389b0cc  # 17:48    900+      0  Merge tag 'localmodconfig-v3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig
> >> > git bisect good a693c46e14c9fdadbcd68ddfa94a4f72495531a9  # 17:55    900+      0  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> > git bisect good 2cc3f16cad1561c6fc551aefff559e53726efc8b  # 18:12    900+      0  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> > git bisect  bad 9326657abe1a83ed4b4f396b923ca1217fd50cba  # 18:21      9-      2  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> > git bisect  bad 7bb73553e2490ac6667387ee723e0faa61e9d999  # 18:38      0-      1  tools lib traceevent: Get rid of die() in reparent_op_arg()
> >> > git bisect  bad 3d7c0144491bd8c21d53b43032274a85efdfe434  # 18:41     11-      4  perf tools: Add build and install plugins targets
> >> > git bisect  bad ba1ddf42f3c3af111d3adee277534f73c1ef6a9b  # 18:43      0-     15  perf script: Print mmap[2] events also
> >> > git bisect  bad a8b4c7014cadfdacd4e1f4c963128593be6f20de  # 18:49      0-      2  perf completion: Rename file to reflect zsh support
> >> > git bisect  bad 4788e5b4b2338f85fa42a712a182d8afd65d7c58  # 18:53      0-      1  perf/x86: Add Intel RAPL PMU support
> >> > git bisect good c912dae60ae6f659455f239298110adc67a5f3e9  # 19:33    900+     14  uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
> >> > git bisect good 09897d78dbc3a544426f2272b5601c62922ccab9  # 19:44    900+      0  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
> >> > git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:52    900+      0  tools/perf/stat: Add event unit and scale support
> >> > # first bad commit: [4788e5b4b2338f85fa42a712a182d8afd65d7c58] perf/x86: Add Intel RAPL PMU support
> >> > git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:56   1000+      0  tools/perf/stat: Add event unit and scale support
> >> > git bisect  bad 1a58d9909611972fd1c081bb04a9f7dc2571e612  # 19:58      0-      3  Add linux-next specific files for 20140724
> >> > git bisect  bad 82e13c71bc655b6dc7110da4e164079dadb44892  # 20:07    448-     10  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
> >> > git bisect  bad 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 20:14      2-      6  Add linux-next specific files for 20140725
> >> >
> >> >
> >> > This script may reproduce the error.
> >> >
> >> > ----------------------------------------------------------------------------
> >> > #!/bin/bash
> >> >
> >> > kernel=$1
> >> > initrd=yocto-minimal-i386.cgz
> >> >
> >> > wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
> >> >
> >> > kvm=(
> >> >         qemu-system-x86_64
> >> >         -enable-kvm
> >> >         -cpu Haswell,+smep,+smap
> >> >         -kernel $kernel
> >> >         -initrd $initrd
> >> >         -m 320
> >> >         -smp 1
> >> >         -net nic,vlan=1,model=e1000
> >> >         -net user,vlan=1
> >> >         -boot order=nc
> >> >         -no-reboot
> >> >         -watchdog i6300esb
> >> >         -rtc base=localtime
> >> >         -serial stdio
> >> >         -display none
> >> >         -monitor null
> >> > )
> >> >
> >> > append=(
> >> >         hung_task_panic=1
> >> >         earlyprintk=ttyS0,115200
> >> >         debug
> >> >         apic=debug
> >> >         sysrq_always_enabled
> >> >         rcupdate.rcu_cpu_stall_timeout=100
> >> >         panic=10
> >> >         softlockup_panic=1
> >> >         nmi_watchdog=panic
> >> >         prompt_ramdisk=0
> >> >         console=ttyS0,115200
> >> >         console=tty0
> >> >         vga=normal
> >> >         root=/dev/ram0
> >> >         rw
> >> >         drbd.minor_count=8
> >> > )
> >> >
> >> > "${kvm[@]}" --append "${append[*]}"
> >> > ----------------------------------------------------------------------------
> >> >
> >> > Thanks,
> >> > Fengguang
> >> >
> >> > _______________________________________________
> >> > LKP mailing list
> >> > LKP@linux.intel.com
> >> >

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb42-98:20140725122403:i386-randconfig-ib1-07251153::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc6-next-20140724 (kbuild@lkp-ib03) (gc=
c version 4.8.2 (Debian 4.8.2-18) ) #89 PREEMPT Fri Jul 25 11:55:48 CST 2014
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x131fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11a00000-0x11bfffff]
[    0.000000]  [mem 0x11a00000-0x11bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x119fffff]
[    0.000000]  [mem 0x10000000-0x119fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11c00000-0x13ffdfff]
[    0.000000]  [mem 0x11c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] cma: Reserved 16 MiB at 10800000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FFE000 000040
[    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d23f0da0, node_mem_map d1=
97f020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12274980
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:m=
aster:1a58d9909611972fd1c081bb04a9f7dc2571e612:bisect-linux-9/.vmlinuz-1a58=
d9909611972fd1c081bb04a9f7dc2571e612-20140725121947-2-ivb42 branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07251153/1a58d9909611972fd1c=
081bb04a9f7dc2571e612/vmlinuz-3.16.0-rc6-next-20140724 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 270992K/327280K available (4674K kernel code, 1662K =
rwdata, 1812K rodata, 432K init, 8296K bss, 56288K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffe0000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd23f8000 - 0xd2464000   ( 432 kB)
[    0.000000]       .data : 0xd2090e86 - 0xd23f6a00   (3478 kB)
[    0.000000]       .text : 0xd1c00000 - 0xd2090e86   (4675 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd0408000 soft=3Dd040a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.16.0-rc6-next-20140724 (kbuild@lkp-ib03) (gc=
c version 4.8.2 (Debian 4.8.2-18) ) #89 PREEMPT Fri Jul 25 11:55:48 CST 2014
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
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x131fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11a00000-0x11bfffff]
[    0.000000]  [mem 0x11a00000-0x11bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x119fffff]
[    0.000000]  [mem 0x10000000-0x119fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11c00000-0x13ffdfff]
[    0.000000]  [mem 0x11c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] cma: Reserved 16 MiB at 10800000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FFE000 000040
[    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat d23f0da0, node_mem_map d1=
97f020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12274980
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:m=
aster:1a58d9909611972fd1c081bb04a9f7dc2571e612:bisect-linux-9/.vmlinuz-1a58=
d9909611972fd1c081bb04a9f7dc2571e612-20140725121947-2-ivb42 branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07251153/1a58d9909611972fd1c=
081bb04a9f7dc2571e612/vmlinuz-3.16.0-rc6-next-20140724 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 270992K/327280K available (4674K kernel code, 1662K =
rwdata, 1812K rodata, 432K init, 8296K bss, 56288K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffe0000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd23f8000 - 0xd2464000   ( 432 kB)
[    0.000000]       .data : 0xd2090e86 - 0xd23f6a00   (3478 kB)
[    0.000000]       .text : 0xd1c00000 - 0xd2090e86   (4675 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd0408000 soft=3Dd040a000
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 5167 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D10774032)
[    0.008007] pid_max: default: 32768 minimum: 301
[    0.009113] ACPI: Core revision 20140627
[    0.013518] ACPI: All ACPI Tables successfully acquired
[    0.014878] ACPI: setting ELCR to 0200 (from 0c00)
[    0.016083] Security Framework initialized
[    0.017095] Yama: becoming mindful.
[    0.018064] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.019455] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.020702] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020702] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020702] tlb_flushall_shift: 6
[    0.024006] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.030312] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.032882] Getting VERSION: 1050014
[    0.033818] Getting VERSION: 1050014
[    0.034739] Getting ID: 0
[    0.036018] Getting ID: f000000
[    0.036892] Getting LVT0: 8700
[    0.037747] Getting LVT1: 8400
[    0.038613] enabled ExtINT on CPU#0
[    0.039533] Using local APIC timer interrupts.
[    0.039533] calibrating APIC timer ...
[    0.044000] ... lapic delta =3D 6248994
[    0.044000] ... PM-Timer delta =3D 357894
[    0.044000] ... PM-Timer result ok
[    0.044000] ..... delta 6248994
[    0.044000] ..... mult: 268392248
[    0.044000] ..... calibration result: 3999356
[    0.044000] ..... CPU clock speed is 2693.0193 MHz.
[    0.044000] ..... host bus clock speed is 999.3356 MHz.
[    0.044763] evm: security.capability
[    0.046679] regulator-dummy: no parameters
[    0.048000] NET: Registered protocol family 16
[    0.048625] cpuidle: using governor ladder
[    0.049655] cpuidle: using governor menu
[    0.052004] ACPI: bus type PCI registered
[    0.053237] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.055046] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.056003] PCI: Using configuration type 1 for base access
[    0.063155] ACPI: Added _OSI(Module Device)
[    0.064005] ACPI: Added _OSI(Processor Device)
[    0.065075] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.066186] ACPI: Added _OSI(Processor Aggregator Device)
[    0.077105] ACPI: Interpreter enabled
[    0.078084] ACPI: (supports S0 S5)
[    0.078993] ACPI: Using PIC for interrupt routing
[    0.080054] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.093150] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.094502] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.095762] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.096297] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.100106] PCI host bridge to bus 0000:00
[    0.101128] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.102353] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.103680] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.104005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.105328] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.106658] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.108005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.109441] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.110952] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.112716] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.116024] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.120006] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.122292] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.123772] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.124005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.125476] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.128408] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.130121] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.131929] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.132458] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.136644] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.139296] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.146444] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.148453] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.150734] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.152975] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.158838] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.160426] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.162254] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.167633] pci_bus 0000:00: on NUMA node 0
[    0.168949] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.170803] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.173086] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.174931] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.176985] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.179139] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.180329] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.182395] vgaarb: loaded
[    0.183199] vgaarb: bridge control possible 0000:00:02.0
[    0.184256] SCSI subsystem initialized
[    0.185330] pps_core: LinuxPPS API ver. 1 registered
[    0.186465] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.188018] PTP clock support registered
[    0.189040] PCI: Using ACPI for IRQ routing
[    0.190062] PCI: pci_cache_line_size set to 64 bytes
[    0.192142] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.193437] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.196166] Bluetooth: Core ver 2.19
[    0.197141] NET: Registered protocol family 31
[    0.198196] Bluetooth: HCI device and connection manager initialized
[    0.199568] Bluetooth: HCI socket layer initialized
[    0.200009] Bluetooth: L2CAP socket layer initialized
[    0.201194] Bluetooth: SCO socket layer initialized
[    0.202344] NET: Registered protocol family 8
[    0.204004] NET: Registered protocol family 20
[    0.205469] Switched to clocksource kvm-clock
[    0.206874] FS-Cache: Loaded
[    0.207760] pnp: PnP ACPI init
[    0.208000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.208785] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.210254] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.211712] pnp 00:03: [dma 2]
[    0.212619] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.214117] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.215622] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.217630] pnp: PnP ACPI: found 6 devices
[    0.218668] PnPBIOS: Disabled
[    0.559340] mdacon: MDA with 8K of memory detected.
[    0.559459] Console: switching consoles 13-16 to MDA-2
[    0.596760] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.598222] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.599685] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.601137] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.602595] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.604149] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.605714] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.607413] NET: Registered protocol family 2
[    0.609222] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.611009] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
[    0.612949] TCP: Hash tables configured (established 4096 bind 4096)
[    0.614847] TCP: reno registered
[    0.615891] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.617454] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.619335] NET: Registered protocol family 1
[    0.620599] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.622142] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.623658] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.625255] pci 0000:00:02.0: Boot video device
[    0.626566] PCI: CLS 0 bytes, default 64
[    0.628050] Unpacking initramfs...
[    0.632409] Initramfs unpacking failed: junk in compressed archive
[    0.635014] BUG: unable to handle kernel NULL pointer dereference at 000=
0000c
[    0.636946] IP: [<d1c52d71>] validate_chain.isra.37+0xc5/0x10e5
[    0.638357] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.638357] Oops: 0000 [#1] PREEMPT=20
[    0.638357] Modules linked in:
[    0.638357] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc6-next-2014=
0724 #89
[    0.638357] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[    0.638357] task: d044a010 ti: d044c000 task.ti: d044c000
[    0.638357] EIP: 0060:[<d1c52d71>] EFLAGS: 00010086 CPU: 0
[    0.638357] EIP is at validate_chain.isra.37+0xc5/0x10e5
[    0.638357] EAX: 00000000 EBX: 0000000e ECX: 00000000 EDX: fffffffc
[    0.638357] ESI: d044a4f4 EDI: d2883348 EBP: d044dd6c ESP: d044dd08
[    0.638357]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.638357] CR0: 8005003b CR2: 0000000c CR3: 12467000 CR4: 000006b0
[    0.638357] Stack:
[    0.638357]  0000000e d044dd14 d1c243ae d044dd1c d1c07d05 d044dd48 d28a2=
7e0 d044a4f4
[    0.638357]  00000001 d044a010 00000000 00000000 00000000 00000000 d044a=
010 0000000e
[    0.638357]  d044dd64 d1c489f8 25d94f2b 00000000 00000000 d044a010 00000=
00e d044a010
[    0.638357] Call Trace:
[    0.638357]  [<d1c243ae>] ? kvm_clock_read+0x13/0x24
[    0.638357]  [<d1c07d05>] ? sched_clock+0x8/0xb
[    0.638357]  [<d1c489f8>] ? sched_clock_cpu+0xb1/0xd0
[    0.638357]  [<d1c54cf2>] __lock_acquire+0x350/0xaa5
[    0.638357]  [<d1c243ae>] ? kvm_clock_read+0x13/0x24
[    0.638357]  [<d1c07d05>] ? sched_clock+0x8/0xb
[    0.638357]  [<d1c24e2e>] ? pvclock_clocksource_read+0xbb/0x149
[    0.638357]  [<d1c55b97>] lock_acquire+0x77/0x92
[    0.638357]  [<d1c9324f>] ? free_pcppages_bulk+0x1f/0x30b
[    0.638357]  [<d208e83c>] _raw_spin_lock+0x3c/0x69
[    0.638357]  [<d1c9324f>] ? free_pcppages_bulk+0x1f/0x30b
[    0.638357]  [<d1c9324f>] free_pcppages_bulk+0x1f/0x30b
[    0.638357]  [<d1c92018>] ? free_pages_prepare+0xc1/0xea
[    0.638357]  [<d1c936e8>] free_hot_cold_page+0x123/0x164
[    0.638357]  [<d1c9373c>] __free_pages.part.74+0x13/0x18
[    0.638357]  [<d1c9374f>] __free_pages+0xe/0x10
[    0.638357]  [<d1c937b0>] free_reserved_area+0x5f/0xdc
[    0.638357]  [<d1c27ca1>] ? set_memory_rw+0x48/0x4a
[    0.638357]  [<d1c250f0>] free_init_pages+0x5b/0x7e
[    0.638357]  [<d23f9d90>] ? maybe_link.part.2+0xe4/0xe4
[    0.638357]  [<d23f9d90>] ? maybe_link.part.2+0xe4/0xe4
[    0.638357]  [<d2406bd3>] free_initrd_mem+0x26/0x2a
[    0.638357]  [<d23f9e67>] populate_rootfs+0xd7/0xf9
[    0.638357]  [<d23f9d90>] ? maybe_link.part.2+0xe4/0xe4
[    0.638357]  [<d1c00426>] do_one_initcall+0x7f/0x1b9
[    0.638357]  [<d23f9d90>] ? maybe_link.part.2+0xe4/0xe4
[    0.638357]  [<d1c54658>] ? trace_hardirqs_on_caller+0xeb/0x1af
[    0.638357]  [<d1c41d8a>] ? parameq+0x13/0x5e
[    0.638357]  [<d23f859b>] ? repair_env_string+0x12/0x51
[    0.638357]  [<d1c41fbe>] ? parse_args+0x1e9/0x319
[    0.638357]  [<d1c3c5ca>] ? __usermodehelper_set_disable_depth+0x3e/0x44
[    0.638357]  [<d23f8d09>] kernel_init_freeable+0xde/0x178
[    0.638357]  [<d23f8589>] ? initcall_blacklist+0x81/0x81
[    0.638357]  [<d20830d0>] kernel_init+0xb/0xc7
[    0.638357]  [<d1c46f06>] ? schedule_tail+0xc/0x3a
[    0.638357]  [<d208f640>] ret_from_kernel_thread+0x20/0x30
[    0.638357]  [<d20830c5>] ? rest_init+0xb5/0xb5
[    0.638357] Code: 89 4d c4 39 c7 74 41 8b 4d c8 33 48 0c 8b 50 08 31 da =
09 d1 0f 84 59 03 00 00 8b 55 c4 89 75 b8 8b 45 c8 89 45 c4 eb 13 8b 4d c4 =
<33> 48 0c 8b 70 08 31 de 09 f1 0f 84 38 03 00 00 8b 42 04 8d 50
[    0.638357] EIP: [<d1c52d71>] validate_chain.isra.37+0xc5/0x10e5 SS:ESP =
0068:d044dd08
[    0.638357] CR2: 000000000000000c
[    0.638357] ---[ end trace af9f92549db6e569 ]---
[    0.638357] note: swapper[1] exited with preempt_count 1
[    0.734957] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    0.734957]=20
[    0.737734] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
b1-07251153/1a58d9909611972fd1c081bb04a9f7dc2571e612/vmlinuz-3.16.0-rc6-nex=
t-20140724 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:master:1a58d9909=
611972fd1c081bb04a9f7dc2571e612:bisect-linux-9/.vmlinuz-1a58d9909611972fd1c=
081bb04a9f7dc2571e612-20140725121947-2-ivb42 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-ib1-07251153/1a58d9909611972fd1c081bb04a9f7dc25=
71e612/vmlinuz-3.16.0-rc6-next-20140724 drbd.minor_count=3D8'  -initrd /ker=
nel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,mode=
l=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb=
 -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb42-98 -serial=
 file:/dev/shm/kboot/serial-quantal-ivb42-98 -daemonize -display none -moni=
tor null=20

--6TrnltStXW4iwmi0--
