Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJPFXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:23:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaJPFXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:23:18 -0400
Date: Wed, 15 Oct 2014 22:23:07 -0700
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-ffe59788e69b548bd62cc9a053253a8af2cdda1d@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        kan.liang@intel.com
Reply-To: ak@linux.intel.com, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, acme@redhat.com,
        kan.liang@intel.com, jolsa@redhat.com
In-Reply-To: <1412694532-23391-5-git-send-email-kan.liang@intel.com>
References: <1412694532-23391-5-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf test:
  Add test case for pmu event new style format
Git-Commit-ID: ffe59788e69b548bd62cc9a053253a8af2cdda1d
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

Commit-ID:  ffe59788e69b548bd62cc9a053253a8af2cdda1d
Gitweb:     http://git.kernel.org/tip/ffe59788e69b548bd62cc9a053253a8af2cdda1d
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 7 Oct 2014 11:08:52 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 16:10:24 -0300

perf test: Add test case for pmu event new style format

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
 
