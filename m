Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBVSAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:00:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaBVSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:43 -0500
Date: Sat, 22 Feb 2014 10:00:24 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-2df58634cd2ad33d7c7ca2e02e1a44db6c8cf68d@git.kernel.org>
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
In-Reply-To: <20140206053211.29635.20563.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053211.29635.20563.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Unify show_available_functions for uprobes/kprobes
Git-Commit-ID: 2df58634cd2ad33d7c7ca2e02e1a44db6c8cf68d
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

Commit-ID:  2df58634cd2ad33d7c7ca2e02e1a44db6c8cf68d
Gitweb:     http://git.kernel.org/tip/2df58634cd2ad33d7c7ca2e02e1a44db6c8cf68d
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:11 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:50 -0300

perf probe: Unify show_available_functions for uprobes/kprobes

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
