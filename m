Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3EIT1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:27:30 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57873 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3EIT11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:27:27 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH v2] perf: detect when perf.data file not closed out properly
Date: Thu,  9 May 2013 13:27:23 -0600
Message-Id: <1368127643-9913-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-record updates the header in the perf.data file at termination.
Without this update perf-report (and other processing builtins) cannot
properly read events from the file -- the algorithm in
__perf_session__process_events depends on the data_size which is read
from the file header and that function loops if data_size is 0.

Catch this condition when the file is opened and warn the user.

v2: put error message on one line

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/header.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..95baef4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2802,6 +2802,17 @@ int perf_session__read_header(struct perf_session *session, int fd)
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
 
+	/*
+	 * sanity check that perf.data was written cleanly: data size
+	 * is initialized to 0 and updated only if the on_exit function
+	 * is run. If data size is still 0 then the file cannot be
+	 * processed.
+	 */
+	if (f_header.data.size == 0) {
+		pr_err("Data size is 0. Was the record command properly terminated?\n");
+		return -1;
+	}
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
-- 
1.7.10.1

