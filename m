Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3EINdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3EINc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:32:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/9] perf tools: Set maximum precise value for event 'p' modifier
Date: Thu,  9 May 2013 15:32:20 +0200
Message-Id: <1368106344-23383-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If single 'p' modifier is specified for event, set the
system precise value for perf_events_attr::precise_ip.

If more than a single 'p' is specified keep the intended
value.

If precise is not supported by system, warning is disaplyed.

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
 tools/perf/util/parse-events.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2e3ef10..6be4599 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -533,6 +533,26 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, NULL);
 }
 
+static int precise_default(void)
+{
+	int precise = perf_precise__get();
+	static int warned;
+
+	/*
+	 * Precise info not supported by by this kernel,
+	 * set 1 as the precise value.
+	 */
+	if (precise == -1)
+		precise = 1;
+
+	/* PEBS is not supported here, display warning. */
+	if (precise == 0 && !warned++)
+		pr_warning("warning: no precise support, "
+			   "using non-precise event(s)\n");
+
+	return precise;
+}
+
 static int config_term(struct perf_event_attr *attr,
 		       struct parse_events_term *term)
 {
@@ -701,7 +721,12 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int eh = evsel ? evsel->attr.exclude_hv : 0;
 	int eH = evsel ? evsel->attr.exclude_host : 0;
 	int eG = evsel ? evsel->attr.exclude_guest : 0;
-	int precise = evsel ? evsel->attr.precise_ip : 0;
+	/*
+	 * No previous state setup for precise,
+	 * let's start from 0 and get incremented
+	 * for both (evsel?) cases.
+	 */
+	int precise = 0;
 	int sample_read = 0;
 
 	int exclude = eu | ek | eh;
@@ -810,7 +835,18 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_user   = mod.eu;
 		evsel->attr.exclude_kernel = mod.ek;
 		evsel->attr.exclude_hv     = mod.eh;
-		evsel->attr.precise_ip     = mod.precise;
+
+		/*
+		 * Let the group precise modifier (if any) overwrite the
+		 * event modifier.
+		 */
+		if (mod.precise) {
+			if (mod.precise > 1)
+				evsel->attr.precise_ip = mod.precise;
+			else
+				evsel->attr.precise_ip = precise_default();
+		}
+
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
-- 
1.7.11.7

