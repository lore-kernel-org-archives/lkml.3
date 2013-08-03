Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab3HCG4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 02:56:13 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57917 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3HCG4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 02:56:11 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
From: ethan <ethan.kernel@gmail.com>
In-Reply-To: <20130730115905.GS3008@twins.programming.kicks-ass.net>
Date: Sat, 3 Aug 2013 14:55:54 +0800
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <078B0C89-5B4A-4400-B914-28184AEA825E@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com> <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de> <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com> <20130730093519.GP3008@twins.programming.kicks-ass.net> <CABawtvNVeHbe06tbuH6Khgp_5gYmRYtk=sz9U7oE8f_x+6yg1g@mail.gmail.com> <20130730115905.GS3008@twins.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter and tglx,
 
  About which hrtimer causes the performance issue, I did some test with my home server because I am on vacation, An ASUS PC server with 4 core Intel i5 cpu inside,
Running the Stable 3.11RC3+ (removed reschedule IPI), almost got the same result as I did with Sun Servers. I suspect it is the tick_sched_timer, the evidence as following:
  While running some test tools such as http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c, the powertop
tool shows following result:
  
    PowerTOP version 1.11      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 2.2%)       Turbo Mode     0.0%
polling           0.0ms ( 0.0%)         3.21 Ghz     0.0%
C1 mwait          0.6ms ( 0.9%)         3.10 Ghz     0.0%
C2 mwait          0.5ms ( 0.1%)         3.00 Ghz     0.0%
C3 mwait          0.9ms (96.7%)         1.60 Ghz   100.0%

Wakeups-from-idle per second : 1100.9   interval: 0.3s
no ACPI power usage estimate available

Top causes for wakeups:
  23.5% (  inf)         swapper/3 : hrtimer_start_range_ns (tick_sched_timer)
  23.5% (  inf)         swapper/0 : hrtimer_start_range_ns (tick_sched_timer)
  23.5% (  inf)         swapper/2 : hrtimer_start_range_ns (tick_sched_timer)
  23.5% (  inf)         swapper/1 : hrtimer_start_range_ns (tick_sched_timer)
   2.4% (  inf)       <interrupt> : xhci_hcd
   2.4% (  inf)   USB device  3-4 : Basic Optical Mouse (Microsoft)
   0.3% (  inf)         rcu_sched : rcu_gp_kthread (process_timeout)
   0.2% (  inf)    gnome-terminal : hrtimer_start_range_ns (hrtimer_wakeup)
   0.2% (  inf)       <interrupt> : PS/2 keyboard/mouse/touchpad
   0.1% (  inf)         swapper/0 : hrtimer_start (menu_hrtimer_notify)
   0.1% (  inf)         swapper/0 : clocksource_watchdog
(clocksource_watchdog)
   0.1% (  inf)         cimserver : hrtimer_start_range_ns (hrtimer_wakeup)
   0.1% (  inf)      avahi-daemon : hrtimer_start_range_ns (hrtimer_wakeup)
   0.1% (  inf)       kworker/0:1 : queue_delayed_work_on
(delayed_work_timer_fn)
   0.1% (  inf)      rtkit-daemon : hrtimer_start_range_ns (hrtimer_wakeup)

And the /proc/timers_list 

[root@localhost proc]# cat timer_list
Timer List Version: v0.7
HRTIMER_MAX_CLOCK_BASES: 4
now at 1463485951666 nsecs

cpu: 0
 clock 0:
  .base:       ffff88021ea0d2c0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88021ea0d780>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0/1
 # expires at 1463486000000-1463486000000 nsecs [in 48507 to 48507 nsecs]
 #1: <ffff88021ea0d900>, watchdog_timer_fn, S:01, hrtimer_start, watchdog/0/10
 # expires at 1464038000000-1464038000000 nsecs [in 552048507 to 552048507 nsecs]
 #2: <ffff880215b139d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-power-man/7341
 # expires at 1467041141813-1467051131812 nsecs [in 3555190320 to 3565180319 nsecs]
 #3: <ffff8802118eb8c8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, ntpd/6806
 # expires at 1469048348291-1469061256427 nsecs [in 5562396798 to 5575304934 nsecs]
 #4: <ffff88020f34b8c8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, cimservermain/6993
 # expires at 1521114040522-1521214040522 nsecs [in 57628089029 to 57728089029 nsecs]
 #5: <ffff880215b57d78>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, master/6886
 # expires at 1521833602390-1521892602389 nsecs [in 58347650897 to 58406650896 nsecs]
 #6: <ffff880213c9c238>, it_real_fn, S:01, hrtimer_start, master/6886
 # expires at 1795833601062-1795833601062 nsecs [in 332347649569 to 332347649569 nsecs]
 clock 1:
  .base:       ffff88021ea0d300
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1375508485789320552 nsecs
active timers:
 #0: <ffff8802157e5e28>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, automount/6767
 # expires at 1375509966602894000-1375509966602944000 nsecs [in 1375508503116942507 to 1375508503116992507 nsecs]
 clock 2:
  .base:       ffff88021ea0d340
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       ffff88021ea0d380
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     1375508485789320552 nsecs
active timers:
  .expires_next   : 1463487000000 nsecs
  .hres_active    : 1
  .nr_events      : 1489177
  .nr_retries     : 145
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .last_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4296130782

cpu: 1
 clock 0:
  .base:       ffff88021ea8d2c0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88021ea8d780>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/1/0
 # expires at 1463487000000-1463487000000 nsecs [in 1048507 to 1048507 nsecs]
 #1: <ffff88021ea8d900>, watchdog_timer_fn, S:01, hrtimer_start, watchdog/1/11
 # expires at 1464038000000-1464038000000 nsecs [in 552048507 to 552048507 nsecs]
 #2: <ffff88020e2739d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, hald-addon-stor/6726
 # expires at 1464211071890-1464213064889 nsecs [in 725120397 to 727113396 nsecs]
 #3: <ffff8802157c99d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rtkit-daemon/7358
 # expires at 1467525043210-1467530043209 nsecs [in 4039091717 to 4044091716 nsecs]
 #4: <ffff880213ec19d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rtkit-daemon/7359
 # expires at 1472525038227-1472525038227 nsecs [in 9039086734 to 9039086734 nsecs]
 #5: <ffff880211a29ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, crond/6941
 # expires at 1475497502106-1475497552106 nsecs [in 12011550613 to 12011600613 nsecs]
 #6: <ffff88021519d9d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, hald/6673
 # expires at 1490211101222-1490241071221 nsecs [in 26725149729 to 26755119728 nsecs]
 #7: <ffff880215055d78>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, certmonger/7048
 # expires at 1492497024071-1492527024070 nsecs [in 29011072578 to 29041072577 nsecs]
 #8: <ffff88021182d8c8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rsyslogd/6412
 # expires at 86416926181907-86417026181907 nsecs [in 84953440230414 to 84953540230414 nsecs]
 clock 1:
  .base:       ffff88021ea8d300
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1375508485789320552 nsecs
active timers:
 clock 2:
  .base:       ffff88021ea8d340
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       ffff88021ea8d380
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     1375508485789320552 nsecs
active timers:
  .expires_next   : 1463487000000 nsecs
  .hres_active    : 1
  .nr_events      : 1505848
  .nr_retries     : 273
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .last_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4296130782

cpu: 2
 clock 0:
  .base:       ffff88021eb0d2c0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88021eb0d780>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/2/0
 # expires at 1463487000000-1463487000000 nsecs [in 1048507 to 1048507 nsecs]
 #1: <ffff880213f918c8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, cimserver/6992
 # expires at 1463603820300-1463604070299 nsecs [in 117868807 to 118118806 nsecs]
 #2: <ffff88021eb0d900>, watchdog_timer_fn, S:01, hrtimer_start, watchdog/2/16
 # expires at 1464050000000-1464050000000 nsecs [in 564048507 to 564048507 nsecs]
 #3: <ffff8802156939d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-settings-/7329
 # expires at 1467041063935-1467045059934 nsecs [in 3555112442 to 3559108441 nsecs]
 #4: <ffff880214db39d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gconfd-2/7310
 # expires at 1467041085986-1467071055985 nsecs [in 3555134493 to 3585104492 nsecs]
 #5: <ffff88020fb41ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, irqbalance/6442
 # expires at 1468210681330-1468210731330 nsecs [in 4724729837 to 4724779837 nsecs]
 #6: <ffff880211a5f9d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rpcbind/6461
 # expires at 1488949026351-1488979026350 nsecs [in 25463074858 to 25493074857 nsecs]
 #7: <ffff8802141ed9d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, NetworkManager/6495
 # expires at 1518210833956-1518310833956 nsecs [in 54724882463 to 54824882463 nsecs]
 #8: <ffff88021492bd78>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, qmgr/6899
 # expires at 1521592237483-1521692237483 nsecs [in 58106285990 to 58206285990 nsecs]
 #9: <ffff880214a929b8>, it_real_fn, S:01, hrtimer_start, qmgr/6899
 # expires at 1554592221196-1554592221196 nsecs [in 91106269703 to 91106269703 nsecs]
 #10: <ffff880212685ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, atd/6952
 # expires at 3620649306705-3620649356705 nsecs [in 2157163355212 to 2157163405212 nsecs]
 clock 1:
  .base:       ffff88021eb0d300
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1375508485789320552 nsecs
active timers:
 clock 2:
  .base:       ffff88021eb0d340
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       ffff88021eb0d380
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     1375508485789320552 nsecs
active timers:
  .expires_next   : 1463487000000 nsecs
  .hres_active    : 1
  .nr_events      : 1499325
  .nr_retries     : 236
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .last_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4296130782

cpu: 3
 clock 0:
  .base:       ffff88021eb8d2c0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88021eb8d780>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/3/0
 # expires at 1463487000000-1463487000000 nsecs [in 1048507 to 1048507 nsecs]
 #1: <ffff88021eb8d900>, watchdog_timer_fn, S:01, hrtimer_start, watchdog/3/21
 # expires at 1464062000000-1464062000000 nsecs [in 576048507 to 576048507 nsecs]
 #2: <ffff880215b199d8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gdm-simple-gree/7340
 # expires at 1474212089328-1474272025327 nsecs [in 10726137835 to 10786073834 nsecs]
 #3: <ffff88021402dea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, sleep/7669
 # expires at 1520896517118-1520896567118 nsecs [in 57410565625 to 57410615625 nsecs]
 #4: <ffff880214befd78>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, pickup/6898
 # expires at 1562833597553-1562933597552 nsecs [in 99347646060 to 99447646059 nsecs]
 #5: <ffff88021277d8c8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, Xorg/7216
 # expires at 1826170099331-1826270099331 nsecs [in 362684147838 to 362784147838 nsecs]
 #6: <ffff880214cda9b8>, it_real_fn, S:01, hrtimer_start, pickup/6898
 # expires at 7462833595405-7462833595405 nsecs [in 5999347643912 to 5999347643912 nsecs]
 clock 1:
  .base:       ffff88021eb8d300
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1375508485789320552 nsecs
active timers:
 #0: <ffff880212e1de28>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, cimservermain/6997
 # expires at 1375509967695245000-1375509967695295000 nsecs [in 1375508504209293507 to 1375508504209343507 nsecs]
 clock 2:
  .base:       ffff88021eb8d340
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       ffff88021eb8d380
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     1375508485789320552 nsecs
active timers:
  .expires_next   : 1463487000000 nsecs
  .hres_active    : 1
  .nr_events      : 1490001
  .nr_retries     : 347
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .last_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4296130782

Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983013276
 min_delta_ns:   13409
 mult:           61496111
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        0

tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   1377930800842
 min_delta_ns:   1000
 mult:           13387279
 shift:          27
 mode:           3
 next_event:     1463487000000 nsecs
 set_next_event: lapic_next_deadline
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   1377930800842
 min_delta_ns:   1000
 mult:           13387279
 shift:          27
 mode:           3
 next_event:     1463487000000 nsecs
 set_next_event: lapic_next_deadline
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        1

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: lapic
 max_delta_ns:   1377930800842
 min_delta_ns:   1000
 mult:           13387279
 shift:          27
 mode:           3
 next_event:     1463487000000 nsecs
 set_next_event: lapic_next_deadline
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: lapic
 max_delta_ns:   1377930800842
 min_delta_ns:   1000
 mult:           13387279
 shift:          27
 mode:           3
 next_event:     1463487000000 nsecs
 set_next_event: lapic_next_deadline
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        0

Note, I removed the reshcedule IPI for test reason, or reschedule IPI is the first reason to wake-up (In another mail I will tell why I removed the reschedule IPI).
The tick_sched_timers are issued by:

 cpu_idle_loop() => tick_nohz_idle_enter() = > tick_nohz_stop_sched_tick() = > raise_softirq_irqoff(TIMER_SOFTIRQ)----------------------------------->+
 run_timer_softirq() => tick_sched_timer()=> tick_sched_handle()=>update_process_times()=> run_local_timers() =>raise_softirq_irqoff(TIMER_SOFTIRQ)-->+
 ^----------------------------------------------------------------------------------------------------------------------------------------------------< 

Thanks,
Ethan



ÔÚ 2013-7-30£¬ÏÂÎç7:59£¬Peter Zijlstra <peterz@infradead.org> Ð´µÀ£º

> On Tue, Jul 30, 2013 at 07:44:03PM +0800, Ethan Zhao wrote:
>> Got it.
>> what tglx and you mean
>> 
>> 
>> So the expensive thing maybe not inside the schedule(), but could
>> outside the scheduler(), the more bigger forever loop.
>> 
>> This is one part of what I am facing.
> 
> Right, so it would be good if you could further diagnose the problem so
> we can come up with a solution that cures the problem while retaining
> the current 'desired' properties.
> 
> The patch you pinpointed caused a regression in that it would wake from
> NOHZ mode far too often. Could it be that the now longer idle sections
> cause your CPU to go into deeper idle modes and you're suffering from
> idle-exit latencies?

