Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaJ2FIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:08:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:60587 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaJ2FIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:08:35 -0400
Message-ID: <1414559311.8574.14.camel@tkhai>
Subject: Re: [sched] [ INFO: suspicious RCU usage. ]
From: Kirill Tkhai <ktkhai@parallels.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 29 Oct 2014 08:08:31 +0300
In-Reply-To: <20141028142715.GB19097@wfg-t540p.sh.intel.com>
References: <20141028142715.GB19097@wfg-t540p.sh.intel.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Fengguang.

I've suggested this patch https://lkml.org/lkml/2014/10/28/41.

В Вт, 28/10/2014 в 22:27 +0800, Fengguang Wu пишет:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/urgent
> commit f6a2b544517d33f6a1e428567bda96fd859ce1c9
> Author:     Kirill Tkhai <ktkhai@parallels.com>
> AuthorDate: Mon Oct 27 14:18:25 2014 +0400
> Commit:     Peter Zijlstra <peterz@infradead.org>
> CommitDate: Mon Oct 27 13:23:31 2014 +0100
> 
>     sched: Fix race between task_group and sched_task_group
>     
>     The race may happen when somebody is changing task_group of a forking task.
>     Child's cgroup is the same as parent's after dup_task_struct() (there just
>     memory copying). Also, cfs_rq and rt_rq are the same as parent's.
>     
>     But if parent changes its task_group before it's called cgroup_post_fork(),
>     we do not reflect this situation on child. Child's cfs_rq and rt_rq remain
>     the same, while child's task_group changes in cgroup_post_fork().
>     
>     To fix this we introduce fork() method, which calls sched_move_task() directly.
>     This function changes sched_task_group on appropriate (also its logic has
>     no problem with freshly created tasks, so we shouldn't introduce something
>     special; we are able just to use it).
>     
>     Possibly, this decides the Burke Libbey's problem: https://lkml.org/lkml/2014/10/24/456
>     
>     Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Link: http://lkml.kernel.org/r/1414405105.19914.169.camel@tkhai
> 
> +---------------------------+-----------+------------+------------+
> |                           | v3.18-rc2 | f6a2b54451 | 8e5859c73b |
> +---------------------------+-----------+------------+------------+
> | boot_successes            | 200       | 0          | 0          |
> | boot_failures             | 1         | 20         | 11         |
> | BUG:kernel_boot_hang      | 1         |            |            |
> | INFO:suspicious_RCU_usage | 0         | 20         | 11         |
> | backtrace:do_fork         | 0         | 20         | 11         |
> +---------------------------+-----------+------------+------------+
> 
> [    0.060187] 
> [    0.060500] ===============================
> [    0.060500] ===============================
> [    0.061307] [ INFO: suspicious RCU usage. ]
> [    0.061307] [ INFO: suspicious RCU usage. ]
> [    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
> [    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
> [    0.063049] -------------------------------
> 
> git bisect start 8e5859c73b9f45602222441a23eba899bb24c82e 522e980064c24d3dd9859e9375e17417496567cf --
> git bisect  bad 259820751fd17a4b49098429c68c2c0adfd1c9ed  # 21:11      0-      2  Merge branch 'sched/core'
> git bisect  bad 8c64bf8de891aa51e916b51a3f7992321ec19b63  # 21:15      0-      1  Merge branch 'sched/urgent'
> git bisect  bad fd457f2bafdc4e367d1814ac395035a35980783f  # 21:27      0-      7  sched/fair: Care divide error in update_task_scan_period()
> git bisect  bad fb5b330f079e243dcc831e9a3d65b9b9fbbed7f8  # 21:36      0-      1  sched/deadline: don't replenish from a !SCHED_DEADLINE entity
> git bisect  bad f6a2b544517d33f6a1e428567bda96fd859ce1c9  # 21:41      0-      2  sched: Fix race between task_group and sched_task_group
> # first bad commit: [f6a2b544517d33f6a1e428567bda96fd859ce1c9] sched: Fix race between task_group and sched_task_group
> git bisect good cac7f2429872d3733dc3f9915857b1691da2eb2f  # 21:58     60+      1  Linux 3.18-rc2
> git bisect  bad 8e5859c73b9f45602222441a23eba899bb24c82e  # 22:00      0-     11  Merge branch 'sched/wait'
> git bisect good cac7f2429872d3733dc3f9915857b1691da2eb2f  # 22:05     60+      1  Linux 3.18-rc2
> git bisect good 7a891e6323e963f3301e44bdeee734028e34d390  # 22:14     60+      0  Add linux-next specific files for 20141027
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=quantal-core-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
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
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com


