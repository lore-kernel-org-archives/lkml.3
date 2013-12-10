Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3LJUd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:33:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34307 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3LJUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:37 -0500
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
Subject: [PATCH 27/34] perf symbols: Remove open coded management of  long_name_allocated member
Date: Tue, 10 Dec 2013 17:31:09 -0300
Message-Id: <1386707476-12370-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of expecting callers to set this member accodingly so that later
at dso destruction it can, if needed, be correctly free()d, make it a
requirement by passing it as a parameter to dso__set_long_name.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-na7t1tqim22vuqkt4zq5n4ri@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 13 +++++++++----
 tools/perf/util/dso.h     |  2 +-
 tools/perf/util/machine.c |  3 +--
 tools/perf/util/symbol.c  |  9 ++++-----
 tools/perf/util/vdso.c    |  2 +-
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index f8c849767c4d..ecb37d62f814 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -386,12 +386,17 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
-void dso__set_long_name(struct dso *dso, char *name)
+void dso__set_long_name(struct dso *dso, char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
-	dso->long_name = name;
-	dso->long_name_len = strlen(name);
+
+	if (dso->long_name_allocated)
+		free(dso->long_name);
+
+	dso->long_name		 = name;
+	dso->long_name_len	 = strlen(name);
+	dso->long_name_allocated = name_allocated;
 }
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
@@ -444,7 +449,7 @@ struct dso *dso__new(const char *name)
 	if (dso != NULL) {
 		int i;
 		strcpy(dso->name, name);
-		dso__set_long_name(dso, dso->name);
+		dso__set_long_name(dso, dso->name, false);
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 8eceab78088f..7b434691525a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -111,7 +111,7 @@ struct dso *dso__new(const char *name);
 void dso__delete(struct dso *dso);
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated);
-void dso__set_long_name(struct dso *dso, char *name);
+void dso__set_long_name(struct dso *dso, char *name, bool name_allocated);
 
 int dso__name_len(const struct dso *dso);
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 09d5c66d4087..751454bcde69 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -763,8 +763,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				ret = -1;
 				goto out;
 			}
-			dso__set_long_name(map->dso, long_name);
-			map->dso->long_name_allocated = 1;
+			dso__set_long_name(map->dso, long_name, true);
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9a5de8837d6d..5029ee1a9421 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1159,7 +1159,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 		dso->data_type = DSO_BINARY_TYPE__GUEST_KCORE;
 	else
 		dso->data_type = DSO_BINARY_TYPE__KCORE;
-	dso__set_long_name(dso, strdup(kcore_filename));
+	dso__set_long_name(dso, strdup(kcore_filename), true);
 
 	close(fd);
 
@@ -1438,8 +1438,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 			dso->data_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 		else
 			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
-		dso__set_long_name(dso, (char *)vmlinux);
-		dso->long_name_allocated = vmlinux_allocated;
+		dso__set_long_name(dso, (char *)vmlinux, vmlinux_allocated);
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 	}
@@ -1631,7 +1630,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
-		dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
+		dso__set_long_name(dso, strdup("[kernel.kallsyms]"), true);
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1679,7 +1678,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	if (err > 0 && !dso__is_kcore(dso)) {
 		machine__mmap_name(machine, path, sizeof(path));
-		dso__set_long_name(dso, strdup(path));
+		dso__set_long_name(dso, strdup(path), true);
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 39159822d58f..0ddb3b8a89ec 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -103,7 +103,7 @@ struct dso *vdso__dso_findnew(struct list_head *head)
 		dso = dso__new(VDSO__MAP_NAME);
 		if (dso != NULL) {
 			dsos__add(head, dso);
-			dso__set_long_name(dso, file);
+			dso__set_long_name(dso, file, false);
 		}
 	}
 
-- 
1.8.1.4

