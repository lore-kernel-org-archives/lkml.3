Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3LKLIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:08:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3LKLI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:29 -0500
Date: Wed, 11 Dec 2013 03:07:49 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-nf7mxf33zt5qw207pbxxryot@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Constify dso->long_name
Git-Commit-ID: bf4414ae7b86cddca60a5b510954a37d30583a1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf4414ae7b86cddca60a5b510954a37d30583a1f
Gitweb:     http://git.kernel.org/tip/bf4414ae7b86cddca60a5b510954a37d30583a1f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Dec 2013 15:19:23 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:09 -0300

perf symbols: Constify dso->long_name

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
index cf6242c..0fcd81e 100644
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
index ecb37d6..2c7e189 100644
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
index 7b43469..a2d7129 100644
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
index 125cdc9..0bb830f 100644
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
index 0c07556..58b2bd8 100644
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
index 5029ee1..e377c2e 100644
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
