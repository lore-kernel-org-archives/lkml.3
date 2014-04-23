Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaDWHAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:00:20 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60300 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaDWHAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:00:11 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/7] perf hists: Add missing update on filtered stats in hists__decay_entries()
Date: Wed, 23 Apr 2014 16:00:04 +0900
Message-Id: <1398236408-8856-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
References: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a filter is used for perf top, its hists->nr_non_filtered_entries
was not updated after it removed an entry in hists__decay_entries().
Also hists->stats.total_non_filtered_period was missed too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3ebc3cd09f42..fb17bf22433b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -225,14 +225,18 @@ static void he_stat__decay(struct he_stat *he_stat)
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
 	u64 prev_period = he->stat.period;
+	u64 diff;
 
 	if (prev_period == 0)
 		return true;
 
 	he_stat__decay(&he->stat);
 
+	diff = prev_period - he->stat.period;
+
+	hists->stats.total_period -= diff;
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->stat.period;
+		hists->stats.total_non_filtered_period -= diff;
 
 	return he->stat.period == 0;
 }
@@ -259,8 +263,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 			if (sort__need_collapse)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
-			hist_entry__free(n);
 			--hists->nr_entries;
+			if (!n->filtered)
+				--hists->nr_non_filtered_entries;
+
+			hist_entry__free(n);
 		}
 	}
 }
-- 
1.9.2

