Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3HaUyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:54:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35102 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab3HaUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:54:44 -0400
Date: Sat, 31 Aug 2013 13:54:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 05/18 v2] ftrace: Do not display non safe RCU
 functions in available_filter_functions
Message-ID: <20130831205430.GB3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.256486055@goodmis.org>
 <20130831194602.GM3871@linux.vnet.ibm.com>
 <1377981303.26624.2.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377981303.26624.2.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-7182-0000-0000-0000084349F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 04:35:03PM -0400, Steven Rostedt wrote:
> On Sat, 2013-08-31 at 12:46 -0700, Paul E. McKenney wrote:
> 
> > >  void arch_ftrace_update_code(int command);
> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > > index 06504b2..be87ac9 100644
> > > --- a/kernel/trace/ftrace.c
> > > +++ b/kernel/trace/ftrace.c
> > > @@ -2645,7 +2645,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
> > >  		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
> > > 
> > >  		    ((iter->flags & FTRACE_ITER_ENABLED) &&
> > > -		     !(rec->flags & FTRACE_FL_ENABLED))) {
> > > +		     !(rec->flags & FTRACE_FL_ENABLED)) ||
> > > +
> > 
> > OK, I'll bite...  Why the blank line?
> 
> For readability. Here's the full if statement:
> 
>                 if (((iter->flags & FTRACE_ITER_FILTER) &&
>                      !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
> 
>                     ((iter->flags & FTRACE_ITER_NOTRACE) &&
>                      !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
> 
>                     ((iter->flags & FTRACE_ITER_ENABLED) &&
>                      !(rec->flags & FTRACE_FL_ENABLED)) ||
> 
>                     ((iter->flags & FTRACE_ITER_UNSAFE_ONLY) &&
>                      !ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip)) ||
> 
>                     ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
>                      ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
> 
> 
> They are grouped in pairs.

Fair enough!

							Thanx, Paul

> -- Steve
> 
> > 
> > 							Thanx, Paul
> > 
> > > +		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
> > > +		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
> > > 
> > >  			rec = NULL;
> > >  			goto retry;
> > > @@ -2773,6 +2776,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
> > >  	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
> > >  	if (iter) {
> > >  		iter->pg = ftrace_pages_start;
> > > +		iter->flags = FTRACE_ITER_NO_UNSAFE;
> > >  		iter->ops = &global_ops;
> > >  	}
> > > 
> > > -- 
> > > 1.7.10.4
> > > 
> > > 
> 
> 

