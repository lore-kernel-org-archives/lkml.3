Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaKCT2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:28:25 -0500
Received: from forward3h.mail.yandex.net ([84.201.187.148]:36193 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:28:23 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Fengguang Wu <fengguang.wu@intel.com>, Kirill Tkhai <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20141103145332.GA5157@wfg-t540p.sh.intel.com>
References: <20141103145332.GA5157@wfg-t540p.sh.intel.com>
Subject: Re: [sched] [ INFO: suspicious RCU usage. ]
MIME-Version: 1.0
Message-Id: <2127541415042898@web25h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 03 Nov 2014 22:28:18 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the fix is already in PeterZ queue, it will go to mainline soon.

03.11.2014, 17:54, "Fengguang Wu" <fengguang.wu@intel.com>:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit eeb61e53ea19be0c4015b00b2e8b3b2185436f2b
> Author: ššššKirill Tkhai <ktkhai@parallels.com>
> AuthorDate: Mon Oct 27 14:18:25 2014 +0400
> Commit: ššššIngo Molnar <mingo@kernel.org>
> CommitDate: Tue Oct 28 10:45:59 2014 +0100
>
> ššššsched: Fix race between task_group and sched_task_group
>
> ššššThe race may happen when somebody is changing task_group of a forking task.
> ššššChild's cgroup is the same as parent's after dup_task_struct() (there just
> ššššmemory copying). Also, cfs_rq and rt_rq are the same as parent's.
>
> ššššBut if parent changes its task_group before it's called cgroup_post_fork(),
> ššššwe do not reflect this situation on child. Child's cfs_rq and rt_rq remain
> ššššthe same, while child's task_group changes in cgroup_post_fork().
>
> ššššTo fix this we introduce fork() method, which calls sched_move_task() directly.
> ššššThis function changes sched_task_group on appropriate (also its logic has
> ššššno problem with freshly created tasks, so we shouldn't introduce something
> ššššspecial; we are able just to use it).
>
> ššššPossibly, this decides the Burke Libbey's problem: https://lkml.org/lkml/2014/10/24/456
>
> ššššSigned-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ššššSigned-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ššššCc: Linus Torvalds <torvalds@linux-foundation.org>
> ššššLink: http://lkml.kernel.org/r/1414405105.19914.169.camel@tkhai
> ššššSigned-off-by: Ingo Molnar <mingo@kernel.org>
>
> +------------------------------------------------+-----------+------------+---------------+
> | ššššššššššššššššššššššššššššššššššššššššššššššš| v3.18-rc2 | eeb61e53ea | next-20141031 |
> +------------------------------------------------+-----------+------------+---------------+
> | boot_successes šššššššššššššššššššššššššššššššš| 60 ššššššš| 0 ššššššššš| 0 šššššššššššš|
> | boot_failures ššššššššššššššššššššššššššššššššš| 0 šššššššš| 20 šššššššš| 11 ššššššššššš|
> | INFO:suspicious_RCU_usage ššššššššššššššššššššš| 0 šššššššš| 20 šššššššš| 11 ššššššššššš|
> | backtrace:do_fork ššššššššššššššššššššššššššššš| 0 šššššššš| 20 šššššššš| 11 ššššššššššš|
> | WARNING:at_kernel/sched/core.c:__might_sleep() | 0 šššššššš| 0 ššššššššš| 11 ššššššššššš|
> | backtrace:rfcomm_run šššššššššššššššššššššššššš| 0 šššššššš| 0 ššššššššš| 11 ššššššššššš|
> | WARNING:CPU:#PID:#at/kbuild/src/smo ššššššššššš| 0 šššššššš| 0 ššššššššš| 1 šššššššššššš|
> | BUG:kernel_boot_hang šššššššššššššššššššššššššš| 0 šššššššš| 0 ššššššššš| 1 šššššššššššš|
> +------------------------------------------------+-----------+------------+---------------+
>
> [ ššš0.086529] debug: unmapping init [mem 0xffffffff82607000-0xffffffff82609fff]
> [ ššš0.090115]
> [ ššš0.090782] ===============================
> [ ššš0.091842] [ INFO: suspicious RCU usage. ]
> [ ššš0.092000] 3.18.0-rc2-00001-geeb61e5 #7 Not tainted
> [ ššš0.092000] -------------------------------
> [ ššš0.092000] kernel/sched/core.c:7408 suspicious rcu_dereference_check() usage!
> [ ššš0.092000]
> [ ššš0.092000] other info that might help us debug this:
> [ ššš0.092000]
> [ ššš0.092000]
> [ ššš0.092000] rcu_scheduler_active = 1, debug_locks = 0
> [ ššš0.092000] 2 locks held by swapper/0/0:
> [ ššš0.092000] š#0: š(&p->pi_lock){......}, at: [<ffffffff810b8d96>] task_rq_lock+0x30/0xaa
> [ ššš0.092000] š#1: š(&rq->lock){-.....}, at: [<ffffffff810b8db8>] task_rq_lock+0x52/0xaa
> [ ššš0.092000]
> [ ššš0.092000] stack backtrace:
> [ ššš0.092000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00001-geeb61e5 #7
> [ ššš0.092000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ ššš0.092000] š0000000000000001 ffffffff819dbcb8 ffffffff815e2acd 000000000000182c
> [ ššš0.092000] šffffffff819f85c0 ffffffff819dbce8 ffffffff810d1774 ffff880013510000
> [ ššš0.092000] šffff8800139de180 ffff880013528000 0000000000800300 ffffffff819dbd48
> [ ššš0.092000] Call Trace:
> [ ššš0.092000] š[<ffffffff815e2acd>] dump_stack+0x4e/0x68
> [ ššš0.092000] š[<ffffffff810d1774>] lockdep_rcu_suspicious+0x107/0x110
> [ ššš0.092000] š[<ffffffff810bf887>] sched_move_task+0xda/0x17b
> [ ššš0.092000] š[<ffffffff810bf945>] cpu_cgroup_fork+0x9/0xb
> [ ššš0.092000] š[<ffffffff8110c301>] cgroup_post_fork+0x9b/0xaa
> [ ššš0.092000] š[<ffffffff8109c1bd>] copy_process+0x17e5/0x1832
> [ ššš0.092000] š[<ffffffff815def62>] ? rest_init+0x136/0x136
> [ ššš0.092000] š[<ffffffff8109c367>] do_fork+0x8a/0x243
> [ ššš0.092000] š[<ffffffff8109c541>] kernel_thread+0x21/0x23
> [ ššš0.092000] š[<ffffffff815dee4a>] rest_init+0x1e/0x136
> [ ššš0.092000] š[<ffffffff82520fb5>] start_kernel+0x4ba/0x4c7
> [ ššš0.092000] š[<ffffffff82520120>] ? early_idt_handlers+0x120/0x120
> [ ššš0.092000] š[<ffffffff825204de>] x86_64_start_reservations+0x2a/0x2c
> [ ššš0.092000] š[<ffffffff825205e6>] x86_64_start_kernel+0x106/0x115
> [ ššš0.096042] Getting VERSION: 1050014
> [ ššš0.097061] Getting VERSION: 1050014
> [ ššš0.098000] Getting ID: 0
>
> git bisect start 4fbe40970dc154aaeeda0584aab8913fc073127b cac7f2429872d3733dc3f9915857b1691da2eb2f --
> git bisect good fd2e6bbbe5b2e8f6d8ea6a28b614ec5c1c8b5a62 š# 23:14 šššš20+ ššššš0 šMerge remote-tracking branch 'hwmon-staging/hwmon-next'
> git bisect good ab6af24617af5f94df5185611f1eb39432d49292 š# 01:33 šššš20+ ššššš0 šMerge remote-tracking branch 'spi/for-next'
> git bisect šbad f5ef810eb87c283118797ea33778c5b3c937ad29 š# 02:08 ššššš0- ššššš3 šMerge remote-tracking branch 'staging/staging-next'
> git bisect šbad 50247251e8b6078b491b5fb54dc31c24867f5930 š# 02:47 ššššš0- ššššš9 šMerge remote-tracking branch 'rcu/rcu/next'
> git bisect šbad 6a91cd724c20352f8cdc2a73c0649bae71897ed8 š# 03:27 ššššš0- ššššš7 šMerge remote-tracking branch 'edac-amd/for-next'
> git bisect šbad d7a8d245f2ffb9adde1a7121e5ab86eed8d03584 š# 03:39 ššššš0- ššššš4 šMerge remote-tracking branch 'tip/auto-latest'
> git bisect good 26c2d2b39128adba276d140eefa2745591b88536 š# 09:46 šššš20+ ššššš0 ši386/audit: stop scribbling on the stack frame
> git bisect šbad 3427445afd26bd2395f29241319283a93f362cd0 š# 11:03 ššššš0- ššššš1 šsched: Exclude cond_resched() from nested sleep test
> git bisect šbad 1a43a14a5bd9c32dbd7af35e35a5afa703944bcb š# 11:39 ššššš0- ššššš2 šsched: Fix schedule_tail() to disable preemption
> git bisect šbad f3a7e1a9c464a32ee186ab91388313c82e7ce018 š# 12:38 ššššš0- ššššš1 šsched/dl: Fix preemption checks
> git bisect šbad 1effd9f19324efb05fccc7421530e11a52db0278 š# 12:55 ššššš0- ššššš1 šsched/numa: Fix unsafe get_task_struct() in task_numa_assign()
> git bisect šbad 64be6f1f5f710f5995d41caf8a1767fe6d2b5a87 š# 15:30 ššššš0- ššššš3 šsched/deadline: Don't replenish from a !SCHED_DEADLINE entity
> git bisect šbad eeb61e53ea19be0c4015b00b2e8b3b2185436f2b š# 17:18 ššššš0- ššššš1 šsched: Fix race between task_group and sched_task_group
> # first bad commit: [eeb61e53ea19be0c4015b00b2e8b3b2185436f2b] sched: Fix race between task_group and sched_task_group
> git bisect good cac7f2429872d3733dc3f9915857b1691da2eb2f š# 17:31 šššš60+ ššššš0 šLinux 3.18-rc2
> git bisect šbad 4fbe40970dc154aaeeda0584aab8913fc073127b š# 17:31 ššššš0- šššš11 šAdd linux-next specific files for 20141031
> git bisect šbad 0df1f2487d2f0d04703f142813d53615d62a1da4 š# 20:17 ššššš0- ššššš3 šLinux 3.18-rc3
> git bisect šbad a641d0e16b552f986e8c4a8735e66a1443a769cf š# 21:44 ššššš0- ššššš3 šAdd linux-next specific files for 20141103
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
> ššššššššqemu-system-x86_64
> šššššššš-enable-kvm
> šššššššš-cpu Haswell,+smep,+smap
> šššššššš-kernel $kernel
> šššššššš-initrd $initrd
> šššššššš-m 320
> šššššššš-smp 1
> šššššššš-net nic,vlan=1,model=e1000
> šššššššš-net user,vlan=1
> šššššššš-boot order=nc
> šššššššš-no-reboot
> šššššššš-watchdog i6300esb
> šššššššš-rtc base=localtime
> šššššššš-serial stdio
> šššššššš-display none
> šššššššš-monitor null
> )
>
> append=(
> ššššššššhung_task_panic=1
> ššššššššearlyprintk=ttyS0,115200
> ššššššššdebug
> ššššššššapic=debug
> ššššššššsysrq_always_enabled
> ššššššššrcupdate.rcu_cpu_stall_timeout=100
> ššššššššpanic=-1
> ššššššššsoftlockup_panic=1
> ššššššššnmi_watchdog=panic
> ššššššššoops=panic
> ššššššššload_ramdisk=2
> ššššššššprompt_ramdisk=0
> ššššššššconsole=ttyS0,115200
> ššššššššconsole=tty0
> ššššššššvga=normal
> ššššššššroot=/dev/ram0
> ššššššššrw
> ššššššššdrbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
> ,
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
