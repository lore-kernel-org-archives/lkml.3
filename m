Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3CUHT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:19:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57775 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab3CUHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:19:03 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-62-514ab46211f2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 9/9] perf util: Cleanup calc_data_size logic
Date: Thu, 21 Mar 2013 16:18:52 +0900
Message-Id: <1363850332-25297-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's for calculating whole trace data size during reading.  However
relation functions are called only in this file, no need to
conditionalize it with tricky +1 offset and rename the variable to
more meaningful name like trace_data_size.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 5ca6c2cc4216..5b794f773cd0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -45,7 +45,7 @@ int file_bigendian;
 int host_bigendian;
 static int long_size;
 
-static ssize_t calc_data_size;
+static ssize_t trace_data_size;
 static bool repipe;
 
 static int __do_read(int fd, void *buf, int size)
@@ -85,8 +85,7 @@ static int do_read(void *data, int size)
 		return -1;
 	}
 
-	if (calc_data_size)
-		calc_data_size += r;
+	trace_data_size += r;
 
 	return r;
 }
@@ -157,8 +156,7 @@ static char *read_string(void)
 			break;
 	}
 
-	if (calc_data_size)
-		calc_data_size += size;
+	trace_data_size += size;
 
 	str = malloc(size);
 	if (str)
@@ -358,9 +356,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	*ppevent = NULL;
 
-	calc_data_size = 1;
 	repipe = __repipe;
-
 	input_fd = fd;
 
 	if (do_read(buf, 3) < 0)
@@ -419,8 +415,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	if (err)
 		goto out;
 
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	size = trace_data_size;
 	repipe = false;
 
 	if (show_funcs) {
-- 
1.7.11.7

