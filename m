Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab3GPCT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:19:29 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38262 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3GPCT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:19:26 -0400
Message-ID: <51E4AD9E.5050808@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 10:19:10 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <51D10899.1080501@linux.vnet.ibm.com> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com> <20130714114721.GB2178@swordfish> <20130714120629.GA4067@swordfish> <51E37194.1080103@linux.vnet.ibm.com> <51E3AA3B.9090003@linux.vnet.ibm.com> <20130715082918.GA2435@swordfish> <51E3F6EB.2050807@linux.vnet.ibm.com>
In-Reply-To: <51E3F6EB.2050807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071602-6102-0000-0000-000003DC1A4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 09:19 PM, Srivatsa S. Bhat wrote:
> On 07/15/2013 01:59 PM, Sergey Senozhatsky wrote:
>> On (07/15/13 15:52), Michael Wang wrote:
>>>>
>>>> And may be we could try below patch to get more info, I've moved the timing
>>>> of restore stop flag from 'after STOP' to 'before START', I suppose that
>>>> could create a window to prevent the work re-queue, it could at least provide
>>>> us more info...
>>>>
>>>> I think I may need to setup a environment for debug now, what's the steps to
>>>> produce this WARN?
>>>
>>> I have done some test, although I failed to reproduce this WARN, but I
>>> found that the work is still running and re-queue itself after STOP,
>>> even with my prev suggestion...
>>>
>>> However, enlarge the stop window as my suggestion below, the work do
>>> stopped...I suppose it will also stop the first WARN too.
>>>
>>> Now we need to figure out the reason...
>>>
>>
>> Hello,
>>
>> WARN is triggered during laptop suspend/hibernate phase.
>> I'll test your patch soon.
>>
> 
> Hi,
> 
> I think I finally found out what exactly is going wrong! :-)
> 
> I tried reproducing the problem on my machine, and found that the problem
> (warning about IPIs to offline CPUs) happens *only* while doing suspend/resume
> and not during halt/shutdown/reboot or regular CPU hotplug via sysfs files.
> That got me thinking and I finally figured out that commit a66b2e5 is again
> the culprit.
> 
> So here is the solution:

Nice to know the problem got solved ;-) (although there are still
something unclear to me...anyway).

Regards,
Michael Wang


> 
> On 3.11-rc1, apply these patches in the order mentioned below, and check
> whether it fixes _all_ problems (both the warnings about IPI as well as the
> lockdep splat).
> 
> 1. Patch given in:  https://lkml.org/lkml/2013/7/11/661
>    (Just apply patch 1, not the entire patchset).
> 
> 2. Apply the patch shown below, on top of the above patch:
> 
> ---------------------------------------------------------------------------
> 
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpufreq: Revert commit 2f7021a to fix CPU hotplug regression
> 
> commit 2f7021a (cpufreq: protect 'policy->cpus' from offlining during
> __gov_queue_work()) caused a regression in CPU hotplug, because it lead
> to a deadlock between cpufreq governor worker thread and the CPU hotplug
> writer task.
> 
> Lockdep splat corresponding to this deadlock is shown below:
> 
> [   60.277396] ======================================================
> [   60.277400] [ INFO: possible circular locking dependency detected ]
> [   60.277407] 3.10.0-rc7-dbg-01385-g241fd04-dirty #1744 Not tainted
> [   60.277411] -------------------------------------------------------
> [   60.277417] bash/2225 is trying to acquire lock:
> [   60.277422]  ((&(&j_cdbs->work)->work)){+.+...}, at: [<ffffffff810621b5>] flush_work+0x5/0x280
> [   60.277444] but task is already holding lock:
> [   60.277449]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81042d8b>] cpu_hotplug_begin+0x2b/0x60
> [   60.277465] which lock already depends on the new lock.
> 
> [   60.277472] the existing dependency chain (in reverse order) is:
> [   60.277477] -> #2 (cpu_hotplug.lock){+.+.+.}:
> [   60.277490]        [<ffffffff810ac6d4>] lock_acquire+0xa4/0x200
> [   60.277503]        [<ffffffff815b6157>] mutex_lock_nested+0x67/0x410
> [   60.277514]        [<ffffffff81042cbc>] get_online_cpus+0x3c/0x60
> [   60.277522]        [<ffffffff814b842a>] gov_queue_work+0x2a/0xb0
> [   60.277532]        [<ffffffff814b7891>] cs_dbs_timer+0xc1/0xe0
> [   60.277543]        [<ffffffff8106302d>] process_one_work+0x1cd/0x6a0
> [   60.277552]        [<ffffffff81063d31>] worker_thread+0x121/0x3a0
> [   60.277560]        [<ffffffff8106ae2b>] kthread+0xdb/0xe0
> [   60.277569]        [<ffffffff815bb96c>] ret_from_fork+0x7c/0xb0
> [   60.277580] -> #1 (&j_cdbs->timer_mutex){+.+...}:
> [   60.277592]        [<ffffffff810ac6d4>] lock_acquire+0xa4/0x200
> [   60.277600]        [<ffffffff815b6157>] mutex_lock_nested+0x67/0x410
> [   60.277608]        [<ffffffff814b785d>] cs_dbs_timer+0x8d/0xe0
> [   60.277616]        [<ffffffff8106302d>] process_one_work+0x1cd/0x6a0
> [   60.277624]        [<ffffffff81063d31>] worker_thread+0x121/0x3a0
> [   60.277633]        [<ffffffff8106ae2b>] kthread+0xdb/0xe0
> [   60.277640]        [<ffffffff815bb96c>] ret_from_fork+0x7c/0xb0
> [   60.277649] -> #0 ((&(&j_cdbs->work)->work)){+.+...}:
> [   60.277661]        [<ffffffff810ab826>] __lock_acquire+0x1766/0x1d30
> [   60.277669]        [<ffffffff810ac6d4>] lock_acquire+0xa4/0x200
> [   60.277677]        [<ffffffff810621ed>] flush_work+0x3d/0x280
> [   60.277685]        [<ffffffff81062d8a>] __cancel_work_timer+0x8a/0x120
> [   60.277693]        [<ffffffff81062e53>] cancel_delayed_work_sync+0x13/0x20
> [   60.277701]        [<ffffffff814b89d9>] cpufreq_governor_dbs+0x529/0x6f0
> [   60.277709]        [<ffffffff814b76a7>] cs_cpufreq_governor_dbs+0x17/0x20
> [   60.277719]        [<ffffffff814b5df8>] __cpufreq_governor+0x48/0x100
> [   60.277728]        [<ffffffff814b6b80>] __cpufreq_remove_dev.isra.14+0x80/0x3c0
> [   60.277737]        [<ffffffff815adc0d>] cpufreq_cpu_callback+0x38/0x4c
> [   60.277747]        [<ffffffff81071a4d>] notifier_call_chain+0x5d/0x110
> [   60.277759]        [<ffffffff81071b0e>] __raw_notifier_call_chain+0xe/0x10
> [   60.277768]        [<ffffffff815a0a68>] _cpu_down+0x88/0x330
> [   60.277779]        [<ffffffff815a0d46>] cpu_down+0x36/0x50
> [   60.277788]        [<ffffffff815a2748>] store_online+0x98/0xd0
> [   60.277796]        [<ffffffff81452a28>] dev_attr_store+0x18/0x30
> [   60.277806]        [<ffffffff811d9edb>] sysfs_write_file+0xdb/0x150
> [   60.277818]        [<ffffffff8116806d>] vfs_write+0xbd/0x1f0
> [   60.277826]        [<ffffffff811686fc>] SyS_write+0x4c/0xa0
> [   60.277834]        [<ffffffff815bbbbe>] tracesys+0xd0/0xd5
> [   60.277842] other info that might help us debug this:
> 
> [   60.277848] Chain exists of:
>   (&(&j_cdbs->work)->work) --> &j_cdbs->timer_mutex --> cpu_hotplug.lock
> 
> [   60.277864]  Possible unsafe locking scenario:
> 
> [   60.277869]        CPU0                    CPU1
> [   60.277873]        ----                    ----
> [   60.277877]   lock(cpu_hotplug.lock);
> [   60.277885]                                lock(&j_cdbs->timer_mutex);
> [   60.277892]                                lock(cpu_hotplug.lock);
> [   60.277900]   lock((&(&j_cdbs->work)->work));
> [   60.277907]  *** DEADLOCK ***
> 
> [   60.277915] 6 locks held by bash/2225:
> [   60.277919]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff81168173>] vfs_write+0x1c3/0x1f0
> [   60.277937]  #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811d9e3c>] sysfs_write_file+0x3c/0x150
> [   60.277954]  #2:  (s_active#61){.+.+.+}, at: [<ffffffff811d9ec3>] sysfs_write_file+0xc3/0x150
> [   60.277972]  #3:  (x86_cpu_hotplug_driver_mutex){+.+...}, at: [<ffffffff81024cf7>] cpu_hotplug_driver_lock+0x17/0x20
> [   60.277990]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff815a0d32>] cpu_down+0x22/0x50
> [   60.278007]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81042d8b>] cpu_hotplug_begin+0x2b/0x60
> [   60.278023] stack backtrace:
> [   60.278031] CPU: 3 PID: 2225 Comm: bash Not tainted 3.10.0-rc7-dbg-01385-g241fd04-dirty #1744
> [   60.278037] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
> [   60.278042]  ffffffff8204e110 ffff88014df6b9f8 ffffffff815b3d90 ffff88014df6ba38
> [   60.278055]  ffffffff815b0a8d ffff880150ed3f60 ffff880150ed4770 3871c4002c8980b2
> [   60.278068]  ffff880150ed4748 ffff880150ed4770 ffff880150ed3f60 ffff88014df6bb00
> [   60.278081] Call Trace:
> [   60.278091]  [<ffffffff815b3d90>] dump_stack+0x19/0x1b
> [   60.278101]  [<ffffffff815b0a8d>] print_circular_bug+0x2b6/0x2c5
> [   60.278111]  [<ffffffff810ab826>] __lock_acquire+0x1766/0x1d30
> [   60.278123]  [<ffffffff81067e08>] ? __kernel_text_address+0x58/0x80
> [   60.278134]  [<ffffffff810ac6d4>] lock_acquire+0xa4/0x200
> [   60.278142]  [<ffffffff810621b5>] ? flush_work+0x5/0x280
> [   60.278151]  [<ffffffff810621ed>] flush_work+0x3d/0x280
> [   60.278159]  [<ffffffff810621b5>] ? flush_work+0x5/0x280
> [   60.278169]  [<ffffffff810a9b14>] ? mark_held_locks+0x94/0x140
> [   60.278178]  [<ffffffff81062d77>] ? __cancel_work_timer+0x77/0x120
> [   60.278188]  [<ffffffff810a9cbd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> [   60.278196]  [<ffffffff81062d8a>] __cancel_work_timer+0x8a/0x120
> [   60.278206]  [<ffffffff81062e53>] cancel_delayed_work_sync+0x13/0x20
> [   60.278214]  [<ffffffff814b89d9>] cpufreq_governor_dbs+0x529/0x6f0
> [   60.278225]  [<ffffffff814b76a7>] cs_cpufreq_governor_dbs+0x17/0x20
> [   60.278234]  [<ffffffff814b5df8>] __cpufreq_governor+0x48/0x100
> [   60.278244]  [<ffffffff814b6b80>] __cpufreq_remove_dev.isra.14+0x80/0x3c0
> [   60.278255]  [<ffffffff815adc0d>] cpufreq_cpu_callback+0x38/0x4c
> [   60.278265]  [<ffffffff81071a4d>] notifier_call_chain+0x5d/0x110
> [   60.278275]  [<ffffffff81071b0e>] __raw_notifier_call_chain+0xe/0x10
> [   60.278284]  [<ffffffff815a0a68>] _cpu_down+0x88/0x330
> [   60.278292]  [<ffffffff81024cf7>] ? cpu_hotplug_driver_lock+0x17/0x20
> [   60.278302]  [<ffffffff815a0d46>] cpu_down+0x36/0x50
> [   60.278311]  [<ffffffff815a2748>] store_online+0x98/0xd0
> [   60.278320]  [<ffffffff81452a28>] dev_attr_store+0x18/0x30
> [   60.278329]  [<ffffffff811d9edb>] sysfs_write_file+0xdb/0x150
> [   60.278337]  [<ffffffff8116806d>] vfs_write+0xbd/0x1f0
> [   60.278347]  [<ffffffff81185950>] ? fget_light+0x320/0x4b0
> [   60.278355]  [<ffffffff811686fc>] SyS_write+0x4c/0xa0
> [   60.278364]  [<ffffffff815bbbbe>] tracesys+0xd0/0xd5
> [   60.280582] smpboot: CPU 1 is now offline
> 
> 
> The intent of this commit was to avoid warnings during CPU hotplug, which
> indicated that offline CPUs were getting IPIs from the cpufreq governor's
> work items. But the real root-cause of that problem was commit a66b2e5
> (cpufreq: Preserve sysfs files across suspend/resume) because it totally
> skipped all the cpufreq callbacks during CPU hotplug in the suspend/resume
> path, and hence it never actually shut down the cpufreq governor's worker
> threads during CPU offline in the suspend/resume path.
> 
> Reflecting back, the reason why we never suspected that commit as the
> root-cause earlier, was that the original issue was reported with just the
> halt command and nobody had brought in suspend/resume to the equation.
> 
> The reason for _that_ in turn, it turns out is that, earlier halt/shutdown
> was being done by disabling non-boot CPUs while tasks were frozen, just like
> suspend/resume....  but commit cf7df378a (reboot: rigrate shutdown/reboot to
> boot cpu) which came somewhere along that very same time changed that logic:
> shutdown/halt no longer takes CPUs offline.
> Thus, the test-cases for reproducing the bug were vastly different and thus
> we went totally off the trail.
> 
> Overall, it was one hell of a confusion with so many commits affecting
> each other and also affecting the symptoms of the problems in subtle
> ways. Finally, now since the original problematic commit (a66b2e5) has been
> completely reverted, revert this intermediate fix too (2f7021a), to fix the
> CPU hotplug deadlock. Phew!
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  drivers/cpufreq/cpufreq_governor.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 4645876..7b839a8 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -25,7 +25,6 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
> -#include <linux/cpu.h>
> 
>  #include "cpufreq_governor.h"
> 
> @@ -137,10 +136,8 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> 

