Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3HLKUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3HLKTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:19:53 -0400
Date: Mon, 12 Aug 2013 03:19:16 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-ffe4f3c0d109dc53e1b3448ac457052107f34a84@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375473947-64285-3-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stats: Add max and min stats
Git-Commit-ID: ffe4f3c0d109dc53e1b3448ac457052107f34a84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffe4f3c0d109dc53e1b3448ac457052107f34a84
Gitweb:     http://git.kernel.org/tip/ffe4f3c0d109dc53e1b3448ac457052107f34a84
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:40 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:26 -0300

perf stats: Add max and min stats

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
