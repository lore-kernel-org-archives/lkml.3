Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaFBSC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaFBSC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:02:26 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf record: Fix poll return value propagation
Date: Mon,  2 Jun 2014 20:02:06 +0200
Message-Id: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
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

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

