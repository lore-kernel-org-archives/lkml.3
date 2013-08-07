Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab3HGVXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:23:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933359Ab3HGVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/47] perf stats: Add max and min stats
Date: Wed,  7 Aug 2013 18:10:44 -0300
Message-Id: <1375909874-22073-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Need an initialization function to set min to -1 to
differentiate from an actual min of 0.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375473947-64285-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/stat.c | 6 ++++++
 tools/perf/util/stat.h | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 7c59c28..6506b3d 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -10,6 +10,12 @@ void update_stats(struct stats *stats, u64 val)
 	delta = val - stats->mean;
 	stats->mean += delta / stats->n;
 	stats->M2 += delta*(val - stats->mean);
+
+	if (val > stats->max)
+		stats->max = val;
+
+	if (val < stats->min)
+		stats->min = val;
 }
 
 double avg_stats(struct stats *stats)
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 588367c..ae8ccd7 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -6,6 +6,7 @@
 struct stats
 {
 	double n, mean, M2;
+	u64 max, min;
 };
 
 void update_stats(struct stats *stats, u64 val);
@@ -13,4 +14,12 @@ double avg_stats(struct stats *stats);
 double stddev_stats(struct stats *stats);
 double rel_stddev_stats(double stddev, double avg);
 
+static inline void init_stats(struct stats *stats)
+{
+	stats->n    = 0.0;
+	stats->mean = 0.0;
+	stats->M2   = 0.0;
+	stats->min  = (u64) -1;
+	stats->max  = 0;
+}
 #endif
-- 
1.8.1.4

