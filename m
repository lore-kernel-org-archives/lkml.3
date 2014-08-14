Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaHNIvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:51:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaHNIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:51:43 -0400
Date: Thu, 14 Aug 2014 01:50:49 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5a52f33adf02a3e5eafdc1e597a3fe172e620bec@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-15-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-15-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Add perf_session__peek_event()
Git-Commit-ID: 5a52f33adf02a3e5eafdc1e597a3fe172e620bec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a52f33adf02a3e5eafdc1e597a3fe172e620bec
Gitweb:     http://git.kernel.org/tip/5a52f33adf02a3e5eafdc1e597a3fe172e620bec
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:57 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:21:44 -0300

perf session: Add perf_session__peek_event()

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
index 7e27f1e..1b383bd 100644
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
index 0630e65..8dd41ca 100644
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
