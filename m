Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbaISFYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:24:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaISFYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:24:08 -0400
Date: Thu, 18 Sep 2014 22:23:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8vhaeeoq11ppz0713el4xcps@git.kernel.org>
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
Subject: [tip:perf/core] perf record:
  Use ring buffer consume method to look like other tools
Git-Commit-ID: e5685730e2c620f97bc12380e9370e857e5bd7a7
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

Commit-ID:  e5685730e2c620f97bc12380e9370e857e5bd7a7
Gitweb:     http://git.kernel.org/tip/e5685730e2c620f97bc12380e9370e857e5bd7a7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Sep 2014 16:42:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 18:01:43 -0300

perf record: Use ring buffer consume method to look like other tools

All builtins that consume events from perf's ring buffer now end up
calling perf_evlist__mmap_consume(), which will allow unmapping the ring
buffer when all the fds gets closed and all events in the buffer
consumed.

This is in preparation for the patchkit that will notice POLLHUP on
perf events file descriptors.

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
Link: http://lkml.kernel.org/n/tip-8vhaeeoq11ppz0713el4xcps@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 87e28a4..a1b0403 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -65,8 +65,9 @@ static int process_synthesized_event(struct perf_tool *tool,
 	return record__write(rec, event, event->header.size);
 }
 
-static int record__mmap_read(struct record *rec, struct perf_mmap *md)
+static int record__mmap_read(struct record *rec, int idx)
 {
+	struct perf_mmap *md = &rec->evlist->mmap[idx];
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -102,8 +103,7 @@ static int record__mmap_read(struct record *rec, struct perf_mmap *md)
 	}
 
 	md->prev = old;
-	perf_mmap__write_tail(md, old);
-
+	perf_evlist__mmap_consume(rec->evlist, idx);
 out:
 	return rc;
 }
@@ -245,7 +245,7 @@ static int record__mmap_read_all(struct record *rec)
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
 		if (rec->evlist->mmap[i].base) {
-			if (record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
+			if (record__mmap_read(rec, i) != 0) {
 				rc = -1;
 				goto out;
 			}
