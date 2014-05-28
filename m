Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaE1BEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:04:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:11393 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaE1BET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:04:19 -0400
Message-ID: <53853604.50500@huawei.com>
Date: Wed, 28 May 2014 09:04:04 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>, Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>	 <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com> <1401196807.5134.132.camel@marge.simpson.net>
In-Reply-To: <1401196807.5134.132.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 21:20, Mike Galbraith wrote:
> On Tue, 2014-05-27 at 20:50 +0800, Libo Chen wrote:
> 
>> in my box:
>>
>> perf top -g --sort=symbol
>>
>> Events: 3K cycles
>>  73.27%  [k] read_hpet
>>   4.30%  [k] _raw_spin_lock_irqsave
>>   1.88%  [k] __schedule
>>   1.00%  [k] idle_cpu
>>   0.91%  [k] native_write_msr_safe
>>   0.68%  [k] select_task_rq_fair
>>   0.51%  [k] module_get_kallsym
>>   0.49%  [.] sem_post
>>   0.44%  [.] main
>>   0.41%  [k] menu_select
>>   0.39%  [k] _raw_spin_lock
>>   0.38%  [k] __switch_to
>>   0.33%  [k] _raw_spin_lock_irq
>>   0.32%  [k] format_decode
>>   0.29%  [.] usleep
>>   0.28%  [.] symbols__insert
>>   0.27%  [k] tick_nohz_stop_sched_tick
>>   0.27%  [k] update_stats_wait_end
>>   0.26%  [k] apic_timer_interrupt
>>   0.25%  [k] enqueue_entity
>>   0.25%  [k] sched_clock_local
>>   0.24%  [k] _raw_spin_unlock_irqrestore
>>   0.24%  [k] select_idle_sibling
> 
> read_hpet?  Are you booting box notsc or something?  Migration cost is
> the least of your worries.

oh yes, no tsc only hpet in my box. I don't know hhy is read_hpet is hot.
but when I bind 3-th tasks to percpu,cost will be rapid decline, yet perf
shows read_hpet is still hot.

after bind

Events: 561K cycles
 64.18%  [kernel]              [k] read_hpet
  5.51%  usleep                [.] main
  2.71%  [kernel]              [k] __schedule
  1.82%  [kernel]              [k] _raw_spin_lock_irqsave
  1.56%  libc-2.11.3.so        [.] usleep
  1.07%  [kernel]              [k] apic_timer_interrupt
  0.89%  libc-2.11.3.so        [.] __GI___libc_nanosleep
  0.82%  [kernel]              [k] native_write_msr_safe
  0.82%  [kernel]              [k] ktime_get
  0.71%  [kernel]              [k] trace_hardirqs_off
  0.63%  [kernel]              [k] __switch_to
  0.60%  [kernel]              [k] _raw_spin_unlock_irqrestore
  0.47%  [kernel]              [k] menu_select
  0.46%  [kernel]              [k] _raw_spin_lock
  0.45%  [kernel]              [k] enqueue_entity
  0.45%  [kernel]              [k] sched_clock_local
  0.43%  [kernel]              [k] try_to_wake_up
  0.42%  [kernel]              [k] hrtimer_nanosleep
  0.36%  [kernel]              [k] do_nanosleep
  0.35%  [kernel]              [k] _raw_spin_lock_irq
  0.34%  [kernel]              [k] rb_insert_color
  0.29%  [kernel]              [k] update_curr
  0.29%  [kernel]              [k] native_sched_clock
  0.28%  [kernel]              [k] hrtimer_interrupt
  0.28%  [kernel]              [k] rcu_idle_exit_common
  0.27%  [kernel]              [k] hrtimer_init
  0.27%  [kernel]              [k] __hrtimer_start_range_ns
  0.26%  [kernel]              [k] __rb_erase_color
  0.26%  [kernel]              [k] lock_hrtimer_base
  0.25%  [kernel]              [k] trace_hardirqs_on
  0.23%  [kernel]              [k] rcu_idle_enter_common
  0.23%  [kernel]              [k] cpuidle_idle_call
  0.23%  [kernel]              [k] finish_task_switch
  0.22%  [kernel]              [k] set_next_entity
  0.22%  [kernel]              [k] cpuacct_charge
  0.22%  [kernel]              [k] pick_next_task_fair
  0.21%  [kernel]              [k] sys_nanosleep
  0.20%  [kernel]              [k] rb_next
  0.20%  [kernel]              [k] start_critical_timings
> 
> -Mike
> 
> 
> 


