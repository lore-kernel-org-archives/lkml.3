Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaAKTqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:46:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:13743 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaAKTnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="457257156"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/9] perf, tools: Add overlap detection for report branch-call-stack mode
Date: Sat, 11 Jan 2014 11:42:57 -0800
Message-Id: <1389469379-13340-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple heuristic to detect overlap of LBR entries and the call
stack when in lbr-as-callgraph mode. The return address in the
normal callstack is one off compared to the from entry in the
branch stack. Handle this with a simple "assume call instruction
is not longer than 8 bytes" heuristic. With that we can remove
any redundant call in the callstack that is already in the branch
stack.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/machine.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 853639c..1f167fe 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1349,6 +1349,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
 	int err;
+	int first_call = 0;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1362,8 +1363,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	 * Limitations for now:
 	 * - No extra filters
 	 * - No annotations (should annotate somehow)
-	 * - When the sample is near the beginning of the function
- 	 *   we may overlap with the real callstack. 
 	 */
 
 	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
@@ -1372,13 +1371,23 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	}
 
 	if (callchain_param.branch_callstack) {
-		int nr = min(max_stack, branch->nr);
+		int nr = min(max_stack, (int)branch->nr);
 		struct branch_entry be[nr];
 
 		for (i = 0; i < nr; i++) { 
-			if (callchain_param.order == ORDER_CALLEE)
+			if (callchain_param.order == ORDER_CALLEE) {
 				be[i] = branch->entries[i];
-			else
+				/* 
+				 * Check for overlap into the callchain.
+				 * The return address is one off compared to
+				 * the branch entry. To adjust for this 
+				 * assume the calling instruction is not longer
+				 * than 8 bytes.
+				 */
+				if (be[i].from < chain->ips[first_call] &&
+				    be[i].from >= chain->ips[first_call] - 8)
+					first_call++;
+			} else
 				be[i] = branch->entries[branch->nr - i - 1];
 		}
 
@@ -1405,7 +1414,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
-	for (i = 0; i < chain_nr; i++) {
+	for (i = first_call; i < chain_nr; i++) {
 		u64 ip;
 
 		if (callchain_param.order == ORDER_CALLEE)
-- 
1.8.3.1

