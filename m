Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3I3ITx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:19:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58546 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3I3ITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:19:51 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-0c-524934252122
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] perf session: Fix infinite loop on invalid perf.data file
Date: Mon, 30 Sep 2013 17:19:48 +0900
Message-Id: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf-record updates the header in the perf.data file at termination.
Without this update perf-report (and other processing built-ins) it
caused an infinite loop when perf report (or something like) called.

This is because the algorithm in __perf_session__process_events()
depends on the data_size which is read from file header.  Use file
size directly instead in this case to do the best-effort processing.

Cc: David Ahern <dsahern@gmail.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c  | 9 +++++++++
 tools/perf/util/session.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26441d0e571b..cedccde6a6b2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2753,6 +2753,15 @@ int perf_session__read_header(struct perf_session *session)
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
 
+	/*
+	 * Sanity check that perf.data was written cleanly; data size is
+	 * initialized to 0 and updated only if the on_exit function is run.
+	 * If data size is still 0 then the file contains only partial
+	 * information.  Just warn user and process it as much as it can.
+	 */
+	if (f_header.data.size == 0)
+		pr_warning("Data size is 0. Was the record command properly terminated?\n");
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6c1d4447c5b4..7bbd60c0a0ed 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1323,7 +1323,7 @@ int __perf_session__process_events(struct perf_session *session,
 	file_offset = page_offset;
 	head = data_offset - page_offset;
 
-	if (data_offset + data_size < file_size)
+	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
-- 
1.7.11.7

