Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaKMCFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:05:34 -0500
Received: from mga03.intel.com ([134.134.136.65]:61611 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaKMCFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:05:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,372,1413270000"; 
   d="scan'208";a="606988892"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/10] perf, tools: Factor out adding new call chain entries
Date: Wed, 12 Nov 2014 18:05:19 -0800
Message-Id: <1415844328-4884-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move the code to resolve and add a new callchain entry
into a new add_callchain_ip function. This will be used
in the next patches to add LBRs too.

No change in behavior.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/machine.c | 51 +++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e9490..84390ee 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1381,6 +1381,34 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	return mi;
 }
 
+static int add_callchain_ip(struct thread *thread,
+			    struct symbol **parent,
+			    struct addr_location *root_al,
+			    int cpumode,
+			    u64 ip)
+{
+	struct addr_location al;
+
+	al.filtered = 0;
+	al.sym = NULL;
+	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+				   ip, &al);
+	if (al.sym != NULL) {
+		if (sort__has_parent && !*parent &&
+		    symbol__match_regex(al.sym, &parent_regex))
+			*parent = al.sym;
+		else if (have_ignore_callees && root_al &&
+		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
+			/* Treat this symbol as the root,
+			   forgetting its callees. */
+			*root_al = al;
+			callchain_cursor_reset(&callchain_cursor);
+		}
+	}
+
+	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+}
+
 struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 					   struct addr_location *al)
 {
@@ -1427,7 +1455,6 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
@@ -1464,24 +1491,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 			continue;
 		}
 
-		al.filtered = 0;
-		thread__find_addr_location(thread, cpumode,
-					   MAP__FUNCTION, ip, &al);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    symbol__match_regex(al.sym, &parent_regex))
-				*parent = al.sym;
-			else if (have_ignore_callees && root_al &&
-			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
-				/* Treat this symbol as the root,
-				   forgetting its callees. */
-				*root_al = al;
-				callchain_cursor_reset(&callchain_cursor);
-			}
-		}
-
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
+		err = add_callchain_ip(thread, parent, root_al,
+				       cpumode, ip);
+		if (err == -EINVAL)
+			break;
 		if (err)
 			return err;
 	}
-- 
1.9.3

