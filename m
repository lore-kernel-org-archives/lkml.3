Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaAOQSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:18:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30767 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751499AbaAOQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:18:41 -0500
Date: Wed, 15 Jan 2014 11:18:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add
 pevent_unregister_event_handler()
Message-ID: <20140115111839.73d85422@gandalf.local.home>
In-Reply-To: <1389750340-15965-7-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-7-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:29 +0900
Namhyung Kim <namhyung@kernel.org> wrote:
  
>  	pr_stat("overriding event (%d) %s:%s with new print handler",
>  		event->id, event->system, event->name);
> @@ -5637,6 +5649,79 @@ int pevent_register_event_handler(struct pevent *pevent, int id,
>  	return -1;
>  }
>  
> +static int handle_matches(struct event_handler *handler, int id,
> +			  const char *sys_name, const char *event_name,
> +			  pevent_event_handler_func func, void *context)
> +{
> +	if (id >= 0 && id != handler->id)
> +		return 0;
> +
> +	if (event_name && (strcmp(event_name, handler->event_name) != 0))
> +		return 0;
> +
> +	if (sys_name && (strcmp(sys_name, handler->sys_name) != 0))
> +		return 0;
> +
> +	if (func != handler->func || context != handler->context)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/**
> + * pevent_unregister_event_handler - unregister an existing event handler
> + * @pevent: the handle to the pevent
> + * @id: the id of the event to unregister
> + * @sys_name: the system name the handler belongs to
> + * @event_name: the name of the event handler
> + * @func: the function to call to parse the event information
> + * @context: the data to be passed to @func
> + *
> + * This function removes existing event handler (parser).
> + *
> + * If @id is >= 0, then it is used to find the event.
> + * else @sys_name and @event_name are used.
> + *
> + * Returns 0 if handler was removed successfully, -1 if event was not found.
> + */
> +int pevent_unregister_event_handler(struct pevent *pevent, int id,
> +				    const char *sys_name, const char *event_name,
> +				    pevent_event_handler_func func, void *context)
> +{
> +	struct event_format *event;
> +	struct event_handler *handle;
> +	struct event_handler **next;
> +
> +	event = pevent_search_event(pevent, id, sys_name, event_name);
> +	if (event == NULL)
> +		goto not_found;
> +
> +	if (event->handler == func && event->context == context) {
> +		pr_stat("overriding event (%d) %s:%s with default print handler",

Should we use the word "overriding" again? Perhaps saying:

"removing override print handler (%d) %s:%s. Going back to default handler."

Or something?

-- Steve

> +			event->id, event->system, event->name);
> +
> +		event->handler = NULL;
> +		event->context = NULL;
> +		return 0;
> +	}
> +
> +not_found:
> +	for (next = &pevent->handlers; *next; next = &(*next)->next) {
> +		handle = *next;
> +		if (handle_matches(handle, id, sys_name, event_name,
> +				   func, context))
> +			break;
> +	}
> +
> +	if (!(*next))
> +		return -1;
> +
> +	*next = handle->next;
> +	free_handler(handle);
> +
> +	return 0;
> +}
> +
