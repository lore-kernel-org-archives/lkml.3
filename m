Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbaGREZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:25:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaGREZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:25:54 -0400
Date: Thu, 17 Jul 2014 21:24:59 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c6d8f2a4a0c5e366330a6a2a94c06b652f4ca554@git.kernel.org>
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
In-Reply-To: <1405332185-4050-18-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-18-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Record whether a dso is 64-bit
Git-Commit-ID: c6d8f2a4a0c5e366330a6a2a94c06b652f4ca554
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

Commit-ID:  c6d8f2a4a0c5e366330a6a2a94c06b652f4ca554
Gitweb:     http://git.kernel.org/tip/c6d8f2a4a0c5e366330a6a2a94c06b652f4ca554
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:41 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:35 -0300

perf symbols: Record whether a dso is 64-bit

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
index dce5ccf..cef8f42 100644
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
index 2e6a2e2..ae2e446 100644
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
index a81877b..436169d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -216,6 +216,7 @@ struct symsrc {
 	GElf_Shdr dynshdr;
 
 	bool adjust_symbols;
+	bool is_64_bit;
 #endif
 };
 
