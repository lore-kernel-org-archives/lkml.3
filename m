Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3HAOaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:30:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43580 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3HAOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:30:11 -0400
Date: Thu, 1 Aug 2013 16:30:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf: Sanitize get_callchain_buffer()
Message-ID: <20130801143006.GI431@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
 <20130801132934.GG1032@krava.brq.redhat.com>
 <20130801134226.GC431@somewhere>
 <20130801135102.GJ1032@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801135102.GJ1032@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:51:02PM +0200, Jiri Olsa wrote:
> On Thu, Aug 01, 2013 at 03:42:28PM +0200, Frederic Weisbecker wrote:
> > On Thu, Aug 01, 2013 at 03:29:34PM +0200, Jiri Olsa wrote:
> > > On Tue, Jul 23, 2013 at 02:31:00AM +0200, Frederic Weisbecker wrote:
> > > SNIP
> > > 
> > > >  		if (event->attach_state & PERF_ATTACH_TASK)
> > > >  			static_key_slow_inc(&perf_sched_events.key);
> > > >  		if (event->attr.mmap || event->attr.mmap_data)
> > > > @@ -6572,16 +6570,19 @@ done:
> > > >  				atomic_inc(&per_cpu(perf_branch_stack_events,
> > > >  						    event->cpu));
> > > >  		}
> > > > -		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
> > > > -			err = get_callchain_buffers();
> > > > -			if (err) {
> > > > -				free_event(event);
> > > > -				return ERR_PTR(err);
> > > > -			}
> > > > -		}
> > > >  	}
> > > >  
> > > >  	return event;
> > > > +
> > > > +err_pmu:
> > > > +	if (event->destroy)
> > > > +		event->destroy(event);
> > > > +err_ns:
> > > > +	if (event->ns)
> > > > +		put_pid_ns(event->ns);
> > > > +	kfree(event);
> > > > +
> > > > +	return ERR_PTR(err);
> > > 
> > > could we call __free_filter(event) here?
> > 
> > Hmm, the filters are installed from ioctl time so there shouldn't be any yet. But there should be
> > an exception with inherited events. I fail to find where the filter is inherited though. Do
> > we actually inherit those?
> 
> ouch.. last I checked was freeing filter before writing this... :)
> 
> what I meant was the __free_event(event)

free_event() doesn't work either because we want several level of rollback depending
of where the error triggered:

   +err_pmu:
           if (event->destroy)
                 event->destroy(event);
   +err_ns:
           if (event->ns)
                 put_pid_ns(event->ns);
           kfree(event);

           return ERR_PTR(err)

If we fail after pmu init we want to call destroy, free pid ns and the event.
If we fail before the pmu init, we want to only free pid ns and the event, ...

_free_event() does the whole in any case, which is not what we want.

But...

OTOH it might work due to the if (event->destroy) and if (event->ns) before freeing the
resource associated.

So may be I can replace the labels with a single call to __free_event() after all as it
checks what needs to be freed.  What do you think?
