Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaAGBuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:50:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61946 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755986AbaAGBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:50:38 -0500
Date: Mon, 6 Jan 2014 20:50:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
Message-ID: <20140106205034.53c219cc@gandalf.local.home>
In-Reply-To: <1389055673.3040.83.camel@empanada>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
	<20140106161347.4cc82a4b@gandalf.local.home>
	<1389055673.3040.83.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jan 2014 18:47:53 -0600

> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 03d2db2..ccda66f 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -370,6 +370,75 @@ extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *fil
> >  extern void event_triggers_post_call(struct ftrace_event_file *file,
> >  				     enum event_trigger_type tt);
> >  
> > +static inline int
> > +ftrace_trigger_call_disabled(struct ftrace_event_file *file)
> > +{
> > +	unsigned long eflags = file->flags;
> > +
> > +	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
> > +		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
> > +			event_triggers_call(file, NULL);
> > +		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> 
> ftrace_trigger_call_disabled() as a name is OK, but it makes it sound
> like the trigger calls are disabled if it returns 1, when it actually
> can invoke the triggers when it returns 1, in cases where there's no
> reason to delay them.  ftrace_call_triggers_check_soft_disabled() is
> more accurate but too unwieldy, so I'm not coming up with anything
> better.  Maybe ftrace_trigger_soft_disabled() reads better, or not.
> Punting...

Honestly, I just whipped those names up out of the blue. Yeah,
ftrace_trigger_soft_disabled() sounds better. Will switch.

> 
> > +static inline int
> > +__event_trigger_test_discard(struct ftrace_event_file *file,
> > +			     struct ring_buffer *buffer,
> > +			     struct ring_buffer_event *event,
> > +			     void *entry,
> > +			     enum event_trigger_type *tt)
> > +{
> > +	unsigned long eflags = file->flags;
> > +
> > +	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
> > +		*tt = event_triggers_call(file, entry);
> > +
> > +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags))
> > +		ring_buffer_discard_commit(buffer, event);
> > +	else if (!filter_check_discard(file, entry, buffer, event))
> > +		return 1;
> 
> If the function is called ..._discard() then shouldn't it return 0 if it
> didn't discard?

Hmm, this was a ugly helper function (hence the "__" ;-) I really
couldn't think of a good name. Actually, it's called "test_discard"
which means it's just a test to know if it should discard or not.

How about if I switch it to ".._discard_test" and just comment what it
returns? I was going to add comments regardless.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static inline void
> > +event_trigger_unlock_commit(struct ftrace_event_file *file,
> > +			    struct ring_buffer *buffer,
> > +			    struct ring_buffer_event *event,
> > +			    void *entry, unsigned long irq_flags, int pc)
> > +{
> > +	unsigned long eflags = file->flags;
> 
> eflags isn't used in this function...

Hah, thanks. It originally was before I created the
__event_trigger_test_discard() helper function. My extensive tests would
have caught that too, but thanks. That saved me from having to fix it
before running the tests again.

> 
> > +	enum event_trigger_type tt = ETT_NONE;
> > +
> > +	if (__event_trigger_test_discard(file, buffer, event, entry, &tt))
> > +		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
> 
> The logic is correct overall, but the way it reads is the opposite of
> what it used to i.e. it should read 'if you don't discard the event,
> then do the trace_buffer_unlock_commit' - it works as written because it
> returns 1 if it didn't discard, which is confusing.

Hmm, OK, I think you may have convinced me. I'll swap the return values.

I need to write up some trigger tests to make sure they work the same
before and after this patch.

> 
> > +
> > +	if (tt)
> > +		event_triggers_post_call(file, tt);
> > +}
> > +
> > +
> > +static inline void
> > +event_trigger_unlock_commit_regs(struct ftrace_event_file *file,
> > +				 struct ring_buffer *buffer,
> > +				 struct ring_buffer_event *event,
> > +				 void *entry, unsigned long irq_flags, int pc,
> > +				 struct pt_regs *regs)
> > +{
> > +	unsigned long eflags = file->flags;
> 
> Ditto here on the unused eflags.

This one was cut and pasted added.

Thanks!

-- Steve

