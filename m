Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbbACC4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 21:56:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:42931 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbbACC4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 21:56:03 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf diff: Fix to sort by baseline field by default
Date: Fri,  2 Jan 2015 23:55:37 -0300
Message-Id: <1420253737-2488-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420253737-2488-1-git-send-email-acme@kernel.org>
References: <1420253737-2488-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The currently perf diff didn't add the baseline and delta (or other
compute) fields to the sort list so output will be sorted by other
fields like alphabetical order of DSO or symbol as below example.

Fix it by adding hpp formats for the fields and provides default compare
functions.

Before:

  $ perf diff
  # Event 'cycles'
  #
  # Baseline    Delta  Shared Object       Symbol
  # ........  .......  ..................  ...............................
  #
                       [bridge]            [k] ip_sabotage_in
                       [btrfs]             [k] __etree_search.constprop.47
       0.01%           [btrfs]             [k] btrfs_file_mmap
       0.01%   -0.01%  [btrfs]             [k] btrfs_getattr
                       [e1000e]            [k] e1000_watchdog
       0.00%           [kernel.vmlinux]    [k] PageHuge
       0.00%           [kernel.vmlinux]    [k] __acct_update_integrals
       0.00%           [kernel.vmlinux]    [k] __activate_page
                       [kernel.vmlinux]    [k] __alloc_fd
       0.02%   +0.02%  [kernel.vmlinux]    [k] __alloc_pages_nodemask
       ...

After:

  # Baseline    Delta  Shared Object       Symbol
  # ........  .......  ..................  ................................
  #
      24.73%   -4.62%  perf                [.] append_chain_children
       7.96%   -1.29%  perf                [.] dso__find_symbol
       6.97%   -2.07%  libc-2.20.so        [.] vfprintf
       4.61%   +0.88%  libc-2.20.so        [.] __fprintf_chk
       4.41%   +2.43%  perf                [.] sort__comm_cmp
       4.10%   -0.16%  perf                [.] comm__str
       4.03%   -0.93%  perf                [.] machine__findnew_thread_time
       3.82%   +3.09%  perf                [.] __hists__add_entry
       2.95%   -0.18%  perf                [.] sort__dso_cmp
       ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1419656793-32756-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 303c1e151dcf..1fd96c13f199 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -545,6 +545,42 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 	return __hist_entry__cmp_compute(p_left, p_right, c);
 }
 
+static int64_t
+hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
+		    struct hist_entry *right __maybe_unused)
+{
+	return 0;
+}
+
+static int64_t
+hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
+{
+	if (sort_compute)
+		return 0;
+
+	if (left->stat.period == right->stat.period)
+		return 0;
+	return left->stat.period > right->stat.period ? 1 : -1;
+}
+
+static int64_t
+hist_entry__cmp_delta(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA);
+}
+
+static int64_t
+hist_entry__cmp_ratio(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO);
+}
+
+static int64_t
+hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
+}
+
 static void insert_hist_entry_by_compute(struct rb_root *root,
 					 struct hist_entry *he,
 					 int c)
@@ -1038,27 +1074,35 @@ static void data__hpp_register(struct data__file *d, int idx)
 	fmt->header = hpp__header;
 	fmt->width  = hpp__width;
 	fmt->entry  = hpp__entry_global;
+	fmt->cmp    = hist_entry__cmp_nop;
+	fmt->collapse = hist_entry__cmp_nop;
 
 	/* TODO more colors */
 	switch (idx) {
 	case PERF_HPP_DIFF__BASELINE:
 		fmt->color = hpp__color_baseline;
+		fmt->sort  = hist_entry__cmp_baseline;
 		break;
 	case PERF_HPP_DIFF__DELTA:
 		fmt->color = hpp__color_delta;
+		fmt->sort  = hist_entry__cmp_delta;
 		break;
 	case PERF_HPP_DIFF__RATIO:
 		fmt->color = hpp__color_ratio;
+		fmt->sort  = hist_entry__cmp_ratio;
 		break;
 	case PERF_HPP_DIFF__WEIGHTED_DIFF:
 		fmt->color = hpp__color_wdiff;
+		fmt->sort  = hist_entry__cmp_wdiff;
 		break;
 	default:
+		fmt->sort  = hist_entry__cmp_nop;
 		break;
 	}
 
 	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
+	perf_hpp__register_sort_field(fmt);
 }
 
 static void ui_init(void)
-- 
1.9.3

