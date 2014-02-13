Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaBMVQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:16:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55909 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaBMVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly
Date: Thu, 13 Feb 2014 18:15:58 -0300
Message-Id: <1392326161-30579-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392326161-30579-1-git-send-email-acme@infradead.org>
References: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

We removed event types from data file in following commits:

  6065210 perf tools: Remove event types framework completely
  44b3c57 perf tools: Remove event types from perf data file

We no longer need this information, because we can get it directly from
tracepoints.

But we still need to handle PERF_RECORD_HEADER_EVENT_TYPE event for the
sake of old perf data files created in pipe mode like:

  $ perf.3.4 record -o - foo >perf.data
  $ perf.312 report -i - < perf.data

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391524668-12546-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0b39a48e5110..5da6ce74c676 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1008,6 +1008,12 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		if (err == 0)
 			perf_session__set_id_hdr_size(session);
 		return err;
+	case PERF_RECORD_HEADER_EVENT_TYPE:
+		/*
+		 * Depreceated, but we need to handle it for sake
+		 * of old data files create in pipe mode.
+		 */
+		return 0;
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(fd, file_offset, SEEK_SET);
-- 
1.8.1.4

