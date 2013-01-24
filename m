Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3AXSto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:49:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:49:41 -0500
Date: Thu, 24 Jan 2013 10:49:13 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-823254edc66eb44bf612b1dfa4829afa9840f691@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1354171126-14387-4-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Convert to _is_group_leader method
Git-Commit-ID: 823254edc66eb44bf612b1dfa4829afa9840f691
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:49:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  823254edc66eb44bf612b1dfa4829afa9840f691
Gitweb:     http://git.kernel.org/tip/823254edc66eb44bf612b1dfa4829afa9840f691
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 29 Nov 2012 15:38:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf evsel: Convert to _is_group_leader method

Convert perf_evsel__is_group_member to perf_evsel__is_group_leader.
This is because the most usecases are using negative form to check
whether the given evsel is a leader or not and it's IMHO somewhat
ambiguous - leader also *is* a member of the group.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1354171126-14387-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c       |  2 +-
 tools/perf/tests/parse-events.c | 20 ++++++++++----------
 tools/perf/util/evlist.c        |  4 ++--
 tools/perf/util/evsel.c         |  6 +++---
 tools/perf/util/evsel.h         |  4 ++--
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c247fac..c12655a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -153,7 +153,7 @@ retry:
 	}
 
 	if (!perf_target__has_task(&target) &&
-	    !perf_evsel__is_group_member(evsel)) {
+	    perf_evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 32ee478..294ffdd 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -521,7 +521,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -557,7 +557,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -583,7 +583,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	return 0;
 }
@@ -606,7 +606,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group1"));
 
@@ -636,7 +636,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group2"));
 
@@ -663,7 +663,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	return 0;
 }
@@ -687,7 +687,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -724,7 +724,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -751,7 +751,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -777,7 +777,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
+	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 
 	return 0;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 90db2a1..d0e1e82 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -221,7 +221,7 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (perf_evsel__is_group_member(pos))
+			if (!perf_evsel__is_group_leader(pos))
 				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -237,7 +237,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (perf_evsel__is_group_member(pos))
+			if (!perf_evsel__is_group_leader(pos))
 				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7e93418..bb58b05 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -520,14 +520,14 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 * Disabling only independent events or group leaders,
 	 * keeping group members enabled.
 	 */
-	if (!perf_evsel__is_group_member(evsel))
+	if (perf_evsel__is_group_leader(evsel))
 		attr->disabled = 1;
 
 	/*
 	 * Setting enable_on_exec for independent events and
 	 * group leaders for traced executed by perf.
 	 */
-	if (perf_target__none(&opts->target) && !perf_evsel__is_group_member(evsel))
+	if (perf_target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
 		attr->enable_on_exec = 1;
 }
 
@@ -708,7 +708,7 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	struct perf_evsel *leader = evsel->leader;
 	int fd;
 
-	if (!perf_evsel__is_group_member(evsel))
+	if (perf_evsel__is_group_leader(evsel))
 		return -1;
 
 	/*
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index cbf6d97..3f7ff47 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -226,8 +226,8 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
 
-static inline bool perf_evsel__is_group_member(const struct perf_evsel *evsel)
+static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
-	return evsel->leader != evsel;
+	return evsel->leader == evsel;
 }
 #endif /* __PERF_EVSEL_H */
