Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaCGB7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:59:16 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51852 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCGB7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:59:15 -0500
Message-ID: <531927EF.1080706@linaro.org>
Date: Fri, 07 Mar 2014 09:59:11 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
References: <20140303142526.GA8517@localhost>
In-Reply-To: <20140303142526.GA8517@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot!
I am working on fix.


On 03/03/2014 10:25 PM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> https://github.com/alexshi/power-scheduling.git single-balance.bak
> commit 2adc591a5cb6768ad11e63be9011906aa171148d
> Author:     Alex Shi <alex.shi@linaro.org>
> AuthorDate: Fri Feb 28 15:25:09 2014 +0800
> Commit:     Alex Shi <alex.shi@linaro.org>
> CommitDate: Sun Mar 2 09:16:38 2014 +0800
> 
>     sched/balance: replace new_idle_balance
>     
>     Curren idle_balance will pull task on half of this group. That is
>     not needed in central balance.
> 
> +-------------------------------------------------------------------------------+--------------+--------------+
> |                                                                               | a15ed8afe32b | 4242b70d68f8 |
> +-------------------------------------------------------------------------------+--------------+--------------+
> | boot_successes                                                                | 73           | 0            |
> | boot_failures                                                                 | 7            | 19           |
> | WARNING:CPU:PID:at/kernel-tests/linux/kernel/events/core.c:perf_swevent_add() | 4            |              |
> | WARNING:CPU:PID:at/kernel-tests/linux/arch/x86/kernel/cpu/amd.c:init_amd()    | 3            |              |
> | backtrace:init_amd                                                            | 3            |              |
> | backtrace:warn_slowpath_fmt                                                   | 3            |              |
> | INFO:possible_recursive_locking_detected                                      | 0            | 19           |
> | BUG:spinlock_lockup_suspected_on_CPU                                          | 0            | 7            |
> | EIP_is_at_default_send_IPI_mask_logical                                       | 0            | 7            |
> | EIP_is_at_try_to_wake_up                                                      | 0            | 4            |
> | backtrace:__alloc_workqueue_key                                               | 0            | 4            |
> | backtrace:cgroup_wq_init                                                      | 0            | 2            |
> | backtrace:kernel_init_freeable                                                | 0            | 4            |
> | BUG:kernel_boot_hang                                                          | 0            | 12           |
> | backtrace:smpboot_thread_fn                                                   | 0            | 6            |
> | backtrace:md_init                                                             | 0            | 2            |
> | backtrace:complete                                                            | 0            | 2            |
> | EIP_is_at_native_safe_halt                                                    | 0            | 1            |
> | backtrace:rescuer_thread                                                      | 0            | 1            |
> | EIP_is_at_delay_tsc                                                           | 0            | 1            |
> | EIP_is_at_do_raw_spin_lock                                                    | 0            | 2            |
> | backtrace:do_fork                                                             | 0            | 1            |
> | backtrace:kthreadd                                                            | 0            | 1            |
> | backtrace:cpu_startup_entry                                                   | 0            | 1            |
> +-------------------------------------------------------------------------------+--------------+--------------+
> 
> [    0.214781] 
> [    0.214783] =============================================
> [    0.214783] =============================================
> [    0.214784] [ INFO: possible recursive locking detected ]
> 
> git bisect start 4242b70d68f8ba165f125b9b264ae27d51ace686 cfbf8d4857c26a8a307fb7cd258074c9dcd8c691 --
> git bisect good 9b87ea06889c0c0a2541bddaeae745c0942d7bb7  # 20:30     20+      1  Merge 'tip/perf/urgent' into devel-roam-i386-201403021704
> git bisect good 99a980e45f688d10422c02f5783cc709a0c9d9da  # 20:35     20+      0  Merge 'nfs/testing' into devel-roam-i386-201403021704
> git bisect  bad 5ae8a8971fe8ffd78ef2eb0e0e8b6ef6795c8c6e  # 20:42      0-      1  Merge 'alexshi/single-balance.bak' into devel-roam-i386-201403021704
> git bisect good bc575710efe937e26d2bd541d92362b240ef0559  # 20:49     20+      1  sched: clean up task_hot function
> git bisect good 0e32dab5df39cfb1be9a937d67c877404b964324  # 20:53     20+      0  sched/balance: rebuild ovutil tree after task moving
> git bisect  bad 2adc591a5cb6768ad11e63be9011906aa171148d  # 20:58      0-      1  sched/balance: replace new_idle_balance
> git bisect good a15ed8afe32bf743621639b7df2c87ffc47d730a  # 21:01     20+      2  sched/balance: add balance_interval to tuning top level balance frequency
> # first bad commit: [2adc591a5cb6768ad11e63be9011906aa171148d] sched/balance: replace new_idle_balance
> git bisect good a15ed8afe32bf743621639b7df2c87ffc47d730a  # 21:14     60+      7  sched/balance: add balance_interval to tuning top level balance frequency
> git bisect  bad 4242b70d68f8ba165f125b9b264ae27d51ace686  # 21:14      0-     19  0day head guard for 'devel-roam-i386-201403021704'
> git bisect good 0414855fdc4a40da05221fc6062cccbc0c30f169  # 21:29     60+      6  Linux 3.14-rc5
> git bisect good dab765ebd307ac40af1a556c0b08e26938a1c9cf  # 21:43     60+      5  Add linux-next specific files for 20140303
> 
> Thanks,
> Fengguang
> 
> 
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 
