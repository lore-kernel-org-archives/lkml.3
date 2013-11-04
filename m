Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3KDUWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3KDUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:04 -0500
Date: Mon, 4 Nov 2013 12:21:47 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4bceffbc26fab2444742db59c6f8124c29e41369@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383291195-24386-3-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Postpone setting up browser after parsing options
Git-Commit-ID: 4bceffbc26fab2444742db59c6f8124c29e41369
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:21:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bceffbc26fab2444742db59c6f8124c29e41369
Gitweb:     http://git.kernel.org/tip/4bceffbc26fab2444742db59c6f8124c29e41369
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 1 Nov 2013 16:33:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:54:32 -0300

perf report: Postpone setting up browser after parsing options

If setup_browser() called earlier than option parsing, the actual error
message can be discarded during the terminal reset.  So move it after
setup_sorting() checks whether the sort keys are valid.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383291195-24386-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 98d3891..4df3161 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -905,13 +905,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			input_name = "perf.data";
 	}
 
-	if (strcmp(input_name, "-") != 0)
-		setup_browser(true);
-	else {
-		use_browser = 0;
-		perf_hpp__init();
-	}
-
 	file.path  = input_name;
 	file.force = report.force;
 
@@ -957,6 +950,18 @@ repeat:
 	if (setup_sorting() < 0)
 		usage_with_options(report_usage, options);
 
+	if (parent_pattern != default_parent_pattern) {
+		if (sort_dimension__add("parent") < 0)
+			goto error;
+	}
+
+	if (strcmp(input_name, "-") != 0)
+		setup_browser(true);
+	else {
+		use_browser = 0;
+		perf_hpp__init();
+	}
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
@@ -986,11 +991,6 @@ repeat:
 	if (symbol__init() < 0)
 		goto error;
 
-	if (parent_pattern != default_parent_pattern) {
-		if (sort_dimension__add("parent") < 0)
-			goto error;
-	}
-
 	if (argc) {
 		/*
 		 * Special case: if there's an argument left then assume that
