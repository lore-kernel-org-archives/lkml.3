Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3KLVzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:55:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab3KLVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:55:02 -0500
Date: Tue, 12 Nov 2013 13:54:35 -0800
From: tip-bot for Patrick Palka <tipbot@zytor.com>
Message-ID: <tip-d53e57d039c323fe3a43630e9f729df48134e2c9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        patrick@parcs.ath.cx, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, patrick@parcs.ath.cx,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1382747149-9716-1-git-send-email-patrick@parcs.ath.cx>
References: <1382747149-9716-1-git-send-email-patrick@parcs.ath.cx>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf ui tui progress: Don'
 t force a refresh during progress update
Git-Commit-ID: d53e57d039c323fe3a43630e9f729df48134e2c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:54:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d53e57d039c323fe3a43630e9f729df48134e2c9
Gitweb:     http://git.kernel.org/tip/d53e57d039c323fe3a43630e9f729df48134e2c9
Author:     Patrick Palka <patrick@parcs.ath.cx>
AuthorDate: Fri, 25 Oct 2013 20:25:49 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 15:56:39 -0300

perf ui tui progress: Don't force a refresh during progress update

Each call to tui_progress__update() would forcibly refresh the entire
screen.  This is somewhat inefficient and causes noticable flickering
during the startup of perf-report, especially on large/slow terminals.

It looks like the force-refresh in tui_progress__update() serves no
purpose other than to clear the screen so that the progress bar of a
previous operation does not subsume that of a subsequent operation.  But
we can do just that in a much more efficient manner by clearing only the
region that a previous progress bar may have occupied before repainting
the new progress bar.  Then the force-refresh could be removed with no
change in visuals.

This patch disables the slow force-refresh in tui_progress__update() and
instead calls SLsmg_fill_region() on the entire area that the progress
bar may occupy before repainting it.  This change makes the startup of
perf-report much faster and appear much "smoother".

It turns out that this was a big bottleneck in the startup speed of
perf-report -- with this patch, perf-report starts up ~2x faster (1.1s
vs 0.55s) on my machines.  (These numbers were measured by running "time
perf report" on an 8MB perf.data and pressing 'q' immediately.)

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382747149-9716-1-git-send-email-patrick@parcs.ath.cx
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/tui/progress.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 3e2d936..c61d14b 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -18,13 +18,14 @@ static void tui_progress__update(struct ui_progress *p)
 	if (p->total == 0)
 		return;
 
-	ui__refresh_dimensions(true);
+	ui__refresh_dimensions(false);
 	pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
 	SLsmg_set_color(0);
 	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
 	SLsmg_gotorc(y++, 1);
 	SLsmg_write_string((char *)p->title);
+	SLsmg_fill_region(y, 1, 1, SLtt_Screen_Cols - 2, ' ');
 	SLsmg_set_color(HE_COLORSET_SELECTED);
 	bar = ((SLtt_Screen_Cols - 2) * p->curr) / p->total;
 	SLsmg_fill_region(y, 1, 1, bar, ' ');
