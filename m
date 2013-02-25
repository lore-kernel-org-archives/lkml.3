Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3BYJxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062Ab3BYJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/5] perf tools: Fix -C option for record command
Date: Mon, 25 Feb 2013 10:52:48 +0100
Message-Id: <1361785972-7431-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the -C option does not work for record command,
because of the targets mismatch when synthesizing threads.

Fixing this by using proper target interface for the
synthesize decision.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 tools/perf/builtin-record.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 774c907..f1a939e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -573,13 +573,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	if (!opts->target.system_wide)
+	if (perf_target__has_task(&opts->target))
 		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
-	else
+	else if (perf_target__has_cpu(&opts->target))
 		err = perf_event__synthesize_threads(tool, process_synthesized_event,
 					       machine);
+	else /* command specified */
+		err = 0;
 
 	if (err != 0)
 		goto out_delete_session;
-- 
1.7.11.7

