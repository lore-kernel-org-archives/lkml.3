Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaETCGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:06:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:29815 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750870AbaETCGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:06:22 -0400
Message-ID: <1400551571.10728.31.camel@pippen.local.home>
Subject: Re: [PATCH 2/4] tools lib traceevent: Add options to plugins
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2014 22:06:11 -0400
In-Reply-To: <1400509775.1742.15.camel@leonhard>
References: <20140516140215.149535442@goodmis.org>
	 <20140516140502.340008258@goodmis.org> <1400509775.1742.15.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 23:29 +0900, Namhyung Kim wrote:
> Hi Steve,
> 
> 2014-05-16 (금), 10:02 -0400, Steven Rostedt:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > The traceevent plugins allows developers to have their events print out
> > information that is more advanced than what can be achieved by the
> > trace event format files.
> > 
> > As these plugins are used on the userspace side of the tracing tools, it
> > is only logical that the tools should be able to produce different types
> > of output for the events. The types of events still need to be defined by
> > the plugins thus we need a way to pass information from the tool to the
> > plugin to specify what type of information to be shown.
> > 
> > Not only does the information need to be passed by the tool to plugin, but
> > the plugin also requires a way to notify the tool of what options it can
> > provide.
> > 
> > This builds the plugin option infrastructure that is taken from trace-cmd
> > that is used to allow plugins to produce different output based on the
> > options specified by the tool.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  tools/lib/traceevent/event-parse.h  |  16 ++-
> >  tools/lib/traceevent/event-plugin.c | 197 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 209 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> > index a68ec3d8289f..d6c610a66006 100644
> > --- a/tools/lib/traceevent/event-parse.h
> > +++ b/tools/lib/traceevent/event-parse.h
> > @@ -107,8 +107,8 @@ typedef int (*pevent_event_handler_func)(struct trace_seq *s,
> >  typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
> >  typedef int (*pevent_plugin_unload_func)(struct pevent *pevent);
> >  
> > -struct plugin_option {
> > -	struct plugin_option		*next;
> > +struct pevent_plugin_option {
> > +	struct pevent_plugin_option	*next;
> 
> Hmm.. this name change reminds me that it might be better if this plugin
> and option list belong to a pevent..

Yeah, eventually, but for now I want to try to sync what I have in
trace-cmd with what is here in libtraceevent. At least to save history.
Then we can modify it to be per pevent. For now, there's no users that
need it per pevent. But that should definitely be changed before we push
this out to distros.



> 
> 
> >  	void				*handle;
> >  	char				*file;
> >  	char				*name;
> > @@ -135,7 +135,7 @@ struct plugin_option {
> >   * PEVENT_PLUGIN_OPTIONS:  (optional)
> >   *   Plugin options that can be set before loading
> >   *
> > - *   struct plugin_option PEVENT_PLUGIN_OPTIONS[] = {
> > + *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
> >   *	{
> >   *		.name = "option-name",
> >   *		.plugin_alias = "overide-file-name", (optional)
> > @@ -355,7 +355,7 @@ enum pevent_func_arg_type {
> >  enum pevent_flag {
> >  	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
> >  	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
> > -	PEVENT_DISABLE_PLUGINS		= 1 << 2,
> > +	PEVENT_DISABLE_PLUGINS		= 1 << 2
> 
> Unnecessary change?

Heh, probably from my ediff (in emacs) making this file more like what I
had in trace-cmd. I can nuke it.

> 
> 
> >  };
> >  
> >  #define PEVENT_ERRORS 							      \
> > @@ -415,6 +415,14 @@ struct plugin_list;
> >  struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
> >  void traceevent_unload_plugins(struct plugin_list *plugin_list,
> >  			       struct pevent *pevent);
> > +char **traceevent_plugin_list_options(void);
> > +void traceevent_plugin_free_options_list(char **list);
> > +int traceevent_plugin_add_options(const char *name,
> > +				  struct pevent_plugin_option *options);
> > +void traceevent_plugin_remove_options(struct pevent_plugin_option *options);
> > +void traceevent_print_plugins(struct trace_seq *s,
> > +			      const char *prefix, const char *suffix,
> > +			      const struct plugin_list *list);
> >  
> >  struct cmdline;
> >  struct cmdline_list;
> > diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> > index 317466bd1a37..a24479426d58 100644
> > --- a/tools/lib/traceevent/event-plugin.c
> > +++ b/tools/lib/traceevent/event-plugin.c
> > @@ -18,6 +18,7 @@
> >   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   */
> >  
> > +#include <stdio.h>
> >  #include <string.h>
> >  #include <dlfcn.h>
> >  #include <stdlib.h>
> > @@ -30,12 +31,208 @@
> >  
> >  #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
> >  
> > +static struct registered_plugin_options {
> > +	struct registered_plugin_options	*next;
> > +	struct pevent_plugin_option		*options;
> > +} *registered_options;
> > +
> > +static struct trace_plugin_options {
> > +	struct trace_plugin_options	*next;
> > +	char				*plugin;
> > +	char				*option;
> > +	char				*value;
> > +} *trace_plugin_options;
> > +
> >  struct plugin_list {
> >  	struct plugin_list	*next;
> >  	char			*name;
> >  	void			*handle;
> >  };
> >  
> > +/**
> > + * traceevent_plugin_list_options - get list of plugin options
> > + *
> > + * Returns an array of char strings that list the currently registered
> > + * plugin options in the format of <plugin>:<option>. This list can be
> > + * used by toggling the option.
> > + *
> > + * Returns NULL if there's no options registered. On error it returns
> > + * an (char **)-1 (must check for that)
> 
> What about making it a macro like INVALID_OPTION_LIST?

Sure.

> 
> > + *
> > + * Must be freed with traceevent_plugin_free_options_list().
> > + */
> > +char **traceevent_plugin_list_options(void)
> > +{
> > +	struct registered_plugin_options *reg;
> > +	struct pevent_plugin_option *op;
> > +	char **list = NULL;
> > +	char *name;
> > +	int count = 0;
> > +
> > +	for (reg = registered_options; reg; reg = reg->next) {
> > +		for (op = reg->options; op->name; op++) {
> > +			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
> > +
> > +			name = malloc(strlen(op->name) + strlen(alias) + 2);
> > +			if (!name)
> > +				goto err;
> > +
> > +			sprintf(name, "%s:%s", alias, op->name);
> > +			list = realloc(list, count + 2);
> > +			if (!list) {
> 
> This will lost the original list pointer.  Please use a temp variable.

Thanks, will do.


> 
> 
> > +				free(name);
> > +				goto err;
> > +			}
> > +			list[count++] = name;
> > +			list[count] = NULL;
> > +		}
> > +	}
> > +	if (!count)
> > +		return NULL;
> > +	return list;
> 
> Isn't it enough to simply return the list?

Confused. Do you mean "Is it enough to simply return the list?"


> 
> > +
> > + err:
> > +	while (--count > 0)
> 
> Shouldn't it be >= instead of > ?

Yes! Nice catch.


> 
> Thanks,
> Namhyung

BTW, Are you at LinuxCon Japan?

-- Steve

> 
> 
> > +		free(list[count]);
> > +	free(list);
> > +
> > +	return (char **)((unsigned long)-1);
> > +}
> 


