Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaLOS4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:56:15 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61061 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:56:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418668613.4200.4@mail.thefacebook.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
 <862cbb2ab71a9f71d1123b5512605350a4b61846.1418006970.git.shli@fb.com>
 <CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
 <20141210215713.GA30230@devbig257.prn2.facebook.com> <CALCETrUi--fmZLBUB=tjmGt_D3y+HJ+MtJTRZ0=JUKFgAvxyuA@mail.gmail.com>
 <20141210225627.GA11754@devbig257.prn2.facebook.com> <CALCETrXpVUVY6paKJq0Uq8VeHG2A0E3qc4b_H+5ZT-QJApkaJw@mail.gmail.com>
 <20141211063621.GC5059@gmail.com> <1418668613.4200.4@mail.thefacebook.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 15 Dec 2014 10:55:51 -0800
Message-ID: <CALCETrUaeujfu4oPNaNThy5ERkb7e-DxLYNdR5suLD=FYq8PAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] X86: Add a thread cpu time implementation to vDSO
To: Chris Mason <clm@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:36 AM, Chris Mason <clm@fb.com> wrote:
>
>
> On Thu, Dec 11, 2014 at 1:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>>
>> * Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>>  On Wed, Dec 10, 2014 at 2:56 PM, Shaohua Li <shli@fb.com> wrote:
>>>  > On Wed, Dec 10, 2014 at 02:13:23PM -0800, Andy Lutomirski wrote:
>>>  >> On Wed, Dec 10, 2014 at 1:57 PM, Shaohua Li <shli@fb.com> wrote:
>>>  >> > On Wed, Dec 10, 2014 at 11:10:52AM -0800, Andy Lutomirski wrote:
>>>  >> >> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
>>>  >> >> > This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID,
>>> ..). We
>>>  >> >> > use the following method to compute the thread cpu time:
>>>  >> >>
>>>  >> >> I like the idea, and I like making this type of profiling fast.  I
>>>  >> >> don't love the implementation because it's an information leak
>>> (maybe
>>>  >> >> we don't care) and it's ugly.
>>>  >> >>
>>>  >> >> The info leak could be fixed completely by having a per-process
>>> array
>>>  >> >> instead of a global array.  That's currently tricky without
>>> wasting
>>>  >> >> memory, but it could be created on demand if we wanted to do that,
>>>  >> >> once my vvar .fault patches go in (assuming they do -- I need to
>>> ping
>>>  >> >> the linux-mm people).
>>>  >> >
>>>  >> > those info leak really doesn't matter.
>>>  >>
>>>  >> Why not?
>>>  >
>>>  > Ofcourse I can't make sure completely, but how could this
>>>  > info be used as attack?
>>>
>>>  It may leak interesting timing info, even from cpus that are
>>>  outside your affinity mask / cpuset.  I don't know how much
>>>  anyone actually cares.
>>
>>
>> Finegraned timing information has been successfully used to
>> recover secret keys (and sometimes even coarse timing
>> information), so it can be a security issue in certain setups.
>
>
> Trying to nail this down a little more clearly.  Are you worried about the
> context switch count being exported or the clock_gettime data?
>

The context switch count is unnecessary.  Here's an IMO better
algorithm that relies on the context switch code storing the TSC at
last context switch for each CPU in a user-accessible location:

clock_gettime does

cpu, tsc = rdtscp;  /* NB: HW orders rdtscp as a load */
barrier();
read scale_factor[cpu], sum_exec_runtime[cpu], etc;
barrier();
if (last_context_switch_tsc[cpu] >= tsc)
  repeat (or fall back to a syscall)
return tsc * whatever + whatever_else;

This should be faster, as it avoids two uses of LSL, which take 7-10
cycles each, IIRC.

With that improvement, the context switch count becomes unavailable.
That leaves sum_exec_runtime (which ought to be totally uninteresting
for attackers) and the time of the last context switch.

The time of the last context switch *on the current cpu* is mostly
available to attackers anyway -- just call clock_gettime in a loop and
watch for jumps.  Some of those are interrupts, but the long ones are
likely to be context switches.

The time of the last context switch on other CPUs is potentially
important.  We could fix that by having a per-process array of per-cpu
values instead of a global array of per-cpu values.  We could
alternatively have a per-process array of per-thread values.

If we did that, we'd probably want to create the array on demand,
which will be a mess without my special_mapping fault rework that no
one has commented on.  I'll ping people after the merge window.

We could also shove all the timing parameters into magic segment
limits in the GDT.  The problem with that is that we only get 20 bits
per descriptor, which isn't enough to make it palatable.

For 32-bit programs, we could do evil things with segmentation to make
this all work cleanly and without leaks, but for 64-bit programs this
is a non-starter.

I *really really* want per-cpu memory mappings for this and other
things.  Pretty please, Intel or AMD?  (We can have them today by
using per-cpu pgds, giving a speedup for system calls (no more swapgs)
and faults but a possibly unacceptable slowdown for switch_mm.  The
slowdown would only be there for programs that either use enormous
amounts of virtual memory or use their address space very sparsely,
though.  It could be done for free on an EPT guest, I think, as long
as the hypervisor were willing to play along and give us a per-vcpu
guest physical "page".)

--Andy
