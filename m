Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaIXUvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:51:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:15173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbaIXUvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391142124"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>, brendan.d.gregg@gmail.com
Subject: [PATCH 2/2] perf tools: apply -F filter to all previous events
Date: Wed, 24 Sep 2014 13:51:09 -0700
Message-Id: <1411591869-325-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411591869-325-1-git-send-email-andi@firstfloor.org>
References: <1411591869-325-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Right now you would need to duplicate the filter definition
for every trace point event. Instead apply it to each previous
one that did not have its own filter. If you have some tracepoint
events you don't want to give filter you can put them after the
last one.

Cc: brendan.d.gregg@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c | 48 +++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9c4bab8..9bf4173 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -962,23 +962,12 @@ int parse_events_option(const struct option *opt, const char *str,
 	return ret;
 }
 
-int parse_filter(const struct option *opt, const char *str,
-		 int unset __maybe_unused)
+static char *gen_filter(const char *str)
 {
-	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
-	struct perf_evsel *last = NULL;
 	char *pid, buf[30], *o;
 	int len, plen;
 	const char *p;
-
-	if (evlist->nr_entries > 0)
-		last = perf_evlist__last(evlist);
-
-	if (last == NULL || last->attr.type != PERF_TYPE_TRACEPOINT) {
-		fprintf(stderr,
-			"-F option should follow a -e tracepoint option\n");
-		return -1;
-	}
+	char *filter;
 
 	plen = sprintf(buf, "%d", getpid());
 	len = strlen(str) + 1;
@@ -987,13 +976,13 @@ int parse_filter(const struct option *opt, const char *str,
 		len += plen - 8;
 	}
 
-	last->filter = malloc(len);
-	if (last->filter == NULL) {
+	filter = malloc(len);
+	if (filter == NULL) {
 		fprintf(stderr, "not enough memory to hold filter string\n");
-		return -1;
+		return NULL;
 	}
 
-	o = last->filter;
+	o = filter;
 	for (p = str; *p; ) {
 		if (*p == 'P' && !strncmp(p, "PERF_PID", 8)) {
 			strcpy(o, buf);
@@ -1002,6 +991,31 @@ int parse_filter(const struct option *opt, const char *str,
 		} else
 			*o++ = *p++;
 	}
+	return filter;
+}
+
+int parse_filter(const struct option *opt, const char *str,
+		 int unset __maybe_unused)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	struct perf_evsel *evsel;
+	int nr_tp = 0;
+
+	evlist__for_each(evlist, evsel) {
+		if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
+			!evsel->filter) {
+			evsel->filter = gen_filter(str);
+			if (!evsel->filter)
+				return -1;
+			nr_tp++;
+		}
+	}
+
+	if (nr_tp == 0) {
+		fprintf(stderr,
+			"-F option should follow a -e tracepoint option\n");
+		return -1;
+	}
 	return 0;
 }
 
-- 
1.9.3

