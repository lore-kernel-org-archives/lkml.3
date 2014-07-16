Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbaGPTOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbaGPTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:25 -0400
Date: Wed, 16 Jul 2014 12:13:37 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ielvluuemzn30bneh0zk3twi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser:
  Allow overriding refresh_dimensions method
Git-Commit-ID: fa70b5d66d6e9de3331f57e434a16bc0eee980a8
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

Commit-ID:  fa70b5d66d6e9de3331f57e434a16bc0eee980a8
Gitweb:     http://git.kernel.org/tip/fa70b5d66d6e9de3331f57e434a16bc0eee980a8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Jul 2014 16:34:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:54 -0300

perf ui browser: Allow overriding refresh_dimensions method

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
index adb294a..6680fa5 100644
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
index cb8f39a..92ae721 100644
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
