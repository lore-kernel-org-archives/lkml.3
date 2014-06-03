Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaFCScm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:32:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbaFCSck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:32:40 -0400
Date: Tue, 3 Jun 2014 11:32:24 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c7405d85d7a354b8ba49e2db7c4b027e6cb997c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-7-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Update cpumode for each cumulative entry
Git-Commit-ID: c7405d85d7a354b8ba49e2db7c4b027e6cb997c1
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

Commit-ID:  c7405d85d7a354b8ba49e2db7c4b027e6cb997c1
Gitweb:     http://git.kernel.org/tip/c7405d85d7a354b8ba49e2db7c4b027e6cb997c1
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Oct 2013 13:58:30 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:34:58 +0200

perf tools: Update cpumode for each cumulative entry

The cpumode and level in struct addr_localtion was set for a sample
and but updated as cumulative callchains were added.  This led to have
non-matching symbol and cpumode in the output.

Update it accordingly based on the fact whether the map is a part of
the kernel or not.  This is a reverse of what thread__find_addr_map()
does.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-7-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/callchain.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 ++
 tools/perf/util/hist.c      | 13 ++-----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 2af69c4..48b6d3f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -630,3 +630,45 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
+
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved)
+{
+	al->map = node->map;
+	al->sym = node->sym;
+	if (node->map)
+		al->addr = node->map->map_ip(node->map, node->ip);
+	else
+		al->addr = node->ip;
+
+	if (al->sym == NULL) {
+		if (hide_unresolved)
+			return 0;
+		if (al->map == NULL)
+			goto out;
+	}
+
+	if (al->map->groups == &al->machine->kmaps) {
+		if (machine__is_host(al->machine)) {
+			al->cpumode = PERF_RECORD_MISC_KERNEL;
+			al->level = 'k';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+			al->level = 'g';
+		}
+	} else {
+		if (machine__is_host(al->machine)) {
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
+	return 1;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index bde2b0c..24a53d5 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -162,6 +162,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 			      struct perf_evsel *evsel, struct addr_location *al,
 			      int max_stack);
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved);
 
 extern const char record_callchain_help[];
 int parse_callchain_report_opt(const char *arg);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6079b5a..37c28fc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -743,18 +743,9 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	al->map = node->map;
-	al->sym = node->sym;
-	if (node->map)
-		al->addr = node->map->map_ip(node->map, node->ip);
-	else
-		al->addr = node->ip;
-
-	if (iter->hide_unresolved && al->sym == NULL)
-		return 0;
-
 	callchain_cursor_advance(&callchain_cursor);
-	return 1;
+
+	return fill_callchain_info(al, node, iter->hide_unresolved);
 }
 
 static int
