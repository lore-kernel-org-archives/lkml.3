Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaKXQS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:18:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:18110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaKXQST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:18:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,449,1413270000"; 
   d="scan'208";a="613180668"
From: Kan Liang <kan.liang@intel.com>
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 3/3] perf tool: check buildid for symoff
Date: Mon, 24 Nov 2014 11:00:29 -0500
Message-Id: <1416844829-26945-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

symoff can support both same binaries and different binaries. However,
the offset may be changed for different binaries. This patch checks the
buildid of perf.data. If they are from different binaries, print a
warning to notify the user.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++++
 tools/perf/util/sort.c    |  3 +++
 tools/perf/util/sort.h    |  1 +
 3 files changed, 29 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 03a4001..2a8c17a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -678,6 +678,28 @@ static void data__free(struct data__file *d)
 	}
 }
 
+static void buildid_check(void)
+{
+	struct dsos *base_k_dsos = &data__files[0].session->machines.host.kernel_dsos;
+	struct dsos *base_u_dsos = &data__files[0].session->machines.host.user_dsos;
+	struct dsos *k_dsos_tmp, *u_dsos_tmp;
+	struct data__file *d;
+	int i;
+
+	data__for_each_file_new(i, d) {
+		k_dsos_tmp = &d->session->machines.host.kernel_dsos;
+		u_dsos_tmp = &d->session->machines.host.user_dsos;
+
+		if (!dsos__build_ids_equal(base_k_dsos, k_dsos_tmp))
+			pr_warning("The perf.data come from different kernel. "
+				   "The kernel symbol offset may vary for different kernel.\n");
+
+		if (!dsos__build_ids_equal(base_u_dsos, u_dsos_tmp))
+			pr_warning("The perf.data come from different user binary. "
+				   "The user space symbol offset may vary for different binaries.\n");
+	}
+}
+
 static int __cmd_diff(void)
 {
 	struct data__file *d;
@@ -700,6 +722,9 @@ static int __cmd_diff(void)
 		perf_evlist__collapse_resort(d->session->evlist);
 	}
 
+	if (sort__has_symoff)
+		buildid_check();
+
 	data_process();
 
  out_delete:
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index e6583c9..c964cbc 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -21,6 +21,7 @@ int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
 int		sort__has_dso = 0;
+int		sort__has_symoff = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 
@@ -1493,6 +1494,7 @@ int sort_dimension__add(const char *tok)
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
 		} else if (sd->entry == &sort_symoff) {
+			sort__has_symoff = 1;
 			/*
 			 * For symoff sort key, not only the offset but also the
 			 * symbol name should be compared.
@@ -1877,6 +1879,7 @@ void reset_output_field(void)
 	sort__has_parent = 0;
 	sort__has_sym = 0;
 	sort__has_dso = 0;
+	sort__has_symoff = 0;
 
 	field_order = NULL;
 	sort_order = NULL;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index ea0122f..d2f9782 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -34,6 +34,7 @@ extern int have_ignore_callees;
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
+extern int sort__has_symoff;
 extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
-- 
1.8.3.2

