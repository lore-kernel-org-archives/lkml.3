Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab3GRT4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:56:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477Ab3GRTu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 66/76] perf tools: Remove event types from perf data file
Date: Thu, 18 Jul 2013 16:49:53 -0300
Message-Id: <1374177003-3706-67-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing event types data storing/reading to/from perf data file as it's
no longer needed. The only user of this data 'perf timechart' was
switched to use tracepoints handler callbacks.

The event_types offset and size stay in the perf data file header but
are ignored from now on.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1373556513-3000-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 28 +---------------------------
 tools/perf/util/header.h |  3 +--
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d12d79c..8862667 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2334,16 +2334,6 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->event_offset = lseek(fd, 0, SEEK_CUR);
-	header->event_size = trace_event_count * sizeof(struct perf_trace_event_type);
-	if (trace_events) {
-		err = do_write(fd, trace_events, header->event_size);
-		if (err < 0) {
-			pr_debug("failed to write perf header events\n");
-			return err;
-		}
-	}
-
 	header->data_offset = lseek(fd, 0, SEEK_CUR);
 
 	if (at_exit) {
@@ -2364,10 +2354,7 @@ int perf_session__write_header(struct perf_session *session,
 			.offset = header->data_offset,
 			.size	= header->data_size,
 		},
-		.event_types = {
-			.offset = header->event_offset,
-			.size	= header->event_size,
-		},
+		/* event_types is ignored, store zeros */
 	};
 
 	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
@@ -2614,8 +2601,6 @@ int perf_file_header__read(struct perf_file_header *header,
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
 
-	ph->event_offset = header->event_types.offset;
-	ph->event_size   = header->event_types.size;
 	ph->data_offset  = header->data.offset;
 	ph->data_size	 = header->data.size;
 	return 0;
@@ -2839,17 +2824,6 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	symbol_conf.nr_events = nr_attrs;
 
-	if (f_header.event_types.size) {
-		lseek(fd, f_header.event_types.offset, SEEK_SET);
-		trace_events = malloc(f_header.event_types.size);
-		if (trace_events == NULL)
-			return -ENOMEM;
-		if (perf_header__getbuffer64(header, fd, trace_events,
-					     f_header.event_types.size))
-			goto out_errno;
-		trace_event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
-	}
-
 	perf_header__process_sections(header, fd, &session->pevent,
 				      perf_file_section__process);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2d1ca7d..298982f 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -45,6 +45,7 @@ struct perf_file_header {
 	u64				attr_size;
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
+	/* event_types is ignored */
 	struct perf_file_section	event_types;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
@@ -88,8 +89,6 @@ struct perf_header {
 	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
-	u64			event_offset;
-	u64			event_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env env;
 };
-- 
1.8.1.4

