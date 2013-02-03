Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3BCGiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 01:38:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:33714 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3BCGii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 01:38:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,591,1355126400"; 
   d="scan'208";a="280292621"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 2/2] perf report: Enable the runtime switching of perf data file
Date: Sun,  3 Feb 2013 14:38:21 +0800
Message-Id: <1359873501-24541-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359873501-24541-1-git-send-email-feng.tang@intel.com>
References: <1359873501-24541-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for tui browser only. This patch will check the returned
key of tui hists browser, if it's K_SWITH_INPUT_DATA, then recreate
a session for the new selected data file.

V2: Move the setup_brower() before the "repeat" jump point.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-report.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d22187..91555d4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -468,9 +468,17 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (use_browser > 0) {
 		if (use_browser == 1) {
-			perf_evlist__tui_browse_hists(session->evlist, help,
-						      NULL,
-						      &session->header.env);
+			ret = perf_evlist__tui_browse_hists(session->evlist,
+							help,
+							NULL,
+							&session->header.env);
+			/*
+			 * Usually "ret" is the last pressed key, and we only
+			 * care if the key notifies us to switch data file.
+			 */
+			if (ret != K_SWITCH_INPUT_DATA)
+				ret = 0;
+
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
 						      NULL);
@@ -708,6 +716,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		else
 			input_name = "perf.data";
 	}
+
+	if (strcmp(input_name, "-") != 0)
+		setup_browser(true);
+	else {
+		use_browser = 0;
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+		perf_hpp__init();
+	}
+
+repeat:
 	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
 	if (session == NULL)
@@ -733,14 +751,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	}
 
-	if (strcmp(input_name, "-") != 0)
-		setup_browser(true);
-	else {
-		use_browser = 0;
-		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-		perf_hpp__init();
-	}
-
 	setup_sorting(report_usage, options);
 
 	/*
@@ -809,6 +819,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	ret = __cmd_report(&report);
+	if (ret == K_SWITCH_INPUT_DATA) {
+		perf_session__delete(session);
+		goto repeat;
+	} else
+		ret = 0;
+
 error:
 	perf_session__delete(session);
 	return ret;
-- 
1.7.9.5

