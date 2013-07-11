Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3GKP3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab3GKP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:29:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/5] perf tools: Remove event types from perf data file
Date: Thu, 11 Jul 2013 17:28:31 +0200
Message-Id: <1373556513-3000-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing event types data storing/reading to/from perf
data file as it's no longer needed. The only user of
this data 'perf timechart' was switched to use tracepoints
handler callbacks.

The event_types offset and size stay in the perf data
file header but are ignored from now on.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

