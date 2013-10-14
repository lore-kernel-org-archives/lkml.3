Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3JNXsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:48:43 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:57374 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3JNXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:48:41 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH v3] tools/perf/util: Fix memory leak in trace-event-info.c
Date: Mon, 14 Oct 2013 20:48:24 -0300
Message-Id: <1381794504-4146-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a memory leak on tracing_data_get() function when returning NULL explicitly

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 tools/perf/util/trace-event-info.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index f3c9e55..83b3a67 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -496,7 +496,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 {
 	struct tracepoint_path *tps;
 	struct tracing_data *tdata;
-	int err;
+	int err = -1;

 	output_fd = fd;

@@ -506,7 +506,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,

 	tdata = malloc(sizeof(*tdata));
 	if (!tdata)
-		return NULL;
+		goto err_tps;

 	tdata->temp = temp;
 	tdata->size = 0;
@@ -518,13 +518,13 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 			 "/tmp/perf-XXXXXX");
 		if (!mkstemp(tdata->temp_file)) {
 			pr_debug("Can't make temp file");
-			return NULL;
+			goto err_tdata;
 		}

 		temp_fd = open(tdata->temp_file, O_RDWR);
 		if (temp_fd < 0) {
 			pr_debug("Can't read '%s'", tdata->temp_file);
-			return NULL;
+			goto err_tdata;
 		}

 		/*
@@ -562,11 +562,13 @@ out:
 		output_fd = fd;
 	}

+err_tdata:
 	if (err) {
 		free(tdata);
 		tdata = NULL;
 	}

+err_tps:
 	put_tracepoints_path(tps);
 	return tdata;
 }
--
1.7.10.4

