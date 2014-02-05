Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaBEOeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaBEOeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:34:10 -0500
Date: Wed, 5 Feb 2014 15:33:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Put proper period for for samples
 without PERIOD sample_type
Message-ID: <20140205143329.GB2373@krava.brq.redhat.com>
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
 <87vbwu1h8d.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbwu1h8d.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:27:30AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Mon,  3 Feb 2014 12:44:41 +0100, Jiri Olsa wrote:
> > We use PERF_SAMPLE_PERIOD sample type only for frequency
> > setup -F (default) option. The -c does not need store period,
> > because it's always the same.
> >
> > In -c case the report code uses '1' as  period. Fixing
> > it to perf_event_attr::sample_period.
> 
> All 3 patches look good.  But I found something strange.  When we
> setup/config evsel attrs following code is used:
> 
>  util/evsel.c::perf_evsel__config()
> 
> 	/*
> 	 * We default some events to a 1 default interval. But keep
> 	 * it a weak assumption overridable by the user.
> 	 */
> 	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
> 				     opts->user_interval != ULLONG_MAX)) {
> 		if (opts->freq) {
> 			perf_evsel__set_sample_bit(evsel, PERIOD);
> 			attr->freq		= 1;
> 			attr->sample_freq	= opts->freq;
> 		} else {
> 			attr->sample_period = opts->default_interval;
> 		}
> 	}

yes, I think thats right.. we should use || instead of &&

It will allow to change period for event types with predefined
attr->sample_period like tracepoints.

However, I tried with tracepoints and even with this fix
and following command line:

  # perf record -e syscalls:sys_enter_read -c 2 ls

you'll still get samples with period 1. The reason is in
kernel code:

static void perf_swevent_event(struct perf_event *event, u64 nr,
                               struct perf_sample_data *data,
                               struct pt_regs *regs)
{
...
        if ((event->attr.sample_type & PERF_SAMPLE_PERIOD) && !event->attr.freq) {
                data->period = nr;
                return perf_swevent_overflow(event, 1, data, regs);

bacause above condition is true for tracepoints.

It looks like a bug, but I'm not sure how handy it'd be
set period other than 1 for tracepoints thought.. ;)

Maybe it's not that big issue in comparison of screwing
up other software events processing.

I haven't checked other software events.

jirka
