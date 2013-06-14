Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3FNQD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:03:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:32994 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3FNQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130614122608.GK5146@linux.vnet.ibm.com>
References: <20130613131057.GA15997@somewhere>
	<20130613140207.GW133453@redhat.com>
	<20130613142210.GD16339@somewhere>
	<20130613144515.GX133453@redhat.com>
	<20130613145601.GE16339@somewhere>
	<20130613152059.GA133453@redhat.com>
	<1371138491.9844.288.camel@gandalf.local.home>
	<CAK7N6vqtnoNzRNodN6T0wysMYgPD+-SgPZLXAvRu3px7TUUvHQ@mail.gmail.com>
	<1371143779.9844.297.camel@gandalf.local.home>
	<CAK7N6vqOQijcZEEuJKFbHKEaULnx8bCkaxSpBaiTe1+VGT+D5w@mail.gmail.com>
	<20130614122608.GK5146@linux.vnet.ibm.com>
Date: Fri, 14 Jun 2013 21:33:27 +0530
Message-ID: <CAK7N6vrCuWd4Q2hquJK9-HED4xyjC7hsCOUdvK3dHEetatzcfw@mail.gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
From: anish singh <anish198519851985@gmail.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Paul & Steve for replying.
On Fri, Jun 14, 2013 at 5:56 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Jun 14, 2013 at 09:47:31AM +0530, anish singh wrote:
>> On Thu, Jun 13, 2013 at 10:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Thu, 2013-06-13 at 21:51 +0530, anish singh wrote:
>> >
>> >> > The concept behind full dynamic ticks is very easy. When you set a given
>> >> > CPU(s) to dynamic tick, when it only has a single task scheduled on that
>> >> > CPU, it disables the periodic tick. This removes essentially *all*
>> >>
>> >> Documentation/timers/highres.txt states that
>> >> hrtimer_stop_sched_tick() is called when a CPU goes into idle state.Would
>> >> you mind elaborating "single task scheduled on that CPU"?
>> >> I am bit new to this so please excuse me if the question is too basic.
>> >
>> > That's the old CONFIG_NO_HZ, which only disables the tick on idle. What
>> > we are working on is to also disable the tick when there's only one task
>> > running on a given CPU. Why have as schedule tick when there's nothing
>> > to schedule?
>> >
>> > 3.10 now has new config options:
>> >
>> > CONFIG_NO_HZ_PERIODIC - which is NO_HZ disabled
>> >    (the old # CONFIG_NO_HZ not set)
>> >
>> > CONFIG_NO_HZ_IDLE - which is what CONFIG_NO_HZ use to be.
>> >
>> > Note, CONFIG_NO_HZ still exists and if set, will make CONFIG_NO_HZ_IDLE
>> > the default. This was to keep the same configuration for people who
>> > update their kernel and run make oldconfig.
>> >
>> > Then there's the new:
>> >
>> > CONFIG_NO_HZ_FULL - this enables CONFIG_NO_HZ_IDLE plus adds the new
>> > feature with disabling the tick when only one task is running on a given
>> > CPU.
>>
>> Thanks and some more explanation in below documents.
>> Documentation/timers/NO_HZ.txt
>> Documentation/timers/highres.txt
>> >
>> >
>> >> > latency from the kernel! That is, if the task is doing some complex
>> >> > calculations, it wont be interrupted for kernel maintenance. A lot of
>> >> > Red Hat customers would love to have this feature. It allows for
>> >> > extremely low latency actions even without a real-time kernel. Heck, it
>> >> > works without even kernel preemption.
>> >> >
>> >> > Now removing the periodic tick is not a trivial task, and this is where
>> >>
>> >> You mean getting rid of period ticks in the kernel code is not easy as there
>> >> are many features such as perf is dependent on it right and that is why
>> >> instead of completely removing periodic ticks we just set the periodic tick
>> >> to happen at 1HZ instead of CONFIG_HZ value?
>> >
>> > IIRC, the reason for moving to 1 HZ is so that the scheduler doesn't get
>> > confused with overflows. It still needs to handle time keeping for
>> "overflows" meaning the tick happening at 1HZ?
>> However as I see here in this patch http://lwn.net/Articles/549592/ -
>> you have plans to move it to 0Hz then how does scheduler cope
>> with this?Does it not need this information to schedule a different
>> task when the current task on "adaptive-ticks CPU" is done?
>
> When the current task completed, it will enter the kernel, allowing
> the scheduler to take over.
>
> If a second task awakens or is created, there will either be some sort
> of interrupt to the CPU itself, or to some other CPU, and this other
> CPU will IPI the first CPU.  Either way, the scheduler gains control
> when it needs it -- but avoids continually interrupting the task.
>
>> Anyway doesn't "future works" should be part of No-hz.txt document?
>
> It does, please see the very last bullet of the document:
>
> o       Some process-handling operations still require the occasional
>         scheduling-clock tick.  These operations include calculating CPU
>         load, maintaining sched average, computing CFS entity vruntime,
>         computing avenrun, and carrying out load balancing.  They are
>         currently accommodated by scheduling-clock tick every second
>         or so.  On-going work will eliminate the need even for these
>         infrequent scheduling-clock ticks.
>
> Here, "the occasional scheduling-clock tick" is the 1Hz tick that

May I know why we zeroed in on 1Hz? Is there any logical reason
or just because it is above 0Hz?
>
>                                                         Thanx, Paul
>
>> > managing how to schedule tasks according to CFS.
>> >
>> > Everything else shouldn't depend on the tick... period.
>> >
>> > -- Steve
>> >
>> >> > all our issues come from. In fact, we can not even completely remove the
>> >> > tick yet, we just move it to 1 HZ instead of whatever the CONFIG_HZ is
>> >> > set to. We have to handle everything that depends on that tick, which
>> >> > includes perf, among other things.
>> >> >
>> >
>> >
>>
>
