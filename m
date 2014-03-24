Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaCXTht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:37:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaCXTho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:37:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 07/15 V3] perf, c2c: Add in sort on physid
Date: Mon, 24 Mar 2014 15:36:58 -0400
Message-Id: <1395689826-215033-8-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the infrastructure is set, add in the support to use
hist_entry to sort on physid.

V2: use new mmap2 sort

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index d7eaf81..b5742bd 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -7,6 +7,7 @@
 #include "util/tool.h"
 #include "util/debug.h"
 #include <api/fs/fs.h>
+#include "util/annotate.h"
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -14,6 +15,7 @@
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
+	struct hists	 hists;
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -151,7 +153,11 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 					struct perf_sample *sample,
 					struct perf_evsel *evsel)
 {
+	struct symbol *parent = NULL;
+	struct hist_entry *he;
 	struct mem_info *mi;
+	uint64_t cost;
+	int err;
 
 	mi = sample__resolve_mem(sample, al);
 	if (!mi)
@@ -163,7 +169,33 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
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
 
 /* setup the basic events for most coverage, options added later */
@@ -266,10 +298,28 @@ out:
 	return err;
 }
 
+static int perf_c2c__init(struct perf_c2c *c2c)
+{
+	sort__mode = SORT_MODE__PHYSID;
+	sort__wants_unique = 1;
+	sort_order = "daddr,iaddr,pid,tid";
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

