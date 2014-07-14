Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaGNKFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:41894 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaGNKF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434311"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/41] perf tools: Record whether a dso is 64-bit
Date: Mon, 14 Jul 2014 13:02:41 +0300
Message-Id: <1405332185-4050-18-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag to 'struct dso' to record if the dso is 64-bit
or not.  Update the flag when reading the ELF.

This is needed for instruction decoding.  For
example, x86 instruction decoding depends on
whether or not the 64-bit instruction set is
used.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c            |  1 +
 tools/perf/util/dso.h            |  1 +
 tools/perf/util/symbol-elf.c     |  3 +++
 tools/perf/util/symbol-minimal.c | 22 ++++++++++++++++++++++
 tools/perf/util/symbol.c         |  1 +
 tools/perf/util/symbol.h         |  1 +
 6 files changed, 29 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 819f104..fc006fe 100644
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
index ad553ba..c239e86 100644
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
index 477596c..84f5e2a 100644
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
index bd15f49..101f55d 100644
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
index 7b9096f..be7b0df 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1064,6 +1064,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 			      &is_64_bit);
 	if (err)
 		goto out_err;
+	dso->is_64_bit = is_64_bit;
 
 	if (list_empty(&md.maps)) {
 		err = -EINVAL;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..6ba8a22 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -215,6 +215,7 @@ struct symsrc {
 	GElf_Shdr dynshdr;
 
 	bool adjust_symbols;
+	bool is_64_bit;
 #endif
 };
 
-- 
1.8.3.2

