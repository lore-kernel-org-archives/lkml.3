Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaK0NxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaK0NxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:53:13 -0500
Date: Thu, 27 Nov 2014 11:53:00 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Do not fail on processing out of order event
Message-ID: <20141127135259.GI3808@redhat.com>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
 <20141126154459.GD3808@redhat.com>
 <20141127105603.GA1987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127105603.GA1987@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 27, 2014 at 11:56:03AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Em Wed, Nov 26, 2014 at 04:39:31PM +0100, Jiri Olsa escreveu:
> > > Linus reported perf report command being interrupted due to
> > > processing of 'out of order' event, with following error:
> > > 
> > >   Timestamp below last timeslice flush
> > >   0x5733a8 [0x28]: failed to process type: 3
> > > 
> > > I could reproduce the issue and in my case it was caused by one
> > > CPU (mmap) being behind during record and userspace mmap reader
> > > seeing the data after other CPUs data were already stored.
> > > 
> > > It'd be nice to find the source of this hiccup, meanwhile I'm
> > > submitting change that does not kill the processing, but only
> > > tracks the number of out of order events and warn user.
> > 
> > Works, for me, thanks for the fast response!
> 
> Thanks Jiri!
> 
> > > --- a/tools/perf/util/session.c
> > > +++ b/tools/perf/util/session.c
> > > @@ -533,15 +533,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
> > >  		return -ETIME;
> > >  
> > >  	if (timestamp < oe->last_flush) {
> > > -		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
> > > -
> > > -		pr_oe_time(timestamp,      "out of order event");
> > > +		pr_oe_time(timestamp,      "out of order event\n");
> > >  		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
> > >  			   oe->last_flush_type);
> > >  
> > > -		/* We could get out of order messages after forced flush. */
> > > -		if (oe->last_flush_type != OE_FLUSH__HALF)
> > > -			return -EINVAL;
> > > +		s->stats.nr_unordered_events++;
> 
> Btw., in the forced flush case we'll get out of order events that 
> are 'expected'. Shouldn't we count them separately and not warn 
> about them, or so?
> 
> > > +	if (session->stats.nr_unordered_events != 0) {
> > > +		ui__warning("%u out of order events recorded.\n",
> > > +			    session->stats.nr_unordered_events);
> > > +	}
> 
> Nit: I'd suggest keeping the message printout on a single line:
>  
> 	if (session->stats.nr_unordered_events != 0) {
> 		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
> 
> as IMHO the cure for this col80 linebreak checkpatch warning is 
> worse than the disease! :-)
> 
> Barring those details:
> 
>   Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Arnaldo, I suppose the fix will go upstream via your tree, as a 
> pull request for v3.18 fixes?

Right, I can do that.

And I agree with the "expected" for events that are out of the current
reordering window, i.e. we can't insert something into previous windows,
so those are, humm, what would be a good name:
stats->out_of_reordering_window, while stats->reordered, would be for
events that were found out of order, but were successfully sorted as
part of a flush operation, right?

Also I'd drop that nr_ prefix, its a 'stat', so it probably is a "number",
right? :-)
 
- Arnaldo
