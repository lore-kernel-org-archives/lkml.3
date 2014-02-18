Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBREwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 23:52:24 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55174 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaBREwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 23:52:22 -0500
Message-ID: <5302E6FA.508@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 12:52:10 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com
CC: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, jason.low2@hp.com, viresh.kumar@linaro.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021804-5816-0000-0000-00000C542FEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 09:55 AM, Alex Shi wrote:
> The cpu_load decays on time according past cpu load of rq. The sched_avg also decays tasks' load on time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load by decay calculation. This patch try to remove the cpu_load decay.
> 
> There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change.
> 
> V2,
> 1, This version do some tuning on load bias of target load, to maximum match current code logical.
> 2, Got further to remove the cpu_load in rq.
> 3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs
> 
> Any testing/comments are appreciated.

Tested on 12-cpu-x86 box with tip/master, ebizzy and hackbench
works fine, show little improvements for each time's testing.

ebizzy default:

BASE					PATCHED

32506 records/s                         |32785 records/s                        
real 10.00 s                            |real 10.00 s                           
user 50.32 s                            |user 49.66 s                           
sys  69.46 s                            |sys  70.19 s                           
32552 records/s                         |32946 records/s                        
real 10.00 s                            |real 10.00 s                           
user 50.11 s                            |user 50.70 s                           
sys  69.68 s                            |sys  69.15 s                           
32265 records/s                         |32824 records/s                        
real 10.00 s                            |real 10.00 s                           
user 49.46 s                            |user 50.46 s                           
sys  70.28 s                            |sys  69.34 s                           
32489 records/s                         |32735 records/s                        
real 10.00 s                            |real 10.00 s                           
user 49.67 s                            |user 50.21 s                           
sys  70.12 s                            |sys  69.54 s                           
32490 records/s                         |32662 records/s                        
real 10.00 s                            |real 10.00 s                           
user 50.01 s                            |user 50.07 s                           
sys  69.79 s                            |sys  69.68 s                           
32471 records/s                         |32784 records/s                        
real 10.00 s                            |real 10.00 s 
32471 records/s                         |32784 records/s                        
real 10.00 s                            |real 10.00 s                           
user 49.73 s                            |user 49.88 s                           
sys  70.07 s                            |sys  69.87 s                           
32596 records/s                         |32783 records/s                        
real 10.00 s                            |real 10.00 s                           
user 49.81 s                            |user 49.42 s                           
sys  70.00 s                            |sys  70.30 s

hackbench 10000 loops:

BASE					PATCHED

Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 30.934                            |Time: 29.965                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.603                            |Time: 30.410                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.724                            |Time: 30.627                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.648                            |Time: 30.596                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.799                            |Time: 30.763                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.847                            |Time: 30.532                           
Running with 48*40 (== 1920) tasks.     |Running with 48*40 (== 1920) tasks.    
Time: 31.828                            |Time: 30.871                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.768                            |Time: 15.284                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.720                            |Time: 15.228                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.819                            |Time: 15.373                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.888                            |Time: 15.184
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.888                            |Time: 15.184                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.660                            |Time: 15.525                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.934                            |Time: 15.337                           
Running with 24*40 (== 960) tasks.      |Running with 24*40 (== 960) tasks.     
Time: 15.669                            |Time: 15.357                           
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.699                             |Time: 7.458                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.693                             |Time: 7.498                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.705                             |Time: 7.439                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.664                             |Time: 7.553                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.603                             |Time: 7.470                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.651                             |Time: 7.491                            
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.647                             |Time: 7.535                        
Running with 12*40 (== 480) tasks.      |Running with 12*40 (== 480) tasks.     
Time: 7.647                             |Time: 7.535                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 6.054                             |Time: 5.293                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.417                             |Time: 5.701                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.287                             |Time: 5.240                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.594                             |Time: 5.571                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.347                             |Time: 6.136                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.430                             |Time: 5.323                            
Running with 6*40 (== 240) tasks.       |Running with 6*40 (== 240) tasks.      
Time: 5.691                             |Time: 5.481                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.192                             |Time: 1.140                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.190                             |Time: 1.125                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.189                             |Time: 1.013                       
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.189                             |Time: 1.013                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.163                             |Time: 1.060                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.186                             |Time: 1.131                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.175                             |Time: 1.125                            
Running with 1*40 (== 40) tasks.        |Running with 1*40 (== 40) tasks.       
Time: 1.157                             |Time: 0.998 


BTW, I got panic while rebooting, but should not caused by
this patch set, will recheck and post the report later.

Regards,
Michael Wang



INFO: rcu_sched detected stalls on CPUs/tasks: { 7} (detected by 1, t=21002 jiffies, g=6707, c=6706, q=227)
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 7
CPU: 7 PID: 1040 Comm: bioset Not tainted 3.14.0-rc2-test+ #402
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
 0000000000000000 ffff88097f2e7bd8 ffffffff8156b38a 0000000000004f27
 ffffffff817ecb90 ffff88097f2e7c58 ffffffff81561d8d ffff88097f2e7c08
 ffffffff00000010 ffff88097f2e7c68 ffff88097f2e7c08 ffff88097f2e7c78
Call Trace:
 <NMI>  [<ffffffff8156b38a>] dump_stack+0x46/0x58
 [<ffffffff81561d8d>] panic+0xbe/0x1ce
 [<ffffffff810e6b03>] watchdog_overflow_callback+0xb3/0xc0
 [<ffffffff8111e928>] __perf_event_overflow+0x98/0x220
 [<ffffffff8111f224>] perf_event_overflow+0x14/0x20
 [<ffffffff8101eef2>] intel_pmu_handle_irq+0x1c2/0x2c0
 [<ffffffff81089af9>] ? load_balance+0xf9/0x590
 [<ffffffff81089b0d>] ? load_balance+0x10d/0x590
 [<ffffffff81562ac2>] ? printk+0x4d/0x4f
 [<ffffffff815763b4>] perf_event_nmi_handler+0x34/0x60
 [<ffffffff81575b6e>] nmi_handle+0x7e/0x140
 [<ffffffff81575d1a>] default_do_nmi+0x5a/0x250
 [<ffffffff81575fa0>] do_nmi+0x90/0xd0
 [<ffffffff815751e7>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff81089340>] ? find_busiest_group+0x120/0x7e0
 [<ffffffff81089340>] ? find_busiest_group+0x120/0x7e0
 [<ffffffff81089340>] ? find_busiest_group+0x120/0x7e0
 <<EOE>>  [<ffffffff81089b7c>] load_balance+0x17c/0x590
 [<ffffffff8108a49f>] idle_balance+0x10f/0x1c0
 [<ffffffff8108a66e>] pick_next_task_fair+0x11e/0x2a0
 [<ffffffff8107ba53>] ? dequeue_task+0x73/0x90
 [<ffffffff815712b7>] __schedule+0x127/0x670
 [<ffffffff815718d9>] schedule+0x29/0x70
 [<ffffffff8104e3b5>] do_exit+0x2a5/0x470
 [<ffffffff81066c90>] ? process_scheduled_works+0x40/0x40
 [<ffffffff8106e78a>] kthread+0xba/0xe0
 [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8157d0ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e6d0>] ? flush_kthread_worker+0xb0/0xb0
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)


> 
> This patch rebase on latest tip/master.
> The git tree for this patchset at:
>  git@github.com:alexshi/power-scheduling.git noload
> 
> Thanks
> Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

