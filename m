Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbaKNOAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:00:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:44441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935201AbaKNN7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:59:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,386,1413270000"; 
   d="scan'208";a="607847738"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH V3 2/3] perf tool: Move cpumode resolve code to add_callchain_ip
Date: Fri, 14 Nov 2014 08:44:11 -0500
Message-Id: <1415972652-17310-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Move the cpumode resolve code to add_callchain_ip function.
No change in behavior.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/machine.c | 62 ++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d97309c..dd8496a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1384,11 +1384,35 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 static int add_callchain_ip(struct thread *thread,
 			    struct symbol **parent,
 			    struct addr_location *root_al,
-			    int cpumode,
+			    u8 cpumode,
 			    u64 ip)
 {
 	struct addr_location al;
 
+	if (ip >= PERF_CONTEXT_MAX) {
+		switch (ip) {
+		case PERF_CONTEXT_HV:
+			cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			break;
+		case PERF_CONTEXT_KERNEL:
+			cpumode = PERF_RECORD_MISC_KERNEL;
+			break;
+		case PERF_CONTEXT_USER:
+			cpumode = PERF_RECORD_MISC_USER;
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
 	al.filtered = 0;
 	al.sym = NULL;
 	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
@@ -1435,9 +1459,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err = 0;
 	int skip_idx __maybe_unused;
 
 	callchain_cursor_reset(&callchain_cursor);
@@ -1467,39 +1489,13 @@ static int thread__resolve_callchain_sample(struct thread *thread,
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
 		err = add_callchain_ip(thread, parent, root_al,
 				       cpumode, ip);
-		if (err == -EINVAL)
-			break;
 		if (err)
-			return err;
+			goto exit;
 	}
-
-	return 0;
+exit:
+	return (err < 0) ? err : 0;
 }
 
 static int unwind_entry(struct unwind_entry *entry, void *arg)
-- 
1.8.3.2

