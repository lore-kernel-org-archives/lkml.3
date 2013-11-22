Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3KVORP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:17:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56978 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3KVORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:17:14 -0500
Subject: Re: [PATCH 01/22] tools lib traceevent: Add plugin support
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-2-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Nov 2013 23:17:06 +0900
Message-ID: <1385129826.1747.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2013-11-21 (목), 12:00 +0100, Jiri Olsa:
> Backporting plugin support for traceevent lib.
> 
> Backported from Steven Rostedt's trace-cmd repo (HEAD 0f2c2fb):
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> It's now possible to use following interface to load plugins
> (shared objects) to enahnce pevent object functionality.
> 
> The plugin interface/hooks are as follows:
> (taken from event-parse.h comments)
> 
> - 'pevent_plugin_loader' (required)
>     The function name to initialized the plugin.
> 
>     int pevent_plugin_loader(struct pevent *pevent)
> 
> - 'pevent_plugin_unloader' (optional)
>     The function called just before unloading
> 
>     int pevent_plugin_unloader(void)
> 
> - 'pevent_plugin_options'  (optional)
>     Plugin options that can be set before loading
> 
>     struct plugin_option pevent_plugin_options[] = {
>        {
>                .name = "option-name",
>                .plugin_alias = "overide-file-name", (optional)
>                .description = "description of option to show users",
>        },
>        {
>                .name = NULL,
>        },
>     };
> 
>     Array must end with .name = NULL;
> 
>     The plugin_alias (below) can be used to give a shorter
>     name to access the vairable. Useful if a plugin handles
>     more than one event.
> 
>     NOTE options support is not backported yet.
> 
> - 'pevent_plugin_alias' (optional)
>     The name to use for finding options (uses filename if not defined)
> 
> New traceevent functions are added to search and load
> available plugins:
> 
>   struct plugin_list*
>   traceevent_load_plugins(struct pevent *pevent)
>     - loads plusing for 'struct pevent' object and returns
>       loaded plugins list
> 
>   void traceevent_unload_plugins(struct plugin_list *plugin_list);
>     - unload plugin list

First of all, thank you for your nice work! :)

> 
[SNIP[
> +static void
> +load_plugin(struct pevent *pevent, const char *path,
> +	    const char *file, void *data)
> +{
> +	struct plugin_list **plugin_list = data;
> +	pevent_plugin_load_func func;
> +	struct plugin_list *list;
> +	const char *alias;
> +	char *plugin;
> +	void *handle;
> +
> +	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);

I'd like not to see this malloc_or_die() anymore in a new code.  Just
returning after showing a warning looks enough here.

> +
> +	strcpy(plugin, path);
> +	strcat(plugin, "/");
> +	strcat(plugin, file);
> +
> +	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);

Why RTLD_NOW and RTLD_GLOBAL?  Hmm.. maybe using _NOW is needed to
prevent a runtime error, but not sure why _GLOBAL is needed.

IIUC _GLOBAL is for exporting symbols to *other libraries*.  Is it
intended for this plugin support?


> +	if (!handle) {
> +		warning("could not load plugin '%s'\n%s\n",
> +			plugin, dlerror());
> +		goto out_free;
> +	}
> +
> +	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
> +	if (!alias)
> +		alias = file;

So this 'alias' is not used anywhere in the current code, right?
Do you plan to add the option processing soon?

> +
> +	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
> +	if (!func) {
> +		warning("could not find func '%s' in plugin '%s'\n%s\n",
> +			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
> +		goto out_free;
> +	}
> +
> +	list = malloc_or_die(sizeof(*list));

Ditto.  Please check return value and handle error properly.


> +	list->next = *plugin_list;
> +	list->handle = handle;
> +	list->name = plugin;
> +	*plugin_list = list;
> +
> +	pr_stat("registering plugin: %s", plugin);
> +	func(pevent);
> +	return;
> +
> + out_free:
> +	free(plugin);
> +}
> +
> +static void
> +load_plugins_dir(struct pevent *pevent, const char *suffix,
> +		 const char *path,
> +		 void (*load_plugin)(struct pevent *pevent,
> +				     const char *path,
> +				     const char *name,
> +				     void *data),

Doesn't gcc complain about the name shadows other function?  Anyway I
think we should avoid using same name - probably using typedef for the
function might be helpful.


> +		 void *data)
[SNIP]
> +	/*
> +	 * Now let the home directory override the environment
> +	 * or system defaults.
> +	 */
> +	home = getenv("HOME");
> +	if (!home)
> +		return;
> +
> +	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);

Ditto.

Thanks,
Namhyung

> +
> +	strcpy(path, home);
> +	strcat(path, "/");
> +	strcat(path, LOCAL_PLUGIN_DIR);
> +
> +	load_plugins_dir(pevent, suffix, path, load_plugin, data);
> +
> +	free(path);
> +}
> +
> +struct plugin_list*
> +traceevent_load_plugins(struct pevent *pevent)
> +{
> +	struct plugin_list *list = NULL;
> +
> +	load_plugins(pevent, ".so", load_plugin, &list);
> +	return list;
> +}
> +
> +void
> +traceevent_unload_plugins(struct plugin_list *plugin_list)
> +{
> +	pevent_plugin_unload_func func;
> +	struct plugin_list *list;
> +
> +	while (plugin_list) {
> +		list = plugin_list;
> +		plugin_list = list->next;
> +		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
> +		if (func)
> +			func();
> +		dlclose(list->handle);
> +		free(list->name);
> +		free(list);
> +	}
> +}



