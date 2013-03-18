Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3CRKzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:55:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3CRKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:55:16 -0400
Date: Mon, 18 Mar 2013 03:53:43 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e4dd45fe7add0de09e0e5b2b511732d9c86b6ee7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1361785972-7431-2-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Fix -C option
Git-Commit-ID: e4dd45fe7add0de09e0e5b2b511732d9c86b6ee7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:53:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4dd45fe7add0de09e0e5b2b511732d9c86b6ee7
Gitweb:     http://git.kernel.org/tip/e4dd45fe7add0de09e0e5b2b511732d9c86b6ee7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Feb 2013 10:52:48 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 16:58:28 -0300

perf record: Fix -C option

Currently the -C option does not work for record command, because of the
targets mismatch when synthesizing threads.

Fixing this by using proper target interface for the synthesize
decision.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361785972-7431-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
