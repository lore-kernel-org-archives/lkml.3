Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBBVqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:46:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbaBBVj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:58 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/22] perf tools: Add header callback into ui_browser_ops struct
Date: Sun,  2 Feb 2014 22:38:58 +0100
Message-Id: <1391377150-23920-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding header callback into 'struct ui_browser_ops',
the prototype is:
   unsigned int (*header)(struct ui_browser *browser);

It's called before the refresh callback under the
same lock.  It's going to be used for hist browser
to display column header.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browser.c | 8 ++++++++
 tools/perf/ui/browser.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index b0b651d..31bd6e8 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -303,11 +303,19 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 	SLsmg_set_char_set(0);
 }
 
+static void __ui_browser__header(struct ui_browser *browser)
+{
+	if (browser->ops.header)
+		browser->ops.header(browser);
+}
+
 static int __ui_browser__refresh(struct ui_browser *browser)
 {
 	int row;
 	int width = browser->width;
 
+	__ui_browser__header(browser);
+
 	row = browser->ops.refresh(browser);
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
 
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 5610176..73b17b7 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -16,6 +16,7 @@
 struct ui_browser;
 
 struct ui_browser_ops {
+	unsigned int  (*header)(struct ui_browser *browser);
 	unsigned int  (*refresh)(struct ui_browser *browser);
 	void	      (*write)(struct ui_browser *browser, void *entry, int row);
 	void	      (*seek)(struct ui_browser *browser, off_t offset, int whence);
-- 
1.8.3.1

