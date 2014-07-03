Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbaGCVn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:43:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:53722 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbaGCVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:43:23 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/7] perf ui browser: Allow overriding refresh_dimensions method
Date: Thu,  3 Jul 2014 18:42:55 -0300
Message-Id: <1404423780-24026-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404423780-24026-1-git-send-email-acme@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Some browsers, like the hist_browser, may want to be notified everytime
a refresh_dimensions is needed, so that it can reset ui_browser->rows,
for instance, or do some other related reaction to screen resizings.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ielvluuemzn30bneh0zk3twi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 7 +++++--
 tools/perf/ui/browser.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index adb294a3ec08..6680fa5cb9dd 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -250,7 +250,10 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 	int err;
 	va_list ap;
 
-	ui_browser__refresh_dimensions(browser);
+	if (browser->refresh_dimensions == NULL)
+		browser->refresh_dimensions = ui_browser__refresh_dimensions;
+
+	browser->refresh_dimensions(browser);
 
 	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(browser, title);
@@ -367,7 +370,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 
 		if (key == K_RESIZE) {
 			ui__refresh_dimensions(false);
-			ui_browser__refresh_dimensions(browser);
+			browser->refresh_dimensions(browser);
 			__ui_browser__show_title(browser, browser->title);
 			ui_helpline__puts(browser->helpline);
 			continue;
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index cb8f39a1646f..92ae72113965 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -19,6 +19,7 @@ struct ui_browser {
 	void	      *priv;
 	const char    *title;
 	char	      *helpline;
+	void 	      (*refresh_dimensions)(struct ui_browser *browser);
 	unsigned int  (*refresh)(struct ui_browser *browser);
 	void	      (*write)(struct ui_browser *browser, void *entry, int row);
 	void	      (*seek)(struct ui_browser *browser, off_t offset, int whence);
-- 
1.9.3

