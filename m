Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaKSQEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:51415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614AbaKSQES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:18 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/16] perf callchain: Factor out adding new call chain entries
Date: Wed, 19 Nov 2014 13:03:26 -0300
Message-Id: <1416413016-19110-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move the code to resolve and add a new callchain entry into a new
add_callchain_ip function. This will be used in the next patches to add
LBRs too.

No change in behavior.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 51 +++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e94902afb1..84390eecab06 100644
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

