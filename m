Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaENPvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:51:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38556 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaENPvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:51:00 -0400
Date: Wed, 14 May 2014 16:50:53 +0100
From: Javi Merino <javi.merino@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v2] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140514155053.GB3052@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
 <1399377998-14870-6-git-send-email-javi.merino@arm.com>
 <20140506132238.22e136d1@gandalf.local.home>
 <484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
 <20140506231238.246c7d3e@gandalf.local.home>
 <20140514142324.GA10024@e102654-lin.cambridge.arm.com>
 <20140514113623.171f2a39@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140514113623.171f2a39@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 May 2014 15:51:04.0230 (UTC) FILETIME=[4FD1FC60:01CF6F8C]
X-MC-Unique: 114051416505707801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:36:23PM +0100, Steven Rostedt wrote:
> On Wed, 14 May 2014 15:23:24 +0100
> Javi Merino <javi.merino@arm.com> wrote:
> 
> > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > index 0a1a4f7..d9c44af 100644
> > > --- a/include/trace/ftrace.h
> > > +++ b/include/trace/ftrace.h
> > > @@ -53,6 +53,9 @@
> > >  #undef __string
> > >  #define __string(item, src) __dynamic_array(char, item, -1)
> > >  
> > > +#undef __bitmask
> > > +#define __bitmask(item, src) __dynamic_array(char, item, -1)
> > > +
> > >  #undef TP_STRUCT__entry
> > >  #define TP_STRUCT__entry(args...) args
> > >  
> > > @@ -128,6 +131,9 @@
> > >  #undef __string
> > >  #define __string(item, src) __dynamic_array(char, item, -1)
> > >  
> > > +#undef __string
> > > +#define __string(item, src) __dynamic_array(unsigned long, item, -1)
> > > +
> > 
> > This overrides the previous definition of __string() and looks like it
> > shouldn't be here.
> 
> Bah! I knew there was a reason I didn't push this out to my for-next
> branch yet. I can still rebase :-)
> 
> That should have been __bitmask(). Hmm, amazing it still worked.
> 
> > 
> > >  #undef DECLARE_EVENT_CLASS
> > >  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > >  	struct ftrace_data_offsets_##call {				\
> > > @@ -200,6 +206,15 @@
> > >  #undef __get_str
> > >  #define __get_str(field) (char *)__get_dynamic_array(field)
> > >  
> > > +#undef __get_bitmask
> > > +#define __get_bitmask(field)						\
> > > +	({								\
> > > +		void *__bitmask = __get_dynamic_array(field);		\
> > > +		unsigned int __bitmask_size;				\
> > > +		__bitmask_size = (__entry->__data_loc_##field >> 16) & 0xffff; \
> > > +		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
> > > +	})
> > > +
> > >  #undef __print_flags
> > >  #define __print_flags(flag, delim, flag_array...)			\
> > >  	({								\
> > > @@ -322,6 +337,9 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
> > >  #undef __string
> > >  #define __string(item, src) __dynamic_array(char, item, -1)
> > >  
> > > +#undef __bitmask
> > > +#define __bitmask(item, src) __dynamic_array(unsigned long, item, -1)
> > > +
> > >
> > >  #undef DECLARE_EVENT_CLASS
> > >  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
> > >  static int notrace __init						\
> > > @@ -372,6 +390,29 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
> > >  #define __string(item, src) __dynamic_array(char, item,			\
> > >  		    strlen((src) ? (const char *)(src) : "(null)") + 1)
> > >  
> > > +/*
> > > + * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
> > > + * num_possible_cpus().
> > > + */
> > > +#define __bitmask_size_in_bytes_raw			\
> > > +	((num_possible_cpus() + 7) / 8)
> > > +
> > > +#define __bitmask_size_in_longs						\
> > > +	((__bitmask_size_in_bytes_raw + ((BITS_PER_LONG / 8) - 1))	\
> > > +	 / (BITS_PER_LONG / 8))
> > > +
> > > +/*
> > > + * __bitmask_size_in_bytes is the number of bytes needed to hold
> > > + * num_possible_cpus() padded out to the nearest long. This is what
> > > + * is saved in the buffer, just to be consistent.
> > > + */
> > > +#define __bitmask_size_in_bytes				\
> > > +	(__bitmask_size_in_longs * (BITS_PER_LONG / 8))
> > > +
> > > +#undef __bitmask
> > > +#define __bitmask(item, src) __dynamic_array(unsigned long, item,	\
> > > +					     __bitmask_size_in_longs)
> > > +
> > >  #undef DECLARE_EVENT_CLASS
> > >  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > >  static inline notrace int ftrace_get_offsets_##call(			\
> > > @@ -513,12 +554,22 @@ static inline notrace int ftrace_get_offsets_##call(			\
> > >  	__entry->__data_loc_##item = __data_offsets.item;
> > >  
> > >  #undef __string
> > > -#define __string(item, src) __dynamic_array(char, item, -1)       	\
> > > +#define __string(item, src) __dynamic_array(char, item, -1)
> > >  
> > >  #undef __assign_str
> > >  #define __assign_str(dst, src)						\
> > >  	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
> > >  
> > > +#undef __bitmask
> > > +#define __bitmask(item, src) __dynamic_array(unsigned long, item, -1)
> > 
> > Why src?  It's not used in any of the definitions of the __bitmask()
> > macro, can we remove it?
> 
> Hmm, I may need to refactor this. I may pull this patch for now to push
> the rest to for-next.
> 
> I just noticed that we need a way to specify the length of the bitmask.
> Right now it's hardcoded as "num_possible_cpus", which Mathieu was
> asking for a more generic approach.
> 
> OK, let me pull this patch out of my tree (thank god I never pushed
> it), and work on it a bit more.

Ok, well keep me posted on this, I've tried to use it but trace-cmd
says "[FAILED TO PARSE]" and I'm still trying to figure out if it's me
not using it properly or some bug in the code.

Cheers,
Javi

