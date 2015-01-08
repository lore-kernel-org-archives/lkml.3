Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbbAHJxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:53:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbbAHJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:53:29 -0500
Date: Thu, 8 Jan 2015 01:53:10 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e7024fc3783317608b8e07048116a72a7d1cd26d@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@kernel.org,
        acme@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, jolsa@redhat.com
Reply-To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        mingo@kernel.org, acme@redhat.com, namhyung@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, jolsa@redhat.com
In-Reply-To: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf diff:
  Fix to sort by baseline field by default
Git-Commit-ID: e7024fc3783317608b8e07048116a72a7d1cd26d
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

Commit-ID:  e7024fc3783317608b8e07048116a72a7d1cd26d
Gitweb:     http://git.kernel.org/tip/e7024fc3783317608b8e07048116a72a7d1cd26d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 27 Dec 2014 14:06:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Jan 2015 23:27:18 -0300

perf diff: Fix to sort by baseline field by default

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
index 303c1e1..1fd96c1 100644
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
