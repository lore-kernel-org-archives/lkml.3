Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3KWJWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:22:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:52152 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750719Ab3KWJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:22:29 -0500
Date: Sat, 23 Nov 2013 04:22:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 10/22] tools lib traceevent: Add function plugin
Message-ID: <20131123042227.0f51320e@gandalf.local.home>
In-Reply-To: <1385132631.1747.68.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-11-git-send-email-jolsa@redhat.com>
	<1385132631.1747.68.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 00:03:51 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

 
> > Removing options support as it's not backported yet.
> > Currently this plugin supports 2 options:
> >  'parent' to display parent function
> >  'indent' to show function call indents
> > 
> > Enabling both of them by default.
> 
> [SNIP]
> > +static struct func_stack {
> > +	int index;
> 
> It seems not used anywhere.

You're right, it's not!  Not sure why I added that. Oh well, again,
lets add that as a clean up and keep the backport separate.

> 
> 
> > +	int size;
> > +	char **stack;
> > +} *fstack;
> > +
> > +static int cpus = -1;
> > +
> > +#define STK_BLK 10
> > +
> > +static void add_child(struct func_stack *stack, const char *child, int pos)
> > +{
> > +	int i;
> > +
> > +	if (!child)
> > +		return;
> > +
> > +	if (pos < stack->size)
> > +		free(stack->stack[pos]);
> > +	else {
> > +		if (!stack->stack)
> > +			stack->stack = malloc_or_die(sizeof(char *) * STK_BLK);
> 
> Please do not use this function.

Again, added as a separate patch (do I hear a theme ;-)

> 
> 
> > +		else
> > +			stack->stack = realloc(stack->stack, sizeof(char *) *
> > +					       (stack->size + STK_BLK));
> 
> It seems you need to use a local variable to check return value.
> 
> 
> > +		for (i = stack->size; i < stack->size + STK_BLK; i++)
> > +			stack->stack[i] = NULL;
> > +		stack->size += STK_BLK;
> > +	}
> > +
> > +	stack->stack[pos] = strdup(child);
> > +}
> > +
> > +static int get_index(const char *parent, const char *child, int cpu)
> 
> It seems this function does not only to get index but also to add
> function stack.  So how about renaming it to something like
> add_and_get_index()?
> 
> > +{
> > +	int i;
> > +
> > +	if (cpu < 0)
> > +		return 0;
> > +
> > +	if (cpu > cpus) {
> > +		if (fstack)
> > +			fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
> > +		else
> > +			fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
> 
> It seems it has same problem as above function.
> 
> > +
> > +		/* Account for holes in the cpu count */
> > +		for (i = cpus + 1; i <= cpu; i++)
> > +			memset(&fstack[i], 0, sizeof(fstack[i]));
> > +		cpus = cpu;
> > +	}
> > +
> > +	for (i = 0; i < fstack[cpu].size && fstack[cpu].stack[i]; i++) {
> > +		if (strcmp(parent, fstack[cpu].stack[i]) == 0) {
> > +			add_child(&fstack[cpu], child, i+1);
> > +			return i;
> > +		}
> > +	}
> > +
> > +	/* Not found */
> > +	add_child(&fstack[cpu], parent, 0);
> > +	add_child(&fstack[cpu], child, 1);
> > +	return 0;
> > +}
> > +
> > +static int function_handler(struct trace_seq *s, struct pevent_record *record,
> > +			    struct event_format *event, void *context)
> > +{
> > +	struct pevent *pevent = event->pevent;
> > +	unsigned long long function;
> > +	unsigned long long pfunction;
> > +	const char *func;
> > +	const char *parent;
> > +	int i, index;
> > +
> > +	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
> > +		return trace_seq_putc(s, '!');
> > +
> > +	func = pevent_find_function(pevent, function);
> > +
> > +	if (pevent_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
> > +		return trace_seq_putc(s, '!');
> > +
> > +	parent = pevent_find_function(pevent, pfunction);
> > +
> > +	index = get_index(parent, func, record->cpu);
> > +
> > +	for (i = 0; i < index; i++)
> > +		trace_seq_printf(s, "   ");
> 
> What about this?
> 
> 	trace_seq_printf(s, "%*s", index*3, "");

Nice trick ;-)

I'm fine with all the updates, but lets make that a patch on top.

Thanks,

-- Steve

> 
> Thanks,
> Namhyung
> 
> > +
> > +	if (func)
> > +		trace_seq_printf(s, "%s", func);
> > +	else
> > +		trace_seq_printf(s, "0x%llx", function);
> > +
> > +	trace_seq_printf(s, " <-- ");
> > +	if (parent)
> > +		trace_seq_printf(s, "%s", parent);
> > +	else
> > +		trace_seq_printf(s, "0x%llx", pfunction);
> > +
> > +	return 0;
> > +}
> > +
> > +int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
> > +{
> > +	pevent_register_event_handler(pevent, -1, "ftrace", "function",
> > +				      function_handler, NULL);
> > +	return 0;
> > +}
> > +
> > +void PEVENT_PLUGIN_UNLOADER(void)
> > +{
> > +	int i, x;
> > +
> > +	for (i = 0; i <= cpus; i++) {
> > +		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
> > +			free(fstack[i].stack[x]);
> > +		free(fstack[i].stack);
> > +	}
> > +
> > +	free(fstack);
> > +	fstack = NULL;
> > +	cpus = -1;
> > +}
> 
> 

