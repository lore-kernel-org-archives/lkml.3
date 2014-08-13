Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaHMFTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaHMFTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:19:34 -0400
Date: Tue, 12 Aug 2014 22:19:19 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-59dc9f2534569d11a55c8b5dbe93c36f2b2fa506@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1406785662-5534-8-git-send-email-namhyung@kernel.org>
References: <1406785662-5534-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix column alignment when headers aren't shown on TUI
Git-Commit-ID: 59dc9f2534569d11a55c8b5dbe93c36f2b2fa506
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59dc9f2534569d11a55c8b5dbe93c36f2b2fa506
Gitweb:     http://git.kernel.org/tip/59dc9f2534569d11a55c8b5dbe93c36f2b2fa506
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Jul 2014 14:47:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:07 -0300

perf tools: Fix column alignment when headers aren't shown on TUI

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
index e07d4e8..045c1e1 100644
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
 
