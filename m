Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbaGCVnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:43:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:53858 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759735AbaGCVnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:43:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf hists browser: Add ui.show-headers config file option
Date: Thu,  3 Jul 2014 18:43:00 -0300
Message-Id: <1404423780-24026-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404423780-24026-1-git-send-email-acme@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding ui.show-headers config file option to define if the histogram
entries headers will start visible or not.

Currently columns headers are displayed by default, following
lines in ~/.perfconfig file will disable that:

  [ui]
        show-headers = true

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

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |  2 +-
 tools/perf/util/config.c       | 13 +++++++++++++
 tools/perf/util/symbol.c       |  1 +
 tools/perf/util/symbol.h       |  3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5fa2e181ef0c..a94b11fc5e00 100644
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
index 24519e14ac56..1e5e2e5af6b1 100644
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
index 7b9096f29cdb..2e6a2e219eb9 100644
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
index 615c752dd767..a81877b1dee0 100644
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
-- 
1.9.3

