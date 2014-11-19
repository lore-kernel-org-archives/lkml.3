Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaKSQE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:51684 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbaKSQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:55 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/16] perf evlist: Do not poll events that use the system_wide flag
Date: Wed, 19 Nov 2014 13:03:34 -0300
Message-Id: <1416413016-19110-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The system_wide flag causes a selected event to be opened always without
a pid.

Consequently it will never get a POLLHUP, but it is used for tracking in
combination with other events, so it should not need to be polled
anyway.

Therefore don't add it for polling.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7e23dae54f1d..cfbe2b99b9aa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -816,7 +816,15 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
+		/*
+		 * The system_wide flag causes a selected event to be opened
+		 * always without a pid.  Consequently it will never get a
+		 * POLLHUP, but it is used for tracking in combination with
+		 * other events, so it should not need to be polled anyway.
+		 * Therefore don't add it for polling.
+		 */
+		if (!evsel->system_wide &&
+		    __perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
 			perf_evlist__mmap_put(evlist, idx);
 			return -1;
 		}
-- 
1.9.3

