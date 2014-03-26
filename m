Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbaCZVWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:22:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34609 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753544AbaCZVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:22:10 -0400
Message-ID: <1395868919.5365.6.camel@pippen.local.home>
Subject: Re: [GIT PULL] tracing: Fix traceon trigger condition to actually
 turn tracing on
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Olof Johansson <olof@lixom.net>
Date: Wed, 26 Mar 2014 17:21:59 -0400
In-Reply-To: <1395857987.10059.23.camel@empanada>
References: <1395839857.7667.9.camel@pippen.local.home>
	 <1395857987.10059.23.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, I forgot to Cc LKML on my pull request. Doing this from a
conference with very poor internet access from a laptop that I don't
usually develop on, means I might make mistakes.

On Wed, 2014-03-26 at 13:19 -0500, Tom Zanussi wrote:
> On Wed, 2014-03-26 at 09:17 -0400, Steven Rostedt wrote:
> > Linus,
> > 
> > While on my flight to Linux Collaboration Summit, I was working on
> > my slides for the event trigger tutorial. I booted a 3.14-rc7 kernel
> > to perform what I wanted to teach and cut and paste it into my slides.
> > When I tried the traceon event trigger with a condition attached to it
> > (turns tracing on only if a field of the trigger event matches a condition
> > set by the user), nothing happened. Tracing would not turn on. I stopped
> > working on my presentation in order to find what was wrong.
> > 
> 
> Hi Steve,
> 
> Sorry you had to stop working on your presentation to dig into this -
> thanks for doing that though - it looks correct and fixes the problem
> here for me, so you can add my Tested-by:
> 
> Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Linus already pulled it. But Olof came to me at lunch to tell me my
patch broke his PA Semi PPC box.

Olof, as you well know, I also own one of those beasts, and I just
booted the kernel with that patch and all works fine. Perhaps its a
config issue? Can you send me your config.

Thanks,

-- Steve

> 
> And I'll make sure I add the 'traceon with filter' case to my
> 'test-suite' (I covered the 'traceoff with filter' case, obviously
> there's an important difference, though).
> 
> Also, if you'd be interested in adding something for your Collab Summit
> event triggers talk, I've been working on a new trigger type called a
> 'hash' trigger and have been using it for my own work here.  If so, I
> can do a quick cleanup and push it somewhere...
> 
> Tom
> 
> 
> > It ended up being the way trace event triggers work when they have
> > conditions. Instead of copying the fields, the condition code just
> > looks at the fields that were copied into the ring buffer. This works
> > great, unless tracing is off. That's because when the event is reserved
> > on the ring buffer, the ring buffer returns a NULL pointer, this tells
> > the tracing code that the ring buffer is disabled. This ends up being
> > a problem for the traceon trigger if it is using this information to
> > check its condition.
> > 
> > Luckily the code that checks if tracing is on returns the ring buffer
> > to use (because the ring buffer is determined by the event file
> > also passed to that field). I was able to easily solve this bug by
> > checking in that helper function if the returned ring buffer entry
> > is NULL, and if so, also check the file flag if it has a trace event
> > trigger condition, and if so, to pass back a temp ring buffer to use.
> > This will allow the trace event trigger condition to still test the
> > event fields, but nothing will be recorded.
> > 
> > I understand that this is very late, but as this feature was added in
> > 3.14, and fixes a bug that breaks a feature that I'm showing people
> > how to use in my tutorial, it would be great if it's not broken in
> > the v3.14 release.
> > 
> > Please pull the latest trace-fixes-v3.14-rc7-v2 tree, which can be found at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > trace-fixes-v3.14-rc7-v2
> > 
> > Tag SHA1: fb89a9d8782b1b25cd78a7c06e1110efa5339911
> > Head SHA1: 2c4a33aba5f9ea3a28f2e40351f078d95f00786b
> > 
> > 
> > Steven Rostedt (Red Hat) (1):
> >       tracing: Fix traceon trigger condition to actually turn tracing on
> > 
> > ----
> >  kernel/trace/trace.c | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> > ---------------------------
> > commit 2c4a33aba5f9ea3a28f2e40351f078d95f00786b
> > Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
> > Date:   Tue Mar 25 23:39:41 2014 -0400
> > 
> >     tracing: Fix traceon trigger condition to actually turn tracing on
> >     
> >     While working on my tutorial for 2014 Linux Collaboration Summit
> >     I found that the traceon trigger did not work when conditions were
> >     used. The other triggers worked fine though. Looking into it, it
> >     is because of the way the triggers use the ring buffer to store
> >     the fields it will use for the condition. But if tracing is off, nothing
> >     is stored in the buffer, and the tracepoint exits before calling the
> >     trigger to test the condition. This is fine for all the triggers that
> >     only work when tracing is on, but for traceon trigger that is to
> >     work when tracing is off, nothing happens.
> >     
> >     The fix is simple, just use a temp ring buffer to record the event
> >     if tracing is off and the event has a trace event conditional trigger
> >     enabled. The rest of the tracepoint code will work just fine, but
> >     the tracepoint wont be recorded in the other buffers.
> >     
> >     Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 815c878..24c1f23 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1600,15 +1600,31 @@ void trace_buffer_unlock_commit(struct ring_buffer *buffer,
> >  }
> >  EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
> >  
> > +static struct ring_buffer *temp_buffer;
> > +
> >  struct ring_buffer_event *
> >  trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
> >  			  struct ftrace_event_file *ftrace_file,
> >  			  int type, unsigned long len,
> >  			  unsigned long flags, int pc)
> >  {
> > +	struct ring_buffer_event *entry;
> > +
> >  	*current_rb = ftrace_file->tr->trace_buffer.buffer;
> > -	return trace_buffer_lock_reserve(*current_rb,
> > +	entry = trace_buffer_lock_reserve(*current_rb,
> >  					 type, len, flags, pc);
> > +	/*
> > +	 * If tracing is off, but we have triggers enabled
> > +	 * we still need to look at the event data. Use the temp_buffer
> > +	 * to store the trace event for the tigger to use. It's recusive
> > +	 * safe and will not be recorded anywhere.
> > +	 */
> > +	if (!entry && ftrace_file->flags & FTRACE_EVENT_FL_TRIGGER_COND) {
> > +		*current_rb = temp_buffer;
> > +		entry = trace_buffer_lock_reserve(*current_rb,
> > +						  type, len, flags, pc);
> > +	}
> > +	return entry;
> >  }
> >  EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
> >  
> > @@ -6494,11 +6510,16 @@ __init static int tracer_alloc_buffers(void)
> >  
> >  	raw_spin_lock_init(&global_trace.start_lock);
> >  
> > +	/* Used for event triggers */
> > +	temp_buffer = ring_buffer_alloc(PAGE_SIZE, RB_FL_OVERWRITE);
> > +	if (!temp_buffer)
> > +		goto out_free_cpumask;
> > +
> >  	/* TODO: make the number of buffers hot pluggable with CPUS */
> >  	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
> >  		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
> >  		WARN_ON(1);
> > -		goto out_free_cpumask;
> > +		goto out_free_temp_buffer;
> >  	}
> >  
> >  	if (global_trace.buffer_disabled)
> > @@ -6540,6 +6561,8 @@ __init static int tracer_alloc_buffers(void)
> >  
> >  	return 0;
> >  
> > +out_free_temp_buffer:
> > +	ring_buffer_free(temp_buffer);
> >  out_free_cpumask:
> >  	free_percpu(global_trace.trace_buffer.data);
> >  #ifdef CONFIG_TRACER_MAX_TRACE
> > 
> > 
> 


