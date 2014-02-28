Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaB1Rs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbaB1Rno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 11/19] perf, c2c: Add in sort on physid
Date: Fri, 28 Feb 2014 12:43:00 -0500
Message-Id: <1393609388-40489-12-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the infrastructure is set, add in the support to use
hist_entry to sort on physid.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 367d6c1..472d4d9 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -6,6 +6,7 @@
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/debug.h"
+#include "util/annotate.h"
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -13,6 +14,7 @@
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
+	struct hists	 hists;
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -144,7 +146,11 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 					struct perf_sample *sample,
 					struct perf_evsel *evsel)
 {
-	struct mem_info *mi;
+	struct symbol *parent = NULL;
+	struct hist_entry *he;
+	struct mem_info *mi, *mx;
+	uint64_t cost;
+	int err;
 
 	mi = sample__resolve_mem(sample, al);
 	if (!mi)
@@ -156,7 +162,42 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 		return 0;
 	}
 
-	return 0;
+	cost = sample->weight;
+	if (!cost)
+		cost = 1;
+
+	/*
+	 * must pass period=weight in order to get the correct
+	 * sorting from hists__collapse_resort() which is solely
+	 * based on periods. We want sorting be done on nr_events * weight
+	 * and this is indirectly achieved by passing period=weight here
+	 * and the he_stat__add_period() function.
+	 */
+	he = __hists__add_entry(&c2c->hists, al, parent, NULL, mi,
+				cost, cost, 0);
+	if (!he) {
+		err = -ENOMEM;
+		goto out_mem;
+	}
+
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (err)
+		goto out;
+
+	mx = he->mem_info;
+	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
+	if (err)
+		goto out;
+
+	c2c->hists.stats.total_period += cost;
+	hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
+	return err;
+
+out_mem:
+	/* implicitly freed by __hists__add_entry */
+	free(mi);
+out:
+	return err;
 }
 
 static const struct perf_evsel_str_handler handlers[] = {
@@ -255,10 +296,28 @@ out:
 	return err;
 }
 
+static int perf_c2c__init(struct perf_c2c *c2c)
+{
+	sort__mode = SORT_MODE__MEMORY;
+	sort__wants_unique = 1;
+	sort_order = "physid";
+
+	if (setup_sorting() < 0) {
+		pr_err("can not setup sorting\n");
+		return -1;
+	}
+
+	hists__init(&c2c->hists);
+
+	return 0;
+}
 static int perf_c2c__report(struct perf_c2c *c2c)
 {
 	setup_pager();
 
+	if (perf_c2c__init(c2c))
+		return -1;
+
 	if (c2c->raw_records)
 		perf_c2c__fprintf_header(stdout);
 
-- 
1.7.11.7

