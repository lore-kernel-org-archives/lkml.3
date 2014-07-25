Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbaGYPij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:35158 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221AbaGYPig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:36 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/27] perf tools: Add dso__type()
Date: Fri, 25 Jul 2014 12:37:01 -0300
Message-Id: <1406302629-11790-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

dso__type() determines wheather a dso is 32-bit, x32 (32-bit with 64-bit
registers) or 64-bit.

dso__type() will be used to determine the VDSO a program maps.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-51-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c            | 11 +++++++++++
 tools/perf/util/dso.h            | 10 ++++++++++
 tools/perf/util/symbol-elf.c     | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c | 21 +++++++++++++++++++++
 tools/perf/util/symbol.h         |  2 ++
 5 files changed, 77 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e657d86e82b9..90d02c661dd4 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -940,3 +940,14 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 
 	return ret;
 }
+
+enum dso_type dso__type(struct dso *dso, struct machine *machine)
+{
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return DSO__TYPE_UNKNOWN;
+
+	return dso__type_fd(fd);
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index af1c256aad4f..5e463c0964d4 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -5,6 +5,7 @@
 #include <linux/rbtree.h>
 #include <stdbool.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include "map.h"
 #include "build-id.h"
 
@@ -50,6 +51,13 @@ enum dso_data_status_seen {
 	DSO_DATA_STATUS_SEEN_ITRACE,
 };
 
+enum dso_type {
+	DSO__TYPE_UNKNOWN,
+	DSO__TYPE_64BIT,
+	DSO__TYPE_32BIT,
+	DSO__TYPE_X32BIT,
+};
+
 #define DSO__SWAP(dso, type, val)			\
 ({							\
 	type ____r = val;				\
@@ -245,4 +253,6 @@ static inline bool dso__is_kcore(struct dso *dso)
 
 void dso__free_a2l(struct dso *dso);
 
+enum dso_type dso__type(struct dso *dso, struct machine *machine);
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 61b9cd456310..d75349979e65 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1028,6 +1028,39 @@ int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
 	return err;
 }
 
+enum dso_type dso__type_fd(int fd)
+{
+	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
+	GElf_Ehdr ehdr;
+	Elf_Kind ek;
+	Elf *elf;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		goto out;
+
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out_end;
+
+	if (gelf_getclass(elf) == ELFCLASS64) {
+		dso_type = DSO__TYPE_64BIT;
+		goto out_end;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out_end;
+
+	if (ehdr.e_machine == EM_X86_64)
+		dso_type = DSO__TYPE_X32BIT;
+	else
+		dso_type = DSO__TYPE_32BIT;
+out_end:
+	elf_end(elf);
+out:
+	return dso_type;
+}
+
 static int copy_bytes(int from, off_t from_offs, int to, off_t to_offs, u64 len)
 {
 	ssize_t r;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 101f55d407d0..c9541fea9514 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -305,6 +305,27 @@ static int fd__is_64_bit(int fd)
 	return e_ident[EI_CLASS] == ELFCLASS64;
 }
 
+enum dso_type dso__type_fd(int fd)
+{
+	Elf64_Ehdr ehdr;
+	int ret;
+
+	ret = fd__is_64_bit(fd);
+	if (ret < 0)
+		return DSO__TYPE_UNKNOWN;
+
+	if (ret)
+		return DSO__TYPE_64BIT;
+
+	if (readn(fd, &ehdr, sizeof(ehdr)) != sizeof(ehdr))
+		return DSO__TYPE_UNKNOWN;
+
+	if (ehdr.e_machine == EM_X86_64)
+		return DSO__TYPE_X32BIT;
+
+	return DSO__TYPE_32BIT;
+}
+
 int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 		  struct symsrc *ss,
 		  struct symsrc *runtime_ss __maybe_unused,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ee2d3ccd3ad1..e7295e93cff9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -243,6 +243,8 @@ struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 struct symbol *dso__next_symbol(struct symbol *sym);
 
+enum dso_type dso__type_fd(int fd);
+
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
-- 
1.9.3

