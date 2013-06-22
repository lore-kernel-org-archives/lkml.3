Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3FVLxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 07:53:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3FVLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 07:53:45 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=KwlVUcAnNHUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H8hNLXAl5-4A:10 a=sNq4P7cdcACIvtj_JKUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371902024.18733.146.camel@gandalf.local.home>
Subject: Re: [PATCH 10/11] tracing: add and use generic set_trigger_filter()
 implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Jun 2013 07:53:44 -0400
In-Reply-To: <1371837575.6453.23.camel@empanada>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <8fe2c1ceb63a6375b56f046de835742f18b955ce.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C3D3FD.2070408@hitachi.com> <1371837575.6453.23.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 12:59 -0500, Tom Zanussi wrote:
> Hi Masami,
> 
> On Fri, 2013-06-21 at 13:18 +0900, Masami Hiramatsu wrote:
> > (2013/06/21 3:31), Tom Zanussi wrote:
> > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > index 88ac7da..7c5627f 100644
> > > --- a/include/trace/ftrace.h
> > > +++ b/include/trace/ftrace.h
> > > @@ -522,14 +522,6 @@ ftrace_raw_event_##call(void *__data, proto)				\
> > >  	int __data_size;						\
> > >  	int pc;								\
> > >  									\
> > > -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > > -		     &ftrace_file->flags))				\
> > > -		event_triggers_call(ftrace_file);			\
> > > -									\
> > > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> > > -		     &ftrace_file->flags))				\
> > > -		return;							\

I'd like to still exit early on soft disable if needed. Perhaps have a:

	if (ftrace_file->flags & (FTRACE_EVENT_FL_TRIGGER_MODE_BIT | \
	     FTRACE_EVENT_FL_SOFT_DISABLED_BIT) == \
	     FTRACE_EVENT_FL_SOFT_DISABLED_BIT) \
		return; \

> > > -									\
> > >  	local_save_flags(irq_flags);					\
> > >  	pc = preempt_count();						\
> > >  									\
> > > @@ -547,8 +539,22 @@ ftrace_raw_event_##call(void *__data, proto)				\
> > >  									\
> > >  	{ assign; }							\
> > >  									\
> > > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> > > +		     &ftrace_file->flags)) {				\
> > > +		ring_buffer_discard_commit(buffer, event);		\
> > > +									\
> > > +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,		\
> > > +			     &ftrace_file->flags))			\
> > > +			event_triggers_call(ftrace_file, entry);	\
> > > +		return;							\
> > > +	}								\
> > > +									\
> > >  	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
> > >  		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
> > > +									\
> > > +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> > > +		     &ftrace_file->flags))				\
> > > +		event_triggers_call(ftrace_file, entry);		\
> > 
> > Actually, since "entry" is a part of "event" which may be already discarded,
> > I think we should not access it here. It may not cause real problem because
> > even if it is discarded, that does NOT mean it is freed. However, it depends
> > on the ring-buffer implementation.
> > 
> > I recommend you to call event triggers before commit the event. It will also
> > make the code simpler :)
> >
> 
> That's what I originally did, and is what I was referring to when I
> mentioned the bit of 'trickiness' here. ;-)
> 
> The problem is that the trace_recursive_lock() check in
> ring_buffer_lock_reserve() prevents a trigger that itself logs to the
> ring buffer from reserving a slot in the buffer, since it's being done
> from the same context as the triggering event.  For example, the
> stacktrace trigger, which calls trace_dump_stack().

Ah, yeah that would happen.

> 
> So the code is a bit more convoluted than I'd like because of that -
> since we can't really invoke the triggers before the current event is
> committed, it waits until the current event is either discarded (because
> we're soft disabled) or committed (logging a normally-enabled event).
> 
> But you do point out a real problem with this - it means having to look
> at a discarded event in the soft-disabled case, and if for example some
> interrupt actually reserves and logs an event between the time we do the
> discard and invoke the filter, we could end up with a false filtering
> outcome.  I'm not sure how to prevent that though at this point - will
> have think about it some more...
> 

Perhaps add a trigger mode here:

enum trigger_mode {
	TM_NONE,
	TM_STACK,
};


Then do:

	trigger_mode = event_triggers_call(ftrace_file, entry);

	(finish event)


	if (unlikely(trigger_mode))
		event_triggers_post_call(ftrace_file, trigger_mode);

Something like that.

-- Steve


