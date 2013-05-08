Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3EHPS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:18:56 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50305 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3EHPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:18:53 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: detect loops processing events
Date: Wed,  8 May 2013 09:18:47 -0600
Message-Id: <1368026327-4741-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recovery algorithm in __perf_session__process_events attempts to remap
a perf.data file with a different file_offset and try again at a new head
position. Both of these adjustment rely on page_offset. If page_offset is
0 then file_offset and head never change which means the remap attempt is
the same and the fetch_mmaped_event is the same and the processing just
loops forever.

Detect this condition and warn the user.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..1c4dc45 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1235,6 +1235,12 @@ more:
 		}
 
 		page_offset = page_size * (head / page_size);
+		/* catch looping where we never make forward progress. */
+		if (page_offset == 0) {
+			pr_err("Loop detection processing events. Is file corrupted?\n");
+			return -1;
+		}
+
 		file_offset += page_offset;
 		head -= page_offset;
 		goto remap;
-- 
1.7.10.1

