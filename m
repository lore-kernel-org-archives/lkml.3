Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3LRKen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:34:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3LRKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:34:25 -0500
Date: Wed, 18 Dec 2013 02:33:45 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2lkbqrn23uc2uvnn9w9in379@git.kernel.org>
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
Subject: [tip:perf/core] perf symbols:
  Use consistent name for the DSO binary type member
Git-Commit-ID: 5f70619d67b99310be9aaf850293b7fd7f31d160
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f70619d67b99310be9aaf850293b7fd7f31d160
Gitweb:     http://git.kernel.org/tip/5f70619d67b99310be9aaf850293b7fd7f31d160
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 17 Dec 2013 16:14:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 17 Dec 2013 16:34:08 -0300

perf symbols: Use consistent name for the DSO binary type member

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
index eef1662..4ddeecb 100644
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
index aa33847..cd7d6f0 100644
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
index 9ee4b80..923d000 100644
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
