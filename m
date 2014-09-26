Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaIZGQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:16:46 -0400
Received: from plane.gmane.org ([80.91.229.3]:55367 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaIZGQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:16:45 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Pawel Moll <public-pawel.moll-5wv7dgnIgG8@plane.gmane.org>
Cc: Namhyung Kim 
	<public-namhyung-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        Richard Cochran 
	<public-richardcochran-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Steven Rostedt 
	<public-rostedt-nx8X9YLhiw1AfugRpC6u6w@plane.gmane.org>,
        Ingo Molnar <public-mingo-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org>,
        Peter Zijlstra 
	<public-peterz-wEGCiKHe2LqWVfeAwA7xHQ@plane.gmane.org>,
        Paul Mackerras 
	<public-paulus-eUNUBHrolfbYtjvyW6yDsg@plane.gmane.org>,
        Arnaldo Carvalho de Melo 
	<public-acme-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        John Stultz 
	<public-john.stultz-QSEj5FYQhm4dnm+yROfE0A@plane.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        "linux-api-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-api-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	<87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
Date: Fri, 26 Sep 2014 15:16:26 +0900
In-Reply-To: <1411642198.4768.30.camel@hornet> (Pawel Moll's message of "Thu,
	25 Sep 2014 11:49:58 +0100")
Message-ID: <8738bekith.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Pawel,

On Thu, 25 Sep 2014 11:49:58 +0100, Pawel Moll wrote:
> On Wed, 2014-09-24 at 06:41 +0100, Namhyung Kim wrote:
>> Hi Pawel,
>> 
>> On Tue, 23 Sep 2014 18:03:06 +0100, Pawel Moll wrote:
>> > This patch adds an option to sample raw monotonic clock
>> > value with any perf event, with the the aim of allowing
>> > time correlation between data coming from perf and
>> > additional performance-related information generated in
>> > userspace.
>> >
>> > In order to correlate timestamps in perf data stream
>> > with events happening in userspace (be it JITed debug
>> > symbols or hwmon-originating environment data), user
>> > requests a more or less periodic event (sched_switch
>> > trace event of a hrtimer-based cpu-clock being the
>> > most obvious examples) with PERF_SAMPLE_TIME *and*
>> > PERF_SAMPLE_CLOCK_RAW_MONOTONIC and stamps
>> > user-originating data with values obtained from
>> > clock_gettime(CLOCK_MONOTONIC_RAW). Then, during
>> > analysis, one looks at the perf events immediately
>> > preceding and following (in terms of the
>> > clock_raw_monotonic sample) the userspace event and
>> > does simple linear approximation to get the equivalent
>> > perf time.
>> >
>> >         perf event     user event
>> >        -----O--------------+-------------O------> t_mono
>> >             :              |             :
>> >             :              V             :
>> >        -----O----------------------------O------> t_perf
>> 
>> Probably a dumb question: why not make PERF_SAMPLE_TIME being monotonic
>> clock instead of adding a new PERF_SAMPLE_CLOCK_XXX flag? 
>
> It's a valid question. And it was asked before, in this thread:
>
> http://thread.gmane.org/gmane.linux.kernel/1611683
>
> A summary of the answer would be:
>
>> On Wed, 2013-12-11 at 12:07 +0000, Ingo Molnar wrote: 
>> > * John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > 
>> > > [...]
>> > > 
>> > > I'd much rather see perf export CLOCK_MONOTONIC_RAW timestamps, 
>> > > since that clockid is well defined. [...]
>> > 
>> > So the problem with that clock is that it does the following for every 
>> > timestamp:
>> > 
>> >         cycle_now = clock->read(clock);
>> > 
>> > ... which is impossibly slow if something like the HPET is used, which 
>> > is rather common - so this is a non-starter to timestamp perf events 
>> > with. We use the scheduler clock as a reasonable compromise between 
>> > scalability and clock globality.

Hmm.. but wouldn't it be up to user?  If one suffers from a slow clock
she will use default and fast one.  Well, if perf can know it'd be bad
for performance, it can warn users about the issue.


>
> Now, for your other comment:
>
>>  Maybe we can
>> add a new ioctl command like PERF_EVENT_IOC_SET_CLOCK so that one can
>> pass a clock id.
>
> Did you mean selecting a time source for PERF_SAMPLE_TIME (so we don't
> need two timestamps in a sample)?

Yes.


> It would be doable, I guess, but what
> if someone *wants* to have sched clock as the timestamps source (because
> it's cheap) but still be able to correlate them with userspace? In this
> case two separate timestamps are required to do the approximation.

But by collecting two timestamps, you'll loose the win of the first
timestamp, no?


>
> Now, if you meant it to select a time source for the "other timestamp",
> let's call it in a more generic way: PERF_SAMPLE_CLOCK_VALUE this could
> work, yes. I see ALSA doing something similar (see
> SNDRV_PCM_TSTAMP_TYPE_* enum in include/uapi/sound/asound.h). One
> question would be: how does it work with groups? Does setting a
> timesource for the leader selects them for all members? I don't think
> you want a bunch of samples with different timestamp sources in the same
> buffer.

My answer would be: if you don't want it, don't do that. :)

Thanks,
Namhyung

