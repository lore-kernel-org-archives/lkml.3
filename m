Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaAJMc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:32:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:35595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaAJMcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:32:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="436877043"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        jolsa@redhat.com, fweisbec@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf, tools: Filter out small loops from LBR-as-call-stack
Date: Fri, 10 Jan 2014 04:32:05 -0800
Message-Id: <1389357126-3003-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Small loops can cause unnecessary duplication in the LBR-as-callstack,
because the loop body appears multiple times. Filter out duplications
from the LBR before unifying it into the histories.  This way the
same loop body only appears once.

This uses a simple hash based cycle detector. It takes some short
cuts (not handling hash collisions) so in rare cases duplicates may
be missed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/machine.c | 73 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a7e538b..0fb4e9a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -10,6 +10,7 @@
 #include "thread.h"
 #include <stdbool.h>
 #include "unwind.h"
+#include "linux/hash.h"
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
@@ -1302,6 +1303,46 @@ static int add_callchain_ip(struct machine *machine,
 	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
 }
 
+#define CHASHSZ 127
+#define CHASHBITS 7
+#define NO_ENTRY 0xff
+
+#define PERF_MAX_BRANCH_DEPTH 127
+
+/* Remove loops. */
+static int remove_loops(struct branch_entry *l, int nr)
+{
+	int i, j, off;
+	unsigned char chash[CHASHSZ];
+	memset(chash, -1, sizeof(chash));
+
+	BUG_ON(nr >= 256);
+	for (i = 0; i < nr; i++) {
+		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;
+
+		/* no collision handling for now */
+		if (chash[h] == NO_ENTRY) {
+			chash[h] = i;
+		} else if (l[chash[h]].from == l[i].from) {
+			bool is_loop = true;
+			/* check if it is a real loop */
+			off = 0;
+			for (j = chash[h]; j < i && i + off < nr; j++, off++)
+				if (l[j].from != l[i + off].from) {
+					is_loop = false;
+					break;
+				}
+			if (is_loop) {
+				memmove(l + i, l + i + off, 
+					(nr - (i + off))
+					* sizeof(struct branch_entry));
+				nr -= off;
+			}
+		}
+	}
+	return nr;
+}
+
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
@@ -1328,29 +1369,39 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	 * - No extra filters
 	 * - No annotations (should annotate somehow)
 	 * - When the sample is near the beginning of the function
- 	 *   we may overlap with the real callstack. Could handle this
-	 *   case later, by checking against the last ip.
+ 	 *   we may overlap with the real callstack. 
 	 */
 
+	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
+		pr_warning("corrupted branch chain. skipping...\n");
+		return 0;
+	}
+
 	if (callchain_param.branch_callstack) {
-		for (i = 0; i < branch->nr; i++) { 
-			struct branch_entry *b; 
+		int nr = branch->nr;
+		struct branch_entry be[nr];
 
+		for (i = 0; i < nr; i++) { 
 			if (callchain_param.order == ORDER_CALLEE)
-				b = &branch->entries[i];
+				be[i] = branch->entries[i];
 			else
-				b = &branch->entries[branch->nr - i - 1];
+				be[i] = branch->entries[branch->nr - i - 1];
+		}
 
-			err = add_callchain_ip(machine, thread, parent, root_al,
-					       -1, b->to);
+		nr = remove_loops(be, nr);
+
+		for (i = 0; i < nr; i++) {
+			err = add_callchain_ip(machine, thread, parent, 
+					       root_al,
+					       -1, be[i].to);
 			if (!err)
-				err = add_callchain_ip(machine, thread, parent, root_al,
-					       -1, b->from);
+				err = add_callchain_ip(machine, thread, 
+						       parent, root_al,
+						       -1, be[i].from);
 			if (err == -EINVAL)
 				break;
 			if (err)
 				return err;
-
 		}
 	}
 
-- 
1.8.3.1

