Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3LDUQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:16:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3LDUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/38] perf symbols: Retain symbol source file name to lookup source line numbers
Date: Wed,  4 Dec 2013 17:06:27 -0300
Message-Id: <1386187622-2928-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Currently, lookup of an ip's source file name and line number is done
using the dso file name.

Instead retain the file name used to lookup the dso's symbols and use
that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386055390-13757-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 1 +
 tools/perf/util/dso.h     | 1 +
 tools/perf/util/srcline.c | 7 ++++++-
 tools/perf/util/symbol.c  | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 68aa55aa5c17..49da9684f635 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -470,6 +470,7 @@ void dso__delete(struct dso *dso)
 		free(dso->long_name);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
+	free(dso->symsrc_filename);
 	free(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d8613dc3ca8f..7142e5261266 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -78,6 +78,7 @@ struct dso {
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	struct rb_root	 cache;
 	void		 *a2l;
+	char		 *symsrc_filename;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 25b85b28301b..93795f9c2480 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -249,11 +249,16 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	char *file = NULL;
 	unsigned line = 0;
 	char *srcline;
-	char *dso_name = dso->long_name;
+	char *dso_name;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
 
+	if (dso->symsrc_filename)
+		dso_name = dso->symsrc_filename;
+	else
+		dso_name = dso->long_name;
+
 	if (dso_name[0] == '[')
 		goto out;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 360eefecb81d..de87dbac50a0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		if (!syms_ss && symsrc__has_symtab(ss)) {
 			syms_ss = ss;
 			next_slot = true;
+			if (!dso->symsrc_filename)
+				dso->symsrc_filename = strdup(name);
 		}
 
 		if (!runtime_ss && symsrc__possibly_runtime(ss)) {
-- 
1.8.1.4

