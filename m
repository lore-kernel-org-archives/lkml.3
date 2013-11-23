Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3KWIM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:12:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42882 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925Ab3KWIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:12:26 -0500
Date: Sat, 23 Nov 2013 03:12:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/22] tools lib traceevent: Add plugin support
Message-ID: <20131123031219.5426ffa9@gandalf.local.home>
In-Reply-To: <1385129826.1747.22.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-2-git-send-email-jolsa@redhat.com>
	<1385129826.1747.22.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 23:17:06 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> > 
> [SNIP[
> > +static void
> > +load_plugin(struct pevent *pevent, const char *path,
> > +	    const char *file, void *data)
> > +{
> > +	struct plugin_list **plugin_list = data;
> > +	pevent_plugin_load_func func;
> > +	struct plugin_list *list;
> > +	const char *alias;
> > +	char *plugin;
> > +	void *handle;
> > +
> > +	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
> 
> I'd like not to see this malloc_or_die() anymore in a new code.  Just
> returning after showing a warning looks enough here.

Yeah I agree. This is a relic from my code. I think it's OK to add
here, as it is pretty much direct port of my code, and then we can just
add a patch against it to remove it.

> 
> > +
> > +	strcpy(plugin, path);
> > +	strcat(plugin, "/");
> > +	strcat(plugin, file);
> > +
> > +	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
> 
> Why RTLD_NOW and RTLD_GLOBAL?  Hmm.. maybe using _NOW is needed to
> prevent a runtime error, but not sure why _GLOBAL is needed.

Yes, we want to make sure all symbols defined are available at time of
load, otherwise bail out.

> 
> IIUC _GLOBAL is for exporting symbols to *other libraries*.  Is it
> intended for this plugin support?

That was the plan. To have one plugin supply a set of functions that
other plugins may use. That is what GLOBAL is for, right?  I don't
recall if I every did this, but it was something I wanted for future
work.

Now if we don't need it, we could remove it, but is it bad to have?


> 
> 
> > +	if (!handle) {
> > +		warning("could not load plugin '%s'\n%s\n",
> > +			plugin, dlerror());
> > +		goto out_free;
> > +	}
> > +
> > +	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
> > +	if (!alias)
> > +		alias = file;
> 
> So this 'alias' is not used anywhere in the current code, right?
> Do you plan to add the option processing soon?

I believe he is, and hopefully he will, because I want to forward port
this code to have trace-cmd use it. The end result should be a separate
library that we all can use.

It may be best to add the above alias when we add option support. But
it doesn't hurt to include it now, as long as we plan to add that in
the near future.

> 
> > +
> > +	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
> > +	if (!func) {
> > +		warning("could not find func '%s' in plugin '%s'\n%s\n",
> > +			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
> > +		goto out_free;
> > +	}
> > +
> > +	list = malloc_or_die(sizeof(*list));
> 
> Ditto.  Please check return value and handle error properly.

I agree, but lets make that a separate patch, such that we see the
changes between the backport and updates.

> 
> 
> > +	list->next = *plugin_list;
> > +	list->handle = handle;
> > +	list->name = plugin;
> > +	*plugin_list = list;
> > +
> > +	pr_stat("registering plugin: %s", plugin);
> > +	func(pevent);
> > +	return;
> > +
> > + out_free:
> > +	free(plugin);
> > +}
> > +
> > +static void
> > +load_plugins_dir(struct pevent *pevent, const char *suffix,
> > +		 const char *path,
> > +		 void (*load_plugin)(struct pevent *pevent,
> > +				     const char *path,
> > +				     const char *name,
> > +				     void *data),
> 
> Doesn't gcc complain about the name shadows other function?  Anyway I
> think we should avoid using same name - probably using typedef for the
> function might be helpful.

I agree here too, but again, lets keep the backport and fixes as
separate patches.

-- Steve

> 
> 
> > +		 void *data)
> [SNIP]
> > +	/*
> > +	 * Now let the home directory override the environment
> > +	 * or system defaults.
> > +	 */
> > +	home = getenv("HOME");
> > +	if (!home)
> > +		return;
> > +
> > +	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
> 
> Ditto.
> 
> Thanks,
> Namhyung
