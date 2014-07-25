Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbaGYPjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:39:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:35298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934747AbaGYPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:39:15 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/27] perf record: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds
Date: Fri, 25 Jul 2014 12:37:09 -0300
Message-Id: <1406302629-11790-28-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Currently we store PERF_RECORD_FINISHED_ROUND event each time
we go throught mmap buffers no matter if it contains any data,
which is useless.

Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
time we finished the round AND wrote at least one event.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406300177-31805-19-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

