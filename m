Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaDVIvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:51:17 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62757 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaDVIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 5/9] perf hists: Add missing update on nr_non_filtered_entries
Date: Tue, 22 Apr 2014 17:49:47 +0900
Message-Id: <1398156591-11001-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a filter is used for perf top, its hists->nr_non_filtered_entries
was not updated after it removed an entry in hists__decay_entries().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 883340d7d43e..7d51f599ae98 100644
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
-- 
1.9.2

