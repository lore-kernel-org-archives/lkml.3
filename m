Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3BFWAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:00:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3BFWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:00:36 -0500
Date: Wed, 6 Feb 2013 14:00:03 -0800
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-ad0de0971b7f7097bd9be1ab4ad2a64db500adbf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1359873501-24541-2-git-send-email-feng.tang@intel.com>
References: <1359873501-24541-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Enable the runtime switching of perf data file
Git-Commit-ID: ad0de0971b7f7097bd9be1ab4ad2a64db500adbf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:00:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad0de0971b7f7097bd9be1ab4ad2a64db500adbf
Gitweb:     http://git.kernel.org/tip/ad0de0971b7f7097bd9be1ab4ad2a64db500adbf
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Sun, 3 Feb 2013 14:38:21 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:25 -0300

perf report: Enable the runtime switching of perf data file

This is for tui browser only. This patch will check the returned key of
tui hists browser, if it's K_SWITH_INPUT_DATA, then recreate a session
for the new selected data file.

V2: Move the setup_brower() before the "repeat" jump point.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359873501-24541-2-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 38 +++++++++++++++++++++++++++-----------
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
