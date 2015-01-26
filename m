Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbbAZRuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:50:04 -0500
Received: from mail.kernel.org ([198.145.29.136]:53231 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbbAZRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:49:14 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/26] perf ui/tui: Show fatal error message only if exists
Date: Mon, 26 Jan 2015 14:47:28 -0300
Message-Id: <1422294449-12735-26-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf exits with some error it shows the error message with
ui__error() or ui__warning() and then calls ui__exit() during
exit_browser().

On TUI, it then shows a window titled "Fatal Error" to inform user a
last message which might be related with this condition.  However it
sometimes contains no message and just annoyes users.

The usual case for this is running perf top as normal user.  (And
/proc/sys/kernel/perf_event_paranoid being 1).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1421736050-5283-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/tui/helpline.c | 3 +++
 tools/perf/ui/tui/setup.c    | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
index 1c8b9afd5d6e..88f5143a5981 100644
--- a/tools/perf/ui/tui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -9,6 +9,7 @@
 #include "../libslang.h"
 
 char ui_helpline__last_msg[1024];
+bool tui_helpline__set;
 
 static void tui_helpline__pop(void)
 {
@@ -35,6 +36,8 @@ static int tui_helpline__show(const char *format, va_list ap)
 			sizeof(ui_helpline__last_msg) - backlog, format, ap);
 	backlog += ret;
 
+	tui_helpline__set = true;
+
 	if (ui_helpline__last_msg[backlog - 1] == '\n') {
 		ui_helpline__puts(ui_helpline__last_msg);
 		SLsmg_refresh();
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 3c38f25b1695..b77e1d771363 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -17,6 +17,7 @@
 static volatile int ui__need_resize;
 
 extern struct perf_error_ops perf_tui_eops;
+extern bool tui_helpline__set;
 
 extern void hist_browser__init_hpp(void);
 
@@ -159,7 +160,7 @@ out:
 
 void ui__exit(bool wait_for_ok)
 {
-	if (wait_for_ok)
+	if (wait_for_ok && tui_helpline__set)
 		ui__question_window("Fatal Error",
 				    ui_helpline__last_msg,
 				    "Press any key...", 0);
-- 
1.9.3

