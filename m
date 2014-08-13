Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaHMWvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:55662 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbaHMWvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:09 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/41] perf session: Add perf_session__peek_event()
Date: Wed, 13 Aug 2014 19:48:21 -0300
Message-Id: <1407970107-24540-36-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to peek at other events in the event stream.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-15-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |  5 +++++
 2 files changed, 60 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7e27f1eb260c..1b383bd93af6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -897,6 +897,61 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
+int perf_session__peek_event(struct perf_session *session, off_t file_offset,
+			     void *buf, size_t buf_sz,
+			     union perf_event **event_ptr,
+			     struct perf_sample *sample)
+{
+	union perf_event *event;
+	size_t hdr_sz, rest;
+	int fd;
+
+	if (session->one_mmap && !session->header.needs_swap) {
+		event = file_offset - session->one_mmap_offset +
+			session->one_mmap_addr;
+		goto out_parse_sample;
+	}
+
+	if (perf_data_file__is_pipe(session->file))
+		return -1;
+
+	fd = perf_data_file__fd(session->file);
+	hdr_sz = sizeof(struct perf_event_header);
+
+	if (buf_sz < hdr_sz)
+		return -1;
+
+	if (lseek(fd, file_offset, SEEK_SET) == (off_t)-1 ||
+	    readn(fd, &buf, hdr_sz) != (ssize_t)hdr_sz)
+		return -1;
+
+	event = (union perf_event *)buf;
+
+	if (session->header.needs_swap)
+		perf_event_header__bswap(&event->header);
+
+	if (event->header.size < hdr_sz)
+		return -1;
+
+	rest = event->header.size - hdr_sz;
+
+	if (readn(fd, &buf, rest) != (ssize_t)rest)
+		return -1;
+
+	if (session->header.needs_swap)
+		event_swap(event, perf_evlist__sample_id_all(session->evlist));
+
+out_parse_sample:
+
+	if (sample && event->header.type < PERF_RECORD_USER_TYPE_START &&
+	    perf_evlist__parse_sample(session->evlist, event, sample))
+		return -1;
+
+	*event_ptr = event;
+
+	return 0;
+}
+
 static s64 perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0630e658f8be..8dd41cad2d59 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,6 +45,11 @@ void perf_session__delete(struct perf_session *session);
 
 void perf_event_header__bswap(struct perf_event_header *hdr);
 
+int perf_session__peek_event(struct perf_session *session, off_t file_offset,
+			     void *buf, size_t buf_sz,
+			     union perf_event **event_ptr,
+			     struct perf_sample *sample);
+
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size, u64 size,
 				   struct perf_tool *tool);
-- 
1.9.3

