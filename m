Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3HBKF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:05:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:52042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab3HBKFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,800,1367996400"; 
   d="scan'208";a="380030469"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 06/10] perf tools: make it possible to read object code from kernel modules
Date: Fri,  2 Aug 2013 13:10:48 +0300
Message-Id: <1375438252-24776-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
References: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new "object code reading" test shows that it is not possible
to read object code from kernel modules.  That is because the mappings
do not map to the dsos.  This patch fixes that.

This involves identifying and flagging relocatable (ELF type ET_REL) files
(e.g. kernel modules) for symbol adjustment and updating map__rip_2objdump()
accordingly.  The kmodule parameter of dso__load_sym() is taken into use
and the module map altered to map to the dso.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c        |  1 +
 tools/perf/util/dso.h        |  1 +
 tools/perf/util/map.c        | 14 +++++++++-----
 tools/perf/util/symbol-elf.c | 15 +++++++++++++++
 tools/perf/util/symbol.c     | 11 ++++++++---
 5 files changed, 34 insertions(+), 8 deletions(-)

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
index ed6f443..f00596f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -599,6 +599,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 	if (dso->kernel == DSO_TYPE_USER) {
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				ehdr.e_type == ET_REL ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
@@ -676,6 +677,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
+	dso->rel = syms_ss->ehdr.e_type == ET_REL;
 
 	if (!syms_ss->symtab) {
 		syms_ss->symtab  = syms_ss->dynsym;
@@ -828,11 +830,24 @@ int dso__load_sym(struct dso *dso, struct map *map,
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
-- 
1.7.11.7

