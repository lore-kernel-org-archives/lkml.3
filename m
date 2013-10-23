Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3JWHxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JWHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:48 -0400
Date: Wed, 23 Oct 2013 00:53:27 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-8c16b649606ff9f6d742ad6f71c76fc0ee996c8e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-6-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Add missing sample flush for piped events
Git-Commit-ID: 8c16b649606ff9f6d742ad6f71c76fc0ee996c8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:53:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c16b649606ff9f6d742ad6f71c76fc0ee996c8e
Gitweb:     http://git.kernel.org/tip/8c16b649606ff9f6d742ad6f71c76fc0ee996c8e
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:02 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 11:19:07 -0300

perf session: Add missing sample flush for piped events

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
