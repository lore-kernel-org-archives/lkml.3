Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbaGYBTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46423 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbaGYBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:17 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/7] perf tools: Fix column alignment when headers aren't shown on TUI
Date: Fri, 25 Jul 2014 10:18:58 +0900
Message-Id: <1406251138-6574-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user sets ui.show-headers config option to false, it didn't
calculate default column width so it broke the alignment.  This is
because it does the calculation just before showing headers.

Move it to the beginning of the hist browser so that it can be called
regardless of the config option.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index f0ef031558dd..ab9ca221fc2c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -853,9 +853,6 @@ static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		/* We need to ensure length of the columns header. */
-		perf_hpp__reset_width(fmt, hists);
-
 		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		if (advance_hpp_check(&dummy_hpp, ret))
 			break;
@@ -1504,6 +1501,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char buf[64];
 	char script_opt[64];
 	int delay_secs = hbt ? hbt->refresh : 0;
+	struct perf_hpp_fmt *fmt;
 
 #define HIST_BROWSER_HELP_COMMON					\
 	"h/?/F1        Show this window\n"				\
@@ -1553,6 +1551,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	memset(options, 0, sizeof(options));
 
+	perf_hpp__for_each_format(fmt)
+		perf_hpp__reset_width(fmt, hists);
+
 	if (symbol_conf.col_width_list_str)
 		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
 
-- 
2.0.0

