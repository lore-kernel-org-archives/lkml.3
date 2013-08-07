Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3HGLd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:33:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:29189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500Ab3HGLdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214653"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 08/13] perf tools: adjust the vmlinux symtab matches kallsyms test again
Date: Wed,  7 Aug 2013 14:38:52 +0300
Message-Id: <1375875537-4509-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kallsyms maps now may map to kcore and the symbol values
now may be file offsets.  For comparison with vmlinux
the virtual memory address is needed which is obtained
by unmapping the symbol value.

The "vmlinux symtab matches kallsyms" is adjusted
accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index e2e1498..2bd13ed 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -16,6 +16,8 @@ static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
 	return 0;
 }
 
+#define UM(x) kallsyms_map->unmap_ip(kallsyms_map, (x))
+
 int test__vmlinux_matches_kallsyms(void)
 {
 	int err = -1;
@@ -74,7 +76,7 @@ int test__vmlinux_matches_kallsyms(void)
 		goto out;
 	}
 
-	ref_reloc_sym.addr = sym->start;
+	ref_reloc_sym.addr = UM(sym->start);
 
 	/*
 	 * Step 5:
@@ -131,7 +133,7 @@ int test__vmlinux_matches_kallsyms(void)
 							 mem_start, NULL, NULL);
 		pair = first_pair;
 
-		if (pair && pair->start == mem_start) {
+		if (pair && UM(pair->start) == mem_start) {
 next_pair:
 			if (strcmp(sym->name, pair->name) == 0) {
 				/*
@@ -143,11 +145,11 @@ next_pair:
 				 * off the real size. More than that and we
 				 * _really_ have a problem.
 				 */
-				s64 skew = mem_end - pair->end;
+				s64 skew = mem_end - UM(pair->end);
 				if (llabs(skew) >= page_size)
 					pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
 						 mem_start, sym->name, mem_end,
-						 pair->end);
+						 UM(pair->end));
 
 				/*
 				 * Do not count this as a failure, because we
@@ -165,7 +167,7 @@ detour:
 				if (nnd) {
 					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
 
-					if (next->start == mem_start) {
+					if (UM(next->start) == mem_start) {
 						pair = next;
 						goto next_pair;
 					}
-- 
1.7.11.7

