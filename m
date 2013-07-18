Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab3GRUFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:05:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab3GRTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/76] perf util: Save long size of traced system
Date: Thu, 18 Jul 2013 16:49:12 -0300
Message-Id: <1374177003-3706-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Save size of long type of system to struct pevent.  Since original
static variable was not used anywhere, just get rid of it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index c6b491b..6166294 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -41,7 +41,6 @@ static int input_fd;
 
 int file_bigendian;
 int host_bigendian;
-static int long_size;
 
 static ssize_t trace_data_size;
 static bool repipe;
@@ -231,12 +230,6 @@ static int read_header_files(struct pevent *pevent)
 	size = read8(pevent);
 	skip(size);
 
-	/*
-	 * The size field in the page is of type long,
-	 * use that instead, since it represents the kernel.
-	 */
-	long_size = header_page_size_size;
-
 	if (do_read(buf, 13) < 0)
 		return -1;
 
@@ -349,6 +342,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_funcs = 0;
 	int show_printk = 0;
 	ssize_t size = -1;
+	int file_long_size;
 	int file_page_size;
 	struct pevent *pevent;
 	int err;
@@ -392,12 +386,13 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	if (do_read(buf, 1) < 0)
 		goto out;
-	long_size = buf[0];
+	file_long_size = buf[0];
 
 	file_page_size = read4(pevent);
 	if (!file_page_size)
 		goto out;
 
+	pevent_set_long_size(pevent, file_long_size);
 	pevent_set_page_size(pevent, file_page_size);
 
 	err = read_header_files(pevent);
-- 
1.8.1.4

