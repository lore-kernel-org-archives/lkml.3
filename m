Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaE0MvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:51:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28862 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE0MvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:51:09 -0400
Message-ID: <53848A2C.5010209@huawei.com>
Date: Tue, 27 May 2014 20:50:52 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com> <1401184553.5134.115.camel@marge.simpson.net>
In-Reply-To: <1401184553.5134.115.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 17:55, Mike Galbraith wrote:
> On Tue, 2014-05-27 at 15:56 +0800, Libo Chen wrote: 
>> > On 2014/5/26 22:19, Mike Galbraith wrote:
>>> > > On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
>>>> > >> On 2014/5/26 13:11, Mike Galbraith wrote:
>>> > > 
>>>>> > >>> Your synthetic test is the absolute worst case scenario.  There has to
>>>>> > >>> be work between wakeups for select_idle_sibling() to have any chance
>>>>> > >>> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
>>>> > >>
>>>> > >> not synthetic, it is a real problem in our product. under no load, waste
>>>> > >> much cpu time.
>>> > > 
>>> > > What happens in your product if you apply the commit I pointed out?
>> > 
>> > under no load, cpu usage is up to 60%, but the same apps cost 10% on
>> > susp sp1.  The apps use a lot of timer.
> Something is rotten.  3.14-rt contains that commit, I ran your test with
> 256 threads on 64 core box, saw ~4%.
> 
> Putting master/nopreempt config on box and doing the same test, box is
> chewing up truckloads of CPU, but not from migrations. 
> 
> perf top -g --sort=symbol
in my box:

perf top -g --sort=symbol

Events: 3K cycles
 73.27%  [k] read_hpet
  4.30%  [k] _raw_spin_lock_irqsave
  1.88%  [k] __schedule
  1.00%  [k] idle_cpu
  0.91%  [k] native_write_msr_safe
  0.68%  [k] select_task_rq_fair
  0.51%  [k] module_get_kallsym
  0.49%  [.] sem_post
  0.44%  [.] main
  0.41%  [k] menu_select
  0.39%  [k] _raw_spin_lock
  0.38%  [k] __switch_to
  0.33%  [k] _raw_spin_lock_irq
  0.32%  [k] format_decode
  0.29%  [.] usleep
  0.28%  [.] symbols__insert
  0.27%  [k] tick_nohz_stop_sched_tick
  0.27%  [k] update_stats_wait_end
  0.26%  [k] apic_timer_interrupt
  0.25%  [k] enqueue_entity
  0.25%  [k] sched_clock_local
  0.24%  [k] _raw_spin_unlock_irqrestore
  0.24%  [k] select_idle_sibling
  0.22%  [k] number
  0.22%  [k] kallsyms_expand_symbol
  0.21%  [k] rcu_irq_exit
  0.20%  [k] ktime_get
  0.20%  [k] rb_insert_color
  0.20%  [k] set_next_entity
  0.19%  [k] vsnprintf
  0.19%  [k] try_to_wake_up
  0.18%  [k] __hrtimer_start_range_ns
  0.18%  [k] update_cfs_load
  0.17%  [k] rcu_idle_exit_common
  0.17%  [k] do_nanosleep
  0.17%  [.] __GI___libc_nanosleep
  0.17%  [k] trace_hardirqs_off
  0.16%  [k] irq_exit
  0.16%  [k] timerqueue_add


