Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3H3S7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:59:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/15] perf tools: Add missing 'abi' member to 'struct regs_dump'
Date: Fri, 30 Aug 2013 15:58:51 -0300
Message-Id: <1377889138-8793-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

And store the parsed value there.  Note that the 'abi' is 0 (no
registers), 1 (32-bit registers) or 2 (64-bit registers), but the
registers are anyway copied one-by-one as 64-bit values onto the event
i.e. see 'perf_output_sample_regs()'

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h | 1 +
 tools/perf/util/evsel.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4913339..f959801 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -62,6 +62,7 @@ struct sample_event {
 };
 
 struct regs_dump {
+	u64 abi;
 	u64 *regs;
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index db4e431..1184188 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,13 +1416,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		u64 avail;
-
 		/* First u64 tells us if we have any regs in sample. */
 		OVERFLOW_CHECK_u64(array);
-		avail = *array++;
+		data->user_regs.abi = *array;
+		array++;
 
-		if (avail) {
+		if (data->user_regs.abi) {
 			u64 regs_user = evsel->attr.sample_regs_user;
 
 			sz = hweight_long(regs_user) * sizeof(u64);
-- 
1.8.1.4

