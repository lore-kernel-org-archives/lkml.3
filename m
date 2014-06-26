Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaFZMib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbaFZMi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:38:29 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] perf tools: Add ui.show-headers config file option
Date: Thu, 26 Jun 2014 14:38:11 +0200
Message-Id: <1403786291-19412-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403786291-19412-1-git-send-email-jolsa@kernel.org>
References: <1403786291-19412-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding report.show-headers config file option to setup
the appearance of the columns headers.

Currently columns headers are displayed by default, following
lines in ~/.perfconfig file will disable that:

  [ui]
        show-headers = true

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  2 +-
 tools/perf/util/config.c       | 13 +++++++++++++
 tools/perf/util/symbol.c       |  1 +
 tools/perf/util/symbol.h       |  3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7e51b5d..bb356a0 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1264,7 +1264,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		browser->show_headers = true;
+		browser->show_headers = symbol_conf.show_headers;
 	}
 
 	return browser;
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 24519e1..2b4c8d8 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -350,6 +350,16 @@ static int perf_default_core_config(const char *var __maybe_unused,
 	return 0;
 }
 
+static int perf_ui_config(const char *var, const char *value)
+{
+	/* Add other config variables here. */
+	if (!strcmp(var, "ui.show-headers")) {
+		symbol_conf.show_headers = perf_config_bool(var, value);
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
index 7b9096f..407317f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -34,6 +34,7 @@ struct symbol_conf symbol_conf = {
 	.annotate_src		= true,
 	.demangle		= true,
 	.cumulate_callchain	= true,
+	.show_headers		= true,
 	.symfs			= "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..0c2c67c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -118,7 +118,8 @@ struct symbol_conf {
 			annotate_src,
 			event_group,
 			demangle,
-			filter_relative;
+			filter_relative,
+			show_headers;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.8.3.1

