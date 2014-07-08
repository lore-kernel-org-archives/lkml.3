Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaGHG7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaGHG7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:59:36 -0400
Date: Tue, 8 Jul 2014 08:59:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf stat: events inheritance can break task targets
Message-ID: <20140708065901.GA12661@krava.redhat.com>
References: <874myt86ju.wl%yarygin@linux.vnet.ibm.com>
 <20140707170040.GB2070@krava.redhat.com>
 <20140707194635.GZ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707194635.GZ6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 09:46:35PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 07:00:40PM +0200, Jiri Olsa wrote:
> > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> > index 5d12bb4..b44184b 100644
> > --- a/kernel/trace/trace_event_perf.c
> > +++ b/kernel/trace/trace_event_perf.c
> > @@ -24,6 +24,9 @@ static int	total_ref_count;
> >  static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
> >  				 struct perf_event *p_event)
> >  {
> > +	struct task_struct owner = p_event->parent ? p_event->parent->owner :
> > +						     p_event->owner;
> > +
> >  	if (tp_event->perf_perm) {
> >  		int ret = tp_event->perf_perm(tp_event, p_event);
> >  		if (ret)
> > @@ -32,7 +35,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
> >  
> >  	/* The ftrace function trace is allowed only for root. */
> >  	if (ftrace_event_is_function(tp_event)) {
> > -		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
> > +		if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_ADMIN))
> >  			return -EPERM;
> >  
> >  		/*
> > @@ -65,7 +68,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
> >  	 * ...otherwise raw tracepoint data can be a severe data leak,
> >  	 * only allow root to have these.
> >  	 */
> > -	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
> > +	if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_ADMIN))
> >  		return -EPERM;
> >  
> >  	return 0;
> 
> You need to either hold rcu_read_lock() or otherwise ensure the owner is
> still valid.

ok, I'll resend

thanks,
jirka
