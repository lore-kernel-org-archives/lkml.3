Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3KGPbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:31:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3KGPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:31:39 -0500
Date: Thu, 7 Nov 2013 07:30:53 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-57706abc19afc60f0b629af839d2ebee17739f59@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383763297-27066-2-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Refactor feature handling into a separate function
Git-Commit-ID: 57706abc19afc60f0b629af839d2ebee17739f59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:31:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57706abc19afc60f0b629af839d2ebee17739f59
Gitweb:     http://git.kernel.org/tip/57706abc19afc60f0b629af839d2ebee17739f59
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 6 Nov 2013 11:41:34 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 10:42:26 -0300

perf record: Refactor feature handling into a separate function

Code move only. No logic changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383763297-27066-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ea4c04f..2932069 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -342,9 +342,28 @@ out:
 	return rc;
 }
 
+static void perf_record__init_features(struct perf_record *rec)
+{
+	struct perf_evlist *evsel_list = rec->evlist;
+	struct perf_session *session = rec->session;
+	int feat;
+
+	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
+		perf_header__set_feat(&session->header, feat);
+
+	if (rec->no_buildid)
+		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
+
+	if (!have_tracepoints(&evsel_list->entries))
+		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
+
+	if (!rec->opts.branch_stack)
+		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+}
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
-	int err, feat;
+	int err;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -371,17 +390,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->session = session;
 
-	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
-		perf_header__set_feat(&session->header, feat);
-
-	if (rec->no_buildid)
-		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
-
-	if (!have_tracepoints(&evsel_list->entries))
-		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
-
-	if (!rec->opts.branch_stack)
-		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+	perf_record__init_features(rec);
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
