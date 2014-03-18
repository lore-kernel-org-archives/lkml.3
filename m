Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaCRV03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbaCRV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] perf report: Merge al->filtered with hist_entry->filtered
Date: Tue, 18 Mar 2014 18:25:57 -0300
Message-Id: <1395177965-8879-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

I.e. don't drop al->filtered entries, create the hist_entries and use
its ->filtered bitmap, that is kept with the same semantics for its
bitmap, leaving the filtering to be done at the hist_entry level, i.e.
in the UIs.

This will allow zooming in/out the filters.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-xeyhkepu7plw716lrtb0zlnu@git.kernel.org
[ yanked this out of a previous patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 2 +-
 tools/perf/util/hist.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c47bf586fcba..a74059f0c45f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -231,7 +231,7 @@ static int process_sample_event(struct perf_tool *tool,
 		return -1;
 	}
 
-	if (al.filtered || (rep->hide_unresolved && al.sym == NULL))
+	if (rep->hide_unresolved && al.sym == NULL)
 		return 0;
 
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9507f33b02ff..f38590d7561b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -422,7 +422,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.weight = weight,
 		},
 		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
+		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
 		.hists	= hists,
 		.branch_info = bi,
 		.mem_info = mi,
-- 
1.8.1.4

