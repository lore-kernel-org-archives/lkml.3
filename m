Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3JRMea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:34:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:48657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3JRMag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936412"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/19] perf session: Add missing sample flush for piped events
Date: Fri, 18 Oct 2013 15:29:02 +0300
Message-Id: <1382099356-4918-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piped events can be sorted so a final flush is needed.
Add that and remove a redundant 'err = 0'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d1e4495..d51e62d 100644
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
1.7.11.7

