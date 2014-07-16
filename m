Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029AbaGPTQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760808AbaGPTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:15:56 -0400
Date: Wed, 16 Jul 2014 12:15:27 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c83023676dc34f1b4422b842e1e2dc5c21bfc4dc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1403886418-5556-4-git-send-email-jolsa@kernel.org>
References: <1403886418-5556-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Add ui.show-headers config file option
Git-Commit-ID: c83023676dc34f1b4422b842e1e2dc5c21bfc4dc
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

Commit-ID:  c83023676dc34f1b4422b842e1e2dc5c21bfc4dc
Gitweb:     http://git.kernel.org/tip/c83023676dc34f1b4422b842e1e2dc5c21bfc4dc
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 27 Jun 2014 18:26:58 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 15:23:31 -0300

perf hists browser: Add ui.show-headers config file option

Adding ui.show-headers config file option to define if the histogram
entries headers will start visible or not.

Currently columns headers are displayed by default, following
lines in ~/.perfconfig file will disable that:

  [ui]
        show-headers = false

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403886418-5556-4-git-send-email-jolsa@kernel.org
[ renamed symbol_conf.show_headers to .show_hist_headers ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |  2 +-
 tools/perf/util/config.c       | 13 +++++++++++++
 tools/perf/util/symbol.c       |  1 +
 tools/perf/util/symbol.h       |  3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5fa2e18..a94b11f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1284,7 +1284,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh_dimensions = hist_browser__refresh_dimensions;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		browser->show_headers = true;
+		browser->show_headers = symbol_conf.show_hist_headers;
 	}
 
 	return browser;
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 24519e1..1e5e2e5 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -350,6 +350,16 @@ static int perf_default_core_config(const char *var __maybe_unused,
 	return 0;
 }
 
+static int perf_ui_config(const char *var, const char *value)
+{
+	/* Add other config variables here. */
+	if (!strcmp(var, "ui.show-headers")) {
+		symbol_conf.show_hist_headers = perf_config_bool(var, value);
+		return 0;
+	}
+	return 0;
+}
+
 int perf_default_config(const char *var, const char *value,
 			void *dummy __maybe_unused)
 {
@@ -359,6 +369,9 @@ int perf_default_config(const char *var, const char *value,
 	if (!prefixcmp(var, "hist."))
 		return perf_hist_config(var, value);
 
+	if (!prefixcmp(var, "ui."))
+		return perf_ui_config(var, value);
+
 	/* Add other config variables here. */
 	return 0;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7b9096f..2e6a2e2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -34,6 +34,7 @@ struct symbol_conf symbol_conf = {
 	.annotate_src		= true,
 	.demangle		= true,
 	.cumulate_callchain	= true,
+	.show_hist_headers	= true,
 	.symfs			= "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..a81877b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -118,7 +118,8 @@ struct symbol_conf {
 			annotate_src,
 			event_group,
 			demangle,
-			filter_relative;
+			filter_relative,
+			show_hist_headers;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
