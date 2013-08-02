Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3HBKFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:05:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:52042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803Ab3HBKFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,800,1367996400"; 
   d="scan'208";a="380030817"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 10/10] perf tools: allow annotation using /proc/kcore
Date: Fri,  2 Aug 2013 13:10:52 +0300
Message-Id: <1375438252-24776-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
References: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotation with /proc/kcore is possible so the logic
is adjusted to allow it.  The main difference is that
/proc/kcore had no symbols so the parsing logic needed
a tweak to read jump offsets.

The other difference is that objdump cannot always
read from kcore.  That seems to be a bug with objdump.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-top.c   |  3 ++-
 tools/perf/util/annotate.c | 13 +++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bbf4635..3b19a6b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -103,7 +103,8 @@ static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 	/*
 	 * We can't annotate with just /proc/kallsyms
 	 */
-	if (map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+	if (map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS &&
+	    !dso__is_kcore(map->dso)) {
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
 		       "path\n", sym->name);
 		sleep(1);
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d102716..4ab2f11 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -110,10 +110,10 @@ static int jump__parse(struct ins_operands *ops)
 {
 	const char *s = strchr(ops->raw, '+');
 
-	ops->target.addr = strtoll(ops->raw, NULL, 16);
+	ops->target.addr = strtoull(ops->raw, NULL, 16);
 
 	if (s++ != NULL)
-		ops->target.offset = strtoll(s, NULL, 16);
+		ops->target.offset = strtoull(s, NULL, 16);
 	else
 		ops->target.offset = UINT64_MAX;
 
@@ -821,6 +821,10 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	if (dl == NULL)
 		return -1;
 
+	if (dl->ops.target.offset == UINT64_MAX)
+		dl->ops.target.offset = dl->ops.target.addr -
+					map__rip_2objdump(map, sym->start);
+
 	disasm__add(&notes->src->source, dl);
 
 	return 0;
@@ -864,7 +868,8 @@ fallback:
 		free_filename = false;
 	}
 
-	if (dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+	if (dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS &&
+	    !dso__is_kcore(dso)) {
 		char bf[BUILD_ID_SIZE * 2 + 16] = " with build id ";
 		char *build_id_msg = NULL;
 
@@ -898,7 +903,7 @@ fallback:
 	snprintf(command, sizeof(command),
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
-		 " -d %s %s -C %s|grep -v %s|expand",
+		 " -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
 		 objdump_path ? objdump_path : "objdump",
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
-- 
1.7.11.7

