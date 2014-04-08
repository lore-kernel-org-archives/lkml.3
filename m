Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaDHTf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:35:59 -0400
Received: from mail.efficios.com ([78.47.125.74]:53580 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbaDHTf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:35:58 -0400
Date: Tue, 8 Apr 2014 19:35:54 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <645268231.929.1396985754629.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140408135600.2f9f5f4f@gandalf.local.home>
References: <1396620154-24542-1-git-send-email-mathieu.desnoyers@efficios.com> <1396620154-24542-2-git-send-email-mathieu.desnoyers@efficios.com> <20140408135600.2f9f5f4f@gandalf.local.home>
Subject: Re: [PATCH v10 1/1] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: 3SDt677yJtbll+i7r6rlrUBnIZrnKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Frank Ch. Eigler" <fche@redhat.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Tuesday, April 8, 2014 1:56:00 PM
> Subject: Re: [PATCH v10 1/1] Tracepoint: register/unregister struct tracepoint
> 
> On Fri,  4 Apr 2014 10:02:34 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Register/unregister tracepoint probes with struct tracepoint pointer
> > rather than tracepoint name.
> > 
> > This change, which vastly simplifies tracepoint.c, has been proposed by
> > Steven Rostedt. It also removes 8.8kB (mostly of text) to the vmlinux
> > size.
> > 
> > >From this point on, the tracers need to pass a struct tracepoint pointer
> > to probe register/unregister. A probe can now only be connected to a
> > tracepoint that exists. Moreover, tracers are responsible for
> > unregistering the probe before the module containing its associated
> > tracepoint is unloaded.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Ingo Molnar <mingo@kernel.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Frank Ch. Eigler <fche@redhat.com>
> > CC: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  include/linux/ftrace_event.h        |   22 +-
> >  include/linux/tracepoint.h          |   41 +--
> >  include/trace/ftrace.h              |    9 +-
> >  kernel/trace/trace_events.c         |   51 ++--
> >  kernel/trace/trace_events_trigger.c |    2 +-
> >  kernel/trace/trace_kprobe.c         |   21 +-
> >  kernel/trace/trace_output.c         |    2 +-
> >  kernel/trace/trace_uprobe.c         |   20 +-
> >  kernel/tracepoint.c                 |  509
> >  +++++++++++++++--------------------
> >  9 files changed, 328 insertions(+), 349 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index cdc3011..75e64e8 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/hardirq.h>
> >  #include <linux/perf_event.h>
> > +#include <linux/tracepoint.h>
> >  
> >  struct trace_array;
> >  struct trace_buffer;
> > @@ -232,6 +233,7 @@ enum {
> >  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
> >  	TRACE_EVENT_FL_WAS_ENABLED_BIT,
> >  	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
> > +	TRACE_EVENT_FL_TRACEPOINT_BIT,
> >  };
> >  
> >  /*
> > @@ -244,6 +246,7 @@ enum {
> >   *                    (used for module unloading, if a module event is
> >   enabled,
> >   *                     it is best to clear the buffers that used it).
> >   *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
> > + *  TRACEPOINT    - Event is a tracepoint
> >   */
> >  enum {
> >  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
> > @@ -252,12 +255,17 @@ enum {
> >  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
> >  	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
> >  	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 <<
> >  	TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
> > +	TRACE_EVENT_FL_TRACEPOINT	= (1 << TRACE_EVENT_FL_TRACEPOINT_BIT),
> >  };
> >  
> >  struct ftrace_event_call {
> >  	struct list_head	list;
> >  	struct ftrace_event_class *class;
> > -	char			*name;
> > +	union {
> > +		char			*name;
> > +		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
> > +		struct tracepoint	*tp;
> > +	};
> >  	struct trace_event	event;
> >  	const char		*print_fmt;
> >  	struct event_filter	*filter;
> > @@ -271,6 +279,7 @@ struct ftrace_event_call {
> >  	 *   bit 3:		ftrace internal event (do not enable)
> >  	 *   bit 4:		Event was enabled by module
> >  	 *   bit 5:		use call filter rather than file filter
> > +	 *   bit 6:		Event is a tracepoint
> >  	 */
> >  	int			flags; /* static flags of different events */
> >  
> > @@ -283,6 +292,15 @@ struct ftrace_event_call {
> >  #endif
> >  };
> >  
> > +static inline const char *
> > +ftrace_event_get_name(struct ftrace_event_call *call)
> 
> I was thinking about this, and it really should be called
> "ftrace_event_name()", the "get" implies that there should be an
> associated "put".

OK. I'll change it.

> 
> > +{
> > +	if (call->flags & TRACE_EVENT_FL_TRACEPOINT)
> > +		return call->tp ? call->tp->name : NULL;
> > +	else
> > +		return call->name;
> > +}
> 
> Also, you missed a bunch of conversions in trace_event.c file. Do a
> search for '->name' and you'll find them. The ones that shouldn't be
> converted are rather obvious (system, field, mod), but you'll see
> others that were missed. I'm a bit nervous about what other ones may be
> missed as well.

Got them. I noticed that I forgot to turn on CONFIG_DYNAMIC_FTRACE when
I did the original swap from name to _name to find the sites to update.

I did test more recently with a config that has all the FTRACE and PERF
features enabled, but that was after I swapped back from _name to name,
so I did not catch those two sites.

I just swapped the field name to _name again, and did the build with
all FTRACE and PERF config options enabled to be certain I did not miss
any. Just to be extra sure, I'm doing a make allyesconfig too.

Then, I'm changing _name back to name, and I'll prepare this as v11.

Is that OK with you ?

Thanks,

Mathieu


> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
