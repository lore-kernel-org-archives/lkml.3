Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIYKuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:50:09 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37239 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaIYKuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:50:07 -0400
Message-ID: <1411642198.4768.30.camel@hornet>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
From: Pawel Moll <pawel.moll@arm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Thu, 25 Sep 2014 11:49:58 +0100
In-Reply-To: <87sijhk21x.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 06:41 +0100, Namhyung Kim wrote:
> Hi Pawel,
> 
> On Tue, 23 Sep 2014 18:03:06 +0100, Pawel Moll wrote:
> > This patch adds an option to sample raw monotonic clock
> > value with any perf event, with the the aim of allowing
> > time correlation between data coming from perf and
> > additional performance-related information generated in
> > userspace.
> >
> > In order to correlate timestamps in perf data stream
> > with events happening in userspace (be it JITed debug
> > symbols or hwmon-originating environment data), user
> > requests a more or less periodic event (sched_switch
> > trace event of a hrtimer-based cpu-clock being the
> > most obvious examples) with PERF_SAMPLE_TIME *and*
> > PERF_SAMPLE_CLOCK_RAW_MONOTONIC and stamps
> > user-originating data with values obtained from
> > clock_gettime(CLOCK_MONOTONIC_RAW). Then, during
> > analysis, one looks at the perf events immediately
> > preceding and following (in terms of the
> > clock_raw_monotonic sample) the userspace event and
> > does simple linear approximation to get the equivalent
> > perf time.
> >
> >         perf event     user event
> >        -----O--------------+-------------O------> t_mono
> >             :              |             :
> >             :              V             :
> >        -----O----------------------------O------> t_perf
> 
> Probably a dumb question: why not make PERF_SAMPLE_TIME being monotonic
> clock instead of adding a new PERF_SAMPLE_CLOCK_XXX flag? 

It's a valid question. And it was asked before, in this thread:

http://thread.gmane.org/gmane.linux.kernel/1611683

A summary of the answer would be:

> On Wed, 2013-12-11 at 12:07 +0000, Ingo Molnar wrote: 
> > * John Stultz <john.stultz@linaro.org> wrote:
> > 
> > > [...]
> > > 
> > > I'd much rather see perf export CLOCK_MONOTONIC_RAW timestamps, 
> > > since that clockid is well defined. [...]
> > 
> > So the problem with that clock is that it does the following for every 
> > timestamp:
> > 
> >         cycle_now = clock->read(clock);
> > 
> > ... which is impossibly slow if something like the HPET is used, which 
> > is rather common - so this is a non-starter to timestamp perf events 
> > with. We use the scheduler clock as a reasonable compromise between 
> > scalability and clock globality.

Now, for your other comment:

>  Maybe we can
> add a new ioctl command like PERF_EVENT_IOC_SET_CLOCK so that one can
> pass a clock id.

Did you mean selecting a time source for PERF_SAMPLE_TIME (so we don't
need two timestamps in a sample)? It would be doable, I guess, but what
if someone *wants* to have sched clock as the timestamps source (because
it's cheap) but still be able to correlate them with userspace? In this
case two separate timestamps are required to do the approximation.

Now, if you meant it to select a time source for the "other timestamp",
let's call it in a more generic way: PERF_SAMPLE_CLOCK_VALUE this could
work, yes. I see ALSA doing something similar (see
SNDRV_PCM_TSTAMP_TYPE_* enum in include/uapi/sound/asound.h). One
question would be: how does it work with groups? Does setting a
timesource for the leader selects them for all members? I don't think
you want a bunch of samples with different timestamp sources in the same
buffer.

Anyway, great stuff, thanks!

Pawel

