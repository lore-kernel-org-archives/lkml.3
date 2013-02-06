Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240Ab3BFWLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:11:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab3BFWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:11:19 -0500
Date: Wed, 6 Feb 2013 14:10:31 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0c5268bf2218144469dde3228f14898fadbbcdcd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1359981185-16819-2-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Add support to display whole group data for raw columns
Git-Commit-ID: 0c5268bf2218144469dde3228f14898fadbbcdcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:10:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c5268bf2218144469dde3228f14898fadbbcdcd
Gitweb:     http://git.kernel.org/tip/0c5268bf2218144469dde3228f14898fadbbcdcd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 4 Feb 2013 13:32:55 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:27 -0300

perf hists browser: Add support to display whole group data for raw columns

Currently we don't display group members' values for raw columns like
'Samples' and 'Period' when in group report mode.

Uniting '__hpp__percent_fmt' and '__hpp__raw_fmt' function under new
function __hpp__fmt. It's basically '__hpp__percent_fmt' code with new
'fmt_percent' bool parameter added saying whether raw number or
percentage should be printed.

This way raw columns print out all the group members when
in group report mode, like:

  $ perf record -e '{cycles,cache-misses}' ls
  ...
  $ perf report --group --show-total-period --stdio
  ...
  #         Overhead                    Period  Command      Shared Object                             Symbol
  # ................  ........................  .......  .................  .................................
  #
      23.63%  11.24%       3331335         317       ls  [kernel.kallsyms]  [k] __lock_acquire
      12.72%   0.00%       1793100           0       ls  [kernel.kallsyms]  [k] native_sched_clock
       9.72%   0.00%       1369920           0       ls  libc-2.14.90.so    [.] _nl_find_locale
       0.03%   0.07%          4476           2       ls  [kernel.kallsyms]  [k] intel_pmu_enable_all
       0.00%  11.73%             0         331       ls  ld-2.14.90.so      [.] _dl_cache_libcmp
       0.00%  11.06%             0         312       ls  [kernel.kallsyms]  [k] vma_interval_tree_insert

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359981185-16819-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c | 53 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a47ce98..d671e63 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -9,18 +9,24 @@
 
 typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
 
-static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			      u64 (*get_field)(struct hist_entry *),
-			      const char *fmt, hpp_snprint_fn print_fn)
+static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+		      u64 (*get_field)(struct hist_entry *),
+		      const char *fmt, hpp_snprint_fn print_fn,
+		      bool fmt_percent)
 {
 	int ret;
-	double percent = 0.0;
 	struct hists *hists = he->hists;
 
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
+	if (fmt_percent) {
+		double percent = 0.0;
+
+		if (hists->stats.total_period)
+			percent = 100.0 * get_field(he) /
+				  hists->stats.total_period;
 
-	ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+	} else
+		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
 
 	if (symbol_conf.event_group) {
 		int prev_idx, idx_delta;
@@ -49,11 +55,15 @@ static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * have no sample
 				 */
 				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0.0);
+						fmt, 0);
 			}
 
-			ret += print_fn(hpp->buf + ret, hpp->size - ret,
-					fmt, 100.0 * period / total);
+			if (fmt_percent)
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 100.0 * period / total);
+			else
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, period);
 
 			prev_idx = perf_evsel__group_idx(evsel);
 		}
@@ -65,23 +75,12 @@ static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			 * zero-fill group members at last which have no sample
 			 */
 			ret += print_fn(hpp->buf + ret, hpp->size - ret,
-					fmt, 0.0);
+					fmt, 0);
 		}
 	}
 	return ret;
 }
 
-static int __hpp__raw_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			  u64 (*get_field)(struct hist_entry *),
-			  const char *fmt, hpp_snprint_fn print_fn)
-{
-	int ret;
-
-	ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
-	return ret;
-}
-
-
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp *hpp)			\
 {									\
@@ -116,16 +115,16 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 										\
 static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__percent_fmt(hpp, he, he_get_##_field, " %6.2f%%",		\
-				  (hpp_snprint_fn)percent_color_snprintf); 	\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+			  (hpp_snprint_fn)percent_color_snprintf, true);	\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
 static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__percent_fmt(hpp, he, he_get_##_field, fmt,		\
-				  scnprintf);					\
+	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
+			  scnprintf, true);					\
 }
 
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
@@ -137,7 +136,7 @@ static u64 he_get_raw_##_field(struct hist_entry *he)				\
 static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__raw_fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf);	\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf, false);	\
 }
 
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
