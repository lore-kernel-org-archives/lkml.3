Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaIQVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:58320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbaIQVZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:53 -0400
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
Subject: [PATCH 20/20] perf record: Use ring buffer consume method to look like other tools
Date: Wed, 17 Sep 2014 18:24:23 -0300
Message-Id: <1410989063-14207-21-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 87e28a4e33ba..a1b040394170 100644
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
-- 
1.9.3

