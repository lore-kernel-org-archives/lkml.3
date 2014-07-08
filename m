Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaGHTDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:03:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:58073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbaGHTDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:03:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/16] perf hists browser: Display columns header text on 'H' press
Date: Tue,  8 Jul 2014 16:02:54 -0300
Message-Id: <1404846184-20075-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Displaying columns header text whenever 'H' is pressed,
and hiding it on on another press.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-w9pcqpum5erza2a05ysvollz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 47 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2be71bf17b71..5fa2e181ef0c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -822,11 +822,54 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	return printed;
 }
 
+static int advance_hpp_check(struct perf_hpp *hpp, int inc)
+{
+	advance_hpp(hpp, inc);
+	return hpp->size <= 0;
+}
+
+static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
+{
+	struct perf_hpp dummy_hpp = {
+		.buf    = buf,
+		.size   = size,
+	};
+	struct perf_hpp_fmt *fmt;
+	size_t ret = 0;
+
+	if (symbol_conf.use_callchain) {
+		ret = scnprintf(buf, size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			return ret;
+	}
+
+	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		/* We need to add the length of the columns header. */
+		perf_hpp__reset_width(fmt, hists);
+
+		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+
+		ret = scnprintf(dummy_hpp.buf, dummy_hpp.size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+	}
+
+	return ret;
+}
+
 static void hist_browser__show_headers(struct hist_browser *browser)
 {
+	char headers[1024];
+
+	hists__scnprintf_headers(headers, sizeof(headers), browser->hists);
 	ui_browser__gotorc(&browser->b, 0, 0);
 	ui_browser__set_color(&browser->b, HE_COLORSET_ROOT);
-	slsmg_write_nstring(" ", browser->b.width + 1);
+	slsmg_write_nstring(headers, browser->b.width + 1);
 }
 
 static void ui_browser__hists_init_top(struct ui_browser *browser)
@@ -1241,7 +1284,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh_dimensions = hist_browser__refresh_dimensions;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		browser->show_headers = false;
+		browser->show_headers = true;
 	}
 
 	return browser;
-- 
1.9.3

