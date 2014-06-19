Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbaFSQjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964833AbaFSQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:39:38 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/9] perf tools: Fix segfault in cumulative.callchain report
Date: Thu, 19 Jun 2014 18:38:47 +0200
Message-Id: <1403195928-1331-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
References: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cumulative callchain mode is on, we could get samples with
with no actual hits. This breaks the assumption of the annotation
code, that each sample has annotation counts allocated and leads
to segfault.

Fixing this by additional checks for annotation stats.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1402821332-12419-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 52c03fb..04a229a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -17,6 +17,7 @@
 #include "../util.h"
 #include "../ui.h"
 #include "map.h"
+#include "annotate.h"
 
 struct hist_browser {
 	struct ui_browser   b;
@@ -1593,13 +1594,18 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					 bi->to.sym->name) > 0)
 				annotate_t = nr_options++;
 		} else {
-
 			if (browser->selection != NULL &&
 			    browser->selection->sym != NULL &&
-			    !browser->selection->map->dso->annotate_warned &&
-				asprintf(&options[nr_options], "Annotate %s",
-					 browser->selection->sym->name) > 0)
-				annotate = nr_options++;
+			    !browser->selection->map->dso->annotate_warned) {
+				struct annotation *notes;
+
+				notes = symbol__annotation(browser->selection->sym);
+
+				if (notes->src &&
+				    asprintf(&options[nr_options], "Annotate %s",
+						 browser->selection->sym->name) > 0)
+					annotate = nr_options++;
+			}
 		}
 
 		if (thread != NULL &&
@@ -1656,6 +1662,7 @@ retry_popup_menu:
 
 		if (choice == annotate || choice == annotate_t || choice == annotate_f) {
 			struct hist_entry *he;
+			struct annotation *notes;
 			int err;
 do_annotate:
 			if (!objdump_path && perf_session_env__lookup_objdump(env))
@@ -1679,6 +1686,10 @@ do_annotate:
 				he->ms.map = he->branch_info->to.map;
 			}
 
+			notes = symbol__annotation(he->ms.sym);
+			if (!notes->src)
+				continue;
+
 			/*
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
-- 
1.8.3.1

