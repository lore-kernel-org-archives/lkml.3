Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315Ab3GSHrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:47:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:47:30 -0400
Date: Fri, 19 Jul 2013 00:47:12 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-94b4d89e0021fe3e10415feede364a3fccaa2f89@git.kernel.org>
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
In-Reply-To: <1370323231-14022-12-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-12-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util:
  Parse header_page to get proper long size
Git-Commit-ID: 94b4d89e0021fe3e10415feede364a3fccaa2f89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:47:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94b4d89e0021fe3e10415feede364a3fccaa2f89
Gitweb:     http://git.kernel.org/tip/94b4d89e0021fe3e10415feede364a3fccaa2f89
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:24 -0300

perf util: Parse header_page to get proper long size

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
