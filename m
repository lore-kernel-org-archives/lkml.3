Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaGNUT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:19:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaGNUT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:19:26 -0400
Date: Mon, 14 Jul 2014 22:18:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140714201854.GJ17761@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714111833.GU19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:18:33PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > When task exits we close:
> >   1) all events that are installed in task
> >   2) all events owned by task (via file descriptor)
> > 
> > But we don't close children events of 2) events. Those children
> > events stay until the child task exits and are useless with the
> > parent being gone, because we have no way to get to values any
> > more.
> > 
> > Plus if the event stays installed in task even with the owner task
> > gone, it runs the perf callback any time the task forks, for no
> > real reason.
> > 
> > Closing all children events events when the owner task of the
> > parent event is closed.
> 
> Do we need this for the other patches, or is this an unrelated change? 
> 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/events/core.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 71a56ae..37797dd 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -7535,6 +7535,32 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
> >  	put_ctx(child_ctx);
> >  }
> >  
> > +static void perf_event_exit_children(struct perf_event *parent)
> > +{
> > +	struct perf_event *child, *tmp;
> > +
> > +	mutex_lock(&parent->child_mutex);
> > +	list_for_each_entry_safe(child, tmp, &parent->child_list,
> > +				 child_list) {
> > +		struct perf_event_context *child_ctx = child->ctx;
> > +
> > +		/*
> > +		 * Child events got removed from child_list under
> > +		 * child_mutex and then freed. So it's safe to access
> > +		 * childs context in here, because the child holds
> > +		 * context ref.
> > +		 */
> > +		mutex_lock(&child_ctx->mutex);
> > +		perf_remove_from_context(child, true);
> > +		mutex_unlock(&child_ctx->mutex);
> > +
> > +		list_del_init(&child->child_list);
> > +		put_event(parent);
> > +		free_event(child);
> > +	}
> > +	mutex_unlock(&parent->child_mutex);
> > +}
> > +
> >  /*
> >   * When a child task exits, feed back event values to parent events.
> >   */
> > @@ -7555,6 +7581,7 @@ void perf_event_exit_task(struct task_struct *child)
> >  		 */
> >  		smp_wmb();
> >  		event->owner = NULL;
> > +		perf_event_exit_children(event);
> >  	}
> >  	mutex_unlock(&child->perf_event_mutex);
> 
> I don't think this is correct, perf_event_init_context() can come in
> concurrently and the first place it runs into ->child_mutex is after its
> already allocated and created the (first) child event.

just noticed this.. I'm working on the other version we decide, but FWIW
there's also mutex_lock(&child_ctx->mutex); before removing the context,
that should protect it against perf_event_init_context call

jirka
