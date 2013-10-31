Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3JaG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43539 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3JaG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:24 -0400
X-AuditID: 9c930197-b7b3eae00000122e-da-5271ff153840
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 07/14] perf tools: Update cpumode for each cumulative entry
Date: Thu, 31 Oct 2013 15:56:09 +0900
Message-Id: <1383202576-28141-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The cpumode and level in struct addr_localtion was set for a sample
and but updated as cumulative callchains were added.  This led to have
non-matching symbol and cpumode in the output.

Update it accordingly based on the fact whether the map is a part of
the kernel or not.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 92cbd5cd1ab1..1b152a8b7f51 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -80,6 +80,7 @@ struct add_entry_iter {
 	struct perf_report *rep;
 	struct perf_evsel *evsel;
 	struct perf_sample *sample;
+	struct machine *machine;
 	struct hist_entry *he;
 	struct symbol *parent;
 	void *priv;
@@ -388,7 +389,7 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
 
 static int
 iter_prepare_cumulative_entry(struct add_entry_iter *iter,
-			      struct machine *machine __maybe_unused,
+			      struct machine *machine,
 			      struct perf_evsel *evsel,
 			      struct addr_location *al __maybe_unused,
 			      struct perf_sample *sample)
@@ -404,6 +405,7 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
 
 	iter->evsel = evsel;
 	iter->sample = sample;
+	iter->machine = machine;
 	return 0;
 }
 
@@ -468,6 +470,27 @@ iter_next_cumulative_entry(struct add_entry_iter *iter __maybe_unused,
 	if (al->sym == NULL)
 		return 0;
 
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
 	callchain_cursor_advance(&callchain_cursor);
 	return 1;
 }
-- 
1.7.11.7

