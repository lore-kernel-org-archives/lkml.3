Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaALSjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:39:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaALSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:39:50 -0500
Date: Sun, 12 Jan 2014 10:39:33 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-5c743cf573e6974befe917ed4a36d42b39ef1ce0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1388036284-32342-2-git-send-email-namhyung@kernel.org>
References: <1388036284-32342-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui: Protect windows by ui__lock
Git-Commit-ID: 5c743cf573e6974befe917ed4a36d42b39ef1ce0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:39:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c743cf573e6974befe917ed4a36d42b39ef1ce0
Gitweb:     http://git.kernel.org/tip/5c743cf573e6974befe917ed4a36d42b39ef1ce0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Dec 2013 14:37:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Dec 2013 11:22:01 -0300

perf ui/tui: Protect windows by ui__lock

Sometimes perf top TUI breaks display with concurrent help/input window
and pr_* messages since they're not protected by ui__lock.

You can check it by pressing (and not releasing) 'h' key on a "perf top
-vvv" TUI session.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1388036284-32342-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/tui/util.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index 092902e..bf890f7 100644
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
