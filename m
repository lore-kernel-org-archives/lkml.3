Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3K3MxC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:53:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3K3Mwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:52:55 -0500
Date: Sat, 30 Nov 2013 04:52:20 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-d2ff1b1499c8e0ad2fc79376a4215ba37771823f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384806771-2945-2-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Skip ignored symbols while printing callchain
Git-Commit-ID: d2ff1b1499c8e0ad2fc79376a4215ba37771823f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:52:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2ff1b1499c8e0ad2fc79376a4215ba37771823f
Gitweb:     http://git.kernel.org/tip/d2ff1b1499c8e0ad2fc79376a4215ba37771823f
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 18 Nov 2013 13:32:44 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:37 -0300

perf evsel: Skip ignored symbols while printing callchain

Allows a command to have a symbol_filter controlled by the user to skip
certain functions in a backtrace. One example is to allow the user to
reduce repeating patterns like:

    do_select  core_sys_select  sys_select

to just sys_select when dumping callchains, consuming less real estate
on the screen while still conveying the essential message - the process
is in a select call.

This option is leveraged by the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-2-git-send-email-dsahern@gmail.com
[ Checked if al.sym is NULL before touching al.sym->ignored, as noted by Adrian Hunter ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f36d24a..b0b15e2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1522,6 +1522,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!node)
 				break;
 
+			if (node->sym && node->sym->ignore)
+				goto next;
+
 			if (print_ip)
 				printf("%c%16" PRIx64, s, node->ip);
 
@@ -1544,12 +1547,15 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!print_oneline)
 				printf("\n");
 
-			callchain_cursor_advance(&callchain_cursor);
-
 			stack_depth--;
+next:
+			callchain_cursor_advance(&callchain_cursor);
 		}
 
 	} else {
+		if (al.sym && al.sym->ignore)
+			return;
+
 		if (print_ip)
 			printf("%16" PRIx64, sample->ip);
 
