Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AXUcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:32:43 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54060
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854Ab3AXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/74] perf tests: Add event parsing test for '*:*' tracepoints
Date: Thu, 24 Jan 2013 17:07:23 -0300
Message-Id: <1359058103-31645-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding event parsing test for '*:*' tracepoints. Checking the count
matches all the tracepoints available plus current standard tracepoint
perf_event_attr check.

This test exposes warnings from traceevent lib about not being able to
parse some tracepoints' format data. Exposing these messages in the
automated test suite will probably speed up the fix ;-)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355749718-4355-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 294ffdd..e7eb708 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
+#include "debugfs.h"
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
@@ -782,6 +783,63 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	return 0;
 }
 
+static int count_tracepoints(void)
+{
+	char events_path[PATH_MAX];
+	struct dirent *events_ent;
+	DIR *events_dir;
+	int cnt = 0;
+
+	scnprintf(events_path, PATH_MAX, "%s/tracing/events",
+		  debugfs_find_mountpoint());
+
+	events_dir = opendir(events_path);
+
+	TEST_ASSERT_VAL("Can't open events dir", events_dir);
+
+	while ((events_ent = readdir(events_dir))) {
+		char sys_path[PATH_MAX];
+		struct dirent *sys_ent;
+		DIR *sys_dir;
+
+		if (!strcmp(events_ent->d_name, ".")
+		    || !strcmp(events_ent->d_name, "..")
+		    || !strcmp(events_ent->d_name, "enable")
+		    || !strcmp(events_ent->d_name, "header_event")
+		    || !strcmp(events_ent->d_name, "header_page"))
+			continue;
+
+		scnprintf(sys_path, PATH_MAX, "%s/%s",
+			  events_path, events_ent->d_name);
+
+		sys_dir = opendir(sys_path);
+		TEST_ASSERT_VAL("Can't open sys dir", sys_dir);
+
+		while ((sys_ent = readdir(sys_dir))) {
+			if (!strcmp(sys_ent->d_name, ".")
+			    || !strcmp(sys_ent->d_name, "..")
+			    || !strcmp(sys_ent->d_name, "enable")
+			    || !strcmp(sys_ent->d_name, "filter"))
+				continue;
+
+			cnt++;
+		}
+
+		closedir(sys_dir);
+	}
+
+	closedir(events_dir);
+	return cnt;
+}
+
+static int test__all_tracepoints(struct perf_evlist *evlist)
+{
+	TEST_ASSERT_VAL("wrong events count",
+			count_tracepoints() == evlist->nr_entries);
+
+	return test__checkevent_tracepoint_multi(evlist);
+}
+
 struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -921,6 +979,10 @@ static struct test__event_st test__events[] = {
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
 	},
+	[33] = {
+		.name  = "*:*",
+		.check = test__all_tracepoints,
+	},
 };
 
 static struct test__event_st test__events_pmu[] = {
-- 
1.8.1.1.361.gec3ae6e

