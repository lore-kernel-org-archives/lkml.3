Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbaGYO5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934299AbaGYO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:57:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/19] perf tools: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds
Date: Fri, 25 Jul 2014 16:56:16 +0200
Message-Id: <1406300177-31805-19-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we store PERF_RECORD_FINISHED_ROUND event each time
we go throught mmap buffers no matter if it contains any data,
which is useless.

Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
time we finished the round AND wrote at least one event.

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
 tools/perf/builtin-record.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4a1a54265b04..4869050e7194 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
 
 static int record__mmap_read_all(struct record *rec)
 {
+	u64 bytes_written = rec->bytes_written;
 	int i;
 	int rc = 0;
 
@@ -250,7 +251,12 @@ static int record__mmap_read_all(struct record *rec)
 		}
 	}
 
-	rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
+	/*
+	 * Mark the round finished in case we wrote
+	 * at least one event.
+	 */
+	if (bytes_written != rec->bytes_written)
+		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
 
 out:
 	return rc;
-- 
1.8.3.1

