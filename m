Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaEVMW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:22:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790AbaEVMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:22:25 -0400
Date: Thu, 22 May 2014 05:22:14 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-22af969e8cfc6ea46d3e1a774a16d7e19b8cf4db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-11-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Call perf_hpp__init()
  before setting up GUI browsers
Git-Commit-ID: 22af969e8cfc6ea46d3e1a774a16d7e19b8cf4db
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

Commit-ID:  22af969e8cfc6ea46d3e1a774a16d7e19b8cf4db
Gitweb:     http://git.kernel.org/tip/22af969e8cfc6ea46d3e1a774a16d7e19b8cf4db
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 16 Apr 2014 11:04:51 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:35 +0200

perf tools: Call perf_hpp__init() before setting up GUI browsers

So that it can be set properly prior to set up output fields.  That
makes easy to handle/warn errors during the setup since it doesn't
need to be bothered with the GUI.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-11-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-report.c    | 6 +++---
 tools/perf/builtin-top.c       | 2 ++
 tools/perf/ui/browsers/hists.c | 2 --
 tools/perf/ui/gtk/hists.c      | 2 --
 tools/perf/ui/setup.c          | 2 --
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f4d640cf..c4dab7a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -823,16 +823,16 @@ repeat:
 			goto error;
 	}
 
+	perf_hpp__init();
+
 	/* Force tty output for header output. */
 	if (report.header || report.header_only)
 		use_browser = 0;
 
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
-	else {
+	else
 		use_browser = 0;
-		perf_hpp__init();
-	}
 
 	if (report.header || report.header_only) {
 		perf_session__fprintf_info(session, stdout,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 34764b6..280945b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1147,6 +1147,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	/* display thread wants entries to be collapsed in a different tree */
 	sort__need_collapse = 1;
 
+	perf_hpp__init();
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 37c5188..92d128f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -661,8 +661,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 2237245..fd52669 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -58,8 +58,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 5df5140..ba51fa8 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -86,8 +86,6 @@ void setup_browser(bool fallback_to_pager)
 		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
-
-		perf_hpp__init();
 		break;
 	}
 }
