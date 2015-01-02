Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbbABRrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:47:52 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40583 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbbABRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:47:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150102025953.GA1253265@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net> <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net> <20150102025953.GA1253265@devbig257.prn2.facebook.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 Jan 2015 09:47:29 -0800
Message-ID: <CALCETrW=Z14X-TyOwsaMGKbY+w=JkUgjRFDsasBgWy83ZtkaeQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
To: Shaohua Li <shli@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 6:59 PM, Shaohua Li <shli@fb.com> wrote:
> On Fri, Dec 19, 2014 at 06:03:34PM +0100, Peter Zijlstra wrote:
>> On Fri, Dec 19, 2014 at 08:48:07AM -0800, Andy Lutomirski wrote:
>> > On Fri, Dec 19, 2014 at 3:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
>> > >> Bad news: this patch is incorrect, I think.  Take a look at
>> > >> update_rq_clock -- it does fancy things involving irq time and
>> > >> paravirt steal time.  So this patch could result in extremely
>> > >> non-monotonic results.
>> > >
>> > > Yeah, I'm not sure how (and if) we could make all that work :/
>> >
>> > I obviously can't comment on what Facebook needs, but if I were
>> > rigging something up to profile my own code*, I'd want a count of
>> > elapsed time, including user, system, and probably interrupt as well.
>> > I would probably not want to count time during which I'm not
>> > scheduled, and I would also probably not want to count steal time.
>> > The latter makes any implementation kind of nasty.
>> >
>> > The API presumably doesn't need to be any particular clock id for
>> > clock_gettime, and it may not even need to be clock_gettime at all.
>> >
>> > Is perf self-monitoring good enough for this?  If not, can we make it
>> > good enough?
>>
>> Yeah, I think you should be able to use that. You could count a NOP
>> event and simply use its activated time. We have PERF_COUNT_SW_DUMMY for
>> such purposes iirc.
>>
>> The advantage of using perf self profiling is that it (obviously)
>> extends to more than just walltime.
>
> Hi Peter & Andy,
> I'm wondering how we could use the perf to implament a clock_gettime.
> reading the perf fd or using ioctl is slow so reading the mmap
> ringbuffer is the only option. But as far as I know the ringbuffer has
> data only when an event is generated. Between two events, there is
> nothing we can read from the ringbuffer. Then how can application get
> time info in the interval?

Don't use the ringbuffer.  Instead, use a counting event, mmap it, and
look at struct perf_event_mmap_page's comments to see how to read the
time stamps.

There's some code here that does this:

https://github.com/andikleen/pmu-tools

but you won't actually need the rdpmc part, since you just want
overall times instead of hardware event counts.

--Andy

>
> Thanks,
> Shaohua



-- 
Andy Lutomirski
AMA Capital Management, LLC
