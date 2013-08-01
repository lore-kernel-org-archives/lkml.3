Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3HANjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3HANju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:39:50 -0400
Date: Thu, 1 Aug 2013 15:39:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130801133921.GI1032@krava.brq.redhat.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
 <20130801124658.GC1032@krava.brq.redhat.com>
 <20130801133155.GB27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801133155.GB27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:31:55PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 01, 2013 at 02:46:58PM +0200, Jiri Olsa wrote:
> > On Tue, Jul 23, 2013 at 02:31:04AM +0200, Frederic Weisbecker wrote:
> > > This is going to be used by the full dynticks subsystem
> > > as a finer-grained information to know when to keep and
> > > when to stop the tick.
> > > 
> > > Original-patch-by: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Jiri Olsa <jolsa@redhat.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Namhyung Kim <namhyung@kernel.org>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: Stephane Eranian <eranian@google.com>
> > > ---
> > >  kernel/events/core.c |    7 +++++++
> > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index b40c3db..f9bd39b 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -141,6 +141,7 @@ enum event_type_t {
> > >  struct static_key_deferred perf_sched_events __read_mostly;
> > >  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
> > >  static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
> > > +static DEFINE_PER_CPU(atomic_t, perf_freq_events);
> > >  
> > >  static atomic_t nr_mmap_events __read_mostly;
> > >  static atomic_t nr_comm_events __read_mostly;
> > > @@ -3139,6 +3140,9 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
> > >  	}
> > >  	if (is_cgroup_event(event))
> > >  		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
> > > +
> > > +	if (event->attr.freq)
> > > +		atomic_dec(&per_cpu(perf_freq_events, cpu));
> > >  }
> > >  
> > >  static void unaccount_event(struct perf_event *event)
> > > @@ -6473,6 +6477,9 @@ static void account_event_cpu(struct perf_event *event, int cpu)
> > >  	}
> > >  	if (is_cgroup_event(event))
> > >  		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
> > > +
> > > +	if (event->attr.freq)
> > > +		atomic_inc(&per_cpu(perf_freq_events, cpu));
> > 
> > cpu could be -1 in here.. getting:
> 
> Ho humm, right you are. 
> 
> So we have:
> 
> static void account_event_cpu(struct perf_event *event, int cpu)
> {
> 	if (event->parent)
> 		return;
> 
> 	if (has_branch_stack(event)) {
> 		if (!(event->attach_state & PERF_ATTACH_TASK))
> 			atomic_inc(&per_cpu(perf_branch_stack_events, cpu));
> 	}
> 	if (is_cgroup_event(event))
> 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
> 
> 	if (event->attr.freq)
> 		atomic_inc(&per_cpu(perf_freq_events, cpu));
> }
> 
> Where the freq thing is new and shiney, but we already had the other
> two. Of those, cgroup events must be per cpu so that should be good,
> the branch_stack thing tests ATTACH_TASK, which should also be good, but
> leaves me wonder wth they do for those that are attached to tasks.

cgroup is cpu only:

SYSCALL(..
        if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
                return -EINVAL;

jirka
