Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaGaGH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:07:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaGaGDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799953"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/31] perf session: Add perf_session__peek_event()
Date: Thu, 31 Jul 2014 09:00:57 +0300
Message-Id: <1406786474-9306-15-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to peek at other events in the
event stream.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |  5 +++++
 2 files changed, 60 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c831c04..da440dc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1086,6 +1086,61 @@ static void event_swap(union perf_event *event, bool sample_id_all)
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
index 86f1bb4..e4ea0cf5 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -58,6 +58,11 @@ void perf_session__delete(struct perf_session *session);
 
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
1.8.3.2

