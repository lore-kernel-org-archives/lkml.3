Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaHDQVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:39717 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHDQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:21:36 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/33] perf tools: Fix column alignment when headers aren't shown on TUI
Date: Mon,  4 Aug 2014 13:17:42 -0300
Message-Id: <1407169064-25625-32-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

If user sets ui.show-headers config option to false, it didn't calculate
default column width so it broke the alignment.  This is because it does
the calculation just before showing headers.

Move it to the beginning of the hist browser so that it can be called
regardless of the config option.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406785662-5534-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e07d4e848d5c..045c1e16ac59 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -850,9 +850,6 @@ static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		/* We need to ensure length of the columns header. */
-		perf_hpp__reset_width(fmt, hists);
-
 		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		if (advance_hpp_check(&dummy_hpp, ret))
 			break;
@@ -1501,6 +1498,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char buf[64];
 	char script_opt[64];
 	int delay_secs = hbt ? hbt->refresh : 0;
+	struct perf_hpp_fmt *fmt;
 
 #define HIST_BROWSER_HELP_COMMON					\
 	"h/?/F1        Show this window\n"				\
@@ -1550,6 +1548,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	memset(options, 0, sizeof(options));
 
+	perf_hpp__for_each_format(fmt)
+		perf_hpp__reset_width(fmt, hists);
+
 	if (symbol_conf.col_width_list_str)
 		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
 
-- 
1.9.3

