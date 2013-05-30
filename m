Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941Ab3E3Lqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab3E3Lqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:46:32 -0400
Date: Thu, 30 May 2013 13:45:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Enable wakeup_events logic for all events
Message-ID: <20130530114544.GB1099@krava.brq.redhat.com>
References: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
 <1369907587-8963-2-git-send-email-jolsa@redhat.com>
 <20130530110239.GN12193@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530110239.GN12193@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 01:02:39PM +0200, Peter Zijlstra wrote:
> On Thu, May 30, 2013 at 11:53:06AM +0200, Jiri Olsa wrote:
> > Currently the perf_events_attr::wakeup_events logic is
> > checked only for regular samples.
> > 
> > If we have an event that produce only auxiliary events
> > (MMAP|COMM|EXIT|FORK), the poll call does not follow
> > the perf_events_attr wakeup_events setup and reports
> > no data.
> > 
> > Fixing this by moving the perf_events_attr::wakeup_events
> > checking logic into the function and calling it from
> > perf_output_end. This way any output event is checked
> > properly.
> > 
> 
> So something like this came up before and ISTR doing a patch similar to
> what you propose but ended up not going with it because... uhm...
> 
> I have vague memories about people (possibly me) wanting wake_events to
> mean samples. Like get me a wakeup every 20 samples. With your patch the
> side-band events now also count towards 'events'.
> 
> I think the most common use of wake_events is people setting it to 1 and
> have perf generate a SIGfoo for every sample so they can do magic in
> their userspace signal handler. This is popular for interpreters.
> 
> It would be unfortunate to get SIGfoos for side-band chatter.
> 
> 
> Makes sense?

hum, well the whole story is that for the ifunc user space tracer
(profwiz) I'd need the auxiliary stuff for the tracee (MMAP, COMM...)
so I could end up with 'reportable' perf.data file and use
just VMA addresses for functions.

So, the only way now is to create an event which is never hit
and set it up for this. At that point I noticed the poll would
never return.. hence the patch ;-)

(I was also thinking of a new special SW event doing nothing,
just be there to get aux stuff..)

Anyway, I could always check the map manually.. but I'd sort of
expect poll to work the same for anything you write/read via RB.

how about having something like:

 wakeup_events - setup for samples (stays)
 wakeup_any    - new flag saying to use wakeup_events for
                 anything going through the RB

thanks,
jirka
