Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab3HGLgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:36:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:56434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476Ab3HGLdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214527"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 04/13] perf tools: adjust the vmlinux symtab matches kallsyms test
Date: Wed,  7 Aug 2013 14:38:48 +0300
Message-Id: <1375875537-4509-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmlinux maps now map to the dso and the symbol values
are now file offsets.  For comparison with kallsyms
the virtual memory address is needed which is obtained
by unmapping the symbol value.

The "vmlinux symtab matches kallsyms" is adjusted
accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index add1539..e2e1498 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -25,6 +25,7 @@ int test__vmlinux_matches_kallsyms(void)
 	struct machine kallsyms, vmlinux;
 	enum map_type type = MAP__FUNCTION;
 	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
+	u64 mem_start, mem_end;
 
 	/*
 	 * Step 1:
@@ -123,10 +124,14 @@ int test__vmlinux_matches_kallsyms(void)
 		if (sym->start == sym->end)
 			continue;
 
-		first_pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
+		mem_start = vmlinux_map->unmap_ip(vmlinux_map, sym->start);
+		mem_end = vmlinux_map->unmap_ip(vmlinux_map, sym->end);
+
+		first_pair = machine__find_kernel_symbol(&kallsyms, type,
+							 mem_start, NULL, NULL);
 		pair = first_pair;
 
-		if (pair && pair->start == sym->start) {
+		if (pair && pair->start == mem_start) {
 next_pair:
 			if (strcmp(sym->name, pair->name) == 0) {
 				/*
@@ -138,10 +143,11 @@ next_pair:
 				 * off the real size. More than that and we
 				 * _really_ have a problem.
 				 */
-				s64 skew = sym->end - pair->end;
+				s64 skew = mem_end - pair->end;
 				if (llabs(skew) >= page_size)
 					pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
-						 sym->start, sym->name, sym->end, pair->end);
+						 mem_start, sym->name, mem_end,
+						 pair->end);
 
 				/*
 				 * Do not count this as a failure, because we
@@ -159,7 +165,7 @@ detour:
 				if (nnd) {
 					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
 
-					if (next->start == sym->start) {
+					if (next->start == mem_start) {
 						pair = next;
 						goto next_pair;
 					}
@@ -172,10 +178,11 @@ detour:
 				}
 
 				pr_debug("%#" PRIx64 ": diff name v: %s k: %s\n",
-					 sym->start, sym->name, pair->name);
+					 mem_start, sym->name, pair->name);
 			}
 		} else
-			pr_debug("%#" PRIx64 ": %s not on kallsyms\n", sym->start, sym->name);
+			pr_debug("%#" PRIx64 ": %s not on kallsyms\n",
+				 mem_start, sym->name);
 
 		err = -1;
 	}
@@ -208,16 +215,19 @@ detour:
 	for (nd = rb_first(&vmlinux.kmaps.maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node), *pair;
 
-		pair = map_groups__find(&kallsyms.kmaps, type, pos->start);
+		mem_start = vmlinux_map->unmap_ip(vmlinux_map, pos->start);
+		mem_end = vmlinux_map->unmap_ip(vmlinux_map, pos->end);
+
+		pair = map_groups__find(&kallsyms.kmaps, type, mem_start);
 		if (pair == NULL || pair->priv)
 			continue;
 
-		if (pair->start == pos->start) {
+		if (pair->start == mem_start) {
 			pair->priv = 1;
 			pr_info(" %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s in kallsyms as",
 				pos->start, pos->end, pos->pgoff, pos->dso->name);
-			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
-				pr_info(": \n*%" PRIx64 "-%" PRIx64 " %" PRIx64 "",
+			if (mem_end != pair->end)
+				pr_info(":\n*%" PRIx64 "-%" PRIx64 " %" PRIx64,
 					pair->start, pair->end, pair->pgoff);
 			pr_info(" %s\n", pair->dso->name);
 			pair->priv = 1;
-- 
1.7.11.7

