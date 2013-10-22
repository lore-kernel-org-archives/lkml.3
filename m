Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3JVO3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3JVO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/26] perf session: Add missing sample flush for piped events
Date: Tue, 22 Oct 2013 11:28:19 -0300
Message-Id: <1382452114-1243-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Piped events can be sorted so a final flush is needed.

Add that and remove a redundant 'err = 0'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d1e449534b33..d51e62db96a7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1263,7 +1263,9 @@ more:
 	if (!session_done())
 		goto more;
 done:
-	err = 0;
+	/* do the final flush for ordered samples */
+	self->ordered_samples.next_flush = ULLONG_MAX;
+	err = flush_sample_queue(self, tool);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(self, tool);
@@ -1392,13 +1394,13 @@ more:
 				    "Processing events...");
 	}
 
-	err = 0;
 	if (session_done())
-		goto out_err;
+		goto out;
 
 	if (file_pos < file_size)
 		goto more;
 
+out:
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
-- 
1.8.1.4

