Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753Ab3DQD7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 23:59:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52665 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730Ab3DQD7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 23:59:41 -0400
X-AuditID: 9c930179-b7bd8ae000004629-fa-516e1e2b68d6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 05/10] perf util: Parse header_page to get proper long size
Date: Wed, 17 Apr 2013 12:59:21 +0900
Message-Id: <1366171161-5353-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-6-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-6-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The header_page file describes the format of the ring buffer page
which is used by ftrace (not perf).  And size of "commit" field (I
guess it's older name was 'size') represents the real size of long
type used for kernel.  So update the pevent's long size.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
It should read into header_page not buf.

 tools/perf/util/trace-event-read.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index fa45fca2a2d3..f2112270c663 100644
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
1.7.11.7

