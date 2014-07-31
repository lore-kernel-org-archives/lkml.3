Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaGaHzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:55:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45577 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932096AbaGaHzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:55:43 -0400
X-IronPort-AV: E=Sophos;i="5.00,1001,1396972800"; 
   d="scan'208";a="34006721"
Message-ID: <53D9F692.2090103@cn.fujitsu.com>
Date: Thu, 31 Jul 2014 15:56:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [scheduler] BUG: unable to handle kernel paging request at 000000000000ce50
References: <20140730135616.GK16537@localhost>
In-Reply-To: <20140730135616.GK16537@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 09:56 PM, Fengguang Wu wrote:
> Hi Christoph,
> 
> FYI, this commit seems to convert some kernel boot hang bug into
> different BUG messages.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17-consistent-ops
> commit 9b0c63851edaf54e909475fe2a0946f57810e98a
> Author:     Christoph Lameter <cl@linux.com>
> AuthorDate: Fri Jun 20 14:31:18 2014 -0500
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Fri Jul 18 19:21:39 2014 -0400
> 
>     scheduler: Replace __get_cpu_var with this_cpu_ptr
>     
>     Convert all uses of __get_cpu_var for address calculation to use
>     this_cpu_ptr instead.


-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_ptr(load_balance_mask);


I think the conversion is wrong. it should be
			*this_cpu_ptr(&load_balance_mask);

there are several such mistakes in the patch.

>     
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Acked-by: Ingo Molnar <mingo@kernel.org>
>     Signed-off-by: Christoph Lameter <cl@linux.com>
>     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> 
> +-----------------------------------------------------------+------------+------------+------------+
> |                                                           | 9dfcba84af | 9b0c63851e | e65347f54c |
> +-----------------------------------------------------------+------------+------------+------------+
> | boot_successes                                            | 1058       | 129        | 38         |
> | boot_failures                                             | 302        | 231        | 3          |
> | BUG:kernel_boot_hang                                      | 302        |            |            |
> | BUG:unable_to_handle_kernel_paging_request                | 0          | 230        | 3          |
> | Oops                                                      | 0          | 230        | 3          |
> | RIP:load_balance                                          | 0          | 230        | 3          |
> | backtrace:__alloc_workqueue_key                           | 0          | 214        | 3          |
> | backtrace:usermodehelper_init                             | 0          | 214        | 3          |
> | backtrace:kernel_init_freeable                            | 0          | 214        | 3          |
> | backtrace:schedule                                        | 0          | 16         |            |
> | backtrace:smpboot_thread_fn                               | 0          | 2          |            |
> | kernel_BUG_at_kernel/smpboot.c                            | 0          | 1          |            |
> | invalid_opcode                                            | 0          | 1          |            |
> | RIP:smpboot_thread_fn                                     | 0          | 1          |            |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 1          |            |
> +-----------------------------------------------------------+------------+------------+------------+
> 
> [    0.260658] Good, all   2 testcases passed! |
> [    0.261298] ---------------------------------
> [    0.261951] smpboot: Total of 2 processors activated (10773.32 BogoMIPS)
> [    0.263759] BUG: unable to handle kernel paging request at 000000000000ce50
> [    0.263759] IP: [<ffffffff8110d4e8>] load_balance+0x48/0xce0
> [    0.263759] PGD 0 
> [    0.263759] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    0.263759] Modules linked in:
> [    0.263777] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00154-g9b0c638 #2
> [    0.264811] task: ffff880000188000 ti: ffff88000018c000 task.ti: ffff88000018c000
> [    0.265805] RIP: 0010:[<ffffffff8110d4e8>]  [<ffffffff8110d4e8>] load_balance+0x48/0xce0
> [    0.267010] RSP: 0000:ffff88000018fa18  EFLAGS: 00010002
> [    0.267856] RAX: 0000000000000000 RBX: ffff88000020d7a0 RCX: 0000000000000002
> [    0.269009] RDX: ffff88000020d7a0 RSI: ffff8800123d1840 RDI: 0000000000000000
> [    0.270000] RBP: ffff88000018faf8 R08: ffff88000018fb3c R09: 0000000000000001
> [    0.270000] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
> [    0.270000] R13: 00000000ffff8b4e R14: 0000000000000000 R15: ffff88000020d7a0
> [    0.270000] FS:  0000000000000000(0000) GS:ffff880012200000(0000) knlGS:0000000000000000
> [    0.270000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.270000] CR2: 000000000000ce50 CR3: 0000000001f2f000 CR4: 00000000000406b0
> [    0.270000] Stack:
> [    0.270000]  ffff88000018fb3c 0000000200188710 ffff88000018fa38 0000000000000000
> [    0.270000]  ffff88000020d7a0 ffffffff00000000 ffff880000188000 0000000000000000
> [    0.270000]  ffff88000018fa90 0000000000000002 0000000000000006 ffff8800123d1840
> [    0.270000] Call Trace:
> [    0.270000]  [<ffffffff81048f85>] ? kvm_clock_read+0x35/0x50
> [    0.270000]  [<ffffffff81010c80>] ? sched_clock+0x10/0x20
> [    0.270000]  [<ffffffff810ff564>] ? sched_clock_local+0x64/0xe0
> [    0.270000]  [<ffffffff8110eebe>] pick_next_task_fair+0x50e/0xb30
> [    0.270000]  [<ffffffff8110ece0>] ? pick_next_task_fair+0x330/0xb30
> [    0.270000]  [<ffffffff81a2f402>] __schedule+0x1e2/0xca0
> [    0.270000]  [<ffffffff81a303fc>] schedule+0x1c/0x30
> [    0.270000]  [<ffffffff81a2ec4c>] schedule_timeout+0x1fc/0x260
> [    0.270000]  [<ffffffff810ff95f>] ? sched_clock_cpu+0x10f/0x140
> [    0.270000]  [<ffffffff810ff9c2>] ? local_clock+0x32/0x60
> [    0.270000]  [<ffffffff81a37c5a>] ? _raw_spin_unlock_irq+0x4a/0x80
> [    0.270000]  [<ffffffff81125a04>] ? trace_hardirqs_on_caller+0x1f4/0x2c0
> [    0.270000]  [<ffffffff81a31836>] wait_for_completion_killable+0x116/0x230
> [    0.270000]  [<ffffffff810fb080>] ? try_to_wake_up+0x5c0/0x5c0
> [    0.270000]  [<ffffffff810d9aa0>] ? process_one_work+0x6d0/0x6d0
> [    0.270000]  [<ffffffff810e59de>] kthread_create_on_node+0x13e/0x240
> [    0.270000]  [<ffffffff810ff95f>] ? sched_clock_cpu+0x10f/0x140
> [    0.270000]  [<ffffffff81a31774>] ? wait_for_completion_killable+0x54/0x230
> [    0.270000]  [<ffffffff81125a04>] ? trace_hardirqs_on_caller+0x1f4/0x2c0
> [    0.270000]  [<ffffffff810ddec7>] __alloc_workqueue_key+0x717/0x940
> [    0.270000]  [<ffffffff8133eb3f>] ? alloc_cpumask_var_node+0x4f/0xa0
> [    0.270000]  [<ffffffff8133ebf6>] ? zalloc_cpumask_var_node+0x16/0x20
> [    0.270000]  [<ffffffff82541860>] ? sched_init_smp+0x51d/0x533
> [    0.270000]  [<ffffffff8253fc2f>] usermodehelper_init+0x38/0x5d
> [    0.270000]  [<ffffffff82523911>] kernel_init_freeable+0x249/0x427
> [    0.270000]  [<ffffffff81a1fe50>] ? kernel_init+0x10/0x190
> [    0.270000]  [<ffffffff81a1fe40>] ? rest_init+0x220/0x220
> [    0.270000]  [<ffffffff81a1fe50>] kernel_init+0x10/0x190
> [    0.270000]  [<ffffffff81a391fc>] ret_from_fork+0x7c/0xb0
> [    0.270000]  [<ffffffff81a1fe40>] ? rest_init+0x220/0x220
> [    0.270000] Code: 48 ff 05 7c dd 57 01 89 bd 58 ff ff ff 48 8b 02 48 89 95 40 ff ff ff 89 8d 2c ff ff ff 4c 89 85 20 ff ff ff 48 89 85 38 ff ff ff <48> 8b 05 61 f9 ef 7e 65 48 03 04 25 18 ca 00 00 4c 8d 6d 80 48 
> [    0.270000] RIP  [<ffffffff8110d4e8>] load_balance+0x48/0xce0
> [    0.270000]  RSP <ffff88000018fa18>
> [    0.270000] CR2: 000000000000ce50
> [    0.270000] ---[ end trace e47ac2652bc5a17c ]---
> [    0.270000] ---[ end trace e47ac2652bc5a17c ]---
> 
> git bisect start e65347f54cfc1a17a3b734a0e268433dad019f3f 1795cd9b3a91d4b5473c97f491d63892442212ab --
> git bisect  bad 5a346c7c81b1e10381e5790134b79b4e6fb4434a  # 11:00      0-     72  Merge 'pm/bleeding-edge' into devel-lkp-hsx01-x86_64-201407191600
> git bisect  bad 8024b4314b39f7d45c621a6492a6b49078f8da5a  # 11:00    120-      2  Merge 'percpu/for-3.17-consistent-ops' into devel-lkp-hsx01-x86_64-201407191600
> git bisect good deebbfe3e05e145d25b065a792b3f57436ea9e06  # 11:10    360+     51  0day base guard for 'devel-lkp-hsx01-x86_64-201407191600'
> git bisect good d672f939bc81513d28a5bfc570ed2f17d8f5b34a  # 11:31    360+     16  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem
> git bisect good d14aef3872bd25af5355a10ad5235556ac83fcfd  # 11:50    360+     75  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 6b233d1fb6da79d7bf86e0cb7c03e56ef7c6d39b  # 11:53      0-     14  drivers/cpuidle: Replace __get_cpu_var uses for address calculation
> git bisect good 22d368544b0ed9093a3db3ee4e00a842540fcecd  # 12:15    360+     69  Merge tag 'trace-fixes-v3.16-rc5-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 9dfcba84af450d8685e3b7af9eea98bf1bea5b1e  # 12:22    360+    157  kernel misc: Replace __get_cpu_var uses
> git bisect  bad 2c20d34275287784397fdeb995c9686f3208fc5e  # 12:24      0-     10  block: Replace __this_cpu_ptr with raw_cpu_ptr
> git bisect  bad 9b0c63851edaf54e909475fe2a0946f57810e98a  # 12:27      1-     71  scheduler: Replace __get_cpu_var with this_cpu_ptr
> # first bad commit: [9b0c63851edaf54e909475fe2a0946f57810e98a] scheduler: Replace __get_cpu_var with this_cpu_ptr
> git bisect good 9dfcba84af450d8685e3b7af9eea98bf1bea5b1e  # 13:48   1000+    302  kernel misc: Replace __get_cpu_var uses
> git bisect  bad e65347f54cfc1a17a3b734a0e268433dad019f3f  # 13:48      0-      3  0day head guard for 'devel-lkp-hsx01-x86_64-201407191600'
> git bisect good f83971912231fe5390d2357442b6c25bb8076d9b  # 13:57   1000+    262  Merge tag 'gfs2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes
> git bisect good 58e323c3ee94f1abcecdeeef211a27d1c106c2b3  # 14:10   1000+    100  Add linux-next specific files for 20140718
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
> 	panic=10
> 	softlockup_panic=1
> 	nmi_watchdog=panic
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
> 
> 
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

