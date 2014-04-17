Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaDQHxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:53:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54766 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaDQHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:53:29 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/3] perf hists: Add missing updates on nr_non_filtered_entries
Date: Thu, 17 Apr 2014 16:53:24 +0900
Message-Id: <1397721206-15393-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a filter is used for perf top, its hists->nr_non_filtered_entries
was not updated after applying the filter.  But it needs to be updated
as new samples are captured.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a892477aa50..2edbcd717f0e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -259,8 +259,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
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
@@ -394,6 +397,9 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		return NULL;
 
 	hists->nr_entries++;
+	if (!he->filtered)
+		hists->nr_non_filtered_entries++;
+
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-- 
1.9.2

