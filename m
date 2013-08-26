Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3HZO7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:59:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:26516 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab3HZO7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:59:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392160955"
Message-ID: <1377529140.15688.13.camel@empanada>
Subject: Re: [PATCH v6 02/10] tracing: add basic event trigger framework
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Aug 2013 09:59:00 -0500
In-Reply-To: <521AF6DF.7010609@hitachi.com>
References: <cover.1377213245.git.tom.zanussi@linux.intel.com>
	 <923484a1826a9c5b872450dc60fe41a6815a1709.1377213245.git.tom.zanussi@linux.intel.com>
	 <521AF6DF.7010609@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-26 at 15:34 +0900, Masami Hiramatsu wrote:
> Hi Tom,
> 
> This patch basically good for me.
> 
> Unfortunately, I've found a small build issue on this patch.
> 
>   CC      kernel/trace/trace_events_filter.o
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events.c:1864:1: error: static declaration of 'find_event_file' follows non-static declaration
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace.h:1019:34: note: previous declaration of 'find_event_file' was here
> make[3]: *** [kernel/trace/trace_events.o] Error 1
> 

Right, making find_event_file() extern is premature here - it isn't even
used until patch 06.

> 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index b1227b9..1733ac9 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -1016,9 +1016,184 @@ extern void trace_event_enable_cmd_record(bool enable);
> >  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
> >  extern int event_trace_del_tracer(struct trace_array *tr);
> >
> > +extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
> > +						 const char *system,
> > +						 const char *event);
> > +
> 
> Here, you exposed find_event_file, but forgot to remove static from the definition
> in kernel/trace/trace_events.c.
> And even if it solved, I also hit an error and many warnings.
> 
>   LD      arch/x86/built-in.o
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c: In function 'event_trigger_callback':
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:510:14: error: 'struct event_trigger_data' has no member named 'post_trigger'
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c: At top level:
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:242:19: warning: 'register_event_command' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:267:19: warning: 'unregister_event_command' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:297:1: warning: 'event_trigger_print' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:326:1: warning: 'event_trigger_init' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:344:1: warning: 'event_trigger_free' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:412:12: warning: 'register_trigger' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:451:13: warning: 'unregister_trigger' defined but not used [-Wunused-function]
> /home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:482:1: warning: 'event_trigger_callback' defined but not used [-Wunused-function]
> make[3]: *** [kernel/trace/trace_events_trigger.o] Error 1
> 
> The post_trigger member is introduced in 7/10, and all warning helper functions
> are used in the next (3/10) patch. So, I recommend you to move all post_trigger
> related code into 7/10 or merge it into this patch, and move all helper functions
> into 3/10 for fixing these warnings and an error. :)
> 

Yeah, some of these also got left behind (or ahead) in the shuffle
between patches - let me fix them up again..

> (2013/08/23 8:27), Tom Zanussi wrote:
> > +/**
> > + * struct event_command - callbacks and data members for event commands
> > + *
> [...]
> > + * @post_trigger: A flag that says whether or not this command needs
> [...]
> > +	trigger_data->count = -1;
> > +	trigger_data->ops = trigger_ops;
> > +	trigger_data->cmd_ops = cmd_ops;
> > +	trigger_data->mode = cmd_ops->trigger_mode;
> > +	trigger_data->post_trigger = cmd_ops->post_trigger;
> 
> BTW, why the trigger_data has a copy of trigger_mode and post_trigger?
> It seems redundant... :(

Good point, no sooner do I assign cmd_ops than apparently completely
forget about it in the next two lines. ;-)

> Also, the "trigger_mode" name is not good for me, because we already has
> FTRACE_EVENT_FL_TRIGGER_MODE_BIT bitflag. Perhaps, trigger_group or just
> group_id may be better, I think.
> 
> Thank you,
> 

Right, since it's doing double duty, it was hard to come up with a good
name for it - group_id might just be generic enough though - I'll switch
to that in the next revision, I think..

Thanks,

Tom 


