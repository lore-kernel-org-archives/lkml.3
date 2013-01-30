Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3A3Otq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:49:46 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54431
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab3A3OrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/21] perf header: Stop using die() calls when processing tracing data
Date: Wed, 30 Jan 2013 11:46:47 -0300
Message-Id: <1359557222-17547-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.8.1.1.361.gec3ae6e

