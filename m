Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaAOSM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:12:26 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54003 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaAOSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:12:24 -0500
Date: Wed, 15 Jan 2014 15:12:14 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add
 pevent_unregister_event_handler()
Message-ID: <20140115181214.GA9750@ghostprotocols.net>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
 <1389750340-15965-7-git-send-email-namhyung@kernel.org>
 <20140115111839.73d85422@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115111839.73d85422@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 15, 2014 at 11:18:39AM -0500, Steven Rostedt escreveu:
> On Wed, 15 Jan 2014 10:45:29 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>   
> >  	pr_stat("overriding event (%d) %s:%s with new print handler",
> >  		event->id, event->system, event->name);
> > @@ -5637,6 +5649,79 @@ int pevent_register_event_handler(struct pevent *pevent, int id,
> >  	return -1;
> >  }
> >  
> > +static int handle_matches(struct event_handler *handler, int id,
> > +			  const char *sys_name, const char *event_name,
> > +			  pevent_event_handler_func func, void *context)
> > +{
> > +	if (id >= 0 && id != handler->id)
> > +		return 0;
> > +
> > +	if (event_name && (strcmp(event_name, handler->event_name) != 0))
> > +		return 0;
> > +
> > +	if (sys_name && (strcmp(sys_name, handler->sys_name) != 0))
> > +		return 0;
> > +
> > +	if (func != handler->func || context != handler->context)
> > +		return 0;
> > +
> > +	return 1;
> > +}
> > +
> > +/**
> > + * pevent_unregister_event_handler - unregister an existing event handler
> > + * @pevent: the handle to the pevent
> > + * @id: the id of the event to unregister
> > + * @sys_name: the system name the handler belongs to
> > + * @event_name: the name of the event handler
> > + * @func: the function to call to parse the event information
> > + * @context: the data to be passed to @func
> > + *
> > + * This function removes existing event handler (parser).
> > + *
> > + * If @id is >= 0, then it is used to find the event.
> > + * else @sys_name and @event_name are used.
> > + *
> > + * Returns 0 if handler was removed successfully, -1 if event was not found.
> > + */
> > +int pevent_unregister_event_handler(struct pevent *pevent, int id,
> > +				    const char *sys_name, const char *event_name,
> > +				    pevent_event_handler_func func, void *context)
> > +{
> > +	struct event_format *event;
> > +	struct event_handler *handle;
> > +	struct event_handler **next;
> > +
> > +	event = pevent_search_event(pevent, id, sys_name, event_name);
> > +	if (event == NULL)
> > +		goto not_found;
> > +
> > +	if (event->handler == func && event->context == context) {
> > +		pr_stat("overriding event (%d) %s:%s with default print handler",
> 
> Should we use the word "overriding" again? Perhaps saying:
> 
> "removing override print handler (%d) %s:%s. Going back to default handler."
> 
> Or something?

Applied up to the patch just before this one, waiting for a resolution.
 
> -- Steve
> 
> > +			event->id, event->system, event->name);
> > +
> > +		event->handler = NULL;
> > +		event->context = NULL;
> > +		return 0;
> > +	}
> > +
> > +not_found:
> > +	for (next = &pevent->handlers; *next; next = &(*next)->next) {
> > +		handle = *next;
> > +		if (handle_matches(handle, id, sys_name, event_name,
> > +				   func, context))
> > +			break;
> > +	}
> > +
> > +	if (!(*next))
> > +		return -1;
> > +
> > +	*next = handle->next;
> > +	free_handler(handle);
> > +
> > +	return 0;
> > +}
> > +
