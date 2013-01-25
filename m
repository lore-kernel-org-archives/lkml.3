Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3AYLEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:04:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:04:19 -0500
Date: Fri, 25 Jan 2013 03:03:45 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-82ce75d93335f7079afc17fb7f2a4e549d2fbecb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1355749718-4355-4-git-send-email-jolsa@redhat.com>
References: <1355749718-4355-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add event parsing test for '*:*'
  tracepoints
Git-Commit-ID: 82ce75d93335f7079afc17fb7f2a4e549d2fbecb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:03:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82ce75d93335f7079afc17fb7f2a4e549d2fbecb
Gitweb:     http://git.kernel.org/tip/82ce75d93335f7079afc17fb7f2a4e549d2fbecb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 17 Dec 2012 14:08:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:10 -0300

perf tests: Add event parsing test for '*:*' tracepoints

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
