Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3GKQ23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:28:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56771 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3GKQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:27:06 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 07/11] perf stats: add max and min stats
Date: Thu, 11 Jul 2013 10:26:38 -0600
Message-Id: <1373560002-14618-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
References: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need an initialization function to set min to -1 to
differentiate from an actual min of 0.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/util/stat.c |    6 ++++++
 tools/perf/util/stat.h |    9 +++++++++
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
1.7.10.1

