Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaBFFcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:32:19 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44302 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaBFFcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:32:14 -0500
Subject: [PATCH -tip v3 04/11] [CLEANUP] perf-probe: Unify
 show_available_functions for uprobes/kprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 06 Feb 2014 05:32:11 +0000
Message-ID: <20140206053211.29635.20563.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify show_available_functions for uprobes/kprobes to cleanup
and reduce the code. This also improves error messages.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |   72 +++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f70fd08..ace3ba3 100644
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


