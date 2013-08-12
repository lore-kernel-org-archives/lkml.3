Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3HLKV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:21:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3HLKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:21:56 -0400
Date: Mon, 12 Aug 2013 03:21:11 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d380b34830cc76461feab012f0bc52b01e65087c@git.kernel.org>
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
In-Reply-To: <1375875537-4509-5-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Adjust the vmlinux symtab matches kallsyms test
Git-Commit-ID: d380b34830cc76461feab012f0bc52b01e65087c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:21:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d380b34830cc76461feab012f0bc52b01e65087c
Gitweb:     http://git.kernel.org/tip/d380b34830cc76461feab012f0bc52b01e65087c
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:48 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:32 -0300

perf tests: Adjust the vmlinux symtab matches kallsyms test

The vmlinux maps now map to the dso and the symbol values are now file
offsets.  For comparison with kallsyms the virtual memory address is
needed which is obtained by unmapping the symbol value.

The "vmlinux symtab matches kallsyms" is adjusted accordingly.

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
Link: http://lkml.kernel.org/r/1375875537-4509-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
