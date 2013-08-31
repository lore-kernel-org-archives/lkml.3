Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3HaUkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:40:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3HaUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:40:11 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ZnFBpunljT8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QYmdpx3kvKkA:10 a=VnNF1IyMAAAA:8 a=hCKiQadejs-moRHCX5cA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Subject: Re: [RFC][PATCH 11/18 v2] ftrace: Adde infrastructure to stop RCU
 unsafe checker from checking
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
In-Reply-To: <20130831195258.GQ3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	 <20130831051702.253028770@goodmis.org>
	 <20130831195258.GQ3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Aug 2013 16:40:04 -0400
Message-ID: <1377981604.26624.4.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 12:52 -0700, Paul E. McKenney wrote:
> On Sat, Aug 31, 2013 at 01:11:28AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > This is a light weight way to keep the rcu checker from checking
> > RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
> > that increments or decrements a counter respectively. When the
> > counter is set, the RCU unsafe checker callback does not run the
> > tests to see if RCU is safe or not.
> 
> Please add something saying what we do instead of testing RCU safety.
> Looks to me like it skips not only the tests, but also invoking the
> callback, but I could easily be wrong.

Yeah, the change log sucks. I wrote the change logs after 1am and was
half asleep. I see I wrote "Add" as "Adde" ;-)

> 
> > This is required by the graph tracer because the checks can cause
> > the graph tracer to live lock the system by its own calls.
> > 
> > It's also needed by the irqsoff tracer, because it may be called
> > in RCU unsafe regions and if its internal functions get traced
> > then the RCU unsafe checker may have some false positives.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> With the augmented commit log as noted above:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Thanks, come Tuesday, I'll update the logs.

-- Steve

> > ---
> >  kernel/trace/trace.h           |   12 +++++++++---
> >  kernel/trace/trace_functions.c |   15 +++++++++++++++
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index e551316..58e4c37 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -760,9 +760,6 @@ static inline int ftrace_graph_addr(unsigned long addr)


