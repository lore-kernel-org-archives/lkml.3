Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3LRFV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:58 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56165 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3LRFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:32 -0500
X-AuditID: 9c93017d-b7c5eae000004296-2b-52b130d9ada4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 09/18] perf tools: Update cpumode for each cumulative entry
Date: Wed, 18 Dec 2013 14:21:17 +0900
Message-Id: <1387344086-12744-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The cpumode and level in struct addr_localtion was set for a sample
and but updated as cumulative callchains were added.  This led to have
non-matching symbol and cpumode in the output.

Update it accordingly based on the fact whether the map is a part of
the kernel or not.  This is a reverse of what thread__find_addr_map()
does.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3bc48e410d06..80c774615287 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -82,6 +82,7 @@ struct add_entry_iter {
 	struct perf_report *rep;
 	struct perf_evsel *evsel;
 	struct perf_sample *sample;
+	struct machine *machine;
 	struct hist_entry *he;
 	struct symbol *parent;
 	void *priv;
@@ -400,7 +401,7 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
 
 static int
 iter_prepare_cumulative_entry(struct add_entry_iter *iter,
-			      struct machine *machine __maybe_unused,
+			      struct machine *machine,
 			      struct perf_evsel *evsel,
 			      struct addr_location *al __maybe_unused,
 			      struct perf_sample *sample)
@@ -409,6 +410,7 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
 
 	iter->evsel = evsel;
 	iter->sample = sample;
+	iter->machine = machine;
 	return 0;
 }
 
@@ -469,9 +471,35 @@ iter_next_cumulative_entry(struct add_entry_iter *iter,
 	else
 		al->addr = node->ip;
 
-	if (iter->rep->hide_unresolved && al->sym == NULL)
-		return 0;
+	if (al->sym == NULL) {
+		if (iter->rep->hide_unresolved)
+			return 0;
+		if (al->map == NULL)
+			goto out;
+	}
 
+	if (al->map->groups == &iter->machine->kmaps) {
+		if (machine__is_host(iter->machine)) {
+			al->cpumode = PERF_RECORD_MISC_KERNEL;
+			al->level = 'k';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+			al->level = 'g';
+		}
+	} else {
+		if (machine__is_host(iter->machine)) {
+			al->cpumode = PERF_RECORD_MISC_USER;
+			al->level = '.';
+		} else if (perf_guest) {
+			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
+			al->level = 'u';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			al->level = 'H';
+		}
+	}
+
+out:
 	callchain_cursor_advance(&callchain_cursor);
 	return 1;
 }
-- 
1.7.11.7

