Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaJCQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:15:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:52029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbaJCQPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="395172447"
From: kan.liang@intel.com
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V7 4/4] perf tools: Add test case for pmu event new style format
Date: Fri,  3 Oct 2014 12:09:08 -0400
Message-Id: <1412352548-7603-5-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
References: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Add test case in automated tests suite. It checks not only the two types
of pmu event stytle formats "pmu_event_name" and "cpu/pmu_event_name/",
but also the different formats mixtures which are more likely to trigger
parse issue.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/tests/parse-events.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 5941927..7f2f51f 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -457,6 +457,36 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 	return 0;
 }
 
+
+static int test__checkevent_pmu_events_mix(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* pmu-event:u */
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	/* cpu/pmu-event/u*/
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	return 0;
+}
+
 static int test__checkterms_simple(struct list_head *terms)
 {
 	struct parse_events_term *term;
@@ -1554,6 +1584,12 @@ static int test_pmu_events(void)
 		e.check = test__checkevent_pmu_events;
 
 		ret = test_event(&e);
+		if (ret)
+			break;
+		snprintf(name, MAX_NAME, "%s:u,cpu/event=%s/u", ent->d_name, ent->d_name);
+		e.name  = name;
+		e.check = test__checkevent_pmu_events_mix;
+		ret = test_event(&e);
 #undef MAX_NAME
 	}
 
-- 
1.8.3.2

