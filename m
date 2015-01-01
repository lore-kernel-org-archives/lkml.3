Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbbAARri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:47:38 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:58824 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbbAARrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:47:37 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: session:  Remove unused function
Date: Thu,  1 Jan 2015 18:50:36 +0100
Message-Id: <1420134636-842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function perf_session__peek_event() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/session.c |   55 ---------------------------------------------
 tools/perf/util/session.h |    5 -----
 2 files changed, 60 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac2..f861788 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -902,61 +902,6 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-int perf_session__peek_event(struct perf_session *session, off_t file_offset,
-			     void *buf, size_t buf_sz,
-			     union perf_event **event_ptr,
-			     struct perf_sample *sample)
-{
-	union perf_event *event;
-	size_t hdr_sz, rest;
-	int fd;
-
-	if (session->one_mmap && !session->header.needs_swap) {
-		event = file_offset - session->one_mmap_offset +
-			session->one_mmap_addr;
-		goto out_parse_sample;
-	}
-
-	if (perf_data_file__is_pipe(session->file))
-		return -1;
-
-	fd = perf_data_file__fd(session->file);
-	hdr_sz = sizeof(struct perf_event_header);
-
-	if (buf_sz < hdr_sz)
-		return -1;
-
-	if (lseek(fd, file_offset, SEEK_SET) == (off_t)-1 ||
-	    readn(fd, &buf, hdr_sz) != (ssize_t)hdr_sz)
-		return -1;
-
-	event = (union perf_event *)buf;
-
-	if (session->header.needs_swap)
-		perf_event_header__bswap(&event->header);
-
-	if (event->header.size < hdr_sz)
-		return -1;
-
-	rest = event->header.size - hdr_sz;
-
-	if (readn(fd, &buf, rest) != (ssize_t)rest)
-		return -1;
-
-	if (session->header.needs_swap)
-		event_swap(event, perf_evlist__sample_id_all(session->evlist));
-
-out_parse_sample:
-
-	if (sample && event->header.type < PERF_RECORD_USER_TYPE_START &&
-	    perf_evlist__parse_sample(session->evlist, event, sample))
-		return -1;
-
-	*event_ptr = event;
-
-	return 0;
-}
-
 static s64 perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a4be851..1d60297 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -44,11 +44,6 @@ void perf_session__delete(struct perf_session *session);
 
 void perf_event_header__bswap(struct perf_event_header *hdr);
 
-int perf_session__peek_event(struct perf_session *session, off_t file_offset,
-			     void *buf, size_t buf_sz,
-			     union perf_event **event_ptr,
-			     struct perf_sample *sample);
-
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size, u64 size,
 				   struct perf_tool *tool);
-- 
1.7.10.4

