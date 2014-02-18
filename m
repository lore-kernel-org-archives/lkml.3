Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBRVQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:16:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBRVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/32] perf probe: Unify show_available_functions for uprobes/kprobes
Date: Tue, 18 Feb 2014 18:08:44 -0300
Message-Id: <1392757731-32619-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Unify show_available_functions for uprobes/kprobes to cleanup and reduce
the code. This also improves error messages.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053211.29635.20563.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 72 ++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f70fd08f00b7..ace3ba37c880 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2323,66 +2323,46 @@ static int filter_available_functions(struct map *map __maybe_unused,
 	return 1;
 }
 
-static int __show_available_funcs(struct map *map)
-{
-	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
-		return -EINVAL;
-	}
-	if (!dso__sorted_by_name(map->dso, map->type))
-		dso__sort_by_name(map->dso, map->type);
-
-	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
-	return 0;
-}
-
-static int available_kernel_funcs(const char *module)
+int show_available_funcs(const char *target, struct strfilter *_filter,
+					bool user)
 {
 	struct map *map;
 	int ret;
 
-	ret = init_symbol_maps(false);
+	ret = init_symbol_maps(user);
 	if (ret < 0)
 		return ret;
 
-	map = kernel_get_module_map(module);
+	/* Get a symbol map */
+	if (user)
+		map = dso__new_map(target);
+	else
+		map = kernel_get_module_map(target);
 	if (!map) {
-		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
+		pr_err("Failed to get a map for %s\n", (target) ? : "kernel");
 		return -EINVAL;
 	}
-	ret = __show_available_funcs(map);
-	exit_symbol_maps();
-
-	return ret;
-}
-
-static int available_user_funcs(const char *target)
-{
-	struct map *map;
-	int ret;
 
-	ret = init_symbol_maps(true);
-	if (ret < 0)
-		return ret;
-
-	map = dso__new_map(target);
-	ret = __show_available_funcs(map);
-	dso__delete(map->dso);
-	map__delete(map);
-	exit_symbol_maps();
-	return ret;
-}
-
-int show_available_funcs(const char *target, struct strfilter *_filter,
-					bool user)
-{
-	setup_pager();
+	/* Load symbols with given filter */
 	available_func_filter = _filter;
+	if (map__load(map, filter_available_functions)) {
+		pr_err("Failed to load symbols in %s\n", (target) ? : "kernel");
+		goto end;
+	}
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
 
-	if (!user)
-		return available_kernel_funcs(target);
+	/* Show all (filtered) symbols */
+	setup_pager();
+	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
+end:
+	if (user) {
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+	exit_symbol_maps();
 
-	return available_user_funcs(target);
+	return ret;
 }
 
 /*
-- 
1.8.1.4

