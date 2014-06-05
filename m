Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaFEOcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:32:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaFEOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:32:47 -0400
Date: Thu, 5 Jun 2014 07:32:19 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a515114fa3cff8f1da10cd68914d55c10879c3e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
References: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix poll return value propagation
Git-Commit-ID: a515114fa3cff8f1da10cd68914d55c10879c3e0
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

Commit-ID:  a515114fa3cff8f1da10cd68914d55c10879c3e0
Gitweb:     http://git.kernel.org/tip/a515114fa3cff8f1da10cd68914d55c10879c3e0
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 2 Jun 2014 13:44:23 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:35:05 +0200

perf record: Fix poll return value propagation

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
