Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbaFCUh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835AbaFCUgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:49 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/9] perf record: Fix poll return value propagation
Date: Tue,  3 Jun 2014 22:36:15 +0200
Message-Id: <1401827776-4443-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the perf record command is interrupted in record__mmap_read_all
function, the 'done' is set and err has the latest poll return
value, which is most likely positive number (= number of pollfds
ready to read).

This 'positive err' is then propagated to the exit code, resulting
in not finishing the perf.data header properly, causing following
error in report:

  # perf record -F 50000 -a

  ---
  make the system real busy, so there's more chance
  to interrupt perf in event writing code
  ---

  ^C[ perf record: Woken up 16 times to write data ]
  [ perf record: Captured and wrote 30.292 MB perf.data (~1323468 samples) ]

  # perf report --stdio > /dev/null
  WARNING: The perf.data file's data size field is 0 which is unexpected.
  Was the 'perf record' command properly terminated?

Fixing this by checking for positive poll return value
and setting err to 0.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401732126-19465-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e4c85b8..ce2cfec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -454,7 +454,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			if (done)
 				break;
 			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
-			if (err < 0 && errno == EINTR)
+			/*
+			 * Propagate error, only if there's any. Ignore positive
+			 * number of returned events and interrupt error.
+			 */
+			if (err > 0 || (err < 0 && errno == EINTR))
 				err = 0;
 			waking++;
 		}
-- 
1.8.3.1

