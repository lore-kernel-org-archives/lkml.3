Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307AbaGQQOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:52401 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933412AbaGQQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:03 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/33] perf symbols: Record whether a dso is 64-bit
Date: Thu, 17 Jul 2014 13:12:18 -0300
Message-Id: <1405613555-23380-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a flag to 'struct dso' to record if the dso is 64-bit or not.
Update the flag when reading the ELF.

This is needed for instruction decoding.  For example, x86 instruction
decoding depends on whether or not the 64-bit instruction set is used.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-18-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c            |  1 +
 tools/perf/util/dso.h            |  1 +
 tools/perf/util/symbol-elf.c     |  3 +++
 tools/perf/util/symbol-minimal.c | 22 ++++++++++++++++++++++
 tools/perf/util/symbol.c         |  1 +
 tools/perf/util/symbol.h         |  1 +
 6 files changed, 29 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 819f10414f08..fc006fed8877 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -703,6 +703,7 @@ struct dso *dso__new(const char *name)
 		dso->data.fd = -1;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->is_64_bit = (sizeof(void *) == 8);
 		dso->loaded = 0;
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ad553ba257bf..c239e86541a3 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -90,6 +90,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 short_name_allocated:1;
 	u8		 long_name_allocated:1;
+	u8		 is_64_bit:1;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 rel;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index dce5ccf61f11..cef8f426356e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -599,6 +599,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 			goto out_elf_end;
 	}
 
+	ss->is_64_bit = (gelf_getclass(elf) == ELFCLASS64);
+
 	ss->symtab = elf_section_by_name(elf, &ehdr, &ss->symshdr, ".symtab",
 			NULL);
 	if (ss->symshdr.sh_type != SHT_SYMTAB)
@@ -699,6 +701,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
+	dso->is_64_bit = syms_ss->is_64_bit;
 	dso->rel = syms_ss->ehdr.e_type == ET_REL;
 
 	/*
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index bd15f490d04f..101f55d407d0 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -288,6 +288,23 @@ int dso__synthesize_plt_symbols(struct dso *dso __maybe_unused,
 	return 0;
 }
 
+static int fd__is_64_bit(int fd)
+{
+	u8 e_ident[EI_NIDENT];
+
+	if (lseek(fd, 0, SEEK_SET))
+		return -1;
+
+	if (readn(fd, e_ident, sizeof(e_ident)) != sizeof(e_ident))
+		return -1;
+
+	if (memcmp(e_ident, ELFMAG, SELFMAG) ||
+	    e_ident[EI_VERSION] != EV_CURRENT)
+		return -1;
+
+	return e_ident[EI_CLASS] == ELFCLASS64;
+}
+
 int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 		  struct symsrc *ss,
 		  struct symsrc *runtime_ss __maybe_unused,
@@ -295,6 +312,11 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 		  int kmodule __maybe_unused)
 {
 	unsigned char *build_id[BUILD_ID_SIZE];
+	int ret;
+
+	ret = fd__is_64_bit(ss->fd);
+	if (ret >= 0)
+		dso->is_64_bit = ret;
 
 	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2e6a2e219eb9..ae2e4464afa7 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1065,6 +1065,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 			      &is_64_bit);
 	if (err)
 		goto out_err;
+	dso->is_64_bit = is_64_bit;
 
 	if (list_empty(&md.maps)) {
 		err = -EINVAL;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index a81877b1dee0..436169dd1d84 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -216,6 +216,7 @@ struct symsrc {
 	GElf_Shdr dynshdr;
 
 	bool adjust_symbols;
+	bool is_64_bit;
 #endif
 };
 
-- 
1.9.3

