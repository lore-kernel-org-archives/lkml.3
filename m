Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365Ab3GRUGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:06:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab3GRTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/76] perf util: Parse header_page to get proper long size
Date: Thu, 18 Jul 2013 16:49:15 -0300
Message-Id: <1374177003-3706-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The header_page file describes the format of the ring buffer page
which is used by ftrace (not perf).  And size of "commit" field (I
guess it's older name was 'size') represents the real size of long
type used for kernel.  So update the pevent's long size.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-12-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index fa45fca..f211227 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -212,6 +212,7 @@ static int read_ftrace_printk(struct pevent *pevent)
 static int read_header_files(struct pevent *pevent)
 {
 	unsigned long long size;
+	char *header_page;
 	char buf[BUFSIZ];
 	int ret = 0;
 
@@ -224,7 +225,26 @@ static int read_header_files(struct pevent *pevent)
 	}
 
 	size = read8(pevent);
-	skip(size);
+
+	header_page = malloc(size);
+	if (header_page == NULL)
+		return -1;
+
+	if (do_read(header_page, size) < 0) {
+		pr_debug("did not read header page");
+		free(header_page);
+		return -1;
+	}
+
+	if (!pevent_parse_header_page(pevent, header_page, size,
+				      pevent_get_long_size(pevent))) {
+		/*
+		 * The commit field in the page is of type long,
+		 * use that instead, since it represents the kernel.
+		 */
+		pevent_set_long_size(pevent, pevent->header_page_size_size);
+	}
+	free(header_page);
 
 	if (do_read(buf, 13) < 0)
 		return -1;
-- 
1.8.1.4

