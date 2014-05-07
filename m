Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaEGKgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:36:45 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39489 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEGKgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405071203150.6261@ionos.tec.linutronix.de>
References: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1405071203150.6261@ionos.tec.linutronix.de>
Date: Wed, 7 May 2014 16:06:43 +0530
Message-ID: <CAKohpon3J7c1waqcN_sqOKw=2ahzF2tk4yT8+e8fndxKobtqiA@mail.gmail.com>
Subject: Re: [PATCH V2] clocksource: register cpu notifier to remove timer
 from dying CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 15:38, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 9 Apr 2014, Viresh Kumar wrote:
>> This patch tries to fix this by registering cpu notifiers from clocksource core,
>> only when we start clocksource-watchdog. And if on the CPU_DEAD notification it
>> is found that dying CPU was the CPU on which this timer is queued on, then it is
>> removed from that CPU and queued to next CPU.
>
> Gah, no. We realy don't want more notifier crap.

Agreed, and could have used the generic ones, probably.

> It's perfectly fine for the watchdog timer to be moved around on cpu
> down.

Functionally? Yes. Then handler doesn't have any CPU specific stuff to
do here and so queuing it on any cpu is fine.

> And the timer itself is not pinned at all. add_timer_on() does
> not set the pinned bit.

The perception I had is this:
- mod_timer() is a more complicated form of add_timer() as it has to
tackle with migration and removal of timers as well. Otherwise they
should work in similar way.
- There is no PINNED bit which can be set, its just a parameter to
__mod_timer() to decide which CPU the timer should fire on.
- And by the 'name add_timer_on()', we must guarantee that timer
fires on the CPU its being added to, otherwise it may break things
for many. There might be users which want to run the handler
on a particular CPU due to some CPU-specific stuff they want to do.
And have used add_timer_on()...

But looking at your reply, it looks that add_timer_on() doesn't
guarantee that timer would fire on the CPU mentioned? Is that the
case for mod_timer_pinned() as well ?

And if that's the case what do we want should we do with these
timers (i.e. ones added with add_timer_on or mod_timer_pinned)
when we try to quiesce a cpu using cpuset.quiesce [1]?

--
viresh

[1] https://lkml.org/lkml/2014/4/4/99
