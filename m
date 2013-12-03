Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3LCNQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:16:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3LCNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:10:22 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/28] tools lib traceevent: Add plugin support
Date: Tue,  3 Dec 2013 14:09:16 +0100
Message-Id: <1386076182-14484-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting plugin support for traceevent lib.

Backported from Steven Rostedt's trace-cmd repo (HEAD 0f2c2fb):
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

It's now possible to use following interface to load plugins
(shared objects) to enhance pevent object functionality.

The plugin interface/hooks are as follows:
(taken from event-parse.h comments)

- 'pevent_plugin_loader' (required)
    The function name to initialized the plugin.

    int pevent_plugin_loader(struct pevent *pevent)

- 'pevent_plugin_unloader' (optional)
    The function called just before unloading

    int pevent_plugin_unloader(void)

- 'pevent_plugin_options'  (optional)
    Plugin options that can be set before loading

    struct plugin_option pevent_plugin_options[] = {
       {
               .name = "option-name",
               .plugin_alias = "overide-file-name", (optional)
               .description = "description of option to show users",
       },
       {
               .name = NULL,
       },
    };

    Array must end with .name = NULL;

    The plugin_alias (below) can be used to give a shorter
    name to access the variable. Useful if a plugin handles
    more than one event.

    NOTE options support is not backported yet.

- 'pevent_plugin_alias' (optional)
    The name to use for finding options (uses filename if not defined)

New traceevent functions are added to search and load
available plugins:

  struct plugin_list*
  traceevent_load_plugins(struct pevent *pevent)
    - loads plusing for 'struct pevent' object and returns
      loaded plugins list

  void traceevent_unload_plugins(struct plugin_list *plugin_list);
    - unload plugin list

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile       |   6 +-
 tools/lib/traceevent/event-parse.h  |   5 +
 tools/lib/traceevent/event-plugin.c | 202 ++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/event-plugin.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index fc15020..2ccb5bc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -180,7 +180,11 @@ $(obj)/%.o: $(src)/%.c
 %.o: $(src)/%.c
 	$(Q)$(call do_compile)
 
-PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
+PEVENT_LIB_OBJS  = event-parse.o
+PEVENT_LIB_OBJS += event-plugin.o
+PEVENT_LIB_OBJS += trace-seq.o
+PEVENT_LIB_OBJS += parse-filter.o
+PEVENT_LIB_OBJS += parse-utils.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
 ALL_OBJS = $(PEVENT_LIB_OBJS)
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 8d73d25..a288860 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -377,6 +377,11 @@ enum pevent_errno {
 };
 #undef _PE
 
+struct plugin_list;
+
+struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
+void traceevent_unload_plugins(struct plugin_list *plugin_list);
+
 struct cmdline;
 struct cmdline_list;
 struct func_map;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
new file mode 100644
index 0000000..d272d87
--- /dev/null
+++ b/tools/lib/traceevent/event-plugin.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <string.h>
+#include <dlfcn.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <dirent.h>
+#include "event-parse.h"
+#include "event-utils.h"
+
+#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+
+struct plugin_list {
+	struct plugin_list	*next;
+	char			*name;
+	void			*handle;
+};
+
+static void
+load_plugin(struct pevent *pevent, const char *path,
+	    const char *file, void *data)
+{
+	struct plugin_list **plugin_list = data;
+	pevent_plugin_load_func func;
+	struct plugin_list *list;
+	const char *alias;
+	char *plugin;
+	void *handle;
+
+	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
+
+	strcpy(plugin, path);
+	strcat(plugin, "/");
+	strcat(plugin, file);
+
+	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
+	if (!handle) {
+		warning("could not load plugin '%s'\n%s\n",
+			plugin, dlerror());
+		goto out_free;
+	}
+
+	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
+	if (!alias)
+		alias = file;
+
+	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
+	if (!func) {
+		warning("could not find func '%s' in plugin '%s'\n%s\n",
+			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
+		goto out_free;
+	}
+
+	list = malloc_or_die(sizeof(*list));
+	list->next = *plugin_list;
+	list->handle = handle;
+	list->name = plugin;
+	*plugin_list = list;
+
+	pr_stat("registering plugin: %s", plugin);
+	func(pevent);
+	return;
+
+ out_free:
+	free(plugin);
+}
+
+static void
+load_plugins_dir(struct pevent *pevent, const char *suffix,
+		 const char *path,
+		 void (*load_plugin)(struct pevent *pevent,
+				     const char *path,
+				     const char *name,
+				     void *data),
+		 void *data)
+{
+	struct dirent *dent;
+	struct stat st;
+	DIR *dir;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0)
+		return;
+
+	if (!S_ISDIR(st.st_mode))
+		return;
+
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		/* Only load plugins that end in suffix */
+		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
+			continue;
+
+		load_plugin(pevent, path, name, data);
+	}
+
+	closedir(dir);
+}
+
+static void
+load_plugins(struct pevent *pevent, const char *suffix,
+	     void (*load_plugin)(struct pevent *pevent,
+				 const char *path,
+				 const char *name,
+				 void *data),
+	     void *data)
+{
+	char *home;
+	char *path;
+	char *envdir;
+
+	/*
+	 * If a system plugin directory was defined,
+	 * check that first.
+	 */
+#ifdef PLUGIN_DIR
+	load_plugins_dir(pevent, suffix, PLUGIN_DIR, load_plugin, data);
+#endif
+
+	/*
+	 * Next let the environment-set plugin directory
+	 * override the system defaults.
+	 */
+	envdir = getenv("TRACEEVENT_PLUGIN_DIR");
+	if (envdir)
+		load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
+
+	/*
+	 * Now let the home directory override the environment
+	 * or system defaults.
+	 */
+	home = getenv("HOME");
+	if (!home)
+		return;
+
+	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
+
+	strcpy(path, home);
+	strcat(path, "/");
+	strcat(path, LOCAL_PLUGIN_DIR);
+
+	load_plugins_dir(pevent, suffix, path, load_plugin, data);
+
+	free(path);
+}
+
+struct plugin_list*
+traceevent_load_plugins(struct pevent *pevent)
+{
+	struct plugin_list *list = NULL;
+
+	load_plugins(pevent, ".so", load_plugin, &list);
+	return list;
+}
+
+void
+traceevent_unload_plugins(struct plugin_list *plugin_list)
+{
+	pevent_plugin_unload_func func;
+	struct plugin_list *list;
+
+	while (plugin_list) {
+		list = plugin_list;
+		plugin_list = list->next;
+		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
+		if (func)
+			func();
+		dlclose(list->handle);
+		free(list->name);
+		free(list);
+	}
+}
-- 
1.8.3.1

