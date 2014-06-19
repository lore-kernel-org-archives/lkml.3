Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaFSLln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaFSLlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:41:40 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] perf tools: Add report.show-headers config file option
Date: Thu, 19 Jun 2014 13:41:16 +0200
Message-Id: <1403178076-14072-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding report.show-headers config file option to setup
the appearance of the columns headers.

Currently columns headers are displayed by default, following
lines in ~/.perfconfig file will disable that:

  [report]
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
 tools/perf/builtin-report.c    | 4 ++++
 tools/perf/ui/browsers/hists.c | 6 +++++-
 tools/perf/util/symbol.c       | 1 +
 tools/perf/util/symbol.h       | 1 +
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830b..cbc68c6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -76,6 +76,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.show-headers")) {
+		symbol_conf.show_headers = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b923f61..a878284 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1260,11 +1260,15 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 	struct hist_browser *browser = zalloc(sizeof(*browser));
 
 	if (browser) {
+		/* If no config option is set, keep the default 'true'. */
+		bool show_headers = symbol_conf.show_headers == -1 ?
+				    true : symbol_conf.show_headers;
+
 		browser->hists = hists;
 		browser->b.ops.refresh = hist_browser__refresh;
 		browser->b.ops.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		browser->show_headers = true;
+		browser->show_headers = show_headers;
 	}
 
 	return browser;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7b9096f..45a319b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -35,6 +35,7 @@ struct symbol_conf symbol_conf = {
 	.demangle		= true,
 	.cumulate_callchain	= true,
 	.symfs			= "",
+	.show_headers		= -1,
 };
 
 static enum dso_binary_type binary_type_symtab[] = {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..8f1854a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -139,6 +139,7 @@ struct symbol_conf {
 			*sym_from_list,
 			*sym_to_list;
 	const char	*symfs;
+	int		show_headers;
 };
 
 extern struct symbol_conf symbol_conf;
-- 
1.8.3.1

