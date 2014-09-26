Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaIZJXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:23:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaIZJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:23:00 -0400
Date: Fri, 26 Sep 2014 02:22:15 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8dg8o21t2ntzly2bfh53p3sg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Filter out POLLHUP'
 ed file descriptors
Git-Commit-ID: 6dcf45ef9877863fb68c065e5ade3cdb6217c504
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dcf45ef9877863fb68c065e5ade3cdb6217c504
Gitweb:     http://git.kernel.org/tip/6dcf45ef9877863fb68c065e5ade3cdb6217c504
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Aug 2014 11:33:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:56 -0300

perf record: Filter out POLLHUP'ed file descriptors

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
index a8c2e9d..320b198 100644
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
