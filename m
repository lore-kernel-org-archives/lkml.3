Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaIHKBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaIHKBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:01:15 -0400
Date: Mon, 8 Sep 2014 12:00:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf: Deny optimized switch for events read by
 PERF_SAMPLE_READ
Message-ID: <20140908100018.GC1172@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-3-git-send-email-jolsa@kernel.org>
 <20140902105244.GI5806@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902105244.GI5806@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:52:44PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 25, 2014 at 04:45:36PM +0200, Jiri Olsa wrote:
> > The optimized task context switch for cloned perf events just
> > swaps whole perf event contexts (of current and next process)
> > if it finds them suitable. Events from the 'current' context
> > will now measure data of the 'next' context and vice versa.
> > 
> > This is ok for cases where we are not directly interested in
> > the event->count value of separate child events, like:
> >   - standard sampling, where we take 'period' value for the
> >     event count
> >   - counting, where we accumulate all events (children)
> >     into a single count value
> > 
> > But in case we read event by using the PERF_SAMPLE_READ sample
> > type, we are interested in direct event->count value measured
> > in specific task. Switching events within tasks for this kind
> > of measurements corrupts data.
> > 
> > Fixing this by setting/unsetting pin_count for perf event context
> > once cloned event with PERF_SAMPLE_READ read is added/removed.
> > The pin_count value != 0 makes the context not suitable for
> > optimized switch.
> 
> no.. so the value of the counter is the sum of all the inherited events.
> It doesn't matter if you flip it or not the sum is not affected.
> 
> PERF_SAMPLE_READ should return the value.

so I want to be able to do the leader sampling over child processes

that means:
  - have event group with sampling leader, and the rest
    of the group events' periods being read on leader's sample
    via PERF_SAMPLE_READ sample_type
  - for each child process created I want it to do the
    same thing as the parent - sample on leader, read
    values of other events in group via PERF_SAMPLE_READ

Now, If I let the optimized switch enabled for above config,
I'll get wrong data, because the period counts of group events
are local to the child process. Optimized switch will move
it to another child.

jirka
