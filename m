Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3JJC2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:28:42 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:53146 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3JJC2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:28:41 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] tools/perf/util: Fix memory leak in trace-event-info.c
Date: Wed,  9 Oct 2013 23:28:55 -0300
Message-Id: <1381372135-4408-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a memory leak on tracing_data_get() function when returning NULL explicitly

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 tools/perf/util/trace-event-info.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index f3c9e55..06f8624 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
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
@@ -569,6 +569,10 @@ out:

 	put_tracepoints_path(tps);
 	return tdata;
+
+err_tdata:
+	free(tdata);
+	return NULL;
 }

 int tracing_data_put(struct tracing_data *tdata)
--
1.7.10.4

