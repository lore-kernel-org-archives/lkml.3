Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab3IPDh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:37:57 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40480 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3IPDh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:37:56 -0400
Message-ID: <52367D0F.6070105@gmail.com>
Date: Sun, 15 Sep 2013 21:37:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 04/24] tools list traceevent: Add plugin support
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com> <1378032529-18498-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/13 4:48 AM, Jiri Olsa wrote:
> Backporting plugin support for traceevent lib.

It would be worthwhile to not where the code is ported from -- 
repository and as of commit id.

David


>
> It's now possible to use following interface
> to load plugins for 'struct pevent' object:
>
> struct plugin_list*
> traceevent_load_plugins(struct pevent *pevent)
>    - loads plusing for 'struct pevent' object and returns
>      loaded plugins list
>
> void traceevent_unload_plugins(struct plugin_list *plugin_list);
>    - unload plugin list
>
> Adding -ldl dependency for perf which is needed
> due to plugins support.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>   tools/lib/traceevent/Makefile       |   2 +-
>   tools/lib/traceevent/event-parse.h  |   5 +
>   tools/lib/traceevent/event-plugin.c | 202 ++++++++++++++++++++++++++++++++++++
>   tools/perf/config/Makefile          |   2 +-
>   4 files changed, 209 insertions(+), 2 deletions(-)
>   create mode 100644 tools/lib/traceevent/event-plugin.c
>
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index ca6cb77..539f3e5 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -180,7 +180,7 @@ $(obj)/%.o: $(src)/%.c
>   %.o: $(src)/%.c
>   	$(Q)$(call do_compile)
>
> -PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
> +PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o
>   PEVENT_LIB_OBJS += kbuffer-parse.o
>
>   ALL_OBJS = $(PEVENT_LIB_OBJS)
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index c37b202..8273c6e 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -374,6 +374,11 @@ enum pevent_errno {
>   };
>   #undef _PE
>
> +struct plugin_list;
> +
> +struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
> +void traceevent_unload_plugins(struct plugin_list *plugin_list);
> +
>   struct cmdline;
>   struct cmdline_list;
>   struct func_map;
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> new file mode 100644
> index 0000000..d272d87
> --- /dev/null
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -0,0 +1,202 @@
> +/*
> + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation;
> + * version 2.1 of the License (not later!)
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#include <string.h>
> +#include <dlfcn.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <dirent.h>
> +#include "event-parse.h"
> +#include "event-utils.h"
> +
> +#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
> +
> +struct plugin_list {
> +	struct plugin_list	*next;
> +	char			*name;
> +	void			*handle;
> +};
> +
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
> +
> +	strcpy(plugin, path);
> +	strcat(plugin, "/");
> +	strcat(plugin, file);
> +
> +	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
> +	if (!handle) {
> +		warning("could not load plugin '%s'\n%s\n",
> +			plugin, dlerror());
> +		goto out_free;
> +	}
> +
> +	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
> +	if (!alias)
> +		alias = file;
> +
> +	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
> +	if (!func) {
> +		warning("could not find func '%s' in plugin '%s'\n%s\n",
> +			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
> +		goto out_free;
> +	}
> +
> +	list = malloc_or_die(sizeof(*list));
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
> +		 void *data)
> +{
> +	struct dirent *dent;
> +	struct stat st;
> +	DIR *dir;
> +	int ret;
> +
> +	ret = stat(path, &st);
> +	if (ret < 0)
> +		return;
> +
> +	if (!S_ISDIR(st.st_mode))
> +		return;
> +
> +	dir = opendir(path);
> +	if (!dir)
> +		return;
> +
> +	while ((dent = readdir(dir))) {
> +		const char *name = dent->d_name;
> +
> +		if (strcmp(name, ".") == 0 ||
> +		    strcmp(name, "..") == 0)
> +			continue;
> +
> +		/* Only load plugins that end in suffix */
> +		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
> +			continue;
> +
> +		load_plugin(pevent, path, name, data);
> +	}
> +
> +	closedir(dir);
> +}
> +
> +static void
> +load_plugins(struct pevent *pevent, const char *suffix,
> +	     void (*load_plugin)(struct pevent *pevent,
> +				 const char *path,
> +				 const char *name,
> +				 void *data),
> +	     void *data)
> +{
> +	char *home;
> +	char *path;
> +	char *envdir;
> +
> +	/*
> +	 * If a system plugin directory was defined,
> +	 * check that first.
> +	 */
> +#ifdef PLUGIN_DIR
> +	load_plugins_dir(pevent, suffix, PLUGIN_DIR, load_plugin, data);
> +#endif
> +
> +	/*
> +	 * Next let the environment-set plugin directory
> +	 * override the system defaults.
> +	 */
> +	envdir = getenv("TRACEEVENT_PLUGIN_DIR");
> +	if (envdir)
> +		load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
> +
> +	/*
> +	 * Now let the home directory override the environment
> +	 * or system defaults.
> +	 */
> +	home = getenv("HOME");
> +	if (!home)
> +		return;
> +
> +	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
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
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 214e17e..f6d720d 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -87,7 +87,7 @@ CFLAGS += -Wall
>   CFLAGS += -Wextra
>   CFLAGS += -std=gnu99
>
> -EXTLIBS = -lelf -lpthread -lrt -lm
> +EXTLIBS = -lelf -lpthread -lrt -lm -ldl
>
>   ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
>     CFLAGS += -fstack-protector-all
>

