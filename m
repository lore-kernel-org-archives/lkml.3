Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaALSd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:33:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaALSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:33:55 -0500
Date: Sun, 12 Jan 2014 10:33:15 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-xwsk964dp681fica3xlqhjin@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Simplify perf_record__write
Git-Commit-ID: cf8b2e6941091d2034f19c1799f8d6407bd565a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:33:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf8b2e6941091d2034f19c1799f8d6407bd565a4
Gitweb:     http://git.kernel.org/tip/cf8b2e6941091d2034f19c1799f8d6407bd565a4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:26:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 14:26:26 -0300

perf record: Simplify perf_record__write

1. Since all callers either test if it is less than zero or assign its
   result to an int variable, convert it from ssize_t to int;

2. There is just one use for the 'session' variable, so use rec->session
   directly instead;

3. No need to store the result of perf_data_file__write, since that
   result is either 'size' or -1, the later making the error result to
   be stored in 'errno' and accessed thru printf's %m in the pr_err
   call.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xwsk964dp681fica3xlqhjin@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8eed3d7..e8d606c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,19 +76,14 @@ struct perf_record {
 	long			samples;
 };
 
-static ssize_t perf_record__write(struct perf_record *rec,
-				  void *buf, size_t size)
+static int perf_record__write(struct perf_record *rec, void *bf, size_t size)
 {
-	struct perf_session *session = rec->session;
-	ssize_t ret;
-
-	ret = perf_data_file__write(session->file, buf, size);
-	if (ret < 0) {
+	if (perf_data_file__write(rec->session->file, bf, size) < 0) {
 		pr_err("failed to write perf data, error: %m\n");
 		return -1;
 	}
 
-	rec->bytes_written += ret;
+	rec->bytes_written += size;
 	return 0;
 }
 
