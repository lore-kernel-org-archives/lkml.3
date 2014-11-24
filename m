Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaKXQSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:18:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:18110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbaKXQST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:18:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,449,1413270000"; 
   d="scan'208";a="613180664"
From: Kan Liang <kan.liang@intel.com>
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 2/3] perf tool: new function to compare build_ids
Date: Mon, 24 Nov 2014 11:00:28 -0500
Message-Id: <1416844829-26945-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

New function to compare the build_ids between different DSOs

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/dso.c | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..e53ce26 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1087,3 +1087,36 @@ enum dso_type dso__type(struct dso *dso, struct machine *machine)
 
 	return dso__type_fd(fd);
 }
+
+bool dsos__build_ids_equal(struct dsos *dsos_a, struct dsos *dsos_b)
+{
+	bool ret;
+	struct dso *dso_a, *dso_b;
+
+	list_for_each_entry(dso_a, &dsos_a->head, node) {
+		dso_b = dsos__find(dsos_b, dso_a->long_name, false);
+		if (dso_b == NULL)
+			return false;
+
+		if (memcmp(dso_a->build_id, dso_b->build_id, sizeof(dso_a->build_id)))
+			return false;
+
+		/* Mark that we compared this one */
+		dso_b->visited = 1;
+	}
+
+	/*
+	 * Now check if there are dsos in dsos_b that are not in
+	 * dsos_a
+	 */
+
+	ret = true;
+	list_for_each_entry(dso_b, &dsos_b->head, node) {
+		if (!dso_b->visited)
+			ret = false;
+		else
+			dso_b->visited = 0;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3782c82..371f826 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -117,6 +117,7 @@ struct dso {
 	u8		 has_build_id:1;
 	u8		 has_srcline:1;
 	u8		 hit:1;
+	u8		 visited:1;
 	u8		 annotate_warned:1;
 	u8		 short_name_allocated:1;
 	u8		 long_name_allocated:1;
@@ -278,4 +279,6 @@ void dso__free_a2l(struct dso *dso);
 
 enum dso_type dso__type(struct dso *dso, struct machine *machine);
 
+bool dsos__build_ids_equal(struct dsos *dsos_a, struct dsos *dsos_b);
+
 #endif /* __PERF_DSO */
-- 
1.8.3.2

