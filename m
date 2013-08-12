Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3HLKWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3HLKWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:03 -0400
Date: Mon, 12 Aug 2013 03:21:21 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-0131c4ec794a7409eafff0c79105309540aaca4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-7-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make it possible to read object code from kernel modules
Git-Commit-ID: 0131c4ec794a7409eafff0c79105309540aaca4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:21:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0131c4ec794a7409eafff0c79105309540aaca4d
Gitweb:     http://git.kernel.org/tip/0131c4ec794a7409eafff0c79105309540aaca4d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:50 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:32 -0300

perf tools: Make it possible to read object code from kernel modules

The new "object code reading" test shows that it is not possible to read
object code from kernel modules.  That is because the mappings do not
map to the dsos.  This patch fixes that.

This involves identifying and flagging relocatable (ELF type ET_REL)
files (e.g. kernel modules) for symbol adjustment and updating
map__rip_2objdump() accordingly.  The kmodule parameter of
dso__load_sym() is taken into use and the module map altered to map to
the dso.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c        |  1 +
 tools/perf/util/dso.h        |  1 +
 tools/perf/util/map.c        | 14 +++++++++-----
 tools/perf/util/symbol-elf.c | 25 ++++++++++++++++++++++++-
 tools/perf/util/symbol.c     | 11 ++++++++---
 5 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 121583d..1955804 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -419,6 +419,7 @@ struct dso *dso__new(const char *name)
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
+		dso->rel = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
 		dso->kernel = DSO_TYPE_USER;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 02aadaf..735a837 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -85,6 +85,7 @@ struct dso {
 	u8		 lname_alloc:1;
 	u8		 sorted_by_name;
 	u8		 loaded;
+	u8		 rel;
 	u8		 build_id[BUILD_ID_SIZE];
 	const char	 *short_name;
 	char		 *long_name;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 5f662a3..4d599fe 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -248,14 +248,18 @@ size_t map__fprintf_dsoname(struct map *map, FILE *fp)
 
 /*
  * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
- * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
+ * map->dso->adjust_symbols==1 for ET_EXEC-like cases except ET_REL which is
+ * relative to section start.
  */
 u64 map__rip_2objdump(struct map *map, u64 rip)
 {
-	u64 addr = map->dso->adjust_symbols ?
-			map->unmap_ip(map, rip) :	/* RIP -> IP */
-			rip;
-	return addr;
+	if (!map->dso->adjust_symbols)
+		return rip;
+
+	if (map->dso->rel)
+		return rip - map->pgoff;
+
+	return map->unmap_ip(map, rip);
 }
 
 void map_groups__init(struct map_groups *mg)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ed6f443..3eaa7b4 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -599,11 +599,13 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 	if (dso->kernel == DSO_TYPE_USER) {
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				ehdr.e_type == ET_REL ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
 	} else {
-		ss->adjust_symbols = ehdr.e_type == ET_EXEC;
+		ss->adjust_symbols = ehdr.e_type == ET_EXEC ||
+				     ehdr.e_type == ET_REL;
 	}
 
 	ss->name   = strdup(name);
@@ -676,6 +678,14 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
+	dso->rel = syms_ss->ehdr.e_type == ET_REL;
+
+	/*
+	 * Modules may already have symbols from kallsyms, but those symbols
+	 * have the wrong values for the dso maps, so remove them.
+	 */
+	if (kmodule && syms_ss->symtab)
+		symbols__delete(&dso->symbols[map->type]);
 
 	if (!syms_ss->symtab) {
 		syms_ss->symtab  = syms_ss->dynsym;
@@ -828,11 +838,24 @@ int dso__load_sym(struct dso *dso, struct map *map,
 					map_groups__insert(kmap->kmaps, map);
 				}
 
+				/*
+				 * The initial module mapping is based on
+				 * /proc/modules mapped to offset zero.
+				 * Overwrite it to map to the module dso.
+				 */
+				if (remap_kernel && kmodule) {
+					remap_kernel = false;
+					map->pgoff = shdr.sh_offset;
+				}
+
 				curr_map = map;
 				curr_dso = dso;
 				goto new_symbol;
 			}
 
+			if (!kmap)
+				goto new_symbol;
+
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", dso->short_name, section_name);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 04300dd..b9056a8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -854,10 +854,15 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (!runtime_ss && syms_ss)
 		runtime_ss = syms_ss;
 
-	if (syms_ss)
-		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, 0);
-	else
+	if (syms_ss) {
+		int km;
+
+		km = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
+		     dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
+		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, km);
+	} else {
 		ret = -1;
+	}
 
 	if (ret > 0) {
 		int nr_plt;
