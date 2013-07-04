Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab3GDNPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:15:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:65349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab3GDNPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264087936"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 08/21] perf tools: validate perf event header size
Date: Thu,  4 Jul 2013 16:20:27 +0300
Message-Id: <1372944040-32690-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'size' includes the header so must be at least
'sizeof(struct perf_event_header)'.  Error out
immediately if that is not the case.  Also
don't byte-swap the header until it is actually
"fetched" from the mmap region.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6b71b88..951a1cf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1094,8 +1094,10 @@ more:
 		perf_event_header__bswap(&event->header);
 
 	size = event->header.size;
-	if (size == 0)
-		size = 8;
+	if (size < sizeof(struct perf_event_header)) {
+		pr_err("bad event header size\n");
+		goto out_err;
+	}
 
 	if (size > cur_size) {
 		void *new = realloc(buf, size);
@@ -1164,8 +1166,12 @@ fetch_mmaped_event(struct perf_session *session,
 	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	if (head + event->header.size > mmap_size)
+	if (head + event->header.size > mmap_size) {
+		/* We're not fetching the event so swap back again */
+		if (session->header.needs_swap)
+			perf_event_header__bswap(&event->header);
 		return NULL;
+	}
 
 	return event;
 }
@@ -1245,7 +1251,7 @@ more:
 
 	size = event->header.size;
 
-	if (size == 0 ||
+	if (size < sizeof(struct perf_event_header) ||
 	    perf_session__process_event(session, event, tool, file_pos) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
-- 
1.7.11.7

