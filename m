Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3CULZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:25:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab3CULZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:25:54 -0400
Date: Thu, 21 Mar 2013 04:24:20 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d8d7cd93e6b5f42bd2ae77680b5dc27415ba7492@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-13-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate/gtk:
  Support event group view on GTK
Git-Commit-ID: d8d7cd93e6b5f42bd2ae77680b5dc27415ba7492
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:24:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d7cd93e6b5f42bd2ae77680b5dc27415ba7492
Gitweb:     http://git.kernel.org/tip/d8d7cd93e6b5f42bd2ae77680b5dc27415ba7492
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:32 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:07 -0300

perf annotate/gtk: Support event group view on GTK

Add support for event group view to GTK annotation browser.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/annotate.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 6e2fc7e..f538794 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -33,7 +33,7 @@ static int perf_gtk__get_percent(char *buf, size_t size, struct symbol *sym,
 		return 0;
 
 	symhist = annotation__histogram(symbol__annotation(sym), evidx);
-	if (!symhist->addr[dl->offset])
+	if (!symbol_conf.event_group && !symhist->addr[dl->offset])
 		return 0;
 
 	percent = 100.0 * symhist->addr[dl->offset] / symhist->sum;
@@ -119,10 +119,24 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		GtkTreeIter iter;
+		int ret = 0;
 
 		gtk_list_store_append(store, &iter);
 
-		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evsel->idx))
+		if (perf_evsel__is_group_event(evsel)) {
+			for (i = 0; i < evsel->nr_members; i++) {
+				ret += perf_gtk__get_percent(s + ret,
+							     sizeof(s) - ret,
+							     sym, pos,
+							     evsel->idx + i);
+				ret += scnprintf(s + ret, sizeof(s) - ret, " ");
+			}
+		} else {
+			ret = perf_gtk__get_percent(s, sizeof(s), sym, pos,
+						    evsel->idx);
+		}
+
+		if (ret)
 			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
 		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
 			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
