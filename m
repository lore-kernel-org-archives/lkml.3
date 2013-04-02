Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab3DBJcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:32:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782Ab3DBJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:32:42 -0400
Date: Tue, 2 Apr 2013 02:32:23 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ebf3c675d7e4ba97568dd6daaa43b1af10046b29@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-10-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Cleanup calc_data_size logic
Git-Commit-ID: ebf3c675d7e4ba97568dd6daaa43b1af10046b29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:32:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebf3c675d7e4ba97568dd6daaa43b1af10046b29
Gitweb:     http://git.kernel.org/tip/ebf3c675d7e4ba97568dd6daaa43b1af10046b29
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:37:37 -0300

perf tools: Cleanup calc_data_size logic

It's for calculating whole trace data size during reading.  However
relation functions are called only in this file, no need to
conditionalize it with tricky +1 offset and rename the variable to
more meaningful name like trace_data_size.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 644ad3b..af215c0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -43,7 +43,7 @@ int file_bigendian;
 int host_bigendian;
 static int long_size;
 
-static ssize_t calc_data_size;
+static ssize_t trace_data_size;
 static bool repipe;
 
 static int __do_read(int fd, void *buf, int size)
@@ -83,8 +83,7 @@ static int do_read(void *data, int size)
 		return -1;
 	}
 
-	if (calc_data_size)
-		calc_data_size += r;
+	trace_data_size += r;
 
 	return r;
 }
@@ -155,8 +154,7 @@ static char *read_string(void)
 			break;
 	}
 
-	if (calc_data_size)
-		calc_data_size += size;
+	trace_data_size += size;
 
 	str = malloc(size);
 	if (str)
@@ -356,9 +354,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	*ppevent = NULL;
 
-	calc_data_size = 1;
 	repipe = __repipe;
-
 	input_fd = fd;
 
 	if (do_read(buf, 3) < 0)
@@ -417,8 +413,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	if (err)
 		goto out;
 
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	size = trace_data_size;
 	repipe = false;
 
 	if (show_funcs) {
