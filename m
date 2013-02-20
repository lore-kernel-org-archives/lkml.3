Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab3BTLQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:16:32 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49669 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047Ab3BTLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:16:31 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 19:16:29 +0800
Message-ID: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
Subject: too many timer retries happen when do local timer swtich with
 broadcast timer
From: Jason Liu <liu.h.jason@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for so long email, please be patient... thanks,

I have seen too many timer retries happen when do local timer switch
with broadcast
timeron ARM Cortex A9 SMP(4 cores), see the following log such as:
retries: 36383

root@~$ cat /proc/timer_list
Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 3
now at 3297691988044 nsecs

cpu: 0
 clock 0:
  .base:       8c0084b8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
[...]

Tick Device: mode:     1
Broadcast device
Clock Event Device: mxc_timer1
 max_delta_ns:   1431655863333
 min_delta_ns:   85000
 mult:           12884901
 shift:          32
 mode:           3
 next_event:     3297700000000 nsecs
 set_next_event: v2_set_next_event
 set_mode:       mxc_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        92
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 0000000a


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           3
 next_event:     3297700000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        36383

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           1
 next_event:     3297720000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        6510

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           3
 next_event:     3297700000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        790

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: local_timer
 max_delta_ns:   8624432320
 min_delta_ns:   1000
 mult:           2138893713
 shift:          32
 mode:           1
 next_event:     3298000000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        6873


Since on our platform, the local timer will stop when enter C3 state,
we need switch the local timer
to bc timer when enter the state and switch back when exit from the
that state. the code is like this:

void arch_idle(void)
{
....
clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);

enter_the_wait_mode();

clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
}

when the broadcast timer interrupt arrives(this interrupt just wakeup
the ARM, and ARM has no chance
to handle it since local irq is disabled. In fact it's disabled in
cpu_idle() of arch/arm/kernel/process.c)

the broadcast timer interrupt will wake up the CPU and run:

clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);    ->
tick_broadcast_oneshot_control(...);
->
tick_program_event(dev->next_event, 1);
->
tick_dev_program_event(dev, expires, force);
->
for (i = 0;;) {
                int ret = clockevents_program_event(dev, expires, now);
                if (!ret || !force)
                        return ret;

                dev->retries++;
                ....
                now = ktime_get();
                expires = ktime_add_ns(now, dev->min_delta_ns);
}
clockevents_program_event(dev, expires, now);

        delta = ktime_to_ns(ktime_sub(expires, now));

        if (delta <= 0)
                return -ETIME;

when the bc timer interrupt arrives,  which means the last local timer
expires too. so,
clockevents_program_event will return -ETIME, which will cause the
dev->retries++
when retry to program the expired timer.

Even under the worst case, after the re-program the expired timer,
then CPU enter idle
quickly before the re-progam timer expired, it will make system
ping-pang forever,

switch to bc timer->wait->bc timer expires->wakeup->switch to loc timer->  |
 ^
                                                         |
 |-------------------<-enter idle <- reprogram the expired loc timer
------------------<

I have run into the worst case on my project. I think this is the
common issue on ARM platform.

What do you think how we can fix this problem?

Thanks you.

Best Regards,
Jason Liu
