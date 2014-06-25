Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaFYFw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:52:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:52:53 -0400
Date: Tue, 24 Jun 2014 22:52:36 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d755330c5e0658d8056242b5b81e2f44ed7a96d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
References: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix segfault in cumulative.callchain report
Git-Commit-ID: d755330c5e0658d8056242b5b81e2f44ed7a96d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d755330c5e0658d8056242b5b81e2f44ed7a96d8
Gitweb:     http://git.kernel.org/tip/d755330c5e0658d8056242b5b81e2f44ed7a96d8
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 15 Jun 2014 10:22:15 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 20 Jun 2014 09:34:18 +0200

perf tools: Fix segfault in cumulative.callchain report

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
