Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3HLKWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3HLKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:37 -0400
Date: Mon, 12 Aug 2013 03:22:01 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-bbb7f846f88df05646795854a014d73fb00f3b8b@git.kernel.org>
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
In-Reply-To: <1375875537-4509-11-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-11-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Allow disassembly using /proc/
 kcore
Git-Commit-ID: bbb7f846f88df05646795854a014d73fb00f3b8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbb7f846f88df05646795854a014d73fb00f3b8b
Gitweb:     http://git.kernel.org/tip/bbb7f846f88df05646795854a014d73fb00f3b8b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:54 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:34 -0300

perf annotate: Allow disassembly using /proc/kcore

Annotation with /proc/kcore is possible so the logic is adjusted to
allow it.  The main difference is that /proc/kcore had no symbols so the
parsing logic needed a tweak to read jump offsets.

The other difference is that objdump cannot always read from kcore.
That seems to be a bug with objdump.

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
Link: http://lkml.kernel.org/r/1375875537-4509-11-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c   |  3 ++-
 tools/perf/util/annotate.c | 13 +++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9101f7c..440c3b3 100644
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
