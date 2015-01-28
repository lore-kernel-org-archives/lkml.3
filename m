Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbbA1V0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:26:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762082AbbA1Uto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:44 -0500
Date: Wed, 28 Jan 2015 07:10:40 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4397bd2f90459d550deca7f6ba32c12e382d8b57@git.kernel.org>
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, acme@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@kernel.org
Reply-To: a.p.zijlstra@chello.nl, hpa@zytor.com, namhyung@kernel.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
References: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui:
  Show fatal error message only if exists
Git-Commit-ID: 4397bd2f90459d550deca7f6ba32c12e382d8b57
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

Commit-ID:  4397bd2f90459d550deca7f6ba32c12e382d8b57
Gitweb:     http://git.kernel.org/tip/4397bd2f90459d550deca7f6ba32c12e382d8b57
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 20 Jan 2015 15:40:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 17:05:10 -0300

perf ui/tui: Show fatal error message only if exists

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
index 1c8b9af..88f5143 100644
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
index 3c38f25..b77e1d7 100644
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
