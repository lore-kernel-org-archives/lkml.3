Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3DPSLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:11:00 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57971 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3DPSK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:10:59 -0400
MIME-Version: 1.0
In-Reply-To: <1365660333.19620.48.camel@marge.simpson.net>
References: <CAGRd_97YLsQ6MkJFgENuRKHhY30fKP4NgQmzcswgTz=abw-KRQ@mail.gmail.com>
	<1365660333.19620.48.camel@marge.simpson.net>
Date: Tue, 16 Apr 2013 14:10:58 -0400
Message-ID: <CAGRd_96xWdq4kXe_fLBKVasL2T=krHpML1mMbENxD5J+aiRCDw@mail.gmail.com>
Subject: Re: RT thread migration (?) problem
From: Phil Wilshire <sysdcs@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 2:05 AM, Mike Galbraith <bitbucket@online.de> wrote:
> On Wed, 2013-04-10 at 08:49 -0400, Phil Wilshire wrote:
>> We are using kernel 3.2.21
>>
>> It looks like we are seeing stalls or lockups when allowing rt threads to
>> migrate.
>>
>> The problem has been much reduced by pinning threads to cpus.
>>
>> However, we still see unreasonable delays in triggering a high priority
>> rt
>> monitoring thread when it, alone, is allowed to migrate cpus. If we lock
>> this monitoring thread down to a single cpu and it all seems to work
>> properly.
>> By unreasonable, I mean a delay of over 500mS or more on a Real Time
>> thread
>> expected to schedule every 250 mS.
>
> There are lots of things that can muck up your rt thread in a non-rt
> kernel.  For example, I recall I measured a transparent huge pages hit
> of 563us.  I don't recall exactly how bad cgroups memory controller was,
> but do recall it was very bad, > 300us.  I once measured proprietary
> nvidia driver IPI blasting all cores as fast as we can do that (~1MHz)
> for a full second, which was hilarious to watch, but have also seen XFS
> match that spectacular full second in kernel performance, as did ext4,
> which wasn't quite as funny for some reason.

We are, luckily , not using any video drivers. We are also using ext3
file system.

>> The kernel 3.2.21 config is attached as is the test code.
>>  We have tried other kernels and have seen exactly the same problem.
>>
>> We  have been looking at this problem for about 3 months now.. It was
>> initially exposed on an intel atom D525 cpu. The system simply seemed to
>> stop working for a period of time, sometimes over 5 seconds. All threads
>> and interrupts seemed to stop until suddenly it all woke up again.
>> Of course when the watchdog was set to 4 seconds we would get a surprise
>> reboot !!
>> When we extended the watchdog time we started to see the system recover
>> in
>> the 5 second period.
>>
>> This problem  happens very rarely on "normal" system loading, say once
>> every three months or so.
>> We managed to accelerate the problem by creating some special stress test
>> code ( attached ) that reduced the failure time to a day or so on some
>> systems.
>
> What you want to do is trap the thing with ftrace.  If you have anything
> resembling a tight latency constraint though, you'll want to switch to
> an rt kernel, there are just too many ways to get burned to the ground
> in a non-rt kernel.
>
Agreed, If possible I would like some suggestions for tracing this.
So far, during the outage, from the tracing I have captured, we get no
timer interrupts at all during the outage.
Then suddenly we get a load of them all well past their deadlines.

In the few traces we have got I have seen a lot of cpu migration and
rcu boost activity
as the system returns back to life.

When we pinned the worker threads to cpus we saw an improvement.
For the last few days with the management thread floating between cpus
our worst system has been behaving well.

 Tue Apr 16 14:02:51 2013:running 45 threads max delta 250134 us max_ever 259291
But we do have tracing turned on for this system at the moment.

trace-cmd start -p function_graph\
       -l smp_apic_timer_interrupt\
       -e irq -e raw_syscalls -e 'sched_wakeup*' \
       -e sched_switch -e hrtimer_start  \
       -e hrtimer_expire_entry

I'll turn this off to try to get a stall.



>> The test code loads the system heavily with a number of RT worker threads
>> repeatedly performing a small task. We are not worried about small missed
>> deadlines on the worker threads. We understand that we are subjecting the
>> system to an unreasonable load. We are simply trying to expose the main
>> problem.
>>
>> In addition, there is an overall supervisor thread at the highest
>> priority.
>> Under the fault condition the supervisor thread would sleep for 5 or so
>> seconds and then wake up and continue. The supervisor thread is in charge
>> of pinging the watchdog.
>>
>> When running the special stress test, we hit the RT Throttling warning
>> and
>> understand what that means.
>> I have enabled LTT tracing and ftrace. I did manage to get some
>> limited traces showing the system just hanging with no activity for 5
>> seconds. When it wakes up we have a rush of thread migration
>> operations as the system tries to recover.
>>
>> Both trace options did not show much detail just prior to the hang.
>> When I enabled more tracing detail under ftrace the problem did not
>> seem to happen.
>>
>> We originally thought this problem was associated with the ATOM
>> processor.
>> The reason for the posting is that we are now seeing the same  pattern
>> with some larger Intel Xeon  E5-2630/2680  systems
>>
>> I am ready to run any tests etc, possibly even provide hardware etc to
>> explore this problem.
>> Note the attached thread_test program currently pins the management
>> thread to cpu 0
>
> At a glance, your test code is a bit busted.  Parsing /proc/cpuinfo is a
> bad idea for one, as cpufreq can change that on the fly, munging your
> "rtc".. if it weren't already munged by unsynchronized etc TSCs.
>
> If you ever hit the throttle, it's game over the instant that happens.
> Once your code is debugged, turn the throttle off, as it's nothing but a
> nasty perturbation source.
>

Thanks again for the feedback.
I'll look for some better options for cpufreq.

And yes we have had some fun with TSC issues

[    0.160009] TSC synchronization [CPU#0 -> CPU#1]:
[    0.160009] Measured 45 cycles TSC warp between CPUs, turning off TSC clock.
[    0.160009] Marking TSC unstable due to check_tsc_sync_source failed

I am still looking for some tracing suggestions. Any help much appreciated.
