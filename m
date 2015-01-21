Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbbAURoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:44:46 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54170 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAURoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <1421860365.14076.91.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	<1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	<20150105134514.GS30905@twins.programming.kicks-ass.net>
	<1421860365.14076.91.camel@arm.com>
Date: Wed, 21 Jan 2015 09:44:37 -0800
Message-ID: <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: John Stultz <john.stultz@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 9:12 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2015-01-05 at 13:45 +0000, Peter Zijlstra wrote:
>> On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
>> > Currently three clocks are implemented: CLOCK_REALITME = 0,
>> > CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
>> > 5 bits wide to allow for future extension to custom, non-POSIX clock
>> > sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
>> > ARM CoreSight (hardware trace) timestamp generator.
>>
>> > @@ -304,7 +305,16 @@ struct perf_event_attr {
>> >                             mmap2          :  1, /* include mmap with inode data     */
>> >                             comm_exec      :  1, /* flag comm events that are due to an exec */
>> >                             uevents        :  1, /* allow uevents into the buffer */
>> > -                           __reserved_1   : 38;
>> > +
>> > +                           /*
>> > +                            * clock: one of the POSIX clock IDs:
>> > +                            *
>> > +                            * 0 - CLOCK_REALTIME
>> > +                            * 1 - CLOCK_MONOTONIC
>> > +                            * 4 - CLOCK_MONOTONIC_RAW
>> > +                            */
>> > +                           clock          :  5, /* clock type */
>> > +                           __reserved_1   : 33;
>> >
>> >     union {
>> >             __u32           wakeup_events;    /* wakeup every n events */
>>
>> This would put a constraint on actually changing MAX_CLOCKS, are the
>> time people OK with that? Thomas, John?
>
> I admit I have some doubts about it myself. But I don't think we can
> afford full int for the clock id, can we?
>
>> I'm also not quite sure of using the >MAX_CLOCKS space for 'special'
>> clocks, preferably those would register themselves with the POSIX clock
>> interface.
>
> That may be a hard sell - John never was particularly keen on extending
> the hard-coded clocks with random sources. And the hardware trace clock
> I had on mind would be probably one of them - its meaning depends a lot
> on the . Of course I'm looking forward to being surprised :-)

Yea. I'm definitely still wanting to be cautious about adding new
clockids. Basically if there's a new well defined time domain, then
I'm open to it,  (for example, I'm expecting there will be a smeared
leapsecond time domain at some point in the future), but we've already
grown more then I'm comfortable with given the existing MAX_CLOCKS
limit.

For example, I regret adding the _ALARM clockids. Those are basically
duplicative time domains from the readers perspective, and only have
unique value for setting timers, which should have been handled via a
flag to the timer interfaces.

I suspect we'll have to bump MAX_CLOCKS that at some point and hope it
doesn't break anyone.

That said, there is the dynamic posix clockids. I'm not sure if it
would make sense, but even if we don't bump MAX_CLOCKS, might there
be some case where someone wants to use a dynamic posix clock for the
perf reference?

thanks
-john
