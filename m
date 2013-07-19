Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935284Ab3GSHrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:47:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:47:02 -0400
Date: Fri, 19 Jul 2013 00:46:43 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-59657f9c8dd91363f1c94c1f749b33ecf626cfc2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-9-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: Save long size of traced system
Git-Commit-ID: 59657f9c8dd91363f1c94c1f749b33ecf626cfc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:46:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59657f9c8dd91363f1c94c1f749b33ecf626cfc2
Gitweb:     http://git.kernel.org/tip/59657f9c8dd91363f1c94c1f749b33ecf626cfc2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:23 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:19 -0300

perf util: Save long size of traced system

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
