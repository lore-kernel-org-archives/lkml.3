Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbaGPTO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965647AbaGPTOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:52 -0400
Date: Wed, 16 Jul 2014 12:14:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-w9pcqpum5erza2a05ysvollz@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Display columns header text on 'H' press
Git-Commit-ID: 81a888fea2cfd727052926e95510c11981d9b1c2
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

Commit-ID:  81a888fea2cfd727052926e95510c11981d9b1c2
Gitweb:     http://git.kernel.org/tip/81a888fea2cfd727052926e95510c11981d9b1c2
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sat, 14 Jun 2014 15:44:52 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:55 -0300

perf hists browser: Display columns header text on 'H' press

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
index 2be71bf..5fa2e18 100644
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
