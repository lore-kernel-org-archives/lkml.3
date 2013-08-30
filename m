Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3H3P7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:59:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3H3P7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:59:47 -0400
Date: Fri, 30 Aug 2013 17:59:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130830155936.GT31370@twins.programming.kicks-ass.net>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
 <20130826175012.GA25202@redhat.com>
 <20130826141814.54dcaa89@gandalf.local.home>
 <20130826182907.GB25202@redhat.com>
 <20130826150304.090a1025@gandalf.local.home>
 <20130827121629.GE10002@twins.programming.kicks-ass.net>
 <20130830155242.GB10875@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830155242.GB10875@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 05:52:43PM +0200, Frederic Weisbecker wrote:
> On Tue, Aug 27, 2013 at 02:16:29PM +0200, Peter Zijlstra wrote:
> > On Mon, Aug 26, 2013 at 03:03:04PM -0400, Steven Rostedt wrote:
> > > > Is there some path through sys_perf_open_event that might be
> > > > missing a capability check perhaps ?
> > > > 
> > > 
> > > That's a question for Ingo, Peter or Jiri.
> > 
> > Its not something I've looked at recently, git blames Jiri and fweisbec
> > for most of that code.
> > 
> > Permission checks appear to live in
> > kernel/trace/trace_event_perf.c:perf_trace_event_perm().
> 
> Actually the following condition is weird:
> 
> 	 /* The ftrace function trace is allowed only for root. */
> 	 if (ftrace_event_is_function(tp_event) &&
> 	     perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
>      			    return -EPERM;
> 

That says: If its its a function-event and we're paranoid but we don't
have root, bail.

> We probably intended to do:
> 
>    /* The ftrace function trace is allowed only for root. */
>    if (ftrace_event_is_function(tp_event) ||
>        perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
>        			      return -EPERM;
> 
> Can somebody confirm?

That would always disallow function-events, no?
