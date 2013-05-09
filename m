Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3EINd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab3EINdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:33:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/9] perf tools: Set maximum precise value for 'precise' term
Date: Thu,  9 May 2013 15:32:21 +0200
Message-Id: <1368106344-23383-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if the term is specified without any value like
-e 'cpu/...,precise,../', the number '1' is assigned as
its default value.

Adding special treatment for 'precise' term to use the
maximum allowed precise value in such case using the
perf_precise__get function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c | 29 ++++++++++++++++++++++++++---
 tools/perf/util/parse-events.h |  2 ++
 tools/perf/util/parse-events.y |  2 +-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6be4599..5297c44 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -590,9 +590,14 @@ do {								\
 		break;
 	case PARSE_EVENTS__TERM_TYPE_PRECISE:
 		CHECK_TYPE_VAL(NUM);
-		if ((unsigned)term->val.num > 2)
-			return -EINVAL;
-		attr->precise_ip = term->val.num;
+		/* No value specified, try to get it from sysfs. */
+		if (term->val.num == (u64) -1)
+			attr->precise_ip = precise_default();
+		else {
+			if ((unsigned)term->val.num > 2)
+				return -EINVAL;
+			attr->precise_ip = term->val.num;
+		}
 		break;
 	default:
 		return -EINVAL;
@@ -1245,6 +1250,24 @@ int parse_events_term__num(struct parse_events_term **term,
 			config, NULL, num);
 }
 
+int parse_events_term__num_default(struct parse_events_term **term,
+				   int type_term, char *config)
+{
+	/*
+	 * If no value is specified for term, we use 1 as default.
+	 * The PRECISE term is an exception, because we force special
+	 * functionality when there's no value specified for it,
+	 * so we need to recognize it.
+	 */
+	u64 num = 1;
+
+	if (type_term == PARSE_EVENTS__TERM_TYPE_PRECISE)
+		num = (u64) -1;
+
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
+			config, NULL, num);
+}
+
 int parse_events_term__str(struct parse_events_term **term,
 			   int type_term, char *config, char *str)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 13d7c66..6810397 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -75,6 +75,8 @@ struct parse_events_terms {
 int parse_events__is_hardcoded_term(struct parse_events_term *term);
 int parse_events_term__num(struct parse_events_term **_term,
 			   int type_term, char *config, u64 num);
+int parse_events_term__num_default(struct parse_events_term **term,
+				   int type_term, char *config);
 int parse_events_term__str(struct parse_events_term **_term,
 			   int type_term, char *config, char *str);
 int parse_events_term__sym_hw(struct parse_events_term **term,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index afc44c1..da77510 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -408,7 +408,7 @@ PE_TERM
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, (int)$1, NULL, 1));
+	ABORT_ON(parse_events_term__num_default(&term, (int)$1, NULL));
 	$$ = term;
 }
 
-- 
1.7.11.7

