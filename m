Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3AaKma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:42:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3AaKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:42:28 -0500
Date: Thu, 31 Jan 2013 02:41:57 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-eeeljnecpi0zi5s7ux1mzdv9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Stop using die()
  calls when processing tracing data
Git-Commit-ID: 2caa48a24061b1f8e8dab43ea3292a608a15e3c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:42:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2caa48a24061b1f8e8dab43ea3292a608a15e3c9
Gitweb:     http://git.kernel.org/tip/2caa48a24061b1f8e8dab43ea3292a608a15e3c9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 22:34:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jan 2013 12:49:29 -0300

perf header: Stop using die() calls when processing tracing data

The callers of this function (perf_event__process_tracing_data) already
handles a negative value return as error, so just use pr_err() to log
the problem and return -1 instead of panic'ing.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-eeeljnecpi0zi5s7ux1mzdv9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fccd69d..e17a8fe 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2921,16 +2921,22 @@ int perf_event__process_tracing_data(union perf_event *event,
 				 session->repipe);
 	padding = PERF_ALIGN(size_read, sizeof(u64)) - size_read;
 
-	if (readn(session->fd, buf, padding) < 0)
-		die("reading input file");
+	if (readn(session->fd, buf, padding) < 0) {
+		pr_err("%s: reading input file", __func__);
+		return -1;
+	}
 	if (session->repipe) {
 		int retw = write(STDOUT_FILENO, buf, padding);
-		if (retw <= 0 || retw != padding)
-			die("repiping tracing data padding");
+		if (retw <= 0 || retw != padding) {
+			pr_err("%s: repiping tracing data padding", __func__);
+			return -1;
+		}
 	}
 
-	if (size_read + padding != size)
-		die("tracing data size mismatch");
+	if (size_read + padding != size) {
+		pr_err("%s: tracing data size mismatch", __func__);
+		return -1;
+	}
 
 	perf_evlist__prepare_tracepoint_events(session->evlist,
 					       session->pevent);
