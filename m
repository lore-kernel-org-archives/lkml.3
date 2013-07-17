Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab3GQRv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811Ab3GQRvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 17/23] perf tools: Get rid of post_processing_offset in record command
Date: Wed, 17 Jul 2013 19:49:57 +0200
Message-Id: <1374083403-14591-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use post_processing_offset variable now when
we know where the data starts.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fcd0baf..b67564c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -75,7 +75,6 @@ struct perf_record {
 	bool			no_buildid;
 	bool			no_buildid_cache;
 	long			samples;
-	off_t			post_processing_offset;
 };
 
 static void advance_output(struct perf_record *rec, size_t size)
@@ -253,15 +252,17 @@ out:
 
 static int process_buildids(struct perf_record *rec)
 {
-	u64 size = lseek(rec->output, 0, SEEK_CUR);
+	struct perf_session *session = rec->session;
+	u64 data_offset              = PERF_FILE_HEADER__DATA_OFFSET;
+	u64 size                     = session->header.data_size;
 
 	if (size == 0)
 		return 0;
 
 	rec->session->fd = rec->output;
-	return __perf_session__process_events(rec->session, rec->post_processing_offset,
-					      size - rec->post_processing_offset,
-					      size, &build_id__mark_dso_hit_ops);
+	return __perf_session__process_events(session, data_offset,
+					      size - data_offset, size,
+					      &build_id__mark_dso_hit_ops);
 }
 
 static void perf_record__exit(int status, void *arg)
@@ -461,8 +462,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
-	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
-
 	machine = &session->machines.host;
 
 	if (opts->pipe_output) {
-- 
1.7.11.7

