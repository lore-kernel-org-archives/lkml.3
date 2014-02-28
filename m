Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaB1RrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaB1Rns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 06/19] perf: Fix stddev calculation
Date: Fri, 28 Feb 2014 12:42:55 -0500
Message-Id: <1393609388-40489-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stddev calculation written matched standard error.  As a result when
using this result to find the relative stddev between runs, it was not
accurate.

Update the formula to match traditional stddev.  Then rename the old
stddev calculation to stderr_stats in case someone wants to use it.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/stat.c | 13 +++++++++++++
 tools/perf/util/stat.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 6506b3d..0cb4dbc 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -33,6 +33,7 @@ double avg_stats(struct stats *stats)
  * http://en.wikipedia.org/wiki/Stddev
  *
  * The std dev of the mean is related to the std dev by:
+ * (also known as standard error)
  *
  *             s
  * s_mean = -------
@@ -41,6 +42,18 @@ double avg_stats(struct stats *stats)
  */
 double stddev_stats(struct stats *stats)
 {
+	double variance;
+
+	if (stats->n < 2)
+		return 0.0;
+
+	variance = stats->M2 / (stats->n - 1);
+
+	return sqrt(variance);
+}
+
+double stderr_stats(struct stats *stats)
+{
 	double variance, variance_mean;
 
 	if (stats->n < 2)
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index ae8ccd7..6f61615 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -12,6 +12,7 @@ struct stats
 void update_stats(struct stats *stats, u64 val);
 double avg_stats(struct stats *stats);
 double stddev_stats(struct stats *stats);
+double stderr_stats(struct stats *stats);
 double rel_stddev_stats(double stddev, double avg);
 
 static inline void init_stats(struct stats *stats)
-- 
1.7.11.7

