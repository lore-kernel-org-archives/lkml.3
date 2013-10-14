Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3JNUfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:35:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38836 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3JNUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 089/161] perf symbols: Add new option --ignore-vmlinux for perf top
Date: Mon, 14 Oct 2013 17:01:18 -0300
Message-Id: <1381780950-25642-90-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

Running "perf top" on a machine with possibly invalid or non-matching
vmlinux at the various places results in no symbol resolving despite
/proc/kallsyms being present and valid.

Add a new option --ignore-vmlinux to explicitly indicate that we do not
want to use these kernels and just use what we have (kallsyms).

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/20130914083259.GA3418@1wt.eu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 2 ++
 tools/perf/util/symbol.c | 4 ++--
 tools/perf/util/symbol.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8466956adbe..65c49b2f51c1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1073,6 +1073,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_BOOLEAN(0, "ignore-vmlinux", &symbol_conf.ignore_vmlinux,
+		    "don't load vmlinux even if found"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
 	OPT_CALLBACK('m', "mmap-pages", &opts->mmap_pages, "pages",
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cd1dcc45049b..48c38791d61b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1215,7 +1215,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		goto do_kallsyms;
 	}
 
-	if (symbol_conf.vmlinux_name != NULL) {
+	if (!symbol_conf.ignore_vmlinux && symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(dso, map,
 					symbol_conf.vmlinux_name, filter);
 		if (err > 0) {
@@ -1227,7 +1227,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		return err;
 	}
 
-	if (vmlinux_path != NULL) {
+	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
 		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
 			return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2a97bb1a8097..9b8b213a62c1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -85,6 +85,7 @@ struct symbol_conf {
 	unsigned short	priv_size;
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
+			ignore_vmlinux,
 			show_kernel_path,
 			use_modules,
 			sort_by_name,
-- 
1.8.1.4

