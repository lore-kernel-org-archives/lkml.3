Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaDVIu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62693 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaDVIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/9] perf hists: Introduce hists__add_nr_events()
Date: Tue, 22 Apr 2014 17:49:44 +0900
Message-Id: <1398156591-11001-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hists__add_nr_events() is a helper function intended to be ran
inside of hists__inc_nr_entries().  However this requires other
changes that handled in the next patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a892477aa50..1c77714f668d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -317,6 +317,27 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
+static void __events_stats__add(struct events_stats *stats, u32 type, u32 val)
+{
+	stats->nr_events[0] += val;
+	stats->nr_events[type] += val;
+}
+
+void events_stats__inc(struct events_stats *stats, u32 type)
+{
+	__events_stats__add(stats, type, 1);
+}
+
+void hists__inc_nr_events(struct hists *hists, u32 type)
+{
+	__events_stats__add(&hists->stats, type, 1);
+}
+
+static void hists__add_nr_events(struct hists *hists, u32 type, u32 val)
+{
+	__events_stats__add(&hists->stats, type, val);
+}
+
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
@@ -805,17 +826,6 @@ void hists__filter_by_symbol(struct hists *hists)
 	}
 }
 
-void events_stats__inc(struct events_stats *stats, u32 type)
-{
-	++stats->nr_events[0];
-	++stats->nr_events[type];
-}
-
-void hists__inc_nr_events(struct hists *hists, u32 type)
-{
-	events_stats__inc(&hists->stats, type);
-}
-
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 						 struct hist_entry *pair)
 {
-- 
1.9.2

