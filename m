Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaJHMPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:15:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50159 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaJHMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:15:38 -0400
Date: Wed, 8 Oct 2014 13:15:35 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20141008121535.GT14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
 <20141007194310.GC4750@worktop.programming.kicks-ass.net>
 <20141008103658.GP14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008103658.GP14343@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 11:36:58AM, Matt Fleming wrote:
> On Tue, 07 Oct, at 09:43:10PM, Peter Zijlstra wrote:
> > On Wed, Sep 24, 2014 at 03:04:12PM +0100, Matt Fleming wrote:
> > > +/*
> > > + * Determine if @a and @b measure the same set of tasks.
> > > + */
> > > +static bool __match_event(struct perf_event *a, struct perf_event *b)
> > > +{
> > > +	if ((a->attach_state & PERF_ATTACH_TASK) !=
> > > +	    (b->attach_state & PERF_ATTACH_TASK))
> > > +		return false;
> > > +
> > > +	/* not task */
> > > +
> > > +	return true; /* if not task, we're machine wide */
> > > +}
> > 
> > You cut too much out there. That first test checks weather the two
> > events are of the same type; ie. both tasks or both cpu. After that you
> > still need to verify that they are indeed the same target.
> 
> This gets fixed in PATCH 10 where we actually implement monitoring of
> task events. At this point in the series, we'll return -EINVAL from
> intel_cqm_event_init() for anything other than a cpu event.

I was having an interesting discussion with one of the teams using this
stuff at Intel and they made the suggestion that when using,

  perf stat -p <pid>

we should by default opt for sharing an RMID between all tasks in that
thread group, rather that assigning a new RMID for each task, which is
what we do currently.

Right now, it's like the Oprah Winfrey of RMID assignment, "You get an
RMID, and you get an RMID!"

Which means we'll run out of RMIDs quicker, and enable the rotation code
sooner.

I'm wondering whether we should require that the user specify whether
they want per-thread monitoring if using -p, via some perf tools event
modifier, and make the record-per-thread-data scenario the exceptional
case, rather than the default?

-- 
Matt Fleming, Intel Open Source Technology Center
