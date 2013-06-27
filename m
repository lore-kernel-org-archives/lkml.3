Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3F0Htr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:49:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:58424 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3F0Hto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:49:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="361296227"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 09/15] perf tools: validate perf event header size
Date: Thu, 27 Jun 2013 10:55:01 +0300
Message-Id: <1372319707-13892-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
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
index 19ea888..7a12886 100644
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

