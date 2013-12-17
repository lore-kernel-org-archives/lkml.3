Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3LQUy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:54:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56162 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3LQUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:23 -0500
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
Subject: [PATCH 09/10] perf symbols: Use consistent name for the DSO binary type member
Date: Tue, 17 Dec 2013 17:52:10 -0300
Message-Id: <1387313531-14629-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was called "data_type", but in this context "data" is way too vague,
it could mean the "data" ELF segment, or something else.

Since we have dso__read_binary_type_filename() and the values this field
receives are all DSO__BINARY_TYPE_<FOO> we may as well call it
"binary_type" for consistency sake.

It also seems more appropriate since it determines if we can do
operations like annotation and DWARF unwinding, that needs more than
just the symtab, requiring access to ELF text segments, CFI ELF
sections, etc.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2lkbqrn23uc2uvnn9w9in379@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c    | 10 +++++-----
 tools/perf/util/dso.h    | 10 +++++-----
 tools/perf/util/symbol.c |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index eef166212324..4ddeecb9ff85 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -148,7 +148,7 @@ static int open_dso(struct dso *dso, struct machine *machine)
 	if (machine)
 		root_dir = machine->root_dir;
 
-	if (dso__read_binary_type_filename(dso, dso->data_type,
+	if (dso__read_binary_type_filename(dso, dso->binary_type,
 					    root_dir, name, PATH_MAX)) {
 		free(name);
 		return -EINVAL;
@@ -168,19 +168,19 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
-	if (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND)
+	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
 		return open_dso(dso, machine);
 
 	do {
 		int fd;
 
-		dso->data_type = binary_type_data[i++];
+		dso->binary_type = binary_type_data[i++];
 
 		fd = open_dso(dso, machine);
 		if (fd >= 0)
 			return fd;
 
-	} while (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND);
+	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
 
 	return -EINVAL;
 }
@@ -475,7 +475,7 @@ struct dso *dso__new(const char *name)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->cache = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
-		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index aa3384745d75..cd7d6f078cdd 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -83,7 +83,7 @@ struct dso {
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
-	enum dso_binary_type	data_type;
+	enum dso_binary_type	binary_type;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
 	u8		 has_srcline:1;
@@ -159,14 +159,14 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
 
 static inline bool dso__is_vmlinux(struct dso *dso)
 {
-	return dso->data_type == DSO_BINARY_TYPE__VMLINUX ||
-	       dso->data_type == DSO_BINARY_TYPE__GUEST_VMLINUX;
+	return dso->binary_type == DSO_BINARY_TYPE__VMLINUX ||
+	       dso->binary_type == DSO_BINARY_TYPE__GUEST_VMLINUX;
 }
 
 static inline bool dso__is_kcore(struct dso *dso)
 {
-	return dso->data_type == DSO_BINARY_TYPE__KCORE ||
-	       dso->data_type == DSO_BINARY_TYPE__GUEST_KCORE;
+	return dso->binary_type == DSO_BINARY_TYPE__KCORE ||
+	       dso->binary_type == DSO_BINARY_TYPE__GUEST_KCORE;
 }
 
 void dso__free_a2l(struct dso *dso);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9ee4b80dac57..923d00040bbf 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1089,9 +1089,9 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 	 * dso__data_read_addr().
 	 */
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
-		dso->data_type = DSO_BINARY_TYPE__GUEST_KCORE;
+		dso->binary_type = DSO_BINARY_TYPE__GUEST_KCORE;
 	else
-		dso->data_type = DSO_BINARY_TYPE__KCORE;
+		dso->binary_type = DSO_BINARY_TYPE__KCORE;
 	dso__set_long_name(dso, strdup(kcore_filename), true);
 
 	close(fd);
@@ -1368,9 +1368,9 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 
 	if (err > 0) {
 		if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
-			dso->data_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
+			dso->binary_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 		else
-			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
+			dso->binary_type = DSO_BINARY_TYPE__VMLINUX;
 		dso__set_long_name(dso, vmlinux, vmlinux_allocated);
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
-- 
1.8.1.4

