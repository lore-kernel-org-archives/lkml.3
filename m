Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaG3XZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:25:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:14663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaG3XW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="577941253"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/10] perf, tools: Add a new pmu interface to iterate over all events
Date: Wed, 30 Jul 2014 16:22:48 -0700
Message-Id: <1406762570-16694-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
References: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With calling a callback. To be used in test code added in the next
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/pmu.c | 18 ++++++++++++++++++
 tools/perf/util/pmu.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8714f9a..397e400 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -869,3 +869,21 @@ bool pmu_have_event(const char *pname, const char *name)
 	}
 	return false;
 }
+
+int pmu_iterate_events(int (*func)(const char *pmu, const char *name))
+{
+	int ret = 0;
+	struct perf_pmu *pmu;
+	struct perf_pmu_alias *alias;
+
+	perf_pmu__find("cpu"); /* Load PMUs */
+	pmu = NULL;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
+		list_for_each_entry(alias, &pmu->aliases, list) {
+			ret = func(pmu->name, alias->name);
+			if (ret != 0)
+				break;
+		}
+	}
+	return ret;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 583d21e..87a1da4 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -47,5 +47,7 @@ bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
 
+int pmu_iterate_events(int (*func)(const char *, const char *name));
+
 extern const char *json_file;
 #endif /* __PMU_H */
-- 
1.9.3

