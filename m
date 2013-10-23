Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3JWCrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:47:42 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43539 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3JWCrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:47:41 -0400
Message-ID: <526738C4.1080508@linux.vnet.ibm.com>
Date: Wed, 23 Oct 2013 10:47:32 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus()
References: <20131019005129.GA5979@localhost> <20131022204632.GD2490@laptop.programming.kicks-ass.net> <20131022212447.GA1373@localhost>
In-Reply-To: <20131022212447.GA1373@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102302-8878-0000-0000-0000096313F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 05:24 AM, Fengguang Wu wrote:
[snip]
> 
>> @@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>>  	p = find_process_by_pid(pid);
>>  	if (!p) {
>>  		rcu_read_unlock();
>> -		put_online_cpus();
>>  		return -ESRCH;
> 
> Yes, it fixed the WARNING.
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks for the testing :)

> 
> // The tests was queued for Michael Wang and have just finished.
> 
> There seems show up a new unreliable error "BUG:kernel_test_crashed".
> I'll increase test runs to confirm whether it's a new bug.

I guess it will be a new thread when get confirmed, let's fix this easy
one firstly, will send a formal patch later.

Regards,
Michael Wang

> 
> /kernel/x86_64-lkp/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e                                  
> +----------------------------------------------------------------------------------+-----------+--------------+--------------+
> |                                                                                  | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
> +----------------------------------------------------------------------------------+-----------+--------------+--------------+
> | good_boots                                                                       | 539       | 0            | 16           |
> | has_kernel_error_warning                                                         | 24        | 20           | 1            |
> | INFO:task_blocked_for_more_than_seconds                                          | 14        |              |              |
> | WARNING:CPU:PID:at_arch/x86/kernel/cpu/perf_event_intel.c:intel_pmu_handle_irq() | 1         |              |              |
> | INFO:NMI_handler(perf_event_nmi_handler)took_too_long_to_run:msecs               | 1         |              |              |
> | XFS(vde):xlog_verify_grant_tail:space_BBTOB(tail_blocks)                         | 5         |              |              |
> | Corruption_detected.Unmount_and_run_xfs_repair                                   | 5         |              |              |
> | metadata_I/O_error:block(xfs_trans_read_buf_map)error_numblks                    | 5         |              |              |
> | BUG:kernel_test_hang                                                             | 3         |              |              |
> | WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                                | 0         | 20           |              |
> | BUG:kernel_test_crashed                                                          | 0         | 0            | 1            |
> +----------------------------------------------------------------------------------+-----------+--------------+--------------+
> 
> /kernel/x86_64-lkp-CONFIG_SCHED_DEBUG/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e
>                                   
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> |                                                                                    | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> | good_boots                                                                         | 39        | 0            | 16           |
> | has_kernel_error_warning                                                           | 0         | 20           |              |
> | INFO:rcu_sched_self-detected_stall_on_CPU(t=jiffies_g=c=q=)                        | 0         | 1            |              |
> | INFO:task_blocked_for_more_than_seconds                                            | 0         | 6            |              |
> | INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0         | 3            |              |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0         | 3            |              |
> | WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                                  | 0         | 12           |              |
> | BUG:kernel_test_crashed                                                            | 0         | 1            |              |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> 
> /kernel/x86_64-lkp-CONFIG_SCSI_DEBUG/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e
> 
> +------------------------------------------------------------------+-----------+--------------+--------------+
> |                                                                  | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
> +------------------------------------------------------------------+-----------+--------------+--------------+
> | good_boots                                                       | 38        | 1            | 17           |
> | has_kernel_error_warning                                         | 1         | 20           | 1            |
> | Out_of_memory:Kill_process                                       | 1         |              |              |
> | Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 1         |              |              |
> | BUG:kernel_test_oops                                             | 1         |              |              |
> | WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                | 0         | 20           |              |
> | INFO:rcu_sched_self-detected_stall_on_CPU(t=jiffies_g=c=q=)      | 0         | 0            | 1            |
> +------------------------------------------------------------------+-----------+--------------+--------------+
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

