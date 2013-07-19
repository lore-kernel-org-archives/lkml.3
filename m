Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908Ab3GSHuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965829Ab3GSHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:40 -0400
Date: Fri, 19 Jul 2013 00:50:03 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-27389d7823f573be8eaff32fb4abe564e181eb71@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372944040-32690-9-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-9-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Validate perf event header size
Git-Commit-ID: 27389d7823f573be8eaff32fb4abe564e181eb71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:50:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27389d7823f573be8eaff32fb4abe564e181eb71
Gitweb:     http://git.kernel.org/tip/27389d7823f573be8eaff32fb4abe564e181eb71
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 4 Jul 2013 16:20:27 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:53:48 -0300

perf tools: Validate perf event header size

The 'size' variable includes the header so must be at least
'sizeof(struct perf_event_header)'.  Error out immediately if that is
not the case.  Also don't byte-swap the header until it is actually
"fetched" from the mmap region.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
