Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKFQrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:47:31 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39746 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaKFQr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:47:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141106071449.GB13941@wfg-t540p.sh.intel.com>
References: <20141106071449.GB13941@wfg-t540p.sh.intel.com>
Date: Thu, 6 Nov 2014 08:47:25 -0800
X-Google-Sender-Auth: oTAZIj-qGsbAOiXzK02Xg0UwrrI
Message-ID: <CAGXu5j+eXx+Wc8M0aGKHiiJ-OmnQXTqkXfBuAx9eQNRcRrJeSg@mail.gmail.com>
Subject: Re: [seccomp] kernel BUG at kernel/fork.c:1102!
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this has been fixed for a while by
69f6a34bdeea4fec50bb90619bc9602973119572 "seccomp: Replace
BUG(!spin_is_locked()) with assert_spin_lock"

Thanks!

-Kees

On Wed, Nov 5, 2014 at 11:14 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> commit dbd952127d11bb44a4ea30b08cc60531b6a23d71
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Fri Jun 27 15:18:48 2014 -0700
> Commit:     Kees Cook <keescook@chromium.org>
> CommitDate: Fri Jul 18 12:13:39 2014 -0700
>
>     seccomp: introduce writer locking
>
>     Normally, task_struct.seccomp.filter is only ever read or modified by
>     the task that owns it (current). This property aids in fast access
>     during system call filtering as read access is lockless.
>
>     Updating the pointer from another task, however, opens up race
>     conditions. To allow cross-thread filter pointer updates, writes to the
>     seccomp fields are now protected by the sighand spinlock (which is shared
>     by all threads in the thread group). Read access remains lockless because
>     pointer updates themselves are atomic.  However, writes (or cloning)
>     often entail additional checking (like maximum instruction counts)
>     which require locking to perform safely.
>
>     In the case of cloning threads, the child is invisible to the system
>     until it enters the task list. To make sure a child can't be cloned from
>     a thread and left in a prior state, seccomp duplication is additionally
>     moved under the sighand lock. Then parent and child are certain have
>     the same seccomp state when they exit the lock.
>
>     Based on patches by Will Drewry and David Drysdale.
>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>     Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>
> +------------------------------------------+------------+------------+------------+
> |                                          | c8bee430dc | dbd952127d | c2426d2ad5 |
> +------------------------------------------+------------+------------+------------+
> | boot_successes                           | 60         | 0          | 0          |
> | boot_failures                            | 0          | 20         | 11         |
> | kernel_BUG_at_kernel/fork.c              | 0          | 20         | 11         |
> | invalid_opcode                           | 0          | 20         | 11         |
> | EIP_is_at_copy_process                   | 0          | 20         | 11         |
> | Kernel_panic-not_syncing:Fatal_exception | 0          | 20         | 11         |
> | backtrace:do_fork                        | 0          | 20         | 11         |
> +------------------------------------------+------------+------------+------------+
>
> [    0.023060] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, stepping: 01)
> [    0.046204] ftrace: allocating 39817 entries in 78 pages
> [    0.070150] ------------[ cut here ]------------
> [    0.071335] kernel BUG at kernel/fork.c:1102!
> [    0.072727] invalid opcode: 0000 [#1] PREEMPT
> [    0.074202] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00031-gdbd95212 #339
> [    0.076276] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.077594] task: c2832140 ti: c2826000 task.ti: c2826000
> [    0.078816] EIP: 0060:[<c1073080>] EFLAGS: 00210046 CPU: 0
> [    0.080000] EIP is at copy_process+0x1720/0x1860
> [    0.080000] EAX: 00000003 EBX: d3464000 ECX: 00000000 EDX: 00000000
> [    0.080000] ESI: fffffff4 EDI: d34701f0 EBP: c2827f84 ESP: c2827f54
> [    0.080000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    0.080000] CR0: 80050033 CR2: ffffffff CR3: 02c1e000 CR4: 00040690
> [    0.080000] Stack:
> [    0.080000]  d3464000 c2827fb8 00000000 00000000 c2457150 00000000 00000000 00800300
> [    0.080000]  fffffff4 c2457150 00020800 c2c1f800 c2827fb8 c1073386 00000000 d3407280
> [    0.080000]  00000000 00800300 c24780f5 00000000 00009b89 00000000 c2457150 00020800
> [    0.080000] Call Trace:
> [    0.080000]  [<c2457150>] ? rest_init+0x110/0x110
> [    0.080000]  [<c2457150>] ? rest_init+0x110/0x110
> [    0.080000]  [<c1073386>] do_fork+0x86/0x710
> [    0.080000]  [<c24780f5>] ? smp_trace_apic_timer_interrupt+0x5/0x2a6
> [    0.080000]  [<c2457150>] ? rest_init+0x110/0x110
> [    0.080000]  [<c1073a4b>] kernel_thread+0x3b/0x50
> [    0.080000]  [<c245707b>] rest_init+0x3b/0x110
> [    0.080000]  [<c2acc562>] start_kernel+0x864/0x88a
> [    0.080000]  [<c2acb31b>] i386_start_kernel+0xe9/0xfb
> [    0.080000] Code: 00 83 05 f8 d1 c5 c2 01 83 15 fc d1 c5 c2 00 83 05 00 d2 c5 c2 01 83 15 04 d2 c5 c2 00 83 05 e0 cf c5 c2 01 83 15 e4 cf c5 c2 00 <0f> 0b 83 05 e8 cf c5 c2 01 83 15 ec cf c5 c2 00 8b 45 e4 83 05
> [    0.080000] EIP: [<c1073080>] copy_process+0x1720/0x1860 SS:ESP 0068:c2827f54
> [    0.080000] ---[ end trace 8262cf1029187723 ]---
> [    0.080000] Kernel panic - not syncing: Fatal exception
>
> git bisect start 594081ee7145cc30a3977cb4e218f81213b63dc5 v3.16 --
> git bisect  bad b49e1043c48dac23f64fba684d31c4a96c1ffaa0  # 19:15      0-      2  tpm: Properly clean sysfs entries in error path
> git bisect good 32c2e6752ff0f48fe03b9e1c7c64bde580a840d2  # 20:28     20+      0  ima: provide double buffering for hash calculation
> git bisect  bad 7d8b6c63751cfbbe5eef81a48c22978b3407a3ad  # 20:46      0-      1  CAPABILITIES: remove undefined caps from all processes
> git bisect  bad fd33c43677a7965624b46352a686a7c1e72ae4aa  # 21:31      0-      2  Merge tag 'seccomp-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux into next
> git bisect good 2ccf4661f315615d018686d91d030a94001d0cc6  # 22:14     20+      0  Merge branch 'next' of git://git.infradead.org/users/pcmoore/selinux into next
> git bisect good 839669714f0a85d677283690e6e164fb698ce206  # 22:31     20+      0  ARM: add seccomp syscall
> git bisect good c8bee430dc52cfca6c1aab27752a89275d78d50f  # 22:43     20+      0  seccomp: split filter prep from check and apply
> git bisect  bad 3ba2530cc06eb4aee4f1f754f43d781e8a12ee09  # 22:48      0-     19  seccomp: allow mode setting across threads
> git bisect  bad dbd952127d11bb44a4ea30b08cc60531b6a23d71  # 23:16      0-     20  seccomp: introduce writer locking
> # first bad commit: [dbd952127d11bb44a4ea30b08cc60531b6a23d71] seccomp: introduce writer locking
> git bisect good c8bee430dc52cfca6c1aab27752a89275d78d50f  # 23:18     60+      0  seccomp: split filter prep from check and apply
> git bisect good a1cff6e25e6e3b55183610dddca91546951b20e3  # 23:27     60+      0  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal
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
>         qemu-system-x86_64
>         -enable-kvm
>         -cpu Haswell,+smep,+smap
>         -kernel $kernel
>         -m 320
>         -smp 1
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -rtc base=localtime
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         hung_task_panic=1
>         earlyprintk=ttyS0,115200
>         debug
>         apic=debug
>         sysrq_always_enabled
>         rcupdate.rcu_cpu_stall_timeout=100
>         panic=-1
>         softlockup_panic=1
>         nmi_watchdog=panic
>         oops=panic
>         load_ramdisk=2
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
>         drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>



-- 
Kees Cook
Chrome OS Security
