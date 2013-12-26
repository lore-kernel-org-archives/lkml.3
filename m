Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3LZFiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 00:38:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56656 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3LZFiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 00:38:09 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-f1-52bbc0be323d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/8] perf ui/tui: Protect windows by ui__lock
Date: Thu, 26 Dec 2013 14:37:57 +0900
Message-Id: <1388036284-32342-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes perf top TUI breaks display with concurrent help/input
window and pr_* messages since they're not protected by ui__lock.
You can check it by pressing (and not releasing) 'h' key on a
"perf top -vvv" TUI session.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/tui/util.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index 092902e30cee..bf890f72fe80 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -92,6 +92,8 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 		t = sep + 1;
 	}
 
+	pthread_mutex_lock(&ui__lock);
+
 	max_len += 2;
 	nr_lines += 8;
 	y = SLtt_Screen_Rows / 2 - nr_lines / 2;
@@ -120,13 +122,19 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 	SLsmg_write_nstring((char *)exit_msg, max_len);
 	SLsmg_refresh();
 
+	pthread_mutex_unlock(&ui__lock);
+
 	x += 2;
 	len = 0;
 	key = ui__getch(delay_secs);
 	while (key != K_TIMER && key != K_ENTER && key != K_ESC) {
+		pthread_mutex_lock(&ui__lock);
+
 		if (key == K_BKSPC) {
-			if (len == 0)
+			if (len == 0) {
+				pthread_mutex_unlock(&ui__lock);
 				goto next_key;
+			}
 			SLsmg_gotorc(y, x + --len);
 			SLsmg_write_char(' ');
 		} else {
@@ -136,6 +144,8 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 		}
 		SLsmg_refresh();
 
+		pthread_mutex_unlock(&ui__lock);
+
 		/* XXX more graceful overflow handling needed */
 		if (len == sizeof(buf) - 1) {
 			ui_helpline__push("maximum size of symbol name reached!");
@@ -174,6 +184,8 @@ int ui__question_window(const char *title, const char *text,
 		t = sep + 1;
 	}
 
+	pthread_mutex_lock(&ui__lock);
+
 	max_len += 2;
 	nr_lines += 4;
 	y = SLtt_Screen_Rows / 2 - nr_lines / 2,
@@ -195,6 +207,9 @@ int ui__question_window(const char *title, const char *text,
 	SLsmg_gotorc(y + nr_lines - 1, x);
 	SLsmg_write_nstring((char *)exit_msg, max_len);
 	SLsmg_refresh();
+
+	pthread_mutex_unlock(&ui__lock);
+
 	return ui__getch(delay_secs);
 }
 
@@ -215,9 +230,7 @@ static int __ui__warning(const char *title, const char *format, va_list args)
 	if (vasprintf(&s, format, args) > 0) {
 		int key;
 
-		pthread_mutex_lock(&ui__lock);
 		key = ui__question_window(title, s, "Press any key...", 0);
-		pthread_mutex_unlock(&ui__lock);
 		free(s);
 		return key;
 	}
-- 
1.7.11.7

