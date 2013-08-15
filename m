Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab3HOH5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3HOH4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:47 -0400
Date: Thu, 15 Aug 2013 00:56:14 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-93ea01c29d4ed5a9fcf6d9a95bc584e54a420834@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-17-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-17-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Change perf_session__has_traces to actually check for tracepoints
Git-Commit-ID: 93ea01c29d4ed5a9fcf6d9a95bc584e54a420834
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:56:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93ea01c29d4ed5a9fcf6d9a95bc584e54a420834
Gitweb:     http://git.kernel.org/tip/93ea01c29d4ed5a9fcf6d9a95bc584e54a420834
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:58 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:08 -0300

perf session: Change perf_session__has_traces to actually check for tracepoints

Any event can have RAW data attribute set. The intent of the function is
to determine if the session has tracepoints, so check for the type of
each event explicitly.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-17-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5a89964..4d9028e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1401,12 +1401,15 @@ int perf_session__process_events(struct perf_session *self,
 
 bool perf_session__has_traces(struct perf_session *session, const char *msg)
 {
-	if (!(perf_evlist__sample_type(session->evlist) & PERF_SAMPLE_RAW)) {
-		pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
-		return false;
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		if (evsel->attr.type == PERF_TYPE_TRACEPOINT)
+			return true;
 	}
 
-	return true;
+	pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
+	return false;
 }
 
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps,
