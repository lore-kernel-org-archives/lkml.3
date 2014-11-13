Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaKMAdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:33:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:14182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbaKMAdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415729816"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 2/3] perf tool: re-organize thread__resolve_callchain_sample
Date: Wed, 12 Nov 2014 19:18:14 -0500
Message-Id: <1415837895-10275-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
References: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Re-organize thread__resolve_callchain_sample. Next patch will reuse
parts of thread__resolve_callchain_sample, so factored out the common
functionality.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/machine.c | 105 +++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 48 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e9490..9c7d136 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1399,6 +1399,57 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 	return bi;
 }
 
+static inline int __thread__resolve_callchain_sample(struct thread *thread,
+						     u64 ip, u8 *cpumode,
+						     struct symbol **parent,
+						     struct addr_location *root_al)
+{
+	struct addr_location al;
+
+	if (ip >= PERF_CONTEXT_MAX) {
+		switch (ip) {
+		case PERF_CONTEXT_HV:
+			*cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			break;
+		case PERF_CONTEXT_KERNEL:
+			*cpumode = PERF_RECORD_MISC_KERNEL;
+			break;
+		case PERF_CONTEXT_USER:
+			*cpumode = PERF_RECORD_MISC_USER;
+			break;
+		default:
+			pr_debug("invalid callchain context: "
+				 "%"PRId64"\n", (s64) ip);
+			/*
+			 * It seems the callchain is corrupted.
+			 * Discard all.
+			 */
+			callchain_cursor_reset(&callchain_cursor);
+			return 1;
+		}
+		return 0;
+	}
+
+	al.filtered = 0;
+	thread__find_addr_location(thread, *cpumode,
+				   MAP__FUNCTION, ip, &al);
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
+	return callchain_cursor_append(&callchain_cursor,
+				       ip, al.map, al.sym);
+
+}
 static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct ip_callchain *chain,
 					     struct symbol **parent,
@@ -1407,9 +1458,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err = 0;
 	int skip_idx __maybe_unused;
 
 	callchain_cursor_reset(&callchain_cursor);
@@ -1427,7 +1476,6 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
@@ -1440,53 +1488,14 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 #endif
 		ip = chain->ips[j];
 
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;
-				break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;
-				break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;
-				break;
-			default:
-				pr_debug("invalid callchain context: "
-					 "%"PRId64"\n", (s64) ip);
-				/*
-				 * It seems the callchain is corrupted.
-				 * Discard all.
-				 */
-				callchain_cursor_reset(&callchain_cursor);
-				return 0;
-			}
-			continue;
-		}
-
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
+		err = __thread__resolve_callchain_sample(thread,
+			ip, &cpumode, parent, root_al);
 		if (err)
-			return err;
+			goto exit;
 	}
 
-	return 0;
+exit:
+	return (err < 0) ? err : 0;
 }
 
 static int unwind_entry(struct unwind_entry *entry, void *arg)
-- 
1.8.3.2

