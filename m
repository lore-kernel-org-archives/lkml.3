Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3JKBVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:21:51 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:53564 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3JKBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:21:49 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH v2] tools/perf/util: Fix memory leak in trace-event-info.c
Date: Thu, 10 Oct 2013 22:21:29 -0300
Message-Id: <1381454489-4135-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a memory leak on tracing_data_get() function when returning NULL explicitly

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 tools/perf/util/trace-event-info.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index f3c9e55..2a0c3c9 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -518,13 +518,15 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 			 "/tmp/perf-XXXXXX");
 		if (!mkstemp(tdata->temp_file)) {
 			pr_debug("Can't make temp file");
-			return NULL;
+			err = -1;
+			goto err_tdata;
 		}

 		temp_fd = open(tdata->temp_file, O_RDWR);
 		if (temp_fd < 0) {
 			pr_debug("Can't read '%s'", tdata->temp_file);
-			return NULL;
+			err = -1;
+			goto err_tdata;
 		}

 		/*
@@ -562,6 +564,7 @@ out:
 		output_fd = fd;
 	}

+err_tdata:
 	if (err) {
 		free(tdata);
 		tdata = NULL;
--
1.7.10.4

