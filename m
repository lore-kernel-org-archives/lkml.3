Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaFLWIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaFLWIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:08:52 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/17] perf tools: Always force PERF_RECORD_FINISHED_ROUND event
Date: Fri, 13 Jun 2014 00:08:17 +0200
Message-Id: <1402610913-19059-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PERF_RECORD_FINISHED_ROUND governs queue flushing in
reporting, so it needs to be stored for any kind of event.

Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
time we finish the round and wrote at least one event.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-record.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..4869050 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
 
 static int record__mmap_read_all(struct record *rec)
 {
+	u64 bytes_written = rec->bytes_written;
 	int i;
 	int rc = 0;
 
@@ -250,7 +251,11 @@ static int record__mmap_read_all(struct record *rec)
 		}
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
+	/*
+	 * Mark the round finished in case we wrote
+	 * at least one event.
+	 */
+	if (bytes_written != rec->bytes_written)
 		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
 
 out:
-- 
1.8.3.1

