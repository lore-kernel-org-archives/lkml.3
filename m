Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3CGBPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:15:04 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:45681 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3CGBPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:15:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130306191408.GN1227@htj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
	<20130305163228.GA12795@htj.dyndns.org>
	<CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
	<20130306191408.GN1227@htj.dyndns.org>
Date: Thu, 7 Mar 2013 09:15:00 +0800
Message-ID: <CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
Subject: Re: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Mar 7, 2013 at 3:14 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lei.
>
> On Wed, Mar 06, 2013 at 10:39:15PM +0800, Lei Wen wrote:
>> We find a race condition as below:
>> CPU0                                                                  CPU1
>> timer interrupt happen
>> __run_timers
>>    __run_timers::spin_lock_irq(&base->lock)
>>    __run_timers::spin_unlock_irq(&base->lock)
>>
>>    __cancel_work_timer
>>
>>    __cancel_work_timer::del_timer
>>
>>    __cancel_work_timer::wait_on_work
>>
>>    __cancel_work_timer::clear_work_data
>>    __run_timers::call_timer_fn(timer, fn, data);
>>          delayed_work_timer_fn::get_work_cwq
>>    __run_timers::spin_lock_irq(&base->lock)
>>
>> It is possible for __cancel_work_timer to be run over cpu1 __BEFORE__
>> cpu0 is ready to
>> run the timer callback, which is delayed_work_timer_fn in our case.
>
> If del_timer() happens after the timer starts running, del_timer()
> would return NULL and try_to_grab_pending() will be called which will
> return >=0 iff if successfully steals the PENDING bit (ie. it's the
> sole owner of the work item).  If del_timer() happens before the timer
> starts running, the timer function would never run.

If del_timer() happen before __run_timers() is called, while timer irq
already happen,
would it return 1 for the timer is still not detached in __run_timers()?
If it is possible, then we would call try_to_grab_pending(), so that
work->data would
be cleared in this way.

>
> clear_work_data() happens iff the work item is confirmed to be idle.
> At this point, I'm pretty skeptical this is a bug in workqueue itself
> and strongly suggest looking at the crashing workqueue user.

Also I am not very familiar with workqueue mechanism, how many place
in kernel would
clear the work->data beside the clear_work_data()?

>From the memory, I cannot find any hint for work structure being destroyed.
So the only possible seems to me is the work->data be set by someone on purpose.

crash> struct delayed_work 0xbf03d544 -x
struct delayed_work {
  work = {
    data = {
      counter = 0x300
    },
    entry = {
      next = 0xbf03d548,
      prev = 0xbf03d548
    },
    func = 0xbf014b00
  },
  timer = {
    entry = {
      next = 0x0,
      prev = 0x200200
    },
    expires = 0x12b638b,
    base = 0xc0844e01,
    function = 0xc014c7a0 <delayed_work_timer_fn>,
    data = 0xbf03d544,
    slack = 0xffffffff,
    start_pid = 0xffffffff,
    start_site = 0x0,
    start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
  }
}

Thanks,
Lei
