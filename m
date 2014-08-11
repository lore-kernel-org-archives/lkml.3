Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaHKMWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHKMWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:22:47 -0400
Date: Mon, 11 Aug 2014 14:22:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 01/20] perf: Add PERF_EVENT_STATE_EXIT state for events
 with exited task
Message-ID: <20140811122212.GA26811@krava.brq.redhat.com>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
 <1407747014-18394-2-git-send-email-jolsa@kernel.org>
 <20140811120102.GY9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811120102.GY9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 02:01:02PM +0200, Peter Zijlstra wrote:

SNIP

> >  	struct perf_event *event = file->private_data;
> >  	struct ring_buffer *rb;
> > -	unsigned int events = POLL_HUP;
> > +	unsigned int events = POLLHUP;
> 
> Should not that be an independent bugfix? It is a silly little thing
> indeed, but it does change behaviour.

ok, I'll send it in a separate patch plus your suggestion
below in v2

> 
> >  	poll_wait(file, &event->waitq, wait);
> > +
> > +	if (event->state == PERF_EVENT_STATE_EXIT)
> > +		return POLLHUP;
> > +
> 
> So, seeing how events is already POLLHUP here, why not return that?
> 
> >  	/*
> >  	 * Pin the event->rb by taking event->mmap_mutex; otherwise
> >  	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
> > @@ -7484,6 +7489,9 @@ __perf_event_exit_task(struct perf_event *child_event,
> >  	if (child_event->parent) {
> >  		sync_child_event(child_event, child);
> >  		free_event(child_event);
> > +	} else {
> > +		child_event->state = PERF_EVENT_STATE_EXIT;
> > +		perf_event_wakeup(child_event);
> >  	}
> >  }
> 
> In any case, ACK on this patch, I'll assume you want to take the lot
> through acme seeing how its mostly tools bits.

yep

thanks,
jirka
