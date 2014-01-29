Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaA2ON3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:13:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaA2ON0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608440"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 8/9] perf tools: Adjust kallsyms for relocated kernel
Date: Wed, 29 Jan 2014 16:14:43 +0200
Message-Id: <1391004884-10334-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is relocated at boot time, kallsyms
will not match data recorded previously.  That
does not matter for modules because they are
corrected anyway.  It also does not matter if
vmlinux is being used for symbols. But if perf
tools has only kallsyms then the symbols will not
match.  Fix by applying the delta gained by
comparing the old and current addresses of the
relocation reference symbol.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4ac1f87..a9d758a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -627,7 +627,7 @@ static int dso__split_kallsyms_for_kcore(struct dso *dso, struct map *map,
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *dso, struct map *map,
+static int dso__split_kallsyms(struct dso *dso, struct map *map, u64 delta,
 			       symbol_filter_t filter)
 {
 	struct map_groups *kmaps = map__kmap(map)->kmaps;
@@ -692,6 +692,12 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *ndso;
 
+			if (delta) {
+				/* Kernel was relocated at boot time */
+				pos->start -= delta;
+				pos->end -= delta;
+			}
+
 			if (count == 0) {
 				curr_map = map;
 				goto filter_symbol;
@@ -721,6 +727,10 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
+		} else if (delta) {
+			/* Kernel was relocated at boot time */
+			pos->start -= delta;
+			pos->end -= delta;
 		}
 filter_symbol:
 		if (filter && filter(curr_map, pos)) {
@@ -1130,15 +1140,41 @@ out_err:
 	return -EINVAL;
 }
 
+/*
+ * If the kernel is relocated at boot time, kallsyms won't match.  Compute the
+ * delta based on the relocation reference symbol.
+ */
+static int kallsyms__delta(struct map *map, const char *filename, u64 *delta)
+{
+	struct kmap *kmap = map__kmap(map);
+	u64 addr;
+
+	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->name)
+		return 0;
+
+	addr = kallsyms__get_function_start(filename,
+					    kmap->ref_reloc_sym->name);
+	if (!addr)
+		return -1;
+
+	*delta = addr - kmap->ref_reloc_sym->addr;
+	return 0;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
+	u64 delta = 0;
+
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return -1;
 
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	if (kallsyms__delta(map, filename, &delta))
+		return -1;
+
 	symbols__fixup_duplicate(&dso->symbols[map->type]);
 	symbols__fixup_end(&dso->symbols[map->type]);
 
@@ -1150,7 +1186,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (!dso__load_kcore(dso, map, filename))
 		return dso__split_kallsyms_for_kcore(dso, map, filter);
 	else
-		return dso__split_kallsyms(dso, map, filter);
+		return dso__split_kallsyms(dso, map, delta, filter);
 }
 
 static int dso__load_perf_map(struct dso *dso, struct map *map,
-- 
1.7.11.7

