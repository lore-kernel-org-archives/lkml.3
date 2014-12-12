Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547AbaLLIS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:18:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478AbaLLISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:18:23 -0500
Date: Fri, 12 Dec 2014 00:18:04 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-2e77784bb7d882647c33d8e75a650625e6df0f8b@git.kernel.org>
Cc: eranian@google.com, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, jolsa@redhat.com,
        ak@linux.intel.com, mingo@redhat.com, acme@redhat.com,
        paulus@samba.org, mingo@kernel.org, hpa@zytor.com, kan.liang@intel.com
Reply-To: mingo@kernel.org, kan.liang@intel.com, hpa@zytor.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, eranian@google.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, acme@redhat.com,
        jolsa@redhat.com, ak@linux.intel.com, mingo@redhat.com,
        paulus@samba.org
In-Reply-To: <1417532814-26208-3-git-send-email-kan.liang@intel.com>
References: <1417532814-26208-3-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Move cpumode resolve code to add_callchain_ip
Git-Commit-ID: 2e77784bb7d882647c33d8e75a650625e6df0f8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e77784bb7d882647c33d8e75a650625e6df0f8b
Gitweb:     http://git.kernel.org/tip/2e77784bb7d882647c33d8e75a650625e6df0f8b
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 2 Dec 2014 10:06:53 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 10:06:29 -0300

perf callchain: Move cpumode resolve code to add_callchain_ip

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
