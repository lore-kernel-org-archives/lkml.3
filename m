Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaLAPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:00:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:48570 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbaLAO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,494,1413270000"; 
   d="scan'208";a="640742608"
From: Kan Liang <kan.liang@intel.com>
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 2/3] perf tool: new function to compare common part of build-ids
Date: Mon,  1 Dec 2014 09:40:11 -0500
Message-Id: <1417444812-22063-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
References: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

New function to compare the build_ids between different DSOs
This function is only interested in the common part of build_ids.
For example, dsos_a includes DSO A and DSO B. dsos_b includes DSO B and
DSO C. Only DSO B's build_id will be compared.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---

Changes since V5:
 - Replace Arnaldo's dsos__build_ids_equal by bool dsos__build_ids_common_equal
 - Only compare the common part of build-ids

 tools/perf/util/dso.c | 20 ++++++++++++++++++++
 tools/perf/util/dso.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..04416b9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1087,3 +1087,23 @@ enum dso_type dso__type(struct dso *dso, struct machine *machine)
 
 	return dso__type_fd(fd);
 }
+
+bool dsos__build_ids_common_equal(struct dsos *dsos_a, struct dsos *dsos_b)
+{
+	struct dso *dso_a, *dso_b;
+
+	list_for_each_entry(dso_a, &dsos_a->head, node) {
+		dso_b = dsos__find(dsos_b, dso_a->short_name, true);
+		if (dso_b == NULL)
+			continue;
+		/*
+		 * Only compare the common part of dsos.
+		 */
+		if (dso_a->has_build_id && dso_b->has_build_id) {
+			if (memcmp(dso_a->build_id, dso_b->build_id, sizeof(dso_a->build_id)))
+				return false;
+		}
+	}
+
+	return true;
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3782c82..e92217c 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -278,4 +278,6 @@ void dso__free_a2l(struct dso *dso);
 
 enum dso_type dso__type(struct dso *dso, struct machine *machine);
 
+bool dsos__build_ids_common_equal(struct dsos *dsos_a, struct dsos *dsos_b);
+
 #endif /* __PERF_DSO */
-- 
1.8.3.2

