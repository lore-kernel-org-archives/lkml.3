Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaGVNVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:21:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:28140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbaGVNVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576986396"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 50/52] perf tools: Add dso__type()
Date: Tue, 22 Jul 2014 16:17:59 +0300
Message-Id: <1406035081-14301-51-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dso__type() determines wheather a dso is 32-bit,
x32 (32-bit with 64-bit registers) or 64-bit.
dso__type() will be used to determine the VDSO
a program maps.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c            | 11 +++++++++++
 tools/perf/util/dso.h            | 10 ++++++++++
 tools/perf/util/symbol-elf.c     | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c | 21 +++++++++++++++++++++
 tools/perf/util/symbol.h         |  2 ++
 5 files changed, 77 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e657d86..90d02c66 100644
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
index d03720b..1c72a33 100644
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
@@ -246,4 +254,6 @@ static inline bool dso__is_kcore(struct dso *dso)
 
 void dso__free_a2l(struct dso *dso);
 
+enum dso_type dso__type(struct dso *dso, struct machine *machine);
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 0387780..ec0b8ea 100644
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
index 101f55d..c9541fe 100644
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
index 31e5400..51fb26b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -244,6 +244,8 @@ struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 struct symbol *dso__next_symbol(struct symbol *sym);
 
+enum dso_type dso__type_fd(int fd);
+
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
-- 
1.8.3.2

