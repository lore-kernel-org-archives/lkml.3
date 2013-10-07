Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3JGTCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:02:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3JGTCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:02:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sonny Rao <sonnyrao@chromium.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf session: Fix infinite loop on invalid perf.data file
Date: Mon,  7 Oct 2013 16:02:29 -0300
Message-Id: <1381172549-3210-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381172549-3210-1-git-send-email-acme@infradead.org>
References: <1381172549-3210-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf-record updates the header in the perf.data file at termination.
Without this update perf-report (and other processing built-ins) it
caused an infinite loop when perf report (or something like) called.

This is because the algorithm in __perf_session__process_events()
depends on the data_size which is read from file header.  Use file size
directly instead in this case to do the best-effort processing.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: David Ahern <dsahern@gmail.com>
Tested-by: Sonny Rao <sonnyrao@chromium.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sonny Rao <sonnyrao@chromium.org>
Link: http://lkml.kernel.org/r/1380529188-27193-1-git-send-email-namhyung@kernel.org
Signed-off-by: David Ahern <dsahern@gmail.com>
[ Reworded warning as per Ingo Molnar suggestion, replaces 'perf.data'
  with session->filename, to precisely identify the data file involved ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  | 12 ++++++++++++
 tools/perf/util/session.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ce69901176d8..c3e5a3b817ab 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2768,6 +2768,18 @@ int perf_session__read_header(struct perf_session *session)
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
 
+	/*
+	 * Sanity check that perf.data was written cleanly; data size is
+	 * initialized to 0 and updated only if the on_exit function is run.
+	 * If data size is still 0 then the file contains only partial
+	 * information.  Just warn user and process it as much as it can.
+	 */
+	if (f_header.data.size == 0) {
+		pr_warning("WARNING: The %s file's data size field is 0 which is unexpected.\n"
+			   "Was the 'perf record' command properly terminated?\n",
+			   session->filename);
+	}
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 37c4718f6be1..568b750c01f6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1312,7 +1312,7 @@ int __perf_session__process_events(struct perf_session *session,
 	file_offset = page_offset;
 	head = data_offset - page_offset;
 
-	if (data_offset + data_size < file_size)
+	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
-- 
1.8.1.4

