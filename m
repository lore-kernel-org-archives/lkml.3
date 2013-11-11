Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3KKUXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3KKUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Patrick Palka <patrick@parcs.ath.cx>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] perf ui tui progress: Don't force a refresh during progress update
Date: Mon, 11 Nov 2013 17:22:24 -0300
Message-Id: <1384201353-23863-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Palka <patrick@parcs.ath.cx>

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
index 3e2d936d7443..c61d14b101e0 100644
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
-- 
1.8.1.4

