Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaLBP1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:27:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:44702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaLBP0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:26:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492314844"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, namhyung@kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 2/3] perf tool: Move cpumode resolve code to add_callchain_ip
Date: Tue,  2 Dec 2014 10:06:53 -0500
Message-Id: <1417532814-26208-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Using flag to distinguish between branch_history and normal callchain.
Move the cpumode to add_callchain_ip function.
No change in behavior.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/machine.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 15dd0a9..94de3e4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1385,19 +1385,46 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 static int add_callchain_ip(struct thread *thread,
 			    struct symbol **parent,
 			    struct addr_location *root_al,
-			    int cpumode,
+			    bool branch_history,
 			    u64 ip)
 {
 	struct addr_location al;
 
 	al.filtered = 0;
 	al.sym = NULL;
-	if (cpumode == -1)
+	if (branch_history)
 		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
 						   ip, &al);
-	else
+	else {
+		u8 cpumode = PERF_RECORD_MISC_USER;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;
+				break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;
+				break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;
+				break;
+			default:
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 1;
+			}
+			return 0;
+		}
 		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
 				   ip, &al);
+	}
+
 	if (al.sym != NULL) {
 		if (sort__has_parent && !*parent &&
 		    symbol__match_regex(al.sym, &parent_regex))
@@ -1480,11 +1507,8 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct addr_location *root_al,
 					     int max_stack)
 {
-	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err;
 	int skip_idx = -1;
 	int first_call = 0;
 
@@ -1542,10 +1566,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 		for (i = 0; i < nr; i++) {
 			err = add_callchain_ip(thread, parent, root_al,
-					       -1, be[i].to);
+					       true, be[i].to);
 			if (!err)
 				err = add_callchain_ip(thread, parent, root_al,
-						       -1, be[i].from);
+						       true, be[i].from);
 			if (err == -EINVAL)
 				break;
 			if (err)
@@ -1574,36 +1598,10 @@ check_calls:
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
+		err = add_callchain_ip(thread, parent, root_al, false, ip);
 
-		err = add_callchain_ip(thread, parent, root_al,
-				       cpumode, ip);
-		if (err == -EINVAL)
-			break;
 		if (err)
-			return err;
+			return (err < 0) ? err : 0;
 	}
 
 	return 0;
-- 
1.8.3.2

