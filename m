Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaBVSKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:10:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaBVSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:24 -0500
Date: Sat, 22 Feb 2014 09:59:51 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-ee45b6c2c52d4217aae82eb2e8136fa2f8b93303@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to do exit call for symbol maps
Git-Commit-ID: ee45b6c2c52d4217aae82eb2e8136fa2f8b93303
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee45b6c2c52d4217aae82eb2e8136fa2f8b93303
Gitweb:     http://git.kernel.org/tip/ee45b6c2c52d4217aae82eb2e8136fa2f8b93303
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:04 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:50 -0300

perf probe: Fix to do exit call for symbol maps

Some perf-probe commands do symbol_init() but doesn't do exit call.

This fixes that to call symbol_exit() and releases machine if needed.

This also merges init_vmlinux() and init_user_exec() because both of
them are doing similar things.  (init_user_exec() just skips init
vmlinux related symbol maps)

Changes from v2:
 - Not to set symbol_conf.try_vmlinux_path in init_symbol_maps()
   (Thanks to Namhyung Kim!)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 104 +++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d8b048c..9aa7783 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -73,31 +73,31 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
 static int convert_name_to_addr(struct perf_probe_event *pev,
 				const char *exec);
 static void clear_probe_trace_event(struct probe_trace_event *tev);
-static struct machine machine;
+static struct machine *host_machine;
 
 /* Initialize symbol maps and path of vmlinux/modules */
-static int init_vmlinux(void)
+static int init_symbol_maps(bool user_only)
 {
 	int ret;
 
 	symbol_conf.sort_by_name = true;
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
-	else
-		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
 	ret = symbol__init();
 	if (ret < 0) {
 		pr_debug("Failed to init symbol map.\n");
 		goto out;
 	}
 
-	ret = machine__init(&machine, "", HOST_KERNEL_ID);
-	if (ret < 0)
-		goto out;
+	if (host_machine || user_only)	/* already initialized */
+		return 0;
 
-	if (machine__create_kernel_maps(&machine) < 0) {
-		pr_debug("machine__create_kernel_maps() failed.\n");
-		goto out;
+	if (symbol_conf.vmlinux_name)
+		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
+
+	host_machine = machine__new_host();
+	if (!host_machine) {
+		pr_debug("machine__new_host() failed.\n");
+		symbol__exit();
+		ret = -1;
 	}
 out:
 	if (ret < 0)
@@ -105,21 +105,30 @@ out:
 	return ret;
 }
 
+static void exit_symbol_maps(void)
+{
+	if (host_machine) {
+		machine__delete(host_machine);
+		host_machine = NULL;
+	}
+	symbol__exit();
+}
+
 static struct symbol *__find_kernel_function_by_name(const char *name,
 						     struct map **mapp)
 {
-	return machine__find_kernel_function_by_name(&machine, name, mapp,
+	return machine__find_kernel_function_by_name(host_machine, name, mapp,
 						     NULL);
 }
 
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
-	struct map_groups *grp = &machine.kmaps;
+	struct map_groups *grp = &host_machine->kmaps;
 
 	/* A file path -- this is an offline module */
 	if (module && strchr(module, '/'))
-		return machine__new_module(&machine, 0, module);
+		return machine__new_module(host_machine, 0, module);
 
 	if (!module)
 		module = "kernel";
@@ -141,7 +150,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 	const char *vmlinux_name;
 
 	if (module) {
-		list_for_each_entry(dso, &machine.kernel_dsos, node) {
+		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
 			if (strncmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
 				goto found;
@@ -150,7 +159,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 		return NULL;
 	}
 
-	map = machine.vmlinux_maps[MAP__FUNCTION];
+	map = host_machine->vmlinux_maps[MAP__FUNCTION];
 	dso = map->dso;
 
 	vmlinux_name = symbol_conf.vmlinux_name;
@@ -173,20 +182,6 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
-static int init_user_exec(void)
-{
-	int ret = 0;
-
-	symbol_conf.try_vmlinux_path = false;
-	symbol_conf.sort_by_name = true;
-	ret = symbol__init();
-
-	if (ret < 0)
-		pr_debug("Failed to init symbol map.\n");
-
-	return ret;
-}
-
 static int convert_exec_to_group(const char *exec, char **result)
 {
 	char *ptr1, *ptr2, *exec_copy;
@@ -563,7 +558,7 @@ static int _show_one_line(FILE *fp, int l, bool skip, bool show_num)
  * Show line-range always requires debuginfo to find source file and
  * line number.
  */
-int show_line_range(struct line_range *lr, const char *module)
+static int __show_line_range(struct line_range *lr, const char *module)
 {
 	int l = 1;
 	struct line_node *ln;
@@ -573,10 +568,6 @@ int show_line_range(struct line_range *lr, const char *module)
 	char *tmp;
 
 	/* Search a line range */
-	ret = init_vmlinux();
-	if (ret < 0)
-		return ret;
-
 	dinfo = open_debuginfo(module);
 	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
@@ -646,6 +637,19 @@ end:
 	return ret;
 }
 
+int show_line_range(struct line_range *lr, const char *module)
+{
+	int ret;
+
+	ret = init_symbol_maps(false);
+	if (ret < 0)
+		return ret;
+	ret = __show_line_range(lr, module);
+	exit_symbol_maps();
+
+	return ret;
+}
+
 static int show_available_vars_at(struct debuginfo *dinfo,
 				  struct perf_probe_event *pev,
 				  int max_vls, struct strfilter *_filter,
@@ -707,14 +711,15 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	int i, ret = 0;
 	struct debuginfo *dinfo;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
 	dinfo = open_debuginfo(module);
 	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	setup_pager();
@@ -724,6 +729,8 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 					     externs);
 
 	debuginfo__delete(dinfo);
+out:
+	exit_symbol_maps();
 	return ret;
 }
 
@@ -1807,7 +1814,7 @@ int show_perf_probe_events(void)
 	if (fd < 0)
 		return fd;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
@@ -1820,6 +1827,7 @@ int show_perf_probe_events(void)
 		close(fd);
 	}
 
+	exit_symbol_maps();
 	return ret;
 }
 
@@ -2135,12 +2143,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	if (pkgs == NULL)
 		return -ENOMEM;
 
-	if (!pevs->uprobes)
-		/* Init vmlinux path */
-		ret = init_vmlinux();
-	else
-		ret = init_user_exec();
-
+	ret = init_symbol_maps(pevs->uprobes);
 	if (ret < 0) {
 		free(pkgs);
 		return ret;
@@ -2174,6 +2177,7 @@ end:
 		zfree(&pkgs[i].tevs);
 	}
 	free(pkgs);
+	exit_symbol_maps();
 
 	return ret;
 }
@@ -2347,7 +2351,7 @@ static int available_kernel_funcs(const char *module)
 	struct map *map;
 	int ret;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
@@ -2356,7 +2360,10 @@ static int available_kernel_funcs(const char *module)
 		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
 		return -EINVAL;
 	}
-	return __show_available_funcs(map);
+	ret = __show_available_funcs(map);
+	exit_symbol_maps();
+
+	return ret;
 }
 
 static int available_user_funcs(const char *target)
@@ -2364,7 +2371,7 @@ static int available_user_funcs(const char *target)
 	struct map *map;
 	int ret;
 
-	ret = init_user_exec();
+	ret = init_symbol_maps(true);
 	if (ret < 0)
 		return ret;
 
@@ -2372,6 +2379,7 @@ static int available_user_funcs(const char *target)
 	ret = __show_available_funcs(map);
 	dso__delete(map->dso);
 	map__delete(map);
+	exit_symbol_maps();
 	return ret;
 }
 
