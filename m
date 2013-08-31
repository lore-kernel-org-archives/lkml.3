Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3HaUfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:35:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3HaUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:35:12 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=NO13L3veMrYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hcrmJ-Ldf6sA:10 a=70CG9LR6gDksKvRav0gA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Subject: Re: [RFC][PATCH 05/18 v2] ftrace: Do not display non safe RCU
 functions in available_filter_functions
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20130831194602.GM3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	 <20130831051701.256486055@goodmis.org>
	 <20130831194602.GM3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Aug 2013 16:35:03 -0400
Message-ID: <1377981303.26624.2.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 12:46 -0700, Paul E. McKenney wrote:

> >  void arch_ftrace_update_code(int command);
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 06504b2..be87ac9 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -2645,7 +2645,10 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
> >  		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
> > 
> >  		    ((iter->flags & FTRACE_ITER_ENABLED) &&
> > -		     !(rec->flags & FTRACE_FL_ENABLED))) {
> > +		     !(rec->flags & FTRACE_FL_ENABLED)) ||
> > +
> 
> OK, I'll bite...  Why the blank line?

For readability. Here's the full if statement:

                if (((iter->flags & FTRACE_ITER_FILTER) &&
                     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||

                    ((iter->flags & FTRACE_ITER_NOTRACE) &&
                     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||

                    ((iter->flags & FTRACE_ITER_ENABLED) &&
                     !(rec->flags & FTRACE_FL_ENABLED)) ||

                    ((iter->flags & FTRACE_ITER_UNSAFE_ONLY) &&
                     !ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip)) ||

                    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
                     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {


They are grouped in pairs.

-- Steve

> 
> 							Thanx, Paul
> 
> > +		    ((iter->flags & FTRACE_ITER_NO_UNSAFE) &&
> > +		     ftrace_lookup_ip(ftrace_unsafe_rcu, rec->ip))) {
> > 
> >  			rec = NULL;
> >  			goto retry;
> > @@ -2773,6 +2776,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
> >  	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
> >  	if (iter) {
> >  		iter->pg = ftrace_pages_start;
> > +		iter->flags = FTRACE_ITER_NO_UNSAFE;
> >  		iter->ops = &global_ops;
> >  	}
> > 
> > -- 
> > 1.7.10.4
> > 
> > 


