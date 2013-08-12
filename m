Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3HLK0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:26:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3HLKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:08 -0400
Date: Mon, 12 Aug 2013 03:22:22 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-484a5e7476b7ce790ba37417a4976c7f86a87231@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1375875537-4509-13-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-13-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Remove nop at end of annotation
Git-Commit-ID: 484a5e7476b7ce790ba37417a4976c7f86a87231
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  484a5e7476b7ce790ba37417a4976c7f86a87231
Gitweb:     http://git.kernel.org/tip/484a5e7476b7ce790ba37417a4976c7f86a87231
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:56 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:35 -0300

perf annotate: Remove nop at end of annotation

When kcore is used for annotation, symbols do not have correct sizes
because they come from kallsyms, that has only its start address, with
the end address being the next symbol's minus one.

That sometimes results in an extra nop being seen after the end of a
function.  Remove it.

Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
Link: http://lkml.kernel.org/r/1375875537-4509-13-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 4ab2f11..646e38d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -830,6 +830,30 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+static void delete_last_nop(struct symbol *sym)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct list_head *list = &notes->src->source;
+	struct disasm_line *dl;
+
+	while (!list_empty(list)) {
+		dl = list_entry(list->prev, struct disasm_line, node);
+
+		if (dl->ins && dl->ins->ops) {
+			if (dl->ins->ops != &nop_ops)
+				return;
+		} else {
+			if (!strstr(dl->line, " nop ") &&
+			    !strstr(dl->line, " nopl ") &&
+			    !strstr(dl->line, " nopw "))
+				return;
+		}
+
+		list_del(&dl->node);
+		disasm_line__free(dl);
+	}
+}
+
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 {
 	struct dso *dso = map->dso;
@@ -923,6 +947,13 @@ fallback:
 		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
 			break;
 
+	/*
+	 * kallsyms does not have symbol sizes so there may a nop at the end.
+	 * Remove it.
+	 */
+	if (dso__is_kcore(dso))
+		delete_last_nop(sym);
+
 	pclose(file);
 out_free_filename:
 	if (free_filename)
