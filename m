Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3LJUd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:33:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34317 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3LJUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 28/34] perf symbols: Constify dso->long_name
Date: Tue, 10 Dec 2013 17:31:10 -0300
Message-Id: <1386707476-12370-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Same reason as for dso->short_name, it may point to a const string, and
in most places it is treated as const, i.e. it is just accessed for
using its contents as a key or to show it on reports.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nf7mxf33zt5qw207pbxxryot@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |  2 +-
 tools/perf/util/dso.c      | 10 +++++-----
 tools/perf/util/dso.h      |  4 ++--
 tools/perf/util/header.c   |  6 +++---
 tools/perf/util/srcline.c  |  2 +-
 tools/perf/util/symbol.c   |  4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index cf6242c92ee2..0fcd81ea31ae 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -900,7 +900,7 @@ fallback:
 		 * cache, or is just a kallsyms file, well, lets hope that this
 		 * DSO is the same as when 'perf record' ran.
 		 */
-		filename = dso->long_name;
+		filename = (char *)dso->long_name;
 		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
 			 symbol_conf.symfs, filename);
 		free_filename = false;
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index ecb37d62f814..2c7e1899a735 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -67,7 +67,7 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 
 	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
 	{
-		char *last_slash;
+		const char *last_slash;
 		size_t len;
 		size_t dir_size;
 
@@ -386,13 +386,13 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
-void dso__set_long_name(struct dso *dso, char *name, bool name_allocated)
+void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
 
 	if (dso->long_name_allocated)
-		free(dso->long_name);
+		free((char *)dso->long_name);
 
 	dso->long_name		 = name;
 	dso->long_name_len	 = strlen(name);
@@ -414,7 +414,7 @@ void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
 
 static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(dso, basename(dso->long_name), false);
+	dso__set_short_name(dso, basename((char *)dso->long_name), false);
 }
 
 int dso__name_len(const struct dso *dso)
@@ -478,7 +478,7 @@ void dso__delete(struct dso *dso)
 	if (dso->short_name_allocated)
 		free((char *)dso->short_name);
 	if (dso->long_name_allocated)
-		free(dso->long_name);
+		free((char *)dso->long_name);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
 	free(dso->symsrc_filename);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 7b434691525a..a2d71292f746 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -96,7 +96,7 @@ struct dso {
 	u8		 rel;
 	u8		 build_id[BUILD_ID_SIZE];
 	const char	 *short_name;
-	char		 *long_name;
+	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
 	char		 name[0];
@@ -111,7 +111,7 @@ struct dso *dso__new(const char *name);
 void dso__delete(struct dso *dso);
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated);
-void dso__set_long_name(struct dso *dso, char *name, bool name_allocated);
+void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated);
 
 int dso__name_len(const struct dso *dso);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 125cdc9250ee..0bb830f6b49c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -177,7 +177,7 @@ perf_header__set_cmdline(int argc, const char **argv)
 			continue;		\
 		else
 
-static int write_buildid(char *name, size_t name_len, u8 *build_id,
+static int write_buildid(const char *name, size_t name_len, u8 *build_id,
 			 pid_t pid, u16 misc, int fd)
 {
 	int err;
@@ -209,7 +209,7 @@ static int __dsos__write_buildid_table(struct list_head *head,
 
 	dsos__for_each_with_build_id(pos, head) {
 		int err;
-		char  *name;
+		const char *name;
 		size_t name_len;
 
 		if (!pos->hit)
@@ -387,7 +387,7 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
 	bool is_vdso = is_vdso_map(dso->short_name);
-	char *name = dso->long_name;
+	const char *name = dso->long_name;
 	char nm[PATH_MAX];
 
 	if (dso__is_kcore(dso)) {
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 0c075560ad46..58b2bd8f38c9 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -255,7 +255,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	char *file = NULL;
 	unsigned line = 0;
 	char *srcline;
-	char *dso_name;
+	const char *dso_name;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5029ee1a9421..e377c2e96191 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1438,7 +1438,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 			dso->data_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 		else
 			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
-		dso__set_long_name(dso, (char *)vmlinux, vmlinux_allocated);
+		dso__set_long_name(dso, vmlinux, vmlinux_allocated);
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 	}
@@ -1630,7 +1630,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
-		dso__set_long_name(dso, strdup("[kernel.kallsyms]"), true);
+		dso__set_long_name(dso, "[kernel.kallsyms]", false);
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
-- 
1.8.1.4

