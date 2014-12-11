Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbaLKV1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:44378 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbaLKV1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:10 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/18] perf callchain: Move cpumode resolve code to add_callchain_ip
Date: Thu, 11 Dec 2014 18:25:58 -0300
Message-Id: <1418333166-15429-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Using flag to distinguish between branch_history and normal callchain.

Move the cpumode to add_callchain_ip function.

No change in behavior.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1417532814-26208-3-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 15dd0a9691ce..94de3e48b490 100644
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
1.9.3

