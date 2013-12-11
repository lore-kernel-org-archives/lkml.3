Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3LKM4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:56:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:32364 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab3LKMiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448279746"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
Date: Wed, 11 Dec 2013 14:36:19 +0200
Message-Id: <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
 tools/perf/util/symbol-minimal.c | 23 +++++++++++++++++++++++
 tools/perf/util/symbol.c         |  1 +
 tools/perf/util/symbol.h         |  1 +
 6 files changed, 30 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index a0c7c59..80817ec 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -446,6 +446,7 @@ struct dso *dso__new(const char *name)
 		dso->cache = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->is_64_bit = (sizeof(void *) == 8);
 		dso->loaded = 0;
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 384f2d9..62680e1 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -91,6 +91,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
 	u8		 lname_alloc:1;
+	u8		 is_64_bit:1;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 rel;
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index eed0b96..a0fc81b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -595,6 +595,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 			goto out_elf_end;
 	}
 
+	ss->is_64_bit = (gelf_getclass(elf) == ELFCLASS64);
+
 	ss->symtab = elf_section_by_name(elf, &ehdr, &ss->symshdr, ".symtab",
 			NULL);
 	if (ss->symshdr.sh_type != SHT_SYMTAB)
@@ -694,6 +696,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
+	dso->is_64_bit = syms_ss->is_64_bit;
 	dso->rel = syms_ss->ehdr.e_type == ET_REL;
 
 	/*
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index ac7070a..b9d1119 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,3 +1,4 @@
+#include "util.h"
 #include "symbol.h"
 
 #include <stdio.h>
@@ -287,6 +288,23 @@ int dso__synthesize_plt_symbols(struct dso *dso __maybe_unused,
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
@@ -294,6 +312,11 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
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
index de87dba..511de06 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1103,6 +1103,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 			      &is_64_bit);
 	if (err)
 		goto out_err;
+	dso->is_64_bit = is_64_bit;
 
 	if (list_empty(&md.maps)) {
 		err = -EINVAL;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f1031a1..7f23a05 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -195,6 +195,7 @@ struct symsrc {
 	GElf_Shdr dynshdr;
 
 	bool adjust_symbols;
+	bool is_64_bit;
 #endif
 };
 
-- 
1.8.5.1

