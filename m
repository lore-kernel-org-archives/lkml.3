Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaGPUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:04:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaGPUDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:22 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 11/13] perf tools: Add a new pmu interface to iterate over all events
Date: Wed, 16 Jul 2014 22:02:47 +0200
Message-Id: <1405540969-18975-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With calling a callback. To be used in test code added in the next
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/n/1405123165-22666-10-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/pmu.c | 18 ++++++++++++++++++
 tools/perf/util/pmu.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8714f9a11abe..397e4004fcdf 100644
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
index 583d21e4cefb..87a1da471686 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -47,5 +47,7 @@ bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
 
+int pmu_iterate_events(int (*func)(const char *, const char *name));
+
 extern const char *json_file;
 #endif /* __PMU_H */
-- 
1.8.3.1

