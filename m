Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3GRT6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:58:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab3GRT4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:56:23 -0400
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
Subject: [PATCH 46/76] perf tools: Validate perf event header size
Date: Thu, 18 Jul 2013 16:49:33 -0300
Message-Id: <1374177003-3706-47-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The 'size' variable includes the header so must be at least
'sizeof(struct perf_event_header)'.  Error out immediately if that is
not the case.  Also don't byte-swap the header until it is actually
"fetched" from the mmap region.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6b71b88..951a1cf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1094,8 +1094,10 @@ more:
 		perf_event_header__bswap(&event->header);
 
 	size = event->header.size;
-	if (size == 0)
-		size = 8;
+	if (size < sizeof(struct perf_event_header)) {
+		pr_err("bad event header size\n");
+		goto out_err;
+	}
 
 	if (size > cur_size) {
 		void *new = realloc(buf, size);
@@ -1164,8 +1166,12 @@ fetch_mmaped_event(struct perf_session *session,
 	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	if (head + event->header.size > mmap_size)
+	if (head + event->header.size > mmap_size) {
+		/* We're not fetching the event so swap back again */
+		if (session->header.needs_swap)
+			perf_event_header__bswap(&event->header);
 		return NULL;
+	}
 
 	return event;
 }
@@ -1245,7 +1251,7 @@ more:
 
 	size = event->header.size;
 
-	if (size == 0 ||
+	if (size < sizeof(struct perf_event_header) ||
 	    perf_session__process_event(session, event, tool, file_pos) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
-- 
1.8.1.4

