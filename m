Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914AbaDJJng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:43:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47977 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573AbaDJJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:42:22 -0400
MIME-Version: 1.0
In-Reply-To: <534664B6.8060603@intel.com>
References: <534664B6.8060603@intel.com>
Date: Thu, 10 Apr 2014 02:42:22 -0700
Message-ID: <CABPqkBQjtbQC5ZS92ZUAsQss5q_AieLCTMc6380NjY9Oe3KGrA@mail.gmail.com>
Subject: Re: [perf] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Stephane Eranian <eranian@google.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 10, 2014 at 2:30 AM, Jet Chen <jet.chen@intel.com> wrote:
> Hi Stephane,
>
> I got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 71ad88efebbcde374bddf904b96f3a7fc82d45d4
> Author:     Stephane Eranian <eranian@google.com>
> AuthorDate: Tue Nov 12 17:58:48 2013 +0100
> Commit:     Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed Nov 27 11:16:38 2013 +0100
>
>     perf: Add active_entry list head to struct perf_event
>         This patch adds a new field to the struct perf_event.
>     It is intended to be used to chain events which are
>     active (enabled). It helps in the hardware layer
>     for PMUs which do not have actual counter restrictions, i.e.,
>     free running read-only counters. Active events are chained
>     as opposed to being tracked via the counter they use.
>         To save space we use a union with hlist_entry as both
>     are mutually exclusive (suggested by Jiri Olsa).
>         Signed-off-by: Stephane Eranian <eranian@google.com>
>     Reviewed-by: Andi Kleen <ak@linux.intel.com>
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Cc: acme@redhat.com
>     Cc: jolsa@redhat.com
>     Cc: zheng.z.yan@intel.com
>     Cc: bp@alien8.de
>     Cc: maria.n.dimakopoulou@gmail.com
>     Link: http://lkml.kernel.org/r/1384275531-10892-2-git-send-email-eranian@google.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>
This patch was later superseded by commit
f3ae75de98c4bac145a87d830c156c96f9414022

Could you try with this one?

The commit you pointed to had some initialization issues potentially.

> +------------------------------------------------------------+------------+------------+
> |                                                            | 09897d78db | 71ad88efeb |
> +------------------------------------------------------------+------------+------------+
> | boot_successes                                             | 866        | 226        |
> | boot_failures                                              | 154        | 74         |
> | WARNING:CPU:PID:at_kernel/events/core.c:perf_swevent_add() | 154        | 70         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference       | 0          | 4          |
> | Oops                                                       | 0          | 4          |
> | EIP_is_at_strlen                                           | 0          | 4          |
> | Kernel_panic-not_syncing:Fatal_exception                   | 0          | 3          |
> | backtrace:vfs_write                                        | 0          | 3          |
> | backtrace:SyS_write                                        | 0          | 3          |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt      | 0          | 1          |
> | EIP_is_at_rapl_pmu_init                                    | 0          | 0          |
> | backtrace:rapl_pmu_init                                    | 0          | 0          |
> | backtrace:kernel_init_freeable                             | 0          | 0          |
> | Oops:PREEMPT_PREEMPT                                       | 0          | 0          |
> +------------------------------------------------------------+------------+------------+
>
> [main] Setsockopt(1 10 80d1000 6b) on fd 378 [8:5:208]
> [main] Setsockopt(29 4 80d1000 30) on fd 380 [10:2:17]
> [main] created 375 sockets
> [   68.404317] BUG: unable to handle kernel NULL pointer dereference at   (null)
> [   68.404317] IP: [<c13f54a5>] strlen+0x10/0x1c
> [   68.404317] *pde = 00000000 [   68.404317] Oops: 0000 [#1] PREEMPT [   68.404317] CPU: 0 PID: 193 Comm: trinity-main Not tainted 3.12.0-10266-g71ad88e #3
> [   68.404317] task: cfced5b0 ti: c0094000 task.ti: cfd22000
> [   68.404317] EIP: 0060:[<c13f54a5>] EFLAGS: 00000042 CPU: 0
> [   68.404317] EIP is at strlen+0x10/0x1c
> [   68.404317] EAX: 00000000 EBX: c2dffd1c ECX: ffffffff EDX: c2dffd1c
> [   68.404317] ESI: c2dffd1c EDI: 00000000 EBP: c0095e4c ESP: c0095e48
> [   68.404317]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   68.404317] CR0: 8005003b CR2: 00000000 CR3: 0fd10000 CR4: 00300690
> [   68.404317] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   68.404317] DR6: 00000000 DR7: 00000000
> [   68.404317] Stack:
> [   68.404317]  c23bdbe8 c0095ed0 c1080b3d 00000046 c0095ec8 c1082d56 c2b0bbc0 00000001
> [   68.404317]  cfc97f40 cfced5b0 00000000 00000042 c2b30b60 00000046 cfced970 00000000
> [   68.404317]  0054c01f c2b13c68 00000000 00000046 00000046 c10d06f5 c2b5bad0 00000046
> [   68.404317] Call Trace:
> [   68.404317]  [<c1080b3d>] perf_trace_lock+0x15/0xbf
> [   68.404317]  [<c1082d56>] ? __lock_acquire+0x546/0xcf3
> [   68.404317]  [<c10d06f5>] ? time_hardirqs_off+0xf/0x37
> [   68.404317]  [<c10a0fcc>] ? ktime_get_update_offsets+0x19/0x87
> [   68.404317]  [<c1083c9c>] lock_release+0x84/0x20c
> [   68.404317]  [<c10a0fcc>] ? ktime_get_update_offsets+0x19/0x87
> [   68.404317]  [<c109f1ab>] read_seqcount_begin.constprop.22+0x52/0xc3
> [   68.404317]  [<c10a0fcc>] ? ktime_get_update_offsets+0x19/0x87
> [   68.404317]  [<c10a0fcc>] ktime_get_update_offsets+0x19/0x87
> [   68.404317]  [<c1ca0da7>] ? _raw_spin_lock+0x45/0x4b
> [   68.404317]  [<c106eca9>] hrtimer_interrupt+0x71/0x362
> [   68.404317]  [<c1083be9>] ? lock_acquire+0x102/0x131
> [   68.404317]  [<c10d06f5>] ? time_hardirqs_off+0xf/0x37
> [   68.404317]  [<c1ca0f58>] ? _raw_spin_unlock_irqrestore+0x4f/0x98
> [   68.404317]  [<c1005026>] timer_interrupt+0x12/0x19
> [   68.404317]  [<c108e2fd>] handle_irq_event_percpu+0xe5/0x3bc
> [   68.404317]  [<c1083dcc>] ? lock_release+0x1b4/0x20c
> [   68.404317]  [<c1ca0f85>] ? _raw_spin_unlock_irqrestore+0x7c/0x98
> [   68.404317]  [<c1085983>] ? do_raw_spin_unlock+0xd6/0x10d
> [   68.404317]  [<c108e605>] handle_irq_event+0x31/0x48
> [   68.404317]  [<c10915bc>] handle_level_irq+0xb9/0xcc
> [   68.404317]  [<c1091503>] ? handle_simple_irq+0xbe/0xbe
> [   68.404317]  <IRQ> [   68.404317]  [<c100463d>] ? do_IRQ+0x39/0xad
> [   68.404317]  [<c107fe6c>] ? debug_mutex_unlock+0x185/0x1fa
> [   68.404317]  [<c1ca2931>] ? common_interrupt+0x31/0x38
> [   68.404317]  [<c13f54a5>] ? strlen+0x10/0x1c
> [   68.404317]  [<c10bb9f4>] ? get_tracepoint+0x11/0x5d
> [   68.404317]  [<c10bba6c>] ? tracepoint_update_probe_range.constprop.2+0x2c/0x208
> [   68.404317]  [<c10bc1b9>] ? tracepoint_probe_register+0x61/0x79
> [   68.404317]  [<c10d7860>] ? ftrace_event_reg+0x3f/0x56
> [   68.404317]  [<c10d8020>] ? perf_trace_init+0x235/0x3ae
> [   68.404317]  [<c10dfc19>] ? perf_tp_event_init+0x56/0x8f
> [   68.404317]  [<c10e8b65>] ? perf_init_event+0x12c/0x1c3
> [   68.404317]  [<c10e8fec>] ? perf_event_alloc+0x3f0/0x554
> [   68.404317]  [<c10e991c>] ? SYSC_perf_event_open+0x7cc/0xd59
> [   68.404317]  [<c107f4c0>] ? up_read+0x1b/0x2d
> [   68.404317]  [<c10ea2a8>] ? SyS_perf_event_open+0x21/0x23
> [   68.404317]  [<c1ca1de8>] ? syscall_call+0x7/0xb
> [   68.404317] Code: 00 89 c6 89 d0 88 c4 ac 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e 5d c3 55 89 e5 57 e8 9a d4 8a 00 83 c9 ff 89 c7 31 c0 <f2> ae b8 fe ff ff ff 29 c8 5f 5d c3 55 89 e5 57 56 53 e8 7c d4
> [   68.404317] EIP: [<c13f54a5>] strlen+0x10/0x1c SS:ESP 0068:c0095e48
> [   68.404317] CR2: 0000000000000000
> [   68.404317] ---[ end trace 2e13450c28f806b4 ]---
> [   68.404317] Kernel panic - not syncing: Fatal exception in interrupt
>
> git bisect start fa389e220254c69ffae0d403eac4146171062d08 v3.13 --
> git bisect  bad 7aa483554d5eb55406f70f13935158032107f3c8  # 00:19      0-      6  Merge tag 'sound-3.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
> git bisect  bad e7651b819e90da924991d727d3c007200a18670d  # 00:23      0-      3  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect  bad 09da8dfa98682d871987145ed11e3232accac860  # 00:36      0-     12  Merge tag 'pm+acpi-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect  bad 02d0a752460ea5dab34ce36c9ddc9c682e846a0d  # 00:46      0-     21  Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> git bisect  bad 06bc0f4a2e7fe54d98539686f070ceccfd73953d  # 00:58      0-      3  Merge branch 'x86-build-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 897aea303fec0c24b2a21b8e29f45dc73a234555  # 21:25    900+    315  Merge branch 'core-debug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 9326657abe1a83ed4b4f396b923ca1217fd50cba  # 21:25      0-     71  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good a693c46e14c9fdadbcd68ddfa94a4f72495531a9  # 21:20    915+    352  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good ad3ab302fd8239a1ddee01e606683c3197ca6908  # 21:46    900+    127  Merge branch 'core-stackprotector-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 2cc3f16cad1561c6fc551aefff559e53726efc8b  # 22:03    900+    164  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 7bb73553e2490ac6667387ee723e0faa61e9d999  # 22:04      0-     46  tools lib traceevent: Get rid of die() in reparent_op_arg()
> git bisect  bad 3d7c0144491bd8c21d53b43032274a85efdfe434  # 22:04      0-     55  perf tools: Add build and install plugins targets
> git bisect  bad ba1ddf42f3c3af111d3adee277534f73c1ef6a9b  # 22:04      0-     50  perf script: Print mmap[2] events also
> git bisect  bad a8b4c7014cadfdacd4e1f4c963128593be6f20de  # 22:04      0-     65  perf completion: Rename file to reflect zsh support
> git bisect  bad 4788e5b4b2338f85fa42a712a182d8afd65d7c58  # 22:04      0-     55  perf/x86: Add Intel RAPL PMU support
> git bisect good c912dae60ae6f659455f239298110adc67a5f3e9  # 22:13    900+    181  uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
> git bisect good 09897d78dbc3a544426f2272b5601c62922ccab9  # 22:24    900+    154  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
> git bisect  bad 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 22:24      0-     33  tools/perf/stat: Add event unit and scale support
> git bisect  bad 71ad88efebbcde374bddf904b96f3a7fc82d45d4  # 22:24      0-     74  perf: Add active_entry list head to struct perf_event
> # first bad commit: [dbbafb74239e8296bc20f86366b3f38e13650900
> 71ad88efebbcde374bddf904b96f3a7fc82d45d4
> 71ad88efebbcde374bddf904b96f3a7fc82d45d4] mtd: m25p80: Add dual read support
> git bisect  bad fa389e220254c69ffae0d403eac4146171062d08  # 22:24      0-     63  Linux 3.14-rc6
>
>
> This script may reproduce the error. But the frequency of reproduction is relatively low.
>
> -----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-i386.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64 -cpu Haswell,+smep,+smap
>         -kernel $kernel
>         -initrd $initrd
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
>
> Thanks,
> Jet
>
>
