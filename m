Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaIYV7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:59:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:44146 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbaIYV7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:59:04 -0400
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
Subject: [PATCH 13/14] perf record: Filter out POLLHUP'ed file descriptors
Date: Thu, 25 Sep 2014 18:57:50 -0300
Message-Id: <1411682271-3771-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411682271-3771-1-git-send-email-acme@kernel.org>
References: <1411682271-3771-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we don't continue polling on vanished file descriptors, i.e.
file descriptors for events monitoring threads that exited.

I.e. the following 'perf record' command now exits as expected, instead
of staying in an eternal loop:

  $ sleep 5s &
  $ perf record -p `pidof sleep`

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
Link: http://lkml.kernel.org/n/tip-8dg8o21t2ntzly2bfh53p3sg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a8c2e9dfb125..320b198b54dd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -308,7 +308,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	struct record_opts *opts = &rec->opts;
 	struct perf_data_file *file = &rec->file;
 	struct perf_session *session;
-	bool disabled = false;
+	bool disabled = false, draining = false;
 
 	rec->progname = argv[0];
 
@@ -457,7 +457,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		}
 
 		if (hits == rec->samples) {
-			if (done)
+			if (done || draining)
 				break;
 			err = perf_evlist__poll(rec->evlist, -1);
 			/*
@@ -467,6 +467,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			if (err > 0 || (err < 0 && errno == EINTR))
 				err = 0;
 			waking++;
+
+			if (perf_evlist__filter_pollfd(rec->evlist, POLLERR | POLLHUP) == 0)
+				draining = true;
 		}
 
 		/*
-- 
1.9.3

