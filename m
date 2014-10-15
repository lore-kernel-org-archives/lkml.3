Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaJOUxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:53:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:35482 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaJOUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:53:29 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/15] perf test: Add test case for pmu event new style format
Date: Wed, 15 Oct 2014 17:52:40 -0300
Message-Id: <1413406368-26245-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413406368-26245-1-git-send-email-acme@kernel.org>
References: <1413406368-26245-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Add test case in automated tests suite. It checks not only the two types
of pmu event stytle formats "pmu_event_name" and "cpu/pmu_event_name/",
but also the different formats mixtures which are more likely to trigger
parse issue.

The patch set including this one has been tested by the perf automated
test:

   ./perf test parse -v"

On haswell, ivybridge and Romley platform.

The patch set also has been tested on haswell by the following script.

Note: please make sure that your test system support TSX and
L1-dcache-loads events. Otherwise, you may want to change the events to
other pmu events.

  [lk@localhost ~]$ cat perf_style_test.sh
  # hardware events + kernel pmu event with different style
  perf stat -x, -e cycles,mem-stores,tx-start sleep 2
  perf stat -x, -e cpu-cycles,cycles-ct,cycles-t sleep 2
  perf stat -x, -e cycles,cpu/cycles-ct/,cpu/cycles-t/ sleep 2
  perf stat -x, -e instructions,cpu/tx-start/ sleep 2
  perf stat -x, -e '{cycles,tx-start}' sleep 2
  perf stat -x, -e '{cycles,cpu/tx-start/}' sleep 2

  # HW Cache event + kernel pmu event with different style
  perf stat -x, -e L1-dcache-loads,cpu/mem-stores/,tx-start sleep 2
  perf stat -x, -e L1-dcache-loads,mem-stores,cpu/tx-start/ sleep 2
  perf stat -x, -e '{L1-dcache-loads,mem-stores}' sleep 2
  perf stat -x, -e '{L1-dcache-loads,cpu/tx-start/}' sleep 2

  # Raw event + kernel pmu event with different style:
  perf stat -x, -e cpu/event=0xc0,umask=0x00/,mem-loads,cpu/mem-stores/ sleep 2
  perf stat -x, -e cpu/event=0xc0,umask=0x00/,tx-start,cpu/el-start/ sleep 2
  perf stat -x, -e '{cpu/event=0xc0,umask=0x00/,tx-start}' sleep 2

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1412694532-23391-5-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 5941927a4b7f..7f2f51f93619 100644
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
1.9.3

