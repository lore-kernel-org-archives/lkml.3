Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaIYV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:59:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:44173 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaIYV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:59:08 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/14] perf trace: Filter out POLLHUP'ed file descriptors
Date: Thu, 25 Sep 2014 18:57:51 -0300
Message-Id: <1411682271-3771-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411682271-3771-1-git-send-email-acme@kernel.org>
References: <1411682271-3771-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we don't continue polling on vanished file descriptors, i.e.
file descriptors for events monitoring threads that exited.

I.e. the following 'trace' command now exits as expected, instead
of staying in an eternal loop:

      $ sleep 5s &
      $ trace -p `pidof sleep`

Reported-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6qegv786zbf6i8us6t4rxug9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b8fedf3f9921..fe39dc620179 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2044,6 +2044,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	int err = -1, i;
 	unsigned long before;
 	const bool forks = argc > 0;
+	bool draining = false;
 	char sbuf[STRERR_BUFSIZE];
 
 	trace->live = true;
@@ -2171,8 +2172,12 @@ next_event:
 	if (trace->nr_events == before) {
 		int timeout = done ? 100 : -1;
 
-		if (perf_evlist__poll(evlist, timeout) > 0)
+		if (!draining && perf_evlist__poll(evlist, timeout) > 0) {
+			if (perf_evlist__filter_pollfd(evlist, POLLERR | POLLHUP) == 0)
+				draining = true;
+
 			goto again;
+		}
 	} else {
 		goto again;
 	}
-- 
1.9.3

