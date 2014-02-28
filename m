Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaB1Rn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbaB1Rn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 19/19] perf, c2c: Add shared cachline summary table
Date: Fri, 28 Feb 2014 12:43:08 -0500
Message-Id: <1393609388-40489-20-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a quick summary of the hottest cache contention lines based
on the input data.  This summarizes what the broken table shows you,
so you can see at a quick glance which cachelines are interesting.

Originally done by Dick Fowles, backported by me.

Sample output (width trimmed):

===================================================================================================================================================

                                                                                          Shared Data Cache Line Table

                                 Total     %All                Total       ---- Core Load Hit ----  -- LLC Load Hit --     ----- LLC Load Hitm -----
   Index           Phys Adrs   Records   Ld Miss     %hitm     Loads        FB       L1D       L2D       Lcl       Rmt     Total       Lcl       Rmt
====================================================================================================================================================
       0  0xffff881fa55b0140     72006    16.97%    23.31%     43095     13591     16860        45      2651        25      9526      3288      6238
       1  0xffff881fba47f000     21854     5.29%     7.26%     13938      3887      6941        15         1         7      3087      1143      1944
       2  0xffff881fc21b9cc0      2153     1.61%     2.21%       862        32        70         0        15         1       740       148       592
       3  0xffff881fc7d91cc0      1957     1.40%     1.92%       866        34        94         0        14         3       720       207       513
       4  0xffff881fba539cc0      1813     1.35%     1.85%       808        33        84         3        14         1       665       170       495

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 0749ea6..57441b9 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -783,6 +783,141 @@ cleanup:
 	}
 }
 
+static void print_c2c_shared_cacheline_report(struct rb_root *hitm_tree,
+					      struct c2c_stats *shared_stats __maybe_unused,
+					      struct c2c_stats *c2c_stats __maybe_unused)
+{
+#define   SHM_TITLE  "Shared Data Cache Line Table"
+
+	struct rb_node	*next = rb_first(hitm_tree);
+	struct c2c_hit	*h;
+	char		header[256];
+	char		delimit[256];
+	u32		crecords;
+	u32		lclmiss;
+	u32		ldcnt;
+	double		p_hitm;
+	double		p_all;
+	int		totmiss;
+	int		rmt_hitm;
+	int		len;
+	int		pad;
+	int		i;
+
+	sprintf(header,"%28s  %8s  %8s  %8s  %8s  %28s  %18s  %28s  %18s  %8s  %28s",
+		" ",
+		"Total",
+		"%All ",
+		" ",
+		"Total",
+		"---- Core Load Hit ----",
+		"-- LLC Load Hit --",
+		"----- LLC Load Hitm -----",
+		"-- Load Dram --",
+		"LLC  ",
+		"---- Store Reference ----");
+
+	len = strlen(header);
+	delimit[0] = '\0';
+
+	for (i = 0; i < len; i++)
+		strcat(delimit, "=");
+
+	printf("\n\n");
+	printf("%s\n", delimit);
+	printf("\n");
+	pad = (strlen(header)/2) - (strlen(SHM_TITLE)/2);
+	for (i = 0; i < pad; i++)
+		printf(" ");
+	printf("%s\n", SHM_TITLE);
+	printf("\n");
+	printf("%s\n", header);
+
+	sprintf(header, "%8s  %18s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s  %8s",
+		"Index",
+		"Phys Adrs",
+		"Records",
+		"Ld Miss",
+		"%hitm",
+		"Loads",
+		"FB",
+		"L1D",
+		"L2D",
+		"Lcl",
+		"Rmt",
+		"Total",
+		"Lcl",
+		"Rmt",
+		"Lcl",
+		"Rmt",
+		"Ld Miss",
+		"Total",
+		"L1Hit",
+		"L1Miss");
+
+	printf("%s\n", header);
+	printf("%s\n", delimit);
+
+	rmt_hitm    = c2c_stats->t.rmt_hitm;
+	totmiss     = c2c_stats->t.lcl_dram +
+		      c2c_stats->t.rmt_dram +
+		      c2c_stats->t.rmt_hit +
+		      c2c_stats->t.rmt_hitm;
+
+	i = 0;
+	while (next) {
+		h = rb_entry(next, struct c2c_hit, rb_node);
+		next = rb_next(&h->rb_node);
+
+		lclmiss  = h->stats.t.lcl_dram +
+			   h->stats.t.rmt_dram +
+			   h->stats.t.rmt_hitm +
+			   h->stats.t.rmt_hit;
+
+		ldcnt    = lclmiss +
+			   h->stats.t.ld_fbhit +
+			   h->stats.t.ld_l1hit +
+			   h->stats.t.ld_l2hit +
+			   h->stats.t.ld_llchit +
+			   h->stats.t.lcl_hitm;
+
+		crecords = ldcnt +
+			   h->stats.t.st_l1hit +
+			   h->stats.t.st_l1miss;
+
+		p_hitm = (double)h->stats.t.rmt_hitm / (double)rmt_hitm;
+		p_all  = (double)h->stats.t.rmt_hitm / (double)totmiss;
+
+		/* stop when the percentage gets to low */
+		if (p_hitm < DISPLAY_LINE_LIMIT)
+			break;
+
+		printf("%8d  %#18lx  %8u  %7.2f%%  %7.2f%%  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u  %8u\n",
+			i,
+			h->cacheline,
+			crecords,
+			100. * p_all,
+			100. * p_hitm,
+			ldcnt,
+			h->stats.t.ld_fbhit,
+			h->stats.t.ld_l1hit,
+			h->stats.t.ld_l2hit,
+			h->stats.t.ld_llchit,
+			h->stats.t.rmt_hit,
+			h->stats.t.lcl_hitm + h->stats.t.rmt_hitm,
+			h->stats.t.lcl_hitm,
+			h->stats.t.rmt_hitm,
+			h->stats.t.lcl_dram,
+			h->stats.t.rmt_dram,
+			lclmiss,
+			h->stats.t.store,
+			h->stats.t.st_l1hit,
+			h->stats.t.st_l1miss);
+
+		i++;
+	}
+}
+
 static void print_hitm_cacheline_header(void)
 {
 #define SHARING_REPORT_TITLE  "Shared Cache Line Distribution Pareto"
@@ -1290,6 +1425,7 @@ static void c2c_analyze_hitms(struct perf_c2c *c2c)
 		free(h);
 
 	print_shared_cacheline_info(&hitm_stats, shared_clines);
+	print_c2c_shared_cacheline_report(&hitm_tree, &hitm_stats, &c2c->stats);
 	print_c2c_hitm_report(&hitm_tree, &hitm_stats, &c2c->stats);
 
 cleanup:
-- 
1.7.11.7

