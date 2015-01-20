Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbATGnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:43:11 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36575 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbATGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:43:10 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf ui/tui: Show fatal error message only if exists
Date: Tue, 20 Jan 2015 15:40:50 +0900
Message-Id: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf exits with some error it shows the error message with
ui__error() or ui__warning() and then calls ui__exit() during
exit_browser().

On TUI, it then shows a window titled "Fatal Error" to inform user a
last message which might be related with this condition.  However it
sometimes contains no message and just annoyes users.

The usual case for this is running perf top as normal user.  (And
/proc/sys/kernel/perf_event_paranoid being 1).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
 
@@ -159,7 +160,7 @@ int ui__init(void)
 
 void ui__exit(bool wait_for_ok)
 {
-	if (wait_for_ok)
+	if (wait_for_ok && tui_helpline__set)
 		ui__question_window("Fatal Error",
 				    ui_helpline__last_msg,
 				    "Press any key...", 0);
-- 
2.2.2

