Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3FDFXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:23:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62623 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3FDFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:36 -0400
X-AuditID: 9c930179-b7c07ae000000e33-33-51ad7921fcb5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/16] perf util: Save long size of traced system
Date: Tue,  4 Jun 2013 14:20:23 +0900
Message-Id: <1370323231-14022-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Save size of long type of system to struct pevent.  Since original
static variable was not used anywhere, just get rid of it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index c6b491bcb8cd..6166294d7f22 100644
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
1.7.11.7

