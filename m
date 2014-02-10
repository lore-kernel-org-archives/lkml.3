Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaBJRgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:36:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbaBJRa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:56 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 14/21] perf, c2c: Output summary stats
Date: Mon, 10 Feb 2014 12:29:09 -0500
Message-Id: <1392053356-23024-15-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Output some summary stats based on the processed records.
Mainly diagnostic uses.

Stats done by Dick Fowles, backported by me.

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 047fe26..c8e76dc 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -1247,7 +1247,6 @@ static void print_hitm_cacheline_offset(struct c2c_hit *clo,
 						 23, stdout);
 	}
 }
-
 static void print_c2c_hitm_report(struct rb_root *hitm_tree,
 				  struct c2c_stats *hitm_stats __maybe_unused,
 				  struct c2c_stats *c2c_stats)
@@ -1442,6 +1441,48 @@ cleanup:
 	return;
 }
 
+static void print_c2c_trace_report(struct perf_c2c *c2c)
+{
+	int llc_misses;
+	struct c2c_stats *stats = &c2c->stats;
+
+	llc_misses = stats->t.lcl_dram +
+		     stats->t.rmt_dram +
+		     stats->t.rmt_hit +
+		     stats->t.rmt_hitm;
+
+	printf("=================================================\n");
+	printf("            Trace Event Information              \n");
+	printf("=================================================\n");
+	printf("  Total records                     : %10d\n", c2c->stats.nr_entries);
+	printf("  Locked Load/Store Operations      : %10d\n", stats->t.locks);
+	printf("  Load Operations                   : %10d\n", stats->t.load);
+	printf("  Loads - uncacheable               : %10d\n", stats->t.ld_uncache);
+	printf("  Loads - no mapping                : %10d\n", stats->t.ld_noadrs);
+	printf("  Load Fill Buffer Hit              : %10d\n", stats->t.ld_fbhit);
+	printf("  Load L1D hit                      : %10d\n", stats->t.ld_l1hit);
+	printf("  Load L2D hit                      : %10d\n", stats->t.ld_l2hit);
+	printf("  Load LLC hit                      : %10d\n", stats->t.ld_llchit + stats->t.lcl_hitm);
+	printf("  Load Local HITM                   : %10d\n", stats->t.lcl_hitm);
+	printf("  Load Remote HITM                  : %10d\n", stats->t.rmt_hitm);
+	printf("  Load Remote HIT                   : %10d\n", stats->t.rmt_hit);
+	printf("  Load Local DRAM                   : %10d\n", stats->t.lcl_dram);
+	printf("  Load Remote DRAM                  : %10d\n", stats->t.rmt_dram);
+	printf("  Load MESI State Exclusive         : %10d\n", stats->t.ld_excl);
+	printf("  Load MESI State Shared            : %10d\n", stats->t.ld_shared);
+	printf("  Load LLC Misses                   : %10d\n", llc_misses);
+	printf("  LLC Misses to Local DRAM          : %10.1f%%\n", ((double)stats->t.lcl_dram/(double)llc_misses) * 100.);
+	printf("  LLC Misses to Remote DRAM         : %10.1f%%\n", ((double)stats->t.rmt_dram/(double)llc_misses) * 100.);
+	printf("  LLC Misses to Remote cache (HIT)  : %10.1f%%\n", ((double)stats->t.rmt_hit /(double)llc_misses) * 100.);
+	printf("  LLC Misses to Remote cache (HITM) : %10.1f%%\n", ((double)stats->t.rmt_hitm/(double)llc_misses) * 100.);
+	printf("  Store Operations                  : %10d\n", stats->t.store);
+	printf("  Store - uncacheable               : %10d\n", stats->t.st_uncache);
+	printf("  Store - no mapping                : %10d\n", stats->t.st_noadrs);
+	printf("  Store L1D Hit                     : %10d\n", stats->t.st_l1hit);
+	printf("  Virt -> Phys Remap Rejects        : %10d\n", stats->t.remap);
+	printf("  No Page Map Rejects               : %10d\n", stats->t.nomap);
+}
+
 static int perf_c2c__process_events(struct perf_session *session,
 				    struct perf_c2c *c2c)
 {
@@ -1453,6 +1494,7 @@ static int perf_c2c__process_events(struct perf_session *session,
 		goto err;
 	}
 
+	print_c2c_trace_report(c2c);
 	c2c_analyze_hitms(c2c);
 
 err:
-- 
1.7.11.7

