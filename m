Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaHVVA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:00:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:43405 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaHVVAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:00:24 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf trace: Filter out POLLHUP'ed file descriptors
Date: Fri, 22 Aug 2014 17:59:45 -0300
Message-Id: <1408741190-5123-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408741190-5123-1-git-send-email-acme@kernel.org>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fhn2pyf8sqhoiwu42hxq9yq2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a9e96ff49c7f..09d4bc44215e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2171,7 +2171,8 @@ next_event:
 	if (trace->nr_events == before) {
 		int timeout = done ? 100 : -1;
 
-		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0)
+		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0 &&
+		    perf_evlist__filter_pollfd(evlist, POLLERR | POLLHUP) > 0)
 			goto again;
 	} else {
 		goto again;
-- 
1.9.3

