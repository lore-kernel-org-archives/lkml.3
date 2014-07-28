Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaG1I1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:27:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaG1I1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:27:08 -0400
Date: Mon, 28 Jul 2014 01:26:05 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2b5b8bb27b9ec899cfba686dabec113ea0d4cbda@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-51-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-51-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dso__type()
Git-Commit-ID: 2b5b8bb27b9ec899cfba686dabec113ea0d4cbda
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

Commit-ID:  2b5b8bb27b9ec899cfba686dabec113ea0d4cbda
Gitweb:     http://git.kernel.org/tip/2b5b8bb27b9ec899cfba686dabec113ea0d4cbda
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:59 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:36:36 -0300

perf tools: Add dso__type()

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
index af1c256..5e463c0 100644
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
index 61b9cd4..d753499 100644
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
index ee2d3cc..e7295e9 100644
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
