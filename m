Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaFOLcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 07:32:45 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58498 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaFOLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 07:32:43 -0400
Message-ID: <539D83EA.4000005@linux.vnet.ibm.com>
Date: Sun, 15 Jun 2014 17:00:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        lkp@01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [CPU hotplug, smp] WARNING: CPU: 1 PID: 0 at kernel/smp.c:209
 generic_smp_call_function_single_interrupt()
References: <539D4AA3.5040609@intel.com>
In-Reply-To: <539D4AA3.5040609@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061511-4790-0000-0000-0000020F7B9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 12:56 PM, Jet Chen wrote:
> Hi Srivatsa,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit ab7a42783d939cdbe729c18ab32dbf0d25746ea2
> Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> AuthorDate: Thu May 22 10:44:06 2014 +1000
> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> CommitDate: Thu May 22 10:44:06 2014 +1000
> 
>     CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline
>         During CPU offline, in the stop-machine loop, we use 2 separate stages to
>     disable interrupts, to ensure that the CPU going offline doesn't get any
>     new IPIs from the other CPUs after it has gone offline.
>         However, an IPI sent much earlier might arrive late on the target CPU
>     (possibly _after_ the CPU has gone offline) due to hardware latencies, and
>     due to this, the smp-call-function callbacks queued on the outgoing CPU
>     might not get noticed (and hence not executed) at all.
>         This is somewhat theoretical, but in any case, it makes sense to
>     explicitly loop through the call_single_queue and flush any pending
>     callbacks before the CPU goes completely offline.  So, flush the queued
>     smp-call-function callbacks in the MULTI_STOP_DISABLE_IRQ_ACTIVE stage,
>     after disabling interrupts on the active CPU.  This can be trivially
>     achieved by invoking the generic_smp_call_function_single_interrupt()
>     function itself (and since the outgoing CPU is still online at this point,
>     we won't trigger the "IPI to offline CPU" warning in this function; so we
>     are safe to call it here).
>         This way, we would have handled all the queued callbacks before going
>     offline, and also, no new IPIs can be sent by the other CPUs to the
>     outgoing CPU at that point, because they will all be executing the
>     stop-machine code with interrupts disabled.
>         Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>     Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
>     Reviewed-by: Tejun Heo <tj@kernel.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Oleg Nesterov <oleg@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 

Thanks for reporting this, but this patch has been superseded by an updated
version of the patch and you can find that here:
https://lkml.org/lkml/2014/6/10/589

Also, this (bad) patch (which you bisected to) is not in linux-next at the
moment. So I guess you tested a slightly old version of linux-next.

Thank you!

Regards,
Srivatsa S. Bhat

> 
> +------------------------------------------------------------------------------+------------+------------+
> |                                                                              | c80d40e1f2 | ab7a42783d |
> +------------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                               | 1194       | 261        |
> | boot_failures                                                                | 6          | 39         |
> | BUG:kernel_test_crashed                                                      | 6          |            |
> | WARNING:CPU:PID:at_kernel/smp.c:generic_smp_call_function_single_interrupt() | 0          | 39         |
> | backtrace:stop_machine_from_inactive_cpu                                     | 0          | 39         |
> | backtrace:mtrr_ap_init                                                       | 0          | 39         |
> | general_protection_fault                                                     | 0          | 0          |
> | RIP:__lock_acquire                                                           | 0          | 0          |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c  | 0          | 0          |
> | INFO:lockdep_is_turned_off                                                   | 0          | 0          |
> | backtrace:do_mount                                                           | 0          | 0          |
> | backtrace:SyS_mount                                                          | 0          | 0          |
> +------------------------------------------------------------------------------+------------+------------+
> 
> [   62.119017] masked ExtINT on CPU#1
> [   62.119017] numa_add_cpu cpu 1 node 0: mask now 0-1
> [   62.261606] ------------[ cut here ]------------
> [   62.261606] WARNING: CPU: 1 PID: 0 at kernel/smp.c:209 generic_smp_call_function_single_interrupt+0xc5/0x155()
> [   62.261606] IPI on offline CPU 1
> [   62.261606] Modules linked in:
> [   62.261606] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15.0-rc5-01473-gab7a427 #4510
> [   62.261606] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   62.261606]  0000000000000000 ffff88001e7e1d28 ffffffff81b01705 ffff88001e7e1d70
> [   62.261606]  ffff88001e7e1d60 ffffffff810754b3 ffffffff810e282c 0000000000000000
> [   62.261606]  0000000000000000 ffffffff82568b01 0000000000000082 ffff88001e7e1dc0
> [   62.261606] Call Trace:
> [   62.261606]  [<ffffffff81b01705>] dump_stack+0x4d/0x66
> [   62.261606]  [<ffffffff810754b3>] warn_slowpath_common+0x7f/0x98
> [   62.261606]  [<ffffffff810e282c>] ? generic_smp_call_function_single_interrupt+0xc5/0x155
> [   62.261606]  [<ffffffff81075518>] warn_slowpath_fmt+0x4c/0x4e
> [   62.261606]  [<ffffffff810e282c>] generic_smp_call_function_single_interrupt+0xc5/0x155
> [   62.261606]  [<ffffffff810f4792>] multi_cpu_stop+0xcf/0x136
> [   62.261606]  [<ffffffff810f5003>] stop_machine_from_inactive_cpu+0xf7/0x132
> [   62.261606]  [<ffffffff81056cfe>] ? mtrr_restore+0x45/0x45
> [   62.261606]  [<ffffffff810573ba>] mtrr_ap_init+0x5a/0x5c
> [   62.261606]  [<ffffffff8104689e>] identify_secondary_cpu+0x19/0x1b
> [   62.261606]  [<ffffffff8105beda>] smp_store_cpu_info+0x3d/0x3f
> [   62.261606]  [<ffffffff8105c6cc>] start_secondary+0x16e/0x254
> [   62.261606] ---[ end trace 1752731e5a47c773 ]---
> [   62.312240] KVM setup async PF for cpu 1
> 
> git bisect start 27a4e439fe5cd92b70137ae237c7aa6888c07b5a 56b54984d49285d515dc6421c93648ccdc0a06bc --
> git bisect  bad 473496a03d9dbf8654f2fd789383d71df4dc7fde  # 15:58     88-      3  Merge branch 'akpm-current/current'
> git bisect good b41b3b6c0ff37f89caf1dd5ec8f203f00d5c9080  # 16:23    300+      0  mm: page_alloc: convert hot/cold parameter and immediate callers to bool
> git bisect good a0a7e7f4b2fbf31729ea5cd5d3d5cb7ee5c0b494  # 16:44    300+      1  rtc: rtc-palmas: make of_device_id array const
> git bisect  bad ab7a42783d939cdbe729c18ab32dbf0d25746ea2  # 16:49     45-      3  CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline
> git bisect good faa7c21459067de9686cdd62cfb47685bc5c60fc  # 16:55    300+      1  fs/hfsplus/wrapper.c: replace min/casting by min_t
> git bisect good 6a2ecc87dcbae7fa62ce1f156c4ac4a52d96b3fd  # 17:01    300+      1  signals: kill rm_from_queue(), change prepare_signal() to use for_each_thread()
> git bisect good ebe499d62a3a08e94fb1067f3486e00eca49edca  # 17:09    300+      1  signals: introduce kernel_sigaction()
> git bisect good ddb7fec09b32ec61e428e7e882b6821a10d3df3f  # 17:43    300+      1  smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5
> git bisect good e840b4a6701321414618aa1fa623925368d66141  # 17:47    300+      2  cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3
> git bisect good c80d40e1f29243cf7d932b8e35126bcae0e875b4  # 18:01    300+      2  cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5
> # first bad commit: [ab7a42783d939cdbe729c18ab32dbf0d25746ea2] CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline
> git bisect good c80d40e1f29243cf7d932b8e35126bcae0e875b4  # 18:10    900+      6  cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5
> git bisect  bad 27a4e439fe5cd92b70137ae237c7aa6888c07b5a  # 18:10      0-      7  Add linux-next specific files for 20140610
> git bisect good 64b2d1fbbfda07765dae3f601862796a61b2c451  # 18:19    900+     99  Merge tag 'for-f2fs-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
> git bisect  bad 27a4e439fe5cd92b70137ae237c7aa6888c07b5a  # 18:19      0-      7  Add linux-next specific files for 20140610
> 
> 
> 
> Thanks,
> Jet
> 


-- 
Regards,
Srivatsa S. Bhat

